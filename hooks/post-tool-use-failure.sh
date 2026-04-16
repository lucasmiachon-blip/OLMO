#!/usr/bin/env bash
set -euo pipefail
# Claude Code hook: PostToolUseFailure
# Logs tool failures to hook-log.jsonl + injects corrective guidance as systemMessage.
# Evento: PostToolUseFailure | Timeout: 5s | Exit: sempre 0

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
. "$PROJECT_ROOT/hooks/lib/hook-log.sh"

# Read event JSON from stdin
INPUT=$(cat)

# Extract tool name and error (best-effort, jq if available)
TOOL_NAME=""
ERROR_MSG=""
if command -v jq &>/dev/null; then
  TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"' 2>/dev/null || echo "unknown")
  ERROR_MSG=$(echo "$INPUT" | jq -r '.error // .tool_error // "no error message"' 2>/dev/null || echo "no error message")
else
  TOOL_NAME=$(echo "$INPUT" | grep -oP '"tool_name"\s*:\s*"[^"]*"' | head -1 | sed 's/.*"tool_name"\s*:\s*"\([^"]*\)".*/\1/' || echo "unknown")
  ERROR_MSG="(jq not available)"
fi

# Log to structured JSONL
hook_log "PostToolUseFailure" "post-tool-use-failure" "tool-error" "$TOOL_NAME" "warn" "$ERROR_MSG"

# Inject corrective guidance as systemMessage
SAFE_ERROR=$(echo "$ERROR_MSG" | sed 's/"/\\"/g' | head -c 200)

cat <<EOF
{"hookSpecificOutput":{"systemMessage":"Tool '$TOOL_NAME' failed: $SAFE_ERROR. Read the complete error, diagnose root cause before retrying. Do not retry the same command blindly."}}
EOF

exit 0
