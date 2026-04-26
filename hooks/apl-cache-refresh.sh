#!/usr/bin/env bash
set -euo pipefail
# Claude Code hook: SessionStart (unconditional)
# APL Foundation — session timer + caches + KPI trends + stuck-item detection
# S217: metrics trend + stuck-item detection (MemR3-inspired evidence-gap tracker)
# S218: section-aware HANDOFF parsing (PENDENTES only) + stuck-counts 3-col schema fix
# S219: interpreted KPI trends (moving avg + efficiency ratio + verdict justification)
# Evento: SessionStart | Timeout: 3s | Exit: sempre 0

# Consume stdin (hook protocol)
cat > /dev/null 2>&1

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
[[ "$(basename "$PROJECT_ROOT")" == ".claude" ]] && { echo "ERROR: PROJECT_ROOT resolved to .claude -- hook aborted" >&2; exit 1; }
APL_DIR="$PROJECT_ROOT/.claude/apl"

mkdir -p "$APL_DIR"

# Session start timestamp (epoch seconds)
date +%s > "$APL_DIR/session-ts.txt"

# Cache top 3 unchecked BACKLOG items
BACKLOG="$PROJECT_ROOT/.claude/BACKLOG.md"
if [ -f "$BACKLOG" ]; then
  { grep -m 3 '^\- \[ \]' "$BACKLOG" | sed 's/^- \[ \] //' || true; } > "$APL_DIR/backlog-top.txt"
fi

# --- QA coverage (slides metanalise) ---
SLIDES_DIR="$PROJECT_ROOT/content/aulas/metanalise/slides"
QA_DIR="$PROJECT_ROOT/content/aulas/metanalise/qa-screenshots"

TOTAL_SLIDES=$(ls "$SLIDES_DIR"/*.html 2>/dev/null | wc -l | tr -d ' ' || echo 0)
QA_EDITORIAL=$(find "$QA_DIR" -name "editorial-suggestions.md" 2>/dev/null | wc -l | tr -d ' ' || echo 0)
echo "${QA_EDITORIAL}/${TOTAL_SLIDES}" > "$APL_DIR/qa-coverage.txt"

# Find next slide needing editorial
NEXT_QA=""
for dir in "$QA_DIR"/s-*/; do
  [ -d "$dir" ] || continue
  [ -f "$dir/editorial-suggestions.md" ] && continue
  NEXT_QA=$(basename "$dir")
  break
done
[ -n "$NEXT_QA" ] && echo "$NEXT_QA" > "$APL_DIR/qa-next.txt" || rm -f "$APL_DIR/qa-next.txt"

# --- Deadline countdown ---
DAYS_R3=$(node -e "console.log(Math.floor((new Date('2026-12-01')-new Date())/86400000))" 2>/dev/null)
[ -n "$DAYS_R3" ] && echo "$DAYS_R3" > "$APL_DIR/deadline-days.txt"

# --- HANDOFF parsing (S255 Phase 3 A.2: extracted to hooks/lib/handoff-utils.sh) ---
. "$PROJECT_ROOT/hooks/lib/handoff-utils.sh"

# --- Stuck-item detection (MemR3-inspired) ---
SNAPSHOT_PREV="$APL_DIR/handoff-prev.txt"
STUCK_FILE="$APL_DIR/stuck-counts.tsv"
STUCK_ALERTS=""
STUCK_COUNT=0
STUCK_OVERFLOW=0

if [ -f "$PROJECT_ROOT/HANDOFF.md" ] && [ -f "$SNAPSHOT_PREV" ]; then
  CURRENT_ITEMS=$(parse_handoff_pendentes "$PROJECT_ROOT/HANDOFF.md" | sort)

  CARRIED=$(comm -12 <(echo "$CURRENT_ITEMS") "$SNAPSHOT_PREV" 2>/dev/null || true)

  if [ -n "$CARRIED" ]; then
    [ ! -f "$STUCK_FILE" ] && printf 'item\tcount\tfirst_seen\n' > "$STUCK_FILE"

    while IFS= read -r item; do
      [ -z "$item" ] && continue
      KEY=$(echo "$item" | cut -c1-40)
      EXISTING=$(grep -F "$KEY" "$STUCK_FILE" 2>/dev/null | tail -1 || true)
      if [ -n "$EXISTING" ]; then
        OLD_COUNT=$(echo "$EXISTING" | cut -f2)
        OLD_FIRST=$(echo "$EXISTING" | cut -f3)
        [[ "$OLD_COUNT" =~ ^[0-9]+$ ]] || OLD_COUNT=1
        [ -z "$OLD_FIRST" ] && OLD_FIRST=$(date +%Y-%m-%d)
        NEW_COUNT=$((OLD_COUNT + 1))
        grep -vF "$KEY" "$STUCK_FILE" > "$STUCK_FILE.tmp" 2>/dev/null || true
        mv "$STUCK_FILE.tmp" "$STUCK_FILE"
        printf '%s\t%d\t%s\n' "$KEY" "$NEW_COUNT" "$OLD_FIRST" >> "$STUCK_FILE"
        if [ "$NEW_COUNT" -ge 3 ]; then
          if [ "$STUCK_COUNT" -lt 5 ]; then
            STUCK_ALERTS="${STUCK_ALERTS}\"${KEY}...\" (${NEW_COUNT} sessoes). "
            STUCK_COUNT=$((STUCK_COUNT + 1))
          else
            STUCK_OVERFLOW=$((STUCK_OVERFLOW + 1))
          fi
        fi
      else
        printf '%s\t1\t%s\n' "$KEY" "$(date +%Y-%m-%d)" >> "$STUCK_FILE"
      fi
    done <<< "$CARRIED"
  fi

  RESOLVED=$(comm -23 "$SNAPSHOT_PREV" <(echo "$CURRENT_ITEMS") 2>/dev/null || true)
  if [ -n "$RESOLVED" ]; then
    while IFS= read -r item; do
      [ -z "$item" ] && continue
      KEY=$(echo "$item" | cut -c1-40)
      grep -vF "$KEY" "$STUCK_FILE" > "$STUCK_FILE.tmp" 2>/dev/null || true
      mv "$STUCK_FILE.tmp" "$STUCK_FILE"
    done <<< "$RESOLVED"
  fi
fi

# KBP-23: cap STUCK output + report overflow
[ "$STUCK_OVERFLOW" -gt 0 ] && STUCK_ALERTS="${STUCK_ALERTS}(+${STUCK_OVERFLOW} more in stuck-counts.tsv)"

# --- Interpreted KPI trends (S219: moving avg + efficiency + verdicts) ---
METRICS_FILE="$APL_DIR/metrics.tsv"
KPI_LINE1=""
KPI_LINE2=""

moving_avg() {
  local arr=($1)
  local n=${#arr[@]}
  [ "$n" -lt 2 ] && echo "0" && return
  local sum=0 count=0
  for ((i=0; i<n-1; i++)); do
    sum=$((sum + arr[i]))
    count=$((count + 1))
  done
  echo $((sum / count))
}

interpret() {
  local cur=$1 avg=$2 direction=$3
  [ "$avg" -eq 0 ] && echo "OK — sem baseline" && return
  if [ "$direction" = "lower_better" ]; then
    local high_thresh=$(( avg + avg * 3 / 10 ))
    local low_thresh=$(( avg * 8 / 10 ))
    if [ "$cur" -gt "$high_thresh" ]; then
      echo "ALTO — acima do baseline"
    elif [ "$cur" -lt "$low_thresh" ]; then
      echo "BOM — abaixo do baseline"
    else
      echo "OK"
    fi
  else
    local low_thresh=$(( avg / 2 ))
    if [ "$cur" -lt "$low_thresh" ] && [ "$avg" -gt 0 ]; then
      echo "BAIXO — abaixo do baseline"
    elif [ "$cur" -gt "$avg" ]; then
      echo "BOM — acima do baseline"
    else
      echo "OK"
    fi
  fi
}

if [ -f "$METRICS_FILE" ]; then
  TC_VALS="" CM_VALS="" HP_VALS="" CL_VALS="" RW_VALS=""
  while IFS=$'\t' read -r sess dt rw bo br hp cl cm tc dur dq cpct; do
    [ "$dq" = "full" ] || continue
    [ "$tc" != "-" ] && [[ "$tc" =~ ^[0-9]+$ ]] && TC_VALS="${TC_VALS:+$TC_VALS }$tc"
    [[ "$cm" =~ ^[0-9]+$ ]] && CM_VALS="${CM_VALS:+$CM_VALS }$cm"
    [ "$hp" != "-" ] && [[ "$hp" =~ ^[0-9]+$ ]] && HP_VALS="${HP_VALS:+$HP_VALS }$hp"
    [ "$cl" != "-" ] && [[ "$cl" =~ ^[0-9]+$ ]] && CL_VALS="${CL_VALS:+$CL_VALS }$cl"
    [ "$rw" != "-" ] && [[ "$rw" =~ ^[0-9]+$ ]] && RW_VALS="${RW_VALS:+$RW_VALS }$rw"
  done < <(tail -n +2 "$METRICS_FILE")

  FULL_COUNT=0
  [ -n "$TC_VALS" ] && FULL_COUNT=$(echo "$TC_VALS" | wc -w | tr -d ' ')

  if [ "$FULL_COUNT" -ge 2 ]; then
    # Line 1: calls + pendentes (DORA leading indicators)
    TC_ARR=($TC_VALS)
    TC_LAST=${TC_ARR[${#TC_ARR[@]}-1]}
    TC_AVG=$(moving_avg "$TC_VALS")
    TC_VERDICT=$(interpret "$TC_LAST" "$TC_AVG" lower_better)
    KPI_LINE1="calls:${TC_LAST} (avg:${TC_AVG}) ${TC_VERDICT}"

    if [ -n "$HP_VALS" ]; then
      HP_ARR=($HP_VALS)
      HP_LAST=${HP_ARR[${#HP_ARR[@]}-1]}
      HP_AVG=$(moving_avg "$HP_VALS")
      HP_VERDICT=$(interpret "$HP_LAST" "$HP_AVG" lower_better)
      KPI_LINE1="${KPI_LINE1} | pendentes:${HP_LAST} (avg:${HP_AVG}) ${HP_VERDICT}"
    fi

    # Line 2: efficiency + commits + rework
    EFF_PART=""
    if [ -n "$CL_VALS" ]; then
      CL_ARR=($CL_VALS)
      CL_LAST=${CL_ARR[${#CL_ARR[@]}-1]}
      if [ "$CL_LAST" -gt 0 ] 2>/dev/null; then
        EFF_LAST=$((TC_LAST / CL_LAST))
        EFF_SUM=0 EFF_N=0
        MIN_LEN=${#TC_ARR[@]}
        [ ${#CL_ARR[@]} -lt "$MIN_LEN" ] && MIN_LEN=${#CL_ARR[@]}
        for ((i=0; i<MIN_LEN-1; i++)); do
          if [ "${CL_ARR[$i]}" -gt 0 ] 2>/dev/null; then
            EFF_SUM=$((EFF_SUM + TC_ARR[$i] / CL_ARR[$i]))
            EFF_N=$((EFF_N + 1))
          fi
        done
        EFF_AVG=0
        [ "$EFF_N" -gt 0 ] && EFF_AVG=$((EFF_SUM / EFF_N))
        EFF_VERDICT=$(interpret "$EFF_LAST" "$EFF_AVG" lower_better)
        EFF_PART="efficiency:${EFF_LAST} calls/cl (avg:${EFF_AVG}) ${EFF_VERDICT}"
      fi
    fi

    CM_PART=""
    if [ -n "$CM_VALS" ]; then
      CM_ARR=($CM_VALS)
      CM_LAST=${CM_ARR[${#CM_ARR[@]}-1]}
      CM_AVG=$(moving_avg "$CM_VALS")
      CM_VERDICT=$(interpret "$CM_LAST" "$CM_AVG" higher_better)
      CM_PART="commits:${CM_LAST} (avg:${CM_AVG}) ${CM_VERDICT}"
    fi

    RW_PART=""
    if [ -n "$RW_VALS" ]; then
      RW_ARR=($RW_VALS)
      RW_LAST=${RW_ARR[${#RW_ARR[@]}-1]}
      RW_AVG=$(moving_avg "$RW_VALS")
      RW_VERDICT=$(interpret "$RW_LAST" "$RW_AVG" lower_better)
      RW_PART="rework:${RW_LAST} (avg:${RW_AVG}) ${RW_VERDICT}"
    fi

    KPI_LINE2="${EFF_PART}"
    [ -n "$CM_PART" ] && KPI_LINE2="${KPI_LINE2:+$KPI_LINE2 | }${CM_PART}"
    [ -n "$RW_PART" ] && KPI_LINE2="${KPI_LINE2:+$KPI_LINE2 | }${RW_PART}"
  fi
fi

# --- SessionStart summary ---
QA_LINE=""
[ -f "$APL_DIR/qa-coverage.txt" ] && QA_LINE="QA: $(cat "$APL_DIR/qa-coverage.txt") editorial"
NEXT_LINE=""
[ -f "$APL_DIR/qa-next.txt" ] && NEXT_LINE="Proximo: $(cat "$APL_DIR/qa-next.txt")"
DEADLINE_LINE=""
[ -f "$APL_DIR/deadline-days.txt" ] && DEADLINE_LINE="R3: $(cat "$APL_DIR/deadline-days.txt")d"

echo "[APL] Cache refreshed. Session timer started."
echo "[APL] ${QA_LINE} | ${NEXT_LINE} | ${DEADLINE_LINE}"
[ -n "$KPI_LINE1" ] && echo "[KPI] ${KPI_LINE1}"
[ -n "$KPI_LINE2" ] && echo "[KPI] ${KPI_LINE2}"
[ -n "$STUCK_ALERTS" ] && echo "[KPI] STUCK: ${STUCK_ALERTS}"

exit 0
