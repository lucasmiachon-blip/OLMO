# CLAUDE.md - AI Agent Ecosystem

## ENFORCEMENT (primacy anchor — leia antes de agir)

1. NAO avance sem autorizacao do Lucas. Proponha, espere OK, execute.
2. Use scripts existentes antes de reinventar. Glob primeiro.
3. Aulas: build ANTES de QA. QA visual = Opus (multimodal), NAO Gemini.

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

## Objectives

MBE, ensino (slideologia), concurso R3 dez/2026, dev AI. Detalhes: `docs/ARCHITECTURE.md`.

## Tool Assignment

```
Claude Code=FAZER  Claude.ai=PENSAR  Cursor=EDITAR  Gemini=PESQUISAR
Perplexity=BUSCAR  NotebookLM=ESTUDAR ChatGPT=VALIDAR Canva=DESIGN
Notion=PUBLICAR    Obsidian=CONECTAR  Zotero=REFERENCIAR
```
Tabela = funcao, NAO autonomia. "Espere OK" (ENFORCEMENT) sempre prevalece.

## Efficiency: Local-First → Cache → Batch

Model routing: trivial→Ollama($0) | simple→Haiku | medium→Sonnet | complex→Opus

## Key Files

Mapa completo: `docs/TREE.md`. Entry points:
- Python: `orchestrator.py` | `config/ecosystem.yaml` | `pytest tests/` | `ruff check .` | `mypy agents/`
- Aulas: `cd content/aulas && npm run dev` | `shared/` (design system) | `cirrose/` `metanalise/` `grade/`
- Concurso: `/concurso` + `/exam-generator` | `assets/provas/` `assets/sap/` (gitignored)
- Meta: `HANDOFF.md` | `docs/ARCHITECTURE.md` | `docs/SYNC-NOTION-REPO.md`

## Conventions

- Python 3.11+, type hints, async/await
- YAML para config, JSON para dados
- Todo conteudo medico: referenciamento impecavel (PMID, DOI)
- **Coautoria AI explicita**: todo output credita quem participou (`.claude/rules/coauthorship.md`)
- Alianca: Opus 4.6 + ChatGPT 5.4 + Gemini 3.1 + Cursor (+ Sonnet, Haiku, Ollama)
- Notion MCP: protocolo seguro em `.claude/rules/mcp_safety.md`
- Notion writes (reorganizar/arquivar): cross-validation obrigatoria em `.claude/rules/notion-cross-validation.md`
- `pytest tests/` | `ruff check .` | `mypy agents/`
- **Living HTML per slide** = source of truth. Evidence-first workflow: HTML gerado ANTES do slide.
- Fontes por slide: evidence HTML + narrative.md. aside.notes deprecated.
- Hooks em `hooks/` + `.claude/hooks/` (bash scripts, config em `.claude/settings.local.json`)
- Lint enforced: `.claude/hooks/guard-lint-before-build.sh` BLOQUEIA builds se lint-slides.js falhar.
- Rules pesadas (`mcp_safety`, `notion-cross-validation`) com `paths:` frontmatter — so carregam em sessoes relevantes
- **NUNCA `taskkill //IM node.exe`** — Lucas roda dev server. Matar por PID especifico.

## Propagation Map (OBRIGATORIO — se mudou X, atualize Y)

| Se mudou... | Deve atualizar... |
|-------------|-------------------|
| `slides/{file}.html` | `_manifest.js` + `index.html` (run build) |
| `evidence/s-{id}.html` | slide correspondente (citation block) |
| `_manifest.js` | `index.html` (run `build-html.ps1`) |
| `.claude/agents/*.md` | HANDOFF.md tabela de agentes |
| `config/ecosystem.yaml` | `docs/ARCHITECTURE.md` |
| `h2` no slide HTML | `_manifest.js` headline + `narrative.md` |
| dados numericos | evidence HTML + speaker notes `[DATA]` tag |
| click-reveals | `_manifest.js` clickReveals + `slide-registry.js` |

## Self-Improvement

- Session docs: `HANDOFF.md` (pendencias) + `CHANGELOG.md` (historico). Regra: `session-hygiene.md`
- Hook `Stop`: verifica hygiene + reinjecta HANDOFF pos-compaction
- `/insights` semanal. `docs/ARCHITECTURE.md` para decisoes tecnicas

## ENFORCEMENT (recency anchor — repita antes de agir)

1. NAO avance sem autorizacao do Lucas. Proponha, espere OK, execute.
2. Use scripts existentes antes de reinventar. Glob primeiro.
3. Aulas: build ANTES de QA. QA visual = Opus (multimodal), NAO Gemini.
