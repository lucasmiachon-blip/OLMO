---
name: janitor
disable-model-invocation: true
description: "Repository cleanup and maintenance (dead code removal, doc consolidation, structure audit, orphan detection)."
---

# Skill: Janitor (Limpeza de Repositorio)

Limpeza, organizacao e manutencao do repositorio.

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

### Resumo
- Arquivos removidos: N
- Linhas removidas: ~N
```

## Protecoes

- NUNCA deletar: CLAUDE.md, HANDOFF.md, CHANGELOG.md, .claude/
- NUNCA deletar sem git commit anterior (safety net)
- Em duvida: perguntar ao usuario
