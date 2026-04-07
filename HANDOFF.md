# HANDOFF - Proxima Sessao

> Sessao 101 | 2026-04-07
> Cross-ref: `.claude/plans/generic-sauteeing-sunbeam.md`

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Build OK (19 slides metanalise).
**Agentes: 8** (todos com maxTurns). **Hooks: 29 registrations** (31 scripts; 2 pre-commit). **Rules: 10**. MCPs: 11.
**OTel + Langfuse V3: TRACES FUNCIONANDO.** Docker stack hardened (untested).
**Antifragile: L1-L5 DONE, L6 BASIC (4 vetores, syntax-verified), L7 DONE.**
**APL: REFORMADO S100.** QA coverage + deadline no SessionStart. Cost brake estrutural. QA gate /new-slide.
**Momentum-brake: COMPLETO.** Arm .*, enforce sem Write/Edit exempt. Stdin protocol compliant.
**Batch 6: 20/26 resolvidos S101.** Restam 6 (3 intentional, 2 timeout tuning, 1 OK).
**Batch 7: 2/10 resolvidos S101.** B7-01=FP, B7-08=fixed. Restam 8 P2 (maioria precisa design).
**Todos hooks stdin-compliant.** Todos argv→stdin refatorados. Paths portaveis. README correto.
**Memory: 19/20.**

## PROXIMOS PASSOS

| # | Item | Impacto | Complexidade |
|---|------|---------|--------------|
| 1 | Batch 7 P2 fixes (8 items) | KBP-02/04 hooks estruturais, cost session-scope, GNU compat | Normal |
| 2 | Batch 6 residual (timeout tuning B6-22/23) | Monitorar se 15s timeout causa problemas | Facil |
| 3 | Editorial Pro s-objetivos COM video | QA slide pendente desde S98 | Facil |
| 4 | ~~Docker stack test~~ | ~~Validar Redis auth, OTel pin~~ | FROZEN |
| 5 | Slide novo metanalise (tema TBD) | Conteudo | Normal |
| 6 | ~~notion-ops write tools + gates~~ | ~~Agent hardening~~ | FROZEN |
| 7 | Chaos production test (B7-09) | Validar L2/L3/L6 chain com CHAOS_MODE=1 | Normal |

## AGENTES

| Agente | Model | maxTurns | Memory | Status |
|--------|-------|----------|--------|--------|
| evidence-researcher | sonnet | 20 | project | OK |
| qa-engineer | sonnet | 12 | project | OK |
| mbe-evaluator | sonnet | 15 | — | OK (FROZEN ate aula completa) |
| reference-checker | haiku | 15 | project | OK |
| quality-gate | haiku | 10 | — | OK |
| researcher | haiku | 15 | — | OK |
| repo-janitor | haiku | 12 | — | OK |
| notion-ops | haiku | 10 | — | P1: adicionar write tools + gates |

## DECISOES ATIVAS

- **QA pipeline S97:** Path linear 11 steps. Preflight 4 dims + loop Lucas antes de Gemini.
- **Momentum-brake S100:** 3 hooks (arm/enforce/clear). Arm em .* (TUDO). Enforce isenta Read/Grep/Glob/Ask/Plan. Write/Edit NAO isentos (double-ask aceito, B5-05).
- **Cost brake S100:** Estrutural. cost-circuit-breaker arma em 400 calls → enforce pede ask. Clear reseta ambos locks.
- **APL reformado S100:** SessionStart mostra QA coverage + deadline. Slot 0 = QA+deadline. Guard-qa-coverage.sh gate /new-slide quando <50%.
- **Values: Antifragile + Curiosidade** — decision gates.
- **Living HTML per slide = source of truth.**
- **CLAUDE.md cascata:** root → content/aulas/ → metanalise/.
- **Cross-ref: dual gate** — stop hook (advisory) + pre-commit (blocking).
- **Self-healing loop:** stop-detect → `.claude/pending-fixes.md` → session-start surfacea.
- **Known-bad-patterns:** 6 KBPs. KBP-06 = agent delegation (S100).
- **Agent delegation:** verificar tipo + output + aprovacao ANTES de lancar.
- Memory governance: cap 20 files (19 atual). /dream ran S100.
- **/insights:** ran S100 (covers S92-S99). Next: S108.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — rodar build apos editar _manifest.js.
- **CSS per-slide: `section#s-{id}`** — specificity 0,1,1,1.
- PMIDs de LLM: ~56% erro. SEMPRE verificar.
- **Docker stack:** Secrets em `.env`. Ports em 127.0.0.1. OTel pinado 0.149.0. NAO TESTADO.
- **QA visual:** Seguir path linear. NUNCA fabricar criterios (KBP-04).
- **npm scripts:** Rodar de `content/aulas/`, NAO da raiz do monorepo.
- **Agent delegation:** NUNCA fire-and-forget. Verificar tipo do agente, output capturavel, aprovacao do Lucas.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S101 2026-04-07
