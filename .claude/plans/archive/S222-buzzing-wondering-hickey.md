# S222 CONTEXT_ROT 3 — cwd bug fix + wire integrity + cleanup orphans

> Session: S222 | Scope: 3 commits isolados | Risco: baixo-medio
> Continua S221 `partitioned-orbiting-hellman.md` — ataca ordem (e) → (d) → (f) do HANDOFF

## Context (why this change)

S221 deixou `.claude/.claude/apl/` (4 files, Apr 16 21:01) e `.claude/tmp/` (5 files) como orfaos. O diagnostico em `pending-fixes.md` dizia "recorrente a cada sessao" mas filesystem mostra evento unico (nao atualizado hoje). Mesmo assim, o **vetor** permanece:

Todos os 14 hooks usam:
```bash
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
```

Esse pattern assume que o script esta sempre 1 nivel deep em `hooks/`. Se o script for copiado/movido (ou invocado de `.claude/tmp/`), `dirname/..` resolve para `.claude/` e toda escrita `$PROJECT_ROOT/.claude/apl` vira `.claude/.claude/apl`. Os 5 orfaos em `.claude/tmp/` (copias dos hooks) provam que o vetor e usavel.

Padrao melhor ja existe em `.claude/hooks/post-global-handler.sh:12`:
```bash
PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
```

Env var autoritativa + fallback. Claude Code harness sempre define `$CLAUDE_PROJECT_DIR`. Para contextos sem env (testes, copias manuais), `git rev-parse --show-toplevel` resolve repo root independente de `$0`.

**Intended outcome:** eliminar classe de bug "orfao gerado por cwd/path resolution errado", instalar vigilancia automatica via integrity.sh no Stop, e so entao limpar orfaos (limpar antes = reinfetavel).

## Approach (3 commits, isolated)

### Commit 1 — Harden PROJECT_ROOT resolution (11 hooks + sanity check)

Padronizar todos os hooks para:
```bash
PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
# Sanity check: abort if PROJECT_ROOT points to .claude subdir
[[ "$(basename "$PROJECT_ROOT")" == ".claude" ]] && { echo "ERROR: PROJECT_ROOT resolved to .claude — bug prevented" >&2; exit 1; }
```

Arquivos a modificar (11 files, pattern search `PROJECT_ROOT="$(cd "$(dirname "$0")/.. && pwd)"` ja confirmado via Grep):
- `hooks/apl-cache-refresh.sh:13`
- `hooks/ambient-pulse.sh:11`
- `hooks/post-tool-use-failure.sh:7`
- `hooks/pre-compact-checkpoint.sh:12`
- `hooks/post-compact-reread.sh:11`
- `hooks/session-compact.sh:8`
- `hooks/nudge-commit.sh:10`
- `hooks/session-start.sh:7`
- `hooks/session-end.sh:11`
- `hooks/stop-metrics.sh:14`
- `hooks/stop-quality.sh:12`

Nao modificar:
- `.claude/hooks/post-global-handler.sh:12` (ja correto)
- `.claude/hooks/post-bash-handler.sh:9` (usa git rev-parse puro — aceitavel)
- `.claude/hooks/coupling-proactive.sh:15` (usa `/../..` que funciona de `.claude/hooks/`)

**Edit mechanism:** o guard bloqueia Edit direto em alguns hooks. Se bloquear, usar Python+shutil.copy seguindo KBP-19.

### Commit 2 — Wire integrity.sh to Stop hook

Adicionar ao `.claude/settings.local.json` Stop array (apos os 2 stop hooks de agent type, antes dos 3 async de command type):

```json
{
  "hooks": [
    {
      "type": "command",
      "command": "bash $CLAUDE_PROJECT_DIR/tools/integrity.sh > /dev/null 2>&1 || echo '[INTEGRITY] violations — see .claude/integrity-report.md'",
      "timeout": 10000,
      "async": true
    }
  ]
}
```

Rationale:
- `async: true` — nao bloqueia session Stop
- Stdout silenciado, so emite se exit != 0
- Report em `.claude/integrity-report.md` (ja gitignored) mostra detalhes
- Session-start hook (`apl-cache-refresh.sh`) pode ler report e surfaceear em sessao seguinte (escopo futuro, nao este commit)

### Commit 3 — Cleanup orphans

Apos commits 1+2 garantirem nao-regressao:
```bash
rm -rf .claude/.claude/
rm -rf .claude/tmp/
bash tools/integrity.sh  # confirma INV-5: 0 violations
```

Verificar `.gitignore` ja cobre (nao versionar). Se nao, adicionar entrada.

## Files modified (summary)

### Commit 1 (defensive)
- 11 hooks em `hooks/*.sh` — PROJECT_ROOT pattern + sanity check

### Commit 2 (wire)
- `.claude/settings.local.json` — adicionar 1 entrada em Stop array

### Commit 3 (cleanup)
- Delete `.claude/.claude/` + `.claude/tmp/`
- Talvez `.gitignore` (verificar)

## Why this order (e → d → f, per HANDOFF recommendation)

1. **Commit 1 antes de cleanup:** fixar gerador antes de limpar sintoma. Limpar antes = orfaos podem voltar na proxima invocacao anomala.
2. **Commit 2 antes de cleanup:** instalar vigilancia enquanto violacao ainda e detectavel (INV-5 falha = 2 violations). Depois do cleanup, INV-5 passa e perdemos dado de baseline.
3. **Commit 3 por ultimo:** so depois de (1) garantir nao-regressao e (2) ter vigilancia.

## Trade-offs

- **Sanity check no hook:** adiciona 2 linhas a cada hook. Trade-off aceitavel — exit 1 em caso anomalo e melhor que lixo silencioso.
- **`git rev-parse` fallback:** requer que cwd esteja dentro de repo. Aceitavel — hooks sempre rodam no contexto do projeto.
- **Wire integrity.sh como async command:** nao pode modificar prompt do usuario. OK — goal e deteccao, nao intervencao. Surface via session-start hook depois.
- **Commits separados:** 3 commits em vez de 1. Alinha com "um trabalho por vez". Permite rollback seletivo.

## Verification

### After Commit 1 (hardening)
```bash
# 1. Syntax check all 11 hooks
for f in hooks/*.sh; do bash -n "$f" && echo "OK $f" || echo "FAIL $f"; done

# 2. Hook fires correctly (manual trigger via PreCompact or similar)
bash hooks/apl-cache-refresh.sh < /dev/null && ls -la .claude/apl/session-ts.txt

# 3. Sanity check triggers if forced into wrong PROJECT_ROOT
CLAUDE_PROJECT_DIR=/c/Dev/Projetos/OLMO/.claude bash hooks/apl-cache-refresh.sh
# Expected: exits 1 with "ERROR: PROJECT_ROOT resolved to .claude"

# 4. Integrity check still passes INV-2
bash tools/integrity.sh
# Expected: INV-2 all PASS (30 hooks still valid)
```

### After Commit 2 (wire)
```bash
# 1. JSON validity
jq '.' .claude/settings.local.json > /dev/null && echo "JSON OK"

# 2. Hook count in INV-2
bash tools/integrity.sh
# Expected: INV-2 "31 registered" (was 30) — new hook counted

# 3. Simulate Stop — integrity.sh runs silently on clean state
bash tools/integrity.sh > /dev/null 2>&1 || echo "would surface"
# Expected: exit 1 (INV-5 fails — orphans still there)
```

### After Commit 3 (cleanup)
```bash
# 1. Orphans gone
ls .claude/.claude 2>&1 | grep "No such"
ls .claude/tmp 2>&1 | grep "No such"

# 2. Integrity passes
bash tools/integrity.sh
# Expected: exit 0, "2 invariants, 0 violations"

# 3. Git status clean (no new untracked)
git status --porcelain | grep -E "^\?\? \.claude/\.claude/|^\?\? \.claude/tmp/"
# Expected: empty
```

## Commit messages (planned)

### Commit 1
```
S222: harden hooks PROJECT_ROOT resolution (env var + git fallback + sanity)

11 hooks em hooks/*.sh padronizados:
  PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel)}"
+ sanity check: abort se basename == ".claude"

Previne classe de bug "orfao .claude/.claude/apl/" (gerado quando
script e copiado 2-deep e dirname/.. resolve para .claude/ em vez
de repo root). Pattern ja usado em .claude/hooks/post-global-handler.sh.

Coautoria: Lucas + Opus 4.7
```

### Commit 2
```
S222: wire integrity.sh to Stop hook (async, silent on pass)

.claude/settings.local.json: adicionar integrity.sh ao Stop array.
Async (nao bloqueia session end). Silencia stdout em sucesso, emite
linha se exit != 0. Report detalhado em .claude/integrity-report.md.

Fecha loop "invariantes detectam mas nada roda automaticamente".

Coautoria: Lucas + Opus 4.7
```

### Commit 3
```
S222: cleanup orphans .claude/.claude/ + .claude/tmp/

Apos commits 1+2 garantirem nao-regressao:
- rm -rf .claude/.claude/ (4 files APL cache desviado)
- rm -rf .claude/tmp/ (5 copias antigas de hooks)

INV-5 passa (0 violations). Integrity report limpa.

Coautoria: Lucas + Opus 4.7
```

## Next (nao este fluxo)

Apos (e)(d)(f) fechados:
- (a) INV-1 md-destino — frontmatter + whitelist
- (b) INV-3 pointer resolution — ataca CLAUDE.md:63+73 DEAD-REFs
- (c) INV-4 count integrity — SCHEMA vs MEMORY reconciliation
- Surface integrity violations em session-start (leitura do report + display)

## Critical files (to modify)

- `hooks/apl-cache-refresh.sh` (canonical pattern target)
- `hooks/ambient-pulse.sh`
- `hooks/post-tool-use-failure.sh`
- `hooks/pre-compact-checkpoint.sh`
- `hooks/post-compact-reread.sh`
- `hooks/session-compact.sh`
- `hooks/nudge-commit.sh`
- `hooks/session-start.sh`
- `hooks/session-end.sh`
- `hooks/stop-metrics.sh`
- `hooks/stop-quality.sh`
- `.claude/settings.local.json` (wire integrity)
