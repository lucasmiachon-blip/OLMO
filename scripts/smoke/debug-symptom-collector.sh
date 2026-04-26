#!/usr/bin/env bash
# scripts/smoke/debug-symptom-collector.sh — D.1 contract + fixture validation
# T4 teatro → ATIVO (S258 Phase A.1 Tier 1). Live invocation (Tier 2) defer S259+
# (requires SessionStart hook bypass infra; spawning claude -p in subprocess inherits
# project hooks that hijack first turn — see CHANGELOG §S258).
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

AGENT="debug-symptom-collector"
AGENT_FILE=".claude/agents/${AGENT}.md"
FIXTURE="scripts/smoke/fixtures/symptom-collector-output.json"

# --- Static contract — agent .md structural invariants ---
[[ -f "$AGENT_FILE" ]] || { echo "FAIL: $AGENT_FILE missing"; exit 1; }
grep -q '^## VERIFY'             "$AGENT_FILE" || { echo "FAIL: ## VERIFY section missing (KBP-32 regression)"; exit 1; }
grep -q '"schema_version"'       "$AGENT_FILE" || { echo "FAIL: schema_version not declared in canonical schema"; exit 1; }
grep -q '"complexity_score"'     "$AGENT_FILE" || { echo "FAIL: complexity_score not declared"; exit 1; }
grep -q '"routing_decision"'     "$AGENT_FILE" || { echo "FAIL: routing_decision not declared (D8 SOTA-D)"; exit 1; }
grep -q 'disallowedTools.*Write' "$AGENT_FILE" || { echo "FAIL: disallowedTools missing Write (anti-fabrication weakened)"; exit 1; }
grep -q 'disallowedTools.*Edit'  "$AGENT_FILE" || { echo "FAIL: disallowedTools missing Edit"; exit 1; }
grep -q 'disallowedTools.*Agent' "$AGENT_FILE" || { echo "FAIL: disallowedTools missing Agent (KBP-06 regression)"; exit 1; }

# --- Fixture — canonical output schema validation ---
[[ -f "$FIXTURE" ]] || { echo "FAIL: fixture $FIXTURE missing"; exit 1; }
jq empty "$FIXTURE" 2>/dev/null || { echo "FAIL: fixture not valid JSON"; exit 1; }

# 10 top-level fields required by schema (agent .md lines 28-77)
for field in schema_version ingested_at error_signature affected_surface reproduction \
             suspected_scope complexity_score evidence_artifacts gaps downstream_hints; do
  jq -e "has(\"$field\")" "$FIXTURE" >/dev/null || { echo "FAIL: fixture missing top-level field '$field'"; exit 1; }
done

# Schema version invariant
jq -e '.schema_version == "1.0"' "$FIXTURE" >/dev/null || { echo "FAIL: schema_version != \"1.0\""; exit 1; }

# error_signature: verbatim_message non-empty (no fabrication via empty string)
jq -e '.error_signature.verbatim_message | length > 0' "$FIXTURE" >/dev/null || { echo "FAIL: verbatim_message empty"; exit 1; }

# complexity_score: value ∈ [0,100], components sum == value
jq -e '.complexity_score.value | (. >= 0 and . <= 100)' "$FIXTURE" >/dev/null || { echo "FAIL: complexity_score.value out of [0,100]"; exit 1; }

VALUE=$(jq -r '.complexity_score.value' "$FIXTURE")
SUM=$(jq -r '.complexity_score.components | (.error_clarity + .repro_determinism + .scope_clarity + .cause_familiarity)' "$FIXTURE")
[[ "$SUM" == "$VALUE" ]] || { echo "FAIL: components sum ($SUM) != complexity_score.value ($VALUE)"; exit 1; }

# routing_decision derivation: value > 75 → "single_agent" | value ≤ 75 → "mas" (D8 SOTA-D)
DECISION=$(jq -r '.complexity_score.routing_decision' "$FIXTURE")
EXPECTED=$([[ "$VALUE" -gt 75 ]] && echo "single_agent" || echo "mas")
[[ "$DECISION" == "$EXPECTED" ]] || { echo "FAIL: routing_decision='$DECISION' but value=$VALUE expects '$EXPECTED' (D8 boundary)"; exit 1; }

# gaps + evidence_artifacts must be arrays
jq -e '.gaps | type == "array"'                "$FIXTURE" >/dev/null || { echo "FAIL: gaps not array"; exit 1; }
jq -e '.evidence_artifacts | type == "array"'  "$FIXTURE" >/dev/null || { echo "FAIL: evidence_artifacts not array"; exit 1; }

# evidence_artifacts excerpts ≤500 chars (per agent .md schema)
jq -e '[.evidence_artifacts[] | .excerpt | length] | all(. <= 500)' "$FIXTURE" >/dev/null \
  || { echo "FAIL: evidence_artifacts excerpt > 500 chars"; exit 1; }

# downstream_hints must reference both archaeologist + adversarial
jq -e '.downstream_hints | has("archaeologist") and has("adversarial")' "$FIXTURE" >/dev/null \
  || { echo "FAIL: downstream_hints missing archaeologist or adversarial"; exit 1; }

echo "PASS: ${AGENT} contract (8 grep) + fixture (10 fields + 7 invariants)"
