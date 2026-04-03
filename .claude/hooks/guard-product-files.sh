#!/usr/bin/env bash
# guard-product-files.sh — BLOCK (exit 2) edits to product files, forcing human confirmation.
# PreToolUse: Write|Edit|StrReplace
# Motivation: ERRO-053 (QA pipeline bypassed), ERRO-049 (approved elements removed)
# Fixed S51: removed SPRINT_MODE bypass, fail-closed on parse errors, path canonicalization

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

# Product file patterns — cirrose production files
PRODUCT_PATTERNS=(
  '(^|/)content/aulas/cirrose/slides/[^/]+\.html$'
  '(^|/)content/aulas/cirrose/(cirrose|archetypes)\.css$'
  '(^|/)content/aulas/cirrose/shared/css/base\.css$'
  '(^|/)content/aulas/cirrose/shared/js/[^/]+\.js$'
  '(^|/)content/aulas/cirrose/slide-registry\.js$'
  '(^|/)content/aulas/cirrose/index\.html$'
)

for pattern in "${PRODUCT_PATTERNS[@]}"; do
  if echo "$FILE_PATH" | grep -qE "$pattern"; then
    echo "BLOQUEADO: arquivo de produto $FILE_PATH" >&2
    exit 2
  fi
done

# Not a product file — allow silently
exit 0
