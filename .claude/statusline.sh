#!/usr/bin/env bash
# Claude Code statusLine — OLMO project
# Output: OLMO | Sessao N: nome | YYYY-MM-DD (com cores ANSI)

CHANGELOG="/c/Dev/Projetos/OLMO/CHANGELOG.md"
SESSION_FILE="/c/Dev/Projetos/OLMO/.claude/.session-name"
TODAY=$(date +%Y-%m-%d)

LAST=$(grep -o 'Sessao [0-9]*' "$CHANGELOG" 2>/dev/null | head -1 | grep -o '[0-9]*')
SESSION=$(( ${LAST:-0} + 1 ))

NAME=""
[ -f "$SESSION_FILE" ] && NAME=$(cat "$SESSION_FILE" 2>/dev/null)

# Cores ANSI
BOLD='\033[1m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RESET='\033[0m'

if [ -n "$NAME" ]; then
    printf "${YELLOW}OLMO${RESET} | ${CYAN}Sessao %d: %s${RESET} | ${GREEN}%s${RESET}" "$SESSION" "$NAME" "$TODAY"
else
    printf "${YELLOW}OLMO${RESET} | ${CYAN}Sessao %d${RESET} | ${GREEN}%s${RESET}" "$SESSION" "$TODAY"
fi
