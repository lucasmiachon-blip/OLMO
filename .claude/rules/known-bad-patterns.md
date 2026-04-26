---
description: Via Negativa — patterns the agent must NEVER repeat. Fed by /insights.
globs: "**/*"
---

# Known-Bad Patterns (Via Negativa)

> Knowing what NOT to do is more robust than knowing what to do. — Taleb
> Governance: /insights appends. NEVER remove — only mark RESOLVED. Next: KBP-42.
> Format: `## KBP-NN Name` + `→ pointer`. Prose vive no pointer target.

## KBP-01 Scope Creep
→ anti-drift.md §Momentum brake

## KBP-02 Context Overflow
→ anti-drift.md §Session docs

## KBP-03 Agent-Script Redundancy
→ anti-drift.md §Script Primacy

## KBP-04 QA Criteria From Training Data
→ qa-pipeline.md (criteria in design-reference.md + slide-rules.md)

## KBP-05 Batch QA Multi-Slide
→ qa-pipeline.md §1

## KBP-06 Agent Delegation Without Verification
→ feedback_agent_delegation.md (memory)

## KBP-07 Workaround Without Diagnosis
→ anti-drift.md §Failure response

## KBP-08 API/MCP Substitution
→ research/SKILL.md §ENFORCEMENT

## KBP-09 API Key Tool via MCP — Wrong Execution Path
→ research/SKILL.md §Step 2 tabela

## KBP-10 Destructive Commands Without Approval
→ guard-bash-write.sh Pattern 17a/17b

## KBP-11 Gemini Thinking Token Pool Shared with Output
→ research/SKILL.md §Perna 1 generationConfig

## KBP-12 Research Prompts Without Output Schema
→ research/SKILL.md §Output Schema Suffix

## KBP-13 Factual Claim Without Verification
→ anti-drift.md §Verification

## KBP-14 Velocity Over Comprehension
→ anti-drift.md §Transparency

## KBP-15 Write Race via External Script
→ feedback_tool_permissions.md §Write race (memory)

## KBP-16 Verbosity Drift in Auto-Loaded Docs
→ this file's own format (pointer-only, no inline prose)

## KBP-17 Gratuitous Agent Spawning
→ anti-drift.md §Delegation gate

## KBP-18 Mechanical Edit Without Format Verification
→ anti-drift.md §Verification

## KBP-19 Bash Indirection for Protected Files
→ guard-write-unified.sh + guard-bash-write.sh

## KBP-20 Visual Change Without Browser Verification
→ anti-drift.md §EC loop

## KBP-21 Narrow Fix in Dirty Section
→ anti-drift.md §EC loop

## KBP-22 Silent Execution Chains
→ anti-drift.md §EC loop + Stop[0] silent execution check

## KBP-23 First-Turn Context Explosion
→ anti-drift.md §First-turn discipline

## KBP-24 Docs sobre sistemas externos dentro de OLMO
→ docs/adr/0002-external-inbox-integration.md §Decisão

## KBP-25 Edit Without Full Read (whitespace precision)
→ anti-drift.md §Edit discipline

## KBP-26 CC permissions.ask broken in 2.1.113
→ `.claude/BACKLOG.md #34` + `.claude/plans/archive/S227-backlog-34-architecture.md`

## KBP-27 Pipeline Python redundante quando crosstalk AI+humano supera
→ `docs/ARCHITECTURE.md §Notion Crosstalk Pattern`

## KBP-28 Adversarial testing frame-bound
→ anti-drift.md §Adversarial review

## KBP-29 Agent Spawn Without HANDOFF/Plan Persistence
→ anti-drift.md §Delegation gate

## KBP-30 Per-Aula HANDOFF Slide Count Stale
→ content/aulas/CLAUDE.md §Cross-Ref (`_manifest.js` add/remove → `{aula}/HANDOFF.md §Estado` slide count)

## KBP-31 Aprendizados KBP-Candidate Without Commit
→ anti-drift.md §Session docs ("KBP candidate" ou "lint rule candidate" em Aprendizados = schedule commit antes de session close)

## KBP-32 Agent AUSENTE claim without spot-check
→ anti-drift.md §Delegation gate

## KBP-33 Prefix-glob deny insuficiente
→ docs/adr/0006-olmo-deny-list-classification.md

## KBP-34 Edit em dominio novo sem ler governing docs
→ CLAUDE.md §ENFORCEMENT #5 + anti-drift.md §Edit discipline

## KBP-35 Plugin bug local-patch trap (workaround entulho)
→ cc-gotchas.md §Upstream plugin bugs

## KBP-36 Claim sem evidência citada (research + decisões + recommendations)
→ CLAUDE.md §ENFORCEMENT #6

## KBP-37 "Elite faria diferente" sem ação ou gate explícito
→ anti-drift.md §EC loop §Elite faria diferente — must be actionable

## KBP-38 Window-restart ≠ daemon-restart pra Agent tool registry
→ cc-gotchas.md §Agent tool registry refresh

## KBP-39 Audit-merge convergence rules followed loosely (1/3 + spot-check ≠ DEFER)
→ `.claude/plans/immutable-gliding-galaxy.md` §6.1 Convergence rules (folded from audit-merge-S251.md S253)

## KBP-40 SessionStart gitStatus snapshot stale
→ anti-drift.md §Verification (branch claim)

## KBP-41 Cut bias — Deferred items mislabeled as Cut
→ anti-drift.md §EC loop §Cut calibration
