#!/usr/bin/env bash
# scripts/smoke/debug-validator.sh — D.7 contract + fixture validation
# T4 teatro → ATIVO (S258 Phase A.7 Tier 1). Live invocation defer S259.
# Validator = Phase 5 mechanical verification. READ-ONLY Bash.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

AGENT="debug-validator"
AGENT_FILE=".claude/agents/${AGENT}.md"
FIXTURE="scripts/smoke/fixtures/validator-output.json"

# --- Static contract — agent .md structural invariants ---
[[ -f "$AGENT_FILE" ]] || { echo "FAIL: $AGENT_FILE missing"; exit 1; }
grep -q '^## VERIFY'                              "$AGENT_FILE" || { echo "FAIL: ## VERIFY missing"; exit 1; }
grep -q '"reproduction_steps"'                    "$AGENT_FILE" || { echo "FAIL: reproduction_steps not declared"; exit 1; }
grep -q '"regression_checks"'                     "$AGENT_FILE" || { echo "FAIL: regression_checks not declared"; exit 1; }
grep -q '"verdict"'                               "$AGENT_FILE" || { echo "FAIL: verdict not declared"; exit 1; }
grep -q '"loop_back_input_to_architect"'          "$AGENT_FILE" || { echo "FAIL: loop_back_input_to_architect not declared"; exit 1; }
grep -qE 'pass\|partial\|fail|pass.*partial.*fail' "$AGENT_FILE" || { echo "FAIL: verdict enum {pass,partial,fail} not declared"; exit 1; }
grep -q 'READ-ONLY'                               "$AGENT_FILE" || { echo "FAIL: READ-ONLY enforcement absent"; exit 1; }
grep -qiE 'evaluator-optimizer|loop.back'         "$AGENT_FILE" || { echo "FAIL: Anthropic Evaluator-Optimizer pattern reference absent"; exit 1; }

# Frontmatter tools: Bash (read-only ops), Read, Grep, Glob (no Write/Edit/Agent)
FM=$(awk '/^---$/{c++; if(c==2)exit; next} c==1' "$AGENT_FILE")
echo "$FM" | grep -qE '^[[:space:]]*-[[:space:]]+Bash'  || { echo "FAIL: tools missing Bash (test/lint runners)"; exit 1; }
echo "$FM" | grep -qE '^[[:space:]]*-[[:space:]]+Read'  || { echo "FAIL: tools missing Read"; exit 1; }
if echo "$FM" | grep -qE '^[[:space:]]*-[[:space:]]+(Write|Edit|Agent)[[:space:]]*$'; then
  echo "FAIL: tools allowlist contains forbidden Write/Edit/Agent (validator = read-only verification)"
  exit 1
fi

# --- Fixture — canonical output schema validation ---
[[ -f "$FIXTURE" ]] || { echo "FAIL: fixture $FIXTURE missing"; exit 1; }
jq empty "$FIXTURE" 2>/dev/null || { echo "FAIL: fixture not valid JSON"; exit 1; }

# 12 top-level fields per schema (agent .md lines 33-80)
for field in schema_version produced_at edit_log_source reproduction_steps regression_checks \
             lint_status test_status verdict verdict_rationale loop_back_recommended \
             loop_back_input_to_architect summary; do
  jq -e "has(\"$field\")" "$FIXTURE" >/dev/null || { echo "FAIL: fixture missing top-level field '$field'"; exit 1; }
done

jq -e '.schema_version == "1.0"' "$FIXTURE" >/dev/null || { echo "FAIL: schema_version != \"1.0\""; exit 1; }

# verdict enum
jq -e '.verdict | test("^(pass|partial|fail)$")' "$FIXTURE" >/dev/null \
  || { echo "FAIL: verdict not in {pass,partial,fail}"; exit 1; }

# loop_back_recommended boolean
jq -e '.loop_back_recommended | type == "boolean"' "$FIXTURE" >/dev/null \
  || { echo "FAIL: loop_back_recommended not boolean"; exit 1; }

# Arrays as arrays
for arr_field in reproduction_steps regression_checks; do
  jq -e ".${arr_field} | type == \"array\"" "$FIXTURE" >/dev/null \
    || { echo "FAIL: ${arr_field} not array"; exit 1; }
done

# lint_status, test_status: objects with required keys
jq -e '.lint_status | (has("ran") and has("tool") and has("exit_code") and has("issues_count"))' "$FIXTURE" >/dev/null \
  || { echo "FAIL: lint_status missing required keys"; exit 1; }
jq -e '.test_status | (has("ran") and has("tool") and has("exit_code") and has("passed_count") and has("failed_count") and has("failed_test_names"))' "$FIXTURE" >/dev/null \
  || { echo "FAIL: test_status missing required keys"; exit 1; }

# CRITICAL invariant: when verdict=fail, loop_back_input_to_architect must be non-null
VERDICT=$(jq -r '.verdict' "$FIXTURE")
LOOP_BACK_REC=$(jq -r '.loop_back_recommended' "$FIXTURE")
LOOP_BACK_INPUT_NULL=$(jq -e '.loop_back_input_to_architect == null' "$FIXTURE" >/dev/null && echo "true" || echo "false")

if [[ "$VERDICT" == "fail" ]]; then
  [[ "$LOOP_BACK_REC" == "true" ]] || { echo "FAIL: verdict=fail requires loop_back_recommended=true (Evaluator-Optimizer pattern)"; exit 1; }
  [[ "$LOOP_BACK_INPUT_NULL" == "false" ]] || { echo "FAIL: verdict=fail requires loop_back_input_to_architect non-null"; exit 1; }
  jq -e '.loop_back_input_to_architect | (has("what_failed") and has("evidence_for_architect_to_consider") and has("suggested_re_examination"))' "$FIXTURE" >/dev/null \
    || { echo "FAIL: loop_back_input_to_architect missing required fields {what_failed, evidence_for_architect_to_consider, suggested_re_examination}"; exit 1; }
fi

# regression_checks check_type enum
jq -e '[.regression_checks[] | .check_type | test("^(syntax|smoke_test|grep_pattern_preserved|no_unintended_changes)$")] | all' "$FIXTURE" >/dev/null \
  || { echo "FAIL: regression_checks check_type not in {syntax,smoke_test,grep_pattern_preserved,no_unintended_changes}"; exit 1; }

# CRITICAL: zero-edit pass case (KBP-35) — when reproduction_steps empty AND verdict=pass,
# rationale must reference KBP-35/upstream/zero-changes (per agent .md Failure Modes "Edit-log empty AND architect prescribed upstream-only")
REPRO_COUNT=$(jq -r '.reproduction_steps | length' "$FIXTURE")
if [[ "$REPRO_COUNT" -eq 0 ]] && [[ "$VERDICT" == "pass" ]]; then
  jq -e '.verdict_rationale | test("KBP-35|upstream|zero.changes|zero edits|no patch"; "i")' "$FIXTURE" >/dev/null \
    || { echo "FAIL: zero-edit pass verdict requires rationale citing KBP-35/upstream-only/zero-changes justification"; exit 1; }
fi

# Cross-fixture coherence: edit_log_source should reference patch-editor fixture
EDITOR_FIXTURE="scripts/smoke/fixtures/patch-editor-output.json"
if [[ -f "$EDITOR_FIXTURE" ]]; then
  EDIT_LOG_SRC=$(jq -r '.edit_log_source' "$FIXTURE")
  if [[ "$EDIT_LOG_SRC" == *"patch-editor-output.json"* ]]; then
    [[ -f "$EDITOR_FIXTURE" ]] || { echo "FAIL: edit_log_source references missing fixture"; exit 1; }
  fi
fi

echo "PASS: ${AGENT} contract (8 grep + tools allowlist Bash-readonly) + fixture (12 fields + verdict invariants + loop-back enforcement + zero-edit case)"
