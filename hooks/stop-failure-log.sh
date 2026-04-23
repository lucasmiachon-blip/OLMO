#!/usr/bin/env bash
set -euo pipefail
# Claude Code hook: StopFailure
# Logs Stop hook failures / API errors to hook-log.jsonl for later inspection.
# Evento: StopFailure | Timeout: 3s | Exit: sempre 0
# S241 infra-plataforma: cobre blind spot identificado pelo Agent 1 (Anthropic
# SOTA research) — subagents pesados (research, qa-engineer) morriam em API
# errors sem deixar traço. Complementa post-tool-use-failure.sh (tool-level).

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
[[ "$(basename "$PROJECT_ROOT")" == ".claude" ]] && { echo "ERROR: PROJECT_ROOT resolved to .claude -- hook aborted" >&2; exit 1; }
. "$PROJECT_ROOT/hooks/lib/hook-log.sh"

# Read event JSON from stdin (defensive fallback for broken pipe)
INPUT=$(cat 2>/dev/null || echo '{}')

# Extract failure reason (best-effort, jq preferred)
REASON=""
if command -v jq &>/dev/null; then
  REASON=$(echo "$INPUT" | jq -r '.reason // .error // .message // "unknown"' 2>/dev/null || echo "unknown")
else
  REASON=$(echo "$INPUT" | grep -oP '"(reason|error|message)"\s*:\s*"[^"]*"' | head -1 | sed 's/.*:\s*"\([^"]*\)".*/\1/' || echo "unknown")
fi

# Log to structured JSONL (consumido por sentinel/insights downstream)
hook_log "StopFailure" "stop-failure-log" "stop-or-api-error" "claude-code" "warn" "$REASON"

exit 0
