#!/usr/bin/env bash
# validate-css.sh — Detect CSS cascade conflicts
# Usage: bash scripts/validate-css.sh [aula] (default: cirrose)
#
# Checks:
# 1. Duplicate bare selectors across CSS files (same specificity, different files)
# 2. !important usage outside .no-js / .stage-bad / @media print
# 3. Import order in index.template.html matches expected cascade

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AULA_ROOT="$(dirname "$SCRIPT_DIR")"
AULA="${1:-cirrose}"
DIR="$AULA_ROOT/$AULA"
FAIL=0
WARN=0

echo "=== CSS Cascade Validator — $AULA ==="
echo ""

# --- Check 1: Import order in template ---
echo "--- [1] Import order in index.template.html ---"
TEMPLATE="$DIR/index.template.html"
if [ -f "$TEMPLATE" ]; then
  # Extract CSS import lines (preserve order)
  # Strip CRLF + exclude HTML comments
  IMPORTS=$(grep "import '.*\.css'" "$TEMPLATE" | grep -v '<!--' | tr -d '\r' | sed "s/.*import '\(.*\)'.*/\1/")

  # Valid patterns: single-file OR base.css then aula.css
  SINGLE="./${AULA}.css"
  BASE_THEN_AULA=$(printf '../shared/css/base.css\n./%s.css' "$AULA")

  if [ "$IMPORTS" = "$SINGLE" ]; then
    echo "  PASS: single-file (${AULA}.css)"
  elif [ "$IMPORTS" = "$BASE_THEN_AULA" ]; then
    echo "  PASS: base.css → ${AULA}.css (correct cascade order)"
  else
    echo "  FAIL: Unexpected import order!"
    echo "  Expected: ${AULA}.css only, or base.css → ${AULA}.css"
    echo "  Got:"
    echo "$IMPORTS" | sed 's/^/    /'
    FAIL=$((FAIL + 1))
  fi
else
  echo "  SKIP: $TEMPLATE not found"
fi
echo ""

# --- Check 2: Shared bare selectors across CSS files ---
echo "--- [2] Shared bare selectors (potential cascade conflicts) ---"

CSS_FILES=()
# Discover CSS files for this aula (shared base + aula-specific)
SHARED_CSS="$(dirname "$DIR")/shared/css/base.css"
[ -f "$SHARED_CSS" ] && CSS_FILES+=("$SHARED_CSS")
[ -f "$DIR/$AULA.css" ] && CSS_FILES+=("$DIR/$AULA.css")

if [ ${#CSS_FILES[@]} -ge 2 ]; then
  # Extract bare class selectors from each CSS file
  # Capture output to count WARNs back in bash
  SELECTOR_OUTPUT=$(
    for file in "${CSS_FILES[@]}"; do
      grep -oE '^[[:space:]]*\.[a-zA-Z][a-zA-Z0-9_-]*' "$file" | sed 's/^[[:space:]]*//' | sort -u | while read -r sel; do
        printf "%s\t%s\n" "$(basename "$file")" "$sel"
      done
    done | awk -F'\t' '{
      file = $1; sel = $2
      if (sel != "") {
        if (seen[sel] && seen[sel] != file) {
          printf "  WARN: \"%s\" defined in %s AND %s\n", sel, seen[sel], file
          warn++
        }
        seen[sel] = file
      }
    }
    END { if (warn == 0) print "  PASS: No bare selector conflicts found" }'
  )
  echo "$SELECTOR_OUTPUT"
  if echo "$SELECTOR_OUTPUT" | grep -q "WARN:"; then
    SELECTOR_WARNS=$(echo "$SELECTOR_OUTPUT" | grep -c "WARN:")
    WARN=$((WARN + SELECTOR_WARNS))
  fi
else
  echo "  SKIP: Less than 2 CSS files found"
fi
echo ""

# --- Check 3: !important outside allowed contexts ---
echo "--- [3] !important audit ---"
IMPORTANT_ISSUES=0

for file in "${CSS_FILES[@]}"; do
  # Find !important lines, exclude .no-js / .stage-bad / @media print blocks
  # Process substitution avoids subshell so WARN increments persist
  while IFS= read -r line; do
    linenum=$(echo "$line" | cut -d: -f1)
    # Check surrounding context (20 lines before for @media blocks)
    context=$(sed -n "$((linenum > 50 ? linenum - 50 : 1)),${linenum}p" "$file")
    if echo "$context" | grep -qE '\.no-js|\.stage-bad|@media\s+print|@media.*prefers-reduced-motion|\.high-contrast|\.qa-mode|\?qa=1'; then
      : # allowed context
    else
      echo "  FAIL: $(basename "$file"):$linenum — !important outside allowed context"
      echo "    $line"
      FAIL=$((FAIL + 1))
    fi
  done < <(grep -n '!important' "$file" 2>/dev/null | grep -v '[0-9]*:[[:space:]]*/\*\|[0-9]*:[[:space:]]*\*\|[0-9]*:[[:space:]]*//')
done
echo ""

# --- Check 4: Inline style with opacity/display/visibility in slide HTML ---
echo "--- [4] Inline style audit (slides) ---"
SLIDES_DIR="$DIR/slides"
if [ -d "$SLIDES_DIR" ]; then
  INLINE_COUNT=$(grep -rl 'style="[^"]*\(opacity\|display\|visibility\)' "$SLIDES_DIR"/*.html 2>/dev/null | wc -l) || INLINE_COUNT=0
  echo "  INFO: $INLINE_COUNT slide files have inline opacity/display/visibility"
  if [ "$INLINE_COUNT" -gt 0 ]; then
    grep -l 'style="[^"]*\(opacity\|display\|visibility\)' "$SLIDES_DIR"/*.html 2>/dev/null | while read -r f; do
      count=$(grep -c 'style="[^"]*\(opacity\|display\|visibility\)' "$f" 2>/dev/null) || count=0
      echo "    $(basename "$f"): $count inline style(s) — expected for GSAP"
    done
  fi
else
  echo "  SKIP: $SLIDES_DIR not found"
fi
echo ""

# --- Summary ---
echo "=== Summary ==="
echo "  FAIL: $FAIL"
echo "  WARN: $WARN"
if [ "$FAIL" -gt 0 ]; then
  echo "  STATUS: FAIL"
  exit 1
else
  echo "  STATUS: PASS (warnings may need review)"
  exit 0
fi
