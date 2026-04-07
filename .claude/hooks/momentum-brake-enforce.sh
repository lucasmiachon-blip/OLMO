#!/usr/bin/env bash
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
#
# Non-exempt (require approval when armed):
#   Write, Edit, Agent, MCP tools, etc.
#   Write/Edit get double-ask with guard-pause.sh — accepted (defense-in-depth, B5-05 S100).
# Exit 0 with JSON = ask. Exit 0 without JSON = allow.

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

# Parse tool name from hook input
TOOL_NAME=$(echo "$INPUT" | node -e "
  try {
    const d=JSON.parse(require('fs').readFileSync(0,'utf8'));
    console.log(d.tool_name||'');
  } catch(e) { console.log(''); }
" 2>/dev/null)

# Exempt tools: allow without asking
case "$TOOL_NAME" in
  Read|Grep|Glob|Bash|ToolSearch|AskUserQuestion|EnterPlanMode|ExitPlanMode)
    exit 0
    ;;
esac

# All other tools while brake is armed: require user approval
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"%s"}}\n' "$REASON"
exit 0
