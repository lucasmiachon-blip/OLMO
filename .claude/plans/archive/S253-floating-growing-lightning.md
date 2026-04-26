# Plan — Unify everything into Conductor 2026 (single source of truth)

> **Session:** S253 INFRA_ROBUSTO · **Branch:** `feat/shell-sota-migration`
> **Lucas frame:** "unifique tudo em um plano max 3, arquive tudo, Notion fica para P2, amanhã é arrumar skills/agents/subagents/hooks por cada um dos grupos do Mermaid (12 braços Conductor) — agora é unificar documentos, não criar mais"
> **Output target:** ≤3 active plans (ideal: 1 = Conductor expanded; 2-3 = Lucas-decision-pending)

---

## Context (1 paragraph)

OLMO tem 11 plans active + 91 archived. O META plan (Conductor 2026 = `immutable-gliding-galaxy.md`) virou referência abstrata enquanto execução fragmentou em sub-plans paralelos (`audit-p5-p6-violations.md`, `fancy-imagining-crab.md`, `audit-merge-S251.md`) + plans de outras tracks (Shell migration, metanálise QA, C5 paused). Resultado: trabalho per-arm dos 12 Mermaid groups está disperso e Lucas perdeu mapeamento. Hoje = unificar tudo dentro de Conductor. Amanhã = audit per-arm (template já no Conductor §14 NEW).

---

## Folding map (3 sub-plans → Conductor sections)

| Existing plan | Folds INTO Conductor section | Action after fold |
|---------------|-----------------------------|-------------------|
| `audit-p5-p6-violations.md` (38/66 audited; 178 li) | **§12 P0(d) Progress table** (replaces brief mention with full audit state) | archive `S252-audit-p5-p6-violations.md` |
| `fancy-imagining-crab.md` (S253-S254 execution scope; ~150 li) | **§13 NEW — Active execution backlog** (S253-S254 tasks per Conductor phasing) | archive `S253-fancy-imagining-crab.md` |
| `audit-merge-S251.md` (3-model decision matrix; KBP-39 anchor) | **§6 council pattern** (already references — absorb decision matrix concrete) | archive `S251-audit-merge-S251.md` |

After fold: Conductor 2026 = 1 file containing META + audit progress + execution backlog + council methodology + 12-arm per-component matrix template (§14 NEW).

---

## Archive list (7 plans → `.claude/plans/archive/`)

| Plan | Why archive | Target filename |
|------|-------------|-----------------|
| `composed-humming-toast.md` | RESOLVED S245 (BACKLOG #13 dormancy) | `archive/S245-composed-humming-toast.md` |
| `debug-ci-hatch-build-broken.md` | PASS S250 (e2e dry-run done) | `archive/S250-debug-ci-hatch-build-broken.md` |
| `gleaming-painting-volcano.md` | DONE S244 (CLAUDE.md detox) | `archive/S244-gleaming-painting-volcano.md` |
| `debug-hooks-nao-disparam.md` | Abandoned stub (Lucas "esqueces"), 0% content | `git rm` (not archive — no content) |
| `audit-p5-p6-violations.md` | Folded into Conductor §12 | `archive/S252-audit-p5-p6-violations.md` |
| `fancy-imagining-crab.md` | Folded into Conductor §13 | `archive/S253-fancy-imagining-crab.md` |
| `audit-merge-S251.md` | Folded into Conductor §6 | `archive/S251-audit-merge-S251.md` |

After archive: `.claude/plans/*.md` count = 11 → 4 (Conductor + mellow + lovely + S239).

---

## Lucas decisions (3 floating plans → ≤3 active goal)

| Plan | Status | Lucas Q | Recommend |
|------|--------|---------|-----------|
| `mellow-scribbling-mitten.md` | Track A P0-P4 done; P5 in-flight (anti-drift.md + CLAUDE.md modified) | finish P5 + merge to main → archive? | **YES finish + archive** — close-to-done; merge desbloqueia branch |
| `lovely-sparking-rossum.md` | metanálise QA, **deadline 30/abr T-4d real** | execute / defer hard / drop? | **DEFER hard** — escope reduzido (3-5 slides priority); plan persiste mas Conductor §13 não promove |
| `S239-C5-continuation.md` | C5 shared-v2 paused S240 | resume HDMI ensaio + deck.js + presenter-safe + dialog OR archive? | **ARCHIVE** — Lucas pivotou consciente para metanálise; history preservada em git |

**End state target:** Conductor unificado (1) + lovely-sparking-rossum kept as Lucas-pending (1) = **2 active plans**. Mellow archives after Track A merge; S239 archives now.

---

## Notion repositioning (P0 → P2)

**Conductor §10 + §12 P0(c):** Currently demands Notion harvest BEFORE P0→P1 transition (Chesterton's Fence T1). Lucas (S253): **Notion → P2**.

Justification: P0 is "audit + baseline" foundation; KPI infra ✓ + audit 58% in progress são suficientes pra avançar P1. Notion harvest é "knowledge ingestion infrastructure" alinhado com P2 (sota-intake skill + cross-model docs). Re-letter:
- §10 Notion harvest-before-abandon → keep section heading mas move to P2 phasing
- §12 P0(c) Notion harvest → REMOVE from P0 deliverables
- §12 P2 deliverables → ADD "Notion harvest + categorize"

---

## NEW §14 — Per-arm component audit matrix (TEMPLATE para amanhã)

Lucas frame: "amanhã é arrumar skills/agents/subagents/hooks igual fizemos hoje mas para cada um dos grupos do Mermaid (12 braços) — eu não sei onde foi parar o que eu havia falado".

Audit P5/P6 atual (38/66 = 58%) é horizontal across all components. §14 vira o mesmo dado em corte VERTICAL por arm — exposes per-arm gaps:

```markdown
## §14 Per-arm component audit matrix

For each Conductor §4 arm (4.1 MEMORY → 4.12 CUSTOM):
| Component | Type | P5 | P6 | Status | Action |
```

**Skeleton + 1 worked example (DEBUG = strong arm):**

### §14.4 DEBUG (per Conductor §4.4)
| Component | Type | P5 | P6 | Status | Action |
|-----------|------|-----|-----|--------|--------|
| debug-symptom-collector | agent | PASS | PART 2/4 | NEED VERIFY+WHY | mechanical S253.C |
| debug-strategist | agent | PASS | PART 3.5/4 | VERIFY ✓; body WHY weak | strict body P253-004 |
| debug-archaeologist | agent | PASS | **PASS 4/4** ✓ | DONE | none |
| debug-adversarial | agent | PASS | **PASS 4/4** ✓ | DONE | none |
| debug-architect | agent | PASS | **PASS 4/4** ✓ | DONE | none |
| debug-patch-editor | agent | PASS | **PASS 4/4** ✓ | DONE | none |
| debug-validator | agent | PASS | PART 3.5/4 | VERIFY ✓; body WHY weak | strict body P253-004 |
| systematic-debugger | agent | PASS | PART 3/4 | needs VERIFY | mechanical |
| systematic-debugging | skill | (pending) | (pending) | likely fold post-H4 merge | H4 destrutivo |
| debug-team | skill | PASS | **PASS 4/4** ✓ | DONE | none |
| post-tool-use-failure | hook | PASS | PART 3/4 | needs VERIFY | mechanical |
| stop-failure-log | hook | (pending audit) | — | — | batch G |

**Arm DEBUG status:** 6/12 components DONE · 4/12 mechanical pending · 1/12 destrutivo (H4) · 1/12 audit pending. **Strongest arm post-S252 audit batch F.**

(Repeat skeleton para arms 4.1-4.3, 4.5-4.12 → trabalho de amanhã. Hoje só skeleton + DEBUG worked.)

---

## Plan execution: 4 groups sequential (gestão + ordem + verificação)

### Group A — Archive ruído (~20min, mechanical, branch-safe, no Lucas decision)

| Step | Action | Files | Verify |
|------|--------|-------|--------|
| A1 | `git mv` 3 done plans → archive/ | composed-humming-toast, debug-ci-hatch-build-broken, gleaming-painting-volcano | `ls archive/ \| grep -E "S244\|S245\|S250"` = 3 new |
| A2 | `git rm` 1 stub | debug-hooks-nao-disparam | not in `ls .claude/plans/` |
| A3 | `git mv` S239-C5 → archive (Lucas pre-recommend ARCHIVE) | S239-C5-continuation | `ls archive/S239-*` exists |
| A4 | `rm` 23 obsolete `.claude-tmp/` files (per inventory acima) | audit-*, adversarial-*, debug-team-state*, diag-*, *.sh.new, HANDOFF.md.new | `ls .claude-tmp/ \| wc -l` ≤ 5 |
| A5 | Single commit | `chore(S253): organize a casa A — archive 4 plans + cleanup .claude-tmp/` | git log shows commit |

### Group B — Fold 3 sub-plans into Conductor (~60min, sequential read+edit)

| Step | Action | File written | Verify |
|------|--------|--------------|--------|
| B1 | Read `audit-p5-p6-violations.md` full → write Conductor §12 P0(d) full progress table inline | immutable-gliding-galaxy.md §12 | §12 P0(d) cell = full table 38/66 |
| B2 | Read `fancy-imagining-crab.md` full → write Conductor §13 NEW "Active execution backlog" | immutable-gliding-galaxy.md §13 NEW | §13 exists with S253-S254 tasks |
| B3 | Read `audit-merge-S251.md` full → write Conductor §6 expansion (decision matrix concrete) | immutable-gliding-galaxy.md §6 | §6 has 3-model decision concrete + KBP-39 anchor |
| B4 | Add Conductor §14 NEW per-arm matrix skeleton + DEBUG worked example | immutable-gliding-galaxy.md §14 NEW | §14 exists with skeleton + DEBUG |
| B5 | Move Notion §10 + §12 P0(c) → P2 phasing | immutable-gliding-galaxy.md §10 + §12 | §12 P0 no longer mentions Notion; §12 P2 includes Notion |
| B6 | `git mv` 3 folded plans → archive/ | audit-p5-p6, fancy-imagining-crab, audit-merge-S251 | `ls archive/S251\|S252\|S253-*` shows 3 new |
| B7 | Single commit | `feat(S253): organize a casa B — fold 3 sub-plans into Conductor + §13 NEW + §14 per-arm template + Notion P0→P2` | git log shows commit |

### Group C — Lucas decisions (3 floating, ~5min Lucas + execution per choice)

| Plan | Lucas decision needed |
|------|----------------------|
| mellow-scribbling-mitten (Track A P5 in-flight) | finish P5 (eu termino + commit) + merge to main + archive? OR pause? |
| lovely-sparking-rossum (metanálise deadline T-4d) | execute now (escopo full) OR defer hard (3 slides priority + escopo reduzido) OR drop? |
| (S239-C5 já archived em A3 per Lucas pre-recommend) | — |

### Group D — Single source of truth (~15min, mechanical)

| Step | Action | File | Verify |
|------|--------|------|--------|
| D1 | Rewrite `HANDOFF.md` priority list → Conductor §12 phasing only (P0(d) audit + P1 redundancies + P2 incl Notion) — replace fragmented S253.A-H + P253-001-006 | HANDOFF.md | HANDOFF references "see immutable-gliding-galaxy.md §12 §13" only |
| D2 | Append `CHANGELOG.md` S253 entry — consolidate /dream + /insights + organize-a-casa | CHANGELOG.md | S253 section exists |
| D3 | `git mv` THIS plan → archive (its purpose was the act of unification) | floating-growing-lightning.md → archive/S253-floating-growing-lightning.md | `ls archive/S253-floating-*` exists |
| D4 | Single commit | `docs(S253): organize a casa D — single source truth (HANDOFF + CHANGELOG + this plan archived)` | git log shows commit |

---

## Final state (after A+B+D + Lucas decisions in C)

| State | Files |
|-------|-------|
| **1 active plan** (META Conductor unified) | `immutable-gliding-galaxy.md` |
| **+1 active if Lucas keeps lovely** (deferred but persistent) | `lovely-sparking-rossum.md` |
| **+1 active if Lucas keeps mellow** (until P5 merge) | `mellow-scribbling-mitten.md` |
| **Total active** | **1-3** (matches Lucas constraint "max 3") |
| Archived (this session adds) | 7 (4 in A, 3 in B, +1 = this in D) |
| `.claude-tmp/` reduced | 24 → ≤5 files |

---

## Verificação end-to-end (6 checkpoints)

1. `ls .claude/plans/*.md \| grep -v README \| wc -l` = 1 to 3 (was 11)
2. `ls .claude/plans/archive/S25*` shows new entries (S244/S245/S250/S251/S252/S253×2)
3. `wc -l .claude/plans/immutable-gliding-galaxy.md` increased significantly (folded 3 sub-plans + §13 + §14 NEW) — ~800-1000 li expected (was ~500)
4. `grep "Notion" .claude/plans/immutable-gliding-galaxy.md` shows §10 + §12 P2 references only (zero in P0)
5. `cat HANDOFF.md` priority list points to "Conductor §12 phasing" — no S253.A-H fragments
6. `ls .claude-tmp/ \| wc -l` ≤ 5

---

## Gestão · Ordem · Verificação (TL;DR)

**Gestão:** 1 doc canonical (Conductor) + Lucas-pending decisions tracked separately. /dream + /insights output viram input pra Conductor §12/§13 (não TODO list paralela). Per-arm audit work amanhã usa §14 template.

**Ordem:** A (cleanup) → B (fold) → C (Lucas decisions) → D (single truth + archive this plan).

**Verificação:** 6 mechanical checks listed acima. Cada Group tem commit atomic = git history conta a história ordenada.

---

## What this plan EXPLICITLY does NOT do (anti-scope-creep)

- **Não cria novos plans** — Lucas explicit "agora é unificar documentos, não criar mais". Este file é o último plan novo (auto-arquivado em D3).
- **Não executa Conductor §14 per-arm audit** — esse é trabalho de amanhã. Hoje só template + 1 worked example (DEBUG).
- **Não toca anti-drift.md OR CLAUDE.md** — Lucas P5 in-flight (race risk). Group C decision Lucas-owned.
- **Não toca content/aulas/** — production work; Group C decision para lovely-sparking-rossum.
- **Não adiciona KBP-40 hoje** — defer até P2 sota-intake skill exists (sem section pra apontar pointer).
- **Não executa /insights P253-001 backlog triage hoje** — defer; P0(d) audit completion antes de backlog triage faz sense ordem-wise.
