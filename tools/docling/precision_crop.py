"""Precision high-DPI crop of specific PDF regions.

Uses PyMuPDF (fitz) for exact coordinate-based cropping at 600 DPI.
Migrated from docling-tools/ repo — paths now relative to OLMO project root.
"""

import os
from pathlib import Path

import fitz

PROJECT_ROOT = Path(os.environ.get("CLAUDE_PROJECT_DIR", Path(__file__).resolve().parents[2]))
OUTPUT_DIR = Path(__file__).parent / "output" / "final"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

DPI = 600
ZOOM = DPI / 72


def crop_and_save(
    pdf_path: str, page_num: int, clip_rect: fitz.Rect, output_name: str, label: str
) -> None:
    """Crop a specific region from a PDF page and save as PNG."""
    doc = fitz.open(pdf_path)
    page = doc[page_num]
    mat = fitz.Matrix(ZOOM, ZOOM)
    pix = page.get_pixmap(matrix=mat, clip=clip_rect)

    out_path = OUTPUT_DIR / output_name
    pix.save(str(out_path))

    aspect = pix.width / pix.height
    if aspect > (1152 / 560):
        canvas_w, canvas_h = 1152, int(1152 / aspect)
    else:
        canvas_h, canvas_w = 560, int(560 * aspect)

    print(f"[{label}]")
    print(f"  {out_path}  —  {pix.width} x {pix.height} px @ {DPI} DPI")
    print(f"  Canvas fit: ~{canvas_w} x {canvas_h} px")
    print()
    doc.close()


def main():
    cochrane = str(
        PROJECT_ROOT / "content" / "aulas" / "dist" / "assets" / "Colchicina_cochrane.pdf"
    )
    tier2 = str(PROJECT_ROOT / "content" / "aulas" / "dist" / "assets" / "Colchicine_tier2.pdf")

    # COCHRANE p.15 — MI forest plot
    cochrane_clip = fitz.Rect(28, 98, 568, 272)
    crop_and_save(
        cochrane,
        14,
        cochrane_clip,
        "cochrane_MI_forest_600dpi.png",
        "Cochrane MI — Ebrahimi et al. 2025, Cochrane Database Syst Rev",
    )

    # TIER2 p.4 — MACE forest plot
    tier2_clip = fitz.Rect(50, 50, 540, 395)
    crop_and_save(
        tier2,
        3,
        tier2_clip,
        "tier2_MACE_forest_600dpi.png",
        "Tier2 MACE — Li et al. 2025, Am J Cardiovasc Drugs",
    )


if __name__ == "__main__":
    main()
