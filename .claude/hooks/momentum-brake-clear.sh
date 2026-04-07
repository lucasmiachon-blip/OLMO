#!/usr/bin/env bash
# momentum-brake-clear.sh — UserPromptSubmit: reset brake when user speaks
# When Lucas sends a message, the brake clears — agent can act freely until next arm.
# Part of the structural momentum-brake system (anti KBP-01).

cat >/dev/null 2>&1 || true  # consume stdin (hook protocol)

rm -f /tmp/olmo-momentum-brake/armed
rm -f /tmp/olmo-cost-brake/armed
exit 0
