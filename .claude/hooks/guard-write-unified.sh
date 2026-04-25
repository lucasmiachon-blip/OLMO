#!/usr/bin/env bash
# guard-write-unified.sh — PreToolUse(Write|Edit): unified write guard
# Merged: guard-worker-write.sh + guard-generated.sh + guard-product-files.sh (S194 Fase 2)
# Single jq parse, dispatch by path pattern. 0 node spawns (was 4).
#
# Priority order:
#   1. Generated file block (index.html)
#   1b. State files block Write (HANDOFF, CHANGELOG, BACKLOG) — S217
#   2. Worker timestamp enforcement + worker-mode guard
#   3. Infrastructure file block/ask (hooks, settings)
#   4. Product file ask (slides, CSS, JS, manifests)

set -euo pipefail

INPUT=$(cat 2>/dev/null || echo '{}')

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
[ -z "$REPO_ROOT" ] && exit 0  # Not in git repo — hook not applicable

# ─── Single jq parse: extract file_path + tool_name ───
PARSED=$(echo "$INPUT" | jq -r '[
  ((.tool_input.file_path // .tool_input.path // "") | gsub("\\\\"; "/")),
  (.tool_name // "")
] | join("\t")' 2>/dev/null)

FILE_PATH=$(printf '%s' "$PARSED" | cut -f1)
TOOL_NAME=$(printf '%s' "$PARSED" | cut -f2)

# Fail-closed: can't parse but input has tool_input → block
if [ -z "$FILE_PATH" ] && echo "$INPUT" | grep -q '"tool_input"'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"BLOQUEADO: guard-write-unified falhou ao parsear input (fail-closed)"}}\n'
  exit 2
fi

[ -z "$FILE_PATH" ] && exit 0

# Normalize path: collapse //, remove ../ traversals, strip ./
FILE_PATH=$(printf '%s' "$FILE_PATH" | sed -E 's|//|/|g; s|[^/]+/\.\./||g; s|^\./||')

# ═══ Guard 1: Generated files (index.html built by npm run build) ═══
if [[ "$FILE_PATH" == *"content/aulas/"*"/index.html" ]]; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"BLOQUEADO: index.html e gerado por npm run build:{aula}. Editar slides/*.html ou index.template.html, depois rodar build."}}\n'
  exit 2
fi

# ═══ Guard 1b: State files structural integrity (S217) ═══
# Write replaces entire file — block. Edit preserves untouched sections.
if echo "$FILE_PATH" | grep -qE '(^|/)(HANDOFF|CHANGELOG|BACKLOG)\.md$'; then
  if [ "$TOOL_NAME" = "Write" ]; then
    BASENAME=$(basename "$FILE_PATH")
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"BLOQUEADO: Use Edit (nao Write) para %s. Write descarta secoes silenciosamente."}}\n' "$BASENAME"
    exit 2
  fi
  exit 0
fi

# ═══ Guard 2: Worker mode & timestamp enforcement ═══
WORKER_FLAG="$REPO_ROOT/.claude/.worker-mode"

if echo "$FILE_PATH" | grep -q '\.claude/workers/'; then
  # 2a. Timestamp enforcement for .md files in workers/ (ALWAYS active)
  if [[ "$FILE_PATH" == *.md ]]; then
    FIRST_LINE=""
    if [ "$TOOL_NAME" = "Write" ]; then
      FIRST_LINE=$(echo "$INPUT" | jq -r '.tool_input.content // ""' 2>/dev/null | head -1)
    elif [ "$TOOL_NAME" = "Edit" ]; then
      # Convert MSYS path /c/... to C:/... for Windows file access
      WIN_PATH=$(printf '%s' "$FILE_PATH" | sed 's|^/\([a-zA-Z]\)/|\1:/|')
      [ -f "$WIN_PATH" ] && FIRST_LINE=$(head -1 "$WIN_PATH" 2>/dev/null || echo "")
    fi

    if [ -n "$FIRST_LINE" ]; then
      # Check format: # Title — YYYY-MM-DD HH:MM (em dash U+2014)
      if ! echo "$FIRST_LINE" | grep -qE '^#.+— [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}'; then
        printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"[WORKER] Titulo do MD precisa de timestamp. Formato: # Titulo — YYYY-MM-DD HH:MM. Get time: date +%%Y-%%m-%%d\\ %%H:%%M"}}\n'
        exit 2
      fi

      # Extract timestamp string
      TS=$(echo "$FIRST_LINE" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}' || true)
      if [ -n "$TS" ]; then
        # Validate date component ranges
        Y=$(echo "$TS" | cut -c1-4)
        MO=$(echo "$TS" | cut -c6-7)
        DA=$(echo "$TS" | cut -c9-10)
        H=$(echo "$TS" | cut -c12-13)
        MI=$(echo "$TS" | cut -c15-16)

        if (( 10#$MO < 1 || 10#$MO > 12 || 10#$DA < 1 || 10#$DA > 31 || 10#$H > 23 || 10#$MI > 59 )); then
          printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"[WORKER] Timestamp has impossible values. Check month/day/hour ranges."}}\n'
          exit 2
        fi

        # Validate staleness (>5 min from system clock)
        TS_EPOCH=$(date -d "$Y-$MO-$DA $H:$MI" +%s 2>/dev/null || echo "")
        if [ -n "$TS_EPOCH" ]; then
          NOW_EPOCH=$(date +%s)
          DIFF=$(( NOW_EPOCH - TS_EPOCH ))
          DIFF_ABS=${DIFF#-}
          if (( DIFF_ABS > 300 )); then
            printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"[WORKER] Timestamp >5min from system clock. Get real time: date +%%Y-%%m-%%d\\ %%H:%%M"}}\n'
            exit 2
          fi
        fi
      fi
    fi
  fi
  # Path is in workers/ and passed all checks — allow
  exit 0
fi

# 2b. Worker-mode guard: block writes outside workers/ when flag exists
if [ -f "$WORKER_FLAG" ]; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"[WORKER MODE] Write/Edit blocked outside .claude/workers/. Use orchestrator window for repo edits."}}\n'
  exit 2
fi

# ═══ Guard 3: Infrastructure files ═══
# Hook scripts: BLOCK Edit/Write (deploy via Write→temp→cp, guard-bash-write asks)
if echo "$FILE_PATH" | grep -qE '(^|/)(\.claude/hooks|hooks)/.*\.sh$'; then
  BASENAME=$(basename "$FILE_PATH")
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"BLOQUEADO: %s e hook de seguranca. Deploy via Write→temp→cp (guard-bash-write pede aprovacao)."}}\n' "$BASENAME"
  exit 2
fi

# Settings files: ASK (need Edit access to register/update hooks)
if echo "$FILE_PATH" | grep -qE '(^|/)\.claude/settings\.(local\.)?json$'; then
  BASENAME=$(basename "$FILE_PATH")
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"[INFRA] %s — config de seguranca. Lucas aprova?"}}\n' "$BASENAME"
  exit 0
fi

# ═══ Guard 4: Product files ═══
PRODUCT_PATTERNS=(
  '(^|/)content/aulas/[^/]+/slides/[^/]+\.html$'
  '(^|/)content/aulas/[^/]+/[^/]+\.css$'
  '(^|/)content/aulas/shared/css/base\.css$'
  '(^|/)content/aulas/shared/js/[^/]+\.js$'
  '(^|/)content/aulas/[^/]+/slide-registry\.js$'
  '(^|/)content/aulas/[^/]+/index\.html$'
  '(^|/)content/aulas/[^/]+/slides/_manifest\.js$'
  '(^|/)content/aulas/scripts/.*\.(mjs|js)$'
  '(^|/)content/aulas/[^/]+/docs/prompts/.*\.md$'
)

for pattern in "${PRODUCT_PATTERNS[@]}"; do
  if echo "$FILE_PATH" | grep -qE "$pattern"; then
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"Produto: %s"}}\n' "$FILE_PATH"
    exit 0
  fi
done

# Not a guarded file — allow silently
exit 0
