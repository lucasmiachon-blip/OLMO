#!/usr/bin/env bash
# PreToolUse: Block writes to generated index.html files
# index.html is built by npm run build:{aula} from _manifest.js + template.
# Direct edits are overwritten on next build = lost work.
# Exit 2 = BLOCK (not just warn).

set -u

INPUT=$(cat 2>/dev/null || echo '{}')

# Parse file_path — jq (10x faster than node, S193)
# Fail-closed: can't parse → block write to be safe (Codex S60 O1/A4)
FILE_PATH=$(echo "$INPUT" | jq -r '(.tool_input.file_path // .tool_input.path // "") | gsub("\\\\"; "/")' 2>/dev/null)
if [ -z "$FILE_PATH" ] && echo "$INPUT" | grep -q '"tool_input"'; then
  printf '{"error": "BLOQUEADO: guard-generated falhou ao parsear input (fail-closed)"}\n'
  exit 2
fi

# Only block content/aulas/*/index.html (generated files)
if [[ "$FILE_PATH" == *"content/aulas/"*"/index.html" ]]; then
    printf '{"error": "BLOQUEADO: index.html e gerado por npm run build:{aula}. Editar slides/*.html ou index.template.html, depois rodar build."}\n'
    exit 2
fi

exit 0
