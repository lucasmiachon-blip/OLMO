---
description: "Regras de edicao de slides: estrutura, CSS, motion, erros. So carrega em contextos de aula."
paths:
  - "content/aulas/**"
---

# Slide Rules — Edição, Identidade, CSS, Motion

> Canônico. Merge de: deck-patterns, slide-editing, slide-identity, css-errors, motion-qa.
> Paths adaptados para monorepo: content/aulas/{aula}/

---

## 1. Estrutura de Slide

```html
<section id="s-a1-damico">
  <div class="slide-inner">
    <h2>Carvedilol reduz HVPG em 20% vs placebo</h2>
    <div class="evidence" data-animate="stagger">...</div>
  </div>
  <aside class="notes">
    [0:00-0:30] Hook. PAUSA 3s.
    [DATA] Fonte: EASL 2024 | Verificado: 2026-02-13
  </aside>
</section>
```

**Regras estruturais:**
- `<h2>` = asserção clínica (NUNCA rótulo genérico). `<ul>`/`<ol>` PROIBIDOS em slides.
- **h2 = trabalho do Lucas.** NUNCA reescrever h2 automaticamente. Flaggear h2 genéricos como "precisa rewrite do Lucas" mas não propor texto. Se Lucas pedir ajuda: oferecer opções como sugestão, nunca como decisão.
- `<aside class="notes">` opcional (Lucas não usa presenter mode). Manter se já existir, não exigir em slides novos.
- NUNCA inline style com `display`/`visibility`/`opacity` no `<section>` (E07).
- NUNCA CSS inline no HTML — exceto `opacity:0` para GSAP init state (pragmático). Inline complexo (layout, cor, fontes) permanece proibido. Todo layout vai no `{aula}.css`, scopado por `#s-{id}`.
- Layout vai dentro de `.slide-inner`, NUNCA no `<section>`.

## 1b. CSS — Tokens + Composição Livre

**Princípio:** tokens padronizam (cor, tipo, espaço), layout é livre por slide.
Fontes: Duarte (unity), Alley (assertion-evidence), Refactoring UI (design system + composição livre).

**Obrigatório:**
- Cores, tipografia, espaçamento: via tokens do `base.css`. NUNCA valor literal.
- Cada slide tem layout próprio no `{aula}.css`, scopado por `#s-{id}`.
- CSS Grid/Flex direto — sem classes de archetype intermediárias.
- `content/aulas/{aula}/references/archetypes.md` = referência visual para consulta, não imposição CSS.

**Proibido:**
- Classes genéricas de layout (`.slide-cards`, `.slide-headline`, `.slide-figure`) em slides novos.
- Agente escolher layout sem aprovação do Lucas.
- CSS inline no HTML. Background via CSS `#s-{id} .slide-inner { background-color }` (§10).

**Decisão de layout:** Lucas decide a composição visual. Agente implementa.

## 2. Checklist Pré-Edição (OBRIGATÓRIO)

- [ ] `<h2>` é asserção clínica
- [ ] Sem `<ul>`/`<ol>` no slide
- [ ] `<aside class="notes">` se existir: timing e fontes (opcional em slides novos)
- [ ] `<section>` sem `style` com `display` (E07)
- [ ] Dados numéricos verificados
- [ ] Animações via `data-animate`, NUNCA gsap inline

**Batch:** Max 5 slides por batch.

## 3. Animação Declarativa (data-animate)

| `data-animate` | Efeito | Extras |
|----------------|--------|--------|
| `countUp` | Número animado (1.5s) | `data-target="25"` `data-decimals="1"` |
| `stagger` | Filhos sequenciais | `data-stagger="0.15"` |
| `drawPath` | SVG stroke progressivo | — |
| `fadeUp` | Fade + translateY | — |
| `highlight` | Von Restorff — destaca linha | `data-highlight-row="3"` |

## 4. Click-Reveal

```html
<div data-reveal="1">Primeiro</div>
<div data-reveal="2">Segundo</div>
```
Max 4 reveals por slide. Click handlers: `stopPropagation()` (E38).

## 5. CSS Errors (principais)

- E07: NUNCA `display` inline no `<section>`
- E20: "Só ajusta X" = escopo APENAS X
- E21: Fonte Tier 1 obrigatória para dado numérico
- E26: NUNCA flex:1 igualitário em containers desiguais
- E32: NUNCA `::before/::after { flex: 1 }` em containers base compartilhados (competem com children)
- E38: Click handlers: `stopPropagation()`
- E52: NUNCA `vw`/`vh` em font-size (deck.js scale)

## 6. Motion QA

| Propriedade | Range |
|-------------|-------|
| Fade/translate | 300–600ms |
| countUp | 800–1200ms |
| stagger total | ≤ 1.5s |
| Max duration | ≤ 2s |

Easing: `power2.out` ou `power3.out`. PROIBIDO: bounce, elastic, linear em UI.

## 7. GSAP — Armadilhas

- **Failsafe obrigatório:** `[data-animate] { opacity: 0; }` + `.no-js [data-animate] { opacity: 1; }`. Sem isso, GSAP offline = slide em branco.
- **Flip:** `Flip.getState()` DEVE ser chamado ANTES da transição (antes de opacity→0). Se estado anterior não existe, fallback com `gsap.from`.
- **Overflow fantasma:** Elementos com `opacity:0` (estado inicial GSAP) ocupam espaço de layout → `scrollHeight` inflado. Verificar se overflow desaparece quando GSAP revela os elementos ANTES de "corrigir" com CSS.

## 8. Scaling — Arquitetura

- `scaleDeck()`: `Math.min(vw/1280, vh/720)` + `translate(-50%,-50%) scale(s)` em `#deck`.
- Scaling é responsabilidade do `shared/js/deck.js`. CSS local NUNCA redefine zoom/transform no body ou `#deck`.
- PROIBIDO: `zoom` CSS (não dispara resize event, causa double-scaling com deck.js transform).

## 9. GSAP — Jurisdição e FOUC

> Fonte: Cirrose E054, E046, E060, E065, E066

**Jurisdição CSS vs GSAP:**
- GSAP controla: `opacity`, `transform` (layout props). CSS controla: `background`, `border`, `filter` (paint props). NUNCA competir — GSAP inline styles vencem qualquer specificity CSS.
- GSAP opacity em texto projetado NUNCA < 0.85. Contraste efetivo = cor × opacity × bg (E060).
- NUNCA GSAP em elemento gerenciado por outro sistema (e.g., case-panel.js). Race condition garantida (E046).

**FOUC cross-slide (E065):**
- Containers animados DEVEM ter `opacity: 0` no CSS base. GSAP revela com `set(container, { opacity: 1 })`.
- `animate()` roda em `slide:changed` (imediato). Delays GSAP (0.3-0.4s) alinham com transição CSS 400ms. NUNCA `slide:entered` (400ms tarde = flash).
- Cleanup do slide anterior: delay 450ms com proteção contra re-entrada.

**FOUC intra-slide — eras stacked (E066):**
- TODO filho animado de era stacked DEVE ter `opacity: 0` no CSS.
- `gsap.set({opacity:0})` no init para eras futuras (S1, S2).
- Re-hide filhos ANTES de `showEra()`, não depois no callback.

**Reset defensivo (E062):**
- Custom animations com advance/retreat DEVEM ter reset defensivo no início da factory. `ctx.revert()` insuficiente para inline styles e SplitText char divs.

## 10. stage-c — Slides com Fundo Escuro

> Fonte: Cirrose E071, Metanalise E001, E009

- stage-c remapeia TODOS os tokens `--*-on-dark` para valores light. Slide navy fica light-on-light sem override.
- Background navy: via CSS `.theme-dark .slide-inner { background-color: #HEX; }` no CSS da aula. NUNCA `data-background-color` (atributo morto em deck.js).
- **Token restoration:** `class="theme-dark"` no `<section>` HTML. base.css `.theme-dark .slide-inner` restaura 11 tokens on-dark automaticamente. NUNCA listar IDs por slide — usar a class.
- Aula-specific: cor de fundo e overrides de token vão em `.theme-dark .slide-inner` no CSS da aula (carrega depois de base.css, cascade order garante override).
- `.slide-navy` (legacy): apenas text color remap. Não restaura tokens stage-c. Preferir `.theme-dark`.

## 11. Specificity & Cascading

> Fonte: Cirrose E036, E057, E070, Metanalise E005, E007

- `#deck p` herda `max-width: 56ch` de base.css. Para `<p>` full-width (source-tag, footer): `max-width: none; width: 100%` com seletor `#deck p.className` (0,1,1,1).
- NUNCA sobrescrever `display` do `.slide-inner`. Adicionar propriedades ao flex existente (como `.slide-title` faz) (E070).
- `::before/::after { flex: 1 }` de base.css competem com children `flex: 1`. Se layout quebra: override `::before, ::after { display: none }` no escopo da aula (E005).
- Import order CSS: base → aula. Validado por `validate-css.sh` Check 1 (E057).

## 12. Bootstrap — Nova Aula deck.js

> Fonte: Metanalise E001, E002, E004, E008, E010

Checklist obrigatória ao criar nova aula deck.js:

- [ ] `<body class="stage-c">` (ou `stage-a`). Sem stage class = renderização quebrada (E001).
- [ ] `body { margin: 0; overflow: hidden; }` no CSS da aula (E002).
- [ ] `aside.notes { display: none; }` no CSS da aula (E002).
- [ ] Zero `reveal.js` em `package.json` — Vite cache poisoning (E010).
- [ ] Zero `zoom` CSS — double-scaling com deck.js (E008).
- [ ] `vite.config.js`: aula incluída em `discoverEntries()`, frozen excluídas (E010).
- [ ] Testar `npx vite --force` após setup inicial.
