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

- 21 subagents em `.claude/agents/*.md` (9 core + 7 debug-team + 5 research wrappers).
- 19 skills em `.claude/skills/*/SKILL.md` (progressive disclosure).
- 35 hook registrations em `.claude/settings.json` (33 command hooks + 2 inline prompts).
- MCP servers: shared inventory em `config/mcp/servers.json`; agent-scoped inline em `.claude/agents/*.md`; policy runtime em `.claude/settings.json` (ver `docs/ARCHITECTURE.md §MCP Connections`).

Full architecture: `docs/ARCHITECTURE.md`.

## Development

```bash
make lint        # ruff check scripts/
make format      # ruff format scripts/
make type-check  # mypy scripts/
make aulas-dev   # Vite dev server for slides
```

## Stack

- Python 3.11+ para scripts standalone (`scripts/fetch_medical.py`). Ruff/mypy como dev helpers. Sem runtime Python agent ou test suite Python ativa (purgados S232).
- Shared MCP inventory (`config/mcp/servers.json`, `status:connected`): PubMed, SCite, Consensus, Scholar Gateway (frozen), NotebookLM, Zotero, Notion, Canva, Excalidraw. Policy runtime (`.claude/settings.json`) pode bloquear subset. Agent-scoped adicionais em `.claude/agents/*.md` (ex: `semantic-scholar` em evidence-researcher). Gemini e Perplexity = `removed` (migrados para CLI/API direta, não MCP).
- Claude Code — 21 CC subagents + 19 skills + 35 hook registrations (ver `docs/ARCHITECTURE.md` para contagens exatas)
- OTel + Langfuse V3 observability (Docker Compose)
- 7-layer antifragile stack claim (Taleb L1-L7) — **não auditado end-to-end** (ver `.claude/BACKLOG.md #45`)
