# CLAUDE.md - AI Agent Ecosystem

## ENFORCEMENT (primacy anchor — leia antes de QUALQUER acao)

1. **Proponha, espere OK, execute.** Sem OK explicito do Lucas = nao fazer. "Parece logico" nao e permissao.
2. **Scripts existentes primeiro.** Glob antes de criar. Se o script existe, USAR — nao reimplementar.
3. **Erro recorrente = rule/hook, nao "vou lembrar".** Consultar `known-bad-patterns.md` antes de agir.
4. **Curiosidade obrigatoria.** Explicar o porque antes de executar. Ensinar durante, nao depois.
5. **Ler os documentos antes de mudar.** Dominio novo ou pouco tocado → ler CLAUDE.md da subarea + `rules/*` + ADR/SKILL.md citados antes do primeiro Edit. "Pareceu obvio" nao dispensa.
6. **Evidence-based em tudo.** Toda claim factual (research SOTA, recommendation arquitetural, decisao, comparativo, "framework X faz Y") cita fonte verificavel: URL + data acesso, paper + arXiv ID, file:line, commit SHA. **Training data memory NAO conta como evidence** — "eu lembro que X" sem fonte = fabricar (KBP-36). Pesquisas externas exigem WebFetch/WebSearch real, nao inferencia. Confidence per claim: high (fonte explicita) | medium (inferencia razoavel) | low (chute educado, flag explicito).

Medico + Professor + Pesquisador + Dev AI. Concurso R3 Clinica Medica dez/2026 (120 questoes).
Consumer: MBE (via `$OLMO_INBOX`), ensino, concurso R3. Producer (daily org, Notion writes) em OLMO_COWORK (ADR-0002). Maximo valor, minimo custo.

## Values (decision gates)

- **Antifragile**: esta decisao torna o sistema mais forte com falhas futuras? Warn vs block → block se FP baixo.
- **Curiosidade**: esta interacao ensina algo? Conexoes reais, nunca infantilizar.

## Architecture

**Sem runtime Python.**

Orquestração = **Claude Code nativo:**
- 19 subagents em `.claude/agents/*.md` (9 core + 7 debug-team + 3 research wrappers)
- 18 skills em `.claude/skills/*/SKILL.md`
- Hooks em `.claude/hooks/` + `hooks/` (34 registrations: 33 command hooks + 1 inline prompt)
- MCP servers: shared inventory em `config/mcp/servers.json`; agent-scoped inline em `.claude/agents/*.md`; policy runtime em `.claude/settings.json`

Pesquisa MBE + QA + inbox-pull: via subagents + skills. Research Pernas 1/5 seguem `.claude/scripts/{gemini,perplexity}-research.mjs` como hot path canônico até D-lite re-bench; `gemini-deep-research` e `perplexity-sonar-research` ficam experimentais. Notion: crosstalk pattern documentado — runtime atual blocked by deny; ver `docs/ARCHITECTURE.md §Notion Crosstalk Pattern`.

## Objectives

MBE, ensino (slideologia), concurso R3 dez/2026, dev AI. Detalhes: `docs/ARCHITECTURE.md`.

## Tool Assignment

Narrative routing only — NOT source of truth for runtime/callable capability.

Operational truth:
- Cross-model routing: `docs/adr/0003-multimodel-orchestration.md`
- MCP inventory/lifecycle: `config/mcp/servers.json`
- Runtime policy gate: `.claude/settings.json`
- Agent-scoped MCPs: `.claude/agents/*.md`

Current role-only heuristic:
Slots like Claude.ai, Cursor, Canva, Notion, NotebookLM, Obsidian, and Zotero do NOT imply callable runtime in OLMO.

## Efficiency: Local-First → Cache → Batch

Model routing: trivial→Ollama($0) | simple→Haiku | medium→Sonnet | complex→Opus

## Key Files

Mapa completo: `docs/TREE.md`. Entry points:
- Python (minimal): `scripts/fetch_medical.py` (standalone) | `make lint/format/type-check` (scripts only)
- Aulas: `content/aulas/CLAUDE.md` (regras, build, QA, slides)
- Concurso: `/concurso` + `/exam-generator`
- Claude Code agents: `.claude/agents/*.md` | skills: `.claude/skills/*/SKILL.md` | hooks: `.claude/settings.json`
- Meta: `HANDOFF.md` | `docs/ARCHITECTURE.md`

## Conventions

- Python 3.11+, type hints, async/await
- YAML para config, JSON para dados
- Conteudo medico: referenciamento impecavel (PMID, DOI)
- **Coautoria AI explicita:** `Coautoria: Lucas + [modelos]` em todo conteudo compartilhado. Commits: `Co-authored-by:`.
- Hooks em `hooks/` + `.claude/hooks/` (config em `.claude/settings.json`; overrides locais em `.claude/settings.local.json`)

## Propagation Map

Aulas: ver `content/aulas/CLAUDE.md`.

| Se mudou... | Deve atualizar... |
|-------------|-------------------|
| `.claude/agents/*.md` | HANDOFF.md tabela de agentes |
| `config/mcp/servers.json` | `docs/ARCHITECTURE.md` §MCP Connections + `README.md` stack |

## Self-Improvement

- Session docs: `HANDOFF.md` + `CHANGELOG.md`. Regra: `anti-drift.md §Session docs`
- Self-healing: `hooks/stop-quality.sh` → `.claude/pending-fixes.md` → session-start surfacea
- Via Negativa: `known-bad-patterns.md` acumula anti-patterns
- `/insights` semanal. Roadmap: `docs/research/implementation-plan-S82.md`
