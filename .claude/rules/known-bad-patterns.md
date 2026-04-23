---
description: Via Negativa — patterns the agent must NEVER repeat. Fed by /insights.
globs: "**/*"
---

# Known-Bad Patterns (Via Negativa)

> Knowing what NOT to do is more robust than knowing what to do. — Taleb
> Governance: /insights appends. NEVER remove — only mark RESOLVED. Next: KBP-32.
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
→ guard-write-unified.sh + guard-bash-write.sh (merged S194, original guard-product-files.sh removed)

## KBP-20 Visual Change Without Browser Verification
→ anti-drift.md §EC loop

## KBP-21 Narrow Fix in Dirty Section
→ anti-drift.md §EC loop

## KBP-22 Silent Execution Chains
→ anti-drift.md §EC loop + Stop[0] prompt silent execution check (S219: enforcement mecanico)

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
