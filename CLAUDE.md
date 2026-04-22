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

## Architecture (S232 post-close — Claude Code only, consumer)

**Sem runtime Python.** S232 post-close deletou stack Python inteiro (orchestrator.py + agents/ + subagents/ + tests/) por ser vestigial/falido/nunca usado.

Orquestração = **Claude Code nativo:**
- 9 subagents em `.claude/agents/*.md` (Task tool + MCPs)
- 18 skills em `.claude/skills/*/SKILL.md`
- 30 hooks em `.claude/hooks/` + `hooks/`
- MCP servers: shared inventory em `config/mcp/servers.json`; agent-scoped inline em `.claude/agents/*.md`; policy runtime em `.claude/settings.json`

Pesquisa MBE + QA + inbox-pull: via subagents + skills (evidence-researcher, qa-engineer, research skill com scripts/*.mjs). Notion: crosstalk pattern documentado — runtime atual blocked by deny; ver `docs/ARCHITECTURE.md §Notion Crosstalk Pattern`.

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

## CC schema gotchas (abril/2026)

> Armadilhas operacionais do Claude Code runtime documentadas após descoberta empírica. Não são bugs a reportar — são facts do sistema que precisam influenciar config reviews futuros.

- **timeout em hook type "command"/"http":** milissegundos.
- **timeout em hook type "prompt"/"agent":** segundos.
  Evidência: stop_hook_summary real com `timeout: 30` + `durationMs: 3025` sem `hookErrors` — se fosse ms teria estourado em 30ms. Não mude timeouts desses tipos sem testar.
- **permissions.ask tem bug em CC >=2.1.113** (KBP-26) — pode degradar silenciosamente para allow. Arquitetura de permissions precisa assumir esse failure mode.
- **deny-list é prefix-match.** Commit 9ef3b78 (S235b) adicionou 7 patterns shell-within-shell (`bash -c`, `sh -c`, `zsh -c`, `eval`, `exec`, `source /*`, `. /*`). `$()`, backticks e pipelines (`Bash(X && bash -c Y)`) requerem hook-level guard — fora do pattern match.

## Transient compute (Windows / MSYS override)

Claude Code v2.1.81+ carrega regra "Scratchpad directory" no system prompt apontando para `%TEMP%\claude\{hash}\{session}\scratchpad\`. Em inspeção empírica (S238), esse path expõe apenas `tasks/` (TaskCreate outputs) — não há subdir utilizável para código transiente escrito pelo agent. Combinado com cygpath quebrado em Git Bash (issues anthropics/claude-code #3923, #9883, #18197, #21640, #24738), resulta em retry-loop sempre que agent precisa executar script one-shot.

Convenção OLMO:
- Transient compute (validação numérica, conversão de cor, audit one-shot, probes exploratórios) vai em `./.claude-tmp/` (repo-relative, gitignored).
- NÃO usar `/tmp` (ambíguo em MSYS: Claude Write resolve diferente de Git Bash node).
- NÃO chamar `cygpath`.
- Path absoluto: `$CLAUDE_PROJECT_DIR/.claude-tmp/{purpose}-{YYYY-MM-DD}.mjs`
- Execução: `node .claude-tmp/{arquivo}.mjs` — passa pelo `Bash(*)` allow, não bate em `Bash(node -e *)` deny.
- Cleanup: manual por ora. TTL automático via Stop hook é candidato futuro (deferido — requer edit em settings.json).

Autorização explícita: o system prompt do CC permite desvio com "Only use /tmp if the user explicitly requests it" — este override estende essa cláusula para `./.claude-tmp/` como padrão persistente do projeto.

Descoberta paralela (S238): A deny-list cobre `node -e` e `node --eval` mas não `node -p`. Risco equivalente. Para validação de expressão única sem I/O, `node -p` é funcional hoje; candidato a fechamento futuro (requer edit em settings.json — self-mod, deferido).
