#!/usr/bin/env bash
set -euo pipefail
# post-global-handler.sh — PostToolUse(.*): cost tracking + momentum brake + KPI loop
# Merged: cost-circuit-breaker.sh + momentum-brake-arm.sh (S194 Fase 2)
# S217: added periodic KPI reflection loop (every 200 calls)
# S219: efficiency baseline + ctx % + data_quality filter in KPI reflection
# Fires on EVERY tool call. Pure bash, no JSON parsing needed.
# Exit 0 always — this hook never blocks.

cat >/dev/null 2>&1 || true  # consume stdin (hook protocol)

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"

# ═══ 1. Cost circuit breaker (Antifragile L3) ═══
WARN_THRESHOLD="${CC_COST_WARN_CALLS:-100}"
BLOCK_THRESHOLD="${CC_COST_BLOCK_CALLS:-400}"

SESSION_ID=$(cat /tmp/cc-session-id.txt 2>/dev/null || date '+%Y%m%d_%H%M%S')
COUNTER_FILE="/tmp/cc-calls-${SESSION_ID}.txt"
COST_BRAKE_DIR="/tmp/olmo-cost-brake"

COUNT=$(cat "$COUNTER_FILE" 2>/dev/null || echo 0)
COUNT=$((COUNT + 1))
echo "$COUNT" > "$COUNTER_FILE"

if [ "$COUNT" -ge "$BLOCK_THRESHOLD" ]; then
  REMAINDER_BLOCK=$(( (COUNT - BLOCK_THRESHOLD) % 100 ))
  if [ "$REMAINDER_BLOCK" -eq 0 ]; then
    mkdir -p "$COST_BRAKE_DIR"
    echo "$COUNT" > "$COST_BRAKE_DIR/armed"
    printf '\n[cost-brake] %d tool calls — brake armado. Proxima acao pedira permissao.\n' "$COUNT"
  fi
elif [ "$COUNT" -ge "$WARN_THRESHOLD" ]; then
  REMAINDER=$(( (COUNT - WARN_THRESHOLD) % 50 ))
  if [ "$REMAINDER" = "0" ]; then
    printf '\n[cost-circuit-breaker] %d tool calls (limite: %d).\n' "$COUNT" "$BLOCK_THRESHOLD"
  fi
fi

# ═══ 2. Momentum brake arm (anti KBP-01) ═══
LOCK_DIR="/tmp/olmo-momentum-brake"
mkdir -p "$LOCK_DIR"
date '+%s' > "$LOCK_DIR/armed"

# ═══ 3. KPI Reflection Loop (DORA-inspired, every 200 calls) ═══
# Leading indicators checked: rework rate, backlog velocity, handoff growth
# Compares current session snapshot against last 5 sessions baseline from metrics.tsv
# Fires at 200, 400, 600, ... calls. Lightweight — reads 2 small files.

KPI_INTERVAL="${CC_KPI_INTERVAL:-200}"
if [ "$COUNT" -ge "$KPI_INTERVAL" ] && [ $(( COUNT % KPI_INTERVAL )) -eq 0 ]; then
  METRICS_FILE="$PROJECT_ROOT/.claude/apl/metrics.tsv"
  KPI_MSG=""

  if [ -f "$METRICS_FILE" ]; then
    # Current session snapshot
    NOW_HANDOFF=0
    [ -f "$PROJECT_ROOT/HANDOFF.md" ] && NOW_HANDOFF=$(grep -c '^- ' "$PROJECT_ROOT/HANDOFF.md" 2>/dev/null || echo 0)

    NOW_BACKLOG_OPEN=0
    [ -f "$PROJECT_ROOT/.claude/BACKLOG.md" ] && NOW_BACKLOG_OPEN=$(grep '^| [0-9]' "$PROJECT_ROOT/.claude/BACKLOG.md" 2>/dev/null | grep -cv 'RESOLVED' || echo 0)

    # Rework: files changed this session that overlap with previous session
    NOW_REWORK=0
    APL_DIR="$PROJECT_ROOT/.claude/apl"
    START_TS=0
    [ -f "$APL_DIR/session-ts.txt" ] && START_TS=$(cat "$APL_DIR/session-ts.txt" 2>/dev/null || echo 0)
    if [ "$START_TS" -gt 0 ]; then
      THIS_FILES=$(git -C "$PROJECT_ROOT" diff --name-only HEAD 2>/dev/null | sort -u)
      if [ -n "$THIS_FILES" ]; then
        PREV_START=$((START_TS - 86400))
        PREV_FILES=$(git -C "$PROJECT_ROOT" log --since="@$PREV_START" --until="@$START_TS" --name-only --format="" 2>/dev/null | sort -u)
        if [ -n "$PREV_FILES" ]; then
          NOW_REWORK=$(comm -12 <(echo "$THIS_FILES" | grep -vE '^(HANDOFF\.md|CHANGELOG\.md)$') <(echo "$PREV_FILES" | grep -vE '^(HANDOFF\.md|CHANGELOG\.md)$') 2>/dev/null | wc -l | tr -d ' ')
        fi
      fi
    fi

    # Baseline: average of last 5 sessions with data_quality=full
    AVG_HANDOFF=0
    AVG_BACKLOG=0
    AVG_REWORK=0
    AVG_EFF=0
    BASELINE_COUNT=0
    EFF_COUNT=0
    while IFS=$'\t' read -r sess dt rw bo br hp cl cm tc dur dq cpct; do
      [ "$dq" = "full" ] || continue
      [[ "$hp" =~ ^[0-9]+$ ]] || continue
      AVG_HANDOFF=$((AVG_HANDOFF + hp))
      [[ "$bo" =~ ^[0-9]+$ ]] && AVG_BACKLOG=$((AVG_BACKLOG + bo))
      [[ "$rw" =~ ^[0-9]+$ ]] && AVG_REWORK=$((AVG_REWORK + rw))
      if [[ "$tc" =~ ^[0-9]+$ ]] && [[ "$cl" =~ ^[0-9]+$ ]] && [ "$cl" -gt 0 ]; then
        AVG_EFF=$((AVG_EFF + tc / cl))
        EFF_COUNT=$((EFF_COUNT + 1))
      fi
      BASELINE_COUNT=$((BASELINE_COUNT + 1))
    done < <(tail -n +2 "$METRICS_FILE" | tail -5)

    # Compare against baseline
    if [ "$BASELINE_COUNT" -gt 0 ]; then
      AVG_HANDOFF=$((AVG_HANDOFF / BASELINE_COUNT))
      AVG_BACKLOG=$((AVG_BACKLOG / BASELINE_COUNT))
      AVG_REWORK=$((AVG_REWORK / BASELINE_COUNT))

      # Alert if current exceeds baseline by >20%
      THRESHOLD_HP=$(( AVG_HANDOFF + AVG_HANDOFF / 5 ))
      THRESHOLD_BO=$(( AVG_BACKLOG + AVG_BACKLOG / 5 ))

      if [ "$NOW_HANDOFF" -gt "$THRESHOLD_HP" ] && [ "$THRESHOLD_HP" -gt 0 ]; then
        KPI_MSG="${KPI_MSG}pendentes ${NOW_HANDOFF} (baseline ${AVG_HANDOFF}) CRESCENDO. "
      fi
      if [ "$NOW_BACKLOG_OPEN" -gt "$THRESHOLD_BO" ] && [ "$THRESHOLD_BO" -gt 0 ]; then
        KPI_MSG="${KPI_MSG}backlog ${NOW_BACKLOG_OPEN} open (baseline ${AVG_BACKLOG}) CRESCENDO. "
      fi
      if [ "$NOW_REWORK" -gt 2 ]; then
        KPI_MSG="${KPI_MSG}rework ${NOW_REWORK} files (alto). "
      fi
    fi

    # Efficiency baseline
    EFF_INFO=""
    if [ "$EFF_COUNT" -gt 0 ]; then
      AVG_EFF=$((AVG_EFF / EFF_COUNT))
      EFF_INFO=" eff-baseline:${AVG_EFF}calls/cl"
    fi

    # Context % from statusline persistence
    CTX_INFO=""
    CTX_FILE="$APL_DIR/ctx-pct.txt"
    if [ -f "$CTX_FILE" ]; then
      CTX_PCT=$(cat "$CTX_FILE" 2>/dev/null || echo 0)
      [[ "$CTX_PCT" =~ ^[0-9]+$ ]] && CTX_INFO=" ctx:${CTX_PCT}%"
      if [ "${CTX_PCT:-0}" -ge 80 ] 2>/dev/null; then
        KPI_MSG="${KPI_MSG}contexto ${CTX_PCT}% (alto — considerar /compact). "
      fi
    fi

    # Always show snapshot at KPI interval, alert only if degrading
    if [ -n "$KPI_MSG" ]; then
      printf '\n[KPI:%d] ALERTA: %s\n' "$COUNT" "$KPI_MSG"
    else
      printf '\n[KPI:%d] OK — rework:%d backlog:%d pendentes:%d%s%s\n' \
        "$COUNT" "$NOW_REWORK" "$NOW_BACKLOG_OPEN" "$NOW_HANDOFF" "$EFF_INFO" "$CTX_INFO"
    fi
  fi
fi

exit 0
