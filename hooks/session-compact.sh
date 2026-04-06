#!/usr/bin/env bash
# Claude Code hook: SessionStart (compact matcher)
# Re-injects critical rules and HANDOFF after context compaction.
# Without this, compaction drops behavioral rules and agent drifts.
# Evento: SessionStart (compact) | Timeout: 5s | Exit: sempre 0

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

ESSENTIALS="$PROJECT_ROOT/.claude/context-essentials.md"
if [ -f "$ESSENTIALS" ]; then
  cat "$ESSENTIALS"
else
  # Fallback hardcoded caso arquivo nao exista
  cat <<'RULES'
=== REGRAS CRITICAS (pos-compaction) ===
1. NAO avance sem autorizacao do Lucas. Proponha, espere OK, execute.
2. Use scripts existentes. NAO reinvente.
3. Build ANTES de QA. QA visual = Opus, NAO Gemini.
RULES
fi

echo ""
echo "=== HANDOFF.md ==="
cat "$PROJECT_ROOT/HANDOFF.md" 2>/dev/null || echo "(HANDOFF.md nao encontrado)"

exit 0
