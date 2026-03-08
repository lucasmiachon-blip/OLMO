# CLAUDE.md - AI Agent Ecosystem

Ecossistema modular de agentes AI para pesquisa medica (MBE), organizacao
pessoal e monitoramento AI. Maximo valor, minimo de API calls.

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
- `config/ecosystem.yaml` → agentes
- `config/workflows.yaml` → workflows
- `config/rate_limits.yaml` → budget
- `ECOSYSTEM.md` → mapa completo do ecossistema
- `PENDENCIAS.md` → checklist de setup

## Skills (sob demanda)

Skills carregadas via `.claude/skills/` quando relevantes:
- `mbe-evidence` → GRADE, CONSORT, STROBE, PRISMA, RoB2, QUADAS...
- `medical-research` → PubMed, PICO, niveis de evidencia
- `notion-publisher` → templates Notion com estetica profissional
- `teaching-improvement` → estudo, autoaprimoramento, referenciamento
- `review` → code review multi-agente + OWASP
- `ai-monitoring` → tracking modelos, tools, benchmarks

## Conventions

- Python 3.11+, type hints, async/await
- YAML para config, JSON para dados
- Todo conteudo medico: referenciamento impecavel (PMID, DOI)
- Cada projeto tem seu CLAUDE.md especifico
- `pytest tests/` | `ruff check .`

## Per-Project Pattern

Cada subprojeto/modulo pode ter seu proprio CLAUDE.md com contexto
especifico, decisoes de arquitetura e TODOs. O root fica enxuto.
