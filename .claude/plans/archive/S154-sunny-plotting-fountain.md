# S153 INFRA_LEVE — Plan

> Sessao 153 · 2026-04-11 · branch `main`
> Origem do pedido: Lucas — "entre em plan sessao INFRA_LEVE, leia o handoff e vamos planejar o que esta la de infra. tambem quero que remova todo o s-checkpoint-1 e referencias... mova para archived se quiser."

## Context

### Por que esta sessao existe

1. **Fechar o rabo do S152** — Lucas decidiu no wrap do S152 que a proxima sessao e **infra continuada** (hooks + otros itens leves) antes de voltar para os slides de forest plot. HANDOFF.md §P3 define o escopo de infra para a proxima sessao, e o foco do S153 e o **subset LEVE** — cleanup + quick wins, adiando re-designs pesados.
2. **Limpar o s-checkpoint-1 do escopo mental** — o slide ja estava arquivado narrativamente desde o S107 (comentado em `_manifest.js` linha 20) mas o arquivo HTML, o CSS (~142 linhas), o registry de animacao (~58 linhas) e 7 cross-refs em docs/evidence continuam ocupando atencao. Lucas quer que o slide saia de vez do escopo.
3. **Preservar historia como via negativa** — docs historicos (CHANGELOG, KBP-13, audits S150/S151) que mencionam s-checkpoint-1 como evidencia de drift ou referencia de projeto NAO devem ser editados — sao registro imutavel.

### Outcome esperado

- `npm run build:metanalise` continua verde, 15 slides (mesma contagem, s-checkpoint-1 ja estava fora do deck ativo).
- CSS da metanalise perde ~142 linhas (bloco `#s-checkpoint-1` + `.ck1-*`) sem afetar outros slides. Classes compartilhadas com checkpoint-2 (`.checkpoint-layout`, `.checkpoint-scenario`, `.checkpoint-question`, `.checkpoint--hidden`) sao **preservadas**.
- `slide-registry.js` perde a factory `'s-checkpoint-1'` (linhas 175-232).
- Evidence HTMLs de F2 (s-pico, s-rs-vs-ma), narrativa e blueprint ficam coerentes com deck sem I1 — sem referencias orfas ao "slide 03 checkpoint-1 / ACCORD trap" como ancora narrativa.
- `.claude/plans/` ganha `archive/` com ate 18 plans SXXX-prefixed (Lucas decide arquivo-por-arquivo — KBP-10).
- `research/SKILL.md` Step 2 ganha coluna `type` (paper|book|guideline|preprint|web) + fallback ID — P005 do /insights S151 backlog.
- HANDOFF.md atualizado com proximo foco = slides (forest plot Vaduganathan + colchicine).

---

## Scope

### Scope A — s-checkpoint-1 remocao (principal work do user)

#### A0. Mapa de resquicios (resultado da investigacao pre-plano)

Busca multi-camada feita: grep literal (`s-checkpoint-1`, `checkpoint-1`), grep de classes CSS (`ck1-`, `checkpoint-scenario`, `checkpoint-question`, `checkpoint-layout`, `checkpoint--hidden`), grep conceitual (`ACCORD`, `UKPDS`, `Ray 2009`, `Riddle`, `liquidificador`, `A1C paradox`), grep de PMIDs (`19465231`, `18539917`, `20427682`, `21366473`, `26822326`, `31167051`).

**Descobertas criticas:**

1. **Classes `.checkpoint-*` sao COMPARTILHADAS com `12-checkpoint-2.html`** (verified: linhas 5, 8, 22 do checkpoint-2). → `.checkpoint-layout`, `.checkpoint-scenario`, `.checkpoint-question`, `.checkpoint--hidden` ficam no CSS intactas.
2. **Classes `.ck1-*` sao EXCLUSIVAS de s-checkpoint-1.** Aparecem apenas em `metanalise.css`, `slide-registry.js`, `slides/03-checkpoint-1.html` e CHANGELOGs historicos. → remocao limpa.
3. **ACCORD e legitimamente citado em `forest-plot-candidates.html` linha 351** ("9 RCTs IPD: SPRINT, ACCORD, ALLHAT...") — contexto de Stead 2023 para forest plots candidatos, NADA a ver com o checkpoint removido. → **NAO TOCAR**.
4. **Speaker note em `04-rs-vs-ma.html` linha 41** — "Âncora ACCORD: diamante = MA, quadrados = RS" — usa ACCORD como mnemonico mental para a dicotomia RS-vs-MA. Com I1 removido, esse pointer fica orfao. → **Lucas decide**: rewrite generico ou manter como mnemonico do professor.
5. **`research-accord-valgimigli.md`** — arquivo tem 3 partes: Parte 1 (ACCORD, ligado a s-checkpoint-1), Parte 2 (Ray 2009, idem), Parte 3 (Valgimigli 2025, ligado a s-ancora ativo). s-ancora.html NAO referencia esse arquivo (verificado). → **Lucas decide** entre (a) archive inteiro, (b) split (extrair Parte 3), (c) rename.

#### A1. Arquivos CANONICOS para remocao/arquivamento

| # | Arquivo | Ativo? | Acao | Linhas afetadas |
|---|---------|--------|------|-----------------|
| 1 | `content/aulas/metanalise/slides/03-checkpoint-1.html` | slide fonte | **mv → `slides/_archive/03-checkpoint-1.html`** (convencao cirrose) | arquivo inteiro (104 linhas) |
| 2 | `content/aulas/metanalise/evidence/s-checkpoint-1.html` | evidence living HTML | **mv → `evidence/_archive/s-checkpoint-1.html`** (criar dir) | arquivo inteiro (194 linhas) |
| 3 | `content/aulas/metanalise/slides/_manifest.js` | build entry | **delete linhas 19-20** (comment de arco narrativo + entrada comentada) | 2 linhas removidas |
| 4 | `content/aulas/metanalise/slide-registry.js` | animation registry | **delete bloco** `'s-checkpoint-1': (slide, gsap) => {...}` | linhas 175-232 (58 linhas) |
| 5 | `content/aulas/metanalise/metanalise.css` | CSS da aula | **delete bloco** `#s-checkpoint-1 .checkpoint-question` + `.ck1-*` + failsafes | linhas 918-1060 aprox (~142 linhas). **Preservar** `/* Checkpoint: multi-step reveal (checkpoint-2) */` que vem depois. |
| 6 | `content/aulas/metanalise/qa-screenshots/s-checkpoint-1/` | QA output (gitignored) | **rm -r** (Lucas aprovou explicitamente — S153 msg 2026-04-11). Gitignored, fora de `.claude/workers/`, sem guard trigger. | 2 PNGs |
| 7 | `content/aulas/metanalise/references/research-accord-valgimigli.md` | research briefing | **mv → `references/_archived/research-accord-valgimigli.md`** (Lucas aprovou archive inteiro). s-ancora.html nao referencia esse arquivo, nada quebra. | arquivo inteiro |

#### A2. Arquivos de documentacao/evidencia com cross-refs ATIVAS a atualizar

| # | Arquivo | Linha | Conteudo | Acao |
|---|---------|-------|----------|------|
| 8 | `content/aulas/metanalise/CLAUDE.md` | 22 | "2. **I1 — Checkpoint** (slide 03): ACCORD trap (Ray 2009 + ACCORD 2008)" | **delete** linha (I1 nao existe mais) |
| 9 | `content/aulas/metanalise/CLAUDE.md` | 26 | "**Exceção I1:** s-checkpoint-1 usa dados reais como armadilha pedagógica." | **delete** linha + a "Regra geral" seguinte ganha sentido sozinha |
| 10 | `content/aulas/metanalise/HANDOFF.md` | 22-23 | `F2: ...` linha sem I1 (ja esta ok); linha 23 `I2: s-checkpoint-2` esta ok | **verificar** — provavelmente ja OK |
| 11 | `content/aulas/metanalise/HANDOFF.md` | 28 | "I1 (s-checkpoint-1): ARCHIVED S107." | **delete** linha (slide saiu de vez) |
| 12 | `content/aulas/metanalise/evidence/meta-narrativa.html` | 76-82 | `<div class="phase-box">` inteiro de "Interacao 1 — Checkpoint de engajamento" | **delete** bloco (5 linhas HTML) |
| 13 | `content/aulas/metanalise/evidence/meta-narrativa.html` | 205 | `Transicao → s-checkpoint-1 (ACCORD trap)` | **rewrite** para "Transicao → s-rs-vs-ma" ou "Transicao → F2 (metodologia)" |
| 14 | `content/aulas/metanalise/evidence/blueprint.html` | 87-101 | `<section id="i1">` "Interacao 1 — Checkpoint de engajamento" | **delete** secao inteira |
| 15 | `content/aulas/metanalise/evidence/s-pico.html` | 73 | "O slide 03 (checkpoint-1, ACCORD trap) revelou que o diamante pode mentir..." | **rewrite** para narrativa sem checkpoint-1 — manter conceito "diamante pode esconder heterogeneidade" via s-rs-vs-ma |
| 16 | `content/aulas/metanalise/evidence/s-rs-vs-ma.html` | 73 | "O slide 03 (checkpoint-1, ACCORD trap) revelou..." | **rewrite** (mesmo criterio) |
| 17 | `content/aulas/metanalise/evidence/s-rs-vs-ma.html` | 193 | "**Tensao anterior:** O slide 03 (checkpoint-1, ACCORD trap)..." | **rewrite** |
| 18 | `content/aulas/metanalise/slides/04-rs-vs-ma.html` | 41 | Speaker note: "Âncora ACCORD: diamante = MA, quadrados = RS" | **rewrite generico** (Lucas aprovou). Proposta: "Analogia: diamante = sumario da MA, quadrados = estudos individuais da RS." |

#### A3. NAO TOCAR (historico / via negativa / aula diferente)

| Arquivo | Motivo |
|---------|--------|
| `HANDOFF.md` (raiz) | Historico de sessao S152 — append-only |
| `CHANGELOG.md` (raiz) | Append-only |
| `.claude/rules/known-bad-patterns.md` (KBP-13) | Cita s-checkpoint-1 como evidencia historica de drift — via negativa, preservar |
| `.claude/skills/insights/references/latest-report.md` | Report historico S151 |
| `docs/pmid-verification-S151.md` | Audit historico |
| `docs/evidence-html-audit-S150.md` | Audit historico |
| `.claude/plans/magical-growing-harbor.md`, `nested-wibbling-pearl.md`, `resilient-napping-willow.md`, `purrfect-spinning-barto.md` | Plans antigos — ja em fila de triage (Scope B) |
| `content/aulas/metanalise/CHANGELOG.md` | Append-only |
| `content/aulas/metanalise/ERROR-LOG.md` | Append-only |
| `content/aulas/metanalise/evidence/research-gaps-report.md` | Historico |
| `content/aulas/metanalise/evidence/cowork-evidence-harvest-S112.md` | Historico S112 |
| `content/aulas/metanalise/evidence/forest-plot-candidates.html` | ACCORD ali = Stead 2023 IPD, NAO checkpoint (A0 descoberta 3) |
| `content/aulas/metanalise/references/_archived/archetypes.md` | Ja arquivado |
| `content/aulas/cirrose/slides/_archive/14-cp2.html`, `18-cp3.html` | Aula diferente (cirrose), irrelevante |
| `content/aulas/grade/archetypes.css`, `content/aulas/scripts/qa-capture.mjs` | Matches foram para classes `.checkpoint-*` compartilhadas — nao especifico |

#### A4. Ordem de execucao sugerida

1. **Criar dirs de arquivo**: `mkdir -p slides/_archive evidence/_archive` (metanalise).
2. **Git mv arquivos** (preserva historia): `slides/03-checkpoint-1.html` e `evidence/s-checkpoint-1.html`.
3. **Edit `_manifest.js`** — remove linhas 19-20.
4. **Edit `slide-registry.js`** — remove factory 175-232.
5. **Edit `metanalise.css`** — remove bloco 918-1060 (nao tocar checkpoint-2 a seguir).
6. **Edit cross-refs** (CLAUDE.md, HANDOFF.md, meta-narrativa.html, blueprint.html, s-pico.html, s-rs-vs-ma.html) — rewrites narrativos.
7. **Lint** `npm run lint:slides metanalise` + **Build** `npm run build:metanalise` → espera PASS.
8. **Grep final** — verificar que `s-checkpoint-1`, `checkpoint-1`, `ck1-`, `liquidificador`, `Ray 2009`, `Riddle`, `UKPDS`, `A1C paradox` nao aparecem mais em `content/aulas/metanalise/**` fora de `_archive/`, `CHANGELOG.md`, `ERROR-LOG.md`, `cowork-evidence-harvest-S112.md` e `research-gaps-report.md`. Items em `qa-screenshots/s-checkpoint-1/` conforme decisao A1#6.
9. **Commit**: `S153: remove s-checkpoint-1 — slide e todas cross-refs ativas arquivadas`.

---

### Scope B — Orphan plans triage (HANDOFF P0, 18 arquivos)

#### B1. Estrategia (KBP-10 hard constraint)

- **Per-file**, NUNCA batch. Lucas aprova arquivo-por-arquivo.
- Criar `.claude/plans/archive/` (ainda nao existe — verificado).
- Convencao de nome: `S<NNN>-<original-name>.md` (prefixo = sessao em que foi consumido, per session-hygiene.md §Artifact cleanup).
- Default = `keep` (move to archive). Alternativa = deixar em `.claude/plans/`. Nunca delete sem pedido explicito.

#### B2. Fila (18 arquivos, ver HANDOFF S152 §P0)

| # | Plan file | Sessao provavel | Proposta |
|---|-----------|-----------------|----------|
| 1 | cached-snuggling-donut.md | ? | archive S???- |
| 2 | compiled-sleeping-raven-agent-a97482049cefea20a.md | S142 | archive S142- |
| 3 | compiled-sleeping-raven.md | ? | archive |
| 4 | dazzling-skipping-koala.md | ~S141 | archive S141- |
| 5 | deep-mixing-badger.md | S135 | archive S135- |
| 6 | floating-gathering-starfish.md | ? | archive |
| 7 | greedy-toasting-quasar.md | S138 | archive S138- |
| 8 | idempotent-orbiting-hinton.md | ~S149 | archive S149- |
| 9 | magical-growing-harbor.md | S151 | archive S151- |
| 10 | nested-wibbling-pearl.md | S150 | archive S150- |
| 11 | precious-inventing-petal.md | S137 | archive S137- |
| 12 | purrfect-spinning-barto.md | ? | archive |
| 13 | resilient-napping-willow.md | ~S147-148 | archive S147- |
| 14 | steady-snuggling-hammock.md | ? | archive |
| 15 | ticklish-booping-lemon.md | ? | archive |
| 16 | tingly-crafting-codd.md | S136 | archive S136- |
| 17 | transient-coalescing-balloon.md | ? | archive |
| 18 | vast-shimmying-toast.md | S145 | archive S145- |

Plans com sessao "?" → abrir o arquivo, ler o header/primeira section, Lucas confirma sessao antes de renomear.

**Este plano (`sunny-plotting-fountain.md`)** fica vivo durante a sessao; ao wrap ele mesmo entra como archive S153-.

---

### Scope C — P005 quick win: research/SKILL.md Step 2 ganha coluna `type`

#### C1. Origem

`/insights` S151 backlog item P005. HANDOFF §P3 item 3 descreve como "Rapido (2 min) mas espera sessao infra". Ja foi planejado e validado conceitualmente no /insights report. Proposta esta em `.claude/skills/insights/references/latest-report.md`.

#### C2. Mudanca

`research/SKILL.md` Step 2 tabela de referencias ganha coluna `type` com valores: `paper` | `book` | `guideline` | `preprint` | `web` + fallback ID (`PMID` para paper, `ISBN` para book, `DOI` para guideline/preprint, `URL` para web).

#### C3. Por que importa

Hoje, o workflow assume que toda referencia e paper. Quando uma referencia e book ou guideline, o agente tenta extrair PMID e falha — ou fabrica. Coluna `type` + fallback ID forca o agente a declarar o tipo antes de tentar PMID lookup.

Arquivo-alvo: `.claude/skills/research/SKILL.md` (verificar localizacao exata — pode estar em `.claude/skills/research-skill/` ou similar).

---

### Scope D — Deferrals (NAO executar nesta sessao — mas persistir no BACKLOG)

**Lucas constraint**: deferrals nao podem ficar perdidos. Devem estar capturados em `HANDOFF.md §BACKLOG` (canal persistente de self-improvement) ao fim da sessao.

| # | Item | Destino BACKLOG |
|---|------|----------------|
| D1 | **Hook/config system review** — YAGNI audit JSON → TOML/YAML/text para configs + `.jsonl` para logs. Requer design session dedicada. | **Ja esta** em `HANDOFF.md §BACKLOG #3` ("Lucas flagged S152"). Verificar continua la no wrap. |
| D2 | **Hook audit re-sweep** — so relevante se novos hooks foram adicionados desde S152. Verificacao: `git log --since='S152' -- hooks/ .claude/hooks/`. Se vazio, **drop** (nao e trabalho persistente). Se nao-vazio, adicionar como novo item BACKLOG. | Check condicional no wrap. |
| D3 | **P006 pre-flight tool availability** — proposta original invalida (hooks nao chamam ToolSearch); precisa re-design. | **Ja esta** em `HANDOFF.md §BACKLOG #8`. Verificar continua la no wrap. |

#### BACKLOG sync obrigatorio no wrap (checklist)

- [ ] `HANDOFF.md §BACKLOG #3` (hook/config review) — confirmar presenca
- [ ] `HANDOFF.md §BACKLOG #7` (P005 reference-type) — **remover** (completado em Scope C)
- [ ] `HANDOFF.md §BACKLOG #8` (P006 pre-flight) — confirmar presenca + atualizar detalhe se re-design amadureceu
- [ ] Scope D2 (re-sweep) — se aplicavel, adicionar como novo item
- [ ] Renumerar items restantes para manter sequencia

Fonte do protocolo: `.claude/rules/session-hygiene.md` (HANDOFF = pendencias futuras) + `CLAUDE.md §Self-Improvement` (BACKLOG = canal persistente de trabalho diferido).

---

## Sequencia de execucao do S153

1. **Scope C (P005 quick win)** — 2 min, isolado, commit separado.
2. **Scope A (s-checkpoint-1 removal)** — maior chunk, commit dedicado, validar build.
3. **Scope B (orphan plans triage)** — por arquivo com aprovacao Lucas, commit bundled no fim.
4. **Wrap** — HANDOFF atualizado (proximo foco = slides forest plot), CHANGELOG S153 entry, este plano → `.claude/plans/archive/S153-sunny-plotting-fountain.md`.

---

## Verification

### Scope A — gates mecanicos

- `npm run lint:slides metanalise` PASS
- `npm run build:metanalise` PASS + `content/aulas/metanalise/index.html` gerado sem `s-checkpoint-1`
- `grep -r "s-checkpoint-1" content/aulas/metanalise/` retorna apenas `slides/_archive/`, `evidence/_archive/`, `CHANGELOG.md`, `ERROR-LOG.md`, `research-gaps-report.md`, `cowork-evidence-harvest-S112.md` (historico)
- `grep -r "ck1-" content/aulas/metanalise/` retorna zero hits fora de `_archive/` e `CHANGELOG.md`
- `grep -r "liquidificador\|Ray 2009\|Riddle\|UKPDS.*ADVANCE.*VADT\|A1C paradox" content/aulas/metanalise/` retorna zero hits fora de `_archive/` e historicos
- Smoke visual: abrir `content/aulas/metanalise/index.html` no browser, confirmar 15 slides, confirmar checkpoint-2 animacao intacta (ela compartilha `.checkpoint-scenario/.checkpoint-question/.checkpoint-layout/.checkpoint--hidden`).

### Scope B

- `.claude/plans/archive/` existe e contem ate 18 arquivos com prefixo `SXXX-`
- `.claude/plans/*.md` (nao-archive) contem apenas este plano ativo (`sunny-plotting-fountain.md`) durante a sessao, depois archive tambem

### Scope C

- `research/SKILL.md` Step 2 tabela tem coluna `type` + instrucao de fallback ID
- Exemplo inline mostrando as 5 linhagens (paper/book/guideline/preprint/web)

---

## Critical files (refs)

- `content/aulas/metanalise/slides/03-checkpoint-1.html` (A1#1)
- `content/aulas/metanalise/slides/_manifest.js:19-20` (A1#3)
- `content/aulas/metanalise/slide-registry.js:175-232` (A1#4)
- `content/aulas/metanalise/metanalise.css:918-1060` (A1#5)
- `content/aulas/metanalise/evidence/s-checkpoint-1.html` (A1#2)
- `content/aulas/metanalise/evidence/meta-narrativa.html:76-82,205` (A2#12,13)
- `content/aulas/metanalise/evidence/blueprint.html:87-101` (A2#14)
- `content/aulas/metanalise/evidence/s-pico.html:73` (A2#15)
- `content/aulas/metanalise/evidence/s-rs-vs-ma.html:73,193` (A2#16,17)
- `content/aulas/metanalise/slides/04-rs-vs-ma.html:41` (A2#18 — decisao Lucas)
- `content/aulas/metanalise/CLAUDE.md:22,26` (A2#8,9)
- `content/aulas/metanalise/HANDOFF.md:28` (A2#11)
- `.claude/skills/insights/references/latest-report.md` (C — referencia de proposta P005)

## Decisoes resolvidas (pre-plano)

1. **Scope INFRA_LEVE** = Scope A (s-checkpoint-1 removal) + Scope B (orphan plans triage) + Scope C (P005 quick win). Scope D deferrals sincronizados no BACKLOG. ✓ Lucas aprovou.
2. **QA screenshots** = `rm -r qa-screenshots/s-checkpoint-1/` (gitignored, sem guard trigger, Lucas aprovou explicitamente). ✓
3. **`research-accord-valgimigli.md`** = archive inteiro → `references/_archived/`. ✓
4. **Speaker note `04-rs-vs-ma.html:41`** = rewrite generico (sem ACCORD). Proposta: "Analogia: diamante = sumario da MA, quadrados = estudos individuais da RS." ✓
