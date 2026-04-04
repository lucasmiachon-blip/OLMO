#!/usr/bin/env bash
# Hook 3 — PostToolUse(Bash): Log build FAILURES to NOTES.md
# OK builds (exit_code 0) are skipped. Single node call for JSON parsing.
# Fixed S59: check tool_response.exit_code instead of non-existent PostToolUseFailure event.

INPUT=$(cat 2>/dev/null || echo '{}')

# Single node call extracts all fields (1 spawn)
PARSED=$(node -e "
const d=JSON.parse(process.argv[1] || '{}');
const ti=d.tool_input||{};
const tr=d.tool_response||{};
console.log(ti.command||'');
console.log(tr.exit_code===undefined?'0':String(tr.exit_code));
console.log(d.cwd||'.');
console.log((tr.stderr||'').substring(0,200));
" "$INPUT" 2>/dev/null) || exit 0

CMD=$(echo "$PARSED" | sed -n '1p')
EXIT_CODE=$(echo "$PARSED" | sed -n '2p')
CWD=$(echo "$PARSED" | sed -n '3p')
STDERR=$(echo "$PARSED" | sed -n '4p')

# Filter: only build commands
if [[ "$CMD" != *"npm run build"* ]] && \
   [[ "$CMD" != *"build:"* ]] && \
   [[ "$CMD" != *"build-html.ps1"* ]]; then
    exit 0
fi

# Only log failures — OK builds are noise
if [ "$EXIT_CODE" = "0" ]; then
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

printf "\n[%s] [BUILD] FAIL (exit %s) — %s | cmd: %s\n" "$DATE" "$EXIT_CODE" "$STDERR" "$CMD" >> "$NOTES"

exit 0
