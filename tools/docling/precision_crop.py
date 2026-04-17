"""Precision high-DPI crop of specific PDF regions.

Uses PyMuPDF (fitz) for exact coordinate-based cropping at 600 DPI.
Migrated from docling-tools/ repo — paths now relative to OLMO project root.

Citations for slide source-tag:
  Cochrane: Ebrahimi et al. 2025, Cochrane Database Syst Rev
  Tier2: Li et al. 2025, Am J Cardiovasc Drugs
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
    # Exact positions from get_text('dict') inspection (merged from source repo S224):
    #   Column headers "Study or Subgroup" + Risk of Bias A-F: y=101-120
    #   Studies: y=131-208
    #   Total (Wald.) / Total events: y=218-237
    #   Test for overall effect: y=238-247
    #   Axis labels "Colchicine"/"Comparison": y=248-257
    #   Heterogeneity: y=258-266
    #   (CUT line)
    #   "Footnotes": y=277
    # Skip "Figure 3." title (y=80-90) — slide h2 replaces it.
    cochrane_clip = fitz.Rect(
        28,  # left
        98,  # top: just before column headers (101)
        568,  # right: include Risk of Bias dots
        272,  # bottom: after heterogeneity (266), before Footnotes (277)
    )
    crop_and_save(
        cochrane,
        14,
        cochrane_clip,
        "cochrane_MI_forest_600dpi.png",
        "Cochrane MI — Ebrahimi et al. 2025, Cochrane Database Syst Rev",
    )

    # TIER2 p.4 — MACE forest plot (2 subgroups)
    # Docling bbox (converted to top-left): top=55.7, bottom=391.0
    # Caption "Fig 1" text starts at y≈405
    tier2_clip = fitz.Rect(
        50,  # left: study names with margin
        50,  # top: include column headers
        540,  # right: include Weight column
        395,  # bottom: include graph axis, stop before caption (~405)
    )
    crop_and_save(
        tier2,
        3,
        tier2_clip,
        "tier2_MACE_forest_600dpi.png",
        "Tier2 MACE — Li et al. 2025, Am J Cardiovasc Drugs",
    )


if __name__ == "__main__":
    main()
