#!/usr/bin/env bash
# guard-secrets-precommit.sh — Git pre-commit version of guard-secrets.sh
# Runs via .pre-commit-config.yaml (not Claude hooks).
# Scans staged blobs for secret patterns. Blocks commit on match.

set -euo pipefail

PATTERNS=(
  'sk-[a-zA-Z0-9]{20,}'
  'sk-ant-[a-zA-Z0-9_\-]{20,}'
  'Bearer [a-zA-Z0-9_\-\.]{20,}'
  '-----BEGIN'
  'AKIA[0-9A-Z]{16}'
  'ghp_[a-zA-Z0-9]{36}'
  'gho_[a-zA-Z0-9]{36}'
  'github_pat_[a-zA-Z0-9_]{20,}'
  'ntn_[a-zA-Z0-9]{40,}'
  'secret_[a-zA-Z0-9]{40,}'
  'AIza[a-zA-Z0-9_\-]{35}'
  'xox[bpars]-[a-zA-Z0-9\-]{10,}'
  'sk_live_[a-zA-Z0-9]{20,}'
  'sk_test_[a-zA-Z0-9]{20,}'
  'pplx-[a-zA-Z0-9]{20,}'
  '(postgres|mysql|mongodb|redis)://[^[:space:]]+'
)

STAGED=$(git diff --cached --name-only 2>/dev/null || true)
[ -z "$STAGED" ] && exit 0

FOUND=0
WARNINGS=""

while IFS= read -r file; do
  [ -z "$file" ] && continue
  [[ "$file" == *.png || "$file" == *.jpg || "$file" == *.woff2 || "$file" == *.pdf || "$file" == *.ico ]] && continue
  [[ "$file" == ".env.example" || "$file" == *"/.env.example" ]] && continue
  [[ "$file" == .env || "$file" == .env.* || "$file" == */.env || "$file" == */.env.* ]] && { echo "BLOCKED: .env file staged: $file"; exit 1; }

  CONTENT=$(git show ":$file" 2>/dev/null || true)
  [ -z "$CONTENT" ] && continue

  for pattern in "${PATTERNS[@]}"; do
    if echo "$CONTENT" | grep -qE "$pattern" 2>/dev/null; then
      MATCH=$(echo "$CONTENT" | grep -nE "$pattern" 2>/dev/null | grep -v '\$\{' | head -3)
      if [ -n "$MATCH" ]; then
        WARNINGS="$WARNINGS\n$file:\n$MATCH\n"
        FOUND=1
      fi
    fi
  done
done <<< "$STAGED"

if [ "$FOUND" -eq 1 ]; then
  echo "BLOCKED: Possible secrets detected in staged files:"
  echo -e "$WARNINGS"
  echo "Remove secrets before committing. False positive? Add pattern to allowlist."
  exit 1
fi

exit 0
