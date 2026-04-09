#!/usr/bin/env bash
# guard-research-queries.sh — PreToolUse(Skill)
# Forces user confirmation before /research skill runs.
# Ensures queries are co-designed with Lucas, not autonomously launched.
# Exit 0 without JSON = allow. "ask" = prompt user.

INPUT=$(cat 2>/dev/null || echo '{}')

# Extract skill name from tool_input
SKILL=$(echo "$INPUT" | node -e "
  try {
    const d=JSON.parse(require('fs').readFileSync(0,'utf8'));
    console.log((d.tool_input||{}).skill||'');
  } catch(e) { console.log(''); }
" 2>/dev/null)

# Only gate the research skill
case "$SKILL" in
  research|evidence)
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"[RESEARCH] Queries co-designed com Lucas? Estruturar queries JUNTO antes de lancar pernas."}}\n'
    exit 0
    ;;
esac

exit 0
