#!/usr/bin/env bash
# PostToolUse(Bash): Success Capture — log clean commits to JSONL
# Detects successful git commit (exit 0) and appends to success-log.jsonl.
# Consumers: /insights, /dream (future). Append-only, gitignored.
# Pattern: build-monitor.sh (PostToolUse+Bash, single node call)

INPUT=$(cat 2>/dev/null || echo '{}')

# === TEMP DEBUG S152 (remove after root cause found) ===
DEBUG_DIR="/c/Dev/Projetos/OLMO/.claude"
echo "[$(date -u '+%Y-%m-%dT%H:%M:%SZ')] invoked" >> "$DEBUG_DIR/success-capture.debug.log"
echo "$INPUT" > "$DEBUG_DIR/success-capture.debug.last-input"
# === END TEMP DEBUG ===

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOG_FILE="$PROJECT_ROOT/.claude/success-log.jsonl"

# Parse stdin: extract command and exit_code
PARSED=$(echo "$INPUT" | node -e "
const d=JSON.parse(require('fs').readFileSync(0,'utf8') || '{}');
const ti=d.tool_input||{};
const tr=d.tool_response||{};
console.log(ti.command||'');
console.log(tr.exit_code===undefined?'0':String(tr.exit_code));
" 2>/dev/null) || exit 0

CMD=$(echo "$PARSED" | sed -n '1p')
EXIT_CODE=$(echo "$PARSED" | sed -n '2p')

# Gate: only git commit commands
[[ "$CMD" != *"git commit"* ]] && exit 0

# Gate: only successful commits
[ "$EXIT_CODE" != "0" ] && exit 0

# Gather data via git
HASH=$(git -C "$PROJECT_ROOT" log -1 --format=%h 2>/dev/null || echo "unknown")
MSG=$(git -C "$PROJECT_ROOT" log -1 --format=%s 2>/dev/null || echo "")
FILES_CHANGED=$(git -C "$PROJECT_ROOT" diff --name-only HEAD~1 HEAD 2>/dev/null | wc -l | tr -d ' ')
TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

SESSION=""
if [ -f "$PROJECT_ROOT/.claude/.session-name" ]; then
  SESSION=$(cat "$PROJECT_ROOT/.claude/.session-name" 2>/dev/null || echo "")
fi

# Single node call for safe JSON encoding (no shell interpolation in JSON)
export SC_TS="$TIMESTAMP" SC_SESSION="$SESSION" SC_HASH="$HASH" SC_FILES="$FILES_CHANGED" SC_MSG="$MSG"
node -e "
const e = {
  timestamp: process.env.SC_TS,
  session: process.env.SC_SESSION,
  commit: process.env.SC_HASH,
  files_changed: parseInt(process.env.SC_FILES, 10) || 0,
  message: process.env.SC_MSG
};
console.log(JSON.stringify(e));
" >> "$LOG_FILE" 2>/dev/null

exit 0
