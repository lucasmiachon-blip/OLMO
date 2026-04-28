# Case: Prognosis Research in Health Care (Riley et al, 2019) — PDF scan → PDF pesquisável

> Pipeline 5 (OCRmyPDF + Tesseract + Ghostscript). S272, 2026-04-28.

## Input

| Campo | Valor |
|---|---|
| Arquivo | `Prognosis Research in Health Care_ Concepts, Methods, and -- Riley, Richard D_ (editor);van der Windt, Danielle -- 1, 2019 jan -- IRL Press at Oxford -- isbn13 9780191837890 -- ... -- A.pdf` |
| Tamanho | 70.5MB |
| Páginas | 376 |
| Producer | **RICOH Aficio MP 6002** (assinatura de scanner multifunção) |
| Page rotation | 90° (book opened, scanned flat — 2-up landscape) |
| Page size | 655.2 × 446.4 pts |
| `pdftotext` pgs 1-5 | 5 bytes (camada de texto inexistente) |
| `pdftotext` pgs 50-55 | 6 bytes |
| Idioma | English |
| Copyright | Oxford University Press 2019 — local-only, gitignored |

## Comando full run

```bash
PATH="$PATH:/c/Program Files/Tesseract-OCR:/c/Users/lucas/AppData/Local/gs10070/bin" \
"C:/Users/lucas/.venvs/document-conversion/Scripts/ocrmypdf.exe" \
  --language eng \
  --rotate-pages --rotate-pages-threshold 5 \
  --deskew \
  --jobs 4 \
  --output-type pdf \
  --optimize 1 \
  "C:/Users/lucas/Downloads/Prognosis-input.pdf" \
  "C:/Users/lucas/Downloads/Prognosis-Research-OCR.pdf"
```

## Output

| Campo | Valor |
|---|---|
| Arquivo | `~/Downloads/Prognosis-Research-OCR.pdf` |
| Tamanho | 84.2MB (+19% vs input — text-layer overhead) |
| Páginas | 376 (preservadas) |
| Producer | `pikepdf 10.5.1` (rewrite por OCRmyPDF) |
| Page rotation | **0°** (auto-corrigida via Tesseract OSD) |
| Page size | 446.4 × 655.2 pts (flipped — orientação correta) |
| PDF version | 1.5 |

## Verificação pdftotext (post-OCR)

| Range | Bytes | Delta vs pre |
|---|---|---|
| pgs 1-5 (cover/title) | 387 | 5 → 387 (77×) |
| pgs 50-55 | 9.208 | 6 → 9.208 (1535×) |
| pgs 100-105 | 15.532 | 0* → 15.532 |
| pgs 200-205 | 19.511 | 0* → 19.511 |
| pgs 350-355 | 15.954 | 0* → 15.954 |

*Não testado pre-OCR; extrapolado de pgs 1-55 (~1 byte/pg).

### Spot-check qualidade pg 100

Texto extraído:

> **80 | TEN PRINCIPLES TO STRENGTHEN PROGNOSIS RESEARCH**
> **4.9 Use reporting guidelines when publishing prognosis research**
> Transparent and complete reporting is important... deficiencies in reporting in published prognosis studies are common (1, 7, 11, 12, 50-53)... REMARK... TRIPOD... CONSORT...

Citações numéricas (1, 7, 11, 12, 50-53), acrônimos (REMARK/TRIPOD/CONSORT), header de página ("80 | ...") — todos preservados. 1 erro tipográfico visível: aspas curvas viraram apóstrofo único. Aceitável.

## Tempo

- Sample (5 pgs): ~30s, 4 jobs.
- Full run (376 pgs): **~3min**, 4 jobs paralelos.

## Warnings registrados

- Pgs 2, 4, 375 (capa/folha de rosto/colofão): `[tesseract] Too few characters. Skipping this page` — comportamento correto, páginas em branco/sparse.
- Pg 376: `[tesseract] lots of diacritics - possibly poor OCR` — colofão da editora com fontes pequenas. Não invalida o resto.
- 6× `Suppressing OCR output text with improbable aspect ratio` — Tesseract suprimiu texto detectado em figuras/diagramas (proteção contra garbage).

## Setup environment (one-time, validado nesta sessão)

```bash
# 1. Tesseract via winget GitHub mirror
winget install --id tesseract-ocr.tesseract -e --silent --accept-package-agreements --accept-source-agreements

# 2. Ghostscript: download via curl + install em terminal Win nativo
curl -sL --max-time 240 \
  "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs10070/gs10070w64.exe" \
  -o ~/Downloads/gs10070w64.exe

#    SEPARATE Windows terminal (Win+R cmd Enter), NÃO Bash:
#    "C:\Users\lucas\Downloads\gs10070w64.exe" /S /D=C:\Users\lucas\AppData\Local\gs10070

# 3. OCRmyPDF via uv no venv existente
uv pip install ocrmypdf --python "C:/Users/lucas/.venvs/document-conversion/Scripts/python.exe"

# 4. Verify
"C:/Program Files/Tesseract-OCR/tesseract.exe" --version
ls "C:/Users/lucas/AppData/Local/gs10070/bin/gswin64c.exe"
"C:/Users/lucas/.venvs/document-conversion/Scripts/ocrmypdf.exe" --version
```

## Lições aprendidas (KBP/skill candidates)

- **UB-Mannheim CDN 403 persistente:** `winget install --id UB-Mannheim.TesseractOCR` falha com HTTP 403 Forbidden no `digi.bib.uni-mannheim.de`. Fallback canônico = `tesseract-ocr.tesseract` (GitHub mirror, distinct download URL).
- **Ghostscript fora do winget catalog:** Microsoft não indexa AGPL packages. Direct download + install user-scope `/D=AppData\Local\` evita UAC.
- **NSIS installer `/S` não roda via Bash MSYS:** `Permission denied 126`. Bash fork/exec não aciona `CreateProcess` Windows API que NSIS depende. Solução = terminal Win nativo (cmd/PowerShell separado), não `! prefix` em Claude Code.
- **OCR sem `--language` flag → KBP-53:** Tesseract default usa training data inferior; flag explícito eng/por/eng+por amarra dataset correto.
- **Sample-first gate ROI alto:** 5 pgs (~30s) valida params antes de gastar 3min em 376 pgs. Threshold 5 confirmou rotação OK em todas as páginas testadas.
