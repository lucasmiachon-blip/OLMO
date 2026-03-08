# ECOSYSTEM.md - Mapa Completo do Ecossistema AI
> Atualizado: 8 de Marco de 2026
> Perfil: Medico + Professor + Developer AI | Low-code workflow
> Orquestrador: Claude Opus 4.6 | Auditor: ChatGPT 5.4
> Ferramentas: Claude Code, Cowork, Cursor, Claude.ai, ChatGPT, Gemini, Perplexity Max

## OBJETIVOS CLAROS

### 1. Informacao Medica Tier 1 da Semana
- Digest semanal automatico com melhores evidencias
- PubMed + ClinicalTrials via MCPs (custo $0)
- Publicado automaticamente no Notion com estetica profissional

### 2. Pipeline: Nota/Paper → Analise MBE → Notion
- Coloca nota ou paper → sistema dispara buscas
- Usa Scite (citacoes), Consensus (consenso), Elicit (PICO)
- Avalia com GRADE, CONSORT, STROBE, PRISMA, RoB2, QUADAS conforme tipo
- Critica com rigor MBE como profissional da especialidade
- Popula Notion com numeros concretos, evidencias, referencias

### 3. Extracao de Fontes Pagas (UpToDate, DynaMed, Best Practice)
- Cowork (browser agent) loga e extrai conteudo/PDF
- ChatGPT Agent como backup para browsing
- Claude Code processa com skill MBE + publica no Notion
- Frequencia: 2-3x/semana

### 4. Automacao Gmail → Notion
- Opus 4.6 monitora emails medicos (2-3x/semana via MCP)
- Classifica, resume, dispara analise se relevante
- Popula databases Notion automaticamente

### 5. Knowledge Base Unificada
- Notion: paginas bonitas, databases, digests (compartilhavel)
  - Base: **Ultimate Brain** (Thomas Frank) - GTD + PARA template
  - Seguranca: protocolo em `.claude/rules/mcp_safety.md`
- Obsidian: vault local, Zettelkasten, links bidirecionais (pessoal)
- Zotero: referencias bibliograficas, PDFs, citacoes

### 6. Ensino e Autoaprimoramento (Professor)
- Objetivo: ser referencia em ensino medico + ensinar alunos a usar AI
- **Slideologia**: Assertion-Evidence, Picture Superiority, Presentation Zen
- **Psicologia cognitiva**: carga cognitiva, testing effect, spaced repetition
- **Retorica/oratoria**: Ethos-Pathos-Logos, storytelling clinico, Feynman
- **Error log**: diario de aulas com acertos, erros e acoes corretivas
- **AI para alunos**: curriculo progressivo de uso responsavel de AI em medicina
- Referenciamento impecavel (PMID, DOI obrigatorios)
- Skills evoluem com novas ferramentas e checklists
- Cada projeto tem seu CLAUDE.md especifico

### 7. Dev AI Continuo (2x/semana)
- Curadoria de fontes: Anthropic, OpenAI, HN, Willison, Latent Space
- Foco alto ROI: MCP, Agent SDK, prompt engineering, agentic patterns
- Sessoes 30-60min: curar → deep dive → nota → aplicar
- Skill: `.claude/skills/teaching-improvement/` (secao Dev AI)

## Visao Geral do Ecossistema

```
┌─────────────────────────────────────────────────────────────────┐
│                    ORCHESTRATOR (Opus 4.6)                      │
│              Coordena, roteia, decide, planeja                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────────┐  │
│  │CIENTIFICO│ │AUTOMACAO │ │ORGANIZAC.│ │  ATUALIZACAO AI  │  │
│  │+MEDICO   │ │(Haiku)   │ │(Sonnet)  │ │  (Sonnet)        │  │
│  │(Sonnet)  │ │          │ │          │ │                  │  │
│  └────┬─────┘ └────┬─────┘ └────┬─────┘ └────────┬─────────┘  │
│       │             │            │                 │            │
│  ┌────┴────┐  ┌─────┴────┐  ┌───┴──────┐   ┌─────┴─────┐     │
│  │Trend    │  │Data      │  │Knowledge │   │Web        │     │
│  │Analyzer │  │Pipeline  │  │Organizer │   │Monitor    │     │
│  └─────────┘  └──────────┘  └──────────┘   └───────────┘     │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│  EFFICIENCY LAYER                                               │
│  SmartScheduler │ BudgetTracker │ Cache │ Batch │ LocalFirst   │
├─────────────────────────────────────────────────────────────────┤
│  MCP SERVERS (MEDICAL + DEV)                                    │
│  healthcare │ pubmed │ biomcp │ notion │ gmail │ context7      │
│  github │ fetch │ memory │ brave-search │ sqlite │ filesystem  │
├─────────────────────────────────────────────────────────────────┤
│  BROWSER AGENTS                                                 │
│  Cowork (UpToDate/DynaMed/BMJ) │ ChatGPT Agent (backup)       │
├─────────────────────────────────────────────────────────────────┤
│  KNOWLEDGE: Notion │ Obsidian │ Zotero │ Perplexity Max       │
├─────────────────────────────────────────────────────────────────┤
│  TOOLS: Claude Code │ Cowork │ Cursor │ Claude.ai │ Canva Pro │
│         ChatGPT Web │ Gemini Web │ NotebookLM │ Excalidraw    │
├─────────────────────────────────────────────────────────────────┤
│  AUDITOR (ChatGPT 5.4 Web - $0)                                │
│  Code review │ Quality check │ Second opinion │ Validation     │
└─────────────────────────────────────────────────────────────────┘
```

## Modelo de Operacao

### Orquestrador Principal: Claude Opus 4.6
- **Papel**: Lider do ecossistema, toma decisoes complexas
- **Quando usar**: Planejamento, raciocinio multi-step, MBE profunda
- **Custo**: ~$0.05-0.10 por chamada

### Subagentes: Claude Sonnet 4.6
- **Papel**: Executores de tarefas delegadas pelo Opus
- **Quando usar**: Sumarizacao, analise, codigo, organizacao
- **Custo**: ~$0.01 por chamada

### Tarefas Simples: Claude Haiku 4.5
- **Papel**: Tarefas rapidas e baratas
- **Quando usar**: Classificacao, extracao, triagem
- **Custo**: ~$0.001 por chamada

### Local: Ollama (Llama 3 / Mistral)
- **Papel**: Tarefas que nao precisam de API
- **Quando usar**: Parsing, regex, formatacao, busca local
- **Custo**: $0.00

### Browser Agents: Cowork + ChatGPT Agent
- **Papel**: Acessar fontes pagas com login (UpToDate, DynaMed, BMJ)
- **Quando usar**: Extracao de guidelines/conteudo autenticado
- **Custo**: $0 (usa planos existentes)

### Auditor: ChatGPT 5.4 (Web + MCP)
- **Papel**: Segunda opiniao, validacao, cross-validation
- **Quando usar**: Decisoes criticas, code review, auditoria MBE, Notion writes
- **Cross-validation**: Claude propoe → 5.4 valida → ambos concordam = executa, divergem = humano
- **Custo**: $0 (web/MCP)
- **Protocolo**: Ver `.claude/rules/mcp_safety.md` (secao CROSS-VALIDATION)

## Agents - Detalhamento

### 1. Agente Cientifico + Medico
```yaml
nome: cientifico
modelo: claude-sonnet-4-6
papel: Pesquisador e analista MBE
capacidades:
  - Busca em PubMed, arXiv, Semantic Scholar
  - Analise critica com GRADE, CASP, CONSORT, STROBE, PRISMA
  - Extracao PICO, NNT, RR, IC 95%
  - Revisao de literatura automatica
  - Mapeamento de tendencias
subagentes:
  - TrendAnalyzer: identifica padroes em dados/papers
skills:
  - mbe-evidence, medical-research, arxiv_search, summarizer
```

### 2. Agente de Automacao
```yaml
nome: automacao
modelo: claude-haiku-4-5
papel: Executor de automacoes (2-3x/semana via MCP)
capacidades:
  - Pipelines de dados configuraveis
  - Integracoes via MCP (Notion, Gmail)
  - Monitoramento e alertas
subagentes:
  - DataPipeline: ETL e transformacao
skills:
  - code_analyzer, data_processor, git_manager
```

### 3. Agente de Organizacao
```yaml
nome: organizacao
modelo: claude-sonnet-4-6
papel: Gestor pessoal e profissional
capacidades:
  - GTD (Getting Things Done) completo
  - Eisenhower Matrix para priorizacao
  - Planejamento diario/semanal/mensal
  - Reviews automaticos
subagentes:
  - KnowledgeOrganizer: Notion + Obsidian + Zotero autonomo
skills:
  - organization, content_writer, notion-publisher
```

### 4. Agente de Atualizacao AI
```yaml
nome: atualizacao_ai
modelo: claude-sonnet-4-6
papel: Curador do ecossistema AI
capacidades:
  - Monitora 8+ fontes de AI
  - Compara modelos (benchmarks, custos)
  - Digest semanal curado
  - Recomendacoes de atualizacao
subagentes:
  - WebMonitor: verifica fontes periodicamente
skills:
  - ai-monitoring, web_search, summarizer
fontes_monitoradas:
  - Anthropic Blog, OpenAI Blog, Google AI Blog
  - Hugging Face, Papers With Code, arXiv cs.AI
  - GitHub Trending, Hacker News
```

## Subagentes

| Subagente | Agente Pai | Modelo | Funcao |
|-----------|-----------|--------|--------|
| KnowledgeOrganizer | Organizacao | Sonnet | Notion + Obsidian + Zotero autonomo |
| TrendAnalyzer | Cientifico | Haiku | Identifica padroes e tendencias |
| DataPipeline | Automacao | Haiku | ETL e processamento de dados |
| WebMonitor | AI Update | Haiku | Monitora fontes web (RSS, APIs) |

## Skills (Progressive Disclosure)

Skills em `.claude/skills/` carregadas sob demanda quando relevantes:

### Medical & MBE
| Skill | Descricao | Destaque |
|-------|-----------|---------|
| mbe-evidence | GRADE, CONSORT, STROBE, PRISMA, RoB2, QUADAS, NOS | 10 reporting + 10 quality tools |
| medical-research | PubMed, ClinicalTrials, PICO, niveis evidencia | MCPs medicos |
| notion-publisher | Templates Notion com estetica profissional | 3 templates |

### Research & Learning
| Skill | Descricao |
|-------|-----------|
| teaching-improvement | Estudo, referenciamento impecavel, per-project MD |
| research | Pesquisa academica, arXiv |
| scientific | Metodologia cientifica |

### Dev & Productivity
| Skill | Descricao |
|-------|-----------|
| review | Code review multi-agente + OWASP |
| ai-monitoring | Tracking modelos, tools, benchmarks |
| automation | Workflow automation |
| organization | GTD + Eisenhower |

## MCP Servers

### Configurados
| MCP Server | Funcao | Prioridade |
|------------|--------|-----------|
| healthcare-mcp | PubMed, FDA, ClinicalTrials, CID-10, calculadoras | CRITICA |
| pubmed-mcp | Busca avancada PubMed (39M+ citacoes) | CRITICA |
| biomcp | PubMed, ClinicalTrials, variantes geneticas | CRITICA |
| notion | Publicacao de conteudo (HTTP MCP, protocolo seguro) | CRITICA |
| chatgpt-5.4 | Cross-validation para writes criticos | ALTA |
| gmail | Emails medicos (Google Workspace MCP) | ALTA |
| context7 | Docs atualizadas para libs/frameworks | ALTA |
| filesystem | Leitura/escrita de arquivos | ALTA |
| github | Issues, PRs, repos | ALTA |
| fetch | Busca web, download | ALTA |
| memory | Persistencia de contexto | ALTA |
| brave-search | Busca web (2000 req/mo free) | MEDIA |
| sqlite | Knowledge base local | MEDIA |

## Workflows

### Medicos (ver `workflows/medical_workflow.yaml`)
1. **paper_to_notion** - Paper → MBE (GRADE) → Notion
2. **weekly_medical_digest** - Digest semanal Tier 1
3. **gmail_to_notion** - Gmail medico → Notion
4. **quick_note_to_evidence** - Nota rapida → evidencia
5. **paid_source_extraction** - Cowork → UpToDate/DynaMed → MBE → Notion

### Operacionais (ver `config/workflows.yaml`)
6. **morning_review** - Digest AI + plano do dia
7. **weekly_review** - Review GTD + plano semanal
8. **research_pipeline** - Busca + analise + sintese
9. **ai_monitoring** - Update modelos + tools
10. **code_review** - Multi-agente + OWASP
11. **full_organization** - Inbox + priorizar + plano

## Regra de Ouro

```
Claude Code  = FAZER (executar, commitar, automatizar, MCPs)
Cowork       = EXTRAIR (browser autenticado, fontes pagas, PDFs)
Cursor       = EDITAR (coding visual, multi-file)
Claude.ai    = PENSAR (brainstorm, analise, planejamento)
ChatGPT Web  = VALIDAR (auditoria, $0, Deep Research, browser agent)
Gemini Web   = PESQUISAR (Drive 30TB, 1M tokens, $0)
Perplexity   = BUSCAR (fontes citadas, pesquisa rapida)
NotebookLM   = ESTUDAR (podcasts, Q&A sobre papers)
Notion       = PUBLICAR (paginas bonitas, databases)
Obsidian     = CONECTAR (Zettelkasten, links, vault local)
Zotero       = REFERENCIAR (bibliografias, PDFs, citacoes)
Canva Pro    = DESIGN (apresentacoes, infograficos, visual)
```

## Budget Mensal Estimado

| Item | Calls/mes | Custo |
|------|----------|-------|
| Medical workflows (Opus) | ~70-78 | $2.20-2.60 |
| Morning Digest (Sonnet) | ~20 | $0.20 |
| Weekly Review (Sonnet) | 12 | $0.12 |
| AI Update (Sonnet) | 4 | $0.04 |
| Research Sprints (Opus) | 6-9 | $0.30-0.45 |
| Smart Queries (Sonnet) | ~20 | $0.20 |
| Cowork/ChatGPT Agent | - | $0 (planos) |
| MCPs (PubMed, Notion, Gmail) | - | $0 |
| **TOTAL** | **~130** | **~$3.00-3.60/mes** |

## Stack Tecnologico (Marco 2026)

### Modelos AI
- **Claude Opus 4.6** - Orquestrador + MBE profunda
- **Claude Sonnet 4.6** - Subagentes (1M context beta)
- **Claude Haiku 4.5** - Tarefas simples
- **ChatGPT 5.4** - Auditor (web, $0)
- **Llama 3.3** - Local via Ollama

### Ferramentas
- **Claude Code v2.1.69** - CLI agent (/batch, /loop, worktrees, skills)
- **Claude Cowork** - Desktop/browser agent (Skills, scheduled tasks)
- **Claude Agent SDK** - Python v0.1.48, TS v0.2.71 (TeammateTool)
- **MCP** - Model Context Protocol (Linux Foundation)
- **Cursor v2.6** - IDE AI-first (Automations, Cloud Agents)

### Notion Base: Ultimate Brain (Thomas Frank)
- **Template**: GTD + PARA pre-configurado
- **Fonte**: https://thomasjfrank.com/brain/
- **Companion**: Flylighter (browser extension)
- **P0**: Verificar se versao esta atualizada (ver `HANDOFF.md`)
- **Seguranca**: `.claude/rules/mcp_safety.md` (bugs conhecidos, protocolo harsh)
- **Cleaner**: `subagents/processors/notion_cleaner.py` (snapshot → inventario → plano → execucao)

### Padroes de Arquitetura (baseado nas melhores praticas 2026)
- **Anthropic**: Subagent orchestration, TeammateTool, progressive disclosure
- **LangGraph**: Subagents, skills, handoffs, routers
- **CrewAI**: 3-4 agents por team, YAML config, Pydantic output
- **Karpathy**: Agentic engineering com supervisao humana
- **Willison**: Sessoes curtas e focadas, custo rastreado

## Key Docs (auto-referencia)

| Documento | Funcao |
|-----------|--------|
| `CLAUDE.md` | Instrucoes raiz, KPIs, safety, self-improvement |
| `ECOSYSTEM.md` | Este arquivo - mapa completo |
| `PENDENCIAS.md` | Checklist de setup e custos |
| `HANDOFF.md` | Continuidade entre sessoes |
| `docs/ARCHITECTURE.md` | Decisoes tecnicas e padroes |
| `docs/BEST_PRACTICES.md` | Convencoes e boas praticas |
| `.claude/rules/mcp_safety.md` | Protocolo Notion seguro (evidence-based) |
| `config/mcp/servers.json` | Configuracao MCP + model routing |
| `config/rate_limits.yaml` | Budget e rate limits |
