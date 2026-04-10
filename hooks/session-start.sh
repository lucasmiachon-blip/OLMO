#!/usr/bin/env bash
# Claude Code hook: SessionStart
# Hidrata sessao nova: projeto, data, sessao, HANDOFF completo.
# Evento: SessionStart | Timeout: 5s | Exit: sempre 0

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_NAME=$(basename "$PROJECT_ROOT")
TODAY=$(date +%Y-%m-%d)
SESSION_FILE="$PROJECT_ROOT/.claude/.session-name"

# Limpar nome da sessao anterior
rm -f "$SESSION_FILE"

# Proximo numero de sessao — take max (not first match) to avoid regression (Codex S60 O10)
LAST_SESSION=$(grep -o 'Sessao [0-9]*' "$PROJECT_ROOT/CHANGELOG.md" 2>/dev/null | grep -o '[0-9]*' | sort -n | tail -1)
NEXT_SESSION=$((LAST_SESSION + 1))

# Generate session-scoped ID for cost brake (B7-06 S102) — AFTER computing NEXT_SESSION
echo "${NEXT_SESSION}_$(date +%Y%m%d_%H%M%S)" > /tmp/cc-session-id.txt

cat <<EOF
Projeto: $PROJECT_NAME | Data: $TODAY | Sessao provavel: $NEXT_SESSION

OBRIGATORIO: antes de qualquer tarefa, pergunte ao usuario o nome/tema desta sessao (ex: "Qual o foco desta sessao?"). Use a resposta para:
1. Escrever o nome no arquivo .claude/.session-name (echo -n "nome" > .claude/.session-name) para atualizar a status line
2. Nomear a sessao no CHANGELOG e HANDOFF

=== HANDOFF.md (contexto da sessao anterior) ===
EOF

cat "$PROJECT_ROOT/HANDOFF.md" 2>/dev/null || echo "(HANDOFF.md nao encontrado)"

# Surface pending fixes from previous session (self-healing loop)
PENDING="$PROJECT_ROOT/.claude/pending-fixes.md"
if [ -f "$PENDING" ] && [ -s "$PENDING" ]; then
  echo ""
  echo "=== PENDING FIXES (from previous session) ==="
  cat "$PENDING"
  echo ""
  echo "→ Address these before starting new work. Clear with: rm .claude/pending-fixes.md"
  # Archive — don't delete (audit trail). Silently fail if rename fails.
  mv "$PENDING" "$PROJECT_ROOT/.claude/pending-fixes-$(date +%Y%m%d-%H%M).md" 2>/dev/null || true
fi

# Surface dream-pending flag for auto-dream contract
DREAM_PENDING="$HOME/.claude/.dream-pending"
if [ -f "$DREAM_PENDING" ]; then
  echo ""
  echo "=== AUTO-DREAM PENDING ==="
  echo "Memory consolidation overdue (>24h). Run /dream as background subagent, then:"
  echo "  rm ~/.claude/.dream-pending"
  echo "  date -u +%Y-%m-%dT%H:%M:%SZ > ~/.claude/.last-dream"
fi

exit 0
