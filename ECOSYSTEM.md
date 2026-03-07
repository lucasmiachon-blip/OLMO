# ECOSYSTEM.md - Mapa Completo do Ecossistema AI
> Atualizado: 7 de Marco de 2026
> Perfil: Medico + Developer | Low-code workflow
> Orquestrador: Claude Opus 4.6 | Auditor: ChatGPT 5.4
> Ferramentas: Claude Code, Cursor, Claude.ai, Gemini, ChatGPT

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
│  ┌────┴────┐  ┌─────┴────┐     │           ┌─────┴─────┐     │
│  │Trend    │  │Data      │     │           │Web        │     │
│  │Analyzer │  │Pipeline  │     │           │Monitor    │     │
│  └─────────┘  └──────────┘     │           └───────────┘     │
│                                 │                              │
├─────────────────────────────────────────────────────────────────┤
│  EFFICIENCY LAYER                                               │
│  SmartScheduler │ BudgetTracker │ Cache │ Batch │ LocalFirst   │
├─────────────────────────────────────────────────────────────────┤
│  MCP SERVERS (MEDICAL + DEV)                                    │
│  healthcare │ pubmed │ biomcp │ context7 │ github │ fetch      │
│  memory │ brave-search │ sqlite │ filesystem │ puppeteer       │
├─────────────────────────────────────────────────────────────────┤
│  TOOLS: Claude Code │ Cursor │ Claude.ai │ ChatGPT │ Gemini   │
├─────────────────────────────────────────────────────────────────┤
│  AUDITOR (ChatGPT 5.4)                                         │
│  Code review │ Quality check │ Second opinion │ Validation     │
└─────────────────────────────────────────────────────────────────┘
```

## Modelo de Operacao

### Orquestrador Principal: Claude Opus 4.6
- **Papel**: Lider do ecossistema, toma decisoes complexas
- **Quando usar**: Planejamento, raciocinio multi-step, pesquisa profunda
- **Custo**: ~$0.05-0.10 por chamada
- **Budget**: Reservar para tarefas de alta complexidade

### Subagentes: Claude Sonnet 4.6
- **Papel**: Executores de tarefas delegadas pelo Opus
- **Quando usar**: Sumarizacao, analise, codigo, organizacao
- **Custo**: ~$0.01 por chamada
- **Budget**: Maioria das tarefas diarias

### Tarefas Simples: Claude Haiku 4.5
- **Papel**: Tarefas rapidas e baratas
- **Quando usar**: Classificacao, extracao, triagem, respostas curtas
- **Custo**: ~$0.001 por chamada

### Local: Ollama (Llama 3 / Mistral)
- **Papel**: Tarefas que nao precisam de API
- **Quando usar**: Parsing, regex, formatacao, busca local
- **Custo**: $0.00

### Auditor: ChatGPT 5.4 (OpenAI)
- **Papel**: Segunda opiniao, validacao, perspectiva diferente
- **Quando usar**: Code review critico, decisoes importantes, cross-validation
- **Custo**: ~$0.02-0.05 por chamada
- **Budget**: 1-2x por semana para auditoria

## Agents - Detalhamento

### 1. Agente Cientifico
```yaml
nome: cientifico
modelo: claude-sonnet-4-6
papel: Pesquisador e analista
capacidades:
  - Busca em arXiv, Semantic Scholar, PubMed
  - Sumarizacao de papers (estilo Andrej Karpathy)
  - Revisao de literatura automatica
  - Geracao de hipoteses
  - Mapeamento de tendencias
  - Analise critica de metodologias
subagentes:
  - TrendAnalyzer: identifica padroes em dados/papers
skills:
  - arxiv_search, web_search, summarizer
```

### 2. Agente de Automacao
```yaml
nome: automacao
modelo: claude-haiku-4-5  # Simples e barato
papel: Executor de automacoes
capacidades:
  - Regras trigger/action (event-driven)
  - Pipelines de dados configuraveis
  - Agendamento cron-like
  - Integracoes via MCP
  - Monitoramento e alertas
subagentes:
  - DataPipeline: ETL e transformacao
skills:
  - code_analyzer, code_generator, data_processor, git_manager
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
  - Gestao de projetos
  - Rastreamento de habitos
  - Reviews automaticos
skills:
  - content_writer, summarizer
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
  - Tracking de ferramentas e frameworks
subagentes:
  - WebMonitor: verifica fontes periodicamente
skills:
  - web_search, summarizer
fontes_monitoradas:
  - Anthropic Blog (claude, MCP, agent SDK)
  - OpenAI Blog (GPT, agents, tools)
  - Google AI Blog (Gemini, DeepMind)
  - Hugging Face (modelos open-source)
  - Papers With Code (benchmarks)
  - arXiv cs.AI (papers)
  - GitHub Trending (ferramentas)
  - Hacker News (comunidade)
```

## Subagentes

| Subagente | Agente Pai | Modelo | Funcao |
|-----------|-----------|--------|--------|
| TrendAnalyzer | Cientifico | Haiku | Identifica padroes e tendencias |
| DataPipeline | Automacao | Haiku | ETL e processamento de dados |
| WebMonitor | AI Update | Haiku | Monitora fontes web (RSS, APIs) |

## Skills Completas

### Medical Research Skills
| Skill | Descricao | API? |
|-------|-----------|------|
| medical_research | PubMed, ClinicalTrials, guidelines, PICO | MCP |
| pubmed_search | Busca avancada PubMed (39M+ citacoes) | MCP |
| clinical_trials | Busca de ensaios clinicos ativos | MCP |
| drug_info | FDA drug information e interacoes | MCP |
| icd10_lookup | Busca de codigos CID-10 | MCP |
| medical_calc | Calculadoras medicas (BMI, etc) | MCP |

### Research Skills
| Skill | Descricao | API? |
|-------|-----------|------|
| web_search | Busca web multi-provedor | Sim |
| arxiv_search | Papers academicos | Sim |
| summarizer | Sumarizacao inteligente | Sim |

### Coding Skills
| Skill | Descricao | API? |
|-------|-----------|------|
| code_analyzer | Qualidade e seguranca | Sim |
| code_generator | Geracao de codigo | Sim |

### Writing Skills
| Skill | Descricao | API? |
|-------|-----------|------|
| content_writer | Blog, docs, emails, reports | Sim |

### Data Skills
| Skill | Descricao | API? |
|-------|-----------|------|
| data_processor | ETL JSON/CSV/YAML | Local |

### DevOps Skills
| Skill | Descricao | API? |
|-------|-----------|------|
| git_manager | Status, log, diff | Local |

### Efficiency Skills (NOVAS)
| Skill | Descricao | API? |
|-------|-----------|------|
| batch_processor | Combina queries | N/A |
| local_first | Processamento local | Local |
| response_cache | Cache inteligente | Local |

## MCP Servers

### Medical MCPs (Prioridade CRITICA)
| MCP Server | Funcao | Notas |
|------------|--------|-------|
| healthcare-mcp | PubMed, FDA drugs, ClinicalTrials, CID-10, medRxiv, DICOM, calculadoras | Tudo-em-um para medicos |
| pubmed-mcp | Busca avancada PubMed (39M+ citacoes), abstracts, artigos relacionados | Pesquisa biomedica |
| biomcp | PubMed, ClinicalTrials.gov, MyVariant.info, queries em linguagem natural | GenomOncology, variantes |

### Dev & Productivity MCPs
| MCP Server | Funcao | Prioridade |
|------------|--------|-----------|
| context7 | Docs atualizadas em tempo real para libs/frameworks | CRITICA |
| filesystem | Leitura/escrita de arquivos | CRITICA |
| github | Issues, PRs, repos, code search | ALTA |
| fetch | Busca web, download de conteudo | ALTA |
| memory | Persistencia de contexto entre sessoes | ALTA |
| brave-search | Busca web alternativa (2000 req/mo free) | MEDIA |
| sqlite | Base de dados local para knowledge | MEDIA |
| puppeteer | Automacao de browser | BAIXA |

### Planejados (futuro)
| MCP Server | Funcao | Quando |
|------------|--------|--------|
| google-calendar | Integracao com calendario | v0.2 |
| notion | Integracao com Notion | v0.2 |
| slack | Notificacoes e comunicacao | v0.3 |
| arxiv | Busca direta no arXiv | v0.2 |
| gmail | Leitura e envio de emails | v0.3 |
| medical-mcp | Queries medicas multi-DB (JamesANZ) | v0.2 |

## Workflows Operacionais

### Diario (~1-2 API calls)
```
07:00 - Batch Morning Digest (1 call)
        → News AI + Tendencias + Plano do dia
        → Cache por 12h

Sob demanda - Smart Query (0-1 call)
        → Cache-first, so chama API se necessario
```

### Semanal (~5-10 API calls)
```
Segunda 10:00 - AI Ecosystem Update (1 call)
        → Novos modelos + Tools + Benchmarks + Precos

Sexta 18:00 - Weekly Deep Review (3 calls)
        → Review + Inbox + Plano semana + Papers

Sob demanda - Research Sprint (3 calls)
        → Mapeamento + Analise + Sintese
```

### Mensal (~5 API calls)
```
1o dia - Monthly Audit (2 calls)
        → Review de custos + Otimizacoes + Tendencias macro

15o dia - Ecosystem Health Check (1 call)
        → Status de todos os agentes + Melhorias

Sob demanda - ChatGPT Audit (2 calls)
        → Cross-validation com ChatGPT 5.4
```

## Budget Mensal Estimado

| Item | Calls/mes | Custo |
|------|----------|-------|
| Morning Digest (Sonnet) | ~20 | $0.20 |
| Weekly Review (Sonnet) | 12 | $0.12 |
| AI Update (Sonnet) | 4 | $0.04 |
| Research Sprints (Opus) | 6-9 | $0.30-0.45 |
| Smart Queries (Sonnet) | ~20 | $0.20 |
| ChatGPT Audit | 4-8 | $0.10-0.20 |
| **TOTAL** | **66-73** | **$0.96-1.21/mes** |

## API Keys Necessarias

| Servico | Variavel | Obrigatorio | Free Tier |
|---------|----------|-------------|-----------|
| Anthropic | ANTHROPIC_API_KEY | Sim | Pay-per-use |
| OpenAI | OPENAI_API_KEY | Auditor | Pay-per-use |
| GitHub | GITHUB_TOKEN | MCP | 5000 req/h |
| Brave Search | BRAVE_API_KEY | MCP | 2000 req/mo free |
| HuggingFace | HF_TOKEN | Modelos | Free |

## Stack Tecnologico (Marco 2026)

### Modelos AI
- **Claude Opus 4.6** - Orquestrador (Anthropic, maio 2025+)
- **Claude Sonnet 4.6** - Subagentes (Anthropic)
- **Claude Haiku 4.5** - Tarefas simples (Anthropic)
- **ChatGPT 5.4** - Auditor (OpenAI)
- **Llama 3.3** - Local via Ollama (Meta, open-source)
- **Mistral Large 2** - Alternativa local (Mistral)

### Frameworks & Tools
- **Claude Agent SDK** - Framework de agentes (Anthropic)
- **MCP (Model Context Protocol)** - Conexao com tools (Linux Foundation)
- **LangGraph** - Grafos de execucao multi-agente
- **CrewAI** - Padrao Flows + Crews
- **Ollama** - LLMs locais
- **Rich** - Terminal UI bonito

### Infraestrutura
- **Python 3.11+** com asyncio
- **SQLite** para knowledge base local
- **JSON/YAML** para configuracao
- **Git** para versionamento e historico
