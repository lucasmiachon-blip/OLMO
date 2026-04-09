---
title: Orquestracao
description: Modelo de orquestracao do OLMO — multi-window, model routing, momentum brake, scope discipline
domain: sistema-olmo
type: topic
confidence: high
tags: [orchestration, multi-window, model-routing, momentum-brake, anti-drift]
created: 2026-04-09
sources:
  - .claude/rules/multi-window.md
  - .claude/rules/anti-drift.md
  - .claude/rules/known-bad-patterns.md
  - docs/ARCHITECTURE.md
related: ["[[agent]]", "[[rule]]", "[[hook]]", "[[safety]]"]
---

# Orquestracao

O OLMO usa um modelo de orquestracao hierarquico: 1 orquestrador (Opus) decide e edita, N workers (Sonnet/Haiku) pesquisam e produzem output read-only.

## Multi-Window Protocol

| Role | Permissoes | Escrita |
|------|-----------|---------|
| Orquestrador (1 janela) | Edit, Write, commit, subagents | Repo inteiro |
| Worker (1-2 janelas) | Read, Glob, Grep, MCPs, WebSearch | `.claude/workers/{task}/` apenas |

Workers criam `output.md` + `DONE.md` com timestamp obrigatorio no H1: `# Titulo — YYYY-MM-DD HH:MM`. Orquestrador consome e apaga apos integrar. Enforcement: `guard-worker-write.sh` (PreToolUse) + `guard-bash-write.sh` (Bash block para workers/).

## Model Routing

```
trivial → Ollama ($0)
simple  → Haiku
medium  → Sonnet
complex → Opus
```

Subagentes herdam routing por funcao: evidence-researcher (Sonnet, 20 turns), quality-gate (Haiku, 10 turns), sentinel (Sonnet, 25 turns, read-only).

## Momentum Brake (KBP-01)

Apos CADA acao discreta (edit, build, commit, QA check): PARAR e reportar. Proximo passo requer instrucao explicita do Lucas. Excecao: plano multi-step aprovado com todos os steps listados upfront.

Enforcement: 3 hooks ask-before-act (`permissionDecision: "ask"`). 24 violacoes historicas pre-hooks, 0 recorrencias S105+.

## Scope Discipline

- Implementar exatamente o pedido, nada mais
- 1 concern por commit
- Codigo adjacente intocado
- Sem melhoria espontanea de codigo vizinho

## Verification Gate (5 steps)

1. Identificar comando de verificacao
2. Executar completamente
3. Ler output completo
4. Confirmar que output confirma a claim
5. So entao assertar o resultado

Red flags: "should pass", "probably works", "seems correct" — voltar ao step 1.

## Anti-Drift

| Principio | Enforcement |
|-----------|-------------|
| Transparencia | Declarar intent antes de agir |
| Scope discipline | Plan → approve → execute |
| Failure response (KBP-07) | Read error → diagnose root cause → report → list options → STOP |
| Budget awareness | Local-first → cache → batch → cheapest model |

## Antifragile Stack

7 camadas L1-L7 herdadas do framework Taleb:

| Layer | Mecanismo | Status |
|-------|-----------|--------|
| L1 | Retry com jitter | DONE |
| L2 | Model fallback (circuit breaker 2/5min) | DONE |
| L3 | Cost breaker (warn@100, block@400) | DONE |
| L4 | Context fork (subagents isolam overflow) | DONE |
| L5 | lint-on-edit → stop-detect → session-start (self-healing) | DONE |
| L6 | Chaos injection (opt-in CHAOS_MODE=1) | BASIC |
| L7 | Memory TTL + /dream consolidation | DONE |

## Session Cycle

HANDOFF.md (futures, <=50 linhas) + CHANGELOG.md (append-only history) + commit early + /clear on context overflow. Pos-compaction: re-ler HANDOFF imediatamente.

---

Coautoria: Lucas + Opus 4.6 | Compilado S117 2026-04-09
