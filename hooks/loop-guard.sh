#!/usr/bin/env bash
set -euo pipefail
# loop-guard.sh — D9 mechanical gate (advisory-mode S249 D13)
# Event: PostToolUse | Matcher: Bash|Edit|Write | Timeout: 3000ms | Exit: 0 always
#
# Purpose: detect runaway loops em /debug-team flow. SOTA evidence: SWE-Effi failures
# consomem 3-4x mais tokens; "progress detection + stop rules enforced outside the model"
# (S6/S8 SOTA-C, docs/research/sota-S248-C-empirical.md).
#
# Self-disabling: only active when .claude-tmp/.debug-team-active exists. Hook em
# sessões normais retorna exit 0 imediato (<5ms overhead, KBP-23 first-turn discipline).
#
# Severidade: advisory-mode (additionalContext top-level, NÃO permissionDecision:block).
# Calibrate-before-harden per D13 + KBP-21. Hardening para block após ≥3 sessões sem FP.
#
# State file: .claude-tmp/debug-team-state.json (orchestrator SKILL.md resets per phase).
# Schema: {"bash_repeated":{<sha16>:int}, "file_edited":{<sha16>:int}, "validator_loop_iter":int}
#
# Threshold semantics: fire ONCE on threshold crossing (==N), não cumulativo, evita spam.
#
# Reference: plan S249 §Phase 1 + plan archive S248 §301-313 + post-tool-use-failure.sh idiom.

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
[[ "$(basename "$PROJECT_ROOT")" == ".claude" ]] && { echo "ERROR: PROJECT_ROOT resolved to .claude — hook aborted" >&2; exit 1; }

# === Self-disable gate (zero-overhead em sessões fora de /debug-team) ===
FLAG="$PROJECT_ROOT/.claude-tmp/.debug-team-active"
[[ -f "$FLAG" ]] || exit 0

. "$PROJECT_ROOT/hooks/lib/hook-log.sh"

# === Read event JSON from stdin (defensive — broken pipe-safe per S225 idiom) ===
INPUT=$(cat 2>/dev/null || echo '{}')

# jq required (OLMO env standard); without jq → silent skip (advisory acceptable miss)
command -v jq &>/dev/null || exit 0

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"' 2>/dev/null || echo "unknown")

# === Tool-specific payload extraction ===
PAYLOAD=""
DOMAIN=""
COUNTER_FIELD=""
THRESHOLD=0
case "$TOOL_NAME" in
  Bash)
    PAYLOAD=$(echo "$INPUT" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")
    DOMAIN="Bash command"
    COUNTER_FIELD="bash_repeated"
    THRESHOLD=4
    ;;
  Edit|Write)
    PAYLOAD=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""' 2>/dev/null || echo "")
    DOMAIN="file"
    COUNTER_FIELD="file_edited"
    THRESHOLD=5
    ;;
  *)
    exit 0
    ;;
esac

[[ -z "$PAYLOAD" ]] && exit 0

# === State file (initialize if first invocation in this session) ===
mkdir -p "$PROJECT_ROOT/.claude-tmp"
STATE="$PROJECT_ROOT/.claude-tmp/debug-team-state.json"
[[ -f "$STATE" ]] || echo '{"bash_repeated":{},"file_edited":{},"validator_loop_iter":0}' > "$STATE"

# === Hash payload for safe JSON key (avoids quote/special-char issues) ===
KEY=$(echo -n "$PAYLOAD" | sha256sum | cut -d' ' -f1 | head -c 16)

# === Atomic increment via jq + temp-rename (race acceptable em advisory mode) ===
NEW_STATE=$(jq --arg f "$COUNTER_FIELD" --arg k "$KEY" '.[$f][$k] = (.[$f][$k] // 0) + 1' "$STATE" 2>/dev/null) || exit 0
echo "$NEW_STATE" > "$STATE.tmp" 2>/dev/null && mv "$STATE.tmp" "$STATE" 2>/dev/null || exit 0

COUNT=$(echo "$NEW_STATE" | jq -r --arg f "$COUNTER_FIELD" --arg k "$KEY" '.[$f][$k]')
ITER=$(echo "$NEW_STATE" | jq -r '.validator_loop_iter // 0')

# === Build advisory (concat parts, fire only on threshold crossing == not >=) ===
ADVISORY=""

if [[ "$COUNT" == "$THRESHOLD" ]]; then
  SAFE_PAYLOAD=$(echo "$PAYLOAD" | tr -d '\n\r' | head -c 80)
  PART="Loop guard advisory (debug-team flow): ${DOMAIN} '${SAFE_PAYLOAD}' has been used ${COUNT}x. Pause + diagnose root cause antes de continuar (KBP-07 workaround-without-diagnosis, KBP-22 silent-execution-chains). State: .claude-tmp/debug-team-state.json"
  ADVISORY="$PART"
  hook_log "PostToolUse" "loop-guard" "threshold-crossed" "$KEY" "warn" "${DOMAIN} count=${COUNT} threshold=${THRESHOLD}"
fi

if [[ "$ITER" == "3" ]]; then
  PART="Loop guard advisory: validator→architect loop reached iteration 3 (cap D16). Pause + Lucas decide continuar/abortar (SOTA-C SWE-Effi S6 — failures consomem 3-4x tokens)."
  if [[ -n "$ADVISORY" ]]; then ADVISORY="${ADVISORY} | "; fi
  ADVISORY="${ADVISORY}${PART}"
  hook_log "PostToolUse" "loop-guard" "iter-cap-reached" "validator_loop_iter" "warn" "iter=${ITER}"
fi

# === Emit additionalContext (jq -nc handles JSON escaping canonically) ===
if [[ -n "$ADVISORY" ]]; then
  JSON_OUT=$(jq -nc --arg msg "$ADVISORY" '{"additionalContext":$msg}' 2>/dev/null) || JSON_OUT=""
  [[ -n "$JSON_OUT" ]] && echo "$JSON_OUT"
fi

exit 0
