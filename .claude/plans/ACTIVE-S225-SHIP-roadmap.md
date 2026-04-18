# OLMO Nova Etapa: SHIP (S225-S230)

> Multi-session roadmap | proposto S224 iter 12 | 2026-04-17
> Thesis: OLMO sai de **RESEARCH + CONSOLIDATE** mode (S193-S224) para **SHIP** mode (S225+).

---

## Context

Apos 30+ sessoes de research + consolidation (S193 hooks anti-perda → S224 Stop[5] H4 + housekeeping + 3 research SOA agents), OLMO acumulou:
- Infrastructure saudavel (Stop[5] observable, hooks 31/31 valid, convention 100%)
- Research completo (knowledge graph SOA, memory/dream/wiki SOA, plans archaeology)
- Debt visivel (9 Codex hooks triaged, DE Fase 2 aberta 25+ sessoes, memory scaling incoming)
- Documentação disciplined (HANDOFF 59 li, CHANGELOG full audit trail, plans status-classified)

**O proximo passo nao e mais research ou patching. E SHIP.** Lucas mencionou doutorado + exemplo para Anthropic: para isso, sistema precisa **executar o que ja foi planejado**, nao re-planejar.

**Slip rate S224 45% subiu vs elite-check #3 (33%).** Diagnose: complexity + partnership speed sem enforcement mecanico. SHIP era precisa hook-level discipline, nao markdown rules.

---

## Thesis: SHIP Era

5 shipping tracks concretos, cada um fecha um tema que ficou aberto por sessoes:

1. **SHIP Codex debt zero** — 9 hooks issues triaged (ACTIVE-S225-codex-triage.md) → all fixed/verified
2. **SHIP DE Fase 2** — rule `.claude/rules/design-excellence.md` + skill `.claude/skills/polish/SKILL.md` (25+ sessoes open)
3. **SHIP semantic memory** — ByteRover/MemSearch operacional, validated em pesquisa medica real
4. **SHIP hook-level enforcement** — write-gate + KBP rules mecanicamente, não so prose
5. **SHIP Docling Phase 2** — notion_writer + ocr_to_fillable (casos 3b + 4 ainda TODO)
6. **SHIP KPIs dashboard** — quantified quality (slip, ctx, commits, issues, latency)

---

## Roadmap S225-S230 (6 sessoes, ~2 semanas)

### S225 — Codex debt zero + memory audit [DONE 2026-04-17, 12 commits]
**Scope:**
- Execute `ACTIVE-S225-codex-triage.md`: Phase 1 (verify #5 metrics race) → Phase 2 (quick wins #7+#10+#2+#6+#1, 40-65min) → Phase 3 (architectural #3+#4+#8, 80-95min) → Phase 4 (decide #9)
- Memory audit: real paths (`.claude/agent-memory/evidence-researcher/` atual 9 files), verificar cap rule aplicavel, consolidar se needed
- BACKLOG.md merge 3→1 (LT-7 S214 deferred)

**Deliverables:**
- 7+ hook issues fixed + committed
- Memory audit report + plan (if consolidation needed)
- Single SoT BACKLOG.md (3 → 1)

**Success:** infrastructure a zero known-debt visivel.

### S226 — Purga arquitetural Cowork↔OLMO [DONE 2026-04-17, 9 commits, PIVOT from planned DE Fase 2]
**Scope (executed):**
- ADR-0001 enforcement via purga 41 ACTIVE cowork refs → 0 drift
- Create ADR-0002 (`docs/adr/0002-external-inbox-integration.md`) — contrato simétrico lado OLMO
- Add KBP-24 (docs sobre sistemas externos) + KBP-25 (Edit Without Full Read)
- anti-drift.md: 5 rules additions (APL=HIGH strict, Propose-before-pour, Budget gate, Edit discipline, Plan execution TaskCreate)

**Delivered:**
- 9 commits (Phase A-G + close + post-close rules)
- Producer-agnostic infrastructure (env var OLMO_INBOX)
- ACTIVE-snoopy-jingling-aurora pipeline já era SHIPPED S204 (archived neste sync post-close)

**DE Fase 2 deferred:** rule + skill + research consolidate → S227 target #3.

**Success:** cowork architectural drift eliminated; producer substituibility established.

### S227 — P0 BACKLOG #34 + Semantic memory + DE Fase 2 (carried from S226)
**Scope (per HANDOFF S227 TARGETS):**
- **[P0] BACKLOG #34**: cp Pattern 8 bypass mystery (deferred S225→S226→S227). Root cause + fix.
- **Track A semantic memory** (original S226 roadmap track): ByteRover CLI OR MemSearch Zilliz OR Smart Connections MCP. Setup + 2-3 real medical research queries. Decision doc.
- **DE Fase 2 (carried from S226)**: rule `.claude/rules/design-excellence.md` + skill `.claude/skills/polish/SKILL.md` + research consolidate docs S199-S204.
- **BACKLOG #36 memory→living-HTML** (non-P0, HANDOFF target #4): plan `.claude/plans/ACTIVE-S227-memory-to-living-html.md` disponível.

**Deliverables:**
- BACKLOG #34 fixed + committed
- Memory layer operacional + evidence + decision doc
- DE rule + skill files + test em 1 slide
- Optional: HTML migration started (scope dependent)

**Success:** semantic retrieval working, DE Fase 2 unblocked, hook bypass mystery resolved.

### S228 — Hook-level enforcement (3-4h)
**Scope:**
- KBP-24 write-gate: PreToolUse hook que bloqueia Write/Edit substantivos sem approval signal from last user message
- Design: matcher = Write OR (Edit && line-count >10) OR (Bash && git-commit OR Agent substantive)
- Approval signal detection: keyword match (ok/sim/pode/go/aprovado) em recent user msg
- Test: trivial typo Edit NOT blocked, new file Write BLOCKED sem OK
- Add PreToolUse (configured em settings.json)

**Deliverables:**
- `hooks/guard-write-gate.sh` implementado + tested
- KBP-24 restaurado em known-bad-patterns.md (not parked)
- S224 slip rate em iter 7 (Write sem review) impossivel a nivel codigo

**Success:** enforcement mecanico > markdown rules. Slip rate goal <15% per session.

### S229 — Docling Phase 2 (2-3h)
**Scope:**
- Write `tools/docling/notion_writer.py` — notion-client wrapper: parse Obsidian markdown → Notion DB row + attachments upload
- Write `tools/docling/ocr_to_fillable.py` — ocrmypdf wrapper: raster PDF → PDF/A with text layer + form fields
- Update `tools/docling/pyproject.toml` adding deps `notion-client>=2.2`, `ocrmypdf>=16.0`
- Test: 1 real PDF full pipeline (PDF → Docling → Obsidian + Notion + figures + fillable)

**Deliverables:**
- 2 new Python scripts funcional
- 1 end-to-end demo: Lucas medical PDF processed through all 5 use cases
- README update: Phase 2 DONE marker

**Success:** docling scope 5/5 use cases operational.

### S230 — Retrospective + KPIs publication (2-3h)
**Scope:**
- Create `docs/kpis/olmo-dashboard.md`:
  - Slip rate per session (historical + target <15%)
  - ctx_pct_max trend (S217-S230)
  - Commits per session
  - Issues closed per session
  - Research-to-implementation latency
- Create `docs/research/olmo-case-study-anthropic.md`:
  - Architecture overview
  - Notable patterns (evidence-grounded medical workflow, multi-agent orchestration)
  - Lessons (KBP system, elite-check cadence, partnership AI-human)
  - External-ready narrative
- Measure baseline + publish targets S231+

**Deliverables:**
- KPI dashboard markdown with data
- Case study doc (Anthropic-ready)
- SHIP era retrospective in HANDOFF

**Success:** system quality quantified, external publication-ready.

---

## KPIs

Pre-SHIP baseline (S224 end):
| Metric | Value |
|--------|-------|
| Slip rate | 45% (5/11 iters) |
| ctx_pct_max | ~50 live end S224 |
| Commits/session | 12 (spike S224) / avg historical ~1 |
| Issues closed/session | 3 FALSE-DONE + 2 DEAD-REFs S224 |
| Research-to-impl latency | 25+ sessions (DE Fase 2) / 4+ sessions (Codex) |
| Plans classification coverage | 100% |
| Convention compliance | 100% S##-prefix |

Post-SHIP targets (S230):
| Metric | Target | Justificativa |
|--------|--------|---------------|
| Slip rate | <15% per session | enforcement via hook (S228) elimina silent writes |
| ctx_pct_max | <60% per session | Track A (memory + lazy skills) ships S227 |
| Commits/session | >=3 | disciplined commit cadence |
| Issues closed/session | >=1 | zero-debt discipline |
| Research-to-impl | <=1 session | Fase 2 rule enforced (no 25-session gap) |
| Convention | 100% | maintain |

---

## Critical files (across S225-S230)

| Session | New | Modified |
|---------|-----|----------|
| S225 | — | hooks/*.sh (Codex fixes), settings.json (matcher expands), .claude/BACKLOG.md merged |
| S226 | `docs/adr/0002-external-inbox-integration.md`, `.claude/rules/known-bad-patterns.md` (KBP-24+25), `.claude/rules/anti-drift.md` (+5 rules) | HANDOFF (purga CLOSED), CHANGELOG S226, archive/S226-purga-cowork-plan.md, archive/S204-snoopy-jingling-aurora.md (sync post-close) |
| S227 | BACKLOG #34 fix (hooks/settings), memory layer config + evidence notes, `docs/research/design-excellence-research-S199-S204.md`, `.claude/rules/design-excellence.md`, `.claude/skills/polish/SKILL.md` | HANDOFF, MEMORY.md index, ACTIVE-S227-memory-to-living-html.md (optional BACKLOG #36) |
| S228 | `hooks/guard-write-gate.sh`, restored `.claude/rules/known-bad-patterns.md` KBP-24 | `.claude/settings.json` PreToolUse registration |
| S229 | `tools/docling/notion_writer.py`, `tools/docling/ocr_to_fillable.py` | `tools/docling/pyproject.toml`, `tools/docling/README.md` |
| S230 | `docs/kpis/olmo-dashboard.md`, `docs/research/olmo-case-study-anthropic.md` | HANDOFF (SHIP era close), CHANGELOG (retrospective entry) |

---

## Risks + Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Scope creep per session | Session balloon >3-4h | Hard scope no plan file cada sessao; elite-check #N cada sessao close |
| Slip rate rise com complexity | Quality degrada | S228 write-gate early ships enforcement |
| Lucas R3 concurso bandwidth (Dec 2026) | Sessoes reduced | Plan allows pause/resume; each session self-contained SoT |
| DE Fase 2 writing blocks pipeline validation | S226 stuck | ACTIVE-snoopy-jingling-aurora deve completar primeiro (S225 verify) |
| Memory layer adoption fails | S227 revert | Evaluation framework defined upfront; decision doc captures revert reason |
| Docling Phase 2 API changes | Notion/ocrmypdf broken | Phase 2 isolated; core pipeline (casos 1+2+3a+5) unaffected |

---

## Success definition (SHIP era)

Nova etapa profissional succeeds when:
1. **Zero Codex debt visible** (S225)
2. **DE Fase 2 shipped** rule + skill + operational (S226)
3. **Semantic memory operational** com evidence medical research queries (S227)
4. **Write-gate mechanical enforcement** (S228)
5. **Docling scope 5/5** use cases operacional (S229)
6. **KPIs published** + Anthropic-ready case study (S230)
7. **Post-SHIP slip rate <15%** mensurado

**External validation:** OLMO becomes a **reference case** — Anthropic-worthy architecture, publishable doutorado material, disciplined AI-human partnership.

---

## Out of scope (SHIP era)

- Slide production (FROZEN — retomar apos SHIP era close, S231+)
- Track B semantic truth-decay (INV-1/3/4) — deferred
- Wallace CSS audit (defer)
- R3 concurso direct study support (Anki, simulados) — separate track Lucas
- Obsidian plugins (Templater, Dataview etc) — optional parallel

---

## Gate review (end of each session)

Every S225-S230 session close triggers:
1. Elite-check cadence (rule a cada 3 iter)
2. KPI snapshot append to CHANGELOG
3. HANDOFF S(N+1) START HERE reflecting SHIP progress
4. Decision log: continue SHIP roadmap OR pause/divert (Lucas decide)

---

Coautoria: Lucas + Opus 4.7 | OLMO Nova Etapa SHIP proposta | S224 2026-04-17
