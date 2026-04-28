#!/usr/bin/env bash
# Claude Code statusLine — OLMO project
# Output: OLMO header + context/quota bars (ANSI)

normalize_path() {
    local path="$1"
    local drive rest lower
    path=$(printf '%s' "$path" | sed 's|\\|/|g')
    case "$path" in
        [A-Za-z]:/*)
            drive=$(printf '%s' "$path" | cut -c1)
            rest=$(printf '%s' "$path" | cut -c4-)
            lower=$(printf '%s' "$drive" | tr '[:upper:]' '[:lower:]')
            if [ -d "/mnt/$lower/$rest" ]; then
                path="/mnt/$lower/$rest"
            elif [ -d "/$lower/$rest" ]; then
                path="/$lower/$rest"
            fi
            ;;
    esac
    printf '%s' "$path"
}

PROJECT_ROOT=$(normalize_path "${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}")
CHANGELOG="$PROJECT_ROOT/CHANGELOG.md"
SESSION_FILE="$PROJECT_ROOT/.claude/.session-name"
TODAY=$(date +%Y-%m-%d)

# Read JSON from stdin (Claude Code sends context data)
INPUT=$(cat)
JQ=$(command -v jq 2>/dev/null || true)
if [ -n "$JQ" ] && [ -x "$JQ" ]; then
    PCT=$(echo "$INPUT" | "$JQ" -r '.context_window.used_percentage // 0' 2>/dev/null)
else
    PCT=$(echo "$INPUT" | grep -o '"used_percentage":[0-9.]*' | grep -o '[0-9.]*')
fi
PCT=${PCT%.*}  # truncate to integer
PCT=${PCT:-0}
[[ "$PCT" =~ ^[0-9]+$ ]] || PCT=0
[ "$PCT" -gt 100 ] 2>/dev/null && PCT=100

# Persist context % for KPI hooks (track peak usage across session)
APL_DIR="$PROJECT_ROOT/.claude/apl"
mkdir -p "$APL_DIR" 2>/dev/null || true
CTX_FILE="$APL_DIR/ctx-pct.txt"
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

bar_for_pct() {
    local pct="${1:-0}"
    local width="${2:-24}"
    local filled empty bar
    [[ "$pct" =~ ^[0-9]+$ ]] || pct=0
    [ "$pct" -gt 100 ] 2>/dev/null && pct=100
    filled=$((pct * width / 100))
    empty=$((width - filled))
    bar=""
    for _ in $(seq 1 "$filled" 2>/dev/null); do bar="${bar}#"; done
    for _ in $(seq 1 "$empty" 2>/dev/null); do bar="${bar}-"; done
    printf '[%s]' "$bar"
}

sum_calls_for_date() {
    local date_key="$1"
    local total=0 n f
    for f in /tmp/cc-calls-*_"${date_key}"_*.txt; do
        [ -f "$f" ] || continue
        n=$(cat "$f" 2>/dev/null || echo 0)
        [[ "$n" =~ ^[0-9]+$ ]] || n=0
        total=$((total + n))
    done
    echo "$total"
}

sum_calls_last_days() {
    local days="${1:-7}"
    local total=0 key n i
    for i in $(seq 0 $((days - 1))); do
        key=$(date -d "-${i} day" +%Y%m%d 2>/dev/null || echo "")
        [ -n "$key" ] || continue
        n=$(sum_calls_for_date "$key")
        total=$((total + n))
    done
    echo "$total"
}

quota_bar() {
    local used="$1"
    local limit="$2"
    local width="${3:-18}"
    local pct
    [[ "$used" =~ ^[0-9]+$ ]] || used=0
    if [[ "$limit" =~ ^[0-9]+$ ]] && [ "$limit" -gt 0 ] 2>/dev/null; then
        pct=$((used * 100 / limit))
        [ "$pct" -gt 100 ] 2>/dev/null && pct=100
        printf '%s %s/%s (%s%%)' "$(bar_for_pct "$pct" "$width")" "$used" "$limit" "$pct"
    else
        printf '%s %s/?' "$(bar_for_pct 0 "$width")" "$used"
    fi
}

# Color context % by usage level
if [ "$PCT" -ge 80 ] 2>/dev/null; then
    PCT_COLOR='\033[1;31m'  # red
elif [ "$PCT" -ge 50 ] 2>/dev/null; then
    PCT_COLOR='\033[1;33m'  # yellow
else
    PCT_COLOR='\033[1;32m'  # green
fi

TODAY_KEY=$(date +%Y%m%d)
DAILY_USED=$(sum_calls_for_date "$TODAY_KEY")
WEEKLY_USED=$(sum_calls_last_days 7)
DAILY_LIMIT="${OLMO_DAILY_QUOTA:-${CC_DAILY_QUOTA:-}}"
WEEKLY_LIMIT="${OLMO_WEEKLY_QUOTA:-${CC_WEEKLY_QUOTA:-}}"

CTX_BAR=$(bar_for_pct "$PCT" 24)
DAY_BAR=$(quota_bar "$DAILY_USED" "$DAILY_LIMIT" 18)
WEEK_BAR=$(quota_bar "$WEEKLY_USED" "$WEEKLY_LIMIT" 18)

if [ -n "$NAME" ]; then
    printf "${YELLOW}OLMO${RESET} | ${CYAN}Sessao %d${RESET}: ${MAGENTA}%s${RESET} | ${GREEN}%s${RESET}\n${PCT_COLOR}ctx  %s %s%%${RESET}\n${CYAN}cota dia %s | semana %s${RESET}" "$SESSION" "$NAME" "$TODAY" "$CTX_BAR" "$PCT" "$DAY_BAR" "$WEEK_BAR"
else
    printf "${YELLOW}OLMO${RESET} | ${CYAN}Sessao %d${RESET} | ${GREEN}%s${RESET}\n${PCT_COLOR}ctx  %s %s%%${RESET}\n${CYAN}cota dia %s | semana %s${RESET}" "$SESSION" "$TODAY" "$CTX_BAR" "$PCT" "$DAY_BAR" "$WEEK_BAR"
fi
