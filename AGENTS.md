# Instruções do Agente - Organizacao

Projeto: ecossistema de agentes AI (orquestrador + científico, automação, organização, atualizacao AI). Python 3.11+, type hints, async.

## Regras rápidas

- **Sempre** seguir convenções em `.cursor/rules/` (core, Python, agents, docs, YAML).
- **Não duplicar** conteúdo de arquivos do repo nas regras; referenciar (`CLAUDE.md`, `config/ecosystem.yaml`, `docs/BEST_PRACTICES.md`, etc.).
- **Coautoria AI**: creditar modelos em output compartilhado; ver `.claude/rules/coauthorship.md`.
- **Config**: YAML em `config/`; secrets em `.env` / `config/keys/`.
- **Ao encerrar sessão**: sugerir atualização de `HANDOFF.md`.

## Notion (workspace principal)

- **Todo o trabalho é executado no Notion.** Página principal do projeto: [Lucas Miachon](https://www.notion.so/Lucas-Miachon-2f6dfe6859a8812b9bb4d93e3bf4f401). Usar para publicar resultados, tarefas, digest, MBE e conhecimento unificado; MCP Notion com protocolo em `.claude/rules/mcp_safety.md`.

## Onde está o quê

| Tema | Arquivo / pasta |
|------|------------------|
| Arquitetura e stack | `CLAUDE.md`, `docs/ARCHITECTURE.md` |
| Objetivos e KPIs | `ECOSYSTEM.md` |
| Agentes e modelos | `config/ecosystem.yaml`, `orchestrator.py` |
| Budget e rate limits | `config/rate_limits.yaml` |
| MCP e segurança | `config/mcp/servers.json`, `.claude/rules/mcp_safety.md` |
| Boas práticas | `docs/BEST_PRACTICES.md` |
| Setup e pendências | `PENDENCIAS.md`, `HANDOFF.md` |

## Qualidade

- Python: `ruff check .` e `pytest tests/`.
- Regras: concisas, acionáveis, <500 linhas; exemplos concretos quando ajudar.
