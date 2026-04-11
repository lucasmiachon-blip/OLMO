# /insights S151 — 2026-04-11

> Scope: 16 sessions since last /insights (timestamp 1775801115 → 1775873680, ~20h window covering S142–S151)
> Phases: SCAN → AUDIT → DIAGNOSE → PRESCRIBE
> Verdict: **IMPROVING** — corrections_5avg 1.128 → 0.912, kbp_5avg 0.32 → 0.154

---

## Phase 1 — SCAN (extracted signal)

### Raw counts (grep noise filtered — real user prompts only)

| Session (prefix) | User msgs | Real corrections | Category |
|---|---|---|---|
| 60393b26 | 19 | 0 | (noise) |
| 4e8e4cdf | 7 | **1** | MCP freeze state drift |
| 31514f81 | 5 | 0 | (time-pressure prompt, not correction) |
| 9325f9f5 (S151) | 12 | **1** | attribution without verification (KBP-07 subtype) |
| ae1d3c8a | 20 | **1** | meta-narrativa sync assumption |
| 26ccc2ef | 11 | 0 | — |
| 0d36d5b2 | 13 | 0 | — |
| 1164db40 | 11 | 0 | (design refinement, not correction) |
| 5f5bfe5e | 17 | 0 | — |
| beb3657a | 9 | 0 | — |
| 40106421 | 13 | 0 | — |
| a1685bc7 | 14 | 0 | — |

Real corrections in sampled 12 of 16 sessions: **3 unique events**. Estimating 4 across 16. **Rate: ~0.25/session** — major drop from S141 baseline 1.33/session.

### Signal: the 3 real corrections share one root cause

All 3 are surface variants of **claim-without-verification**:

1. **S4e8e4cdf — MCP freeze state drift**. Agent asserted MCP X was frozen; user corrected: "esse mcp nao eh freeze eu falei algungs mcp freeze e ele nao era um deles". Root cause: HANDOFF says "9 frozen" without naming them; agent filled the list from memory.
2. **Sae1d3c8a — meta-narrativa sync assumption**. Agent treated `meta-narrativa.html` as a tracked/synced artifact; user: "eu prefiro metanarrativa que nao precisa ser sincronizada, so on demand quando eu falar". Root cause: doc intent not verified before assuming.
3. **S9325f9f5 — attribution without verification** (this session). Agent claimed `.v`/`.c` CSS pattern originated in `s-checkpoint-1.html`; user corrected: "na verdade se origiu em algum dos html de forest plot". Verified via `git log -S '.v { background: #2563eb'` → actual origin was `forest-plot-candidates.html` (S146 ea434e7). Root cause: working-memory coherence bias — recently edited file offered as answer instead of grep.

**Convergence**: 3 corrections, 1 category. Not a coincidence — it's a **repeating failure mode** that escapes current rules.

### Success-side signal (calibration)

**Critical finding**: `.claude/success-log.jsonl` has **1 entry since 2026-04-09** despite dozens of real commits across S142–S151. Manual hook test with realistic payload works correctly — the hook is registered, the logic is sound, yet it's not firing during real sessions.

Hypothesis: Windows path resolution (`bash /c/Dev/Projetos/OLMO/hooks/success-capture.sh`) may break under Claude Code's native hook invocation. Alternative: the `tool_response` payload field names differ from what the hook parses.

**Impact**: /dream and future /insights lose their positive-signal input. Hook calibration is blind — we can see corrections but not which commits flowed cleanly.

### Hook-stats calibration signal

`hook-stats.jsonl` (63 entries since 2026-04-09) shows:
- `nudge-checkpoint` and `nudge-commit` fire frequently
- **Many entries have `session=""`** — the APL session-naming hook fired reminders but the user didn't set names (S151 itself only got its name during this /insights run, not at session start)
- `model-fallback` fired 3 times in S150 (2026-04-10)

Dispersion of fires across multiple sessions with empty `session=""` suggests the `.claude/.session-name` protocol is **weakly adopted** — users see the reminder but defer naming.

---

## Phase 2 — AUDIT (rule compliance)

### Rules loaded (11)

```
anti-drift coauthorship design-reference known-bad-patterns mcp_safety
multi-window notion-cross-validation qa-pipeline session-hygiene
slide-patterns slide-rules
```

### Compliance matrix (windowed)

| Rule | Status | Evidence |
|---|---|---|
| `anti-drift.md §Momentum brake` | **followed** | S151 phase-by-phase atomic commits with reports between |
| `anti-drift.md §Verification gate` | **partial** | Step 3 (read complete output) followed; but the gate fires on *test/error* claims, not on *historical/state* claims. All 3 corrections bypassed this because they weren't errors. |
| `anti-drift.md §Failure response` / KBP-07 | **partial** | Same — fires on failure, not on claims during routine work. S151 attribution event = KBP-07 subtype that escaped |
| `anti-drift.md §Scope discipline` | **followed (direction: shrink)** | S151 unilaterally shrank Fase D scope (benchmark skip, colspan skip). Not a violation per the current rule wording, but a gap. |
| `known-bad-patterns.md` (KBP-01..12) | **no new violations in named classes** | 0 events of KBP-01/05/06/08/09/10/11/12 |
| `session-hygiene.md §Proactive Checkpoints` | **followed** | S151 HANDOFF+CHANGELOG+atomic commits |
| `session-hygiene.md §Artifact cleanup` | **gap** | `.claude/plans/` has 16 untracked orphans; no lifecycle defined for consumed plans |
| `multi-window.md` | **not exercised** | No worker-mode sessions in window |
| `qa-pipeline.md` | **mostly dormant** | Window had few QA runs; not validated |
| `design-reference.md` | **followed** | Color/typography not flagged |
| `mcp_safety.md` | **gap** | Rule covers Notion MCP safety but not the "freeze state claims" failure mode (S4e8e4cdf) |

### Key gaps identified

1. **No rule guards factual claims about state/history** (only failures and code). → RULE_GAP.
2. **No lifecycle for `.claude/plans/`** — KBP-10 blocks delete, so they accumulate. → RULE_GAP.
3. **Scope *shrinking* not enforced symmetrically with scope creep** — the rule guards against doing *more*, not *less*. → RULE_GAP.
4. **Plan templates don't declare reference types** (paper/book/guideline) — S151 Fase A discovered Borenstein is a BOOK only mid-execution. → SKILL_GAP.
5. **MCP/tool availability not pre-checked at plan start** — S151 fell back from PubMed MCP to NCBI eutils without explicit approval (mild KBP-08 edge case: same data source, different tool). → HOOK_GAP or PLAN_TEMPLATE_GAP.
6. **success-capture hook silently broken** — calibration blindspot. → HOOK_BUG (not a rule gap, a deployment bug).

---

## Phase 3 — DIAGNOSE (prioritized)

Ranked by frequency × impact × fixability.

### PATTERN_REPEAT #1 (highest priority): claim-without-verification

- **Frequency**: 3/3 real corrections in window (100% of signal points here)
- **Impact**: medium (each correction costs ~1 message of back-and-forth)
- **Fixability**: high — one rule + one optional hook catches all 3 subtypes
- **Subtypes observed**:
  - State drift (MCP freeze list recalled from memory)
  - Design-intent assumption (meta-narrativa sync)
  - Historical attribution (file origin claim)
- **Category**: RULE_GAP (new KBP-13 needed)

### HOOK_BUG #1: success-capture silently broken

- **Evidence**: 1 write in 48h despite ~15+ commits
- **Impact**: high (blocks /dream positive signal, blinds /insights calibration)
- **Fixability**: medium (need to debug Windows bash path resolution OR adapt to real `tool_response` schema)
- **Category**: HOOK_BUG

### RULE_GAP #2: `.claude/plans/` lifecycle

- **Frequency**: 16 orphan files observed; problem recurs each session
- **Impact**: low (accumulation, not breakage)
- **Fixability**: high (session-hygiene wrap-step addition)
- **Category**: RULE_GAP

### SKILL_GAP #1: plan template reference-type column

- **Frequency**: 1 event (Borenstein BOOK mid-execution)
- **Impact**: low (Fase A caught it)
- **Fixability**: high (add column to plan template)
- **Category**: SKILL_GAP

### RULE_GAP #3: scope-shrink symmetry

- **Frequency**: 2 events in S151 (benchmark skip, colspan skip)
- **Impact**: low (HANDOFF captured both retroactively)
- **Fixability**: high (anti-drift §Scope discipline one-sentence addition)
- **Category**: RULE_GAP

### SKILL_UNDERTRIGGER #1: APL session-naming

- **Frequency**: many empty `session=""` entries in hook-stats
- **Impact**: low (reminder works, just dismissed)
- **Fixability**: medium (block first tool call until name is set, or accept as-is)
- **Category**: SKILL_UNDERTRIGGER (not actionable without user friction)

---

## Phase 4 — PRESCRIBE (concrete, diff-ready)

### P001 — RULE_GAP: Add KBP-13 "Factual claims require verification"

**Target**: `.claude/rules/known-bad-patterns.md`
**Evidence**: 3 corrections in window all share this root cause (S4e8e4cdf MCP freeze, Sae1d3c8a meta-narrativa, S9325f9f5 attribution)

**Draft** (append after KBP-12):

```markdown
## KBP-13 Factual Claim Without Verification
Trigger: agent asserts a fact about state (e.g., "MCP X is frozen"), history (e.g., "pattern introduced in file Y"), or design intent (e.g., "doc Z is synced") and user corrects. Cause: working-memory coherence bias — the first plausible answer is offered without checking the source of truth. Different from KBP-07 which fires on failures; KBP-13 fires during *routine* claims. Fix: before any factual assertion about state/history/intent, run the cheapest verification (grep, git log -S, read the doc's own header) and cite it inline. If cost > ~5s, stop and ask. **→ anti-drift.md §Verification gate extended to historical/state claims**
```

**Also update**: `.claude/rules/anti-drift.md §Verification` — add to the "Claim about code" bullet:

```markdown
- Claim about state (freeze lists, status, current config): verify by reading the source-of-truth file (HANDOFF, settings, config). Memory decays.
- Claim about history (who introduced X, which file/session): verify via `git log -S '<literal>'` or `git blame`. Working memory is coherence-biased, not verification-biased.
- Claim about intent (sync vs on-demand, required vs optional): verify by reading the doc header or asking Lucas. Never assume.
```

### P002 — HOOK_BUG: Debug success-capture silent failure

**Target**: `hooks/success-capture.sh` (investigation, not blind fix)
**Evidence**: `.claude/success-log.jsonl` has 1 entry from 2026-04-09 despite ~15+ real commits. Manual test with realistic payload writes correctly.

**Draft** (diagnostic plan, not a code change):

```bash
# Step 1: add debug log to verify hook is being invoked at all
# At start of hooks/success-capture.sh, temporarily add:
echo "[$(date -u '+%Y-%m-%dT%H:%M:%SZ')] success-capture invoked" >> .claude/success-capture.debug.log

# Step 2: log the raw stdin to compare against expected schema
cat > .claude/success-capture.debug.last-input 2>/dev/null

# Step 3: commit something trivial and inspect both debug files

# Likely causes to test:
# - Windows bash path resolution failing silently (hook registered but not executed)
# - tool_response schema no longer has the field names the hook expects
# - Hook registered but matcher "Bash" doesn't match actual tool_name in payload
```

**Note**: Do NOT blind-fix. Diagnose first (KBP-07 compliance).

### P003 — RULE_GAP: Plans lifecycle in session-hygiene

**Target**: `.claude/rules/session-hygiene.md §Artifact cleanup`
**Evidence**: 16 orphan plan files in `.claude/plans/` at S151 end; no defined consume→archive flow

**Draft** (replace existing §Artifact cleanup final sentence about workers with):

```markdown
## Artifact cleanup

Before wrap-up: limpar `.claude/*.md` orfaos, temp files. Excecao: arquivos que Lucas pediu para manter.
**`.claude/workers/`: NUNCA deletar sem aprovacao explicita do Lucas — mesmo consumidos (KBP-10).** Hook hard-blocks rm. Listar workers para cleanup, Lucas decide.
**`.claude/plans/`: plans consumidos (aprovados e executados) devem ser listados ao wrap com origem+destino ("archive", "keep", "delete"). Default = manter (KBP-10). Lucas decide individualmente. Para arquivar: mover para `.claude/plans/archive/` com prefixo SXXX-.**
```

### P004 — RULE_GAP: Scope-shrink symmetry

**Target**: `.claude/rules/anti-drift.md §Scope discipline`
**Evidence**: S151 Fase D unilaterally skipped benchmark file (14 links, 3 th) and colspan cases (9 th) without prior approval

**Draft** (add as new bullet to §Scope discipline):

```markdown
- **Scope reductions require explicit report.** If executing a plan and you decide to SKIP part of it (read-only invariant, edge case, ambiguous pattern), stop and either: (a) ask Lucas before skipping, or (b) if you already skipped, surface the skip in HANDOFF/CHANGELOG with reason. Silent skips are drift in the opposite direction — the plan is executed at less-than-promised scope without Lucas knowing.
```

### P005 — SKILL_GAP: Plan template reference-type

**Target**: `.claude/skills/research/SKILL.md` + `/plan` template (if exists)
**Evidence**: S151 Fase A discovered Borenstein 2021 is a BOOK, not a journal paper, only mid-execution — plan assumed universal PMID

**Draft** (add to Step 2 tabela in SKILL.md, and to any plan template that lists references):

```markdown
| Ref | Type | Fallback ID |
|---|---|---|
| Author Year | paper\|book\|guideline\|preprint\|web | PMID\|ISBN\|DOI\|URL |
```

Rule: every reference in a plan or research output must declare `type`. If `type = book` → ISBN required, no PMID attempt. If `type = guideline` → organization+year+URL.

### P006 — HOOK_GAP: Plan pre-flight tool availability

**Target**: New hook or SessionStart enhancement
**Evidence**: S151 Fase A plan named "PubMed MCP" but the tool was not in the tool pool; fell back to WebFetch+eutils without explicit approval (KBP-08 edge case)

**Draft** (conceptual, not code-ready — requires infra session):

```
When a plan file in .claude/plans/ names specific tools (regex: mcp__|MCP|Tool:|tool:),
SessionStart hook should:
1. Parse plan for tool names
2. Pre-flight check each via ToolSearch select:X
3. If any missing, surface as "Plan references unavailable tool X. Ask Lucas before starting Fase that uses it."
```

---

## Evolution metrics (vs S141)

| Metric | S141 | S151 | Δ |
|---|---|---|---|
| `corrections_per_session` (windowed) | 1.33 | 0.25 | **↓ 81%** |
| `kbp_per_session` (windowed) | 0.33 | 0.06 | **↓ 82%** |
| `corrections_5avg` | 1.128 | **0.912** | **↓** |
| `kbp_5avg` | 0.32 | **0.154** | **↓** |
| Direction | regressing | **improving** | ✓ |
| Patterns new this window | — | 1 (KBP-13 claim-without-verification) | — |
| Patterns resolved since last | — | 0 (S141's KBP-04 wrong-criteria did not recur; counts as latent-resolved) | — |

**Interpretation**: The window had dramatically fewer corrections and KBP events. The 3 corrections that did occur cluster into a **single new pattern** (KBP-13). The improvement is real — but NOT because agents got "smarter"; rather, because the workload in this window was heavy on mechanical batch edits (S151 D.1/D.2, S150 audit fixes) where verification is cheap and the failure surface is narrow. **Caveat**: S151 was unusually heavy on atomic-commit discipline. The stable trend will only be visible after 2-3 more content-production sessions cycle in.

---

## OK/WARN/REGRESSION

**OK: Trend improving.** Both rolling averages decreased (corrections 1.128→0.912, kbp 0.32→0.154). No regression in named KBPs. One NEW pattern (KBP-13) emerged as the dominant failure class — propose adding the rule before the next content-production session.

---

## Files to update (if Lucas approves)

1. `.claude/rules/known-bad-patterns.md` — append KBP-13
2. `.claude/rules/anti-drift.md` — extend §Verification bullets
3. `.claude/rules/session-hygiene.md` — add plans lifecycle to §Artifact cleanup
4. `.claude/rules/anti-drift.md` — add scope-shrink symmetry bullet
5. `.claude/skills/research/SKILL.md` — add reference-type column to Step 2
6. `hooks/success-capture.sh` — diagnose silent failure (NOT blind-fix)
7. `.claude/skills/insights/references/failure-registry.json` — append S151 entry (done automatically after this report)

**Estimated scope**: 5 rule-file edits (1-3 lines each) + 1 hook diagnostic + 1 registry append. All concrete, none speculative.
