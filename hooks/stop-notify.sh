#!/usr/bin/env bash
set -euo pipefail
# Claude Code hook: Stop
# Beep + toast quando Claude termina de responder.
# Evento: Stop | Timeout: 10s | Exit: sempre 0 (nunca bloqueia)

# Drain stdin (hook protocol — prevent parent process stall)
cat >/dev/null 2>&1

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"

# S255 Phase 3 A.3: toast logic extracted to hooks/lib/toast.sh (DRY with notify.sh)
. "$PROJECT_ROOT/hooks/lib/toast.sh"
show_toast 'Claude Code' 'Pronto' 2000

exit 0
