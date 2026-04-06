#!/usr/bin/env bash
# PostToolUse: cost-circuit-breaker
# Rastreia numero de tool calls como proxy de custo.
# Avisa em WARN_THRESHOLD, injeta STOP em BLOCK_THRESHOLD (Antifragile L3).
#
# TODO S85: substituir por custo USD real quando OTel/Langfuse estiver configurado.
# (CLAUDE_CODE_ENABLE_TELEMETRY=1 + OTEL_EXPORTER_OTLP_ENDPOINT em .env)
#
# Thresholds ajustaveis via env:
#   CC_COST_WARN_CALLS  (default: 100) — aviso no contexto do agente
#   CC_COST_BLOCK_CALLS (default: 400) — injeta instrucao STOP

WARN_THRESHOLD="${CC_COST_WARN_CALLS:-100}"
BLOCK_THRESHOLD="${CC_COST_BLOCK_CALLS:-400}"

# ID de sessao: data + hora (reseta a cada hora = novo budget)
SESSION_ID=$(date '+%Y%m%d_%H')
COUNTER_FILE="/tmp/cc-calls-${SESSION_ID}.txt"

# Incrementa contador
COUNT=$(cat "$COUNTER_FILE" 2>/dev/null || echo 0)
COUNT=$((COUNT + 1))
echo "$COUNT" > "$COUNTER_FILE"

# Silencio abaixo do threshold de aviso
if [ "$COUNT" -lt "$WARN_THRESHOLD" ]; then
    exit 0
fi

# BLOCK: injeta instrucao de parada no contexto do agente
if [ "$COUNT" -ge "$BLOCK_THRESHOLD" ]; then
    printf '\n[CIRCUIT BREAKER] %d tool calls nesta sessao (limite: %d).\n' "$COUNT" "$BLOCK_THRESHOLD"
    printf 'PARE. Custo estimado: alto. Verifique o que esta sendo feito.\n'
    printf 'Para aumentar o limite: export CC_COST_BLOCK_CALLS=%d\n' "$((BLOCK_THRESHOLD + 100))"
    printf 'Para ver custo real: instalar OTel (vars em .env.example)\n\n'
    exit 0
fi

# WARN: aviso progressivo a cada 10 calls apos o threshold
REMAINDER=$(( (COUNT - WARN_THRESHOLD) % 10 ))
if [ "$REMAINDER" = "0" ]; then
    printf '\n[cost-circuit-breaker] %d tool calls nesta sessao (aviso: %d, limite: %d). Considere encerrar logo.\n\n' \
        "$COUNT" "$WARN_THRESHOLD" "$BLOCK_THRESHOLD"
fi

exit 0
