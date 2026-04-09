#!/usr/bin/env bash
# stop-should-dream.sh — Stop hook: create .dream-pending if >=24h since last dream
# Contract: ~/.claude/.last-dream (ISO timestamp), ~/.claude/.dream-pending (flag)
# Next session start: CLAUDE.md auto-dream reads .dream-pending → runs /dream → updates .last-dream

LAST_DREAM_FILE="$HOME/.claude/.last-dream"
PENDING_FILE="$HOME/.claude/.dream-pending"

# If pending already exists, skip (idempotent)
[ -f "$PENDING_FILE" ] && exit 0

# If no timestamp file, assume dream is overdue
if [ ! -f "$LAST_DREAM_FILE" ]; then
  touch "$PENDING_FILE"
  exit 0
fi

# Parse last dream timestamp
LAST=$(date -d "$(cat "$LAST_DREAM_FILE")" +%s 2>/dev/null)
NOW=$(date +%s)

# If parse fails, assume overdue
if [ -z "$LAST" ]; then
  touch "$PENDING_FILE"
  exit 0
fi

DIFF=$(( NOW - LAST ))
THRESHOLD=86400  # 24 hours in seconds

if [ "$DIFF" -ge "$THRESHOLD" ]; then
  touch "$PENDING_FILE"
fi

exit 0
