#!/usr/bin/env bash
# Claude Code hook: SessionStart (unconditional)
# APL Foundation — initializes session timer + caches BACKLOG top items.
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
  grep -m 3 '^\- \[ \]' "$BACKLOG" | sed 's/^- \[ \] //' > "$APL_DIR/backlog-top.txt"
fi

# --- QA coverage (slides metanalise) ---
SLIDES_DIR="$PROJECT_ROOT/content/aulas/metanalise/slides"
QA_DIR="$PROJECT_ROOT/content/aulas/metanalise/qa-screenshots"

TOTAL_SLIDES=$(ls "$SLIDES_DIR"/*.html 2>/dev/null | wc -l | tr -d ' ')
QA_EDITORIAL=$(find "$QA_DIR" -name "editorial-suggestions.md" 2>/dev/null | wc -l | tr -d ' ')
echo "${QA_EDITORIAL}/${TOTAL_SLIDES}" > "$APL_DIR/qa-coverage.txt"

# Find next slide needing editorial (has QA dir but no editorial-suggestions.md)
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

# --- SessionStart summary ---
QA_LINE=""
[ -f "$APL_DIR/qa-coverage.txt" ] && QA_LINE="QA: $(cat "$APL_DIR/qa-coverage.txt") editorial"
NEXT_LINE=""
[ -f "$APL_DIR/qa-next.txt" ] && NEXT_LINE="Proximo: $(cat "$APL_DIR/qa-next.txt")"
DEADLINE_LINE=""
[ -f "$APL_DIR/deadline-days.txt" ] && DEADLINE_LINE="R3: $(cat "$APL_DIR/deadline-days.txt")d"

echo "[APL] Cache refreshed. Session timer started."
echo "[APL] ${QA_LINE} | ${NEXT_LINE} | ${DEADLINE_LINE}"

exit 0
