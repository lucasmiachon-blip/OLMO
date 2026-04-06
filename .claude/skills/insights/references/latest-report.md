# /insights — Full Retrospective Report S91

> Period: 2026-04-06 (sessions since last run at 2026-04-05 23:37)
> Analyst: Opus 4.6
> Method: SCAN -> AUDIT -> DIAGNOSE -> PRESCRIBE
> Previous report: S82 (58 sessions, 20 deep-analyzed)
> Sessions analyzed: 13 main + subagents

---

## Executive Summary

13 sessions scanned since last /insights run. **Zero user corrections, zero real agent errors, zero KBP violations.** This is the first /insights run since the S82 baseline (which found 2.0 corrections/session and 3.05 KBP violations/session across 20 sessions). The enforcement mechanisms implemented in S82-S85 (known-bad-patterns, anti-drift guardrails, momentum brake, self-healing loop) appear to be working.

**Key metric:** User corrections = 0 (down from 2.0/session). KBP violations = 0 (down from 3.05/session).

Sessions were primarily: plan mode, doc review/hydration, cleanup, and infrastructure work. No QA or slide-authoring sessions (which historically trigger KBP-04 and KBP-05).

---

## Phase 1: SCAN — Incident Summary

| Category | Count | Notes |
|----------|-------|-------|
| User corrections | 0 | No "stop", "no", "wrong", "calma" signals |
| Real agent errors | 0 | All grep matches were lexical noise (error-handling code, docs) |
| Retries/workarounds | 0 | Retry mentions were in retry-utils.sh code, not actual retries |
| KBP violations | 0 | All KBP mentions were documentation reads during hydration |

**Notable:** Session 1138643d (largest, 3MB) contained 23 user messages that were directional steering in plan mode — normal teaching cadence, not error recovery.

---

## Phase 2: AUDIT — Rule Compliance Matrix

| Rule file | Status | Notes |
|-----------|--------|-------|
| anti-drift.md | FOLLOWED | References content/aulas/scripts/ (exists) |
| coauthorship.md | FOLLOWED | Ref: docs/coauthorship_reference.md (exists) |
| design-reference.md | FOLLOWED | Refs: docs/aulas/design-principles.md (exists) |
| known-bad-patterns.md | FOLLOWED | 5 KBPs present, all references valid |
| mcp_safety.md | FOLLOWED | HARSH model well-defined, cross-refs valid |
| notion-cross-validation.md | UNTESTED | Template exists but workflow never invoked |
| process-hygiene.md | FOLLOWED | Port reservation table current |
| qa-pipeline.md | FOLLOWED | All script refs valid (lint-slides.js, gemini-qa3.mjs) |
| session-hygiene.md | FOLLOWED | Hardening checklist present |
| slide-rules.md | UNTESTED | No slide work in analyzed period |

**Summary:** 8/10 rules FOLLOWED, 2/10 UNTESTED (no relevant workflow triggered). 0 VIOLATED. 0 STALE.

---

## Phase 3: DIAGNOSE — Prioritized Findings

### [RULE_GAP] P001: notion-cross-validation workflow defined but not invoked
- **Evidence:** Rule file defines Claude->ChatGPT audit workflow. Template exists at templates/chatgpt_audit_prompt.md. No agent references this workflow.
- **Severity:** MEDIUM — protocol defined but adoption path unclear
- **Category:** RULE_GAP

### [HOOK_GAP] P002: qa-pipeline state enum unversioned
- **Evidence:** qa-pipeline.md hardcodes states "BACKLOG->DRAFT->CONTENT->SYNCED->LINT-PASS->QA->DONE". Scripts and HANDOFF use these strings. No canonical enum definition — typo = silent state mismatch.
- **Severity:** MEDIUM — runtime fragility
- **Category:** HOOK_GAP

### [RULE_GAP] P003: KBP patterns advisory-only in agent definitions
- **Evidence:** known-bad-patterns.md lists 5 KBPs with fixes. Agent definitions (e.g., qa-engineer.md) don't encode KBP-05 single-slide guard as hard maxTurns or invocation gate. Enforcement relies on agent reading the rule, not structural prevention.
- **Severity:** MEDIUM — rules exist but enforcement is advisory
- **Category:** RULE_GAP

### [STALENESS] P004: design-principles.md untouched in 14+ days
- **Evidence:** Referenced by design-reference.md but no git commits touching it recently. Still valid content, just not actively maintained.
- **Severity:** LOW — reference doc, not active rule
- **Category:** RULE_STALE

### [SKILL_GAP] P005: Skills don't cross-reference rules
- **Evidence:** 25 skills exist. Zero cross-reference rule files. Skills operate independently of rule governance.
- **Severity:** LOW — modular by design, but error patterns are rule-level
- **Category:** SKILL_GAP

---

## Phase 4: PRESCRIBE — Proposals

### P001: notion-cross-validation — Defer
- **Target:** .claude/rules/notion-cross-validation.md
- **Proposed action:** No immediate change. This workflow is valid but requires ChatGPT interaction (outside Claude Code scope). Mark as "on-demand protocol" rather than "active enforcement."
- **Priority:** LOW — defer until Notion publishing becomes active

### P002: qa-pipeline state enum
- **Target:** content/aulas/scripts/ (new canonical enum) OR qa-pipeline.md
- **Proposed action:** Define states as a const array in one canonical location. Reference it from qa-pipeline.md.
- **Draft:** Add to qa-pipeline.md header: `States defined in: content/aulas/metanalise/_manifest.js (source of truth for build states)`
- **Priority:** MEDIUM — worth doing next QA session

### P003: KBP advisory → structural
- **Target:** .claude/agents/qa-engineer.md
- **Proposed action:** Add explicit "STOP if referencing a second slide ID" instruction in agent preamble. Already present in qa-pipeline.md but could be reinforced in agent definition.
- **Draft:** Add to qa-engineer.md: `## Hard Guard: 1 slide per invocation. If you detect a second slide ID in the task, STOP and report violation.`
- **Priority:** MEDIUM — next QA session

### P004: design-principles.md — No action
- **Target:** docs/aulas/design-principles.md
- **Proposed action:** None. Content is still valid. Staleness is cosmetic.
- **Priority:** LOW

### P005: Skill-rule cross-references — No action
- **Target:** .claude/skills/*/SKILL.md
- **Proposed action:** None. Skills are modular. Adding rule references would increase maintenance burden without clear benefit.
- **Priority:** LOW

---

## Evolution Metrics (vs S82 baseline)

| Metric | S82 baseline | S91 | Delta |
|--------|-------------|-----|-------|
| User corrections/session | 2.0 | 0.0 | -100% |
| KBP violations/session | 3.05 | 0.0 | -100% |
| Tool errors | 61 | 0 | -100% |
| Retries | 9 | 0 | -100% |
| Proposals | 6 accepted | 5 proposed | — |
| New KBPs | 5 | 0 | Stable |

**Interpretation:** The enforcement mechanisms from S82-S85 (known-bad-patterns, anti-drift, momentum brake, self-healing loop) achieved their goal. However, this period was dominated by planning/infra sessions — the true test will be the next QA or slide-authoring session where KBP-04 and KBP-05 historically trigger.

---

Coautoria: Lucas + Opus 4.6 | S91 2026-04-06
