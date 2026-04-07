# Plan: S102 ULTIMA_INFRA

## Context

Esta e a ULTIMA sessao de infraestrutura. Apos ela, foco muda para conteudo/slides/ensino.
Objetivo: fechar todos os items pendentes de infra — fixar o que vale a pena, documentar o resto
como limitacao conhecida, deixar o sistema auto-explicativo para manutencao futura.

## Estado Residual

### Batch 6 (6/26 restantes — 20 resolvidos S101)
| ID | Status | Razao |
|----|--------|-------|
| B6-15 | VERIFIED OK | README accurate |
| B6-18 | INTENTIONAL | Broad matcher `.*` harmless (enforce exempts reads) |
| B6-19 | INTENTIONAL | Double-ask Write/Edit aceito (B5-05 decision) |
| B6-20 | VERIFIED OK | Chaos ordering correct |
| B6-22 | TIMEOUT TUNING | guard-lint-before-build 15s vs worst-case 63s |
| B6-23 | TIMEOUT TUNING | lint-on-edit 15s, acceptable (monitor) |

### Batch 7 (8/10 restantes — B7-01=FP, B7-08=fixed)
| ID | Sev | Decisao | Razao |
|----|-----|---------|-------|
| B7-02 | P2 | ACCEPT | KBP-02 prompt-only. Hook design complexo vs beneficio marginal |
| B7-03 | P2 | ACCEPT | KBP-04 prompt-only. Idem |
| B7-04 | P2 | ACCEPT | guard-pause whitelist memory/plans = risco baixo, by design |
| B7-05 | P2 | ACCEPT | 3-commit lookback = heuristica boa o suficiente |
| B7-06 | P2 | FIX | Cost brake hourly→session-scope. Quick: session-start gera ID, hook usa |
| B7-07 | P2 | ACCEPT | Chaos timing post-facto ok |
| B7-09 | P1 | TEST | Chaos production test. Unica P1 restante |
| B7-10 | P2 | FIX | GNU stat/date → portable. Quick fix |

## Plano de Execucao (5 blocos)

### Bloco 0: Momentum brake — exemptar Bash (UX fix recorrente)
**Problema**: `momentum-brake-enforce.sh` faz "ask" em TODO Bash apos a 1a tool.
Bash de leitura (ls, git status, echo session-name) causa friccao recorrente.
`guard-bash-write.sh` ja protege contra bash destrutivo — duplicacao desnecessaria.

**Fix**: Adicionar `Bash|ToolSearch` ao case exempt em `momentum-brake-enforce.sh` (linha 46).
- Arquivo: `.claude/hooks/momentum-brake-enforce.sh`
- De: `Read|Grep|Glob|AskUserQuestion|EnterPlanMode|ExitPlanMode`
- Para: `Read|Grep|Glob|Bash|ToolSearch|AskUserQuestion|EnterPlanMode|ExitPlanMode`
- Atualizar comentario header (linhas 6-13)
- **Safety net permanece**: guard-bash-write.sh (write patterns), guard-secrets.sh (secrets)

### Bloco 1: Quick fixes (parallel)
1. **B6-22**: Aumentar timeout `guard-lint-before-build.sh` de 15000→30000ms em `settings.local.json`
   - Arquivo: `.claude/settings.local.json` linha 183
2. **B7-10**: Substituir GNU `stat --format` e `date -d` por alternativas portaveis em `pre-compact-checkpoint.sh`
   - Arquivo: `hooks/pre-compact-checkpoint.sh` linhas 17-19
3. **B7-06**: Session-scope counter para cost-circuit-breaker
   - `hooks/session-start.sh`: gerar `SESSION_ID` e gravar em `/tmp/cc-session-id.txt`
   - `.claude/hooks/cost-circuit-breaker.sh`: usar session ID em vez de `date '+%Y%m%d_%H'`

### Bloco 2: Chaos production test (B7-09)
- Rodar uma sessao curta com `CHAOS_MODE=1 CHAOS_PROBABILITY=20`
- Verificar output do stop-chaos-report
- Validar que L2 (model-fallback) e L3 (cost-brake) reagem
- Arquivar report

### Bloco 3: Documentacao de closure
- Adicionar coluna "Resolution" nos batch files com status final de cada item
- Atualizar README.md hooks com correcoes doc pendentes (B6-16, B6-17 se nao feitos S101)

### Bloco 4: Feedback memory + session closure
- Salvar feedback: "Write so em situacoes excepcionais, so orquestrador com permissao do Lucas"
- Salvar feedback: "Bash de leitura (ls, git, echo metadata) nao deve pedir aprovacao — friccao recorrente"
- Atualizar HANDOFF.md: "Infra COMPLETA. Batches 6+7 closed."
- Atualizar CHANGELOG.md
- Commit

## Arquivos Criticos
- `.claude/hooks/momentum-brake-enforce.sh` (Bash exempt — UX fix)
- `.claude/settings.local.json` (timeout fix)
- `hooks/pre-compact-checkpoint.sh` (GNU compat)
- `.claude/hooks/cost-circuit-breaker.sh` (session-scope)
- `hooks/session-start.sh` (session ID gen)
- `.claude/plans/batch-6-findings.md` (closure annotations)
- `.claude/plans/batch-7-findings.md` (closure annotations)

## Verificacao
- `bash hooks/session-start.sh < /dev/null` → verifica session ID gerado
- `cat /tmp/cc-session-id.txt` → confirma arquivo existe
- `bash -n hooks/pre-compact-checkpoint.sh` → syntax check
- `bash -n .claude/hooks/cost-circuit-breaker.sh` → syntax check
- CI (53 testes) deve permanecer verde
