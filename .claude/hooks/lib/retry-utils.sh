#!/usr/bin/env bash
# retry-utils.sh -- Antifragile L1: retry with exponential backoff + jitter
# Source this file in hooks that need transient retry.
#
# Usage:
#   source "$(dirname "$0")/lib/retry-utils.sh"
#   retry_with_jitter 3 1 -- node my-script.js arg1
#
# Parameters:
#   $1 = max_attempts (default: 3)
#   $2 = base_delay_s (default: 1)
#   -- = separator
#   remaining args = command + arguments (executed as array, no eval)
#
# Returns: exit code of last attempt. stdout/stderr from last attempt in RETRY_OUTPUT.

retry_with_jitter() {
    local max_attempts="${1:-3}"
    local base_delay="${2:-1}"
    local max_delay=30
    shift 2 2>/dev/null

    # Skip '--' separator if present
    [[ "${1:-}" == "--" ]] && shift

    # Remaining args are the command
    local cmd_args=("$@")

    if [ ${#cmd_args[@]} -eq 0 ]; then
        echo "retry_with_jitter: no command provided" >&2
        return 1
    fi

    local attempt=0
    local exit_code=1

    while [ "$attempt" -lt "$max_attempts" ]; do
        # Run command as array -- no eval, no shell reinterpretation
        # && ok || fail -- safe under set -e (|| neutralizes errexit)
        RETRY_OUTPUT=$("${cmd_args[@]}" 2>&1) && exit_code=0 || exit_code=$?

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
