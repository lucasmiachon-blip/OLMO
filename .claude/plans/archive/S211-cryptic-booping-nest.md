# S211 Fase 2: Hooks mecanicos — COMPLETO

## Contexto

Fase 1 (anti-perda) completa (commit `d5e60b6`). Fase 2 moderniza hooks com melhorias mecanicas. Plano base: `hashed-zooming-bonbon.md` Fase 2. Pesquisa: 6 agentes S210.

## Acoes (4 items, ~70 min total)

### 1. `async: true` em hooks nao-bloqueantes (~5 min)

**Arquivo:** `.claude/settings.local.json`
**Candidatos (6 hooks, todos confirmados non-blocking pelo explore):**

| Hook | Linha | Evento | Porque async-safe |
|------|-------|--------|-------------------|
| `stop-metrics.sh` | 342 | Stop | Pure logging, /tmp reads, exit 0 |
| `stop-notify.sh` | 351 | Stop | PowerShell toast com Sleep 2.5s — timeout 10s desperdicado |
| `stop-should-dream.sh` | 360 | Stop | Epoch write em ~/.claude, zero output |
| `chaos-inject-post.sh` | 269 | PostToolUse | Quick-exit quando CHAOS_MODE != 1, /tmp writes |
| `model-fallback-advisory.sh` | 279 | PostToolUse | Advisory text, /tmp log |
| `notify.sh` | 300 | Notification | PowerShell toast, mesmo pattern que stop-notify |

**Nota:** 4 originais do plano + 2 adicionais (`stop-should-dream.sh`, `notify.sh`) identificados pelo explore com mesmos patterns. Todos sao fire-and-forget — output nao afeta decisao do agente.

**Fix:** adicionar `"async": true` em cada hook entry.

### 2. `$CLAUDE_PROJECT_DIR` em settings.local.json (~15 min)

**Arquivo:** `.claude/settings.local.json`
**32 ocorrencias** de `/c/Dev/Projetos/OLMO`:
- 28 em `"command":` strings de hooks
- 2 em `permissions.allow` (formato `Bash(cp /c/Dev/...)`)
- 1 em `statusLine.command`
- 1 extra

**Fix:** replace `/c/Dev/Projetos/OLMO` → `$CLAUDE_PROJECT_DIR` nas 28+1+1 command strings.
**Permissions (2 ocorrencias):** verificar se `$CLAUDE_PROJECT_DIR` resolve dentro de permission patterns. Se nao, manter hardcoded (permissions sao config estatica, nao runtime).

**Teste obrigatorio:** rodar 1 hook simples apos migracao para confirmar que Git Bash resolve `$CLAUDE_PROJECT_DIR`.
```bash
echo $CLAUDE_PROJECT_DIR  # deve imprimir /c/Dev/Projetos/OLMO
```

### 3. `set -euo pipefail` nos scripts sem protecao (~30 min)

**Estado real (corrigido pelo explore):**
- 1 script com `set -euo pipefail`: `guard-secrets.sh`
- 3 scripts com `set -u` parcial: `guard-write-unified.sh`, `guard-lint-before-build.sh`, `guard-read-secrets.sh`
- ~25 scripts sem nenhum strict mode

**Fix:** adicionar `set -euo pipefail` na linha 2 de cada script (apos shebang).
**Upgrade:** os 3 com `set -u` parcial → `set -euo pipefail` completo.

**Cuidados concretos (verificados no codigo):**
- `retry-utils.sh` — usa `$?` na linha 29. Com `-e`, o script morre no primeiro erro antes de chegar ao `$?`. Fix: `"${cmd_args[@]}" 2>&1` ja captura exit code via `$?` no while — OK porque assignment nao dispara `-e`.
- Scripts com `|| exit 0` ou `|| echo` (session-start, ambient-pulse, post-compact-reread): precisam `|| true` nos pontos intencionais.
- Vars opcionais (`$SESSION_NAME`, `$CHAOS_MODE`): `${VAR:-}` ou `${VAR:-default}`.

**Protocolo por script:**
1. Adicionar `set -euo pipefail` apos shebang
2. `bash -n script.sh` (syntax check)
3. Testar dry run com `bash script.sh < /dev/null`

### 4. `if` conditions em PreToolUse (~20 min)

**Arquivo:** `.claude/settings.local.json`
**Natureza:** otimizacao de performance (evita process spawn), NAO correcao funcional. Os scripts internamente ja filtram corretamente.

**Candidatos (3, ordenados por impacto):**

| Hook | Matcher atual | `if` proposto | Spawns evitados |
|------|--------------|---------------|-----------------|
| `momentum-brake-enforce.sh` | `.*` (TODA tool call) | Sem `if` — catch-all e intencional. Script faz case/esac internamente (l.44-48), ~5ms por spawn | Muitos, mas logica interna protege |
| `guard-bash-write.sh` | `Bash` | `"if": "Bash(*>*|*>>*|*rm *|*mv *|*cp *|*chmod*|*kill*)"` | ~60% dos Bash calls sao read-only |
| `guard-research-queries.sh` | `Skill` | `"if": "Skill(research*|evidence*)"` | Maioria dos Skill calls nao sao research |

**Decisao sobre momentum-brake:** NAO adicionar `if` — o catch-all e intencional (defense-in-depth). O custo e ~5ms/call, aceitavel.

## Ordem de execucao

1. Item 2 ($CLAUDE_PROJECT_DIR) — maior impacto, habilita portabilidade
2. Item 1 (async) — trivial apos item 2
3. Item 4 (if conditions) — 2 entries em settings.json
4. Item 3 (pipefail) — mais trabalhoso, ~25 scripts via Write→tmp→cp

## Verificacao final

```bash
# 1. async count
grep -c '"async": true' .claude/settings.local.json  # >= 6

# 2. hardcoded paths (excl permissions se mantidas)
grep -c '/c/Dev/Projetos/OLMO' .claude/settings.local.json  # <= 2 (permissions only)

# 3. pipefail coverage
grep -rl 'set -euo pipefail' hooks/ .claude/hooks/ --include='*.sh' | wc -l  # >= 28

# 4. if conditions
grep -c '"if":' .claude/settings.local.json  # >= 4
```
