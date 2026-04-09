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

## Enforcement

- v1: convencao + regra (este arquivo)
- Hook guard: NAO implementado. Adicionar se violacoes recorrerem (KBP pattern)
- Worker identifica-se com: `echo "worker" > .claude/.worker-mode` (opcional)

## Cross-repo

- OLMO (`C:\Dev\Projetos\OLMO`) — repo principal
- OLMO_COWORK (`C:\Dev\Projetos\OLMO_COWORK`) — repo cowork
- Cada repo tem seu proprio orquestrador. NAO editar repo alheio.
