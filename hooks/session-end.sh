#!/usr/bin/env bash
set -euo pipefail
# Claude Code hook: SessionEnd
# Fires ONCE on true session exit (vs Stop which fires per turn).
# Responsibilities: dream flag check, final metrics snapshot, log session end.
# Evento: SessionEnd | Timeout: 5s | Exit: sempre 0

# Drain stdin
cat >/dev/null 2>&1

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
[[ "$(basename "$PROJECT_ROOT")" == ".claude" ]] && { echo "ERROR: PROJECT_ROOT resolved to .claude -- hook aborted" >&2; exit 1; }
. "$PROJECT_ROOT/hooks/lib/hook-log.sh"

LAST_DREAM_FILE="$HOME/.claude/.last-dream"
PENDING_FILE="$HOME/.claude/.dream-pending"

# --- Dream flag (moved from stop-should-dream.sh) ---
if [ ! -f "$PENDING_FILE" ]; then
  SHOULD_DREAM=false

  if [ ! -f "$LAST_DREAM_FILE" ]; then
    SHOULD_DREAM=true
  else
    LAST=$(cat "$LAST_DREAM_FILE" 2>/dev/null | tr -d '[:space:]')
    NOW=$(date +%s)
    if ! [[ "$LAST" =~ ^[0-9]+$ ]]; then
      SHOULD_DREAM=true
    elif [ $(( NOW - LAST )) -ge 86400 ]; then
      SHOULD_DREAM=true
    fi
  fi

  if [ "$SHOULD_DREAM" = true ]; then
    touch "$PENDING_FILE"
    hook_log "SessionEnd" "session-end" "dream" "dream-pending-created" "info" ">=24h since last dream"
  fi
fi

# --- Log session end ---
hook_log "SessionEnd" "session-end" "lifecycle" "session-closed" "info" ""

exit 0
