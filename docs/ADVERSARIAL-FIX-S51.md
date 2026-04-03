# Adversarial Review Fix Report — S51

> Session: adversarial-fix | Date: 2026-04-02
> Coautoria: Lucas + Opus 4.6

## Summary

- **Reviewed:** 118 findings from GPT-5.4 adversarial review (S50)
- **Validated:** 38 key findings against actual code via 3 parallel explore agents
- **Result:** 30 TRUE, 5 PARTIALLY TRUE, 3 FALSE POSITIVE
- **Fixed:** All confirmed findings across 3 tiers + 7 gap fixes
- **Tests:** 53 passing (47 original + 6 new NaN/negative/empty input tests)

## False Positives Discarded (3)

| # | File | Finding | Why FP |
|---|------|---------|--------|
| 1 | `mcp_safety.py` | Unknown ops escape via batch_size>5 | Unknown ops already return BLOCK before reaching batch check |
| 2 | `validate-css.sh` | Always exits 0 | Script correctly exits 1 when FAIL>0; WARNs are informational by design |
| 3 | `pre-commit.sh` | Branch guard doesn't block main | Intentional: main commits skip slide-specific gates |

## Tier 1: CRITICAL Fixes

### 1. `agents/core/mcp_safety.py` — NaN guard + input validation

**Problem:** `float('nan') < 0.95` is `False` in IEEE 754, so NaN confidence bypasses all thresholds and falls through to ALLOW. Negative batch_size/page_age_days also bypass guards. `validate_move()` ignores page_id and target_parent_id parameters.

**Fix:**
- Added `math.isnan()` + `math.isinf()` check early → BLOCK
- Added `batch_size < 0` and `page_age_days < 0` checks → BLOCK
- `validate_move()` now validates page_id/target_parent_id are non-empty

### 2. `agents/core/orchestrator.py` — wire validate_mcp_step + status bug

**Problem:** `validate_mcp_step()` existed but was never called anywhere — MCP safety gate was dead code. `finally` block always reset status to IDLE, hiding ERROR state.

**Fix:**
- `route_task()` now calls `validate_mcp_step()` for any task with `mcp_operation` key
- BLOCK → return error. NEEDS_HUMAN_REVIEW → return error requiring human approval
- `finally` now preserves ERROR state: `if self.status != AgentStatus.ERROR`

### 3. `.claude/hooks/guard-secrets.sh` — staged blob + word-splitting + patterns

**Problem:** Script scanned working-tree files (`grep "$file"`) instead of staged blobs. `for file in $STAGED` word-splits on spaces. Missing patterns for Anthropic, Google, Slack, Stripe, GitHub fine-grained, database URIs.

**Fix:**
- Replaced `grep "$file"` with `git show ":$file" | grep` (staged blob content)
- Replaced `for file in $STAGED` with `while IFS= read -r file` (safe iteration)
- Added 8 new patterns: sk-ant, AIza, xox[bpars], sk_live/sk_test, github_pat_, database URIs
- Added symlink detection in staged files (mode 120000 → BLOCK)

### 4. `.claude/skills/medical-researcher/SKILL.md` — NNT + retraction

**Problem:** NNT forced as universal metric (invalid for HR without baseline risk, non-binary outcomes, ARR=0). No retraction/editorial-notice check before VERIFIED status.

**Fix:**
- NNT marked "when applicable" with explicit exclusions (HR-only, non-binary, ARR=0)
- D7 rubric updated: accepts native metric with CI when NNT inapplicable
- Added mandatory retraction check via SCite editorialNotices or PubMed before VERIFIED
- Added 4 new verification statuses: RETRACTED, CORRECTED, SUPERSEDED, DISPUTED
- Added 4 new anti-patterns: NNT from HR without baseline, subgroup analysis, surrogate endpoints, preprints, retracted papers

## Tier 2: HIGH Fixes (deadline metanalise 2026-04-15)

### 5. `content/aulas/shared/js/engine.js` — reduced-motion + timer scoping

**Problem:** `prefers-reduced-motion` returned early without calling `forceAnimFinalState()` — content invisible for accessibility users. Timer cleanup was global — killed new slide's timers when previous slide's cleanup fired.

**Fix:**
- `forceAnimFinalState(slide)` now called for ALL early-return cases (not just print/QA)
- `activeTimers` replaced with `slideTimers` Map (keyed by slide element)
- Cleanup only clears the PREVIOUS slide's timers, not current

### 6. `content/aulas/shared/js/deck.js` — transitionend race + idempotency + click hijack

**Problem:** Rapid navigation left stale `transitionend` listeners that could dispatch `slide:entered` for wrong slide. `initDeck()` not idempotent — double call doubled all event handlers. Viewport click-to-advance intercepted clicks on interactive elements.

**Fix:**
- `activeTransitionEnd` tracks current listener; cleaned up at start of `goTo()`
- `initialized` flag prevents duplicate init
- Click handler now checks `e.target.closest('a, button, input, select, textarea, [role="button"], [data-reveal]')` — returns early for interactive elements

### 7. `content/aulas/shared/css/base.css` — OKLCH fallback + E059 + stage-bad

**Problem:** OKLCH fallback block omitted `--shadow-subtle`, `--shadow-soft`, `--overlay-border`, `--bg-black` tokens — shadows/borders break in older browsers. All 5 `color-mix()` tint definitions used achromatic endpoint `oklch(97% 0 0)` (E059 — undefined hue interpolation). Stage-bad selectors didn't cover `[data-reveal]` or `.fragment`.

**Fix:**
- Added `rgba()` fallbacks for shadow/overlay/bg-black tokens in `@supports not` block
- Replaced `oklch(97% 0 0)` with `oklch(97% 0.002 258)` in all 5 tint definitions
- Added `.stage-bad [data-reveal]` and `.stage-bad .fragment` with `!important` visibility

## Tier 3: Opportunistic Fixes

### 8. Shell scripts hardening

**validate-css.sh:**
- CRLF stripping + HTML comment exclusion in import order check
- Anchored regex now matches indented selectors inside @media blocks
- Comment filter fixed to account for `grep -n` line number prefixes

**pre-commit.sh:**
- Slide count check now reads from staged index (`git show ":$MANIFEST"`, `git ls-files`)

**guard-product-files.sh:**
- Removed SPRINT_MODE env var bypass (was fail-open by design — any parent process could disable guards)
- Fail-closed on parse errors: empty input or failed path extraction → exit 2
- Path canonicalization: resolves `../` traversals
- Refactored to use pattern array (DRY)

### 9. `agents/core/orchestrator.py` — race condition + exception boundary

**Problem:** `agent.model = resolved_model` mutated shared agent object (race condition with concurrent routing). `run_workflow()` had no per-step exception handling.

**Fix:**
- Model resolution passed via task dict (`_resolved_model` key) instead of mutating shared agent
- `run_workflow()` wraps each step in try/except, converting exceptions to TaskResult

### 10. `agents/core/smart_scheduler.py` — atomic writes + locking

**Problem:** `budget.json` write was non-atomic (crash mid-write = corrupted file → counter reset). `has_budget()` + `record_usage()` had TOCTOU race (concurrent callers could overspend).

**Fix:**
- Atomic file write: write to `.tmp`, then `os.replace()` (atomic rename)
- `threading.Lock` protects `has_budget()` and `record_usage()`

### 11. `CLAUDE.md` — docs drift

**Fix:**
- Updated test count (47 → 53)
- Updated hook counts (accurate for hooks/ and .claude/hooks/)
- Added living HTML workflow and evidence-first documentation
- Added `mypy agents/` to CI command

## Gap Fixes (from secondary review)

| Gap | Description | Status |
|-----|-------------|--------|
| 1 | deck.js click hijack on interactive elements | Fixed (closest() check) |
| 2 | drawPath on line/polyline without getTotalLength | Already guarded (line 80) — FP |
| 3 | SPRINT_MODE env var bypass in guard-product-files | Removed entirely |
| 4 | guard-secrets missing github_pat_ pattern | Added |
| 5 | guard-product-files fail-open → fail-closed | Fixed (exit 2 on parse error) |
| 6 | guard-secrets symlink check | Added (mode 120000 detection) |
| 7 | Tests for NaN/negative/empty input | Added 6 new tests |
| 8 | Visual reduced-motion verification | Manual test (not code) |

## Verification

- Python: `pytest tests/` — 53 passed
- JS/CSS: `npm run build:metanalise` — Built 18 slides OK
- Ruff: no new violations
- Git audit: running in background (separate report)

## Files Modified (16)

| File | Changes |
|------|---------|
| `agents/core/mcp_safety.py` | NaN/inf/negative guards, validate_move params |
| `agents/core/orchestrator.py` | Wire MCP gate, fix status, race condition, exception boundary |
| `agents/core/smart_scheduler.py` | Atomic writes, threading lock |
| `.claude/hooks/guard-secrets.sh` | Staged blob, word-splitting, patterns, symlink check |
| `.claude/hooks/guard-product-files.sh` | Remove SPRINT_MODE, fail-closed, path canonicalization |
| `.claude/skills/medical-researcher/SKILL.md` | NNT constraints, retraction check, new statuses |
| `content/aulas/shared/js/engine.js` | Reduced-motion fix, per-slide timer scoping |
| `content/aulas/shared/js/deck.js` | Transitionend cleanup, init guard, click hijack fix |
| `content/aulas/shared/css/base.css` | OKLCH fallback, E059 achromatic fix, stage-bad selectors |
| `content/aulas/scripts/validate-css.sh` | CRLF, comment filter, indented selectors |
| `content/aulas/scripts/pre-commit.sh` | Staged index for slide count |
| `tests/test_core/test_mcp_safety.py` | 6 new tests for input validation |
| `CLAUDE.md` | Hook counts, test count, living HTML workflow |

---

*Coautoria: Lucas + Opus 4.6 | 2026-04-02*
