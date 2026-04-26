#!/usr/bin/env bash
# scripts/smoke/debug-archaeologist.sh — D.3 contract + fixture validation
# T4 teatro → ATIVO (S258 Phase A.3 Tier 1). Live invocation defer S259 (Gemini CLI dep + hooks bypass).
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

AGENT="debug-archaeologist"
AGENT_FILE=".claude/agents/${AGENT}.md"
FIXTURE="scripts/smoke/fixtures/archaeologist-output.json"

# --- Static contract — agent .md structural invariants ---
[[ -f "$AGENT_FILE" ]] || { echo "FAIL: $AGENT_FILE missing"; exit 1; }
grep -q '^## VERIFY'                           "$AGENT_FILE" || { echo "FAIL: ## VERIFY missing"; exit 1; }
grep -q '"git_blame_relevant_commits"'         "$AGENT_FILE" || { echo "FAIL: git_blame_relevant_commits not declared"; exit 1; }
grep -q '"historical_pattern_matches"'         "$AGENT_FILE" || { echo "FAIL: historical_pattern_matches not declared"; exit 1; }
grep -q '"prior_fixes_attempted"'              "$AGENT_FILE" || { echo "FAIL: prior_fixes_attempted not declared"; exit 1; }
grep -q '"related_issues_external"'            "$AGENT_FILE" || { echo "FAIL: related_issues_external not declared"; exit 1; }
grep -q 'command -v gemini'                    "$AGENT_FILE" || { echo "FAIL: Gemini preflight pattern absent (defensive code regression)"; exit 1; }
grep -q 'KBP-32'                               "$AGENT_FILE" || { echo "FAIL: KBP-32 spot-check reference missing"; exit 1; }

# Frontmatter tools allowlist: Bash, Read, Grep, Glob (no Write/Edit/Agent)
FM=$(awk '/^---$/{c++; if(c==2)exit; next} c==1' "$AGENT_FILE")
echo "$FM" | grep -qE '^[[:space:]]*-[[:space:]]+Bash'  || { echo "FAIL: tools missing Bash (needed for git/gemini calls)"; exit 1; }
echo "$FM" | grep -qE '^[[:space:]]*-[[:space:]]+Read'  || { echo "FAIL: tools missing Read"; exit 1; }
if echo "$FM" | grep -qE '^[[:space:]]*-[[:space:]]+(Write|Edit|Agent)[[:space:]]*$'; then
  echo "FAIL: tools allowlist contains forbidden Write/Edit/Agent (READ-ONLY violation)"
  exit 1
fi

# --- Fixture — canonical output schema validation ---
[[ -f "$FIXTURE" ]] || { echo "FAIL: fixture $FIXTURE missing"; exit 1; }
jq empty "$FIXTURE" 2>/dev/null || { echo "FAIL: fixture not valid JSON"; exit 1; }

# 11 top-level fields per schema (agent .md lines 28-77)
for field in schema_version produced_at input_collector_complexity_score external_brain_used \
             git_blame_relevant_commits historical_pattern_matches prior_fixes_attempted \
             related_issues_external architectural_context confidence_overall gaps; do
  jq -e "has(\"$field\")" "$FIXTURE" >/dev/null || { echo "FAIL: fixture missing top-level field '$field'"; exit 1; }
done

jq -e '.schema_version == "1.0"' "$FIXTURE" >/dev/null || { echo "FAIL: schema_version != \"1.0\""; exit 1; }

# external_brain_used: "gemini-3-1-pro" canonical, OR null if preflight failed
jq -e '.external_brain_used == "gemini-3-1-pro" or .external_brain_used == null' "$FIXTURE" >/dev/null \
  || { echo "FAIL: external_brain_used not in {\"gemini-3-1-pro\", null}"; exit 1; }

# Arrays must be arrays (even if empty)
for arr_field in git_blame_relevant_commits historical_pattern_matches prior_fixes_attempted related_issues_external gaps; do
  jq -e ".${arr_field} | type == \"array\"" "$FIXTURE" >/dev/null \
    || { echo "FAIL: ${arr_field} not array"; exit 1; }
done

# git_blame_relevant_commits: each item has sha/date/author/subject + confidence enum
jq -e '[.git_blame_relevant_commits[] | (has("sha") and has("date") and has("author") and has("subject") and has("confidence"))] | all' "$FIXTURE" >/dev/null \
  || { echo "FAIL: git_blame_relevant_commits item missing sha/date/author/subject/confidence"; exit 1; }

# historical_pattern_matches: each has pattern/occurrences/evidence_paths/confidence
jq -e '[.historical_pattern_matches[] | (has("pattern") and has("occurrences") and has("evidence_paths") and has("confidence"))] | all' "$FIXTURE" >/dev/null \
  || { echo "FAIL: historical_pattern_matches item missing required fields"; exit 1; }

# prior_fixes_attempted outcome enum (per schema line 59 — strict enum)
# NOTE: agent .md example (line 240) uses "tracking" which violates this enum — drift flagged S259
jq -e '[.prior_fixes_attempted[] | .outcome | test("^(success|partial|reverted|unknown)$")] | all' "$FIXTURE" >/dev/null \
  || { echo "FAIL: prior_fixes_attempted outcome not in {success,partial,reverted,unknown} (per schema line 59)"; exit 1; }

# related_issues_external source enum
jq -e '[.related_issues_external[] | .source | test("^(github_issue|stackoverflow|blog|docs|other)$")] | all' "$FIXTURE" >/dev/null \
  || { echo "FAIL: related_issues_external source not in declared enum"; exit 1; }

# confidence_overall enum
jq -e '.confidence_overall | test("^(high|medium|low)$")' "$FIXTURE" >/dev/null \
  || { echo "FAIL: confidence_overall not in {high,medium,low}"; exit 1; }

# Cross-fixture coherence with collector
COLLECTOR_FIXTURE="scripts/smoke/fixtures/symptom-collector-output.json"
if [[ -f "$COLLECTOR_FIXTURE" ]]; then
  COLLECTOR_SCORE=$(jq -r '.complexity_score.value' "$COLLECTOR_FIXTURE")
  ARCH_MIRROR=$(jq -r '.input_collector_complexity_score' "$FIXTURE")
  [[ "$COLLECTOR_SCORE" == "$ARCH_MIRROR" ]] \
    || { echo "FAIL: input_collector_complexity_score ($ARCH_MIRROR) != collector ($COLLECTOR_SCORE)"; exit 1; }
fi

# Optional KBP-32 spot-check: SHAs in git_blame_relevant_commits must exist in git log
# (skip if array empty — this fixture has empty git_blame because bug #191 is in external plugin)
SHA_COUNT=$(jq -r '.git_blame_relevant_commits | length' "$FIXTURE")
if [[ "$SHA_COUNT" -gt 0 ]]; then
  for sha in $(jq -r '.git_blame_relevant_commits[].sha' "$FIXTURE"); do
    git log --oneline -1 "$sha" >/dev/null 2>&1 || { echo "FAIL: SHA '$sha' not in git log (KBP-32 fabrication)"; exit 1; }
  done
fi

echo "PASS: ${AGENT} contract (7 grep + tools allowlist + Bash) + fixture (11 fields + 8 invariants + cross-coherence + SHA spot-check)"
