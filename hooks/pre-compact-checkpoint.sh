#!/usr/bin/env bash
# Claude Code hook: PreCompact
# Saves a lightweight checkpoint so session-compact.sh can restore context.
# Captures both code state (git) and cognitive state (plans, research, pending fixes).
# Overwrites each turn — only latest state matters.
# Evento: PreCompact | Timeout: 5000ms | Exit: sempre 0

# Drain stdin (hook protocol — prevent parent process stall)
cat >/dev/null 2>&1

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CHECKPOINT="$PROJECT_ROOT/.claude/.last-checkpoint"

{
  echo "=== Checkpoint $(date '+%Y-%m-%d %H:%M:%S') ==="
  echo ""

  echo "## Session Name"
  cat "$PROJECT_ROOT/.claude/.session-name" 2>/dev/null || echo "(none)"
  echo ""

  echo "## HANDOFF Header"
  head -5 "$PROJECT_ROOT/HANDOFF.md" 2>/dev/null || echo "(no HANDOFF)"
  echo ""

  echo "## Git Status"
  git -C "$PROJECT_ROOT" status --short 2>/dev/null | head -20
  echo ""

  echo "## Recently Modified (last 10 min)"
  find "$PROJECT_ROOT" -maxdepth 4 \( -name "*.html" -o -name "*.js" -o -name "*.md" -o -name "*.css" \) -mmin -10 2>/dev/null \
    | head -10
  echo ""

  echo "## Active Plan"
  if [ -f "$PROJECT_ROOT/.claude/.plan-path" ]; then
    cat "$PROJECT_ROOT/.claude/.plan-path" 2>/dev/null
  else
    # Most recently modified plan file (excluding archive)
    find "$PROJECT_ROOT/.claude/plans" -maxdepth 1 -name "*.md" -mmin -60 2>/dev/null \
      | head -3
  fi
  echo ""

  echo "## Recent Plan Files (agent research)"
  find "$PROJECT_ROOT/.claude/plans" -maxdepth 1 -name "*.md" -newer "$CHECKPOINT" 2>/dev/null \
    | head -5 || \
  find "$PROJECT_ROOT/.claude/plans" -maxdepth 1 -name "*.md" -mmin -30 2>/dev/null \
    | head -5
  echo ""

  echo "## Pending Fixes"
  if [ -f "$PROJECT_ROOT/.claude/pending-fixes.md" ]; then
    head -10 "$PROJECT_ROOT/.claude/pending-fixes.md" 2>/dev/null
  else
    echo "(none)"
  fi
} > "$CHECKPOINT" 2>/dev/null

exit 0
