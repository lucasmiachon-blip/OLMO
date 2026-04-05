---
description: CHANGELOG e HANDOFF obrigatorios ao final de toda sessao
---

# Regra: Higiene de Sessao

> CHANGELOG e HANDOFF sao obrigatorios ao final de toda sessao com mudancas.
> Ambos devem ser enxutos — sem verbosidade, sem redundancia.

## HANDOFF.md (max ~30 linhas)

So pendencias. Estrutura: ESTADO ATUAL → PROXIMO → PENDENTE → CONFLITOS.
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
