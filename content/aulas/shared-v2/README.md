# shared-v2 — Design System (S237 C4 Day 1)

Biblioteca de tokens, tipografia fluida e primitives de layout para aulas médicas OLMO. Consumida por cada aula via `@import "../shared-v2/css/index.css"`.

## Arquitetura de tokens (3 camadas)

1. **`tokens/reference.css`** — primitivos OKLCH (palette, type scale, space, motion, radius, shadow). Sem semântica. Calibrado por Lucas com filosofia Stripe Sail + calibrações Radix-inspired (warning L=82% com on-solid dark explícito, info hue 210° para separação de accent blue-violet 265°). Danger hue 22° (editorial red range Lancet/NEJM/JAMA/NYT).
2. **`tokens/system.css`** — semântica role-based (`--surface-*`, `--text-*`, `--success-*`, `--warning-*`, `--danger-*`, `--info-*`, `--intermediate-*`, `--font-*`, `--motion-*`). Zero literais; consome apenas reference.
3. **`tokens/components.css`** — slide-specific e GRADE (`--slide-h1-*`, `--claim-*`, `--evidence-*`, `--chip-*`, `--grade-certainty-*`, `--grade-rec-*`, `--slide-caption-*`). Consome apenas system.

**Regra dura:** zero skip-chain entre camadas. Components nunca lê de reference direto.

## Browser baseline

Evergreen 2024+ (Chromium/WebKit/Gecko). **Chrome 121+** target efetivo para stack completo (View Transitions API + `@starting-style` entregues em C5). Ausência de feature = degradação graceful via `@supports` gate. Browser incompatível = fallback PDF (L3 build) ou PPTX (L4 export) via `done-gate.js` (handoff §D6). Validação prática em ensaio HDMI residencial (C5 Day 2) — laptop HC-FMUSP institucional é unknown version.

## Acessibilidade

- **`prefers-reduced-motion: reduce` obrigatório e não-negociável.** Neutralização em `tokens/system.css` `@media` block: durations colapsam para `--dur-instant`. C5 JS consulta `window.matchMedia` antes de qualquer `element.animate()`.
- **APCA Lc ≥ 75** em body sobre surface-canvas; **Lc ≥ 60** em on-solid (ex: `--warning-on-solid` explícito em system.css após fix S237 C4).
- Fundamento: 60 residentes no auditório ⇒ estatisticamente presentes pessoas com vestibular disorders / ansiedade / epilepsia fotossensível. Omitir reduction em código novo 2026 = WCAG 2.2 AA violation + falha grosseira editorial.

## Como consumir

```html
<link rel="stylesheet" href="/shared-v2/css/index.css">
<section data-slide="s-hero">
  <div class="stack">
    <p class="slide-eyebrow">F2 · Metodologia</p>
    <h1 class="slide-headline">Headline assertiva aqui</h1>
    <p class="slide-body">Body prose seguinte.</p>
    <p class="slide-caption">Citação · PMID NNNNNNNN</p>
  </div>
</section>
```

**Classes tipográficas:** `.slide-headline` / `.slide-claim` / `.slide-body` / `.slide-caption` / `.slide-eyebrow`.
**Layout primitives:** `.stack` / `.cols` / `.cluster` / `.grid-auto-fit`.
**Utilities:** `.evidence` / `.chip` + `.chip-{high,mod,low,vlow}`.

## Dev server

```bash
npm run dev:shared-v2   # port 4103, abre _mocks/hero.html
```

## O que NÃO fazer

- **Skip-chain:** components.css lendo `var(--oklch-*)` ou reference.css direto. Sempre via system.css.
- **Literais hardcoded** em vez de tokens (exceção: fluid type `calc()` onde literais são derivados explícitos documentados em comment-header de `type/scale.css`).
- **Media queries** em primitives ou slides. Use container queries (já habilitadas em `section[data-slide]` via `container-type: inline-size`).
- **Motion sem guard `prefers-reduced-motion`** (C5 enforcement em JS).
- **Reset CSS completo** (Normalize, Reset). Minimalismo intencional: Vite + browsers modernos cobrem essencial.

## Escopo C4 vs C5+

**C4 Day 1 (este):** tokens (pre-calibrados por Lucas) + `type/scale.css` fluid + `layout/slide.css` aspect-ratio 16:9 + `layout/primitives.css` every-layout + `css/index.css` entry + 2 mocks (hero + evidence).

**C5 Day 2 (próximo):** motion CSS (`motion/tokens.css` + `motion/transitions.css` com View Transitions + `@starting-style`) + JS layer (`js/deck.js` + `js/presenter-safe.js` + `js/motion.js` + `js/reveal.js`) + ensaio HDMI residencial. Motion adiado pois requer JS coupling para validação real via `element.animate()`.

**C6:** `_mocks/dialog.html` quando houver conteúdo grade-v2 real para testar arquétipo de comparação.
