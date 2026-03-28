# Best Practices - Baseado nos Melhores Devs e Pesquisadores

## Fontes e Referencias

### Andrej Karpathy - "Agentic Engineering"
- Evoluiu de "vibe coding" (2025) para "agentic engineering" (2026)
- Humano supervisiona agentes, mantendo qualidade com alavancagem
- "Claim leverage from agents but without any compromise on software quality"
- Agentes vao demorar uma decada para amadurecer - use com supervisao
- Ref: https://x.com/kaboretarpathy (talks, posts)

### Simon Willison - Eficiencia por Design
- Rastreia custo por projeto ($0.61 por 17 minutos de trabalho)
- Sessoes curtas e focadas com objetivos claros
- Humano assume quando o agente trava (evita loops de retry)
- 120+ ferramentas criadas com AI como acelerador
- Ref: https://simonwillison.net/

### Anthropic - Claude Agent SDK + Skills
- Progressive disclosure: skills carregadas sob demanda (~100 tokens metadata)
- CLAUDE.md <60 linhas, regras em `.claude/rules/`, skills em `.claude/skills/`
- Graus de liberdade: alta (pesquisa) → media (analise) → baixa (deploy)
- Composable patterns: prompt chaining, routing, parallelization, orchestrator-workers
- TeammateTool: lead + teammates com contexto isolado
- Ref: https://www.anthropic.com/engineering/building-agents-with-the-claude-agent-sdk
- Ref: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
- Ref: https://www.anthropic.com/engineering/advanced-tool-use

### CrewAI - "Structure from Intelligence"
- Backbone deterministico (Flow) + inteligencia seletiva (Crews)
- 3-4 agentes por team (nosso ecossistema: 4 agentes)
- YAML-driven config para agentes e tasks
- Structured output via Pydantic
- Ref: https://docs.crewai.com/en/guides/agents/crafting-effective-agents

### LangGraph - Multi-Agent Architecture
- 4 padroes: subagents, skills, handoffs, routers
- "Comece com 1 agente + tools bons. Escale para multi-agent quando contexto e limitante"
- Opus como lead + Sonnet como subagents = 90.2% melhor
- Ref: https://blog.langchain.com/choosing-the-right-multi-agent-architecture/

### CLAUDE.md Best Practices (Anthropic + Comunidade)
- CLAUDE.md root <60-80 linhas (HumanLayer benchmark)
- Cobrir WHAT, WHY, HOW: stack, proposito, como trabalhar
- Nomes de arquivo concretos (`file:line`), nao abstratos
- Nunca enviar LLM para fazer trabalho de linter
- Evitar instrucoes de personalidade ("Be a senior engineer")
- `/init` para gerar starter, `/insights` semanal para refinar
- Ref: https://github.com/josix/awesome-claude-md
- Ref: https://github.com/anthropics/claude-code-action/blob/main/CLAUDE.md

## Regras de Ouro para Poucos Requests

### 1. Local-First → Cache → Batch (3 Camadas)
```
Pergunta chega → Cache hit? → Sim → Resposta ($0, <100ms)
                → Nao → Resolve local? → Sim → Resposta ($0)
                                        → Nao → Batch? → Sim → Agrupa
                                                        → Nao → API call
```

### 2. Modelo Certo para a Tarefa Certa
| Complexidade | Modelo | Custo/call |
|---|---|---|
| Trivial (parsing, regex) | Ollama local | $0.00 |
| Simples (extracao, triagem) | Haiku | ~$0.001 |
| Media (resumo, codigo) | Sonnet | ~$0.01 |
| Complexa (MBE, raciocinio) | Opus | ~$0.05-0.10 |
| Browser (fontes pagas) | Cowork | $0 (plano) |

### 3. Human-in-the-Loop (Karpathy)
- Nao deixe agentes retentarem autonomamente
- Uma tentativa falhada que voce revisa > 5 retries
- Humano decide, agente executa

### 4. Coautoria AI Explicita (Pacto de Alianca)
Protocolo completo em `.claude/rules/coauthorship.md`.
Principio: transparencia total, honestidade intelectual, rastreabilidade.

### 5. Meca e Otimize (Willison)
- Rastreie custo por agente e por tarefa (BudgetTracker)
- Cache hit rate > 50%
- `max_budget_usd` como safety net
- Reviews mensais de custo

### 6. Referenciamento Impecavel (MBE)
- PMID obrigatorio para papers medicos
- DOI quando disponivel
- URL verificavel para fontes web
- Data de acesso para conteudo online
- Nivel de evidencia classificado (GRADE ou Oxford CEBM)

## Skill Design (Anthropic Pattern)

```
skill-name/
├── SKILL.md          # Instrucoes principais (<500 linhas)
├── REFERENCE.md      # Carregado sob demanda
└── scripts/          # Executados, nao carregados no contexto
```

### Anti-Patterns a Evitar
- Skill >500 linhas (quebrar em REFERENCE.md)
- Oferecer muitas opcoes sem default
- Assumir ferramentas instaladas
- Informacao time-sensitive no SKILL.md
- Instrucoes de personalidade

Ref: Anthropic Skill Best Practices
https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices

## Workflow MBE Referenciado

### Ferramentas por Tipo de Estudo
```
RCT → CONSORT (report) + Cochrane RoB 2 (qualidade)
Coorte → STROBE (report) + Newcastle-Ottawa ou ROBINS-I (qualidade)
Caso-controle → STROBE (report) + Newcastle-Ottawa (qualidade)
Revisao sistematica → PRISMA (report) + AMSTAR-2 (qualidade)
Meta-analise obs. → MOOSE (report)
Diagnostico → STARD (report) + QUADAS-2/3 (qualidade)
Guideline → AGREE II (qualidade)
Relato de caso → CARE (report)
```

Ref: EQUATOR Network - https://www.equator-network.org/
Ref: GoodReports - https://www.goodreports.org/
Ref: Johansen & Thomsen (2016). PMC10833025

### Estatisticos de Referencia para Aprendizado
- Frank Harrell: fharrell.com (Bayesiano, trials, free e-book hbiostat.org/bbr)
- Andrew Gelman: statmodeling.stat.columbia.edu (Bayesiano, causal)
- Vinay Prasad: vinayakkprasad.com (Epidemio, critica MBE, Plenary Session)
- StatQuest (YouTube): bioestatistica visual, Josh Starmer
- Dr. Luis Correia (BR): medicinabaseadaemevidencias.blogspot.com

### Fontes de Busca
- EQUATOR Network: 500+ reporting guidelines
- GoodReports: seletor interativo de checklist
- Cochrane Library: revisoes sistematicas gold standard
- GRADE Working Group: gradeworkinggroup.org
