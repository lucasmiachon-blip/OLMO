---
paths:
  - content/aulas/**
---

# Design Reference

## Color
**PROIBIDO `rgba()`/`rgb()`.** Use `oklch(L C H / alpha)`. `--danger`: hue ≤ 10°, chroma ≥ 0.20. Severity bg: 25-40% color-mix.

## Typography
- NEVER weight 300. Minimum 400 (projector legibility).
- NEVER `vw`/`vh` font-size (E52). `tabular-nums lining-nums` on numerical data.

## Medical Data
- **NUNCA inventar/estimar/memória.** Sem fonte → `[TBD]`. PMIDs: verify PubMed first, `[CANDIDATE]` until verified (56% error).
- **Propagation:** on correction, `grep -rn` all → update ALL in same batch. **HR ≠ RR (E25):** HR=trial, RR=MA.

Color semantics, hierarchy, typography → `docs/aulas/slide-advanced-reference.md`. Principles (27) → `design-principles.md`.
