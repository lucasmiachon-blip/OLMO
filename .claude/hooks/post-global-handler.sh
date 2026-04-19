#!/usr/bin/env bash
set -euo pipefail
# post-global-handler.sh — PostToolUse(.*): cost tracking + momentum brake arm
# Merged: cost-circuit-breaker.sh + momentum-brake-arm.sh (S194 Fase 2)
# S230 G.3: slim VANITY — removed KPI Reflection Loop (100 li) + Cost BLOCK arm (7 li). Zero firings em 11d.
# Fires on EVERY tool call. Pure bash, no JSON parsing needed.
# Exit 0 always — this hook never blocks.

cat >/dev/null 2>&1 || true  # consume stdin (hook protocol)

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"

# ═══ 1. Cost circuit breaker WARN (S230 G.3: BLOCK arm deleted — zero firings em 11d) ═══
WARN_THRESHOLD="${CC_COST_WARN_CALLS:-100}"

SESSION_ID=$(cat /tmp/cc-session-id.txt 2>/dev/null || date '+%Y%m%d_%H%M%S')
COUNTER_FILE="/tmp/cc-calls-${SESSION_ID}.txt"

COUNT=$(cat "$COUNTER_FILE" 2>/dev/null || echo 0)
COUNT=$((COUNT + 1))
echo "$COUNT" > "$COUNTER_FILE"

if [ "$COUNT" -ge "$WARN_THRESHOLD" ]; then
  REMAINDER=$(( (COUNT - WARN_THRESHOLD) % 50 ))
  if [ "$REMAINDER" = "0" ]; then
    printf '\n[cost-circuit-breaker] %d tool calls.\n' "$COUNT"
  fi
fi

# ═══ 2. Momentum brake arm (anti KBP-01) ═══
LOCK_DIR="/tmp/olmo-momentum-brake"
mkdir -p "$LOCK_DIR"
date '+%s' > "$LOCK_DIR/armed"

exit 0
