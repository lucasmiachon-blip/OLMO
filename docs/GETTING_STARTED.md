# Guia de Inicio Rapido

> Perfil: Medico + Professor + Pesquisador + Developer AI
> Checklist completo: `.claude/BACKLOG.md` §Setup & Infra | Seguranca Notion: `docs/mcp_safety_reference.md`

## Pre-requisitos

- Python 3.11+
- `uv` (recomendado para instalar deps Python do workspace)
- Node.js 20+ (para MCPs via npx e aulas)
- Claude Code CLI instalado
- Docker Desktop (opcional, so se for usar Langfuse/OTel local)

## Instalacao

```bash
# Clone o repositorio
git clone <repo-url> OLMO_ROADMAP
cd OLMO_ROADMAP

# Python (workspace root)
uv sync --extra dev

# Aulas (Node.js)
cd content/aulas && npm install && cd ../..

# Variaveis de ambiente
cp .env.example .env   # PowerShell: Copy-Item .env.example .env
# Edite .env apenas com as variaveis que voce realmente usa
```

## MCPs — 3 camadas

**Shared inventory** (`config/mcp/servers.json`) — `status:connected`: PubMed, SCite, Consensus, Scholar Gateway (frozen per evidence-researcher), NotebookLM, Zotero, Notion, Canva, Excalidraw. `status:removed`: Perplexity (→ API direta), Gemini (→ CLI OAuth).

**Policy/runtime** (`.claude/settings.json`) — o que é callable sem prompt:
- `pre-approved` (allow): PubMed, SCite, Consensus (via claude.ai) + pubmed/biomcp/crossref (local)
- `blocked by deny`: Notion, Canva, Excalidraw, Scholar Gateway, Zotero, Gmail, Google Calendar
- `not pre-approved by current policy` (unlisted): demais (ex: NotebookLM)

**Agent-scoped** (`.claude/agents/*.md` `mcpServers:` block, **fora** do shared inventory): ex. `evidence-researcher` declara `semantic-scholar` escopado (não em `servers.json`).

**Inventoriado ≠ callable.** Detalhes em `docs/ARCHITECTURE.md §MCP Connections`. Para ativar MCP hoje `blocked by deny`, mover manualmente deny→allow em `.claude/settings.json`.

```bash
# Notion MCP — setup de shared inventory
# IMPORTANTE: ler docs/mcp_safety_reference.md ANTES de usar (bugs conhecidos)
# Nota: runtime atual = blocked by deny em .claude/settings.json; requer reativação manual
claude mcp add --transport http notion https://mcp.notion.com/mcp
```

## Uso Basico

Stack Python runtime (orchestrator.py + workflows YAML) foi retirado do repo em S232 — era vestigial/falido/nunca usado. Orquestração real acontece via Claude Code (subagents + skills + MCPs). Producer workflows migrados para OLMO_COWORK (ADR-0002). Python remanescente no repo: `scripts/fetch_medical.py` (standalone, httpx-only).

## Uso com Claude Code

```bash
# Pesquisa medica rapida
claude "busque no PubMed sobre metformina e cancer coloretal"

# Analise MBE completa (consumer — gera living HTML local)
claude "analise este paper com GRADE e gere living HTML: [PMID]"

# Notion audit/add (crosstalk pattern — interativo)
# Requer runtime ativo: mcp__claude_ai_Notion__* está blocked by deny em .claude/settings.json — ativar antes
claude "audite minha pagina Notion X e adicione secao Y"
```

## Estrutura do Projeto

```
OLMO_ROADMAP/
├── CLAUDE.md                 # Instrucoes root
├── CHANGELOG.md              # Historico (ultimas 3 sessoes; arquivo em docs/)
├── .claude/BACKLOG.md        # Backlog + setup checklist
├── HANDOFF.md                # Continuidade entre sessoes
# (stack Python runtime retirado S232: orchestrator.py, agents/, subagents/ removidos do repo)
├── content/aulas/            # Subsistema Node.js (deck.js + GSAP)
│   ├── shared/               # Design system (CSS OKLCH, deck.js, engine.js, fonts)
│   ├── cirrose/              # 11 slides ativos + 35 archived
│   ├── grade/                # 58 slides (migrada, precisa redesign)
│   ├── scripts/              # Linters compartilhados
│   └── STRATEGY.md           # Roadmap tecnico
├── assets/                   # Concurso R3 (provas + SAPs, gitignored)
├── .claude/
│   ├── skills/               # Sob demanda (progressive disclosure)
│   ├── rules/                # Sempre carregadas (path-scoped)
│   ├── agents/               # Claude Code subagent definitions
│   └── hooks/                # Guards + antifragile hooks
├── hooks/                    # Session lifecycle + stop hooks
├── config/
│   └── mcp/servers.json      # MCP server configs
└── docs/                     # Documentacao tecnica
```

## Ordem de Setup Recomendada

1. Copiar `.env.example` para `.env` e preencher so o necessario (ver `docs/keys_setup.md`)
2. MCPs nativos claude.ai: `pre-approved` no runtime atual = PubMed, Consensus, SCite. Demais inventariados (ex: Notion, Canva, Scholar Gateway) estão `blocked by deny` — ativar manualmente em `.claude/settings.json` se necessário.
3. Perplexity (API direta via `PERPLEXITY_API_KEY`, **não MCP**); Zotero (inventariado em servers.json, **blocked by deny** no runtime atual); NotebookLM (inventariado, **not pre-approved by current policy**)
4. Gemini: CLI OAuth (`gemini auth login`) + API key for scripts (`GEMINI_API_KEY`)
5. Aulas: `cd content/aulas && npm install && npm run dev`
6. Python (scripts standalone): `uv run ruff check scripts/` + `uv run mypy scripts/` (ou `make lint` + `make type-check` se voce usar `make`)
7. Docker: `docker compose up -d` (OTel + Langfuse observability)

Full architecture: `docs/ARCHITECTURE.md`
