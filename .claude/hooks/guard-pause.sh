#!/usr/bin/env bash
# guard-pause.sh — PreToolUse: force user confirmation before Edit/Write
# Prevents agent from advancing without authorization.
# Returns "ask" decision — user must approve each file edit.
# Motivation: S57 repeated drift — agent advances without consulting user or memory.
# Exit 0 with JSON = ask. Exit 0 without JSON = allow. Exit 2 = block.

INPUT=$(cat 2>/dev/null || echo '{}')

# Parse file path with node — robust JSON (Codex S60 O16/A4)
FULL_PATH=$(echo "$INPUT" | node -e "
  try {
    const d=JSON.parse(require('fs').readFileSync(0,'utf8'));
    const p=(d.tool_input||{}).file_path||(d.tool_input||{}).path||'';
    console.log(p.replace(/\\\\/g,'/'));
  } catch(e) { console.log(''); }
" 2>/dev/null)

FILE_PATH=$(echo "$FULL_PATH" | sed 's|.*/||')  # basename for display

# Whitelist: memory files, session metadata, plan files — don't nag on these
if echo "$FULL_PATH" | grep -q '/memory/'; then
  exit 0  # allow memory writes silently
fi

if echo "$FULL_PATH" | grep -q '/.claude/plans/'; then
  exit 0  # allow plan file writes silently (plan mode needs this)
fi

case "$FILE_PATH" in
  .session-name)
    exit 0  # allow session name writes silently
    ;;
esac

# Everything else: ask user
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"Editando: %s"}}\n' "$FILE_PATH"
exit 0
