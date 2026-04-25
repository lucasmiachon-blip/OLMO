#!/usr/bin/env bash
set -euo pipefail
# Claude Code hook: PostCompact
# Re-injects HANDOFF + session context after mid-session compaction.
# Structural fix for KBP-02 (context overflow → lost decisions).
# Evento: PostCompact | Timeout: 3000ms | Exit: sempre 0

# Drain stdin (hook protocol)
cat >/dev/null 2>&1

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
[[ "$(basename "$PROJECT_ROOT")" == ".claude" ]] && { echo "ERROR: PROJECT_ROOT resolved to .claude -- hook aborted" >&2; exit 1; }
SESSION_NAME=$(cat "$PROJECT_ROOT/.claude/.session-name" 2>/dev/null || echo "(sem nome)")

MSG="[POST-COMPACT] Contexto compactado. OBRIGATORIO: re-ler HANDOFF.md e CLAUDE.md agora. Sessao: $SESSION_NAME. NAO confiar em memoria pre-compaction — verificar decisoes ativas."

jq -cn --arg msg "$MSG" '{systemMessage:$msg}'
exit 0
