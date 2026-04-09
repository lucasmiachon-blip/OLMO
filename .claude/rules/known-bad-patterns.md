---
description: Via Negativa — patterns the agent must NEVER repeat. Fed by /insights.
globs: "**/*"
---

# Known-Bad Patterns (Via Negativa)

> Knowing what NOT to do is more robust than knowing what to do. — Taleb
> Source: /insights S82 report (58 sessions, 20 analyzed in depth)
> Governance: /insights appends new patterns. NEVER remove — only mark RESOLVED with date.
> IDs are stable and sequential. Next available: KBP-09.

## [KBP-01] Scope Creep — Acting Without Permission

- **When**: After completing a task, agent chains to the "next logical step" without asking
- **Symptom**: Lucas says "calma", "pare", "espere", "primeiro X depois eu falo proximo passo"
- **Cause**: Helpfulness bias — model optimizes for appearing productive over following protocol
- **Fix**: Momentum brake (anti-drift.md). After EVERY discrete action: STOP, report result, wait for explicit instruction. Exception: approved multi-step plan with all steps listed upfront. **Structural enforcement S99:** 3 hooks (arm/enforce/clear) use `permissionDecision: "ask"` — harness-enforced, model cannot bypass. Variant: autonomous fallback (switching model/approach without asking, S97-S98).
- **Incidence**: 24 events / 8 sessions + 4 recurrences S97-S98 (pre-hooks) + 5 recurrences S100-S104 (pre-hook-fix)
- **Sessions**: 8cc72d17, 3a47931d, 1cfc1f1c, 20706c01, multiple others
- **Post-S102 status:** 3 hook bugs fixed (B5-02/04/05). S105-S107: 0 recurrences. Hooks structurally enforce ask-before-act. Monitor S109+.

## [KBP-02] Context Overflow Leading to Thread Loss

- **When**: Sessions with 3+ subagent runs, heavy research, or long QA passes
- **Symptom**: Agent forgets earlier decisions, repeats questions, contradicts prior work. Lucas says "organize num md antes de perder", "contexto esta estourando"
- **Cause**: Context window fills with tool outputs; compaction loses conventions and decisions while preserving code
- **Fix**: Proactive checkpoints (session-hygiene.md). After 2 complex subagent tasks: commit, update HANDOFF, suggest /clear. After compaction: immediately re-read HANDOFF.md
- **Incidence**: 11 events / 6 sessions
- **Sessions**: 1cfc1f1c, 3a47931d, multiple others

## [KBP-03] Agent-Script Redundancy — Reinventing Instead of Using Scripts

- **When**: Agent creates new script or reimplements logic already in content/aulas/scripts/
- **Symptom**: Lucas says "eliminar redundancia e seguir os scripts nao criar novos", "tem redundancia com scripts", "tem muita redundancia entre os scripts e os agentes"
- **Cause**: Agent definition duplicates script logic. When definition and script disagree, agent follows its own definition
- **Fix**: Script primacy (anti-drift.md). Scripts in content/aulas/scripts/ are canonical. Agent definitions MUST reference scripts, not reimplement. NEVER create new scripts without Lucas's explicit request
- **Incidence**: 10 events / 5 sessions
- **Sessions**: 8cc72d17, 20706c01, 5559f171

## [KBP-04] QA Criteria Invented From Training Data

- **When**: Agent evaluates slides using general knowledge instead of script-defined checks
- **Symptom**: Lucas says "nao aplicou os criterios", "com os criterios nao da sua cabeca", "eu preciso que vc avalie visual conforme o script"
- **Cause**: qa-engineer reads slide DOM and applies aesthetics/content criteria from training data instead of reading lint-slides.js checks and gemini-qa3.mjs gate prompts first
- **Fix**: Criteria-source mandate (qa-pipeline.md). ALWAYS read script check definitions BEFORE evaluating. Preflight: lint-slides.js. Inspect/Editorial: gemini-qa3.mjs gate prompts. If a check is not in the script, it does not exist
- **Incidence**: 9 events / 3 sessions
- **Sessions**: 8cc72d17, 3a47931d

## [KBP-05] Batch QA Multi-Slide in Single Pass

- **When**: Agent receives instruction to QA a slide and processes multiple slides in the same invocation
- **Symptom**: Lucas says "esta rodando tudo errado eh um slide por vez", "trave sempre para fazer um slide por vez"
- **Cause**: maxTurns budget allows processing multiple slides. Agent optimizes for throughput over protocol
- **Fix**: Single-slide convention (qa-engineer.md + qa-pipeline.md). At invocation start, identify the ONE slide. Agent self-enforces: if referencing a second slide ID or file, STOP and report. 1 gate = 1 invocation = 1 slide. Enforcement: agent prompt + maxTurns=12 backstop (no hook)
- **Incidence**: 7 events / 3 sessions
- **Sessions**: 8cc72d17

## [KBP-06] Agent Delegation Without Verification

- **When**: Orchestrator launches subagent without verifying agent type, expected output format, or whether the agent can actually do the task
- **Symptom**: Agent returns empty output, "submitted to external tool", or findings not persisted. Lucas says "verificar antes de lancar", "agente errado"
- **Cause**: Fire-and-forget pattern — model assumes any agent can handle any task. Codex:rescue delegates to Codex CLI (external), general-purpose runs in-process (correct for review)
- **Fix**: Pre-launch checklist: (1) verify agent type matches task, (2) confirm output is capturable (file write instruction in prompt), (3) get Lucas's approval before launching. Memory: `feedback_agent_delegation.md`
- **Incidence**: 3 events / 1 session + 1 recurrence S114 (codex:rescue fire-and-forget during adversarial audit)
- **Sessions**: S99 (2026-04-07), S114 (2026-04-08)
- **Post-S114 status:** Root cause confirmed: `codex:rescue` delegates to external Codex CLI which returns without waiting for output. Fix: (1) sentinel no longer delegates to Codex internally — Codex adversarial is a separate perna launched by orchestrator; (2) for internal review tasks, use `general-purpose` agent type (runs in-process) or sentinel (Sonnet read-only), NOT `codex:rescue`. Also: subagent outputs must be VERIFIED by orchestrator before acting on them (explorer hallucinated a bug in S114).

## [KBP-07] Workaround Without Diagnosis

- **When**: Something fails (API timeout, build error, script failure) and agent invents a creative alternative instead of diagnosing the root cause and asking
- **Symptom**: Lucas says "nao invente", "nao mexe sem autorizacao", "procure uma trava para workaround". Agent proposes skipping features, creating simplified versions, or editing scripts without approval
- **Cause**: Aversion to reporting failure — model prefers appearing productive to admitting something broke. Disguises workaround as pragmatism ("vou tentar sem video", "vou aumentar o timeout")
- **Fix**: Failure gate (anti-drift.md §Failure Response). When something fails: (1) read full error, (2) diagnose root cause (NOT first hypothesis), (3) report what/why/root cause, (4) list options including "do nothing", (5) STOP. PROIBIDO: propor alternativa que contorne o problema sem resolver a causa. PROIBIDO: editar scripts canônicos sem aprovação explícita.
- **Incidence**: 3 events / 1 session (S104: skip video suggestion, prompt edit without approval, misdiagnosis timeout vs MAX_TOKENS)
- **Sessions**: S104 (2026-04-07)

## [KBP-08] API/MCP Substitution — WebSearch as Fake Leg

- **When**: Pipeline /research precisa executar perna com API especifica (Gemini, Perplexity) ou MCPs academicos, e agente substitui por WebSearch ou agente general-purpose
- **Symptom**: Output aparenta funcional mas fontes sao genericas, sem grounding API, sem Tier 1 filtering. Tabela perna-vs-realidade mostra divergencia. Lucas: "fez ou nao fez o gemini e perplexity?"
- **Cause**: WebSearch nos allowed-tools do skill permite improviso. Sem pre-flight validation, API keys faltantes nao geram erro. Otimizacao para throughput sobre protocolo.
- **Fix**: (1) Remover WebSearch dos allowed-tools do skill orquestrador. (2) Pre-flight validation de API keys antes de dispatch. (3) Enforcement textual: perna falhou = reportar e pular, NUNCA substituir. (4) WebSearch em evidence-researcher escopado a verificacao pontual.
- **Incidence**: 1 evento / S124 (Gemini + Perplexity substituidos por general-purpose + WebSearch)
- **Sessions**: S124 (2026-04-09)
