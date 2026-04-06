#!/usr/bin/env bash
# PostToolUse: model-fallback-advisory (Antifragile L2)
# Detects model-related errors in tool output and suggests downgrade.
# Advisory only — does NOT auto-switch models (Claude Code limitation).
# Fires on Agent and Bash tool responses.
#
# Fallback chain: Opus -> Sonnet -> Haiku
# Patterns: overloaded (529), rate_limit (429), model_not_available, context_length_exceeded

INPUT=$(cat 2>/dev/null || echo '{}')

# Extract tool_response as string (first 2000 chars to avoid parsing huge outputs)
RESPONSE=$(node -e "
const d=JSON.parse(process.argv[1] || '{}');
const tr=d.tool_response||{};
const s=typeof tr==='string'?tr:JSON.stringify(tr);
console.log(s.substring(0,2000));
" "$INPUT" 2>/dev/null) || exit 0

# No response = nothing to check
[ -z "$RESPONSE" ] && exit 0

# Pattern matching — case insensitive
MATCH=""
if echo "$RESPONSE" | grep -qi "overloaded_error\|overloaded"; then
    MATCH="modelo sobrecarregado (overloaded/529)"
elif echo "$RESPONSE" | grep -qi "rate_limit\|rate.limit\|429\|too.many.requests"; then
    MATCH="rate limit atingido (429)"
elif echo "$RESPONSE" | grep -qi "model_not_available\|model.not.found\|service_unavailable"; then
    MATCH="modelo indisponivel"
elif echo "$RESPONSE" | grep -qi "context_length_exceeded\|context.too.long\|maximum.context"; then
    MATCH="contexto excedeu limite do modelo"
fi

# No match = silent exit
[ -z "$MATCH" ] && exit 0

# Advisory output — injected into agent context
printf '\n[model-fallback] Detectado: %s.\n' "$MATCH"
printf 'Cadeia de fallback: Opus -> Sonnet -> Haiku.\n'
printf 'Acao sugerida:\n'
printf '  1. Se agente falhou: re-invocar com model: sonnet (ou haiku)\n'
printf '  2. Se contexto excedido: /clear ou reduzir escopo\n'
printf '  3. Se rate limit: aguardar 30s e tentar novamente\n\n'

exit 0
