#!/usr/bin/env bash
# Claude Code hook: Stop
# Dual purpose:
#   1. Verifica se HANDOFF.md e CHANGELOG.md foram atualizados (se houve mudancas)
#   2. Imprime HANDOFF.md no stdout para context recovery pos-compaction
# Evento: Stop | Timeout: 5s

# Drain stdin (hook protocol — prevent parent process stall)
cat >/dev/null 2>&1

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HANDOFF="$PROJECT_ROOT/HANDOFF.md"
CHANGELOG="$PROJECT_ROOT/CHANGELOG.md"

# Checar se houve mudancas no working tree
CHANGED=$(cd "$PROJECT_ROOT" && git diff --name-only 2>/dev/null | wc -l)
STAGED=$(cd "$PROJECT_ROOT" && git diff --cached --name-only 2>/dev/null | wc -l)

if [ "$((CHANGED + STAGED))" -gt 0 ]; then
  # Check both unstaged AND staged changes (Codex S60 O11)
  H_MOD=$(cd "$PROJECT_ROOT" && { git diff --name-only -- HANDOFF.md 2>/dev/null; git diff --cached --name-only -- HANDOFF.md 2>/dev/null; } | wc -l)
  C_MOD=$(cd "$PROJECT_ROOT" && { git diff --name-only -- CHANGELOG.md 2>/dev/null; git diff --cached --name-only -- CHANGELOG.md 2>/dev/null; } | wc -l)

  if [ "$H_MOD" -eq 0 ] || [ "$C_MOD" -eq 0 ]; then
    echo "SESSION-HYGIENE WARNING:"
    [ "$H_MOD" -eq 0 ] && echo "  - HANDOFF.md NOT updated"
    [ "$C_MOD" -eq 0 ] && echo "  - CHANGELOG.md NOT updated"
    echo "  Per session-hygiene rule: update both before ending."
  fi
fi

# Sempre output HANDOFF para context recovery pos-compaction
echo ""
echo "=== HANDOFF.md ==="
if [ -f "$HANDOFF" ]; then
  cat "$HANDOFF"
else
  echo "(HANDOFF.md not found)"
fi
