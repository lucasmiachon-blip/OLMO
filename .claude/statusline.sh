#!/usr/bin/env bash
# Claude Code statusLine — OLMO project
# Output: OLMO | Sessao N: nome | YYYY-MM-DD (com cores ANSI)

CHANGELOG="/c/Dev/Projetos/OLMO/CHANGELOG.md"
SESSION_FILE="/c/Dev/Projetos/OLMO/.claude/.session-name"
TODAY=$(date +%Y-%m-%d)

# Read JSON from stdin (Claude Code sends context data)
INPUT=$(cat)
JQ=$(command -v jq 2>/dev/null || echo "/c/Users/lucas/AppData/Local/Microsoft/WinGet/Packages/jqlang.jq_Microsoft.Winget.Source_8wekyb3d8bbwe/jq.exe")
if [ -x "$JQ" ]; then
    PCT=$(echo "$INPUT" | "$JQ" -r '.context_window.used_percentage // 0' 2>/dev/null)
else
    PCT=$(echo "$INPUT" | grep -o '"used_percentage":[0-9.]*' | grep -o '[0-9.]*')
fi
PCT=${PCT%.*}  # truncate to integer
PCT=${PCT:-0}

# Persist context % for KPI hooks (track peak usage across session)
CTX_FILE="/c/Dev/Projetos/OLMO/.claude/apl/ctx-pct.txt"
PREV_PCT=0
[ -f "$CTX_FILE" ] && PREV_PCT=$(cat "$CTX_FILE" 2>/dev/null || echo 0)
[[ "$PREV_PCT" =~ ^[0-9]+$ ]] || PREV_PCT=0
[ "$PCT" -gt "$PREV_PCT" ] 2>/dev/null && echo "$PCT" > "$CTX_FILE"

LAST=$(grep -o 'Sessao [0-9]*' "$CHANGELOG" 2>/dev/null | head -1 | grep -o '[0-9]*')
SESSION=$(( ${LAST:-0} + 1 ))

NAME=""
[ -f "$SESSION_FILE" ] && NAME=$(cat "$SESSION_FILE" 2>/dev/null)

# Cores ANSI
BOLD='\033[1m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
GREEN='\033[1;32m'
RESET='\033[0m'

# Color context % by usage level
if [ "$PCT" -ge 80 ] 2>/dev/null; then
    PCT_COLOR='\033[1;31m'  # red
elif [ "$PCT" -ge 50 ] 2>/dev/null; then
    PCT_COLOR='\033[1;33m'  # yellow
else
    PCT_COLOR='\033[1;32m'  # green
fi

if [ -n "$NAME" ]; then
    printf "${YELLOW}OLMO${RESET} | ${CYAN}Sessao %d${RESET}: ${MAGENTA}%s${RESET} | ${PCT_COLOR}ctx %s%%${RESET} | ${GREEN}%s${RESET}" "$SESSION" "$NAME" "$PCT" "$TODAY"
else
    printf "${YELLOW}OLMO${RESET} | ${CYAN}Sessao %d${RESET} | ${PCT_COLOR}ctx %s%%${RESET} | ${GREEN}%s${RESET}" "$SESSION" "$PCT" "$TODAY"
fi
