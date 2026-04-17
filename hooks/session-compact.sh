#!/usr/bin/env bash
set -euo pipefail
# Claude Code hook: SessionStart (compact matcher)
# Re-injects critical rules and HANDOFF after context compaction.
# Without this, compaction drops behavioral rules and agent drifts.
# Evento: SessionStart (compact) | Timeout: 5s | Exit: sempre 0

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
[[ "$(basename "$PROJECT_ROOT")" == ".claude" ]] && { echo "ERROR: PROJECT_ROOT resolved to .claude -- hook aborted" >&2; exit 1; }

ESSENTIALS="$PROJECT_ROOT/.claude/context-essentials.md"
if [ -f "$ESSENTIALS" ]; then
  cat "$ESSENTIALS"
else
  # Fallback hardcoded caso arquivo nao exista
  cat <<'RULES'
=== REGRAS CRITICAS (pos-compaction) ===
1. NAO avance sem autorizacao do Lucas. Proponha, espere OK, execute.
2. Use scripts existentes. NAO reinvente.
3. Build ANTES de QA. QA via gemini-qa3.mjs (Gemini Flash/Pro). Opus orquestra, NAO avalia visual.
RULES
fi

echo ""
echo "=== HANDOFF.md ==="
cat "$PROJECT_ROOT/HANDOFF.md" 2>/dev/null || echo "(HANDOFF.md nao encontrado)"

CHECKPOINT="$PROJECT_ROOT/.claude/.last-checkpoint"
if [ -f "$CHECKPOINT" ]; then
  echo ""
  echo "=== Last Checkpoint (pre-compaction snapshot) ==="
  cat "$CHECKPOINT"
fi

exit 0
