---
name: slide-authoring
description: "Create and edit medical education slides using the OLMO deck.js design system (OKLCH tokens, GSAP declarative animations, 1280×720 viewport). Use this skill whenever the user wants to create a new slide, add content to a lecture, redesign an existing slide, work on cirrose/metanalise/grade/osteoporose presentations, or mentions slide layout, typography, animation, or clinical assertions — even if they don't say 'slide' explicitly."
---

# Slide Authoring — OLMO Medical Education

Every slide makes ONE clinical claim, supported by visual evidence. This is Assertion-Evidence methodology (Alley 2013) — audiences process an assertion + visual faster than a title + bullet list.

## Design Thinking

Before writing HTML, answer three questions:

1. **What is the clinical assertion?** Write it as a complete sentence. "Carvedilol reduces HVPG by 20% vs placebo" — not "Carvedilol". This becomes the `<h2>`.
2. **What evidence supports it?** A figure, a data table, comparison cards, a forest plot. Never a bullet list — `<ul>/<ol>` are prohibited in slides.
3. **How should the audience discover it?** All at once, or progressively via `data-reveal`? An animated number via `data-animate="countUp"`? Choose the disclosure that matches the teaching moment.

Bold clinical clarity and refined minimalism both work. The key is intentionality — every element serves comprehension. Decoration without purpose is noise in a lecture hall.

## Stack

deck.js (custom engine, NOT Reveal.js) with GSAP 3 declarative animations, OKLCH design tokens in `shared/css/base.css`, 1280×720 viewport with JS scaling. Self-hosted fonts: Instrument Serif (display), DM Sans (body), JetBrains Mono (data). Dev servers via Vite (ports 4100-4102).

## Workflow

1. **Identify** the clinical assertion
2. **Choose** evidence format (read `references/patterns.md` for examples)
3. **Propose** layout to Lucas — he decides composition (Decision Protocol in `shared/decision-protocol.md`)
4. **Implement** HTML in the lecture file + CSS scoped by `#s-{id}` in `{lecture}.css`
5. **Add** speaker notes with `[timing]`, `[DATA] source`, `[VERIFIED] date`
6. **Check** against slide-rules.md (auto-loaded in `content/aulas/**`)

Max 5 slides per batch. Pause for review before continuing.

## References

Read these as needed — don't load everything upfront:

| File | When |
|------|------|
| `shared/css/base.css` | Token values, stages, components, color system |
| `.claude/rules/slide-rules.md` | Structure rules, CSS errors, animation specs (auto-loads) |
| `shared/decision-protocol.md` | Before proposing content changes |
| `references/patterns.md` | Layout patterns and HTML examples |
| `{lecture}/references/narrative.md` | Lecture flow and story arc |
| `{lecture}/references/evidence-db.md` | Clinical data sources and PMIDs |
| `content/aulas/STRATEGY.md` | Technical roadmap |

## Anti-patterns

- **Topic headlines**: "Carvedilol" instead of "Carvedilol reduces HVPG by 20%"
- **Bullet slides**: `<ul>/<ol>` in slides — use visual evidence instead
- **Literal colors**: `color: #cc4a3a` instead of `var(--danger)`
- **Inline styles**: `style="display:flex"` on `<section>` — use scoped CSS
- **Unsourced data**: Clinical numbers without PMID in speaker notes
- **Animation overload**: More than 4 reveals, bounce/elastic easing, stagger > 1.5s
- **Generic layouts**: Copy-pasting the same grid everywhere instead of designing for the content

## QA Scripts

```bash
npm run qa:screenshots:grade    # Playwright + font-size audit
npm run lint:slides             # Structure validation
npm run done-gate               # Pre-commit quality gate
```
