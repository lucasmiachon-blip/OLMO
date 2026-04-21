#!/usr/bin/env bash
set -euo pipefail
# momentum-brake-enforce.sh — PreToolUse: gate consecutive actions
# If brake is armed AND tool is not exempt, forces permissionDecision: "ask".
# Part of the structural momentum-brake system (anti KBP-01).
#
# Exempt tools (no ask needed):
#   Read, Grep, Glob        — pure observation, not actions
#   Bash                     — guarded by guard-bash-write.sh + guard-secrets.sh (S102)
#   ToolSearch               — meta tool, no side effects
#   AskUserQuestion          — stopping to ask IS the desired behavior
#   EnterPlanMode/ExitPlanMode — meta tools, not actions
#   WebFetch, WebSearch      — pure observation (read-only web content), S209
#   Task*                    — meta tools, no codebase side effects, S209
#
# Non-exempt (require approval when armed):
#   Write, Edit, Agent, MCP tools, etc.
#   Write/Edit get double-ask with guard-pause.sh — accepted (defense-in-depth, B5-05 S100).
# Exit 0 with JSON = ask. Exit 0 without JSON = allow.
# S230 G.4: added hook_log on brake fires — visibility for /insights P001 follow-up.
# S236: P001 resolved KEEP (evidence-flipped: 246 brake-fired events in 5d; popup
#   absence was KBP-26 permissions.ask artifact, not brake ineffectiveness).
#   COST_LOCK check kept as defense-in-depth — cost brake may be revived.

INPUT=$(cat 2>/dev/null || echo '{}')

LOCK_FILE="/tmp/olmo-momentum-brake/armed"
COST_LOCK="/tmp/olmo-cost-brake/armed"

# Check both brakes: momentum (consecutive action) and cost (call budget)
ARMED=""
REASON=""
if [ -f "$LOCK_FILE" ]; then
  ARMED="momentum"
  REASON="[momentum-brake] Acao consecutiva — aprovar para continuar"
elif [ -f "$COST_LOCK" ]; then
  COST_COUNT=$(cat "$COST_LOCK" 2>/dev/null || echo "?")
  ARMED="cost"
  REASON="[cost-brake] $COST_COUNT tool calls — aprovar para continuar"
fi

# No brake armed = allow immediately
[ -z "$ARMED" ] && exit 0

# Parse tool name from hook input (jq — 10x faster than node, S193)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""' 2>/dev/null)

# Exempt tools: allow without asking
case "$TOOL_NAME" in
  Read|Grep|Glob|Bash|ToolSearch|AskUserQuestion|EnterPlanMode|ExitPlanMode|WebFetch|WebSearch|TaskCreate|TaskUpdate|TaskList|TaskStop|TaskGet|TaskOutput)
    exit 0
    ;;
esac

# S230 G.4: log brake firings (/insights P001 follow-up — measure real fires)
PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
{ . "$PROJECT_ROOT/hooks/lib/hook-log.sh" && hook_log "PreToolUse" "momentum-brake-enforce" "brake-fired" "$TOOL_NAME" "info" "armed=$ARMED"; } 2>/dev/null || true

# All other tools while brake is armed: require user approval
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"%s"}}\n' "$REASON"
exit 0
