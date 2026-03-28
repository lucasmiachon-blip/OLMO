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

## Custom Agents (`.claude/agents/`)

Subagents com MCP scoped e maxTurns definido:
- `researcher` → exploracao de codebase, read-only (Haiku, 15 turns)
- `notion-ops` → reads/writes Notion com protocolo MCP safety (Sonnet, 10 turns)
- `literature` → pesquisa cientifica PubMed/SCite/Consensus (Sonnet, 12 turns)
- `quality-gate` → lint, type-check, testes pre-commit (Haiku, 10 turns)

## Skills (19, sob demanda)

Skills carregadas via `.claude/skills/` quando relevantes (todas com YAML frontmatter):
- `mbe-evidence` → GRADE, CONSORT, STROBE, PRISMA, RoB2, QUADAS...
- `medical-research` → PubMed, PICO, niveis de evidencia
- `research` → pesquisa cientifica + web search + literature review
- `notion-publisher` → templates Notion com estetica profissional
- `notion-knowledge-capture` → conversa/pesquisa → Masterpiece DB
- `notion-spec-to-impl` → specs → tasks no Notion Tasks DB
- `organization` → GTD, Eisenhower, memory management, task management
- `automation` → regras, pipelines, cron, hooks, scheduled agents
- `teaching` → metodologia de ensino, andragogia, slideologia, diario docente
- `concurso` → prep concurso nov/2026, Anki AI, evidence-based learning
- `ai-fluency` → AI fluency para ensino + dev AI continuo
- `review` → code review multi-agente + OWASP LLM Top 10 2025
- `ai-monitoring` → tracking modelos, tools, benchmarks
- `exam-generator` → simulados calibrados por bancas, Anki cards, anti-cue protocol
- `skill-creator` → meta-skill para criar/refinar skills interativamente
- `janitor` → limpeza e manutencao do repositorio
- `self-evolving` → auto-evolucao PDCA do ecossistema (skills, rules, configs)
- `continuous-learning` → aprendizado progressivo dev/ML/AI ops
- `daily-briefing` → email diario (Gmail→classificar→Notion Emails Digest DB)

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
