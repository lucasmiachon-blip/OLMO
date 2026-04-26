#!/usr/bin/env bash
# guard-read-secrets.sh — PreToolUse(Read|Grep|Glob): block reading/searching secret/credential files
# Motivation: Codex S60 adversarial A10 — agent can Read .env then exfiltrate via print/WebFetch.
# S256 B.3 D3 expansion: Glob '**/.env' or Grep 'AWS_KEY' *.env* bypassed Read-only matcher.
# Now matches Read|Grep|Glob (settings.json) + Grep pattern keyword check (BEGIN RSA, AWS_*, etc).
# Defense-in-depth pair: permissions.deny tem credential path patterns (declarativo) — hook
# este eh o procedural layer (KBP-26 prova permissions falha silently em CC ≥2.1.113).
# Exit 2 = BLOCK.

set -euo pipefail

INPUT=$(cat 2>/dev/null || true)

# Fail-closed: no input = can't verify safety — ask user (not silent allow)
if [ -z "$INPUT" ]; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"guard-read-secrets: empty stdin — confirme leitura"}}\n'
  exit 0
fi

# S256 B.3: detect tool_name; Read uses file_path, Glob uses pattern, Grep uses pattern + path
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""' 2>/dev/null)

# S256 B.3: Grep additional check — pattern (regex) com credential keywords = block
# (independent of file path — agent could Grep credentials from /tmp or /etc)
if [ "$TOOL_NAME" = "Grep" ]; then
  GREP_PATTERN=$(echo "$INPUT" | jq -r '.tool_input.pattern // ""' 2>/dev/null)
  if echo "$GREP_PATTERN" | grep -qiE '(BEGIN[[:space:]]+RSA|BEGIN[[:space:]]+PRIVATE[[:space:]]+KEY|BEGIN[[:space:]]+OPENSSH|AWS_SECRET|AWS_ACCESS_KEY|API[_-]TOKEN|GITHUB_TOKEN|PRIVATE_KEY=|GHCR_PAT)'; then
    printf '{"error": "BLOQUEADO: Grep pattern contem credential keyword (AWS/API/SSH/PRIVATE KEY). Use Lucas approval explicit se intencional."}\n'
    exit 2
  fi
fi

# Parse file_path/pattern — jq (10x faster than node, S193)
case "$TOOL_NAME" in
  Glob)
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.pattern // ""' 2>/dev/null | sed 's|\\|/|g')
    ;;
  Grep|Read|*)
    FILE_PATH=$(echo "$INPUT" | jq -r '(.tool_input.file_path // .tool_input.path // "") | gsub("\\\\"; "/")' 2>/dev/null)
    ;;
esac

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
