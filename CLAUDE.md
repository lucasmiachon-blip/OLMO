# CLAUDE.md - AI Agent Ecosystem

## ENFORCEMENT (primacy anchor — leia antes de QUALQUER acao)

1. **Proponha, espere OK, execute.** Sem OK explicito do Lucas = nao fazer. "Parece logico" nao e permissao.
2. **Scripts existentes primeiro.** Glob antes de criar. Se o script existe, USAR — nao reimplementar.
3. **Erro recorrente = rule/hook, nao "vou lembrar".** Consultar `known-bad-patterns.md` antes de agir.
4. **Curiosidade obrigatoria.** Explicar o porque antes de executar. Ensinar durante, nao depois.

Medico + Professor + Pesquisador + Dev AI. Concurso R3 Clinica Medica dez/2026 (120 questoes).
Consumer: MBE (via `$OLMO_INBOX`), ensino, concurso R3. Producer (daily org, Notion writes) em OLMO_COWORK (ADR-0002). Maximo valor, minimo custo.

## Values (decision gates)

- **Antifragile**: esta decisao torna o sistema mais forte com falhas futuras? Warn vs block → block se FP baixo.
- **Curiosidade**: esta interacao ensina algo? Conexoes reais, nunca infantilizar.

## Architecture (S229 slim — consumer only)

Runtime Python (minimo honesto):
```
Orchestrator (dispatch)
└── Automacao (Haiku) ─── regras, pipelines, cron
    └── data_pipeline (subagent)
```

Pesquisa MBE + QA + inbox-pull: Claude Code subagents (`.claude/agents/*.md`), não pelo orchestrator Python.
Notion audit + add_content: crosstalk pattern (Claude Code + MCP Notion direct inline) — ver `docs/ARCHITECTURE.md`.

## Objectives

MBE, ensino (slideologia), concurso R3 dez/2026, dev AI. Detalhes: `docs/ARCHITECTURE.md`.

## Tool Assignment

```
Claude Code=FAZER  Claude.ai=PENSAR  Cursor=EDITAR  Gemini=PESQUISAR
Perplexity=BUSCAR  NotebookLM=ESTUDAR ChatGPT=VALIDAR Canva=DESIGN
Notion=PUBLICAR    Obsidian=CONECTAR  Zotero=REFERENCIAR
```
Tabela = funcao, NAO autonomia. "Espere OK" sempre prevalece.

## Efficiency: Local-First → Cache → Batch

Model routing: trivial→Ollama($0) | simple→Haiku | medium→Sonnet | complex→Opus

## Key Files

Mapa completo: `docs/TREE.md`. Entry points:
- Python: `orchestrator.py` | `config/ecosystem.yaml` | `pytest tests/` | `ruff check .` | `mypy agents/`
- Aulas: `content/aulas/CLAUDE.md` (regras, build, QA, slides)
- Concurso: `/concurso` + `/exam-generator`
- Meta: `HANDOFF.md` | `docs/ARCHITECTURE.md`

## Conventions

- Python 3.11+, type hints, async/await
- YAML para config, JSON para dados
- Conteudo medico: referenciamento impecavel (PMID, DOI)
- **Coautoria AI explicita:** `Coautoria: Lucas + [modelos]` em todo conteudo compartilhado. Commits: `Co-authored-by:`.
- Hooks em `hooks/` + `.claude/hooks/` (config em `.claude/settings.local.json`)

## Propagation Map

Aulas: ver `content/aulas/CLAUDE.md`.

| Se mudou... | Deve atualizar... |
|-------------|-------------------|
| `.claude/agents/*.md` | HANDOFF.md tabela de agentes |
| `config/ecosystem.yaml` | `docs/ARCHITECTURE.md` + `README.md` + `CLAUDE.md` (architecture blocks) |

## Self-Improvement

- Session docs: `HANDOFF.md` + `CHANGELOG.md`. Regra: `anti-drift.md §Session docs`
- Self-healing: `hooks/stop-quality.sh` → `.claude/pending-fixes.md` → session-start surfacea
- Via Negativa: `known-bad-patterns.md` acumula anti-patterns
- `/insights` semanal. Roadmap: `docs/research/implementation-plan-S82.md`
