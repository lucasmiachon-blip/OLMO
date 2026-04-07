#!/usr/bin/env bash
# Claude Code hook: Stop (before stop-notify.sh)
# APL Session Scorecard — 2-line session summary at end.
# Evento: Stop | Timeout: 5s | Exit: sempre 0

# Consume stdin (hook protocol)
cat > /dev/null 2>&1

PROJECT_ROOT="/c/Dev/Projetos/OLMO"
APL_DIR="$PROJECT_ROOT/.claude/apl"

# --- Focus ---
SESSION_NAME="(sem nome)"
if [ -f "$PROJECT_ROOT/.claude/.session-name" ]; then
  NAME=$(cat "$PROJECT_ROOT/.claude/.session-name" 2>/dev/null)
  [ -n "$NAME" ] && SESSION_NAME="$NAME"
fi

# --- Duration ---
DURATION="(?)"
if [ -f "$APL_DIR/session-ts.txt" ]; then
  START_TS=$(cat "$APL_DIR/session-ts.txt" 2>/dev/null || echo 0)
  NOW_TS=$(date +%s)
  ELAPSED_MIN=$(( (NOW_TS - START_TS) / 60 ))
  HOURS=$((ELAPSED_MIN / 60))
  MINS=$((ELAPSED_MIN % 60))
  if [ "$HOURS" -gt 0 ]; then
    DURATION="${HOURS}h${MINS}m"
  else
    DURATION="${MINS}m"
  fi
fi

# --- Commits since session start ---
COMMITS=0
if [ -f "$APL_DIR/session-ts.txt" ]; then
  START_TS=$(cat "$APL_DIR/session-ts.txt" 2>/dev/null || echo 0)
  COMMITS=$(git -C "$PROJECT_ROOT" log --oneline --since="@$START_TS" 2>/dev/null | wc -l | tr -d ' ')
fi

# --- Tool calls today ---
CALLS=0
TODAY=$(date +%Y%m%d)
for f in /tmp/cc-calls-${TODAY}_*.txt; do
  [ -f "$f" ] || continue
  n=$(cat "$f" 2>/dev/null || echo 0)
  CALLS=$((CALLS + n))
done

# --- Cost verdict ---
if [ "$CALLS" -lt 100 ]; then
  COST="OK"
elif [ "$CALLS" -lt 300 ]; then
  COST="MODERATE"
else
  COST="HIGH"
fi

# --- Hygiene check ---
HYGIENE="OK"
UNCOMMITTED=$(git -C "$PROJECT_ROOT" diff --name-only 2>/dev/null)
STAGED=$(git -C "$PROJECT_ROOT" diff --cached --name-only 2>/dev/null)
if [ -n "$UNCOMMITTED" ] || [ -n "$STAGED" ]; then
  HANDOFF_TOUCHED=$(echo "$UNCOMMITTED$STAGED" | grep -c 'HANDOFF.md' || true)
  CHANGELOG_TOUCHED=$(echo "$UNCOMMITTED$STAGED" | grep -c 'CHANGELOG.md' || true)
  if [ "$HANDOFF_TOUCHED" -eq 0 ] || [ "$CHANGELOG_TOUCHED" -eq 0 ]; then
    HYGIENE="PENDENTE"
  fi
fi

# --- Output (exactly 2 lines) ---
echo "[SCORECARD] Foco: \"$SESSION_NAME\" | Duracao: $DURATION"
echo "[SCORECARD] Commits: $COMMITS | Tool calls: $CALLS | Custo: $COST | Hygiene: $HYGIENE"

exit 0
