#!/usr/bin/env bash
# retry-utils.sh — Antifragile L1: retry with exponential backoff + jitter
# Source this file in hooks that need transient retry.
#
# Usage:
#   source "$(dirname "$0")/lib/retry-utils.sh"
#   retry_with_jitter "node my-script.js arg1" 3 1
#
# Parameters:
#   $1 = command (string, eval'd)
#   $2 = max_attempts (default: 3)
#   $3 = base_delay_s (default: 1)
#   $4 = max_delay_s (default: 30)
#
# Returns: exit code of last attempt. stdout/stderr from last attempt in RETRY_OUTPUT.

retry_with_jitter() {
    local cmd="$1"
    local max_attempts="${2:-3}"
    local base_delay="${3:-1}"
    local max_delay="${4:-30}"

    local attempt=0
    local exit_code=1

    while [ "$attempt" -lt "$max_attempts" ]; do
        # Run command, capture output
        RETRY_OUTPUT=$(eval "$cmd" 2>&1)
        exit_code=$?

        if [ "$exit_code" -eq 0 ]; then
            return 0
        fi

        attempt=$((attempt + 1))

        # Don't sleep after the last attempt
        if [ "$attempt" -ge "$max_attempts" ]; then
            break
        fi

        # Exponential backoff: base * 2^attempt
        local exp_delay
        exp_delay=$(awk "BEGIN { d = $base_delay * (2 ^ $attempt); print (d > $max_delay) ? $max_delay : d }")

        # Jitter: multiply by random factor [0.5, 1.0)
        # $RANDOM is 0-32767; scale to 0.5-1.0
        local jitter
        jitter=$(awk "BEGIN { print 0.5 + ($RANDOM / 32767.0) * 0.5 }")

        local delay
        delay=$(awk "BEGIN { printf \"%.1f\", $exp_delay * $jitter }")

        sleep "$delay"
    done

    return "$exit_code"
}
