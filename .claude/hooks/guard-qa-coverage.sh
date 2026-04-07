#!/usr/bin/env bash
set -euo pipefail
# guard-qa-coverage.sh — PreToolUse(Skill): gate new-slide when QA coverage < 50%
# Fires only on Skill tool. Checks if skill is "new-slide" or "slide-authoring".
# If QA editorial coverage is below 50%, asks user to confirm.
# Exit 0 with JSON = ask. Exit 0 without JSON = allow.

INPUT=$(cat 2>/dev/null || echo '{}')

# Parse skill name from Skill tool input
SKILL_NAME=$(echo "$INPUT" | node -e "
  try {
    const d=JSON.parse(require('fs').readFileSync(0,'utf8'));
    console.log((d.tool_input||{}).skill||'');
  } catch(e) { console.log(''); }
" 2>/dev/null)

# Only gate new-slide and slide-authoring skills
case "$SKILL_NAME" in
  new-slide|slide-authoring) ;;
  *) exit 0 ;;
esac

# Check QA coverage from cache
APL_DIR="/c/Dev/Projetos/OLMO/.claude/apl"
QA_FILE="$APL_DIR/qa-coverage.txt"
[ -f "$QA_FILE" ] || exit 0

COVERAGE=$(cat "$QA_FILE" 2>/dev/null || echo "0/0")
DONE=$(echo "$COVERAGE" | cut -d/ -f1)
TOTAL=$(echo "$COVERAGE" | cut -d/ -f2)

# Allow if no slides or >= 50% coverage
[ "$TOTAL" -eq 0 ] 2>/dev/null && exit 0
THRESHOLD=$(( TOTAL / 2 ))
[ "$DONE" -ge "$THRESHOLD" ] 2>/dev/null && exit 0

# Below 50%: ask permission
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"[QA gate] %s/%s slides com editorial completo (<50%%). Criar novo slide mesmo?"}}\n' "$DONE" "$TOTAL"
exit 0
