#!/usr/bin/env bash
# PreToolUse: Block writes to generated index.html files
# index.html is built by npm run build:{aula} from _manifest.js + template.
# Direct edits are overwritten on next build = lost work.
# Exit 2 = BLOCK (not just warn).

INPUT=$(cat 2>/dev/null || echo '{}')

# Parse file_path with fail-closed (Codex S60 O1/A4)
FILE_PATH=$(echo "$INPUT" | node -e "
  try {
    const d=JSON.parse(require('fs').readFileSync(0,'utf8'));
    const p=(d.tool_input||{}).file_path||(d.tool_input||{}).path||'';
    console.log(p.replace(/\\\\/g,'/'));
  } catch(e) { process.exit(1); }
" 2>/dev/null) || {
  # Fail-closed: can't parse → block write to be safe
  printf '{"error": "BLOQUEADO: guard-generated falhou ao parsear input (fail-closed)"}\n'
  exit 2
}

# Only block content/aulas/*/index.html (generated files)
if [[ "$FILE_PATH" == *"content/aulas/"*"/index.html" ]]; then
    printf '{"error": "BLOQUEADO: index.html e gerado por npm run build:{aula}. Editar slides/*.html ou index.template.html, depois rodar build."}\n'
    exit 2
fi

exit 0
