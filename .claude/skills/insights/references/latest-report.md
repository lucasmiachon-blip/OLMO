# /insights S132 — Full Retrospective Report

> Period: 2026-04-09 (sessions S125-S132, post-S124 insights)
> Analyst: Opus 4.6 (orchestrator mode)
> Method: SCAN -> AUDIT -> DIAGNOSE -> PRESCRIBE
> Previous report: S124 (7 sessions, 5 corrections, zero KBP)
> Sessions analyzed: 15 substantial transcripts (~8 distinct sessions S125-S132)

## Executive Summary

First real stress test of the enforcement layer under production workloads (evidence HTML authoring, research pipeline, multi-window coordination, context diet). **Three KBP violations detected** after two consecutive zero-KBP periods. The zero-KBP streak ended because workloads shifted from infra to content production — exactly the scenario the S124 report predicted would stress-test untested rules.

| Metric | S82 baseline | S91 | S108 | S116 | S124 | S132 | Delta vs S124 |
|--------|-------------|-----|------|------|------|------|---------------|
| Sessions analyzed | 20 | 13 | 9 | ~7 | ~7 | ~8 | +1 |
| User corrections total | 40 | 0 | 12 | 8 | 5 | 9 | +80% |
| User corrections/session | 2.0 | 0.0 | 1.33 | 1.14 | ~0.71 | ~1.13 | +59% |
| KBP violations total | 61 | 0 | 8 | 0 | 0 | 3 | +3 |
| KBP violations/session | 3.05 | 0.0 | 0.89 | 0 | 0 | 0.38 | +0.38 |
| Tool errors | 61 | 0 | 0 | 2 | 1 | 3 | +2 |
| Retries | 9 | 0 | 0 | 0 | 1 | 2 | +1 |

Pattern: corrections and KBP violations rebounded modestly as workload shifted from pure infra to content-production + research-pipeline stress. This is expected — the untested rules (design, QA, research pipeline) encountered real-world friction.

## Proposals from S124 — Status

- P001 (beginner-calibrated explanations) — **APPLIED** (anti-drift.md §Transparency, confirmed in text)
- P002 (evidence narrative depth) — **APPLIED** (project_living_html.md §Estilo narrativo)
- P003 (QA/slide stress test) — **IN PROGRESS** (s-importancia work started S131-S132, rules now tested)

## Phase 1: SCAN — Incident Summary

| # | Session (slug) | S# | Category | Description | Severity |
|---|----------------|-----|----------|-------------|----------|
| I-01 | 19cf0527 (curious-crafting-mist) | S131 | KBP-10 VIOLATION | Agent deleted worker files, user said "nao era para remover todos os md so alguns" — had to undo | High |
| I-02 | c4f1fae4 (humble-churning-pearl) | S131 | ROLE VIOLATION | Worker attempted to create template file; user corrected "vc nao monta o templante vc eh worker" | Medium |
| I-03 | cab4eff5 (snug-purring-gadget) | S131 | CORRECTION | rm -rf failing on PowerShell (multiline syntax); user said "estou no powershell"; hook configured as block when should be ask | Medium |
| I-04 | 9bc17b78 (merry-rolling-adleman) | S130 | KBP-01 VIOLATION | Research scope drift — user corrected "a pesquisa era para o pre reading de forest plot, vies... nao va para os outros slides" | Medium |
| I-05 | 9bc17b78 (merry-rolling-adleman) | S130 | CORRECTION | Agent produced examples instead of real pre-reading content; user: "eu nao quero exemplos eu quero pre readings... Quero coisas metodologicas" | High |
| I-06 | 1ee9c152 (mighty-wishing-steele) | S127 | CORRECTION | User noted researcher not following combined approach; "o evidence researcher e o researcher nao esta seguinfo o combinado" | Medium |
| I-07 | 1ee9c152 (mighty-wishing-steele) | S127 | CORRECTION | Information should have been in changelog/memory; user: "era para estar no changelog ou memoria" | Low |
| I-08 | a5e65b5f (wise-jingling-castle) | S126 | CORRECTION | User noted research pipeline failure was a memory gap; "ja foi tentado arrumar o agente de pesquisa nao lancou todas as pernas" | Medium |
| I-09 | 6e8a0737 (rippling-sniffing-nest) | S129 | OPERATIONAL | Rate limit hit on evidence search; PubMed MCP session expiry during verification | Low |

**Hook stats (Step 1b):** 22 firings logged since last run — 13x nudge-checkpoint, 5x nudge-commit, 4x model-fallback. nudge-checkpoint fires frequently (13 in ~8 sessions = 1.6/session). model-fallback fires during research-heavy sessions only. No user complaints about any proactive hook.

**Success log:** 1 clean commit logged (S128 .claudeignore). Low volume — suggests hook deployed too recently for calibration.

## Phase 2: AUDIT — Rule Compliance Matrix

| Rule | Status | Evidence |
|------|--------|----------|
| anti-drift.md | PARTIAL VIOLATION | P001 applied and effective for explanations, but scope creep recurred (I-04) |
| coauthorship.md | FOLLOWED | All commits S125-S132 have co-authorship |
| known-bad-patterns.md | FOLLOWED + EXTENDED | KBP-08, KBP-09, KBP-10 added during this period |
| multi-window.md | VIOLATED (I-02) | Worker attempted orchestrator-only action (template creation) |
| session-hygiene.md | FOLLOWED | HANDOFF+CHANGELOG updated each session |
| mcp_safety.md | FOLLOWED | MCP gate hook (S130) enforcing ask-before-call |
| design-reference.md | FIRST TEST | s-importancia evidence HTML refactored against benchmark — rule followed |
| qa-pipeline.md | UNTESTED | No QA runs this period |
| slide-rules.md | UNTESTED | No slide construction (evidence only) |
| notion-cross-validation.md | UNTESTED | No Notion writes |

**Key observation:** The 4 "untested" rules from S124 report dropped to 2 untested (design-reference now tested, mcp_safety now enforced via hook). qa-pipeline and slide-rules remain untested — these will be stressed when s-importancia slide is actually built.

## Phase 3: DIAGNOSE — Prioritized Findings

### F-001 [KBP-10 RECURRENCE] Destructive commands despite new guard

**Evidence:** I-01 (S131, 19cf0527) — agent rm'd all worker MDs when user wanted selective removal
**Root cause:** KBP-10 was documented S130 and hook deployed, but the initial hook was "block" mode. User requested "ask" mode (I-03). Even after hook change, the agent over-deleted in a subsequent session. The guard pattern works for *agent-initiated* rm, but user-pasted rm commands in bash bypass the semantic guard.
**Impact:** High — data loss (worker outputs), required manual recovery
**Frequency:** 2 instances across 2 sessions (I-01, I-03)
**Category:** PATTERN_REPEAT

### F-002 [RULE_VIOLATION] Worker role boundary violation

**Evidence:** I-02 (S131, c4f1fae4) — worker attempted to create template HTML
**Root cause:** multi-window.md clearly states workers are read-only on repo + write only to `.claude/workers/`. Agent in worker mode tried to create a template file outside the worker directory.
**Impact:** Medium — caught by user immediately
**Frequency:** 1 instance
**Category:** RULE_VIOLATION

### F-003 [KBP-01 RECURRENCE] Research scope drift

**Evidence:** I-04 (S130, 9bc17b78) — research intended for forest-plot/bias pre-reading drifted to other slides
**Root cause:** Research task scope not pinned to specific deliverables. Agent generalized from "pre-reading research" to "all slides research". KBP-01 (scope creep) recurred in research context specifically — the anti-drift momentum brake works for code but research tasks have fuzzier boundaries.
**Impact:** Medium — wasted tokens, user had to redirect
**Frequency:** 2 instances (I-04, I-08 across 2 sessions)
**Category:** PATTERN_REPEAT

### F-004 [RULE_GAP] Research output quality — examples vs content

**Evidence:** I-05 (S130, 9bc17b78) — agent produced generic examples instead of sourced pre-reading content
**Root cause:** No explicit rule that research output must be grounded in retrieved sources, not synthesized from training data. The user specifically said they wanted "coisas metodologicas para residentes" from actual papers, not generated examples.
**Impact:** High — fundamentally wrong deliverable type
**Frequency:** 1 instance
**Category:** RULE_GAP

### F-005 [POSITIVE] KBP system self-extending

**Evidence:** S125 (KBP-08), S129 (KBP-09), S130 (KBP-10) — three new KBPs added this period
**Note:** The anti-pattern library grew from 7 to 10 entries. Each was triggered by real incidents and documented with fix. The Via Negativa system is working as designed — errors are captured and codified.

### F-006 [POSITIVE] Context optimization delivered

**Evidence:** S126-S128 — rules consolidation (-22%), MCP pruning (12->3 active), .claudeignore, affordance bias removal
**Note:** Multi-session effort to reduce context load succeeded. This is the first time the system optimized itself proactively rather than reactively fixing errors.

### F-007 [POSITIVE] Evidence HTML benchmark established

**Evidence:** S131-S132 — s-importancia fully refactored against pre-reading-heterogeneidade benchmark
**Note:** The "evidence benchmark" decision (S131) creates a reusable standard. All 6 remaining evidence HTMLs now have a concrete reference to follow.

## Phase 4: PRESCRIBE — Proposals

### P001 [PATTERN_REPEAT] Selective deletion guard — confirm list before rm

**Evidence:** I-01, I-03 (S131)
**Root cause:** Guard catches agent-initiated rm but not user-pasted rm commands where agent over-interprets scope
**Proposed fix:**
- **Target:** `.claude/rules/anti-drift.md` §Failure response (or new subsection)
- **Change:** Add explicit "selective deletion protocol" after KBP-10 reference
- **Draft:**
```
## Selective deletion protocol (extends KBP-10)

When user asks to remove "some" files from a set:
1. List ALL files in the target directory
2. Ask user to confirm WHICH specific files to remove (by number or name)
3. Execute removal ONE directory/file at a time, confirming each
4. NEVER batch-delete when the request says "some" or "os inuteis" — ambiguity = ask
```

### P002 [RULE_GAP] Research scope pinning

**Evidence:** I-04, I-08 (S129-S130)
**Root cause:** Research tasks have fuzzy scope boundaries; momentum brake insufficient
**Proposed fix:**
- **Target:** `.claude/rules/anti-drift.md` §Scope discipline
- **Change:** Add research-specific scope clause
- **Draft:**
```
- Research tasks: pin scope to SPECIFIC deliverable(s) named in the request. If user says
  "pesquisa para pre-reading de forest plot", research ONLY forest plot pre-reading content.
  Do not generalize to adjacent slides or topics. Scope expansion requires explicit user request.
```

### P003 [RULE_GAP] Research output grounding requirement

**Evidence:** I-05 (S130)
**Root cause:** No rule requiring research output to come from retrieved sources
**Proposed fix:**
- **Target:** `.claude/rules/anti-drift.md` §Verification (add subsection) OR research SKILL.md
- **Change:** Add research output grounding requirement
- **Draft:**
```
- Research output grounding: When producing content for evidence/pre-reading, every claim must
  trace to a retrieved source (PubMed, SCite, Perplexity, NLM). Training-data synthesis
  ("examples") is NOT acceptable as primary content. If no source found, state the gap explicitly
  rather than generating plausible content.
```

### P004 [RULE_VIOLATION] Worker boundary enforcement reminder

**Evidence:** I-02 (S131)
**Root cause:** Worker role clear in multi-window.md but agent forgot in-context
**Proposed fix:**
- **Target:** `.claude/rules/multi-window.md` §Roles
- **Change:** Add explicit file-creation prohibition
- **Draft:**
```
**Workers NEVER:** create HTML/CSS/JS files, edit _manifest.js, modify slides/,
create templates, or perform any action that changes the build output.
Workers CREATE only: .md files inside `.claude/workers/{task-name}/`.
```

### P005 [MONITORING] nudge-checkpoint calibration

**Evidence:** 13 firings in ~8 sessions (1.6/session)
**Root cause:** nudge-checkpoint fires on a time-based threshold
**Proposed fix:** No change yet — 1.6/session seems reasonable. If it exceeds 2.5/session in the next period, consider increasing the threshold. model-fallback (4 firings, all during research) is correctly targeted. This is a monitoring note, not a code change.

---

## Evolution Metrics (vs S124)

| Previous proposal | Status |
|---|---|
| P001 beginner-calibrated explanations | APPLIED — confirmed in anti-drift.md |
| P002 evidence narrative depth | APPLIED — confirmed in project_living_html.md |
| P003 QA/slide stress test | IN PROGRESS — s-importancia evidence tested, slide build pending |

**Pattern resolution:** Worker timestamp issue (F-002 from S124) — RESOLVED (no recurrence).
**New patterns:** 3 (F-001 selective deletion, F-003 research scope drift, F-004 output grounding).
**Net assessment:** The system expanded from infra to content production. The KBP rebound (+3) is expected and healthy — it means the system is encountering new failure modes rather than repeating old ones. All 3 new KBPs (08/09/10) were caught, documented, and hooks deployed within the same period.

## Structured JSON Output

```json
{
  "insights_run": "2026-04-09",
  "sessions_analyzed": 8,
  "proposals": [
    {
      "id": "P001",
      "category": "PATTERN_REPEAT",
      "title": "Selective deletion guard — confirm list before rm",
      "target_file": ".claude/rules/anti-drift.md",
      "priority": "high",
      "frequency": 2,
      "draft": "## Selective deletion protocol (extends KBP-10)\n\nWhen user asks to remove \"some\" files from a set:\n1. List ALL files in the target directory\n2. Ask user to confirm WHICH specific files to remove (by number or name)\n3. Execute removal ONE directory/file at a time, confirming each\n4. NEVER batch-delete when the request says \"some\" or \"os inuteis\" — ambiguity = ask"
    },
    {
      "id": "P002",
      "category": "RULE_GAP",
      "title": "Research scope pinning",
      "target_file": ".claude/rules/anti-drift.md",
      "priority": "medium",
      "frequency": 2,
      "draft": "- Research tasks: pin scope to SPECIFIC deliverable(s) named in the request. If user says \"pesquisa para pre-reading de forest plot\", research ONLY forest plot pre-reading content. Do not generalize to adjacent slides or topics. Scope expansion requires explicit user request."
    },
    {
      "id": "P003",
      "category": "RULE_GAP",
      "title": "Research output grounding requirement",
      "target_file": ".claude/rules/anti-drift.md",
      "priority": "high",
      "frequency": 1,
      "draft": "- Research output grounding: When producing content for evidence/pre-reading, every claim must trace to a retrieved source (PubMed, SCite, Perplexity, NLM). Training-data synthesis (\"examples\") is NOT acceptable as primary content. If no source found, state the gap explicitly rather than generating plausible content."
    },
    {
      "id": "P004",
      "category": "RULE_VIOLATION",
      "title": "Worker boundary — explicit file-creation prohibition",
      "target_file": ".claude/rules/multi-window.md",
      "priority": "medium",
      "frequency": 1,
      "draft": "**Workers NEVER:** create HTML/CSS/JS files, edit _manifest.js, modify slides/, create templates, or perform any action that changes the build output. Workers CREATE only: .md files inside `.claude/workers/{task-name}/`."
    },
    {
      "id": "P005",
      "category": "MONITORING",
      "title": "nudge-checkpoint calibration watch",
      "target_file": "N/A",
      "priority": "low",
      "frequency": 0,
      "draft": "Monitor: if nudge-checkpoint exceeds 2.5 firings/session in next period, increase threshold."
    }
  ],
  "kbps_to_add": [],
  "pending_fixes_to_add": [
    {
      "item": "Apply selective deletion protocol to anti-drift.md (P001)",
      "priority": "P1",
      "target": ".claude/rules/anti-drift.md"
    },
    {
      "item": "Add research output grounding rule (P003)",
      "priority": "P1",
      "target": ".claude/rules/anti-drift.md"
    }
  ],
  "metrics": {
    "rule_violations": 3,
    "user_corrections": 9,
    "retries": 2,
    "patterns_resolved_since_last": 1,
    "patterns_new": 3
  }
}
```

---
Coautoria: Lucas + Opus 4.6 | S132 2026-04-09
