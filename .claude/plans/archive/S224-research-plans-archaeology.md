# Plans Archaeology — S224 Research Report

> Scope: 56 plan files (4 active + 52 archived, S135–S224).
> Method: Glob + targeted Grep + selective Read. Depth over completeness.
> Date: 2026-04-17 | Coautoria: Lucas + Sonnet 4.6

---

## 1. Inventory Summary

### Count by Status

| Status | Count | Notes |
|--------|-------|-------|
| ACTIVE | 2 | `ACTIVE-snoopy-jingling-aurora.md` (pipeline hardening), `ACTIVE-proud-drifting-sunbeam.md` (S220 micro-batches, likely stale) |
| BACKLOG | 1 | `BACKLOG-S220-codex-adversarial-report.md` (40 findings, S221+ deferred) |
| ARCHIVED — DONE (genuine) | ~38 | S135–S222 plans with clear deliverables completed |
| ARCHIVED — FALSE-DONE | 3 | `S199-STALE-mutable-mapping-seal.md`, `S208-STALE-generic-wondering-manatee.md`, `S204-warm-bouncing-dahl.md` |
| ARCHIVED — STALE | 2 | `S208-STALE-generic-wondering-manatee.md`, `hashed-zooming-bonbon.md` Fase 2 items |
| ARCHIVED — INCONCLUSIVE | 2 | `S223-validation-report.md` (2 PASS / 1 FAIL / 1 INCONCLUSIVE), `S216-functional-rolling-waffle.md` (venv decision open) |
| OPEN QUESTION for S225 | 1 | `S224-stop-dispatch-diag.md` L152-159: Stop[5] per-turn vs per-session |

### Count by Session Range

| Range | Count | Dominant Theme |
|-------|-------|----------------|
| S135–S156 | 17 | Slide build, QA gate dev, PMID audit, BACKLOG infra |
| S193–S201 | 9 | Hooks Fase 1+2, Design Excellence research, memory loss prevention |
| S202–S213 | 7 | Design Excellence Loop, QA repair, self-improvement, hooks state-of-art |
| S216–S224 | 13 | PDF/Obsidian pipeline, context rot, infra integrity, Stop dispatch |

---

## 2. Cross-Reference Graph (plan → plans cited)

```
ACTIVE-snoopy-jingling-aurora
  ← referenced by: BACKLOG-S220-codex-adversarial-report.md (L55)
  ← referenced by: archive/S204-warm-bouncing-dahl.md (L53-55)
  → depends on: archive/S199-STALE-mutable-mapping-seal.md (Fase 2 prereq)
  → blocks: .claude/rules/design-excellence.md (Fase 2.1, not yet created)
  → blocks: .claude/skills/polish/SKILL.md (Fase 2.2, not yet created)

ACTIVE-proud-drifting-sunbeam (S220 micro-batches)
  ← gates: archive/S220-humble-toasting-ritchie.md (L4, L153: "B2 /dream Phase 2.6 bloqueado")
  → references: /dream Phase 2.6 (stop-metrics.sh fix)
  → references: tools/docling + pdf_to_obsidian.py (S216 deliverables — FALSE-DONE)

BACKLOG-S220-codex-adversarial-report
  → generates backlog for: S221+ (hooks 9 issues, memory 9 merges/moves, rules 7 issues)
  → cites: archive/S216-functional-rolling-waffle.md (FALSE-DONE, venv open)
  → cites: archive/S199-STALE-mutable-mapping-seal.md (FALSE-DONE, Fase 1 unverified)
  → cites: archive/S208-STALE-generic-wondering-manatee.md (STALE, artifacts missing)
  → cites: archive/S204-warm-bouncing-dahl.md (FALSE-DONE, Design Excellence claim invalid)

archive/S224-stop-dispatch-diag → archive/S224-fizzy-hopping-honey (superseded by)
archive/S224-fizzy-hopping-honey → open question for S225 (Track A decision)
archive/S223-validation-report → informed by: archive/S223-clever-churning-starlight.md
archive/S222-buzzing-wondering-hickey → continues: archive/S221-partitioned-orbiting-hellman.md
archive/S221-partitioned-orbiting-hellman → continues: S220 context rot thread
archive/S220-humble-toasting-ritchie → feeds: archive/S220 codex adversarial report (B1.5)
archive/S199-STALE-mutable-mapping-seal → researched by: archive/S199-research-design-excellence.md
archive/S199-STALE-mutable-mapping-seal → researched by: archive/S201-mutable-mapping-seal-agent.md
archive/S199-STALE-mutable-mapping-seal → diagnostic: archive/S199-gemini-qa-diagnostic.md
archive/S199-STALE-mutable-mapping-seal → informed by: archive/S202-noble-plotting-lecun.md
archive/S208-STALE-generic-wondering-manatee → continues: S208-research-claudemd-ecosystem.md
archive/S211-cryptic-booping-nest → base plan: archive/hashed-zooming-bonbon.md Fase 2
archive/S196-crispy-munching-blum → continues: archive/S196-functional-prancing-clarke.md
archive/S196-functional-prancing-clarke → base: archive/S194-polished-wibbling-cloud.md Fase 1
archive/S198-partitioned-swimming-axolotl → closes: archive/S196-crispy-munching-blum.md
archive/S214-curious-honking-platypus → BACKLOG.md consolidation (3 files → 1)
```

---

## 3. Top 5 Recurring Themes (with evidence)

### T1: QA Pipeline Accuracy / Evaluator Quality

**9+ sessions** (S139, S141, S143–S145, S199, S201–S204, ACTIVE-snoopy-jingling-aurora).

The core loop: Gemini QA produces false positives → team spends cycles on phantom fixes → pipeline quality doesn't improve. Diagnosed in depth at S199 (`archive/S199-gemini-qa-diagnostic.md:1-30`): 5 root causes — Call A invents selectors (CR-1), Call B parse failure 30–40% (CR-2), zero few-shot, zero delta tracking, Call D mixes two jobs. `ACTIVE-snoopy-jingling-aurora.md:7-60` identifies 5 current bottlenecks (G1-G5) as of 2026-04.

Status: Fase 1 (evaluator repair) claimed DONE at S202, but BACKLOG-S220 Batch 3 L53 flags it FALSE-DONE (no run logs). ACTIVE plan (snoopy) is still fixing G1-G4. **Loop unresolved since ~S139 (~86 sessions).**

### T2: Hook System Integrity / Stop Dispatch

**10+ sessions** (S193–S196, S208–S213, S218–S224).

Hook system has been through 2 major overhauls (Fase 1 anti-perda: `hashed-zooming-bonbon.md`, Fase 2 consolidation: `S196-crispy-munching-blum.md` 34→29 registros, 0 node spawns). Yet BACKLOG-S220 Batch 1 found 10 new issues post-S219, 5 rated HIGH (`BACKLOG-S220-codex-adversarial-report.md:8-22`). Stop[5] specifically: dispatch silent for 8h22m in S223 (`S223-validation-report.md:41-48`), root cause unresolved (`S224-stop-dispatch-diag.md:152-159`). Open question for S225: per-turn vs per-session dispatch.

### T3: Context Weight / CONTEXT_ROT

**6 sessions** (S220–S224), but diagnostic extends to S208.

`S208-STALE-generic-wondering-manatee.md:5-36` diagnosed the root feedback loop: more rules → more context → less compliance → more KBPs. `S220-humble-toasting-ritchie.md:32` documented the "13% → 40-50% after first response" jump. Sessions S220-S224 labeled with CONTEXT_ROT 1/2/3 suffix. Partial mitigations: removing `CLAUDE_CODE_DISABLE_1M_CONTEXT` (S223), ctx_pct tracking (58 in S224 vs 82 in S223 per `S224-fizzy-hopping-honey.md:17`). Root cause of instruction budget saturation not yet structurally resolved.

### T4: Self-Improvement Loop / Dream / Memory Consolidation

**8+ sessions** (S210–S213, S216, S218, S220).

Recurring failure: research agent output lands in temp file → compaction erases it → work lost. `hashed-zooming-bonbon.md:101-108` diagnosed this at S210. Repeated in S216 (docling tools) and S220 (/dream Phase 2.6 gated behind stop-metrics fix). `/dream Phase 2.6` (metrics trend analysis) appears in `S218-mutable-leaping-wilkinson.md:47-123` as planned but still gated. `ACTIVE-proud-drifting-sunbeam.md B2` was waiting for S220 stop-metrics fix which itself was gated on S220 humble-toasting-ritchie diagnostic.

### T5: Design Excellence Loop (Phases 2.1–2.2 never shipped)

**5+ sessions** (S199–S204, snoopy ACTIVE).

Phase 2 was declared planned at `S199-STALE-mutable-mapping-seal.md:120-124`: two deliverables: `.claude/rules/design-excellence.md` and `.claude/skills/polish/SKILL.md`. `S204-warm-bouncing-dahl.md:53-55` claimed Phase 2 "NEXT planned phase." BACKLOG-S220 L53 confirms both deliverables **do not exist** (checked S224). `ACTIVE-snoopy-jingling-aurora.md:218` explicitly defers: "NÃO: rule design-excellence.md (Fase 2.1 — depende de pipeline validado)." This thread has been open since approximately S199 (~25+ sessions).

---

## 4. Lost Threads (Orphaned TODOs / Decisions Never Actioned)

### LT-1: docling-tools / PDF→Obsidian pipeline
**File:** `archive/S216-functional-rolling-waffle.md:136-143`
All 5 verification boxes open: `tools/docling/` not present in repo (confirmed absent — `ACTIVE-proud-drifting-sunbeam.md` still lists Step 2 as pending). Decision on moving `C:\Dev\Projetos\docling-tools\` to OLMO monorepo (`tools/docling/`) was made at S216 L32-40 but never executed. `ACTIVE-proud-drifting-sunbeam.md:B5-B8` still treat it as future work.

### LT-2: Memory wiki consolidation (9 candidates from Codex Batch 2)
**File:** `BACKLOG-S220-codex-adversarial-report.md:29-44`
9 specific memory operations identified (merge, move, delete, clarify) all deferred to S221+. None executed as of S224. Memory cap is at 20/20 (`BACKLOG-S220-codex-adversarial-report.md:29`). Governance: "review cadence every 3 sessions" — S220 was ≥3 sessions ago. Items include: `SCHEMA.md` DELETE (#6, declared stale), merge `project_values.md + user_mentorship.md + project_self_improvement.md` (#4), and 3 MOVE-TO-RULES items.

### LT-3: Hook issues #1-4, #6-10 (from Codex Batch 1)
**File:** `BACKLOG-S220-codex-adversarial-report.md:82-88`
9 hook issues deferred to S221+. Includes 4 HIGH-severity: guard-bash-write.sh only catches `> >> rm mv cp chmod kill` but misses `mkdir tee sed -i python curl -o` (#1); `PostToolUseFailure` event may not exist (#6 — silently disables hooks); concurrent session state corruption via `/tmp/cc-session-id.txt` (#4). S221 addressed only `integrity.sh` seeding; none of the 9 carried over to S222-S224.

### LT-4: EC loop as real hook (not prompt heuristic)
**File:** `BACKLOG-S220-codex-adversarial-report.md:68` (Rules issue #3)
"Move EC loop validation to PreToolUse/Edit/Write hook real, not prompt heuristic" — gap since `anti-drift.md:46`. Currently enforced only by Stop[0] KBP-22 check at 3+ action calls. No mechanical gate exists. Never entered the active plan queue.

### LT-5: crossref-precommit.sh and stop-detect-issues.sh — DEAD-REFs in CLAUDE.md
**File:** `BACKLOG-S220-codex-adversarial-report.md:64-66` (Rules issues #1-2)
`CLAUDE.md:63` references `crossref-precommit.sh` (does not exist). `CLAUDE.md:73` references `stop-detect-issues.sh` (not found — current analog is `hooks/stop-quality.sh`). Listed in Rules batch F3 of S220, but verification reveals Lucas did S220 Part F only partially. These DEAD-REFs are still live.

### LT-6: s-takehome creative direction (BLOCKED on Lucas decision)
**File:** `archive/S204-warm-bouncing-dahl.md:47`
"BLOCKED on Lucas" — no evidence of decision being made. Slide s-takehome exists in QA pipeline but no direction given. Now appears in `ACTIVE-snoopy-jingling-aurora.md` as the test case for pipeline hardening (R12 planned), which implicitly unblocks this — but the creative decision about the slide direction itself was never recorded.

### LT-7: BACKLOG.md consolidation (3 → 1 source of truth)
**File:** `archive/curious-honking-platypus.md:21-38` (S214 plan)
Plan to merge `BACKLOG.md` (root, stale since S93), `PENDENCIAS.md`, and `.claude/BACKLOG.md` into single source. Was a Batch 1 item in S214. No confirmation this was executed — `curious-honking-platypus.md` does not mark DONE.

### LT-8: /dream Phase 2.6 (metrics trend analysis)
**File:** `archive/S218-mutable-leaping-wilkinson.md:47-123`; `ACTIVE-proud-drifting-sunbeam.md:B2`
Planned in S218, gated behind stop-metrics.sh fix (S220 Part D). Stop-metrics fix was scoped to Issue #5 (metrics race) in S220. S220 humble-toasting-ritchie L48+ documented the fix plan. Whether the race condition was actually fixed determines if B2 is unblocked. No completion record found.

---

## 5. Consolidation Recommendations

### R1: Resolve FALSE-DONE plans before S226 feature work
**Target files:**
- `archive/S199-STALE-mutable-mapping-seal.md` — treat Fase 1 as unverified, require artifact attachment (run log + Call B ≥90%)
- `archive/S208-STALE-generic-wondering-manatee.md` — Fase 2 artifacts L257/L265 don't exist; reclassify as PENDING_GATE
- `archive/S204-warm-bouncing-dahl.md` — claim "Design Excellence Phase 2 OK" is invalid per Codex verdict

Action: Add `> Status: FALSE-DONE — S224 archaeology` comment block to each. Do not delete — history is load-bearing.

### R2: Create S225 Track A decision record immediately
**Context:** `S224-stop-dispatch-diag.md:152-159` + `S224-fizzy-hopping-honey.md:128-129`
The per-turn vs per-session dispatch question for Stop[5] is the critical gate for S225. Write a decision record (even "Lucas deferred") to prevent another session of re-diagnosing.

### R3: Execute LT-2 memory consolidation before session 230
The 9 Codex Batch 2 memory candidates have been deferred 4+ sessions. At 20/20 cap, new memory content has no home. Priority items: `SCHEMA.md` DELETE (#6, zero-effort), `feedback_context_rot.md` MOVE-TO-RULES (#1, anti-drift.md already covers it). This unblocks creation of future memory files without governance violation.

### R4: Merge design-excellence research cluster (S199–S204) into single reference doc
Four plan files cover the same Design Excellence research:
- `archive/S199-research-design-excellence.md`
- `archive/S201-mutable-mapping-seal-agent.md`
- `archive/S199-gemini-qa-diagnostic.md`
- `archive/S199-STALE-mutable-mapping-seal.md` (sections 1-2)

These are rarely referenced individually but collectively contain the foundational research. A single `docs/research/design-excellence-research-S199-S204.md` (read-only reference, not a plan) would serve better. The plans themselves stay in archive.

### R5: Formalize "Track A" scope before snoopy pipeline closes
`ACTIVE-snoopy-jingling-aurora.md` is a prerequisite for Design Excellence Phase 2.1 (rule) and 2.2 (skill/polish). Both deliverables are undefined. Before snoopy closes, write the scope for Fase 2.1 as a plan stub — otherwise the thread restarts from scratch again in S226+ (repeating the S199→S204→S208 pattern of re-researching the same ground).

---

## Metadata

- Plan files read (direct): 22 of 56
- Grep searches: 12
- False-DONE plans confirmed: 3
- Open questions for S225: 2 (Stop[5] dispatch + Track A scope)
- Lost threads: 8
- Recurring themes: 5
- Plans with no completion evidence: ~6 additional (S216 all verification boxes open)

Coautoria: Lucas + Sonnet 4.6 | S224 2026-04-17
