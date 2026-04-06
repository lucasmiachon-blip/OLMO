---
description: Via Negativa — patterns the agent must NEVER repeat. Fed by /insights.
globs: "**/*"
---

# Known-Bad Patterns (Via Negativa)

> Knowing what NOT to do is more robust than knowing what to do. — Taleb
> Source: /insights S82 report (58 sessions, 20 analyzed in depth)
> Governance: /insights appends new patterns. NEVER remove — only mark RESOLVED with date.
> IDs are stable and sequential. Next available: KBP-06.

## [KBP-01] Scope Creep — Acting Without Permission

- **When**: After completing a task, agent chains to the "next logical step" without asking
- **Symptom**: Lucas says "calma", "pare", "espere", "primeiro X depois eu falo proximo passo"
- **Cause**: Helpfulness bias — model optimizes for appearing productive over following protocol
- **Fix**: Momentum brake (anti-drift.md). After EVERY discrete action: STOP, report result, wait for explicit instruction. Exception: approved multi-step plan with all steps listed upfront
- **Incidence**: 24 events / 8 sessions (most frequent pattern)
- **Sessions**: 8cc72d17, 3a47931d, 1cfc1f1c, 20706c01, multiple others

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
- **Fix**: Single-slide guard (qa-engineer.md + qa-pipeline.md). At invocation start, identify the ONE slide. If referencing a second slide's ID or file: STOP — violation detected. 1 gate = 1 invocation = 1 slide
- **Incidence**: 7 events / 3 sessions
- **Sessions**: 8cc72d17
