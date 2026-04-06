# HANDOFF - Proxima Sessao

> Sessao 84 | 2026-04-07
> Cross-ref: `BACKLOG.md` | `docs/research/implementation-plan-S82.md`

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Lint clean. Build OK (18 slides metanalise).
**Agentes: 8** (3 sem model routing — ver Tier 1A). **Hooks: 15** (2 novos S83). **Rules: 10** (+known-bad-patterns). MCPs: 12 connected.
S83: 3 features implementadas (cross-ref pre-commit, known-bad-patterns, self-healing loop) + 2 pesquisas + cleanup + values.

## PROXIMOS PASSOS (Tier 1 do implementation plan)

| # | Item | Impacto | Tempo |
|---|------|---------|-------|
| 1A | Agent model routing (3 agentes) | ECONOMIA tokens | 15 min |
| 1B | PreCompact hook migration | CORRECAO timing | 5 min |
| 1C | Agent memory: project (qa-eng, ref-checker) | ANTIFRAGILE L7 | 10 min |
| 1D | context: fork em skills pesadas | CONTEXT PROTECTION | 10 min |
| 0 | OTel env vars (observability) | FUNDAMENTAL | 5 min |

Plano completo: `docs/research/implementation-plan-S82.md`

## PESQUISAS (S82-S83)

| Pesquisa | Arquivo | Linhas |
|----------|---------|--------|
| Anti-drift tools | `docs/research/anti-drift-tools-2026.md` | 449 |
| Self-improvement tools | `docs/research/agent-self-improvement-2026.md` | 811 |
| CLAUDE.md best practices | `docs/research/claude-md-best-practices-2026.md` | 414 |
| Memory best practices | `docs/research/memory-best-practices-2026.md` | 736 |
| Claude Code best practices | `docs/research/claude-code-best-practices-2026.md` | 1076 |

## AGENTES

| Agente | Model | maxTurns | Status |
|--------|-------|----------|--------|
| evidence-researcher | herda (→sonnet) | — (→add) | **NEEDS model routing** |
| qa-engineer | sonnet | 12 | OK |
| mbe-evaluator | sonnet | 15 | OK (FROZEN ate aula completa) |
| reference-checker | herda (→haiku) | — (→add) | **NEEDS model routing** |
| quality-gate | haiku | 10 | FROZEN: falta JS/CSS lint scripts |
| researcher | haiku | 15 | OK |
| repo-janitor | haiku | 12 | OK |
| notion-ops | sonnet (→haiku) | 10 | **NEEDS model routing** |

## HOOKS (15 total)

| Hook | Evento | Funcao |
|------|--------|--------|
| pre-compact-checkpoint | Stop (→mover p/ PreCompact) | Grava estado antes de compaction |
| stop-crossref-check | Stop | Warning se cross-ref quebrado |
| **stop-detect-issues** | **Stop** | **Persiste issues em pending-fixes.md** NEW |
| stop-hygiene | Stop | Verifica session hygiene |
| stop-notify | Stop | Notificacao visual |
| session-start | SessionStart | Inicializacao + surfacea pending-fixes |
| session-compact | SessionStart(compact) | Reinjecta essentials + HANDOFF |
| guard-read-secrets | PreToolUse(Read) | Bloqueia leitura de secrets |
| guard-pause | PreToolUse(Write/Edit) | Pausa antes de escrever |
| guard-generated | PreToolUse(Write/Edit) | Protege arquivos gerados |
| guard-product-files | PreToolUse(Write/Edit) | Protege arquivos de produto |
| guard-secrets | PreToolUse(Bash) | Bloqueia secrets em bash |
| guard-bash-write | PreToolUse(Bash) | Protege escrita via bash |
| guard-lint-before-build | PreToolUse(Bash) | Lint antes de build |
| **crossref-precommit** | **pre-commit (git)** | **BLOQUEIA commit se cross-ref quebrado** NEW |

## DECISOES ATIVAS

- **Values: Antifragile + Curiosidade** — decision gates, nao decoracao.
- **Living HTML per slide = source of truth.** evidence-db.md deprecated.
- **CLAUDE.md cascata:** root (85 linhas) → content/aulas/ → metanalise/.
- **Cross-ref: dual gate** — stop hook (advisory) + pre-commit (blocking).
- **Self-healing loop:** stop-detect → pending-fixes → session-start surfacea.
- **Known-bad-patterns (Via Negativa):** 5 KBPs, alimentado por /insights.
- Agentes: max 2, Lucas dita, scripts existentes, 1 slide por vez.
- Memory governance: cap 20 files (17 atual). Next review: S84.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — rodar build apos editar _manifest.js.
- **CSS per-slide: `section#s-{id}`** — specificity 0,1,1,1.
- PMIDs de LLM: ~56% erro. SEMPRE verificar.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-06
