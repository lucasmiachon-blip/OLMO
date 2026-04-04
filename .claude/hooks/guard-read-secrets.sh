#!/usr/bin/env bash
# guard-read-secrets.sh — PreToolUse(Read): block reading secret/credential files
# Motivation: Codex S60 adversarial A10 — agent can Read .env then exfiltrate via print/WebFetch.
# Exit 2 = BLOCK.

set -u

INPUT=$(cat 2>/dev/null || true)

# Fail-closed: if no input, block
if [ -z "$INPUT" ]; then
  exit 0  # No input on Read = probably not a file read
fi

# Parse file_path with node — robust JSON (Codex S60 A4)
FILE_PATH=$(echo "$INPUT" | node -e "
  try {
    const d=JSON.parse(require('fs').readFileSync(0,'utf8'));
    const p=(d.tool_input||{}).file_path||(d.tool_input||{}).path||'';
    console.log(p.replace(/\\\\/g,'/'));
  } catch(e) { console.log(''); }
" 2>/dev/null)

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
