---
description: "QA: execution path, propagation, anti-sycophancy. Loads for aula/QA contexts."
paths:
  - "content/aulas/**"
---

# QA Pipeline

> Implementation: `content/aulas/scripts/gemini-qa3.mjs`

## Execution Path (linear, no shortcuts)

NEVER batch QA — 1 slide per cycle.

```
STEP 1   npm run build:{aula}
STEP 2   node scripts/qa-capture.mjs --aula {aula} --slide {id}
STEP 3   Read criteria: design-reference.md, slide-rules.md
STEP 4   Read screenshot + slide code
STEP 5   Evaluate 4 dims (Color, Typography, Hierarchy, Design) → PASS/FAIL → STOP
STEP 6   Lucas reviews → requests changes → re-evaluate
STEP 7   Lucas says "proceed"
STEP 8   gemini-qa3.mjs --inspect → report → STOP
STEP 9   Lucas OK
STEP 10  gemini-qa3.mjs --editorial → report → STOP
STEP 11  Save to qa-screenshots/{id}/editorial-suggestions.md
```

States: BACKLOG → DRAFT → CONTENT → SYNCED → LINT-PASS → QA → DONE.

## Anti-Sycophancy (E069)
- Rubric ceiling: medical GSAP presentation = **6-8** if well made. 9 = exceptional cinematographic narrative.
- Penalization: uniform stagger = max 7. CountUp without pause = max 6.
- Timestamp inventory proves model SAW, not that it EVALUATED quality.
- Temperature: 1.0 (Gemini 3 default).

## Propagation Table

| Changed... | Also update... |
|-----------|---------------|
| h2 in HTML | `_manifest.js` headline |
| `<section id>` | ALL surfaces (manifest, registry, CSS, evidence, HANDOFF) |
| Slide CSS | Check QA score impact |
| Numerical data | evidence HTML, notes `[DATA]` tag |
| Position in deck | `_manifest.js` order |
| Click-reveals | `_manifest.js` clickReveals, `slide-registry.js` |
| customAnim | `_manifest.js` customAnim, `slide-registry.js` |

Transition checklists → `docs/aulas/slide-advanced-reference.md`.
