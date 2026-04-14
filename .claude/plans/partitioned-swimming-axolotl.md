# Plan: S196 Post-Fase 2 — Audit-Driven Consolidation

## Context

Hooks Fase 2 complete (34→29 registros, 0 node spawns). Two sentinel audits running:
1. Scripts professionalism (quality, references, redundancy, edge cases)
2. Orchestration integrity (settings↔scripts, agents, rules, docs, permissions)

New rule `proven-wins.md` establishes maturity tiers. Most components are currently **Unaudited** — they work but haven't been through a quality loop. This plan structures what happens after the audits report.

## Phase 1: Triage audit findings

Wait for both sentinel reports. Classify each finding:

| Severity | Action |
|----------|--------|
| CRITICAL | Fix immediately (broken references, missing scripts, wrong paths) |
| WARN | Fix this session if <15 min effort, else backlog |
| INFO | Note for future, no action now |

## Phase 2: Backlog hygiene

Mark RESOLVED (already done):
- #3: Hook/config system review → Fase 1+2 DONE
- #15: Hooks reduction audit → 34→29 DONE

Review if any other items are stale or superseded.

## Phase 3: Plans archive

2 consumed plans in `.claude/plans/`:
- `crispy-munching-blum.md` — Hooks Fase 2 master plan (S194-S196)
- `functional-prancing-clarke.md` — Steps 4-5 detail plan (S195-S196)

Propose: archive both as `S196-crispy-munching-blum.md` and `S196-functional-prancing-clarke.md`.

## Phase 4: Apply audit results

Based on findings, create targeted fixes grouped by:
- **Scripts**: quoting, error handling, missing headers, edge cases
- **Orchestration**: stale permissions, orphan references, doc count drift
- **Maturity promotion**: scripts that pass audit → promote to Audited tier

## Verification

- `jq . .claude/settings.local.json` (valid JSON)
- `ls hooks/*.sh .claude/hooks/*.sh | wc -l` matches registration count
- All paths in settings reference existing files
- HANDOFF counts match reality

## Sentinel 1: Scripts Professionalism — COMPLETE

### CRITICAL (fix this session)

| # | Finding | Scripts | Fix |
|---|---------|---------|-----|
| S1 | **Tool-call counter glob mismatch** — files named `196_20260414_*.txt` but glob looks for `20260414_*.txt`. Counts always 0. SCORECARD/APL cost broken since session-number prefix was introduced. | stop-metrics.sh, ambient-pulse.sh, apl-cache-refresh.sh | Fix glob pattern: `cc-calls-*_${TODAY}_*.txt` or `cc-calls-${SESSION_NUM}_*.txt` |
| S2 | **guard-bash-write Pattern 7 FP on mypy** — regex `(python3?\|py)\s+` matches `mypy` → every mypy call triggers "Python execution detected". | guard-bash-write.sh | Add word boundary: `\b(python3?\|py)\b` |

### WARN (fix if <15 min, else backlog)

| # | Finding | Scripts | Fix |
|---|---------|---------|-----|
| S3 | Momentum-brake "Armed" noise — prints on every PostToolUse including Read/Grep/Glob. ~300 lines/session. | post-global-handler.sh | Suppress print for exempt tools (Read\|Grep\|Glob\|Glob) |
| S4 | Node not migrated to jq — 4 scripts still spawn node for JSON parsing. | guard-lint-before-build, guard-research-queries, lint-on-edit, model-fallback-advisory | jq migration (same pattern as S193) |
| S5 | Hygiene check duplication — stop-quality and stop-metrics both check HANDOFF/CHANGELOG independently with different semantics. | stop-metrics.sh | Remove hygiene block from stop-metrics (stop-quality is the authoritative check) |
| S6 | guard-lint-before-build hardcoded path — only hook using absolute path instead of `$(dirname "$0")` | guard-lint-before-build.sh | Use relative path resolution |

### INFO (no action now)

| # | Finding | Notes |
|---|---------|-------|
| S7 | pre-compact-checkpoint header says "Stop" but registered as PreCompact | Cosmetic, no functional bug |
| S8 | post-compact-reread.sh JSON injection risk via SESSION_NAME | Low probability (session names are simple strings) |
| S9 | stdin drain missing in 7 scripts | Most functionally drain via `$(cat)`. Protocol compliance, not reliability. |
| S10 | stop-quality prints HANDOFF on every Stop | By design (context recovery). Early exit prevents double-print. |

### Maturity summary

| Tier | Count | Scripts |
|------|-------|---------|
| Proven (no issues) | 8 | allow-plan-exit, guard-mcp-queries, guard-read-secrets, guard-secrets, momentum-brake-clear, notify, nudge-checkpoint, post-bash-handler |
| Proven (minor) | 6 | guard-write-unified, nudge-commit, session-compact, session-start, stop-notify, stop-should-dream |
| Audited (needs work) | 8 | chaos-inject-post, coupling-proactive, guard-research-queries, lint-on-edit, model-fallback-advisory, post-compact-reread, pre-compact-checkpoint, stop-quality |
| Broken (silent) | 3 | stop-metrics (counter), ambient-pulse (counter), apl-cache-refresh (counter + node) |
| Medium risk | 2 | guard-bash-write (mypy FP), guard-lint-before-build (hardcoded + node) |

## Sentinel 2: Orchestration — TRUNCATED

Agent ran 50 tool calls / 340s but result summary was truncated. Orchestration integrity checks should be done inline during execution (paths, counts, permissions).

---

## Execution Plan

### Step 1: CRITICAL — Fix tool-call counter glob (S1)

**Root cause:** `session-start.sh` writes session ID as `{NUM}_{DATE}_{TIME}` (e.g., `196_20260414_201030`). Counter files are named `cc-calls-{SESSION_ID}.txt`. But `stop-metrics.sh` and `ambient-pulse.sh` glob `cc-calls-${TODAY}_*.txt` expecting date-first format.

**Fix:** Change glob from `cc-calls-${TODAY}_*.txt` to `cc-calls-*_${TODAY}_*.txt` in:
- `hooks/stop-metrics.sh` (line ~47: `for f in /tmp/cc-calls-${TODAY}_*.txt`)
- `hooks/ambient-pulse.sh` (get_calls function)
- `hooks/apl-cache-refresh.sh` (get_calls function)

**Test:** After fix, `echo '' | bash hooks/stop-metrics.sh` should show non-zero tool calls.

### Step 2: CRITICAL — Fix guard-bash-write mypy false positive (S2)

**Root cause:** regex `(python3?|py)\s+` matches end of `mypy`.

**Fix:** In `.claude/hooks/guard-bash-write.sh`, change pattern to `\b(python3?|py)\b\s+(-c\b|[^-][^-])`.

**Test:** `echo '{"tool_input":{"command":"mypy agents/"}}' | bash .claude/hooks/guard-bash-write.sh` should NOT trigger python warning.

### Step 3: WARN — Remove hygiene duplication from stop-metrics (S5)

**Rationale:** stop-quality.sh already checks HANDOFF/CHANGELOG with richer logic (recent commits). stop-metrics duplicates with simpler logic → conflicting signals.

**Fix:** Remove lines 67-76 (HYGIENE block) from stop-metrics.sh. Set `HYGIENE="—"` (not checked here, defer to stop-quality).

### Step 4: WARN — Suppress Armed noise for exempt tools (S3)

**Fix:** In `.claude/hooks/post-global-handler.sh`, skip the "Armed" print when tool is Read|Grep|Glob|Glob.

### Steps 5-6: Backlog + plans archive (if time)

- Mark backlog #3 and #15 as RESOLVED S196
- Archive 2 consumed plans to `.claude/plans/archive/S196-*`

### Deferred to backlog

- S4: Node→jq migration (4 scripts) — dedicated session, ~30 min
- S6: guard-lint-before-build hardcoded path — small fix but needs test
- S7-S10: INFO items — no action needed

## Verification

After all steps:
1. `echo '' | bash hooks/stop-metrics.sh` → non-zero tool calls
2. `echo '{"tool_input":{"command":"mypy agents/"}}' | bash .claude/hooks/guard-bash-write.sh` → no python warning
3. `jq . .claude/settings.local.json` → valid JSON
4. Count: `ls hooks/*.sh .claude/hooks/*.sh | wc -l` = 29
