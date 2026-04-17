# S223 — Passo 0 Validation Report (S222 infra)

> Session: S223 | 2026-04-17 | Scope: validar-s222-only
> Verdict: **2 PASS / 1 FAIL / 1 INCONCLUSIVE** — S222 infra PARCIALMENTE TEATRO

## Resumo

| Check | Descrição | Verdict |
|-------|-----------|---------|
| #1 | Orphan dirs `.claude/.claude` e `.claude/tmp` ausentes | PASS |
| #2 | Integrity.sh Stop[5] fires automatico por turno | **FAIL** |
| #3 | Sanity check aborta quando PROJECT_ROOT resolve para `.claude` | PASS |
| #4 | Hook-log mostra SessionEnd pos-S222 com PROJECT_ROOT hardened | INCONCLUSIVE |

---

## Check #1 — Orphan dirs ausentes (PASS)

**Comando:**
```bash
ls -la .claude/.claude .claude/tmp 2>&1 | head -5
```

**Output:**
```
ls: cannot access '.claude/.claude': No such file or directory
ls: cannot access '.claude/tmp': No such file or directory
```

**Interpretação:** orfaos deletados em S222 nao retornaram em S223 session start. Classe de bug parece sob controle — mas prova apenas que o HOOK atual de S223 start nao gerou orfao. Nao testa a vulnerabilidade original (PROJECT_ROOT mal-resolvido).

---

## Check #2 — Stop[5] auto-fire (FAIL)

**Baseline capturada no inicio da sessao:**
```
2026-04-17 00:39:43.719534400 -0300
```

**mtime apos ~8h22min de S223 (multiplos Stop events por turno):**
```
2026-04-17 00:39:43.719534400 -0300
```

**Wall clock no momento do check:** `2026-04-17T12:22:13Z` (09:22 BRT)

**Report header (ainda fossil de S222):**
```
# Integrity Report — S20260417 2026-04-17 00:39
```

**Interpretação:** o registro em `.claude/settings.json:372-379`:
```json
{
  "type": "command",
  "command": "bash $CLAUDE_PROJECT_DIR/tools/integrity.sh > /dev/null 2>&1 || echo '[INTEGRITY] violations -- see .claude/integrity-report.md'",
  "timeout": 10000,
  "async": true
}
```
NAO produziu efeito observavel em nenhum dos ~8 turns desta sessao. Hipoteses:
- (a) Harness nao invoca Stop hooks em ambiente Windows da forma esperada
- (b) `async: true` + redirect silencia falha de invocacao (comando nao encontrado? shell quote issue?)
- (c) `$CLAUDE_PROJECT_DIR` nao expandido em Stop context
- (d) Stop event nao dispara o hook tipo "command" corretamente

**Consequencia:** S222 commit `a573fff` ("context weight disables + slide/CSS frozen + arrumar a casa") contem a afirmacao implicita de que integrity.sh roda auto no Stop. **Isso e falso observado.** O report era fossil de `bash tools/integrity.sh` manual as 00:39 local.

**HANDOFF S222 linha 12** ja alertava: "bash tools/integrity.sh manual → 0 violations — manual, nao Stop automatico". A honestidade estava la, mas o fix real nao foi feito.

---

## Check #3 — Sanity check forcado (PASS)

**Comando:**
```bash
CLAUDE_PROJECT_DIR="$(pwd)/.claude" bash hooks/session-start.sh
```

**Resultado:**
- exit code: `1`
- stderr: `ERROR: PROJECT_ROOT resolved to .claude -- hook aborted`
- stdout: vazio

**PIPESTATUS confirmatorio:** `[1 0]` (script exit 1, head exit 0).

**Interpretação:** sanity check em `hooks/session-start.sh:8` funciona corretamente. Se `$CLAUDE_PROJECT_DIR` ficar mal-setado para `.claude/`, o hook aborta antes de escrever `/tmp/cc-session-id.txt` (linha 21) ou cat HANDOFF. Defense-in-depth validado — mas o gatilho real (qual evento populara `$CLAUDE_PROJECT_DIR=.claude`) nao foi reproduzido.

---

## Check #4 — Hook-log SessionEnd pos-S222 (INCONCLUSIVE)

**SessionEnd timestamps em `.claude/hook-log.jsonl`:**
```
2026-04-16T15:48:23Z
2026-04-16T17:01:53Z
2026-04-16T18:18:07Z
2026-04-16T18:54:44Z
2026-04-16T22:12:01Z
2026-04-16T23:35:48Z
2026-04-17T01:48:23Z
2026-04-17T02:10:30Z
2026-04-17T02:56:52Z
```

**Commit S222 final:** `a573fff` @ `2026-04-17T03:39:29Z UTC` (00:39:29 -0300 BRT)

**SessionEnd pos-S222:** **zero entries**.

**Cobertura do logger (`hooks/lib/hook-log.sh`):**
- `SessionEnd` (via `hooks/session-end.sh:41`)
- `PostToolUseFailure` (via `hooks/post-tool-use-failure.sh`)
- `Stop` warnings (via `hooks/stop-quality.sh` seletivamente)

**Events encontrados no log:** `PostToolUseFailure` (32), `SessionEnd` (9), `test` (1). Zero `Stop`.

**Interpretação:** inconclusive por 2 razoes:
1. S223 ainda em andamento — `session-end.sh` so dispara em fim real. Nao ha SessionEnd registrado pos-S222 simplesmente porque nenhuma sessao entre S222 e S223 encerrou gracefully ate agora (esta sessao nao terminou ainda).
2. Mesmo quando terminar, se Stop[5] nao fira (Check #2 FAIL), nao ha razao forte para acreditar que SessionEnd fira — mesma classe de problema.

**O proximo fim de sessao grava ou nao grava SessionEnd?** Unica forma de desambiguar: completar S223, iniciar S224, ler `hook-log.jsonl`.

---

## Classe de bug reaberta

**`.claude/plans/buzzing-wondering-hickey.md` Commit 2** declara:
> Wire integrity.sh to Stop hook

A wiring foi feita em `.claude/settings.json:372-379`. **Mas a invocacao harness-side nao esta executando.** Isso vai alem de PROJECT_ROOT — e um problema de dispatch de Stop hook em si.

Candidatos a investigar em S224:
1. Permissao de Stop hook — `.claude/settings.json:permissions.allow` nao lista Stop explicitamente (so Skills/Bash/etc).
2. Harness log externo — Claude Code proprio mantem log de invocacao de hooks em algum lugar do OS/perfil (nao o `hook-log.jsonl` deste projeto). Localizar.
3. Testar command-type Stop hook simples (echo > /tmp/stop-ping.txt) para isolar se e dispatch ou se e o integrity.sh especifico.
4. Async + redirect pode mascarar falha de expansao de var. Testar com `async: false` + stderr visivel.

---

## Efeito paralelo — CLAUDE_CODE_DISABLE_1M_CONTEXT removido

Hipotese Lucas: flag inflacionava peso percebido de contexto.

Observacao objetiva desta sessao: `/context` mostrou `31k/200k (15%)` apos ~8h. Sem baseline S222 comparavel, impossivel dizer se removendo o flag reduziu peso. Manter removido por 1 sessao completa e comparar ao fim.

---

## Proximo passo (S224)

1. **Passo 0 bis:** diagnosticar por que Stop[5] integrity.sh nao dispara. Teste minimo: substituir por `echo "stop-fired $(date)" >> /tmp/stop-trace.txt` async:false, observar se grava.
2. Se dispatch de Stop hook command-type nao funciona no Windows: considerar migrar integrity.sh para SessionEnd hook (onde logger prova que funciona) ou para pre-commit.
3. Reabrir `buzzing-wondering-hickey.md` com adendo deste report.
