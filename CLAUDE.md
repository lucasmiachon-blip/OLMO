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
- `config/mcp/servers.json` → 13 MCPs + ChatGPT 5.4
- `ECOSYSTEM.md` → mapa completo (perfil, objetivos, KPIs, budget)
- `PENDENCIAS.md` → checklist de setup
- `HANDOFF.md` → continuidade entre sessoes

## Skills (sob demanda)

Skills carregadas via `.claude/skills/` quando relevantes:
- `mbe-evidence` → GRADE, CONSORT, STROBE, PRISMA, RoB2, QUADAS...
- `medical-research` → PubMed, PICO, niveis de evidencia
- `notion-publisher` → templates Notion com estetica profissional
- `teaching-improvement` → ensino, andragogia, concurso, AI fluency, dev AI
- `review` → code review multi-agente + OWASP
- `ai-monitoring` → tracking modelos, tools, benchmarks
- `exam-generator` → simulados calibrados por bancas, Anki cards, anti-cue protocol

## Conventions

- Python 3.11+, type hints, async/await
- YAML para config, JSON para dados
- Todo conteudo medico: referenciamento impecavel (PMID, DOI)
- **Coautoria AI explicita**: todo output credita quem participou (`.claude/rules/coauthorship.md`)
- Alianca: Opus 4.6 + ChatGPT 5.4 + Gemini 3.1 + Cursor (+ Sonnet, Haiku, Ollama)
- Notion MCP: protocolo seguro em `.claude/rules/mcp_safety.md`
- `pytest tests/` | `ruff check .`

## Self-Improvement

- `HANDOFF.md` atualizado a cada sessao
- `/insights` semanal → refinar rules e skills
- `docs/ARCHITECTURE.md` → decisoes tecnicas
- `docs/BEST_PRACTICES.md` → convencoes (Karpathy, Willison, Anthropic)
