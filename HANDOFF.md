# HANDOFF - Proxima Sessao

> **S233 CLOSED** (substrate-truth-cleanup) 2026-04-20 — correcao adversarial de canonicos falsos pos-S232. Detalhes e arquivos tocados em `CHANGELOG §Sessao 233`. Fase B destrutiva (ghost dirs filesystem local `agents/`, `subagents/`, `tests/` gitignored) NAO executada — aguarda OK separado.

**S234 HYDRATION (ordem obrigatória):**
1. Read este HANDOFF completo
2. Check `.claude/plans/README.md` (convenção + taxonomia)
3. `CHANGELOG §Sessao 233` para edits do cleanup + `§Sessao 232` para decisões históricas
4. Se dúvida S232 execução profunda: `.claude/plans/archive/S232-v6-adversarial-consolidation.md`

---

## PRIORIDADES S234-S238 — ordem definida + racional brutal

**Tese pós-S232 final:** Python stack deletado. Remaining evolution = **verificar repairs + adicionar capabilities concretas**. Ordem shift -1 slot (antigo S234 P0 Python agora RESOLVED; wins secundários promovidos).

### P0 — S234: **Research skill E2E verification + fix (B)** — BACKLOG #47

**Consumer:** toda research session (Perna 1 Gemini + Perna 5 Perplexity).

**Pain concreto:** S232 criou `.claude/scripts/{gemini,perplexity}-research.mjs` unblock KBP-26. Scripts rodam syntax-wise mas **nunca invocados contra API real**. HANDOFF S232 claim "unblocked" é teórico.

**Por quê P0:** baseline honesto antes de adicionar nada; verifica claim S232; unlock confidence para A/Living-HTML.

**Execução:**
1. Escolher 1 topic real (ex: "MELD-Na 2024-2026 updates")
2. Invocar `node .claude/scripts/gemini-research.mjs "<prompt>"` — verify (a) path loads; (b) API call returns; (c) output format
3. Mesmo para Perplexity
4. Se break: diagnose + fix same-session
5. Document baseline em `.claude/scripts/README.md`

**Deliverable:** evidência empírica. ~1-2h. Close S234.

---

### P1 — S235: **PMID batch verification automation (A)** — BACKLOG #48

**Consumer:** ~100 slides/ano.

**Pain concreto:** research skill marca PMIDs CANDIDATE; verificação manual 5-10min/slide.

**Solução:** script `.claude/scripts/pmid-batch-verify.mjs` — input CANDIDATE list, output VERIFIED/INVALID via PubMed MCP esummary batch.

**Deliverable:** 1 script + evidence-researcher SKILL.md update.

**Ganho:** 8-16h/ano + zero PMID errado publicado.

---

### P1 — S236: **Living-HTML migration partial (BACKLOG #36)**

**Status:** ACTIVE COMMITMENT per Lucas S232 close. Plan canonical archived `.claude/plans/archive/S227-memory-to-living-html.md`.

**Consumer:** evidence-researcher agent + aulas cirrose/metanalise.

**Execução:** 2-3 high-value files (csph-nsbb, meld-na, te-accuracy) migrate para `content/aulas/cirrose/evidence/*.html`; use #48 (PMID batch verify) para VERIFIED PMIDs; update MEMORY.md redirect; git rm migrated .md.

**Full migration (remaining 3 files):** S239+.

---

### P2 — S237: **QA gate parallelism (D)** — BACKLOG #50 — ADR + pilot

**Consumer:** toda QA session.

**Pain concreto:** 30-40min/slide sequential × 19 slides × 10 aulas = ~95h/ano.

**Solução:** 3 gates paralelo MESMO slide (KBP-05 preservado); ADR-0005 + opt-in flag `--parallel` + pilot reversível.

**Ganho:** ~50% QA time cut = ~47h/ano.

---

### P3 — S238+: **Slides production em escala**

Com wins acumulados:
- Python stack deleted (complexidade -900li) ✅ S232
- Research skill verified ✅ S234
- PMID auto ✅ S235
- Living-HTML partial ✅ S236
- Possivelmente QA parallel ✅ S237
- Concurso R3 225d pressure continues

---

## Estado factual para S234

- **Python runtime:** ausente. Repo versionado purgado S232; resíduo pycache gitignored local não viaja em clone. Remaining: `scripts/fetch_medical.py` standalone.
- **Research scripts (S232):** `.claude/scripts/{gemini,perplexity}-research.mjs` criados mas nunca testados contra API real — baseline empírica = S234 P0.
- **Infra runtime:** Claude Code nativo (9 subagents + 18 skills + hooks + MCPs). Detalhes em `docs/ARCHITECTURE.md`.
- **Plans:** 0 active. Archive em `.claude/plans/archive/`.
- **BACKLOG:** contagens em `.claude/BACKLOG.md` §header.
- **Control plane:** `.claude/settings.json` canonical; `.local.json` user overrides only.

## Deferreds S239+ (explicit non-action)

- MemSearch / ByteRover semantic retrieval — YAGNI para 6 memory files
- Reflexion retry-with-reward — requires test infra
- HyperAgents hierarchical / Voyager skill extraction / DGM — no current pain
- Claude Managed Agents — sem consumer (orchestrator deletado); reabrir apenas se novo use case
- Native Structured Outputs agent-level — defer

## Naming convention

- `HANDOFF.md`: future-only priority-ordered, max 120 li
- `CHANGELOG.md`: append-only session history
- `.claude/BACKLOG.md`: tiered P0/P1/P2 persistent
- `.claude/plans/README.md`: índex + taxonomia
- `.claude/plans/S{N}-{slug}.md`: active (auto-generated OK em plan mode; rename at archival)
- `.claude/plans/archive/S{N}-{slug}.md`: historical
- `docs/adr/{N}-{name}.md`: architectural decisions numbered

---
Coautoria: Lucas + Opus 4.7 | S233 substrate-truth-cleanup (pós-S232) | 2026-04-20

(R3 Clínica Médica: 224 dias)
