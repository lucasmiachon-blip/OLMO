#!/usr/bin/env bash
# handoff-utils.sh — Section-aware HANDOFF.md parsing utilities
# Source: . "$PROJECT_ROOT/hooks/lib/handoff-utils.sh"
# Created: S255 Phase 3 A.2 (DRY extract from stop-metrics.sh + apl-cache-refresh.sh)
#
# Provides:
#   parse_handoff_pendentes <file>  — emit one line per "- " bullet under "## PENDENTES" section

# S255 Phase 3 A.2: idempotent include guard (banner.sh:7-11 model)
[[ -n "${_HANDOFF_UTILS_LOADED:-}" ]] && return 0
readonly _HANDOFF_UTILS_LOADED=1

# Section-aware HANDOFF parsing — only PENDENTES section bullets
# S218 origin: stop-metrics.sh + apl-cache-refresh.sh (copy-pasted)
# S236 robustness: explicit `return 0` — HANDOFF may lack PENDENTES section
# (S234 pivot → P0/P0.5/P1 format means parser may fail to find section header)
parse_handoff_pendentes() {
  local file="$1" in_section=0
  while IFS= read -r line; do
    [[ "$line" =~ ^##\ PENDENTES ]] && in_section=1 && continue
    [[ "$line" =~ ^##\  ]] && [ "$in_section" -eq 1 ] && break
    [ "$in_section" -eq 1 ] && [[ "$line" =~ ^-\  ]] && echo "${line#- }"
  done < "$file"
  return 0  # explicit — HANDOFF may lack PENDENTES section under set -euo pipefail
}
