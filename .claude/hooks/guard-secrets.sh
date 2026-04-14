#!/usr/bin/env bash
# guard-secrets.sh — BLOQUEIA se staged files contêm padrões de secrets reais
# Wired: PreToolUse → Bash (git commit/add)
# Comportamento: fail-closed (exit 2) em match confirmado. Falsos positivos: allowlist abaixo.
# Fixed S51: scan staged blobs (not working-tree), safe word-splitting, expanded patterns
# Fixed S194: node→jq migration (Fase 2 step 3)

set -euo pipefail

# Read stdin (PreToolUse passes JSON via stdin)
INPUT=$(cat 2>/dev/null || echo '{}')

# Só roda em comandos git commit/add — jq (10x faster than node, S194)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // ""' 2>/dev/null)

if ! echo "$CMD" | grep -qE 'git\s+(commit|add)'; then
  exit 0
fi

# Padrões de secrets a escanear
PATTERNS=(
  'sk-[a-zA-Z0-9]{20,}'                  # OpenAI keys
  'sk-ant-[a-zA-Z0-9_\-]{20,}'           # Anthropic keys
  'Bearer [a-zA-Z0-9_\-\.]{20,}'         # Auth headers (broad)
  'Authorization:\s*Bearer'               # Authorization headers
  '-----BEGIN'                             # Private keys (RSA, EC, etc.)
  'AKIA[0-9A-Z]{16}'                      # AWS access keys
  'ghp_[a-zA-Z0-9]{36}'                   # GitHub PATs
  'gho_[a-zA-Z0-9]{36}'                   # GitHub OAuth tokens
  'github_pat_[a-zA-Z0-9_]{20,}'           # GitHub fine-grained PATs
  'ntn_[a-zA-Z0-9]{40,}'                  # Notion internal tokens
  'secret_[a-zA-Z0-9]{40,}'              # Notion integration secrets
  'AIza[a-zA-Z0-9_\-]{35}'               # Google API keys
  'xox[bpars]-[a-zA-Z0-9\-]{10,}'        # Slack tokens (bot, user, app, etc.)
  'sk_live_[a-zA-Z0-9]{20,}'             # Stripe live secret keys
  'sk_test_[a-zA-Z0-9]{20,}'             # Stripe test secret keys
  '(postgres|mysql|mongodb|redis)://[^[:space:]]+'  # Database connection URIs
)

# Arquivos staged
STAGED=$(git diff --cached --name-only 2>/dev/null || true)
if [ -z "$STAGED" ]; then
  exit 0
fi

FOUND=0
WARNINGS=""

# Safe iteration: read line-by-line (handles spaces in filenames)
while IFS= read -r file; do
  [ -z "$file" ] && continue

  # Block symlinks in staged files (mode 120000 = symlink)
  if git ls-files -s "$file" 2>/dev/null | grep -q "^120"; then
    printf '{"error": "BLOQUEADO: symlink em staged files: %s"}\n' "$file"
    exit 2
  fi

  # Skip binários
  if [[ "$file" == *.png || "$file" == *.jpg || "$file" == *.woff2 || "$file" == *.pdf || "$file" == *.ico ]]; then
    continue
  fi

  # Skip .env.example (placeholders, não secrets reais)
  if [[ "$file" == ".env.example" || "$file" == *"/.env.example" ]]; then
    continue
  fi

  # Block .env files by filename (secrets by definition)
  if [[ "$file" == .env || "$file" == .env.* || "$file" == */.env || "$file" == */.env.* ]]; then
    printf '{"error": "BLOQUEADO: .env file staged: %s (use .env.example for templates)"}\n' "$file"
    exit 2
  fi

  # Read staged blob content (not working-tree)
  CONTENT=$(git show ":$file" 2>/dev/null || true)
  if [ -z "$CONTENT" ]; then
    continue
  fi

  for pattern in "${PATTERNS[@]}"; do
    if echo "$CONTENT" | grep -qE "$pattern" 2>/dev/null; then
      # Excluir referências a ${VAR} (template vars, não secrets)
      MATCH=$(echo "$CONTENT" | grep -nE "$pattern" 2>/dev/null | grep -v '\$\{' | head -3)
      if [ -n "$MATCH" ]; then
        WARNINGS="$WARNINGS\n⚠ $file:\n$MATCH\n"
        FOUND=1
      fi
    fi
  done
done <<< "$STAGED"

if [ "$FOUND" -eq 1 ]; then
  echo "⚠ guard-secrets: Possíveis secrets detectados em staged files:"
  echo -e "$WARNINGS"
  echo "BLOQUEADO: remova os secrets antes de commitar."
  echo "Se são falsos positivos, adicione o padrão à allowlist em guard-secrets.sh."
  exit 2
fi

exit 0
