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

  # Use printf for safe JSON — no eval, no injection (KBP-07)
  printf '{"ts":"%s","event":"%s","hook":"%s","category":"%s","pattern":"%s","severity":"%s","detail":"%s"}\n' \
    "$ts" "$event" "$hook" "$category" "$pattern" "$severity" "$detail" \
    >> "$HOOK_LOG_FILE" 2>/dev/null || true
}
