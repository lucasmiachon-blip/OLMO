# S223 — Validar S222 (Passo 0 only)

## Context

HANDOFF S222 admite que a infra foi **codificada mas não validada**. Três classes de dúvida permanecem:

1. Integrity report é de Stop[5] automático ou de run manual pré-commit?
2. Sanity check (`basename == ".claude" && exit 1`) realmente dispara em PROJECT_ROOT mal-resolvido?
3. Hooks funcionam em SessionEnd real com o novo resolver (`${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel)}`)?

Lucas escolheu foco `validar-s222-only`: executar os 4 checks do Passo 0, registrar evidência honesta, decidir PASS/FAIL. Sem Track A nem B nesta sessão.

Paralelamente, Lucas removeu `CLAUDE_CODE_DISABLE_1M_CONTEXT` de `.claude/settings.json` no início da sessão — teste lateral da hipótese "flag causava peso percebido". Não é o foco, mas deve ser logado.

## Evidência já coletada (Phase 1 read-only)

| Check | Evidência | Status interino |
|-------|-----------|-----------------|
| #1 orphans ausentes | `ls -la .claude/.claude .claude/tmp` → "No such file or directory" | **PASS provisório** |
| #2 integrity-report timestamp | Report stamp `2026-04-17 00:39`; commit S222 final `a573fff` às 00:39:29 -0300 | **INDETERMINADO** — precisa de Stop event novo para desambiguar |
| #3 sanity check | `hooks/session-start.sh:8` verifica antes de qualquer side-effect (rm na linha 14) → forçar é seguro | **Pendente execução** |
| #4 hook-log | 5 SessionEnd em `.claude/hook-log.jsonl`; último `2026-04-17T02:56:52Z` (23:56 BRT Apr 16). **Nenhum após commit S222** | **SUSPEITO** — ausência de trace pós-S222 |

## Execution plan (pós-aprovação)

### Etapa 1 — Baseline de timestamp
Capturar mtime atual do integrity report antes de qualquer ação:
```bash
stat -c '%y' .claude/integrity-report.md > /tmp/pre-mtime.txt
cat /tmp/pre-mtime.txt
```

### Etapa 2 — Check #3 (sanity check forçado)
```bash
CLAUDE_PROJECT_DIR="$(pwd)/.claude" bash hooks/session-start.sh 2>&1 | head -3
echo "exit=$?"
```
**Expected:** `ERROR: PROJECT_ROOT resolved to .claude -- hook aborted` + `exit=1`.
FAIL se stdout contiver conteúdo de HANDOFF ou se exit != 1.

### Etapa 3 — Check #4 (hook-log scan completo)
```bash
grep -E '"event":"(SessionEnd|Stop)"' .claude/hook-log.jsonl | \
  awk -F'"ts":"' '{print $2}' | awk -F'"' '{print $1}' | sort -u | tail -30
```
Listar todos SessionEnd/Stop timestamps. Confirmar se há qualquer entry após `2026-04-17T03:39Z` (commit S222). Se nenhum → infra não está sendo exercida ou não grava log.

### Etapa 4 — Check #2 (Stop[5] auto-firing)
Forçar ciclo Stop natural (fim desta sessão ou fim de uma interação). Então:
```bash
stat -c '%y' .claude/integrity-report.md
diff /tmp/pre-mtime.txt <(stat -c '%y' .claude/integrity-report.md)
```
**PASS:** mtime > baseline (Stop[5] regenerou report automaticamente).
**FAIL:** mtime inalterado → Stop[5] não dispara auto; report é fóssil de S222 manual.

### Etapa 5 — Consolidação
- Escrever `.claude/plans/s223-validation-report.md` com 4 resultados + evidência bruta
- Atualizar `CHANGELOG.md` com linha única: `S223: Passo 0 validação S222 — [N/4] PASS`
- Atualizar `HANDOFF.md`:
  - Se **4/4 PASS**: remover seção "HONESTIDADE S222", declarar infra VALIDADA, Lucas escolhe Track A ou B na S224
  - Se **qualquer FAIL**: reabrir `.claude/plans/buzzing-wondering-hickey.md` com evidência; HANDOFF aponta classe de bug identificada

### Etapa 6 — Log do teste 1M-context
Entrada no CHANGELOG separada:
```
S223: test — CLAUDE_CODE_DISABLE_1M_CONTEXT removed (hipótese: flag inflaciona context harness-side)
```
Sem decisão sobre manter/reverter nesta sessão — só observação.

## Files to modify

- `.claude/plans/s223-validation-report.md` (novo, evidência bruta dos 4 checks)
- `CHANGELOG.md` (append 2 linhas S223)
- `HANDOFF.md` (edit Edit tool, preservar DECISOES/CUIDADOS/PENDENTES)
- `.claude/plans/buzzing-wondering-hickey.md` (só se FAIL)

## Reused artifacts (não reimplementar)

- `tools/integrity.sh` — já existe, gera o report
- `hooks/session-start.sh:8` — sanity check já presente, só forçar invocação
- `.claude/hook-log.jsonl` — já é source of truth para trace

## Verification (end-to-end)

1. `.claude/plans/s223-validation-report.md` existe e lista 4/4 com evidência bruta (stdout capturado, timestamps reais, exit codes)
2. HANDOFF.md diff visível preservando seções DECISOES/CUIDADOS/PENDENTES (anti-drift §State files)
3. CHANGELOG.md tem exatamente 2 novas linhas S223

## Rollback

- Nenhuma mudança funcional — só observação. Se algo der errado, re-adicionar `CLAUDE_CODE_DISABLE_1M_CONTEXT: "1"` em `.claude/settings.json:12` (diff na history desta sessão).

## Out of scope (explicit)

- Track A (context weight attack)
- Track B (semantic truth-decay INV-3/4/1)
- Memory merges (9 pendentes)
- Hooks resto (momentum-brake Bash exemption, PostToolUseFailure evento, `/tmp/cc-session-id.txt` compartilhado)
- Slides, CSS, content work (**FROZEN** per S222 fim)
