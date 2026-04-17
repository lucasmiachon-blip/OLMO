#!/usr/bin/env bash
set -euo pipefail
# Claude Code hook: SessionStart
# Hidrata sessao nova: projeto, data, sessao, HANDOFF completo.
# Evento: SessionStart | Timeout: 5s | Exit: sempre 0
# S225 Issue #10: reset inter-session /tmp counters (nudge-checkpoint state)
# S225 Issue #4: namespace /tmp/cc-session-id file per repo (was shared across repos)

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
[[ "$(basename "$PROJECT_ROOT")" == ".claude" ]] && { echo "ERROR: PROJECT_ROOT resolved to .claude -- hook aborted" >&2; exit 1; }
PROJECT_NAME=$(basename "$PROJECT_ROOT")
TODAY=$(date +%Y-%m-%d)
SESSION_FILE="$PROJECT_ROOT/.claude/.session-name"

# S225 Issue #4: compute repo-scoped session-id path (prevents cross-repo collision)
REPO_SLUG=$(printf '%s' "$PROJECT_ROOT" | sha256sum 2>/dev/null | cut -c1-8)
[ -z "$REPO_SLUG" ] && REPO_SLUG="default"
SESSION_ID_FILE="/tmp/cc-session-id-${REPO_SLUG}.txt"

# Limpar nome da sessao anterior
rm -f "$SESSION_FILE"

# Proximo numero de sessao — take max (not first match) to avoid regression (Codex S60 O10)
LAST_SESSION=$(grep -o 'Sessao [0-9]*' "$PROJECT_ROOT/CHANGELOG.md" 2>/dev/null | grep -o '[0-9]*' | sort -n | tail -1 || echo 0)
NEXT_SESSION=$((LAST_SESSION + 1))

# Generate session-scoped ID for cost brake (B7-06 S102) — AFTER computing NEXT_SESSION
echo "${NEXT_SESSION}_$(date +%Y%m%d_%H%M%S)" > "$SESSION_ID_FILE"

# S225 Issue #10: reset inter-session counters (nudge-checkpoint state leaks without reset)
rm -f /tmp/olmo-subagent-count /tmp/olmo-checkpoint-nudged

# S225 Issue #4 migration cleanup: remove legacy shared session-id file (pre-S225) if exists
rm -f /tmp/cc-session-id.txt

cat <<EOF
Projeto: $PROJECT_NAME | Data: $TODAY | Sessao provavel: $NEXT_SESSION

OBRIGATORIO: antes de qualquer tarefa, pergunte ao usuario o nome/tema desta sessao (ex: "Qual o foco desta sessao?"). Use a resposta para:
1. Escrever o nome no arquivo .claude/.session-name (echo -n "nome" > .claude/.session-name) para atualizar a status line
2. Nomear a sessao no CHANGELOG e HANDOFF

=== HANDOFF.md (contexto da sessao anterior) ===
EOF

# KBP-23: cap HANDOFF output to 50 li (anti-drift target); pointer if truncated
HANDOFF_LINES=$(wc -l < "$PROJECT_ROOT/HANDOFF.md" 2>/dev/null || echo 0)
if [ "$HANDOFF_LINES" -gt 50 ]; then
  head -n 50 "$PROJECT_ROOT/HANDOFF.md"
  echo ""
  echo "(HANDOFF.md truncado em 50/${HANDOFF_LINES} li — Read integral se DECISOES/CUIDADOS precisos)"
else
  cat "$PROJECT_ROOT/HANDOFF.md" 2>/dev/null || echo "(HANDOFF.md nao encontrado)"
fi

# Surface pending fixes from previous session (self-healing loop)
PENDING="$PROJECT_ROOT/.claude/pending-fixes.md"
if [ -f "$PENDING" ] && [ -s "$PENDING" ]; then
  echo ""
  echo "=== PENDING FIXES (from previous session) ==="
  cat "$PENDING"
  echo ""
  echo "→ Address these before starting new work."
  # Truncate after surfacing — no rename, no orphans (S193 fix)
  > "$PENDING"
fi

# Surface dream-pending flag (informational only — user decides when to run)
DREAM_PENDING="$HOME/.claude/.dream-pending"
if [ -f "$DREAM_PENDING" ]; then
  echo ""
  echo "(Dream disponivel — rode /dream quando quiser)"
fi

exit 0
