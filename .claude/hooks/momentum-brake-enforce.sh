#!/usr/bin/env bash
# momentum-brake-enforce.sh — PreToolUse: gate consecutive actions
# If brake is armed AND tool is not exempt, forces permissionDecision: "ask".
# Part of the structural momentum-brake system (anti KBP-01).
#
# Exempt tools (no ask needed):
#   Read, Grep, Glob        — pure observation, not actions
#   Write, Edit              — already guarded by guard-pause.sh (avoid double-ask)
#   AskUserQuestion          — stopping to ask IS the desired behavior
#   EnterPlanMode            — meta tool, not an action
#
# Everything else (Bash, Agent, MCP tools, etc.) requires approval when armed.
# Exit 0 with JSON = ask. Exit 0 without JSON = allow.

INPUT=$(cat 2>/dev/null || echo '{}')

LOCK_FILE="/tmp/olmo-momentum-brake/armed"

# No lock = brake not armed = allow immediately
[ ! -f "$LOCK_FILE" ] && exit 0

# Parse tool name from hook input
TOOL_NAME=$(echo "$INPUT" | node -e "
  try {
    const d=JSON.parse(require('fs').readFileSync(0,'utf8'));
    console.log(d.tool_name||'');
  } catch(e) { console.log(''); }
" 2>/dev/null)

# Exempt tools: allow without asking
case "$TOOL_NAME" in
  Read|Grep|Glob|Write|Edit|AskUserQuestion|EnterPlanMode|ExitPlanMode)
    exit 0
    ;;
esac

# All other tools while brake is armed: require user approval
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"[momentum-brake] Acao consecutiva — aprovar para continuar"}}\n'
exit 0
