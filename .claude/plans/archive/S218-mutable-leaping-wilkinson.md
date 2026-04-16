# S218 — KPI + Self-Improvement

## Context

KPI system deployed S217 (DORA-inspired). metrics.tsv has 27 rows but only S217 has complete data (S190-S216 are seed with only `changelog_lines` and `commits` filled). Self-improvement is PAUSED pending evidence. The connection between quantitative KPI data and /dream memory consolidation does not exist — they are parallel tracks. Stuck-item detection has a schema bug and is measuring noise (72 items from HANDOFF decisions, not genuine stuck tasks). This session closes the gaps to make the KPI → self-improvement feedback loop actually work.

---

## Block A — Stuck-Detection Fix (2 hooks, 1 data reset)

**Problem:** `apl-cache-refresh.sh` writes 2-column rows (`item\tcount`) but `stop-metrics.sh` creates the header with 3 columns (`item\tcount\tfirst_seen`). The `first_seen` column is never populated. Additionally, stuck detection parses ALL `^- ` bullets in HANDOFF.md, including permanent decisions (DECISOES ATIVAS section), which are carried over every session and generate pure noise.

### A1: Section-aware HANDOFF parsing

Both hooks currently use `grep '^- ' HANDOFF.md` which captures everything. Fix: parse only bullets between `## PENDENTES` and the next `##` header (which is `## DECISOES ATIVAS`).

**Files:**
- `hooks/apl-cache-refresh.sh` line 56: replace `grep '^- '` with section-aware parsing
- `hooks/stop-metrics.sh` line 108 (`HANDOFF_PEND` count) and line 150 (snapshot writer): same fix

**Logic (both hooks):**
```bash
parse_handoff_pendentes() {
  local file="$1" in_section=0
  while IFS= read -r line; do
    [[ "$line" =~ ^##\ PENDENTES ]] && in_section=1 && continue
    [[ "$line" =~ ^##\  ]] && [ "$in_section" -eq 1 ] && break
    [ "$in_section" -eq 1 ] && [[ "$line" =~ ^-\  ]] && echo "${line#- }"
  done < "$file"
}
```

### A2: Fix stuck-counts.tsv schema (3 columns with `first_seen`)

- `apl-cache-refresh.sh` line 63: header → `printf 'item\tcount\tfirst_seen\n'`
- Line 78 (existing item update): preserve existing `first_seen` from column 3
- Line 84 (new item): `printf '%s\t1\t%s\n' "$KEY" "$(date +%Y-%m-%d)"`

### A3: Reset stuck-counts.tsv

After deploying A1+A2, reset to header-only. The 72 existing items are noise (decisions, not tasks). No data loss — none reached the 3-session alert threshold.

**Verification:** Start a new session after deploy. `[KPI] STUCK:` should NOT appear (clean slate). After 3+ sessions, only genuine PENDENTES items should accumulate.

---

## Block B — /dream Phase 2.6: Metrics Trend Analysis

**Problem:** /dream reads transcripts and hook-log.jsonl but has no awareness of metrics.tsv. Memory lacks quantitative health data.

### B1: Add Sub-step 6 to dream SKILL.md

**File:** `C:\Users\lucas\.claude\skills\dream\SKILL.md` — after line 245 (end of Sub-step 5 report section), before `## Phase 3: CONSOLIDATE`

**Content of Sub-step 6:**

```markdown
### Sub-step 6: Metrics Trend Analysis

**Goal:** Derive quantitative health signals from KPI data. Only fires for projects with a metrics.tsv file.

#### Step 1: Locate metrics
```bash
METRICS_FILE="$CLAUDE_PROJECT_DIR/.claude/apl/metrics.tsv"
[ -f "$METRICS_FILE" ] || echo "(No metrics.tsv found — sub-step 6 skipped)"
```
If absent, skip this entire sub-step.

#### Step 2: Identify real data rows
Read all rows. A "real" row has numeric values in ALL leading indicator columns (rework_files, backlog_open, backlog_resolved, handoff_pendentes) — rows with `-` are seed/partial data.

If fewer than 3 real rows exist:
> "(KPI baseline insufficient — {N} real rows, need >= 3 for trend. Skipping.)"

#### Step 3: Compute trends (last 5 real rows)
For the most recent min(5, N) real rows:
- **rework_files**: direction (rising/stable/falling) + latest value
- **backlog_velocity**: `resolved / (open + resolved)` per session → trend direction
- **handoff_pendentes**: direction + absolute value
- **tool_calls, duration_min**: report but do not alert (vanity/context metrics)

#### Step 4: Flag anomalies
- rework_files increasing 2+ consecutive sessions → `REWORK RISING`
- handoff_pendentes > 60 → `PENDENTES HIGH`
- backlog_velocity = 0 for 3+ sessions → `BACKLOG STAGNANT`

#### Step 5: Write to memory
Append a dated entry to `project_self_improvement.md`:
```
- [YYYY-MM-DD] KPI snapshot S{N}-S{M}: rework={val}({trend}), pendentes={val}({trend}), backlog_velocity={pct}%({trend}). (source: metrics.tsv, confidence: high, origin: explicit)
```
```

### B2: No structural change to /dream phases

Phase 2.6 fits naturally as another GATHER SIGNAL sub-step. Phase 3 (CONSOLIDATE) already handles updates to existing memory files. No other /dream changes needed.

**Verification:** Run `/dream` after adding Sub-step 6. It should report "(KPI baseline insufficient — 1 real row, need >= 3)" until S219+.

---

## Block C — Self-Improvement Resume Gate

**Problem:** Self-improvement is PAUSED with no concrete criteria for resuming. "Lucas decides" is necessary but insufficient — needs measurable conditions.

### C1: Define resume gate (governance, no code)

Proposed criteria — ALL must be true:

1. **>= 5 real rows** in metrics.tsv (complete leading indicator data). Currently: 1/5. ETA: ~S222 if sessions are daily.
2. **rework_files not rising** over last 3 real sessions. (System stability signal.)
3. **No STUCK alerts** (stuck-counts.tsv, count >= 3). (No unresolved architectural debt.)
4. **/dream has run with Phase 2.6** at least once. (Quantitative grounding confirmed.)

### C2: Record gate in HANDOFF.md

Edit the `Self-improvement: PAUSADO` line in DECISOES ATIVAS to include the 4 criteria. Makes them visible at every session start.

### C3: Update project_self_improvement.md

Add the gate definition to memory so /dream and /insights can reference it.

**Verification:** Next session's HANDOFF read shows the gate. /dream Phase 2.6 reports progress toward the 5-session threshold.

---

## Block D — Housekeeping

### D1: Archive async-orbiting-toucan.md
```bash
mv .claude/plans/async-orbiting-toucan.md .claude/plans/archive/S217-async-orbiting-toucan.md
```
Update HANDOFF: "Plans: 4 ativos" → "Plans: 3 ativos"

### D2: HANDOFF KPI epoch note
Add note: "Real KPI data starts S217. S190-S216: only changelog_lines + commits."

---

## Execution Order

| Cycle | Block | Risk | Needs OK |
|-------|-------|------|----------|
| 1 | A1+A2: Hook fixes (section-aware parsing + schema fix) | Medium — changes 2 hooks | Yes |
| 2 | A3: Reset stuck-counts.tsv | Low — no alert-threshold data lost | Yes |
| 3 | B1: /dream Phase 2.6 | Low — global skill edit, no-op without metrics.tsv | Yes |
| 4 | C1-C3: Resume gate | Zero — governance only | Yes |
| 5 | D1-D2: Housekeeping | Zero | Yes |

## Critical Files

- `hooks/apl-cache-refresh.sh` — Blocks A1, A2
- `hooks/stop-metrics.sh` — Block A1, A2
- `~/.claude/skills/dream/SKILL.md` — Block B1
- `.claude/apl/stuck-counts.tsv` — Block A3
- `HANDOFF.md` — Blocks C2, D1, D2
- `~/.claude/projects/C--Dev-Projetos-OLMO/memory/project_self_improvement.md` — Block C3
