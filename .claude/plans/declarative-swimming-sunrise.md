# S159 — Forest Plot: Evidence HTML + Preservacao

> Supersede: `abundant-pondering-zebra.md` (S157, nunca executado)
> Decisoes S152 brainstorm firmes. Worker colchicine-macce census consumido aqui.
> **Slides (s-forest1 + s-forest2) ficam para S160** — contexto insuficiente nesta sessao.

## Context

Lucas quer UM evidence HTML unico (`s-forest-plot-final.html`) que destila Li 2026 + Ebrahimi Cochrane 2025 + census 15 MAs do worker. Apos consumo + commit, Lucas autoriza remocao do diretorio worker colchicine-macce.

Benchmark CSS: `pre-reading-heterogeneidade.html` (READ-ONLY, padrao-ouro S148).

---

## Fase 1 — Preservar census + arquivar legados

**1.1** Mover census do worker (gitignored) para versionado:
```
mv .claude/workers/colchicine-macce-2025-2026/40-census-final.md \
   content/aulas/metanalise/references/colchicine-macce-census-S148.md
```

**1.2** Arquivar evidence legados:
```
mkdir -p content/aulas/metanalise/evidence/_archive
mv evidence/s-forest-plot.html → evidence/_archive/s-forest-plot-DRAFT-S146.html
mv evidence/forest-plot-candidates.html → evidence/_archive/forest-plot-candidates-S147.html
```

**Commit:** `S159: preserve colchicine census + archive legacy evidence`

**STOP** — Lucas confirma.

---

## Fase 2 — Evidence HTML unico denso

**2.1** Criar `content/aulas/metanalise/evidence/s-forest-plot-final.html`:

Estrutura (benchmark = pre-reading-heterogeneidade.html para CSS):

- `header` — titulo, meta, objectives (3-layer pre-reading)
- `#anatomia-5-elementos` — square/bar/null/diamond/weight (contexto Li 2026)
- `#rob-meta-elemento` — RoB como 6o elemento (contexto Ebrahimi Cochrane)
- `#li-2026` — sintese destilada PMID 40889093 VERIFIED (PICO, resultado, forest plot)
- `#ebrahimi-2025` — sintese destilada PMID 41224205 VERIFIED (PICO, GRADE, resultado)
- `#census-15-mas` — destilacao curada do worker census (convergencia 9/9 MACE + Pinheiro outlier + sinal clinico)
- `#speaker-notes` — fala de 10s: "Quinze metanalises em quatorze meses..."
- `#depth-rubric` — D1-D8 em `<details>`
- `#referencias` — PMIDs clicaveis (`.v VERIFIED`), `rel="noopener noreferrer"`
- `footer` — coautoria S159

**A11y:** `rel="noopener noreferrer"` em links externos, `scope="col"` em `<th>`.

**Commit:** `S159: add s-forest-plot-final.html — dense evidence (Li + Ebrahimi + 15 MAs)`

**STOP** — Lucas revisa evidence.

---

## Fase 3 — Cleanup worker

Apos commit do evidence, dar a Lucas o comando:
```bash
rm -rf .claude/workers/colchicine-macce-2025-2026/
```
(Lucas autorizado explicitamente. Census ja versionado em references/.)

Worker `s-forest-planning/` preservado (brainstorm scope card, trail epistemologico).

---

## Fase 4 — Wrap S159

- HANDOFF.md: P0 forest atualizado (evidence DONE, slides → S160)
- CHANGELOG.md: S159 entry
- Workers: `colchicine-macce` removido (Lucas), `s-forest-planning` preservado

**Commit:** `S159: wrap — evidence + census preserved, slides deferred S160`

---

## Deferred → S160

- Criar `slides/08a-forest1.html` + `slides/08b-forest2.html`
- Wiring: `_manifest.js`, `metanalise.css`, `slide-registry.js`
- Build + lint + QA pipeline (1 slide por ciclo)
- Crops dos PDFs (Lucas fornece)
- HANDOFF 15→17 slides

---

## Critical files (S159)

| Acao | Arquivo |
|------|---------|
| Criar | `evidence/s-forest-plot-final.html` |
| Criar | `references/colchicine-macce-census-S148.md` (mv) |
| Criar | `evidence/_archive/` (2 legados) |
| Benchmark | `evidence/pre-reading-heterogeneidade.html` (READ-ONLY) |

## Verification (S159)

1. PMIDs 40889093 + 41224205 clicaveis em `#referencias`
2. Census versionado em `references/`
3. Evidence HTML segue benchmark CSS (pre-reading-heterogeneidade.html)
4. Worker colchicine-macce removido apos commit
