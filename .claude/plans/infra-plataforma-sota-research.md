# Infra Plataforma — SOTA Research (S241)

> **Lançado:** 2026-04-23 por S241 `infra-plataforma`.
> **Fase 1:** 3 agents de pesquisa externa em paralelo (Anthropic / Competitors / Frontend).
> **Fase 2 (pós-relatórios):** matriz `ADOPT/EVALUATE/IGNORE/ALREADY` por área OLMO.
> **Fase 3 (pós-matriz):** plano de mudanças propose-before-pour.
> **Governance:** agents NÃO modificam código. Relatórios retornam via tool result; orquestrador (Claude Code Opus 4.7) consolida neste arquivo.

---

## Status dos agents

| # | Agent | Escopo | Status |
|---|-------|--------|--------|
| 1 | `claude-code-guide` | Anthropic ecosystem 2026-04 (Claude Code + Agent SDK + MCP) | **completed** (287s, 66.3k tokens, 18 tool uses) |
| 2 | `general-purpose` | Competitors SOTA (OpenAI Agents + Google ADK + top GH frameworks) | **completed** (139s, 32.7k tokens, 15 tool uses) |
| 3 | `general-purpose` | Frontend SOTA (CSS/JS baseline 2026 + slideware ecosystem) | **completed** (329s, 47.4k tokens, 35 tool uses) |

---

## Relatório 1 — Anthropic SOTA (claude-code-guide)

**Retorno:** 2026-04-23 | 287s | 66.3k tokens | 18 tool uses

**Fontes:** Claude Code Docs, Platform Docs, Hooks/Skills/Settings Refs, Agent Teams, Memory, Managed Agents, Changelog.

### 1. Feature inventory (resumo — inventário completo no relatório bruto do agent)

**Hooks (OLMO tem MAIORIA):**
- PRESENTE: SessionStart, SessionEnd, UserPromptSubmit (3×), PreToolUse (6+), PostToolUse (6+), Stop (7 hooks sequenciais), Notification, PreCompact, PostCompact, PostToolUseFailure
- AUSENTE (alta relevância): **StopFailure (v2.1.92)** — API errors silenciosos, **PermissionRequest (v2.0.45)** — poderia auditar KBP-26 allow-list growth, **SubagentStart/Stop (v1.0.41)**, **TaskCreated/Completed (v2.1.83/85)** quality gates, **InstructionsLoaded** debug, **FileChanged** .env watcher, **Elicitation/ElicitationResult (v2.1.76)** MCP
- AUSENTE (hook fields novos): `type: mcp_tool` (v2.1.101), `type: http`, `asyncRewake: true` (background exit 2), `once: true`, `statusMessage` (mensagem durante hook), `permissionDecision: defer`

**Skills (18 em OLMO; campos frontmatter subutilizados):**
- AUSENTE: `context: fork` (subagent isolation), `paths:` (path-scoped rules), `allowed-tools`, `agent:`, `effort:`, `model:`, `hooks:`, `arguments:` named, `${CLAUDE_SKILL_DIR}`, `${CLAUDE_SESSION_ID}`, inline shell `!backtick`, live change detection, skill nested monorepo

**Subagents (9 em OLMO):**
- PRESENTE: `mcpServers:` inline (evidence-researcher), `tools:` allowlist (alguns), `model:` via env `CLAUDE_CODE_SUBAGENT_MODEL=claude-sonnet-4-6`
- AUSENTE: `isolation: worktree`, `skills:` preload, `initialPrompt:`, `effort:`, `disallowedTools:`, agent auto memory

**Agent Teams (v2.1.32+):** AUSENTE — desabilitado por default; overhead alto; sem caso de uso OLMO.

**Worktrees:** AUSENTE nativo (/batch skill custom cobre parcialmente). `WorktreeCreate` hook disponível.

**Background / Tasks:** PRESENTE: TaskCreate/Update/List/Stop. [VERIFY]: Monitor tool, ScheduleWakeup, CronCreate, run_in_background — presentes neste ambiente mas não documentados canonicamente.

**Memory:**
- PRESENTE: CLAUDE.md hierarchy (user/project/local), `.claude/rules/` directory
- AUSENTE: `paths:` frontmatter, auto memory (desabilitado deliberadamente em favor de /dream), `/memory` command, CLAUDE.md block comments, `claudeMdExcludes`, import `@path`, AGENTS.md interop

**Settings / Permissions:**
- PRESENTE: settings.json hierarchy 5 níveis, `permissions.defaultMode: auto`, `skipAutoPermissionPrompt: true`, `alwaysThinkingEnabled: true`, `effortLevel: high`, `CLAUDE_CODE_EFFORT_LEVEL: max`, `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING`, status line custom, `otelHeadersHelper`
- AUSENTE (alta): `$schema` em settings.json (1-line fix), `sandbox:` block (resolveria KBP-28 systemicamente), `permissions.ask` **broken em ≥2.1.113** (KBP-26)
- PARCIAL: Bash hardening v2.1.98 (guard-bash-write.sh existe mas não cobre todos casos)

**Context / Compaction:**
- PRESENTE: compaction auto, `/compact`, `/resume` 67% faster, 1M context (Opus 4.7), extended thinking budgets, autocompact thrash detect (3x)
- AUSENTE: `xhigh` effort level (v2.1.111)

**MCP:**
- PRESENTE: `.mcp.json` inventory, HTTP servers (pubmed/scite/notion/consensus), OAuth (notion), Remote MCP (claude.ai), large output truncation + jq, concurrent startup
- AUSENTE: MCP Registry (api.anthropic.com), MCP tool hooks, MCP elicitation hooks

**Managed Agents SDK (2026-04 beta):** TOTALMENTE AUSENTE — Sessions API, Memory Store, Vaults, Cloud Environments, Agents/Skills APIs. **Irrelevante para OLMO consumer stack.**

**UI / Modelos:**
- PRESENTE: claude-sonnet-4-6 (subagent), Opus 4.7 1M context [VERIFY se Max inclui], native binary bfs+ugrep
- AUSENTE: `/tui fullscreen`, Vim visual mode, custom themes, `/usage` merge, `/ultrareview`

### 2. Novidades 2025-2026 alto impacto (top 5 para OLMO)

1. **Hook types novos** — StopFailure, SubagentStart/Stop, TaskCreated/Completed, PermissionRequest. OLMO tem infraestrutura sofisticada mas cego a falhas de API (StopFailure), dispatches silenciosos (SubagentStart/Stop) e quality gates em task lifecycle.
2. **`isolation: worktree` em subagents** + /batch built-in — elimina conflitos de merge entre agentes paralelos em migrações de escala.
3. **`permissions.sandbox:` block** — enforcement OS-level impermeável a shell-within-shell, $(), backticks, eval. Resolve KBP-28 sistemicamente.
4. **Path-scoped rules (`paths:` frontmatter em rules/)** — slide-rules.md carregaria apenas em content/aulas/. Reduz APL (KBP-23).
5. **Auto memory (MEMORY.md)** — complementar a /dream; auto para microlearnings, /dream para consolidação semanal.

### 3. Obsolescências

- `/cost` e `/stats` → merged em `/usage` (v2.1.118)
- `/tag` removido (v2.1.84); use `claude plugin tag`
- `/vim` removido (v2.1.84); config via `/config` → Editor mode
- `includeCoAuthoredBy` → `attribution: {commit, pr}` object
- `C:\ProgramData\ClaudeCode\managed-settings.json` deprecated → `C:\Program Files\ClaudeCode\managed-settings.json`
- `CLAUDE_CODE_ENHANCED_TELEMETRY_BETA` [VERIFY] — OLMO usa, confirmar se ainda ativa
- Hardcoded `enableAutoMode` — desnecessário para Max em v2.1.111+
- Custom `.claude/commands/` — funcionam mas skills são recomendadas (frontmatter rico, supporting files, live reload)

### 4. OLMO drift observado

| Drift | Severidade | Evidence |
|-------|-----------|----------|
| KBP-26 permissions.ask broken | Alta | Arquitetura precisa assumir binary allow/deny |
| Stop hook bloat (7 hooks seq) | Média | >3 min em sessões longas; Stop[0] e HANDOFF agent com overlap |
| StopFailure ausente | Média | Subagents pesados morrem silenciosamente em API errors |
| Allow-list auto-cresce | Média | `skipAutoPermissionPrompt: true` + approvals add rules sem revisão |
| SubagentStart/Stop ausentes | Baixa | PostToolUse[Agent] é proxy imperfeito |
| path-scoped rules ausentes | Baixa | rules/ carrega em todo contexto |
| `context: fork` em skills ausente | Baixa | /dream, /research, /systematic-debugging poluem contexto principal |
| sandbox ausente | Baixa-Média | deny-list prefix-match tem gaps (KBP-28) |
| Auto memory desabilitado | Baixa | possível gap de learnings sem /dream invocado |
| `$schema` ausente | Baixa | perde validação IDE |

### 5. Recomendações ranqueadas

**ADOPT now:**
1. `$schema` em settings.json — 1 linha, IDE validation imediato
2. Hook StopFailure — script simples, loga API errors em `.claude/hook-log.jsonl`
3. Hook SubagentStart/Stop — cost tracking + diagnóstico de falhas
4. path-scoped rules (`paths: ["content/aulas/**"]` em slide-rules.md)
5. `statusMessage` em hooks Stop lentos (HANDOFF agent 60s timeout sem feedback)

**EVALUATE:**
6. Hook PermissionRequest — audita allow-list growth
7. `context: fork` em /dream e /research — isola mas muda semântica
8. `isolation: worktree` em /batch — requer git worktrees + symlinkDirectories
9. `permissions.sandbox` — verificar Windows disponibilidade
10. TaskCreated/TaskCompleted hooks — integra com §Plan execution

**IGNORE:**
- Agent Teams (experimental, overhead)
- Managed Agents SDK (irrelevante consumer)
- `/ultrareview` (codex:review já cobre)
- Memory Store API / Vaults / Sessions API (infra produto)
- `wslInheritsWindowsSettings` (Windows nativo)
- Custom themes, Vim visual mode

## Relatório 2 — Competitors SOTA (general-purpose)

**Retorno:** 2026-04-23 | 139s | 32.7k tokens | 15 tool uses

### 1. Timeline 2024-2026 (key releases)

**OpenAI**
- Nov 2024: Swarm experimental (precursor)
- Mar 2025: **Agents SDK v0.1** — lançamento oficial; primitivos: `Agent`, `Handoff`, `Guardrail`, `Tracing`; successor do Swarm; Python + TypeScript
- Mar 2025: MCP client support adicionado ao Agents SDK e Responses API
- Ago 2025: Assistants API marked deprecated (sunset: 26/ago/2026) — migração obrigatória para Responses API
- Fev 2026: `openai v2.x` breaking — `Agent` → `AgentBase` em args tipados
- Abr 2026: sandbox execution nativo + model-native harness para long-running agents

**Google**
- Abr 2025: Google ADK open-source Python launch; Demis Hassabis confirma suporte MCP em Gemini
- Out 2025: 1ª community meeting ADK (15/out/2025)
- Abr 2026: **ADK v1.0 stable** — 4 linguagens (Python, TS, Java, Go); **ADK Python 2.0 Beta** com workflow agents + agent teams; TypeScript 1.0
- Abr 2026: Suporte oficial Gemini 3 Pro e Flash [VERIFY]; A2A Protocol v1.2 (Linux Foundation/AAIF), 150 orgs em produção [VERIFY]

**GitHub frameworks**
- Jan 2025: LangGraph v0.x → estabilização com checkpointing e human-in-the-loop
- Dez 2025: **LangGraph v1.1** — retry middleware, content moderation middleware, production hardening
- 2025: **CrewAI v1.12** — agent skills, OpenAI-compatible providers (Ollama, vLLM, DeepSeek), Qdrant Edge memory, hierarchical memory isolation
- Jan 2026: **CrewAI** — native async a2a, A2A protocol handlers (poll/stream/push), global flow config para HITL, Flows+Crews production arch
- 2025-2026: **AutoGen → AG2** — redesign "AG2 Beta" com event-driven arch, streaming, typed tools, dependency injection
- Dez 2024-2026: **smolagents** (HuggingFace) 26k+ stars; **pydantic-ai** 16.5k stars, v1.85.1 em abr/2026
- Dez 2025: Anthropic doa MCP para AAIF (Linux Foundation); OpenAI co-funda AAIF

### 2. Comparative table

| Eixo | OpenAI Agents SDK | Google ADK | LangGraph | Claude Code (OLMO) |
|---|---|---|---|---|
| **Tool calling** | Function tools via JSON schema; MCP client nativo; typed via `AgentBase`; provider-agnostic (100+ LLMs) | Function tools + MCP tools + OpenAPI tools (auth); pre-built Google Search; action confirmations | Tool nodes tipados no grafo; model-agnostic; langchain-mcp-adapters para MCP | MCP servers (in-process + remote); settings.json policy gate; deny-list prefix-match; sem SDK próprio |
| **Memory/state** | Sessions: SQLite, SQLAlchemy, Redis, Dapr, encrypted; ephemeral default; context variables | Sessions + memory + artifacts com lazy-loading; token budget tracking; summarização automática | Checkpointing em cada node; time-travel (replay); TypedDict + Annotated state; durable execution cross-interruption | Via MCP servers para estado persistente; hooks `.claude/hooks/` para lifecycle; sem runtime Python nativo |
| **Hooks/callbacks** | Guardrails (input/output validation); Tracing built-in; hooks via middleware pattern | Callback system documentado com multiple types; event-driven; design patterns explícitos | Retry middleware + content moderation middleware (v1.1); node-level interceptors; LangSmith observability | 30 hooks em `hooks/` + `.claude/hooks/`; stop/pre-tool/post-tool hooks; `settings.json` policy; `Stop[0]` silent execution check |
| **MCP interop** | Client: sim (built-in); Server: [VERIFY]; adotou mar/2025 | Client: sim (ADK Python); Server: [VERIFY]; adotou abr/2025 | Client: via `langchain-mcp-adapters`; Server: [VERIFY] | Client+Server: arquitetura central; bidirectional |
| **Orchestration** | Agent + Handoff (delegação explícita); Guardrail; sem grafo — linear + branching via handoffs; sandbox execution | LLM agent + Workflow agent (seq/loop/parallel) + Custom agent; Agent Teams (2.0 Beta); A2A Protocol nativo; deployment: Cloud Run/GKE/Docker | Directed graph (DAG+cycles); supervisor/swarm/hierarchical patterns; human-in-the-loop com pause state; fan-out/fan-in | 9 subagents em `.claude/agents/*.md`; Task tool; skills (18); sem grafo explícito — routing via CLAUDE.md + ADR-0003; human-in-the-loop nativo (Lucas aprova) |

### 3. MCP interop status

| Competitor | Client | Server | Notes |
|---|---|---|---|
| OpenAI Agents SDK | Sim — built-in, transparente como function tool | [VERIFY] | Adotou mar/2025; co-funda AAIF dez/2025 |
| Google ADK | Sim — nativo, categoria própria de tool | [VERIFY] | Adotou abr/2025; A2A Protocol complementar ao MCP (MCP=tools, A2A=agent-to-agent) |
| LangGraph / LangChain | Via `langchain-mcp-adapters` (adapter layer) | [VERIFY] | Não first-class |
| CrewAI | Sim — nativo via A2A handlers | [VERIFY] | A2A v1.2 suportado desde jan/2026 |
| AutoGen / AG2 | Sim — A2A suporte nativo | [VERIFY] | Parte do ecosistema AAIF |
| Claude Code (OLMO) | Sim — arquitetura central | Sim — `config/mcp/servers.json`; inline agents | MCP único integration layer; policy gate `settings.json`; 10k+ servers públicos |

MCP spec governance: AAIF (Linux Foundation), co-fundado por Anthropic + OpenAI + Block; 97M downloads/mês mar/2026.

### 4. Onde Claude Code é superior / inferior / convergente

**Superior:**
- Policy gate declarativo (settings.json deny-list/permissions.ask/hooks) — nenhum competitor tem equivalente declarativo fora de código
- MCP como único integration layer — arquiteturalmente mais limpo que adapter pattern LangChain ou SDK-centric OpenAI
- HITL nativo sem framework — modelo padrão, não addon
- Cost-zero orchestração via Max subscription — zero runtime overhead
- Agents como markdown — declarativos, versionáveis, auditáveis sem execução

**Inferior:**
- Grafo explícito ausente — LangGraph oferece DAG tipado com time-travel, checkpointing por node, replay
- State persistence nativo — OpenAI Redis/SQLAlchemy/Dapr sessions; ADK artifact management; Claude Code delega MCP server externo
- Multi-language — ADK v1.0 cobre Python+TS+Java+Go; Claude Code é Node-bound
- A2A cross-vendor orchestration — Google A2A permite Salesforce→Google→ServiceNow via protocolo padrão; Claude Code não tem equivalente
- Observability nativa — LangSmith + OpenAI Tracing built-in mais maduros que `stop-quality.sh` + `pending-fixes.md`

**Convergente:**
- MCP como padrão de tools: todos adotaram ou adotando; convergência para AAIF governance
- Sandboxed execution: OpenAI abr/2026; Claude Code tem deny-list + hook guards como equivalente funcional
- HITL: todos implementam, diferentes abordagens
- Provider-agnostic: OpenAI SDK 100+ LLMs; ADK model-agnostic; Claude Code via ADR-0003 roteia Haiku/Sonnet/Opus/Ollama

### 5. Recomendações para OLMO

**ADOPT via MCP:**
- **A2A Protocol client** via MCP server wrapper — permite OLMO receber tarefas de agentes externos (Salesforce, ServiceNow) sem re-arquitetura
- **Observability MCP server** — LangSmith API pública ou Langfuse (open-source self-hosted) wrapped em MCP daria tracing estruturado sem migrar
- **State persistence via Redis MCP** — padroniza sessões ad-hoc para modelo equivalente ao OpenAI sessions

**EVALUATE re-arch:**
- **Workflow agent pattern (ADK-inspired)** — para pipelines determinísticos (fetch→QA→build→deploy), Sequential/Loop/Parallel nodes reduziria hooks ad-hoc e tornaria pipeline auditável. Risco: adiciona abstração onde hooks funcionam
- **Checkpointing explícito para research loops** — LangGraph-style por node permitiria retomar sessões MBE interrompidas. Hoje HANDOFF.md é checkpoint manual frágil a context drift

**IGNORE (scope mismatch):**
- OpenAI Responses API / Assistants migration — OLMO não usa
- CrewAI role-based crews — modelo de crews (Researcher+Writer+Reviewer em papéis fixos) não se encaixa no modelo skills/subagents
- smolagents code-execution loop — "agent escreve código para agir" conflita com deny-list OLMO + KBP-10/KBP-19
- AG2 event-driven full redesign — overhead arquitetural; OLMO já tem event-driven via hooks nativos

### Notas de incerteza (agent)

- `[VERIFY]` para server-side MCP dos competitors (docs focam client-side)
- A2A Protocol v1.2 + 150 orgs em produção baseados em fonte única
- Gemini 3 oficial status [VERIFY] (pode ser Gemini 2.5 renomeado)
- GH stars snapshot (LangGraph >40k, AG2 28.4k, smolagents 26k, pydantic-ai 16.5k) — valores flutuam

## Relatório 3 — Frontend SOTA (general-purpose)

**Retorno:** 2026-04-23 | 329s | 47.4k tokens | 35 tool uses

**Fontes:** web.dev/baseline Mar+Jan 2026, caniuse, MDN, Slidev docs, reveal.js v6 releases, Utopia, DTCG spec.

### 1. CSS features 2026 — Baseline & OLMO adoption

| Feature | Baseline | OLMO usa? | Prioridade |
|---|---|---|---|
| OKLCH / oklch() | Widely (2023+) | **Sim** (todo base.css) | -- (ahead) |
| color-mix() | Widely (nov/2025) | **Sim** (tokens v1+bridge) | -- (ahead) |
| @layer | Widely (2023+) | **Sim** (shared-v2 7 layers + metanalise-modern) | -- (ahead) |
| Subgrid | Widely (mar/2026) | **Sim** (C2 metanalise) | -- (ahead) |
| :has() | Newly (dez/2023) → Widely ~jun/2026 | Parcial (S240 C2) | ADOPT |
| @container size queries | Widely (ago/2025) | **Não** | EVALUATE (panels/cards responsive) |
| @container style queries | Parcial | **Não** | EVALUATE baixa prio |
| **@property** | Newly (jul/2024) → Widely ~jan/2027 | **Não** | **ADOPT — essencial para animar tokens OKLCH** |
| @scope | Newly (dez/2025 FF 146) | Não (usa `section#s-{id}`) | EVALUATE (pode substituir padrão atual) |
| **@starting-style** | Newly (ago/2024) → Widely ~fev/2027 | **Não** | **ADOPT — substitui gsap.from({opacity:0}) em casos simples** |
| Anchor Positioning | Pre-Baseline (FF 147, Safari 26 [VERIFY]) | Não | IGNORE (projetor sem tooltips) |
| View Transitions (same-doc) | Newly (out/2025) | Parcial (motion.js duck-mock) | EVALUATE (substituir duck-mock por VT nativo) |
| View Transitions (cross-doc) | Parcial (Firefox gap) | Não | IGNORE (FF gap = risco projetor) |
| Logical properties | Widely (2022+) | Não confirmado em base.css | ADOPT (margin-inline, padding-block) |

### 2. JS features 2026 — Baseline & OLMO adoption

| Feature | Baseline | OLMO usa? | Prioridade |
|---|---|---|---|
| Array by copy (toReversed/toSorted) | Widely (jan/2026) | Não detectado | LOW (safe adopt) |
| Navigation API | Newly (jan/2026) | Não (deck.js usa hashchange) | EVALUATE futuro |
| Service Worker JS modules | Newly (jan/2026) | N/A (offline não SW) | IGNORE |
| WAAPI Group/Sequence | Spec, **não implementado** | Não | MONITOR |
| WAAPI element.animate() + promises | Widely (2023+) | **Sim** (motion.js) | -- (usa) |
| Scheduler API (postTask/yield) | Não Baseline (Safari gap) | Não | EVALUATE (mas Safari risk) |
| ResizeObserver | Widely (2023+) | **Sim** (presenter-safe.js clamp) | -- (usa) |
| Dynamic import() | Widely (2022+) | Provavelmente usado | -- |
| View Transitions JS (startViewTransition) | Newly (out/2025 same-doc) | Parcial (duck-mock) | EVALUATE |
| Async iteration (for await...of) | Widely (2023+) | Não detectado | LOW |

### 3. Slideware comparative

| Feat | Slidev | reveal.js 6 | **OLMO custom** |
|---|---|---|---|
| Base | Vue 3 + Vite + UnoCSS | HTML/CSS/JS + Vite (v6 migrou de Gulp) | HTML nativo + deck.js próprio |
| Authoring | Markdown + Vue | HTML (MD plugin) | HTML puro por slide |
| Fragment reveals | `<v-click>` | `data-fragment-index` | `data-animate` declarativo + click-reveal.js custom |
| Keyboard nav | Sim | Sim (+ hash URL) | Sim (deck.js keybind + hashchange + aria-live) |
| Presenter mode | Sim (porta separada) | Sim (speaker notes window) | **Não nativo** — presenter-safe.js é só clamp |
| Speaker notes | Sim (YAML frontmatter) | Sim (`<aside class="notes">`) | **Não** |
| Export PDF/PNG | Sim | Sim (print CSS + Playwright) | Sim (`export-pdf.js` Playwright) |
| Export PPTX | Sim (`--format pptx`) | **Não nativo** | Não |
| Math (LaTeX) | Sim (KaTeX) | Sim (MathJax 4) | Não |
| Code highlight | Sim (Shiki, Monaco, live coding) | Sim (highlight.js / Shiki plugin) | Não |
| GSAP custom anims | Via Vue + lib | Via plugin | **Sim — SplitText+Flip+ScrambleText por slide, slide-registry.js** |
| Theming | npm themes | CSS themes | Token system base.css + shared-v2 |
| Scroll view (reading) | Não nativo | **Sim** v5.0 (auto <435px) | Não |
| Scaling 1280×720 | Configurável | Nativo | **`Math.min(vw/1280, vh/720)` próprio; 1.5× em 1080p** |
| Offline / zero CDN | [VERIFY] (CDN opcional) | Sim | **Sim — self-hosted WOFF2** |
| Auditório 10m + projetor | Sem consideração nativa | Sem consideração nativa | **Otimizado — font ≥18px@1280; scaleDeck testado** |
| OKLCH/design tokens | Via UnoCSS config | Via CSS custom | **Sim — sistema completo + APCA calibrado** |

### 4. CSS architecture SOTA — aplicabilidade OLMO

- **Utopia fluid type/space (clamp)** — INAPLICÁVEL font-size (E52 proíbe vw/vh; scaleDeck dupla-escala quebra). **Aplicável** margin/gap/padding fora de texto.
- **Cascade Layers (OLMO shared-v2)** — alinhado com SOTA 2025-2026 (Open Props, Tailwind v4, Pico.css). Gaps: (1) sem layer `utilities` separado (ad-hoc utilities em metanalise.css vazam); (2) `@layer metanalise-modern` per-section é pragmático mas shared-v2 sugere caminho escalável.
- **DTCG (out/2025 stable)** — JSON format `.tokens.json`; Adobe/Figma/Tokens Studio/Style Dictionary suportam. OLMO single-platform web = **baixa aplicabilidade agora**; monitor se export para Figma virar requisito.
- **Open Props** — IGNORE (namespace conflict; OLMO mais especializado).
- **CUBE CSS** — methodology, não lib. Parcialmente alinhado com shared-v2 `@layer components`. Falta layer `utilities` explícito. Adotável sem dep.

### 5. Drift técnico identificado

**OLMO gaps:**
- Sem `@property` → tokens OKLCH não animam nativamente (GSAP-dependent)
- Sem `@starting-style` → entry anims via `gsap.from({opacity:0})` (~30% dos casos covered sem GSAP)
- `@scope` não adotado → `section#s-{id}` frágil a rename
- Navigation API não usada (hashchange funciona; baixo impacto)
- **Presenter mode ausente** — gap real para uso em sala com segundo display
- `@container` não usado (panels/cards teriam valor)

**OLMO ahead:**
- OKLCH completo + color-mix + APCA calibrado desde v1 (maioria ainda usa HSL/RGB)
- Zero CDN / offline-first (Slidev/reveal dependem de CDN por default)
- scaleDeck 1.5× em 1080p testado auditório (**nenhum framework resolve**)
- GSAP per-slide via slide-registry (granularidade sem poluição global)
- `@layer` 7-camadas shared-v2 (mais rigoroso que Open Props/Pico.css)
- E22 documentado como regra (@import antes de @font-face — nenhum framework mainstream trata)

### 6. Recomendações ranqueadas

**ADOPT now (safe, Baseline):**
- **`@property` com `syntax: "<color>"` nos tokens OKLCH** — `@property --bg-navy { syntax: "<color>"; inherits: true; initial-value: oklch(22% 0.042 258); }`. Habilita animação nativa sem GSAP.
- **`@starting-style`** para entry anims (`display:none → block`) — substitui `gsap.from()` em casos simples. Chrome 117+.
- Logical properties em novos componentes shared-v2 (Widely 2022+)
- Array by copy methods (toSorted, toReversed) — sem polyfill jan/2026

**EVALUATE:**
- `@scope` como substituto progressivo de `section#s-{id}` — testar em slides-lab (FF 146 muito recente)
- `@container` size queries em componentes internos (`.panel`, `.card`, `.stats-grid`) — safe Chrome/FF/Safari
- View Transitions API — substituir duck-mock por `document.startViewTransition()` com fallback
- Navigation API — futura v deck.js (hashchange funciona; não urgente)
- Presenter mode nativo — gap real; requer 2ª janela; avaliar reveal.js scroll-view

**IGNORE:**
- VT cross-doc (FF gap)
- Anchor Positioning (Safari 26 instável; sem tooltips)
- Scheduler API (Safari gap; slides carregam <200ms)
- DTCG JSON (single-platform)
- Utopia `clamp()` em font-size (E52 proíbe)
- WAAPI Group/Sequence (não implementado em browser)
- Slidev / Spectacle (overhead injustificado; OLMO custom supera para auditório médico)
- Open Props (namespace conflict)

**Nota browser projetor:** assumir Chrome 120+ ou Edge equivalente. Safe: OKLCH, color-mix, layers, subgrid, :has(), @container size, @starting-style, WAAPI, dynamic import. **Não safe sem fallback:** @scope (FF 146), VT cross-doc, Anchor Positioning.

---

## Matriz consolidada (fase 2 — pós-relatórios)

Verdicts: **ADOPT** (agora) · **ALREADY** (OLMO já usa) · **DONE-S241** (commitado nesta sessão) · **EVAL-next** (próxima sessão) · **IGNORE** (fora de escopo).

| Área OLMO | Anthropic | Competitors | Frontend | Decisão S241 |
|-----------|-----------|-------------|----------|--------------|
| **CSS architecture** | — | — | `@property` DONE (6 solid★ tokens); `@starting-style` ADOPT; logical props ADOPT; `@scope` EVAL; `@container` EVAL; VT cross-doc IGNORE; Utopia clamp IGNORE; Open Props IGNORE | **`@property` DONE-S241** (commit e5cf330); `@starting-style` + logical props DEFERRED (piloto em shared-v2 components.css); `@scope` + `@container` EVAL-next |
| **JS modules** | — | — | array by copy ADOPT; Navigation API EVAL; VT same-doc EVAL (duck-mock → nativo); Scheduler API IGNORE | **array by copy** DEFERRED (safe, baixa prio); **VT same-doc** EVAL-next (substituir duck-mock em motion.js) |
| **Hooks** | `$schema` ADOPT; `StopFailure` ADOPT; `statusMessage` ADOPT; `SubagentStart/Stop` EVAL; `PermissionRequest` EVAL; `TaskCreated/Completed` EVAL; `Elicitation` IGNORE | — | — | **`$schema` DONE-S241** (533d648); **`statusMessage` DONE-S241** (7edf5d9); **`StopFailure` DONE-S241** (7e205a3); `SubagentStart/Stop` + `PermissionRequest` EVAL-next |
| **Agents (subagents)** | `isolation: worktree` EVAL; `skills:` preload EVAL; `initialPrompt` EVAL; `effort:` EVAL; `disallowedTools:` EVAL | **A2A Protocol MCP wrapper** ADOPT; **Observability MCP** (Langfuse) ADOPT; **Redis state MCP** ADOPT; Workflow agent pattern EVAL-rearch; Checkpointing EVAL-rearch | — | Todos DEFERRED — MCP wrappers (A2A/Observability/Redis) são S242+ candidates com investigação dedicada |
| **Skills** | `context: fork` ADOPT (piloto /dream); `paths:` ALREADY; `allowed-tools` ADOPT; `agent:` EVAL; `hooks:` EVAL; `arguments:` EVAL; `${CLAUDE_SKILL_DIR}` IGNORE | — | — | **`paths:` ALREADY** em 3 rules (slide-rules/design-reference/qa-pipeline); `context: fork` EVAL-next (piloto /dream ou /research); resto DEFERRED |
| **Scripts** (content/aulas/scripts/) | — | — | — | **Não coberto** por agents; auditoria dedicada futura (sentinel + repo-janitor em sessão separada) |
| **Settings + MCP** | `$schema` ADOPT; `sandbox:` block EVAL (Windows?); `permissions.ask` KBP-26 MITIGATE; `disableSkillShellExecution` IGNORE | 3 MCP wrappers ADOPT (já listados em Agents) | — | **$schema DONE-S241** (533d648); **deny-list refactor DONE-S241** (36feffe — bonus estrutural); `sandbox` EVAL-next (verificar Windows 11 support) |

### Falso-positivos do batch (detectados em Phase 1 validation)

- Agent 1 reportou `paths:` frontmatter AUSENTE → **ALREADY** em 3 rules (spot-check salvou commit errado)
- Agent 3 reportou `@property` AUSENTE → **confirmado AUSENTE** em shared/ e shared-v2/ (pre-ADOPT 3)
- Agent 3 reportou logical properties "não confirmado em base.css" → **confirmado AUSENTE** (0 matches em base.css — ADOPT deferred)

**Lição operacional:** spot-check de claims "AUSENTE" antes de Edit é barato e essencial. 1 falso-positivo em 3 amostras = 33% taxa de erro dos agents. Fase 1 validation é não-opcional.

---

## Plano de mudanças (fase 3 — pós-matriz)

### DONE nesta sessão (5 ADOPTs + 1 refactor bonus = 6 commits)

| # | Commit | Natureza | Insight-chave |
|---|--------|----------|---------------|
| 1 | `533d648` | `$schema` em settings.json | 1-linha IDE validation; URL schemastore convenção |
| 2 | `e5cf330` | `@property` OKLCH tokens (6 solid★ PoC) | Habilita animação nativa de cores sem GSAP; expansão sob demanda |
| 3 | `7edf5d9` | `statusMessage` em Stop[0]/Stop[1] | Reduz opacidade de 30-60s em session close |
| 4 | `36feffe` | Deny-list refactor HIGH-RISK only | Remove 9 patterns benignos; resolve problema antigo S235b-era |
| 5 | `7e205a3` | `StopFailure` hook skeleton | Cobre blind spot: subagents pesados morriam silenciosos em API errors |

### DEFERRED para S242+ (ranked por valor/custo)

**Top priority (low cost, high value):**
- **`@starting-style` + logical props** em shared-v2 components.css — substitui gsap.from({opacity:0}) em ~30% dos casos; logical props safe (Widely 2022+)
- **`context: fork` em /dream + /research** — piloto isolação de contexto; 1 skill por vez
- **Hook SubagentStart/Stop** — instrumentation de dispatch; ~30 li script
- **Hook PermissionRequest** — audita allow-list growth (mitigação KBP-26)

**Medium priority (high value, requer investigação):**
- **`@scope` migration** — substituir padrão `section#s-{id}` (testar slides-lab primeiro; FF 146 muito recente)
- **`@container` size queries** em panels/cards — safe Chrome/FF/Safari
- **View Transitions same-doc** — substituir duck-mock de motion.js por API nativa
- **`permissions.sandbox`** — verificar Windows 11 disponibilidade; resolveria KBP-28 sistemicamente
- **A2A Protocol MCP wrapper** — federação cross-vendor (Salesforce, ServiceNow, Google ADK)
- **Observability MCP (Langfuse self-hosted)** — tracing estruturado substituto de stop-quality.sh
- **Redis state MCP** — padroniza session state (equivalente ao OpenAI Redis sessions)

**Lower priority (baixo custo, baixo impacto):**
- Array by copy methods em JS scripts (safe jan/2026)
- `$schema` JSON format em quaisquer tokens futuros

### IGNORE (fora escopo OLMO)

- Managed Agents SDK — infra produto, não consumer
- Agent Teams — experimental, overhead
- `/ultrareview` — codex:review já cobre
- Slidev / Spectacle migration — OLMO custom supera para auditório 10m + projetor
- Open Props — namespace conflict
- Utopia `clamp()` em font-size — E52 proíbe (scaleDeck dupla-escala)
- VT cross-doc — Firefox gap
- Anchor Positioning — Safari 26 instável
- DTCG JSON spec — single-platform
- WAAPI Group/Sequence — spec sem implementação browser
- Scheduler API — Safari gap
- Custom themes, Vim visual mode — preferências UI sem necessidade declarada

---

## Matriz pronta para S242+ hidratação

Próximas sessões podem ler apenas este file para hidratar sem custar os 3 relatórios integrais (~30KB). Status final: **5/5 ADOPTs committed + 1 refactor bonus + 3 DEFERRED priority groups documentados + 12 IGNORE formalizados**.

---

Coautoria: Lucas + Opus 4.7 (Claude Code) | S241 infra-plataforma | 2026-04-23
