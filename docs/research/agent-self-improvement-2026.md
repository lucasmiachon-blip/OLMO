# Agent Self-Improvement Tools for Production Claude Code Ecosystems

> Pesquisa: Lucas + Opus 4.6 | S84 | 2026-04-06
> Contexto: OLMO monorepo — 8 agentes, 11 hooks, 15 memory files, anti-drift rules
> Fontes consultadas: 60+ (web search, GitHub repos, papers, blog posts)

---

## Table of Contents

1. [OpenTelemetry for Claude Code](#1-opentelemetry-for-claude-code)
2. [Memory Systems Beyond CLAUDE.md](#2-memory-systems-beyond-claudemd)
3. [Self-Healing and Anti-Fragile Patterns](#3-self-healing-and-anti-fragile-patterns)
4. [Contract Enforcement / Cross-Ref Tools](#4-contract-enforcement--cross-ref-tools)
5. [Claude Code Ecosystem Tools](#5-claude-code-ecosystem-tools)
6. [Agent Frameworks (Reference)](#6-agent-frameworks-reference)
7. [Practical Recommendations for OLMO](#7-practical-recommendations-for-olmo)

---

## 1. OpenTelemetry for Claude Code

### 1.1 Claude Code Native OTel Support

Claude Code has **built-in OpenTelemetry support** — no wrappers or sidecars needed. It exports
metrics via the standard OTLP protocol, events via logs/events, and optionally traces.

**Key environment variables:**

| Variable | Purpose | Example |
|----------|---------|---------|
| `CLAUDE_CODE_ENABLE_TELEMETRY` | Master switch | `1` |
| `OTEL_METRICS_EXPORTER` | Metrics backend | `otlp`, `prometheus`, `console`, `none` |
| `OTEL_LOGS_EXPORTER` | Logs/events backend | `otlp`, `console`, `none` |
| `OTEL_EXPORTER_OTLP_PROTOCOL` | Wire protocol | `grpc` |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | Collector address | `http://localhost:4317` |
| `OTEL_METRIC_EXPORT_INTERVAL` | Flush interval (ms) | `10000` (default: 60000) |
| `OTEL_EXPORTER_OTLP_HEADERS` | Auth header | `Authorization=Bearer token` |
| `OTEL_LOG_USER_PROMPTS` | Log prompt content | `1` (disabled by default) |

**Metrics emitted:**

- `claude_code.cost.usage` — COUNTER, cost in USD per session
- Token usage by type: input, output, cache creation, cache read
- Session attributes: `session.id`, model, user
- Lines of code changed

**Relevance to OLMO**: Direct solution for the "no observability" problem. Can track cost per
session, per agent invocation, and per model tier. Zero cost — just env vars + collector.

Sources:
- [Claude Code Monitoring Docs](https://code.claude.com/docs/en/monitoring-usage)
- [SigNoz OTel Guide](https://signoz.io/blog/claude-code-monitoring-with-opentelemetry/)
- [Bindplane Per-Session Tracking](https://bindplane.com/blog/claude-code-opentelemetry-per-session-cost-and-token-tracking)

### 1.2 Langfuse

| Field | Value |
|-------|-------|
| What | Open-source LLM engineering platform: tracing, evals, prompt management, datasets |
| Stars | ~19k+ GitHub |
| License | MIT (core), commercial (enterprise modules: SCIM, audit logging) |
| Cost | Self-hosted: $0. Cloud free tier: 50k events/month, 2 users. Paid: $29/m (100k events) |
| Setup | Docker Compose (5 min) or Helm (production) |

**Key features:**
- Full trace visualization for multi-step agent workflows
- OpenTelemetry-native SDK v3 (thin wrapper on official OTel client)
- Token usage tracking, cost aggregation, cache efficiency
- LLM-as-a-judge evaluations, user feedback, manual labeling
- Prompt versioning and management with caching

**Relevance to OLMO**: Best open-source option for LLM-specific observability. Self-hosted = $0.
The OTel-native SDK means it integrates directly with Claude Code's native telemetry. Prompt
management could replace manual CLAUDE.md versioning for agent system prompts.

Sources:
- [Langfuse GitHub](https://github.com/langfuse/langfuse)
- [Langfuse Docs](https://langfuse.com/docs)
- [Langfuse OTel Integration](https://langfuse.com/integrations/native/opentelemetry)

### 1.3 Arize Phoenix

| Field | Value |
|-------|-------|
| What | AI observability platform built on OpenTelemetry + OpenInference |
| Stars | ~8.6k GitHub |
| License | Elastic License 2.0 (source-available, no managed service resale) |
| Cost | Self-hosted: $0, no feature gates. Cloud: free tier available |
| Setup | `pip install arize-phoenix` or Docker |

**Key features:**
- OpenTelemetry-native (agnostic to vendor, framework, language)
- Built-in hallucination detection and embedding drift visualization
- Support for Claude Agent SDK, LangGraph, OpenAI Agents SDK, and more
- Complete visibility into tool executions, retrieval ops, agent reasoning loops
- Experiment tracking and dataset management

**Relevance to OLMO**: Strong alternative to Langfuse. Better for embedding analysis and RAG
debugging (relevant if OLMO adds evidence retrieval pipelines). ELv2 license is fine for
internal use but blocks offering as a service.

Sources:
- [Arize Phoenix GitHub](https://github.com/Arize-ai/phoenix)
- [Phoenix Docs](https://arize.com/docs/phoenix)
- [OpenInference](https://github.com/Arize-ai/openinference)

### 1.4 Local Collector Setup

A minimal local OTel stack for OLMO would be:

```
Claude Code (OTLP exporter)
    → OTel Collector (otel/opentelemetry-collector-contrib)
        → Prometheus (metrics)
        → Jaeger or Tempo (traces)
        → Grafana (dashboards)
```

All via Docker Compose. Reference implementation: **claude-code-otel** by ColeMurray
([GitHub](https://github.com/ColeMurray/claude-code-otel)) — MIT license, pre-built Grafana
dashboards for sessions, costs, tokens, LOC changed.

Also notable: **claude_telemetry** by TechNickAI — drop-in `claudia` command that wraps `claude`
with OTel export to Logfire, Sentry, Honeycomb, or Datadog.

Sources:
- [OTel Collector Docker Setup](https://opentelemetry.io/docs/collector/install/docker/)
- [claude-code-otel](https://github.com/ColeMurray/claude-code-otel)
- [claude_telemetry](https://github.com/TechNickAI/claude_telemetry)

---

## 2. Memory Systems Beyond CLAUDE.md

### 2.1 Mem0

| Field | Value |
|-------|-------|
| What | Universal memory layer for AI agents — extract, store, retrieve memories |
| Stars | ~48k GitHub |
| License | Apache 2.0 |
| Cost | Self-hosted: $0. Cloud: free (10k memories), $19/m (50k), $249/m (unlimited + graph) |
| Integration | One-line API: `m.add(text, user_id=...)`, works with OpenAI, LangGraph, CrewAI |

**Key features:**
- Automatic memory extraction from conversations
- Semantic search over memories using vector embeddings
- Project-level config: inclusion/exclusion prompts, memory depth, use-case tuning (v1.0.3)
- Timestamp backfilling for imported/migrated data (v1.0.4)

**Limitations:**
- **No native temporal model** — memories timestamped at creation only
- No concept of fact validity windows or temporal supersession
- Graph features (entity relationships, multi-hop) gated behind $249/m tier

**Relevance to OLMO**: Could replace the manual MEMORY.md system. The "add memory with one
line" pattern is attractive. But OLMO already has a working `/dream` consolidation skill.
The lack of temporal invalidation means stale facts persist — a known OLMO pain point.

Sources:
- [Mem0 GitHub](https://github.com/mem0ai/mem0)
- [Mem0 Research Paper (arXiv)](https://arxiv.org/abs/2504.19413)
- [State of AI Agent Memory 2026](https://mem0.ai/blog/state-of-ai-agent-memory-2026)

### 2.2 Graphiti / Zep

| Field | Value |
|-------|-------|
| What | Temporal knowledge graph engine for agent memory |
| Stars | Graphiti: ~24.4k GitHub |
| License | Apache 2.0 (Graphiti OSS), commercial (Zep Cloud) |
| Cost | Graphiti self-hosted: $0. Zep Cloud: $25/m Flex tier, usage-based above |
| Requires | Neo4j (graph DB) |

**Key features:**
- **Bi-temporal model**: tracks event time (when fact occurred) and ingestion time (when
  recorded). Every edge carries `valid_from`, `valid_to`, `invalid_at` markers
- Temporal supersession: old facts invalidated when new conflicting facts arrive
- Dynamic synthesis of unstructured conversation + structured business data
- DMR benchmark: 94.8% accuracy (vs 93.4% for MemGPT)
- LongMemEval: 18.5% enhanced accuracy, 90% latency reduction for multi-hop queries

**Relevance to OLMO**: The bi-temporal model directly solves the "stale facts" problem.
If Lucas changes a convention (e.g., "narrative.md replaces aside.notes"), the old fact gets
temporal invalidation instead of persisting forever in flat MEMORY.md files. Requires Neo4j,
which adds infra complexity. Best long-term option.

Sources:
- [Graphiti GitHub](https://github.com/getzep/graphiti)
- [Zep Paper (arXiv)](https://arxiv.org/abs/2501.13956)
- [Mem0 vs Zep Comparison](https://vectorize.io/articles/mem0-vs-zep)

### 2.3 Letta (formerly MemGPT)

| Field | Value |
|-------|-------|
| What | Platform for building stateful agents with OS-inspired tiered memory |
| Stars | ~21.6k GitHub |
| License | MIT |
| Cost | Self-hosted: $0. Cloud: free tier + paid tiers |
| Integration | REST API, Python SDK, model-agnostic |

**Key features:**
- **Three-tier memory**: Core (RAM, always in-context), Archival (vector store, explicit
  retrieval), Recall (conversation history, searchable)
- Agents **edit their own memory** using tool calls
- State persisted in databases, not Python variables
- Letta Code (March 2026): memory-first coding agent with background memory subagents
- Agent Development Environment (ADE): visual debugging for memory state inspection

**Relevance to OLMO**: The tiered memory model maps well to OLMO's current structure
(CLAUDE.md = Core, MEMORY.md files = Archival, conversation = Recall). Self-editing memory
is interesting but risky without guardrails (an agent could corrupt its own memory). MIT
license and model-agnostic design are positives.

Sources:
- [Letta GitHub](https://github.com/letta-ai/letta)
- [Letta Docs](https://letta.com/)
- [Letta vs Mem0 Comparison](https://vectorize.io/articles/mem0-vs-letta)

### 2.4 Claude-Mem

| Field | Value |
|-------|-------|
| What | Claude Code plugin for automatic session capture + context injection |
| Stars | ~4.1k GitHub |
| License | AGPL-3.0 |
| Cost | $0 (self-hosted) |
| Integration | MCP server + Claude Code hooks |

**Key features:**
- Automatically captures tool usage observations during sessions
- Generates semantic summaries via AI compression (using Claude agent-sdk)
- ChromaDB vector storage for semantic search across past sessions
- Loads relevant context at session startup
- MCP integration for querying past sessions

**Relevance to OLMO**: Directly addresses the "lost thread after compaction" problem. Could
complement `/dream` by capturing real-time observations vs `/dream`'s batch consolidation.
AGPL license means derivative works must also be AGPL — important if OLMO code is shared.

Sources:
- [claude-mem GitHub](https://github.com/thedotmack/claude-mem)
- [Claude-Mem Documentation](https://claude-mem.ai/)

### 2.5 xMemory

| Field | Value |
|-------|-------|
| What | 4-level semantic hierarchy for agent memory (messages → episodes → semantics → themes) |
| Stars | Research project (limited GitHub presence) |
| License | Research (King's College London + Alan Turing Institute) |
| Cost | N/A (research framework) |
| Paper | [arXiv 2602.02007](https://arxiv.org/html/2602.02007) |

**Key features:**
- **Four-level hierarchy**: raw messages → episodes (contiguous block summaries) →
  semantics (reusable facts) → themes (high-level groupings)
- Top-down search: theme → semantics → raw snippets
- Adaptive optimization: prevents categories from becoming too bloated or fragmented
- Token efficiency: drops usage from 9,000+ to ~4,700 tokens per query on some tasks

**Relevance to OLMO**: The hierarchical model is intellectually interesting and maps to how
medical knowledge is organized (symptoms → syndromes → diseases → systems). The token
reduction is significant for cost-conscious operation. However, this is a research framework
— not production-ready tooling. Best as design inspiration for OLMO's memory architecture.

Sources:
- [xMemory Paper](https://arxiv.org/html/2602.02007)
- [VentureBeat Coverage](https://venturebeat.com/orchestration/how-xmemory-cuts-token-costs-and-context-bloat-in-ai-agents)
- [xMemory GitHub](https://github.com/HU-xiaobai/xMemory)

---

## 3. Self-Healing and Anti-Fragile Patterns

### 3.1 NeoSigma — Autonomous Improvement Loop

| Field | Value |
|-------|-------|
| What | Infrastructure for automated failure mining, clustering, and harness optimization |
| Stars | N/A (commercial product, neosigma.ai) |
| License | Proprietary |
| Cost | Not publicly listed |

**Key result**: After 18 batches of automated failure mining under GPT-5.4, an agent's val
score improved from 0.560 to 0.780 — a **39.3% improvement with no model upgrade**.

**How it works:**
1. Run agent on task batch, collect failures
2. Push failures into candidates register pool
3. Cluster by shared root-cause mechanism
4. High `total_failures` + low `resolution_rate` = most systemic failure modes
5. Generate candidate harness updates (multiple trajectories explored)
6. Reject any candidate that degresses previously fixed failures
7. Accept only globally consistent improvements
8. Repeat (96 experiments across 18 batches in the documented run)

**Relevance to OLMO**: This is exactly the pattern OLMO needs — but at a smaller scale.
The `/insights` skill already does retrospective analysis. Adding structured failure
clustering and tracking resolution rates would close the loop. The key insight is
**constrained optimization**: only accept changes that don't regress.

Sources:
- [NeoSigma Blog](https://www.neosigma.ai/blog/self-improving-agentic-systems)

### 3.2 ChaosEater — Chaos Engineering for LLM Systems

| Field | Value |
|-------|-------|
| What | LLM-based system that fully automates Chaos Engineering cycles |
| Stars | Research project (NTT / ASE 2025) |
| License | Research (experimental, not production-ready) |
| Cost | $0.20-$0.80 per CE cycle, 11-25 min per cycle |
| Paper | [arXiv 2511.07865](https://arxiv.org/abs/2511.07865) |

**How it works:**
1. **Hypothesis**: Define steady states and failure scenarios
2. **Experiment**: Inject faults using Kubernetes chaos tools
3. **Analysis**: Validate using "Validation as Code" (VaC) with Python/JS scripts
4. **Improvement**: Generate and apply fixes

**Relevance to OLMO**: The concept of systematic failure injection is valuable for testing
agent robustness (e.g., "what happens when HANDOFF.md is malformed?", "what if a hook
fails silently?"). Not directly applicable to OLMO's current scale, but the VaC pattern
(validation scripts, not manual checks) is immediately useful.

Sources:
- [ChaosEater GitHub](https://github.com/ntt-dkiku/chaos-eater)
- [ChaosEater Paper](https://arxiv.org/abs/2511.07865)

### 3.3 Via Negativa / Known-Bad-Patterns Registries

**sec-context** by Arcanum Security:
- 475 GitHub stars, CC-BY-4.0 license
- 25+ security anti-patterns distilled from 150+ sources
- Frequency/severity/detectability matrix for ranking
- Designed to be injected into LLM system prompts
- Finding: 86% of AI-generated code fails XSS defenses (Veracode 2025)

**Common LLM anti-patterns identified in production:**
- Packing too many tasks into single prompt → hallucinations
- Over-commenting and excessive print statements in generated code
- Exposing LLMs directly to users without guardrails
- Using LLMs for tasks better suited to traditional ML
- Infinite agent conversation loops (see ZenML incident below)

**Relevance to OLMO**: The via negativa approach (define what NOT to do) is already used in
OLMO's anti-drift rules. Could be formalized into a `.claude/rules/known-bad-patterns.md`
registry that grows as new failure modes are discovered by `/insights`.

Sources:
- [sec-context GitHub](https://github.com/Arcanum-Sec/sec-context)
- [LLM Anti-Patterns (Medium)](https://medium.com/marvelous-mlops/patterns-and-anti-patterns-for-building-with-llms-42ea9c2ddc90)

### 3.4 Validate → Classify → Recover → Learn Loops

**H-LLM Framework** (NeurIPS 2024):
1. **Monitor**: Statistical drift detection over k previous time points
2. **Diagnose**: LLM generates k candidate reasons using CoT + self-reflection
3. **Adapt**: Generate adaptation actions conditioned on diagnosis distribution
4. **Test**: Evaluate on empirical dataset, implement only optimal action

**ICLR 2026 Workshop on AI with Recursive Self-Improvement**:
- RSI is moving from labs to production
- Key challenge: building algorithmic foundations for reliable self-improvement
- Loops that update weights, rewrite prompts, or adapt controllers are now deployed

**Relevance to OLMO**: The 4-phase loop maps to OLMO's existing tools:
Monitor = OTel metrics | Diagnose = `/insights` | Adapt = rule/skill edits | Test = `pytest`

Sources:
- [H-LLM Paper (NeurIPS 2024)](https://proceedings.neurips.cc/paper_files/paper/2024/file/4a86ec12e94ef1fe306362e7bdcd5894-Paper-Conference.pdf)
- [ICLR 2026 RSI Workshop](https://openreview.net/pdf?id=OsPQ6zTQXV)

### 3.5 Circuit Breakers for LLM Cost

**The ZenML $47k Incident:**
- Multi-agent market research system
- Agent A asked Agent B for help, B asked A for clarification → infinite loop
- Ran undetected for 11 days
- Cost escalation: $127 → $891 → $6,240 → $18,400/week
- Total: $47,000 before detection

**Circuit breaker patterns from production (1,200 deployments surveyed):**
- **Cost threshold**: Auto-stop at P95 cost per conversation (Cox Automotive)
- **Turn limit**: Stop at ~20 back-and-forth turns
- **Token bucket**: Rate limit by actual compute volume, not request count
- **Cascading degradation**: Breach → route to cheaper model → skip non-essential steps →
  serve cached results
- **Time-boxing**: Hard timeout on multi-step agent executions

**Relevance to OLMO**: OLMO already uses `maxTurns` per agent. Missing: cost thresholds,
cross-session cost tracking, and automatic model downgrade. OTel metrics + a simple hook
could implement a per-session cost circuit breaker.

Sources:
- [ZenML 1,200 Deployments Report](https://www.zenml.io/blog/what-1200-production-deployments-reveal-about-llmops-in-2025)
- [LLM Cost Control Guide 2026](https://techdim.com/llm-cost-control-for-your-business-practical-guide-for-2026/)
- [Traefik Token-Level Controls](https://markets.financialcontent.com/stocks/article/bizwire-2026-3-16-traefik-labs-advances-llm-and-mcp-runtime-governance-with-composable-safety-pipeline-multi-provider-resilience-and-token-level-cost-controls)

---

## 4. Contract Enforcement / Cross-Ref Tools

### 4.1 ifttt-lint (LINT.IfChange / LINT.ThenChange)

| Field | Value |
|-------|-------|
| What | Cross-file change enforcement via comment directives |
| Stars | Small project (~100 stars across forks) |
| License | MIT (simonepri fork) |
| Cost | $0 |
| Integration | CLI + programmatic API, Node.js |

**How it works:**
```javascript
// file-a.js
// LINT.IfChange('schema')
const SCHEMA_VERSION = 3;
// LINT.ThenChange('file-b.js#schema')

// file-b.js
// LINT.Label('schema')
const EXPECTED_VERSION = 3;
// LINT.EndLabel
```

If `file-a.js` changes within the IfChange block but `file-b.js#schema` doesn't change
in the same commit, the linter fails.

**Key features:**
- Labeled regions for fine-grained co-change requirements
- Parallel parsing with Node.js worker threads
- Used in production at Google (internal tool), Chromium, Fuchsia, TensorFlow

**Relevance to OLMO**: **High**. Directly solves the cross-reference failure problem.
Could enforce: "if slide HTML changes, evidence HTML must also change" or "if agent .md
changes, HANDOFF table must also change". Can run as a pre-commit hook.

Sources:
- [ifttt-lint (simonepri)](https://github.com/simonepri/ifttt-lint)
- [ifttt-lint (ebrevdo)](https://github.com/ebrevdo/ifttt-lint)
- [Chromium Keep Files In Sync](https://www.chromium.org/chromium-os/developer-library/guides/development/keep-files-in-sync/)

### 4.2 Schemathesis

| Field | Value |
|-------|-------|
| What | Property-based API testing from OpenAPI specs |
| Stars | ~2.5k GitHub |
| License | MIT |
| Cost | $0 |

Generates hundreds of edge-case requests from your spec automatically. Validates responses
against the schema. Useful for testing any API-driven components.

### 4.3 Dredd

| Field | Value |
|-------|-------|
| What | Language-agnostic HTTP API testing against description documents |
| Stars | ~4.2k GitHub |
| License | MIT |
| Cost | $0 |

Validates that API implementation matches its OpenAPI/Swagger spec. CI integration
ready. Catches drift between documentation and implementation.

### 4.4 oasdiff

| Field | Value |
|-------|-------|
| What | OpenAPI breaking change detector between spec versions |
| Stars | ~1.5k GitHub |
| License | Apache 2.0 |
| Cost | $0 |

Detects breaking changes between two versions of an OpenAPI specification. Prevents
unintentional disruption. Key stat: 75% of APIs don't conform to their specs.

### 4.5 PactFlow Drift

| Field | Value |
|-------|-------|
| What | Spec-driven API testing: verify implementation conforms to OpenAPI definition |
| Stars | Part of Pact ecosystem (~12k combined) |
| License | MIT (Pact OSS), commercial (PactFlow) |
| Cost | Pact OSS: $0. PactFlow: paid plans |

**Key features:**
- OpenAPI spec as source of truth
- Plug-and-play CLI
- Declarative, version-controlled test suites
- AI-powered automatic test suite generation from spec
- Positions spec-driven testing + contract testing as integrated workflow

**Relevance to OLMO**: Schemathesis, Dredd, oasdiff, and PactFlow are most relevant if OLMO
builds API-driven agent communication. Currently OLMO agents communicate via Claude Code's
subagent system, not HTTP APIs. Keep on radar for future architecture evolution.

Sources:
- [PactFlow Drift Blog](https://pactflow.io/blog/schemas-can-be-contracts/)
- [Dredd Docs](https://dredd.org/en/latest/)
- [oasdiff on OpenAPI Tooling](https://tools.openapis.org/categories/testing.html)

---

## 5. Claude Code Ecosystem Tools

### 5.1 Superpowers by Jesse Vincent

| Field | Value |
|-------|-------|
| What | Agentic skills framework and dev methodology for Claude Code |
| Stars | ~107k GitHub (fastest-growing Claude Code plugin) |
| License | Not specified in search results |
| Cost | $0 |
| Author | Jesse Vincent (created RT, Perl pumpking, Keyboardio co-founder) |

**Key features:**
- **Brainstorm-first**: Activates before code writing, refines ideas through questions,
  presents design for validation
- **TDD enforcement**: If Claude writes code before tests, Superpowers deletes it and
  forces restart with tests first
- **Subagent-driven**: Launches specialized subagents for parallel execution, each with
  two-stage review (spec compliance + code quality)
- **Planning mode**: Multi-step plan approval before execution

**Relevance to OLMO**: OLMO already implements similar patterns (anti-drift rules, subagent
architecture, plan-first approach). Superpowers could be studied for its TDD enforcement
mechanism — OLMO's quality-gate agent could adopt the "delete code written without tests"
pattern. The two-stage review (spec + quality) is also worth adapting.

Sources:
- [Superpowers GitHub](https://github.com/obra/superpowers)
- [Superpowers Explained (Dev Genius)](https://blog.devgenius.io/superpowers-explained-the-claude-plugin-that-enforces-tdd-subagents-and-planning-c7fe698c3b82)
- [Builder.io Guide](https://www.builder.io/blog/claude-code-superpowers-plugin)

### 5.2 Anthropic Skills Repository

| Field | Value |
|-------|-------|
| What | Official skill library from Anthropic |
| Stars | Part of anthropics org on GitHub |
| License | Apache 2.0 (most skills), source-available (document creation skills) |
| Cost | $0 |

**Key features:**
- Official reference implementation for skill architecture
- Covers creative, technical, and enterprise workflows
- Can be registered as a plugin marketplace in Claude Code
- Includes skill-creator for building custom skills

**Relevance to OLMO**: OLMO already uses the skill system extensively (30+ skills). The
official repo serves as a reference for best practices and new skill patterns. The
skill-creator skill is already installed in OLMO.

Sources:
- [anthropics/skills GitHub](https://github.com/anthropics/skills)
- [Skills Guide (PDF)](https://resources.anthropic.com/hubfs/The-Complete-Guide-to-Building-Skill-for-Claude.pdf)

### 5.3 Awesome Claude Code Collections

| Collection | Stars | Contents |
|-----------|-------|----------|
| awesome-claude-code (hesreallyhim) | ~2k | Skills, hooks, slash-commands, orchestrators, plugins |
| awesome-claude-code-toolkit (rohitg00) | ~1k | 135 agents, 35 skills, 42 commands, 150+ plugins |
| awesome-claude-plugins (ComposioHQ) | ~500 | Production-ready plugins curated list |

**Notable tools from these collections:**
- **claude-devtools**: Desktop app for session observability (detailed session log analysis)
- **cchistory**: Shell history for Claude Code sessions (list all bash commands run)
- **connect-apps**: Connect Claude to 500+ services (Gmail, Slack, GitHub, Notion)
- **claude-brain** (memvid): Single portable `.mv2` file for memory (no DB, no ChromaDB)

**Assessment**: ~250 skill packages exist on GitHub, but only ~30 are worth installing.
Most are personal `.claude/` folder copies.

Sources:
- [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code)
- [awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit)

### 5.4 plansDirectory Config

Claude Code supports a `plansDirectory` setting that designates a folder for storing
execution plans. Plans are generated during brainstorming/planning phases and can be
referenced during execution.

**Relevance to OLMO**: Could formalize the "propose plan, wait for OK" workflow. Plans
would be persisted and version-controlled alongside code.

### 5.5 PreCompact / PostCompact Hooks

As of March 2026, Claude Code expanded hook events from 14 to 21, including:

- **PreCompact**: Runs before compaction. Can distinguish auto vs manual compaction.
  Use case: back up transcript, inject critical context into summary.
- **PostCompact**: Runs after compaction. Receives `compact_summary` field.
  Use case: log summary, update external state, reinject HANDOFF.md.

**Configuration example:**
```json
{
  "hooks": {
    "PreCompact": [
      {
        "command": "bash hooks/pre-compact-backup.sh",
        "matcher": { "trigger": "auto" }
      }
    ],
    "PostCompact": [
      {
        "command": "bash hooks/post-compact-reinject.sh"
      }
    ]
  }
}
```

**Relevance to OLMO**: **Critical**. OLMO's biggest pain point is context loss after
compaction. PostCompact hook can reinject HANDOFF.md + active rules + current task state.
PreCompact can save the full transcript for `/dream` consolidation. This is the single
highest-impact improvement available today.

Sources:
- [Claude Code Hooks Reference](https://code.claude.com/docs/en/hooks)
- [PostCompact Feature Request](https://github.com/anthropics/claude-code/issues/32026)
- [Claude Code Hooks Mastery](https://github.com/disler/claude-code-hooks-mastery)

---

## 6. Agent Frameworks (Reference)

These are not for direct implementation in OLMO but provide architectural patterns and
design ideas worth studying.

### 6.1 OpenHands (formerly OpenDevin)

| Field | Value |
|-------|-------|
| What | Open platform for AI software developers as generalist agents |
| Stars | ~65-70k GitHub |
| License | MIT |
| Funding | $18.8M Series A |
| Version | v1.6.0 (March 2026) |

**Notable patterns:**
- Planning Mode beta: create plan → approve → execute (matches OLMO's ENFORCEMENT rules)
- Sandboxed Docker execution for safety
- Kubernetes support for multi-agent scaling
- SDK redesign: optional sandboxing, LocalWorkspace by default

### 6.2 Aider

| Field | Value |
|-------|-------|
| What | AI pair programming in the terminal, git-first approach |
| Stars | ~39k GitHub |
| License | Apache 2.0 |
| Installations | 4.1M+ |

**Notable patterns:**
- Every AI edit = git commit with descriptive message
- Sessions on their own branch
- Git history = complete record of AI actions
- Automatic lint + test on generated code, auto-fix on failure
- Codebase map for navigation in large projects

**Relevance to OLMO**: Aider's git-first philosophy is already partially adopted in OLMO
(session-hygiene.md, CHANGELOG). The "auto-lint + auto-fix" loop is worth studying — OLMO's
guard-lint-before-build.sh blocks but doesn't auto-fix.

### 6.3 SWE-agent

| Field | Value |
|-------|-------|
| What | Autonomous GitHub issue resolution using LMs |
| Stars | ~19k GitHub |
| License | MIT |
| Origin | Princeton + Stanford (NeurIPS 2024) |

**Notable patterns:**
- Custom Agent-Computer Interface (ACI) for code navigation
- Mini-SWE-Agent: 100 lines of Python, 65% on SWE-bench verified
- Focus on minimal, well-designed tool interfaces > complex orchestration

### 6.4 LangGraph

| Field | Value |
|-------|-------|
| What | Graph-based framework for stateful multi-step AI agents |
| Stars | ~28k GitHub |
| License | MIT |
| Integration | Python, JS, LangSmith for debugging |

**Notable patterns:**
- Nodes (functions) + edges (transitions) + conditional branching + loops
- Built-in checkpointers: MemorySaver, SqliteSaver, PostgresSaver
- State saved after every node — crash recovery from last checkpoint
- Human-in-the-loop: inspect + modify agent state at any point
- Durable execution: agents persist through failures

**Relevance to OLMO**: LangGraph's checkpoint pattern is directly applicable. If OLMO's
hooks could save agent state between tool calls, crash recovery becomes possible. The
human-in-the-loop pattern maps to OLMO's "espere OK" enforcement.

Sources:
- [OpenHands GitHub](https://github.com/OpenHands/OpenHands)
- [Aider GitHub](https://github.com/Aider-AI/aider)
- [SWE-agent GitHub](https://github.com/SWE-agent/SWE-agent)
- [LangGraph GitHub](https://github.com/langchain-ai/langgraph)

---

## 7. Practical Recommendations for OLMO

### Tier 1 — Implement Now ($0, high impact)

| # | What | Why | How |
|---|------|-----|-----|
| 1 | **Enable OTel telemetry** | Observability for cost, tokens, errors per session | Set env vars in shell profile. Zero code change. |
| 2 | **PostCompact hook** | Stop losing context after compaction | Hook reinjects HANDOFF.md + active task state + critical rules |
| 3 | **PreCompact hook** | Preserve transcript for `/dream` | Save full transcript before lossy compaction |
| 4 | **ifttt-lint directives** | Enforce cross-file co-changes | Add LINT.IfChange/ThenChange comments to coupled files. Pre-commit hook. |
| 5 | **Known-bad-patterns registry** | Via negativa — grow from `/insights` failures | Create `.claude/rules/known-bad-patterns.md`, append as new patterns found |

### Tier 2 — Implement This Quarter (low cost, medium complexity)

| # | What | Why | How |
|---|------|-----|-----|
| 6 | **Local OTel collector + Grafana** | Dashboard for cost trends, error rates, cache efficiency | Docker Compose stack (claude-code-otel as reference) |
| 7 | **Langfuse self-hosted** | LLM-specific tracing + evals beyond raw metrics | Docker Compose, connect to OTel exporter |
| 8 | **Circuit breaker hook** | Prevent runaway token spend | PostToolUse hook checks cumulative cost, kills session at threshold |
| 9 | **NeoSigma-style failure registry** | Structured failure clustering for `/insights` | JSON file tracking failure_mode, count, resolution_rate, last_seen |
| 10 | **Structured `/insights` output** | Machine-readable improvement proposals | Output JSON, not prose. Track which proposals were accepted/rejected. |

### Tier 3 — Evaluate Next Quarter (higher complexity, strategic)

| # | What | Why | How |
|---|------|-----|-----|
| 11 | **Graphiti temporal knowledge graph** | Replace flat MEMORY.md with temporal facts | Requires Neo4j. Pilot with a subset of memory files. |
| 12 | **Claude-Mem integration** | Real-time session capture vs batch `/dream` | MCP server + hooks. Evaluate AGPL license implications. |
| 13 | **Aider-style auto-fix on lint failure** | Guard-lint blocks but doesn't fix | Extend guard-lint hook: on failure, invoke Haiku to fix, re-lint |
| 14 | **LangGraph-style checkpointing** | Crash recovery for long agent runs | SQLite checkpointer in hooks. Save state between tool calls. |

### Not Recommended Now (but tracked for reference)

| Tool | Why Not Now |
|------|-----------|
| Mem0 | No temporal model; OLMO's `/dream` already handles memory consolidation |
| xMemory | Research-only; design inspiration, not production tooling |
| ChaosEater | Overkill for current scale; revisit when agent count > 20 |
| Letta | Full platform; OLMO benefits more from targeted tools than platform migration |
| Schemathesis/Dredd/oasdiff/PactFlow | Agents don't communicate via HTTP APIs yet |
| OpenHands/SWE-agent | Reference patterns only; OLMO uses Claude Code natively |
| Superpowers | OLMO already has equivalent patterns; study TDD enforcement selectively |

### Architecture Vision

```
Current (S84):
  Claude Code → flat CLAUDE.md + MEMORY.md files → manual /insights

Near-term (S90-S95):
  Claude Code → OTel → Langfuse/Grafana → automated /insights
  ifttt-lint → pre-commit → cross-ref enforcement
  PostCompact hook → context preservation
  Failure registry → constrained optimization loop

Long-term (S120+):
  Claude Code → Graphiti temporal graph → bi-temporal memory
  NeoSigma-style autonomous improvement (failure → cluster → fix → verify)
  Circuit breakers + cascading model degradation
  Full validate → classify → recover → learn loop
```

---

## Appendix: Tool Summary Table

| Tool | Stars | License | Cost | Category |
|------|-------|---------|------|----------|
| Langfuse | 19k+ | MIT | $0 self-hosted | Observability |
| Arize Phoenix | 8.6k | ELv2 | $0 self-hosted | Observability |
| claude-code-otel | ~200 | MIT | $0 | Observability |
| claude_telemetry | ~100 | MIT | $0 | Observability |
| Mem0 | 48k | Apache 2.0 | $0-$249/m | Memory |
| Graphiti/Zep | 24.4k | Apache 2.0 | $0-$25/m | Memory |
| Letta/MemGPT | 21.6k | MIT | $0 | Memory |
| Claude-Mem | 4.1k | AGPL-3.0 | $0 | Memory |
| xMemory | Research | Research | N/A | Memory |
| NeoSigma | N/A | Proprietary | TBD | Self-healing |
| ChaosEater | Research | Research | $0.20-0.80/cycle | Self-healing |
| sec-context | 475 | CC-BY-4.0 | $0 | Anti-patterns |
| ifttt-lint | ~100 | MIT | $0 | Cross-ref |
| Schemathesis | 2.5k | MIT | $0 | Contract testing |
| Dredd | 4.2k | MIT | $0 | Contract testing |
| oasdiff | 1.5k | Apache 2.0 | $0 | Contract testing |
| PactFlow Drift | 12k (Pact) | MIT / commercial | $0-paid | Contract testing |
| Superpowers | 107k | TBD | $0 | Claude Code |
| anthropics/skills | Official | Apache 2.0 | $0 | Claude Code |
| OpenHands | 65-70k | MIT | $0 | Agent framework |
| Aider | 39k | Apache 2.0 | $0 | Agent framework |
| SWE-agent | 19k | MIT | $0 | Agent framework |
| LangGraph | 28k | MIT | $0 | Agent framework |

---

> Proxima etapa: revisar com Lucas, aprovar tier 1, criar implementation plan.
