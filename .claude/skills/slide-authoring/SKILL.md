---
name: slide-authoring
version: 2.0.0
context: fork
description: "Create and edit medical education slides using the OLMO deck.js design system (OKLCH tokens, GSAP declarative animations, 1280x720 viewport). Use for creating, editing, redesigning slides, adding content to lectures, or working on cirrose/metanalise/grade/osteoporose presentations. MANDATORY TRIGGERS: criar slide, novo slide, new slide, adicionar slide, redesign slide, slide layout, tipografia, animacao, GSAP, deck.js, assertion-evidence, aula, apresentacao, slide sobre"
argument-hint: "[lecture] [assertion]"
allowed-tools: Read, Write, Bash(npm run lint:slides)
---

# Slide Authoring — OLMO Medical Education

Every slide makes ONE clinical claim, supported by visual evidence. Assertion-Evidence methodology (Alley 2013).

## Design Thinking

Before writing HTML, answer three questions:

1. **What is the clinical assertion?** Complete sentence. "Carvedilol reduces HVPG by 20% vs placebo" — not "Carvedilol". This becomes the `<h2>`.
2. **What evidence supports it?** A figure, data table, comparison cards, forest plot. Never a bullet list — `<ul>/<ol>` prohibited.
3. **How should the audience discover it?** All at once, or progressively via `data-reveal`? Animated number via `data-animate="countUp"`?

## Before Creating (Antes de criar)

1. Verificar `_manifest.js` da aula para posicao correta
2. Confirmar que assertion tem dado clinico verificavel (com fonte)
3. Usar CSS da aula (`{aula}.css` — tokens + componentes + slide-specific)

## Workflow

1. **Identify** the clinical assertion
2. **Choose** evidence format (read `references/patterns.md` for examples)
3. **Propose** layout to Lucas — he decides composition
4. **Implement** HTML in `slides/NN-slug.html` + CSS scoped by `#s-{id}` in `{lecture}.css`
5. **Add** speaker notes with `[timing]`, `[DATA] source`, `[VERIFIED] date`
6. **Check** against slide-rules.md (auto-loaded in `content/aulas/**`)

Max 5 slides per batch. Pause for review before continuing.

## After Creating — 9 Surfaces

1. `npm run lint:slides` — corrigir erros
2. Verificar todas as superficies de identidade:
   - [ ] `_manifest.js` — entrada com `id` correto na posicao certa
   - [ ] `slides/NN-slug.html` — `<section id="s-...">` correspondente
   - [ ] `slide-registry.js` — se tem customAnimation, registrar
   - [ ] `{aula}.css` — seletores `#s-...` se necessario
   - [ ] `narrative.md` — linha na tabela do ato
   - [ ] `evidence-db.md` — referencias se aplicavel
   - [ ] `AUDIT-VISUAL.md` — scorecard header
   - [ ] `HANDOFF.md` — mencao/contagem atualizada
   - [ ] `npm run build:{aula}` — rebuild index.html (NUNCA editar manualmente)

## References

Read as needed — don't load everything upfront:

| File | When |
|------|------|
| `shared/css/base.css` | Token values, stages, color system |
| `.claude/rules/slide-rules.md` | Structure rules, CSS errors, animation specs (auto-loads) |
| `references/patterns.md` | Layout patterns, HTML examples, new-slide template |
| `{lecture}/references/narrative.md` | Lecture flow and story arc |
| `{lecture}/references/evidence-db.md` | Clinical data sources and PMIDs |

## Anti-patterns

- **Topic headlines**: "Carvedilol" instead of "Carvedilol reduces HVPG by 20%"
- **Bullet slides**: `<ul>/<ol>` in slides — use visual evidence instead
- **Literal colors**: `color: #cc4a3a` instead of `var(--danger)`
- **Inline styles**: `style="display:flex"` on `<section>` — use scoped CSS (exception: `opacity:0` for GSAP init)
- **Unsourced data**: Clinical numbers without PMID in speaker notes
- **Animation overload**: More than 4 reveals, bounce/elastic easing, stagger > 1.5s
- **Generic layouts**: Copy-pasting the same grid everywhere

## QA Scripts

```bash
npm run lint:slides             # Structure validation
npm run qa:screenshots:{aula}   # Playwright batch screenshots
npm run done-gate               # Pre-commit quality gate
```
