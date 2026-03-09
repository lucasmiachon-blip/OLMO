# Regra: Higiene de Sessao

> CHANGELOG e HANDOFF sao obrigatorios ao final de toda sessao com mudancas.
> Ambos devem ser enxutos — sem verbosidade, sem redundancia.

## HANDOFF.md (max ~30 linhas)

So pendencias. Estrutura fixa:

```
# HANDOFF - Proxima Sessao
> Sessao N | DATA

## ESTADO ATUAL
[2-3 linhas: o que funciona agora]

## PROXIMO
[lista numerada: proximos passos concretos]

## PENDENTE
[checklist: backlog medio prazo]

## CONFLITOS
[checklist: bugs/inconsistencias conhecidas]
```

### Regras
- Sem historico — so futuro
- Items completados → remover (ja estao no CHANGELOG)
- Cada item = 1 linha, acao concreta
- Atualizar numero da sessao e data

## CHANGELOG.md (append-only)

Historico do que foi feito. Estrutura por sessao:

```
## Sessao N — DATA

### [Categoria]
- [o que mudou, em 1 linha]

---
Coautoria: Lucas + [modelos] | DATA
```

### Regras
- Append new sessao no topo (mais recente primeiro)
- 1 linha por mudanca — sem explicacao longa
- Categorias: o que faz sentido (Auditoria, Config, Skills, Code, etc.)
- Nao repetir o que ja esta no HANDOFF

## Quando atualizar

- **HANDOFF**: toda sessao que mude estado do projeto
- **CHANGELOG**: toda sessao com commit
- **Ambos**: quando usuario pedir commit/wrap-up
