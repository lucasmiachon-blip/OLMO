"""Extract and inspect figure elements from PDFs using docling pipeline.

Detects PictureItems via DocLayNet layout analysis, exports as high-res PNGs.
Migrated from docling-tools/ repo — paths now relative to OLMO project root.
"""

import logging
import os
from pathlib import Path

from docling.datamodel.base_models import InputFormat
from docling.datamodel.pipeline_options import PdfPipelineOptions
from docling.document_converter import DocumentConverter, PdfFormatOption
from docling_core.types.doc import PictureItem, TableItem

logging.basicConfig(level=logging.INFO)
_log = logging.getLogger(__name__)

# High resolution for presentation quality (scale=1 ~ 72 DPI, scale=6 ~ 432 DPI)
IMAGE_RESOLUTION_SCALE = 6.0

PROJECT_ROOT = Path(os.environ.get("CLAUDE_PROJECT_DIR", Path(__file__).resolve().parents[2]))
OUTPUT_DIR = Path(__file__).parent / "output"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# Default PDFs — override via CLI args or PDFS env
PDFS = {
    "cochrane": PROJECT_ROOT / "content" / "aulas" / "dist" / "assets" / "Colchicina_cochrane.pdf",
    "tier2": PROJECT_ROOT / "content" / "aulas" / "dist" / "assets" / "Colchicine_tier2.pdf",
}

pipeline_options = PdfPipelineOptions()
pipeline_options.images_scale = IMAGE_RESOLUTION_SCALE
pipeline_options.generate_page_images = True
pipeline_options.generate_picture_images = True

converter = DocumentConverter(
    format_options={InputFormat.PDF: PdfFormatOption(pipeline_options=pipeline_options)}
)


def extract(pdf_path: Path, label: str) -> int:
    """Extract figures from a single PDF, return count."""
    _log.info(f"\n{'=' * 60}")
    _log.info(f"Processing: {label} — {pdf_path.name}")
    _log.info(f"{'=' * 60}")

    result = converter.convert(pdf_path)
    doc = result.document

    picture_count = 0
    for element, _level in doc.iterate_items():
        if isinstance(element, PictureItem):
            picture_count += 1
            caption = element.caption_text(doc) or "(no caption)"
            prov = element.prov[0] if element.prov else None
            page_no = prov.page_no if prov else "?"

            _log.info(f"\n  Picture {picture_count} — page {page_no}")
            _log.info(f"  Caption: {caption[:120]}")

            img = element.get_image(doc)
            if img:
                fname = OUTPUT_DIR / f"{label}-picture-{picture_count}-p{page_no}.png"
                img.save(str(fname), "PNG")
                _log.info(f"  Saved: {fname} ({img.width}x{img.height})")

    table_count = sum(1 for el, _ in doc.iterate_items() if isinstance(el, TableItem))
    _log.info(f"\n  Total pictures: {picture_count} | Total tables: {table_count}")
    return picture_count


if __name__ == "__main__":
    import sys

    if len(sys.argv) > 1:
        # CLI: extract_figures.py <label>:<path> [<label>:<path> ...]
        for arg in sys.argv[1:]:
            if ":" in arg:
                lbl, p = arg.split(":", 1)
            else:
                lbl = Path(arg).stem
                p = arg
            extract(Path(p), lbl)
    else:
        for label, pdf_path in PDFS.items():
            extract(pdf_path, label)
