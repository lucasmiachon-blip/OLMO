# OLMO — AI Agent Ecosystem

Ecossistema de agentes AI para pesquisa medica baseada em evidencias, ensino e automacao pessoal.

## Quick Start

```bash
uv sync --extra dev    # install dependencies
make check             # lint + type-check + test
```

## Architecture

```
Orchestrator (Opus 4.6) --- rota, planeja, decide
├── Cientifico (Sonnet) --- papers, PubMed, hipoteses
├── Automacao (Haiku)   --- regras, pipelines, cron
├── Organizacao (Sonnet)--- GTD, Eisenhower, Notion
└── AtualizacaoAI (Sonnet) --- modelos, tools, benchmarks
```

Full architecture with Mermaid DAGs: `docs/ARCHITECTURE.md`

## Development

```bash
make lint        # ruff check
make format      # ruff format
make type-check  # mypy
make test        # pytest (53 tests)
```

## Stack

- Python 3.11+, uv, ruff, mypy, pytest
- 11 MCP servers (Notion, PubMed, SCite, Consensus, Gmail, Zotero...)
- Claude Code (Opus 4.6 orchestrator + 8 agents + 22 hooks)
- OTel + Langfuse V3 observability (Docker Compose)
- 7-layer antifragile stack (Taleb L1-L7)
