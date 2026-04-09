#!/usr/bin/env bash
# guard-worker-write.sh -- PreToolUse: two independent guards
# 1. Timestamp enforcement: .claude/workers/**/*.md ALWAYS requires timestamp in H1 (regardless of worker mode)
# 2. Worker-mode guard: when .worker-mode flag exists, block Write/Edit outside .claude/workers/
# Exit 0 without JSON = allow. Exit 2 = block.

INPUT=$(cat 2>/dev/null || echo '{}')

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
[ -z "$REPO_ROOT" ] && exit 0  # Not in git repo -- hook not applicable
WORKER_FLAG="$REPO_ROOT/.claude/.worker-mode"

# Parse file path and tool name
PARSED=$(echo "$INPUT" | node -e "
  try {
    const d=JSON.parse(require('fs').readFileSync(0,'utf8'));
    const p=(d.tool_input||{}).file_path||(d.tool_input||{}).command||'';
    console.log(JSON.stringify({path:p.replace(/\\\\\\\\/g,'/'),tool:d.tool_name||''}));
  } catch(e) { console.log('{}'); }
" 2>/dev/null)

FULL_PATH=$(echo "$PARSED" | node -e "try{console.log(JSON.parse(require('fs').readFileSync(0,'utf8')).path||'')}catch(e){console.log('')}" 2>/dev/null)
TOOL_NAME=$(echo "$PARSED" | node -e "try{console.log(JSON.parse(require('fs').readFileSync(0,'utf8')).tool||'')}catch(e){console.log('')}" 2>/dev/null)

# --- Guard 1: Timestamp enforcement for .claude/workers/**/*.md (ALWAYS active) ---
if echo "$FULL_PATH" | grep -q '\.claude/workers/'; then
  if echo "$FULL_PATH" | grep -q '\.md$'; then
    BLOCK=$(echo "$INPUT" | node -e "
      try {
        const d = JSON.parse(require('fs').readFileSync(0, 'utf8'));
        const tn = d.tool_name || '';
        if (tn === 'Write') {
          const content = (d.tool_input || {}).content || '';
          const firstLine = content.split('\n')[0];
          if (!/^#.+\u2014 \d{4}-\d{2}-\d{2} \d{2}:\d{2}/.test(firstLine)) {
            console.log('missing');
          }
        } else if (tn === 'Edit') {
          const fp = (d.tool_input || {}).file_path || '';
          const fs = require('fs');
          const fpath = fp.replace(/\//g, require('path').sep);
          if (fs.existsSync(fpath)) {
            const firstLine = fs.readFileSync(fpath, 'utf8').split('\n')[0];
            if (!/^#.+\u2014 \d{4}-\d{2}-\d{2} \d{2}:\d{2}/.test(firstLine)) {
              console.log('missing');
            }
          }
        }
      } catch (e) {}
    " 2>/dev/null)

    if [ "$BLOCK" = "missing" ]; then
      printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"[WORKER] MD missing timestamp in H1. Required: # Title \u2014 YYYY-MM-DD HH:MM (multi-window.md convention)"}}\n'
      exit 2
    fi
  fi
  # Path is in workers/ and passed timestamp check (or not .md) -- allow
  exit 0
fi

# --- Guard 2: Worker-mode enforcement (only when flag exists) ---
[ ! -f "$WORKER_FLAG" ] && exit 0

# Block writes outside .claude/workers/ in worker mode
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"[WORKER MODE] Write/Edit blocked outside .claude/workers/. Use orchestrator window for repo edits."}}\n'
exit 2
