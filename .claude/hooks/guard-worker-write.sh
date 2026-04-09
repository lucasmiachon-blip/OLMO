#!/usr/bin/env bash
# guard-worker-write.sh — PreToolUse: block Write/Edit outside .claude/workers/ when in worker mode
# Worker mode: .claude/.worker-mode file exists
# Exit 0 without JSON = allow. Exit 2 = block.

INPUT=$(cat 2>/dev/null || echo '{}')

# Only active if worker-mode flag exists
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
[ -z "$REPO_ROOT" ] && exit 0  # Not in git repo — hook not applicable
WORKER_FLAG="$REPO_ROOT/.claude/.worker-mode"
[ ! -f "$WORKER_FLAG" ] && exit 0

# Parse file path
FULL_PATH=$(echo "$INPUT" | node -e "
  try {
    const d=JSON.parse(require('fs').readFileSync(0,'utf8'));
    const p=(d.tool_input||{}).file_path||(d.tool_input||{}).command||'';
    console.log(p.replace(/\\\\\\\\/g,'/'));
  } catch(e) { console.log(''); }
" 2>/dev/null)

# Allow writes to .claude/workers/ — but validate timestamp in .md H1 (Write only)
if echo "$FULL_PATH" | grep -q '\.claude/workers/'; then
  BLOCK=$(echo "$INPUT" | node -e "
    try {
      const d = JSON.parse(require('fs').readFileSync(0, 'utf8'));
      if (d.tool_name !== 'Write') process.exit(0);
      const fp = (d.tool_input || {}).file_path || '';
      if (!fp.endsWith('.md')) process.exit(0);
      const content = (d.tool_input || {}).content || '';
      const firstLine = content.split('\n')[0];
      if (!/^#.+\u2014 \d{4}-\d{2}-\d{2} \d{2}:\d{2}/.test(firstLine)) {
        console.log('missing');
      }
    } catch (e) {}
  " 2>/dev/null)

  if [ "$BLOCK" = "missing" ]; then
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"[WORKER] MD missing timestamp in H1. Required: # Title \u2014 YYYY-MM-DD HH:MM (multi-window.md convention)"}}\n'
    exit 2
  fi

  exit 0
fi

# Block everything else in worker mode
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"[WORKER MODE] Write/Edit blocked outside .claude/workers/. Use orchestrator window for repo edits."}}\n'
exit 2
