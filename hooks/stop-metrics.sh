#!/usr/bin/env bash
set -euo pipefail
# Claude Code hook: Stop
# Merged: scorecard + chaos-report (Fase 2 step 5)
# Session summary (2 lines) + conditional chaos report.
# Hygiene check deferred to stop-quality.sh (authoritative).
# Evento: Stop | Timeout: 5s | Exit: sempre 0

# Drain stdin (hook protocol — prevent parent process stall)
cat >/dev/null 2>&1

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APL_DIR="$PROJECT_ROOT/.claude/apl"

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

# Tool calls today (glob matches session-number prefix: cc-calls-{NUM}_{DATE}_{TIME}.txt)
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

# Output (2 lines — hygiene handled by stop-quality.sh)
echo "[SCORECARD] Foco: \"$SESSION_NAME\" | Duracao: $DURATION"
echo "[SCORECARD] Commits: $COMMITS | Tool calls: $CALLS | Custo: $COST"

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
# Read session ID from the same source as post-global-handler.sh
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
