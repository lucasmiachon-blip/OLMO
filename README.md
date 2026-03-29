# AI Agent Ecosystem

Ecossistema de agentes AI para pesquisa medica baseada em evidencias, ensino e automacao pessoal.

## Quick Start

```bash
uv sync --extra dev    # install dependencies
make check             # lint + type-check + test
make status            # show agent tree
```

## Architecture

```
Orchestrator (Opus 4.6) --- rota, planeja, decide
├── Cientifico (Sonnet) --- papers, PubMed, hipoteses
├── Automacao (Haiku)   --- regras, pipelines, cron
├── Organizacao (Sonnet)--- GTD, Eisenhower, Notion
└── AtualizacaoAI (Sonnet) --- modelos, tools, benchmarks
```

## Development

```bash
make lint        # ruff check
make format      # ruff format
make type-check  # mypy
make test        # pytest
make test-cov    # pytest + coverage
```

## Stack

- Python 3.11+, uv, ruff, mypy, pytest
- 13 MCP servers (Notion, PubMed, Gmail, Gemini, Perplexity...)
- Claude Code (Opus 4.6 orchestrator + Sonnet/Haiku subagents)
