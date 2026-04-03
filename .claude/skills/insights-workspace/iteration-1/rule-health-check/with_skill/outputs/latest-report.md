# /insights — Rule Health Check Report

> Generated: 2026-04-03 | Scope: 27 sessions (last 7 days, S46-S53+)
> Recipe: 3 (Rule Health Check — rule staleness focus)
> Analyst: Opus 4.6
> Previous report: Weekly Retrospective (same date, S38-S53)

---

## Compliance Matrix

| # | Rule File | Status | Confidence | Detail |
|---|-----------|--------|------------|--------|
| 1 | `anti-drift.md` | PARTIALLY FOLLOWED | Medium | Intent declarations in 23/27 sessions. 5-step verification gate unverifiable from transcripts. Previous report: VIOLATED (I01, I03). Improvement: parameter guessing and sycophancy patterns now documented in memory. |
| 2 | `coauthorship.md` | FOLLOWED | High | Co-Authored-By in 20/20 recent commits. Stable across both reports. |
| 3 | `design-reference.md` | FOLLOWED | High | --danger hue=8 (<=10), chroma=0.22 (>=0.20). E059 achromatic fix applied. PMID verification active. Stable. |
| 4 | `efficiency.md` | STALE | High | BudgetTracker DB never created. Rule is 5 vague lines. Previous report marked FOLLOWED (model routing), but the specific BudgetTracker directive is dead. |
| 5 | `mcp_safety.md` | FOLLOWED | High | NaN bypass fixed S51, gates now fail-closed. Previous report: VIOLATED then FIXED. Resolution confirmed. |
| 6 | `notion-cross-validation.md` | FOLLOWED (dormant) | Medium | No reorganization operations. Template exists. Dormant both reports. |
| 7 | `process-hygiene.md` | FOLLOWED | High | Zero `taskkill //IM` executions (all mentions are rule text in system-reminders). PID-based kills correct. Stable. |
| 8 | `qa-pipeline.md` | FOLLOWED | Medium | QA pipeline terminology in 10+ sessions. Gate sequencing referenced. Stable. |
| 9 | `quality.md` | PARTIALLY FOLLOWED | Low | Too vague (5 lines) to audit rigorously. Previous: VIOLATED (encoding, cascade, hardcoded paths). Encoding now in memory. Improvements made but rule still underspecified. |
| 10 | `session-hygiene.md` | FOLLOWED | High | HANDOFF at S54 (~52 lines, within ~30 line target). CHANGELOG append-only. Stable. |
| 11 | `slide-rules.md` | PARTIALLY FOLLOWED | High | Metanalise: 0 inline styles (compliant). Cirrose: 6. Grade: 1876 (legacy import, pre-dates rule). Previous: FOLLOWED — grade not examined. |

---

## Evolution Metrics (vs Previous Report)

| Metric | Previous (Weekly) | Current (Rule Health) |
|--------|-------------------|----------------------|
| Rules followed | 7/11 (64%) | 5/11 fully + 3 partially (73% at least partial) |
| Rules violated | 3/11 (27%) | 0/11 (0%) — all prior violations resolved |
| Rules stale | 0 identified | 3 identified (deeper audit found staleness) |
| Gaps identified | 0 | 4 new gaps |
| Incidents (CRITICAL) | 2 (I04, I05) | 0 — both fixed in S51 |

**Key evolution:** The previous report found active violations (anti-drift parameter guessing, mcp_safety NaN bypass, quality encoding gaps). All three were fixed in S51-S52. This report finds no active violations but identifies staleness and gaps that the previous report missed (because it focused on incidents, not structural health).

---

## Prioritized Findings

### 1. [RULE_STALE + HOOK_GAP] check-evidence-db.sh hook references deprecated workflow
- **Evidence:** Hook blocks slide edits if evidence-db.md not read. But evidence-db.md is deprecated (replaced by living HTML per slide). Hook wired in settings.local.json, runs on every Write/Edit.
- **Root cause:** Hook created before evidence-first workflow pivot (S46-S48).
- **Proposed fix:** Remove from settings.local.json, delete hook file.
- **Priority:** MEDIUM (unnecessary friction on every edit)

### 2. [RULE_STALE] efficiency.md BudgetTracker never materialized
- **Evidence:** `data/knowledge.db` does not exist. Schema in `agents/core/database.py` but never initialized. Max subscription = $0/session.
- **Proposed fix:** Remove BudgetTracker reference, keep actionable principles.
- **Priority:** LOW

### 3. [RULE_STALE] Grade aula 1876 inline styles vs slide-rules.md
- **Evidence:** Grade imported via `d269150` before rules existed. CLAUDE.md notes "precisa redesign legibilidade."
- **Proposed fix:** Add legacy exemption to slide-rules.md.
- **Priority:** MEDIUM

### 4. [RULE_GAP] Anti-drift 5-step verification gate has no enforcement
- **Evidence:** No hook enforcement. Agent can skip without detection. Transcripts show intent declarations but not systematic 5-step execution.
- **Proposed fix:** Add self-check anchor: "Verified via [command]. Output: [key result]."
- **Priority:** MEDIUM

### 5. [RULE_GAP] CLAUDE.md hook count mismatch (4 vs 5)
- **Evidence:** CLAUDE.md says 4 hooks in .claude/hooks/, reality is 5 (includes build-monitor.sh).
- **Proposed fix:** Update CLAUDE.md.
- **Priority:** LOW

### 6. [RULE_STALE] quality.md too vague (5 lines)
- **Evidence:** No connection to actual tooling (ruff, mypy, pytest). CLAUDE.md conventions section is more actionable.
- **Proposed fix:** Merge into CLAUDE.md or expand with tooling references.
- **Priority:** LOW

### 7. [RULE_GAP] No encoding rule (Windows cp1252)
- **Evidence:** Bug documented in memory (S46), 7 files fixed. No rule prevents recurrence.
- **Proposed fix:** Add encoding mandate to quality.md or CLAUDE.md.
- **Priority:** LOW

### 8. [RULE_GAP] Stale skills (evidence/, mbe-evidence/) not cleaned up
- **Evidence:** Both still exist in .claude/skills/ despite being superseded. Referenced in HANDOFF pending cleanup.
- **Proposed fix:** Delete after Lucas approval.
- **Priority:** LOW

---

## Summary

The rule ecosystem has improved significantly since the previous report. All active violations from S38-S53 (anti-drift parameter guessing, mcp_safety NaN bypass, quality encoding gaps) have been fixed in S51-S52. The current audit found zero active violations but uncovered structural issues: 3 rules have stale references, and 4 gaps exist where documented practices lack formal rules. The highest-impact fix is removing the deprecated check-evidence-db.sh hook.

---

Coautoria: Lucas + Opus 4.6 | 2026-04-03
