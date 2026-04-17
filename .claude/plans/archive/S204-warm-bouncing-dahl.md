# S204 Orchestration Plan — Consolidation + Priority Triage

> **Status: FALSE-DONE — S224 audit** — Claim L53-55 "Design Excellence Phase 2 OK pois Phase 1.5 DONE" invalidada: `mutable-mapping-seal:122` ainda exige proof. Ver `BACKLOG-S220-codex-adversarial-report.md` L56.

## Context

S204 accumulated significant work without a commit: Pipeline I/O Hardening (5 edits to gemini-qa3.mjs + qa-capture.mjs), s-takehome functional improvements (click-reveal 3 cards), s-quality CSS audit, prompt updates, and new APCA tooling. 11 tracked files modified (300 ins, 88 del) + 6 untracked items. Need to consolidate before diverging into new work.

## Step 0 — Fix pending issue (5 min)

**What:** Rebuild index.html from updated _manifest.js.
**Why:** Stop hook detected _manifest.js was modified without rebuilding index.html. Timestamps suggest it may already be current, but rebuild to be safe.
**How:** `cd content/aulas && npm run build:metanalise`

## Step 1 — Commit current S204 work (10 min)

**Files to commit (tracked, 11):**
- `CHANGELOG.md`, `HANDOFF.md` — session docs
- `content/aulas/scripts/gemini-qa3.mjs` — Pipeline I/O hardening (computedStyles, reliability, few-shot, delta, priority_actions, selector validation)
- `content/aulas/scripts/qa-capture.mjs` — Pipeline I/O hardening
- `content/aulas/metanalise/docs/prompts/gate4-call-a-visual.md` — prompt alignment
- `content/aulas/metanalise/docs/prompts/gate4-call-b-uxcode.md` — prompt alignment
- `content/aulas/metanalise/metanalise.css` — s-takehome + s-quality CSS
- `content/aulas/metanalise/slide-registry.js` — s-takehome animation wiring
- `content/aulas/metanalise/slides/17-takehome.html` — s-takehome functional
- `content/aulas/metanalise/slides/_manifest.js` — metadata (17 slides, clickReveals=3)
- `content/aulas/metanalise/.slide-integrity` — hash update

**Files to commit (untracked, 4):**
- `content/aulas/scripts/apca-audit.mjs` — new APCA accessibility audit tool
- `.claude/plans/archive/S201-*.md`, `.claude/plans/archive/S202-*.md` — archived plans
- `package.json`, `package-lock.json` — root devDeps (apca-w3, colorjs.io)

**Exclude from commit:**
- `content/aulas/.claude/` — agent memory (gitignored or ephemeral)

**Commit message theme:** S204: Pipeline I/O Hardening + s-takehome functional + APCA tooling

## Step 2 — Priority triage (Lucas decides)

Three pending workstreams, ordered by actionability:

### A. s-quality evidence HTML integration (ACTIONABLE)
- Research DONE: 4 refs verified (Santos 2026, Alvarenga-Brant 2024, Ho 2024, Mickenautsch 2024)
- Task: integrate refs into evidence HTML, write speaker notes (~90s bottom-up)
- Blocked on: nothing — can execute now
- Estimate: ~1 step (evidence HTML edit + verification)

### B. s-takehome creative direction (BLOCKED on Lucas)
- Functionally complete (click-reveal 3 cards, failsafe)
- Visually weak: 5 diagnosed problems (no color differentiation, no punchline emphasis, decorative numbers, generic aesthetic, no visual arc)
- Blocked on: Lucas's creative vision — colors per card? punchline treatment? icon language?
- Cannot proceed without direction

### C. Design Excellence Phase 2 (NEXT planned phase)
- Rule `design-excellence.md` + skill `/polish` + Chrome DevTools MCP
- Depends on: Phase 1.5 DONE (confirmed) + commit (Step 1)
- Can start after commit, but s-quality/s-takehome may be higher priority

## Verification

- Step 0: `npm run build:metanalise` exits 0
- Step 1: `git status` clean after commit
- Step 2: Lucas decides priority order

## Lucas Decision (in-session)

- **Commit:** single organized commit covering all S204 work
- **Scope:** Steps 0 + 1 only. Priority triage after commit is clean.
