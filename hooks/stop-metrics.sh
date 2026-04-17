#!/usr/bin/env bash
set -euo pipefail
# Claude Code hook: Stop
# Merged: scorecard + chaos-report (Fase 2 step 5) + metrics persistence (S217)
# Leading indicators (DORA-inspired): rework_files, backlog velocity, handoff pendentes
# S217: added HANDOFF snapshot for stuck-item detection across sessions
# S218: section-aware HANDOFF parsing (PENDENTES only) + consistent stuck-counts schema
# S219: data_quality (11th) + ctx_pct_max (12th) columns for metrics.tsv
# Evento: Stop | Timeout: 5s | Exit: sempre 0

# Drain stdin (hook protocol — prevent parent process stall)
cat >/dev/null 2>&1

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APL_DIR="$PROJECT_ROOT/.claude/apl"

# --- Section-aware HANDOFF parsing (S218: only PENDENTES section) ---
parse_handoff_pendentes() {
  local file="$1" in_section=0
  while IFS= read -r line; do
    [[ "$line" =~ ^##\ PENDENTES ]] && in_section=1 && continue
    [[ "$line" =~ ^##\  ]] && [ "$in_section" -eq 1 ] && break
    [ "$in_section" -eq 1 ] && [[ "$line" =~ ^-\  ]] && echo "${line#- }"
  done < "$file"
}

# ===== SCORECARD =====

# Focus
SESSION_NAME="(sem nome)"
if [ -f "$PROJECT_ROOT/.claude/.session-name" ]; then
  NAME=$(cat "$PROJECT_ROOT/.claude/.session-name" 2>/dev/null)
  [ -n "$NAME" ] && SESSION_NAME="$NAME"
fi

# Duration
DURATION="(?)"
START_TS=0
ELAPSED_MIN=0
if [ -f "$APL_DIR/session-ts.txt" ]; then
  START_TS=$(cat "$APL_DIR/session-ts.txt" 2>/dev/null || echo 0)
  [[ $START_TS =~ ^[0-9]+$ ]] || START_TS=0
  NOW_TS=$(date +%s)
  ELAPSED_MIN=$(( (NOW_TS - START_TS) / 60 ))
  HOURS=$((ELAPSED_MIN / 60))
  MINS=$((ELAPSED_MIN % 60))
  if [ "$HOURS" -gt 0 ]; then
    DURATION="${HOURS}h${MINS}m"
  else
    DURATION="${MINS}m"
  fi
fi

# Commits since session start
COMMITS=0
if [ "$START_TS" -gt 0 ]; then
  COMMITS=$(git -C "$PROJECT_ROOT" log --oneline --since="@$START_TS" 2>/dev/null | wc -l | tr -d ' ' || echo 0)
fi

# Tool calls today
CALLS=0
TODAY=$(date +%Y%m%d)
for f in /tmp/cc-calls-*_${TODAY}_*.txt; do
  [ -f "$f" ] || continue
  n=$(cat "$f" 2>/dev/null || echo 0)
  [[ $n =~ ^[0-9]+$ ]] || n=0
  CALLS=$((CALLS + n))
done

# Cost verdict
if [ "$CALLS" -lt 100 ]; then
  COST="OK"
elif [ "$CALLS" -lt 300 ]; then
  COST="MODERATE"
else
  COST="HIGH"
fi

# Output scorecard
echo "[SCORECARD] Foco: \"$SESSION_NAME\" | Duracao: $DURATION"
echo "[SCORECARD] Commits: $COMMITS | Tool calls: $CALLS | Custo: $COST"

# ===== LEADING INDICATORS =====

# Detect session number
SESSION_NUM=""
LATEST_COMMIT_MSG=$(git -C "$PROJECT_ROOT" log --oneline -1 --format='%s' 2>/dev/null || echo "")
if [[ "$LATEST_COMMIT_MSG" =~ ^S([0-9]+): ]]; then
  SESSION_NUM="S${BASH_REMATCH[1]}"
fi
if [ -z "$SESSION_NUM" ] && [[ "$SESSION_NAME" =~ S([0-9]+) ]]; then
  SESSION_NUM="S${BASH_REMATCH[1]}"
fi

# --- Rework Rate (DORA 5th metric adapted) ---
REWORK_FILES=0
if [ "$START_TS" -gt 0 ]; then
  THIS_FILES=$(git -C "$PROJECT_ROOT" log --since="@$START_TS" --name-only --format="" 2>/dev/null | sort -u)
  if [ -n "$THIS_FILES" ]; then
    PREV_END="$START_TS"
    PREV_START=$((START_TS - 86400))
    PREV_FILES=$(git -C "$PROJECT_ROOT" log --since="@$PREV_START" --until="@$PREV_END" --name-only --format="" 2>/dev/null | sort -u)
    if [ -n "$PREV_FILES" ]; then
      REWORK_FILES=$(comm -12 <(echo "$THIS_FILES" | grep -v -E '^(HANDOFF\.md|CHANGELOG\.md)$') <(echo "$PREV_FILES" | grep -v -E '^(HANDOFF\.md|CHANGELOG\.md)$') 2>/dev/null | wc -l | tr -d ' ')
    fi
  fi
fi

# --- Backlog Velocity ---
BACKLOG_OPEN=0
BACKLOG_RESOLVED=0
if [ -f "$PROJECT_ROOT/.claude/BACKLOG.md" ]; then
  BACKLOG_OPEN=$(grep '^| [0-9]' "$PROJECT_ROOT/.claude/BACKLOG.md" 2>/dev/null | grep -cv 'RESOLVED' || echo 0)
  BACKLOG_RESOLVED=$(grep '^| [0-9]' "$PROJECT_ROOT/.claude/BACKLOG.md" 2>/dev/null | grep -c 'RESOLVED' || echo 0)
fi

# --- HANDOFF pendentes (S218: section-aware, PENDENTES only) ---
HANDOFF_PEND=0
if [ -f "$PROJECT_ROOT/HANDOFF.md" ]; then
  HANDOFF_PEND=$(parse_handoff_pendentes "$PROJECT_ROOT/HANDOFF.md" | wc -l | tr -d ' ')
fi

# --- CHANGELOG lines this session ---
CL_LINES=0
if [ -n "$SESSION_NUM" ] && [ -f "$PROJECT_ROOT/CHANGELOG.md" ]; then
  NUM_ONLY="${SESSION_NUM#S}"
  IN_SESSION=0
  while IFS= read -r line; do
    if [[ "$line" =~ ^##\ Sessao\ ${NUM_ONLY}\  ]]; then
      IN_SESSION=1; continue
    fi
    if [ "$IN_SESSION" -eq 1 ] && [[ "$line" =~ ^##\  ]]; then
      break
    fi
    if [ "$IN_SESSION" -eq 1 ] && [[ "$line" =~ ^-\  ]]; then
      CL_LINES=$((CL_LINES + 1))
    fi
  done < "$PROJECT_ROOT/CHANGELOG.md"
fi

# Print leading indicators
echo "[KPI] Rework: $REWORK_FILES files | Backlog: $BACKLOG_OPEN open, $BACKLOG_RESOLVED resolved | Pendentes: $HANDOFF_PEND"

# ===== PERSIST TO METRICS.TSV =====
METRICS_FILE="$APL_DIR/metrics.tsv"
TODAY_DATE=$(date +%Y-%m-%d)

if [ -n "$SESSION_NUM" ] && [ -f "$METRICS_FILE" ]; then
  if ! grep -q "^${SESSION_NUM}	" "$METRICS_FILE"; then
    # Read peak context % from statusline persistence
    CTX_MAX="-"
    CTX_FILE="$APL_DIR/ctx-pct.txt"
    if [ -f "$CTX_FILE" ]; then
      CTX_MAX=$(cat "$CTX_FILE" 2>/dev/null || echo "-")
      [[ "$CTX_MAX" =~ ^[0-9]+$ ]] || CTX_MAX="-"
      rm -f "$CTX_FILE"
    fi
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
      "$SESSION_NUM" "$TODAY_DATE" "$REWORK_FILES" "$BACKLOG_OPEN" "$BACKLOG_RESOLVED" \
      "$HANDOFF_PEND" "$CL_LINES" "$COMMITS" "$CALLS" "$ELAPSED_MIN" "full" "$CTX_MAX" \
      >> "$METRICS_FILE"
    echo "[METRICS] Persisted to metrics.tsv"
  fi
fi

# ===== HANDOFF SNAPSHOT (for stuck-item detection) =====
# S218: save only PENDENTES section bullets (not decisions/context)
SNAPSHOT_FILE="$APL_DIR/handoff-prev.txt"
if [ -f "$PROJECT_ROOT/HANDOFF.md" ]; then
  parse_handoff_pendentes "$PROJECT_ROOT/HANDOFF.md" | sort > "$SNAPSHOT_FILE"
fi

# Update stuck-counts header if needed (3-col schema)
STUCK_FILE="$APL_DIR/stuck-counts.tsv"
if [ ! -f "$STUCK_FILE" ]; then
  printf 'item\tcount\tfirst_seen\n' > "$STUCK_FILE"
fi

# ===== CHAOS REPORT (conditional) =====

CHAOS_LOG="/tmp/cc-chaos-log.jsonl"
[ ! -f "$CHAOS_LOG" ] && exit 0

trim() { echo "$1" | tr -d '[:space:]'; }

TOTAL_INJECTED=$(trim "$(grep -c '"injected":true' "$CHAOS_LOG" 2>/dev/null || echo 0)")
TOTAL_SKIPPED=$(trim "$(grep -c '"injected":false' "$CHAOS_LOG" 2>/dev/null || echo 0)")

[ "$TOTAL_INJECTED" -eq 0 ] && exit 0

COUNT_429=$(trim "$(grep -c '"vector":"http_429".*"injected":true' "$CHAOS_LOG" 2>/dev/null || echo 0)")
COUNT_TIMEOUT=$(trim "$(grep -c '"vector":"socket_timeout".*"injected":true' "$CHAOS_LOG" 2>/dev/null || echo 0)")
COUNT_MODEL=$(trim "$(grep -c '"vector":"model_unavailable".*"injected":true' "$CHAOS_LOG" 2>/dev/null || echo 0)")
COUNT_RAPID=$(trim "$(grep -c '"vector":"rapid_calls".*"injected":true' "$CHAOS_LOG" 2>/dev/null || echo 0)")

FAILURE_LOG="/tmp/cc-model-failures.log"
SESSION_ID=$(cat /tmp/cc-session-id.txt 2>/dev/null || date '+%Y%m%d_%H%M%S')
CALLS_FILE="/tmp/cc-calls-${SESSION_ID}.txt"

L2_FAILURES=0
if [ -f "$FAILURE_LOG" ]; then
  L2_FAILURES=$(trim "$(wc -l < "$FAILURE_LOG" 2>/dev/null || echo 0)")
  [[ $L2_FAILURES =~ ^[0-9]+$ ]] || L2_FAILURES=0
fi

L3_COUNT=0
if [ -f "$CALLS_FILE" ]; then
  L3_COUNT=$(trim "$(cat "$CALLS_FILE" 2>/dev/null || echo 0)")
  [[ $L3_COUNT =~ ^[0-9]+$ ]] || L3_COUNT=0
fi

printf '\n╔══════════════════════════════════════╗\n'
printf '║     [CHAOS-L6] Session Report        ║\n'
printf '╠══════════════════════════════════════╣\n'
printf '║ Injections: %-4d  Skipped: %-4d      ║\n' "$TOTAL_INJECTED" "$TOTAL_SKIPPED"
printf '╠══════════════════════════════════════╣\n'
printf '║ Vectors:                             ║\n'
printf '║   HTTP 429:         %-4d             ║\n' "$COUNT_429"
printf '║   Socket timeout:   %-4d             ║\n' "$COUNT_TIMEOUT"
printf '║   Model unavail:    %-4d             ║\n' "$COUNT_MODEL"
printf '║   Rapid calls:      %-4d             ║\n' "$COUNT_RAPID"
printf '╠══════════════════════════════════════╣\n'
printf '║ Defense state:                       ║\n'
printf '║   L2 failure log entries: %-4d       ║\n' "$L2_FAILURES"
printf '║   L3 call counter: %-4d              ║\n' "$L3_COUNT"
printf '╠══════════════════════════════════════╣\n'

GAPS=0
if [ "$((COUNT_429 + COUNT_TIMEOUT + COUNT_MODEL))" -gt 0 ] && [ "$L2_FAILURES" -eq 0 ]; then
  printf '║ GAP: L2 injections but no failures   ║\n'
  GAPS=$((GAPS + 1))
fi
if [ "$COUNT_RAPID" -gt 0 ] && [ "$L3_COUNT" -lt 50 ]; then
  printf '║ GAP: L3 injection but counter low     ║\n'
  GAPS=$((GAPS + 1))
fi
if [ "$GAPS" -eq 0 ]; then
  printf '║ No gaps detected — defenses OK        ║\n'
fi

printf '╚══════════════════════════════════════╝\n\n'

exit 0
