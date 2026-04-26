#!/usr/bin/env bash
# scripts/smoke/debug-patch-editor.sh — D.6 contract + fixture validation
# T4 teatro → ATIVO (S258 Phase A.6 Tier 1). Live invocation defer S259.
# Patch-editor = ÚNICO writer em /debug-team. Fixture validates zero-edit case (KBP-35).
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

AGENT="debug-patch-editor"
AGENT_FILE=".claude/agents/${AGENT}.md"
FIXTURE="scripts/smoke/fixtures/patch-editor-output.json"

# --- Static contract — agent .md structural invariants ---
[[ -f "$AGENT_FILE" ]] || { echo "FAIL: $AGENT_FILE missing"; exit 1; }
grep -q '^## VERIFY'                         "$AGENT_FILE" || { echo "FAIL: ## VERIFY missing"; exit 1; }
grep -q '"edits_applied"'                    "$AGENT_FILE" || { echo "FAIL: edits_applied not declared"; exit 1; }
grep -q '"drift_detected"'                   "$AGENT_FILE" || { echo "FAIL: drift_detected not declared"; exit 1; }
grep -q '"validation_pre_apply_passed"'      "$AGENT_FILE" || { echo "FAIL: validation_pre_apply_passed not declared"; exit 1; }
grep -q 'KBP-01'                             "$AGENT_FILE" || { echo "FAIL: KBP-01 single-writer enforcement absent"; exit 1; }
grep -q 'KBP-19'                             "$AGENT_FILE" || { echo "FAIL: KBP-19 protected files reference absent"; exit 1; }
grep -q 'KBP-32'                             "$AGENT_FILE" || { echo "FAIL: KBP-32 spot-check reference absent"; exit 1; }
grep -qE 'Write.*temp.*cp|Write→temp→cp|Write→.*\.new'  "$AGENT_FILE" || { echo "FAIL: KBP-19 deploy pattern (Write→temp→cp) absent"; exit 1; }

# Frontmatter tools: writer (Bash, Read, Edit, Write, Grep, Glob — NO Agent only)
FM=$(awk '/^---$/{c++; if(c==2)exit; next} c==1' "$AGENT_FILE")
echo "$FM" | grep -qE '^[[:space:]]*-[[:space:]]+Edit'   || { echo "FAIL: tools missing Edit (writer agent)"; exit 1; }
echo "$FM" | grep -qE '^[[:space:]]*-[[:space:]]+Write'  || { echo "FAIL: tools missing Write (writer agent)"; exit 1; }
echo "$FM" | grep -qE '^[[:space:]]*-[[:space:]]+Bash'   || { echo "FAIL: tools missing Bash (Codex assist)"; exit 1; }
if echo "$FM" | grep -qE '^[[:space:]]*-[[:space:]]+Agent[[:space:]]*$'; then
  echo "FAIL: tools allowlist contains forbidden Agent (no recursive subagent spawning)"
  exit 1
fi

# --- Fixture — canonical output schema validation ---
[[ -f "$FIXTURE" ]] || { echo "FAIL: fixture $FIXTURE missing"; exit 1; }
jq empty "$FIXTURE" 2>/dev/null || { echo "FAIL: fixture not valid JSON"; exit 1; }

# 9 top-level fields per schema (agent .md lines 33-60)
for field in schema_version produced_at architect_plan_source edits_applied \
             drift_detected codex_assist_used validation_pre_apply_passed \
             summary next_phase_input; do
  jq -e "has(\"$field\")" "$FIXTURE" >/dev/null || { echo "FAIL: fixture missing top-level field '$field'"; exit 1; }
done

jq -e '.schema_version == "1.0"' "$FIXTURE" >/dev/null || { echo "FAIL: schema_version != \"1.0\""; exit 1; }

# Arrays as arrays
for arr_field in edits_applied drift_detected validation_pre_apply_passed; do
  jq -e ".${arr_field} | type == \"array\"" "$FIXTURE" >/dev/null \
    || { echo "FAIL: ${arr_field} not array"; exit 1; }
done

# codex_assist_used boolean
jq -e '.codex_assist_used | type == "boolean"' "$FIXTURE" >/dev/null \
  || { echo "FAIL: codex_assist_used not boolean"; exit 1; }

# CRITICAL: zero-edit valid case — if edits_applied empty, must be intentional (per KBP-35 or upstream-only)
EDITS_COUNT=$(jq -r '.edits_applied | length' "$FIXTURE")
if [[ "$EDITS_COUNT" -eq 0 ]]; then
  jq -e '.summary | test("KBP-35|upstream-only|zero changes|no.*local|policy"; "i")' "$FIXTURE" >/dev/null \
    || { echo "FAIL: zero edits requires summary justification (KBP-35/upstream-only/policy reference)"; exit 1; }
fi

# If edits_applied non-empty, each item has 6 required fields + operation enum + matches_architect_intent enum
if [[ "$EDITS_COUNT" -gt 0 ]]; then
  jq -e '[.edits_applied[] | (has("file_path") and has("lines_changed") and has("operation") and has("diff_summary") and has("matches_architect_intent") and has("error"))] | all' "$FIXTURE" >/dev/null \
    || { echo "FAIL: edits_applied item missing required fields"; exit 1; }

  # operation enum: Edit | Write | cp_protected (KBP-19)
  jq -e '[.edits_applied[] | .operation | test("^(Edit|Write|cp_protected.*KBP-19.*|cp_protected)")] | all' "$FIXTURE" >/dev/null \
    || { echo "FAIL: operation not in {Edit, Write, cp_protected (KBP-19)}"; exit 1; }

  # matches_architect_intent enum
  jq -e '[.edits_applied[] | .matches_architect_intent | test("^(true|false|partial)$")] | all' "$FIXTURE" >/dev/null \
    || { echo "FAIL: matches_architect_intent not in {true,false,partial}"; exit 1; }
fi

# drift_detected items: each has intended_file + drift_type + details
DRIFT_COUNT=$(jq -r '.drift_detected | length' "$FIXTURE")
if [[ "$DRIFT_COUNT" -gt 0 ]]; then
  jq -e '[.drift_detected[] | (has("intended_file") and has("drift_type") and has("details"))] | all' "$FIXTURE" >/dev/null \
    || { echo "FAIL: drift_detected item missing required fields"; exit 1; }

  # drift_type enum
  jq -e '[.drift_detected[] | .drift_type | test("^(out_of_plan_file|architect_intent_unclear|edit_failed|pre_patch_check_failed|plan_parse_failed|kbp_violation)$")] | all' "$FIXTURE" >/dev/null \
    || { echo "FAIL: drift_type not in declared enum"; exit 1; }
fi

# Cross-fixture coherence: architect_plan_source should reference architect fixture
ARCH_FIXTURE="scripts/smoke/fixtures/architect-output.md"
if [[ -f "$ARCH_FIXTURE" ]]; then
  PLAN_SRC=$(jq -r '.architect_plan_source' "$FIXTURE")
  if [[ "$PLAN_SRC" == *"architect-output.md"* ]]; then
    [[ -f "$ARCH_FIXTURE" ]] || { echo "FAIL: architect_plan_source references missing fixture"; exit 1; }
  fi
fi

echo "PASS: ${AGENT} contract (8 grep + writer tools allowlist) + fixture (9 fields + zero-edit/edit invariants + drift enums)"
