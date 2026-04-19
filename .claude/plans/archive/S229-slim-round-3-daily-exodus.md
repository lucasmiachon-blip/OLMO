# S229 — slim-round-3-daily-exodus

> **Co-authoria:** Lucas + Opus 4.7 | 2026-04-18
> **Contexto:** ADR-0002 (OLMO consumer / OLMO_COWORK producer). S228 migrou stubs gmail/digest/AI/research; S229 fecha o residuo producer-side de **organizacao diaria + Notion writes**.

## Context (por que esta mudanca)

S228 deixou OLMO honesto como consumer-only **exceto** pela superficie residual de daily organization (GTD agent + 2 subagents Notion-bound + 3 skills + 3 workflows). Lucas: *"organizacao do dia a dia sai daqui; cowork organiza conhecimento; talvez sobre alguma coisa para nos mantermos organizados — GSD, indices, filosofia"*.

Decisao arquitetonica: **toda superficie producer (escreve em Notion ou organiza tasks diarias) migra conceitualmente para OLMO_COWORK**. OLMO mantem apenas: consumer pipelines (mbe-evidence, knowledge-ingest), automacao (Haiku tier), ensino/concurso, infra.

Knowledge integration OLMO ↔ COWORK fica como **debt arquitetonico explicito** (BACKLOG #46) — nao se remove codigo sem nomear a duvida que ele responderia.

## Classificacao ADR-0002

### REMOVE — producer-side daily org / Notion writes

| Item | Path | LOC | Justificativa |
|------|------|-----|----------------|
| OrganizationAgent | `agents/organization/` (dir) | 289 | GTD/Eisenhower/daily-plan/weekly-review puros |
| KnowledgeOrganizerSubagent | `subagents/processors/knowledge_organizer.py` | 459 | Notion+Obsidian+Zotero sync writes |
| NotionCleanerSubagent | `subagents/processors/notion_cleaner.py` + `notion/` pkg | ~5+pkg | Notion writes (dedupe/archive) — producer |
| Workflow `full_organization` | `config/workflows.yaml:103-121` | 19 | GTD daily workflow |
| Workflow `notion_cleanup` | `config/workflows.yaml:124-172` | 49 | Notion writes pipeline |
| Workflow `local_status_check` | `config/workflows.yaml:15-27` | 13 | Usa agent organizacao |
| Skill `organization` | `.claude/skills/organization/SKILL.md` | 64 | GTD + Notion Tasks DB sync **(decisao 1 abaixo)** |
| Skill `notion-publisher` | `.claude/skills/notion-publisher/SKILL.md` | 169 | Notion Masterpiece DB writes |
| Skill `notion-spec-to-impl` | `.claude/skills/notion-spec-to-impl/SKILL.md` | 55 | Notion Tasks DB writes |
| ecosystem.yaml entries | `config/ecosystem.yaml:28-36, 43-52, 60-69` | ~25 | Agent + 2 subagents + 3 skills |
| orchestrator.py wires | `orchestrator.py:23,26-27,45-46,49,52-53,64,67-68` | 7 | Imports + registrations |

### KEEP — consumer / philosophy / live MCP

- `AutomationAgent` + `DataPipelineSubagent` (Haiku tier, automacao consumer)
- `.claude/agents/evidence-researcher` (6 MCPs live metanalise — protected per S228)
- Skills `mbe-evidence`, `teaching`, `concurso`, `exam-generator`, `continuous-learning`, `knowledge-ingest`, `automation`, `review`, `skill-creator`, `janitor`
- `content/aulas/`, concurso/exam-generator pipelines
- Gemini/Perplexity/NLM MCP routing intacto

### Adjacencia ja mapeada (1 fix em Phase F)

- `.claude/skills/knowledge-ingest/SKILL.md:169` — referencia textual `notion-publisher` (em "Quando NAO usar"). Fix: apontar para OLMO_COWORK ou remover linha. Nao bloqueia delete.
- `.claude/skills/janitor/SKILL.md:9,15` e `continuous-learning/SKILL.md:151` — usam "organizacao" como substantivo comum (organização de repo / Notion AI). **Sem acao.**
- `tests/` — zero hits para qualquer modulo a remover. Phase E pytest deve passar limpo.

## Phase Plan (~60-90min)

### Phase A — BACKLOG #46 (debt antes do delete) — 5min
Adicionar entry em `.claude/BACKLOG.md`:
```
#46 [P1] Knowledge integration architecture (OLMO ↔ COWORK)
Origem: S229. OLMO removeu producer-side knowledge management
(Notion+Obsidian+Zotero sync). Pendente ADR descrevendo como
consumer (OLMO) le knowledge produzido por COWORK sem reintroduzir
sync code. Candidatos: filesystem cross-mount, MCP read-only,
periodic snapshot import.
```
Counts: P1=11/P2=24.

### Phase B — Producer Python removal — 15min
Delete:
- `agents/organization/` (dir + __pycache__)
- `subagents/processors/knowledge_organizer.py`
- `subagents/processors/notion_cleaner.py`
- `subagents/processors/notion/` (subpackage + __pycache__)

Edit:
- `orchestrator.py` — remove 3 imports (li 23, 26, 27), 1 agent (li 45), 2 subagents (li 49, 52-53 — keep DataPipelineSubagent), 2 mappings (li 67-68)
- `config/ecosystem.yaml` — remove agent organizacao bloco (li 28-36) + subagents knowledge_organizer/notion_cleaner (li 43-52)

Commit: `S229 round 3 Phase B: remove producer Python (organizacao + 2 subagents)`

### Phase C — Workflows removal — 5min
Edit `config/workflows.yaml`:
- Remove `full_organization`, `notion_cleanup`, `local_status_check`
- Append round 3 migration note ao bloco existente li 189-195 (S228 ja tem padrao)

Commit: `S229 round 3 Phase C: remove organizacao workflows`

### Phase D — Skills removal — 10min
Delete:
- `.claude/skills/organization/SKILL.md` (+ dir)
- `.claude/skills/notion-publisher/SKILL.md` (+ dir)
- `.claude/skills/notion-spec-to-impl/SKILL.md` (+ dir)

Edit:
- `config/ecosystem.yaml:60-69` — remove 3 skill entries
- `.claude/skills/knowledge-ingest/SKILL.md:169` — fix notion-publisher reference

Commit: `S229 round 3 Phase D: remove organizacao + notion skills (3)`

### Phase E — Verification — 10min
1. `python -m orchestrator status` → builds; mostra 1 agent (automacao) + 1 subagent (data_pipeline) + 5 workflows
2. `pytest tests/` → 100% pass
3. `ruff check .` → clean
4. `mypy agents/` → clean
5. Grep negativo: `organizacao`, `knowledge_organizer`, `notion_cleaner`, `notion-publisher`, `notion-spec-to-impl`, `full_organization`, `notion_cleanup`, `local_status_check` → 0 hits em codigo ativo (matches em CHANGELOG/HANDOFF/wiki/archive sao OK como historicos)

Falha = STOP + report, sem auto-fix.

### Phase F — Docs propagation + crosstalk pattern — 18min
Edit:
- `CLAUDE.md` — bloco Architecture (so automacao + data_pipeline restam)
- `docs/ARCHITECTURE.md`:
  - Remove organizacao branch; add round 3 ao historico de migracao
  - **Add secao "Notion Crosstalk Pattern"**: Claude Code (OLMO) + MCP Notion direct para audit + add_content inline. Justificativa: Python pipeline batch async (notion_cleaner.py removido) era mais lento que sessao interativa Lucas+Claude. Crosstalk > COWORK handoff para operacoes pontuais. MCP Notion ja configurado — capacidade permanece, infraestrutura some.
- `docs/TREE.md` — remove paths deletados
- `README.md` — grep organizacao, update se hit
- `HANDOFF.md` — substituir S228 pendencias por S229 (incluir BACKLOG #46 surface)

### Phase G — Session docs + KBP — 10min
- `CHANGELOG.md` — append S229 entry (cap 5 li per anti-drift.md §Session docs)
- `KBP-27` — apenas se padrao emergir (e.g., "memory gov ja coberto por anti-drift+dream — skill duplicada removida")
- `BACKLOG.md` counts atualizados

### Phase H — Final commit — 5min
`S229 close: round 3 daily-exodus + ADR-0002 reinforced + BACKLOG #46`

## Risks

1. **Hidden eager import**: orchestrator pode falhar se algum dispatch indireto referencia removidos. Mitigation: Phase E status check antes de prosseguir.
2. **State files rewrite drift**: HANDOFF/CHANGELOG/BACKLOG via `Edit` (Read full primeiro), nunca `Write`. KBP-25 + anti-drift.md §State files.
3. **CHANGELOG verbosity**: cap 5 li hard.
4. **Skill plugin manifest**: zero hits ja verificado fora de docs/SKILL refs.

## Verification (end-to-end)
- `python -m orchestrator status`: 1 main + 1 sub + 5 workflows visiveis
- `pytest tests/` verde
- `ruff check .` + `mypy agents/` clean
- `git log --oneline -8` mostra 4 phased commits + close
- `wc -l agents/ subagents/ .claude/skills/` reflete shrinkage

## Decisoes resolvidas (Lucas 2026-04-18)

1. **Skill `.claude/skills/organization/`**: DELETE completo. Memory gov ja coberto por `anti-drift.md §Session docs` + `/dream` + `wiki-lint`/`wiki-query`. Filosofia GTD nao requer 64 li dedicadas.
2. **notion_cleaner**: REMOVE Python pipeline + workflow. Pattern "Notion crosstalk" (Claude Code + MCP Notion direct em sessao interativa) substitui batch async lento. Documentar em `docs/ARCHITECTURE.md` em Phase F. MCP Notion ja configurado — capacidade permanece, so a infra Python some.

## KBP candidato (Phase G)

**KBP-27 "Pipeline Python redundante quando crosstalk AI+humano e mais rapido"** — quando interacao Claude Code + MCP supera batch subagent em velocidade e controle, preferir crosstalk. Notion_cleaner (S229) como caso canonico.
