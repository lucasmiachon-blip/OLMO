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

# Drain stdin (hook protocol — prevent parent process stall)
cat >/dev/null 2>&1

WARN_THRESHOLD="${CC_COST_WARN_CALLS:-100}"
BLOCK_THRESHOLD="${CC_COST_BLOCK_CALLS:-400}"

# ID de sessao: session-scoped (gerado por session-start.sh). Fallback: timestamp unico.
SESSION_ID=$(cat /tmp/cc-session-id.txt 2>/dev/null || date '+%Y%m%d_%H%M%S')
COUNTER_FILE="/tmp/cc-calls-${SESSION_ID}.txt"
COST_BRAKE_DIR="/tmp/olmo-cost-brake"

# Incrementa contador
COUNT=$(cat "$COUNTER_FILE" 2>/dev/null || echo 0)
COUNT=$((COUNT + 1))
echo "$COUNT" > "$COUNTER_FILE"

# Silencio abaixo do threshold de aviso
if [ "$COUNT" -lt "$WARN_THRESHOLD" ]; then
    exit 0
fi

# BLOCK: arm cost brake at threshold and every 100 calls after.
# Enforcement chain: this arms → momentum-brake-enforce.sh (PreToolUse) blocks next tool
# via permissionDecision: "ask". Clear on UserPromptSubmit resets both brakes.
if [ "$COUNT" -ge "$BLOCK_THRESHOLD" ]; then
    REMAINDER_BLOCK=$(( (COUNT - BLOCK_THRESHOLD) % 100 ))
    if [ "$REMAINDER_BLOCK" -eq 0 ]; then
        mkdir -p "$COST_BRAKE_DIR"
        echo "$COUNT" > "$COST_BRAKE_DIR/armed"
        printf '\n[cost-brake] %d tool calls — brake armado. Proxima acao pedira permissao.\n' "$COUNT"
    fi
    exit 0
fi

# WARN: aviso a cada 50 calls apos warn threshold (menos spam que cada 10)
REMAINDER=$(( (COUNT - WARN_THRESHOLD) % 50 ))
if [ "$REMAINDER" = "0" ]; then
    printf '\n[cost-circuit-breaker] %d tool calls (limite: %d).\n' "$COUNT" "$BLOCK_THRESHOLD"
fi

exit 0
