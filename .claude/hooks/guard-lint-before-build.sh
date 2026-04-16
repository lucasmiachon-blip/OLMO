#!/usr/bin/env bash
# guard-lint-before-build.sh — PreToolUse(Bash): enforce lint before build
# Detects npm run build:* or build-html.ps1 and runs lint scripts first.
# If any lint fails → BLOCK (exit 2). If all pass → ALLOW (exit 0).
# Motivation: S60 — lint gates exist but agent ignores them (no enforcement).
# Fixed S61 O6: run all 3 linters, not just lint-slides.js.

set -euo pipefail

# L1 retry (S89): retry with jitter on transient node failures
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
[ -f "$SCRIPT_DIR/lib/retry-utils.sh" ] && source "$SCRIPT_DIR/lib/retry-utils.sh"

INPUT=$(cat 2>/dev/null || echo '{}')

# Extract command — jq parser (S198: migrated from node -e)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // ""' 2>/dev/null) || {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"JSON parse falhou — confirme build"}}\n'
  exit 0
}

[ -z "$CMD" ] && exit 0

# Only trigger on build commands (expanded: npm run build, vite build, npx vite — Codex S60 A9)
if ! echo "$CMD" | grep -qE '(npm run build(:|$)|vite build|npx vite build|build-html\.ps1)'; then
  exit 0
fi

# Extract aula name from command
# npm run build:cirrose → cirrose
# build-html.ps1 in cirrose/scripts/ → cirrose
AULA=""
if echo "$CMD" | grep -qE 'npm run build:'; then
  AULA=$(echo "$CMD" | sed -n 's/.*npm run build:\([a-z_-]*\).*/\1/p')
fi
if [ -z "$AULA" ] && echo "$CMD" | grep -qE 'build-html\.ps1'; then
  AULA=$(echo "$CMD" | sed -n 's|.*\([a-z_-]*\)/scripts/build-html\.ps1.*|\1|p')
fi

# If aula extraction fails, warn but don't block (fail-open on parse errors for build)
if [ -z "$AULA" ]; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"Build detectado mas nao consegui extrair aula — rodar lint manualmente?"}}\n'
  exit 0
fi

# Run all lint scripts for the aula (O6 fix: was only lint-slides.js)
# S198: resolve path relative to script location instead of hardcoded (S196 S6 fix)
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
AULAS_DIR="$REPO_ROOT/content/aulas"
LINT_SCRIPTS=("lint-slides.js" "lint-case-sync.js")
LINT_FAILED=0
LINT_ERRORS=""

for SCRIPT in "${LINT_SCRIPTS[@]}"; do
  if [ ! -f "$AULAS_DIR/scripts/$SCRIPT" ]; then
    continue
  fi

  if type retry_with_jitter &>/dev/null; then
    (cd "$AULAS_DIR" && retry_with_jitter 3 1 -- node "scripts/$SCRIPT" "$AULA") && LINT_RC=0 || LINT_RC=$?
    LINT_OUTPUT="${RETRY_OUTPUT:-}"
  else
    LINT_OUTPUT=$(cd "$AULAS_DIR" && node "scripts/$SCRIPT" "$AULA" 2>&1) && LINT_RC=0 || LINT_RC=$?
  fi
  if [ $LINT_RC -ne 0 ]; then
    LINT_FAILED=1
    SHORT_OUTPUT=$(echo "$LINT_OUTPUT" | head -5 | cut -c1-200)
    LINT_ERRORS="${LINT_ERRORS}\n--- ${SCRIPT} ---\n${SHORT_OUTPUT}"
  fi
done

if [ $LINT_FAILED -ne 0 ]; then
  # Sanitize lint errors: escape quotes and newlines to prevent JSON injection (M-11)
  SAFE_ERRORS=$(echo -e "$LINT_ERRORS" | tr '"' "'" | tr '\n' ' ' | cut -c1-500)
  printf '{"error": "BLOQUEADO: lint falhou para %s. Corrija antes de buildar. %s"}\n' "$AULA" "$SAFE_ERRORS"
  exit 2
fi

# All lints passed — allow build
exit 0
