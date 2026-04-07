#!/usr/bin/env bash
# Claude Code hook: SessionStart (unconditional)
# APL Foundation — initializes session timer + caches BACKLOG top items.
# Evento: SessionStart | Timeout: 3s | Exit: sempre 0

# Consume stdin (hook protocol)
cat > /dev/null 2>&1

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APL_DIR="$PROJECT_ROOT/.claude/apl"

mkdir -p "$APL_DIR"

# Session start timestamp (epoch seconds)
date +%s > "$APL_DIR/session-ts.txt"

# Cache top 3 unchecked BACKLOG items
BACKLOG="$PROJECT_ROOT/BACKLOG.md"
if [ -f "$BACKLOG" ]; then
  grep -m 3 '^\- \[ \]' "$BACKLOG" | sed 's/^- \[ \] //' > "$APL_DIR/backlog-top.txt"
fi

echo "[APL] Cache refreshed. Session timer started."

exit 0
