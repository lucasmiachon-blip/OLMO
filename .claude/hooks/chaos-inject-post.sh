#!/usr/bin/env bash
set -euo pipefail
# PostToolUse: chaos-inject-post (Antifragile L6)
# Fires on Agent|Bash tool responses. When CHAOS_MODE=1, randomly injects
# fake failures into /tmp state files that L2/L3 defense hooks read.
#
# Must be registered BEFORE model-fallback-advisory.sh in settings.json
# so injected state is visible to defense hooks on the same cycle.
# (S255 Phase 3 A.1 fix: was "settings.local.json" — drift, real registration in settings.json)
#
# Activation: CHAOS_MODE=1 (default: off — opt-in by design preserves capability w/ zero overhead).
# S256 B.1 D1 Lucas decision: opt-in document (vs always-on or remove). Antifragile L6
# capability available but not auto-activated em produção (zero noise default).
#
# Usage examples:
#   CHAOS_MODE=1 claude code                       # session-scoped opt-in (recommended)
#   CHAOS_MODE=1 CHAOS_PROBABILITY=10 claude code  # higher chaos rate (testing)
#   export CHAOS_MODE=1                            # shell-scoped (rare; persists env)
#
# Probability: CHAOS_PROBABILITY=5 (default: 5%)
# Vectors: see .claude/hooks/lib/chaos-inject.sh

# Consume stdin (required by hook protocol, even if unused)
cat > /dev/null 2>&1

# Gate: quick exit if chaos disabled (most common path)
[ "${CHAOS_MODE:-}" != "1" ] && exit 0

# Source the chaos library
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/lib/chaos-inject.sh"

# Attempt injection
if chaos_maybe_inject; then
    # Notify the agent that chaos was injected (visible in context)
    printf '\n[CHAOS-L6] Injected: %s (probability: %s%%)\n' \
        "$CHAOS_LAST_VECTOR" "$CHAOS_PROB"
fi

exit 0
