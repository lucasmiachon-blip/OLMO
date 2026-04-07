#!/usr/bin/env bash
# guard-product-files.sh — ASK confirmation before editing product files (all aulas).
# PreToolUse: Write|Edit
# Motivation: ERRO-053 (QA pipeline bypassed), ERRO-049 (approved elements removed)
# Fixed S51: removed SPRINT_MODE bypass, fail-closed on parse errors, path canonicalization
# Fixed S58: expanded from cirrose-only to all aulas, changed from block to ask

set -u

INPUT=$(cat 2>/dev/null || true)

# Fail-closed: if we can't read input, block
if [ -z "$INPUT" ]; then
  echo "BLOQUEADO: guard-product-files não recebeu input (fail-closed)" >&2
  exit 2
fi

# Parse file_path with node — robust JSON parsing (Codex S60 O4/A2/A4)
FILE_PATH=$(echo "$INPUT" | node -e "
  try {
    const d=JSON.parse(require('fs').readFileSync(0,'utf8'));
    const p=(d.tool_input||{}).file_path||(d.tool_input||{}).path||'';
    console.log(p.replace(/\\\\/g,'/').replace(/\/\//g,'/').replace(/[^/]+\/\.\.\//g,'').replace(/^\.\//,''));
  } catch(e) { process.exit(1); }
" 2>/dev/null) || {
  echo "BLOQUEADO: guard-product-files falhou ao parsear JSON (fail-closed)" >&2
  exit 2
}

# Fail-closed: if no path extracted but input has tool_input
if [ -z "$FILE_PATH" ]; then
  if echo "$INPUT" | grep -q '"tool_input"'; then
    echo "BLOQUEADO: guard-product-files falhou ao extrair path do input (fail-closed)" >&2
    exit 2
  fi
  exit 0
fi

# CRITICAL GUARD: Block edits to hook infrastructure (A6 — Codex S60)
# These files control the guard system itself. Editing them disables all protection.
INFRA_BLOCK_PATTERNS=(
  '(^|/)\.claude/settings\.local\.json$'
  '(^|/)\.claude/settings\.json$'
  '(^|/)\.claude/hooks/.*\.sh$'
  '(^|/)hooks/.*\.sh$'
)

for pattern in "${INFRA_BLOCK_PATTERNS[@]}"; do
  if echo "$FILE_PATH" | grep -qE "$pattern"; then
    printf '{"error": "BLOQUEADO: %s e infraestrutura de seguranca. Edite manualmente se necessario."}\n' "$(echo "$FILE_PATH" | sed 's|.*/||')"
    exit 2
  fi
done

# Product file patterns — all aulas (generalized)
PRODUCT_PATTERNS=(
  '(^|/)content/aulas/[^/]+/slides/[^/]+\.html$'
  '(^|/)content/aulas/[^/]+/[^/]+\.css$'
  '(^|/)content/aulas/shared/css/base\.css$'
  '(^|/)content/aulas/shared/js/[^/]+\.js$'
  '(^|/)content/aulas/[^/]+/slide-registry\.js$'
  '(^|/)content/aulas/[^/]+/index\.html$'
  '(^|/)content/aulas/[^/]+/slides/_manifest\.js$'
  '(^|/)content/aulas/scripts/.*\.(mjs|js)$'
  '(^|/)content/aulas/[^/]+/docs/prompts/.*\.md$'
)

for pattern in "${PRODUCT_PATTERNS[@]}"; do
  if echo "$FILE_PATH" | grep -qE "$pattern"; then
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"Produto: %s"}}\n' "$FILE_PATH"
    exit 0
  fi
done

# Not a product file — allow silently
exit 0
