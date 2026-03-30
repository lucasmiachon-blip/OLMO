# CLAUDE.md - AI Agent Ecosystem

Medico + Professor + Pesquisador + Dev AI. Concurso R3 Clinica Medica dez/2026 (120 questoes).
Pesquisa MBE, ensino, organizacao, monitoramento AI. Maximo valor, minimo custo.

## Architecture

```
Orchestrator (Opus 4.6) ─── rota, planeja, decide
├── Cientifico (Sonnet) ─── papers, PubMed, hipoteses
│   └── TrendAnalyzer (Haiku)
├── Automacao (Haiku) ─── regras, pipelines, cron
│   └── DataPipeline (Haiku)
├── Organizacao (Sonnet) ─── GTD, Eisenhower, Notion
│   └── KnowledgeOrganizer (Sonnet) ─── Notion+Obsidian+Zotero
└── AtualizacaoAI (Sonnet) ─── modelos, tools, benchmarks
    └── WebMonitor (Haiku)
```

## Efficiency: Local-First → Cache → Batch

Model routing: trivial→Ollama($0) | simple→Haiku | medium→Sonnet | complex→Opus

## Key Files

### Python (CI verde: ruff + mypy + 47 testes)
- `orchestrator.py` → entry point
- `config/ecosystem.yaml` → agentes + model routing
- `config/rate_limits.yaml` → budget ($100/mes max)
- `config/mcp/servers.json` → 16 MCPs (13 connected, 3 planned)
- `hooks/` → 2 hooks (notification desktop, stop session-hygiene)

### Aulas (Node.js: `cd content/aulas && npm run dev`)
- `content/aulas/shared/` → design system (base.css OKLCH, deck.js, engine.js, fonts woff2)
- `content/aulas/cirrose/` → 44 slides deck.js+GSAP (producao). Rules: `.claude/rules/slide-rules.md`
- `content/aulas/grade/` → 58 slides deck.js (migrada, precisa redesign legibilidade)
- `content/aulas/STRATEGY.md` → roadmap tecnico (CSS @layer, D3, Lottie, PPTX)
- `content/aulas/scripts/` → linters compartilhados (lint-slides, done-gate, QA)
- QA: `npm run qa:screenshots:grade` (Playwright + C8 font-size audit)

### Concurso R3 Clinica Medica (dez/2026)
- `assets/provas/` → PDFs de bancas R3 (gitignored)
- `assets/sap/` → MKSAP e SAPs de especialidade (gitignored)
- Skills: `/concurso` (plano de estudo) + `/exam-generator` (questoes anti-cue)

### Docs & Meta
- `ECOSYSTEM.md` → mapa completo (perfil, objetivos, KPIs, budget)
- `PENDENCIAS.md` → checklist de setup e backlog
- `HANDOFF.md` → continuidade entre sessoes
- `docs/ARCHITECTURE.md` → decisoes tecnicas
- `docs/SYNC-NOTION-REPO.md` → protocolo sync Notion ↔ Repo (source of truth, collection IDs)

## Conventions

- Python 3.11+, type hints, async/await
- YAML para config, JSON para dados
- Todo conteudo medico: referenciamento impecavel (PMID, DOI)
- **Coautoria AI explicita**: todo output credita quem participou (`.claude/rules/coauthorship.md`)
- Alianca: Opus 4.6 + ChatGPT 5.4 + Gemini 3.1 + Cursor (+ Sonnet, Haiku, Ollama)
- Notion MCP: protocolo seguro em `.claude/rules/mcp_safety.md`
- Notion writes (reorganizar/arquivar): cross-validation obrigatoria em `.claude/rules/notion-cross-validation.md`
- `pytest tests/` | `ruff check .`
- Hooks em `hooks/` (bash scripts, config em `.claude/settings.local.json`)
- Rules pesadas (`mcp_safety`, `notion-cross-validation`) com `paths:` frontmatter — so carregam em sessoes relevantes
- **NUNCA `taskkill //IM node.exe`** — Lucas roda dev server. Matar por PID especifico.

## Self-Improvement

- `HANDOFF.md` atualizado a cada sessao (so pendencias, max ~30 linhas)
- `CHANGELOG.md` append a cada sessao com commit
- Regra: `.claude/rules/session-hygiene.md`
- Hook `Stop`: verifica hygiene + reinjecta HANDOFF pos-compaction
- `/insights` semanal → refinar rules e skills
- `docs/ARCHITECTURE.md` → decisoes tecnicas
