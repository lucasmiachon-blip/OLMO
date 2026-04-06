#!/usr/bin/env bash
# Claude Code hook: Stop
# Checks if slide HTML was modified without updating cross-ref files.
# Deterministic, $0 cost. Prints warnings the model will see.
# Evento: Stop | Timeout: 5s | Exit: sempre 0

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Get all modified files (staged + unstaged) relative to HEAD
CHANGED=$(git -C "$PROJECT_ROOT" diff --name-only HEAD 2>/dev/null)
STAGED=$(git -C "$PROJECT_ROOT" diff --cached --name-only 2>/dev/null)
ALL_CHANGED=$(printf "%s\n%s" "$CHANGED" "$STAGED" | sort -u | grep -v '^$')

# No changes? Exit silently.
[ -z "$ALL_CHANGED" ] && exit 0

# Check: slide HTML modified → _manifest.js also modified?
SLIDE_CHANGED=$(echo "$ALL_CHANGED" | grep -E 'content/aulas/.+/slides/.+\.html' | head -5)
if [ -n "$SLIDE_CHANGED" ]; then
  MANIFEST_CHANGED=$(echo "$ALL_CHANGED" | grep '_manifest.js')
  if [ -z "$MANIFEST_CHANGED" ]; then
    echo "CROSS-REF WARNING: Slide HTML modified but _manifest.js NOT updated:"
    echo "$SLIDE_CHANGED" | sed 's/^/  /'
    echo "→ Check: headline, clickReveals, customAnim in _manifest.js"
  fi
fi

# Check: evidence HTML modified → slide also modified?
EVIDENCE_CHANGED=$(echo "$ALL_CHANGED" | grep -E 'content/aulas/.+/evidence/.+\.html' | head -5)
if [ -n "$EVIDENCE_CHANGED" ]; then
  if [ -z "$SLIDE_CHANGED" ]; then
    echo "CROSS-REF WARNING: Evidence HTML modified but no slide HTML updated:"
    echo "$EVIDENCE_CHANGED" | sed 's/^/  /'
    echo "→ Check: citation block in corresponding slide"
  fi
fi

# Check: _manifest.js modified → index.html also modified (needs build)?
MANIFEST_CHANGED=$(echo "$ALL_CHANGED" | grep '_manifest.js')
if [ -n "$MANIFEST_CHANGED" ]; then
  INDEX_CHANGED=$(echo "$ALL_CHANGED" | grep 'index.html')
  if [ -z "$INDEX_CHANGED" ]; then
    echo "CROSS-REF WARNING: _manifest.js modified but index.html NOT rebuilt:"
    echo "→ Run: npm run build:{aula} or build-html.ps1"
  fi
fi

# Check: agent definition modified → HANDOFF also updated?
AGENT_CHANGED=$(echo "$ALL_CHANGED" | grep -E '\.claude/agents/.+\.md' | head -5)
if [ -n "$AGENT_CHANGED" ]; then
  HANDOFF_CHANGED=$(echo "$ALL_CHANGED" | grep 'HANDOFF.md')
  if [ -z "$HANDOFF_CHANGED" ]; then
    echo "CROSS-REF WARNING: Agent definition modified but HANDOFF.md NOT updated:"
    echo "$AGENT_CHANGED" | sed 's/^/  /'
  fi
fi

exit 0
