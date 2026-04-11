#!/usr/bin/env bash
# Hook 3 — PostToolUse(Bash): Log build FAILURES to NOTES.md
# OK builds (exit_code 0) are skipped. Single node call for JSON parsing.
# Fixed S59: check tool_response.exit_code instead of non-existent PostToolUseFailure event.

INPUT=$(cat 2>/dev/null || echo '{}')

# L1 retry (S89): retry with jitter on transient node failures
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
[ -f "$SCRIPT_DIR/lib/retry-utils.sh" ] && source "$SCRIPT_DIR/lib/retry-utils.sh"

# Single node call extracts all fields (1 spawn, with L1 retry S89)
# S152 fix: strip newlines from command (multi-line -m/heredoc breaks sed line
# indexing). tool_response has no exit_code for Bash — use interrupted flag +
# stderr content as failure signals. Same bug pattern as success-capture.sh.
_parse_input() {
    echo "$INPUT" | node -e "
const d=JSON.parse(require('fs').readFileSync(0,'utf8') || '{}');
const ti=d.tool_input||{};
const tr=d.tool_response||{};
console.log((ti.command||'').replace(/[\r\n]+/g,' ').trim());
console.log(tr.interrupted===true?'1':'0');
console.log(d.cwd||'.');
console.log((tr.stderr||'').replace(/[\r\n]+/g,' ').substring(0,200));
" 2>/dev/null
}

if type retry_with_jitter &>/dev/null; then
    retry_with_jitter "_parse_input" 2 1
    PARSED="$RETRY_OUTPUT"
else
    PARSED=$(_parse_input) || exit 0
fi

CMD=$(echo "$PARSED" | sed -n '1p')
INTERRUPTED=$(echo "$PARSED" | sed -n '2p')
CWD=$(echo "$PARSED" | sed -n '3p')
STDERR=$(echo "$PARSED" | sed -n '4p')

# Filter: only build commands
if [[ "$CMD" != *"npm run build"* ]] && \
   [[ "$CMD" != *"build:"* ]] && \
   [[ "$CMD" != *"build-html.ps1"* ]]; then
    exit 0
fi

# Skip interrupted invocations or clean runs (no stderr content = success).
# Heuristic: treat stderr non-empty as failure signal (builds are noisy anyway
# but a real failure emits stack trace / "error" text).
if [ "$INTERRUPTED" = "1" ]; then
    exit 0
fi
if [ -z "$STDERR" ]; then
    exit 0
fi

# Auto-detect aula from command or git branch
AULA=""
if echo "$CMD" | grep -qo 'build:[a-z]*'; then
    AULA=$(echo "$CMD" | grep -o 'build:[a-z]*' | sed 's/build://')
fi
if [ -z "$AULA" ]; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    case "$BRANCH" in
      *cirrose*)     AULA="cirrose" ;;
      *metanalise*)  AULA="metanalise" ;;
      *grade*)       AULA="grade" ;;
      *osteo*)       AULA="osteoporose" ;;
      *)             AULA="unknown" ;;
    esac
fi

# Skip if aula unknown or dir missing
if [ "$AULA" = "unknown" ] || [ ! -d "${CWD:-.}/content/aulas/$AULA" ]; then
    exit 0
fi

NOTES="${CWD:-.}/content/aulas/$AULA/NOTES.md"
DATE=$(date '+%Y-%m-%d %H:%M')

# Create NOTES.md if it doesn't exist
if [ ! -f "$NOTES" ]; then
    printf "# NOTES — %s\n\n" "$AULA" > "$NOTES"
fi

printf "\n[%s] [BUILD] FAIL — %s | cmd: %s\n" "$DATE" "$STDERR" "$CMD" >> "$NOTES"

exit 0
