#!/usr/bin/env bash
# Claude Code hook: SessionStart (compact matcher)
# Re-injects critical rules and HANDOFF after context compaction.
# Without this, compaction drops behavioral rules and agent drifts.
# Evento: SessionStart (compact) | Timeout: 5s | Exit: sempre 0

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cat <<'RULES'
=== REGRAS CRITICAS (pos-compaction) ===

1. NAO avance sem autorizacao do Lucas. Proponha, espere OK, execute.
2. Use scripts existentes (qa-batch-screenshot.mjs, npm run build:{aula}). NAO reinvente.
3. Build ANTES de QA: npm run build:{aula} → qa-batch-screenshot.mjs.
4. QA visual = EU (Opus, multimodal). NAO delegar ao Gemini.
5. Plan mode quando pedido. NAO pule direto para execucao.
RULES

echo ""
echo "=== HANDOFF.md ==="
cat "$PROJECT_ROOT/HANDOFF.md" 2>/dev/null || echo "(HANDOFF.md nao encontrado)"

exit 0
