# Plan: Guard contra sobreescrita de state files

## Context

S217: HANDOFF.md reescrito com Write, perdendo 5 secoes/itens silenciosamente. Nenhum hook detectou. anti-drift.md tinha regra textual "use Edit" mas sem enforcement. O pattern "pit of success" (eliminar a possibilidade de erro) e o canonico para PreToolUse guards no OLMO (ja usado para index.html, hooks .sh, settings.json).

## Abordagem

Bloquear Write em HANDOFF.md, CHANGELOG.md, BACKLOG.md. Forcar Edit sempre. Esses arquivos sao append-modify — Write e semanticamente errado.

## Step 1: Guard 1b em guard-write-unified.sh

Inserir apos Guard 1 (linha 43), antes de Guard 2:

```bash
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
```

Deploy: Write→tmp→python shutil.copy (pattern existente).

## Step 2: Verificacao

1. `Write HANDOFF.md` → deve bloquear com mensagem
2. `Edit HANDOFF.md` → deve passar
3. `Write README.md` → nao afetado

## Files

- `.claude/hooks/guard-write-unified.sh` — unico arquivo (add Guard 1b)
