# Focused Error Audit — Recurring Patterns

> /insights Recipe 2 | 2026-04-03 | Sessions analyzed: 20 (Mar 31 - Apr 3)
> Agent: Opus 4.6 | Baseline: previous-report.md (same period, full 4-phase)

---

## Executive Summary

22 main sessions scanned, 20 within the 7-day window. 10 of 20 (50%) experienced context overflow. 5 patterns repeat across 3+ sessions. The dominant failure mode is **context rot leading to lost thread**, which cascades into forgotten plans, unnecessary work, and invisible outputs.

---

## Evolution from Previous Report

The previous insights run (full 4-phase) identified 8 prioritized findings. Comparing:

| Previous Finding | Status |
|------------------|--------|
| Fail-open security gates | RESOLVED (S51 fixes) |
| Working-tree vs staged blob | RESOLVED (S51 fixes) |
| Parameter guessing | PERSISTS (memory exists, still violated) |
| PMID metadata fabrication | RESOLVED (verification protocol working) |
| Anti-sycophancy failure | IMPROVED (memory + rule strengthened) |
| Context rot | **PERSISTS — WORSENED** (10/20 sessions) |
| Windows encoding cp1252 | **PERSISTS** (7/20 sessions) |
| CSS cascade false positives | IMPROVED (validation protocol established) |

**Net:** 4 resolved, 1 improved, 1 partially improved, 2 persisting.

---

## Top 5 Recurring Patterns

### 1. [PATTERN_REPEAT] Context Overflow & Session Fragmentation

**Frequency:** 10/20 sessions (50%)
**Impact:** HIGH
**Sessions:** e667d3b9, bd30970f, b6481cfa, ffce597a, 0eb6439c, 364598d4, 8783887e, 36e03571, 12d1555e, 90b4969a

**Evidence:**
- Session 364598d4 hit context overflow 3 times in a single session
- User flagged: "estamos encontrando 2 problemas, context rot, e suas memorias nao estao funcionando"

**Root cause:** Sessions grow too large before committing. Subagent results bloat context. No proactive checkpoints.

**Proposed fix — Target: `.claude/rules/session-hygiene.md`**
```markdown
## Proactive Checkpoints

Before reaching ~60% of context capacity:
1. Commit any uncommitted work
2. Update HANDOFF.md with current state
3. Suggest /clear to user if switching tasks

Never run 3+ complex subagent tasks without an intermediate checkpoint.
When a continuation summary appears, immediately re-read HANDOFF.md — the summary is lossy.
```

### 2. [PATTERN_REPEAT] Unnecessary Work / Scope Drift

**Frequency:** 8/20 sessions (40%)
**Impact:** MEDIUM
**Sessions:** 0eb6439c, 364598d4, 7601f49c, 63deadb3, 8783887e, 36e03571, 82695db8, ebcdbff5

**Evidence:** User corrections about working on deprecated files (presenter mode, evidence-db.md, blueprint.md) and over-engineering features.

**Proposed fix — Target: `.claude/rules/anti-drift.md`**
```markdown
## Active Inventory Check

Before working on a file or feature, confirm it is in active use:
- Check HANDOFF.md DECISOES ATIVAS for deprecated items
- If a file was deprecated in a recent session, do not reference or update it
- When user says "nao uso X" — add to deprecated list for the session
```

### 3. [PATTERN_REPEAT] Encoding Issues (Windows cp1252 / Mojibake)

**Frequency:** 7/20 sessions (35%)
**Impact:** MEDIUM
**Sessions:** e667d3b9, bd30970f, 0a897a43, b6481cfa, ffce597a, 0eb6439c, 364598d4

**Evidence:** "funcionando mas com mojibakes" -> "ainda mojibake" — agent failed to fix on first attempt. Rule exists in memory but is violated in new scripts.

**Proposed fix — Target: `.claude/rules/quality.md`**
```markdown
## Windows Encoding (mandatory)

Every Python `open()` call MUST include `encoding="utf-8"`.
Every Node.js `readFileSync`/`writeFileSync` MUST use `'utf-8'`.
This is Windows — the default is cp1252, not UTF-8.
Violation = mojibake in Portuguese content. Non-negotiable.
```

### 4. [PATTERN_REPEAT] Lost Thread / Forgotten Plans

**Frequency:** 6/20 sessions (30%)
**Impact:** HIGH
**Sessions:** e667d3b9, 364598d4, 7601f49c, 63deadb3, 90b4969a, ebcdbff5

**Evidence:** Agent forgot established research prompt templates, previous commitments, and the correct tools to use. HANDOFF itself was sometimes stale/wrong.

**Proposed fix — Target: `.claude/rules/session-hygiene.md`**
```markdown
## Commitments

When the agent promises future work ("next session I will..."),
it MUST be recorded in HANDOFF.md under PROXIMO.
Conversational promises not in HANDOFF.md don't survive context overflow.
```

### 5. [PATTERN_REPEAT] Output Invisible / Changes Not Reflected

**Frequency:** 5/20 sessions (25%)
**Impact:** MEDIUM
**Sessions:** e667d3b9, b6481cfa, ffce597a, 0eb6439c, 364598d4

**Evidence:** "nao vejo no meu html", "nao vejo o que vc mudou no vite", "ele quebra nao deveria quebrar"

**Proposed fix — Target: `.claude/rules/anti-drift.md`**
```markdown
## Visual Change Verification

After editing HTML/CSS that should produce a visible change:
1. Confirm the correct file was edited (the one served by Vite, not a duplicate)
2. If Vite HMR may not pick up the change, note that restart may be needed
3. For CSS: verify specificity wins over existing rules
4. Never claim "done" on a visual change without confirming it renders
```

---

## Causal Chain

```
Context Overflow (P1, 50%)
  -> Lost Thread (P4, 30%)
  -> Forgotten Plan (P4)
  -> Unnecessary Work (P2, 40%)
  -> Output Invisible (P5, 25%)

Encoding (P3, 35%) — independent, platform-specific
```

## Action Items (ordered by impact)

1. Add proactive checkpoint rule to session-hygiene.md
2. Add commitments section to HANDOFF protocol
3. Add encoding mandate to quality.md
4. Add active inventory check to anti-drift.md
5. Strengthen visual verification gate in anti-drift.md

All proposals are additions to existing rules. No new files needed.

---

> Coautoria: Lucas + Opus 4.6
> Report generated by /insights Recipe 2 (Focused Error Audit)
