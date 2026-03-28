---
name: janitor
description: "Limpeza e manutencao do repositorio. Ativar para remover dead files, corrigir docs stale ou auditar estrutura."
---

# Skill: Janitor (Limpeza de Repositorio)

Limpeza, organizacao e manutencao do repositorio.
Baseada em Claude-Janitor (danielrosehill) + adaptacoes do ecossistema.

## Quando Ativar
- `/janitor` ou "limpar repo", "cleanup", "organizar arquivos"
- Antes de release ou merge importante
- Repositorio com arquivos orfaos, docs desatualizados, codigo morto

## Operacoes (sequenciais, uma por vez)

### 1. Separar Codigo de Documentacao
- Verificar se estrutura de pastas separa codigo de docs
- Sugerir reorganizacao se misturado
- Confirmar com usuario antes de mover

### 2. Organizar Estrutura
- Identificar arquivos fora do lugar
- Agrupar por funcao (config/, docs/, skills/, tests/)
- Nunca mover sem confirmar impacto em imports/paths

### 3. Remover Codigo Legado
- Identificar codigo morto (funcoes nao chamadas, imports nao usados)
- Identificar arquivos placeholder vazios
- Confirmar remocao com usuario

### 4. Limpar Scripts de Diagnostico
- Remover scripts one-off (test_*.py que nao sao testes reais)
- Consolidar scripts similares
- Preservar scripts de setup e CI

### 5. Reduzir Sprawl de Documentacao
- Identificar docs duplicados ou desatualizados
- Consolidar em docs existentes em vez de criar novos
- Preservar README, CLAUDE.md, CHANGELOG, HANDOFF

### 6. Limpar Conteudo de Docs
- Remover linguagem excessiva e redundante
- Garantir precisao tecnica
- Manter tom enxuto e direto

## Processo de Seguranca

1. **ANTES**: `git status` — garantir working tree limpo
2. **DURANTE**: uma operacao por vez, confirmar antes de deletar
3. **DEPOIS**: `git diff` — revisar todas as mudancas antes de commit
4. **NUNCA**: deletar sem confirmar, mover arquivos que quebram imports

## Formato de Output

```
## Janitor Report

### Operacao: [nome]
- Removidos: [lista]
- Movidos: [de → para]
- Consolidados: [lista]
- Mantidos (justificativa): [lista]

### Resumo
- Arquivos removidos: N
- Arquivos movidos: N
- Linhas removidas: ~N
- Espaco liberado: ~N KB
```

## Protecoes

- NUNCA deletar: CLAUDE.md, HANDOFF.md, CHANGELOG.md, .claude/
- NUNCA deletar sem git commit anterior (safety net)
- Arquivos > 30 dias sem modificacao: flag para review, nao auto-delete
- Em duvida: perguntar ao usuario

## Eficiencia
- Modelo recomendado: Sonnet (analise) + Haiku (listagem)
- Registrar custo no BudgetTracker
