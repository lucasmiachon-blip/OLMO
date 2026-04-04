#!/usr/bin/env bash
# guard-lint-before-build.sh — PreToolUse(Bash): enforce lint before build
# Detects npm run build:* or build-html.ps1 and runs lint-slides.js first.
# If lint fails → BLOCK (exit 2). If lint passes → ALLOW (exit 0).
# Motivation: S60 — lint gates exist but agent ignores them (no enforcement).

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

# Check if lint-slides.js exists
LINT_SCRIPT="/c/Dev/Projetos/OLMO/content/aulas/scripts/lint-slides.js"
if [ ! -f "$LINT_SCRIPT" ]; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"lint-slides.js nao encontrado — build sem lint?"}}\n'
  exit 0
fi

# Run lint-slides.js for the aula
LINT_OUTPUT=$(cd /c/Dev/Projetos/OLMO/content/aulas && node scripts/lint-slides.js --aula "$AULA" 2>&1)
LINT_EXIT=$?

if [ $LINT_EXIT -ne 0 ]; then
  # Lint failed — BLOCK the build
  # Truncate output for display (max 200 chars)
  SHORT_OUTPUT=$(echo "$LINT_OUTPUT" | head -5 | cut -c1-200)
  printf '{"error": "BLOQUEADO: lint-slides.js falhou para %s. Corrija os erros antes de buildar.\\n%s"}\n' "$AULA" "$SHORT_OUTPUT"
  exit 2
fi

# Lint passed — allow build
exit 0
