# HANDOFF - Proxima Sessao

> Sessao 210 | Settings+Hooks+Memoria — plano aprovado, Fase 0 completa.

## ESTADO ATUAL

Monorepo funcional. Build PASS (**17 slides** metanalise).
**Rules: 5 files, 198 li.** **Hooks: 30 shell scripts (8/27 eventos, so `command` type).** **Permissions: 38.**
**Memory: 21/20 (over cap).** Agentes: 10. MCPs: 3+9. KBPs: 21. Skills: 22+3. Backlog: 33 (7 resolved).

## PLANO ATIVO: `.claude/plans/hashed-zooming-bonbon.md`

Plano baseado em **6 agentes de pesquisa** (hooks audit, memory state, memory solutions 2026, hooks state-of-art 2026, claude-mem triangulacao, settings community research). Todas as fontes verificadas e persistidas.

### Fase 0 ✅ COMPLETA (S210)
- Settings env vars aplicados em `.claude/settings.local.json` (efeito proxima sessao):
  - `CLAUDE_CODE_EFFORT_LEVEL=max` (bug: JSON key silenciosamente falha, so env var persiste)
  - `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` (previne zero-think turns → halucinacoes)
  - `CLAUDE_CODE_SUBAGENT_MODEL=claude-sonnet-4-6` (Sonnet default, Opus via frontmatter)
  - `CLAUDE_CODE_DISABLE_1M_CONTEXT=1` (desabilitado default, perguntar no session-start)
  - `autoMemoryEnabled: false` (OLMO usa sistema manual curado)
  - `alwaysThinkingEnabled: true`
- Commit: `2c2f52c` — 9 arquivos, toda pesquisa persistida em plan files
- Momentum brake fix: WebFetch/WebSearch/Task* isentos

### Fase 1: Anti-perda (PENDENTE — ~1h)
1. Melhorar `pre-compact-checkpoint.sh` — salvar resumo de agentes recentes
2. Corrigir vuln `post-compact-reread.sh:15` (JSON hand-assembly → jq)
3. Regra: pesquisa de agente sempre persistida em plan file ANTES de reportar
4. Avaliar `claude-memory-compiler` (coleam00) — /dream automatizado, Karpathy pattern

### Fase 2: Hooks mecanicos — zero risco, ROI maximo (PENDENTE — ~70 min)
1. `async: true` em hooks nao-bloqueantes (5 min) — stop-metrics, stop-notify, chaos-inject-post, model-fallback-advisory
2. `$CLAUDE_PROJECT_DIR` em settings.local.json (15 min) — 29 paths hardcoded → portavel
3. `set -euo pipefail` nos 28 scripts sem protecao (30 min)
4. `if` conditions em PreToolUse (20 min) — guard-bash-write, guard-research-queries

### Fase 3: Hooks seguranca + consolidacao (PENDENTE — ~2-3h)
1. Fix eval injection — `retry-utils.sh:28` (`eval "$cmd"` → array execution)
2. Fix JSON hand-assembly — `post-compact-reread.sh:15` (→ jq)
3. Prompt hook Stop — Trail of Bits anti-rationalizacao pattern (Haiku, $0 no Max)
4. Consolidar PreToolUse — 9→5 entries

### Fase 4: Memoria — avaliar com dados (PENDENTE — ~2h, pode ser sessao separada)
- Avaliar em ordem: claude-memory-compiler → ByteRover CLI → nenhum
- NAO instalar: Mem0 (cloud, dados medicos), claude-mem (pesado, API key risk), Graphiti (overkill)
- Jamie Lord 2026: <500 artigos, LLM index > vector search. OLMO tem 20.

## PESQUISA S210 — Achados principais (6 agentes)

### Settings (fontes: GitHub issues + community)
- `effortLevel: "max"` no JSON = bug, silenciosamente vira undefined (issues #30726, #33937, #43322)
- Mar 2026: Anthropic rebaixou default high→medium em Pro/Max sem aviso. Boris Cherny confirmou
- `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` + `CLAUDE_CODE_EFFORT_LEVEL=max` = consenso comunidade
- `ANTHROPIC_API_KEY` no env bypassa Max subscription — usuario pagou $1.800 em 2 dias (issue #37686)
- `CLAUDE_CODE_SUBAGENT_MODEL` env var controla modelo default subagents (docs oficiais)
- `autoMemoryEnabled: false` ou `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1` desabilita auto memory

### Hooks state-of-art (fontes: code.claude.com, GitHub repos)
- 27 eventos lifecycle (usamos 8), 4 handler types (usamos 1: command)
- `$CLAUDE_PROJECT_DIR`: production, funciona Windows Git Bash. OLMO: 0/29 scripts usam
- `if` conditions (v2.1.85+): production, evita process spawn. OLMO ja usa 2
- Prompt hooks: production (bugs fixados abr 2026), $0 no Max. Best for Stop anti-rationalization
- Hookify: complements only (5/27 eventos, warn/block only, sem updatedInput)
- `async: true`: production, free latency reduction em hooks nao-bloqueantes

### Hooks audit (30 scripts no disco)
- 28/29 sem `set -euo pipefail` (so guard-secrets.sh)
- 2 vulns confirmadas: eval injection (retry-utils.sh:28), JSON hand-assembly (post-compact-reread.sh:15)
- 1 vuln possivelmente corrigida: printf injection (nao encontrada em audit)
- 0/29 usam $CLAUDE_PROJECT_DIR (todos usam dirname relativo — portavel, mas settings.json hardcoded)
- 1 node -e restante (apl-cache-refresh.sh:42)
- pre-push.sh/post-merge.sh: NAO referenciados em settings — finding stale, nao e bug

### Memoria state-of-art (fontes: GitHub, arXiv, community benchmarks)
- **Benchmarks sao lixo**: LoCoMo audit — 6.4% golden answers errados, LLM judge aceita 63% wrong, Mem0 0.20 vs 0.66 reportado, Zep 84%→58%
- **claude-mem** (55.8k stars): SQLite+ChromaDB+worker. API key leak (issue #733), subagent cost multiplication (issue #1464). Infra pesada.
- **ByteRover CLI** (4.3k stars): markdown files, zero-infra, MCP native. Elastic License. Maior match com OLMO.
- **claude-memory-compiler** (~800 stars): Karpathy pattern, session-end hook + Agent SDK. = /dream automatizado. MAIOR match filosofico.
- **Mem0**: self-hosted MCP archived Mar 2026 → cloud-only. Dados medicos em cloud = nao.
- **Jamie Lord (abril 2026, 2.455 evals)**: "Memory tools are mostly redundant." <500 artigos: LLM index > vector search.
- **MemPalace**: EVITAR — benchmark gaming, crypto pump-and-dump, autoria disputada.

## P0 — System Maturity (plano master: `.claude/plans/generic-wondering-manatee.md`)

**Rules reduction ✅:** 1,102 → 198 li, 13 → 5 files (-82%). Fase 1a (S208) + Fase 1b (S209).
**Pesquisa S209 ✅:** hooks + memoria + audit. Tudo persistido em plan files.
**Settings S210 ✅:** env vars aplicados, efeito proxima sessao.

## P0 — Pendentes Anteriores

- s-quality: evidence HTML integration + narrativa pendente
- s-tipos-ma: slide PENDENTE (Lucas decide quantos, posicao, h2)
- drive-package: PDF stale, PNG export pendente
- Apresentacao S208: PDF cortou slides, HDMI comprimiu janela

## P1

- Wallace CSS-wide: 29 font-sizes raw, #162032 sem token, 20 !important
- TREE.md desatualizado (S93 → S210)
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
Coautoria: Lucas + Opus 4.6 | S210 2026-04-15
