# /insights Report — S100 (covering S92-S99)
> Date: 2026-04-07 | Sessions analyzed: 8
> Last /insights: S91 (covered S86-S90, found 0 issues — planning/infra sessions only)

## Executive Summary

- **KBP-01 (scope creep) recurred in S97+S98 despite rules+memory**, confirming that prose-based guardrails are insufficient. S99 implemented structural fix (momentum-brake hooks with `permissionDecision: "ask"`). First hooks-based enforcement of a KBP.
- **New pattern identified: Agent Delegation Without Verification (candidate KBP-06).** S99 launched 3 agents that failed before diagnosing root cause (wrong agent type for the task). Memory file created but no KBP entry yet.
- **Adversarial review pipeline matured.** S95-S98 ran Codex against the full codebase: 23 findings (5 P0, 17 P1, 1 P2), 16 resolved. However, delegation failures (codex:rescue instead of general-purpose) wasted 3 invocations in S99.
- **QA pipeline underwent major simplification.** S95 removed 2093 lines of legacy code. S97 removed the 30-word rule and rewrote the path to 11 linear steps. S98 applied editorial fixes. Pipeline now has clear separation: Opus Preflight (4 dims) → Lucas loop → Gemini Inspect → Gemini Editorial.
- **Infrastructure hardened significantly.** S92 validated OTel+Langfuse. S93 added L6 chaos engineering. S94 added APL (3 hooks). S96 fixed 5 P0 security issues (Docker secrets, port binding, debug exporter). Hooks grew from 22 to 28 registrations.

## Error Patterns

| Pattern | Freq | Sessions | Severity | Classification |
|---------|------|----------|----------|----------------|
| KBP-01 reincidence: model swap without permission | 1 event | S98 | High | Agent error — autonomous fallback (Pro→Flash) |
| KBP-01 reincidence: chaining without stop (QA) | 3 events | S97 | Medium | Agent error — skipped momentum brake, invented criteria |
| Wrong agent type for task (codex:rescue ≠ reviewer) | 3 invocations | S99 | High | Agent error — fire-and-forget delegation |
| Retry without diagnosis (same wrong agent) | 2 retries | S99 | Medium | Agent error — KBP-01 adjacent (acting without understanding) |
| stop-detect-issues false positives (13 stale) | 13 entries | S98 | Low | System error — hook overfiring on plan files |
| Codex batches 1+4 returned empty | 2 batches | S95 | Medium | System error — Codex CLI did not produce findings |
| QA criteria invented from training data | 1 event | S97 | Medium | Agent error — KBP-04 reincidence (dims from head, not docs) |

## KBP Compliance

| KBP-ID | Description | Recurrences S92-S99 | Fix Effectiveness | Notes |
|--------|-------------|--------------------:|-------------------|-------|
| KBP-01 | Scope creep | **4** (S97: 3, S98: 1) | WEAK — prose rules failed; structural fix (hooks) deployed S99, untested under load | Model swap Pro→Flash in S98 is KBP-01 variant. S97 QA session broke momentum brake 3 times. S99 hooks now gate via `permissionDecision: "ask"` |
| KBP-02 | Context overflow | **0** | EFFECTIVE — proactive checkpoints working | No context rot incidents despite heavy sessions (S95-S96 had 23+ findings to process) |
| KBP-03 | Script redundancy | **0** | EFFECTIVE — script primacy rule holding | No new scripts created without request. QA pipeline simplified (removed duplicates in S95) |
| KBP-04 | Invented QA criteria | **1** (S97) | PARTIAL — dims gate added S97 but violation occurred in same session before fix | S97 fix: 4 dims with cross-ref sources + count check. Fix is structural but needs testing |
| KBP-05 | Batch QA multi-slide | **0** | EFFECTIVE — no QA batch violations | No multi-slide QA attempted in this period (only s-objetivos was QA'd) |

**Trend vs S91 baseline:** S91 reported 0 recurrences across S86-S90 (planning/infra only). S92-S99 saw **5 total KBP recurrences** because content/QA sessions resumed (S97-S99). This is expected — the S86-S90 zero was an artifact of session type, not true improvement. The real question is whether the new structural fixes (momentum-brake hooks, dims gate) will hold.

## New Pattern Candidates

### Candidate KBP-06: Agent Delegation Without Verification

- **When:** Launching subagents (especially via Skill tool) without reading the agent definition, confirming output format, or asking Lucas
- **Symptom:** Agent fails silently or returns empty output. Lucas says nothing (because the failure is invisible until 3 invocations later)
- **Evidence:**
  - S99: 3 failed invocations — codex:codex-rescue used for adversarial review (it delegates to external Codex CLI, returns empty), then researcher (output not persisted). 3 wasted invocations before root cause identified
  - S99: Memory file `feedback_agent_delegation.md` created with 4-point checklist
- **Cause:** Agent assumes subagent type from name without reading definition. "codex:rescue" sounds like it does rescue work, but it actually delegates to an external CLI
- **Proposed fix type:** KBP entry + memory (already in memory, needs KBP codification)
- **Proposed KBP text:** See Proposed Fixes below

### Candidate KBP-07: Autonomous Model/Tool Fallback Without Permission

- **When:** A tool/model fails (timeout, error, unavailability) and agent switches to alternative without asking
- **Symptom:** Lucas says "pare de fazer as coisas sem eu no loop", "sem flash"
- **Evidence:**
  - S98: Gemini Pro timed out 3x, agent switched to Flash autonomously. Lucas corrected immediately
  - Memory file `feedback_no_fallback_without_approval.md` created
- **Cause:** Helpfulness bias disguised as pragmatism — agent treats failure as permission to improvise
- **Assessment:** This is a KBP-01 variant (scope creep in disguise). Rather than a separate KBP, it should be explicitly listed as a KBP-01 manifestation. Separate memory file is correct for retrieval, but the canonical enforcement is momentum-brake (which now gates all tool calls).
- **Proposed fix type:** Append to KBP-01 as named variant, not separate KBP

## Proposed Systemic Fixes

### P001: Add KBP-06 to known-bad-patterns.md [NEW KBP]

**Priority: P0** — This pattern wasted 3 invocations and produced zero output. The cost is invisible (no user correction needed because the agent noticed the failure itself), making it especially dangerous.

```markdown
## [KBP-06] Agent Delegation Without Verification

- **When**: Launching subagents via Skill/Agent tool without reading the agent definition or confirming with Lucas
- **Symptom**: Agent fails silently or returns empty output. Multiple retries before root cause identified
- **Cause**: Agent assumes subagent capability from name/description without reading definition. Retry without diagnosis compounds the error
- **Fix**: Before any Agent/Skill invocation: (1) read agent definition, (2) confirm output is capturable, (3) ask Lucas which agent to use if uncertain, (4) test 1 before launching N. Memory: `feedback_agent_delegation.md`
- **Incidence**: 3 failed invocations / 1 session
- **Sessions**: S99
```

### P002: Update KBP-01 with S97-S98 variant [KBP UPDATE]

**Priority: P1** — KBP-01 text should document the "autonomous fallback" variant and reference the momentum-brake hooks as the structural fix. Current text only mentions prose-based momentum brake.

Changes:
- Add S97/S98 to session list
- Add "autonomous model/tool fallback" as named variant under Symptom
- Update Fix section to reference momentum-brake hooks (S99) as structural enforcement
- Update incidence count: 24 → 28 events

### P003: Update failure-registry.json with S92-S99 data [REGISTRY UPDATE]

**Priority: P1** — Registry has no entries between S85 and S91 (6 sessions gap), and nothing for S92-S99. Add aggregate entry for this /insights run.

Proposed entry:
```json
{
  "id": "S100",
  "date": "2026-04-07",
  "note": "/insights run S100. Analyzed 8 sessions (S92-S99). KBP-01 recurred 4x (S97+S98). KBP-04 recurred 1x (S97). New pattern KBP-06 identified (agent delegation). Sessions mixed: infra (S92-S94), adversarial (S95-S96), QA+content (S97-S98), hooks+QA (S99).",
  "metrics": {
    "sessions_in_sample": 8,
    "user_corrections_total": 5,
    "user_corrections_per_session": 0.625,
    "kbp_violations": {
      "KBP-01_scope_creep": 4,
      "KBP-02_context_overflow": 0,
      "KBP-03_agent_script_redundancy": 0,
      "KBP-04_wrong_criteria": 1,
      "KBP-05_batch_violation": 0,
      "KBP-06_blind_delegation": 3
    },
    "kbp_total": 8,
    "kbp_per_session": 1.0,
    "tool_errors": 5,
    "retries": 3
  },
  "insights_run": true,
  "new_kbps_added": 1,
  "proposals_accepted": 0,
  "proposals_rejected": 0
}
```

**Trend analysis:** corrections_per_session rises from 0.4 → recalculated with S100 data. kbp_violations_per_session rises from 0.61. This is NOT a regression — it reflects the first QA/content sessions since enforcement was implemented. S86-S90 zeros were from planning/infra-only sessions. The real test is S101+ with momentum-brake hooks active.

### P004: stop-detect-issues.sh false positive fix verification [HOOK VERIFICATION]

**Priority: P2** — S98 fixed the stop-detect hook (exclude .claude/plans/, check last 3 commits). Verify the fix is holding by checking if any pending-fixes files were created since S98.

### P005: Momentum-brake B5-02/04/05 fixes [PENDING FROM S99]

**Priority: P1** — Already documented in `.claude/plans/quizzical-cuddling-goose.md` with exact diffs. Three changes: `set -euo pipefail`, matcher `.*`, remove Write|Edit from exemptions. Not an /insights proposal — inherited backlog.

## Velocity Analysis

| Session | Focus | Commits | Lines Changed | Doing vs Debugging |
|---------|-------|---------|--------------|-------------------|
| S92 | OTel pipeline fix | 1 | ~20 | 90% doing, 10% debugging (env var override) |
| S93 | L6 chaos + docs refresh | 5 | ~500+ | 95% doing, 5% debugging |
| S94 | APL implementation | 1 | ~200 | 85% doing, 15% research (GSD evaluation) |
| S95 | QA simplification + Codex review | 1 | -2093 | 70% doing, 30% triage (Codex findings) |
| S96 | Codex fixes | 3 | ~300 | 80% doing, 20% analysis (skip/apply decisions) |
| S97 | QA pipeline rewrite + smoke test | 2 | ~200 | 60% doing, 40% debugging (30-word rule, QA workflow) |
| S98 | Slide fixes + Codex B1+B4 | 2 | ~200 | 70% doing, 20% debugging, 10% KBP-01 correction |
| S99 | Momentum-brake + QA capture | 2 | ~150 | 50% doing, 30% failed delegation, 20% documentation |

**Trend:** Infrastructure/hardening sessions (S92-S96) are highly productive — clear scope, measurable output, few corrections. Content/QA sessions (S97-S99) surface more friction — KBP-01 recurs when the agent has creative latitude. S99 had the most waste (3 failed agent delegations).

**Ratio doing:debugging across period:** ~75:25 overall. The 25% debugging is dominated by S97 (QA workflow issues) and S99 (agent delegation failures). Both have structural fixes now deployed or planned.

## Metrics

| Metric | Value |
|--------|-------|
| Sessions analyzed | 8 (S92-S99) |
| Total issues found | 13 |
| KBP-01 recurrences | 4 (S97: 3, S98: 1) |
| KBP-04 recurrences | 1 (S97) |
| KBP-02/03/05 recurrences | 0 |
| New pattern candidates | 2 (KBP-06 agent delegation, KBP-01 variant autonomous fallback) |
| Proposed new KBPs | 1 (KBP-06) |
| Proposed KBP updates | 1 (KBP-01 variant + sessions + momentum-brake fix) |
| Proposed registry updates | 1 (S100 aggregate) |
| Proposed hook fixes | 1 (stop-detect verification) |
| Pending from backlog (not /insights) | 1 (momentum-brake B5 fixes) |
| Hooks added S92-S99 | 6 (chaos-inject, chaos-report, APL x3, momentum-brake x3) |
| Lines removed S92-S99 | ~2500+ (QA cleanup S95, research MD cleanup S90) |
| Security fixes applied | 5 P0 + 6 P1 (S96) |
| Adversarial findings resolved | 16 of 23 |

## Comparison with Previous /insights

| Metric | S82 (baseline) | S91 | S100 |
|--------|---------------|-----|------|
| Sessions covered | 20 | 13 (S86-S90) | 8 (S92-S99) |
| User corrections/session | 2.0 | 0.0 | 0.625 |
| KBP violations/session | 3.05 | 0.0 | 1.0 |
| Session types | Mixed (QA+content+infra) | Planning/infra only | Mixed (infra+QA+content) |
| New KBPs added | 5 | 0 | 1 (proposed) |

**Interpretation:** The S91 zeros were misleading — they reflected session composition (no QA/content), not behavioral improvement. S92-S99 saw KBP recurrences once QA/content sessions resumed, but at significantly lower rates than the S82 baseline (1.0 vs 3.05 violations/session, 0.625 vs 2.0 corrections/session). The momentum-brake structural fix (S99) is the first attempt to enforce KBP-01 mechanically rather than through prose.

---

> Coautoria: Lucas + Opus 4.6 | /insights S100 | 2026-04-07
