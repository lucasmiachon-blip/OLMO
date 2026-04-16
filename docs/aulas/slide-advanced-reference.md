# Slide Advanced Reference

> Consultar on demand. NÃO auto-loaded. Migrado de rules S208-S209.
> Para constraints ativos, ver: `slide-rules.md`, `design-reference.md`, `qa-pipeline.md`.

---

## GSAP Armadilhas

- **Failsafe:** `[data-animate] { opacity: 0; }` + `.no-js [data-animate] { opacity: 1; }`. Sem failsafe, GSAP offline = slide em branco.
- **Flip:** `Flip.getState()` DEVE ser chamado ANTES da transição. Sem estado anterior → fallback `gsap.from`.
- **Overflow fantasma:** Elementos `opacity:0` (GSAP init) ocupam layout → `scrollHeight` inflado. Verificar se overflow desaparece quando GSAP revela ANTES de "corrigir" com CSS.

## GSAP Jurisdição e FOUC

> Fonte: Cirrose E054, E046, E060, E065, E066

**CSS vs GSAP:**
- GSAP controla: `opacity`, `transform` (layout props). CSS controla: `background`, `border`, `filter` (paint props). NUNCA competir — GSAP inline styles vencem qualquer specificity.
- GSAP opacity em texto projetado NUNCA < 0.85. Contraste efetivo = cor × opacity × bg (E060).
- NUNCA GSAP em elemento gerenciado por outro sistema (e.g., case-panel.js). Race condition garantida (E046).

**FOUC cross-slide (E065):**
- Containers animados: `opacity: 0` no CSS base. GSAP revela com `set(container, { opacity: 1 })`.
- `animate()` roda em `slide:changed` (imediato). Delays 0.3-0.4s alinham com transição CSS 400ms. NUNCA `slide:entered` (tarde = flash).
- Cleanup do slide anterior: delay 450ms com proteção contra re-entrada.

**FOUC intra-slide — eras stacked (E066):**
- Todo filho animado de era stacked: `opacity: 0` no CSS.
- `gsap.set({opacity:0})` no init para eras futuras (S1, S2).
- Re-hide filhos ANTES de `showEra()`, não depois no callback.

**Reset defensivo (E062):**
- Custom animations com advance/retreat: reset defensivo no início da factory. `ctx.revert()` insuficiente para inline styles e SplitText char divs.

## stage-c — Slides com Fundo Escuro

> Fonte: Cirrose E071, Metanalise E001, E009

- stage-c remapeia TODOS os tokens `--*-on-dark` para valores light. Slide navy fica light-on-light sem override.
- Background navy: via CSS `.theme-dark .slide-inner { background-color: #HEX; }`. NUNCA `data-background-color` (atributo morto em deck.js).
- **Token restoration:** `class="theme-dark"` no `<section>` HTML. base.css `.theme-dark .slide-inner` restaura 11 tokens automaticamente. NUNCA listar IDs por slide.
- Aula-specific: cor de fundo e overrides em `.theme-dark .slide-inner` no CSS da aula (cascade order garante override).
- `.slide-navy` (legacy): apenas text color remap. Não restaura tokens stage-c. Preferir `.theme-dark`.

## Specificity & Cascading

> Fonte: Cirrose E036, E057, E070, Metanalise E005, E007

- `#deck p` herda `max-width: 56ch` de base.css. Full-width: `max-width: none; width: 100%` com `#deck p.className` (0,1,1,1).
- NUNCA sobrescrever `display` do `.slide-inner`. Adicionar propriedades ao flex existente (E070).
- `::before/::after { flex: 1 }` de base.css competem com children `flex: 1`. Override: `::before, ::after { display: none }` no escopo (E005).
- Import order CSS: base → aula. Validado por `validate-css.sh` Check 1 (E057).

## Bootstrap — Nova Aula deck.js

> Fonte: Metanalise E001, E002, E004, E008, E010

- [ ] `<body class="stage-c">` (ou `stage-a`). Sem stage class = renderização quebrada (E001).
- [ ] `body { margin: 0; overflow: hidden; }` no CSS da aula (E002).
- [ ] Zero `zoom` CSS — double-scaling com deck.js (E008).
- [ ] `vite.config.js`: aula incluída em `discoverEntries()`, frozen excluídas (E010).
- [ ] Testar `npx vite --force` após setup inicial.

## Color-mix Armadilhas

> Fonte: Cirrose E059, E072

- **color-mix() com endpoint acromático** (hue=0) interpola hue pelo caminho mais curto → salmon/coral inesperado. NUNCA confiar em `var(--safe-light)` para backgrounds neutros (E059).
- **CSS Color 5** (`oklch(from var(--token) l c h / alpha)`) = relative color syntax, suporte limitado. Usar **color-mix() (Color 4)** para derivações (E072).

## NNT Format

```
NNT [valor] (IC 95%: [lower]–[upper]) em [tempo] | [população]
```
Hierarquia: **NNT > ARR > HR**. NNT=decisão (hero, --safe). HR=acadêmico (menor destaque).

## Verification Vocabulary

| Status | Significado | Quando usar |
|--------|------------|-------------|
| `VERIFIED` | PubMed MCP confirmou (author + title + patient count) | Fonte ideal |
| `WEB-VERIFIED` | PubMed web ou WebSearch confirmou (MCP indisponível) | Fallback aceitável |
| `CANDIDATE` | Não verificado — aguardando verificação | NUNCA em report final |
| `SECONDARY` | Confirmado por 2+ fontes independentes | Cross-referência |
| `UNRESOLVED` | Fontes discordam — decisão do Lucas | Revisão humana |

## Fontes Tier 1 — Hepatologia

| Fonte | Tipo | ID |
|-------|------|----|
| BAVENO VII | Consenso HP | DOI:10.1016/j.jhep.2021.12.012 |
| EASL Cirrose 2024 | CPG | DOI: TBD |
| AASLD Varizes 2024 | Practice Guidance | DOI: TBD |
| PREDESCI | RCT | PMID:30910320 |
| CONFIRM | RCT | PMID:33657294 |
| ANSWER | RCT | PMID:29861076 |
| D'Amico 2006 | Systematic review | PMID:16298014 |

## Content Rules

**OK:** Reduzir texto mantendo significado, reorganizar hierarquia, adicionar de fontes verificadas, remover drogas não disponíveis no Brasil.
**PROIBIDO:** Inventar dados/referências, modificar números sem fonte, extrapolar entre estudos.

**Diagnostic Tool Framing:** "Recebi este resultado. Quais condições no MEU paciente tornam este número não confiável?" Anti-padrão: "Este é um escore que mede..."

## QA Transition Checklists

### BACKLOG → DRAFT
- [ ] HTML criado em `slides/NN-slug.html`
- [ ] `<section id="s-{act}-{slug}">` correto
- [ ] `<div class="slide-inner">` wrapper
- [ ] `<h2>` com asserção (mesmo provisória)
- [ ] Entrada em `_manifest.js` na posição correta

### DRAFT → CONTENT
- [ ] h2 = asserção clínica verificável
- [ ] Zero `<ul>`/`<ol>` no corpo
- [ ] Todos dados numéricos verificados (PMID ou [TBD])

### CONTENT → SYNCED (9 surfaces)
- [ ] `_manifest.js` headline = `<h2>` do HTML
- [ ] `_manifest.js` clickReveals = número real de `[data-reveal]`
- [ ] `_manifest.js` customAnim = null ou ID correto
- [ ] `slide-registry.js` tem wiring se customAnim != null
- [ ] `{aula}.css` tem seletores se necessário
- [ ] Evidence HTML tem referências
- [ ] HANDOFF registra estado SYNCED

### SYNCED → LINT-PASS
- [ ] `npm run build` PASS
- [ ] `npm run lint:slides` PASS

### QA → DONE
- [ ] Todos sub-stages QA PASS
- [ ] HANDOFF estado = DONE
- [ ] CHANGELOG entry

---

## New Slide Template

> Migrado de slide-rules.md S209.

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

## data-animate Values

| Value | Effect | Extras |
|-------|--------|--------|
| `countUp` | Animated number (1.5s) | `data-target` `data-decimals` |
| `stagger` | Sequential children | `data-stagger="0.15"` |
| `drawPath` | SVG stroke progressive | — |
| `fadeUp` | Fade + translateY | — |
| `highlight` | Von Restorff row | `data-highlight-row` |

Click-reveal: `data-reveal="N"`, max 4. Handlers: `stopPropagation()` (E38).

## Motion QA Ranges

| Property | Range |
|----------|-------|
| Fade/translate | 300–600ms |
| countUp | 800–1200ms |
| stagger total | ≤ 1.5s |
| Max duration | ≤ 2s |

## Color Semantics

| Token | Clinical meaning | Use |
|-------|-----------------|-----|
| `--safe` | Maintain course | Favorable result, target met |
| `--warning` | Investigate/monitor | Gray zone, needs follow-up |
| `--danger` | Intervene now | Real risk: death, bleeding, failure |
| `--downgrade` | Downgrade evidence | Limitation, caveat (always with ↓) |
| `--ui-accent` | Chrome/UI | Progress, tags, decoration — NEVER clinical |

### Color Hierarchy
- **Punchline > Support:** culminating element gets superior visual treatment.
- Semantic color in text: only when text IS the primary element (title, punchline).
- Icons MUST have explicit color matching severity.

## Typography Reference

| Rule | Detail |
|------|--------|
| Serif = authority | `--font-display` (Instrument Serif) for titles |
| `tabular-nums lining-nums` | On numerical data |

## QA Execution Path

```
STEP 1   npm run build:{aula}
STEP 2   node scripts/qa-capture.mjs --aula {aula} --slide {id}
STEP 3   Read criteria: design-reference.md, slide-rules.md
STEP 4   Read screenshot + slide code
STEP 5   Evaluate 4 dims (Color, Typography, Hierarchy, Design) → PASS/FAIL → STOP
STEP 6   Lucas reviews → requests changes → re-evaluate
STEP 7   Lucas says "proceed"
STEP 8   gemini-qa3.mjs --inspect → report → STOP
STEP 9   Lucas OK
STEP 10  gemini-qa3.mjs --editorial → report → STOP
STEP 11  Save to qa-screenshots/{id}/editorial-suggestions.md
```

States: BACKLOG → DRAFT → CONTENT → SYNCED → LINT-PASS → QA → DONE.

## Propagation Table

| Changed... | Also update... |
|-----------|---------------|
| h2 in HTML | `_manifest.js` headline |
| `<section id>` | ALL surfaces (manifest, registry, CSS, evidence, HANDOFF) |
| Slide CSS | Check QA score impact |
| Numerical data | evidence HTML, notes `[DATA]` tag |
| Position in deck | `_manifest.js` order |
| Click-reveals | `_manifest.js` clickReveals, `slide-registry.js` |
| customAnim | `_manifest.js` customAnim, `slide-registry.js` |
