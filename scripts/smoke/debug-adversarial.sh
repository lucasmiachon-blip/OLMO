#!/usr/bin/env bash
# scripts/smoke/debug-adversarial.sh — D.4 contract + fixture validation
# T4 teatro → ATIVO (S258 Phase A.4 Tier 1). Live invocation defer S259.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

AGENT="debug-adversarial"
AGENT_FILE=".claude/agents/${AGENT}.md"
FIXTURE="scripts/smoke/fixtures/adversarial-output.json"

# --- Static contract — agent .md structural invariants ---
[[ -f "$AGENT_FILE" ]] || { echo "FAIL: $AGENT_FILE missing"; exit 1; }
grep -q '^## VERIFY'                                   "$AGENT_FILE" || { echo "FAIL: ## VERIFY missing"; exit 1; }
grep -q '"assumption_challenges"'                      "$AGENT_FILE" || { echo "FAIL: assumption_challenges not declared"; exit 1; }
grep -q '"alternative_root_causes"'                    "$AGENT_FILE" || { echo "FAIL: alternative_root_causes not declared"; exit 1; }
grep -q '"frame_blindspots"'                           "$AGENT_FILE" || { echo "FAIL: frame_blindspots not declared"; exit 1; }
grep -q '"failure_mode_categories_unexamined"'         "$AGENT_FILE" || { echo "FAIL: failure_mode_categories_unexamined not declared"; exit 1; }
grep -q 'command -v codex'                             "$AGENT_FILE" || { echo "FAIL: Codex preflight pattern absent"; exit 1; }
grep -q 'KBP-28'                                       "$AGENT_FILE" || { echo "FAIL: KBP-28 frame-bound reference missing"; exit 1; }
grep -qE 'bash -c|sh -c|eval|exec|source'              "$AGENT_FILE" || { echo "FAIL: KBP-28 shell command checklist tokens missing"; exit 1; }

# Frontmatter tools allowlist: Bash, Read, Grep, Glob (no Write/Edit/Agent)
FM=$(awk '/^---$/{c++; if(c==2)exit; next} c==1' "$AGENT_FILE")
echo "$FM" | grep -qE '^[[:space:]]*-[[:space:]]+Bash'  || { echo "FAIL: tools missing Bash (needed for codex CLI)"; exit 1; }
if echo "$FM" | grep -qE '^[[:space:]]*-[[:space:]]+(Write|Edit|Agent)[[:space:]]*$'; then
  echo "FAIL: tools allowlist contains forbidden Write/Edit/Agent"
  exit 1
fi

# --- Fixture — canonical output schema validation ---
[[ -f "$FIXTURE" ]] || { echo "FAIL: fixture $FIXTURE missing"; exit 1; }
jq empty "$FIXTURE" 2>/dev/null || { echo "FAIL: fixture not valid JSON"; exit 1; }

# 10 top-level fields per schema (agent .md lines 31-66)
for field in schema_version produced_at input_collector_complexity_score external_brain_used \
             assumption_challenges alternative_root_causes frame_blindspots \
             failure_mode_categories_unexamined confidence_per_challenge_overall gaps; do
  jq -e "has(\"$field\")" "$FIXTURE" >/dev/null || { echo "FAIL: fixture missing top-level field '$field'"; exit 1; }
done

jq -e '.schema_version == "1.0"' "$FIXTURE" >/dev/null || { echo "FAIL: schema_version != \"1.0\""; exit 1; }

# external_brain_used: "codex-max" canonical OR null if preflight failed
jq -e '.external_brain_used == "codex-max" or .external_brain_used == null' "$FIXTURE" >/dev/null \
  || { echo "FAIL: external_brain_used not in {\"codex-max\", null}"; exit 1; }

# Arrays as arrays
for arr_field in assumption_challenges alternative_root_causes frame_blindspots failure_mode_categories_unexamined gaps; do
  jq -e ".${arr_field} | type == \"array\"" "$FIXTURE" >/dev/null \
    || { echo "FAIL: ${arr_field} not array"; exit 1; }
done

# assumption_challenges: each has 5 required fields
jq -e '[.assumption_challenges[] | (has("collector_assumption") and has("challenge") and has("evidence_for_challenge") and has("implication_if_assumption_wrong") and has("confidence"))] | all' "$FIXTURE" >/dev/null \
  || { echo "FAIL: assumption_challenges item missing required fields"; exit 1; }

# alternative_root_causes diverges_from enum
jq -e '[.alternative_root_causes[] | .diverges_from | test("^(collector|strategist|both|consensus)$")] | all' "$FIXTURE" >/dev/null \
  || { echo "FAIL: diverges_from not in {collector,strategist,both,consensus}"; exit 1; }

# alternative_root_causes test_to_distinguish must be non-empty (KBP-28 inverse — testability)
jq -e '[.alternative_root_causes[] | .test_to_distinguish | length > 0] | all' "$FIXTURE" >/dev/null \
  || { echo "FAIL: alternative_root_causes test_to_distinguish empty (untestable hypothesis)"; exit 1; }

# frame_blindspots: each has blindspot/why_collector_missed/expansion_question
jq -e '[.frame_blindspots[] | (has("blindspot") and has("why_collector_missed") and has("expansion_question"))] | all' "$FIXTURE" >/dev/null \
  || { echo "FAIL: frame_blindspots item missing required fields"; exit 1; }

# failure_mode_categories_unexamined: ≥1 (per Failure Modes — empty = adversarial value zero)
jq -e '.failure_mode_categories_unexamined | length >= 1' "$FIXTURE" >/dev/null \
  || { echo "FAIL: failure_mode_categories_unexamined empty (Codex produced no adversarial value)"; exit 1; }

# confidence enum
jq -e '.confidence_per_challenge_overall | test("^(high|medium|low)$")' "$FIXTURE" >/dev/null \
  || { echo "FAIL: confidence_per_challenge_overall not in {high,medium,low}"; exit 1; }
jq -e '[.assumption_challenges[] | .confidence | test("^(high|medium|low)$")] | all' "$FIXTURE" >/dev/null \
  || { echo "FAIL: assumption_challenges confidence not enum"; exit 1; }

# Cross-fixture coherence with collector
COLLECTOR_FIXTURE="scripts/smoke/fixtures/symptom-collector-output.json"
if [[ -f "$COLLECTOR_FIXTURE" ]]; then
  COLLECTOR_SCORE=$(jq -r '.complexity_score.value' "$COLLECTOR_FIXTURE")
  ADV_MIRROR=$(jq -r '.input_collector_complexity_score' "$FIXTURE")
  [[ "$COLLECTOR_SCORE" == "$ADV_MIRROR" ]] \
    || { echo "FAIL: input_collector_complexity_score ($ADV_MIRROR) != collector ($COLLECTOR_SCORE)"; exit 1; }
fi

# KBP-32: assumption_challenges should target REAL collector fields
# (heuristic: collector_assumption text should reference an actual collector field name)
if [[ -f "$COLLECTOR_FIXTURE" ]]; then
  for assumption in $(jq -r '.assumption_challenges[].collector_assumption' "$FIXTURE" | tr ' ' '_'); do
    # Convert back, check against collector field names
    assumption_text=$(echo "$assumption" | tr '_' ' ')
    # At minimum, check it mentions a collector schema concept
    echo "$assumption_text" | grep -qiE 'reproduction|platform|deterministic|complexity|scope|signature|surface|frequency|external_dependencies' \
      || { echo "WARN: collector_assumption '$assumption_text' may not target real collector field (KBP-32 phantom risk)"; }
  done
fi

echo "PASS: ${AGENT} contract (8 grep + tools allowlist + Bash) + fixture (10 fields + 9 invariants + cross-coherence)"
