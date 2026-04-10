# Plan: QA s-pico — S145

## Context

s-pico is at state LINT-PASS, ready for QA. Evidence was refactored to benchmark in S144. h2 updated with "RS" in S144. Screenshots from 2026-04-05 are stale (pre-h2 update). This plan follows the established QA pipeline (qa-pipeline.md §1) exactly — no shortcuts, no batching.

Design target: auditorio 10m projetor (cenario B).

## Steps

### Step 1 — Build
```bash
cd content/aulas && npm run build:metanalise
```
Confirms lint + build pass. Prerequisite for capture.

### Step 2 — Capture fresh screenshots
```bash
cd content/aulas && node scripts/qa-capture.mjs --aula metanalise --slide s-pico
```
Generates fresh S0/S1/S2 screenshots (replacing stale 2026-04-05 captures).

### Step 3 — Preflight (Fase B: QA visual MULTIMODAL)

**Analise visual obrigatoria (S138):** ler o screenshot COMO IMAGEM (multimodal), nao apenas codigo. Olhar: contraste, hierarquia, varredura, densidade, **alinhamento**.

Lucas ja sinalizou: **ha um desalinhamento gritante visivel.** Prioridade na inspeção visual.

Criteria already read (design-reference.md §1-§2, slide-rules.md). Evaluate 4 dims against fresh screenshot + code:

| Dim | Source | What to check |
|-----|--------|---------------|
| Cor | design-reference.md §1 | Tokens only (no literals). Semantic color correct (--downgrade for ≠ symbol, --ui-accent for letters). Contrast for 10m projection |
| Tipografia | design-reference.md §2 | Font >= 18px body. No vw/vh. Weight >= 400. Display font for PICO letters. Tabular-nums if numeric |
| Hierarquia | slide-rules.md §1, §1b | h2 present (assertion). Punchline > support. PICO letters draw eye first, then desc. Visual flow top→bottom |
| Design | slide-rules.md §1b | Grid 2x2 composition. **Alinhamento cards** (grid gaps, padding, baseline). Spacing. Viewport usage 1280x720. Punchline separated by border-top |

Output: PASS/FAIL table with evidence from screenshot + code. **STOP after report.**

### Step 4 — Lucas loop
Lucas reviews, requests changes if needed, iterates. Each change = rebuild + recapture + re-evaluate.

### Step 5 — Inspect (after Lucas "prossiga")
```bash
cd content/aulas && node scripts/gemini-qa3.mjs --aula metanalise --slide s-pico --inspect
```
Gemini Flash defect scan. Report → STOP.

### Step 6 — Editorial (after Lucas OK)
```bash
cd content/aulas && node scripts/gemini-qa3.mjs --aula metanalise --slide s-pico --editorial
```
3 Gemini Pro calls (A: visual, B: UX/code, C: motion) + Call D (anti-sycophancy audit). Report → STOP.

Known FP to inject: css_cascade (2/10 R14) — failsafe rules correctly scoped, Gemini confuses conditional with global.

### Step 7 — Wrap-up
Save editorial suggestions to `qa-screenshots/s-pico/editorial-suggestions.md`. Update HANDOFF state to DONE (pending final Lucas approval). CHANGELOG entry.

## Critical files

| File | Role |
|------|------|
| `content/aulas/metanalise/slides/04-pico.html` | Slide source |
| `content/aulas/metanalise/metanalise.css` (L392-464) | CSS for s-pico |
| `content/aulas/metanalise/slide-registry.js` (L234+) | Custom animation |
| `content/aulas/metanalise/slides/_manifest.js` (L25) | Manifest entry |
| `content/aulas/metanalise/evidence/s-pico.html` | Evidence (read-only reference) |
| `content/aulas/metanalise/qa-screenshots/s-pico/` | Screenshots output |

## Verification

- Build passes without errors
- Fresh screenshots captured (timestamp matches today)
- Preflight 4 dims evaluated with evidence
- Each gate waits for Lucas before proceeding
- Editorial suggestions saved to file
