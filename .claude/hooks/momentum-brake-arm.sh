#!/usr/bin/env bash
# momentum-brake-arm.sh — PostToolUse: arm brake after any discrete action
# After Write|Edit|Bash|Agent, creates lock so enforce hook gates next action.
# Part of the structural momentum-brake system (anti KBP-01).
#
# Cycle: arm (PostToolUse) → enforce (PreToolUse) → clear (UserPromptSubmit)
# The lock persists until the user sends a new message.
# Exit 0 always — this hook never blocks.

cat >/dev/null 2>&1 || true  # consume stdin (hook protocol)

LOCK_DIR="/tmp/olmo-momentum-brake"
mkdir -p "$LOCK_DIR"
date '+%s' > "$LOCK_DIR/armed"

printf '\n[momentum-brake] Armed — proxima acao requer aprovacao.\n'
exit 0
