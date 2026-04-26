#!/usr/bin/env bash
set -euo pipefail
# Claude Code hook: SessionStart
# Hidrata sessao nova: projeto, data, sessao, HANDOFF completo.

# S255 fix: drain stdin (hook protocol — prevent harness stall causing
# "SessionStart:startup hook error / Failed with non-blocking, no stderr")
cat >/dev/null 2>&1 || true
# Evento: SessionStart | Timeout: 5s | Exit: sempre 0
# S225 Issue #10: reset inter-session /tmp counters (nudge-checkpoint state)
# S225 Issue #4: namespace /tmp/cc-session-id file per repo (was shared across repos)
# S230 G.8+G.5: anti-meta-loop banner + /insights bi-diario reminder

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

# S236 P008: auto-rotate hook-log.jsonl (aligned com /dream Phase 2 threshold 500)
HOOKLOG="$PROJECT_ROOT/.claude/hook-log.jsonl"
if [ -f "$HOOKLOG" ]; then
  LOG_LINES=$(wc -l < "$HOOKLOG" 2>/dev/null | tr -d ' ' || echo 0)
  if [ "$LOG_LINES" -gt 500 ]; then
    mkdir -p "$PROJECT_ROOT/.claude/hook-log-archive"
    EXCESS=$((LOG_LINES - 500))
    head -n "$EXCESS" "$HOOKLOG" > "$PROJECT_ROOT/.claude/hook-log-archive/hook-log-$(date -I).jsonl"
    tail -n 500 "$HOOKLOG" > "$HOOKLOG.tmp" && cat "$HOOKLOG.tmp" > "$HOOKLOG" && rm -f "$HOOKLOG.tmp"
    echo "[HOOK-ROTATE] Archived ${EXCESS} oldest lines to hook-log-archive/" >&2
  fi
fi

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

# S255 Phase 3 A.5: Surface integrity violations from previous Stop[5] integrity check.
# tools/integrity.sh runs async + redirects stdout to /dev/null em settings.json:441 — invisível
# sem este surface. Voice 1+2+3+Codex (4/5) convergence em S255 Phase 2 confirmou silent firing.
INTEGRITY_REPORT="$PROJECT_ROOT/.claude/integrity-report.md"
if [ -f "$INTEGRITY_REPORT" ] && grep -q '\[FAIL\]' "$INTEGRITY_REPORT" 2>/dev/null; then
  echo ""
  echo "=== INTEGRITY VIOLATIONS (from previous session integrity check) ==="
  grep '\[FAIL\]' "$INTEGRITY_REPORT" | head -10
  echo ""
  echo "→ Inspect full report: .claude/integrity-report.md"
fi

# DISABLED S254 — recurring false positives 4-5x, debug sistematico pending (BACKLOG #63)
# Re-enable: change `if false` to `if true` after fix verified.
if false; then
  # Surface dream-pending flag (informational only — user decides when to run)
  DREAM_PENDING="$HOME/.claude/.dream-pending"
  if [ -f "$DREAM_PENDING" ]; then
    echo ""
    echo "(Dream disponivel — rode /dream quando quiser)"
  fi
fi

# S230 Phase G.8 + G.5: anti-meta-loop banner + /insights bi-diario reminder
# S255 Phase 3 A.4: capture banner.sh source stderr (was silently absorbed by `2>/dev/null` pre-A.4).
# A6 Phase 1 fix idempotent guard resolveu readonly recursion; este captura outros source failures.
. "$PROJECT_ROOT/hooks/lib/hook-log.sh" 2>/dev/null || true  # graceful — for hook_log function
_BANNER_STDERR_FILE=$(mktemp 2>/dev/null || echo "/tmp/banner-stderr-$$")
_BANNER_EC=0
. "$PROJECT_ROOT/hooks/lib/banner.sh" 2>"$_BANNER_STDERR_FILE" || _BANNER_EC=$?
_BANNER_STDERR=$(cat "$_BANNER_STDERR_FILE" 2>/dev/null || echo "")
rm -f "$_BANNER_STDERR_FILE"

# Log if source emitted stderr OR non-zero exit (envelope blindspot — Voice 1+2+3 convergence S255 Phase 2)
if [ -n "$_BANNER_STDERR" ] || [ "$_BANNER_EC" -ne 0 ]; then
  if command -v hook_log >/dev/null 2>&1; then
    hook_log "SessionStart" "session-start" "lib-source" "banner.sh" "warn" "rc=$_BANNER_EC stderr=${_BANNER_STDERR:-empty}"
  fi
fi

# Banner functions only available if source succeeded — gate G.8 + G.5
if [ "$_BANNER_EC" -eq 0 ]; then
  # G.8: anti-meta-loop (commits content/aulas/ vs total last 5)
  AULAS_COMMITS_LAST_5=$(git -C "$PROJECT_ROOT" log -5 --pretty=format:"%H" -- content/aulas/ 2>/dev/null | wc -l | tr -d ' ' || echo "0")
  TOTAL_LAST_5=$(git -C "$PROJECT_ROOT" log -5 --pretty=format:"%H" 2>/dev/null | wc -l | tr -d ' ' || echo "0")
  META_STREAK=$((TOTAL_LAST_5 - AULAS_COMMITS_LAST_5))

  R3_DAYS="?"
  if [ -f "$PROJECT_ROOT/.claude/apl/deadline-days.txt" ]; then
    R3_DAYS=$(cat "$PROJECT_ROOT/.claude/apl/deadline-days.txt" 2>/dev/null || echo "?")
  fi

  if [ "$META_STREAK" -ge 5 ] || { [ "$R3_DAYS" != "?" ] && [ "$R3_DAYS" -lt 100 ] 2>/dev/null; }; then
    banner_critical "$META_STREAK SESSOES SEM PRODUTO" "R3 Clinica Medica: ${R3_DAYS} dias" "ACAO: voltar para content/aulas/"
  elif [ "$META_STREAK" -ge 3 ]; then
    banner_attn "$META_STREAK sessoes sem aulas/" "R3 Clinica Medica: ${R3_DAYS} dias" "Considere voltar a slides hoje"
  fi

  # G.5: /insights bi-diario reminder — DISABLED S254 (BACKLOG #63, recurring false positives, debug sistematico pending)
  # Re-enable: change `if false` to `if true` after `.last-insights` write-on-close fix verified.
  if false; then
    LAST_INS_FILE="$PROJECT_ROOT/.claude/.last-insights"
    if [ -f "$LAST_INS_FILE" ]; then
      LAST_INS=$(cat "$LAST_INS_FILE" 2>/dev/null || echo 0)
      NOW=$(date +%s)
      GAP_DAYS=$(( (NOW - LAST_INS) / 86400 ))
      if [ "$GAP_DAYS" -ge 2 ]; then
        banner_info "/insights pendente" "Ultimo run: ${GAP_DAYS}d atras" "Periodicidade alvo: bi-diaria"
      fi
    fi
  fi
fi

exit 0
