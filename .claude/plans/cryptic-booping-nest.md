# S211 Fase 1: Anti-perda — plano de execucao

## Contexto

Sessao 209 perdeu pesquisa de 6 agentes quando compaction apagou o contexto. O diagnostico (S210): o problema nao e memoria, e processo — output de agente ficou em temp/contexto, sem persistencia automatica pre-compaction. Fase 0 (settings) completa. Fase 1 corrige o processo.

## Acoes (4 items, ~45 min total)

### 1. Melhorar `hooks/pre-compact-checkpoint.sh` (~15 min)

**Arquivo:** `hooks/pre-compact-checkpoint.sh`
**Problema:** salva apenas git status + arquivos recentes. Nao captura estado cognitivo (planos ativos, pesquisa pendente).
**Fix:** adicionar ao checkpoint:
- Plano ativo (cat `.claude/.plan-path` se existir, ou glob mais recente em `.claude/plans/*.md` excluindo archive)
- Ultimos 5 arquivos modificados em `.claude/plans/` (pesquisa de agente vai para plan files)
- Conteudo de `.claude/pending-fixes.md` se existir
- Header do HANDOFF.md (primeiras 5 linhas — estado atual)

**Nota:** o comentario do script diz "Stop" mas esta registrado em `PreCompact`. Corrigir comentario.

**Verificacao:** `cat .claude/.last-checkpoint` apos simular compaction deve mostrar as secoes novas.

### 2. Fix vuln JSON hand-assembly em `hooks/post-compact-reread.sh:15` (~5 min)

**Arquivo:** `hooks/post-compact-reread.sh`
**Problema:** linha 15 monta JSON por string interpolation: `echo "{\"hookSpecificOutput\":{\"message\":\"$MSG\"}}"`. Se SESSION_NAME contiver `"` ou `\`, JSON quebra ou permite injection.
**Fix:** substituir por `jq -cn --arg msg "$MSG" '{hookSpecificOutput:{message:$msg}}'`
**Dependencia:** jq 1.8.1 disponivel em PATH (confirmado).

**Verificacao:** `echo 'test "quotes"' > .claude/.session-name && bash hooks/post-compact-reread.sh < /dev/null` deve produzir JSON valido.

### 3. Fix vuln eval injection em `.claude/hooks/lib/retry-utils.sh:28` (~15 min)

**Arquivo:** `.claude/hooks/lib/retry-utils.sh`
**Problema:** `eval "$cmd"` na linha 28. Qualquer string com metacharacters shell sera interpretada.
**Risco real:** BAIXO — so 2 chamadores (lint-on-edit.sh:37, guard-lint-before-build.sh:60), ambos passam strings hardcoded (`node "scripts/X" "Y"`). Mas o pattern e perigoso se alguem adicionar novo chamador.
**Fix:** mudar interface para aceitar comando como argumentos posicionais (array), nao string eval'd:
```bash
# Antes: retry_with_jitter "node script.js arg1" 3 1
# Depois: retry_with_jitter 3 1 -- node script.js arg1
```
Onde `--` separa config de comando. Internamente usar `"${cmd_args[@]}"` em vez de `eval`.

**Chamadores a atualizar:**
- `.claude/hooks/lint-on-edit.sh:37` — `retry_with_jitter "node \"$LINT_SCRIPT\" \"$AULA\"" 2 1`
- `.claude/hooks/guard-lint-before-build.sh:60` — `retry_with_jitter "node \"scripts/$SCRIPT\" \"$AULA\"" 3 1`

**Verificacao:** rodar `npm run lint:slides` de `content/aulas/` — lint-on-edit usa retry-utils internamente.

### 4. Regra operacional: pesquisa de agente persistida antes de reportar (~10 min)

**Problema:** a regra "pesquisa de agente SEMPRE persistida em plan file ANTES de reportar" existe no HANDOFF como cuidado, mas nao e enforced por rules.
**Fix:** adicionar 2 linhas em `.claude/rules/anti-drift.md` secao "Delegation gate (KBP-17)":
```
4. Agent spawn que produz pesquisa → resultado escrito em plan file ANTES de reportar ao usuario. Contexto e volatil, plan file persiste.
```
E adicionar em `.claude/context-essentials.md` (pos-compaction survival):
```
7. Pesquisa de agente: resultado em plan file ANTES de reportar. Contexto e volatil.
```

**Verificacao:** `grep -n "plan file" .claude/rules/anti-drift.md` confirma regra presente.

---

## Fora de escopo (explicito)

- `claude-memory-compiler` avaliacao → Fase 4 (sessao separada)
- `$CLAUDE_PROJECT_DIR` migration → Fase 2
- `set -euo pipefail` nos 28 scripts → Fase 2
- `async: true` em hooks → Fase 2
- Prompt hook Stop → Fase 3
- Consolidacao PreToolUse → Fase 3

## Ordem de execucao

1. Item 2 (post-compact-reread.sh) — menor, mais simples
2. Item 3 (retry-utils.sh) — seguranca, 2 chamadores para atualizar
3. Item 1 (pre-compact-checkpoint.sh) — melhoria funcional
4. Item 4 (regra operacional) — 2 linhas em 2 arquivos
5. Commit unico com todos os 4 items

## Verificacao final

```bash
# 1. JSON valido no post-compact
echo 'test "quotes" \\backslash' > .claude/.session-name
bash hooks/post-compact-reread.sh < /dev/null | jq .

# 2. retry-utils sem eval
grep -n 'eval' .claude/hooks/lib/retry-utils.sh  # deve retornar 0

# 3. checkpoint com secoes novas
bash hooks/pre-compact-checkpoint.sh < /dev/null
cat .claude/.last-checkpoint  # deve ter secoes Plan, HANDOFF, etc.

# 4. regra presente
grep -n 'plan file' .claude/rules/anti-drift.md
grep -n 'plan file' .claude/context-essentials.md
```
