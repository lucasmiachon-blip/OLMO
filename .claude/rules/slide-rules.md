---
description: "Slide editing: structure, CSS, errors, motion. Loads for aula contexts."
paths:
  - "content/aulas/**"
---

# Slide Rules

## Structure
- `<h2>` = clinical assertion (NEVER generic). **h2 = Lucas's work** — NEVER auto-rewrite. `<ul>`/`<ol>` PROIBIDOS.
- NEVER inline `display`/`visibility`/`opacity` on `<section>` (E07). Only `opacity:0` for GSAP init.
- All layout in `{aula}.css` scoped `section#s-{id}`. Layout in `.slide-inner`, NEVER on `<section>`.

## CSS
- Tokens (`base.css`) for color/type/space — NEVER literal values. Scoped `section#s-{id}` (0,1,1,1).
- No archetype classes. Agent NEVER chooses layout without Lucas's approval.

## Errors
- E07: NEVER `display` inline on `<section>`
- E20: "Just adjust X" = scope ONLY X
- E21: Tier 1 font mandatory for numerical data
- E26: NEVER `flex:1` equal on unequal containers
- E32: NEVER `::before/::after { flex: 1 }` in shared base containers
- E38: Click handlers: `stopPropagation()`
- E52: NEVER `vw`/`vh` in font-size (deck.js scale)

## Motion + Scaling
- Easing: `power2.out` or `power3.out`. PROIBIDO: bounce, elastic, linear.
- `scaleDeck()`: `Math.min(vw/1280, vh/720)`. PROIBIDO: `zoom` CSS (double-scaling).

Template, checklist, data-animate, motion ranges → `docs/aulas/slide-advanced-reference.md`.
