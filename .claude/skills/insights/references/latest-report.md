# /insights S240 — 2026-04-23

> Scope: S237-S240 (4 sessions, Apr 21-23, post-S236-insights window)
> Previous: S236 report (5 proposals pending, P007/P008/P009 executed)
> Sessions analyzed: S237 (Beggining_GRADE_V2, Apr 21), S238 (correcao_rota, Apr 22),
>   S239 (pwsh-update C4.6 + 239-INFRA, Apr 22), S240 (metanalise-SOTA-loop, Apr 23)
> Phases: SCAN → AUDIT → DIAGNOSE → PRESCRIBE → QUESTION → REGISTRY

---

## Phase 1 — SCAN

### Hook-log window 2026-04-21 → 2026-04-23 (559 active entries)

| pattern | cat | count | sev | status |
|---------|-----|-------|-----|--------|
| brake-fired:Edit | info | high | info | OK — hook working |
| brake-fired:Write | info | moderate | info | OK |
| brake-fired:Agent | info | 4 | info | OK |
| brake-fired:mcp_chrome-devtools_evaluate_script | info | seen | info | NEW — MCP tools now in brake scope |
| brake-fired:mcp_chrome-devtools_navigate_page | info | seen | info | NEW |
| brake-fired:mcp_chrome-devtools_take_screenshot | info | seen | info | NEW |
| tool-error:Bash | warn | 18 | warn | PERSISTENT — up from 7 in S236 window (CRLF + deny-list) |
| tool-error:Read | warn | 5 | warn | KBP-23 candidate — Read without limit |
| tool-error:mcp_chrome-devtools_take_screenshot | warn | 1 | warn | MCP tool error (S239 adversarial audit) |
| tool-error:WebFetch | warn | 1 | warn | Single, not pattern |
| tool-error:Glob | warn | 1 | warn | Single |

**Notable:** `brake-fired:mcp_chrome-devtools_*` entries confirm momentum-brake now catches MCP tool chains — a new healthy pattern since S236. tool-error:Bash count increased from 7→18 (3x) over similar window — warrants investigation.

### Success-log highlights (S237-S240 clean commits)
- S237: 5 commits clean (state refresh, grade-v1 archive, ADR-0004/0005, shared-v2 Day 1)
- S238: 3 commits clean (font-face fix, transient compute, revert)
- S239: 2 commits clean (C4.6 OKLCH gamut + APCA, C5 partial, revert)
- S240: 3 commits clean (metanalise C1 shared-bridge, C2 s-etd modernization, docs)
Total: 13 clean commits across 4 sessions — healthy velocity.

### User corrections identified

**C1 — Build-before-QA skip (S240, HIGH)**
Source: CHANGELOG.md §S240 Aprendizados + S240 JSONL grep
Quote: "sem workaround, arruma, não pule etapas" (build ANTES de QA)
Evidence: Agent ran `qa-capture.mjs` before running `npm run build:metanalise`. Lucas corrected
explicitly. Rule exists in `content/aulas/CLAUDE.md §ENFORCEMENT item 1`.

**C2 — evaluate_script workaround instead of canonical tool (S240, HIGH)**
Source: CHANGELOG.md §S240 Aprendizados
Quote: "evaluate_script manual injetando `slide-active` foi workaround descartado por Lucas"
Evidence: Agent used raw MCP `evaluate_script` to inject class `slide-active` directly instead
of calling `__deckGoTo(index)` from deck.js. Lucas corrected: "sem workaround arrume e deixe
profissional, tem script mcp". Canonical path is `qa-capture.mjs --slide <id> --port <N>` which
internally calls `window.__deckGoTo(idx)`.

**C3 — HANDOFF stale detection gap (S240, MEDIUM)**
Source: CHANGELOG.md §S240 + metanalise/HANDOFF.md reading
Evidence: `metanalise/HANDOFF.md` showed "16/16 slides" as of S162 (last update). Actual manifest
has 17 slides since S207 — a 13-session drift. The note in HANDOFF (current HEAD) acknowledges:
"Manifest real = 17 slides (S207) — HANDOFF abaixo desatualizado desde S162." No automatic
detection mechanism caught this; Lucas caught it manually. Slides dir confirms 20 items (19 slides
+ _archive folder currently).

### Additional observations from CHANGELOG scan

- S237: "Revisão Opus-sobre-Opus tem correlação de blind spots" — workaround mitigation via
  external Codex CLI review added. Pattern-of-note, not an error.
- S238: CSS `@font-face before @import` was a silent bug since initial commit (projetor failure
  root cause). Caught by adversarial audit. Rule E22 proposed but not yet added to slide-rules.md.
- S238 Aprendizados: "`node -p` bypassa deny-list" — KBP candidate, currently unrecorded.
- S239: 13-item adversarial audit showed `culori` missing as dependency → Items 2+3 PARCIAL.
  Resolution came next session. Gap between "tool needed" and "tool available" is recurrent.

---

## Phase 2 — AUDIT (Compliance Matrix)

### Rules checked

**`content/aulas/CLAUDE.md §ENFORCEMENT item 1`** — "Build ANTES de QA. Sempre."
- Status: **VIOLATED** (C1, S240)
- Coverage: Rule IS explicit. Failure mode is agent forgetting under time/task pressure.
- Hook coverage: `guard-lint-before-build.sh` blocks lint skip, but no hook enforces
  build-before-QA for `qa-capture.mjs` invocations.

**`content/aulas/CLAUDE.md §Scripts` — Script Primacy**
- Status: **VIOLATED** (C2, S240)
- Rule states: "Script primacy: estes scripts sao canonicos. Agentes referenciam, nunca reimplementam."
- `qa-capture.mjs` IS listed as canonical. Using raw `evaluate_script` to replicate its slide
  navigation is reimplementation-by-proxy.

**`content/aulas/CLAUDE.md §Convencoes por Aula` — HANDOFF.md per-aula**
- Status: **GAP** (C3, S240)
- No rule mandates cross-referencing `HANDOFF.md` slide count against `_manifest.js` at session
  start. The propagation table (`§Cross-Ref`) covers manifest→index.html but not HANDOFF sync.

**`anti-drift.md §Script primacy`** — identical to CLAUDE.md script primacy
- Status: FOLLOWED in S237-S239, **VIOLATED** once in S240 (evaluate_script workaround).

**`anti-drift.md §EC loop`** — pre-action gate with verification claim
- Status: Generally FOLLOWED across S237-S240 (CHANGELOG shows EC blocks present).

**`anti-drift.md §Propose-before-pour`** — S240 Aprendizados explicitly acknowledges it was followed.
- Status: **FOLLOWED** — "Split s-etd em 2 aprovado: propose-before-pour aprovado."

**`known-bad-patterns.md §KBP-03 Agent-Script Redundancy`**
- Status: **VIOLATED** (C2) — evaluate_script reimplements qa-capture.mjs slide navigation.
  KBP-03 points to "anti-drift.md §Script Primacy" — rule coverage exists, enforcement absent.

**`slide-rules.md` — E22 (@import order lint)**
- Status: **STALE/GAP** — E22 was proposed in S238 Aprendizados as "Lint rule candidate" but was
  never added to slide-rules.md. Error that caused the projetor bug is unguarded in new slides.

**`known-bad-patterns.md §KBP-07 Workaround Without Diagnosis`**
- Status: C2 is also a KBP-07 instance — agent reached for workaround (`evaluate_script` class
  injection) without diagnosing "why isn't the canonical script working?" first.

---

## Phase 3 — DIAGNOSE

### Prioritized findings

**F1 — RULE_VIOLATION: Build-skip before qa-capture.mjs [HIGH, frequency=1+, impact=HIGH]**
Category: RULE_VIOLATION
The rule "Build ANTES de QA" is explicit and unambiguous. Agent skipped it under implicit
pressure to progress quickly through QA iteration. No hook enforces the prerequisite. The
correction pattern ("sem workaround, nao pule etapas") is identical to previous corrections
about workarounds — same failure mode, different surface.
Fix target: hook-level enforcement + reinforce qa-pipeline.md.

**F2 — RULE_VIOLATION + KBP-03: Script-API workaround via raw MCP [HIGH, frequency=2 across window]**
Category: RULE_VIOLATION (KBP-03)
Canonical path `qa-capture.mjs --slide X --port N` uses `__deckGoTo(idx)` internally. Agent
used raw `mcp__chrome-devtools__evaluate_script` to inject `slide-active` class directly,
bypassing the canonical script. Two corrections in window ("sem workaround arrume, tem script mcp"
and "sem workaround arruma nao pule etapas"). Both point to same meta-pattern: agent reaches for
direct MCP tool use when a canonical script should be the interface.
Fix target: qa-pipeline.md + content/aulas/CLAUDE.md — explicit "prefer qa-capture.mjs over
raw evaluate_script for slide navigation."

**F3 — RULE_GAP: HANDOFF/manifest slide count drift undetected 13 sessions [MEDIUM, systemic]**
Category: RULE_GAP
No cross-reference check between per-aula HANDOFF.md slide count claim and `_manifest.js`
actual slide count. S162 HANDOFF said "16 slides," S207 added slide 17 — gap persisted until
S240 when Lucas caught it manually. session-start hook loads HANDOFF but does not validate it
against manifest.
Fix target: session-start.sh or content/aulas/CLAUDE.md — add manifest-count assertion at
session open for aula contexts.

**F4 — RULE_GAP: E22 (@import order) never added to slide-rules.md [MEDIUM, frequency=1 concrete bug]**
Category: RULE_GAP
S238 discovered that `@font-face before @import` silently invalidated 6 CSS imports (projetor
bug root cause). Aprendizados flagged "Lint rule candidate (E22)" but no write happened.
`guard-lint-before-build.sh` does not check at-rule order. If a new aula repeats this pattern,
same silent projetor failure will occur.
Fix target: slide-rules.md §Errors — add E22. Optionally guard-lint-before-build.sh.

**F5 — TOOL_ERROR regression: Bash errors 7→18 (3x increase) [MEDIUM, frequency=18]**
Category: PATTERN_REPEAT
Bash tool errors went from 7 in the S231-S236 window to 18 in the S237-S240 window. Mix of
deny-list hits and CRLF warnings. CRLF warnings are noise; deny-list hits represent unresolved
tension between Windows/MSYS tooling and deny-list policies. S238 introduced `.claude-tmp/`
convention to partially address this. Elevated count post-fix suggests the convention is not
resolving all friction points.
Fix target: investigate Bash error breakdown more specifically in next window; low priority now.

---

## Phase 4 — PRESCRIBE

### [RULE_VIOLATION] P012 — Hook to enforce build-before-QA-capture

**Evidence:** S240 — agent ran `qa-capture.mjs` without running `npm run build:metanalise` first.
Lucas corrected with "sem workaround arruma nao pule etapas."
**Root cause:** No pre-tool hook intercepts `qa-capture.mjs` invocations to assert build freshness.
The rule lives in CLAUDE.md but has no mechanical enforcement.

**Proposed fix:**
- **Target:** `content/aulas/CLAUDE.md §ENFORCEMENT`
- **Change:** Add note that the rule is enforced at session-reminder level (no hook today), and
  add explicit phrasing for MCP context.
- **Draft addition after "Build ANTES de QA. Sempre.":**
  ```
  ENFORCE: Antes de qualquer invocação de `qa-capture.mjs` ou MCP screenshot,
  confirmar que `npm run build:{aula}` rodou nessa sessão. Sem build = sem QA.
  ```
- **Optional hook (future):** PreToolUse hook matching `qa-capture.mjs` invocation that checks
  `index.html` mtime vs `slides/*.html` mtime. Low complexity, medium value.

**Lucas approval required.** Rule text change only (no hook today unless Lucas approves both).

---

### [RULE_VIOLATION + KBP-03] P013 — Canonical path for slide navigation: qa-capture.mjs over raw evaluate_script

**Evidence:** S240 — agent used `mcp__chrome-devtools__evaluate_script` to inject `slide-active`
class directly. Lucas corrected twice: "sem workaround arrume e deixe profissional, tem script mcp."
**Root cause:** `content/aulas/CLAUDE.md §Scripts` table lists `qa-capture.mjs` as "captura
screenshots" but does not explicitly state that it is the ONLY sanctioned path for slide navigation
in QA context. Agent correctly understands the script exists but incorrectly judges raw MCP use
as equivalent.

**Proposed fix:**
- **Target:** `content/aulas/CLAUDE.md §Scripts`
- **Change:** Extend qa-capture.mjs description to flag canonical navigation.
- **Draft — replace existing row:**
  ```
  | `qa-capture.mjs` | Captura screenshots + video. **Caminho canônico para navegação de slides em QA** (`__deckGoTo(idx)`). NUNCA usar `evaluate_script` direto para navegação de slides. |
  ```

**Lucas approval required.**

---

### [RULE_GAP] P014 — KBP-30: Slide-count drift in per-aula HANDOFF vs manifest

**Evidence:** S240 — metanalise HANDOFF.md showed "16 slides" from S162, manifest has 17 since
S207 (13-session gap, caught manually by Lucas).
**Root cause:** No rule or check requires agents to validate HANDOFF slide count against
`_manifest.js` when opening an aula context. `content/aulas/CLAUDE.md §Cross-Ref` propagation
table covers `slides/*.html → _manifest.js → index.html` but stops there — HANDOFF is not
downstream.

**Proposed KBP-30:**
- **Target:** `.claude/rules/known-bad-patterns.md` — append KBP-30
- **Draft:**
  ```
  ## KBP-30 Per-Aula HANDOFF Slide Count Stale
  → content/aulas/CLAUDE.md §Cross-Ref (add: _manifest.js → HANDOFF.md slide count)
  ```
- **Target rule fix:** `content/aulas/CLAUDE.md §Cross-Ref propagation table`
- **Draft row to add:**
  ```
  | `slides/*.html` (add/remove) | `_manifest.js` + `HANDOFF.md §Estado atual` (slides count) + `index.html` (run build) |
  ```

**Lucas approval required for both KBP-30 and propagation table row.**

---

### [RULE_GAP] P015 — Add E22 (@import order) to slide-rules.md §Errors

**Evidence:** S238 discovered `@font-face before @import` silently invalidated 6 CSS imports,
causing the projetor slide-invisible bug. Aprendizados flagged "E22 — lint rule candidate" but
write never happened.
**Root cause:** Insights findings that don't produce a commit are lost. S238 Aprendizados is
ephemeral; the rule file is persistent. No mechanism to carry "candidate" flags forward.

**Proposed fix:**
- **Target:** `.claude/rules/slide-rules.md §Errors`
- **Change:** Add E22 line.
- **Draft — add after existing errors list:**
  ```
  - E22: CSS at-rule order — `@import` MUST precede `@font-face` and all other rules (CSS Cascade §6.1). Violation = silent import failure (projetor bug S238).
  ```

**Lucas approval required.**

---

### [RULE_GAP] P016 — KBP-31: Aprendizados "candidates" lost without commit

**Evidence:** S237 Aprendizados: "Windows path escape (KBP candidate) emergiu como pattern — non-blocking
but silent failure." S238 Aprendizados: "E22 lint rule candidate." Neither produced a KBP or rule
commit. The candidate signal is documented but ephemeral.
**Root cause:** CHANGELOG Aprendizados is append-only but read-only after session close. No workflow
routes "KBP candidate" → actual KBP file write.

**Proposed KBP-31:**
- **Target:** `.claude/rules/known-bad-patterns.md` — append KBP-31
- **Draft:**
  ```
  ## KBP-31 Aprendizados KBP-Candidate Without Commit
  → anti-drift.md §Session docs (add: "KBP candidate in Aprendizados = schedule commit before session close")
  ```
- **Target rule fix:** `anti-drift.md §Session docs`
- **Draft addition:**
  ```
  KBP candidates in Aprendizados: if Aprendizados contains "KBP candidate" or "lint rule candidate",
  schedule a known-bad-patterns.md commit before session close. Candidate without commit = lost.
  ```

**Lucas approval required for both KBP-31 and anti-drift rule addition.**

---

## Phase 4.5 — QUESTION (Double-Loop Audit)

### Double-Loop Audit

| KBP/Rule | Verdict | Evidence | Action |
|----------|---------|----------|--------|
| KBP-03 Agent-Script Redundancy | **ACTIVE** — violated S240 (evaluate_script) | C2 above | KEEP |
| KBP-07 Workaround Without Diagnosis | **ACTIVE** — violated S240 (class injection) | C2 above | KEEP |
| KBP-17 Gratuitous Agent Spawning | No data in S237-S240 | — | KEEP |
| KBP-23 First-Turn Context Explosion | Followed in S237-S240 (no violations noted) | — | KEEP |
| KBP-25 Edit Without Full Read | No violations in window | — | KEEP |
| KBP-29 Agent Spawn Without HANDOFF | No agent spawns without plan in window | — | KEEP |
| E22 in slide-rules.md | **MISSING** — proposed S238, never committed | P015 | ADD |
| anti-drift §Script Primacy | Covered; no redundancy | — | KEEP |
| qa-pipeline.md §1 Build ANTES | Rule exists; violated once | P012 | REINFORCE |

**Previous proposals status:**
- P007 (metrics fallback): EXECUTED S236
- P008 (hook-log rotation): EXECUTED S236
- P009 (KBP-29): EXECUTED S236
- P010 (nudge-commit threshold): Status unknown — not applied in window (calibration still HIGH)
- P011 (.dream-pending path): Status unknown — no evidence in window

---

## Phase 5 — Failure Registry Update

**New entry for S240:**
```json
{
  "id": "S240",
  "date": "2026-04-23",
  "metrics": {
    "sessions_in_sample": 4,
    "user_corrections_total": 3,
    "user_corrections_per_session": 0.75,
    "kbp_violations": {
      "KBP-03_agent_script_redundancy": 1,
      "KBP-07_workaround_without_diagnosis": 1,
      "rule_build_before_qa": 1
    },
    "kbp_total": 3,
    "kbp_per_session": 0.75,
    "tool_errors": 26,
    "retries": 0
  },
  "insights_run": true,
  "new_kbps_added": 2,
  "proposals_accepted": 0,
  "proposals_rejected": 0
}
```

**Trend (3 entries, need 5 for rolling avg):**
- S230: kbp_total=31 (qualitative, 163 sessions)
- S236: kbp_per_session=0.8 (5 sessions)
- S240: kbp_per_session=0.75 (4 sessions)

Direction: IMPROVING (0.80 → 0.75 kbp/session). Insufficient data for 5-avg (need S241+S242).
Tool errors increased (16→26) — watch but not alarming given larger window and adversarial audit activity.

OK: Trend stable/improving on kbp_per_session.

---

## Structured JSON Output

```json
{
  "insights_run": "2026-04-23",
  "sessions_analyzed": 4,
  "proposals": [
    {
      "id": "P012",
      "category": "RULE_VIOLATION",
      "title": "Enforce build-before-QA at rule + optional hook level",
      "target_file": "content/aulas/CLAUDE.md",
      "priority": "high",
      "frequency": 1,
      "draft": "Após '1. Build ANTES de QA. npm run build:{aula} → depois QA. Sempre.' adicionar: 'ENFORCE: Antes de qualquer invocação de qa-capture.mjs ou MCP screenshot, confirmar que npm run build:{aula} rodou nessa sessão. Sem build = sem QA.'"
    },
    {
      "id": "P013",
      "category": "RULE_VIOLATION",
      "title": "qa-capture.mjs = canonical slide navigation — banir evaluate_script direto",
      "target_file": "content/aulas/CLAUDE.md",
      "priority": "high",
      "frequency": 2,
      "draft": "Na tabela de Scripts, substituir linha qa-capture.mjs por: '| `qa-capture.mjs` | Captura screenshots + video. **Caminho canônico para navegação de slides em QA** (`__deckGoTo(idx)`). NUNCA usar `evaluate_script` direto para navegação de slides. |'"
    },
    {
      "id": "P014",
      "category": "RULE_GAP",
      "title": "KBP-30: HANDOFF slide count stale vs manifest",
      "target_file": ".claude/rules/known-bad-patterns.md",
      "priority": "medium",
      "frequency": 1,
      "draft": "## KBP-30 Per-Aula HANDOFF Slide Count Stale\n→ content/aulas/CLAUDE.md §Cross-Ref (add: _manifest.js → HANDOFF.md slide count)"
    },
    {
      "id": "P015",
      "category": "RULE_GAP",
      "title": "Add E22 (@import order) to slide-rules.md §Errors",
      "target_file": ".claude/rules/slide-rules.md",
      "priority": "medium",
      "frequency": 1,
      "draft": "- E22: CSS at-rule order — `@import` MUST precede `@font-face` and all other rules (CSS Cascade §6.1). Violation = silent import failure (projetor bug S238)."
    },
    {
      "id": "P016",
      "category": "RULE_GAP",
      "title": "KBP-31: Aprendizados KBP-candidate without commit = lost",
      "target_file": ".claude/rules/known-bad-patterns.md",
      "priority": "medium",
      "frequency": 2,
      "draft": "## KBP-31 Aprendizados KBP-Candidate Without Commit\n→ anti-drift.md §Session docs (add: KBP candidate in Aprendizados = schedule commit before session close)"
    }
  ],
  "kbps_to_add": [
    {
      "pattern": "KBP-30: Per-aula HANDOFF.md slide count not cross-referenced against _manifest.js",
      "trigger": "When opening aula context or adding/removing slides from manifest",
      "fix": "After any manifest slide add/remove: update HANDOFF.md §Estado slide count in same commit. At session open for aula: compare HANDOFF count vs manifest count."
    },
    {
      "pattern": "KBP-31: Aprendizados entry flagged as 'KBP candidate' or 'lint rule candidate' with no follow-up commit",
      "trigger": "Session closes with candidate in Aprendizados but no commit to known-bad-patterns.md or slide-rules.md",
      "fix": "Before session close: grep Aprendizados for 'candidate'. If found, create commit adding the KBP/rule OR explicitly defer with BACKLOG item."
    }
  ],
  "pending_fixes_to_add": [
    {
      "item": "Add E22 to slide-rules.md §Errors (CSS @import before @font-face, projetor S238 bug)",
      "priority": "P1",
      "target": ".claude/rules/slide-rules.md"
    },
    {
      "item": "Update content/aulas/CLAUDE.md: qa-capture.mjs canonical nav + build-before-QA enforce note",
      "priority": "P1",
      "target": "content/aulas/CLAUDE.md"
    },
    {
      "item": "Add KBP-30 + KBP-31 to known-bad-patterns.md after Lucas approval",
      "priority": "P1",
      "target": ".claude/rules/known-bad-patterns.md"
    },
    {
      "item": "Update content/aulas/CLAUDE.md §Cross-Ref: add manifest→HANDOFF slide count propagation row",
      "priority": "P2",
      "target": "content/aulas/CLAUDE.md"
    }
  ],
  "metrics": {
    "rule_violations": 2,
    "user_corrections": 3,
    "retries": 0,
    "patterns_resolved_since_last": 0,
    "patterns_new": 2
  }
}
```
