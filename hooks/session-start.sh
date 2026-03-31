#!/usr/bin/env bash
# Claude Code hook: SessionStart
# Identifica projeto, data, e pede nome da sessao.
# Evento: SessionStart | Timeout: 5s | Exit: sempre 0

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_NAME=$(basename "$PROJECT_ROOT")
TODAY=$(date +%Y-%m-%d)

# Proximo numero de sessao (conta sessoes no CHANGELOG)
LAST_SESSION=$(grep -o 'Sessao [0-9]*' "$PROJECT_ROOT/CHANGELOG.md" 2>/dev/null | head -1 | grep -o '[0-9]*')
NEXT_SESSION=$((LAST_SESSION + 1))

cat <<EOF
Projeto: $PROJECT_NAME | Data: $TODAY | Sessao provavel: $NEXT_SESSION

OBRIGATORIO: antes de qualquer tarefa, pergunte ao usuario o nome/tema desta sessao (ex: "Qual o foco desta sessao?"). Use a resposta para:
1. Escrever o nome no arquivo .claude/.session-name (echo -n "nome" > .claude/.session-name) para atualizar a status line
2. Nomear a sessao no CHANGELOG e HANDOFF
EOF

exit 0
