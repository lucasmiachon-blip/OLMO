#!/usr/bin/env python3
"""Workflow Cirrose + Ascite: Zotero → Notion + Obsidian.

Cria:
1. Nota Obsidian "Cirrose" (tags: cirrose, ascite, hepatologia, gastro)
2. Nota Obsidian "Ascite" (tags: ascite, cirrose, hepatologia, gastro)
3. Conteudo Notion para Masterpiece DB (scripts/output/)

Conteudo baseado em: StatPearls NCBI, diretrizes AASLD/EASL.
Com Zotero MCP: buscar PDFs e enriquecer referencias.

Uso: python scripts/workflow_cirrose_ascite.py
"""

from __future__ import annotations

import json
import re
from datetime import datetime
from pathlib import Path

# Vault: projeto root (tem .obsidian) ou data/obsidian-vault
VAULT_ROOT = Path(__file__).resolve().parent.parent
OBSIDIAN_RESOURCES = VAULT_ROOT / "03-Resources"
OBSIDIAN_RESOURCES.mkdir(parents=True, exist_ok=True)


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
) -> str:
    """Cria nota Obsidian com frontmatter."""
    frontmatter = {
        "title": title,
        "type": "note",
        "tags": tags,
        "created": datetime.now().strftime("%Y-%m-%d"),
        "references": references or [],
    }
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


# Conteudo Cirrose (resumo baseado em StatPearls, diretrizes, MBE)
CIRROSE_CONTENT = """## Definicao
Cirrose hepatica e o estagio final e irreversivel de doencas cronicas do figado, caracterizada por substituicao progressiva do tecido hepatico por fibrose e nodulos de regeneracao.

## Epidemiologia
- Ascite afeta ~50% dos cirroticos em 10 anos
- Marca transicao cirrose compensada → descompensada
- Mortalidade 5 anos: ~80% (compensada) → ~30% (descompensada)

## Etiologias principais
- Alcool
- Hepatites virais (B, C)
- NASH / esteatohepatite nao alcoolica
- Doencas autoimunes
- Hemocromatose, doenca de Wilson

## Complicacoes
- [[Ascite]]
- Encefalopatia hepatica
- Varizes esofagicas
- Peritonite bacteriana espontanea (PBS)
- Sindrome hepatorrenal

## Referencias
- StatPearls Ascites (NCBI Bookshelf)
- Diretriz manejo ascite e complicacoes na cirrose (AASLD/EASL)
"""

# Conteudo Ascite
ASCITE_CONTENT = """## Definicao
Acumulo anormal de liquido na cavidade peritoneal. Nos EUA, ~80% dos casos sao por cirrose.

## Fisiopatologia (cirrose)
1. **Hipertensao portal** — fibrose distorce arquitetura, resistencia ao fluxo porta
2. **Vasodilatacao esplancnica** — oxido nitrico, reducao volume arterial efetivo
3. **Hipoalbuminemia** — figado cirrotico reduz producao
4. **Retencao renal** — RAAS, vasopressina, sistema nervoso simpatico

## Diagnostico
- Paracentese propedeutica obrigatoria na primeira apresentacao
- **GAASA** (gradiente albumina soro-ascite): ≥1.1 g/dL sugere hipertensao portal
- Analise: proteinas, citometria, citologia, cultura

## Tratamento
- Restricao sodio (2 g/dia)
- Diureticos (espironolactona + furosemida)
- Paracentese terapeutica quando refratario
- PBS: antibiotico empirico + albumina
- TIPS em casos selecionados
- Considerar transplante hepatico

## Links
- [[Cirrose]]
"""

# Conteudo Notion (Masterpiece DB format)
NOTION_CIRROSE_CONTENT = """# Cirrose Hepatica

> Fonte: StatPearls, diretrizes AASLD/EASL | Data: {date}

## Pontos-Chave
- Cirrose = estagio final de doenca hepatica cronica (fibrose + nodulos)
- Ascite e a complicacao mais comum (~50% em 10 anos)
- Marca transicao compensada → descompensada
- Etiologias: alcool, hepatites B/C, NASH, autoimune, Wilson, hemocromatose
- Complicacoes: ascite, encefalopatia, varizes, PBS, sindrome hepatorrenal

## Ascite (resumo)
- Fisiopatologia: hipertensao portal + vasodilatacao + hipoalbuminemia + retencao renal
- GAASA ≥1.1 g/dL sugere hipertensao portal
- Tratamento: restricao Na, diureticos, paracentese, TIPS, transplante

## Referencias
- StatPearls Ascites. NCBI Bookshelf. https://www.ncbi.nlm.nih.gov/books/NBK470482/
- Diretriz manejo ascite e complicacoes na cirrose (AASLD/EASL)

---
Coautoria: Lucas + opus
"""


def main() -> None:
    print("=== Workflow Cirrose + Ascite ===\n")

    # 1. Obsidian: Cirrose
    cirrose_note = create_obsidian_note(
        title="Cirrose",
        content=CIRROSE_CONTENT,
        tags=["cirrose", "ascite", "hepatologia", "gastro"],
        references=[
            "StatPearls Ascites NCBI",
            "AASLD/EASL diretriz ascite",
        ],
    )
    cirrose_path = OBSIDIAN_RESOURCES / "cirrose.md"
    cirrose_path.write_text(cirrose_note, encoding="utf-8")
    print(f"1. Obsidian: {cirrose_path}")

    # 2. Obsidian: Ascite
    ascite_note = create_obsidian_note(
        title="Ascite",
        content=ASCITE_CONTENT,
        tags=["ascite", "cirrose", "hepatologia", "gastro"],
        references=[
            "StatPearls Ascites NCBI",
        ],
    )
    ascite_path = OBSIDIAN_RESOURCES / "ascite.md"
    ascite_path.write_text(ascite_note, encoding="utf-8")
    print(f"2. Obsidian: {ascite_path}")

    # 3. Notion: conteudo para Masterpiece DB
    notion_content = NOTION_CIRROSE_CONTENT.format(
        date=datetime.now().strftime("%Y-%m-%d")
    )
    notion_path = VAULT_ROOT / "scripts" / "output" / "notion-cirrose-masterpiece.md"
    notion_path.parent.mkdir(parents=True, exist_ok=True)
    notion_path.write_text(notion_content, encoding="utf-8")
    print(f"3. Notion (copiar para Masterpiece): {notion_path}")

    print("\n=== Concluido ===")
    print("Obsidian: notas em 03-Resources/ com tags #cirrose #ascite")
    print("Notion: abra scripts/output/notion-cirrose-masterpiece.md e crie pagina no Masterpiece DB")
    print("Properties: Pilar=MEDICINA, Maturidade=Broto, Tipo=Topico")


if __name__ == "__main__":
    main()
