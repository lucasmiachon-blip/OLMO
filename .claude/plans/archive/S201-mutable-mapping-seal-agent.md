# Design Excellence Loop — Research Report

> State-of-the-art frontend slide/presentation design excellence, April 2026.
> Target: raw HTML/CSS/JS medical education deck (vanilla, no frameworks).

---

## 1. CSS Moderno Vanilla — O Que E Production-Ready (Abril 2026)

Todas as features abaixo sao **Baseline** em Chrome, Firefox, Safari, Edge:

| Feature | Suporte | Status | Relevancia OLMO |
|---------|---------|--------|-----------------|
| **OKLCH / color-mix()** | Chrome 120+, Safari 17.2+, FF 117+ (~95% trafego) | Ship | Ja mandatorio em design-reference.md |
| **CSS Nesting** | Chrome 120+, Safari 17.2+, FF 117+ | Ship | Reduziria verbosidade do `{aula}.css` por `#s-{id}` |
| **@layer** (Cascade Layers) | Todos engines desde 2022, >96% global | Ship | Analisado abaixo |
| **Container Queries** | Chrome 105+, Safari 16+, FF 110+ (~90% trafego) | Ship | Cards/evidence responsivos dentro do viewport fixo |
| **Subgrid** | Chrome 117+, Safari 16.4+, FF 119+ | Ship | Alinhamento de filhos em grids aninhados |
| **Scroll-driven animations** | Cross-browser baseline 2025 | Irrelevante | deck.js usa slides discretos, nao scroll |
| **View Transitions API** | Chrome 111+, Safari 18+, FF parcial | Monitorar | deck.js gerencia transicoes proprias |
| **Relative Color Syntax** (CSS Color 5) | Suporte limitado | Evitar | Usar color-mix() (Color 4) per E072 |

**Vanilla JS/CSS em 2026:** A tendencia e clara — vanilla JavaScript re-entrou no mainstream em 2025. APIs como Fetch, Web Components e ES Modules amadureceram em ferramentas production-grade. Sem bundles massivos, hydration scripts ou reconciliation, load times caem drasticamente. O OLMO ja opera neste paradigma: deck.js + GSAP + Vite, sem React/Vue/Angular. Isso e *vantagem*, nao limitacao.

---

## 2. @layer — Analise Honesta para o OLMO

### O que @layer faz
Permite declarar explicitamente a ordem do cascade, independente de specificity. Exemplo: `@layer reset, base, aula, slide;` — um seletor simples em `slide` sempre vence um seletor complexo em `base`, sem precisar de `!important` ou hacks de specificity.

### Beneficio real para o OLMO
O OLMO hoje usa `section#s-{id}` (specificity 0,1,1,1) para que CSS per-slide venca `base.css`. Funciona, mas e um contrato implicito — depende de manter specificity correta em cada seletor. Com @layer, o contrato seria explicito:

```css
@layer reset, base, aula, slide;

@layer base { /* base.css tokens — sempre lowest priority */ }
@layer aula { /* cirrose.css, metanalise.css */ }
@layer slide { /* overrides per-slide — sempre vence */ }
```

### Vale a pena AGORA?
**Provavelmente nao como prioridade imediata.** Razoes:
1. O sistema atual funciona (specificity `section#s-{id}` e testado e auditado — tier Tested/Proven)
2. Migracao envolve reescrever a cascade de todos os CSS files existentes
3. O ganho real aparece quando ha conflitos de specificity — o OLMO tem poucos porque cada slide e scopado por ID
4. Smashing Magazine (2025) nota que para projetos pequenos/bem-escopados, @layer pode ser "overkill"

**Quando valeria:** se o OLMO crescer para 5+ aulas com CSS compartilhado, ou se conflitos de specificity comecarem a surgir. Ai sim @layer eliminaria a necessidade de `section#s-{id}` e simplificaria tudo.

**Veredicto:** backlog item para futuro, nao prioridade. CSS Nesting tem ROI maior agora (reduz linhas sem mudar arquitetura).

---

## 3. Design System Engineering — Token Architecture Profissional

### Brad Frost: Atomic Design + Tokens (2025)
Frost evoluiu do Atomic Design (2013) para **Design Tokens como particulas subatomicas**. A arquitetura de tokens tem 3 tiers:
- **Tier 1 (Option/Global):** paleta completa — `--color-blue-500`, `--space-16`. Privados, nao usados diretamente.
- **Tier 2 (Semantic/Alias):** intencao — `--color-danger`, `--space-card-gap`. Publicados para uso.
- **Tier 3 (Component):** especificos — `--card-border-radius`, `--hero-font-size`. Escopo local.

### Martin Fowler: Design Token-Based UI Architecture (Dec 2024)
Fowler formalizou que CSS custom properties **nao sao** o token system — sao o **delivery mechanism**. Tokens sao o contrato compartilhado entre design e engineering. Manter option tokens privados reduz file size e permite non-breaking changes.

### Como o OLMO se compara
O OLMO ja implementa um sistema de 2-tier funcional:
- **Tier 1 (base.css `:root`):** tokens globais (cores, tipografia, espacamento)
- **Tier 2 (semantico):** `--safe`, `--warning`, `--danger`, `--downgrade` (design-reference.md)
- **Tier 3 (slide):** overrides per-slide em `#s-{id}` (mas sem naming convention formal)

**Gap identificado:** Tier 3 nao tem convencao de naming. Slides usam valores de Tier 2 diretamente ou criam variaveis ad-hoc. Uma convencao como `--s-{id}-hero-size` formalizaria o que ja e pratica implicita.

### Governanca (enterprise patterns adaptados)
- **Single source of truth:** `base.css :root` = canonico. Mudar token la propaga automaticamente.
- **Propagation map:** ja existe em CLAUDE.md e qa-pipeline.md — "se mudou X, atualize Y".
- **Versionamento:** git tracking ja cobre. Sem necessidade de Style Dictionary ou tooling extra para 1-3 aulas.

---

## 4. Slideology — Criterios Quantificaveis (Convergencia de 4 Frameworks)

### Michael Alley — Assertion-Evidence
- Headline: max 2 linhas, frase completa assertiva (nao rotulo)
- Corpo: apenas evidencia visual, zero bullet lists
- **Evidencia:** AE slides produzem compreensao mais profunda e melhor recall vs. topic-subtopic (Alley, ASEE 2011)

### Edward Tufte — Data-Ink Ratio
- **Data-Ink Ratio** = (ink de dados) / (ink total). Meta: >=0.80
- **Lie Factor** = (tamanho do efeito no grafico) / (tamanho do efeito nos dados). Meta: 1.0 +/- 0.05
- **Chartjunk:** zero gridlines decorativas, efeitos 3D, gradientes em dados

### Garr Reynolds — Signal-to-Noise Ratio
- **SNR** = elementos relevantes / elementos totais. Quanto maior, melhor
- **Tres operacoes:** Restrain, Reduce, Emphasize
- Reynolds nota que SNR e "um principio entre muitos" — nao regra absoluta

### Nancy Duarte — Structural Patterns
- Sparkline narrativa: alternar problema/solucao, min 4 beats
- Ponto focal unico por slide
- Regra de 3: max 3 grupos visuais por layout

**Status OLMO:** Todos os quatro frameworks ja estao codificados em `design-principles.md` (27 principios). A pesquisa confirma que o OLMO esta alinhado com o state of the art em design theory.

---

## 5. Motion Design para Educacao — Ciencia + Pratica

### Mayer's Multimedia Learning Principles (aplicados a motion)

| Principio | Implicacao para Motion | Implementacao OLMO |
|-----------|----------------------|---------------------|
| **Signaling** | Animar o elemento CHAVE, nao tudo | `data-animate` em evidencia, nao decoracao |
| **Segmenting** | Quebrar info complexa em reveals progressivos | `data-reveal="1,2,3"` click-reveal |
| **Temporal Contiguity** | Visual aparece COM narracao | GSAP delay alinha com timing do speaker |
| **Coherence** | Remover animacao extranea | Sem bounce/elastic; so `power2.out` |
| **Redundancy** | Nao animar o que o speaker ja diz | CountUp para numeros referenciados, nao lidos |

- **Meta-analise 2025:** Confirma que principios de Mayer se mantem across media types, com boundary conditions por nivel de expertise (expertise-reversal relevante para audiencia de congresso medico)

### GSAP Criterios Quantificaveis

| Propriedade | Range | Fonte |
|-------------|-------|-------|
| Fade/translate | 300-600ms | Industry consensus + slide-rules.md |
| CountUp | 800-1200ms | slide-rules.md |
| Stagger total | <=1.5s | slide-rules.md |
| Max duration | <=2s | slide-rules.md |
| Easing | `power2.out` ou `power3.out` | slide-rules.md |
| `prefers-reduced-motion` | `gsap.matchMedia()` | GSAP a11y docs |
| Init failsafe | `[data-animate] { opacity: 0 }` | slide-rules.md S7 |
| Frame target | 60fps | Transform/opacity only |

### Motion DO's
- Anticipation em hero numbers
- Stagger nao-uniforme em data cards (stagger uniforme = max 7 no QA rubric)
- CountUp com pausa significativa no valor alvo

### Motion DON'Ts
- Stagger uniforme (cap QA score)
- Parallax decorativo
- Animacao em elementos que o speaker nao referencia
- Elastic/bounce easing
- Animacao que flasha >3x/segundo (acessibilidade — 70M+ pessoas com disturbios vestibulares)

---

## 6. Iteration Loop — Claude Code + Chrome DevTools MCP

### O Loop Visual (ja disponivel no OLMO)
1. **Edit** codigo (Edit tool)
2. **Build** (`npm run build:{aula}`)
3. **Screenshot** (`take_screenshot` via Chrome DevTools MCP — ja configurado)
4. **Analyze** screenshot contra criterios do rubric
5. **Fix** e repetir

### 29 ferramentas MCP disponiveis
- `take_screenshot` — verificacao visual pixel-level
- `evaluate_script` — inspecao DOM runtime
- `lighthouse_audit` — scoring performance/a11y
- `emulate` — teste de viewport/device
- `list_console_messages` — deteccao de erros com source maps

### Visual Regression (gap identificado)
O OLMO ja tem QA loop mais rigoroso que a maioria (qa-pipeline.md): Build -> Screenshot -> 4-dim preflight -> Gemini Inspect -> Gemini Editorial.

**Gap:** Nao ha **baseline screenshots** armazenados por slide. Padrao industry (Percy, Applitools): capturar golden screenshot -> editar CSS -> capturar novo -> diff automatico. OLMO poderia armazenar baselines em `qa-screenshots/{id}/baseline.png` e comparar apos mudancas.

---

## 7. Frontend Excellence Checklist — Consenso de Experts

### CSS Reset (Josh Comeau, update marco 2026)
- `box-sizing: border-box` em todos elementos
- `margin: 0` default removal
- `line-height: 1.5` (body), `1.1` (headings)
- `text-wrap: pretty` para headings (Chrome 117+)
- `interpolate-size: allow-keywords` para animate-to-auto (Chrome 129+)

### Quality Signals (lint-enforceable)
- Zero `rgba()`/`rgb()` em CSS novo -> **ja enforced**
- Zero `vw`/`vh` em font-size -> **ja enforced** (E52)
- Zero `!important` -> enforceable via lint (gap)
- Zero inline `display`/`visibility`/`opacity` em `<section>` -> **ja enforced** (E07)
- `[data-animate]` values em allowed set -> enforceable
- `[data-animate] { opacity: 0 }` failsafe presente -> enforceable
- Color tokens only, zero hex/oklch literals em slide CSS -> enforceable
- `font-display: swap` em todo @font-face -> **ja enforced**

### Quality Signals (human-judged)
- Assertion e clinicamente acionavel (nao apenas factual)
- Hero element >= 2x peso visual dos elementos de suporte
- Motion timing alinha com beats narrativos do speaker
- Composicao segue F-pattern ou Z-pattern apropriadamente
- Fontes de dados Tier 1 com status de verificacao

---

## 8. Presentation Frameworks — Patterns Emprestiveis

| Framework | Pattern | Util para OLMO? |
|-----------|---------|-----------------|
| **reveal.js** | CSS custom properties para theming | Ja adotado |
| **reveal.js** | Plugin ecosystem | Nao — deck.js e mais simples por design |
| **Slidev** | Hot-reload com Vite | Ja funciona via `npm run dev:{aula}` |
| **Marp** | Markdown -> HTML pipeline | OLMO usa HTML direto (mais rico) |
| **Todos** | Fixed viewport scaling | Ja implementado (`scaleDeck()` 1280x720) |
| **Todos** | CSS scoping per slide | Ja implementado (`#s-{id}`) |

**Pattern mais valioso a emprestar:** Nenhum framework-level. O OLMO ja implementa os patterns que importam. A vantagem do vanilla e exatamente nao carregar overhead de framework para um deck de 17 slides.

---

## Rubric de Excelencia Proposto

Scoring: 1-3 por dimensao (1=abaixo, 2=meets, 3=exceeds). Total maximo: 24. Threshold "elite": >=20.

| Dimensao | 1 (Abaixo) | 2 (Meets) | 3 (Exceeds) |
|----------|-----------|-----------|-------------|
| **Assertion Quality** | Rotulo topico ou >2 linhas | Assertiva completa, <=2 linhas | Assertiva clinicamente acionavel |
| **Data-Ink Ratio** | <0.60 (elementos decorativos) | 0.60-0.80 | >0.80 (cada pixel carrega dado) |
| **Cognitive Load** | >4 grupos, peso visual uniforme | <=4 grupos, hero claro | <=3 grupos, Von Restorff hero 2-3x |
| **Color Semantics** | Cores sem significado clinico | Cores match safe/warning/danger | Cores + icones + deltaL>=10% entre niveis |
| **Typography** | Valores literais, pesos inconsistentes | Todos tokens, min 400 weight | Tokens + tabular-nums + split serif/sans |
| **Motion Purpose** | Decorativa ou ausente | Sinaliza dado chave (countUp, stagger) | Anticipation + stagger nao-uniforme + pausa |
| **WCAG Contrast** | <4.5:1 em algum texto | >=4.5:1 todo texto, >=7:1 primary | >=7:1 todo texto + testado em projecao |
| **CSS Architecture** | Inline styles, `!important`, magic numbers | Token-based, scope per-slide, zero `!important` | Nesting + zero literals + naming convention T3 |

---

## Gap Analysis: OLMO Atual vs. State of the Art

| Area | Estado Atual | Gap | Prioridade |
|------|-------------|-----|------------|
| Color system | OKLCH mandatorio, paleta Tol, tokens semanticos | **Nenhum** — a frente da maioria | -- |
| Assertion-Evidence | Enforced por lint + rules | **Nenhum** | -- |
| Token architecture | 2-tier funcional (base + semantico) | Tier 3 sem naming convention | Baixa |
| @layer cascade | Nao usado; specificity via `section#s-{id}` | Oportunidade futura | Backlog |
| CSS Nesting | Nao usado | Reduziria verbosidade | Media |
| Motion accessibility | Sem `prefers-reduced-motion` | Adicionar `gsap.matchMedia()` | Media |
| Visual regression baseline | Sem golden screenshots armazenados | Armazenar baselines per-slide | Media |
| Excellence rubric | 4-dim preflight existe | Expandir para 8 dimensoes (acima) | Alta |
| Lint `!important` | Nao verificado | Adicionar a lint-slides.js | Baixa |
| Vanilla JS/CSS paradigm | Ja opera sem framework | **Nenhum** — vantagem competitiva | -- |

---

## Sources

- [State of CSS 2026 — Container Queries, Scroll Animations](https://www.codercops.com/blog/state-of-css-2026)
- [State of CSS 2025 Survey — Features](https://2025.stateofcss.com/en-US/features/)
- [Modern CSS Toolkit 2026](https://www.nickpaolini.com/blog/modern-css-toolkit-2026)
- [CSS @layer Complete Guide 2026](https://devtoolbox.dedyn.io/blog/css-cascade-layers-complete-guide)
- [Integrating CSS Cascade Layers to Existing Project (Smashing, 2025)](https://www.smashingmagazine.com/2025/09/integrating-css-cascade-layers-existing-project/)
- [CSS Cascade Layers vs BEM vs Utility Classes (Smashing, 2025)](https://www.smashingmagazine.com/2025/06/css-cascade-layers-bem-utility-classes-specificity-control/)
- [Martin Fowler: Design Token-Based UI Architecture (Dec 2024)](https://martinfowler.com/articles/design-token-based-ui-architecture.html)
- [Brad Frost: Design Tokens + Atomic Design](https://bradfrost.com/blog/post/design-tokens-atomic-design-%E2%9D%A4%EF%B8%8F/)
- [Design Tokens Course (Brad & Ian Frost)](https://designtokenscourse.com)
- [Nathan Curtis: Tokens in Design Systems (EightShapes)](https://medium.com/eightshapes-llc/tokens-in-design-systems-25dd82d58421)
- [Assertion-Evidence Approach (Michael Alley)](https://www.assertion-evidence.com/)
- [AE Comprehension Study (ASEE 2011)](https://peer.asee.org/assertion-evidence-slides-appear-to-lead-to-better-comprehension-and-recall-of-more-complex-concepts.pdf)
- [Tufte's Data Visualization Principles](https://thedoublethink.com/tuftes-principles-for-visualizing-quantitative-information/)
- [Presentation Zen: Signal-to-Noise Ratio](https://presentationzen.com/blog/the-signal-to-noise-ratio-activity)
- [Duarte Slideology](https://www.duarte.com/resources/books/slideology/)
- [Mayer's 12 Principles of Multimedia Learning](https://www.digitallearninginstitute.com/blog/mayers-principles-multimedia-learning)
- [Meta-analysis of Mayer's Research (2025)](https://www.sciencedirect.com/science/article/pii/S1747938X25000673)
- [Mayer — Past, Present, Future of CTML (2023)](https://link.springer.com/article/10.1007/s10648-023-09842-1)
- [GSAP Accessible Animation](https://gsap.com/resources/a11y/)
- [Web Animation Best Practices](https://gist.github.com/uxderrick/07b81ca63932865ef1a7dc94fbe07838)
- [Josh Comeau Modern CSS Reset](https://www.joshwcomeau.com/css/custom-css-reset/)
- [Chrome DevTools MCP](https://github.com/ChromeDevTools/chrome-devtools-mcp)
- [Sauce Labs Visual Testing Tools 2026](https://saucelabs.com/resources/blog/comparing-the-20-best-visual-testing-tools-of-2026)
- [Slidev vs Marp vs Reveal.js 2026](https://www.pkgpulse.com/blog/slidev-vs-marp-vs-revealjs-code-first-presentations-2026)
- [Vanilla JavaScript in 2025 (HTML All The Things)](https://www.htmlallthethings.com/podcast/stop-using-frameworks-for-everything-vanilla-javascript-in-2025)
- [Why Developers Are Ditching Frameworks (The New Stack)](https://thenewstack.io/why-developers-are-ditching-frameworks-for-vanilla-javascript/)
- [Design Systems 2026: Airbnb & Uber at Scale](https://wearepresta.com/design-systems-for-scale-2026/)
