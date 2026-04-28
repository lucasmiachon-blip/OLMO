# Case Study — Fletcher Epidemiologia Clínica 6ed (S268)

> **Apenas metadata + commands.** Conteúdo do livro NÃO é commitado (copyright Artmed).
> Output PDF mora em `~/Downloads/`, fora do repo.

## Input

| Field | Value |
|---|---|
| Title | Epidemiologia Clínica: Elementos Essenciais |
| Authors | Grant S. Fletcher; Robert H. Fletcher |
| Edition | 6ª, 2021 |
| Publisher | Artmed (Wolters Kluwer) |
| ISBN-13 | 9781975109554 |
| Source | Anna's Archive (gray-zone, local-only) |
| Filename | `Epidemiologia Clínica_ Elementos Essenciais -- Grant S Fletcher; Robert H Fletcher -- 6, 2021 -- Artmed -- isbn13 9781975109554 -- 300b8dc12bf699c6721c1a519d907939 -- Anna’s Archive.epub` |
| Size | 18.56 MB |
| Files in zip | 199 (154 jpg, 26 xhtml, 9 fonts, 2 css, 1 opf, 1 ncx) |
| DRM | None ✓ |

## Pipeline used: Pandoc + xelatex (Pipeline 1 do SKILL.md)

### Tools versions
- Pandoc 3.9.0.2
- MiKTeX-XeTeX 4.16 (MiKTeX 25.12)
- Calibre 9.7.0 (instalado mas não usado — fallback)
- uv 0.11.8 (Astral Python pkg manager, S269 hardening)
- Docling 2.91.0 (em venv `~/.venvs/document-conversion/`, S269 — NÃO foi usado neste run, citado para completude)

### Command (exato, runnable)

```bash
"C:/Users/lucas/AppData/Local/Pandoc/pandoc.exe" \
  "C:/Users/lucas/Downloads/Epidemiologia Clínica_ Elementos Essenciais -- Grant S Fletcher; Robert H Fletcher -- 6, 2021 -- Artmed -- isbn13 9781975109554 -- 300b8dc12bf699c6721c1a519d907939 -- Anna’s Archive.epub" \
  -o "C:/Users/lucas/Downloads/Fletcher-Epidemiologia-Clinica-6ed-2021.pdf" \
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

> **Notes para reprodução:**
> - O run original (S268) **NÃO** incluiu `--sandbox` — adicionado retroativamente neste documento como mitigation default (CVE-2025-51591 SSRF + GHSA-xj5q-fv23-575g file write). Para reproduzir o resultado idêntico, basta omitir `--sandbox` (input EPUB era local DRM-free, sem vetor de ataque).
> - Run original usou `--highlight-style=tango` (deprecated); o snippet acima já corrige para `--syntax-highlighting=tango`.

## Output

| Field | Value |
|---|---|
| Path | `C:/Users/lucas/Downloads/Fletcher-Epidemiologia-Clinica-6ed-2021.pdf` |
| Size | 22.6 MB (22,589,600 bytes) |
| Pages | **372** |
| Format | A4 (595.28 × 841.89 pt), margem 2.5cm |
| PDF version | 1.7 |
| Title metadata | "Epidemiologia Clínica: Elementos Essenciais" (auto-extraído do EPUB) |
| Author metadata | "Grant S. Fletcher" |
| Producer | LaTeX via pandoc → MiKTeX-dvipdfmx (20250413) |
| Encrypted | No |

## Warnings observed (non-blocking)

```
[WARNING] Deprecated: --highlight-style. Use --syntax-highlighting instead.
[WARNING] [makePDF] LaTeX Warning: Hyper reference `part0009.xhtml_aAE5' on page 43 undefined
[WARNING] [makePDF] LaTeX Warning: Hyper reference `part0011.xhtml_aAEE' on page 100 undefined
[WARNING] [makePDF] LaTeX Warning: Hyper reference `part0012.xhtml_aADH' on page 123 undefined
[WARNING] [makePDF] LaTeX Warning: Hyper reference `part0013.xhtml_aAEA' on page 145 undefined
[WARNING] [makePDF] LaTeX Warning: Hyper reference `part0013.xhtml_aAES' on page 152 undefined
[WARNING] [makePDF] LaTeX Warning: Hyper reference `part0013.xhtml_aADU' on page 156 undefined
[WARNING] [makePDF] LaTeX Warning: Hyper reference `part0015.xhtml_aAD0' on page 188 undefined
[WARNING] [makePDF] LaTeX Warning: There were undefined references.
```

**Diagnóstico:** 8 hyperlinks internos do EPUB original referenciam IDs (`aAE5`, `aAEE`, etc.) que o capítulo de destino não declara. Pandoc reportou e seguiu — não inventa âncoras. Correção exigiria editar EPUB source (não vale o esforço).

## Time + cost

| Step | Duration | Notes |
|---|---|---|
| winget install Pandoc | ~30s | 39MB MSI |
| winget install MiKTeX | ~2min | 141MB EXE + setup |
| winget install Calibre | ~2min | parallel |
| MiKTeX `initexmf --set-config-value=[MPM]AutoInstall=1` | <1s | one-time |
| Pandoc + xelatex compile | ~3min | Inclui MiKTeX baixando packages on-demand (babel-portuguese, fontspec, hyperref, geometry, longtable etc) |
| **Total cold-start** | **~8min** | runs subsequentes ~1min |

## Decisões tomadas

1. **Pandoc primary, Calibre fallback**: tipografia LaTeX > preservar CSS web. Pandoc não falhou → fallback não disparado.
2. **Cambria mainfont**: serif Win11 nativo, sem necessidade de instalar font extra. Fontspec achou via Windows registry.
3. **A4 + margem 2.5cm**: pt-BR standard, compromisso entre densidade e respiro.
4. **TOC 3 níveis + number-sections**: livro científico estrutura completa.
5. **Output em Downloads, NÃO em OLMO**: copyright Artmed; OLMO é repo público.
6. **Docling NÃO usado neste run**: docling não suporta EPUB input (v2.91.0 abr/2026). Para markdown estruturado deste livro, ver §Pipeline 4 do SKILL.md (bridge via Calibre).
7. **S269 hardening (pós-run):** docling re-instalado em venv isolado (`~/.venvs/document-conversion/`) via `uv` — Python global do laptop tinha 24 vulnerabilidades em deps compartilhadas; venv audit clean ("No known vulnerabilities found"). uv 0.11.8 fixou GHSA-pjjw-68hj-v9mw da versão anterior 0.10.6.

## Próximos passos possíveis

- [ ] Rodar **Pipeline 4** (EPUB → HTML via Calibre → Markdown via Docling) para alimentar grep/AI-assist no estudo R3.
- [ ] Comparar visual com **Pipeline 2 (Calibre direto EPUB→PDF)** para decidir qual style prefere.
- [ ] Re-rodar com `--syntax-highlighting=tango` (sem warning deprecated).
- [ ] Re-rodar com fonte alternativa (Latin Modern Roman, EB Garamond) se quiser style diferente.

## Provenance

- Plan: `.claude/plans/toasty-greeting-crown.md`
- Skill: `.claude/skills/document-conversion/SKILL.md`
- Session: S268 (2026-04-27)
- Author: Lucas Peres Miachon + Claude Opus 4.7
