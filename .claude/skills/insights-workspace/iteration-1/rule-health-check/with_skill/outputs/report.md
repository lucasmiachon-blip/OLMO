# Rule Health Check Report

> Generated: 2026-04-03 | Scope: 27 sessions (last 7 days, S46-S53+)
> Recipe 3: Rule Health Check (insights skill)
> First /insights run — no previous report for comparison.

---

## Compliance Matrix

| # | Rule File | Status | Detail |
|---|-----------|--------|--------|
| 1 | `anti-drift.md` | **PARTIALLY FOLLOWED** | Intent declarations present in 23/27 sessions but inconsistent density. Verification gate (5-step) compliance unclear — no systematic evidence of step-by-step execution in transcripts. |
| 2 | `coauthorship.md` | **FOLLOWED** | Co-Authored-By present in 100% of last 20 commits. Format consistent. |
| 3 | `design-reference.md` | **FOLLOWED** | `--danger` hue=8 (rule: <=10), chroma=0.22 (rule: >=0.20). E059 achromatic fix applied (chroma 0.001). PMID verification workflow active in 10+ sessions. |
| 4 | `efficiency.md` | **STALE** | References BudgetTracker, but `data/knowledge.db` does not exist. Schema defined in `agents/core/database.py` but never initialized. Rule itself is 5 generic lines — not actionable. |
| 5 | `mcp_safety.md` | **FOLLOWED** | Notion MCP used in 10 sessions with appropriate read-first patterns. No evidence of bulk automatic writes or "Always Approve" violations. Scoped correctly with `paths:` frontmatter. |
| 6 | `notion-cross-validation.md` | **FOLLOWED (low activity)** | No reorganization/archival operations detected in recent sessions. Rule is dormant but valid. Template file exists. |
| 7 | `process-hygiene.md` | **FOLLOWED** | Zero actual `taskkill //IM node.exe` executions found (all //IM mentions are rule text in system-reminders). PID-based killing used correctly. Port checking present in 3 sessions that ran dev servers. |
| 8 | `qa-pipeline.md` | **FOLLOWED** | QA pipeline terminology present in 10+ sessions. Gate sequencing, attention separation, and rubric anti-sycophancy referenced in QA-heavy sessions (S41-S42). Scoped correctly with `paths:` frontmatter. |
| 9 | `quality.md` | **PARTIALLY FOLLOWED** | Type hints and no-refactor rules generally followed. But 5 generic lines — too vague to audit compliance rigorously. |
| 10 | `session-hygiene.md` | **FOLLOWED** | HANDOFF.md current (S54, ~52 lines). CHANGELOG.md actively maintained (append-only, most-recent-first). Both updated in every session with commits. |
| 11 | `slide-rules.md` | **PARTIALLY FOLLOWED** | Metanalise: 0 inline styles (full compliance). Cirrose: 6 inline styles (minor). Grade: 1876 inline styles (pre-dates rule, needs redesign). Rule scoped correctly with `paths:` frontmatter. |

---

## Phase 3: DIAGNOSE — Prioritized Findings

### 1. [RULE_STALE] efficiency.md — BudgetTracker never materialized

**Evidence:** `config/rate_limits.yaml` defines `budget_tracker` config pointing to `sqlite:data/knowledge.db`. `agents/core/database.py` has the schema. But `data/knowledge.db` does not exist — the tracker was never initialized or used. The rule says "Registre o custo no BudgetTracker" but this is impossible.
**Root cause:** Rule was written aspirationally alongside the config. No one built the initialization pathway. Claude Code sessions use Max subscription ($0 per the CLAUDE.md), so cost tracking has low urgency.
**Category:** `RULE_STALE`
**Priority:** Low (no real cost to track at $0/session)
**Proposed fix:**
- **Target:** `.claude/rules/efficiency.md`
- **Change:** Remove BudgetTracker reference. Keep the 4 actionable principles (cache, local-first, cheapest model, batch calls). Add: "Budget tracking deferred — Max subscription eliminates per-call cost."
- **Draft:**
  ```markdown
  # Regra: Eficiencia de API

  Antes de qualquer API call:
  1. Verifique cache local primeiro
  2. Tente resolver localmente (regex, parsing, busca em arquivos)
  3. Se precisar de API, use o modelo mais barato que resolve
  4. Combine perguntas relacionadas em 1 chamada (batch)

  Budget tracking deferred — Max subscription elimina custo per-call para Claude.
  MCP calls (Gemini, PubMed) sem custo adicional. Monitorar se isso mudar.
  ```

### 2. [RULE_STALE] check-evidence-db.sh hook — references deprecated workflow

**Evidence:** `check-evidence-db.sh` in `.claude/hooks/` blocks slide edits if `evidence-db.md` was not read in the session. But `evidence-db.md` is deprecated (replaced by living HTML per slide, confirmed in HANDOFF.md, MEMORY.md, and CLAUDE.md). The hook is wired in `settings.local.json` and runs on every Write/Edit.
**Root cause:** Hook was created before the evidence-first workflow pivot (S46-S48). Never updated after deprecation.
**Category:** `RULE_STALE` + `HOOK_GAP`
**Priority:** Medium (unnecessary friction — hook fires on every slide edit for no benefit, or worse, blocks valid edits)
**Proposed fix:**
- **Target:** `.claude/settings.local.json` — remove the check-evidence-db hook entry
- **Target:** `.claude/hooks/check-evidence-db.sh` — delete or archive
- **Change:** The evidence-first workflow is now enforced by the living HTML per slide convention and the `/research` pipeline, not by a hook checking for evidence-db.md reads.

### 3. [RULE_GAP] CLAUDE.md hook count mismatch

**Evidence:** CLAUDE.md states `.claude/hooks/ → 4 hooks (guard-generated, guard-secrets, guard-product-files, check-evidence-db)` but reality is 5 hooks (includes `build-monitor.sh`). Similarly, HANDOFF.md says "5 hooks ativos e verificados" which matches reality but contradicts CLAUDE.md.
**Root cause:** CLAUDE.md was not updated when build-monitor.sh was added. Documentation drift.
**Category:** `RULE_GAP` (documentation accuracy)
**Priority:** Low (cosmetic)
**Proposed fix:**
- **Target:** `CLAUDE.md`
- **Change:** Update `.claude/hooks/` line to: `5 hooks (guard-generated, guard-secrets, guard-product-files, build-monitor, check-evidence-db)` — or 4 if check-evidence-db is removed per finding #2.

### 4. [RULE_STALE] slide-rules.md — grade aula has 1876 inline styles

**Evidence:** `content/aulas/grade/slides/*.html` contains 1876 non-opacity inline styles. The slide-rules.md explicitly says "NUNCA CSS inline no HTML. Todo layout vai no `{aula}.css`." Grade was imported via `d269150 feat: rescue grade aula (58 slides)` — before slide-rules existed.
**Root cause:** Grade aula was rescued/imported as-is from a previous system. The rule was written for new slide creation, not retroactively. The CLAUDE.md notes "precisa redesign legibilidade" but no rule exempts legacy slides.
**Category:** `RULE_STALE` (rule does not account for legacy)
**Priority:** Medium (grade aula is low priority now — metanalise is the active deadline)
**Proposed fix:**
- **Target:** `.claude/rules/slide-rules.md`
- **Change:** Add a legacy exemption note: "Grade aula (imported pre-rules) exempt until redesign. New slides in grade MUST follow these rules."
- **Draft addition after "NUNCA CSS inline no HTML" line:**
  ```markdown
  **Legacy:** grade aula (importada pre-rules) isenta ate redesign. Slides novos em grade DEVEM seguir estas regras.
  ```

### 5. [RULE_GAP] anti-drift.md verification gate — no enforcement mechanism

**Evidence:** The 5-step verification gate is the most critical anti-drift measure, but it has no hook enforcement. The agent can skip it without any automated check. Session transcripts show intent declarations (23/27 sessions) but no evidence of systematic 5-step execution.
**Root cause:** Verification is a cognitive discipline, not an automated gate. Hard to enforce via hooks (would need to parse assistant output for verification phrases).
**Category:** `RULE_GAP`
**Priority:** Medium (the rule exists and is partially followed, but the most important part — actually running the verification command — is the easiest to skip)
**Proposed fix:**
- **Target:** `.claude/rules/anti-drift.md`
- **Change:** Add a self-check prompt: "Before claiming 'Done': did I run the test? Did I read the output? State the command and result." This is cheaper than a hook and creates a textual anchor the user can spot.
- **Draft addition after step 5:**
  ```markdown
  **Self-check anchor:** Before claiming completion, state: "Verified via [command]. Output: [key result]."
  ```

### 6. [RULE_STALE] quality.md — too vague to be actionable

**Evidence:** 5 lines, all generic ("Type hints em todas as funcoes", "Sem verbosidade"). No enforcement mechanism, no examples, no connection to actual tooling (ruff, mypy, pytest). The CLAUDE.md already specifies `ruff check . | mypy agents/` which is more actionable than this rule.
**Root cause:** Written early in the project as a placeholder. Never evolved.
**Category:** `RULE_STALE`
**Priority:** Low (the CLAUDE.md conventions section covers this better)
**Proposed fix:**
- **Target:** `.claude/rules/quality.md`
- **Change:** Either expand to reference actual tooling (`ruff`, `mypy`, `pytest`) with specific examples of what triggers violations, or merge into CLAUDE.md conventions and delete the rule file. Preference: merge and delete, since CLAUDE.md already covers it.

### 7. [RULE_GAP] No rule for encoding (Windows cp1252)

**Evidence:** MEMORY.md states "Windows Python: always encoding='utf-8' in file I/O (default cp1252 = mojibake)". This was a real bug encountered and documented. But no rule enforces it — it only lives in memory.
**Root cause:** The encoding issue was discovered and documented in memory but never promoted to a rule.
**Category:** `RULE_GAP`
**Priority:** Low (memory is checked at session start, but a rule would be more durable)
**Proposed fix:**
- **Target:** `.claude/rules/quality.md` (if kept) or new section in CLAUDE.md
- **Change:** Add: "Python file I/O: always `encoding='utf-8'` (Windows default cp1252 causes mojibake)."

### 8. [RULE_GAP] No rule for skill cleanup lifecycle

**Evidence:** MEMORY.md and HANDOFF.md both note "Pending cleanup: remove old skills (evidence/, mbe-evidence/)". These skills still exist. The `evidence/` and `mbe-evidence/` skills in `.claude/skills/` are stale (superseded by `research`, `medical-researcher`, `nlm-skill`). No rule defines when/how to archive skills.
**Root cause:** Skills accumulate organically. No lifecycle rule.
**Category:** `RULE_GAP` + `SKILL_GAP`
**Priority:** Low (stale skills waste context tokens when loaded but don't cause errors)
**Proposed fix:**
- **Target:** Could add to CLAUDE.md conventions or create a skill lifecycle note
- **Change:** "Skills superseded by newer versions should be deleted, not archived. The skill-creator eval workspace preserves history."

---

## Summary Statistics

| Category | Count |
|----------|-------|
| FOLLOWED | 5 rules (coauthorship, mcp_safety, process-hygiene, qa-pipeline, session-hygiene) |
| PARTIALLY FOLLOWED | 3 rules (anti-drift, quality, slide-rules) |
| STALE | 3 findings (efficiency/BudgetTracker, check-evidence-db hook, grade inline styles) |
| GAP | 4 findings (CLAUDE.md hook count, anti-drift verification enforcement, encoding rule, skill lifecycle) |
| VIOLATED | 0 rules |

**Key insight:** The rule ecosystem is healthy overall. No rules are actively violated. The main issues are staleness (aspirational features that never materialized) and gaps (patterns documented in memory but not promoted to rules). The highest-impact fix is removing the deprecated `check-evidence-db.sh` hook, which runs on every Write/Edit for no benefit.

---

## Recommendations (priority order)

1. **Remove check-evidence-db.sh** hook from settings.local.json and delete the file (stale, runs on every edit)
2. **Update efficiency.md** — remove BudgetTracker reference, keep actionable principles
3. **Add legacy exemption** to slide-rules.md for grade aula
4. **Add self-check anchor** to anti-drift.md verification gate
5. **Update CLAUDE.md** hook count (4 → 5, or 4 after removing check-evidence-db)
6. **Delete stale skills** evidence/ and mbe-evidence/ (pending Lucas approval per HANDOFF)
7. **Merge quality.md** into CLAUDE.md conventions (or expand with tooling references)
8. **Add encoding rule** (Windows cp1252 → utf-8) to quality.md or CLAUDE.md

---

Coautoria: Lucas + Opus 4.6 | 2026-04-03
