#!/usr/bin/env bash
set -euo pipefail
# Claude Code hook: Stop
# Merged: crossref-check + detect-issues + hygiene (Fase 2 step 5)
# Cross-ref consistency, hygiene, persist pending-fixes, print HANDOFF.
# Now also logs warnings to hook-log.jsonl (S213 self-improvement loop step 1).
# Evento: Stop | Timeout: 5s | Exit: sempre 0

# Drain stdin (hook protocol — prevent parent process stall)
cat >/dev/null 2>&1

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
. "$PROJECT_ROOT/hooks/lib/hook-log.sh"
PENDING="$PROJECT_ROOT/.claude/pending-fixes.md"
HANDOFF="$PROJECT_ROOT/HANDOFF.md"

# Shared git diff (was 6 calls across 3 scripts -> now 2)
CHANGED=$(git -C "$PROJECT_ROOT" diff --name-only HEAD 2>/dev/null || true)
STAGED=$(git -C "$PROJECT_ROOT" diff --cached --name-only 2>/dev/null || true)
ALL_CHANGED=$(printf "%s\n%s" "$CHANGED" "$STAGED" | sort -u | grep -v '^$' || true)

# No changes? Print HANDOFF and exit.
if [ -z "$ALL_CHANGED" ]; then
  echo ""
  echo "=== HANDOFF.md ==="
  [ -f "$HANDOFF" ] && cat "$HANDOFF" || echo "(HANDOFF.md not found)"
  exit 0
fi

ISSUES=""

# --- Cross-ref checks ---

# Slide HTML -> _manifest.js
SLIDE_CHANGED=$(echo "$ALL_CHANGED" | grep -E 'content/aulas/.+/slides/.+\.html' | head -5 || true)
if [ -n "$SLIDE_CHANGED" ]; then
  if ! echo "$ALL_CHANGED" | grep -q '_manifest.js'; then
    echo "CROSS-REF WARNING: Slide HTML modified but _manifest.js NOT updated:"
    echo "$SLIDE_CHANGED" | sed 's/^/  /'
    echo "-> Check: headline, clickReveals, customAnim in _manifest.js"
    ISSUES="${ISSUES}- Slide HTML modified but _manifest.js NOT updated\n"
    hook_log "Stop" "stop-quality" "cross-ref" "slide-without-manifest" "warn" "Slide HTML modified but _manifest.js NOT updated"
  fi
fi

# Evidence HTML -> slide HTML
EVIDENCE_CHANGED=$(echo "$ALL_CHANGED" | grep -E 'content/aulas/.+/evidence/.+\.html' | head -5 || true)
if [ -n "$EVIDENCE_CHANGED" ]; then
  if [ -z "$SLIDE_CHANGED" ]; then
    echo "CROSS-REF WARNING: Evidence HTML modified but no slide HTML updated:"
    echo "$EVIDENCE_CHANGED" | sed 's/^/  /'
    echo "-> Check: citation block in corresponding slide"
    ISSUES="${ISSUES}- Evidence HTML modified but no slide HTML updated\n"
    hook_log "Stop" "stop-quality" "cross-ref" "evidence-without-slide" "warn" "Evidence HTML modified but no slide HTML updated"
  fi
fi

# _manifest.js -> index.html
if echo "$ALL_CHANGED" | grep -q '_manifest.js'; then
  if ! echo "$ALL_CHANGED" | grep -q 'index.html'; then
    echo "CROSS-REF WARNING: _manifest.js modified but index.html NOT rebuilt:"
    echo "-> Run: npm run build:{aula} or build-html.ps1"
    ISSUES="${ISSUES}- _manifest.js modified but index.html NOT rebuilt\n"
    hook_log "Stop" "stop-quality" "cross-ref" "manifest-without-build" "warn" "_manifest.js modified but index.html NOT rebuilt"
  fi
fi

# Agent def -> HANDOFF
AGENT_CHANGED=$(echo "$ALL_CHANGED" | grep -E '\.claude/agents/.+\.md' | head -5 || true)
if [ -n "$AGENT_CHANGED" ]; then
  if ! echo "$ALL_CHANGED" | grep -q 'HANDOFF.md'; then
    echo "CROSS-REF WARNING: Agent definition modified but HANDOFF.md NOT updated:"
    echo "$AGENT_CHANGED" | sed 's/^/  /'
    ISSUES="${ISSUES}- Agent definition modified but HANDOFF.md NOT updated\n"
    hook_log "Stop" "stop-quality" "cross-ref" "agent-without-handoff" "warn" "Agent definition modified but HANDOFF.md NOT updated"
  fi
fi

# --- Hygiene (detect-issues logic — checks recent commits too) ---
MEANINGFUL=$(echo "$ALL_CHANGED" | grep -vE '^\.(claude/plans/|claude/apl/)' | grep -v '^arvore\.txt$' || true)
if [ -n "$MEANINGFUL" ]; then
  H_MOD=$(echo "$ALL_CHANGED" | grep 'HANDOFF.md' || true)
  C_MOD=$(echo "$ALL_CHANGED" | grep 'CHANGELOG.md' || true)
  H_RECENT=$(git -C "$PROJECT_ROOT" log --oneline -3 --diff-filter=M -- HANDOFF.md 2>/dev/null | head -1)
  C_RECENT=$(git -C "$PROJECT_ROOT" log --oneline -3 --diff-filter=M -- CHANGELOG.md 2>/dev/null | head -1)
  if { [ -z "$H_MOD" ] && [ -z "$H_RECENT" ]; } || { [ -z "$C_MOD" ] && [ -z "$C_RECENT" ]; }; then
    echo "SESSION-HYGIENE WARNING:"
    if [ -z "$H_MOD" ] && [ -z "$H_RECENT" ]; then
      echo "  - HANDOFF.md NOT updated"
      ISSUES="${ISSUES}- HANDOFF.md NOT updated\n"
      hook_log "Stop" "stop-quality" "hygiene" "handoff-not-updated" "warn" "HANDOFF.md NOT updated"
    fi
    if [ -z "$C_MOD" ] && [ -z "$C_RECENT" ]; then
      echo "  - CHANGELOG.md NOT updated"
      ISSUES="${ISSUES}- CHANGELOG.md NOT updated\n"
      hook_log "Stop" "stop-quality" "hygiene" "changelog-not-updated" "warn" "CHANGELOG.md NOT updated"
    fi
    echo "  Per session-hygiene rule: update both before ending."
  fi
fi

# --- Persist issues to pending-fixes.md (hash dedup, S193) ---
if [ -n "$ISSUES" ]; then
  NOW=$(date '+%Y-%m-%d %H:%M')
  if [ ! -f "$PENDING" ]; then
    echo "# Pending Fixes (auto-generated, cleared after surfacing)" > "$PENDING"
    echo "" >> "$PENDING"
  fi
  ISSUES_HASH=$(echo -e "$ISSUES" | md5sum | cut -d' ' -f1)
  if ! grep -qF "$ISSUES_HASH" "$PENDING" 2>/dev/null; then
    echo "" >> "$PENDING"
    echo "<!-- hash:$ISSUES_HASH -->" >> "$PENDING"
    echo "## $NOW — Issues detected at session end" >> "$PENDING"
    echo -e "$ISSUES" >> "$PENDING"
  fi
fi

# --- HANDOFF print for context recovery ---
echo ""
echo "=== HANDOFF.md ==="
[ -f "$HANDOFF" ] && cat "$HANDOFF" || echo "(HANDOFF.md not found)"

exit 0
