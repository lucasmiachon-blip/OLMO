#!/usr/bin/env bash
# Claude Code hook: PostCompact
# Re-injects HANDOFF + session context after mid-session compaction.
# Structural fix for KBP-02 (context overflow → lost decisions).
# Evento: PostCompact | Timeout: 3000ms | Exit: sempre 0

# Drain stdin (hook protocol)
cat >/dev/null 2>&1

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SESSION_NAME=$(cat "$PROJECT_ROOT/.claude/.session-name" 2>/dev/null || echo "(sem nome)")

MSG="[POST-COMPACT] Contexto compactado. OBRIGATORIO: re-ler HANDOFF.md e CLAUDE.md agora. Sessao: $SESSION_NAME. NAO confiar em memoria pre-compaction — verificar decisoes ativas."

echo "{\"hookSpecificOutput\":{\"message\":\"$MSG\"}}"
exit 0
