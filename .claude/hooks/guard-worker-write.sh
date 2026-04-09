#!/usr/bin/env bash
# guard-worker-write.sh — PreToolUse: block Write/Edit outside .claude/workers/ when in worker mode
# Worker mode: .claude/.worker-mode file exists
# Exit 0 without JSON = allow. Exit 2 = block.

INPUT=$(cat 2>/dev/null || echo '{}')

# Only active if worker-mode flag exists
WORKER_FLAG="$(git rev-parse --show-toplevel 2>/dev/null)/.claude/.worker-mode"
[ ! -f "$WORKER_FLAG" ] && exit 0

# Parse file path
FULL_PATH=$(echo "$INPUT" | node -e "
  try {
    const d=JSON.parse(require('fs').readFileSync(0,'utf8'));
    const p=(d.tool_input||{}).file_path||(d.tool_input||{}).command||'';
    console.log(p.replace(/\\\\\\\\/g,'/'));
  } catch(e) { console.log(''); }
" 2>/dev/null)

# Allow writes to .claude/workers/
if echo "$FULL_PATH" | grep -q '\.claude/workers/'; then
  exit 0
fi

# Block everything else in worker mode
echo '{"decision":"block","reason":"[WORKER MODE] Write/Edit blocked outside .claude/workers/. Use orchestrator window for repo edits."}'
exit 0
