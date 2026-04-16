# S208 Rules Reduction — Tiered Information Architecture

## Context

Rules = 1,102 lines / 13 files. LLM has ~100-150 effective instruction slots. Current system saturates attention → model triages internally → process rules lose to task pressure → non-compliance → more rules (negative feedback loop).

Evidence: Anthropic <200 lines, Boris Cherny ~100 lines + 3 hooks, Karpathy ~50 lines. All high-compliance systems use FEWER instructions with HIGHER signal density.

## Design: Tiered Enforcement

| Tier | Mechanism | Reliability | Context cost |
|------|-----------|------------|-------------|
| T1 | Hooks (29 existing) | 100% deterministic | 0 |
| T2 | Rules unconditional | ~70-80% | High — competes with task |
| T3 | Rules path-scoped | ~80-90% | Medium — only when active |
| T4 | Reference doc (not auto-loaded) | On-demand | 0 until consulted |

**Decision for each piece of content:** Which tier does this belong to? NOT "cut or keep."

## Result: 13 → 5 files, ~215 lines

### T2 Unconditional (always loaded):
- `anti-drift.md` ~45 lines — behavioral constitution (absorbs session-hygiene + elite-conduct)
- `known-bad-patterns.md` ~48 lines — pointer index

### T3 Path-scoped (loaded for content/aulas/**):
- `slide-rules.md` ~55 lines — slide constraints + template (absorbs slide-patterns)
- `design-reference.md` ~35 lines — color/type/data constraints
- `qa-pipeline.md` ~35 lines — QA path + propagation

### T4 Reference (not auto-loaded, consulted on demand):
- `docs/aulas/slide-advanced-reference.md` — GSAP patterns, stage-c, specificity, bootstrap, FOUC, checklists. Migrated from rules, NOT deleted.

## Execution

### Step 1: git rm 8 files

Direct delete (zero value):
- `coauthorship.md` (31) — 1 line in CLAUDE.md
- `notion-cross-validation.md` (34) — Notion MCP frozen
- `mcp_safety.md` (50) — Notion MCP frozen
- `multi-window.md` (35) — hook enforces
- `proven-wins.md` (43) — superseded by CMMI

Delete after absorbing:
- `session-hygiene.md` (64) → anti-drift
- `elite-conduct.md` (74) → anti-drift
- `slide-patterns.md` (152) → slide-rules

### Step 2: Create T4 reference doc

`docs/aulas/slide-advanced-reference.md` — migrated knowledge:
- GSAP armadilhas (§7 from slide-rules)
- GSAP jurisdicao + FOUC (§9 from slide-rules)
- stage-c dark slides (§10 from slide-rules)
- Specificity & cascading (§11 from slide-rules)
- Bootstrap new aula (§12 from slide-rules)
- Color-mix armadilhas (§4 from design-reference)
- NNT format (§3 from design-reference)
- Verification vocabulary (§3 from design-reference)
- Fontes Tier 1 (§3 from design-reference)
- QA transition checklists (§4 from qa-pipeline)

### Step 3: Rewrite anti-drift.md (~45 lines)

Absorbs session-hygiene + elite-conduct. Pure facts.

### Step 4: Rewrite slide-rules.md (~55 lines)

Absorbs slide-patterns §0 template. Facts + tables.

### Step 5: Rewrite design-reference.md (~35 lines)

Color/type/data constraints only.

### Step 6: Rewrite qa-pipeline.md (~35 lines)

Linear path + propagation table.

### Step 7: Update known-bad-patterns.md pointers (~48 lines)

6 KBP pointers need update (targets moved/merged).

### Step 8: Update CLAUDE.md

- Line 58: coauthorship inline
- Line 59: remove mcp_safety ref
- Line 73: session-hygiene → anti-drift

### Step 9: Verify

1. `wc -l .claude/rules/*.md` ≤ 220
2. `ls .claude/rules/*.md | wc -l` = 5
3. `docs/aulas/slide-advanced-reference.md` exists with migrated content
4. Build PASS

## Projection

| Tier | File | Lines |
|------|------|-------|
| T2 | anti-drift.md | ~45 |
| T2 | known-bad-patterns.md | ~48 |
| T3 | slide-rules.md | ~55 |
| T3 | design-reference.md | ~35 |
| T3 | qa-pipeline.md | ~35 |
| T4 | slide-advanced-reference.md | ~120 |
| **Rules total** | **5 files** | **~218** |
