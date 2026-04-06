# HANDOFF - Proxima Sessao

> Sessao 83 | 2026-04-06
> Cross-ref: `BACKLOG.md` | `docs/research/implementation-plan-S82.md`

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Lint clean (v6). Build OK (19 slides metanalise).
**Agentes: 8** (todos OK). **Hooks: 13** (4 novos S82). MCPs: 12 connected + 3 planned.
S82 INFRA: 5 quick wins implementados, 3 pesquisas completas, plano de implementacao compilado.

## PROXIMOS PASSOS (do implementation plan)

| # | Item | Impacto | Tempo |
|---|------|---------|-------|
| 5 | ifttt-lint (cross-ref deterministico) | MUITO ALTO | 1-2h |
| 6 | Known-bad-patterns registry | ALTO | 20 min |
| 7 | Self-healing loop skeleton | ALTO | 30 min |
| 0 | OTel env vars (observability) | FUNDAMENTAL | 5 min |
| 16 | content/aulas/CLAUDE.md compartilhado | MEDIO | 10 min |

Plano completo: `docs/research/implementation-plan-S82.md`

## PESQUISAS COMPLETAS (S82)

| Pesquisa | Arquivo | Linhas |
|----------|---------|--------|
| Anti-drift tools | `docs/research/anti-drift-tools-2026.md` | 449 |
| Self-improvement tools | `docs/research/agent-self-improvement-2026.md` | 811 |
| CLAUDE.md best practices | `docs/research/claude-md-best-practices-2026.md` | 414 |

## AGENTES

| Agente | Status |
|--------|--------|
| evidence-researcher | OK |
| qa-engineer | OK |
| mbe-evaluator | OK (FROZEN ate aula completa) |
| reference-checker | OK |
| quality-gate | **FROZEN: falta JS/CSS lint scripts** (ver BACKLOG) |
| researcher | OK |
| repo-janitor | OK |
| notion-ops | OK |

## HOOKS (13 total, 4 novos S82)

| Hook | Evento | Funcao |
|------|--------|--------|
| pre-compact-checkpoint | Stop | Grava git status + arquivos recentes **NOVO** |
| stop-crossref-check | Stop | Warning se slide mudou sem manifest **NOVO** |
| stop-hygiene | Stop | Verifica session hygiene |
| stop-notify | Stop | Notificacao visual |
| session-start | SessionStart | Inicializacao |
| session-compact | SessionStart(compact) | Reinjecta essentials + HANDOFF + checkpoint **ATUALIZADO** |
| guard-read-secrets | PreToolUse(Read) | Bloqueia leitura de secrets |
| guard-pause | PreToolUse(Write/Edit) | Pausa antes de escrever |
| guard-generated | PreToolUse(Write/Edit) | Protege arquivos gerados |
| guard-product-files | PreToolUse(Write/Edit) | Protege arquivos de produto |
| guard-secrets | PreToolUse(Bash) | Bloqueia secrets em bash |
| guard-bash-write | PreToolUse(Bash) | Protege escrita via bash |
| guard-lint-before-build | PreToolUse(Bash) | Lint antes de build |

## DECISOES ATIVAS

- **Living HTML per slide = source of truth.** evidence-db.md deprecated.
- **Gemini: so API/CLI, NAO MCP** (descartado S71).
- deck.js le DOM, nao manifest em runtime. index.html gerado pelo build.
- Agentes: max 2, Lucas dita, scripts existentes, 1 slide por vez.
- **1 gate = 1 invocacao** (hard stop via maxTurns).
- Memory governance: cap 20 files (16 atual).
- Backlog persistente em `BACKLOG.md` (separado do HANDOFF).
- **plansDirectory: `.claude/plans`** — planos sobrevivem sessoes.
- **context-essentials.md** — regras reinjectadas pos-compaction.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — rodar build-html.ps1 apos editar _manifest.js.
- **Editar slide = AMBOS arquivos** — slides/{file}.html + index.html.
- **CSS per-slide: `section#s-{id}`** — specificity 0,1,1,1.
- PMIDs de LLM: ~56% erro. SEMPRE verificar.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-06
