#!/usr/bin/env bash
# guard-bash-write.sh — PreToolUse(Bash): ask confirmation on shell write patterns
# Catches file writes via Bash that bypass Edit/Write guards (guard-pause, guard-product-files).
# Uses "ask" (not block) — legitimate writes proceed with user approval.
# Motivation: Codex audit S57 — "Bash(echo > file)" bypasses ALL file guards.

INPUT=$(cat 2>/dev/null || echo '{}')

# Extract command from tool_input — jq (10x faster than node, S193)
# Fail-closed: if parse fails, ask (Codex S60 O4/A2/A4)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // ""' 2>/dev/null)
if [ -z "$CMD" ] && echo "$INPUT" | grep -q '"command"'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"JSON parse falhou — confirme comando"}}\n'
  exit 0
fi

[ -z "$CMD" ] && exit 0

# Whitelist: session metadata (always benign)
if echo "$CMD" | grep -q '\.session-name'; then
  exit 0
fi

# Block Bash writes to .claude/workers/ — force Write tool (timestamp enforcement via guard-worker-write)
if echo "$CMD" | grep -qE '\.claude/workers/.*\.(md|txt)'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"[SECURITY] Bash writes to .claude/workers/ blocked — use Write tool (timestamp enforcement)"}}\n'
  exit 2
fi

# Remove safe redirect patterns before checking for file writes
# Safe: 2>&1, >/dev/null, 2>/dev/null, &>/dev/null
CLEANED=$(echo "$CMD" | sed -E 's/2>&1//g; s/[12&]?>[[:space:]]*\/dev\/null//g')

# Pattern 1: redirect to file (> or >> followed by path-like target)
if echo "$CLEANED" | grep -qE '>>?[[:space:]]*[A-Za-z0-9./~$"'\''_-]'; then
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

# Pattern 7: Python execution (inline -c AND script files — S193 fix backlog #20)
# Catches: python -c, python script.py, python ./file.py, python3, py
# Allows: python --version, python --help, python -m pip
if echo "$CMD" | grep -qE '(python3?|py)\s+(-c\b|[^-][^-])'; then
  if ! echo "$CMD" | grep -qE '(python3?|py)\s+--(version|help)' && \
     ! echo "$CMD" | grep -qE '(python3?|py)\s+-m\s+pip'; then
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"Python execution detectado — confirme se intencional"}}\n'
    exit 0
  fi
fi

# Pattern 8: cp/mv/install/rsync — file copy/move primitives (Codex S60 O5/A1)
if echo "$CMD" | grep -qE '\b(cp|mv|install|rsync)\b'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"File copy/move detectado — confirme se intencional"}}\n'
  exit 0
fi

# Pattern 9: dd — raw block copy
if echo "$CMD" | grep -qE '\bdd\b.*\bof='; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"dd of= detectado — confirme se intencional"}}\n'
  exit 0
fi

# Pattern 10: perl -pi (in-place edit) / ruby -e with File.write
if echo "$CMD" | grep -qE '(perl\s+-[a-zA-Z]*p[a-zA-Z]*i|perl\s+-i|ruby\s+-e)'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"perl/ruby inline edit detectado — confirme se intencional"}}\n'
  exit 0
fi

# Pattern 11: Node.js fs.promises.writeFile / fs.appendFile (Codex S60 A2 evasion)
if echo "$CMD" | grep -qE '(fs\.promises\.writeFile|fs\.appendFile|fs\.createWriteStream)'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"Node.js fs write detectado — confirme se intencional"}}\n'
  exit 0
fi

# Pattern 12: touch — file creation
if echo "$CMD" | grep -qE '\btouch\b'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"touch detectado — confirme se intencional"}}\n'
  exit 0
fi

# Pattern 13: mkdir — directory creation
if echo "$CMD" | grep -qE '\bmkdir\b'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"mkdir detectado — confirme se intencional"}}\n'
  exit 0
fi

# Pattern 14: ln — symlink/hardlink creation
if echo "$CMD" | grep -qE '\bln\b'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"ln detectado — confirme se intencional"}}\n'
  exit 0
fi

# Pattern 15: tar/unzip/gunzip — archive extraction (creates files)
if echo "$CMD" | grep -qE '\b(tar\b.*-[a-zA-Z]*x|unzip|gunzip|7z\s+x)\b'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"Archive extraction detectado — confirme se intencional"}}\n'
  exit 0
fi

# Pattern 16: git apply/am — patch application
if echo "$CMD" | grep -qE '\bgit\s+(apply|am)\b'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"git apply/am detectado — confirme se intencional"}}\n'
  exit 0
fi

# Pattern 17: rm/rmdir — file/directory deletion
# 17a: ASK before rm on .claude/workers/ (irreplaceable research data)
# Whitelist: .worker-mode flag, .dream-pending flag
if echo "$CMD" | grep -qE '\b(rm|rmdir)\b'; then
  if echo "$CMD" | grep -qE '\.claude/workers/' && ! echo "$CMD" | grep -qE '\.(worker-mode|dream-pending)'; then
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"[SAFETY] rm em .claude/workers/ — workers contem pesquisa. Lucas aprova?"}}\n'
    exit 0
  fi
  # 17b: All other rm/rmdir — ask confirmation
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"rm/rmdir detectado — confirme se intencional"}}\n'
  exit 0
fi

# Pattern 18: chmod/chown — permission changes
if echo "$CMD" | grep -qE '\b(chmod|chown)\b'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"chmod/chown detectado — confirme se intencional"}}\n'
  exit 0
fi

# Pattern 19: truncate — file truncation
if echo "$CMD" | grep -qE '\btruncate\b'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"truncate detectado — confirme se intencional"}}\n'
  exit 0
fi

# No write pattern — allow silently
exit 0
