#!/usr/bin/env bash
# UserPromptSubmit: nudge-commit — Proactive commit reminder
# Alerts when >35min since last commit AND uncommitted changes exist.
# Output goes to conversation context as [NUDGE].

# Drain stdin (hook protocol)
cat > /dev/null 2>&1

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Quick gate: skip if no git repo
git -C "$PROJECT_ROOT" rev-parse --git-dir >/dev/null 2>&1 || exit 0

# Get last commit timestamp
LAST_COMMIT_TS=$(git -C "$PROJECT_ROOT" log -1 --format=%ct 2>/dev/null || echo 0)
NOW_TS=$(date +%s)
ELAPSED=$(( (NOW_TS - LAST_COMMIT_TS) / 60 ))

# Threshold: 35 minutes
[ "$ELAPSED" -lt 35 ] && exit 0

# Check if there are actual changes worth committing
CHANGED_COUNT=$(git -C "$PROJECT_ROOT" status --short 2>/dev/null | grep -cv '^\?\?' || true)
UNTRACKED=$(git -C "$PROJECT_ROOT" status --short 2>/dev/null | grep -c '^\?\?' || true)
TOTAL=$(( CHANGED_COUNT + UNTRACKED ))

[ "$TOTAL" -eq 0 ] && exit 0

# Cooldown: don't nag more than once per 15 minutes
COOLDOWN_FILE="/tmp/olmo-nudge-commit-last"
if [ -f "$COOLDOWN_FILE" ]; then
  LAST_NUDGE=$(cat "$COOLDOWN_FILE" 2>/dev/null || echo 0)
  SINCE_NUDGE=$(( NOW_TS - LAST_NUDGE ))
  [ "$SINCE_NUDGE" -lt 900 ] && exit 0
fi
echo "$NOW_TS" > "$COOLDOWN_FILE"

echo "[NUDGE] ${ELAPSED}min sem commit. ${CHANGED_COUNT} modified + ${UNTRACKED} untracked. Considere commitar trabalho parcial."

exit 0
