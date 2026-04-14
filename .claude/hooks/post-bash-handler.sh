#!/usr/bin/env bash
# PostToolUse(Bash): Unified handler — build monitor + success capture + hook calibration
# Replaces: build-monitor.sh, success-capture.sh, hook-calibration.sh
# S195 Fase 2 step 4. 0 node spawns, 1 jq parse.

INPUT=$(cat 2>/dev/null || echo '{}')

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
[ -z "$PROJECT_ROOT" ] && PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

# --- Parse stdin (1 jq call replaces 3 node calls) ---
PARSED=$(echo "$INPUT" | jq -r '[
  (.tool_input.command // "" | gsub("[\\r\\n]+"; " ") | sub("^[[:space:]]+"; "") | sub("[[:space:]]+$"; "")),
  (if .tool_response.interrupted == true then "1" else "0" end),
  (.cwd // "."),
  (.tool_response.stderr // "" | gsub("[\\r\\n]+"; " ") | .[0:200])
] | join("\n")' 2>/dev/null) || exit 0

CMD=$(echo "$PARSED" | sed -n '1p')
INTERRUPTED=$(echo "$PARSED" | sed -n '2p')
CWD=$(echo "$PARSED" | sed -n '3p')
STDERR=$(echo "$PARSED" | sed -n '4p')

# Shared
TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
SESSION=""
[ -f "$PROJECT_ROOT/.claude/.session-name" ] && SESSION=$(cat "$PROJECT_ROOT/.claude/.session-name" 2>/dev/null || echo "")

# ============================================================
# DISPATCH 1: Build failure monitor (was build-monitor.sh)
# Gate: npm run build | build:* | build-html.ps1
# ============================================================
if [[ "$CMD" == *"npm run build"* ]] || [[ "$CMD" == *"build:"* ]] || [[ "$CMD" == *"build-html.ps1"* ]]; then
  if [ "$INTERRUPTED" != "1" ] && [ -n "$STDERR" ]; then
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
    if [ "$AULA" != "unknown" ] && [ -d "${CWD:-.}/content/aulas/$AULA" ]; then
      NOTES="${CWD:-.}/content/aulas/$AULA/NOTES.md"
      DATE=$(date '+%Y-%m-%d %H:%M')
      [ ! -f "$NOTES" ] && printf "# NOTES — %s\n\n" "$AULA" > "$NOTES"
      printf "\n[%s] [BUILD] FAIL — %s | cmd: %s\n" "$DATE" "$STDERR" "$CMD" >> "$NOTES"
    fi
  fi
fi

# ============================================================
# DISPATCH 2: Commit success capture (was success-capture.sh)
# Gate: git commit + not interrupted
# ============================================================
if [[ "$CMD" == *"git commit"* ]] && [ "$INTERRUPTED" != "1" ]; then
  LOG_FILE="$PROJECT_ROOT/.claude/success-log.jsonl"
  HASH=$(git -C "$PROJECT_ROOT" log -1 --format=%h 2>/dev/null || echo "unknown")
  MSG=$(git -C "$PROJECT_ROOT" log -1 --format=%s 2>/dev/null || echo "")
  FILES_CHANGED=$(git -C "$PROJECT_ROOT" diff --name-only HEAD~1 HEAD 2>/dev/null | wc -l | tr -d ' ')
  [[ "$FILES_CHANGED" =~ ^[0-9]+$ ]] || FILES_CHANGED=0

  jq -cn --arg ts "$TIMESTAMP" --arg session "$SESSION" --arg hash "$HASH" \
    --argjson files "$FILES_CHANGED" --arg msg "$MSG" \
    '{timestamp: $ts, session: $session, commit: $hash, files_changed: $files, message: $msg}' \
    >> "$LOG_FILE" 2>/dev/null
fi

# ============================================================
# DISPATCH 3: Hook calibration breadcrumbs (was hook-calibration.sh)
# Always runs: checks /tmp/olmo-hook-fired-* breadcrumbs
# ============================================================
STATS_FILE="$PROJECT_ROOT/.claude/hook-stats.jsonl"
BREADCRUMB_PREFIX="/tmp/olmo-hook-fired-"

for crumb in "${BREADCRUMB_PREFIX}"*; do
  [ -f "$crumb" ] || continue
  HOOK_NAME=$(basename "$crumb" | sed 's/^olmo-hook-fired-//')
  FIRE_TS=$(cat "$crumb" 2>/dev/null || echo "")

  jq -cn --arg ts "$TIMESTAMP" --arg hook "$HOOK_NAME" \
    --arg session "$SESSION" --arg fire_ts "$FIRE_TS" \
    '{timestamp: $ts, hook: $hook, session: $session, fired_at: $fire_ts}' \
    >> "$STATS_FILE" 2>/dev/null

  rm -f "$crumb"
done

exit 0
