# /insights S193 — 2026-04-14

> Scope: S174-S192 (19 sessions, 29 commits). + S193 correction.
> Phases: SCAN → AUDIT → DIAGNOSE → PRESCRIBE → QUESTION
> Verdict: **STABLE** — 1 calibration correction (S193), 2 rule conflicts found, 1 KBP-14 recurrence

---

## Phase 1 — SCAN

### Signal sources

| Source | Count | Notes |
|---|---|---|
| Commits analyzed | 29 | git log S174-S192 |
| Success-log entries | 20 | Clean commits S181-S192 |
| nudge-commit firings | 79 | hook-stats.jsonl |
| nudge-checkpoint firings | 45 | hook-stats.jsonl |
| model-fallback firings | 22 | hook-stats.jsonl |
| Calibration correction | 1 | S193: velocity without reflection |

### Key git patterns

- s-rob2 rework loop: 11 sessions (S174-S184) on same slide
- FOUC regression: S181-S182 fix-of-fix across 3 slides
- Code reverted: S180 (docs only, code reverted)
- KBP pointer drift: S192 (4 pointers broken, fixed)
- Gemini model drift: S175 fix

### Hook calibration

nudge-commit: 79 firings / 3 days. nudge-checkpoint: 45. model-fallback: 22.
No anomalies — frequency consistent with high-activity slide production period.

---

## Phase 2 — AUDIT

| Rule | Status | Evidence |
|---|---|---|
| anti-drift §Momentum brake | **VIOLATED S193** | Executed /insights greps without proposing approach |
| anti-drift §KBP-14 (velocity) | **RECURRED S193** | "seja profissional, refletir before act" |
| qa-pipeline.md §3 temp | **STALE** | Says 1.0 editorial, code uses 0.2 (S178), Google recommends 1.0 for Gemini 3 |
| slide-patterns.md §5 | **CONFLICTS** with slide-rules.md §1+§10 | Uses data-background-color (dead) + inline style (prohibited) |
| slide-rules.md §9 FOUC | **VIOLATED S181-S182** | FOUC fix in 3+ slides |
| KBP pointers | **STALE S192** | 4 pointers broken, fixed in 39678e0 |
| session-hygiene | **FOLLOWED** | Plans purged S191, HANDOFF updated |
| coauthorship | **FOLLOWED** | Co-author in commits |
| design-reference OKLCH | **FOLLOWED** | S188 rewrite used oklch |
| mcp_safety / notion-cross-val | **NO DATA** | No Notion operations |
| multi-window | **NO DATA** | No multi-window in period |

---

## Phase 3 — DIAGNOSE

| ID | Category | Priority |
|---|---|---|
| F001 | RULE_VIOLATION — KBP-14 recurrence: velocity without reflection (S193) | HIGH |
| F002 | RULE_STALE — qa-pipeline.md §3: temp=1.0 in doc, 0.2 in code, Google says 1.0 for Gemini 3 | HIGH |
| F003 | RULE_CONFLICT — slide-patterns.md §5 contradicts slide-rules.md §1+§10 | HIGH |
| F004 | PATTERN_REPEAT — s-rob2 11-session rework loop (S174-S184) | MEDIUM |
| F005 | RULE_STALE — gemini-qa3.mjs --help says "Gate 4 default: 1.0" but TEMP_DEFAULTS=0.2 | MEDIUM |
| F006 | HOOK_GAP — nudge-commit 79 firings/3d — threshold review | LOW |

---

## Phase 4 — PRESCRIBE

### P001 — KBP-14 strengthening (pre-execution gate) [PENDING]

Target: .claude/rules/anti-drift.md §Momentum brake
Draft: "Pre-execution reflection gate (KBP-14 enforcement): Before ANY multi-step execution, state WHAT+WHY in 1 sentence. Cannot articulate = haven't reflected enough."

### P002 — qa-pipeline.md §3 temperature stale [PENDING]

Target: .claude/rules/qa-pipeline.md §3
Change: Update temp from 1.0 (S71) to reflect reality: code uses 0.2 (S178), Google recommends 1.0 for Gemini 3.
Research: 5 official Google sources confirm Gemini 3 optimized for temp=1.0. Lower temp causes looping/degraded reasoning.

### P003 — slide-patterns.md §5 conflict [PENDING]

Target: .claude/rules/slide-patterns.md §5
Change: Replace data-background-color (dead attr) with class="theme-dark", remove inline style.

---

## Phase 4.5 — Double-Loop Audit

| KBP/Rule | Verdict | Evidence | Action |
|----------|---------|----------|--------|
| KBP-14 Velocity Over Comprehension | **MODIFY** | Recurred S193 — needs enforcement | P001 |
| qa-pipeline.md §3 | **UPDATE** | Temp stale: doc vs code vs Google | P002 |
| slide-patterns.md §5 | **UPDATE** | Conflict with slide-rules.md | P003 |
| All other KBPs (1-13, 15-18) | KEEP | No violations or staleness evidence | — |
| proven-wins.md (NEW S196) | KEEP | New rule, no data yet | — |
| elite-conduct.md (NEW S195) | KEEP | New rule, no data yet | — |

---

## Gemini Parameter Research (S193)

5 official Google sources confirm: Gemini 3.x models optimized for temperature=1.0.
Lowering below 1.0 causes: looping, degraded reasoning, fallback responses.
Current script: 0.1-0.2 (S178 hardening for Gemini 2.x, NOT updated for 3.x migration).
Recommendation: restore to 1.0 for all calls when using Gemini 3.x models.

Sources:
- Gemini 3 Developer Guide (ai.google.dev)
- Gemini 3 Prompting Guide (cloud.google.com)
- Parameter tuning guide (cloud.google.com)
- AI Studio tooltip (discuss.ai.google.dev)
- Content generation parameters (cloud.google.com)

---

## Evolution metrics

| Metric | S154 (previous) | S193 (current) | Delta |
|---|---|---|---|
| Sessions analyzed | 3 | 19 | +16 |
| User corrections | 0 | 1 (calibration) | +1 |
| corrections_per_session | 0 | 0.05 | +0.05 |
| KBP violations | 0 | 1 (KBP-14) | +1 |
| kbp_per_session | 0 | 0.05 | +0.05 |
| calibration_feedback | 3 | 1 | -2 |
| Rule conflicts found | 0 | 2 | +2 |

Direction: STABLE. Single calibration correction, not behavioral regression.

---

## OK / WARN / REGRESSION

**OK: Trend stable.** 1 calibration correction in 19 sessions. 2 rule conflicts are doc-stale, not production violations. KBP-14 recurred but pattern is self-correcting (user flags immediately). Gemini temp research is net-positive — identified root cause of "less creative" QA output.
