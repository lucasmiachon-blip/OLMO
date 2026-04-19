---
description: "QA: constraints, anti-sycophancy. Loads for aula/QA contexts."
paths:
  - "content/aulas/**"
---

# QA Pipeline — `content/aulas/scripts/gemini-qa3.mjs`

NEVER batch QA — 1 slide per cycle.

## Anti-Sycophancy (E069)
- Rubric ceiling: medical GSAP = **6-8**. 9 = exceptional cinematographic.
- Penalization: uniform stagger = max 7. CountUp without pause = max 6. Temp: 1.0.

Execution steps, states, propagation table → `docs/aulas/slide-advanced-reference.md`.

## State Machine (per aula)

```
BACKLOG → DRAFT → CONTENT → SYNCED → LINT-PASS → QA → DONE
```

Gates:
- **Gate 1 (CONTENT→SYNCED):** h2 é asserção clínica + notes com timing/fontes
- **Gate 2 (SYNCED→LINT-PASS):** `npm run lint:slides` PASS
- **Gate 3 (LINT-PASS→QA):** Build PASS + sem orphans
- **Gate 4 (QA→DONE):** `gemini-qa3.mjs` 3-gate sequence com **Lucas OK entre cada**:
  - Preflight (dims objetivas, $0) → **[Lucas OK]**
  - Inspect (Gemini Flash) → **[Lucas OK]**
  - Editorial (Gemini Pro) → Lucas approved

Per-slide tracking: `HANDOFF.md` (por aula).
Threshold: score < 7 → checkpoint Lucas antes de continuar.
