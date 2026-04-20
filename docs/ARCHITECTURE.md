# Arquitetura do Ecossistema OLMO

> AI agent ecosystem for medical education and exam prep (consumer-only).
> **Consumer side** (producer em OLMO_COWORK — ver ADR-0002).
> Estado: S230 | 2026-04-19 (bubbly-forging-cat — adversarial audit + simplification)

## Runtime Python DAG (dispatcher + 1 agent)

```mermaid
graph TD
    U[Lucas] -->|request| O[Orchestrator<br>dispatcher]
    O -->|pipelines, rules, cron| AUT[Automacao<br>Haiku]
    AUT -->|subagent| DP[data_pipeline]

    style O fill:#f5a623,color:#000
    style AUT fill:#20b2aa,color:#fff
    style DP fill:#95a5a6,color:#fff
```

Pesquisa científica + QA + research-pull rodam via **Claude Code subagents** (próxima seção) — não pelo orchestrator Python.
Notion audit/add_content: **crosstalk pattern** (seção abaixo).

**Regra** (canônica em `.claude/rules/anti-drift.md` §Propose-before-pour): Lucas decide, agente executa.

**Nota histórica (S228-S230):** Foram deletados `Cientifico`+`AtualizacaoAI` (S228) + `Organizacao`+`KnowledgeOrganizer`+`NotionCleaner` (S229) + `SmartScheduler`+`LocalFirstSkill`+`ModelRouter` (S230 bubbly-forging-cat — teatro arquitetural). Pesquisa MBE real roda via `.claude/agents/evidence-researcher` (6 braços MCP) + `.claude/skills/mbe-evidence`. Daily org + Notion writes migrados para OLMO_COWORK ou substituídos por crosstalk pattern. Ver `.claude/plans/archive/S228-groovy-launching-steele.md` + `.claude/plans/archive/S229-slim-round-3-daily-exodus.md` + `.claude/plans/archive/S230-bubbly-forging-cat.md`.

## Claude Code Subagents (9)

> Separado do runtime Python acima — estes são `.claude/agents/*.md` invocados via Task tool dentro do Claude Code, com MCPs + maxTurns próprios.

| Agent | Model | maxTurns | Memory | Role |
|-------|-------|----------|--------|------|
| evidence-researcher | Sonnet | 35 | project | Multi-MCP research, living HTML |
| qa-engineer | Sonnet | 12 | project | 1 slide, 1 gate, 1 invocation |
| mbe-evaluator | Sonnet | 15 | — | GRADE/CONSORT/STROBE (FROZEN) |
| reference-checker | Haiku | 15 | project | PMID cross-ref, stale data |
| quality-gate | Haiku | 10 | — | Lint, type-check, tests |
| researcher | Haiku | 15 | — | Codebase exploration |
| repo-janitor | Haiku | 12 | — | Orphan files, dead links |
| sentinel | Sonnet | 25 | project | Read-only self-improvement, anti-pattern detection |
| systematic-debugger | Sonnet | 25 | project | 4-phase structured debugging |

## Memory (canonical layout)

**Per-agent memory** = `.claude/agent-memory/{agent-name}/` — only agent with material memory currently is `evidence-researcher` (6 topic files + MEMORY.md index). Agents create subdir on first write; empty subdirs (qa-engineer, sentinel, reference-checker) are tolerated as placeholder but NOT canonical state.

**User-global memory** = `~/.claude/memory/` — Lucas-wide cross-project (outside OLMO repo scope; managed via `/dream` + `/wiki-lint` plugin skills).

**NOT IN USE** (S232 v6 cleanup):
- `AgentContext.shared_memory` — dead field deleted from `agents/core/base_agent.py`
- Project-level global memory layer — intentionally absent; per-agent isolation is canonical

## Hook Pipeline

```mermaid
graph LR
    UPS[UserPromptSubmit] --> SS[SessionStart] --> PT[PreToolUse] --> TU[Tool Use] --> PO[PostToolUse] --> S[Stop]

    UPS --- ups1[ambient-pulse.sh<br>APL: 5-slot rotation]
    SS --- ss1[session-start.sh<br>session-compact.sh<br>apl-cache-refresh.sh]
    PT --- pt1[9 guards:<br>read-secrets · write-unified<br>plan-exit · bash-secrets<br>bash-write · lint-before-build<br>research-queries · mcp-queries<br>momentum-brake-enforce]
    PO --- po1[post-bash-handler<br>lint-on-edit L5<br>nudge-checkpoint<br>coupling-proactive<br>chaos-inject-post L6<br>model-fallback L2<br>post-global-handler]
    S --- s1[prompt: silent-exec guard<br>agent: hygiene check<br>stop-quality (merged)<br>stop-metrics (merged)<br>stop-notify · integrity]

    style UPS fill:#e67e22,color:#fff
    style SS fill:#4a9eff,color:#fff
    style PT fill:#ff6b6b,color:#fff
    style TU fill:#ffd93d,color:#000
    style PO fill:#6bcb77,color:#fff
    style S fill:#9b59b6,color:#fff
```

**30 scripts · 32 hook registrations em `settings.json`** (10 eventos: SessionStart · UserPromptSubmit · PreToolUse · PostToolUse · Notification · PreCompact · PostCompact · Stop · PostToolUseFailure · SessionEnd + 2 inline Stop hooks).
APL (Ambient Productivity Layer): 3 hooks — pulse per prompt, cache at start, scorecard at stop.
**Control plane (canonical):** `.claude/settings.json` = hooks array + permissions (deny/allow). `.claude/settings.local.json` = user-specific overrides ONLY (permissions.allow for per-user tool auth; NOT hook registrations). Agents auditing hook health must check `settings.json:hooks[]`, never `.local.json`. Reference: `.claude/hooks/README.md`.

## Antifragile Stack (Taleb L1-L7)

```mermaid
graph BT
    L1[L1 Retry + Jitter<br>retry-utils.sh] --> L2[L2 Model Fallback<br>Opus → Sonnet → Haiku<br>circuit breaker 2 fails/5min]
    L2 --> L3[L3 Cost Circuit Breaker<br>warn@100 block@400 calls/hr]
    L3 --> L4[L4 Graceful Degradation<br>context:fork in heavy skills]
    L4 --> L5[L5 Self-Healing Loop<br>lint-on-edit → stop-detect<br>→ pending-fixes → session-start]
    L5 --> L6[L6 Chaos Engineering<br>4 vectors, opt-in CHAOS_MODE=1<br>injects into L2/L3 state files]
    L6 --> L7[L7 Continuous Learning<br>failure-registry NeoSigma<br>memory TTL · /dream · /insights]

    style L1 fill:#2ecc71,color:#fff
    style L2 fill:#2ecc71,color:#fff
    style L3 fill:#2ecc71,color:#fff
    style L4 fill:#2ecc71,color:#fff
    style L5 fill:#2ecc71,color:#fff
    style L6 fill:#f39c12,color:#fff
    style L7 fill:#2ecc71,color:#fff
```

| Layer | Status S93 | Key files |
|-------|-----------|-----------|
| L1 | DONE | `.claude/hooks/lib/retry-utils.sh` |
| L2 | DONE | `.claude/hooks/model-fallback-advisory.sh` |
| L3 | NOT IMPLEMENTED | cost-circuit-breaker.sh removed — behavior unlinked (S230 audit) |
| L4 | DONE | `context:fork` in skills |
| L5 | DONE | `lint-on-edit.sh`, `stop-detect-issues.sh` |
| L6 | BASIC | `chaos-inject-post.sh` + `lib/chaos-inject.sh` (stop-chaos-report absorvido/removido — reporting gap) |
| L7 | DONE | `failure-registry.json`, memory TTL, `/dream`, `/insights` |

Design doc: `docs/research/chaos-engineering-L6.md`

## Content Pipeline (Aulas)

```mermaid
graph LR
    R[Research] -->|evidence| LH[Living HTML<br>per slide]
    LH --> S[Slides<br>slides/*.html]
    S --> M[_manifest.js]
    M -->|build-html.ps1| I[index.html]
    I -->|lint-slides.js| QA[QA Pipeline]
    QA -->|gemini-qa3.mjs| G[3 Gates:<br>Preflight · Inspect · Editorial]
    G -->|export-pdf.js| PDF[PDF Export]

    style R fill:#9b59b6,color:#fff
    style QA fill:#e74c3c,color:#fff
```

```
content/aulas/
├── shared/              # Design system (OKLCH, deck.js, GSAP engine)
├── metanalise/          # 19 slides — active development
├── cirrose/             # 11 slides
├── grade/               # 58 slides — needs redesign
├── scripts/             # Linters: lint-slides.js, gemini-qa3.mjs, export-pdf.js
├── CLAUDE.md            # Aula-specific rules (cascades from root)
└── package.json         # dev, build, lint, QA scripts
```

**Patterns:** assertion-evidence (`<h2>` = claim, visual = evidence), declarative animation (`data-animate`), OKLCH design tokens, 1280x720 viewport.

## MCP Connections

| Category | MCPs | Used by |
|----------|------|---------|
| Medical (evidence) | PubMed, SCite, Consensus, Scholar Gateway, Semantic Scholar, CrossRef, BioMCP | evidence-researcher (6 braços MBE) |
| Study | NotebookLM, Zotero | reference management |
| Productivity | Notion | crosstalk pattern (S229 — MCP direct inline) |
| Visual | Excalidraw, Canva | diagrams, design |

Gemini: CLI OAuth ($0) + API key (scripts QA). Perplexity: API direta (not MCP).

**Migrated S228-S229 → OLMO_COWORK (ADR-0002):** Gmail (S228, email scan/classify/publish); daily org agents + Notion write subagents (S229).

## Notion Crosstalk Pattern (S229)

Notion audit + add_content opera via **Claude Code (OLMO) + MCP Notion direct** em sessão interativa Lucas+Claude. NÃO existe Python subagent ou workflow batch.

**Rationale:** Python pipeline async era mais lento que crosstalk síncrono. Claude Code pode classificar, auditar, adicionar conteúdo e confirmar inline — Lucas aprova em tempo real, rollback imediato disponível. Para operações pontuais (1-N páginas), crosstalk supera COWORK handoff assíncrono.

**Quando usar crosstalk (OLMO):** audit pontual, add_content interativo, dedupe com decisão humana.
**Quando usar OLMO_COWORK:** producer pipeline (harvest → classify → publish em lote), sem humano no loop.

Infra: MCP Notion configurado em `config/mcp/servers.json`. Capacidade preservada, código Python batch não.

## Model Routing

**Intra-Claude** (complexity-based, CLAUDE.md §Efficiency):
```
trivial → Ollama ($0)  │  simple → Haiku  │  medium → Sonnet  │  complex → Opus
```

**Cross-model orchestration** — ver [`docs/adr/0003-multimodel-orchestration.md`](adr/0003-multimodel-orchestration.md) para framework 5-critérios (objetivo/trigger/artefato/custo/risco) + invocation gates Claude Code ↔ Codex ↔ Gemini ↔ Ollama + deferral rationale (Antigravity, ChatGPT deflate).

**Cost**: $0 tier — Claude Code Max + Gemini CLI OAuth + Codex ChatGPT. API keys only for QA scripts.

## Daily/Weekly Workflow

### Session Cycle (each session)

```mermaid
graph TD
    START[Session Start] -->|hooks inject| CTX[HANDOFF + pending-fixes<br>+ APL cache refresh]
    CTX --> FOCUS[Define focus<br>.session-name]
    FOCUS --> WORK[Execute tasks<br>propose → OK → execute]
    WORK -->|APL pulse per prompt| CHECK[Verify<br>lint · test · build]
    CHECK --> WRAP[Wrap-up<br>HANDOFF + CHANGELOG]
    WRAP --> COMMIT[Commit + push]
    COMMIT --> STOP[Stop hooks<br>crossref · hygiene<br>scorecard · notify]

    style WORK fill:#e67e22,color:#fff
```

### Daily

1. **Start session** — hooks surface HANDOFF + pending-fixes automatically
2. **Pick focus** — from HANDOFF proximos passos (P0 first, then P1)
3. **Work** — propose/OK/execute cycle. Max 2 subagents. Commit early.
4. **Wrap** — update HANDOFF (future-only) + CHANGELOG (append-only)
5. **Inbox pull** — `/digest-pull` or `/research-pull` reads artifacts from `$OLMO_INBOX` (producer = OLMO_COWORK)

### Weekly

1. **Monday** — review `.claude/BACKLOG.md`, pick week's priorities
2. **Mid-week** — `/insights` if 3+ sessions since last run (cadence: every 3-4 sessions)
3. **Friday** — `/dream` memory consolidation (auto-triggered every 24h via hook)
4. **Every 3 sessions** — memory governance: check merge candidates, TTL dates

### Cadences

| What | Frequency | Next |
|------|-----------|------|
| `/insights` | Every 3-4 sessions | S94 |
| Memory governance | Every 3 sessions | S95 |
| MCP pinning review | Quarterly | S95 |
| `/dream` consolidation | Auto 24h | Hook-driven |

## Project Structure

```
OLMO/
├── CLAUDE.md                # Root instructions (85 lines)
├── HANDOFF.md               # Session state (future-only, ~50 lines)
├── CHANGELOG.md             # Session history (append-only)
├── .claude/BACKLOG.md       # Prioritized work items + setup checklist
├── .claude/
│   ├── settings.json        # Hook registrations + permissions + env vars
│   ├── settings.local.json  # Local overrides (permissions only)
│   ├── rules/ (5)           # Anti-drift, KBPs, QA pipeline, slide/design rules
│   ├── skills/ (18)         # Progressive disclosure (loaded on demand)
│   ├── agents/ (9)          # Subagent definitions with model routing
│   ├── hooks/ (17 + lib/)   # Guards + antifragile hooks
│   │   └── lib/             # retry-utils.sh, chaos-inject.sh
│   ├── apl/                 # Ambient Productivity Layer cache (gitignored)
│   ├── insights/            # failure-registry.json, reports
│   └── plans/               # Session plans
├── hooks/ (13)              # Lifecycle + APL: session-start, stop-*, ambient-pulse, apl-cache, nudge-commit, post-compact-reread, session-end
├── config/
│   ├── ecosystem.yaml       # Agent routing + skills
│   └── mcp/servers.json     # MCP server configs (pinned versions)
├── content/aulas/           # Node.js subsystem (deck.js + GSAP + Vite)
├── tests/ (53)              # pytest suite
├── docs/                    # Architecture, workflows, research
│   └── research/            # Implementation plans, chaos design doc
└── docker-compose.yml       # OTel Collector + Langfuse + Postgres + ClickHouse
```

## Architectural Principles

1. **Human-in-the-loop** — Lucas decides, agent executes (Karpathy)
2. **Antifragile** — system gets stronger from failures, not just resilient (Taleb)
3. **Via Negativa** — remove what fails > add guardrails. KBPs > more rules
4. **Reversibility** — every agent action must be reversible (Anthropic)
5. **Modelo certo** — smallest model that solves the task (efficiency)
6. **Referenciamento** — PMID, DOI mandatory for medical content
7. **Curiosidade** — explain why, not just what. Teach during, not after

## Related Documents

- `docs/research/implementation-plan-S82.md` — Master roadmap (antifragile, self-improvement)
- `docs/research/chaos-engineering-L6.md` — L6 design doc
- `docs/WORKFLOW_MBE.md` — MBE research workflow
- `docs/PIPELINE_MBE_NOTION_OBSIDIAN.md` — Research pipeline details
- `content/aulas/STRATEGY.md` — Slide tech roadmap (CSS @layer, D3, Lottie)
- `docs/coauthorship_reference.md` — AI coauthorship policy
- `docs/mcp_safety_reference.md` — MCP security protocol

---

Coautoria: Lucas + Opus 4.7 | S228 (slim consumer migration)
