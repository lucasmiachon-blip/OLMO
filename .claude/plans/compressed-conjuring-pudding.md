# S219 Plan: Self-Improvement KPI Enhancement + Infra Decisions

## Context

The KPI system (metrics.tsv + hooks) was introduced in S217 but only 2 of 27 rows have real data. The session-start display shows raw deltas without interpretation. The user wants the agent to explain WHY metrics are good/bad with justification, not just show numbers. Additionally, pending infra decisions (Docling venv, Python orchestrator) need to be formally registered.

## NOT in scope

- Install Docling venv (~2GB)
- Slides/QA work
- Run /dream

---

## Block 1: metrics.tsv cleanup (data_quality column)

**Why**: 25/27 rows have dashes because stop-metrics.sh didn't exist pre-S217. Trend calculations need to distinguish real vs backfill data cleanly.

**File**: `.claude/apl/metrics.tsv`

**Change**: Add 11th column `data_quality` to header and all rows:
- S190-S216 (backfill): append `backfill`
- S217-S218 (real): append `full`

**Backward-compat**: Existing `while IFS=$'\t' read -r ... dur` loops silently ignore the 11th field. No breakage.

**Verify**: `head -1 .claude/apl/metrics.tsv` shows 11 column names. `tail -3` shows S217/S218 ending with `full`.

---

## Block 2: apl-cache-refresh.sh — interpreted KPI trends

**Why**: Current `trend_arrow()` only compares last 2 sessions. User wants moving average + interpretation with justification.

**File**: `hooks/apl-cache-refresh.sh` (lines 114-158)

**Changes to the metrics trend section** (lines 114-145):

1. Replace `trend_arrow()` with two new functions:
   - `moving_avg()`: given space-separated values, returns integer average of all-but-last
   - `interpret()`: given name, current, avg, direction (lower_better/higher_better) → returns verdict string

2. `interpret()` logic:
   - `lower_better` + current > avg*1.3 → `ALTO — acima do baseline`
   - `lower_better` + current < avg*0.8 → `BOM — abaixo do baseline`
   - `higher_better` + current < avg*0.5 → `BAIXO — abaixo do baseline`
   - else → `OK`

3. Add efficiency ratio: `EFF = tool_calls / changelog_lines` (computed inline, not stored)

4. Filter: only use rows where `data_quality` = `full` (11th column) for trend calculation

5. Output format (replaces single `[KPI]` line):
   ```
   [KPI] calls:2011 (avg:1800) ALTO — acima do baseline | pendentes:17 (avg:35) BOM — abaixo do baseline
   [KPI] efficiency:201 calls/cl (>150=alto) | commits:1 (avg:1) OK | rework:2 (avg:4) BOM
   ```

**Deploy**: Write → `.claude/tmp/apl-cache-refresh.sh` → `python shutil.copy` → `hooks/`

**Verify**: `bash hooks/apl-cache-refresh.sh` — no errors, [KPI] lines show interpretations.

---

## Block 3: stop-metrics.sh — persist data_quality column

**Why**: New sessions must write `full` as 11th column.

**File**: `hooks/stop-metrics.sh` (line 149)

**Change**: Add `full` to the printf template:
```bash
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  "$SESSION_NUM" "$TODAY_DATE" "$REWORK_FILES" "$BACKLOG_OPEN" "$BACKLOG_RESOLVED" \
  "$HANDOFF_PEND" "$CL_LINES" "$COMMITS" "$CALLS" "$ELAPSED_MIN" "full" \
  >> "$METRICS_FILE"
```

**Deploy**: Write → `.claude/tmp/stop-metrics.sh` → `python shutil.copy` → `hooks/`

**Verify**: `bash hooks/stop-metrics.sh` — no errors.

---

## Block 4: post-global-handler.sh — efficiency in mid-session KPI

**Why**: Mid-session reflection (every 200 calls) should show efficiency alongside rework/backlog.

**File**: `.claude/hooks/post-global-handler.sh` (line 117)

**Change**: Add efficiency to the OK/ALERTA output:
- Compute `EFF_BASELINE` from metrics.tsv (avg of tool_calls/changelog_lines for full rows)
- Show `efficiency:~N calls/cl` in the `[KPI:N]` line
- Alert if current running efficiency > baseline * 1.3

**Deploy**: Write → `.claude/tmp/post-global-handler.sh` → `python shutil.copy` → `.claude/hooks/`

**Verify**: `bash .claude/hooks/post-global-handler.sh` — no errors.

---

## Block 5: Infra decisions → HANDOFF + CHANGELOG

**Decisions to register** (no code changes):

1. **Opus 4.7**: Considerar como modelo principal (proxima sessao: testar).
2. **Docling venv**: `tools/docling/.venv` separado. Razao: PyTorch ~2GB + Python >=3.13 incompativel com root >=3.11.
3. **Multi-agent orchestration**: deferred.
4. **Python infra**: Keep orchestrator.py + agents/ + subagents/ + config/. Archive `skills/efficiency/` (orphaned).

**Files**: `HANDOFF.md` (Edit: move items from PENDENTES to DECISOES ATIVAS), `CHANGELOG.md` (Edit: append S219 entries)

**Verify**: Read HANDOFF.md, confirm PENDENTES count decreased, DECISOES ATIVAS updated.

---

## Execution order

```
Block 1 → OK → Block 2 → OK → Block 3 → OK → Block 4 → OK → Block 5 → OK → commit
```

Each block requires explicit approval before proceeding.

## Critical files

- `.claude/apl/metrics.tsv` — data store (Block 1)
- `hooks/apl-cache-refresh.sh` — session-start KPI display (Block 2)
- `hooks/stop-metrics.sh` — end-of-session persist (Block 3)
- `.claude/hooks/post-global-handler.sh` — mid-session KPI (Block 4)
- `HANDOFF.md`, `CHANGELOG.md` — state docs (Block 5)
