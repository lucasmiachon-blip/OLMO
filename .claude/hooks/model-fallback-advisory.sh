#!/usr/bin/env bash
# PostToolUse: model-fallback-advisory (Antifragile L2)
# Detects model-related errors in tool output and suggests downgrade.
# S89 upgrade: state tracking + per-model circuit breaker.
#   - Tracks failures to /tmp/cc-model-failures.log
#   - Model fails 2x in 5min → marked "degraded" → STRONG advisory
# Fires on Agent and Bash tool responses.
#
# Fallback chain: Opus -> Sonnet -> Haiku
# Patterns: overloaded (529), rate_limit (429), model_not_available, context_length_exceeded

INPUT=$(cat 2>/dev/null || echo '{}')

# Extract tool_response as string (first 2000 chars to avoid parsing huge outputs)
RESPONSE=$(echo "$INPUT" | node -e "
const d=JSON.parse(require('fs').readFileSync(0,'utf8') || '{}');
const tr=d.tool_response||{};
const s=typeof tr==='string'?tr:JSON.stringify(tr);
console.log(s.substring(0,2000));
" 2>/dev/null) || exit 0

# No response = nothing to check
[ -z "$RESPONSE" ] && exit 0

# --- State tracking (S89) ---
FAILURE_LOG="/tmp/cc-model-failures.log"
WINDOW_SECONDS=300  # 5 minute window for circuit breaker
FAILURE_THRESHOLD=2 # failures before marking degraded

# Detect which model caused the error (best-effort from context)
detect_model() {
    local model="unknown"
    if echo "$RESPONSE" | grep -qi "opus"; then
        model="opus"
    elif echo "$RESPONSE" | grep -qi "sonnet"; then
        model="sonnet"
    elif echo "$RESPONSE" | grep -qi "haiku"; then
        model="haiku"
    fi
    echo "$model"
}

# Count recent failures for a model within the time window
count_recent_failures() {
    local model="$1"
    local cutoff
    cutoff=$(date -d "-${WINDOW_SECONDS} seconds" '+%s' 2>/dev/null || date -v-${WINDOW_SECONDS}S '+%s' 2>/dev/null || echo 0)
    if [ ! -f "$FAILURE_LOG" ]; then
        echo 0
        return
    fi
    awk -v model="$model" -v cutoff="$cutoff" -F'|' '
        $2 == model && $1 >= cutoff { count++ }
        END { print count+0 }
    ' "$FAILURE_LOG"
}

# Record a failure
record_failure() {
    local model="$1"
    local error_type="$2"
    local now
    now=$(date '+%s')
    echo "${now}|${model}|${error_type}" >> "$FAILURE_LOG"
    # Prune entries older than 1 hour to prevent log bloat
    if [ -f "$FAILURE_LOG" ]; then
        local one_hour_ago
        one_hour_ago=$((now - 3600))
        awk -F'|' -v cutoff="$one_hour_ago" '$1 >= cutoff' "$FAILURE_LOG" > "${FAILURE_LOG}.tmp" && mv "${FAILURE_LOG}.tmp" "$FAILURE_LOG"
    fi
}

# Get next model in fallback chain
next_model() {
    case "$1" in
        opus)   echo "sonnet" ;;
        sonnet) echo "haiku" ;;
        haiku)  echo "(nenhum — haiku e o ultimo)" ;;
        *)      echo "sonnet" ;;
    esac
}

# --- Pattern matching — case insensitive ---
MATCH=""
ERROR_TYPE=""
if echo "$RESPONSE" | grep -qi "overloaded_error\|overloaded"; then
    MATCH="modelo sobrecarregado (overloaded/529)"
    ERROR_TYPE="overloaded"
elif echo "$RESPONSE" | grep -qi "rate_limit\|rate.limit\|429\|too.many.requests"; then
    MATCH="rate limit atingido (429)"
    ERROR_TYPE="rate_limit"
elif echo "$RESPONSE" | grep -qi "model_not_available\|model.not.found\|service_unavailable"; then
    MATCH="modelo indisponivel"
    ERROR_TYPE="model_not_available"
elif echo "$RESPONSE" | grep -qi "context_length_exceeded\|context.too.long\|maximum.context"; then
    MATCH="contexto excedeu limite do modelo"
    ERROR_TYPE="context_exceeded"
fi

# No match = silent exit
[ -z "$MATCH" ] && exit 0

# --- Record failure and check circuit breaker ---
MODEL=$(detect_model)
record_failure "$MODEL" "$ERROR_TYPE"
RECENT_FAILURES=$(count_recent_failures "$MODEL")
FALLBACK=$(next_model "$MODEL")

# Breadcrumb for hook-calibration.sh
date '+%s' > "/tmp/olmo-hook-fired-model-fallback"

if [ "$RECENT_FAILURES" -ge "$FAILURE_THRESHOLD" ]; then
    # Circuit breaker OPEN — strong advisory
    printf '\n[model-fallback] DEGRADADO: %s falhou %sx em %ss.\n' "$MODEL" "$RECENT_FAILURES" "$WINDOW_SECONDS"
    printf 'Erro: %s.\n' "$MATCH"
    printf 'ACAO RECOMENDADA: usar model: %s para proximas invocacoes.\n' "$FALLBACK"
    printf 'Cadeia de fallback: Opus -> Sonnet -> Haiku.\n'
    if [ "$ERROR_TYPE" = "rate_limit" ]; then
        printf 'Rate limit: aguardar 30-60s antes de re-invocar.\n'
    elif [ "$ERROR_TYPE" = "context_exceeded" ]; then
        printf 'Contexto excedido: /clear ou reduzir escopo antes de continuar.\n'
    fi
    printf '[model-fallback] Failures log: %s\n\n' "$FAILURE_LOG"
else
    # First failure — standard advisory
    printf '\n[model-fallback] Detectado: %s.\n' "$MATCH"
    printf 'Cadeia de fallback: Opus -> Sonnet -> Haiku.\n'
    printf 'Acao sugerida:\n'
    printf '  1. Se agente falhou: re-invocar com model: %s\n' "$FALLBACK"
    printf '  2. Se contexto excedido: /clear ou reduzir escopo\n'
    printf '  3. Se rate limit: aguardar 30s e tentar novamente\n\n'
fi

exit 0
