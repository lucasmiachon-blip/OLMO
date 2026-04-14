#!/usr/bin/env bash
# guard-read-secrets.sh — PreToolUse(Read): block reading secret/credential files
# Motivation: Codex S60 adversarial A10 — agent can Read .env then exfiltrate via print/WebFetch.
# Exit 2 = BLOCK.

set -u

INPUT=$(cat 2>/dev/null || true)

# Fail-closed: no input = can't verify safety — ask user (not silent allow)
if [ -z "$INPUT" ]; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"guard-read-secrets: empty stdin — confirme leitura"}}\n'
  exit 0
fi

# Parse file_path — jq (10x faster than node, S193)
FILE_PATH=$(echo "$INPUT" | jq -r '(.tool_input.file_path // .tool_input.path // "") | gsub("\\\\"; "/")' 2>/dev/null)

[ -z "$FILE_PATH" ] && exit 0
BASENAME=$(echo "$FILE_PATH" | sed 's|.*/||')

# Block patterns: secrets, credentials, private keys
case "$BASENAME" in
  .env|.env.local|.env.production|.env.staging)
    printf '{"error": "BLOQUEADO: %s contem credenciais. Use .env.example como referencia."}\n' "$BASENAME"
    exit 2
    ;;
  *.pem|*.key|*.p12|*.pfx|*.jks)
    printf '{"error": "BLOQUEADO: %s e material criptografico privado."}\n' "$BASENAME"
    exit 2
    ;;
  credentials.json|service-account*.json|*_secret*.json)
    printf '{"error": "BLOQUEADO: %s contem credenciais de servico."}\n' "$BASENAME"
    exit 2
    ;;
  id_rsa|id_ed25519|id_ecdsa)
    printf '{"error": "BLOQUEADO: %s e chave SSH privada."}\n' "$BASENAME"
    exit 2
    ;;
esac

# Additional path-based checks
if echo "$FILE_PATH" | grep -qE '(^|/)\.env(\.|$)'; then
  printf '{"error": "BLOQUEADO: arquivo .env contem credenciais."}\n'
  exit 2
fi

# Allow everything else
exit 0
