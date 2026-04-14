#!/usr/bin/env bash
# Claude Code hook: UserPromptSubmit (unconditional)
# APL Ambient Pulse — injects 1 rotating line of productivity context per prompt.
# 5 slots rotate every 12 minutes. Silent when no data available.
# Evento: UserPromptSubmit | Timeout: 3s | Exit: sempre 0

# Consume stdin (hook protocol)
cat > /dev/null 2>&1

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APL_DIR="$PROJECT_ROOT/.claude/apl"

# --- Slot rotation: deterministic, changes every 12 minutes ---
HOUR=$(date +%-H)
MINUTE=$(date +%-M)
SLOT=$(( (HOUR * 60 + MINUTE) / 12 % 5 ))

# --- Helper: get total tool calls today ---
get_calls() {
  local total=0
  local today
  today=$(date +%Y%m%d)
  for f in /tmp/cc-calls-*_${today}_*.txt; do
    [ -f "$f" ] || continue
    local n
    n=$(cat "$f" 2>/dev/null || echo 0)
    [[ $n =~ ^[0-9]+$ ]] || n=0
    total=$((total + n))
  done
  echo "$total"
}

# --- Slot 0: QA coverage + deadline (most actionable) ---
if [ "$SLOT" -eq 0 ]; then
  QA_LINE=""
  [ -f "$APL_DIR/qa-coverage.txt" ] && QA_LINE="QA: $(cat "$APL_DIR/qa-coverage.txt") editorial"
  NEXT_LINE=""
  [ -f "$APL_DIR/qa-next.txt" ] && NEXT_LINE="Proximo: $(cat "$APL_DIR/qa-next.txt")"
  DEADLINE_LINE=""
  [ -f "$APL_DIR/deadline-days.txt" ] && DEADLINE_LINE="R3: $(cat "$APL_DIR/deadline-days.txt")d"
  [ -n "$QA_LINE" ] || exit 0
  echo "[APL] ${QA_LINE} | ${NEXT_LINE} | ${DEADLINE_LINE}"
  exit 0
fi

# --- Slot 1: Session focus + duration ---
if [ "$SLOT" -eq 1 ]; then
  SESSION_NAME=""
  if [ -f "$PROJECT_ROOT/.claude/.session-name" ]; then
    SESSION_NAME=$(cat "$PROJECT_ROOT/.claude/.session-name" 2>/dev/null)
  fi
  if [ -z "$SESSION_NAME" ]; then
    echo "[APL] Sessao sem nome -- defina o foco."
    exit 0
  fi
  if [ -f "$APL_DIR/session-ts.txt" ]; then
    START_TS=$(cat "$APL_DIR/session-ts.txt" 2>/dev/null || echo 0)
    NOW_TS=$(date +%s)
    ELAPSED=$(( (NOW_TS - START_TS) / 60 ))
    echo "[APL] Foco: \"$SESSION_NAME\" - ${ELAPSED}min nesta sessao"
  else
    echo "[APL] Foco: \"$SESSION_NAME\""
  fi
  exit 0
fi

# --- Slot 2: Commit age ---
if [ "$SLOT" -eq 2 ]; then
  LAST_COMMIT_TS=$(git -C "$PROJECT_ROOT" log -1 --format=%ct 2>/dev/null)
  [ -z "$LAST_COMMIT_TS" ] && exit 0
  NOW_TS=$(date +%s)
  COMMIT_AGO=$(( (NOW_TS - LAST_COMMIT_TS) / 60 ))
  CALLS=$(get_calls)
  echo "[APL] Ultimo commit: ${COMMIT_AGO}min atras - $CALLS tool calls"
  exit 0
fi

# --- Slot 3: Deadline countdown ---
if [ "$SLOT" -eq 3 ]; then
  [ -f "$APL_DIR/deadline-days.txt" ] || exit 0
  DAYS=$(cat "$APL_DIR/deadline-days.txt" 2>/dev/null)
  [ -n "$DAYS" ] || exit 0
  echo "[APL] R3 Clinica Medica: ${DAYS} dias"
  exit 0
fi

# --- Slot 4: Cost verdict ---
if [ "$SLOT" -eq 4 ]; then
  CALLS=$(get_calls)
  [ "$CALLS" -eq 0 ] && exit 0
  if [ "$CALLS" -lt 100 ]; then
    VERDICT="OK"
  elif [ "$CALLS" -lt 300 ]; then
    VERDICT="MODERATE"
  else
    VERDICT="HIGH"
  fi
  echo "[APL] $CALLS tool calls - custo: $VERDICT"
  exit 0
fi

exit 0
