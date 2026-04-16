#!/usr/bin/env bash
set -euo pipefail
# Claude Code hook: SessionStart (unconditional)
# APL Foundation — session timer + caches + KPI trends + stuck-item detection
# S217: metrics trend + stuck-item detection (MemR3-inspired evidence-gap tracker)
# S218: section-aware HANDOFF parsing (PENDENTES only) + stuck-counts 3-col schema fix
# Evento: SessionStart | Timeout: 3s | Exit: sempre 0

# Consume stdin (hook protocol)
cat > /dev/null 2>&1

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APL_DIR="$PROJECT_ROOT/.claude/apl"

mkdir -p "$APL_DIR"

# Session start timestamp (epoch seconds)
date +%s > "$APL_DIR/session-ts.txt"

# Cache top 3 unchecked BACKLOG items
BACKLOG="$PROJECT_ROOT/BACKLOG.md"
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

# --- Section-aware HANDOFF parsing (S218: only PENDENTES section) ---
parse_handoff_pendentes() {
  local file="$1" in_section=0
  while IFS= read -r line; do
    [[ "$line" =~ ^##\ PENDENTES ]] && in_section=1 && continue
    [[ "$line" =~ ^##\  ]] && [ "$in_section" -eq 1 ] && break
    [ "$in_section" -eq 1 ] && [[ "$line" =~ ^-\  ]] && echo "${line#- }"
  done < "$file"
}

# --- Stuck-item detection (MemR3-inspired) ---
# Compare current HANDOFF PENDENTES against previous session's snapshot
# Items that persist across sessions get their count incremented
SNAPSHOT_PREV="$APL_DIR/handoff-prev.txt"
STUCK_FILE="$APL_DIR/stuck-counts.tsv"
STUCK_ALERTS=""

if [ -f "$PROJECT_ROOT/HANDOFF.md" ] && [ -f "$SNAPSHOT_PREV" ]; then
  # Current HANDOFF pendentes only (normalized: sort)
  CURRENT_ITEMS=$(parse_handoff_pendentes "$PROJECT_ROOT/HANDOFF.md" | sort)

  # Items present in both current and previous = carried over
  CARRIED=$(comm -12 <(echo "$CURRENT_ITEMS") "$SNAPSHOT_PREV" 2>/dev/null || true)

  if [ -n "$CARRIED" ]; then
    # Initialize stuck file if needed (3-col schema: item, count, first_seen)
    [ ! -f "$STUCK_FILE" ] && printf 'item\tcount\tfirst_seen\n' > "$STUCK_FILE"

    while IFS= read -r item; do
      [ -z "$item" ] && continue
      # Extract first 40 chars as key (handles minor rewording)
      KEY=$(echo "$item" | cut -c1-40)
      # Check if already tracked
      EXISTING=$(grep -F "$KEY" "$STUCK_FILE" 2>/dev/null | tail -1 || true)
      if [ -n "$EXISTING" ]; then
        OLD_COUNT=$(echo "$EXISTING" | cut -f2)
        OLD_FIRST=$(echo "$EXISTING" | cut -f3)
        [[ "$OLD_COUNT" =~ ^[0-9]+$ ]] || OLD_COUNT=1
        [ -z "$OLD_FIRST" ] && OLD_FIRST=$(date +%Y-%m-%d)
        NEW_COUNT=$((OLD_COUNT + 1))
        # Update in place (remove old, append new preserving first_seen)
        grep -vF "$KEY" "$STUCK_FILE" > "$STUCK_FILE.tmp" 2>/dev/null || true
        mv "$STUCK_FILE.tmp" "$STUCK_FILE"
        printf '%s\t%d\t%s\n' "$KEY" "$NEW_COUNT" "$OLD_FIRST" >> "$STUCK_FILE"
        # Alert if stuck >= 3 sessions
        if [ "$NEW_COUNT" -ge 3 ]; then
          STUCK_ALERTS="${STUCK_ALERTS}\"${KEY}...\" (${NEW_COUNT} sessoes). "
        fi
      else
        printf '%s\t1\t%s\n' "$KEY" "$(date +%Y-%m-%d)" >> "$STUCK_FILE"
      fi
    done <<< "$CARRIED"
  fi

  # Items in previous but NOT in current = resolved, remove from stuck tracking
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

# --- Metrics trend (last 5 sessions from metrics.tsv) ---
METRICS_FILE="$APL_DIR/metrics.tsv"
TREND_LINE=""
if [ -f "$METRICS_FILE" ]; then
  ROWS=$(tail -n +2 "$METRICS_FILE" | tail -5)
  ROW_COUNT=$(echo "$ROWS" | wc -l | tr -d ' ')

  if [ "$ROW_COUNT" -ge 3 ]; then
    # Extract columns — skip "-" entries
    TC_VALS="" CM_VALS="" HP_VALS=""
    while IFS=$'\t' read -r sess dt rw bo br hp cl cm tc dur; do
      [ "$tc" = "-" ] || TC_VALS="${TC_VALS:+$TC_VALS }$tc"
      CM_VALS="${CM_VALS:+$CM_VALS }$cm"
      [ "$hp" = "-" ] || HP_VALS="${HP_VALS:+$HP_VALS }$hp"
    done <<< "$ROWS"

    trend_arrow() {
      local arr=($1)
      local n=${#arr[@]}
      [ "$n" -lt 2 ] && echo "~" && return
      local last=${arr[$((n-1))]}
      local prev=${arr[$((n-2))]}
      if [ "$last" -gt "$prev" ] 2>/dev/null; then echo "${prev}>${last}"
      elif [ "$last" -lt "$prev" ] 2>/dev/null; then echo "${prev}<${last}"
      else echo "${last}="; fi
    }

    [ -n "$TC_VALS" ] && TREND_LINE="calls:$(trend_arrow "$TC_VALS") "
    TREND_LINE="${TREND_LINE}commits:$(trend_arrow "$CM_VALS")"
    [ -n "$HP_VALS" ] && TREND_LINE="$TREND_LINE pendentes:$(trend_arrow "$HP_VALS")"
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
[ -n "$TREND_LINE" ] && echo "[KPI] ${TREND_LINE}"
[ -n "$STUCK_ALERTS" ] && echo "[KPI] STUCK: ${STUCK_ALERTS}"

exit 0
