# HANDOFF — Meta-analise

> Estado operacional dos slides. Atualizar ao final de cada sessao.
> Cross-ref: root `HANDOFF.md` (workflow de agentes, decisoes globais, security, pendentes herdados)
> Migrado de wt-metanalise para monorepo em 2026-03-31. Ultima atualizacao: S267 rehydrate sync (estado operacional S265 preservado).

---

## Estado atual

- **Fase:** QA slide-a-slide (1 por vez, Lucas decide qual).
- **Slides:** 16/16 no deck. Lint PASS. Build PASS. Orphans: 0.
- **Ancora:** Valgimigli 2025 Lancet (PMID 40902613) — IPD-MA, 7 RCTs, 28.982 pts
- **GSAP plugins:** SplitText + Flip + ScrambleTextPlugin
- **Dark-bg:** 3 slides (s-checkpoint-2, s-heterogeneity, s-ancora)
- **HEX navy:** #162032

> **S162:** s-benefit-harm removido. Evidence enrichido (sintese critica full-text, meta-research redundancia, overlap matrix). Pendente S163: overlap completo 15 MAs × 14 RCTs + icone Cochrane clicavel no s-forest2 + conteudo visual slides.

> **S240 em progresso:** Retomo QA + shared-v2 gradual. C1 `2a17744` shared-bridge.css (8 tokens v2 opt-in). C2 s-etd modernizado (subgrid + :has() + logical props — fix H1 border-left asymmetry + H2 1fr drift). Pendente: C3 split s-etd → novo slide s-aplicabilidade (CYP2C19 + NICE gap), C4 evidence/s-aplicabilidade.html, C5 s-heterogeneity CSS moderno. Manifest real = 17 slides (S207) — HANDOFF abaixo desatualizado desde S162.

> **S259 (heterogeneity-evolve):** Phase C0 ROB2 restoration from OLMO_GENESIS (regression fix). Restored: theme-dark + .rob2-bar-track wrapper + .rob2-figure white card. Modernizado: :has() edge bleed (replace MutationObserver), subgrid bars (alignment shared), .kappa-stats grid + tabular-nums (column-mismatch bug). Palette: oklch literais inventados → Paul Tol Bright tokens (--data-1/5/7/2 em shared/css/base.css:79-91, color-blind safe scientific viz standard). Files: `slides/08c-rob2.html` + `metanalise.css`. Pendente S260+: s-heterogeneity refactor (Phase C1) + s-fixed-random (Phase C2) + evidence expansion (Phase D).

> **S259 (metanalise-s-quality, paralelo):** s-quality v2 rebuild com carga germânica + 6ª perna research (Codex xhigh / GPT-5.5 POC). 8 phases, 5 commits. R1 paper-fonte identificado (Strawbridge 2025 BJPsych Open, PMID 41186074); R4 finding crítico: "ortogonal" NÃO é termo EBM estabelecido — heurística pedagógica. H2 mudou de "ortogonais" → "Qualidade, Risco de Viés e Certeza: três perguntas distintas, não hierarquia". Slide layout: 3 cards isomórficos (Qualidade/RoB/Certeza × Pergunta/Confusão/Ferramenta) + dissociation panel (52% Alvarenga 2024). Evidence HTML expandido +7 PMIDs verified (Strawbridge, Lunny, Schunemann, Yang, Karvinen, McKechnie, Igelstrom). Files: `slides/05-quality.html` + `metanalise.css` (lines 334-475 substituídos) + `shared-bridge.css` (s-quality opt-in 4º slide-laboratório) + `slide-registry.js` (4 beats CLT-driven) + `evidence/s-quality-grade-rob.html` (paper-source + why-not-orthogonal + lucas-narrative sections). State s-quality: LINT-PASS → ready Lucas QA preflight.

> **S260 (heterogeneity-evolve C1+C2+D, uncommitted):** Slides s-heterogeneity (09a) + s-fixed-random (10) reescritos pedagogicamente — zero jargão estatístico no slide, analogias clínicas (auscultar sopro / decisão a priori), source-tags clean sem PMID (KBP-44 candidate). `evidence/s-heterogeneity.html` enriquecido: nova seção `#estrategias-didaticas` (4 abordagens NLM ancoradas em Borenstein 2021 Cap. 20 — Estetoscópio / Zoom / Pior Cenário / Algoritmo 3 passos) + 3 refs novas validadas (Borenstein 2022 J Clin Epi DOI 10.1016/j.jclinepi.2022.10.003 · Carlson 2023 PMID 37768880 · Seo 2025 DOI 10.63528/jebp.2025.00006) + correção vol Borenstein 2023 (13(1)→12(4)) + 2 gaps marcados RESOLVIDO. Pesquisa: Gemini 3.1 Pro + evidence-researcher (PubMed/CrossRef MCPs detectou 2 PMIDs fabricados pelo Gemini + 1 DOI placeholder) + NLM notebook. Perplexity recusou (Tier 1 pedagogy narrow). Detalhes: root `CHANGELOG.md §S260`.

> **S262 (s-quality content + visual evolution, DONE):** Card Qualidade ganhou 4 chips animados PROSPERO/A priori/PRISMA/Transparência (princípios de qualidade da RS); Card RoB ganhou 4 chips RoB 1/RoB 2/ROBUST-RCT/ROBINS (substituindo texto Ferramenta); Card Certeza ganhou chip GRADE; Card Qualidade Ferramenta convertido para chips simétricos AMSTAR-2/ROBIS. Row Confusão removida dos 3 cards (alinhamento + clareza). Reveal: 5 cliques agrupado (Beat 0 auto cards juntos; Beat 1 perguntas + chips card 1; Beats 2-4 ferramentas por card; Beat 5 dissociation). Refactor visual SOTA: `.slide-inner` scoped grid `auto 1fr auto auto` + `block-size: 100%` (dissoc visível); `.term-card` glassmorphism (background `color-mix --v2-surface-panel 88%, transparent` + `backdrop-filter blur 12px saturate 120%` + hairline border `--v2-border-hair 60%` + 3-layer shadow stack); `:has()` reactive lift quando chip ativo; `.term-checklist` `align-self: start` + `.term-chip` `height: fit-content` (fix stretching bug); `.term-label` `--v2-text-muted` → `--v2-text-body` (contraste). Motion shared-v2: easing `power2.out` (era power3.out) + `stagger: 0.1` nativo GSAP. Tipografia confirmada: Instrument Serif (`--font-display`) em term-name/stat + DM Sans (`--font-body`) em term-content/stat-claim. Files: `slides/05-quality.html` + `metanalise.css` (lines 347-540) + `slide-registry.js` (s-quality function rewrite 5-beat).

## Ordem do deck (atualizada S157)

```
F1: s-title -> s-objetivos -> s-hook -> s-importancia
F2: s-rs-vs-ma -> s-contrato -> s-pico -> s-forest1 -> s-forest2 -> s-heterogeneity -> s-fixed-random
I2: s-checkpoint-2
F3: s-ancora -> s-aplicabilidade -> s-takehome
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

### F2 — Metodologia (8 slides)

| # | Slide | Estado | Notas |
|---|-------|--------|-------|
| 5 | s-rs-vs-ma | LINT-PASS | QA pendente. |
| 6 | s-quality | DONE | **S262 evolution → S265 Phase A architectural fix.** Wrapper `.term-content-block` (grid `1fr auto`) encapsula term-grid + fixa dissoc no rodapé (overflow vertical resolved). Quick wins contraste: chip bg 18%→30%, label `--v2-text-body`→`--v2-text-emphasis` (S262→S265 iteração inline), borders 60%→80%. lint+build PASS. |
| 7 | s-contrato | DONE | Evidence HTML S143. Click-reveal 2 cards. QA R11 PASS. |
| 8 | s-pico | LINT-PASS | Evidence refatorado S144 (benchmark). h2 com RS. QA pendente. |
| 9 | s-forest1 | LINT-PASS | Refactor architectural + QA pendentes (S264 pós-clear). Tokens + glassmorphism + motion stagger. Plan: `.claude/plans/curious-enchanting-tarjan.md` Phases C.1+D. |
| 10 | s-forest2 | LINT-PASS | Refactor architectural + QA pendentes (S264 pós-clear). Calibration + tokens + aspect-ratio + bottom-row + motion. Plan: `.claude/plans/curious-enchanting-tarjan.md` Phases B+C+D. |
| 11 | s-heterogeneity | LINT-PASS | QA pendente. **S260 reformulado pedagogicamente** (zero jargão, analogia "auscultar sopro"). |
| 12 | s-fixed-random | LINT-PASS | QA pendente. **S260 reformulado pedagogicamente** (decisão a priori, sem "42%"). |

### I2 — Checkpoint (1 slide)

| # | Slide | Estado | Notas |
|---|-------|--------|-------|
| 12 | s-checkpoint-2 | LINT-PASS | QA pendente. Dark-bg. |

### F3 — Aplicacao Valgimigli (4 slides)

| # | Slide | Estado | Notas |
|---|-------|--------|-------|
| 13 | s-ancora | LINT-PASS | Dark-bg. |
| 14 | s-aplicabilidade | LINT-PASS | |
| 16 | s-takehome | LINT-PASS | |

### Resumo

- **DONE (4):** s-title, s-hook, s-contrato, s-quality (S265)
- **QA (1):** s-objetivos
- **LINT-PASS (12):** restantes (16 total deck — manifest = 17 slides; HANDOFF table will reconcile com s-pubbias1/2 e s-rob2 em sessão futura)

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
