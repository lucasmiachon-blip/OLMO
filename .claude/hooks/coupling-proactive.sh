#!/usr/bin/env bash
# PostToolUse(Edit): coupling-proactive — Detects stale coupled files
# When editing slide HTML, checks if evidence is older.
# When editing evidence HTML, checks if slide exists.
# Advisory only — never blocks.

# Read stdin to get the tool input (contains file_path)
INPUT=$(cat 2>/dev/null || true)

# Extract file path from the Edit tool input
FILE_PATH=$(echo "$INPUT" | grep -oP '"file_path"\s*:\s*"([^"]+)"' | head -1 | sed 's/.*"file_path"\s*:\s*"//;s/"$//' || true)
[ -z "$FILE_PATH" ] && exit 0

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

# Normalize path
FILE_REL="${FILE_PATH#$PROJECT_ROOT/}"

# Case 1: Editing a slide → check evidence freshness
if echo "$FILE_REL" | grep -qE 'content/aulas/.+/slides/[^_].+\.html'; then
  AULA=$(echo "$FILE_REL" | sed -E 's|content/aulas/([^/]+)/.*|\1|')
  SLIDE_NAME=$(basename "$FILE_REL" .html)
  # Extract slide ID (e.g., "01-hook" → "s-hook", "02-importancia" → "s-importancia")
  SLIDE_ID=$(echo "$SLIDE_NAME" | sed -E 's/^[0-9]+-/s-/')
  EVIDENCE="$PROJECT_ROOT/content/aulas/$AULA/evidence/${SLIDE_ID}.html"

  if [ -f "$EVIDENCE" ]; then
    SLIDE_MOD=$(stat -c %Y "$FILE_PATH" 2>/dev/null || stat -f %m "$FILE_PATH" 2>/dev/null || echo 0)
    EV_MOD=$(stat -c %Y "$EVIDENCE" 2>/dev/null || stat -f %m "$EVIDENCE" 2>/dev/null || echo 0)
    DIFF=$(( (SLIDE_MOD - EV_MOD) / 86400 ))
    if [ "$DIFF" -gt 7 ]; then
      echo "[COUPLING] Slide editado mas evidence/${SLIDE_ID}.html tem ${DIFF}d sem update. Verificar sincronia."
    fi
  fi
fi

# Case 2: Editing evidence → check if slide exists
if echo "$FILE_REL" | grep -qE 'content/aulas/.+/evidence/s-.+\.html'; then
  AULA=$(echo "$FILE_REL" | sed -E 's|content/aulas/([^/]+)/.*|\1|')
  EV_NAME=$(basename "$FILE_REL" .html)
  # s-importancia → look for *-importancia.html in slides/
  SLUG="${EV_NAME#s-}"
  SLIDE_EXISTS=$(find "$PROJECT_ROOT/content/aulas/$AULA/slides/" -name "*-${SLUG}.html" 2>/dev/null | head -1)

  if [ -z "$SLIDE_EXISTS" ]; then
    echo "[COUPLING] Evidence ${EV_NAME}.html editada mas slide correspondente nao existe ainda. Workflow evidence-first OK — slide pendente."
  fi
fi

exit 0
