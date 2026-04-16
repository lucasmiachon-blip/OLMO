---
paths:
  - content/aulas/**
---

# Design Reference

> Tokens from `base.css` :root (shared), overrides per aula in `{aula}.css` :root.
> Design principles (27) → `docs/aulas/design-principles.md`.

## Color Semantics

| Token | Clinical meaning | Use |
|-------|-----------------|-----|
| `--safe` | Maintain course | Favorable result, target met |
| `--warning` | Investigate/monitor | Gray zone, needs follow-up |
| `--danger` | Intervene now | Real risk: death, bleeding, failure |
| `--downgrade` | Downgrade evidence | Limitation, caveat (always with ↓) |
| `--ui-accent` | Chrome/UI | Progress, tags, decoration — NEVER clinical |

**PROIBIDO `rgba()`/`rgb()`.** Use `oklch(L C H / alpha)`. Convert on touch.

### Hierarchy
- **Punchline > Support:** culminating element gets superior visual treatment.
- Semantic color in text: only when text IS the primary element (title, punchline).
- Icons MUST have explicit color matching severity.

## Typography

| Rule | Detail |
|------|--------|
| Serif = authority | `--font-display` (Instrument Serif) for titles |
| NEVER weight 300 | Minimum 400 for body (projector legibility) |
| `tabular-nums lining-nums` | On numerical data |
| NEVER `vw`/`vh` font-size | deck.js scale — always forbidden (E52) |

## Medical Data

**NUNCA inventar, estimar ou usar de memória.** Sem fonte → `[TBD]`. País-alvo: Brasil.
- **PMIDs:** NEVER use LLM PMID without PubMed verification. Mark `[CANDIDATE]` until verified. Error rate: **56%**.
- **Propagation:** On correction, `grep -rn` all instances. Update ALL in same batch.
- **HR ≠ RR (E25):** HR = single trial. RR = meta-analysis. NEVER mix.

## OKLCH Constraints

| Token | Constraint | Reason |
|-------|-----------|--------|
| `--danger` root | hue ≤ 10°, chroma ≥ 0.20 | hue 25° = terracotta, not red |
| Severity bg | 25-40% color-mix | 15% invisible in projection |

Advanced (color-mix, NNT, vocabulary, Tier 1 sources) → `docs/aulas/slide-advanced-reference.md`.
