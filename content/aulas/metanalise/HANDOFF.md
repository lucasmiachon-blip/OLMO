# HANDOFF — Meta-analise

> Estado operacional dos slides. Atualizar ao final de cada sessao.
> Cross-ref: root `HANDOFF.md` (workflow de agentes, decisoes globais, security, pendentes herdados)
> Migrado de wt-metanalise para monorepo em 2026-03-31. Ultima atualizacao: S157 (reconcile phantom + Context Melt fix).

---

## Estado atual

- **Fase:** QA slide-a-slide (1 por vez, Lucas decide qual). S157: +2 slides forest plot em execucao.
- **Slides:** 15/15 no deck. Lint PASS. Build PASS. Orphans: 0.
- **Ancora:** Valgimigli 2025 Lancet (PMID 40902613) — IPD-MA, 7 RCTs, 28.982 pts
- **GSAP plugins:** SplitText + Flip + ScrambleTextPlugin
- **Dark-bg:** 4 slides (s-checkpoint-2, s-heterogeneity, s-ancora, s-absoluto)
- **HEX navy:** #162032

> **S157 reconciliation:** linha `s-forest-plot` era fantasma (registrada S146 mas nunca criada). Removida. Contagem corrigida 16→15. Em execucao S157: 2 slides novos (s-forest1 Li + s-forest2 Ebrahimi) com evidence unico `s-forest-plot.html`.

## Ordem do deck (atualizada S157)

```
F1: s-title -> s-objetivos -> s-hook -> s-importancia
F2: s-rs-vs-ma -> s-contrato -> s-pico -> s-benefit-harm -> s-heterogeneity -> s-fixed-random
I2: s-checkpoint-2
F3: s-ancora -> s-aplicabilidade -> s-absoluto -> s-takehome
```

Removidos S136: s-abstract (PRISMA = producao, nao appraisal), s-grade (permeia outros slides), s-aplicacao (claim incorreta).

## Estado dos Slides

> Estados: BACKLOG -> DRAFT -> CONTENT -> SYNCED -> LINT-PASS -> QA -> DONE

### F1 — Criar importancia (4 slides)

| # | Slide | Estado | Notas |
|---|-------|--------|-------|
| 1 | s-title | DONE | Choreography + masking. |
| 2 | s-objetivos | QA | Preflight pendente. |
| 3 | s-hook | DONE | Asymmetric grid, countUp GSAP. |
| 4 | s-importancia | LINT-PASS | Criado S135. Build S136. |

### F2 — Metodologia (6 slides)

| # | Slide | Estado | Notas |
|---|-------|--------|-------|
| 5 | s-rs-vs-ma | LINT-PASS | QA pendente. |
| 6 | s-contrato | DONE | Evidence HTML S143. Click-reveal 2 cards. QA R11 PASS. |
| 7 | s-pico | LINT-PASS | Evidence refatorado S144 (benchmark). h2 com RS. QA pendente. |
| 8 | s-benefit-harm | LINT-PASS | QA pendente. |
| 9 | s-heterogeneity | LINT-PASS | QA pendente. Dark-bg. |
| 10 | s-fixed-random | LINT-PASS | QA pendente. |

### I2 — Checkpoint (1 slide)

| # | Slide | Estado | Notas |
|---|-------|--------|-------|
| 11 | s-checkpoint-2 | LINT-PASS | QA pendente. Dark-bg. |

### F3 — Aplicacao Valgimigli (4 slides)

| # | Slide | Estado | Notas |
|---|-------|--------|-------|
| 12 | s-ancora | LINT-PASS | Dark-bg. |
| 13 | s-aplicabilidade | LINT-PASS | |
| 14 | s-absoluto | LINT-PASS | Dark-bg. |
| 15 | s-takehome | LINT-PASS | |

### Resumo

- **DONE (3):** s-title, s-hook, s-contrato
- **QA (1):** s-objetivos
- **LINT-PASS (11):** restantes

## Proximo (Lucas decide)

QA 1 slide por vez. Pipeline por slide:
1. Preflight (dims objetivas: cor, tipografia, hierarquia) — $0
2. [Lucas OK]
3. `node scripts/gemini-qa3.mjs --aula metanalise --slide {id} --inspect` (Gate 0)
4. [Lucas OK]
5. `node scripts/gemini-qa3.mjs --aula metanalise --slide {id} --editorial` (Gate 4)

## Pendencias conhecidas

| Item | Impacto | Acao |
|------|---------|------|
| Cochrane forest plots | Precisam screenshots/crops reais | Acessar via CAPES |
| s-objetivos customAnim | stagger nao wired | Apos QA visual |

## Fontes

### Internas (repo)

| Fonte | Conteudo |
|-------|----------|
| `evidence/s-{id}.html` | Living HTML per slide. Dados clinicos verificados, PMIDs |
| `evidence/meta-narrativa.html` | Arco narrativo, competencias, 3 perguntas (on-demand) |
| `evidence/blueprint.html` | Espinha de slides por fase (on-demand) |
| `references/reading-list.md` | Pre-reading (4 papers) |

### Externas (MCPs)

PubMed (verificar PMIDs) . Scite (citation tallies)

---

> Workflow de agentes, decisoes globais, security: root `HANDOFF.md`
> QA pipeline detalhado: `.claude/rules/qa-pipeline.md`
