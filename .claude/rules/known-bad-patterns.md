---
description: Via Negativa — patterns the agent must NEVER repeat. Fed by /insights.
globs: "**/*"
---

# Known-Bad Patterns (Via Negativa)

> Knowing what NOT to do is more robust than knowing what to do. — Taleb
> Governance: /insights appends. NEVER remove — only mark RESOLVED. Next: KBP-09.

## KBP-01 Scope Creep
Trigger: chains to next step without asking. Lucas: "calma/pare/espere". Cause: helpfulness bias. **→ anti-drift.md §Momentum brake**

## KBP-02 Context Overflow
Trigger: 3+ subagent runs → forgets decisions, repeats questions. Cause: compaction loses conventions. **→ session-hygiene.md §Proactive Checkpoints**

## KBP-03 Agent-Script Redundancy
Trigger: reimplements logic from `content/aulas/scripts/`. Lucas: "tem redundancia com scripts". Cause: agent definition duplicates script. **→ anti-drift.md §Script Primacy**

## KBP-04 QA Criteria From Training Data
Trigger: evaluates slides from general knowledge, not script checks. Lucas: "com os criterios nao da sua cabeca". **→ qa-pipeline.md §0 Pre-Read Gate**

## KBP-05 Batch QA Multi-Slide
Trigger: processes 2+ slides in one invocation. Lucas: "um slide por vez". Cause: throughput over protocol. **→ qa-pipeline.md §1**

## KBP-06 Agent Delegation Without Verification
Trigger: subagent returns empty/"submitted to external tool". Lucas: "verificar antes de lancar". Cause: fire-and-forget. Fix: (1) verify agent type matches task, (2) confirm output capturable, (3) Lucas approval. Never `codex:rescue` for internal review — use `general-purpose` or `sentinel`.

## KBP-07 Workaround Without Diagnosis
Trigger: failure → agent invents alternative instead of diagnosing. Lucas: "nao invente/nao mexe sem autorizacao". Cause: aversion to reporting failure, disguises workaround as pragmatism. **→ anti-drift.md §Failure response**

## KBP-08 API/MCP Substitution
Trigger: /research substitui WebSearch por API/MCP especifica. Output parece OK mas fontes genericas. Lucas: "fez ou nao fez o gemini e perplexity?". Cause: missing API keys don't error. Fix: (1) WebSearch removido de evidence-researcher S126. (2) Pre-flight API key validation. (3) Perna falhou = reportar e pular, NUNCA substituir.
