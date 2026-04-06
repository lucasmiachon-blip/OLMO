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

## Hardening de agentes (checklist S80)

Ao criar ou reescrever agente:
1. **maxTurns**: obrigatorio. Estimar turns reais (scripts + DOM + report) + margem 20%
2. **tools**: verificar que cada tool existe no SDK (ex: `StrReplace` nao existe, usar `Edit`)
3. **1 tarefa = 1 invocacao**: se o agente precisa parar no meio, dividir em invocacoes separadas
4. **Referenciar scripts, nao duplicar**: listar comando, nao reimplementar logica
5. **Gate names descritivos**: Preflight/Inspect/Editorial, nao numeros arbitrarios (-1/0/4)
