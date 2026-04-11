# INFRA-PESADO (S155) — Simple Plan

> Lucas + Opus 4.6 + Gemini 3.1 (3 calls) + Codex (2 batches)
> 2026-04-11

## Why
Context auto-load is too big. Tonight: adversarial review (Opus + Gemini + Codex) to find infra bloat and fix obvious wins. Defer anything that requires new hooks/triggers/infra.

## Backlog gate (Lucas's rule, governs the whole session)

**High complexity + low ROI = backlog, even if useful.** Applies to:
- The plan itself (cut ceremony unless it earns its keep)
- Findings from Gemini/Codex (orchestrator triages BEFORE presenting to Lucas)
- New work that emerges mid-session

Concrete test for each finding: `if (estimated_commits > 1) AND (loc_saved < 50) AND (touches_runtime == true): → backlog`. Backlog goes to `HANDOFF.md` BACKLOG table at wrap, not lost.

## Scope

**In:** `settings.local.json` · skill+agent descriptions · rules · KBPs · memory files · hooks dead code

**Out (hard firewall — drop any finding touching these):**
- `content/aulas/slides/**`, `content/aulas/evidence/**`, `content/aulas/{aula}.css`, `content/aulas/{aula}/references/**`
- `content/aulas/scripts/gemini-qa3.mjs` (the hammer — don't refactor it during the hammer session)
- `docs/aulas/design-principles.md`
- `.claude/agent-memory/**` (evidence-researcher notes)
- `CHANGELOG.md` (append-only)
- Notion data, HTML build artifacts
- `h2` headers in any slide (Lucas's work)

## The 5 steps

### 1. Dispatch (~15 min wall)

**Gemini 3.1 Pro × 3 parallel** via inline `curl` (no script — orchestrator fires 3 background `curl` calls and waits for all):

| Call | Dimension | Input scope |
|------|-----------|-------------|
| G1 | Permissions garbage | Full `.claude/settings.local.json` (503 LOC) |
| G2 | Description sprawl | Frontmatter (≤8 lines each) of all 19 `skills/*/SKILL.md` + 10 `agents/*.md` |
| G3 | Rules + KBPs + memory dedup | 6 always-loaded rules + 14 KBPs + 20 memory topic files |

**Codex × 2 sequential** via `Skill("codex:rescue")`:

| Call | Purpose |
|------|---------|
| C1 | Cross-file duplication (validate G3's claims, find passages I missed) |
| C2 | Hook dead code (orphans in `hooks/` + `.claude/hooks/` not referenced anywhere) |

C1+C2 fire **after** G1-G3 return so Codex has Gemini findings to validate adversarially.

### 2. Read findings together (~10 min)
Orchestrator paste-presents Gemini outputs + Codex outputs side-by-side, grouped by surface. No scoring algorithm — just visual comparison. Where Gemini and Codex agree = high confidence. Where they disagree = Lucas decides.

### 3. Lucas approves obvious wins (~20-40 min)

**Adaptive granularity (Lucas's choice):**
- **Batch approve** (with override list): permissions garbage deletes, description compressions
- **Per-finding approve** (KBP-10 strict): rule merges, hook deletes, anything touching always-loaded files

**Send to backlog automatically** (orchestrator drops these before showing Lucas — backlog gate):
- Anything requiring new hooks / trigger detection / MCP startup changes
- Anything where rollback isn't a single `git revert`
- Anything `>1 commit` AND `<50 LOC saved`
- Anything "useful but engineered"

### 4. Execute approved (~30-60 min)
- One concern per commit
- Verify after each: settings.local.json → `jq .`; rules → re-read; hooks → grep callers; build → `npm run build:metanalise` after rule merges only
- Two consecutive verification fails → **STOP** and report (KBP-07)

### 5. Wrap (~15 min)
- `CHANGELOG.md` (append) + `HANDOFF.md` (replace state)
- Memory save (post-plan-mode action): extend `feedback_anti-sycophancy.md` with Lucas's "you be the professional" + "complexity-as-ceremony" lesson (~3 lines, fits via 3-line test)
- Possible new KBP-15 if a pattern emerged
- Cleanup `.claude/tmp/g{1..3}-result.md` and Codex tmp outputs

## Payload sizing (HARD constraints — KBP-11 + KBP-12 + Lucas's directive)

**Gemini calls:**
- `maxOutputTokens: 32768`, `thinkingBudget: 16384` (KBP-11 — without this, returns are empty)
- Temperature 0.2 (audit tasks)
- Input target ~25K chars, hard ceiling 40K
- **Output schema suffix on every prompt** (KBP-12):
  ```
  Output as Markdown table with columns:
  | ID | Surface | Finding | Confidence(H/M/L) | Action | LOC_saved | Risk(H/M/L) |
  NO INTRODUCTIONS. NO PREAMBLE. NO SUMMARY. ONLY THE TABLE.
  Cap at top 15 rows by ROI. If no findings: | — | — | NO FINDINGS | — | — | 0 | — |
  ```
- **Empty return → STOP and ask Lucas** (KBP-07 anti-workaround). No multi-step retry pipeline; one report, Lucas decides.

**Codex batches:**
- Max 15 files OR 2,500 LOC per batch (whichever hits first)
- Same 7-column output schema for easy merge with Gemini

## Out of plan-mode actions (after ExitPlanMode)

These are NOT executed inside this plan, but I owe Lucas a record of them. They go to **memory files**, NOT to new KBPs (per Lucas governance: KBP-15 only if genuinely novel AND not mappable to a well-known systems-engineering pattern; otherwise reference the existing pattern and extend memory).

**Three Lucas directives from this plan-mode conversation, with their systems-eng analogues:**

1. **"Você seja o profissional, não seja cego às minhas diretivas"** ↔ Anti-Sycophancy / Devil's Advocate / Challenge-the-Brief. Push back on user directives when suboptimal; don't be blind. Save target: extend `feedback_anti-sycophancy.md` Regra 2 to cover *user* anti-sycophancy in addition to *inter-model*.

2. **"Complexity-as-ceremony"** ↔ YAGNI ("You Aren't Gonna Need It") / KISS / Worse-Is-Better. When an intermediary agent (Plan/Codex/Gemini) returns competent-sounding elaboration, ask "is this what was asked?" before adopting. Save target: extend `feedback_anti-sycophancy.md` (intermediate-agent bias is just inter-model bias one layer in).

3. **"Backlog gate"** ↔ RICE scoring / Cost-of-Delay / 80-20 Pareto. High complexity + low ROI = backlog, even if useful. Lucas's exact framing: *"embora útil para nosso projeto fica para backlog"*. Save target: extend `patterns_antifragile.md` as a new layer ("L8: backlog as antifragile filter") OR extend `feedback_teach_best_usage.md` (about ambition calibration).

**KBP-15 decision:** *DO NOT FILE* unless a finding from this session itself reveals a brand-new anti-pattern with no prior literature. The three directives above all have prior literature → memory extension, not new KBP. Only if Gemini/Codex surfaces something genuinely novel during dispatch.

## Critical files

**Read-heavy (Phase 1):**
- `C:\Dev\Projetos\OLMO\.claude\settings.local.json`
- `C:\Dev\Projetos\OLMO\.claude\skills\**\SKILL.md` (19)
- `C:\Dev\Projetos\OLMO\.claude\agents\*.md` (10)
- `C:\Dev\Projetos\OLMO\.claude\rules\*.md` (11)
- `C:\Dev\Projetos\OLMO\hooks\*.sh` + `C:\Dev\Projetos\OLMO\.claude\hooks\*.sh`
- `C:\Users\lucas\.claude\projects\C--Dev-Projetos-OLMO\memory\*.md` (20)

**Possible writes (Phase 4 — only if Lucas approves):**
- Same set + `HANDOFF.md` + `CHANGELOG.md`

**DO NOT touch:** anything in `Scope out` above.

## Verification (end-to-end)

1. After each commit: file-specific check (`jq .` for JSON, `git diff --check` for whitespace, `npm run build:metanalise` after rule merges)
2. End of session: `git log --oneline S155-baseline..HEAD` shows clean commit history
3. Manual eyeball: re-launch a fresh session, check `<system-reminder>` baseline blocks for visible reduction

## Risks (live, mitigated)

| Risk | Mitigation |
|------|------------|
| Empty Gemini return | STOP + ask Lucas (KBP-07) |
| Findings overflow | Top-15 cap in G1-G3 prompts + backlog gate triages BEFORE Lucas review |
| Build breaks after rule merge | `npm run build:metanalise` after each rule change |
| Scope creep into slides | Out-of-scope firewall drops findings before Lucas sees them |
| Session > 2.5h | Hard checkpoint: stop dispatch, push remaining to backlog, wrap |

## Estimated total
**~1.5 to 2.5 hours.** Hard cap at 2.5h. Gemini/Codex cost: ~$1-2.

## Open questions
**None.** Decisions baked in:
- 3 Gemini + 2 Codex (Opus engineering judgment — keeps payload safe)
- Inline curl, no dispatcher script (simpler than `.mjs`)
- Adaptive batch/per-finding approval (Lucas)
- Scope: in/out lists above (Lucas + firewall)
- Anything "engineered" (lazy-load, MCP conditional) defers to another night

---

*If anything here still feels too elaborate, say so before I exit plan mode and I'll cut more.*
