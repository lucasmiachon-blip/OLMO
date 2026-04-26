#!/usr/bin/env bash
# scripts/smoke/debug-strategist.sh — D.2 contract + fixture validation
# T4 teatro → ATIVO (S258 Phase A.2 Tier 1). Live invocation defer S259 (see D.1 notes).
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

AGENT="debug-strategist"
AGENT_FILE=".claude/agents/${AGENT}.md"
FIXTURE="scripts/smoke/fixtures/strategist-output.json"

# --- Static contract — agent .md structural invariants ---
[[ -f "$AGENT_FILE" ]] || { echo "FAIL: $AGENT_FILE missing"; exit 1; }
grep -q '^## VERIFY'                               "$AGENT_FILE" || { echo "FAIL: ## VERIFY missing"; exit 1; }
grep -q '"first_principles_decomposition"'         "$AGENT_FILE" || { echo "FAIL: first_principles_decomposition not declared"; exit 1; }
grep -q '"proposed_root_cause_hypotheses"'         "$AGENT_FILE" || { echo "FAIL: proposed_root_cause_hypotheses not declared"; exit 1; }
grep -q '"architectural_lens_view"'                "$AGENT_FILE" || { echo "FAIL: architectural_lens_view not declared"; exit 1; }
grep -q '"what_would_disprove"'                    "$AGENT_FILE" || { echo "FAIL: what_would_disprove not declared (KBP-28 inverse)"; exit 1; }

# Frontmatter tools allowlist: Read, Grep, Glob ONLY (no Write/Edit/Bash/Agent)
FM=$(awk '/^---$/{c++; if(c==2)exit; next} c==1' "$AGENT_FILE")
echo "$FM" | grep -qE '^[[:space:]]*-[[:space:]]+Read'  || { echo "FAIL: tools missing Read"; exit 1; }
echo "$FM" | grep -qE '^[[:space:]]*-[[:space:]]+Grep'  || { echo "FAIL: tools missing Grep"; exit 1; }
echo "$FM" | grep -qE '^[[:space:]]*-[[:space:]]+Glob'  || { echo "FAIL: tools missing Glob"; exit 1; }
if echo "$FM" | grep -qE '^[[:space:]]*-[[:space:]]+(Write|Edit|Bash|Agent)[[:space:]]*$'; then
  echo "FAIL: tools allowlist contains forbidden Write/Edit/Bash/Agent (KBP-10/15 violation)"
  exit 1
fi

# --- Fixture — canonical output schema validation ---
[[ -f "$FIXTURE" ]] || { echo "FAIL: fixture $FIXTURE missing"; exit 1; }
jq empty "$FIXTURE" 2>/dev/null || { echo "FAIL: fixture not valid JSON"; exit 1; }

# 8 top-level fields per schema (agent .md lines 28-53)
for field in schema_version produced_at input_collector_complexity_score \
             first_principles_decomposition proposed_root_cause_hypotheses \
             architectural_lens_view confidence_overall gaps; do
  jq -e "has(\"$field\")" "$FIXTURE" >/dev/null || { echo "FAIL: fixture missing top-level field '$field'"; exit 1; }
done

jq -e '.schema_version == "1.0"' "$FIXTURE" >/dev/null || { echo "FAIL: schema_version != \"1.0\""; exit 1; }

# first_principles_decomposition: atomic_claims (≥2), implicit_assumptions, failure_locus non-empty
jq -e '.first_principles_decomposition.atomic_claims | length >= 2' "$FIXTURE" >/dev/null \
  || { echo "FAIL: atomic_claims < 2 (decomposicao incompleta per Failure Modes)"; exit 1; }
jq -e '.first_principles_decomposition.implicit_assumptions_in_symptom | type == "array"' "$FIXTURE" >/dev/null \
  || { echo "FAIL: implicit_assumptions_in_symptom not array"; exit 1; }
jq -e '.first_principles_decomposition.failure_locus | length > 0' "$FIXTURE" >/dev/null \
  || { echo "FAIL: failure_locus empty"; exit 1; }

# proposed_root_cause_hypotheses: ≥1, each has rank/hypothesis/reasoning_chain/what_would_disprove/confidence
jq -e '.proposed_root_cause_hypotheses | length >= 1' "$FIXTURE" >/dev/null \
  || { echo "FAIL: ≥1 hypothesis required (VERIFY contract)"; exit 1; }
jq -e '[.proposed_root_cause_hypotheses[] | (has("rank") and has("hypothesis") and has("reasoning_chain") and has("what_would_disprove") and has("confidence"))] | all' "$FIXTURE" >/dev/null \
  || { echo "FAIL: hypothesis missing rank/hypothesis/reasoning_chain/what_would_disprove/confidence"; exit 1; }

# what_would_disprove must be non-empty (KBP-28 inverse — defesa contra confirmation bias)
jq -e '[.proposed_root_cause_hypotheses[] | .what_would_disprove | length > 0] | all' "$FIXTURE" >/dev/null \
  || { echo "FAIL: ≥1 hypothesis has empty what_would_disprove (confirmation bias risk)"; exit 1; }

# Confidence values constrained
jq -e '[.proposed_root_cause_hypotheses[] | .confidence | test("^(high|medium|low)$")] | all' "$FIXTURE" >/dev/null \
  || { echo "FAIL: hypothesis confidence not in {high,medium,low}"; exit 1; }

# architectural_lens_view: design_flaw|bug claim + boundary + alternative_design (VERIFY contract)
jq -e '.architectural_lens_view.is_design_flaw_or_bug | test("^(design_flaw|bug|both|unclear)$")' "$FIXTURE" >/dev/null \
  || { echo "FAIL: is_design_flaw_or_bug not in {design_flaw,bug,both,unclear}"; exit 1; }
jq -e '.architectural_lens_view | has("boundary_violated") and has("alternative_design_that_would_prevent")' "$FIXTURE" >/dev/null \
  || { echo "FAIL: architectural_lens_view missing boundary_violated or alternative_design_that_would_prevent"; exit 1; }

# confidence_overall present + valid
jq -e '.confidence_overall | test("^(high|medium|low)$")' "$FIXTURE" >/dev/null \
  || { echo "FAIL: confidence_overall not in {high,medium,low}"; exit 1; }

# Cross-fixture coherence: input_collector_complexity_score should match symptom-collector fixture
COLLECTOR_FIXTURE="scripts/smoke/fixtures/symptom-collector-output.json"
if [[ -f "$COLLECTOR_FIXTURE" ]]; then
  COLLECTOR_SCORE=$(jq -r '.complexity_score.value' "$COLLECTOR_FIXTURE")
  STRATEGIST_MIRROR=$(jq -r '.input_collector_complexity_score' "$FIXTURE")
  [[ "$COLLECTOR_SCORE" == "$STRATEGIST_MIRROR" ]] \
    || { echo "FAIL: input_collector_complexity_score ($STRATEGIST_MIRROR) != collector fixture value ($COLLECTOR_SCORE)"; exit 1; }
fi

echo "PASS: ${AGENT} contract (5 grep + tools allowlist) + fixture (8 fields + 9 invariants + cross-coherence)"
