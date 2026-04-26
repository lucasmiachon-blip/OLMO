#!/usr/bin/env bash
set -euo pipefail
# guard-bash-write.sh — PreToolUse(Bash): ask confirmation on shell write patterns
# Catches file writes via Bash that bypass Edit/Write guards (guard-pause, guard-product-files).
# Uses "ask" (not block) — legitimate writes proceed with user approval.
# Motivation: Codex audit S57 — "Bash(echo > file)" bypasses ALL file guards.
#
# S256 B.4 D4 Lucas decision (c) KEEP + CLEAN DEAD: pre-S256 script tinha 23
# patterns mas settings.json:246 `if Bash(*>*|*>>*|*rm *|*mv *|*cp *|*chmod*|*kill*)`
# filter only triggers hook para 7 categorias (>, >>, rm, mv, cp, chmod, kill).
# Patterns sem match no filter eram dead code = teatro (Voice Codex B3 audit).
# Removed (S256): sed -i, tee, writeFile, curl -o, wget -O, python, dd of=,
# perl/ruby inline, Node.js fs, touch, mkdir, ln, patch, tar/unzip, git apply/am,
# truncate, awk system, find -exec, xargs interpreter, make. Sub-patterns dead
# também removidos: Pattern 8 install/rsync (only cp/mv live); Pattern 18 chown
# (only chmod live). Kill filter continua but no detector — destructive process
# ops out of scope este hook (defense surface = file writes).
#
# Defesa real (5 LIVE patterns) reflete os settings filter: redirect (>, >>),
# cp/mv, rm/rmdir, chmod, plus .claude/workers/ specific guards.

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

# Pattern 1: redirect to file (> or >> followed by path-like target) — filter `*>*|*>>*` LIVE
if echo "$CLEANED" | grep -qE '>>?[[:space:]]*[A-Za-z0-9./~$"'\''_-]'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"Shell redirect detectado — confirme se intencional"}}\n'
  exit 0
fi

# Pattern 8: cp/mv — file copy/move primitives (Codex S60 O5/A1) — filter `*cp *|*mv *` LIVE
# S256 B.4: install|rsync sub-detectors removed (DEAD — não em settings filter).
if echo "$CMD" | grep -qE '\b(cp|mv)\b'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"File copy/move detectado — confirme se intencional"}}\n'
  exit 0
fi

# Pattern 17: rm/rmdir — file/directory deletion — filter `*rm *` LIVE
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

# Pattern 18: chmod — permission changes — filter `*chmod*` LIVE
# S256 B.4: chown sub-detector removed (DEAD — não em settings filter).
if echo "$CMD" | grep -qE '\bchmod\b'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"chmod detectado — confirme se intencional"}}\n'
  exit 0
fi

# No write pattern — allow silently
exit 0
