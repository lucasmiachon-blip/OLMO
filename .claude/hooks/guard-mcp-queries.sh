#!/usr/bin/env bash
# guard-mcp-queries.sh — PreToolUse(mcp__*)
# Forces user confirmation before any MCP tool call.
# Prevents autonomous queries to PubMed, SCite, Consensus, etc.
# Exit 0 without JSON = allow. "ask" = prompt user.

INPUT=$(cat 2>/dev/null || echo '{}')

# All MCP calls require user confirmation
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"[MCP] Query a servico externo detectada. Lucas aprova?"}}\n'
exit 0
