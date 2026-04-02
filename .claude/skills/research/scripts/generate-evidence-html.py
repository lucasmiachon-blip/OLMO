#!/usr/bin/env python3
"""Generate a living HTML evidence page for a slide.

Usage (from orchestrator or CLI):
    python generate-evidence-html.py \
        --slide-id s-aplicacao \
        --aula metanalise \
        --assertion "Clopidogrel reduz MACCE em 14% vs aspirina" \
        --slide-number 14 \
        --total-slides 18 \
        --phase F3 \
        --data evidence.json

evidence.json schema:
{
  "sintese_narrativa": "prosa...",
  "speaker_notes": "o que dizer...",
  "pedagogia": "posicionamento...",
  "retorica": "analise...",
  "grade": [{"claim": "...", "level": "MODERATE", "domains": {...}}],
  "numeros": [{"metric": "HR", "value": "0.86", "ci": "0.75-0.99", ...}],
  "sugestoes": {"considerar": [...], "nao_fazer": [...]},
  "depth_rubric": [{"dim": "D1", "score": 7, "achado": "...", "implicacao": "..."}],
  "convergencia": "interpretacao...",
  "coautoria": "Lucas + Opus 4.6"
}

The orchestrator can also call generate_html() directly as a library.
"""

from __future__ import annotations

import argparse
import json
from datetime import datetime, timedelta
from html import escape
from pathlib import Path
from typing import Any

CSS = (
    "body{font-family:'Segoe UI',system-ui,sans-serif;"
    "max-width:800px;margin:2rem auto;padding:0 1rem;"
    "color:#1a1a2e;line-height:1.6;text-align:justify}"
    ".v{display:inline-block;font-size:.65rem;font-weight:700;"
    "color:#fff;background:#2563eb;border-radius:3px;"
    "padding:0 .3rem;margin:0 .1rem;vertical-align:middle;"
    "letter-spacing:.02em}"
    ".c{display:inline-block;font-size:.65rem;font-weight:700;"
    "color:#fff;background:#dc2626;border-radius:3px;"
    "padding:0 .3rem;margin:0 .1rem;vertical-align:middle;"
    "letter-spacing:.02em}"
    "h1{font-size:1.4rem;border-bottom:2px solid #2d6a4f;"
    "padding-bottom:.5rem}"
    "h2{font-size:1.1rem;color:#2d6a4f;margin-top:1.5rem}"
    ".meta{font-size:.85rem;color:#555}"
    ".meta .stale{color:#d00;font-weight:bold}"
    "table{border-collapse:collapse;width:100%;"
    "margin:.5rem 0;font-size:.9rem}"
    "th,td{border:1px solid #ccc;padding:.4rem .6rem;"
    "text-align:left}"
    "th{background:#f0f4f0}"
    "details{margin:1rem 0}"
    "summary{cursor:pointer;font-weight:600;color:#2d6a4f}"
    "footer{margin-top:2rem;padding-top:.5rem;"
    "border-top:1px solid #ccc;font-size:.8rem;color:#777}"
    ".speaker-notes{background:#fffbea;"
    "border-left:4px solid #d4a017;padding:.8rem 1rem;"
    "margin:.5rem 0;white-space:pre-line}"
    ".suggestion-do{color:#2d6a4f}"
    ".suggestion-dont{color:#8b0000}"
)


def esc(text: str | None) -> str:
    """Escape HTML, preserve None as empty."""
    return escape(str(text)) if text else ""


def render_grade_table(grade_items: list[dict[str, Any]]) -> str:
    if not grade_items:
        return ""
    rows = ""
    for g in grade_items:
        claim = esc(g.get("claim", ""))
        level = esc(g.get("level", ""))
        domains = g.get("domains", {})
        domain_cells = "".join(f"<td>{esc(str(v))}</td>" for v in domains.values())
        domain_headers = "".join(f"<th>{esc(k)}</th>" for k in domains)
        rows += f"<tr><td>{claim}</td><td><strong>{level}</strong></td>{domain_cells}</tr>"
    header = f"<tr><th>Claim</th><th>GRADE</th>{domain_headers}</tr>" if grade_items else ""
    return f"""
<section id="grade">
  <h2>GRADE Assessment</h2>
  <table>{header}{rows}</table>
</section>"""


def render_numeros_table(numeros: list[dict[str, Any]]) -> str:
    if not numeros:
        return ""
    rows = ""
    for n in numeros:
        rows += (
            "<tr>"
            + "".join(
                f"<td>{esc(str(n.get(k, '')))}</td>"
                for k in ("metric", "value", "ci", "timeframe", "population", "pmid", "risco_basal")
            )
            + "</tr>"
        )
    return f"""
<section id="numeros">
  <h2>Numeros-Chave</h2>
  <table>
    <tr><th>Metrica</th><th>Valor</th><th>IC 95%</th><th>Tempo</th>
    <th>Populacao</th><th>PMID</th><th>Risco Basal</th></tr>
    {rows}
  </table>
</section>"""


def render_depth_rubric(rubric: list[dict[str, Any]]) -> str:
    if not rubric:
        return ""
    rows = ""
    for r in rubric:
        dim = esc(r.get("dim", ""))
        score = esc(str(r.get("score", "")))
        achado = esc(r.get("achado", ""))
        impl = esc(r.get("implicacao", ""))
        rows += f"<tr><td>{dim}</td><td>{score}</td><td>{achado}</td><td>{impl}</td></tr>"
    return f"""
<details>
  <summary>Depth Rubric (D1-D8)</summary>
  <table>
    <tr><th>Dim</th><th>Score</th><th>Achado</th><th>Implicacao</th></tr>
    {rows}
  </table>
</details>"""


def render_sugestoes(sugestoes: dict[str, Any]) -> str:
    considerar = sugestoes.get("considerar", [])
    nao_fazer = sugestoes.get("nao_fazer", [])
    if not considerar and not nao_fazer:
        return ""
    items = ""
    for s in considerar:
        items += f'<li class="suggestion-do"><strong>Considerar:</strong> {esc(s)}</li>\n'
    for s in nao_fazer:
        items += f'<li class="suggestion-dont"><strong>Nao fazer:</strong> {esc(s)}</li>\n'
    return f"""
<section id="sugestoes">
  <h2>O Que Mudar / O Que Manter</h2>
  <ul>{items}</ul>
</section>"""


def generate_html(
    slide_id: str,
    aula: str,
    assertion: str,
    slide_number: int,
    total_slides: int,
    phase: str,
    data: dict[str, Any],
) -> str:
    """Generate standalone evidence HTML from structured data."""
    now = datetime.now()
    validade = (now + timedelta(days=180)).strftime("%Y-%m-%d")
    timestamp = now.strftime("%Y-%m-%d %H:%M")
    coautoria = esc(data.get("coautoria", "Lucas + Opus 4.6"))

    # Conditional sections
    grade_html = render_grade_table(data.get("grade", []))
    numeros_html = render_numeros_table(data.get("numeros", []))
    depth_html = render_depth_rubric(data.get("depth_rubric", []))
    sugestoes_html = render_sugestoes(data.get("sugestoes", {}))

    convergencia = data.get("convergencia", "")
    convergencia_html = (
        f"""
<details>
  <summary>Convergencia Entre Fontes</summary>
  <p>{esc(convergencia)}</p>
</details>"""
        if convergencia
        else ""
    )

    # Optional quick-reference section (collapsed, for Q&A prep)
    ref_rapida = data.get("referencia_rapida", [])
    if ref_rapida:
        ref_rows = ""
        for item in ref_rapida:
            termo = esc(item.get("termo", ""))
            definicao = esc(item.get("definicao", ""))
            nota = esc(item.get("nota", ""))
            ref_rows += (
                f"<tr><td><strong>{termo}</strong></td><td>{definicao}</td><td>{nota}</td></tr>\n"
            )
        ref_rapida_html = f"""
<details>
  <summary>Referencia Rapida — Se Perguntarem</summary>
  <table>
    <tr><th>Termo</th><th>Definicao</th><th>Nota</th></tr>
    {ref_rows}
  </table>
</details>"""
    else:
        ref_rapida_html = ""

    # Post-process verification badges (after esc() so tokens survive)
    def badge(html_str: str) -> str:
        replacements = [
            ("[VERIFIED]", '<span class="v">VERIFIED</span>'),
            ("[WEB-VERIFIED]", '<span class="v">WEB-VERIFIED</span>'),
            ("[CANDIDATE]", '<span class="c">CANDIDATE</span>'),
        ]
        for token, span in replacements:
            html_str = html_str.replace(token, span)
        return html_str

    raw = f"""<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Evidence: {esc(slide_id)}</title>
  <style>{CSS}</style>
</head>
<body>
  <header>
    <h1>{esc(assertion)}</h1>
    <p class="meta">Aula: {esc(aula)} | Slide {slide_number} de {total_slides}
    | Fase: {esc(phase)}</p>
    <p class="meta">Gerado: {timestamp} | Validade sugerida: {validade}</p>
  </header>

  <section id="sintese">
    <h2>Sintese Narrativa</h2>
    <p>{esc(data.get("sintese_narrativa", "[pendente]"))}</p>
  </section>

  <section id="speaker-notes">
    <h2>Speaker Notes</h2>
    <div class="speaker-notes">{esc(data.get("speaker_notes", "[pendente]"))}</div>
  </section>

  <section id="pedagogia">
    <h2>Posicionamento Pedagogico</h2>
    <p>{esc(data.get("pedagogia", "[pendente]"))}</p>
  </section>

  <section id="retorica">
    <h2>Analise Retorica</h2>
    <p>{esc(data.get("retorica", "[pendente]"))}</p>
  </section>
{grade_html}
{numeros_html}
{sugestoes_html}
{depth_html}
{convergencia_html}
{ref_rapida_html}

  <footer>
    Coautoria: {coautoria} | Pipeline: /research v2 | Slide: {esc(slide_id)}
  </footer>
</body>
</html>
"""
    return badge(raw)


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate evidence HTML for a slide")
    parser.add_argument("--slide-id", required=True)
    parser.add_argument("--aula", required=True)
    parser.add_argument("--assertion", required=True)
    parser.add_argument("--slide-number", type=int, required=True)
    parser.add_argument("--total-slides", type=int, required=True)
    parser.add_argument("--phase", required=True)
    parser.add_argument("--data", required=True, help="Path to evidence JSON file")
    parser.add_argument(
        "--output", help="Output path (default: content/aulas/{aula}/evidence/{slide-id}.html)"
    )
    args = parser.parse_args()

    data_path = Path(args.data)
    with data_path.open(encoding="utf-8") as f:
        data = json.load(f)

    html = generate_html(
        slide_id=args.slide_id,
        aula=args.aula,
        assertion=args.assertion,
        slide_number=args.slide_number,
        total_slides=args.total_slides,
        phase=args.phase,
        data=data,
    )

    if args.output:
        out = Path(args.output)
    else:
        out = Path(f"content/aulas/{args.aula}/evidence/{args.slide_id}.html")

    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(html, encoding="utf-8")
    print(f"Generated: {out}")


if __name__ == "__main__":
    main()
