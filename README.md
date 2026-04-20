# OLMO — AI Agent Ecosystem (Consumer Side)

Ecossistema consumer para organizacao pessoal medica, ensino e consumo de evidencias.
Producer (scan externo + publish) vive em **OLMO_COWORK** (ver `docs/adr/0002-external-inbox-integration.md`).

## Quick Start

```bash
uv sync --extra dev    # install dev dependencies (ruff, mypy, pre-commit)
cd content/aulas && npm install  # install aulas Node stack
```

## Architecture

**Sem runtime Python** (post-S232 v6: stack vestigial purgado). Orquestração = **Claude Code nativo**:

- 9 subagents em `.claude/agents/*.md` (research, QA, infra):
  `evidence-researcher`, `qa-engineer`, `mbe-evaluator`, `reference-checker`,
  `quality-gate`, `researcher`, `repo-janitor`, `sentinel`, `systematic-debugger`.
- 18 skills em `.claude/skills/*/SKILL.md` (progressive disclosure).
- 30 hooks em `.claude/hooks/` + `hooks/` (event-driven lifecycle).
- MCP servers via `config/mcp/servers.json`.

Full architecture: `docs/ARCHITECTURE.md`.

## Development

```bash
make lint        # ruff check scripts/
make format      # ruff format scripts/
make type-check  # mypy scripts/
make aulas-dev   # Vite dev server for slides
```

## Stack

- Python 3.11+, uv, ruff, mypy, pytest (40 tests)
- Multiple MCP servers (PubMed, SCite, Consensus, Semantic Scholar, Zotero, Notion, NotebookLM, Gemini, Perplexity...)
- Claude Code — 1 Python runtime agent + 9 CC subagents + 31 hooks
- OTel + Langfuse V3 observability (Docker Compose)
- 7-layer antifragile stack (Taleb L1-L7 — ver `docs/ARCHITECTURE.md`)
