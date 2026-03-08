# Guia de Inicio Rapido

> Perfil: Medico + Professor + Pesquisador + Developer AI
> Checklist completo: `PENDENCIAS.md` | Seguranca Notion: `.claude/rules/mcp_safety.md`

## Pre-requisitos

- Python 3.11+
- Node.js 18+ (para MCPs via npx)
- Claude Code CLI instalado
- Claude Desktop (para Cowork)

## Instalacao

```bash
# Clone o repositorio
git clone <repo-url>
cd organizacao

# Crie ambiente virtual
python -m venv .venv
source .venv/bin/activate

# Instale dependencias
pip install -e ".[dev]"

# Configure variaveis de ambiente
cp .env.example .env
# Edite .env com suas API keys (ver PENDENCIAS.md)
```

## MCPs Medicos (Prioridade CRITICA)

```bash
# Healthcare MCP (PubMed, FDA, ClinicalTrials, CID-10)
claude mcp add healthcare-mcp npx -- -y healthcare-mcp

# PubMed MCP (busca avancada 39M+ citacoes)
claude mcp add pubmed-mcp npx -- -y pubmed-mcp

# BioMCP (queries em linguagem natural)
claude mcp add biomcp npx -- -y biomcp

# Notion MCP (publicacao de conteudo)
# IMPORTANTE: ler .claude/rules/mcp_safety.md ANTES de usar (bugs conhecidos)
# Usar 2 tokens: read-only (padrao) + read-write (sob demanda)
claude mcp add --transport http notion https://mcp.notion.com/mcp

# Context7 (docs atualizadas de libs)
claude mcp add context7 npx -- -y @anthropic/context7-mcp
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
├── CLAUDE.md                 # Instrucoes root (perfil, KPIs, safety)
├── ECOSYSTEM.md              # Mapa completo do ecossistema
├── PENDENCIAS.md             # Checklist de setup e custos
├── HANDOFF.md                # Continuidade entre sessoes
├── orchestrator.py           # Entry point principal
├── agents/                   # Agentes principais
│   ├── core/                 # Base + Orchestrator + Scheduler + Budget
│   ├── scientific/           # Cientifico + Medico
│   ├── automation/           # Automacao
│   ├── organization/         # Organizacao (GTD)
│   └── ai_update/            # Atualizacao AI
├── subagents/                # Subagentes especializados
│   ├── processors/           # KnowledgeOrganizer, NotionCleaner, DataPipeline
│   ├── monitors/             # WebMonitor
│   └── analyzers/            # TrendAnalyzer
├── skills/                   # Skills Python reutilizaveis
│   ├── research/             # web_search, arxiv, summarizer
│   ├── coding/               # code_analyzer, code_generator
│   ├── writing/              # content_writer
│   ├── data/                 # data_processor
│   ├── devops/               # git_manager
│   └── efficiency/           # batch, cache, local_first
├── .claude/
│   ├── skills/               # Skills Claude Code (sob demanda)
│   │   ├── mbe-evidence/     # GRADE, CONSORT, STROBE, PRISMA...
│   │   ├── medical-research/ # PubMed, PICO
│   │   ├── notion-publisher/ # Templates Notion
│   │   ├── teaching-improvement/ # Ensino, andragogia, AI fluency, dev AI
│   │   └── ...               # + 7 skills (review, ai-monitoring, etc)
│   └── rules/                # Regras sempre carregadas
│       ├── quality.md        # Qualidade de codigo
│       ├── efficiency.md     # Eficiencia de API
│       └── mcp_safety.md     # Protocolo seguro Notion (CRITICO)
├── config/                   # Configuracoes YAML
│   ├── ecosystem.yaml        # Agentes + model routing
│   ├── workflows.yaml        # Workflows operacionais
│   ├── rate_limits.yaml      # Budget $100/mes
│   ├── tools_ecosystem.yaml  # Ferramentas do ecossistema
│   ├── mcp/servers.json      # 13 MCP servers + ChatGPT 5.4
│   └── keys/                 # Guia de API keys
├── workflows/                # Workflows medicos
│   ├── medical_workflow.yaml
│   └── efficient_workflows.yaml
├── templates/                # Templates de prompts
└── docs/                     # Documentacao
    ├── ARCHITECTURE.md       # Decisoes tecnicas e padroes
    ├── BEST_PRACTICES.md     # Convencoes e boas praticas
    └── GETTING_STARTED.md    # Este arquivo
```

## Ordem de Setup Recomendada

Ver `PENDENCIAS.md` para checklist completo. Resumo:

1. API keys Anthropic + OpenAI no `.env`
2. Instalar MCPs medicos (healthcare, pubmed, biomcp)
3. Configurar Notion MCP + criar databases
4. Configurar Gmail MCP + criar labels
5. Testar workflow `quick_note_to_evidence`
6. Configurar Cowork para fontes pagas
7. Agendar workflows semanais
