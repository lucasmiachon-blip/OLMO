#!/usr/bin/env bash
# guard-worker-write.sh -- PreToolUse: two independent guards
# 1. Timestamp enforcement: .claude/workers/**/*.md ALWAYS requires ACCURATE timestamp in H1
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
    console.log(JSON.stringify({path:p.split('\\\\').join('/'),tool:d.tool_name||''}));
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
        let firstLine = '';

        if (tn === 'Write') {
          firstLine = ((d.tool_input || {}).content || '').split('\n')[0];
        } else if (tn === 'Edit') {
          const fp = (d.tool_input || {}).file_path || '';
          const fs = require('fs');
          const fpath = fp.replace(/^\/([a-zA-Z])\//, (_, drive) => drive.toUpperCase() + ':/');
          if (fs.existsSync(fpath)) {
            firstLine = fs.readFileSync(fpath, 'utf8').split('\n')[0];
          }
        }

        if (!firstLine) { process.exit(0); }

        const fmtMatch = firstLine.match(/^#.+\u2014 (\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2})/);
        if (!fmtMatch) { console.log('missing'); process.exit(0); }

        const [, y, mo, da, h, mi] = fmtMatch.map(Number);
        if (mo < 1 || mo > 12 || da < 1 || da > 31 || h > 23 || mi > 59) {
          console.log('invalid'); process.exit(0);
        }
        const tsDate = new Date(y, mo - 1, da, h, mi);
        const diffMin = Math.abs(Date.now() - tsDate.getTime()) / 60000;
        if (diffMin > 5) {
          console.log('stale'); process.exit(0);
        }
      } catch (e) {}
    " 2>/dev/null)

    case "$BLOCK" in
      missing)
        printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"[WORKER] MD missing timestamp in H1. Required: # Title \u2014 YYYY-MM-DD HH:MM. Get time: date +%%Y-%%m-%%d\\ %%H:%%M"}}\n'
        exit 2 ;;
      invalid)
        printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"[WORKER] Timestamp has impossible values. Check month/day/hour ranges."}}\n'
        exit 2 ;;
      stale)
        printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"[WORKER] Timestamp >5min from system clock. Get real time: date +%%Y-%%m-%%d\\ %%H:%%M"}}\n'
        exit 2 ;;
    esac
  fi
  # Path is in workers/ and passed timestamp check (or not .md) -- allow
  exit 0
fi

# --- Guard 2: Worker-mode enforcement (only when flag exists) ---
[ ! -f "$WORKER_FLAG" ] && exit 0

# Block writes outside .claude/workers/ in worker mode
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"[WORKER MODE] Write/Edit blocked outside .claude/workers/. Use orchestrator window for repo edits."}}\n'
exit 2
