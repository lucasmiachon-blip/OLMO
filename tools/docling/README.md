# tools/docling — PDF Pipeline for Medical Research

> OLMO medical research workflow. Auditado/documentado em S224 (2026-04-17).
> Separate venv (~2GB). Python 3.13 required.
> Migrado de `C:/Dev/Projetos/docling-tools/` em S216. Source agora obsoleto (candidato a delete).

## Scope (5 use cases Lucas)

| # | Use case | Status | Tool |
|---|----------|--------|------|
| 1 | PDF (incl. raster) → texto LLM-ready | **DONE** | `pdf_to_obsidian.py` via IBM Docling lib (OCR built-in) |
| 2 | Resumir texto extraido | **DONE** | `pdf_to_obsidian.py` Agent 3 (multi-agent orchestration) |
| 3a | Alimentar Obsidian vault | **DONE** | `pdf_to_obsidian.py` → `OBSIDIAN_VAULT/_inbox/` |
| 3b | Alimentar Notion | TODO Phase 2 | `notion-client` wrapper (nao escrito) |
| 4 | Raster PDF → PDF fillable com campos | TODO Phase 2 | `ocrmypdf --output-type pdfa` (dep nao adicionada) |
| 5 | Crop imagens para apresentacoes | **DONE** | `extract_figures.py` (Docling layout 432 DPI) + `precision_crop.py` (PyMuPDF bbox 600 DPI) |
| BONUS | Cross-evidence triangulation (anti-hallucination) | **DONE** | `cross_evidence.py` — concordance/discordance matrix entre N literature-notes |

## Scripts

| File | Size | Purpose |
|------|------|---------|
| `pdf_to_obsidian.py` | 10 KB | PDF → Obsidian literature-note com Docling + PubMed/CrossRef enrichment. Multi-agent pattern: Agent 1 (Docling extraction) + Agent 2 (metadata) + Agent 3 (summarization). CLI: `--type RCT|SR|Meta|Guideline|Review`, `--pmid`, dir batch. |
| `cross_evidence.py` | 13 KB | Cross-evidence synthesis: N notes → permanent-note com triangulation matrix. Anti-hallucination (claims anchored to source PDFs). CLI: `--tag`, `--files`, `--topic`. |
| `extract_figures.py` | 3 KB | Docling layout detection → high-res PictureItem PNG export (432 DPI default). Hardcoded: colchicine PDFs. |
| `precision_crop.py` | 2 KB | PyMuPDF bbox crop com coordenadas exatas (600 DPI). Hardcoded: forest plots MI/MACE colchicine. |

## Setup

```bash
cd tools/docling
uv venv && uv sync
```

Separate `.venv` (~2GB, gitignored). Primeira execucao baixa ~2GB de modelos Docling (layout detection + table recognition).

## Usage

```bash
# Case 1+2+3a: PDF to Obsidian literature-note
cd tools/docling
uv run python pdf_to_obsidian.py /path/to/paper.pdf --type RCT
uv run python pdf_to_obsidian.py /path/to/paper.pdf --pmid 12345678
uv run python pdf_to_obsidian.py /path/to/dir_of_pdfs/

# Case 5: Figure extraction
uv run python extract_figures.py
uv run python precision_crop.py

# Bonus: Cross-evidence triangulation
uv run python cross_evidence.py --tag colchicine
uv run python cross_evidence.py --files note1.md note2.md note3.md
uv run python cross_evidence.py --topic "colchicine pericarditis"
```

Obsidian vault path via env: `OBSIDIAN_VAULT` (default `C:\Users\lucas\OneDrive\LM\Documentos\Obsidian Vault`).

## Phase 2 TODO (S225+)

| Case | Code needed | Deps |
|------|-------------|------|
| 3b Notion | `notion_writer.py` — parse Obsidian markdown → Notion database rows, upload attachments | `notion-client>=2.2` |
| 4 Fillable PDF | `ocr_to_fillable.py` — `ocrmypdf --output-type pdfa --deskew` wrapper | `ocrmypdf>=16.0` |

## Known limitations

- `extract_figures.py` + `precision_crop.py`: hardcoded colchicine paths. Generalize quando houver 2+ PDFs distintos.
- `pdf_to_obsidian.py`: assume Docling models baixados. Primeira execucao ~2GB download.
- Docling OCR: requer TesseraCT ou EasyOCR instalado para raster PDFs; testar em S225 com PDF real scanned.
- Notion writer ausente: atualmente envio manual via copy-paste do Obsidian note.

## References

- IBM Docling: https://github.com/docling-project/docling (Apache 2.0)
- PyMuPDF: https://pymupdf.readthedocs.io/
- ocrmypdf: https://ocrmypdf.readthedocs.io/
- notion-client (python SDK): https://github.com/ramnes/notion-sdk-py

## Source repo status

Repo original `C:/Dev/Projetos/docling-tools/` tem versao **obsoleta** (2 files stale, sem `pdf_to_obsidian.py` nem `cross_evidence.py`). Safe to delete apos S224 verificacao. OLMO `tools/docling/` = canonical.

---
Coautoria: Lucas + Opus 4.7 | S224 2026-04-17
