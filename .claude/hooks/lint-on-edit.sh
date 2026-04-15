#!/usr/bin/env bash
# PostToolUse(Write|Edit): lint-on-edit
# Se o arquivo editado for slides/*.html, roda lint-slides.js e injeta erros
# como additionalContext para o agente auto-corrigir (Antifragile L5).
#
# Silencioso em sucesso. Injeta erros no stdout em falha.
# L1 retry (S89): 1 retry with jitter on transient node failures.

INPUT=$(cat 2>/dev/null || echo '{}')

# Extrai path do arquivo editado (Write usa 'path', Edit usa 'path' tambem)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // ""' 2>/dev/null) || exit 0

# Filtro: so arquivos slides/*.html
if ! echo "$FILE_PATH" | grep -qE 'content/aulas/[a-z]+/slides/[^/]+\.html$'; then
    exit 0
fi

# Extrai nome da aula do path
AULA=$(echo "$FILE_PATH" | grep -oE 'content/aulas/[a-z]+/slides' | sed 's|content/aulas/||;s|/slides||')
if [ -z "$AULA" ]; then
    exit 0
fi

# Repo root via cwd do hook
CWD=$(echo "$INPUT" | jq -r '.cwd // "."' 2>/dev/null) || CWD="."

LINT_SCRIPT="$CWD/content/aulas/scripts/lint-slides.js"
if [ ! -f "$LINT_SCRIPT" ]; then
    exit 0
fi

# Roda lint (with retry for transient node failures — L1 S89)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SCRIPT_DIR/lib/retry-utils.sh" ]; then
    source "$SCRIPT_DIR/lib/retry-utils.sh"
    retry_with_jitter "node \"$LINT_SCRIPT\" \"$AULA\"" 2 1
    LINT_OUTPUT="$RETRY_OUTPUT"
    LINT_EXIT=$?
else
    LINT_OUTPUT=$(node "$LINT_SCRIPT" "$AULA" 2>&1)
    LINT_EXIT=$?
fi

# Sucesso: silencio total
if [ "$LINT_EXIT" = "0" ]; then
    exit 0
fi

# Falha: injeta erros como additionalContext
printf '\n[lint-on-edit] Erros em %s/slides — corrija antes de continuar:\n' "$AULA"
echo "$LINT_OUTPUT"
printf '[lint-on-edit] Fim dos erros. Corrija e re-edite o slide.\n\n'

# Exit 0: PostToolUse nao pode reverter — deixa o agente decidir
exit 0
