#!/usr/bin/env bash
# Claude Code hook: Stop (runs after every turn)
# Saves a lightweight checkpoint so session-compact.sh can restore context.
# Overwrites each turn — only latest state matters.
# Evento: Stop | Timeout: 5s | Exit: sempre 0

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CHECKPOINT="$PROJECT_ROOT/.claude/.last-checkpoint"

{
  echo "=== Checkpoint $(date '+%Y-%m-%d %H:%M:%S') ==="
  echo ""
  echo "## Git Status"
  git -C "$PROJECT_ROOT" status --short 2>/dev/null | head -20
  echo ""
  echo "## Recently Modified (last 10 min)"
  find "$PROJECT_ROOT" -maxdepth 4 -name "*.html" -o -name "*.js" -o -name "*.md" -o -name "*.css" 2>/dev/null \
    | xargs stat --format='%Y %n' 2>/dev/null \
    | awk -v cutoff="$(date -d '10 minutes ago' +%s 2>/dev/null || echo 0)" '$1 > cutoff {print $2}' \
    | head -10
  echo ""
  echo "## Session Name"
  cat "$PROJECT_ROOT/.claude/.session-name" 2>/dev/null || echo "(none)"
} > "$CHECKPOINT" 2>/dev/null

exit 0
