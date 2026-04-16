"""PDF → Obsidian literature note pipeline.

Converts academic PDFs into Obsidian-compatible markdown with structured frontmatter.
Uses Docling for extraction + optional PubMed enrichment for metadata.

Usage:
    uv run python tools/docling/pdf_to_obsidian.py <pdf_path> [--type RCT|SR|Meta|Guideline|Review]
    uv run python tools/docling/pdf_to_obsidian.py <pdf_path> --pmid 12345678
    uv run python tools/docling/pdf_to_obsidian.py <dir_of_pdfs>/

Multi-agent orchestration pattern (when called from Claude Code):
    Agent 1: Docling extraction (structure, tables, figures)
    Agent 2: PubMed/CrossRef metadata enrichment (DOI, PMID, authors)
    Agent 3: Content summarization (key findings, clinical relevance)
    Orchestrator: Merges outputs into final literature-note
"""

import argparse
import json
import logging
import os
import re
import sys
from datetime import UTC, datetime
from pathlib import Path

from docling.datamodel.base_models import InputFormat
from docling.datamodel.pipeline_options import PdfPipelineOptions
from docling.document_converter import DocumentConverter, PdfFormatOption
from docling_core.types.doc import PictureItem, TableItem, TextItem

logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
_log = logging.getLogger(__name__)

# Paths
PROJECT_ROOT = Path(os.environ.get("CLAUDE_PROJECT_DIR", Path(__file__).resolve().parents[2]))
OBSIDIAN_VAULT = Path(
    os.environ.get("OBSIDIAN_VAULT", r"C:\Users\lucas\OneDrive\LM\Documentos\Obsidian Vault")
)
INBOX_DIR = OBSIDIAN_VAULT / "_inbox"
ATTACHMENTS_DIR = OBSIDIAN_VAULT / "_attachments"

# Docling pipeline
pipeline_options = PdfPipelineOptions()
pipeline_options.images_scale = 4.0  # 288 DPI — good for reading, not wasteful
pipeline_options.generate_page_images = False
pipeline_options.generate_picture_images = True

converter = DocumentConverter(
    format_options={InputFormat.PDF: PdfFormatOption(pipeline_options=pipeline_options)}
)


def slugify(text: str) -> str:
    """Convert text to filesystem-safe slug."""
    text = text.lower().strip()
    text = re.sub(r"[^\w\s-]", "", text)
    text = re.sub(r"[-\s]+", "-", text)
    return text[:80]


def extract_metadata_from_doc(doc) -> dict:
    """Extract what metadata we can from the Docling document itself."""
    meta = {
        "title": "",
        "authors": [],
        "year": "",
        "doi": "",
        "pmid": "",
    }

    # Docling stores document-level metadata
    if hasattr(doc, "name") and doc.name:
        meta["title"] = doc.name

    # Try to get title from first heading
    if not meta["title"]:
        for element, _level in doc.iterate_items():
            if isinstance(element, TextItem):
                text = element.text.strip()
                if len(text) > 10 and len(text) < 300:
                    meta["title"] = text
                    break

    return meta


def extract_content(pdf_path: Path) -> dict:
    """Phase 1: Docling extraction — structure, tables, figures, text."""
    _log.info(f"Converting: {pdf_path.name}")
    result = converter.convert(pdf_path)
    doc = result.document

    # Get markdown body
    markdown_body = result.document.export_to_markdown()

    # Extract figures
    figures = []
    for element, _level in doc.iterate_items():
        if isinstance(element, PictureItem):
            img = element.get_image(doc)
            caption = element.caption_text(doc) or ""
            prov = element.prov[0] if element.prov else None
            page_no = prov.page_no if prov else 0
            figures.append(
                {
                    "image": img,
                    "caption": caption,
                    "page": page_no,
                }
            )

    # Count tables
    table_count = sum(1 for el, _ in doc.iterate_items() if isinstance(el, TableItem))

    # Extract metadata from document
    metadata = extract_metadata_from_doc(doc)

    return {
        "markdown": markdown_body,
        "metadata": metadata,
        "figures": figures,
        "table_count": table_count,
        "source_pdf": str(pdf_path),
    }


def build_frontmatter(metadata: dict, pdf_path: Path, study_type: str = "", pmid: str = "") -> str:
    """Build YAML frontmatter compatible with Obsidian literature-note template."""
    title = metadata.get("title", pdf_path.stem)
    authors = metadata.get("authors", [])
    year = metadata.get("year", "")
    doi = metadata.get("doi", "")

    # Use provided PMID or extracted one
    if not pmid:
        pmid = metadata.get("pmid", "")

    now = datetime.now(UTC).strftime("%Y-%m-%dT%H:%M:%SZ")

    fm = {
        "title": title,
        "authors": authors if authors else [],
        "year": year,
        "doi": doi,
        "pmid": pmid,
        "type": study_type,
        "grade": "",
        "tags": ["literature-note", "auto-digested"],
        "source_pdf": pdf_path.name,
        "digested_at": now,
        "coautoria": "Lucas + Docling",
    }

    # Build YAML manually for clean formatting
    lines = ["---"]
    lines.append(f'title: "{fm["title"]}"')
    if fm["authors"]:
        lines.append(f"authors: {json.dumps(fm['authors'])}")
    else:
        lines.append("authors: []")
    lines.append(f"year: {fm['year']}")
    lines.append(f'doi: "{fm["doi"]}"')
    lines.append(f'pmid: "{fm["pmid"]}"')
    lines.append(f"type: {fm['type']}")
    lines.append('grade: ""')
    lines.append(f"tags: {json.dumps(fm['tags'])}")
    lines.append(f'source_pdf: "{fm["source_pdf"]}"')
    lines.append(f'digested_at: "{fm["digested_at"]}"')
    lines.append(f'coautoria: "{fm["coautoria"]}"')
    lines.append("---")
    return "\n".join(lines)


def save_figures(figures: list, slug: str) -> list[str]:
    """Save figures to Obsidian _attachments/{slug}/ and return embed links."""
    if not figures:
        return []

    fig_dir = ATTACHMENTS_DIR / slug
    fig_dir.mkdir(parents=True, exist_ok=True)
    embeds = []

    for i, fig in enumerate(figures, 1):
        if fig["image"]:
            fname = f"fig-{i}-p{fig['page']}.png"
            fpath = fig_dir / fname
            fig["image"].save(str(fpath), "PNG")
            caption = fig["caption"][:100] if fig["caption"] else f"Figure {i}"
            embeds.append(f"![[{slug}/{fname}|{caption}]]")
            _log.info(f"  Figure {i}: {fpath}")

    return embeds


def build_note(content: dict, frontmatter: str, figure_embeds: list[str]) -> str:
    """Assemble the final Obsidian note."""
    sections = [frontmatter, ""]

    # TL;DR placeholder for human completion
    sections.append("## TL;DR")
    sections.append("<!-- Complete after reading -->")
    sections.append("")

    # Key Findings placeholder
    sections.append("## Key Findings")
    sections.append("")
    sections.append("| Finding | Effect Size | CI 95% | p-value |")
    sections.append("|---------|-------------|--------|---------|")
    sections.append("| <!-- fill --> | | | |")
    sections.append("")

    # Figures
    if figure_embeds:
        sections.append("## Figures")
        sections.append("")
        for embed in figure_embeds:
            sections.append(embed)
            sections.append("")

    # Full text (from Docling)
    sections.append("## Full Text (auto-extracted)")
    sections.append("")
    sections.append(content["markdown"])
    sections.append("")

    # Clinical Relevance placeholder
    sections.append("## Clinical Relevance")
    sections.append("<!-- NNT, ARR, applicability -->")
    sections.append("")

    # Limitations placeholder
    sections.append("## Limitations")
    sections.append("<!-- fill -->")
    sections.append("")

    # Links
    sections.append("## Links")
    if content["metadata"].get("doi"):
        sections.append(f"- DOI: https://doi.org/{content['metadata']['doi']}")
    if content["metadata"].get("pmid"):
        sections.append(f"- PubMed: https://pubmed.ncbi.nlm.nih.gov/{content['metadata']['pmid']}/")
    sections.append(f"- Source PDF: [[{content['source_pdf']}]]")
    sections.append("")

    return "\n".join(sections)


def process_pdf(pdf_path: Path, study_type: str = "", pmid: str = "") -> Path:
    """Main pipeline: PDF → Obsidian literature note."""
    INBOX_DIR.mkdir(parents=True, exist_ok=True)

    # Phase 1: Extract
    content = extract_content(pdf_path)

    # Phase 2: Build frontmatter
    frontmatter = build_frontmatter(content["metadata"], pdf_path, study_type, pmid)

    # Phase 3: Save figures
    slug = slugify(content["metadata"].get("title", "") or pdf_path.stem)
    figure_embeds = save_figures(content["figures"], slug)

    # Phase 4: Assemble note
    note = build_note(content, frontmatter, figure_embeds)

    # Phase 5: Write to inbox
    note_path = INBOX_DIR / f"{slug}.md"
    note_path.write_text(note, encoding="utf-8")
    _log.info(f"\nNote saved: {note_path}")
    _log.info(f"  Tables: {content['table_count']} | Figures: {len(content['figures'])}")

    return note_path


def main():
    parser = argparse.ArgumentParser(description="PDF → Obsidian literature note")
    parser.add_argument("path", type=Path, help="PDF file or directory of PDFs")
    parser.add_argument(
        "--type",
        default="",
        choices=["RCT", "SR", "Meta", "Guideline", "Review", ""],
        help="Study type",
    )
    parser.add_argument("--pmid", default="", help="PubMed ID for metadata enrichment")
    parser.add_argument("--vault", type=Path, default=None, help="Override Obsidian vault path")
    args = parser.parse_args()

    if args.vault:
        global INBOX_DIR, ATTACHMENTS_DIR
        INBOX_DIR = args.vault / "_inbox"
        ATTACHMENTS_DIR = args.vault / "_attachments"

    if args.path.is_dir():
        pdfs = sorted(args.path.glob("*.pdf"))
        if not pdfs:
            _log.error(f"No PDFs found in {args.path}")
            sys.exit(1)
        _log.info(f"Processing {len(pdfs)} PDFs from {args.path}")
        for pdf in pdfs:
            process_pdf(pdf, args.type, args.pmid)
    elif args.path.is_file():
        process_pdf(args.path, args.type, args.pmid)
    else:
        _log.error(f"Path not found: {args.path}")
        sys.exit(1)


if __name__ == "__main__":
    main()
