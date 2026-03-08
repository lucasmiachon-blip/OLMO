# CLAUDE.md - AI Agent Ecosystem

Ecossistema modular de agentes AI para medico-professor-developer.
Pesquisa medica (MBE), ensino (slideologia, retorica, cognicao),
organizacao pessoal e monitoramento AI. Maximo valor, minimo de API calls.

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

## Perfil

Medico + Professor + Developer AI. Objetivo: ser referencia em ensino medico.
- **Clinica**: MBE, GRADE, evidencias tier 1
- **Ensino**: slideologia, psicologia cognitiva, retorica/oratoria, error log
- **AI Fluency**: dominar AI para transmitir fluencia aos alunos de medicina
- **Dev AI**: aprendizado continuo 2x/semana, alto ROI, ultimas noticias
- **Diario**: error log de aulas + reflexao continua

## Safety

- Notion MCP: protocolo seguro em `.claude/rules/mcp_safety.md`
- Cross-validation Claude + ChatGPT 5.4 para writes ($0)
- Modelo harsh: na duvida, nao age. Ver `config/mcp/servers.json`

## KPIs (medir semanalmente)

- Cache hit rate > 50%
- Custo mensal < $40
- Notion pages organizadas vs orfas
- Workflows executados com sucesso / total
- Cross-validation agreement rate (Claude vs 5.4)

## Self-Improvement

- `HANDOFF.md` → atualizado a cada sessao
- `/insights` semanal → refinar rules e skills
- Retrospectiva mensal: custo real vs estimado, KPIs, gaps

## Key Docs (auto-referencia)

- `ECOSYSTEM.md` → mapa completo do ecossistema
- `PENDENCIAS.md` → checklist de setup
- `HANDOFF.md` → continuidade entre sessoes
- `docs/ARCHITECTURE.md` → decisoes tecnicas
- `docs/BEST_PRACTICES.md` → padroes e convencoes
- `.claude/rules/mcp_safety.md` → protocolo Notion seguro
