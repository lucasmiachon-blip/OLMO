# Multi-Window Coordination

> Lucas trabalha em 2-3 janelas Claude Code simultaneamente.
> Esta regra define o contrato de coordenacao.

## Roles

### Orquestrador (1 janela unica)
- Edita arquivos do repo (Edit/Write)
- Faz commits
- Integra resultados dos workers
- Lanca subagents
- Decide o que entra no repo

### Worker (1-2 janelas adicionais)
- **Read-only** no repo (Read, Glob, Grep, Bash read-only)
- Pode usar MCPs (PubMed, Consensus, Scite, NLM, Gemini API)
- Pode usar WebSearch/WebFetch
- Escreve APENAS em `.claude/workers/{task-name}/`
- **NUNCA** faz commit
- **NUNCA** edita slides, evidence, scripts, config, agents, rules, hooks
- Ao terminar: cria `.claude/workers/{task-name}/DONE.md`

## Pasta de workers

```
.claude/workers/
  {task-name}/
    output.md      ← resultados do worker
    DONE.md        ← sinal de conclusao (template abaixo)
```

- Gitignored (output temporario)
- Orquestrador consome e apaga apos integrar

## Template DONE.md

```markdown
# Worker Signal: {task-name}
Status: COMPLETE | PARTIAL | FAILED
Timestamp: {ISO datetime}
Session: S{N}

## Resumo
{2-3 linhas do que foi feito}

## Arquivos criados
- .claude/workers/{task}/output.md — {descricao}

## Sugestoes para orquestrador
- {acao sugerida}

## Pendencias (se PARTIAL/FAILED)
- {o que falta e por que}
```

## Ativacao

Quando o usuario disser **"worker mode"**, **"voce e um worker"**, ou **"modo worker"**:
1. Criar flag: rodar `echo "worker" > .claude/.worker-mode` via Bash
2. Criar pasta da tarefa: `mkdir -p .claude/workers/{task-name}/`
3. Confirmar: "Worker mode ativo. Escrevendo em .claude/workers/{task-name}/. Write/Edit bloqueado fora desta pasta."
4. Perguntar a tarefa se o usuario nao especificou

Quando o usuario disser **"orquestrador"** ou nao disser nada: modo padrao (sem .worker-mode).

## Enforcement

- Regra (este arquivo) — auto-loaded em todas as sessoes do repo
- Hook: `guard-worker-write.sh` — bloqueia Write/Edit fora de `.claude/workers/` quando `.worker-mode` existe
- Ao encerrar worker: remover flag com `rm .claude/.worker-mode`

## Cross-repo

- OLMO (`C:\Dev\Projetos\OLMO`) — repo principal
- OLMO_COWORK (`C:\Dev\Projetos\OLMO_COWORK`) — repo cowork
- Cada repo tem seu proprio orquestrador. NAO editar repo alheio.
