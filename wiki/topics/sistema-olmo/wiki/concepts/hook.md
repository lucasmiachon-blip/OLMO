---
title: Hooks
description: Hook pipeline do Claude Code — 34 registrations, 6 event types, guards + antifragile
domain: sistema-olmo
confidence: high
tags: [hook, guard, antifragile, safety, automation]
created: 2026-04-08
sources:
  - docs/ARCHITECTURE.md
  - .claude/hooks/*.sh
  - hooks/*.sh
  - .claude/settings.local.json
---

# Hooks

Hooks sao shell scripts disparados automaticamente pelo harness Claude Code em eventos especificos. O OLMO tem 34 registrations em 6 event types.

## Event Pipeline

```
UserPromptSubmit → SessionStart → PreToolUse → [Tool Use] → PostToolUse → Stop
```

## Categorias

### Guards (PreToolUse) — bloqueiam acoes perigosas
- guard-secrets.sh — bloqueia leak de chaves
- guard-pause.sh — momentum brake (KBP-01)
- guard-generated-files.sh — protege index.html
- guard-product-files.sh — protege scripts canonicos
- guard-plan-exit.sh — controla saida de plan mode
- guard-bash-secrets.sh — secrets em Bash
- guard-bash-write.sh — Bash destrutivo (19 patterns)
- guard-lint-before-build.sh — lint obrigatorio antes de build
- guard-worker-write.sh — workers read-only + timestamp H1

### Antifragile (PostToolUse + Stop) — sistema aprende com falhas
- model-fallback-advisory.sh — L2 circuit breaker
- cost-circuit-breaker.sh — L3 warn@100 block@400 calls/hr
- lint-on-edit.sh — L5 lint automatico apos editar
- stop-detect-issues.sh — L5 self-healing
- chaos-inject.sh — L6 chaos engineering (opt-in)

### APL (Ambient Productivity Layer)
- ambient-pulse.sh — 5-slot rotation por prompt
- apl-cache-refresh.sh — cache no session start
- stop-scorecard.sh — scorecard no final

## Safety (P001 S116)

Hooks DEVEM ter:
1. Exit condition (pode ser desabilitado/override)
2. Nao bloquear ExitPlanMode ou repair de settings.json
3. Teste em contexto nao-critico antes de deploy

## Config

- Registrations: `.claude/settings.local.json` (gitignored, local)
- Scripts: `.claude/hooks/` + `hooks/` (tracked)
- Lib: `.claude/hooks/lib/` (retry-utils, chaos)

## Relacionados

- [[agent]] — hooks guardam comportamento de agentes
- [[rule]] — hooks enforcem rules estruturalmente
- [[safety]] — guards sao a primeira linha de defesa
