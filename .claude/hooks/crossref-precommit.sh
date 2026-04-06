#!/usr/bin/env bash
# crossref-precommit.sh — Git pre-commit cross-reference enforcement
# Runs via .pre-commit-config.yaml (not Claude hooks).
# Blocks commit if coupled files are not co-modified.
# Sibling of stop-crossref-check.sh (advisory) — this one is blocking.

set -euo pipefail

STAGED=$(git diff --cached --name-only 2>/dev/null || true)
[ -z "$STAGED" ] && exit 0

ERRORS=""
WARNINGS=""

# --- Check 1 (BLOCK): slide HTML staged without _manifest.js ---
SLIDE_STAGED=$(echo "$STAGED" | grep -E 'content/aulas/.+/slides/.+\.html' || true)
if [ -n "$SLIDE_STAGED" ]; then
  # For each aula with staged slides, check if its _manifest.js is also staged
  AULAS_WITH_SLIDES=$(echo "$SLIDE_STAGED" | sed -E 's|content/aulas/([^/]+)/slides/.*|\1|' | sort -u)
  while IFS= read -r aula; do
    [ -z "$aula" ] && continue
    MANIFEST_STAGED=$(echo "$STAGED" | grep "content/aulas/$aula/slides/_manifest.js" || true)
    if [ -z "$MANIFEST_STAGED" ]; then
      AFFECTED=$(echo "$SLIDE_STAGED" | grep "content/aulas/$aula/")
      ERRORS="${ERRORS}\nBLOCKED: Slide HTML staged without _manifest.js for aula '$aula':"
      ERRORS="${ERRORS}\n$(echo "$AFFECTED" | sed 's/^/  /')"
      ERRORS="${ERRORS}\n  → Update headline, clickReveals, customAnim in _manifest.js and stage it."
    fi
  done <<< "$AULAS_WITH_SLIDES"
fi

# --- Check 2 (BLOCK): evidence HTML staged without corresponding slide HTML ---
EVIDENCE_STAGED=$(echo "$STAGED" | grep -E 'content/aulas/.+/evidence/.+\.html' || true)
if [ -n "$EVIDENCE_STAGED" ]; then
  if [ -z "$SLIDE_STAGED" ]; then
    ERRORS="${ERRORS}\nBLOCKED: Evidence HTML staged but no slide HTML staged:"
    ERRORS="${ERRORS}\n$(echo "$EVIDENCE_STAGED" | sed 's/^/  /')"
    ERRORS="${ERRORS}\n  → Update citation block in corresponding slide and stage it."
  fi
fi

# --- Check 3 (WARN): _manifest.js staged without index.html ---
MANIFEST_STAGED=$(echo "$STAGED" | grep '_manifest.js' || true)
if [ -n "$MANIFEST_STAGED" ]; then
  INDEX_STAGED=$(echo "$STAGED" | grep 'content/aulas/.*/index.html' || true)
  if [ -z "$INDEX_STAGED" ]; then
    WARNINGS="${WARNINGS}\nWARNING: _manifest.js staged but index.html not rebuilt:"
    WARNINGS="${WARNINGS}\n  → Run build-html.ps1 or npm run build:{aula} before committing."
  fi
fi

# --- Check 4 (WARN): agent .md staged without HANDOFF.md ---
AGENT_STAGED=$(echo "$STAGED" | grep -E '\.claude/agents/.+\.md' || true)
if [ -n "$AGENT_STAGED" ]; then
  HANDOFF_STAGED=$(echo "$STAGED" | grep 'HANDOFF.md' || true)
  if [ -z "$HANDOFF_STAGED" ]; then
    WARNINGS="${WARNINGS}\nWARNING: Agent definition staged without HANDOFF.md:"
    WARNINGS="${WARNINGS}\n$(echo "$AGENT_STAGED" | sed 's/^/  /')"
    WARNINGS="${WARNINGS}\n  → Update HANDOFF.md agent table and stage it."
  fi
fi

# Print warnings (non-blocking)
if [ -n "$WARNINGS" ]; then
  echo -e "$WARNINGS"
fi

# Print errors and block
if [ -n "$ERRORS" ]; then
  echo -e "$ERRORS"
  echo ""
  echo "Cross-ref enforcement failed. Stage the coupled files or bypass with: git commit --no-verify"
  exit 1
fi

exit 0
