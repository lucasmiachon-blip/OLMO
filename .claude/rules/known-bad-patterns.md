---
description: Via Negativa — patterns the agent must NEVER repeat. Fed by /insights.
globs: "**/*"
---

# Known-Bad Patterns (Via Negativa)

> Knowing what NOT to do is more robust than knowing what to do. — Taleb
> Governance: /insights appends. NEVER remove — only mark RESOLVED. Next: KBP-12.

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

## KBP-09 API Key Tool via MCP — Wrong Execution Path
Trigger: /research Perna 1 (Gemini) ou 5 (Perplexity) lancada via MCP/subagent em vez de Bash/API key. Agente reporta "sem MCP direto" como limitacao. Lucas: "eh para ser via api key". Cause: agente generaliza "pesquisa = MCP" e ignora scripts Bash no SKILL.md. Complementa KBP-08 (substitution vs wrong path). Fix: (1) Tabela Step 2 com coluna "Ferramenta/Executor" (S129). (2) Pre-flight API key check (Step 1.5). (3) Pernas 1/5/6 = orquestrador via Bash, NUNCA subagent. **→ SKILL.md Step 2 tabela**

## KBP-10 Destructive Commands Without Approval
Trigger: agente executa `rm`/`rmdir`/delete em dados do projeto sem aprovacao explicita do Lucas. Lucas: "nao pode dar comando destrutivo sem ask". Cause: (1) regra "artifact cleanup consumidos" interpretada permissivamente, (2) Pattern 17 usava "ask" que podia ser auto-aprovado, (3) `.claude/workers/` gitignored = sem rede de seguranca. Fix S130: (1) guard-bash-write.sh Pattern 17a hard-blocks rm em `.claude/workers/`. (2) Regra geral: NENHUM comando destrutivo sem aprovacao explicita — nem orquestrador, nem worker. **→ guard-bash-write.sh Pattern 17a/17b**

## KBP-11 Gemini Thinking Token Pool Shared with Output
Trigger: Gemini API call retorna 0 bytes de texto. `finishReason: MAX_TOKENS` ou `STOP` sem texto. Lucas: "gemini retornou vazio". Cause: `maxOutputTokens` inclui thinking tokens no Gemini (diferente de Claude). Com `maxOutputTokens: 8192` e `thinkingBudget: 24576`, o modelo gasta tudo em thinking e sobram 0 tokens para texto. Fix S145: (1) `maxOutputTokens: 32768` com `thinkingBudget: 16384`. (2) Check `finishReason === 'MAX_TOKENS'` + check `!parts.some(p => p.text)`. (3) Comentario explicativo no SKILL.md. **→ SKILL.md Perna 1 generationConfig**

## KBP-12 Research Prompts Without Output Schema
Trigger: pesquisa retorna ensaio/prosa em vez de dados estruturados. Lucas: "vc tem que forca-los a dar output estruturado". Cause: prompts diziam "ABERTO" sem distinguir liberdade de TOPICO de liberdade de FORMATO. Perplexity retornou 31KB ensaio, Opus retornou narrativa longa. Fix S145: (1) Principio "OPEN topic + CLOSED format" no SKILL.md. (2) Output Schema Suffix obrigatorio em toda perna. (3) System prompt Perplexity reescrito com formato tabular. (4) Schema Validation Gate mecanico no Step 2.5. **→ SKILL.md §Output Schema Suffix + §Principio I/O**
