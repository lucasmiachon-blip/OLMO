# TREE.md — Mapa do Projeto

> Atualizado: Sessao 266 | 2026-04-27

## Raiz (operacional)

```
CLAUDE.md            # Contexto AI agents
README.md            # Quick start
CHANGELOG.md         # Historico sessao-a-sessao (append-only)
HANDOFF.md           # Pendencias para proxima sessao
AGENTS.md            # Agentes do ecossistema
GEMINI.md            # Instrucoes Gemini CLI
Makefile             # Atalhos dev (lint, format, aulas-*)
pyproject.toml       # Config Python minimal (httpx único runtime dep; ruff/mypy dev)
uv.lock              # Lock file uv
package.json         # Node deps (raiz — apca-w3, colorjs.io)
docker-compose.yml   # Stack observabilidade (OTel, opcional)
```

## .claude/ (AI agent infrastructure)

```
.claude/
├── agents/              # 19 agent definitions (.md)
│   ├── evidence-researcher.md
│   ├── codex-xhigh-researcher.md
│   ├── gemini-deep-research.md
│   ├── perplexity-sonar-research.md
│   ├── mbe-evaluator.md
│   ├── qa-engineer.md
│   ├── quality-gate.md
│   ├── reference-checker.md
│   ├── repo-janitor.md
│   ├── researcher.md
│   ├── sentinel.md
│   ├── systematic-debugger.md
│   └── debug-*.md          # 7-agent debug-team pipeline
├── agent-memory/        # Per-agent persistent memory
├── apl/                 # Ambient Pulse Loop (statusline data)
├── commands/            # Custom slash commands
│   └── evidence.md
├── hooks/               # PreToolUse/PostToolUse guard scripts (17 .sh)
│   ├── guard-*.sh       # Security guards
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
├── plans/               # Active plans (named *.md) + archive/ + README
├── rules/               # 6 rule files (anti-drift, KBP, QA, slides, design, cc-gotchas path-scoped)
├── skills/              # 18 skill directories
├── settings.json        # Primary config (hooks, permissions, env, statusLine)
├── settings.local.json  # Local permission overrides
├── statusline.sh        # Status line renderer
├── BACKLOG.md           # Persistent backlog (ver próprio arquivo §header para contagem)
├── hook-log.jsonl       # Hook event log
├── hook-stats.jsonl     # Hook performance stats
├── success-log.jsonl    # Success tracking
├── workers/             # Research workspace
└── tmp/                 # Temp files (deploy staging)
```

> Orquestracao real = Claude Code nativo. Ver `docs/ARCHITECTURE.md §Runtime`.

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
├── mcp/servers.json     # MCP server inventory (shared; usado por Claude Code)
└── otel/                # OpenTelemetry collector config (docker-compose)
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
├── archive/                 # Session-dated audits (historical)
├── adr/                     # Architecture Decision Records
│   ├── 0002-external-inbox-integration.md
│   ├── 0003-multimodel-orchestration.md
│   ├── 0004-grade-v1-archived.md
│   ├── 0005-shared-v2-greenfield.md
│   ├── 0006-olmo-deny-list-classification.md
│   └── 0007-shared-v2-migration-posture.md
├── aulas/                   # Slide-specific docs
│   ├── design-principles.md
│   ├── slide-pedagogy.md
│   ├── slide-advanced-reference.md
│   └── css-error-codes.md
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
├── loop-guard.sh            # PostToolUse: loop/repetition guard
├── nudge-commit.sh          # UserPromptSubmit: commit reminder
├── stop-quality.sh          # Stop: quality checks
├── stop-metrics.sh          # Stop: metrics snapshot (async)
├── stop-notify.sh           # Stop: notification (async)
├── stop-failure-log.sh      # StopFailure: API/hook failure log
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
scripts/             # Standalone Python scripts (fetch_medical.py — PubMed/Zotero read)
templates/           # Prompt templates
resources/           # Static resources (provas, SAP)
assets/              # Exam assets
.github/             # CI/CD (dependabot, PR template, ci.yml)
```
