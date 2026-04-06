# HANDOFF — Meta-analise

> Estado operacional dos slides. Atualizar ao final de cada sessao.
> Cross-ref: root `HANDOFF.md` (workflow de agentes, decisoes globais, security, pendentes herdados)
> Migrado de wt-metanalise para monorepo em 2026-03-31. Ultima atualizacao: S78.

---

## Estado atual

- **Fase:** QA slide-a-slide (1 por vez, Lucas decide qual)
- **Slides:** 19/19 no deck. Lint PASS. Build PASS. Orphans: 0.
- **Ancora:** Valgimigli 2025 Lancet (PMID 40902613) — IPD-MA, 7 RCTs, 28.982 pts
- **GSAP plugins:** SplitText + Flip + ScrambleTextPlugin
- **Dark-bg:** 6 slides (s-checkpoint-1/2, s-forest-plot, s-heterogeneity, s-ancora, s-absoluto)
- **HEX navy:** #162032

## Ordem do deck (atualizada S78)

```
F1: s-title -> s-objetivos -> s-hook
I1: s-checkpoint-1
F2: s-rs-vs-ma -> s-contrato -> s-pico -> s-abstract -> s-forest-plot -> s-benefit-harm -> s-grade -> s-heterogeneity -> s-fixed-random
I2: s-checkpoint-2
F3: s-ancora -> s-aplicacao -> s-aplicabilidade -> s-absoluto -> s-takehome
```

## Estado dos Slides

> Estados: BACKLOG -> DRAFT -> CONTENT -> SYNCED -> LINT-PASS -> QA -> DONE

### F1 — Criar importancia (3 slides)

| # | Slide | Estado | Notas |
|---|-------|--------|-------|
| 1 | s-title | DONE | Choreography + masking. Gemini beauty 9, legibility 10. |
| 2 | s-objetivos | QA | 35 checks: 33 PASS, 2 WARN. Gate 0/4 pendentes. customAnim: null. |
| 3 | s-hook | DONE | Asymmetric grid, countUp GSAP. 14-dim avg 9.36. |

### I1 — Checkpoint (1 slide)

| # | Slide | Estado | Notas |
|---|-------|--------|-------|
| 4 | s-checkpoint-1 | QA | ACCORD trap. Screenshots S0+S2 OK. Fixes pendentes: axis 10px->14px, trial names 16px->18px, tabular-nums. |

### F2 — Metodologia (9 slides)

| # | Slide | Estado | Notas |
|---|-------|--------|-------|
| 5 | s-rs-vs-ma | LINT-PASS | QA pendente. |
| 6 | s-contrato | DONE | Movido de F1->F2 (S78). Watermark-only 35%. |
| 7 | s-pico | LINT-PASS | QA pendente. |
| 8 | s-abstract | LINT-PASS | QA pendente. |
| 9 | s-forest-plot | LINT-PASS | QA pendente. Dark-bg. |
| 10 | s-benefit-harm | LINT-PASS | QA pendente. |
| 11 | s-grade | LINT-PASS | QA pendente. |
| 12 | s-heterogeneity | LINT-PASS | QA pendente. Dark-bg. |
| 13 | s-fixed-random | LINT-PASS | QA pendente. |

### I2 — Checkpoint (1 slide)

| # | Slide | Estado | Notas |
|---|-------|--------|-------|
| 14 | s-checkpoint-2 | LINT-PASS | QA pendente. Dark-bg. |

### F3 — Aplicacao Valgimigli (5 slides)

| # | Slide | Estado | Notas |
|---|-------|--------|-------|
| 15 | s-ancora | LINT-PASS | Notes enriquecidas. Dark-bg. |
| 16 | s-aplicacao | LINT-PASS | Notes enriquecidas. |
| 17 | s-aplicabilidade | LINT-PASS | Notes enriquecidas. |
| 18 | s-absoluto | LINT-PASS | Dark-bg. |
| 19 | s-takehome | LINT-PASS | |

### Resumo

- **DONE (4):** s-title, s-hook, s-contrato, (s-objetivos quase)
- **QA (2):** s-objetivos (35 checks done, gates pendentes), s-checkpoint-1 (fixes pendentes)
- **LINT-PASS (13):** restantes

## Proximo (Lucas decide)

QA 1 slide por vez. Pipeline por slide:
1. `node scripts/qa-batch-screenshot.mjs --aula metanalise --slide {id}`
2. qa-engineer (35 checks) -> qa-browser-report.json
3. `node scripts/gemini-qa3.mjs --aula metanalise --slide {id} --inspect` (Gate 0)
4. [checkpoint Lucas]
5. `node scripts/gemini-qa3.mjs --aula metanalise --slide {id} --editorial` (Gate 4)

## Pendencias conhecidas

| Item | Impacto | Acao |
|------|---------|------|
| ~40 refs `--on-dark` tokens | Naming misleading, funcional | Cleanup futuro |
| Cochrane forest plots | Precisam screenshots/crops reais | Acessar via CAPES |
| s-objetivos customAnim | stagger nao wired | Apos QA visual |
| Codex adversarial review | 2 arquivos em .claude/ | Lucas decidir sobre conteudo dos objetivos |

## Fontes

### Internas (repo)

| Fonte | Conteudo |
|-------|----------|
| `evidence/s-{id}.html` | Living HTML per slide. Dados clinicos verificados, PMIDs |
| `references/narrative.md` | Arco narrativo, beats de tensao |
| `references/blueprint.md` | Mapa slide-a-slide com evidencias |
| `references/research-accord-valgimigli.md` | Briefing ACCORD + Valgimigli |
| `references/reading-list.md` | Pre-reading (4 papers) |
| `evidence/research-gaps-report.md` | Gaps de evidence HTML por slide (S78) |

### Externas (MCPs)

PubMed (verificar PMIDs) . Scite (citation tallies) . Perplexity (estado da arte) . Consensus (consenso quantitativo)

---

> Workflow de agentes, decisoes globais, security: root `HANDOFF.md`
> Historico completo: `HANDOFF-ARCHIVE.md`
> QA pipeline detalhado: `.claude/rules/qa-pipeline.md`
> Auditoria agents/scripts: `docs/aulas/AGENT-AUDIT-S78.md`
