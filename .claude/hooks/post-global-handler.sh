#!/usr/bin/env bash
# post-global-handler.sh — PostToolUse(.*): cost tracking + momentum brake
# Merged: cost-circuit-breaker.sh + momentum-brake-arm.sh (S194 Fase 2)
# Fires on EVERY tool call. Pure bash, no JSON parsing needed.
# Exit 0 always — this hook never blocks.

cat >/dev/null 2>&1 || true  # consume stdin (hook protocol)

# ═══ 1. Cost circuit breaker (Antifragile L3) ═══
# Tracks tool call count as cost proxy. Warns at threshold, arms brake at limit.
# Thresholds adjustable via env: CC_COST_WARN_CALLS (100), CC_COST_BLOCK_CALLS (400)
WARN_THRESHOLD="${CC_COST_WARN_CALLS:-100}"
BLOCK_THRESHOLD="${CC_COST_BLOCK_CALLS:-400}"

SESSION_ID=$(cat /tmp/cc-session-id.txt 2>/dev/null || date '+%Y%m%d_%H%M%S')
COUNTER_FILE="/tmp/cc-calls-${SESSION_ID}.txt"
COST_BRAKE_DIR="/tmp/olmo-cost-brake"

COUNT=$(cat "$COUNTER_FILE" 2>/dev/null || echo 0)
COUNT=$((COUNT + 1))
echo "$COUNT" > "$COUNTER_FILE"

if [ "$COUNT" -ge "$BLOCK_THRESHOLD" ]; then
  REMAINDER_BLOCK=$(( (COUNT - BLOCK_THRESHOLD) % 100 ))
  if [ "$REMAINDER_BLOCK" -eq 0 ]; then
    mkdir -p "$COST_BRAKE_DIR"
    echo "$COUNT" > "$COST_BRAKE_DIR/armed"
    printf '\n[cost-brake] %d tool calls — brake armado. Proxima acao pedira permissao.\n' "$COUNT"
  fi
elif [ "$COUNT" -ge "$WARN_THRESHOLD" ]; then
  REMAINDER=$(( (COUNT - WARN_THRESHOLD) % 50 ))
  if [ "$REMAINDER" = "0" ]; then
    printf '\n[cost-circuit-breaker] %d tool calls (limite: %d).\n' "$COUNT" "$BLOCK_THRESHOLD"
  fi
fi

# ═══ 2. Momentum brake arm (anti KBP-01) ═══
# After any tool call, arm brake so enforce hook gates the next action.
# Cycle: arm (PostToolUse) → enforce (PreToolUse) → clear (UserPromptSubmit)
LOCK_DIR="/tmp/olmo-momentum-brake"
mkdir -p "$LOCK_DIR"
date '+%s' > "$LOCK_DIR/armed"
printf '\n[momentum-brake] Armed — proxima acao requer aprovacao.\n'

exit 0
