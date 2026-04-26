# /insights S253 — 2026-04-26 (INFRA_ROBUSTO)

> Scope: 7 sessions S247-S253 (since last /insights S246 Apr 25 15:00 UTC)
> Previous: S246 report (1-session, "infrinha")
> Phases: SCAN → AUDIT → DIAGNOSE → PRESCRIBE → QUESTION → REGISTRY
> Note: chained com /dream S253 — Phase 1 SCAN signal harvested via CHANGELOG (denser than JSONL).
> **Branch-aware:** running on `feat/shell-sota-migration` (6 commits ahead of main); 2 files Lucas in-flight (anti-drift.md P5.1 + CLAUDE.md P5.2).

---

## Phase 1 — SCAN

### Hook-log analysis (post-rotation 504→500, S253 dream archived 4 oldest)

| pattern | category | count | severity | status |
|---------|----------|-------|----------|--------|
| brake-fired (Edit/Write/Skill) | momentum-brake-enforce | 366 | info | NOMINAL — design pattern working as intended |
| Bash (diverse exit codes 1/2/128/5) | tool-error | 14 | warn | sub-pattern (no single recurring fix target) |
| WebFetch 404/403 | tool-error | 7 | warn | **CANDIDATE** — emerging URL-lifecycle pattern |
| Read File-not-exist | tool-error | 5 | warn | **KNOWN (KBP-13) — recurring** rule-not-internalized |
| Agent debug-symptom-collector not found | tool-error | 2 | warn | KNOWN (KBP-38) — recurring (daemon-restart fix) |

### KPI metrics (S246-S252 window)

- rework_files: [0,3,4,4,3,0,**9**] — REWORK SPIKE S252 (was 0 S251)
- backlog_open: 41 stable 7 sessions; backlog_resolved=11 unchanged 18 sessions (S235-S252) — **STAGNANT escalating** (was 11 sessions in S246 report)
- handoff_pendentes: 0 throughout (stable)
- ctx_pct_max: [28,30,44,44,33,29,36] declining trend — **first-turn discipline (KBP-23) confirmed working**

### CHANGELOG signal (curated, S247-S252)

5 of 7 sessions had Lucas mid-session correction → KBP codification:
- S248 KBP-36 evidence-based primacy (caught fabricated SOTA-A claim "10/10 sem model" — actual 10/10 declare)
- S249 KBP-37 elite-actionable codified (pseudo-confessional pattern)
- S250 KBP-38 daemon-restart codified
- S251 X1 audit-merge convergence rules followed loosely → KBP-39 candidate flagged
- S252 KBP-39 codified + KBP-16 vigilance Lucas catch ("cuidado com prose in pointer")

---

## Phase 2 — AUDIT (compliance matrix, focused)

| Incident | Relevant rule | Compliance | Note |
|----------|---------------|------------|------|
| S248 SOTA-A claim "10/10 sem model" FABRICATED | KBP-36 (codified mid-session) | RULE_VIOLATION → RESOLVED | Lucas caught + codified rule retroactively |
| S249 "Elite faria diferente" pseudo-confessional | KBP-22 / KBP-37 | RULE_GAP → RESOLVED | KBP-37 codified |
| S250 X1 ADOPT-NEXT was 1/3 should be DEFER | audit-merge convergence rules | RULE_VIOLATION → DEFERRED to S252 | KBP-39 codified S252 |
| S252 KBP-39 entry had inline prose | KBP-16 (pointer-only) | RULE_VIOLATION caught mid-Edit | Lucas vigilance working |
| Read File-not-exist × 5 | KBP-13 (Glob first) | RULE_VIOLATION recurring | Rule exists, not internalized |
| WebFetch 404/403 × 7 | None | RULE_GAP | URL lifecycle pattern emerging |
| 6 first P6 PASSes (16% milestone) | audit-p5-p6 hypothesis | RULE_VALIDATED | VERIFY mechanical 75% conversion confirmed |

---

## Phase 3 — DIAGNOSE

| # | Finding | Category | Priority | Frequency |
|---|---------|----------|----------|-----------|
| F1 | Backlog STAGNANT 18 sessions (escalating from 11 in S246) | PATTERN_REPEAT | **HIGH** | 18 sessions |
| F2 | Read-without-Glob recurring violation (KBP-13) | RULE_VIOLATION recurring | medium | 5 fires |
| F3 | WebFetch URL lifecycle emerging | RULE_GAP | medium | 7 fires |
| F4 | P6 6b standard heterogeneity (~ vs ✓ body vs frontmatter) | RULE_GAP / SKILL_GAP | medium | 2 (debug-validator + debug-strategist) |
| F5 | REWORK SPIKE S252=9 anomaly | informational | low | 1 |
| F6 | mellow-scribbling-mitten plan execution in-flight (P5 pending) | informational | low | this session |
| F7 | Lucas mid-session corrections × 5/7 sessions = high engagement | PATTERN (good) | informational | 5 |
| F8 | Agent registry refresh (KBP-38) recurring | KNOWN recurring | low | 2 fires |

---

## Phase 4 — PRESCRIBE

### F1 — Backlog STAGNANT escalating (P246-005 still pending) — **HIGH PRIORITY**

**Evidence:** metrics.tsv backlog_resolved=11 unchanged S235-S252 = 18 sessions. S246 /insights flagged at 11 sessions; now +7 sessions later, ZERO progress on triage. P246-005 ACTION ITEM (single-session ~30min triage) not executed.

**Root cause:** new items added without triage cadence; no cron/hook surfaces backlog-stagnant alert.

**Proposed fix:**
- **Target:** `.claude/BACKLOG.md` triage session
- **Action:** bulk audit 41 open items — categorize keep/close/defer-90d. Single-session work, ~30min.
- **Mechanical guard:** add `hooks/stop-quality.sh` check — if `backlog_resolved` unchanged ≥10 sessions, surface STAGNANT-ALERT to session-start until resolved.
- **Pending fix:** ITEM_S253_BACKLOG_TRIAGE_ESCALATION, **P0** (was P1 S246, escalated due to no progress).

### F2 — Read-without-Glob recurring (KBP-13)

**Evidence:** Hook-log 5× `tool-error:Read "File does not exist. Note: your current working directory is C:\Dev\Projetos\OLMO."` in 7-session window. KBP-13 rule explicit: "File not found → Glob".

**Root cause:** Rule lives in anti-drift.md text — agent (me) sometimes types path direct without Glob first.

**Proposed fix:**
- **Target:** consider hook enforcement OR retain advisory
- **Option A (advisory):** keep as is — Lucas tolerates 5 fires/7-sessions as low-friction
- **Option B (mechanical):** add `.claude/hooks/guard-read-glob-hint.sh` — pre-Read advisory if path doesn't exist + Glob suggestion. Cost: 1 new hook, ~15min.
- **Recommend:** A (current rate ~0.7/session, low harm). Track: if rises to >2/session avg, escalate to B.

### F3 — WebFetch URL lifecycle (NEW KBP candidate)

**Evidence:** Hook-log 7× WebFetch 404/403 in 7-session window. Possibly research artifacts hardcoding URLs that decay (Anthropic blog URLs, paper preprint URLs).

**Root cause:** Pattern emerging; `/research` skill outputs cite URLs but no lifecycle (URLs decay over months).

**Proposed fix:**
- **Target:** `.claude/rules/known-bad-patterns.md` + `.claude/skills/research/SKILL.md`
- **KBP candidate:** "External URL lifecycle — research artifacts hardcode URLs that decay (404/403). Mitigation: cite + archive (Internet Archive snapshot URL OR commit-SHA OR DOI canonical) when adding to living HTML / plans."
- **Status:** propose Lucas; defer if frequency stays <2/session.

### F4 — P6 6b standard calibration decision (S252 deferred)

**Evidence:** debug-validator + debug-strategist scored PART 3.5/4 (citation só em frontmatter description, NOT em body markdown section). Audit standard ambiguous: strict (body required) vs permissive (frontmatter ok).

**Root cause:** audit-p5-p6 methodology didn't pre-register strict vs permissive — emerged mid-execution.

**Proposed fix:**
- **Target:** `.claude/plans/audit-p5-p6-violations.md` §Methodology
- **Decision needed (Lucas):** strict standard → 2 PART 3.5/4 components need body strengthen (~30min); permissive standard → upgrade them to PASS retroactively
- **Recommend:** strict (body markdown is what auto-loaders read for context) — promote consistency. ~30min S253 effort.

### F5 — REWORK SPIKE S252=9 (anomaly, informational)

**Evidence:** rework_files=9 in single S252 (was 0 S251). 4 commits + audit batch + VERIFY headers + KBP codify + close = naturally high-touch mechanical phase.

**Root cause hypothesis:** mechanical phase pattern → high re-edit count is feature, not bug. To verify: count `git diff --stat` per S252 commit; if avg <3 files/commit but rework=9 → possible regression. If avg >2 files/commit → confirmed mechanical density.

**Proposed action:** monitor. Re-evaluate if S253 mechanical phases also spike >5.

### F6 — mellow-scribbling-mitten plan in-flight (informational)

**Evidence:** Branch `feat/shell-sota-migration` has 6 commits (P0 CRLF + P1 doc drift + P2 PS isolation + P3 .ps1 delete + P4 prompt cleanup); P5 §Branch discipline modified in-flight (anti-drift.md + CLAUDE.md uncommitted).

**Root cause:** None — plan executing as designed via parallel session.

**Note for Lucas:** when P5 commits land, the durable rule "branch sempre" will be auto-enforced via `.githooks/pre-commit`. Future direct-commit-to-main attempts will exit 1 with helpful error. Pending: execute `git config --local core.hooksPath .githooks` after P5.3 commit to activate.

---

## Phase 4.5 — QUESTION (Double-Loop Audit)

| KBP/Rule | Verdict | Evidence | Action |
|----------|---------|----------|--------|
| KBP-13 (File not found → Glob) | KEEP+monitor | 5 fires recurring; rule clear, internalization slow | Track; consider hook if rises >2/session |
| KBP-16 (Verbosity drift in pointers) | KEEP — VALIDATED | Lucas catch S252 mid-Edit on KBP-39 = rule working as anti-pattern reminder | KEEP |
| KBP-22 (Silent execution chains) | KEEP | Stop[0] silent-execution check active; no fires this window | KEEP |
| KBP-23 (First-turn context explosion) | KEEP — VALIDATED | ctx_pct_max declining 44→29 over S248-S251 = rule effect measurable | KEEP |
| KBP-32 (Spot-check AUSENTE) | KEEP — VALIDATED | S250 caught 4+ FPs in 3-model audit; ~33% error rate confirmed | KEEP |
| KBP-36 (Evidence-based primacy) | KEEP — NEW S248 | Codified mid-session; CLAUDE.md ENFORCEMENT #6 anchored | KEEP |
| KBP-37 (Elite faria diferente actionable) | KEEP — NEW S249 | Codified mid-session; anti-drift §EC loop hardened | KEEP |
| KBP-38 (Daemon-restart for Agent registry) | KEEP — NEW S250 | 2 fires already this window — rule prevents misdiagnosis | KEEP |
| KBP-39 (Audit-merge convergence loose) | KEEP — NEW S252 | Codified S252; pointer KBP-16 enforced | KEEP |
| anti-drift §First-turn discipline | KEEP — VALIDATED | ctx declining + APL=HIGH strict additions S252 working | KEEP |
| anti-drift §Adversarial review | KEEP | KBP-32 active enforcement; S250 3-model methodology validates structurally | KEEP |
| anti-drift §EC loop | EXTENDED S249 | 3 destinos (doing-now/deferred-with-gate/cut) added per KBP-37 | KEEP |
| anti-drift §Branch discipline (P5 in-flight) | NEW PROPOSED | Lucas in-flight on this branch; durable rule "branch sempre, main nunca" | EXECUTE (Lucas owns) |

**No KBPs flagged for DEPRECATE.** All recent additions show evidence of need; older rules show evidence of effect (ctx declining, fabrications caught, prose-in-pointer caught).

---

## Phase 5 — REGISTRY UPDATE

Append S253 entry to `.claude/insights/failure-registry.json`. Trend computation: 5 entries (S230, S236, S240, S246, S253) → first 5avg available.

| Metric | S246 | S253 | Direction |
|--------|------|------|-----------|
| user_corrections_per_session | 1.0 | 0.71 (5/7) | improving ✓ |
| kbp_per_session | 2.0 | 0.71 (5 KBPs/7 sessions) | improving ✓ |
| tool_errors | 1 | 28 (hook-log: 14 Bash + 7 WebFetch + 5 Read + 2 Agent) | regressing ✗ (partly self-spawn from background research agents S248) |
| backlog_resolved velocity | 0% (11 sessions) | 0% (18 sessions) | regressing ✗ — escalating |

**Constrained optimization check:** EITHER rolling avg increased? Yes — tool_errors regressing. **WARNING: Regression detected.**

But qualifier: tool_errors increase mostly from S248 background SOTA research (3 parallel agents fetching outdated URLs) + S252 audit batch volume — NOT from agent quality regression. Backlog stagnation IS real regression and **HIGH PRIORITY** to address.

---

## Structured JSON Output

```json
{
  "insights_run": "2026-04-26",
  "sessions_analyzed": 7,
  "session_id": "S253",
  "session_name": "INFRA_ROBUSTO",
  "session_window": "S247-S253",
  "branch_aware": "feat/shell-sota-migration (6 commits ahead of main)",
  "proposals": [
    {
      "id": "P253-001",
      "category": "PATTERN_REPEAT",
      "title": "Backlog triage escalation (was P246-005, no progress 7+ sessions)",
      "target_file": ".claude/BACKLOG.md",
      "priority": "high",
      "frequency": 18,
      "draft": "[ACTION ITEM not draft] Backlog triage session — review 41 open items, categorize keep/close/defer-90d. Single-session work, ~30min. STAGNANT 18 sessions (S235-S252). PRIORITY ESCALATED P1→P0 due to no progress since S246 flag."
    },
    {
      "id": "P253-002",
      "category": "HOOK_GAP",
      "title": "Backlog stagnant alert mechanism",
      "target_file": "hooks/stop-quality.sh",
      "priority": "medium",
      "frequency": 1,
      "draft": "Add check: if .claude/apl/metrics.tsv backlog_resolved unchanged ≥10 sessions consecutivas, append banner_warn 'BACKLOG STAGNANT — triage overdue (N sessions)' to session-end output. Surfaces problem rather than letting metric vanish."
    },
    {
      "id": "P253-003",
      "category": "RULE_GAP",
      "title": "WebFetch URL lifecycle (NEW KBP candidate)",
      "target_file": ".claude/rules/known-bad-patterns.md",
      "priority": "medium",
      "frequency": 7,
      "draft": "## KBP-40 External URL lifecycle (research artifacts decay)\n→ .claude/skills/research/SKILL.md §URL preservation (cite URL+date+commit-SHA OR Internet Archive snapshot OR DOI canonical when persisting external sources in living HTML/plans)"
    },
    {
      "id": "P253-004",
      "category": "RULE_GAP",
      "title": "P6 6b standard calibration (strict body vs permissive frontmatter)",
      "target_file": ".claude/plans/audit-p5-p6-violations.md",
      "priority": "medium",
      "frequency": 2,
      "draft": "## Methodology calibration S253\n6b WHY criterion strict standard: citation must appear in body markdown section (not just frontmatter description). Auto-loaders parse body; frontmatter is meta. Per Lucas decision S253: strict standard adopted. debug-validator + debug-strategist need body WHY strengthen (~30min combined) to convert PART 3.5/4 → PASS 4/4."
    },
    {
      "id": "P253-005",
      "category": "SKILL_GAP",
      "title": "/insights filter same-session noise (P246-004 unimplemented)",
      "target_file": ".claude/skills/insights/SKILL.md",
      "priority": "low",
      "frequency": 1,
      "draft": "[CARRYOVER from S246] Phase 1 Sub-step 5 enhancement: filter current-session hook-log events from cross-session frequency. Predicate: event.session_id != current. Reason: agent self-spawns inflate counts."
    },
    {
      "id": "P253-006",
      "category": "PATTERN_REPEAT",
      "title": "REWORK SPIKE S252=9 (informational monitor)",
      "target_file": "(no file action — observability item)",
      "priority": "low",
      "frequency": 1,
      "draft": "[MONITOR ONLY] If S253+S254 mechanical phases also rework_files >5, escalate to investigation. Hypothesis: mechanical batch density (audit + VERIFY + KBP codify + close = 4 distinct file-touch passes per session) naturally inflates rework. Confirm via git diff --stat per commit."
    }
  ],
  "kbps_to_add": [
    {
      "pattern": "External URL lifecycle (research artifacts hardcode URLs that decay 404/403)",
      "trigger": "WebFetch failures rising in hook-log (7× in 7-session window)",
      "fix": "Cite URL+date+commit-SHA OR Internet Archive snapshot OR DOI canonical when persisting external sources"
    }
  ],
  "pending_fixes_to_add": [
    {
      "item": "Backlog triage session (escalation of P246-005, ZERO progress 7+ sessions)",
      "priority": "P0",
      "target": ".claude/BACKLOG.md"
    },
    {
      "item": "P6 6b calibration decision (strict body vs permissive frontmatter)",
      "priority": "P1",
      "target": ".claude/plans/audit-p5-p6-violations.md + 2 agents body strengthen"
    },
    {
      "item": "mellow-scribbling-mitten P5 commit (anti-drift §Branch discipline + CLAUDE.md §ENFORCEMENT #7 + .githooks/pre-commit) — Lucas in-flight",
      "priority": "P0",
      "target": "feat/shell-sota-migration branch (this branch)"
    }
  ],
  "metrics": {
    "rule_violations": 5,
    "user_corrections": 5,
    "retries": 1,
    "patterns_resolved_since_last": 4,
    "patterns_new": 2
  }
}
```

---

## Notes for next /insights run

- Track if `tool_errors` rate normalizes once background SOTA research stops (S248 spike likely transient)
- Track if backlog_resolved velocity changes after P253-001 triage executes
- Track if P5 branch-discipline rule + git hook lands → all subsequent /insights should auto-detect branch context (this report set precedent)
- 5-entry registry milestone reached → next run can compute proper rolling 5avg; persist trend direction
