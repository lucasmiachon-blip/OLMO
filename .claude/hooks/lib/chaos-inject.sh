#!/usr/bin/env bash
# chaos-inject.sh — Antifragile L6: chaos injection library
# Source this file in hooks that need chaos injection.
#
# Usage:
#   source "$(dirname "$0")/lib/chaos-inject.sh"
#   chaos_maybe_inject   # returns 0 if injected, 1 if skipped
#
# Environment:
#   CHAOS_MODE=1          — enable chaos (default: off)
#   CHAOS_PROBABILITY=5   — percent chance per call (default: 5)
#
# Writes to:
#   /tmp/cc-chaos-log.jsonl       — injection log (one JSON line per attempt)
#   /tmp/cc-model-failures.log    — shared with L2 model-fallback-advisory
#   /tmp/cc-calls-*.txt           — shared with L3 cost-circuit-breaker

CHAOS_LOG="/tmp/cc-chaos-log.jsonl"
CHAOS_PROB="${CHAOS_PROBABILITY:-5}"

# --- Gate: is chaos enabled? ---
chaos_enabled() {
    [ "$CHAOS_MODE" = "1" ]
}

# --- Probability roll: returns 0 if chaos should fire ---
chaos_roll() {
    local roll=$(( RANDOM % 100 ))
    [ "$roll" -lt "$CHAOS_PROB" ]
}

# --- Log a chaos event to JSONL ---
chaos_log() {
    local vector="$1"
    local model="${2:-unknown}"
    local injected="${3:-true}"
    local ts
    ts=$(date -u '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date '+%Y-%m-%dT%H:%M:%S')
    printf '{"ts":"%s","vector":"%s","model":"%s","injected":%s,"probability":%s}\n' \
        "$ts" "$vector" "$model" "$injected" "$CHAOS_PROB" >> "$CHAOS_LOG"
}

# --- Vector 1: HTTP 429 rate limit ---
inject_http_429() {
    local now
    now=$(date '+%s')
    echo "${now}|opus|rate_limit" >> "/tmp/cc-model-failures.log"
    chaos_log "http_429" "opus"
}

# --- Vector 2: Socket timeout ---
inject_socket_timeout() {
    local now
    now=$(date '+%s')
    echo "${now}|unknown|overloaded" >> "/tmp/cc-model-failures.log"
    chaos_log "socket_timeout" "unknown"
}

# --- Vector 3: Model unavailable ---
inject_model_unavailable() {
    local now
    now=$(date '+%s')
    echo "${now}|opus|model_not_available" >> "/tmp/cc-model-failures.log"
    chaos_log "model_unavailable" "opus"
}

# --- Vector 4: Rapid tool calls (inflate counter by 50) ---
inject_rapid_calls() {
    local session_id
    session_id=$(date '+%Y%m%d_%H')
    local counter_file="/tmp/cc-calls-${session_id}.txt"
    local current
    current=$(cat "$counter_file" 2>/dev/null || echo 0)
    echo $((current + 50)) > "$counter_file"
    chaos_log "rapid_calls" "n/a"
}

# --- Pick a random vector and inject ---
CHAOS_VECTORS=("inject_http_429" "inject_socket_timeout" "inject_model_unavailable" "inject_rapid_calls")

chaos_pick_and_inject() {
    local idx=$(( RANDOM % ${#CHAOS_VECTORS[@]} ))
    local vector="${CHAOS_VECTORS[$idx]}"
    $vector
    # Return the vector name for caller to use
    CHAOS_LAST_VECTOR="$vector"
}

# --- Main entry point: gate + roll + inject ---
# Returns 0 if injected, 1 if skipped (not enabled or roll missed)
chaos_maybe_inject() {
    if ! chaos_enabled; then
        return 1
    fi

    if ! chaos_roll; then
        chaos_log "none" "n/a" "false"
        return 1
    fi

    chaos_pick_and_inject
    return 0
}
