#!/usr/bin/env python3
"""Atualiza um tema/topico: Obsidian + Notion.

Integra: PubMed, Zotero e outras fontes medicas.

Uso:
  uv run python scripts/atualizar_tema.py -t "Ascite" --fetch
  uv run python scripts/atualizar_tema.py -t "Restrição salina ascite" --fetch --tier1 --recent
  uv run python scripts/atualizar_tema.py -t "Cirrose" --fetch --sources pubmed,zotero
  uv run python scripts/atualizar_tema.py -t "Ascite" --tags "ascite,cirrose" --so-metadata

Fontes: pubmed (gratuito), zotero (ZOTERO_API_KEY + ZOTERO_LIBRARY_ID no .env)
Tier 1: --tier1 filtra meta-analise + revisao sistematica. --recent ordena por data.
Pipeline completo: docs/PIPELINE_MBE_NOTION_OBSIDIAN.md
"""

from __future__ import annotations

import argparse
import re
from datetime import datetime
from pathlib import Path

# Import fetch apenas quando --fetch
VAULT_ROOT = Path(__file__).resolve().parent.parent
OBSIDIAN_RESOURCES = VAULT_ROOT / "03-Resources"
OUTPUT_DIR = VAULT_ROOT / "scripts" / "output"


def slugify(text: str) -> str:
    """Converte titulo em slug para filename."""
    slug = text.lower().strip()
    slug = re.sub(r"[^\w\s-]", "", slug)
    slug = re.sub(r"[-\s]+", "-", slug)
    return slug[:80]


def create_obsidian_note(
    title: str,
    content: str,
    tags: list[str],
    references: list[str] | None = None,
    evidence_level: str = "",
    last_review: str | None = None,
) -> str:
    """Cria nota Obsidian com frontmatter."""
    today = datetime.now().strftime("%Y-%m-%d")
    frontmatter = {
        "title": title,
        "type": "note",
        "tags": tags,
        "created": today,
        "updated": today,
        "last_review": last_review or today,
        "references": references or [],
    }
    if evidence_level:
        frontmatter["evidence_level"] = evidence_level
    yaml_lines = ["---"]
    for key, value in frontmatter.items():
        if isinstance(value, list):
            yaml_lines.append(f"{key}:")
            for item in value:
                yaml_lines.append(f"  - {item}")
        else:
            yaml_lines.append(f"{key}: {value}")
    yaml_lines.append("---")
    yaml_lines.append("")
    yaml_lines.append(f"# {title}")
    yaml_lines.append("")
    yaml_lines.append(content)
    return "\n".join(yaml_lines)


def create_notion_content(
    title: str,
    content: str,
    references: list[str] | None = None,
    evidence_level: str = "",
    last_review: str = "",
) -> str:
    """Formato Masterpiece DB."""
    today = datetime.now().strftime("%Y-%m-%d")
    meta_line = f"> Atualizado: {today}"
    if evidence_level:
        meta_line += f" | Nivel evidencia: {evidence_level}"
    if last_review:
        meta_line += f" | Ultima revisao: {last_review}"
    # Se content ja tem secao Referencias, nao duplicar
    ref_block = ""
    if references and "## Referencias" not in content:
        ref_block = "\n\n## Referencias\n" + "\n".join(f"- {r}" for r in references)
    elif references:
        ref_block = ""
    elif "## Referencias" not in content:
        ref_block = "\n\n## Referencias\n- (adicionar PMID/DOI)"
    return f"""# {title}

{meta_line}

{content}{ref_block}

---
Coautoria: Lucas + opus
"""


def main() -> None:
    parser = argparse.ArgumentParser(description="Atualiza tema em Obsidian + Notion")
    parser.add_argument("-t", "--tema", required=True, help="Nome do tema/topico")
    parser.add_argument(
        "--tags",
        default="",
        help="Tags separadas por virgula (ex: ascite,cirrose,hepatologia)",
    )
    parser.add_argument(
        "--content-file",
        help="Arquivo com conteudo markdown (se omitido, usa template minimo)",
    )
    parser.add_argument(
        "--links",
        default="",
        help="Links para outras notas, separados por virgula (ex: Cirrose,Ascite)",
    )
    parser.add_argument(
        "--so-metadata",
        action="store_true",
        help="Atualiza apenas frontmatter (tags, updated). Preserva conteudo existente.",
    )
    parser.add_argument(
        "--fetch",
        action="store_true",
        help="Busca em PubMed e Zotero para enriquecer o conteudo.",
    )
    parser.add_argument(
        "--sources",
        default="pubmed,zotero",
        help="Fontes para --fetch: pubmed,zotero (separadas por virgula)",
    )
    parser.add_argument(
        "--max-refs",
        type=int,
        default=5,
        help="Max referencias por fonte (default: 5)",
    )
    parser.add_argument(
        "--tier1",
        action="store_true",
        help="Filtrar apenas tier 1: meta-analise + revisao sistematica (PubMed)",
    )
    parser.add_argument(
        "--recent",
        action="store_true",
        help="Ordenar por data (mais recentes primeiro)",
    )
    args = parser.parse_args()

    tema = args.tema.strip()
    tags = [t.strip() for t in args.tags.split(",") if t.strip()] or [slugify(tema)]
    links = [l.strip() for l in args.links.split(",") if l.strip()]

    obsidian_path = OBSIDIAN_RESOURCES / f"{slugify(tema)}.md"
    OBSIDIAN_RESOURCES.mkdir(parents=True, exist_ok=True)

    references: list[str] = []
    evidence_level = ""
    last_review = ""

    # Conteudo: --fetch busca em PubMed/Zotero
    if args.fetch:
        import sys
        sys.path.insert(0, str(Path(__file__).resolve().parent))
        from fetch_medical import fetch_all

        print(f"Buscando '{tema}' em {args.sources}...")
        if args.tier1:
            print("  Filtro: tier 1 (meta-analise + revisao sistematica)")
        sources_list = [s.strip() for s in args.sources.split(",") if s.strip()]
        items, ref_content = fetch_all(
            tema,
            sources=sources_list,
            max_per_source=args.max_refs,
            tier1_only=args.tier1,
            sort_by_date=args.recent,
        )
        references = [f"{r.title} ({r.source})" for r in items]
        # Inferir nivel de evidencia a partir dos tipos encontrados
        evidence_level = ""
        if items:
            types_seen = {r.evidence_type for r in items if r.evidence_type}
            if "meta_analysis" in types_seen or "systematic_review" in types_seen:
                evidence_level = "I"
            elif "rct" in types_seen:
                evidence_level = "II"
            elif types_seen:
                evidence_level = "III"
        last_review = datetime.now().strftime("%Y-%m-%d")
        link_lines = "\n".join(f"- [[{l}]]" for l in links) if links else ""
        content = f"""## Definicao
(adicionar definicao baseada nas referencias)

## Pontos-Chave
- (sintetizar dos abstracts e PDFs)

## Referencias
{ref_content}

## Links
{link_lines or "- (adicionar links)"}
"""
    # --so-metadata preserva body existente
    elif args.so_metadata and obsidian_path.exists():
        raw = obsidian_path.read_text(encoding="utf-8")
        parts = raw.split("---", 2)
        if len(parts) >= 3:
            body = parts[2].strip()
            content = re.sub(r"^#\s+" + re.escape(tema) + r"\s*\n?", "", body).strip()
        else:
            content = raw
    elif args.content_file:
        content_path = Path(args.content_file)
        if not content_path.is_absolute():
            content_path = VAULT_ROOT / content_path
        content = content_path.read_text(encoding="utf-8")
    else:
        link_lines = "\n".join(f"- [[{link}]]" for link in links) if links else ""
        content = f"""## Definicao
(adicionar definicao)

## Pontos-Chave
- (adicionar pontos)

## Links
{link_lines or "- (adicionar links)"}
"""

    # 1. Obsidian
    OBSIDIAN_RESOURCES.mkdir(parents=True, exist_ok=True)
    obsidian_note = create_obsidian_note(
        title=tema,
        content=content,
        tags=tags,
        references=references,
        evidence_level=evidence_level,
        last_review=last_review or None,
    )
    obsidian_path = OBSIDIAN_RESOURCES / f"{slugify(tema)}.md"
    obsidian_path.write_text(obsidian_note, encoding="utf-8")
    print(f"Obsidian: {obsidian_path}")

    # 2. Notion
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    notion_content = create_notion_content(
        tema, content, references, evidence_level=evidence_level, last_review=last_review
    )
    notion_path = OUTPUT_DIR / f"notion-{slugify(tema)}-masterpiece.md"
    notion_path.write_text(notion_content, encoding="utf-8")
    print(f"Notion: {notion_path}")

    print(f"\nTema '{tema}' atualizado. Tags: {tags}")


if __name__ == "__main__":
    main()
