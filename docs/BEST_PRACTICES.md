# Best Practices - Inspirado nos Melhores Devs

## Fontes de Inspiracao

### Andrej Karpathy - "Agentic Engineering"
- Evoluiu de "vibe coding" (2025) para "agentic engineering" (2026)
- Humano supervisiona agentes, mantendo qualidade com alavancagem
- "Claim leverage from agents but without any compromise on software quality"
- Use agentes apenas para subtarefas que genuinamente precisam de inteligencia
- Agentes vao demorar uma decada para amadurecer - use com supervisao

### Simon Willison - Eficiencia por Design
- Rastreia custo por projeto ($0.61 por 17 minutos de trabalho)
- Sessoes curtas e focadas com objetivos claros
- Humano assume quando o agente trava (evita loops de retry)
- "LLMs are no replacement for human intuition and experience"
- 120+ ferramentas criadas com AI como acelerador, nao substituto

### CrewAI - "Structure from Intelligence"
- Backbone deterministico (Flow) + inteligencia seletiva (Crews)
- "Stable pieces keep them simple, fast, and cheap"
- Anti-pattern: cramming too much into one agent
- Human-in-the-loop e o verdadeiro diferenciador
- Role-based: Manager (orquestra), Worker (executa), Researcher (pesquisa)

### Anthropic - Claude Agent SDK
- Skills: pastas com instrucoes carregadas sob demanda (progressive disclosure)
- `max_budget_usd` para controle de custo por execucao
- Fallback entre modelos automatico
- PreToolUse hooks para interceptar acoes perigosas
- Agent Teams: lead + teammates com contexto compartilhado

### LangGraph - Grafos de Execucao
- 4 padroes multi-agente: subagents, skills, handoffs, routers
- Filosofia: controle total, sem prompts escondidos
- Melhor benchmark: Opus como lead + Sonnet como subagents = 90.2% melhor

## Regras de Ouro para Poucos Requests

### 1. Invista em Arquitetura (Gratis), Nao em API Calls (Caro)
- CLAUDE.md bem estruturado economiza 30-50% de requests desperdicados
- Cada request que falha por falta de contexto e budget queimado

### 2. Cache Agressivamente
- Mesma pergunta nunca deve bater na API 2x
- Cache hits: sub-100ms vs 1-3s de API calls
- TTL por tipo: news (6h), papers (48h), models (1 semana)

### 3. Batch Quando Possivel
- 5 perguntas sobre AI news = 1 API call, nao 5
- Combine perguntas relacionadas em sessoes unicas
- Morning digest: 1 chamada para news + trends + planning

### 4. Local-First para Tarefas Rotineiras
- Regex, parsing, formatacao = $0.00 (local)
- Busca em arquivos, contagem, filtros = $0.00 (local)
- So chame API para raciocinio e geracao

### 5. Modelo Certo para a Tarefa Certa
| Complexidade | Modelo | Custo/call |
|---|---|---|
| Trivial (parsing, regex) | Ollama local | $0.00 |
| Simples (extracao, triagem) | Haiku | ~$0.001 |
| Media (resumo, codigo simples) | Sonnet | ~$0.01 |
| Complexa (pesquisa, raciocinio) | Opus | ~$0.05-0.10 |

### 6. Meca e Otimize
- Rastreie custo por agente e por tarefa
- Identifique os agentes mais caros
- Aumente cache hit rate para > 50%
- Use `max_budget_usd` como safety net

### 7. Human-in-the-Loop
- Nao deixe agentes retentarem autonomamente
- Uma tentativa falhada que voce revisa e mais barata que 5 retries
- Humano decide, agente executa

## Stack Minimo Viavel

| Componente | Opcao | Custo |
|---|---|---|
| CLAUDE.md / Config | Arquivo no repo | Gratis |
| CLI Agent | Claude Code / API | Pay-per-use |
| Workflow Automation | Scripts Python | Gratis |
| Cache | SQLite / JSON files | Gratis |
| Knowledge Base | Markdown + Git | Gratis |
| Local LLM | Ollama | Gratis |

## Os 3 Agentes que Mais Importam

1. **Code/Task Agent** - coding, pesquisa, analise (onde vai o budget)
2. **Automation Agent** - conecta servicos, tarefas agendadas (rules-based)
3. **Knowledge Agent** - mantem contexto entre sessoes (100% local)

## Fontes da Pesquisa

- Anthropic Blog, Agent SDK Docs, MCP Protocol
- OpenAI Agents SDK, AgentKit
- LangChain/LangGraph Multi-Agent Patterns
- CrewAI Production Architecture
- Google Cloud Agent Design Patterns
- Simon Willison Blog (simonwillison.net)
- Andrej Karpathy (Twitter/X, talks)
- JetBrains AI Developer Survey 2026
- Nordic APIs on Rate Limiting
- Portkey AI Gateway
