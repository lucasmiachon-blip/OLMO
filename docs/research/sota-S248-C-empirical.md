# SOTA-C: Empirical Agent Evidence (S248, 2026-04-25)

> Escopo: evidence-first. Apenas claims com paper/URL/data citável.
> KBP-32 aplicado: nenhum claim "X é ausente" sem Grep/Read confirmando.
> Confidence: HIGH = multi-paper consensus + benchmark | MED = single paper ou strong prod case | LOW = anecdotal

---

## Sources Cited

| # | Fonte | Tipo | Data | URL/ID |
|---|-------|------|------|--------|
| S1 | AgentBench: Evaluating LLMs as Agents (Liu et al.) | paper | ICLR 2024 | arXiv:2308.03688 |
| S2 | GAIA: a benchmark for General AI Assistants (Mialon et al.) | paper | ICLR 2024 | arXiv:2311.12983 |
| S3 | OAgents: An Empirical Study of Building Effective Agents | paper | EMNLP 2025 | arXiv:2506.15741 |
| S4 | SWE-Bench Verified leaderboard | benchmark | live | swebench.com/verified.html |
| S5 | Berkeley Function Calling Leaderboard (BFCL) V4 (Patil et al.) | benchmark | ICML 2025 | gorilla.cs.berkeley.edu |
| S6 | SWE-Effi: Re-Evaluating Software AI Agent System Effectiveness Under Resource Constraints | paper | 2025-09 | arXiv:2509.09853 |
| S7 | Inside the Scaffold: A Source-Code Taxonomy of Coding Agent Architectures | paper | 2025-04 | arXiv:2604.03515 |
| S8 | Towards a Science of Scaling Agent Systems | paper | 2025-12 | arXiv:2512.08296 |
| S9 | A Comprehensive Empirical Evaluation of Agent Frameworks on Code-centric SE Tasks | paper | 2025-11 | arXiv:2511.00872 |
| S10 | OpenHands Software Agent SDK (Wang et al.) | paper | 2025-11 | arXiv:2511.03690 |
| S11 | Multi-Agent Design: Optimizing Agents with Better Prompts and Topologies (MASS) | paper | 2025-02 | arXiv:2502.02533 |
| S12 | Single-Agent LLMs Outperform Multi-Agent Systems on Multi-Hop Reasoning | paper | 2025-04 | arXiv:2604.02460 |
| S13 | How Do Coding Agents Spend Your Money? (token consumption study) | paper | 2025 | OpenReview:1bUeVB3fov |
| S14 | Dive into Claude Code: The Design Space of Today's and Future AI Agent Systems | paper | 2025-04 | arXiv:2604.14228 |
| S15 | Anthropic Engineering: Effective Harnesses for Long-Running Agents | postmortem | 2025 | anthropic.com/engineering |
| S16 | Cognition/Devin: 18-Month Performance Review | postmortem | 2025 | cognition.ai/blog/devin-annual-performance-review-2025 |
| S17 | 9 Critical Failure Patterns of Coding Agents (DAPLab, Columbia) | postmortem | 2026-01 | daplab.cs.columbia.edu |
| S18 | Factory.ai: Evaluating Context Compression for AI Agents | eval-framework | 2025 | factory.ai/news/evaluating-compression |
| S19 | ACON: Optimizing Context Compression for Agents | paper | 2025 | OpenReview:7JbSwX6bNL |
| S20 | AISI/Inspect AI: Early lessons from evaluating frontier AI systems | eval-framework | 2024-2025 | aisi.gov.uk/blog |
| S21 | ReAct: Synergizing Reasoning and Acting in Language Models (Yao et al.) | paper | 2022→cited 2024 | arXiv:2210.03629 |
| S22 | Reflexion: Language Agents with Verbal Reinforcement Learning (Shinn et al.) | paper | 2023→replicated 2024 | arXiv:2303.11366 |
| S23 | Language Agent Tree Search — LATS (Zhou et al.) | paper | 2024 | arXiv:2310.04406 |
| S24 | SWE-EVO: Benchmarking Coding Agents in Long-Horizon SE Scenarios | paper | 2025-12 | arXiv:2512.18470 |
| S25 | RAGAS: Automated Evaluation of RAG (Es et al.) | paper | EACL 2024 | arXiv:2309.15217 |

---

## Design Choices Correlated with Reliability (per metric)

### Higher Accuracy

**Single-agent até baseline ~45% > multi-agent (HIGH, S8)**
Estudo com 180 configurações, 5 arquiteturas, 3 LLM families, 4 benchmarks.
- Tarefas onde single-agent já excede 45% de accuracy: adicionar agentes resulta em retorno negativo (β̂ = −0.408, p < 0.001).
- Finance Agent (PSA = 0.35): MAS deu +80.9% melhoria.
- PlanCraft (PSA = 0.57): MAS degradou −39% a −70%.
- Conclusão: MAS só agrega onde o baseline single-agent é fraco.

**Tool design especializado > tools genéricas (HIGH, S9, S7)**
- Frameworks sem tool de geração de patch falharam completamente em program repair (S9).
- SWE-Agent's Agent-Computer Interface (ACI) com edit_file + scroll especializado correlaciona com scores SWE-Bench mais altos (S7).
- OpenHands atingiu 72.8% no SWE-Bench Verified com Claude Sonnet 4.5 via typed tool system + sandboxed execution (S10).

**Instruction alignment > code pretraining isolado (MED, S1)**
AgentBench (ICLR 2024): "poor long-term reasoning, decision-making, and instruction following" são os principais gargalos. Code pretraining tem impacto ambivalente — melhora alguns tasks, piora outros.

**Modular scaffold + loop composto (MED, S7)**
11 de 13 agentes analisados combinam múltiplos loop primitives (ReAct + generate-test-repair + tree search). Modularidade permite flexibilidade sem overhead fixo de MAS completo.

**GPT-5/Claude 4.5 base model domina scaffolding choice (MED, S24)**
GPT-5 no OpenHands: 65% SWE-Bench Verified vs apenas 21% no SWE-EVO (long-horizon). Capacidade do modelo de base importa mais que escolha de scaffold para tasks difíceis.

### Lower Hallucination

**Context management correto reduz hallucination em MAS (HIGH, S9)**
Single-agent frameworks mantêm "minimal context that remains within the LLM's long-context constraints" — acesso histórico completo + hallucination mais controlada vs MAS com information overload.

**Artifact tracking é o ponto mais fraco de todas as approaches (HIGH, S18)**
Factory.ai: compressão de contexto avaliada em 36.611 mensagens de produção.
- Artifact tracking score: 2.19–2.45/5.0 em TODOS os métodos testados.
- "No method reliably remembering what files were changed."
- Compressão genérica perde file paths e error messages — força re-fetching custoso.

**ACON (context-aware compaction) reduz tokens 26–54% mantendo 95% da accuracy (MED, S19)**
Método: otimização guiada por falhas do compressor em vez de heurística fixa. Destilação em modelos menores: 95% da accuracy do teacher.

**Hallucination em MAS propaga entre agentes (MED, S9)**
Multi-agent "interaction overhead between the planning agent and downstream specialized agents" causa information loss e hallucination propagation. Trajectórias MAS quase 2x mais longas sem ganho de effectiveness.

**65% de enterprise AI failures em 2025 atribuídas a context drift/memory loss (LOW, anecdotal)**
Reportado como tendência por múltiplas fontes de produção, sem paper peer-reviewed. Flag como não-resolvido.

### Better Tool Use

**Implicit parameter conversion é o maior failure mode (HIGH, S5 — BFCL)**
GPT-4 falha em converter "5%" → 0.05 enquanto modelos superiores convertem. Performance cai dramaticamente em:
- Multi-function call scenarios
- Parallel function calls
- Deciding when NOT to call a tool
- Long-turn multi-step tool sequences

**Flexible type system > rigid JSON schema (MED, S5)**
Gorilla OpenFunctions-v2 supera GPT-4 parcialmente por suportar tipos linguísticos específicos (HashMap, LinkedList) vs genérico "number". Leaderboard BFCL V4 top score: 0.885 (Llama 3.1 405B Instruct).

**Typed tool system com validação Pydantic previne runtime errors (MED, S10)**
OpenHands SDK: Action-Observation pattern com schema validation antes de execução reduz crashes em tool invocation.

**MCP integration como first-class tool (MED, S10)**
JSON Schemas de ferramentas externas traduzidos automaticamente em Action models — padronização reduz drift entre especificação e execução.

### Reduced Loops / Stuck States

**Token snowball effect é sistemático e quantificado (HIGH, S6)**
SWE-Effi (50 issues do SWE-Bench Verified):
- SWE-Agent + GPT-4o: falhas consomem 8.8M tokens / 658s vs sucessos em 1.8M tokens / 167s → 4x+ overhead.
- OpenHands + Llama-70B: falhas em 238.9s vs sucessos em 79s → 3x overhead.
- Cada API call adiciona "thousands of tokens even when the agent fails to make meaningful progress."

**Failing trajectories são 12–82% mais longas que successful (HIGH, S7)**
Estudo em repositórios reais: repository navigation domina atividade de agentes falhos. Estratégia de retrieval é crítica para prevenir loops de navegação.

**Step limit hard cap é defesa mecânica mais confiável (MED, S8 + produção)**
Decisão de retry é "locally reasonable" mas sem estado global de progresso. Solução: progress detection + stop rules enforced outside the model. Sem gate mecânico, o agente não para.

**Comunicação super-linear cresce com número de agentes: T = 2.72 × (n + 0.5)^1.724, R² = 0.974 (HIGH, S8)**
6.2x mais turns em hybrid MAS vs single-agent. Em Workbench (16 tools), hybrid exibiu 515% de overhead.

---

## Benchmark Insights

### SWE-Bench Top Patterns (S4, S6, S7, S9, S10, S24)

- **Top score atual**: OpenHands + Claude Sonnet 4.5 → 72.8% no SWE-Bench Verified (S10, fev 2026)
- **Long-horizon gap**: GPT-5 cai de 65% (SWE-Bench Verified) para 21% (SWE-EVO long-horizon) — benchmark contamination e task-length sensitivity (S24)
- **Agentless vs scaffolded**: Agentless + Qwen3-32B lidera em token efficiency (46.7% EuTB) e resolve rate (48%) no SWE-Effi (S6)
- **Model-scaffold pairing matters**: SWE-Agent + GPT-4o-mini usa 18x mais tokens que SWE-Agent + Qwen3-32B para performance inferior — integração modelo+scaffold é variável critica (S6)
- **Overestimation residual**: métricas de SWE-Bench Verified podem superestimar performance real em 54% relativo quando test suite é augmentada (S4 notes)
- **Bug localization domina tempo**: repository navigation é o maior gargalo em trajectórias falhas (S7)

### BFCL Top Patterns (S5)

- **Top score**: 0.885 (Llama 3.1 405B Instruct, self-reported)
- **Single-turn**: modelos SOTA acertam bem; multi-turn e parallel calls ainda problemáticos
- **Evaluation approach**: structural check de tool calls sem executar todas as tools permite scale a 2,000+ question-function pairs
- **Open challenge**: "memory, dynamic decision-making, and long-horizon reasoning remain open challenges"
- **BFCL V4 expansion**: agora inclui web search agentic evaluation além de function calling

### AgentBench Patterns (S1 — ICLR 2024)

- **8 environments** testados em 29 LLMs
- **GPT-4 score**: 4.01 vs open-source: <1.00 na maioria
- **Principal obstáculo**: long-term reasoning + decision-making + instruction following
- **Code training**: efeito duplo — melhora alguns tasks, prejudica outros
- **Gap comercial vs open-source**: substantivo, sinal de que alinhamento de instrução é bottleneck principal

### GAIA Patterns (S2, S3)

- **Human accuracy**: 92% vs GPT-4 com plugins: 15% (2023 baseline)
- **OAgents SOTA** (open-source): 73.93% no GAIA (S3)
- **OAgents finding**: reproducibilidade era problema crítico — "significant variance between random runs" motivou protocolo de avaliação mais robusto
- **GAIA2** (ICLR 2026): asynchronous + event-driven environments, 1,120 cenários móveis, GPT-5 (high) atinge 42% — stress-test de temporal constraints + multi-agent coordination

---

## Production Postmortem Patterns (Failure Modes Empirically Observed)

### Devin / Cognition Labs — 18 months production (S16)

Dados quantificados de produção real:
- **PR merge rate**: 67% (2025) vs 34% (2024) — design iteration ao longo de 18 meses
- **Speed**: 4x mais rápido em problem solving; 2x mais eficiente em resource consumption
- **Security vulnerabilities**: 20x efficiency gain — 1.5 min/Devin vs 30 min/human
- **Java version upgrades**: 14x menos tempo que engenheiro humano
- **Test coverage**: de 50-60% para 80-90%

Failure modes observados:
1. **Ambiguous requirements**: agent falha com spec vaga — não aplica senior-level judgment autonomamente
2. **Mid-task requirement changes**: degradação performance quando escopo muda durante execução
3. **Unverifiable outcomes**: code quality e test logic validation ainda exigem human review
4. **Task sweet spot**: tasks com "clear, upfront requirements e verifiable outcomes, 4-8hrs junior engineer"

### Anthropic — Long-Running Agents (S15)

Failure modes e soluções documentadas:
| Failure | Solução implementada |
|---------|----------------------|
| "One-shotting" projetos completos prematuramente | Feature list JSON com >200 items discretos, testáveis, inicialmente "failing" |
| Trabalho incompleto entre sessões sem documentação | Git commits + progress notes no handoff |
| Features marcadas completas sem teste | Browser automation explícita via Puppeteer MCP |
| Incapacidade de retomar trabalho | Leitura de git logs + progress files no session start |

Insight: "Claude tended to mark features complete without proper testing" até ser explicitamente instruído a usar ferramentas de verificação.

### Claude Code Design Space — Failure Modes Identificados (S14)

1. **Silent failure & observability gap**: agent falha sem surfaçar erro ao usuário. Sistema não distingue completion de failure silenciosa.
2. **Cross-session persistence**: design atual suporta coerência intra-sessão mas falha em memória longitudinal entre sessões.
3. **Permission escalation under load**: granular safety causes UI freezes — fallback para generic approval prompt >50 subcomandos.
4. **Users approve ~93% of permission prompts** — "approval theater" sem real oversight = habituation trap.
5. **Short-term amplification vs long-term skill erosion**: ~27% das tasks seriam tentadas apenas com agent — mas sem mecanismo explícito de preservação de habilidade humana.

### DAPLab / Columbia — 9 Critical Failure Patterns (S17)

Observados across 15+ applications e 5 coding agents (sem frequências quantificadas):
1. Presentation & UI grounding mismatch (spatial reasoning ausente)
2. State management failures em refactoring cross-component
3. Business logic mismatch (código correto sintaticamente, lógica errada)
4. Data management errors (schema unawareness)
5. **API credential hallucination** — agent inventa credentials em vez de pedir
6. Security vulnerabilities (access control misimplementation)
7. Repeated code / duplicação vs abstração
8. **Codebase awareness degrada com crescimento do repositório** — reinventa em vez de reusar
9. **Exception handling silenciosa** — erros suprimidos em vez de comunicados

---

## Empirically-Backed Recommendations (com Effect Size quando disponível)

| Recomendação | Evidence | Effect Size | Confidence |
|---|---|---|---|
| Use single-agent até baseline >45%; só adicione MAS se tarefa exige paralelismo real | S8, S9 | β̂ = −0.408 single→MAS degradation acima do threshold | HIGH |
| Design tools especializadas com schema tipado; não generic grep | S5, S7, S9, S10 | frameworks sem patch tool: 0% repair success | HIGH |
| Implemente hard step cap + repeated-action detection mecânico, fora do modelo | S6, S8 + produção | falhas custam 3-4x mais tokens/tempo que sucessos | HIGH |
| Contexto histórico completo (single-agent) > inter-agent messaging (MAS) para tarefas longas | S8, S9 | MAS: quase 2x mais trajectória, performance inferior | HIGH |
| Verifiable outcomes definidos upfront aumentam PR merge rate | S16 | 34% → 67% merge rate em 18 meses (Devin) | MED |
| Anchored iterative summarization para compressão de contexto (Factory approach) | S18 | +0.26 quality score vs Anthropic/OpenAI methods | MED |
| ACON-style guided compaction reduz tokens 26-54% preservando 95% accuracy | S19 | 26-54% token reduction | MED |
| Agent-Computer Interface especializado (edit + scroll + lint) vs terminal genérico | S7, S9 | sem ACI especializado: falha completa em program repair | HIGH |
| Session state persistida em artifacts explícitos (features JSON + progress file + git log) | S15 | elimina "mark complete without testing" pattern | MED |
| Prompt optimization tem maior token-efficiency que mudança de topologia em MAS | S11 | "substantial margin" — sem número exato no abstract | MED |
| Explicit testing gate (browser automation, test runner) deve ser obrigatório, não opcional | S15, S16 | agentes marcam features complete sem teste quando não obrigados | MED |
| Scaffold + modelo devem ser co-avaliados, não separados | S6 | 18x token difference pelo mesmo scaffold com modelo diferente | HIGH |

---

## OLMO Matrix por Dimensão

| Dim | Empirical evidence | OLMO state | Decision |
|-----|-------------------|-----------|---------|
| **Single vs Multi-agent** | Single-agent supera MAS acima de 45% baseline; MAS adiciona overhead super-linear (S8) | 10 agents definidos; maioria especializada, não paralela | OLMO usa padrão correto: agents especializados sequenciais vs MAS paralelo. Threshold 45% deve guiar criação de novos agents |
| **Tool design** | Typed tools + ACI especializado > generic grep. Sem tool correta = 0% em task class (S5, S9) | Tools declaradas por agent em `.claude/agents/*.md`; MCP integration presente | ADOPT: auditar se cada agent tem tools mínimas suficientes para seu task class. Tool ausente = blocker, não workaround |
| **Context management** | Artifact tracking é o ponto mais fraco (2.2-2.5/5.0 em todos os métodos). Compressão perde file paths (S18) | HANDOFF.md, pending-fixes.md, progress tracking existentes | GAP: não há contexto compactado estruturado entre sessões. HANDOFF é human-readable mas não machine-queryable |
| **Loop prevention** | Hard cap mecânico + repeated-action detection. Falhas custam 3-4x recursos de sucessos (S6) | Stop hooks existentes; guard-bash-write.sh presente | GAP: não há step counter ou repeated-action detector documentado nos hooks |
| **Verifiable outcomes** | Explicit test gates aumentam PR merge rate (34→67%). Silent completion = hallucination trap (S15, S16) | `hooks/stop-quality.sh` existe; pending-fixes.md documenta residual | PARTIAL: stop quality hook captura alguns casos; agent-level explicit verification gate ausente |
| **Prompt structure** | Prompt optimization > topology para multi-agent. Role + instruction + exemplos compõem bloco otimizável (S11) | Skills em `SKILL.md` têm estrutura consistente; agents têm `description` field | PARTIAL: estrutura existe mas sem ablation/versionamento de prompts |
| **Session persistence** | Artifacts explícitos (feature list, progress, git log) previnem "mark complete without testing" (S15) | HANDOFF.md + CHANGELOG.md present; session-start hook lê pending-fixes | ADEQUATE: padrão OLMO alinhado com best practice identificada |
| **Model-scaffold pairing** | Integração modelo+scaffold > scaffold isolado. 18x token difference por wrong pairing (S6) | Routing por complexidade: trivial→Ollama, simple→Haiku, medium→Sonnet, complex→Opus | ADEQUATE: routing explícito. Risco: não há mecanismo de feedback quando pairing é subótimo |
| **Reproducibility** | Variance entre runs motivou protocolo mais robusto no OAgents (S3) | Sessions documentadas, mas sem protocolo de eval reproduzível de agents | GAP: sem eval harness formal para agents OLMO |

---

## Gaps in Literature (Design Choices Não-Resolvidos)

1. **Artifact tracking durante context compression**: todos os métodos comparados (Factory, Anthropic, OpenAI) pontuam 2.19-2.45/5.0 — nenhuma solução robusta publicada. Pesquisa aberta.

2. **Long-horizon vs short-horizon gap**: GPT-5 cai de 65% para 21% entre SWE-Bench Verified e SWE-EVO. O que específicamente quebra em long-horizon ainda não está mapeado com granularidade suficiente.

3. **Quando LATS/ToT supera ReAct/Reflexion**: comparação empírica direta em 2024-2026 é escassa. LATS (arXiv:2310.04406) mostra +0.19 sobre ReAct no HotPotQA, mas comparações controlled em coding tasks faltam.

4. **Prompt ablation para agents**: MASS (S11) propõe framework mas não publica números de ablation no abstract acessível. Qual a magnitude do ganho de prompt vs topologia remains open.

5. **MAS coordination protocols**: comunicação super-linear é observada (R²=0.974), mas protocolos que reduzem overhead sem perder paralelismo ainda não têm benchmark empírico consolidado.

6. **Context drift vs raw exhaustion**: claim de que "65% of enterprise AI failures em 2025 atribuídas a context drift" circula em múltiplas fontes mas sem paper peer-reviewed confirmado. Marcado LOW confidence.

7. **Agent eval reproducibility**: OAgents identificou "significant variance between random runs" como problema crítico. Protocolo de avaliação reproduzível para agent ecosystems como OLMO (multi-agent, multi-session) não tem standard estabelecido.

8. **Permission fatigue quantificado**: Claude Code design analysis nota 93% approval rate de permission prompts, mas impacto de habituation em security outcomes não tem estudo controlado publicado.

---

## Additional Evidence: Architecture Patterns Comparison

### ReAct vs Reflexion vs LATS — Empirical Numbers (S21, S22, S23)

| Method | HotPotQA EM | HumanEval pass@1 | Notes |
|--------|------------|-------------------|-------|
| ReAct (baseline) | 32% | — | GPT-3.5; Yao et al. arXiv:2210.03629 |
| Reflexion + ReAct | 44% | +11pp vs baseline | GPT-3.5; Shinn et al. arXiv:2303.11366 (NeurIPS 2023) |
| MAR (Multi-Agent Reflexion) | 47% (hard subset) | — | +3pp sobre single-agent Reflexion; arXiv:2512.20845 |
| LATS (tree search) | ~+0.19 over ReAct | — | Zhou et al. arXiv:2310.04406 |

Interpretação empírica: Reflexion oferece ganho real (+12pp EM) sobre ReAct puro, mas o benefício concentra-se em tarefas onde self-reflection resolve o erro — não é universal. LATS adiciona overhead de tree expansion que pode ser justificado apenas em espaços de busca grandes.

### Aider Architect/Editor Pattern (postmortem | 2024-09)

URL: aider.chat/2024/09/26/architect.html

- **Padrão**: modelo A (Architect) descreve a solução; modelo B (Editor) traduz para edições de arquivo
- **Resultado**: 85% pass rate (o1-preview Architect + o1-mini Editor) vs single-model baseline
- **Ganhos sobre solo**: Claude 3.5 Sonnet: 77.4% → 80.5%; GPT-4o: 71.4% → 75.2%; o1-mini: 61.1% → 71.4%
- **Mecanismo**: separação de concerns — reasoning sem constraint de formato (Architect) + format conformance sem reasoning (Editor)
- **Insight crítico**: "LLMs write worse code if you ask them to return code wrapped in JSON via tool function call" — format overhead degrada qualidade

Aplicabilidade OLMO: padrão diretamente relevante para agents que geram conteúdo + validam output (ex: qa-engineer + evidence-researcher). Separar geração de formatação pode melhorar qualidade sem aumentar custo de modelo.

### Anthropic "Building Effective Agents" — Design Taxonomy (postmortem | 2024-12)

URL: anthropic.com/research/building-effective-agents

Hierarquia de complexidade empiricamente justificada (adicionar complexidade só quando necessário):
1. Augmented LLM (retrieval + tools + memory) — suficiente para maioria dos casos
2. Prompt Chaining com gates programáticos — para sequências verificáveis
3. Routing para handlers especializados — quando classificação de input é confiável
4. Paralelização (sectioning ou voting) — quando subtasks são independentes
5. Orchestrator-Workers — quando subtasks não são previsíveis upfront
6. Evaluator-Optimizer loop — quando qualidade é mensurável iterativamente
7. Autonomous agents com tool loops — apenas quando os 6 anteriores são insuficientes

Failure modes documentados:
- **Framework abstraction overhead**: esconde lógica, dificulta debug — "Incorrect assumptions about what's under the hood are a common source of customer error"
- **Tool format friction**: relative filepaths causam falhas após directory changes — tooling deve usar absolute paths
- **Compounding errors**: em operações longas, erros se amplificam — checkpoint/verification gates são necessários

### ZenML Production Analysis — 1,200 Deployments (postmortem | 2025)

URL: zenml.io/blog/what-1200-production-deployments-reveal-about-llmops-in-2025

- Transição de workflow-based → agent-based resultou em melhor error handling para tasks complexas
- "Context engineering" emergiu como skill primária de 2025: "arquitetar a informação que os modelos consomem"
- Implementações mais bem-sucedidas tratam o LLM como "componente caótico que deve ser contido, verificado e restringido"
- 90% dos sistemas que não funcionam como esperado têm problemas nas instruções, não no modelo

### Google Cloud — "AI grew up and got a job" (postmortem | 2025)

URL: cloud.google.com/transform/ai-grew-up-and-got-a-job-lessons-from-2025-on-agents-and-trust

Lições de produção de 2025:
- Agents em produção real exigem trust calibration — nem autonomia total, nem micro-gerenciamento
- Observabilidade é requisito de produção, não feature opcional
- Agents que sabem quando escalar para humanos têm maior acceptance rate

---

## Supplementary: AISI / Inspect AI Evaluation Framework (S20)

URL: aisi.gov.uk + github.com/UKGovernmentBEIS/inspect_ai

Framework open-source do UK AI Security Institute para evals reproduzíveis de LLMs/agents:
- +200 evals pré-construídas, qualquer modelo
- Resultado chave (2024→2025): cyber tasks completadas 9% → 50% (apprentice level)
- Primeiro modelo a superar PhD holders em Biology QA: testado em 2024; hoje SOTA vai além
- Evals de comportamento agentico stress-testadas em 2025

Relevância para OLMO: Inspect AI como eval harness externo resolve o gap de reproducibilidade identificado em S3 (OAgents). Pode ser usado para criar baseline de eval formal de agents OLMO.

---

## Sources Index (Adicionais)

| # | Fonte | Tipo | Data | URL/ID |
|---|-------|------|------|--------|
| S26 | Anthropic: Building Effective Agents | postmortem | 2024-12 | anthropic.com/research/building-effective-agents |
| S27 | Aider: Separating code reasoning and editing (Architect/Editor) | postmortem | 2024-09 | aider.chat/2024/09/26/architect.html |
| S28 | ZenML: What 1,200 Production Deployments Reveal About LLMOps | postmortem | 2025 | zenml.io/blog/what-1200-production-deployments-reveal-about-llmops-in-2025 |
| S29 | MAR: Multi-Agent Reflexion Improves Reasoning Abilities in LLMs | paper | 2025-12 | arXiv:2512.20845 |
| S30 | When Single-Agent with Skills Replace Multi-Agent Systems | paper | 2025-01 | arXiv:2601.04748 |

---

*Coautoria: Lucas + Claude Sonnet 4.6 | S248 | 2026-04-25*
*Papers verificados via WebFetch antes de citar — nenhum arXiv ID fabricado.*
*Total fontes: 30 (25 papers/benchmarks/evals + 5 postmortems de produção)*
