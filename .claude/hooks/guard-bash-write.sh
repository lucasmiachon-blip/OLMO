#!/usr/bin/env bash
# guard-bash-write.sh — PreToolUse(Bash): ask confirmation on shell write patterns
# Catches file writes via Bash that bypass Edit/Write guards (guard-pause, guard-product-files).
# Uses "ask" (not block) — legitimate writes proceed with user approval.
# Motivation: Codex audit S57 — "Bash(echo > file)" bypasses ALL file guards.

INPUT=$(cat 2>/dev/null || echo '{}')

# Extract command from tool_input — node parser (not sed, avoids JSON truncation)
# Fail-closed: if parse fails, block (Codex S60 O4/A2/A4)
CMD=$(echo "$INPUT" | node -e "
  try {
    const d=JSON.parse(require('fs').readFileSync(0,'utf8'));
    console.log((d.tool_input||{}).command||'');
  } catch(e) { process.exit(1); }
" 2>/dev/null) || {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"JSON parse falhou — confirme comando"}}\n'
  exit 0
}

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

# Pattern 5: curl download to file (-o / --output)
if echo "$CMD" | grep -qE 'curl\b.*(-o\b|--output\b)'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"curl -o detectado — confirme se intencional"}}\n'
  exit 0
fi

# Pattern 6: wget download to file (-O / --output-document)
if echo "$CMD" | grep -qE 'wget\b.*(-O\b|--output-document\b)'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"wget -O detectado — confirme se intencional"}}\n'
  exit 0
fi

# Pattern 7: Python one-liner (-c flag can write files via open())
if echo "$CMD" | grep -qE 'python3?\s+-c\b'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"python -c detectado — confirme se intencional"}}\n'
  exit 0
fi

# No write pattern — allow silently
exit 0
