#!/usr/bin/env bash
# guard-bash-write.sh — PreToolUse(Bash): ask confirmation on shell write patterns
# Catches file writes via Bash that bypass Edit/Write guards (guard-pause, guard-product-files).
# Uses "ask" (not block) — legitimate writes proceed with user approval.
# Motivation: Codex audit S57 — "Bash(echo > file)" bypasses ALL file guards.

INPUT=$(cat 2>/dev/null || echo '{}')

# Extract command from tool_input
CMD=$(echo "$INPUT" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

[ -z "$CMD" ] && exit 0

# Whitelist: session metadata (always benign)
if echo "$CMD" | grep -q '\.session-name'; then
  exit 0
fi

# Remove safe redirect patterns before checking for file writes
# Safe: 2>&1, >/dev/null, 2>/dev/null, &>/dev/null
CLEANED=$(echo "$CMD" | sed -E 's/2>&1//g; s/[12&]?>[[:space:]]*\/dev\/null//g')

# Pattern 1: redirect to file (> or >> followed by path-like target)
if echo "$CLEANED" | grep -qE '>>?[[:space:]]+[A-Za-z0-9./~$"'\''_-]'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"Shell redirect detectado — confirme se intencional"}}\n'
  exit 0
fi

# Pattern 2: sed -i (in-place file edit)
if echo "$CMD" | grep -qE 'sed[[:space:]]+-i'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"sed -i detectado — confirme se intencional"}}\n'
  exit 0
fi

# Pattern 3: tee (writes stdin to file)
if echo "$CMD" | grep -qE '\btee\b'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"tee detectado — confirme se intencional"}}\n'
  exit 0
fi

# Pattern 4: Node.js writeFileSync / writeFile
if echo "$CMD" | grep -qE 'writeFile(Sync)?'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"writeFile detectado — confirme se intencional"}}\n'
  exit 0
fi

# No write pattern — allow silently
exit 0
