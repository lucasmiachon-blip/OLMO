#!/usr/bin/env bash
# scripts/smoke/debug-architect.sh — D.5 contract + fixture validation
# T4 teatro → ATIVO (S258 Phase A.5 Tier 1). Live invocation defer S259.
# Architect = Aider Architect role: outputs MARKDOWN TEXT (not JSON tool calls).
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

AGENT="debug-architect"
AGENT_FILE=".claude/agents/${AGENT}.md"
FIXTURE="scripts/smoke/fixtures/architect-output.md"

# --- Static contract — agent .md structural invariants ---
[[ -f "$AGENT_FILE" ]] || { echo "FAIL: $AGENT_FILE missing"; exit 1; }
grep -q '^## VERIFY'                               "$AGENT_FILE" || { echo "FAIL: ## VERIFY missing"; exit 1; }
grep -q 'markdown TEXT'                            "$AGENT_FILE" || { echo "FAIL: 'markdown TEXT' (D7 critical) not declared in VERIFY"; exit 1; }
grep -q 'NUNCA JSON\|nunca JSON'                   "$AGENT_FILE" || { echo "FAIL: explicit 'NUNCA JSON' enforcement absent"; exit 1; }
grep -q 'READ-ONLY'                                "$AGENT_FILE" || { echo "FAIL: READ-ONLY enforcement absent"; exit 1; }
grep -q 'Aider'                                    "$AGENT_FILE" || { echo "FAIL: Aider 2024-09 study reference absent (D7 evidence)"; exit 1; }
grep -q 'KBP-32'                                   "$AGENT_FILE" || { echo "FAIL: KBP-32 spot-check reference missing"; exit 1; }

# Frontmatter tools: extreme READ-ONLY (Read, Grep, Glob — NO Bash, no Write/Edit/Agent)
FM=$(awk '/^---$/{c++; if(c==2)exit; next} c==1' "$AGENT_FILE")
echo "$FM" | grep -qE '^[[:space:]]*-[[:space:]]+Read'  || { echo "FAIL: tools missing Read"; exit 1; }
echo "$FM" | grep -qE '^[[:space:]]*-[[:space:]]+Grep'  || { echo "FAIL: tools missing Grep"; exit 1; }
echo "$FM" | grep -qE '^[[:space:]]*-[[:space:]]+Glob'  || { echo "FAIL: tools missing Glob"; exit 1; }
if echo "$FM" | grep -qE '^[[:space:]]*-[[:space:]]+(Bash|Write|Edit|Agent)[[:space:]]*$'; then
  echo "FAIL: tools allowlist contains forbidden Bash/Write/Edit/Agent (architect = pure read-only reasoner)"
  exit 1
fi

# --- Fixture — markdown structural validation (NOT JSON) ---
[[ -f "$FIXTURE" ]] || { echo "FAIL: fixture $FIXTURE missing"; exit 1; }

# Fixture must NOT be JSON (D7 critical)
if jq empty "$FIXTURE" 2>/dev/null; then
  echo "FAIL: fixture parses as JSON — architect must output markdown TEXT (D7 Aider study)"
  exit 1
fi

# Fixture must NOT contain JSON tool call patterns (Anthropic harness syntax)
if grep -qE '<function_calls>|<function_calls>|"tool_use"|"tool_calls"' "$FIXTURE"; then
  echo "FAIL: fixture contains JSON tool call patterns — architect must produce prose, editor parses"
  exit 1
fi

# Required markdown sections (per agent .md output spec lines 31-102)
required_sections=(
  '^# Patch Architecture Plan'
  '^> Bug:'
  '^> Routing:'
  '^> Confidence:'
  '^## Source Inputs Considered'
  '^## Root Cause Decision'
  '^## Proposed Changes'
  '^## Risks'
  '^## Rollback Plan'
  '^## KBP References'
  '^## Validation Pre-Patch'
  '^## Validation Post-Patch'
)

for pattern in "${required_sections[@]}"; do
  grep -qE "$pattern" "$FIXTURE" || { echo "FAIL: required markdown section missing: $pattern"; exit 1; }
done

# If MAS path declared, Cross-Validation section must exist
if grep -qE '^> Routing: mas' "$FIXTURE"; then
  grep -qE '^## Cross-Validation' "$FIXTURE" || { echo "FAIL: MAS routing requires ## Cross-Validation section"; exit 1; }
fi

# Proposed Changes section: must have either ZERO changes statement OR ≥1 ### File: header
if ! grep -qE '^### File:' "$FIXTURE" && ! grep -qiE 'zero local file changes|no.*changes|N/A' "$FIXTURE"; then
  echo "FAIL: Proposed Changes section needs ≥1 '### File:' header OR explicit zero-changes statement"
  exit 1
fi

# Validation Pre-Patch checklist: ≥1 unchecked item (D10 Lucas confirm gate)
PRE_CHECKS=$(awk '/^## Validation Pre-Patch/,/^## Validation Post-Patch/' "$FIXTURE" | grep -cE '^- \[ \]' || true)
[[ "$PRE_CHECKS" -ge 1 ]] || { echo "FAIL: Validation Pre-Patch needs ≥1 checklist item (D10 confirm gate)"; exit 1; }

# Validation Post-Patch: ≥1 checklist (validator Phase 5 input)
# awk skip heading (next), then count '- [ ]' lines until EOF or next ## section
POST_CHECKS=$(awk '/^## Validation Post-Patch/{flag=1; next} flag && /^## /{flag=0} flag' "$FIXTURE" | grep -cE '^- \[ \]' || true)
[[ "$POST_CHECKS" -ge 1 ]] || { echo "FAIL: Validation Post-Patch needs ≥1 checklist item (validator B.6 input)"; exit 1; }

# KBP References: cite real KBPs (KBP-32 spot-check)
KBP_REFS=$(grep -oE 'KBP-[0-9]+' "$FIXTURE" | sort -u)
if [[ -n "$KBP_REFS" ]]; then
  for kbp in $KBP_REFS; do
    grep -q "## $kbp" .claude/rules/known-bad-patterns.md \
      || { echo "FAIL: $kbp referenced in architect plan but absent from known-bad-patterns.md (KBP-32 fabrication)"; exit 1; }
  done
fi

echo "PASS: ${AGENT} contract (7 grep + tools allowlist no-Bash) + fixture markdown (12 sections + KBP spot-check)"
