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

FILE_PATH=$(echo "$INPUT" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

# Fallback: some tools use "path" instead of "file_path"
if [ -z "$FILE_PATH" ]; then
  FILE_PATH=$(echo "$INPUT" | sed -n 's/.*"path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
fi

# Fail-closed: if no path extracted, block rather than silently allow
if [ -z "$FILE_PATH" ]; then
  # Check if input looks like a file operation (has JSON with tool_input)
  if echo "$INPUT" | grep -q '"tool_input"'; then
    echo "BLOQUEADO: guard-product-files falhou ao extrair path do input (fail-closed)" >&2
    exit 2
  fi
  # Not a file operation at all — allow
  exit 0
fi

# Normalize: backslashes → forward slashes, collapse //, resolve ../ sequences
FILE_PATH=$(echo "$FILE_PATH" | tr '\\' '/' | sed 's|//|/|g')
# Canonicalize: remove ../ traversals
FILE_PATH=$(echo "$FILE_PATH" | sed -E 's|[^/]+/\.\./||g; s|^\./||')

# CRITICAL GUARD: Block edits to hook infrastructure (A6 — Codex S60)
# These files control the guard system itself. Editing them disables all protection.
INFRA_BLOCK_PATTERNS=(
  '(^|/)\.claude/settings\.local\.json$'
  '(^|/)\.claude/settings\.json$'
  '(^|/)\.claude/hooks/[^/]+\.sh$'
  '(^|/)hooks/[^/]+\.sh$'
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
)

for pattern in "${PRODUCT_PATTERNS[@]}"; do
  if echo "$FILE_PATH" | grep -qE "$pattern"; then
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"Produto: %s"}}\n' "$FILE_PATH"
    exit 0
  fi
done

# Not a product file — allow silently
exit 0
