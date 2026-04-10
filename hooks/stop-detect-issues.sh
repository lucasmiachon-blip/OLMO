#!/usr/bin/env bash
# Claude Code hook: Stop
# Detects cross-ref and hygiene issues, persists to pending-fixes.md
# for the next session to surface. Closes the self-healing loop.
# Evento: Stop | Timeout: 5s | Exit: sempre 0

# Drain stdin (hook protocol — prevent parent process stall)
cat >/dev/null 2>&1

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PENDING="$PROJECT_ROOT/.claude/pending-fixes.md"

# Get all modified files (staged + unstaged) relative to HEAD
CHANGED=$(git -C "$PROJECT_ROOT" diff --name-only HEAD 2>/dev/null || true)
STAGED=$(git -C "$PROJECT_ROOT" diff --cached --name-only 2>/dev/null || true)
ALL_CHANGED=$(printf "%s\n%s" "$CHANGED" "$STAGED" | sort -u | grep -v '^$')

# No changes? Exit silently.
[ -z "$ALL_CHANGED" ] && exit 0

ISSUES=""
NOW=$(date '+%Y-%m-%d %H:%M')

# Check 1: slide HTML modified without _manifest.js
SLIDE_CHANGED=$(echo "$ALL_CHANGED" | grep -E 'content/aulas/.+/slides/.+\.html' || true)
if [ -n "$SLIDE_CHANGED" ]; then
  MANIFEST_CHANGED=$(echo "$ALL_CHANGED" | grep '_manifest.js' || true)
  if [ -z "$MANIFEST_CHANGED" ]; then
    ISSUES="${ISSUES}- Slide HTML modified but _manifest.js NOT updated:\n"
    ISSUES="${ISSUES}$(echo "$SLIDE_CHANGED" | head -3 | sed 's/^/    /')\n"
  fi
fi

# Check 2: evidence HTML modified without slide HTML
EVIDENCE_CHANGED=$(echo "$ALL_CHANGED" | grep -E 'content/aulas/.+/evidence/.+\.html' || true)
if [ -n "$EVIDENCE_CHANGED" ]; then
  if [ -z "$SLIDE_CHANGED" ]; then
    ISSUES="${ISSUES}- Evidence HTML modified but no slide HTML updated:\n"
    ISSUES="${ISSUES}$(echo "$EVIDENCE_CHANGED" | head -3 | sed 's/^/    /')\n"
  fi
fi

# Check 3: _manifest.js modified without index.html rebuilt
MANIFEST_CHANGED=$(echo "$ALL_CHANGED" | grep '_manifest.js' || true)
if [ -n "$MANIFEST_CHANGED" ]; then
  INDEX_CHANGED=$(echo "$ALL_CHANGED" | grep 'index.html' || true)
  if [ -z "$INDEX_CHANGED" ]; then
    ISSUES="${ISSUES}- _manifest.js modified but index.html NOT rebuilt\n"
  fi
fi

# Check 4: HANDOFF/CHANGELOG not updated when work was done
# Filter out noise: plans, temp files, untracked-only paths
MEANINGFUL=$(echo "$ALL_CHANGED" | grep -vE '^\.(claude/plans/|claude/apl/)' | grep -v '^arvore\.txt$' || true)
if [ -n "$MEANINGFUL" ]; then
  # Check current diff AND last 3 commits for HANDOFF/CHANGELOG updates
  H_MOD=$(echo "$ALL_CHANGED" | grep 'HANDOFF.md' || true)
  C_MOD=$(echo "$ALL_CHANGED" | grep 'CHANGELOG.md' || true)
  H_RECENT=$(git -C "$PROJECT_ROOT" log --oneline -3 --diff-filter=M -- HANDOFF.md 2>/dev/null | head -1)
  C_RECENT=$(git -C "$PROJECT_ROOT" log --oneline -3 --diff-filter=M -- CHANGELOG.md 2>/dev/null | head -1)
  # Only flag if NEITHER in current diff NOR in recent commits
  if { [ -z "$H_MOD" ] && [ -z "$H_RECENT" ]; } || { [ -z "$C_MOD" ] && [ -z "$C_RECENT" ]; }; then
    HYGIENE=""
    [ -z "$H_MOD" ] && [ -z "$H_RECENT" ] && HYGIENE="${HYGIENE}- HANDOFF.md NOT updated\n"
    [ -z "$C_MOD" ] && [ -z "$C_RECENT" ] && HYGIENE="${HYGIENE}- CHANGELOG.md NOT updated\n"
    ISSUES="${ISSUES}${HYGIENE}"
  fi
fi

# If issues found, append to pending-fixes.md (with dedup)
if [ -n "$ISSUES" ]; then
  # Create header if file doesn't exist
  if [ ! -f "$PENDING" ]; then
    echo "# Pending Fixes (auto-generated, cleared after surfacing)" > "$PENDING"
    echo "" >> "$PENDING"
  fi
  # Dedup: only append if this exact issue block is not already present
  ISSUES_FLAT=$(echo -e "$ISSUES" | tr '\n' '|')
  EXISTING_FLAT=$(cat "$PENDING" 2>/dev/null | tr '\n' '|')
  DOMINATED=true
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    if ! echo "$EXISTING_FLAT" | grep -qF "$line"; then
      DOMINATED=false
      break
    fi
  done <<< "$(echo -e "$ISSUES")"
  if [ "$DOMINATED" = false ]; then
    echo "" >> "$PENDING"
    echo "## $NOW — Issues detected at session end" >> "$PENDING"
    echo -e "$ISSUES" >> "$PENDING"
  fi
fi

exit 0
