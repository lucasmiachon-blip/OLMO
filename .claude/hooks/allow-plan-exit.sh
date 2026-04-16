#!/usr/bin/env bash
set -euo pipefail
# allow-plan-exit.sh — PreToolUse(ExitPlanMode): explicitly allow plan mode exit
# Fix for Claude Code bug: ExitPlanMode auto-denied despite being in allow list.
# The platform has a hardcoded permission gate that bypasses allow list for plan tools.
# This hook registers a PreToolUse handler so executePermissionRequestHooks finds it.
# See: github.com/anthropics/claude-code/issues/15755, #30463, #19623
# Added: S67 (2026-04-04)

# Drain stdin (hook protocol — prevent parent process stall)
cat >/dev/null 2>&1

# Return "ask" so user sees the plan and approves before exiting
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"Aprovar plano e sair do plan mode?"}}\n'
exit 0
