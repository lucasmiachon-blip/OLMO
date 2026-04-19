#!/usr/bin/env bash
set -euo pipefail
# Claude Code hook: PostToolUseFailure
# Logs tool failures to hook-log.jsonl + injects corrective guidance as systemMessage.
# Evento: PostToolUseFailure | Timeout: 5s | Exit: sempre 0
# S225 Issue #7: defensive cat fallback — prevents hook abort on broken stdin pipe.
# S230 G.7: KBP-23 enforcement — banner_warn quando Read falha com "exceeds maximum tokens".

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
[[ "$(basename "$PROJECT_ROOT")" == ".claude" ]] && { echo "ERROR: PROJECT_ROOT resolved to .claude -- hook aborted" >&2; exit 1; }
. "$PROJECT_ROOT/hooks/lib/hook-log.sh"

# Read event JSON from stdin (S225: defensive fallback for broken pipe)
INPUT=$(cat 2>/dev/null || echo '{}')

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

# S230 Phase G.7: KBP-23 enforcement (Read sem limit)
if [[ "$TOOL_NAME" == "Read" ]] && [[ "$ERROR_MSG" == *"exceeds maximum allowed tokens"* ]]; then
  { . "$PROJECT_ROOT/hooks/lib/banner.sh" && banner_warn "KBP-23 Read sem limit" "Use 'limit: 50' primeiro" "Depois Grep targeted" >&2; } || true
fi

# Inject corrective guidance as systemMessage
SAFE_ERROR=$(echo "$ERROR_MSG" | sed 's/"/\\"/g' | head -c 200)

cat <<EOF
{"hookSpecificOutput":{"systemMessage":"Tool '$TOOL_NAME' failed: $SAFE_ERROR. Read the complete error, diagnose root cause before retrying. Do not retry the same command blindly."}}
EOF

exit 0
