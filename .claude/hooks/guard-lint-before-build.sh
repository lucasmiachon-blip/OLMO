#!/usr/bin/env bash
# guard-lint-before-build.sh — PreToolUse(Bash): enforce lint before build
# Detects npm run build:* or build-html.ps1 and runs lint scripts first.
# If any lint fails → BLOCK (exit 2). If all pass → ALLOW (exit 0).
# Motivation: S60 — lint gates exist but agent ignores them (no enforcement).
# Fixed S61 O6: run all 3 linters, not just lint-slides.js.

set -u

INPUT=$(cat 2>/dev/null || echo '{}')

# Extract command — node parser (not sed, avoids JSON truncation — Codex S60 O7/A4)
CMD=$(echo "$INPUT" | node -e "
  try {
    const d=JSON.parse(require('fs').readFileSync(0,'utf8'));
    console.log((d.tool_input||{}).command||'');
  } catch(e) { process.exit(1); }
" 2>/dev/null) || {
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
AULAS_DIR="/c/Dev/Projetos/OLMO/content/aulas"
LINT_SCRIPTS=("lint-slides.js" "lint-case-sync.js" "lint-narrative-sync.js")
LINT_FAILED=0
LINT_ERRORS=""

for SCRIPT in "${LINT_SCRIPTS[@]}"; do
  if [ ! -f "$AULAS_DIR/scripts/$SCRIPT" ]; then
    continue
  fi

  LINT_OUTPUT=$(cd "$AULAS_DIR" && node "scripts/$SCRIPT" "$AULA" 2>&1)
  if [ $? -ne 0 ]; then
    LINT_FAILED=1
    SHORT_OUTPUT=$(echo "$LINT_OUTPUT" | head -5 | cut -c1-200)
    LINT_ERRORS="${LINT_ERRORS}\n--- ${SCRIPT} ---\n${SHORT_OUTPUT}"
  fi
done

if [ $LINT_FAILED -ne 0 ]; then
  printf '{"error": "BLOQUEADO: lint falhou para %s. Corrija antes de buildar.%s"}\n' "$AULA" "$LINT_ERRORS"
  exit 2
fi

# All lints passed — allow build
exit 0
