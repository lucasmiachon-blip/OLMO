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
- `<aside class="notes">` obrigatório em TODO `<section>`.
- NUNCA inline style com `display`/`visibility`/`opacity` no `<section>` (E07).
- NUNCA CSS inline no HTML. Todo layout vai no `{aula}.css`, scopado por `#s-{id}`.
- Layout vai dentro de `.slide-inner`, NUNCA no `<section>`.

## 1b. CSS — Tokens + Composição Livre

**Princípio:** tokens padronizam (cor, tipo, espaço), layout é livre por slide.
Fontes: Duarte (unity), Alley (assertion-evidence), Refactoring UI (design system + composição livre).

**Obrigatório:**
- Cores, tipografia, espaçamento: via tokens do `base.css`. NUNCA valor literal.
- Cada slide tem layout próprio no `{aula}.css`, scopado por `#s-{id}`.
- CSS Grid/Flex direto — sem classes de archetype intermediárias.
- `references/archetypes.md` = referência visual para consulta, não imposição CSS.

**Proibido:**
- Classes genéricas de layout (`.slide-cards`, `.slide-headline`, `.slide-figure`) em slides novos.
- Agente escolher layout sem aprovação do Lucas.
- CSS inline no HTML (exceto `data-background-color` HEX quando necessário).

**Decisão de layout:** Lucas decide a composição visual. Agente implementa.

## 2. Checklist Pré-Edição (OBRIGATÓRIO)

- [ ] `<h2>` é asserção clínica
- [ ] Sem `<ul>`/`<ol>` no slide
- [ ] `<aside class="notes">` com timing e fontes
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
