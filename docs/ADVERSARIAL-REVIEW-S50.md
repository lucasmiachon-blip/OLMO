# Adversarial Review — S50

> Reviewer: GPT-5.4 (Codex) | Orchestrator: Opus 4.6 | Date: 2026-04-02
> Coautoria: Lucas + Opus 4.6 + GPT-5.4

## Summary

- **17 files reviewed** across 6 domains (Python, JS, CSS, Rules/Skills, Shell hooks, Docs)
- **118 findings** total
- CRITICAL: 9 | HIGH: 61 | MEDIUM: 36 | LOW: 12

| File | CRIT | HIGH | MED | LOW | Verdict |
|------|------|------|-----|-----|---------|
| `agents/core/mcp_safety.py` | 2 | 3 | 1 | 0 | FAIL |
| `agents/core/smart_scheduler.py` | 0 | 2 | 3 | 1 | WARN |
| `agents/core/orchestrator.py` | 1 | 3 | 2 | 0 | FAIL |
| `content/aulas/shared/js/deck.js` | 0 | 3 | 2 | 2 | WARN |
| `content/aulas/shared/js/engine.js` | 0 | 2 | 1 | 1 | WARN |
| `content/aulas/shared/js/case-panel.js` | 0 | 2 | 2 | 1 | WARN |
| `content/aulas/shared/css/base.css` | 0 | 3 | 3 | 1 | WARN |
| `content/aulas/metanalise/metanalise.css` | 0 | 1 | 1 | 3 | PASS |
| `.claude/rules/slide-rules.md` | 0 | 8 | 2 | 0 | WARN |
| `.claude/rules/design-reference.md` | 0 | 4 | 6 | 0 | WARN |
| `.claude/skills/medical-researcher/SKILL.md` | 2 | 5 | 4 | 1 | FAIL |
| `.claude/hooks/guard-product-files.sh` | 0 | 4 | 0 | 0 | FAIL |
| `.claude/hooks/guard-secrets.sh` | 2 | 3 | 2 | 1 | FAIL |
| `content/aulas/scripts/validate-css.sh` | 1 | 5 | 3 | 0 | FAIL |
| `content/aulas/scripts/pre-commit.sh` | 0 | 5 | 2 | 2 | FAIL |
| `CLAUDE.md` (root) | 0 | 4 | 2 | 0 | WARN |
| `docs/ARCHITECTURE.md` | 1 | 6 | 2 | 0 | FAIL |

---

## Cross-Cutting Patterns

### P1: Security Theater (4 instances)

Gates that exist but don't actually protect:

1. **`orchestrator.py`**: `validate_mcp_step()` is defined but never called in `route_task()` or `run_workflow()` — MCP safety is dead code
2. **`validate-css.sh`**: Increments `WARN` not `FAIL` — always exits 0, pre-commit never blocks
3. **`guard-secrets.sh`**: Scans working-tree files, not staged blobs — secrets can slip through
4. **`guard-product-files.sh`**: Fail-open on parse errors — broken input = no protection

### P2: Working-Tree vs Staged Blob (3 instances)

Same structural bug in 3 independent scripts:

- `guard-secrets.sh` (CRITICAL)
- `pre-commit.sh` (HIGH)
- `validate-css.sh` (HIGH)

All scan the file on disk instead of `git show ":$file"`. A user can stage a bad file, clean the working copy, and commit — the hook sees the clean version.

### P3: Fail-Open Design (4 instances)

Errors cause the safety system to permit rather than block:

- `mcp_safety.py`: `confidence=NaN` bypasses all thresholds → auto-allow
- `guard-product-files.sh`: Parse error → exit 0 (allow)
- `smart_scheduler.py`: Corrupted budget.json → reset to zero usage
- `validate-css.sh`: Regex failures → no exit code change

### P4: Documentation Drift (5+ instances)

Docs describe a system that no longer matches reality:

- `CLAUDE.md`: Missing living HTML workflow, stale CI command, wrong hook counts
- `ARCHITECTURE.md`: Workflows YAML is aspirational not executable, context isolation is false, missing notion_cleaner
- `slide-rules.md`: stage-c token restoration not enumerated, timing contradictions
- `design-reference.md`: E21 checklist incomplete, verification vocabulary missing RETRACTED/SUPERSEDED
- `TREE.md`: Stale counts for rules, hooks, skills

---

## Findings by File

### 1. agents/core/mcp_safety.py (2 CRIT, 3 HIGH, 1 MED)

| # | Sev | Lines | Issue |
|---|-----|-------|-------|
| 1 | CRIT | 131-138, 182-187 | Unknown ops escape hard-block via `batch_size>5` (human review instead of block) |
| 2 | CRIT | 150-180 | `confidence=NaN` bypasses all thresholds — falls through to ALLOW |
| 3 | HIGH | 91-95, 123-129 | `mode` not validated as enum — string "read_only" bypasses write-block |
| 4 | HIGH | 190-203 | `validate_move()` ignores page_id and target_parent_id entirely |
| 5 | HIGH | 94-95, 132-147 | Negative batch_size/page_age_days bypass gates |
| 6 | MED | 48-60, 182-187 | Write allowlist may be out of sync with actual API operation names |

### 2. agents/core/smart_scheduler.py (0 CRIT, 2 HIGH, 3 MED, 1 LOW)

| # | Sev | Lines | Issue |
|---|-----|-------|-------|
| 1 | HIGH | 121-127, 139-145 | Non-atomic check-then-increment — concurrent callers can overspend budget |
| 2 | HIGH | 93-96, 101-102 | budget.json write non-atomic — crash resets counters to zero |
| 3 | MED | 171-176 | Malformed cache metadata can crash scheduling |
| 4 | MED | 173-180 | Concurrent cache cleanup raises FileNotFoundError |
| 5 | MED | 273-276 | `get_next_tasks()` ignores weekly limit |
| 6 | LOW | 295 | cache_files count can go negative |

### 3. agents/core/orchestrator.py (1 CRIT, 3 HIGH, 2 MED)

| # | Sev | Lines | Issue |
|---|-----|-------|-------|
| 1 | CRIT | 47-48, 62-66, 108-110 | **`validate_mcp_step()` is never called** — MCP safety gate is dead code |
| 2 | HIGH | 47-48, 63-65 | Explicit agent routing skips model resolution |
| 3 | HIGH | 31, 63-66 | Shared `agent.model` mutation — cross-task routing races |
| 4 | HIGH | 108-110 | Workflow execution has no exception boundary |
| 5 | MED | 75-89 | Status is always reset to IDLE in finally (hides ERROR state) |
| 6 | MED | 45-48, 61-66 | Unknown agent names silently fall through to type-based routing |

### 4. content/aulas/shared/js/deck.js (0 CRIT, 3 HIGH, 2 MED, 2 LOW)

| # | Sev | Lines | Issue |
|---|-----|-------|-------|
| 1 | HIGH | 41-57 | Stale transitionend can dispatch slide:entered for wrong slide on rapid nav |
| 2 | HIGH | 15, 116-146 | `initDeck()` not idempotent — double init doubles all handlers |
| 3 | HIGH | 137 | Viewport click-to-advance hijacks interactive slide content |
| 4 | MED | 50-57 | Slides without CSS transition leak transitionend listeners |
| 5 | MED | 77-102 | Keyboard shortcuts fire while typing in inputs |
| 6 | LOW | 149-153 | Zero-sized viewport → scale(0), deck invisible |
| 7 | LOW | 125-133 | slide-id-label is dev artifact shipped to production |

### 5. content/aulas/shared/js/engine.js (0 CRIT, 2 HIGH, 1 MED, 1 LOW)

| # | Sev | Lines | Issue |
|---|-----|-------|-------|
| 1 | HIGH | 170, 184-196 | prefers-reduced-motion returns without showing final state — content invisible |
| 2 | HIGH | 169, 217-225, 257 | Timer cleanup is global — kills new slide's timers too |
| 3 | MED | 73-75, 144-148 | drawPath misses direct `<line>`/`<polyline>` + forceAnimFinalState incomplete |
| 4 | LOW | 170 | Reduced-motion snapshotted once, not reactive to OS changes |

### 6. content/aulas/shared/js/case-panel.js (0 CRIT, 2 HIGH, 2 MED, 1 LOW)

| # | Sev | Lines | Issue |
|---|-----|-------|-------|
| 1 | HIGH | 196-200, 320-337 | Stale calc result stays visible when input cleared |
| 2 | HIGH | 229-255, 320-340, 358-416 | Missing dialysis Cr override (OPTN: Cr=4.0/3.0) |
| 3 | MED | Multiple | Non-physiologic input (negative, extreme) silently accepted |
| 4 | MED | Multiple | innerHTML with state values — XSS sink |
| 5 | LOW | 308 | Antonio case albumin 3.6 clamped to 3.5 without UI feedback |

### 7. content/aulas/shared/css/base.css (0 CRIT, 3 HIGH, 3 MED, 1 LOW)

| # | Sev | Lines | Issue |
|---|-----|-------|-------|
| 1 | HIGH | 99-101, 133-148 | OKLCH fallback omits shadow/overlay tokens — borders/shadows break |
| 2 | HIGH | 55, 60, 65, 71, 76 | color-mix() achromatic endpoint (E059) still present in all light tints |
| 3 | HIGH | 356-360 | Stage B fallback incomplete — misses [data-reveal], .fragment, inline opacity |
| 4 | MED | 42, 133-148 | --bg-black missing from @supports not fallback |
| 5 | MED | 395, 596 | Print mode: html overflow still hidden |
| 6 | MED | 607 | Print .fragment: opacity reset but not transform |
| 7 | LOW | 604 | page-break-after on last slide creates blank trailing page |

### 8. content/aulas/metanalise/metanalise.css (0 CRIT, 1 HIGH, 1 MED, 3 LOW)

| # | Sev | Lines | Issue |
|---|-----|-------|-------|
| 1 | HIGH | 698-705, 843-848, 958-999 | stage-bad fallback missing for checkpoint hidden states |
| 2 | MED | 702-705, 958-966, 986-999 | QA mode does not reveal checkpoint 2 steps/verdict |
| 3 | LOW | 610-621 | subgrid used without fallback |
| 4 | LOW | 229-235 | Empty no-JS rule is dead code |
| 5 | LOW | 6-10 | Redundant aside.notes hide rule |

### 9. .claude/rules/slide-rules.md (0 CRIT, 8 HIGH, 2 MED)

| # | Sev | Section | Issue |
|---|-----|---------|-------|
| 1 | HIGH | S10 | stage-c "8 token restoration" never enumerated |
| 2 | HIGH | S10 | Navy slides inside light (stage-c) themes not covered |
| 3 | HIGH | S10 | Token restoration scope only for full-slide navy, not navy components |
| 4 | HIGH | S10 | Missing: which 8 tokens must be re-declared |
| 5 | HIGH | S3 vs S6 | countUp duration contradicts: 1.5s (S3) vs 800-1200ms (S6) |
| 6 | HIGH | S1 | "NUNCA inline style" vs inline opacity:0 for GSAP init is ambiguous |
| 7 | HIGH | S12 | Bootstrap checklist incomplete vs actual template wiring |
| 8 | HIGH | S9 | CSS vs GSAP jurisdiction boundary not exhaustive |
| 9 | MED | S5 | E-code catalog has gaps — undocumented patterns can bypass rules |
| 10 | MED | S4 | click-reveal max 4 — no rule for what happens with >4 |

### 10. .claude/rules/design-reference.md (0 CRIT, 4 HIGH, 6 MED)

| # | Sev | Section | Issue |
|---|-----|---------|-------|
| 1 | HIGH | E21 | Checklist missing: study design, primary outcome, effect measure, population match |
| 2 | HIGH | PMID | Verification only checks author+title+n — same trial can have multiple papers |
| 3 | HIGH | Vocab | Missing terminal states: RETRACTED, SUPERSEDED, DISPUTED |
| 4 | HIGH | NNT | NNT without ARR/baseline risk = non-portable across populations |
| 5 | MED | Tier 1 | EASL 2024 and AASLD 2024 have DOI: TBD — unresolvable references |
| 6 | MED | Color | Danger hue <=10 needs wrap-around (350-360 is also red in OKLCH) |
| 7 | MED | Color | No chroma floor for safe/warning/downgrade tokens |
| 8 | MED | Color | "HEX is truth" resolution protocol incomplete for derived tokens |
| 9 | MED | Color | color-mix() armadilha documented but no safe recipe specified |
| 10 | MED | Brazil | Non-Brazil evidence not required to be labeled as external |

### 11. .claude/skills/medical-researcher/SKILL.md (2 CRIT, 5 HIGH, 4 MED, 1 LOW)

| # | Sev | Step | Issue |
|---|-----|------|-------|
| 1 | CRIT | S1/S3 | NNT forced as universal metric — invalid for HR, non-binary, ARR=0 |
| 2 | CRIT | S2.2 | No retraction/editorial-notice check before VERIFIED |
| 3 | HIGH | S2.1 | Cross-reference accepts downstream repeats as "independent" |
| 4 | HIGH | S2.2 | PMID-only verification — no DOI or web-document path |
| 5 | HIGH | S2.4 | Population match criteria too narrow for hepatology |
| 6 | HIGH | S1-T | n>100 filter can miss pivotal smaller RCTs |
| 7 | HIGH | Gates | PMID/DOI gate conflicts with society webpages and PCDT sources |
| 8 | MED | S3 | Depth rubric and adequacy gate internally inconsistent |
| 9 | MED | MCP | Fallback chain undefined for verification failures |
| 10 | MED | Hierarchy | UpToDate/DynaMed extracted but not ranked in source hierarchy |
| 11 | MED | Anti-patterns | Missing: subgroup analysis, surrogate endpoints, preprints, retracted |
| 12 | LOW | S1-M | Forest plot prohibition stated but not enforced |

### 12. .claude/hooks/guard-product-files.sh (0 CRIT, 4 HIGH)

| # | Sev | Lines | Issue |
|---|-----|-------|-------|
| 1 | HIGH | 10+ | SPRINT_MODE env var injection disables all guards |
| 2 | HIGH | 26-74 | No path canonicalization — ../ bypasses |
| 3 | HIGH | 26-80 | Symlinks/junctions bypass path checks |
| 4 | HIGH | 6-84 | Fail-open on parse errors |

### 13. .claude/hooks/guard-secrets.sh (2 CRIT, 3 HIGH, 2 MED, 1 LOW)

| # | Sev | Lines | Issue |
|---|-----|-------|-------|
| 1 | CRIT | 34, 49, 54, 60 | Scans working-tree instead of staged blob |
| 2 | CRIT | 34, 42, 49 | Filenames with spaces break word-splitting — silently skipped |
| 3 | HIGH | 22-31 | Missing providers: Anthropic, Google AIza, Azure, Slack, Stripe, GitHub PAT |
| 4 | HIGH | 43, 55-57 | .env files not handled separately |
| 5 | HIGH | 22-31 | No database connection string detection |
| 6 | MED | 22-31 | No base64-encoded secret detection |
| 7 | MED | 24, 54, 60 | Bearer token regex too narrow |
| 8 | LOW | 25 | Private keys only via -----BEGIN marker |

### 14. content/aulas/scripts/validate-css.sh (1 CRIT, 5 HIGH, 3 MED)

| # | Sev | Lines | Issue |
|---|-----|-------|-------|
| 1 | CRIT | 132-137 | Violations increment WARN not FAIL — script always exits 0 |
| 2 | HIGH | 27, 33-35 | CRLF line endings break import order checks |
| 3 | HIGH | 27 | Grep matches inside comments; misses double-quoted imports |
| 4 | HIGH | 63-66 | Anchored regex misses indented selectors in @media |
| 5 | HIGH | 67-75 | Duplicate detection ignores at-rule context |
| 6 | HIGH | 107 | Comment filtering broken by grep -n line prefixes |
| 7 | MED | 99-100 | !important backward scan not block-aware |
| 8 | MED | 63-66 | BOM-prefixed first lines break selector matching |
| 9 | MED | 67-75 | Comma-separated selectors counted incorrectly |

### 15. content/aulas/scripts/pre-commit.sh (0 CRIT, 5 HIGH, 2 MED, 2 LOW)

| # | Sev | Lines | Issue |
|---|-----|-------|-------|
| 1 | HIGH | 2-5, 13, 52 | Branch guard doesn't block commits on main — only skips gates |
| 2 | HIGH | 15-21, 46-47 | Aula detection trivially bypassed via branch naming |
| 3 | HIGH | 22-28 | Reads working-tree instead of staged index |
| 4 | HIGH | 11-12, 24-28 | Regression baseline has no historical reference |
| 5 | HIGH | 53-56 | Integrity gate accepts any .slide-integrity regardless of aula |
| 6 | MED | 24, 28 | grep -c exit code 1 on zero matches causes fallback bug |
| 7 | MED | 83-91 | CRLF not stripped from .ghost-canary lines |
| 8 | LOW | 22, 25, 80, 120, 125 | Assumes repo root cwd — no git rev-parse guard |
| 9 | LOW | 1-5 | --no-verify bypass undocumented |

### 16. CLAUDE.md root (0 CRIT, 4 HIGH, 2 MED)

| # | Sev | Section | Issue |
|---|-----|---------|-------|
| 1 | HIGH | Architecture | Missing notion_cleaner subagent |
| 2 | HIGH | Conventions | CI command stale — omits mypy (real gate is `make check`) |
| 3 | HIGH | Conventions | Path-scoped rules list incomplete — missing slide-rules, qa-pipeline |
| 4 | HIGH | Aulas | Missing living HTML / evidence-first workflow |
| 5 | MED | Key Files | Hook counts stale (2 vs 4 root, 7 vs 4 active .claude/hooks) |
| 6 | MED | Misc | TREE.md presented as authoritative but stale |

### 17. docs/ARCHITECTURE.md (1 CRIT, 6 HIGH, 2 MED)

| # | Sev | Section | Issue |
|---|-----|---------|-------|
| 1 | CRIT | Workflow Engine | YAML workflows are aspirational, not executable — route_task() can't run most step types |
| 2 | HIGH | Orchestrator-Workers | Claims subagent context isolation — not implemented |
| 3 | HIGH | Diagram | Missing notion_cleaner in hierarchy |
| 4 | HIGH | Skills | Skills inventory stale, .claude/skills/ includes non-production dirs |
| 5 | HIGH | Per-Project | Still references old organizacao/ topology with wrong counts |
| 6 | HIGH | Aulas | Missing metanalise deck and Living HTML pipeline |
| 7 | HIGH | Efficiency | Model routing tiers don't match model_router.py or rate_limits.yaml |
| 8 | MED | MCP/Workflows | Integration names don't match servers.json |
| 9 | MED | Aulas | Living HTML transition has no ADR-style rationale |

---

## Lucas + Opus Assessment

> [A ser preenchido apos revisao conjunta]

### Categorias de acao sugerida:

**Corrigir imediatamente (CRITICAL + security theater):**
- [ ] mcp_safety.py: NaN guard + unknown-op ordering
- [ ] orchestrator.py: wire validate_mcp_step() into route_task()
- [ ] guard-secrets.sh: scan staged blob, fix word-splitting
- [ ] validate-css.sh: increment FAIL not WARN
- [ ] medical-researcher: NNT constraints + retraction check

**Corrigir antes do deadline metanalise (2026-04-15):**
- [ ] deck.js: transitionend race condition, click hijack
- [ ] engine.js: prefers-reduced-motion visibility, timer scoping
- [ ] base.css: OKLCH fallback completeness, E059 color-mix
- [ ] pre-commit.sh: scan staged, branch guard fix

**Corrigir quando oportuno:**
- [ ] case-panel.js: dialysis override, stale result display
- [ ] slide-rules.md: enumerate 8 tokens, fix timing contradiction
- [ ] design-reference.md: expand E21, add RETRACTED status
- [ ] CLAUDE.md: add living HTML, fix CI command
- [ ] ARCHITECTURE.md: align with implementation

---

*Generated 2026-04-02 | Coautoria: Lucas + Opus 4.6 + GPT-5.4 (Codex)*
