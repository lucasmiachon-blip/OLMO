# OLMO — AI Agent Ecosystem (Consumer Side)

Ecossistema consumer para organizacao pessoal medica, ensino e consumo de evidencias.
Producer (scan externo + publish) vive em **OLMO_COWORK** (ver `docs/adr/0002-external-inbox-integration.md`).

## Quick Start

```bash
uv sync --extra dev    # install dependencies
make check             # lint + type-check + test
```

## Architecture

Runtime Python (orchestrator CLI — slim, consumer-only):

```
Orchestrator (dispatch por agent-name ou type-keyword)
├── Automacao (Haiku) --- regras, pipelines, cron
└── Organizacao (Sonnet) --- GTD, Eisenhower, Notion cleanup
```

Claude Code subagents (`.claude/agents/*.md` — research + QA + infra):
`evidence-researcher`, `qa-engineer`, `mbe-evaluator`, `reference-checker`,
`quality-gate`, `researcher`, `repo-janitor`, `notion-ops`.

Full architecture with Mermaid DAGs: `docs/ARCHITECTURE.md`.

## Development

```bash
make lint        # ruff check
make format      # ruff format
make type-check  # mypy
make test        # pytest (53 tests)
```

## Stack

- Python 3.11+, uv, ruff, mypy, pytest (53 tests)
- Multiple MCP servers (PubMed, SCite, Consensus, Semantic Scholar, Zotero, Notion, NotebookLM, Gemini, Perplexity...)
- Claude Code — 2 Python runtime agents + 8 CC subagents + 31 hooks
- OTel + Langfuse V3 observability (Docker Compose)
- 7-layer antifragile stack (Taleb L1-L7 — ver `docs/ARCHITECTURE.md`)
