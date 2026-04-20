# S232 — Readiness + Multimodel Orchestration + Agent/Memory Optimization

> Status: ACTIVE (criado 2026-04-19) | Pipeline: 2 sessões (S232+S233) | Retomada de slides: S234
> Session name: `S232-readiness-multimodel-agents-memory` (plan name = session name — convenção S232+)
> Priority: Execução de research já feita (S224 SOA docs + BACKLOG #29 6-phase plan desde S190)

---

## Context

Lucas: "ultimo ajuste de memoria, agentes, subagentes, rules, scripts, orquestracao e ver se tudo esta funcionando, em dois dias voltamos a produzir slides ... estado da arte de orquestracao multimodel, claude code, isso sempre ficou para depois agora eh a hora".

**Achado central (audit S232 pré-flight):** S224 já produziu 2 docs SOA comprehensive (`S224-research-memory-dream-wiki-soa.md` 358 li + `S224-research-knowledge-graph-soa.md` 163 li). BACKLOG #29 tem 6-phase plan desde S190. **Nenhuma das recomendações foi implementada.** S232 = execução, não pesquisa nova.

**Caminho explícito** (HANDOFF lição S231): "próxima sessão executa X, depois Y" > menu de opções.

---

## Stage 0 — Substrate cleanup (DONE em S232 pré-flight)

6 drifts docs↔reality reconciliados:

- ✅ `S230-Phase-G-retrospective.md` → `.claude/plans/archive/` (git mv preservando history)
- ✅ BACKLOG header: P0=0/P1=12/P2=22/Resolved=9 (era 1/11/24/8)
- ✅ BACKLOG: #42 ModelRouter RESOLVED entry adicionada à Resolved table
- ✅ HANDOFF: Hooks count 31→30, BACKLOG counts sync
- ✅ ARCHITECTURE.md: 31 scripts · 33 registrations → 30 scripts · 32 registrations
- ✅ Session name gravada: `S232-readiness-multimodel-agents-memory`

**Validação:** `.claude/plans/` = 1 active (S227) + archive; BACKLOG counts sum=46 ✅.

---

## Stage 1 — Research snapshot + ADR-0003 multimodel orchestration (S232 ~90min) ✅ DONE 2026-04-19

**Artifacts:** `docs/adr/0003-multimodel-orchestration.md` (novo) + ARCHITECTURE.md §Model Routing link. Reality-check inline no ADR §Reality check. Correção plan §1.4: HANDOFF update removido (violaria anti-drift §Session docs future-only) — ARCHITECTURE link suficiente.


### 1.1 Read S224 research (~15min)

- `.claude/plans/archive/S224-research-memory-dream-wiki-soa.md` — PROP-1/2/3, decision tree
- `.claude/plans/archive/S224-research-knowledge-graph-soa.md` — REC-1/2/3, matriz Graphiti/Mem0/Letta/LangGraph/Zep/flat

### 1.2 Reality check recs 2026-04-19 (~20min)

Dois dias passaram desde S224 (2026-04-17). Verificar se algo mudou:
- ByteRover CLI — stars/maturidade GitHub
- MemSearch (Zilliz) — release cadence
- Smart Connections MCP — Obsidian plugin status
- Logseq DB version — maturidade

**Método:** WebFetch de cada URL crítico (S224 §6 References). Reportar diffs.

### 1.3 Multimodel formalization (~40min) — `docs/adr/0003-multimodel-orchestration.md`

**Escopo:** formalizar roles + invocation gates de:

| Modelo | CLI/API | Papel atual (implícito) | Proposta explícita |
|--------|---------|-------------------------|---------------------|
| Claude Code (Opus/Sonnet/Haiku) | Max subscription | FAZER (principal) | Orchestrator + execução de código |
| Codex (GPT-5.4) | `codex-cli-runtime` plugin | 2nd opinion/rescue | Rescue investigations, code review |
| Gemini | MCP + API | PESQUISAR | Research conversacional + QA scripts |
| Antigravity (?) | — | desconhecido | Investigar — HANDOFF menciona Batch 5 |
| Ollama | local | trivial routing | $0 tier trivial tasks |

**Crosstalk patterns existentes** (documentar):
- Claude Code + Notion MCP (S229, KBP-27)
- Claude Code + Gemini MCP (research)

**ADR deliverable:** decision + tradeoffs + invocation gates ("quando chamar X vs Y") + failure modes.

### 1.4 Deliverable Stage 1

- `docs/adr/0003-multimodel-orchestration.md` (novo)
- `docs/ARCHITECTURE.md` §Model Routing expandido (link ADR-0003)
- HANDOFF append: Stage 1 status

---

## Stage 2 — Agent/memory optimization (S232 ~120min)

### 2.1 BACKLOG #29 Phase 1 — Tool restrictions audit (~45min)

9 agents em `.claude/agents/*.md`. Para cada:
- Listar tools atualmente disponíveis (frontmatter `tools:`)
- Avaliar necessidade real (exemplos de uso recentes em plans/archive)
- Remover tools não-usados (least-privilege)

**Output:** tabela comparativa before/after + commits atomic per agent.

### 2.2 BACKLOG #29 Phase 2 — Model routing (~30min)

Audit da tabela ARCHITECTURE.md §Claude Code Subagents:
- repo-janitor (Haiku 12) — correto?
- quality-gate (Haiku 10) — correto?
- reference-checker (Haiku 15) — correto?
- researcher (Haiku 15) — correto?
- mbe-evaluator (Sonnet 15) — FROZEN justifica Sonnet?
- qa-engineer (Sonnet 12) — Sonnet necessário ou Haiku serve?

Critério: task complexity vs modelo. Evidência: transcripts de uso recente.

**Output:** routing table atualizada + justificativa escrita.

### 2.3 PROP-1 S224 — `/dream` conflict detection (~45min)

Inspiração: SleepGate + SSGM Truth Maintenance.

**Implementação:**
- Read current `/dream` skill definition
- Adicionar step: para cada novo claim, buscar no topic file por termos-chave; se conflict detected, marcar CONFLICT + surface para Lucas (não consolidar silenciosamente)
- Custo: zero infra, apenas logic update

**Deliverable:** skill `/dream` updated + teste em próxima consolidação

### 2.4 Deliverable Stage 2

- 9 agents optimized (tool restrictions + model routing)
- `/dream` skill augmented com conflict detection
- `docs/ARCHITECTURE.md` tabela subagents atualizada
- `.claude/rules/known-bad-patterns.md` KBP-28 se novo pattern emergir

---

## Stage 3 — S233 reserved scope (não executar em S232)

- BACKLOG #29 Phase 3 (maxTurns calibration)
- PROP-2 S224 (bi-temporal frontmatter)
- Rules/skills cleanup — 18 skills scan for staleness
- E2E smoke test (1 slide → MBE → QA gates)
- HANDOFF S234 explícito: "retoma produção slides"

**Deferido conscientemente:** BACKLOG #29 Phase 4 (HyperAgents/DGM), Phase 5 (QA parallelism), Phase 6 (agent-as-skill) — requerem mais design, pós-slides.

---

## Verification criteria (per stage)

**Stage 1 done quando:**
- `docs/adr/0003-multimodel-orchestration.md` existe + revisado
- ARCHITECTURE.md link ADR-0003 presente
- Reality-check (§1.2) reportado (inline no ADR ou em HANDOFF)

**Stage 2 done quando:**
- 9 agents committed com tool restrictions (1 commit per agent OU 1 batch justificado)
- Model routing doc atualizada
- `/dream` skill passa smoke test: invocar e verificar que detecta conflict em fixture

**S232 done quando:** Stage 1 + Stage 2 complete + HANDOFF S233 com caminho explícito.

---

## Budget

| Stage | Tempo estimado | Modelo primário |
|-------|----------------|-----------------|
| 0 | 20min (done) | Opus (decisão/verificação) |
| 1 | 90min | Opus (ADR design) + Sonnet (WebFetch) |
| 2 | 120min | Sonnet (edits mecânicos) + Opus (decisões routing) |
| **Total S232** | **~4h** | Max routing: trivial→Haiku, medium→Sonnet, complex→Opus |

**Extensão budget:** se Stage 2 exceder +30min, parar + HANDOFF + mover Phase restante para S233.

---

## Residual post-S232 (input para HANDOFF S233)

- BACKLOG #29 Phases 3-6 status
- PROP-2/3 S224 implementation status
- S233 focus statement: "E2E test + retomada slides"

---

## References

- `.claude/plans/archive/S224-research-memory-dream-wiki-soa.md` (PROP-1/2/3)
- `.claude/plans/archive/S224-research-knowledge-graph-soa.md` (REC-1/2/3)
- `.claude/BACKLOG.md` #29 (6-phase plan)
- `docs/adr/0002-external-inbox-integration.md` (ADR template)
- HANDOFF residual: "Batch 5 multimodel integration gate — Codex/Gemini/Antigravity formalization"

---

Coautoria: Lucas + Opus 4.7 (1M context) | S232 readiness-multimodel-agents-memory | 2026-04-19
