# SOTA-B: Industry Agent Creation Frameworks (S248, 2026-04-25)

> Foco: single agent creation, não orchestration. Pesquisa externa — OLMO citado somente na seção de transferência.
> Confidence: **high** = URL fonte primária verificada | **medium** = padrão observado em múltiplas fontes secundárias | **low** = inferência ou fonte única não verificada

---

## Sources cited (URL + access date 2026-04-25)

1. https://developers.openai.com/api/docs/guides/agents — OpenAI Agents SDK docs
2. https://openai.com/index/new-tools-for-building-agents/ — New tools announcement Mar 2025
3. https://cdn.openai.com/business-guides-and-resources/a-practical-guide-to-building-agents.pdf — Practical Guide PDF
4. https://adk.dev/ — Google ADK homepage (redirect from google.github.io/adk-docs)
5. https://docs.cloud.google.com/gemini-enterprise-agent-platform/build/adk — Gemini Enterprise Agent Platform docs
6. https://google.github.io/adk-docs/agents/models/google-gemini/ — ADK model integration
7. https://learn.microsoft.com/en-us/agent-framework/overview/ — Microsoft Agent Framework overview (updated 2026-04-20)
8. https://devblogs.microsoft.com/foundry/introducing-microsoft-agent-framework-the-open-source-engine-for-agentic-ai-apps/ — MAF announcement
9. https://visualstudiomagazine.com/articles/2026/04/06/microsoft-ships-production-ready-agent-framework-1-0-for-net-and-python.aspx — MAF 1.0 release
10. https://docs.crewai.com/en/concepts/agents — CrewAI agent definition (official docs)
11. https://blog.langchain.com/langchain-langgraph-1dot0/ — LangChain/LangGraph 1.0 announcement
12. https://docs.langchain.com/oss/python/langgraph/overview — LangGraph overview
13. https://pydantic.dev/docs/ai/overview/ — PydanticAI docs (redirect from ai.pydantic.dev)
14. https://huggingface.co/docs/smolagents/en/guided_tour — Smolagents guided tour (official)
15. https://huggingface.co/blog/smolagents — Smolagents launch post
16. https://github.com/letta-ai/letta — Letta GitHub
17. https://docs.letta.com/concepts/letta/ — Letta concepts/research background
18. https://www.letta.com/blog/letta-v1-agent — Letta v1 agent loop rearchitecture
19. https://mastra.ai/ — Mastra homepage
20. https://mastra.ai/blog/choosing-a-js-agent-framework — Mastra framework comparison blog
21. https://www.speakeasy.com/blog/ai-agent-framework-comparison — Cross-framework comparison (Speakeasy)
22. https://langfuse.com/blog/2025-03-19-ai-agent-comparison — Langfuse framework comparison Mar 2025

---

## Per-framework essence

### OpenAI Agents SDK (successor to Assistants API)

**Status 2026:** Assistants API sunset previsto Aug 26 2026. Successores: Responses API + Agents SDK (lançado Mar 2025). [confidence: high, src 1, 2]

**Core single-agent primitives:**
- `instructions` — system prompt do agente (string)
- `tools` — lista de ferramentas acessíveis (allow-list explícita)
- `model` — referência ao modelo LLM
- `handoffs` — lista de agentes para delegação (omitir para single agent)
- `guardrails` — validação input/output (opcional)

**Execution:** `Runner.run(agent, input)` — tracing automático do execution graph.

**Design philosophy:** "Start here when shaping a single agent contract." Minimal abstractions: Agent, Handoff, Guardrail, Session. SDK é produção-ready (substituiu Swarm experimental de 2024). [confidence: high, src 1]

**Nota OLMO:** Claude Code usa idioma diferente (frontmatter YAML + body), mas os conceitos mapeiam: `instructions` → YAML `description` + body MD do agente.

---

### Google Gemini / Vertex AI ADK

**Status 2026:** ADK é open-source, multi-linguagem (Python, TypeScript, Go, Java). Gemini Enterprise Agent Platform unificou Agent Builder + ADK em plataforma única. [confidence: high, src 4, 5]

**Core single-agent primitives (Python/TS):**
```python
agent = Agent(
    name="researcher",          # required — identificador
    model="gemini-flash-latest", # required — modelo
    instruction="...",           # required — system prompt / persona
    tools=[google_search],       # optional — allow-list de ferramentas
    description="..."            # optional — usado quando agente é sub-agent
)
```

**Design philosophy:** "Powerful simplicity" — 4 params para agente funcional, cresce para multi-agent quando necessário. Model-agnostic (suporta LiteLLM para modelos não-Gemini). [confidence: high, src 4]

**Differentiator:** Integração nativa com Google Search, Code Execution, e Interactions API. `description` (diferente de `instruction`) é o campo usado para expor o agente como managed agent em sistemas multi-agent — separação clara de responsabilidade.

---

### Microsoft Agent Framework (MAF) — sucessor de AutoGen + Semantic Kernel

**Status 2026:** MAF 1.0 lançado abr 2026 — release production-ready com stable APIs e LTS. Convergência de AutoGen (multi-agent patterns simples) + Semantic Kernel (enterprise features). [confidence: high, src 7, 9]

**Core single-agent (Python):**
```python
agent = client.as_agent(
    name="HelloAgent",
    instructions="You are a friendly assistant. Keep your answers brief.",
)
result = await agent.run("query")
```

**Core single-agent (.NET):**
```csharp
AIAgent agent = new AIProjectClient(...).AsAIAgent(
    model: "gpt-5.4-mini",
    instructions: "...");
```

**Design philosophy:** "If you can write a function to handle the task, do that instead of using an AI agent." — saudável gate anti-over-engineering. Agents para tarefas open-ended; Workflows (graph-based) para multi-step com controle explícito. [confidence: high, src 7]

**Migração AutoGen → MAF:** Single-agent requer apenas "light refactoring". MAF adiciona session-based state management, type safety, middleware, telemetry sobre as abstrações simples do AutoGen. [confidence: high, src 8]

---

### CrewAI

**Status 2026:** >1.4 bilhões de execuções agentic; ~60% Fortune 500 users (late 2025). Framework Python open-source focado em role-based multi-agent. [confidence: medium, src 10]

**Core single-agent primitives:**
```python
Agent(
    role="Senior Market Researcher",   # required — função/expertise
    goal="Find and summarize...",      # required — objective individual
    backstory="...",                   # required — contexto/persona
    llm="claude-sonnet-4-6",          # optional — default gpt-4
    tools=[SearchTool()],              # optional — []
    verbose=False,                     # optional
    allow_delegation=False,            # optional — default False
    max_iter=20,                       # optional — max loops
    respect_context_window=True,       # optional — auto-summarize
    reasoning=False,                   # optional — reflect before execute
)
```

**Config recomendada:** YAML em `config/agents.yaml` referenciado por código (mais maintainable que definição inline). [confidence: high, src 10]

**Design philosophy:** Role-Goal-Backstory como "hiring for a job" — quanto mais específico e realístico o role, melhor a performance. Engenharia de prompt diretamente impacta resultado. [confidence: high, src 10]

**Pattern produção observado (medium confidence):** Prototipação em CrewAI → rewrite de produção em LangGraph quando o design está consolidado e controle de fluxo preciso é necessário. [confidence: medium, src 21]

---

### LangChain / LangGraph

**Status 2026:** LangChain 1.0 out 2025; LangGraph v1.1.3 mar 2026 (distributed runtime + agent templates). Posicionamento claro: "Use LangGraph for agents, not LangChain." LangChain permanece bom para RAG/Q&A; LangGraph é o runtime de agentes. [confidence: high, src 11, 12]

**Core single-agent (LangGraph):**
- `create_agent()` — nova abstraction de alto nível (LangChain 1.0), mais rápida para single agent
- Modelo como grafo: nodes = steps/decisions, edges = transições condicionais
- State é explícito e tipado — persistência built-in

**Design philosophy:** Shift de "muitos patterns" → "abstrações menos e mais opinativas". Dor de versões anteriores: abstrações pesadas, API surface muito ampla. LangGraph resolve isso com graph explícito que dá controle total sobre estado, branching, error recovery, e human-in-the-loop. [confidence: high, src 11]

**Differentiator:** LangGraph trata estado como cidadão de primeira classe — checkpointing nativo para workflows longos. Unico framework com distributed runtime CLI (v1.1.3). [confidence: medium, src 11]

---

### Emerging: Mastra / Letta / Smolagents / Pydantic AI / e2b

#### Mastra (TypeScript-first)
**Status:** Framework TS para equipes TypeScript/serverless. Ativo 2025. [confidence: medium, src 20]

**Core agent fields:**
```typescript
new Agent({
    name: "my-agent",
    model: "anthropic/claude-3-5-haiku",  // "provider/model" pattern
    instructions: "...",                    // system prompt
    tools: { ... },                         // object (não array)
    providerOptions: { ... },               // model-specific config
})
```
`.generate()` aceita `structuredOutput` com Zod schema para outputs tipados. [confidence: medium, src 20]

**Differentiator:** Native TypeScript-first (vs adapters), serverless workflow engine, Zod schema nativamente integrado para output tipado. [confidence: medium, src 20, 21]

#### Letta (formerly MemGPT)
**Status:** Framework para "stateful agents com long-term memory". Paradigma LLM-as-OS. [confidence: high, src 16, 17, 18]

**Core agent creation fields:**
```python
agent = client.agents.create(
    memory_blocks=[
        {"label": "human", "value": "..."},  # info sobre o usuário
        {"label": "persona", "value": "..."}  # personalidade do agente
    ],
    model="openai/gpt-5.2",
    tools=["web_search"],
)
```

**Design philosophy:** Memória em camadas — core memory (in-context, tamanho limitado como RAM), archival memory (external storage, como disco), recall memory (histórico de conversas). Agentes se auto-editam via memory tools. [confidence: high, src 17, 18]

**Differentiator:** Único framework onde o AGENTE gerencia sua própria memória ativamente (self-editing memory). Não é simplesmente "RAG" — é persistência estruturada com agency sobre o que manter em contexto. [confidence: high, src 18]

#### Smolagents (HuggingFace)
**Status:** v1.24.0 disponível. Filosofia "barebones" — minimal abstractions. [confidence: high, src 14]

**Dois agent types:**
- `CodeAgent(tools=[], model=model)` — ações como código Python (expressivo, requer sandbox seguro)
- `ToolCallingAgent(tools=[], model=model)` — ações como JSON estruturado (confiável, previsível)

**Mínimo viável:** apenas `tools` e `model` são obrigatórios. [confidence: high, src 14]

**Design philosophy:** CodeAgent é inovação principal — ao invés de "qual tool chamar com quais args", LLM gera e executa Python. Alta expressividade: combina tools, faz loops, transforma resultados. Requer executor seguro (E2B, Blaxel, Docker, ou local com allow-list). [confidence: high, src 14]

**Differentiator:** Code-first action generation é único entre os frameworks mainstream. Emergent reasoning — agente pode criar sub-ferramentas dinamicamente durante execução. [confidence: high, src 14]

#### Pydantic AI
**Status:** v1.0 set 2025 (API stability commitment). Python, type-safe, da equipe Pydantic. [confidence: high, src 13]

**Core agent fields:**
```python
agent = Agent(
    model="anthropic:claude-sonnet-4-6",  # provider:model
    instructions="...",                     # static ou @agent.instructions dynamic
    deps_type=MyDeps,                       # dataclass com dependencies
    output_type=MyPydanticModel,           # estrutura e valida output
    tools=[my_tool],                        # @agent.tool decorator
)
```

**Design philosophy:** FastAPI-like ergonomics para AI. Type hints como contrato — IDE autocompletion, erros em write-time não runtime. [confidence: high, src 13]

**Differentiator:** `output_type` com Pydantic model valida resposta LLM automaticamente — rerun se inválido. `Capabilities` primitive (v1.71) agrupa tools + hooks + instructions como unidade reutilizável. [confidence: medium, src 13]

#### e2b
**Status:** Sandbox de execução de código seguro (complementa outros frameworks, não substitui). Usado por CrewAI, Smolagents, etc. como executor. Não é framework de agent definition per se. [confidence: high, src 14]

---

## Consensus across frameworks (≥3 concordam)

| # | Consensus | Evidência |
|---|-----------|-----------|
| C1 | **Instructions/system prompt como campo primário obrigatório** | OpenAI (`instructions`), Google ADK (`instruction`), MAF (`instructions`), CrewAI (`role`+`goal`+`backstory`), Mastra (`instructions`), PydanticAI (`instructions`) | high |
| C2 | **Tool allow-list explícita** — agente sabe quais ferramentas tem; não acesso irrestrito | Todos frameworks sem exceção. OpenAI: lista em `tools`; Google ADK: array `tools`; CrewAI: lista `tools`; Smolagents: lista `tools` | high |
| C3 | **Modelo é parâmetro configurável**, não hardcoded — swap sem reescrever lógica | OpenAI, ADK, MAF, CrewAI, Mastra, PydanticAI, Smolagents | high |
| C4 | **Separação description vs instructions** — `description` descreve o agente para outros (humans/orchestrators); `instructions` governa o comportamento interno | OpenAI (instructions + handoffs list), ADK (`description` separado de `instruction`), MAF (instructions), Smolagents (name+description para multi-agent) | high |
| C5 | **Tool definition requer nome + descrição + schema** — LLM usa estas para decidir quando chamar | Todos frameworks. Smolagents: "name, description, input types, output type." PydanticAI: type hints como schema | high |
| C6 | **Max iterations / timeout** como safety gate — evita loop infinito | CrewAI (`max_iter`, `max_execution_time`), OpenAI SDK (max_turns), Smolagents (max_steps), MAF (timeout) | high |
| C7 | **Structured output** como feature primeira-classe — Pydantic/Zod para validar resposta LLM | PydanticAI (`output_type`), Mastra (`structuredOutput` + Zod), OpenAI SDK (output schemas), CrewAI (`response_template`) | high |
| C8 | **Gate anti-over-engineering** — frameworks explicitamente aconselham não usar agente se função simples resolve | MAF: "If you can write a function, do that." CrewAI: "limit allow_delegation=False para executores." OpenAI: "start single before multi" | medium |

---

## Divergence (frameworks discordam fundamentalmente)

| # | Dimensão | Posições | Análise |
|---|----------|----------|---------|
| D1 | **Stateful vs Stateless default** | Letta: stateful é primitivo central (memory blocks). MAF: session-based state opt-in. OpenAI SDK: Sessions como feature adicional. CrewAI/Smolagents: stateless por default, memória é tool ou extensão | Design choice genuíno: trade-off entre simplicidade (stateless) e continuidade (stateful). Para assistentes pessoais persistentes → Letta ganha. Para pipelines de tarefas discretas → stateless é mais simples. |
| D2 | **Code generation vs JSON tool calling** | Smolagents CodeAgent: ações como Python code (alto poder, risco). Todos outros: JSON tool calls (lower power, mais seguro e previsível) | Objective measure parcial: CodeAgent tem benchmarks superiores em tasks complexas, mas requer sandboxing obrigatório. JSON é mais seguro e interoperável. |
| D3 | **Role/persona como campo estruturado vs instrução livre** | CrewAI: role, goal, backstory como campos separados obrigatórios. Todos outros: `instructions` é string livre sem estrutura forçada | CrewAI aposta que estruturar força o desenvolvedor a ser explícito. Outros apostam que liberdade permite tailoring superior. Evidência empírica (medium confidence): "quanto mais específico e realístico o role, melhor a performance" — mas isso vale para string livre também. |
| D4 | **Config format: YAML vs code** | CrewAI recomenda YAML (`config/agents.yaml`). MAF, OpenAI SDK, PydanticAI: código (Python/C#). ADK: código. Mastra: código TypeScript | YAML favorece legibilidade e separação config/code. Código favorece type-safety e IDE support. Claude Code usa frontmatter YAML + body MD — modelo híbrido próximo do CrewAI approach. |
| D5 | **Memory architecture** | Letta: camadas explícitas (core/archival/recall), agente auto-edita. PydanticAI: dependencies injection (deps_type). MAF: session + context providers. CrewAI: knowledge_sources + RAG opt-in | Fundamental: Letta é framework construído em torno de memória; outros tratam como extensão. |

---

## Patterns transferíveis para Claude Code (OLMO específico)

**Claude Code idiom:** frontmatter YAML + Markdown body. Agente = `.claude/agents/*.md`.

| Padrão framework | Tradução Claude Code / OLMO | Já existe? |
|-----------------|----------------------------|------------|
| `instructions` (campo primário) | Body MD do arquivo de agente | Sim (body MD é o system prompt) |
| `description` separado de `instructions` | Frontmatter `description:` — usado pelo orchestrator para decidir quando spawnar | Sim (debug-symptom-collector tem description no frontmatter) |
| Tool allow-list explícita | Frontmatter `disallowedTools:` (negativo) — OLMO usa deny-list, não allow-list | Sim — mas inversão: deny vs allow |
| Max iterations | Frontmatter `maxTurns:` | Sim |
| Model como parâmetro | Frontmatter `model:` | Sim |
| Role/Goal/Backstory (CrewAI) | OLMO: role = nome do agent + description; goal = primeiras linhas do body; backstory implícita nas constraints e exemplos | Parcialmente — role é nome, goal é description, backstory emerge do body |
| Structured output schema | Body MD define schema JSON (ex: debug-symptom-collector Output Schema) | Sim — manual, não validado automaticamente |
| Capability primitive (PydanticAI) | Skills em `.claude/skills/*/SKILL.md` — tools + instructions reutilizáveis | Sim — pattern de skills serve função similar |
| Code-first actions (Smolagents) | Claude Code nativo pode executar Bash/Node.js — análogo ao CodeAgent | Sim — agentes podem spawnar bash |
| Stateful memory (Letta) | Memória em `~/.claude/memory/*.md` — diferente mas análogo | Parcial — sem auto-edição pelo agente |

**Gap identificado (KBP-32 spot-checked):** OLMO usa `disallowedTools` (deny-list) enquanto todos os frameworks externos usam allow-list explícita. Não é necessariamente inferior — deny-list simplifica definição quando o agente precisa da maioria das tools — mas inverte o princípio de least-privilege. Grep confirmou: debug-symptom-collector usa `disallowedTools: Write, Edit, Agent`.

---

## OLMO matriz por dimensão

| Dimensão | Consensus externo | OLMO state | Decision |
|----------|-------------------|------------|----------|
| Instructions como campo primário | Universal — string ou campos estruturados | Sim — body MD é system prompt | Alinhado |
| Description separada de instructions | Recomendada para uso em multi-agent | Sim — frontmatter `description:` | Alinhado |
| Tool allow-list explícita | Todos recomendam | OLMO usa deny-list (`disallowedTools`) | Diverge — aceitável, mas conscientemente inverso ao princípio least-privilege |
| Model configurável por agente | Universal | Sim — frontmatter `model:` | Alinhado |
| Max iterations safety | Universal | Sim — frontmatter `maxTurns:` | Alinhado |
| Structured output schema | ≥4 frameworks têm validação automática | OLMO: manual no body MD | Parcial — sem validação automática, mas schema explícito no body |
| Role explícito como campo | CrewAI obrigatório; outros: em `instructions` | OLMO: role está no nome do arquivo + primeiras linhas do body | Funcional mas implícito |
| Stateful memory per-agent | Letta core; outros: opt-in | OLMO: `memory: project` no frontmatter; sem auto-edição | Básico — read-only memory |
| Config como YAML | CrewAI recomenda; Claude Code usa | Frontmatter YAML + body MD | Alinhado com CrewAI approach |
| Capability/Skill reutilizável | PydanticAI Capabilities, OpenAI SDK tools | `.claude/skills/*/SKILL.md` | Alinhado — skills são o equivalente |

---

## Open questions

1. **Deny-list vs allow-list:** Vale migrar agentes OLMO para allow-list explícita (ex: `allowedTools: Read, Grep, Bash`) para alinhar com least-privilege universal dos frameworks? Trade-off: verbosidade maior na definição.

2. **Structured output validation:** Os frameworks com `output_type` (PydanticAI) ou Zod (Mastra) validam automaticamente e reiniciam se inválido. OLMO tem schemas manuais no body. Existe mecanismo de validação de output no Claude Code SDK que poderíamos usar?

3. **Capability composition:** PydanticAI `Capabilities` agrupa tools + hooks + instructions como unidade reutilizável. Skills em OLMO servem função análoga — mas são invocadas por Lucas, não por agentes. Agentes podem chamar skills programaticamente?

4. **Letta-style persistent memory per agent:** `memory: project` no OLMO frontmatter fornece acesso read ao project memory, mas agentes não auto-editam. Existe valor em agentes que atualizam sua própria memória entre sessões?

5. **CodeAgent pattern (Smolagents):** Agentes OLMO já podem executar Bash — mas não geram código dinamicamente como o CodeAgent do Smolagents. Para quais casos de uso OLMO esse nível de flexibilidade seria valioso vs os riscos de segurança?

---

*Gerado por: Lucas + Claude Sonnet 4.6 | S248 | 2026-04-25*
*Coautoria AI explícita conforme CLAUDE.md §Conventions*
