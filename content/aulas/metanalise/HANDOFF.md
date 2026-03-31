# HANDOFF — Meta-análise

> Estado operacional. Atualizar ao final de cada sessão.
> Migrado de wt-metanalise para monorepo em 2026-03-31.

---

## Estado atual

- **Fase:** QA slide-a-slide com visual uplift
- **Slides:** 18/18 no deck. Lint PASS. Orphans: 0.
- **Âncora:** Valgimigli 2025 Lancet (PMID 40902613) — IPD-MA, 7 RCTs, 28.982 pts
- **GSAP plugins:** SplitText + Flip + ScrambleTextPlugin
- **Dark-bg:** 6 slides (ver NOTES.md §dark-bg reference map)
- **HEX navy:** #162032

## Estado dos Slides

> Estados: BACKLOG → DRAFT → CONTENT → SYNCED → LINT-PASS → QA → DONE

### F1 — Criar importância (3 slides)

| # | Slide | Estado | Notas |
|---|-------|--------|-------|
| 1 | s-title | DONE | Choreography + masking. Gemini beauty 9, legibility 10. |
| 2 | s-hook | DONE | Asymmetric grid, countUp GSAP. 14-dim avg 9.36. |
| 3 | s-contrato | DONE | Watermark-only 35% opacity. Gemini+Lucas approved. |

### I1 — Checkpoint (1 slide)

| # | Slide | Estado | Notas |
|---|-------|--------|-------|
| 4 | s-checkpoint-1 | QA | ACCORD trap (Ray 2009 + ACCORD 2008). Slide-punch 6/6 PASS. Scorecard 14-dim + screenshots pendentes. |

### F2 — Metodologia (8 slides)

| # | Slide | Estado | Notas |
|---|-------|--------|-------|
| 5 | s-rs-vs-ma | LINT-PASS | Scorecard 14-dim pendente. |
| 6 | s-pico | LINT-PASS | Scorecard 14-dim pendente. |
| 7 | s-abstract | LINT-PASS | Scorecard 14-dim pendente. |
| 8 | s-forest-plot | LINT-PASS | Scorecard 14-dim pendente. |
| 9 | s-benefit-harm | LINT-PASS | Scorecard 14-dim pendente. |
| 10 | s-grade | LINT-PASS | Scorecard 14-dim pendente. |
| 11 | s-heterogeneity | LINT-PASS | Scorecard 14-dim pendente. |
| 12 | s-fixed-random | LINT-PASS | Scorecard 14-dim pendente. |

### I2 — Checkpoint (1 slide)

| # | Slide | Estado | Notas |
|---|-------|--------|-------|
| 13 | s-checkpoint-2 | LINT-PASS | Scorecard 14-dim pendente. |

### F3 — Aplicação Valgimigli (5 slides)

| # | Slide | Estado | Notas |
|---|-------|--------|-------|
| 14 | s-ancora | LINT-PASS | Notes enriquecidas: 7 RCTs, modelo IPD, Giacoppo BMJ. |
| 15 | s-aplicacao | LINT-PASS | Notes enriquecidas: NICE gap, custo, lacuna GRADE. |
| 16 | s-aplicabilidade | LINT-PASS | Notes enriquecidas: CYP2C19, generalização geográfica. |
| 17 | s-absoluto | LINT-PASS | Scorecard 14-dim pendente. |
| 18 | s-takehome | LINT-PASS | Scorecard 14-dim pendente. |

### Resumo

- **DONE (3):** s-title, s-hook, s-contrato
- **QA (1):** s-checkpoint-1 — screenshots pendentes
- **LINT-PASS (14):** restantes — scorecard 14-dim pendente

## Próximo

1. QA s-checkpoint-1 (screenshots + scorecard 14-dim)
2. QA sequencial F2 (s-rs-vs-ma → s-fixed-random)
3. Dark-bg: decidir por slide (propostos: s-forest-plot, s-heterogeneity, s-ancora, s-absoluto)
4. Build de produção (`npm run build:metanalise`)

## Pendências conhecidas

| Item | Impacto | Ação |
|------|---------|------|
| ~40 refs `--on-dark` tokens | Naming misleading, funcional | Cleanup futuro |
| Cochrane forest plots | Precisam screenshots/crops reais | Acessar via CAPES |

## Fontes — retórica e conhecimento

### Internas (repo)

| Fonte | Conteúdo |
|-------|----------|
| `references/evidence-db.md` | **Canônica.** Todos dados clínicos verificados, PMIDs |
| `references/narrative.md` | Arco narrativo, beats de tensão |
| `references/blueprint.md` | Mapa slide-a-slide com evidências |
| `references/research-accord-valgimigli.md` | Briefing ACCORD + Valgimigli |
| `references/reading-list.md` | Pre-reading (4 papers) |
| Speaker notes nos slides | Script retórico com timing |

### Externas (MCPs)

PubMed (verificar PMIDs) · Scite (citation tallies) · Perplexity (estado da arte) · Consensus (consenso quantitativo)

---

> Histórico completo: `HANDOFF-ARCHIVE.md`
> QA pipeline detalhado: `WT-OPERATING.md` (referência)
