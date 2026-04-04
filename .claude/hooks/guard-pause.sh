#!/usr/bin/env bash
# guard-pause.sh — PreToolUse: force user confirmation before Edit/Write
# Prevents agent from advancing without authorization.
# Returns "ask" decision — user must approve each file edit.
# Motivation: S57 repeated drift — agent advances without consulting user or memory.
# Exit 0 with JSON = ask. Exit 0 without JSON = allow. Exit 2 = block.

INPUT=$(cat 2>/dev/null || echo '{}')

# Extract file path (handles both file_path and path keys, backslash normalization)
FILE_PATH=$(echo "$INPUT" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
if [ -z "$FILE_PATH" ]; then
  FILE_PATH=$(echo "$INPUT" | sed -n 's/.*"path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
fi
FILE_PATH=$(echo "$FILE_PATH" | tr '\\' '/' | sed 's|.*/||')  # basename only for display

# Whitelist: memory files and session metadata — don't nag on these
case "$FILE_PATH" in
  MEMORY.md|*.md)
    # Check if it's a memory file
    FULL_PATH=$(echo "$INPUT" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
    if echo "$FULL_PATH" | tr '\\' '/' | grep -q '/memory/'; then
      exit 0  # allow memory writes silently
    fi
    ;;
  .session-name)
    exit 0  # allow session name writes silently
    ;;
esac

# Everything else: ask user
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"Editando: %s"}}\n' "$FILE_PATH"
exit 0
