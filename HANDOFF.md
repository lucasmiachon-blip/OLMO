# HANDOFF - Proxima Sessao

> Sessao 85 | 2026-04-06
> Cross-ref: `BACKLOG.md` | `docs/research/implementation-plan-S82.md`

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Lint clean. Build OK (18 slides metanalise).
**Agentes: 8** (todos com model routing). **Hooks: 18** (+lint-on-edit, +cost-circuit-breaker S85). **Rules: 10**. MCPs: 12 connected.
S85: Tier 2 concluido — lint-on-edit (L5), circuit breaker (L3), quality-gate descongelado, /insights JSON.

## PROXIMOS PASSOS (Tier 2 restante + Tier 3)

| # | Item | Impacto | Complexidade |
|---|------|---------|--------------|
| 2A | OTel + Langfuse self-host | OBSERVABILITY real | Docker Desktop (instalar primeiro) |
| 2C | Model fallback chain (Opus → Sonnet → Haiku) | ANTIFRAGILE L2 | config + hook |
| 3A | NeoSigma failure registry JSON | Constrained optimization | depende /insights JSON (feito) |
| 3B | Memory temporal invalidation (TTL) | Fatos nao ficam stale | memory files frontmatter |

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

| Agente | Model | maxTurns | Memory | Status |
|--------|-------|----------|--------|--------|
| evidence-researcher | sonnet ✓ | — | project ✓ | OK |
| qa-engineer | sonnet ✓ | 12 | project ✓ NEW | OK |
| mbe-evaluator | sonnet ✓ | 15 | — | OK (FROZEN ate aula completa) |
| reference-checker | haiku ✓ NEW | 15 | project ✓ NEW | OK |
| quality-gate | haiku ✓ | 10 | — | OK (JS/CSS lint adicionado S85) |
| researcher | haiku ✓ | 15 | — | OK |
| repo-janitor | haiku ✓ | 12 | — | OK |
| notion-ops | haiku ✓ NEW | 10 | — | OK |

## HOOKS (16 total)

| Hook | Evento | Funcao |
|------|--------|--------|
| **pre-compact-checkpoint** | **PreCompact ✓ NEW** | **Grava estado antes de compaction (timing correto)** |
| stop-crossref-check | Stop | Warning se cross-ref quebrado |
| stop-detect-issues | Stop | Persiste issues em pending-fixes.md |
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
| crossref-precommit | pre-commit (git) | BLOQUEIA commit se cross-ref quebrado |
| build-monitor | PostToolUse(Bash) | Monitora output de build |

## DECISOES ATIVAS

- **Values: Antifragile + Curiosidade** — decision gates, nao decoracao.
- **Living HTML per slide = source of truth.** evidence-db.md deprecated.
- **CLAUDE.md cascata:** root (85 linhas) → content/aulas/ → metanalise/.
- **Cross-ref: dual gate** — stop hook (advisory) + pre-commit (blocking).
- **Self-healing loop:** stop-detect → pending-fixes → session-start surfacea.
- **Known-bad-patterns (Via Negativa):** 5 KBPs, alimentado por /insights.
- Agentes: max 2, Lucas dita, scripts existentes, 1 slide por vez.
- Memory governance: cap 20 files (17 atual). Next review: S85.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — rodar build apos editar _manifest.js.
- **CSS per-slide: `section#s-{id}`** — specificity 0,1,1,1.
- PMIDs de LLM: ~56% erro. SEMPRE verificar.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + claude-4.6-sonnet-medium-thinking (Cursor) | S84-S85 2026-04-06
