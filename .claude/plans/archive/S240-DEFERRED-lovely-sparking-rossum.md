# Plan S240 — Retomo aula metanalise + melhoria iterativa de tooling + shared-v2 gradual

## Context

Lucas pivotou de C5 shared-v2 (deck.js/presenter-safe/dialog/ensaio HDMI — commits S239 `9da4f30` + partial) para retomar QA editorial da aula metanalise. Deadline 30/abr/2026 (T-8d) agora reinterpretado: **metanalise é o produto P0 real**, shared-v2 vira infraestrutura de suporte que será incorporada "aos poucos".

Três intenções combinadas (respostas de Lucas):
1. **Melhorar metanalise** (primário — 14 slides pendentes de QA, 5 slides com scores R11 abaixo do threshold 7).
2. **Incorporar shared-v2 aos poucos** (não big-bang — oportunista: quando QA revela gap, trocar primitivo para v2).
3. **Scripts/agents/subagents como SOTA** — não construir qa-pipeline v2 greenfield (C7) nem rodar gemini-qa3.mjs pristine. Iterar: cada slide ensina uma melhoria ao tooling que vale para o próximo.

## Estado factual metanalise (pós-exploration)

**Deck:** `_manifest.js` lista **17 slides** (S207), não 16 como HANDOFF afirmava. Arquivos:
`00-title, 00b-objetivos, 01-hook, 02-importancia, 04-rs-vs-ma, 05-quality, 02-contrato, 04-pico, 08a-forest1, 08b-forest2, 08c-rob2, 11a-pubbias1, 11b-pubbias2, 09a-heterogeneity, 10-fixed-random, 14-etd, 18-contrato-final`

**Orphans (filesystem, fora do manifest):**
- `17-takehome.html` (removido S207)
- `09b-i2.html`
- `_archive/03-checkpoint-1.html` (intencional)

**QA rounds state (R11 = estado corrente):**

| Slide | Score R11 | Editorial? | Status HANDOFF |
|---|---|---|---|
| s-title | — | — | DONE |
| s-hook | — | — | DONE |
| s-contrato | 5.7 | NO | DONE (inconsistente — 5.7 < threshold 7) |
| s-objetivos | **2.8** | YES | QA (preflight pendente) |
| s-importancia | **5.2** | NO | LINT-PASS |
| s-forest1 | **5.6** | NO | LINT-PASS |
| s-rob2 | 6.5 | NO | LINT-PASS |
| s-pico | 7.3 | YES | LINT-PASS |
| s-forest2 | 7.4 | YES | LINT-PASS |
| s-takehome | 7.9 | NO | órfão (fora do deck) |
| 10 slides | — | — | nunca iniciado QA |

**Inconsistência a resolver:** s-contrato marcado DONE mas R11=5.7 e sem editorial — reabrir ou aceitar? Lucas decide.

**CSS @import risk:** `metanalise.css` não tem o padrão que causou bug projetor em shared-v2 (nenhum `@font-face` antes de `@import` — não há nenhum @import/font-face no arquivo top-30).

**Missing assets:** zero `[TBD]` / `[CANDIDATE]` em slides ou evidence ativos. Não há blocker de dados.

**ERROR-LOG ativos (candidatos a "pendência para main"):** ERRO-002 (aside.notes → mover para shared), ERRO-004 (vite.config hardcoded open path), ERRO-005 (justify-content override frágil), ERRO-006 (checkpoint layout frágil).

## Abordagem: três loops sobrepostos

Em vez de sequência linear "QA slide → próximo slide", estabelecer três loops que cada slide toca:

### Loop A — QA per slide (Lucas decide slide, pipeline fixo)

Pipeline unitário por slide (alinhado `qa-pipeline.md`):

```
1. Lucas escolhe slide
2. Preflight ($0) — dims objetivas: token compliance, h2 asserção, fonts Tier1, APCA, vw/vh, E07
3. [Lucas OK]
4. gemini-qa3.mjs --inspect (Flash)
5. [Lucas OK + patch]
6. gemini-qa3.mjs --editorial (Pro)
7. [Lucas OK + patch final]
8. Commit slide + update metanalise/HANDOFF.md linha do slide
```

**Granularidade:** 1 slide = 1 commit = 1 entrada CHANGELOG. NUNCA batch (qa-pipeline.md §1).

### Loop B — Melhoria iterativa de tooling (SOTA incremental)

Depois de cada slide QA'do, extrair 1 aprendizado que melhora tooling para próximo slide. Canais:

- `scripts/gemini-qa3.mjs` — adicionar checks preflight que se repetiram como findings manuais
- `.claude/agents/qa-engineer.md` — refinar rubric/penalização quando agent errou magnitude
- `.claude/agents/evidence-researcher.md` — adicionar MCP novo ou padronizar prompt quando pesquisa PMID falhou
- `content/aulas/metanalise/docs/prompts/*.md` — versionar prompts que funcionaram

**Invariante:** nenhuma melhoria de tooling é tentada em greenfield. Só quando slide concreto expôs gap.

**Anti-SOTA guard:** ≤30% do budget da sessão em meta-work. Se tooling improvement exceder, adiar para próxima sessão — slide delivery > infra polish.

### Loop C — Incorporação shared-v2 aos poucos (oportunista)

Quando slide revela deficiência resolvível por primitivo shared-v2, fazer bridge cirúrgico:

| Se slide revela... | Candidato v2 | Risco |
|---|---|---|
| APCA contrast fail em texto | `--text-emphasis` (S239 C4.6 fix) | BAIXO — 1 variable swap |
| Raw px em font-size | `shared-v2/type/scale.css` fluid | MÉDIO — cascade review |
| GSAP inline / data-animate scrappy | `shared-v2/js/reveal.js` + `motion/transitions.css` | ALTO — requires mock port first |
| Projector legibility | `shared-v2/js/presenter-safe.js` (após C5 close) | ALTO — depende C5 done |
| Dark-bg contrast gap (4 slides) | OKLCH neutral-6/7 recalibrados S239 | BAIXO |

**Regra:** Cada incorporação v2 = commit separado, revertível. NUNCA dentro do commit de QA do slide.

**Deferido explicitamente:** port total de metanalise para shared-v2 (big-bang migration) — só pós-30/abr.

## Propostas de decisão (Lucas valida via ExitPlanMode)

1. **Session name:** `metanalise-SOTA-loop` (S240).
2. **Reabrir s-contrato** (score R11=5.7, marcado DONE sem editorial): DOWNGRADE para LINT-PASS + rodar editorial. Inconsistência silenciosa é risco.
3. **Orphans:** manter `17-takehome.html` e `09b-i2.html` no filesystem (não deletar — Lucas pode decidir re-incluir). Adicionar ao `metanalise/HANDOFF.md` seção "Orphans intencionais" para não parecerem perdidos.
4. **Shared-v2 bridge primeiro toque:** quando o 1º slide escolhido tiver APCA fail em texto, aplicar swap `text-body → text-emphasis` (precedente S239 C4.6). Se não tiver, aguardar próximo.

## Critical files

**Ler antes de cada slide:**
- `content/aulas/metanalise/slides/{id}.html` (slide em si)
- `content/aulas/metanalise/evidence/s-{id}.html` (evidence living HTML)
- `content/aulas/metanalise/qa-screenshots/{id}/gemini-qa3-r11.md` (se existir, rubric R11)
- `content/aulas/metanalise/qa-screenshots/{id}/editorial-suggestions.md` (se existir)

**Editar durante QA (escopo slide):**
- `content/aulas/metanalise/slides/{id}.html` (fix patches)
- `content/aulas/metanalise/metanalise.css` (scoped `section#s-{id}`)
- `content/aulas/metanalise/HANDOFF.md` (linha do slide: LINT-PASS → QA → DONE)
- `content/aulas/metanalise/CHANGELOG.md` (append 1 linha)

**Editar durante Loop B (tooling):**
- `content/aulas/scripts/gemini-qa3.mjs` (rare — only when preflight gap found)
- `.claude/agents/qa-engineer.md` (rubric refinement)
- `content/aulas/metanalise/docs/prompts/*.md` (prompt versioning)

**Editar durante Loop C (shared-v2 bridge):**
- `content/aulas/metanalise/metanalise.css` (token swaps scoped)
- Nunca: `content/aulas/shared/css/base.css` (shared v1 é estável, não tocar)
- Nunca: `content/aulas/shared-v2/**` (v2 é separado, não editar daqui)

## Verification per slide

1. **Preflight PASS:** dims objetivas $0 passam (h2 = asserção, 0 vw/vh em font-size, tokens em todos os valores, fonts Tier1).
2. **Build PASS:** `npm run build:metanalise` (gera `index.html` do manifest).
3. **Lint PASS:** `npm run lint:slides` + `lint-case-sync`.
4. **Visual:** `npm run dev:metanalise` (porta 4102) + screenshot manual via `qa-capture.mjs`.
5. **Inspect score ≥ 7:** R11 < 7 → rework antes de editorial.
6. **Editorial PASS:** Lucas approved (subjetivo — sem threshold numérico).
7. **HANDOFF updated:** linha do slide em `metanalise/HANDOFF.md` reflete estado final.

## Deferred (explícito — não tocar em S240)

- C5 shared-v2 completion (deck.js + presenter-safe + dialog + ensaio HDMI) — pausado até slide metanalise expor necessidade concreta de presenter-safe.
- C6 grade-v2 scaffold — pós-30/abr.
- C7 qa-pipeline v2 greenfield — substituído por Loop B (evolução gemini-qa3.mjs).
- P1 R3 infra + Anki — pós-30/abr.
- Port completo metanalise → shared-v2 — big-bang proibido, só pós-30/abr.
- Reabrir slide-rule E22 (@import order lint) — ciclo separado.

## Out of scope deste plano

- Ordem específica dos slides (Lucas decide slide-a-slide).
- Meta-work além de 30% do budget (Loop B).
- Editar shared v1 (`content/aulas/shared/`) ou shared-v2 (`content/aulas/shared-v2/`) — só metanalise/.

## Primeiro micro-ciclo (após aprovação)

1. Lucas diz qual slide começar.
2. Eu leio slide.html + evidence + R11 rubric (se existir) + editorial (se existir).
3. Rodo preflight manual (dims objetivas) — reporto findings.
4. Lucas OK → rodamos gemini-qa3.mjs --inspect.
5. Primeiro ciclo encerra quando primeiro slide estiver em QA→DONE OU Lucas pedir outro slide.

---

Coautoria: Lucas + Opus 4.7 (Claude Code) | S240 metanalise-SOTA-loop plan | 2026-04-23
