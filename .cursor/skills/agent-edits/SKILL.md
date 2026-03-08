---
name: agent-edits
description: Aplica padrões ao editar agentes, orquestrador ou config do ecossistema. Use ao modificar agents/, subagents/, orchestrator, config/ecosystem.yaml ou rate_limits.
---

# Edições em Agentes e Config

## Ao editar código de agente

1. Manter type hints e async onde já existir; não remover anotações.
2. Carregar config via `config/loader`; não hardcodar modelo ou URLs.
3. Writes/Notion: sem retry automático (ver `.claude/rules/mcp_safety.md`).
4. Logar erros com contexto; não `except: pass`.
5. Rodar `ruff check .` e `pytest tests/` após mudanças relevantes.

## Ao editar config (ecosystem.yaml, rate_limits.yaml)

1. Chaves em snake_case; comentários em PT quando explicarem regra.
2. Ao adicionar agente/subagente: espelhar estrutura existente em `config/ecosystem.yaml`.
3. Budget: manter `max_budget_usd` e rate limits consistentes com `docs/BEST_PRACTICES.md` (Willison/Karpathy).
4. Não colocar secrets em YAML; usar `.env` ou `config/keys/`.

## Referência

- Arquitetura: `docs/ARCHITECTURE.md`
- Regra agents: `@.cursor/rules/agents-ecosystem.mdc`
