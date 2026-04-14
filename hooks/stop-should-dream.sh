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

# Parse ISO 8601 timestamp to epoch seconds
# Try GNU date first, fallback to jq fromdateiso8601, fallback to overdue (S193 portability fix)
TS=$(cat "$LAST_DREAM_FILE")
DATE_STR="${TS:0:4}-${TS:5:2}-${TS:8:2} ${TS:11:2}:${TS:14:2}:${TS:17:2} UTC"
LAST=$(date -d "$DATE_STR" +%s 2>/dev/null || \
       jq -rn --arg ts "$TS" '$ts | fromdateiso8601' 2>/dev/null || \
       echo "")
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
