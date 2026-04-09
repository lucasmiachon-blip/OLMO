---
description: Via Negativa — patterns the agent must NEVER repeat. Fed by /insights.
globs: "**/*"
---

# Known-Bad Patterns (Via Negativa)

> Knowing what NOT to do is more robust than knowing what to do. — Taleb
> Governance: /insights appends. NEVER remove — only mark RESOLVED. Next: KBP-09.

## [KBP-01] Scope Creep — Acting Without Permission

- **When**: After completing a task, agent chains to the "next logical step" without asking
- **Symptom**: Lucas says "calma", "pare", "espere", "primeiro X depois eu falo proximo passo"
- **Cause**: Helpfulness bias — model optimizes for appearing productive over following protocol
- **Fix**: Momentum brake (anti-drift.md). After EVERY discrete action: STOP, report result, wait for explicit instruction. Exception: approved multi-step plan. Structurally enforced by 3 hooks (arm/enforce/clear).

## [KBP-02] Context Overflow Leading to Thread Loss

- **When**: Sessions with 3+ subagent runs, heavy research, or long QA passes
- **Symptom**: Agent forgets earlier decisions, repeats questions, contradicts prior work. Lucas says "organize num md antes de perder", "contexto esta estourando"
- **Cause**: Context window fills with tool outputs; compaction loses conventions and decisions while preserving code
- **Fix**: Proactive checkpoints (session-hygiene.md). After 2 complex subagent tasks: commit, update HANDOFF, suggest /clear. After compaction: immediately re-read HANDOFF.md

## [KBP-03] Agent-Script Redundancy — Reinventing Instead of Using Scripts

- **When**: Agent creates new script or reimplements logic already in content/aulas/scripts/
- **Symptom**: Lucas says "eliminar redundancia e seguir os scripts nao criar novos", "tem redundancia com scripts", "tem muita redundancia entre os scripts e os agentes"
- **Cause**: Agent definition duplicates script logic. When definition and script disagree, agent follows its own definition
- **Fix**: Script primacy (anti-drift.md). Scripts in content/aulas/scripts/ are canonical. Agent definitions MUST reference scripts, not reimplement. NEVER create new scripts without Lucas's explicit request

## [KBP-04] QA Criteria Invented From Training Data

- **When**: Agent evaluates slides using general knowledge instead of script-defined checks
- **Symptom**: Lucas says "nao aplicou os criterios", "com os criterios nao da sua cabeca", "eu preciso que vc avalie visual conforme o script"
- **Cause**: qa-engineer reads slide DOM and applies aesthetics/content criteria from training data instead of reading lint-slides.js checks and gemini-qa3.mjs gate prompts first
- **Fix**: Criteria-source mandate (qa-pipeline.md). ALWAYS read script check definitions BEFORE evaluating. Preflight: lint-slides.js. Inspect/Editorial: gemini-qa3.mjs gate prompts. If a check is not in the script, it does not exist

## [KBP-05] Batch QA Multi-Slide in Single Pass

- **When**: Agent receives instruction to QA a slide and processes multiple slides in the same invocation
- **Symptom**: Lucas says "esta rodando tudo errado eh um slide por vez", "trave sempre para fazer um slide por vez"
- **Cause**: maxTurns budget allows processing multiple slides. Agent optimizes for throughput over protocol
- **Fix**: Single-slide convention (qa-engineer.md + qa-pipeline.md). At invocation start, identify the ONE slide. If referencing a second slide, STOP. 1 gate = 1 invocation = 1 slide.

## [KBP-06] Agent Delegation Without Verification

- **When**: Orchestrator launches subagent without verifying agent type, expected output format, or whether the agent can actually do the task
- **Symptom**: Agent returns empty output, "submitted to external tool", or findings not persisted. Lucas says "verificar antes de lancar", "agente errado"
- **Cause**: Fire-and-forget pattern — model assumes any agent can handle any task. Codex:rescue delegates to Codex CLI (external), general-purpose runs in-process (correct for review)
- **Fix**: Pre-launch checklist: (1) verify agent type matches task, (2) confirm output is capturable, (3) get Lucas's approval. Never use `codex:rescue` for internal review — use `general-purpose` (in-process) or `sentinel` (read-only). Verify subagent outputs before acting.

## [KBP-07] Workaround Without Diagnosis

- **When**: Something fails (API timeout, build error, script failure) and agent invents a creative alternative instead of diagnosing the root cause and asking
- **Symptom**: Lucas says "nao invente", "nao mexe sem autorizacao", "procure uma trava para workaround". Agent proposes skipping features, creating simplified versions, or editing scripts without approval
- **Cause**: Aversion to reporting failure — model prefers appearing productive to admitting something broke. Disguises workaround as pragmatism ("vou tentar sem video", "vou aumentar o timeout")
- **Fix**: Failure gate (anti-drift.md §Failure Response). When something fails: (1) read full error, (2) diagnose root cause (NOT first hypothesis), (3) report what/why/root cause, (4) list options including "do nothing", (5) STOP. PROIBIDO: contornar sem resolver. PROIBIDO: editar scripts canonicos sem aprovacao.

## [KBP-08] API/MCP Substitution — WebSearch as Fake Leg

- **When**: Pipeline /research precisa executar perna com API especifica (Gemini, Perplexity) ou MCPs academicos, e agente substitui por WebSearch ou agente general-purpose
- **Symptom**: Output aparenta funcional mas fontes sao genericas, sem grounding API, sem Tier 1 filtering. Tabela perna-vs-realidade mostra divergencia. Lucas: "fez ou nao fez o gemini e perplexity?"
- **Cause**: WebSearch nos allowed-tools do skill permite improviso. Sem pre-flight validation, API keys faltantes nao geram erro. Otimizacao para throughput sobre protocolo.
- **Fix**: (1) WebSearch removido de evidence-researcher S126. (2) Pre-flight validation de API keys antes de dispatch. (3) Perna falhou = reportar e pular, NUNCA substituir.
