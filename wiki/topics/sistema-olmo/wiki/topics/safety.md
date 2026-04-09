---
title: Safety
description: Safety architecture — guards, fail-closed gates, MCP protocol, KBP gates, verification, chaos engineering
domain: sistema-olmo
type: topic
confidence: high
tags: [safety, guards, fail-closed, mcp-safety, kbp, verification, chaos-engineering, antifragile]
created: 2026-04-09
sources:
  - memory/patterns_defensive.md
  - .claude/hooks/guard-*.sh
  - .claude/rules/mcp_safety.md
  - .claude/rules/known-bad-patterns.md
  - .claude/rules/anti-drift.md
  - docs/research/chaos-engineering-L6.md
related: [[hook]], [[rule]], [[orquestracao]]
---

# Safety

Safety no OLMO opera em camadas defensivas que se reforçam mutuamente: guards bloqueiam ações perigosas antes da execução, gates impõem protocolos em pontos de decisão, e patterns defensivos tratam classes inteiras de falha. O princípio unificador é fail-closed — na dúvida, bloquear.

## Guards (PreToolUse Hooks)

9 guard hooks interceptam chamadas de ferramenta antes da execução:

| Guard | Proteção |
|-------|----------|
| guard-secrets.sh | Bloqueia vazamento de chaves/tokens |
| guard-pause.sh | Enforce momentum brake (KBP-01) |
| guard-bash-write.sh | Bloqueia 19 padrões destrutivos em Bash |
| guard-bash-secrets.sh | Secrets em comandos Bash |
| guard-product-files.sh | Protege scripts canônicos |
| guard-generated-files.sh | Protege arquivos gerados |
| guard-plan-exit.sh | Controla saída de plan mode |
| guard-lint-before-build.sh | Lint obrigatório antes de build |
| guard-worker-write.sh | Timestamp enforcement + worker-mode isolation |

Todos usam `permissionDecision: "block"` com mensagem descritiva. Falha no hook = operação bloqueada (fail-closed).

## Fail-Closed Gates

Princípio: gates de segurança DEVEM bloquear em caso de erro, nunca permitir.

4 bugs históricos que motivaram este princípio:
1. **NaN comparisons** bypass thresholds (IEEE 754 — NaN falha todas as comparações)
2. **Shell parse errors** exiting 0 (allow) em vez de non-zero (block)
3. **Missing file scans** — arquivo não encontrado = scan pulado, não "limpo"
4. **Corrupted budget resets** — valor corrompido tratado como 0, não como erro

Checklist de implementação: validar inputs numéricos antes de comparações; shell hooks exit non-zero on failure; file reads com fallback seguro; guard negativos antes da lógica.

## MCP Safety Protocol (Notion)

Protocolo de 3 fases para operações MCP:

1. **READ-ONLY** (padrão): escopo específico, nunca workspace inteiro
2. **WRITE** (após snapshot + aprovação humana): uma operação por vez, verificar resultado antes da próxima
3. **VERIFICAÇÃO**: re-ler página pós-write, parar se resultado diverge

Modelo HARSH: writes requerem aprovação humana; confidence < 0.70 = bloquear; dados de paciente = bloquear (LGPD); erro em write = parar (não retry). Archive instead of delete (reversível 30 dias).

## KBP Safety Gates

Dois Known-Bad Patterns com impacto direto em safety:

**KBP-01 — Scope Creep:** Agent encadeia ações sem permissão. Fix: momentum brake — STOP após cada ação discreta, reportar, esperar instrução explícita. Enforcement estrutural via 3 hooks com `permissionDecision: "ask"`.

**KBP-07 — Workaround Without Diagnosis:** Agent inventa alternativa em vez de diagnosticar falha. Fix: failure gate de 5 passos (ler erro completo → diagnosticar root cause → reportar com evidência → listar opções → STOP). Proibido: contornar sem resolver causa, editar scripts canônicos sem aprovação.

## Failure Response Gate

Gate de 5 passos (anti-drift.md), obrigatório quando algo falha:

1. Ler mensagem de erro COMPLETA
2. Diagnosticar ROOT CAUSE (verificar, não assumir primeira hipótese)
3. Reportar: o que falhou, por que, root cause com evidência
4. Listar opções (incluindo "retry", "fix causa", "deferir", "nada")
5. STOP — esperar decisão

Red flags de gate pulado: "should pass", "probably works", "seems correct", "Done!"

## Verification Gate

Gate de 5 passos, obrigatório antes de afirmar resultado:

1. Identificar comando de verificação (test, build, lint, manual)
2. Executar completamente
3. Ler output completo
4. Confirmar que output corresponde à afirmação
5. Só então assertar resultado

## Chaos Engineering (L6)

Framework opt-in de chaos engineering (docs/research/chaos-engineering-L6.md): 4/6 vetores implementados. Ativação via `CHAOS_MODE` env var. Testa resiliência injetando falhas controladas em hooks, MCPs e agent responses.

## Antifragile Stack

Safety integra-se à stack antifragile de 7 camadas (L1-L7): retry+jitter → model fallback → cost breaker → graceful degradation → self-healing → chaos engineering → continuous learning. Guards e gates operam em L1-L4; chaos engineering testa L5-L6.

---

Fontes: memory/patterns_defensive.md, .claude/hooks/guard-*.sh, .claude/rules/mcp_safety.md, .claude/rules/known-bad-patterns.md, .claude/rules/anti-drift.md, docs/research/chaos-engineering-L6.md
Coautoria: Lucas + Opus 4.6 | S121 2026-04-09
