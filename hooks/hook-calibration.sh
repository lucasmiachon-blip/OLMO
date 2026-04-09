#!/usr/bin/env bash
# PostToolUse(Bash): Hook Calibration — count proactive hook firings
# Logs each proactive hook firing to hook-stats.jsonl.
# Consumers: /insights (future). Append-only, gitignored.
#
# How it works: proactive hooks write a breadcrumb to /tmp/olmo-hook-fired-{name}
# when they fire. This hook checks for breadcrumbs, logs them, and cleans up.
# This avoids adding a new hook on matcher .* (which would add latency to ALL calls).
#
# Proactive hooks that drop breadcrumbs:
#   nudge-commit.sh, nudge-checkpoint.sh, coupling-proactive.sh,
#   model-fallback-advisory.sh, chaos-inject-post.sh

INPUT=$(cat 2>/dev/null || echo '{}')

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOG_FILE="$PROJECT_ROOT/.claude/hook-stats.jsonl"
BREADCRUMB_PREFIX="/tmp/olmo-hook-fired-"

# Check for any breadcrumbs
FOUND=0
for crumb in "${BREADCRUMB_PREFIX}"*; do
  [ -f "$crumb" ] || continue
  FOUND=1

  HOOK_NAME=$(basename "$crumb" | sed 's/^olmo-hook-fired-//')
  FIRE_TS=$(cat "$crumb" 2>/dev/null || echo "")
  TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

  SESSION=""
  if [ -f "$PROJECT_ROOT/.claude/.session-name" ]; then
    SESSION=$(cat "$PROJECT_ROOT/.claude/.session-name" 2>/dev/null || echo "")
  fi

  # Safe JSON via node env vars
  export HC_TS="$TIMESTAMP" HC_HOOK="$HOOK_NAME" HC_SESSION="$SESSION" HC_FIRE_TS="$FIRE_TS"
  node -e "
const e = {
  timestamp: process.env.HC_TS,
  hook: process.env.HC_HOOK,
  session: process.env.HC_SESSION,
  fired_at: process.env.HC_FIRE_TS
};
console.log(JSON.stringify(e));
" >> "$LOG_FILE" 2>/dev/null

  # Clean up breadcrumb
  rm -f "$crumb"
done

exit 0
