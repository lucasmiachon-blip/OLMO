# TREE.md — Mapa do Projeto

> Atualizado: Sessao 93 | 2026-04-06

## Raiz (operacional)

```
CLAUDE.md            # Contexto AI agents (Claude Code le na abertura, ~85 linhas)
README.md            # Quick start
CHANGELOG.md         # Historico sessao-a-sessao (append-only)
HANDOFF.md           # Continuidade entre sessoes (max ~50 linhas, future-only)
BACKLOG.md           # Items para proxima semana+
PENDENCIAS.md        # Checklist setup + infra pendente
orchestrator.py      # Entry point principal
__main__.py          # Package entry
pyproject.toml       # Config Python (uv, ruff, mypy, pytest)
docker-compose.yml   # OTel Collector + Langfuse V3 + Postgres + ClickHouse + Redis + MinIO
Makefile             # Targets: check, lint, format, test, run
uv.lock              # Lock file Python
.pre-commit-config.yaml
.env.example         # Template de credenciais (.env e fonte de verdade, nunca committar)
```

## agents/ — Framework de agentes AI

```
agents/
├── core/
│   ├── base_agent.py        # Classe base
│   ├── model_router.py      # Roteamento: Ollama→Haiku→Sonnet→Opus
│   ├── mcp_safety.py        # Validador de safety para MCPs
│   ├── orchestrator.py      # Router/planner principal
│   ├── smart_scheduler.py   # Agendamento inteligente
│   ├── database.py          # Acesso SQLite
│   ├── exceptions.py        # Hierarquia de erros
│   └── log.py               # Logging padrao
├── scientific/              # Agente PubMed/MBE (Sonnet)
├── automation/              # Agente regras/pipelines (Haiku)
├── organization/            # Agente GTD/Notion (Sonnet)
└── ai_update/               # Agente monitoramento AI (Sonnet)
```

## subagents/ — Workers especializados

```
subagents/
├── analyzers/
│   └── trend_analyzer.py    # TrendAnalyzer (Haiku)
├── monitors/
│   └── web_monitor.py       # WebMonitor (Haiku)
└── processors/
    ├── data_pipeline.py     # DataPipeline (Haiku)
    ├── knowledge_organizer.py  # KnowledgeOrganizer (Sonnet)
    ├── notion_cleaner.py    # Re-export compat → notion/
    └── notion/              # Notion ops (5 modulos)
        ├── analysis.py
        ├── cleaner.py
        ├── executor.py
        ├── models.py
        └── snapshot.py
```

## config/ — Configuracao centralizada

```
config/
├── ecosystem.yaml       # Definicoes de agentes + model routing
├── rate_limits.yaml     # Budget
├── workflows.yaml       # Pipelines de execucao
├── loader.py            # Parser YAML/JSON
├── otel/                # OTel collector config (gRPC:4317 → Langfuse HTTP)
└── mcp/
    └── servers.json     # MCP server configs (pinned versions, SEC-004)
```

## content/aulas/ — Slide decks (Node.js, deck.js)

```
content/aulas/
├── package.json         # npm scripts: dev, build, lint, QA
├── vite.config.js       # Bundler (ports: cirrose=4100, grade=4101, metanalise=4102)
├── shared/              # Design system compartilhado
│   ├── css/             # base.css (OKLCH tokens)
│   ├── js/              # deck.js, engine.js, fonts loader
│   ├── assets/          # Fontes woff2
│   ├── decision-protocol.md  # Governanca DR-NNN para decisoes nao-triviais
│   └── coautoria.md     # Template ICMJE/SAGE disclosure AI
├── cirrose/             # 11 ativos (Act 1) + 35 archive. CSS single-file.
│   ├── slides/          # 11 HTMLs ativos + _archive/ (35 Act 2/3/appendix)
│   ├── slides/_manifest.js  # SOURCE OF TRUTH: ordem, archetypes, panelStates
│   ├── cirrose.css      # 3224L self-contained (OKLCH tokens + per-slide)
│   ├── slide-registry.js # Animacoes GSAP customizadas por slide
│   ├── references/      # 7 docs (CASE, narrative, evidence-db, must-read-trials...)
│   ├── scripts/         # Build, QA (gemini-qa3, content-research, screenshots)
│   ├── docs/            # biblia-narrativa, blueprint, lessons, prompts/ (15 QA)
│   ├── ERROR-LOG.md     # 67 erros → rules (feedback loop)
│   ├── AUDIT-VISUAL.md  # Scorecard 14 dimensoes por slide
│   ├── HANDOFF-CIRROSE.md  # Tracking especifico da aula
│   └── CHANGELOG-CIRROSE.md
├── metanalise/          # 19 slides, QA em progresso
│   ├── slides/          # HTMLs individuais
│   ├── references/      # 6 docs (archetypes, blueprint, evidence-db, narrative...)
│   └── scripts/         # Build
├── grade/               # 58 slides, ILEGIVEL (9/10 fail C8). Redesign pendente.
│   ├── slides/
│   ├── scripts/
│   └── qa-screenshots/
├── scripts/             # Linters compartilhados (lint-slides, done-gate, QA, validate-css)
│   └── qa/              # qa-batch-screenshot.mjs
├── STRATEGY.md          # Roadmap tecnico (CSS @layer, D3, Lottie, PPTX)
└── README.md            # Overview com status por aula
```

## skills/ — Python runtime skills

```
skills/
└── efficiency/
    └── local_first.py   # LocalFirstSkill (otimizacao local→cache→API)
```

> NAO confundir com `.claude/skills/` (slash commands instrucao-based).

## scripts/ — Automacao Python standalone

```
scripts/
├── atualizar_tema.py              # Update topico: PubMed→Obsidian+Notion
├── fetch_medical.py               # Fetcher PubMed/Zotero
├── workflow_cirrose_ascite.py     # Workflow cirrose+ascite
└── output/                        # Gerados (gitignored)
```

## resources/ — Notas medicas (Obsidian-compatible)

```
resources/
├── cirrose.md                     # Notas PT
├── ascite.md
├── restricao-sodica-ascite.md
├── albumin-*.md                   # Variantes EN
├── sodium-restriction-*.md
└── workflow-mbe-opus-classificacao.md
```

## tests/ — Suite pytest (53 testes)

```
tests/
├── conftest.py          # Fixtures compartilhados
├── test_config/         # Testes config/loader
└── test_core/           # Testes mcp_safety, model_router
```

## docs/ — Referencia tecnica

```
docs/
├── ARCHITECTURE.md                # Mermaid DAGs, antifragile stack, daily/weekly workflow
├── TREE.md                        # Este arquivo
├── SYNC-NOTION-REPO.md            # Protocolo sync Notion↔Repo
├── WORKFLOW_MBE.md                # Workflow MBE completo
├── PIPELINE_MBE_NOTION_OBSIDIAN.md  # Pipeline PubMed→Notion→Obsidian
├── GETTING_STARTED.md             # Setup inicial
├── keys_setup.md                  # Setup de API keys
├── coauthorship_reference.md      # Tabela membros alianca AI
├── mcp_safety_reference.md        # Referencia completa MCP safety
├── CHANGELOG-archive.md           # Historico antigo de sessoes
├── research/                      # Planos e design docs
│   ├── implementation-plan-S82.md # Master roadmap
│   └── chaos-engineering-L6.md    # L6 design doc (S93)
└── aulas/                         # Docs universais para todas as aulas
    ├── design-principles.md       # 27 principios (Cowan, Gestalt, Duarte, Tufte)
    ├── css-error-codes.md         # 52 E-codes CSS
    ├── slide-pedagogy.md          # Andragogia (Knowles, Sweller, Mayer)
    └── HARDENING-SCRIPTS.md       # Seguranca Node scripts
```

## .claude/ — Configuracao Claude Code

```
.claude/
├── agents/ (8)          # Agentes especializados (sonnet/haiku com model routing)
│   ├── evidence-researcher.md, qa-engineer.md, mbe-evaluator.md    # pesquisa + QA
│   ├── reference-checker.md, quality-gate.md, repo-janitor.md      # validacao
│   └── researcher.md, notion-ops.md                                 # utilidades
├── agent-memory/        # Memorias persistentes de agentes
│   └── evidence-researcher/  # memories hepatologia
├── commands/ (3)        # Custom commands (audit-docs, evidence, new-slide)
├── hooks/ (11)          # Guards + antifragile hooks
│   └── lib/             # Libraries: retry-utils.sh (L1), chaos-inject.sh (L6)
├── rules/ (10)          # Regras comportamentais (path-scoped)
│   ├── anti-drift.md, coauthorship.md, known-bad-patterns.md
│   ├── session-hygiene.md, qa-pipeline.md, process-hygiene.md
│   ├── mcp_safety.md, notion-cross-validation.md
│   └── slide-rules.md, design-reference.md
├── skills/ (20+)        # Slash commands instrucao-based (progressive disclosure)
├── insights/            # failure-registry.json, reports (NeoSigma)
├── plans/               # Session plans
└── settings.local.json  # Hook registration + env vars + permissions
```

## hooks/ — Session Lifecycle (11 scripts)

```
hooks/
├── session-start.sh       # SessionStart: inject HANDOFF + rules
├── session-compact.sh     # SessionStart (compact): re-inject after compaction
├── pre-compact-checkpoint.sh  # PreCompact: save context before compaction
├── notify.sh              # Notification: toast "Aguardando input"
├── stop-crossref-check.sh # Stop: cross-ref slides ↔ evidence
├── stop-detect-issues.sh  # Stop (L5): detect desync, write pending-fixes
├── stop-chaos-report.sh   # Stop (L6): chaos injection report
├── stop-hygiene.sh        # Stop: check HANDOFF/CHANGELOG updated
└── stop-notify.sh         # Stop: toast "Pronto"
```

## Outros

```
templates/
├── chatgpt_audit_prompt.md  # Prompt cross-validation ChatGPT
└── prompts.yaml             # Templates de prompts

assets/
├── provas/              # PDFs bancas R3 (gitignored)
└── sap/                 # MKSAP e SAPs (gitignored)

data/                    # SQLite + runtime data (gitignored, local only)
```
