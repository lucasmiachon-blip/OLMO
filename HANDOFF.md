# HANDOFF - Proxima Sessao

> Sessao 211 | Fases 1+2 completas. Fase 3 pendente.

## ESTADO ATUAL

Monorepo funcional. Build PASS (**17 slides** metanalise).
**Rules: 5 files, 199 li.** **Hooks: 29+2 shell scripts (8/27 eventos, `command` type, 6 async, 4 `if` guards).** **Permissions: 38.**
**Memory: 21/20 (over cap).** Agentes: 10. MCPs: 3+9. KBPs: 21. Skills: 22+3. Backlog: 33 (7 resolved).
**Strict mode: 29/29 scripts com `set -euo pipefail`** (2 libs sourced herdam do chamador). Paths portaveis via `$CLAUDE_PROJECT_DIR`.

## PLANO ATIVO: `.claude/plans/hashed-zooming-bonbon.md`

### Fase 0 ✅ COMPLETA (S210)
- Settings env vars aplicados. Commit: `2c2f52c`.

### Fase 1 ✅ COMPLETA (S211)
- `pre-compact-checkpoint.sh`: +4 secoes cognitivas (HANDOFF header, plano ativo, plan files recentes, pending-fixes)
- `post-compact-reread.sh:15`: JSON hand-assembly → `jq -cn --arg` (vuln fix)
- `retry-utils.sh:28`: `eval "$cmd"` → array execution `"${cmd_args[@]}"` (vuln fix) + 2 chamadores atualizados
- Regra KBP-17 item 4 + context-essentials item 7: pesquisa de agente → plan file ANTES de reportar

### Fase 2 ✅ COMPLETA (S211)
- `$CLAUDE_PROJECT_DIR`: 30 command strings migradas em `settings.local.json` (2 permissions mantidas hardcoded)
- `async: true`: 6 hooks fire-and-forget (stop-metrics, stop-notify, stop-should-dream, chaos-inject-post, model-fallback-advisory, notify)
- `if` conditions: guard-bash-write (destructive ops) + guard-research-queries (research/evidence skills)
- `set -euo pipefail`: 29/29 scripts standalone (26 added, 3 upgraded de `set -u`); 2 libs sourced sem pipefail (herdam do chamador) + 15 hazard fixes preventivos

### Fase 3: Hooks seguranca + consolidacao (PENDENTE — ~2h)
1. Prompt hook Stop — Trail of Bits anti-rationalizacao pattern (Haiku, $0 no Max)
2. Consolidar PreToolUse — 9→5 entries
(eval + JSON vulns resolved em Fase 1)

### Fase 4: Memoria — avaliar com dados (PENDENTE — sessao separada)
- Avaliar em ordem: claude-memory-compiler → ByteRover CLI → nenhum

## P0 — Pendentes Anteriores

- s-quality: evidence HTML integration + narrativa pendente
- s-tipos-ma: slide PENDENTE (Lucas decide quantos, posicao, h2)
- drive-package: PDF stale, PNG export pendente

## P1

- Wallace CSS-wide: 29 font-sizes raw, #162032 sem token, 20 !important
- TREE.md desatualizado (S93 → S212)
- Sentinel agent improvement (backlog #31)

## DECISOES ATIVAS

- Gemini QA temp: 1.0, topP 0.95. OKLCH obrigatorio.
- Living HTML = source of truth. Agent effort: max.
- CMMI maturity model. Hooks = freio (L2). Verification loops = melhoria (L3+).
- Settings: effort=max, adaptive_thinking=off, subagent=sonnet, 1M=off (perguntar no start).
- Memoria: sistema atual cobre 80% (Lord 2026). Avaliar claude-memory-compiler antes de adicionar infra.

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro.
- npm scripts: rodar de `content/aulas/`. h2 = trabalho do Lucas.
- NUNCA colocar `ANTHROPIC_API_KEY` no env (bypassa Max, cobra API direto).
- Pesquisa de agente: SEMPRE persistir em plan file ANTES de reportar.

---
Coautoria: Lucas + Opus 4.6 | S211 2026-04-16
