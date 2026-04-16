#!/usr/bin/env bash
set -euo pipefail
# stop-should-dream.sh — Stop hook: create .dream-pending if >=24h since last dream
# Contract: ~/.claude/.last-dream (epoch seconds), ~/.claude/.dream-pending (flag)
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

# Read epoch seconds directly — no ISO parsing needed
LAST=$(cat "$LAST_DREAM_FILE" 2>/dev/null | tr -d '[:space:]')
NOW=$(date +%s)

# Validate: must be a number
if ! [[ "$LAST" =~ ^[0-9]+$ ]]; then
  touch "$PENDING_FILE"
  exit 0
fi

DIFF=$(( NOW - LAST ))

if [ "$DIFF" -ge 86400 ]; then
  touch "$PENDING_FILE"
fi

exit 0
