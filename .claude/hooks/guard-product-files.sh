#!/usr/bin/env bash
# guard-product-files.sh — ASK confirmation before editing product/infra files (all aulas + hooks/settings).
# PreToolUse: Write|Edit
# Motivation: ERRO-053 (QA pipeline bypassed), ERRO-049 (approved elements removed)
# Fixed S51: removed SPRINT_MODE bypass, fail-closed on parse errors, path canonicalization
# Fixed S58: expanded from cirrose-only to all aulas, changed from block to ask
# Fixed S193: infra guard changed from block to ask — Lucas decides, not the hook

set -u

INPUT=$(cat 2>/dev/null || true)

# Fail-closed: if we can't read input, block
if [ -z "$INPUT" ]; then
  echo "BLOQUEADO: guard-product-files não recebeu input (fail-closed)" >&2
  exit 2
fi

# Parse file_path — jq (10x faster than node, S193)
# Path normalization: \\ → /, // → /, strip ./ prefix, remove ../ traversals
FILE_PATH=$(echo "$INPUT" | jq -r '
  (.tool_input.file_path // .tool_input.path // "")
  | gsub("\\\\"; "/")
  | gsub("//"; "/")
  | gsub("[^/]+/\\.\\./"; "")
  | if startswith("./") then .[2:] else . end
' 2>/dev/null) || {
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

# INFRA GUARD (A6 — Codex S60, refined S193)
# Hook scripts: BLOCK Edit/Write (defense-in-depth against prompt injection/fast-approval).
# Deploy path: Write→temp→test→cp (guard-bash-write asks Lucas on cp).
# Settings files: ASK (need Edit access to register/update hooks).
INFRA_BLOCK_PATTERNS=(
  '(^|/)\.claude/hooks/.*\.sh$'
  '(^|/)hooks/.*\.sh$'
)

BASENAME=$(echo "$FILE_PATH" | sed 's|.*/||')
for pattern in "${INFRA_BLOCK_PATTERNS[@]}"; do
  if echo "$FILE_PATH" | grep -qE "$pattern"; then
    printf '{"error": "BLOQUEADO: %s e hook de seguranca. Deploy via Write→temp→cp (guard-bash-write pede aprovacao)."}\n' "$BASENAME"
    exit 2
  fi
done

INFRA_ASK_PATTERNS=(
  '(^|/)\.claude/settings\.local\.json$'
  '(^|/)\.claude/settings\.json$'
)

for pattern in "${INFRA_ASK_PATTERNS[@]}"; do
  if echo "$FILE_PATH" | grep -qE "$pattern"; then
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"[INFRA] %s — config de seguranca. Lucas aprova?"}}\n' "$BASENAME"
    exit 0
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
