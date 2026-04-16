---
description: "Slide editing: structure, CSS, motion, errors, template. Loads for aula contexts."
paths:
  - "content/aulas/**"
---

# Slide Rules

## Structure
- `<h2>` = clinical assertion (NEVER generic label). `<ul>`/`<ol>` PROIBIDOS.
- **h2 = Lucas's work.** NEVER rewrite h2 automatically. Flag generic h2 as needing Lucas's input.
- NEVER inline style with `display`/`visibility`/`opacity` on `<section>` (E07).
- CSS inline: only `opacity:0` for GSAP init. All layout in `{aula}.css` scoped by `section#s-{id}`.
- Layout inside `.slide-inner`, NEVER on `<section>`.

## CSS — Tokens + Free Composition
Tokens standardize (color, type, space); layout is free per slide.
- Colors, typography, spacing: via `base.css` tokens. NEVER literal values.
- Each slide: own layout in `{aula}.css`, scoped by `section#s-{id}` (specificity 0,1,1,1).
- CSS Grid/Flex direct — no archetype classes. Agent NEVER chooses layout without Lucas's approval.

## New Slide Template

```html
<section id="s-[id]">
  <div class="slide-inner">
    <p class="section-tag">[BLOCO]</p>
    <h2>[CLINICAL ASSERTION — verifiable complete claim]</h2>
    <div class="evidence" data-animate="fadeUp">
      <!-- visual evidence: chart, table, key number, diagram -->
    </div>
    <cite class="source-tag">Author et al. Journal Year;Vol:Pages. PMID: XXXXX</cite>
  </div>
</section>
```

## Pre-Edit Checklist
- [ ] `<h2>` is clinical assertion
- [ ] No `<ul>`/`<ol>`
- [ ] `<section>` no `style` with `display` (E07)
- [ ] Numerical data verified
- [ ] `.source-tag`: Author Year format
- [ ] Animations via `data-animate` only
- [ ] CSS: `section#s-{id}` (not `#s-{id}`)

## data-animate

| Value | Effect | Extras |
|-------|--------|--------|
| `countUp` | Animated number (1.5s) | `data-target` `data-decimals` |
| `stagger` | Sequential children | `data-stagger="0.15"` |
| `drawPath` | SVG stroke progressive | — |
| `fadeUp` | Fade + translateY | — |
| `highlight` | Von Restorff row | `data-highlight-row` |

Click-reveal: `data-reveal="N"`, max 4. Handlers: `stopPropagation()` (E38).

## CSS Errors
- E07: NEVER `display` inline on `<section>`
- E20: "Just adjust X" = scope ONLY X
- E21: Tier 1 font mandatory for numerical data
- E26: NEVER `flex:1` equal on unequal containers
- E32: NEVER `::before/::after { flex: 1 }` in shared base containers
- E38: Click handlers: `stopPropagation()`
- E52: NEVER `vw`/`vh` in font-size (deck.js scale)

## Motion QA

| Property | Range |
|----------|-------|
| Fade/translate | 300–600ms |
| countUp | 800–1200ms |
| stagger total | ≤ 1.5s |
| Max duration | ≤ 2s |

Easing: `power2.out` or `power3.out`. PROIBIDO: bounce, elastic, linear.

## Scaling
`scaleDeck()`: `Math.min(vw/1280, vh/720)` + `translate(-50%,-50%) scale(s)` in `#deck`.
PROIBIDO: `zoom` CSS (double-scaling with deck.js).

Advanced (GSAP, stage-c, specificity, bootstrap) → `docs/aulas/slide-advanced-reference.md`.
