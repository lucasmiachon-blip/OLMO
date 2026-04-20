# HANDOFF - Proxima Sessao

> ✅ **S232 COMPLETE** (generic-snuggling-cloud — v6 adversarial consolidation) 2026-04-19 — audit-first cleanup; 11 commits; net ~570 li removed. Infra limpa, capability inalterada (evolução = 0).
>
> **S233 SKIPPED** — verification done inline durante S232 close.

**S234 HYDRATION (ordem obrigatória):**
1. Read este HANDOFF completo
2. Check `.claude/plans/README.md` (convenção + taxonomia)
3. Se dúvida S232 execution: `.claude/plans/archive/S232-v6-adversarial-consolidation.md`
4. CHANGELOG §Sessao 232 para decisões históricas

---

## PRIORIDADES S234-S239 — ordem definida + racional brutal

**Tese:** S232 pagou débito declarado. S234 ataca débito UNDECLARED descoberto no close: **Python orchestrator stack é vestigial/falido/nunca usado** (Lucas S232 close). Via Negativa antes de qualquer evolução capability.

### P0 — S234: **DELETE OR MIGRATE Python orchestrator stack**

**Tese brutal Lucas (S232 close):** "nunca foi utilizado, está vestigial e falido".

**Evidência empírica (grep S232 close):**
- Invocação runtime: APENAS `make run` + `make status` (manual; raramente invocado por Lucas)
- **ZERO hooks** invocam orchestrator.py / AutomationAgent / data_pipeline
- **ZERO external consumer code**
- `make test` roda pytest mas testa loader + base class, NÃO invoca runtime orchestrator
- Stack sobreviveu S228-S230 purges (5+ deleções relacionadas) mas nunca materializou justificativa
- S232 Batch 4 deletou workflows.yaml (último stub aspiracional); restante é esqueleto sem uso

**Escopo Python stack (candidato à deleção):**
- `orchestrator.py` (root CLI)
- `__main__.py`
- `agents/automation/` (automation_agent.py + __init__.py)
- `subagents/processors/data_pipeline.py`
- `agents/core/{base_agent.py, orchestrator.py, log.py, exceptions.py, mcp_safety.py, database.py}` (question: any reuse fora do stack acima?)
- `tests/test_config/`, `tests/conftest.py` (partial — Python stack tests)
- Makefile targets `run`, `status`
- pyproject.toml deps (se só Python stack usa)

**Preservar (ambiguous — audit clarifies):**
- `config/loader.py` + `config/ecosystem.yaml` + `config/rate_limits.yaml` — se forem usados por Claude Code subagents/skills (não só por Python orchestrator), preservar
- `config/mcp/servers.json` — MCP config, preservar

**Execução S234 (ordem rígida):**

1. **Consumer audit completo (~30min)**
   - Grep exhaustivo: quem importa `agents.core.*`, `agents.automation.*`, `subagents.processors.*`
   - Grep: quem invoca `orchestrator` em Makefile, hooks, scripts, docs
   - Verificar: `config/loader.py` é usado fora do Python stack? (Claude Code subagents leem YAML direto, não via Python loader)

2. **Decision ADR-0004 (~30min)**
   - `docs/adr/0004-python-orchestrator-disposition.md`
   - Inventory findings
   - 3 outcomes concretos:
     - **DELETE TOTAL:** `git rm -r agents/ subagents/ orchestrator.py __main__.py tests/test_config/ tests/conftest.py`; update Makefile/docs/configs; ~800-1500 li removed
     - **MIGRATE:** replace com Claude Managed Agents (April 8 hosted); new ADR + migration sessions S235+
     - **STATUS QUO + JUSTIFY:** se audit revelar consumer real, documentar

3. **Executar decisão (~60-90min)**
   - Se DELETE: executar + update docs + commit
   - Se MIGRATE: ADR complete + schedule migration + abort other S234 work
   - Se STATUS QUO: justificativa explícita no ADR + volta a P1 items

**Deliverable S234:** ADR-0004 committed + execução da decisão (se DELETE, execução nesta sessão; se MIGRATE, apenas ADR).

**Assunção de trabalho (brutal):** provável veredicto é **DELETE TOTAL**. Evidence: 5+ deleções progressivas S228-S232 de peças deste stack sem sequer notar perda funcional. Managed Agents seria substituto só se demanda nova materializar.

**Rejeito explícito:** manter Python stack "por apego histórico" ou "pode ser útil no futuro" — v6 lição é que aspiracional ≠ runtime.

---

### P1 — S235: **Research skill E2E verification + fix (B)**

**Consumer:** toda research session (Perna 1 Gemini + Perna 5 Perplexity).

**Pain concreto:** S232 criou `.claude/scripts/{gemini,perplexity}-research.mjs` unblock KBP-26 mas scripts **nunca invocados contra API real**. HANDOFF claim "unblocked" é teórico.

**Execução:** 1 topic real, invocar cada script, verificar (path + API + output); se break, diagnose + fix; document baseline em `.claude/scripts/README.md`.

**~1-2h.** Close S235.

---

### P1 — S236: **PMID batch verification automation (A)**

**Consumer:** ~100 slides/ano.

**Pain concreto:** research output PMIDs CANDIDATE; verificação manual 5-10min/slide.

**Solução:** `.claude/scripts/pmid-batch-verify.mjs` — input CANDIDATE list, output VERIFIED/INVALID via PubMed MCP esummary batch.

**Ganho:** 8-16h/ano + zero PMID errado publicado.

---

### P1 — S237: **Living-HTML migration partial (BACKLOG #36)**

**Status:** ACTIVE COMMITMENT per Lucas (preservado S232 close; plan canonical archived `.claude/plans/archive/S227-memory-to-living-html.md`).

**Consumer:** evidence-researcher agent + aulas cirrose/metanalise.

**Execução S237:** 2-3 high-value files (csph-nsbb, meld-na, te-accuracy) migrate para `content/aulas/cirrose/evidence/*.html`; use #48 (PMID batch verify) para VERIFIED PMIDs; update MEMORY.md redirect; git rm migrated .md.

**Full migration (4 remaining):** S240+.

---

### P2 — S238: **QA gate parallelism ADR + pilot (D)**

**Consumer:** toda QA session.

**Pain concreto:** 30-40min/slide sequential × 19 slides × 10 aulas = ~95h/ano.

**Solução:** 3 gates paralelo MESMO slide (KBP-05 preservado); ADR-0005 + opt-in flag `--parallel` + pilot reversível.

**Ganho:** ~50% QA time cut = ~47h/ano.

---

### P3 — S239+: **Slides production em escala**

Com wins acumulados:
- Python stack deleted (complexidade arquitetural reduzida) OR Managed Agents migrated
- Research skill verified + PMID auto
- Living-HTML partial (S237) → full (S240+)
- Possivelmente QA parallel
- Concurso R3 225d pressure continues

---

## BACKLOG triage (S232 close)

| # | Change | Razão |
|---|--------|-------|
| **NEW #51** | DELETE OR MIGRATE Python orchestrator — **P0 S234** | Vestigial/falido/nunca usado (Lucas + empirical grep audit) |
| #49 | Merged into #51 (Managed Agents é branch da decisão, não escopo separado) | Eliminar duplicação |
| #36 Living-HTML | ACTIVE continues; SCHEDULED S237 (era S236) | Downshift 1 slot devido elevação de #51 a P0 |
| #47 (research verify) | P1 S235 (era S234 P0) | Downshift devido #51 P0 |
| #48 (PMID auto) | P1 S236 (era S235) | Downshift |
| #50 (QA parallelism) | P2 S238 (era S238) | Unchanged |

---

## ESTADO POS-S232 (snapshot factual)

- **Infra limpa pré-evolução:** workflows.yaml deleted, chatgpt-5.4 → gpt-4.1-mini, mbe-evidence phantoms eliminated, shared_memory dead field, producer scripts purged.
- **Python orchestrator status (honesto explícito):** **vestigial/falido/nunca usado**. Empirical grep audit confirmou: 0 hook invocations, 0 external consumers, apenas `make run`/`make status` manual. Stack sobreviveu 5+ purges S228-S230 sem justificar existência. **S234 P0 decidirá DELETE vs MIGRATE vs (improvável) STATUS QUO.**
- **Research skill:** scripts criados em `.claude/scripts/`, NÃO testados empiricamente (S235 P1 resolve).
- **Control plane:** settings.json canonical; .local.json user overrides ONLY.
- **Memory governance:** per-agent only; §Memory em ARCHITECTURE.md.
- **Plans:** 0 active. Historical archive intact (78 files).
- **BACKLOG:** 17 P1 items post-S232 close (12 old + #47 + #48 + #50 + #36 promoted + #51 new P0). #49 subsumed by #51.
- **Hooks:** 30/30 valid (questão: quanto duplica se Managed Agents for rota — S234 ADR resolve).
- **Tests:** 37/37 pass (mas ~12-15 são do Python stack candidato à deleção — recount pós-S234 P0).

## Deferreds S240+ (explicit non-action)

- MemSearch / ByteRover semantic retrieval — YAGNI para 6 files
- Reflexion retry-with-reward — requires test infra
- HyperAgents hierarchical / Voyager skill extraction / DGM — architectural revolution
- Native Structured Outputs agent-level — defer até S234 P0 decide arquitetura

## Naming convention

- `HANDOFF.md`: future-only priority-ordered, max 120 li
- `CHANGELOG.md`: append-only session history
- `.claude/BACKLOG.md`: tiered P0/P1/P2 persistent
- `.claude/plans/README.md`: índex + taxonomia
- `.claude/plans/S{N}-{slug}.md`: active (auto-generated em plan mode OK; rename at archival)
- `.claude/plans/archive/S{N}-{slug}.md`: historical
- `docs/adr/{N}-{name}.md`: architectural decisions numbered

---
Coautoria: Lucas + Opus 4.7 + Codex + Gemini + research agent + 3 Explore agents | S232 generic-snuggling-cloud v6 + post-close Python stack P0 elevation | 2026-04-19

(R3 Clínica Médica: 225 dias)
