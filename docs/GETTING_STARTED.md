# Guia de Inicio Rapido

> Perfil: Medico + Professor + Pesquisador + Developer AI
> Checklist completo: `PENDENCIAS.md` | Seguranca Notion: `.claude/rules/mcp_safety.md`

## Pre-requisitos

- Python 3.11+
- Node.js 20+ (para MCPs via npx e aulas)
- Claude Code CLI instalado
- Claude Desktop (para Cowork)

## Instalacao

```bash
# Clone o repositorio
git clone <repo-url>
cd organizacao

# Python
python -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"

# Aulas (Node.js)
cd content/aulas && npm install && cd ../..

# Variaveis de ambiente
cp .env.example .env
# Edite .env com suas API keys (ver PENDENCIAS.md)
```

## MCPs Configurados (ver `config/mcp/servers.json`)

**Conectados (13)** — maioria via claude.ai (OAuth, $0):
- **Medicos**: PubMed, SCite, Consensus, Scholar Gateway
- **Produtividade**: Notion, Gmail, Google Calendar, Canva, Excalidraw
- **AI/Pesquisa**: Gemini, Perplexity, NotebookLM, Zotero

**Planejados (3)**: Anki, Google Drive, ChatGPT

```bash
# Notion MCP (publicacao de conteudo)
# IMPORTANTE: ler .claude/rules/mcp_safety.md ANTES de usar (bugs conhecidos)
claude mcp add --transport http notion https://mcp.notion.com/mcp
```

## Uso Basico

```bash
# Ver status do ecossistema
python orchestrator.py status

# Executar workflow medico
python orchestrator.py workflow paper_to_notion
python orchestrator.py workflow weekly_medical_digest
python orchestrator.py workflow quick_note_to_evidence

# Workflows operacionais
python orchestrator.py workflow morning_review
python orchestrator.py workflow weekly_review
```

## Uso com Claude Code

```bash
# Pesquisa medica rapida
claude "busque no PubMed sobre metformina e cancer coloretal"

# Analise MBE completa
claude "analise este paper com GRADE e publique no Notion: [PMID]"

# Digest semanal
claude "gere o digest medico semanal e publique no Notion"
```

## Uso com Cowork (Fontes Pagas)

1. Abrir Claude Desktop → Cowork
2. Criar Skill "Extrair UpToDate" com instrucoes
3. Disparar com 1 clique
4. Cowork loga, extrai, salva em `data/extracted/`
5. Claude Code processa com skill MBE

## Estrutura do Projeto

```
organizacao/
├── CLAUDE.md                 # Instrucoes root (~74 linhas)
├── CHANGELOG.md              # Historico (ultimas 3 sessoes; arquivo em docs/)
├── PENDENCIAS.md             # Checklist de setup e custos
├── HANDOFF.md                # Continuidade entre sessoes
├── orchestrator.py           # Entry point Python
├── agents/                   # Agentes Python (~30% implementados)
│   ├── core/                 # Base, Orchestrator, ModelRouter, MCP Safety, Scheduler
│   ├── scientific/           # Cientifico (MBE, AI/ML, DevOps/MLOps)
│   ├── automation/           # Automacao
│   ├── organization/         # Organizacao (GTD)
│   └── ai_update/            # Atualizacao AI
├── subagents/                # Subagentes especializados
│   ├── processors/           # KnowledgeOrganizer, NotionCleaner, DataPipeline
│   ├── monitors/             # WebMonitor
│   └── analyzers/            # TrendAnalyzer
├── skills/                   # Skills Python reutilizaveis
│   └── efficiency/           # local_first (custo zero)
├── content/aulas/            # Subsistema Node.js (deck.js + GSAP)
│   ├── shared/               # Design system (CSS OKLCH, deck.js, engine.js, fonts)
│   ├── cirrose/              # 44 slides (producao, lint clean)
│   ├── grade/                # 58 slides (migrada, precisa redesign)
│   ├── scripts/              # Linters compartilhados
│   └── STRATEGY.md           # Roadmap tecnico
├── assets/                   # Concurso R3 (provas + SAPs, gitignored)
├── .claude/
│   ├── skills/ (17)          # Sob demanda (progressive disclosure)
│   ├── rules/ (8)            # Sempre carregadas (2 path-scoped)
│   └── agents/ (4)           # researcher, notion-ops, literature, quality-gate
├── hooks/                    # notify.sh, stop-hygiene.sh
├── config/
│   ├── ecosystem.yaml        # Agentes + model routing + skills
│   ├── mcp/servers.json      # 16 MCPs (13 connected, 3 planned)
│   └── rate_limits.yaml      # Budget $100/mes
└── docs/                     # Documentacao tecnica
```

## Ordem de Setup Recomendada

Ver `PENDENCIAS.md` para checklist completo. Resumo:

1. API keys no `.env` (ver `docs/keys_setup.md`)
2. MCPs nativos claude.ai: ja conectados via OAuth (PubMed, Notion, Gmail, etc.)
3. MCPs locais: Gemini (`GOOGLE_AI_KEY`), Perplexity (`PERPLEXITY_API_KEY`), Zotero
4. Aulas: `cd content/aulas && npm install && npm run dev`
5. Python: `make check` (lint + mypy + pytest)
6. Configurar Cowork para fontes pagas
