#!/usr/bin/env bash
# Claude Code hook: StopFailure
# Logs Stop hook failures / API errors to hook-log.jsonl for later inspection.
# Evento: StopFailure | Timeout: 3s | Exit: sempre 0
# S241 infra: cobre blind spot Agent 1 (Anthropic SOTA) — subagents pesados
# morriam em API errors sem deixar traço. Complementa post-tool-use-failure.sh.
# S243 F05/F24-F32: fail-complete semantic. set -euo removed (F32), sentinel
# always touched (F32 >> append), defensive checks, jq/grep platform fallback.

# F32 sentinel append BEFORE any logic — survives all downstream failures
SENTINEL_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}/.claude"
{ [[ -d "$SENTINEL_DIR" ]] && date -u +%Y-%m-%dT%H:%M:%SZ >> "$SENTINEL_DIR/.stop-failure-sentinel"; } 2>/dev/null || true

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"

# F24 defensive PROJECT_ROOT check (fallback if CLAUDE_PROJECT_DIR broken)
[[ -d "$PROJECT_ROOT" ]] || PROJECT_ROOT="$(pwd)"

# F27 guard-against-claude resolve: return/exit 0 (was exit 1 — wrong semantic)
if [[ "$(basename "$PROJECT_ROOT")" == ".claude" ]]; then
  echo "WARN: PROJECT_ROOT resolved to .claude -- hook skipped" >&2
  return 0 2>/dev/null || exit 0
fi

# F25 pré-source existence check (avoid noisy error if lib missing)
[[ -f "$PROJECT_ROOT/hooks/lib/hook-log.sh" ]] || exit 0
. "$PROJECT_ROOT/hooks/lib/hook-log.sh" 2>/dev/null || exit 0

# F29 INPUT defensive chain (no set -euo, fallback chain to empty JSON)
INPUT="${INPUT:-$(cat 2>/dev/null)}"
[[ -z "$INPUT" ]] && INPUT='{}'

# F26 jq pipeline restructured — no pipefail dep, explicit capture
REASON="unknown"
if command -v jq &>/dev/null; then
  JQ_OUT=$(echo "$INPUT" | jq -r '.reason // .error // .message // "unknown"' 2>/dev/null)
  [[ -n "$JQ_OUT" && "$JQ_OUT" != "null" ]] && REASON="$JQ_OUT"
else
  # F30 platform detect: grep -P non-portable (BSD grep lacks)
  if echo test | grep -qP '' 2>/dev/null; then
    GREP_OUT=$(echo "$INPUT" | grep -oP '"(reason|error|message)"\s*:\s*"[^"]*"' 2>/dev/null | head -1 | sed 's/.*:\s*"\([^"]*\)".*/\1/' 2>/dev/null)
  else
    GREP_OUT=$(echo "$INPUT" | grep -oE '"(reason|error|message)":"[^"]*"' 2>/dev/null | head -1 | sed 's/.*":"\([^"]*\)"/\1/' 2>/dev/null)
  fi
  [[ -n "$GREP_OUT" ]] && REASON="$GREP_OUT"
fi

# F28 escape $REASON for safe embedding in hook_log printf "%s" JSON
# Manual JSON string escape: backslash FIRST (else double-escape), then double-quote
REASON_ESC=$(printf '%s' "$REASON" | sed 's/\\/\\\\/g; s/"/\\"/g' 2>/dev/null)
[[ -z "$REASON_ESC" ]] && REASON_ESC="unknown"

# F05 || true per chamada externa (no abort mid-lifecycle if hook_log fails)
hook_log "StopFailure" "stop-failure-log" "stop-or-api-error" "claude-code" "warn" "$REASON_ESC" 2>/dev/null || true

exit 0
