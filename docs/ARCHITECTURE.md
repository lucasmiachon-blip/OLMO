# Arquitetura do Ecossistema de Agentes AI

> Baseado em: Anthropic Agent SDK, LangGraph, CrewAI, Karpathy, Willison
> Ref: https://www.anthropic.com/engineering/building-agents-with-the-claude-agent-sdk
> Ref: https://blog.langchain.com/choosing-the-right-multi-agent-architecture/
> Ref: https://docs.crewai.com/en/guides/agents/crafting-effective-agents

## Padroes de Orquestracao

### Padrao Usado: Orchestrator-Workers (Anthropic)

> **Status: scaffold (~30%).** Config/safety/routing implementados.
> Agents sao stubs — a orquestracao real acontece via Claude Code CLI.

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
 │  MCP SERVERS (12 connected, 3 planned, 1 removed)    │
 │  Medical: PubMed │ SCite │ Consensus │ Scholar GW   │
 │  Research: Perplexity │ NotebookLM │ Zotero         │
 │  Prod: Notion │ Gmail │ Google Calendar │ Canva     │
 │  Visual: Excalidraw                                  │
 │  Planned: Google Drive │ ChatGPT MCP │ Anki MCP     │
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

20 skills em `.claude/skills/` — todas com SKILL.md (formato oficial). Lista derivavel via `ls .claude/skills/`.

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
OLMO/
├── CLAUDE.md              # Root: enxuto
├── .claude/
│   ├── rules/ (9)         # anti-drift, coauthorship, design-reference,
│   │                      # mcp_safety, notion-cross-validation, process-hygiene,
│   │                      # qa-pipeline, session-hygiene, slide-rules
│   ├── skills/ (20)       # Sob demanda (progressive disclosure, SKILL.md)
│   └── agents/ (8)        # researcher, qa-engineer, evidence-researcher, etc.
├── config/
│   ├── ecosystem.yaml     # Agentes + model routing + skills
│   └── mcp/servers.json   # 16 MCPs (12 connected, 3 planned, 1 removed)
└── content/aulas/         # Subsistema Node.js (deck.js + GSAP)
```

## Aulas — Arquitetura HTML/JS

Decisao sessao 23-24: HTML/JS + deck.js (nao Reveal.js, nao PPTX).

```
content/aulas/
├── shared/                # Design system compartilhado (promovido sessao 24)
│   ├── css/base.css       # OKLCH design tokens, tipografia, layout
│   ├── js/deck.js         # Navegacao vanilla (170 linhas, scale 1280×720)
│   ├── js/engine.js       # GSAP dispatcher declarativo (data-animate)
│   ├── js/click-reveal.js # Progressive reveal (data-reveal)
│   └── assets/fonts/      # DM Sans, Instrument Serif, JetBrains Mono (woff2)
├── cirrose/               # 11 slides ativos + 35 archived
├── grade/                 # 58 slides, migrada Reveal→deck.js, precisa redesign
├── scripts/               # Linters compartilhados (lint-slides, done-gate)
├── STRATEGY.md            # Roadmap tecnico (CSS @layer, D3, Lottie, PPTX)
├── package.json           # Scripts: dev, build, lint, QA
└── vite.config.js         # Multi-page auto-discovery
```

**Padroes:**
- Assertion-evidence: `<h2>` = claim clinico, visual = evidencia. Sem bullet lists.
- Animacao declarativa: `data-animate="countUp|stagger|drawPath|fadeUp|highlight"`
- Build: PowerShell `build-html.ps1` concatena `slides/*.html` via `_manifest.js`
- QA: Playwright screenshots + metricas (C1 word count, C8 font-size ≥18px)
- Rules: `.claude/rules/slide-rules.md` (path-scoped a `content/aulas/**`)

## Principios Arquiteturais

1. **Reversibilidade** - Toda acao de agente deve ser reversivel (Anthropic)
2. **Human-in-the-loop** - Humano decide, agente executa (Karpathy)
3. **Sessoes curtas** - Objetivos claros, sem loops de retry (Willison)
4. **Modelo certo** - Menor modelo que resolve a tarefa (efficiency)
5. **Referenciamento** - PMID, DOI obrigatorios em conteudo medico
6. **Determinismo** - Backbone deterministico + inteligencia seletiva (CrewAI)

## Documentos Relacionados

- `docs/WORKFLOW_MBE.md` — Workflow principal: topico → Notion + Obsidian
- `docs/PIPELINE_MBE_NOTION_OBSIDIAN.md` — Detalhes tecnicos (PubMed tier1, Consensus, Scite)
- `docs/OBSIDIAN_CLI_PLAN.md` — Integracao Obsidian CLI
- `content/aulas/STRATEGY.md` — Roadmap tecnico de aulas (CSS @layer, D3, Lottie, PPTX)
- `docs/coauthorship_reference.md` — Referencia completa coautoria AI
- `docs/mcp_safety_reference.md` — Referencia completa seguranca MCP
