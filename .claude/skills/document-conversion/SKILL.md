---
name: document-conversion
description: "Pipeline de conversão entre formatos de documento (EPUB→PDF, PDF→Markdown, DOCX/PPTX→structured) via Pandoc+xelatex / Docling / Calibre. Use quando precisar converter livros, papers ou documentos para leitura, estudo R3 ou ingestão por AI."
version: 1.1.0
context: fork
allowed-tools: Read, Glob, Bash, Write
argument-hint: "<input-file> [--to {pdf,md,html,mobi}] [--font Cambria]"
---

# Document Conversion — Pipelines Canônicos

## ENFORCEMENT (primacy anchor — leia antes de qualquer execução)

1. **NUNCA commit PDF/EPUB/DOCX de livros ou papers com copyright** ao repo OLMO. Outputs vão em `~/Downloads` ou `~/Documents/Books/`. Repo OLMO é público em github.com — copyright + git bloat = risco real.
2. **Tool selection é input×output match.** Não improvise: cada par (input format, output format) tem o tool certo (ver §Decision Tree). Misturar (ex: docling para EPUB) = falha silenciosa ou perda de qualidade. KBP-08 análogo.
3. **Pre-flight binários obrigatório.** Confirmar paths absolutos dos executáveis antes de dispatch — Win11 não atualiza PATH em shell ativo pós-install. Use `--version` check com path absoluto.
4. **Verify output antes de claim sucesso.** `pdfinfo` para PDF, `file -b` para tipo, `ls -lh` para size. Exit code 0 ≠ output válido — pandoc pode emitir PDF quebrado com warnings ignorados.
5. **Copyright respect.** Material proprietário (livros Wolters Kluwer/Artmed/Elsevier, papers paywalled) — uso pessoal de estudo OK; redistribuição via repo público NÃO. Anna's Archive é gray-zone — tratar como local-only.
6. **Pandoc `--sandbox` SEMPRE.** Mitigation contra CVE-2025-51591 (SSRF via iframe HTML, AWS IMDS attack vector) e GHSA-xj5q-fv23-575g (arbitrary file write via `--extract-media` em input untrusted). Custo zero, blinda input untrusted.
7. **Python isolation via venv obrigatório.** Tools Python (docling) instalados em `~/.venvs/document-conversion/` via `uv` — nunca poluir Python global. Audit clean: `pip-audit` no venv = "No known vulnerabilities found". Global Python tem 24+ vulns por ser env compartilhado.

---

## Decision Tree

| Input | Output | Tool | Comando-base | Why |
|---|---|---|---|---|
| EPUB | PDF | **Pandoc + xelatex** | `pandoc in.epub -o out.pdf --pdf-engine=xelatex --sandbox` | LaTeX typography pro (ligatures, kerning, hyphenation pt-BR), Unicode-safe |
| EPUB | PDF (CSS-preserving) | **Calibre** `ebook-convert` | `ebook-convert in.epub out.pdf` | Preserva CSS web original; mais resiliente a layouts complexos |
| EPUB | MOBI/AZW3 | **Calibre** `ebook-convert` | `ebook-convert in.epub out.mobi` | E-reader formats (Kindle) |
| PDF | Markdown | **Docling** (venv) | `<venv>/Scripts/docling.exe in.pdf --to md --output out.md` | Structured extraction layout-aware (papers, livros) |
| PDF | JSON/DocTags | **Docling** (venv) | `<venv>/Scripts/docling.exe in.pdf --to json` | AI-ingestion format (RAG, agents) |
| DOCX/PPTX/XLSX | Markdown | **Docling** (venv) | `<venv>/Scripts/docling.exe in.docx --to md` | Office formats com layout-preserving |
| HTML | PDF | **Pandoc** + weasyprint OR wkhtmltopdf | `pandoc in.html -o out.pdf --pdf-engine=weasyprint --sandbox` | Web styles preservados |
| Markdown | PDF | **Pandoc + xelatex** | `pandoc in.md -o out.pdf --pdf-engine=xelatex --sandbox` | Standard pandoc; o caso de uso primário do Pandoc |
| EPUB | HTML (intermediate) | **Calibre** `ebook-convert` | `ebook-convert in.epub out.html` | Bridge para docling (que não lê EPUB direto) |

**Insight chave:** Docling não lê EPUB. Para EPUB→Markdown estruturado: pipeline 2-step EPUB → HTML (Calibre) → Markdown (Docling).

---

## Tools Required (Win11, paths absolutos)

| Tool | Path | Versão pinada | Source |
|---|---|---|---|
| **uv** (Python pkg manager) | `C:/Users/lucas/AppData/Local/Programs/Python/Python314/Scripts/uv.exe` | 0.11.8+ | Astral (pip install uv) |
| Pandoc | `C:/Users/lucas/AppData/Local/Pandoc/pandoc.exe` | 3.9.0.2 | winget JohnMacFarlane.Pandoc |
| xelatex (MiKTeX) | `C:/Users/lucas/AppData/Local/Programs/MiKTeX/miktex/bin/x64/xelatex.exe` | 4.16 (MiKTeX 25.12) | winget MiKTeX.MiKTeX |
| pdfinfo (MiKTeX) | `C:/Users/lucas/AppData/Local/Programs/MiKTeX/miktex/bin/x64/pdfinfo.exe` | poppler bundled | (vem com MiKTeX) |
| Calibre | `C:/Program Files/Calibre2/ebook-convert.exe` | 9.7.0 | winget calibre.calibre |
| Docling (em venv) | `C:/Users/lucas/.venvs/document-conversion/Scripts/docling.exe` | 2.91.0 | uv pip install (no venv) |

### Setup completo (one-time, idempotent)

```bash
# 1. Native binaries via winget
winget install --id JohnMacFarlane.Pandoc -e --accept-package-agreements --accept-source-agreements
winget install --id MiKTeX.MiKTeX -e --accept-package-agreements --accept-source-agreements
winget install --id calibre.calibre -e --accept-package-agreements --accept-source-agreements

# 2. MiKTeX auto-install packages (evita prompts interativos no primeiro xelatex)
"C:/Users/lucas/AppData/Local/Programs/MiKTeX/miktex/bin/x64/initexmf.exe" --set-config-value="[MPM]AutoInstall=1"

# 3. uv (Python package manager moderno)
pip install --upgrade uv

# 4. Venv isolado para docling (NÃO poluir Python global)
mkdir -p ~/.venvs
uv venv ~/.venvs/document-conversion --python 3.14
uv pip install docling --python "C:/Users/lucas/.venvs/document-conversion/Scripts/python.exe"

# 5. Verify
"C:/Users/lucas/AppData/Local/Pandoc/pandoc.exe" --version | head -1
"C:/Users/lucas/AppData/Local/Programs/MiKTeX/miktex/bin/x64/xelatex.exe" --version | head -1
"C:/Program Files/Calibre2/ebook-convert.exe" --version | head -1
"C:/Users/lucas/.venvs/document-conversion/Scripts/docling.exe" --version
```

### Por que uv > pip (decisão profissional)

- **10–100× mais rápido** (resolução paralela em Rust).
- **Lockfile determinístico** (`uv.lock`) — reproducible builds.
- **venv built-in** sem virtualenv extra.
- **Mantido pela Astral** (mesma team do `ruff`, `ty`).
- **Compatível PEP 723** (script deps inline).
- **Substitui** pip + pip-tools + virtualenv + pyenv num único binário.
- Histórico CVE: GHSA-pjjw-68hj-v9mw fixed em 0.11.6 — sempre rodar versão atual.

### Por que venv isolado (não pollute global)

`pip-audit` no global Python do laptop: **24 vulnerabilidades em 16 packages** (env compartilhado com outros projetos). `pip-audit` no venv `document-conversion`: **No known vulnerabilities found**. Isolation = audit clean garantido.

---

## Pipeline 1 — EPUB → PDF (Pandoc + xelatex)

### Quando usar
Livro científico/técnico para leitura LaTeX-grade (estudo R3, MBE deep-read).

### Comando canônico (com `--sandbox` mitigation)

```bash
"C:/Users/lucas/AppData/Local/Pandoc/pandoc.exe" \
  "<input.epub>" \
  -o "<output.pdf>" \
  --pdf-engine="C:/Users/lucas/AppData/Local/Programs/MiKTeX/miktex/bin/x64/xelatex.exe" \
  --sandbox \
  --toc --toc-depth=3 \
  --number-sections \
  -V documentclass=book \
  -V geometry:margin=2.5cm \
  -V geometry:a4paper \
  -V lang=pt-BR \
  -V mainfont=Cambria \
  -V monofont=Consolas \
  -V linkcolor=NavyBlue \
  -V urlcolor=NavyBlue \
  -V toccolor=NavyBlue \
  --syntax-highlighting=tango \
  --standalone
```

### Justificativa por flag
- `--sandbox`: mitigation CVE-2025-51591 (SSRF iframe→IMDS) e GHSA-xj5q-fv23-575g (arbitrary file write). Bloqueia leitura de arquivos remotos via iframe/include — safe para EPUB local DRM-free.
- `--pdf-engine=xelatex`: Unicode + system fonts (Cambria/Calibri Win11 nativos).
- `--toc --toc-depth=3`: TOC interativo até 3 níveis (chapter > section > subsection).
- `documentclass=book`: chapter breaks, recto-verso, two-sided typography.
- `geometry:margin=2.5cm a4paper`: pt-BR standard.
- `lang=pt-BR`: Babel hyphenation portuguesa.
- `mainfont=Cambria`: serif Win11 nativo, render bom em ciência. Fallback: Latin Modern Roman (default LaTeX, sempre presente).
- `linkcolor=NavyBlue`: links visíveis sem berrar.
- `--syntax-highlighting=tango`: substitui o deprecated `--highlight-style`.

### Variantes
- **Sem TOC:** remover `--toc --toc-depth=3 --number-sections`.
- **Fonte fallback robusta** (se Cambria falha por fontspec error): `-V mainfont="Latin Modern Roman"`.
- **Two-column** (papers): `-V classoption=twocolumn`.
- **Input HTML/Markdown trusted com recursos remotos**: omit `--sandbox` (override consciente, não default).

### Caso real: Fletcher — Epidemiologia Clínica 6ed (S268, 2026-04-27)
Ver [`examples/fletcher-epidemiologia-2026-04-27.md`](./examples/fletcher-epidemiologia-2026-04-27.md).

Resumo:
- Input: 18.56MB, 199 files, 154 imagens JPG, DRM-free.
- Output: **372 páginas A4, 22.6MB**.
- 8 hyperref warnings (links internos quebrados no EPUB original).
- Tempo: ~3min cold-start; runs subsequentes ~1min.

---

## Pipeline 2 — EPUB → PDF (Calibre fallback)

### Quando usar
- Pandoc falha em tabelas/imagens complexas.
- Quer preservar CSS original do EPUB (não tipografia LaTeX).
- Livros didáticos com layouts visuais ricos.

```bash
"C:/Program Files/Calibre2/ebook-convert.exe" \
  "<input.epub>" \
  "<output.pdf>" \
  --paper-size a4 \
  --pdf-default-font-size 11 \
  --pdf-page-margin-top 50 --pdf-page-margin-bottom 50 \
  --pdf-page-margin-left 60 --pdf-page-margin-right 60 \
  --pretty-print \
  --preserve-cover-aspect-ratio \
  --pdf-add-toc
```

**Calibre 9.7.0 está patched** contra CVE-2026-25636/26064/26065 (path traversal — fixed em 9.3.0). Nunca rodar Calibre em EPUBs de origem desconhecida (Anna's Archive OK; aleatório da web NÃO).

---

## Pipeline 3 — PDF/DOCX → Markdown (Docling, no venv)

### Quando usar
- Paper PDF para grep/search/AI-ingestion (RAG, alimentar agente de estudo).
- Livro já-PDF que quer reduzir a markdown limpo para indexar.
- DOCX/PPTX/XLSX corporativos para documentação textual.

### Comando (path absoluto do venv binário)

```bash
"C:/Users/lucas/.venvs/document-conversion/Scripts/docling.exe" \
  "<input.pdf>" \
  --to md \
  --output "<output.md>"
```

Output formats também disponíveis: `--to html`, `--to json`, `--to doctags`.

### Caso de uso típico R3
- Baixar paper PDF de NEJM/JAMA → `docling paper.pdf --to md` → grep no markdown para extrair conclusões/PMID.
- Alimentar `evidence-researcher` subagent com markdown limpo (mais eficiente que PDF binário).

---

## Pipeline 4 — EPUB → Markdown (2-step via Calibre + Docling)

Docling não lê EPUB diretamente. Bridge:

```bash
"C:/Program Files/Calibre2/ebook-convert.exe" "<input.epub>" "<intermediate.html>"
"C:/Users/lucas/.venvs/document-conversion/Scripts/docling.exe" "<intermediate.html>" --to md --output "<output.md>"
rm "<intermediate.html>"   # limpar temp
```

---

## Pipeline 5 — PDF escaneado → PDF pesquisável (OCRmyPDF + Tesseract + Ghostscript)

### Quando usar
Livro/paper escaneado precisa Ctrl+F + texto copiável preservando imagens originais. **Sinais de scan no input:** Producer = nome de hardware (RICOH MP, Canon iR), `pdftotext` <10 bytes em páginas de conteúdo, page rotation 90° comum (book opened, scanned flat).

### Tools adicionais

| Tool | Path | Versão | Source |
|---|---|---|---|
| Tesseract | `C:/Program Files/Tesseract-OCR/tesseract.exe` | 5.5.0.20241111 | `winget install --id tesseract-ocr.tesseract` (NÃO `UB-Mannheim.TesseractOCR` — CDN 403 confirmado S272) |
| Ghostscript | `C:/Users/lucas/AppData/Local/gs10070/bin/gswin64c.exe` | 10.07.0 | direct download `github.com/ArtifexSoftware/ghostpdl-downloads/releases/tag/gs10070` (não no winget catalog default — AGPL); install **em terminal Windows nativo** (cmd/PowerShell direto, NÃO via Bash MSYS — Permission denied 126): `"...\gs10070w64.exe" /S /D=C:\Users\lucas\AppData\Local\gs10070` |
| OCRmyPDF | `C:/Users/lucas/.venvs/document-conversion/Scripts/ocrmypdf.exe` | 17.4.2 | `uv pip install ocrmypdf --python <venv>/Scripts/python.exe` |

### Comando canônico

```bash
PATH="$PATH:/c/Program Files/Tesseract-OCR:/c/Users/lucas/AppData/Local/gs10070/bin" \
"C:/Users/lucas/.venvs/document-conversion/Scripts/ocrmypdf.exe" \
  --language eng \
  --rotate-pages --rotate-pages-threshold 5 \
  --deskew \
  --jobs 4 \
  --output-type pdf \
  --optimize 1 \
  "<input.pdf>" "<output-OCR.pdf>"
```

### Justificativa por flag
- `--language eng|por|eng+por`: dataset Tesseract. **Sem flag = KBP-53** (default usa training inferior). Livro EN → `eng`; PT-BR → `por`; mixto → `eng+por`.
- `--rotate-pages --rotate-pages-threshold 5`: auto-detect orientação (scans 2-up landscape vêm 90°). Threshold 5 conservador (default 14 mais agressivo, pode rotacionar páginas legítimas erradas).
- `--deskew`: corrige inclinação de scanner.
- `--jobs 4`: paralelismo CPU-bound (Tesseract single-thread per page).
- `--output-type pdf`: PDF normal. PDF/A archival apenas se preservação 50-anos (custo: ~1.5-2x size, sem ganho pra estudo).
- `--optimize 1`: lossless (default). `2` requer jbig2enc não-instalado; `3` lossy.

### Sample-first gate (obrigatório livros >50pp)

Antes de full run, validar params em 5 páginas via `--pages 1-5`:
```bash
ocrmypdf [...flags...] --pages 1-5 input.pdf sample-OCR.pdf
pdftotext -f 1 -l 5 sample-OCR.pdf - | wc -c   # deve ser >> bytes pre-OCR
```
Bytes <500 ou texto ilegível → ajustar params antes do full run. CPU caro: 376pp ~3min com 4 jobs.

### Caso real: Prognosis Research in Health Care 2019 (Riley et al)
Ver [`examples/prognosis-research-2026-04-28.md`](./examples/prognosis-research-2026-04-28.md).

Resumo: 70.5MB/376pp scan RICOH MP 6002 → 84MB pesquisável (+19% text-layer overhead), page rot 90°→0° auto-corrigida, ~3min CPU 4 jobs, `pdftotext` 9k-19k bytes/range pos vs 5-6 bytes pre.

---

## Storage Convention

| Tipo | Onde |
|---|---|
| Output PDF de livro com copyright | `~/Downloads/` ou `~/Documents/Books/` (gitignored) |
| Output Markdown de paper para estudo | `~/Documents/R3/papers-md/` (local, gitignored) |
| Temp files (intermediate HTML, etc) | `.claude/.research-tmp/` (já em .gitignore) |
| Skill examples / case studies | `.claude/skills/document-conversion/examples/` (este diretório, OK commit — só docs) |
| Python venv (docling + deps) | `~/.venvs/document-conversion/` (fora do repo, ~2GB com torch) |

**NÃO commit:**
- PDFs/EPUBs/DOCXs de livros comerciais.
- Papers paywalled.
- Arquivos >5MB de conteúdo terceirizado.
- Venvs (qualquer `.venv*/` ou `~/.venvs/`).

**OK commit:**
- Markdown de notas/resumos próprios.
- Outputs de docs públicos (CC-BY, public domain).
- Este SKILL.md + examples conceituais.

---

## Verification Checklist

Após qualquer conversão:

```bash
# 1. File exists + size sanity
ls -lh "<output>"

# 2. PDF metadata (se PDF)
"C:/Users/lucas/AppData/Local/Programs/MiKTeX/miktex/bin/x64/pdfinfo.exe" "<output.pdf>"

# 3. Markdown sanity (se markdown)
wc -l "<output.md>"
head -20 "<output.md>"

# 4. Audit do venv (Python deps)
"C:/Users/lucas/.venvs/document-conversion/Scripts/pip-audit.exe"
```

**PASS criteria:**
- File exists, size razoável (PDF: 5–30MB para livro 300pp; markdown: depende).
- pdfinfo: Pages > 0, Title detectado, Encrypted=no.
- Open no reader: TOC clicável, primeiras 5 páginas renderizam, fontes legíveis.
- pip-audit: "No known vulnerabilities found".

**FAIL signs:**
- Size <500KB (provável crash silencioso).
- pdfinfo retorna erro.
- Páginas vazias ou imagens ausentes.
- pip-audit reporta CVE — `uv pip install --upgrade <pkg> --python <venv>/Scripts/python.exe`.

→ FAIL = aplicar fallback alternativo (Pipeline 1 fail → Pipeline 2; Docling fail → Pandoc) ou diagnose root cause.

---

## Maintenance (rotina trimestral)

1. **Upgrade native binaries:**
   ```bash
   winget upgrade --id JohnMacFarlane.Pandoc --silent --accept-package-agreements
   winget upgrade --id MiKTeX.MiKTeX --silent --accept-package-agreements
   winget upgrade --id calibre.calibre --silent --accept-package-agreements
   ```
2. **Upgrade Python deps no venv:**
   ```bash
   uv pip install --upgrade docling --python "C:/Users/lucas/.venvs/document-conversion/Scripts/python.exe"
   ```
3. **Audit:**
   ```bash
   "C:/Users/lucas/.venvs/document-conversion/Scripts/pip-audit.exe"
   ```
4. **Check CVE feeds:**
   - https://github.com/jgm/pandoc/security
   - https://github.com/kovidgoyal/calibre/security
   - https://github.com/docling-project/docling/security

---

## Related

- `.claude/plans/toasty-greeting-crown.md` — plan inicial S268 (Fletcher conversion).
- `examples/fletcher-epidemiologia-2026-04-27.md` — case study completo Fletcher.
- `CLAUDE.md §Architecture` — runtime sem Python para skills core; este skill é exception (docling Python-based via venv).
- `docs/adr/0002-external-inbox-integration.md` — convenção `$OLMO_INBOX` para inputs externos (não é storage de outputs).
- KBP-08 (API/MCP Substitution): princípio análogo — usar a tool certa, não improvisar com substituto inferior.

## Security context (S269 audit)

- **Pandoc 3.9.0.2**: CVE-2025-51591 mitigation = `--sandbox` (default no skill); GHSA-xj5q-fv23-575g afeta `--extract-media` em input untrusted (não usado).
- **MiKTeX 25.12**: clean per lo4d.com (jan/2026); CVE-2023-32700 fixed em 23.5 → 25.12 patched.
- **Calibre 9.7.0**: patched contra CVE-2026-25636/26064/26065 (fixed em 9.3.0).
- **Docling 2.91.0**: IBM Research Zurich oficial, OpenSSF Best Practices, signed PyPI releases, MIT, sem CVEs reportadas.
- **uv 0.11.8**: GHSA-pjjw-68hj-v9mw fixed em 0.11.6 → 0.11.8 patched.
- **Venv audit**: `pip-audit` em `~/.venvs/document-conversion/` = "No known vulnerabilities found".
