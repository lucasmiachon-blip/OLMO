# S161 — Forest Plot: Evidence Expansion + 2 Slides + Build

## Context

P0 do HANDOFF S160. Crops DONE (Li 4084x2876, Ebrahimi 4501x1451 @ 600 DPI). Evidence HTML existe (`s-forest-plot-final.html`) mas precisa expansao com resultados e termos. Slides `08a-forest1` e `08b-forest2` nao existem. Apos criar, wiring em manifest/CSS, build, QA.

---

## Fase 1 — Expandir evidence HTML

**Arquivo:** `content/aulas/metanalise/evidence/s-forest-plot-final.html`

Adicionar 3 blocos:

1. **Glossario pedagogico** de termos do forest plot: OR vs RR, I², modelo fixed vs random, diamante, peso, GRADE certainty, NNT. Vinculado ao pre-reading 3 camadas. Formato: tabela `<details>` expandivel.

2. **Caracteristicas dos papers + subgrupos:** detalhes de inclusao/exclusao, modelo estatistico, analises de subgrupo (dose cumulativa Li, desfechos separados Ebrahimi). Ebrahimi usou plataforma **COVIDENCE** para triagem sistematica — incluir como nota metodologica. Backup para perguntas de alunos — Lucas nao cita muito na aula, mas precisa ter dominio se perguntarem.

3. **Contexto "15 MAs em 14 meses":** ja parcialmente coberto no census. Enriquecer com angulo pedagogico: por que o cluster aconteceu (CLEAR-SYNERGY neutro → onda de reanalise) + o que isso diz sobre incentivos academicos. Sera referenciado como beat final do slide 08b.

**Regras:** manter benchmark CSS (pre-reading-heterogeneidade.html). PMIDs VERIFIED. Nao alterar secoes existentes — append/enrich.

**STOP** — Lucas revisa expansao.

---

## Fase 2 — Criar slide 08a-forest1.html (Li 2026)

**Pattern:** Assertion + Figure (slide-patterns.md §2)
**Imagem:** `assets/forest-li-2025-MACE.png` (4084x2876 — quase quadrado, 1.42:1)
**h2:** `[TBD — Lucas escreve antes da implementacao]`

```html
<section id="s-forest1" data-timing="90">
  <div class="slide-inner">
    <h2 class="slide-headline">[TBD — Lucas]</h2>
    <div class="forest-figure" data-animate="fadeUp">
      <img src="assets/forest-li-2025-MACE.png"
           alt="Forest plot: colchicina vs controle para MACE — Li et al. 2026, 14 RCTs">
    </div>
    <p class="source-tag">Li et al. Am J Cardiovasc Drugs 2026 | PMID: 40889093</p>
  </div>
</section>
```

**CSS** (`metanalise.css`, scopado `section#s-forest1`):
- `.forest-figure` flex centered, max-height ~480px (imagem quase quadrada, height-constrained)
- `img` max-width 100%, max-height 100%, object-fit contain
- Failsafes: `.no-js`, `@media print`, `[data-qa]` → opacity 1

---

## Fase 3 — Criar slide 08b-forest2.html (Ebrahimi Cochrane 2025)

**Pattern:** Assertion + Figure (slide-patterns.md §2)
**Imagem:** `assets/forest-ebrahimi-2025-MI.png` (4501x1451 — panoramico, 3.1:1)
**h2:** `[TBD — Lucas escreve antes da implementacao]`

```html
<section id="s-forest2" data-timing="90">
  <div class="slide-inner">
    <h2 class="slide-headline">[TBD — Lucas]</h2>
    <div class="forest-figure" data-animate="fadeUp">
      <img src="assets/forest-ebrahimi-2025-MI.png"
           alt="Forest plot Cochrane: colchicina para IAM — Ebrahimi et al. 2025, 12 RCTs com RoB">
    </div>
    <p class="source-tag">Ebrahimi et al. Cochrane Database Syst Rev 2025 | <a href="https://www.cochranelibrary.com/cdsr/doi/10.1002/14651858.CD014808.pub2/full" target="_blank" rel="noopener noreferrer">Cochrane Library</a></p>
  </div>
</section>
```

**CSS** (`metanalise.css`, scopado `section#s-forest2`):
- `.forest-figure` flex centered, width-constrained (imagem panoramica, 3.1:1)
- `img` max-width 100%, object-fit contain
- Failsafes identicas

---

## Fase 4 — Wiring

### 4.1 `_manifest.js`
Inserir 2 entries APOS `s-benefit-harm` (phase F2), ANTES de `s-heterogeneity`:

```js
{ id: 's-forest1', file: '08a-forest1.html', phase: 'F2', headline: '[TBD]',
  timing: 90, clickReveals: 0, customAnim: null,
  narrativeRole: 'setup', tensionLevel: 2, narrativeCritical: false,
  evidence: 's-forest-plot-final.html' },
{ id: 's-forest2', file: '08b-forest2.html', phase: 'F2', headline: '[TBD]',
  timing: 90, clickReveals: 0, customAnim: null,
  narrativeRole: 'payoff', tensionLevel: 2, narrativeCritical: false,
  evidence: 's-forest-plot-final.html' },
```

### 4.2 `slide-registry.js`
**Nenhuma entrada.** Slides usam `data-animate="fadeUp"` declarativo (deck.js nativo). Sem click-reveals, sem animacao custom.

### 4.3 `metanalise.css`
Adicionar blocos CSS scopados para `section#s-forest1` e `section#s-forest2`.

---

## Fase 5 — Build + Lint

```bash
cd content/aulas && npm run lint:slides && npm run build:metanalise
```

Verificar: 17 slides no output (15 atuais + 2 novos).

**STOP** — Lucas revisa build.

---

## Fase 6 — QA (1 slide por ciclo)

Pipeline: Preflight → Inspect → Editorial. 1 slide por vez. `08a-forest1` primeiro, depois `08b-forest2`.

---

## Critical files

| Acao | Arquivo |
|------|---------|
| Editar | `evidence/s-forest-plot-final.html` (expandir) |
| Criar | `slides/08a-forest1.html` |
| Criar | `slides/08b-forest2.html` |
| Editar | `slides/_manifest.js` (2 entries) |
| Editar | `metanalise.css` (2 blocos CSS) |
| Build | `index.html` (gerado) |
| Read-only | `slide-registry.js` (sem mudanca) |

## Verification

1. `npm run lint:slides` PASS
2. `npm run build:metanalise` PASS — 17 slides
3. Imagens renderizam no browser (dev server porta 4102)
4. Failsafes: `.no-js` mostra conteudo (opacity:1)
5. PMIDs clicaveis no evidence HTML
6. CSS scopado: `section#s-forest1`, `section#s-forest2`
