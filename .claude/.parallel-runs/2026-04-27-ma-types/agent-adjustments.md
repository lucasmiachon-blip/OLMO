# Agent Adjustments — S264.a

> **Path:** `.claude/.parallel-runs/2026-04-27-ma-types/agent-adjustments.md`
> **Date:** 2026-04-27 | **Session:** 264.a
> **Trigger:** Phase 1.3 smoke + Phase 2 Path A partial revealed agent-level issues blocking Phase 3 Path B dispatch.
> **Coautoria:** Lucas + Claude Code (Opus 4.7).

---

## `.claude/agents/perplexity-sonar-research.md`

### Change: `maxTurns: 15 → 25`

**Location:** frontmatter line 10
**Diff:**
```yaml
- maxTurns: 15
+ maxTurns: 25
```

**Rationale:** Phase 1.3 smoke evidenciou cap esgotado. Perplexity-sonar agent body has 6 phases (preflight + ingest + API + parse + spot-check + emit) que combined com maxTurns:15 deixou apenas ~2-3 turns por phase no peak — insufficient for sonar-deep-research's natural `<think>` + tool-use pattern.

**Evidence:**
- Smoke last orchestrator-visible text: *"Excellent — rich, high-quality prose with full thematic coverage. Now I have all the data needed. Let me build the schema-compliant JSON from this content."* — agent killed before stdout final.
- Disk file `.claude/.parallel-runs/2026-04-27-ma-types/smoke/perplexity-smoke-i2-threshold.json` (5.3KB) PRESENT and schema-valid (5 findings, 3 candidate PMIDs, 3 convergence flags).
- Total tokens 34,231 / tool_uses 15 / duration 331s.
- Gap noted IN smoke JSON itself: *"Perplexity sonar-deep-research returned markdown prose instead of JSON; findings were manually extracted from prose. Schema was built by orchestrator (Claude Sonnet), not by Perplexity directly."* — confirming Perplexity API does prose, agent does extraction → extraction needs more turns.

**Risk if not fixed:** Phase 3 Path B 3× perplexity-sonar dispatches all hit cap → orchestrator never sees clean JSON return summary → bench data only on disk → manual collection overhead → bench validity questioned ("agent didn't terminate cleanly = fail mode?").

**Verification:** Read line 10 → `maxTurns: 25` ✅ (verified S264.a turn 7).

**Commit:** S264.a (this session). CHANGELOG cross-ref deferred S265 (cross-window write protected).

---

## `.claude/agents/evidence-researcher.md`

### Change A: Drop `biomcp` (uvx Python redundant for MA methodology)

**Locations modified (5):**
1. `description:` line 3 — "BioMCP" reference removed
2. `tools:` array — `mcp:biomcp` removed (line 13)
3. `mcpServers:` block — `biomcp:` 4-line block removed (lines 36-39)
4. `## MCP Toolkit` table — `biomcp` row removed; "5 MCPs" → "4 MCPs"
5. `### Fase 2 — Busca Multi-Fonte` — `BioMCP (ClinicalTrials.gov)` removed from RCTs source line

**Diff samples:**
```yaml
# tools array
-   - mcp:biomcp
```
```yaml
# mcpServers block (removed entirely)
-  - biomcp:
-      type: stdio
-      command: uvx
-      args: ["--from", "biomcp-python", "biomcp", "run"]
```
```markdown
# MCP Toolkit table
- 5 MCPs escopados (conectam automaticamente):
+ 4 MCPs escopados (conectam automaticamente):
- | **biomcp** | Clinical trials + farmacovigilancia |
```

**Rationale:**
- biomcp via `uvx` (Python package manager) = slowest cold-start path (~30-60s npx vs ~2-5s well-cached vs uvx Python interpreter spawn).
- For meta-analysis methodology queries (RCT vs observational vs DTA designs), biomcp focus on genomic/farmacovigilância adds **no domain signal** — pubmed + crossref + scite + semantic-scholar already cover MA literature comprehensively.
- 5 MCP fan-out → 4 reduces first-spawn install latency proportionally.

**Evidence:** Phase 2 evidence-researcher dispatch hit 600s watchdog kill pre-MCP-init with last text *"I'll start with structured thinking before executing the research."* (no MCP tool actually invoked). Hypothesis = combined Phase 1 file-not-found stall (Change B fix) + biomcp uvx cold-start contributing.

**Risk if not fixed:** Phase 3 Path B Perna 2 same outcome → bench fairness compromised (Path A AND Path B both fail Perna 2 = signal loss for MCP-academic perna entirely).

**Verification:** post-edit `grep -i "biomcp" .claude/agents/evidence-researcher.md` should return 0 matches.

### Change B: Add `### Fase 1.5 — Bench mode (slide ainda nao existe)`

**Location:** body, inserted between §Fase 1 step 5 and §Fase 2.
**New content:** ~12 linhas. Body adapt:
1. SKIP Fase 1 file reads (slide HTML/evidence HTML/aula CLAUDE.md inexistentes — file-not-found cascade = stall observado S264.a)
2. Receber `synthetic_context` inline do orchestrator prompt
3. Single-Q only por dispatch (3-Q batch viola §ENFORCEMENT #2 "1 slide/tema por execucao")
4. Output path override: orchestrator especifica path
5. MCP cold-start: accept 30-60s primeiro spawn; não falhar watchdog antes desse budget

**Rationale:** Phase 2 dispatch root-cause hypothesis = Phase 1 step 1-3 file-not-found cascade. Para slide `s-ma-types` em construção (não criado ainda), Reads de `content/aulas/metanalise/slides/06-ma-types.html` + `content/aulas/metanalise/evidence/s-ma-types.html` + aula CLAUDE.md falham → agent stalls em pre-MCP planning loop.

**Evidence:** evidence-researcher last text *"I'll start with structured thinking before executing the research."* (consistent com pre-MCP-loop, não MCP-init failure).

**Risk if not fixed:** Phase 3 Path B Perna 2 same outcome unless slide pre-created (chicken-and-egg para bench que produz a slide via comparison results).

**Verification:** Read evidence-researcher.md → `### Fase 1.5 — Bench mode` section present, well-formed (5 numbered adapt steps).

---

## NOT modified (clean baseline)

### `.claude/agents/gemini-deep-research.md`
Smoke 342s ✅ FULL PASS (3 findings, PMID NCBI-verified, 13/15 turns — comfortable margin). No adjustment needed.

### `.claude/agents/codex-xhigh-researcher.md`
Phase 2 Q1 = **strongest perna**: 240s, 4 findings, 0% PMID fab, NCBI-verified inline (PMID 3802833 + 22007046 both confirmed), corrigiu typo "Newcastle-Ohio" → "Newcastle-Ottawa". Cross-family GPT-5.5 reasoning xhigh ensemble functioning as designed (S259 POC pattern).

---

## Cross-window guard (S264.a session)

Outro agente (window paralela) executando `qa-editorial-metanalise` scope:
- M `HANDOFF.md`, `GEMINI.md`
- M `content/aulas/metanalise/**` (slides + evidence)

**Edits S264.a confined to safe zones:**
- `.claude/agents/{evidence-researcher,perplexity-sonar-research}.md` ✅
- `.claude/.parallel-runs/2026-04-27-ma-types/**` ✅
- `.claude/plans/sleepy-wandering-firefly.md` ✅

CHANGELOG.md + KBP-Candidate formalization defer S265 post outro-agente-finishes editorial pipeline.
