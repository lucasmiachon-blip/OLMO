# TREE.md — Mapa do Projeto

> Atualizado: Sessao 230 | 2026-04-19 (bubbly-forging-cat — adversarial audit + simplification)

## Raiz (operacional)

```
CLAUDE.md            # Contexto AI agents
README.md            # Quick start
CHANGELOG.md         # Historico sessao-a-sessao (append-only)
HANDOFF.md           # Pendencias para proxima sessao
AGENTS.md            # Agentes do ecossistema
GEMINI.md            # Instrucoes Gemini CLI
Makefile             # Atalhos dev
orchestrator.py      # Orchestrator principal (Python)
pyproject.toml       # Config Python (deps, ruff, mypy, pytest)
uv.lock              # Lock file uv
package.json         # Node deps (raiz — apca-w3, colorjs.io)
docker-compose.yml   # Stack observabilidade
```

## .claude/ (AI agent infrastructure)

```
.claude/
├── agents/              # 9 agent definitions (.md)
│   ├── evidence-researcher.md
│   ├── mbe-evaluator.md
│   ├── qa-engineer.md
│   ├── quality-gate.md
│   ├── reference-checker.md
│   ├── repo-janitor.md
│   ├── researcher.md
│   ├── sentinel.md
│   └── systematic-debugger.md
├── agent-memory/        # Per-agent persistent memory
├── apl/                 # Ambient Pulse Loop (statusline data)
├── commands/            # Custom slash commands
│   └── evidence.md
├── hooks/               # PreToolUse/PostToolUse guard scripts (17 .sh)
│   ├── guard-*.sh       # Security guards (6: write, bash, secrets, lint, mcp, research)
│   ├── momentum-*.sh    # Momentum brake (2: enforce, clear)
│   ├── coupling-proactive.sh
│   ├── chaos-inject-post.sh
│   ├── model-fallback-advisory.sh
│   ├── nudge-checkpoint.sh
│   ├── post-bash-handler.sh
│   ├── post-global-handler.sh
│   ├── lint-on-edit.sh
│   ├── allow-plan-exit.sh
│   └── lib/hook-log.sh
├── plans/               # Active plans (3) + archive/
├── rules/               # 5 rule files (anti-drift, KBP, QA, slides, design)
├── skills/              # 22 skill directories
├── settings.local.json  # Hooks, permissions, env config
├── statusline.sh        # Status line renderer
├── BACKLOG.md           # 46 items (8 resolved)
├── hook-log.jsonl       # Hook event log
├── hook-stats.jsonl     # Hook performance stats
├── success-log.jsonl    # Success tracking
├── workers/             # Research workspace
└── tmp/                 # Temp files (deploy staging)
```

## agents/ (Python agent implementations)

```
agents/
├── core/
│   ├── base_agent.py        # BaseAgent ABC
│   ├── orchestrator.py      # Dispatcher (single-agent post-S229)
│   ├── database.py          # SQLite persistence
│   ├── mcp_safety.py        # MCP safety checks
│   ├── exceptions.py        # Custom exceptions
│   └── log.py               # Logging config
└── automation/              # Automation agent (unico runtime Python pos-S229)

# REMOVED S228: ai_update/ + scientific/ (producer → OLMO_COWORK per ADR-0002)
# REMOVED S229: organization/ (daily GTD → OLMO_COWORK per ADR-0002)
# REMOVED S230: smart_scheduler.py + skills/ root (orphan cascade — bubbly-forging-cat Batch 3b)
# REMOVED S230: model_router.py (teatro arquitetural; routing intent preservada como diretiva humana em CLAUDE.md — bubbly-forging-cat Batch 3c, BACKLOG #42 RESOLVED)
```

## subagents/ (processor implementations)

```
subagents/
└── processors/
    └── data_pipeline.py

# REMOVED S228: analyzers/trend_analyzer.py + monitors/web_monitor.py (→ OLMO_COWORK)
# REMOVED S229: knowledge_organizer.py + notion_cleaner.py + notion/ (Notion writes → OLMO_COWORK + crosstalk pattern)
```

## tools/ (standalone utilities)

```
tools/
├── docling/                 # PDF digestion pipeline (NEW S216)
│   ├── pyproject.toml       # Python 3.13, docling + pymupdf
│   ├── pdf_to_obsidian.py   # PDF → Obsidian literature-note
│   ├── cross_evidence.py    # Cross-evidence synthesis (anti-hallucination)
│   ├── extract_figures.py   # Docling figure extraction
│   ├── precision_crop.py    # High-DPI PDF region crop
│   └── .gitignore           # Excludes .venv, output/, preview/
└── zone-calibrator.html     # OKLCH zone calibration tool
```

## content/aulas/ (slide presentations)

```
content/aulas/
├── CLAUDE.md            # Regras de slides, build, QA
├── STRATEGY.md          # Estrategia de ensino
├── package.json         # Node deps (reveal.js, decktape, etc.)
├── vite.config.js       # Build config
├── scripts/             # Build, QA, export scripts (.mjs/.js)
├── shared/              # CSS base + JS compartilhado
├── metanalise/          # Aula metanalise (17 slides, BUILD PASS)
│   ├── slides/*.html
│   ├── *.css
│   └── docs/
├── cirrose/             # Aula cirrose
├── grade/               # Aula GRADE
├── dist/                # Build output (gitignored exceto assets/)
├── exports/             # PDF exports
├── drive-package/       # Google Drive package
├── qa-screenshots/      # QA capture output
└── test-results/        # QA test results
```

## config/ (ecosystem configuration)

```
config/
├── ecosystem.yaml       # Agent ecosystem config
├── rate_limits.yaml     # API rate limits
├── workflows.yaml       # Workflow definitions
├── loader.py            # Config loader
├── mcp/servers.json     # MCP server config
└── otel/                # OpenTelemetry collector config
```

## docs/ (documentation)

```
docs/
├── ARCHITECTURE.md          # System architecture
├── TREE.md                  # This file
├── GETTING_STARTED.md       # Setup guide
├── CHANGELOG-archive.md     # Archived changelog entries
├── SYNC-NOTION-REPO.md      # Notion sync docs
├── coauthorship_reference.md
├── mcp_safety_reference.md
├── keys_setup.md
├── evidence-html-audit-S150.md
├── pmid-verification-S151.md
├── aulas/                   # Slide-specific docs
│   ├── design-principles.md
│   ├── slide-pedagogy.md
│   ├── slide-advanced-reference.md
│   ├── css-error-codes.md
│   └── AGENT-AUDIT-S79.md
└── research/
    ├── implementation-plan-S82.md
    └── chaos-engineering-L6.md
```

## hooks/ (session lifecycle)

```
hooks/
├── session-start.sh         # SessionStart: hidrata sessao
├── session-end.sh           # SessionEnd: dream flag + log
├── session-compact.sh       # Compact: context refresh
├── ambient-pulse.sh         # UserPromptSubmit: statusline data
├── apl-cache-refresh.sh     # SessionStart: APL cache
├── nudge-commit.sh          # UserPromptSubmit: commit reminder
├── stop-quality.sh          # Stop: quality checks
├── stop-metrics.sh          # Stop: metrics snapshot (async)
├── stop-notify.sh           # Stop: notification (async)
├── notify.sh                # Notification handler (async)
├── pre-compact-checkpoint.sh
├── post-compact-reread.sh
├── post-tool-use-failure.sh
└── lib/hook-log.sh          # Shared logging utility
```

## wiki/ (knowledge base — junction to Obsidian)

```
wiki/
├── _index.md                # Global index (2 domains, 11 concepts)
├── README.md
└── topics/
    ├── medicina-clinica/
    │   ├── raw/             # Source EN files
    │   └── wiki/            # Compiled concepts
    └── sistema-olmo/
        ├── raw/
        └── wiki/
```

## Other directories

```
tests/               # pytest test suite (40 tests PASS — S230 -13 test_model_router)
scripts/             # Standalone Python scripts (atualizar_tema, fetch_medical)
skills/              # Python skill implementations
templates/           # Prompt templates
resources/           # Static resources (provas, SAP)
assets/              # Exam assets
.github/             # CI/CD (dependabot, PR template, ci.yml)
```
