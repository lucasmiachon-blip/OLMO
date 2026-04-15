---
description: Via Negativa — patterns the agent must NEVER repeat. Fed by /insights.
globs: "**/*"
---

# Known-Bad Patterns (Via Negativa)

> Knowing what NOT to do is more robust than knowing what to do. — Taleb
> Governance: /insights appends. NEVER remove — only mark RESOLVED. Next: KBP-21.
> Format: `## KBP-NN Name` + `→ pointer`. Prose vive no pointer target. See anti-drift.md §Pointer-only discipline.

## KBP-01 Scope Creep
→ anti-drift.md §Momentum brake

## KBP-02 Context Overflow
→ session-hygiene.md §Proactive Checkpoints

## KBP-03 Agent-Script Redundancy
→ anti-drift.md §Script Primacy

## KBP-04 QA Criteria From Training Data
→ qa-pipeline.md §0 Pre-Read Gate

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
→ anti-drift.md §Execution-phase explanation budget

## KBP-15 Write Race via External Script
→ feedback_tool_permissions.md §Write race (memory)

## KBP-16 Verbosity Drift in Auto-Loaded Docs
→ anti-drift.md §Pointer-only discipline

## KBP-17 Gratuitous Agent Spawning
→ anti-drift.md §Delegation gate

## KBP-18 Mechanical Edit Without Format Verification
→ anti-drift.md §Verification (Edit-time format compliance)

## KBP-19 Bash Indirection for Protected Files
→ guard-product-files.sh §INFRA GUARD comment (code is the fix: block→ask, S193)

## KBP-20 Visual Change Without Browser Verification
→ elite-conduct.md §Gate visual
