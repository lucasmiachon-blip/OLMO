#!/usr/bin/env bash
set -euo pipefail
# PostToolUse(Agent): nudge-checkpoint — Context overflow prevention
# Counts subagent invocations per session. After 3+, suggests checkpoint.
# Resets on session start (via /tmp file).

# Drain stdin (hook protocol)
cat > /dev/null 2>&1

COUNTER_FILE="/tmp/olmo-subagent-count"
NUDGED_FILE="/tmp/olmo-checkpoint-nudged"

# Initialize counter if missing
[ ! -f "$COUNTER_FILE" ] && echo "0" > "$COUNTER_FILE"

# Increment
COUNT=$(cat "$COUNTER_FILE" 2>/dev/null || echo 0)
COUNT=$((COUNT + 1))
echo "$COUNT" > "$COUNTER_FILE"

# Gate: only nudge at 3, 6, 9 (every 3 agents, not every call)
if [ $((COUNT % 3)) -ne 0 ]; then
  exit 0
fi

# Cooldown: don't repeat for same threshold
LAST_NUDGE=$(cat "$NUDGED_FILE" 2>/dev/null || echo 0)
[ "$LAST_NUDGE" -eq "$COUNT" ] && exit 0
echo "$COUNT" > "$NUDGED_FILE"

# Breadcrumb for hook-calibration.sh
date '+%s' > "/tmp/olmo-hook-fired-nudge-checkpoint"

echo "[NUDGE] ${COUNT} subagents nesta sessao. Considere: commit + update HANDOFF + /clear se task esta mudando."

exit 0
