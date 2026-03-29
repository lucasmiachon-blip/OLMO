# CLAUDE.md - AI Agent Ecosystem

Medico + Professor + Pesquisador + Dev AI. Concurso nov/2026 (120 questoes).
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

- `orchestrator.py` → entry point
- `config/ecosystem.yaml` → agentes + model routing
- `config/rate_limits.yaml` → budget ($100/mes max)
- `config/mcp/servers.json` → 16 MCPs (13 connected, 3 planned)
- `hooks/` → 2 hooks (notification desktop, stop session-hygiene)
- `ECOSYSTEM.md` → mapa completo (perfil, objetivos, KPIs, budget)
- `PENDENCIAS.md` → checklist de setup
- `HANDOFF.md` → continuidade entre sessoes
- `apps/` → frontend/API (futuro)
- `content/aulas/` → slides interativos. Node.js: `cd content/aulas && npm run dev`
- `content/aulas/shared/` → design system compartilhado (base.css, deck.js, engine.js, fonts)
- `content/aulas/cirrose/` → 44 slides deck.js + GSAP (live). Regras em `.claude/rules/slide-rules.md`
- `content/aulas/grade/` → 58 slides deck.js (live). Sistema GRADE + CAC + dislipidemias SBC 2025
- `content/aulas/STRATEGY.md` → roadmap de interatividade profissional + pesquisa
- `assets/provas/` → PDFs de bancas R3 (gitignored). `assets/sap/` → MKSAP e SAPs
- `content/blog/` → blog (futuro)

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

## Self-Improvement

- `HANDOFF.md` atualizado a cada sessao (so pendencias, max ~30 linhas)
- `CHANGELOG.md` append a cada sessao com commit
- Regra: `.claude/rules/session-hygiene.md`
- Hook `Stop`: verifica hygiene + reinjecta HANDOFF pos-compaction
- `/insights` semanal → refinar rules e skills
- `docs/ARCHITECTURE.md` → decisoes tecnicas
