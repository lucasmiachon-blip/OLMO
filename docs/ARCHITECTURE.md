# Arquitetura do Ecossistema de Agentes AI

> Baseado em: Anthropic Agent SDK, LangGraph, CrewAI, Karpathy, Willison
> Ref: https://www.anthropic.com/engineering/building-agents-with-the-claude-agent-sdk
> Ref: https://blog.langchain.com/choosing-the-right-multi-agent-architecture/
> Ref: https://docs.crewai.com/en/guides/agents/crafting-effective-agents

## Padroes de Orquestracao

### Padrao Usado: Orchestrator-Workers (Anthropic)

```
Orchestrator (Opus 4.6)
├── route_task() → classifica e despacha
├── run_workflow() → executa pipelines multi-step
└── delegate() → subagent com contexto isolado
    ├── Cientifico (Sonnet) → pesquisa, MBE
    ├── Automacao (Haiku) → pipelines, regras
    ├── Organizacao (Sonnet) → GTD, projetos
    └── AtualizacaoAI (Sonnet) → monitoring
```

Cada subagente tem **contexto isolado** e retorna apenas o resultado
relevante ao orchestrator. Isso previne poluicao de contexto.

Ref: Anthropic - "Composable Patterns" (prompt chaining, routing,
parallelization, orchestrator-workers, evaluator-optimizer)
https://www.anthropic.com/engineering/advanced-tool-use

### Alternativas Consideradas

| Padrao | Quando Usar | Ref |
|--------|------------|-----|
| **Subagents** | Paralelizacao + isolamento (USADO) | Anthropic |
| **Skills** | Agente unico + prompts dinamicos | LangGraph |
| **Handoffs** | Agente ativo muda dinamicamente | LangGraph |
| **Router** | Roteamento deterministico por input | LangGraph |
| **TeammateTool** | Lead + teammates com task list | Anthropic Opus 4.6 |

Ref: LangGraph Multi-Agent Architecture Guide
https://blog.langchain.com/choosing-the-right-multi-agent-architecture/

### Regra CrewAI: 3-4 Agents por Team
Nosso ecossistema tem **4 agentes** (cientifico, automacao, organizacao,
ai_update) + 4 subagentes. Alinhado com best practice CrewAI.

Ref: CrewAI Crafting Effective Agents
https://docs.crewai.com/en/guides/agents/crafting-effective-agents

## Diagrama Completo

```
                    ┌─────────────────────┐
                    │    ORCHESTRATOR      │
                    │    (Opus 4.6)        │
                    │  route / workflow    │
                    └──────────┬──────────┘
                               │
          ┌────────────────────┼────────────────────┐
          │                    │                    │
 ┌────────┴────────┐  ┌───────┴───────┐  ┌────────┴────────┐
 │   CIENTIFICO    │  │  AUTOMACAO    │  │  ORGANIZACAO    │
 │   (Sonnet)      │  │  (Haiku)      │  │  (Sonnet)       │
 │                 │  │               │  │                 │
 │ MBE, GRADE      │  │ Pipelines     │  │ GTD, Eisenhower │
 │ PubMed, arXiv   │  │ Regras, Cron  │  │ Projetos        │
 │ CASP, CONSORT   │  │ MCPs          │  │ Reviews         │
 └────────┬────────┘  └───────┬───────┘  └────────┬────────┘
          │                    │                    │
          │           ┌───────┴───────┐            │
          │           │ ATUALIZACAO   │            │
          │           │ AI (Sonnet)   │            │
          │           │ Modelos,Tools │            │
          │           │ News,Bench    │            │
          │           └───────┬───────┘            │
          │                    │                    │
 ┌────────┴────┐  ┌───────┴──────┐  ┌──────┴──────────┐
 │TrendAnalyzer│  │ WebMonitor   │  │KnowledgeOrganizer│
 │  (Haiku)    │  │  (Haiku)     │  │   (Sonnet)       │
 └─────────────┘  └──────────────┘  │Notion+Obsidian   │
                                     │+Zotero           │
          ┌──────────┐               └─────────────────┘
          │DataPipeline│
          │  (Haiku)   │
          └────────────┘

 ┌─────────────────────────────────────────────────────┐
 │  EFFICIENCY LAYER                                    │
 │  SmartScheduler │ BudgetTracker │ Cache │ Batch     │
 │                                                      │
 │  Model Routing:                                      │
 │  trivial→Ollama($0) │ simple→Haiku │ medium→Sonnet  │
 │  complex→Opus │ browser→Cowork/ChatGPT              │
 └─────────────────────────────────────────────────────┘

 ┌─────────────────────────────────────────────────────┐
 │  MCP SERVERS                                         │
 │  Medical: healthcare │ pubmed │ biomcp              │
 │  Prod: notion │ gmail │ context7 │ github │ fetch   │
 │  Local: memory │ sqlite │ filesystem │ brave-search │
 └─────────────────────────────────────────────────────┘

 ┌─────────────────────────────────────────────────────┐
 │  BROWSER AGENTS (fontes pagas)                       │
 │  Cowork → UpToDate │ DynaMed │ BMJ Best Practice    │
 │  ChatGPT Agent → backup browser                     │
 └─────────────────────────────────────────────────────┘
```

## Skills - Progressive Disclosure

Seguindo best practice Anthropic: skills carregadas **sob demanda**,
nao sempre-on. Metadata (~100 tokens) no startup, SKILL.md completo
apenas quando ativado.

Ref: Anthropic Skill Authoring Best Practices
https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices

```
.claude/skills/
├── mbe-evidence/          # GRADE, CONSORT, STROBE, PRISMA, RoB2...
├── medical-research/      # PubMed, PICO, niveis evidencia
├── notion-publisher/      # Templates Notion profissionais
├── teaching/              # Metodologia de ensino, andragogia, slideologia
├── concurso/              # Prep concurso nov/2026, Anki AI, evidence-based learning
├── ai-fluency/            # AI fluency para ensino + dev AI continuo
├── review/                # Code review multi-agente + OWASP
├── ai-monitoring/         # Tracking modelos e ferramentas
├── automation/            # Workflow automation
├── organization/          # GTD + Eisenhower
├── research/              # Pesquisa academica
└── scientific/            # Metodologia cientifica
```

### Graus de Liberdade (Anthropic Pattern)
- **Alta liberdade**: pesquisa aberta, brainstorm (cientifico)
- **Media liberdade**: analise MBE com checklists (mbe-evidence)
- **Baixa liberdade**: publicacao Notion com template exato (notion-publisher)

## Workflow Engine

Workflows definidos em YAML, executados pelo orchestrator:

```python
# Padrao: Prompt Chaining (Anthropic)
# Output de um step → input do proximo
steps = [
    {"type": "local", "action": "parse_input"},       # $0
    {"type": "mcp", "server": "pubmed-mcp"},           # $0
    {"type": "api_call", "model": "opus-4.6"},          # $0.05-0.10
    {"type": "mcp", "server": "notion"},               # $0
]
```

Ref: Anthropic Advanced Tool Use - Prompt Chaining
https://www.anthropic.com/engineering/advanced-tool-use

## Efficiency Layer

3 camadas para minimizar custo (Willison pattern):

1. **Local-First** → regex, parsing, file ops ($0)
2. **Cache** → TTL por tipo: news 6h, papers 48h, models 1 semana
3. **Batching** → combina queries relacionadas (80% economia)

Ref: Simon Willison - custo rastreado por projeto
https://simonwillison.net/tags/costs/

## Per-Project CLAUDE.md

Seguindo Anthropic best practice: CLAUDE.md root <60 linhas,
contexto especifico em subdiretorios.

Ref: Anthropic CLAUDE.md Best Practices
https://code.claude.com/docs/en/best-practices

```
organizacao/
├── CLAUDE.md              # Root: enxuto (~45 linhas)
├── .claude/
│   ├── rules/             # Sempre carregadas
│   │   ├── quality.md
│   │   ├── efficiency.md
│   │   └── mcp_safety.md  # Protocolo seguro Notion (evidence-based)
│   └── skills/            # Sob demanda (progressive disclosure)
├── agents/
│   └── CLAUDE.md          # Especifico: como criar/modificar agentes
├── workflows/
│   └── CLAUDE.md          # Especifico: como criar/modificar workflows
└── config/
    └── CLAUDE.md          # Especifico: configuracao e keys
```

## Principios Arquiteturais

1. **Reversibilidade** - Toda acao de agente deve ser reversivel (Anthropic)
2. **Human-in-the-loop** - Humano decide, agente executa (Karpathy)
3. **Sessoes curtas** - Objetivos claros, sem loops de retry (Willison)
4. **Modelo certo** - Menor modelo que resolve a tarefa (efficiency)
5. **Referenciamento** - PMID, DOI obrigatorios em conteudo medico
6. **Determinismo** - Backbone deterministico + inteligencia seletiva (CrewAI)

## Documentos Relacionados

- `docs/WORKFLOW_MBE.md` — **Workflow principal** tópico → Notion + Obsidian (passo a passo, cenários)
- `docs/PIPELINE_MBE_NOTION_OBSIDIAN.md` — Detalhes técnicos (PubMed tier1, Consensus, Scite)
- `docs/OBSIDIAN_CLI_PLAN.md` — Integracao Obsidian CLI
