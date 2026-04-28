#!/usr/bin/env bash
# scripts/smoke/hooks-health.sh — Reproducible hooks runtime verification
# T4 teatro → ATIVO (S258 Phase C.1 hooks Tier). Run anytime para verificar hooks ativos.
# Cada teste tem: TRIGGER + EXPECTED + ACTUAL + VERDICT. Reproducible by Lucas direto.
set -uo pipefail   # NÃO -e — quero capturar exit codes
cd "$(git rev-parse --show-toplevel)"

PASS=0
FAIL=0
declare -a RESULTS

test_case() {
  local name="$1"
  local expected="$2"
  local actual="$3"
  local detail="$4"
  if [[ "$expected" == "$actual" ]]; then
    RESULTS+=("PASS  | $name | expected=$expected actual=$actual | $detail")
    ((PASS++))
  else
    RESULTS+=("FAIL  | $name | expected=$expected actual=$actual | $detail")
    ((FAIL++))
  fi
}

echo "=== Hooks Runtime Health Check (S258 Phase C.1) ==="
echo "Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo ""

# --- Test 1: Hook scripts exist on disk ---
HOOK_COUNT_CLAUDE=$(find .claude/hooks -maxdepth 1 -name "*.sh" -type f | wc -l)
HOOK_COUNT_REPO=$(find hooks -maxdepth 1 -name "*.sh" -type f | wc -l)
TOTAL=$((HOOK_COUNT_CLAUDE + HOOK_COUNT_REPO))
test_case "T1: hook scripts on disk" "true" "$([[ $TOTAL -ge 30 ]] && echo true || echo false)" \
  "found $TOTAL scripts (.claude/hooks=$HOOK_COUNT_CLAUDE + hooks=$HOOK_COUNT_REPO)"

# --- Test 2: All hooks executable ---
NON_EXEC=$(find .claude/hooks hooks -maxdepth 1 -name "*.sh" -type f ! -perm -u+x 2>/dev/null | wc -l)
test_case "T2: all hooks executable (chmod +x)" "0" "$NON_EXEC" \
  "non-executable hooks count"

# --- Test 3: integrity-report.md INV-2 PASS count ≥ 20 ---
if [[ -f .claude/integrity-report.md ]]; then
  INV2_PASS=$(grep -c '^- \[PASS\]' .claude/integrity-report.md || echo 0)
  test_case "T3: INV-2 hook registration PASS" "true" "$([[ $INV2_PASS -ge 20 ]] && echo true || echo false)" \
    "PASS=$INV2_PASS (threshold ≥20)"
else
  test_case "T3: INV-2 hook registration PASS" "true" "false" "integrity-report.md missing"
fi

# --- Test 4: hook-log.jsonl populated (proves hooks fire + log) ---
if [[ -f .claude/hook-log.jsonl ]]; then
  LOG_LINES=$(wc -l < .claude/hook-log.jsonl)
  test_case "T4: hook-log populated" "true" "$([[ $LOG_LINES -ge 50 ]] && echo true || echo false)" \
    "$LOG_LINES entries (threshold ≥50)"

  # Check distinct hooks logged
  DISTINCT_HOOKS=$(grep -oE '"hook":"[^"]*"' .claude/hook-log.jsonl | sort -u | wc -l)
  test_case "T4b: distinct hooks logged" "true" "$([[ $DISTINCT_HOOKS -ge 3 ]] && echo true || echo false)" \
    "$DISTINCT_HOOKS distinct hooks (threshold ≥3)"
else
  test_case "T4: hook-log populated" "true" "false" "hook-log.jsonl missing"
fi

# --- Test 5: APL state files updating (proves SessionStart + Stop hooks fire) ---
if [[ -f .claude/apl/metrics.tsv ]]; then
  APL_AGE=$(( $(date +%s) - $(stat -c %Y .claude/apl/metrics.tsv 2>/dev/null || echo 0) ))
  # Expect updated within last 24h (86400s)
  test_case "T5: APL metrics fresh" "true" "$([[ $APL_AGE -lt 86400 ]] && echo true || echo false)" \
    "metrics.tsv age=${APL_AGE}s (threshold <86400s)"
fi

# --- Test 6: guard-read-secrets BLOCKS Glob '**/.env' (live behavior) ---
# We can't trigger Glob from bash directly — but we CAN call the hook script with mock input
# matching what CC harness sends.
HOOK_INPUT='{"tool_name":"Glob","tool_input":{"pattern":"**/.env"},"hook_event_name":"PreToolUse"}'
HOOK_OUTPUT=$(echo "$HOOK_INPUT" | bash .claude/hooks/guard-read-secrets.sh 2>&1)
HOOK_EXIT=$?
# Expect non-zero exit OR JSON output with permissionDecision=block
if [[ $HOOK_EXIT -ne 0 ]] || echo "$HOOK_OUTPUT" | grep -q 'block\|deny\|secret'; then
  test_case "T6: guard-read-secrets blocks .env" "block" "block" "exit=$HOOK_EXIT, output reasonable"
else
  test_case "T6: guard-read-secrets blocks .env" "block" "allow" "exit=$HOOK_EXIT, output=$HOOK_OUTPUT"
fi

# --- Test 7: guard-bash-write blocks `>` redirect (mock input) ---
HOOK_INPUT_BASH='{"tool_name":"Bash","tool_input":{"command":"echo test > /tmp/foo.txt"},"hook_event_name":"PreToolUse"}'
HOOK_OUTPUT_BASH=$(echo "$HOOK_INPUT_BASH" | bash .claude/hooks/guard-bash-write.sh 2>&1)
HOOK_EXIT_BASH=$?
if [[ $HOOK_EXIT_BASH -ne 0 ]] || echo "$HOOK_OUTPUT_BASH" | grep -qE 'ask|block|permissionDecision'; then
  test_case "T7: guard-bash-write asks on >" "ask" "ask" "exit=$HOOK_EXIT_BASH"
else
  test_case "T7: guard-bash-write asks on >" "ask" "allow" "exit=$HOOK_EXIT_BASH, output=${HOOK_OUTPUT_BASH:0:100}"
fi

# --- Test 8: settings.json hooks array parseable (jq) ---
if jq -e '.hooks' .claude/settings.json >/dev/null 2>&1; then
  EVENT_COUNT=$(jq '.hooks | length' .claude/settings.json)
  test_case "T8: settings.json hooks parseable" "true" "true" "$EVENT_COUNT events configured"
else
  test_case "T8: settings.json hooks parseable" "true" "false" "jq parse failed"
fi

# --- Test 9: guard-write-unified blocks Write to protected .claude/hooks/* ---
HOOK_INPUT_WU='{"tool_name":"Write","tool_input":{"file_path":".claude/hooks/test-mock.sh","content":"x"},"hook_event_name":"PreToolUse"}'
HOOK_OUTPUT_WU=$(echo "$HOOK_INPUT_WU" | bash .claude/hooks/guard-write-unified.sh 2>&1)
HOOK_EXIT_WU=$?
if [[ $HOOK_EXIT_WU -ne 0 ]] || echo "$HOOK_OUTPUT_WU" | grep -qE 'block|protected|permissionDecision'; then
  test_case "T9: guard-write-unified blocks .claude/hooks/*" "block" "block" "exit=$HOOK_EXIT_WU"
else
  test_case "T9: guard-write-unified blocks .claude/hooks/*" "block" "allow" "exit=$HOOK_EXIT_WU, out=${HOOK_OUTPUT_WU:0:80}"
fi

# --- Test 9b: guard-write-unified asks on unclassified in-repo paths ---
HOOK_INPUT_WU_UNCLASS='{"tool_name":"Write","tool_input":{"file_path":"scratch/untracked-note.md","content":"x"},"hook_event_name":"PreToolUse"}'
HOOK_OUTPUT_WU_UNCLASS=$(echo "$HOOK_INPUT_WU_UNCLASS" | bash .claude/hooks/guard-write-unified.sh 2>&1)
HOOK_EXIT_WU_UNCLASS=$?
if echo "$HOOK_OUTPUT_WU_UNCLASS" | grep -qE 'ask|UNCLASSIFIED|permissionDecision'; then
  test_case "T9b: guard-write-unified asks on unclassified path" "ask" "ask" "exit=$HOOK_EXIT_WU_UNCLASS"
else
  test_case "T9b: guard-write-unified asks on unclassified path" "ask" "allow" "exit=$HOOK_EXIT_WU_UNCLASS, out=${HOOK_OUTPUT_WU_UNCLASS:0:80}"
fi

# --- Test 9c: guard-write-unified blocks outside-repo absolute paths ---
HOOK_INPUT_WU_OUTSIDE='{"tool_name":"Write","tool_input":{"file_path":"C:/Users/lucas/outside.txt","content":"x"},"hook_event_name":"PreToolUse"}'
HOOK_OUTPUT_WU_OUTSIDE=$(echo "$HOOK_INPUT_WU_OUTSIDE" | bash .claude/hooks/guard-write-unified.sh 2>&1)
HOOK_EXIT_WU_OUTSIDE=$?
if [[ $HOOK_EXIT_WU_OUTSIDE -ne 0 ]] || echo "$HOOK_OUTPUT_WU_OUTSIDE" | grep -qE 'block|fora do repo|permissionDecision'; then
  test_case "T9c: guard-write-unified blocks outside repo" "block" "block" "exit=$HOOK_EXIT_WU_OUTSIDE"
else
  test_case "T9c: guard-write-unified blocks outside repo" "block" "allow" "exit=$HOOK_EXIT_WU_OUTSIDE, out=${HOOK_OUTPUT_WU_OUTSIDE:0:80}"
fi

# --- Test 10: guard-secrets handles git commit input (parseable + valid exit) ---
# NOTE: full BLOCK path requires .env in stage. This validates HOOK RUNS + handles git command shape.
HOOK_INPUT_SEC='{"tool_name":"Bash","tool_input":{"command":"git commit -m test"},"hook_event_name":"PreToolUse"}'
HOOK_OUTPUT_SEC=$(echo "$HOOK_INPUT_SEC" | bash .claude/hooks/guard-secrets.sh 2>&1)
HOOK_EXIT_SEC=$?
if [[ $HOOK_EXIT_SEC -eq 0 ]] || [[ $HOOK_EXIT_SEC -eq 2 ]]; then
  test_case "T10: guard-secrets handles git commit" "ran" "ran" "exit=$HOOK_EXIT_SEC (0=allow|2=block)"
else
  test_case "T10: guard-secrets handles git commit" "ran" "crashed" "exit=$HOOK_EXIT_SEC, out=${HOOK_OUTPUT_SEC:0:80}"
fi

# --- Test 11: guard-mcp-queries asks on MCP call ---
HOOK_INPUT_MCP='{"tool_name":"mcp__pubmed__search","tool_input":{"query":"test"},"hook_event_name":"PreToolUse"}'
HOOK_OUTPUT_MCP=$(echo "$HOOK_INPUT_MCP" | bash .claude/hooks/guard-mcp-queries.sh 2>&1)
HOOK_EXIT_MCP=$?
if echo "$HOOK_OUTPUT_MCP" | grep -qE 'ask|block|permissionDecision|MCP'; then
  test_case "T11: guard-mcp-queries asks on MCP call" "ask" "ask" "exit=$HOOK_EXIT_MCP"
else
  test_case "T11: guard-mcp-queries asks on MCP call" "ask" "allow" "exit=$HOOK_EXIT_MCP, out=${HOOK_OUTPUT_MCP:0:80}"
fi

# --- Test 12: guard-research-queries asks on Skill(research) ---
HOOK_INPUT_RES='{"tool_name":"Skill","tool_input":{"skill":"research"},"hook_event_name":"PreToolUse"}'
HOOK_OUTPUT_RES=$(echo "$HOOK_INPUT_RES" | bash .claude/hooks/guard-research-queries.sh 2>&1)
HOOK_EXIT_RES=$?
if echo "$HOOK_OUTPUT_RES" | grep -qE 'ask|block|permissionDecision|RESEARCH'; then
  test_case "T12: guard-research-queries asks on Skill(research)" "ask" "ask" "exit=$HOOK_EXIT_RES"
else
  test_case "T12: guard-research-queries asks on Skill(research)" "ask" "allow" "exit=$HOOK_EXIT_RES, out=${HOOK_OUTPUT_RES:0:80}"
fi

# --- Test 13: guard-lint-before-build handles npm build command (valid exit) ---
# NOTE: BLOCK path depends on lint state. This validates hook RECOGNIZES build cmd + RUNS.
HOOK_INPUT_LINT='{"tool_name":"Bash","tool_input":{"command":"npm run build:metanalise"},"hook_event_name":"PreToolUse"}'
HOOK_OUTPUT_LINT=$(echo "$HOOK_INPUT_LINT" | bash .claude/hooks/guard-lint-before-build.sh 2>&1)
HOOK_EXIT_LINT=$?
if [[ $HOOK_EXIT_LINT -eq 0 ]] || [[ $HOOK_EXIT_LINT -eq 2 ]]; then
  test_case "T13: guard-lint-before-build handles build cmd" "ran" "ran" "exit=$HOOK_EXIT_LINT (0=allow|2=block)"
else
  test_case "T13: guard-lint-before-build handles build cmd" "ran" "crashed" "exit=$HOOK_EXIT_LINT, out=${HOOK_OUTPUT_LINT:0:80}"
fi

# --- Report ---
echo ""
echo "=== Results ==="
printf "%s\n" "${RESULTS[@]}"
echo ""
echo "PASS: $PASS"
echo "FAIL: $FAIL"
echo ""
[[ $FAIL -eq 0 ]] && echo "VERDICT: hooks runtime healthy" || echo "VERDICT: $FAIL test(s) failed"
exit $FAIL
