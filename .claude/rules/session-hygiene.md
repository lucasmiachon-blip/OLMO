---
description: CHANGELOG e HANDOFF obrigatorios ao final de toda sessao
---

# Regra: Higiene de Sessao

> CHANGELOG e HANDOFF sao obrigatorios ao final de toda sessao com mudancas.
> Ambos devem ser enxutos — sem verbosidade, sem redundancia.

## HANDOFF.md (max ~50 linhas)

So pendencias. Estrutura: ESTADO ATUAL → P0/P1 (priority bands) → DECISOES ATIVAS → CUIDADOS → PENDENTE → CONFLITOS.
- Sem historico — so futuro
- Items completados → remover (ja estao no CHANGELOG)
- Cada item = 1 linha, acao concreta
- Atualizar numero da sessao e data

## CHANGELOG.md (append-only)

Historico do que foi feito. Append nova sessao no topo (mais recente primeiro).
- 1 linha por mudanca — sem explicacao longa
- Categorias: o que faz sentido (Config, Skills, Code, etc.)
- Nao repetir o que ja esta no HANDOFF

## Quando atualizar

- **HANDOFF**: toda sessao que mude estado do projeto
- **CHANGELOG**: toda sessao com commit
- **Ambos**: quando usuario pedir commit/wrap-up
- **Sem commit mas com state change** (ex: decisao, pesquisa): atualizar HANDOFF, CHANGELOG opcional

## Pos-consolidacao de agentes

Apos eliminar, criar ou renomear agentes, verificar mecanicamente:
1. `ls .claude/agents/*.md | wc -l` == contagem declarada no HANDOFF
2. Cada arquivo: `filename` (sem .md) == `name:` no frontmatter
3. Tabela HANDOFF lista exatamente os arquivos existentes — sem extras, sem faltantes

## Proactive Checkpoints

Apos completar 2 tarefas complexas de subagent na sessao:
1. Commitar trabalho pendente
2. Atualizar HANDOFF.md com estado atual
3. Sugerir /clear ao usuario se task esta mudando

Quando continuation summary aparecer apos compaction:
1. Imediatamente re-ler HANDOFF.md (summary e lossy)
2. NAO confiar em memoria do contexto pre-compaction

## P0 Security Gate

No inicio da sessao, se HANDOFF.md lista items P0 SECURITY:
1. Surfacea-los para Lucas imediatamente
2. NAO iniciar feature work ate Lucas explicitamente deferir

## Hardening de agentes

Ao criar/reescrever agente: (1) maxTurns obrigatorio (+20% margem), (2) verificar tools existem no SDK, (3) 1 tarefa = 1 invocacao. Script primacy e gate names → anti-drift.md §Script Primacy.

## Artifact cleanup

Before wrap-up: limpar `.claude/*.md` orfaos, `.claude/workers/` consumidos, temp files. Excecao: arquivos que Lucas pediu para manter.
