# Rule Health Check — Audit Report

> Auditor: Claude Opus 4.6 (without skill guidance)
> Date: 2026-04-03
> Scope: 11 rule files in `.claude/rules/`
> Method: Cross-reference rules against project state, git history (156 commits, 53 sessions), hooks, CLAUDE.md, HANDOFF.md, CHANGELOG.md, and actual file structure.

---

## Executive Summary

| Category | Count |
|----------|-------|
| Rules audited | 11 |
| Fully compliant | 5 |
| Partially compliant (minor issues) | 3 |
| Stale / outdated | 2 |
| Gaps identified (missing rules) | 6 |

Overall health: **GOOD with localized rot.** The adversarial review sessions (S50-S52) significantly hardened the codebase. The main problem is that the rules did NOT keep pace with the evidence-first / Living HTML architectural shift (S46-S49), creating a growing disconnect between documented rules and actual workflow.

---

## Per-Rule Assessment

### 1. anti-drift.md (53 lines) -- COMPLIANT

**Status:** Actively followed. The 5-step verification gate is consistently applied in recent sessions (S50-S53 all show full test runs, lint checks, and output verification before claims).

**Evidence of compliance:**
- Recent commits show "declare intent before acting" pattern
- Adversarial review (S50-S51) is the anti-drift philosophy in action
- Verification commands run before every assertion (53 tests passing)

**Minor note:** The rule says "one concern per commit" but some commits bundle multiple concerns (e.g., S51 commit has Tier 1+2+3 fixes). This is pragmatic for review sessions but technically violates the rule.

---

### 2. coauthorship.md (27 lines) -- COMPLIANT

**Status:** Consistently followed in commits and docs.

**Evidence:**
- All 5 most recent commit bodies contain `Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>`
- HANDOFF.md footer: `Coautoria: Lucas + Opus 4.6 | 2026-04-03`
- Reference doc exists: `docs/coauthorship_reference.md`

**No issues found.**

---

### 3. design-reference.md (114 lines) -- PARTIALLY COMPLIANT (pending items)

**Status:** Core rules actively followed. HANDOFF lists 3 pending expansions.

**Compliant areas:**
- Color semantics, typography rules, NNT format, PMID verification vocabulary all in active use
- E059 achromatic fix applied (S51-S52)
- OKLCH chroma floor (0.001) applied (S52)

**Pending per HANDOFF (not yet in the rule):**
- `RETRACTED` verification status not added (HANDOFF item #5)
- E21 expansion not done
- Chroma floor not documented in rule (applied in code but rule still references E059 without the 0.001 fix)

**Staleness risk:** LOW. The core rules are accurate; the missing items are additive.

---

### 4. efficiency.md (8 lines) -- PARTIALLY COMPLIANT (aspirational)

**Status:** The rule mentions "BudgetTracker" but no such class exists in the codebase. The concept is implemented via `config/rate_limits.yaml` and `smart_scheduler.py`, but the specific instruction "Registre o custo no BudgetTracker" is a dead reference.

**What works:**
- Model routing (Ollama/Haiku/Sonnet/Opus) is configured in `config/ecosystem.yaml`
- Rate limits are defined in `config/rate_limits.yaml`
- Cache-first pattern is followed (local-first in CLAUDE.md)

**What doesn't:**
- Step 5 ("Registre o custo no BudgetTracker") references a nonexistent class
- No evidence of actual cost tracking per API call in the codebase
- Rule is 8 lines — too generic to be actionable. No specific patterns for "combine questions in 1 call."

---

### 5. mcp_safety.md (50 lines) -- COMPLIANT

**Status:** Actively followed and recently hardened (S51 NaN guard, fail-closed).

**Evidence:**
- `paths:` frontmatter correctly scopes loading to Notion/MCP contexts
- Cross-reference to `notion-cross-validation.md` works
- Reference doc `docs/mcp_safety_reference.md` exists
- S51 fixed NaN bypass and param validation in mcp_safety.py
- "MODELO HARSH" pattern is enforced (writes require human approval)

**No issues found.**

---

### 6. notion-cross-validation.md (34 lines) -- COMPLIANT (low usage)

**Status:** Rule is correct and well-scoped with `paths:` frontmatter. Cross-validation template exists at `templates/chatgpt_audit_prompt.md`.

**Note:** Low usage frequency — Notion reorganization hasn't been a recent focus (sessions 40-53 focused on aulas, adversarial review, skills). The rule is dormant but correct.

---

### 7. process-hygiene.md (43 lines) -- COMPLIANT

**Status:** Port table matches `package.json` exactly (4100/4101/4102). Kill-by-PID rule is enforced (mentioned in HANDOFF, CLAUDE.md, and memory).

**Evidence:**
- `package.json` confirms: cirrose=4100, grade=4101, metanalise=4102
- `NUNCA taskkill //IM node.exe` appears in HANDOFF, CLAUDE.md, and memory

**No issues found.**

---

### 8. qa-pipeline.md (44 lines) -- PARTIALLY COMPLIANT (low recent usage)

**Status:** The rule is well-designed (separation of attention, anti-sycophancy rubric, semantic color criteria). However, 13 metanalise slides are still pending QA (per HANDOFF), suggesting the pipeline isn't being applied at the needed velocity.

**Rule quality:** HIGH — the E068 attention separation and E069 rubric ceiling are sophisticated and well-documented.

**Compliance gap:** The rule itself is accurate, but the "Gates are sequential: BACKLOG -> DRAFT -> CONTENT -> SYNCED -> LINT-PASS -> QA -> DONE" pipeline doesn't document how Living HTML fits in. The old flow assumed evidence-db.md -> slide -> QA. The new flow is evidence HTML -> slide -> QA. The rule doesn't reflect this.

---

### 9. quality.md (8 lines) -- COMPLIANT

**Status:** Simple, well-followed. Type hints and docstring rules are verified by mypy and ruff in CI.

**Evidence:**
- `ruff check .` and `mypy agents/` are configured
- "Nao refatorar codigo que nao foi pedido" is enforced by anti-drift.md

**No issues found.** Could be merged with anti-drift.md to reduce file count.

---

### 10. session-hygiene.md (25 lines) -- COMPLIANT

**Status:** Consistently followed. HANDOFF and CHANGELOG are updated at every session with commits.

**Evidence:**
- HANDOFF.md: Session 54, ~52 lines (exceeds "max ~30 linhas" soft limit but is structured and not verbose)
- CHANGELOG.md: Append-only, most recent first, 1-line-per-change format
- Stop hook (`hooks/stop-hygiene.sh`) enforces this

**Minor deviation:** HANDOFF at 52 lines exceeds the "max ~30 linhas" guideline. The content is relevant (not verbose), but the "DECISOES ATIVAS" and "CUIDADOS" sections could be moved to CLAUDE.md or memory to trim it.

---

### 11. slide-rules.md (168 lines) -- STALE (critical)

**Status:** The largest rule file and the most important for day-to-day slide work. Core CSS/motion/structure rules are accurate, but multiple references are outdated.

**Stale elements:**

1. **`<aside class="notes">` still marked as "obrigatorio em TODO section"** (lines 31, 58) — but memory says "aside.notes deprecated — Lucas NAO usa presenter mode." This is a direct contradiction. The rule enforces something the project has deprecated.

2. **No mention of Living HTML per slide** — the evidence-first workflow (evidence HTML generated BEFORE presentation slide) is the project's most significant architectural shift since S46, yet slide-rules.md has zero references to it. A developer following this rule would not know about evidence HTML.

3. **`evidence-db.md` is not mentioned** but the associated hook (`check-evidence-db.sh`) still gates slide edits based on reading evidence-db.md, which CLAUDE.md marks as deprecated.

4. **E-codes reference** — the rule references 15+ E-codes (E07, E20, E21, E25, E26, E32, etc.) but provides no index of what each error code means. Cross-referencing requires reading `content/aulas/cirrose/ERROR-LOG.md` or similar, which is not linked.

5. **Section 12 (Bootstrap - Nova Aula)** references `aside.notes { display: none; }` as mandatory — accurate for rendering but contradicts the deprecation of aside.notes as a content workflow.

---

## Stale Artifacts (not rules, but rule-adjacent)

### check-evidence-db.sh (STALE HOOK)

**Critical finding:** This hook blocks editing `slides/*.html` unless `evidence-db.md` was read in the current session. But:
- CLAUDE.md (line 86): "`evidence-db.md` e `aside.notes` deprecated"
- Memory: "Living HTML per slide = source of truth. Substitui evidence-db.md"
- The evidence files now live at `content/aulas/{aula}/evidence/{slide-id}.html`

The hook should be updated to check for evidence HTML reads instead of evidence-db.md reads, or removed if the guard is no longer needed.

### .claude/hooks/README.md (STALE)

- Claims "8 scripts" but only 5 exist (S52 removed guard-evidence-db.sh and task-completed-gate.sh)
- Still lists the 2 removed hooks in the table
- Lists `StrReplace` in the matcher description but settings.local.json uses `Write|Edit`

---

## Gaps — Missing Rules

### GAP 1: Living HTML / Evidence-First Workflow

**Severity: HIGH**

The most significant architectural decision since S46 has NO rule. The workflow is:
1. Generate evidence HTML at `content/aulas/{aula}/evidence/{slide-id}.html`
2. THEN create/edit the presentation slide

This is documented in CLAUDE.md (1 line), HANDOFF (2 lines), and memory (3 files), but has no dedicated rule. A new session agent would not know this workflow exists unless it reads CLAUDE.md carefully.

**Recommendation:** Add to slide-rules.md Section 0 (before structure), or create a new `evidence-workflow.md` rule.

### GAP 2: Windows/Platform-Specific Conventions

**Severity: MEDIUM**

Known issues with no rule coverage:
- `encoding="utf-8"` required for all Python file I/O (Windows cp1252 default = mojibake)
- Smart App Control blocks pre-commit hooks (workaround: manual run + --no-verify)
- Path separators (forward slashes in bash hooks, backslashes in some Windows APIs)

These are documented only in memory files. A rule would prevent rediscovery.

### GAP 3: Security Gate Philosophy (fail-closed)

**Severity: MEDIUM**

S51 established that security gates must fail-closed (NaN, parse errors, empty input -> BLOCK). This is documented in memory (`patterns_fail_closed.md`) but not in any rule. It's a cross-cutting concern that affects mcp_safety.py, guard-secrets.sh, guard-product-files.sh, and any future gate.

**Recommendation:** Add a "Security Gates" section to an existing rule (anti-drift.md or a new `security.md`).

### GAP 4: Git Hook Staged-Blob Pattern

**Severity: LOW**

S51 established that git hooks must scan staged blobs (`git show :file`), not working-tree files. This is in memory (`patterns_staged_blob.md`) but not in any rule. Only relevant when writing new hooks.

### GAP 5: PMID Cross-Reference Workflow

**Severity: LOW**

The PMID verification workflow (cross-ref author + title + journal, 56% error rate from LLMs) is in design-reference.md's verification vocabulary table but the actual step-by-step procedure is only in memory (`feedback_pmid_cross_reference.md`). design-reference.md says WHAT statuses exist but not HOW to verify.

### GAP 6: Skill/Hook Count Sync

**Severity: LOW**

CLAUDE.md says "4 hooks" in `.claude/hooks/` but there are 5 (build-monitor.sh was moved). The hooks README says 8 but there are 5. No rule enforces keeping these counts synchronized. This is a docs-drift pattern.

---

## Overlap / Redundancy Analysis

| Overlap | Files | Assessment |
|---------|-------|------------|
| "NUNCA refatorar" | quality.md + anti-drift.md | Complementary, not redundant. quality.md is terse, anti-drift has context. |
| PMID verification | design-reference.md (vocabulary) + CLAUDE.md (1-liner) | Vocabulary in rule, procedure in memory. Should merge into rule. |
| Notion safety | mcp_safety.md + notion-cross-validation.md | Clean separation. mcp_safety = all MCP. cross-validation = Notion writes only. |
| Slide rules | slide-rules.md + design-reference.md + qa-pipeline.md | Largest overlap risk. All 3 load for `content/aulas/**`. Well-separated by concern (editing vs design vs QA). |

No redundancies requiring immediate action.

---

## Token Economy

Total rule tokens (approximate, at ~4 chars/token):

| File | Lines | Est. Tokens | Loads |
|------|-------|-------------|-------|
| slide-rules.md | 168 | ~1200 | content/aulas/** only |
| design-reference.md | 114 | ~850 | Always (no paths filter) |
| anti-drift.md | 53 | ~400 | Always |
| mcp_safety.md | 50 | ~350 | Notion/MCP only |
| qa-pipeline.md | 44 | ~300 | content/aulas/** + qa* |
| process-hygiene.md | 43 | ~300 | Always |
| notion-cross-validation.md | 34 | ~250 | Notion only |
| coauthorship.md | 27 | ~200 | Always |
| session-hygiene.md | 25 | ~180 | Always |
| efficiency.md | 8 | ~60 | Always |
| quality.md | 8 | ~60 | Always |
| **Total** | **574** | **~4150** | |

**Always-loaded budget:** ~1200 tokens (anti-drift + design-reference + process-hygiene + coauthorship + session-hygiene + efficiency + quality).

**Note:** design-reference.md (114 lines, ~850 tokens) has NO `paths:` frontmatter, so it loads in EVERY session. Most of its content (color semantics, NNT format, OKLCH traps) is only relevant during aula work. Adding `paths: ["content/aulas/**"]` would save ~850 tokens in non-aula sessions.

---

## Prioritized Recommendations

### P0 — Fix Now (stale = active harm)

1. **Update `check-evidence-db.sh`** to check for evidence HTML reads (`evidence/{slide-id}.html`) instead of evidence-db.md, OR disable the hook until updated.
2. **Update `.claude/hooks/README.md`** — change "8 scripts" to 5, remove the 2 deleted hooks from the table, fix matcher description.
3. **Update CLAUDE.md** — `.claude/hooks/` has 5 hooks (not 4). build-monitor.sh is in `.claude/hooks/`, not `hooks/`.

### P1 — Add Soon (gaps = preventable drift)

4. **Add Living HTML workflow to slide-rules.md** — at minimum a Section 0 that establishes evidence HTML as source of truth and precondition for slide edits.
5. **Resolve aside.notes contradiction in slide-rules.md** — either remove "obrigatorio" or clarify that `<aside class="notes">` in HTML is still required for rendering but no longer the content authoring workflow.
6. **Add `paths:` frontmatter to design-reference.md** — saves ~850 tokens per non-aula session.

### P2 — Improve (quality of life)

7. **Fix efficiency.md** — remove "BudgetTracker" dead reference, link to actual budget mechanism (`config/rate_limits.yaml`).
8. **Add fail-closed security gate pattern** to anti-drift.md or a new rule.
9. **Add Windows encoding rule** — `encoding="utf-8"` for Python file I/O.
10. **Trim HANDOFF.md** to ~30 lines by moving DECISOES ATIVAS to CLAUDE.md.

### P3 — Nice to Have

11. **E-code index** — link from slide-rules.md to error log or create a summary table.
12. **Merge quality.md into anti-drift.md** — both are always-loaded, quality.md is only 8 lines.
13. **PMID verification procedure** — expand design-reference.md or create dedicated rule.

---

## Conclusion

The rule system is well-designed and mostly followed. The primary debt is **temporal**: the Living HTML architectural shift (S46-S49) was not propagated to rules, creating a gap between what the rules say and what the project actually does. The `check-evidence-db.sh` hook is the most concrete example — it actively enforces a deprecated workflow.

The adversarial review sessions (S50-S52) dramatically improved code quality and security posture, but the rules themselves were not updated to reflect the new patterns discovered (fail-closed, staged-blob scanning, etc.). These patterns live only in memory files, which are not visible to new sessions that haven't loaded the dream memories.

Fix the P0 items first (stale hook + stale README + CLAUDE.md count). Then propagate the Living HTML workflow into the rules (P1). The rest is incremental improvement.

---

Coautoria: Lucas + Opus 4.6 | 2026-04-03
