---
description: "Layout patterns com HTML concreto para slides deck.js. Consultar ao criar/editar slides."
paths:
  - "content/aulas/**"
---

# Slide Layout Patterns

Concrete HTML examples from the OLMO design system. Each pattern is a starting point — adapt layout freely using CSS Grid/Flex scoped by `#s-{id}`.

## 0. New Slide Template

Base template for creating a new slide from scratch:

```html
<section id="s-[id]">
  <div class="slide-inner">
    <p class="section-tag">[BLOCO: A1 / A2 / A3 / APP]</p>
    <h2>[AFIRMACAO CLINICA COMPLETA — frase verificavel]</h2>
    <div class="evidence" data-animate="fadeUp">
      <!-- evidencia visual: grafico, tabela, numero-chave, diagrama -->
    </div>
    <cite class="source-tag">Autor et al. Journal Ano;Vol:Pags. PMID: XXXXX</cite>
  </div>
  <aside class="notes">
    [TEMPO: ~90s]
    Falar: ...
    Enfase: ...
    [DATA] Fonte: | Verificado: AAAA-MM-DD
    Transicao: proximo slide aborda ...
  </aside>
</section>
```

Rules: `<h2>` = complete claim, zero `<ul>/<ol>`, PMID required, OKLCH tokens only, `data-animate` only.

## 1. Assertion + Data Cards

Two or three metric cards supporting the headline assertion.

```html
<section id="s-a1-nsbb-efficacy">
  <div class="slide-inner">
    <p class="section-tag">Portal Hypertension</p>
    <h2>NSBB reduces variceal bleeding by 50% in primary prophylaxis</h2>
    <div style="display:none"><!-- layout in cirrose.css #s-a1-nsbb-efficacy --></div>
    <div class="cards" data-animate="stagger">
      <div class="card">
        <p class="hero-number text-safe" data-animate="countUp" data-target="50">0</p>
        <h3>% reduction</h3>
        <p>Bleeding risk</p>
      </div>
      <div class="card">
        <p class="hero-number" data-animate="countUp" data-target="10">0</p>
        <h3>NNT</h3>
        <p>Over 2 years</p>
      </div>
    </div>
  </div>
  <aside class="notes">
    [0:00-0:20] State the magnitude. Let numbers land.
    [DATA] D'Amico 2014, Hepatology | PMID: 25066088
    [VERIFIED] 2026-03-31
  </aside>
</section>
```

## 2. Assertion + Figure

Full-width image or forest plot supporting the claim.

```html
<section id="s-mn-valgimigli-forest">
  <div class="slide-inner">
    <p class="section-tag">Results</p>
    <h2>Short DAPT non-inferior to standard duration for MACE</h2>
    <div class="slide-figure" data-animate="fadeUp">
      <img src="assets/valgimigli-forest.svg" alt="Forest plot: short vs standard DAPT">
    </div>
    <p class="source-tag">Valgimigli 2025, Lancet | PMID: pending</p>
  </div>
  <aside class="notes">
    [0:00-0:15] Point to the summary diamond.
    [0:15-0:30] Note the I² — moderate heterogeneity.
    [DATA] Valgimigli et al. Lancet 2025
    [VERIFIED] 2026-03-31
  </aside>
</section>
```

## 3. Assertion + Tufte Table

Clean data table with optional row highlight.

```html
<section id="s-gr-quality-comparison">
  <div class="slide-inner">
    <p class="section-tag">GRADE Framework</p>
    <h2>Only 2 of 8 domains consistently rated across guidelines</h2>
    <table class="tufte" data-animate="fadeUp" data-highlight-row="3">
      <thead>
        <tr><th>Domain</th><th data-num>Rated (%)</th><th>Concordance</th></tr>
      </thead>
      <tbody>
        <tr><td>Risk of bias</td><td data-num>100</td><td class="text-safe">High</td></tr>
        <tr><td>Inconsistency</td><td data-num>95</td><td class="text-safe">High</td></tr>
        <tr class="highlight"><td>Publication bias</td><td data-num>23</td><td class="text-danger">Low</td></tr>
      </tbody>
    </table>
  </div>
  <aside class="notes">
    [0:00-0:20] Walk through columns. Pause at publication bias.
    [DATA] Schünemann 2023, JCE | PMID: 36702743
    [VERIFIED] 2026-03-31
  </aside>
</section>
```

## 4. Progressive Reveal (Click)

Step-by-step clinical reasoning.

```html
<section id="s-a1-albumin-indication">
  <div class="slide-inner">
    <h2>Albumin indication depends on the clinical scenario</h2>
    <div data-reveal="1">
      <h3 class="text-safe">SBP</h3>
      <p>1.5 g/kg D1 + 1 g/kg D3 — grade A evidence</p>
    </div>
    <div data-reveal="2">
      <h3 class="text-warning">LVP > 5L</h3>
      <p>8 g/L removed — prevents PICD</p>
    </div>
    <div data-reveal="3">
      <h3 class="text-danger">HRS-AKI</h3>
      <p>With terlipressin — uncertain benefit alone</p>
    </div>
  </div>
  <aside class="notes">
    [0:00-0:10] "When do we use albumin?" PAUSE.
    [CLICK] SBP — strongest evidence.
    [CLICK] LVP — dose per liter.
    [CLICK] HRS — controversy.
    [DATA] EASL 2024 Guidelines | Runyon 2023
    [VERIFIED] 2026-03-31
  </aside>
</section>
```

## 5. Section Opener (Dark)

Navy background, minimal text, sets context for a section.

```html
<section id="s-a1-section-treatment" class="theme-dark">
  <div class="slide-inner">
    <p class="section-tag">Part III</p>
    <h1 data-animate="fadeUp">Treatment</h1>
  </div>
  <aside class="notes">
    [0:00-0:05] Transition. Breathe.
  </aside>
</section>
```

## CSS Scoping Example

Each slide gets its own layout in `{lecture}.css`:

```css
/* cirrose.css */
#s-a1-nsbb-efficacy .cards {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-md);
  margin-top: var(--space-lg);
}

#s-a1-nsbb-efficacy .card {
  text-align: center;
  padding: var(--space-lg) var(--space-md);
}
```

Never use generic layout classes across slides. Each `#s-{id}` scope is independent.
