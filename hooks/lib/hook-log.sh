#!/usr/bin/env bash
# hook-log.sh — Structured JSONL logging for hooks
# Source this file: . "$PROJECT_ROOT/hooks/lib/hook-log.sh"
# Usage: hook_log "event" "hook_name" "category" "pattern" "severity" "detail"
# Appends one JSON line to .claude/hook-log.jsonl

HOOK_LOG_FILE="${CLAUDE_PROJECT_DIR:-.}/.claude/hook-log.jsonl"

hook_log() {
  local event="${1:-unknown}"
  local hook="${2:-unknown}"
  local category="${3:-uncategorized}"
  local pattern="${4:-}"
  local severity="${5:-info}"
  local detail="${6:-}"
  local ts
  ts=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

  # S256 A.8: jq -cn --arg for safe JSON construction (defends quotes/newlines/
  # backslashes em $detail/$pattern que corrompiam JSONL pre-fix com printf raw
  # interpolação). Fallback printf se jq missing — best-effort, tail readers
  # parse line-by-line tolerant.
  if command -v jq >/dev/null 2>&1; then
    jq -cn \
      --arg ts "$ts" \
      --arg event "$event" \
      --arg hook "$hook" \
      --arg category "$category" \
      --arg pattern "$pattern" \
      --arg severity "$severity" \
      --arg detail "$detail" \
      '{ts:$ts,event:$event,hook:$hook,category:$category,pattern:$pattern,severity:$severity,detail:$detail}' \
      >> "$HOOK_LOG_FILE" 2>/dev/null || true
  else
    printf '{"ts":"%s","event":"%s","hook":"%s","category":"%s","pattern":"%s","severity":"%s","detail":"%s"}\n' \
      "$ts" "$event" "$hook" "$category" "$pattern" "$severity" "$detail" \
      >> "$HOOK_LOG_FILE" 2>/dev/null || true
  fi
}
