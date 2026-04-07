#!/usr/bin/env bash
# Stop hook: chaos report (Antifragile L6)
# At session end, if CHAOS_MODE was active, reports:
#   - Total injections per vector
#   - Whether defense hooks activated
#   - Any gaps (injections without defense response)

# Gate: skip if chaos was never enabled this session
CHAOS_LOG="/tmp/cc-chaos-log.jsonl"
[ ! -f "$CHAOS_LOG" ] && exit 0

# Trim helper (wc -l and cat may include whitespace/newlines)
trim() { echo "$1" | tr -d '[:space:]'; }

# Count injections (only lines with "injected":true)
TOTAL_INJECTED=$(trim "$(grep -c '"injected":true' "$CHAOS_LOG" 2>/dev/null || echo 0)")
TOTAL_SKIPPED=$(trim "$(grep -c '"injected":false' "$CHAOS_LOG" 2>/dev/null || echo 0)")

# If no injections happened, nothing to report
[ "$TOTAL_INJECTED" -eq 0 ] && exit 0

# Count per vector
COUNT_429=$(trim "$(grep -c '"vector":"http_429".*"injected":true' "$CHAOS_LOG" 2>/dev/null || echo 0)")
COUNT_TIMEOUT=$(trim "$(grep -c '"vector":"socket_timeout".*"injected":true' "$CHAOS_LOG" 2>/dev/null || echo 0)")
COUNT_MODEL=$(trim "$(grep -c '"vector":"model_unavailable".*"injected":true' "$CHAOS_LOG" 2>/dev/null || echo 0)")
COUNT_RAPID=$(trim "$(grep -c '"vector":"rapid_calls".*"injected":true' "$CHAOS_LOG" 2>/dev/null || echo 0)")

# Check defense activation
FAILURE_LOG="/tmp/cc-model-failures.log"
SESSION_ID=$(date '+%Y%m%d_%H')
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

# Report
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

# Gap analysis
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
