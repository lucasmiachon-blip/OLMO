# Guia de Inicio Rapido

> Perfil: Medico + Professor + Pesquisador + Developer AI
> Checklist completo: `.claude/BACKLOG.md` §Setup & Infra | Seguranca Notion: `.claude/rules/mcp_safety.md`

## Pre-requisitos

- Python 3.11+
- Node.js 20+ (para MCPs via npx e aulas)
- Claude Code CLI instalado

## Instalacao

```bash
# Clone o repositorio
git clone <repo-url>
cd OLMO

# Python
python -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"

# Aulas (Node.js)
cd content/aulas && npm install && cd ../..

# Variaveis de ambiente
cp .env.example .env
# Edite .env com suas API keys (ver .claude/BACKLOG.md §Setup & Infra)
```

## MCPs Configurados (ver `config/mcp/servers.json`)

**Conectados (9)** — maioria via claude.ai (OAuth, $0):
- **Medicos**: PubMed, SCite, Consensus, Scholar Gateway
- **Produtividade**: Notion, Canva, Excalidraw (Gmail+Calendar purged S229)
- **Pesquisa**: NotebookLM, Zotero

Perplexity: API direta (nao MCP). Gemini: CLI OAuth + API key (scripts).

```bash
# Notion MCP (publicacao de conteudo)
# IMPORTANTE: ler .claude/rules/mcp_safety.md ANTES de usar (bugs conhecidos)
claude mcp add --transport http notion https://mcp.notion.com/mcp
```

## Uso Basico

```bash
# Ver status do ecossistema
python orchestrator.py status

# Executar workflows disponiveis (pos-slim S228+S229)
python orchestrator.py workflow weekly_deep_review
python orchestrator.py workflow smart_query
python orchestrator.py workflow code_review

# Producer workflows (paper_to_notion, weekly_medical_digest, etc.) migrados para OLMO_COWORK (ADR-0002).
# Daily org/matriz (full_organization, notion_cleanup) migrados em S229.
```

## Uso com Claude Code

```bash
# Pesquisa medica rapida
claude "busque no PubMed sobre metformina e cancer coloretal"

# Analise MBE completa (consumer — gera living HTML local)
claude "analise este paper com GRADE e gere living HTML: [PMID]"

# Notion audit/add (crosstalk pattern — interativo)
claude "audite minha pagina Notion X e adicione secao Y"
```

## Estrutura do Projeto

```
OLMO/
├── CLAUDE.md                 # Instrucoes root
├── CHANGELOG.md              # Historico (ultimas 3 sessoes; arquivo em docs/)
├── .claude/BACKLOG.md        # Backlog + setup checklist
├── HANDOFF.md                # Continuidade entre sessoes
├── orchestrator.py           # Entry point Python
├── agents/                   # Runtime Python (slim pos-S229 — consumer-only)
│   ├── core/                 # Base, Orchestrator, MCP Safety
│   └── automation/           # Automacao (unico agent)
├── subagents/                # Subagentes
│   └── processors/           # DataPipeline (unico subagent)
├── content/aulas/            # Subsistema Node.js (deck.js + GSAP)
│   ├── shared/               # Design system (CSS OKLCH, deck.js, engine.js, fonts)
│   ├── cirrose/              # 11 slides ativos + 35 archived
│   ├── grade/                # 58 slides (migrada, precisa redesign)
│   ├── scripts/              # Linters compartilhados
│   └── STRATEGY.md           # Roadmap tecnico
├── assets/                   # Concurso R3 (provas + SAPs, gitignored)
├── .claude/
│   ├── skills/ (~17)         # Sob demanda (progressive disclosure; 3 purged S229)
│   ├── rules/ (10)           # Sempre carregadas (path-scoped)
│   ├── agents/ (8)           # researcher, qa-engineer, evidence-researcher, etc.
│   └── hooks/ (11)           # Guards + antifragile hooks
├── hooks/ (11)               # Session lifecycle + stop hooks + chaos report
├── config/
│   ├── ecosystem.yaml        # Agentes + model routing + skills
│   ├── mcp/servers.json      # MCP server configs
│   └── rate_limits.yaml      # Budget
└── docs/                     # Documentacao tecnica
```

## Ordem de Setup Recomendada

1. API keys no `.env` (ver `docs/keys_setup.md`)
2. MCPs nativos claude.ai: ja conectados via OAuth (PubMed, Notion, etc.)
3. MCPs locais: Perplexity (`PERPLEXITY_API_KEY`), Zotero, NotebookLM
4. Gemini: CLI OAuth (`gemini auth login`) + API key for scripts (`GEMINI_API_KEY`)
5. Aulas: `cd content/aulas && npm install && npm run dev`
6. Python: `make check` (lint + mypy + pytest)
7. Docker: `docker compose up -d` (OTel + Langfuse observability)

Full architecture: `docs/ARCHITECTURE.md`
