# S226 post-close++: Sync 3 active plans to reality

> Status: PROPOSED (plan mode) | 2026-04-17
> Origin: Lucas "quais planos ainda estao ativos? todoas atualizados?" — Option B sync approved

---

## Context

S226 CLOSED com 9 commits (purga-cowork via ADR-0002/KBP-24). Auditoria pós-close revelou 3 active plan files desincronizados com realidade executada. Para "começar amanhã onde paramos" ser verdade, plans precisam ser leitura fidedigna.

Findings (read-only verification):

1. **`ACTIVE-S225-SHIP-roadmap.md`** (217 li) — S225 não marcado DONE; S226 section declara "DE Fase 2 ship" (não aconteceu — pivot para purga); S227 planejado era semantic memory mas HANDOFF S227 TARGETS prioritiza BACKLOG #34 diferente.

2. **`ACTIVE-S226-memory-to-living-html.md`** (159 li) — nomenclatura enganosa (S226 não executou — pivot). HANDOFF S227 TARGET #4 o lista como low-priority carry-forward. Conteúdo válido.

3. **`ACTIVE-snoopy-jingling-aurora.md`** (221 li) — **EXECUTADO** (confirmado via Grep):
   - `qa-capture.mjs:342` → `typographyHierarchy` (E1 shipped)
   - `gemini-qa3.mjs:531` → `validateFixTokens` function (E4 shipped)
   - `gemini-qa3.mjs:1228-1229` → `{{TYPOGRAPHY_HIERARCHY}}` + `{{SPACING_MAP}}` placeholders (E5 shipped)
   - Commit `a940234 S204: Pipeline I/O Hardening + s-takehome functional + APCA tooling` = execution session
   - Naming fora convention ACTIVE-S{N} e plan cumprido — candidato a archive S204.

---

## Goal

Alinhar plan files com realidade pós-S226:
- SHIP roadmap reflete S225 DONE + S226 pivot + S227 realigned
- Snoopy archived como S204 (executed)
- Memory-to-living renomeado S227 (per HANDOFF target)
- Cross-refs internos atualizados (HANDOFF + SHIP roadmap)

---

## Scope — 3 files + 1 HANDOFF cross-ref, 1 commit

### A. Edit `ACTIVE-S225-SHIP-roadmap.md`

Minimal updates — preserve S228-S230 future planning intact:

- **L37 header:** `### S225 — Codex debt zero + memory audit (2.5-3h)` → `### S225 — Codex debt zero + memory audit [DONE 2026-04-17, 12 commits]`
- **L50-61 S226 block:** rewrite entirely. Replace "Design Excellence Fase 2 ship" track com "PIVOT to purga-cowork (ADR-0002/KBP-24, 9 commits) — DE Fase 2 deferred to S227+". Preserve deliverables format but update com actual outcomes (41 cowork refs → 0 drift, ADR-0002 created, KBP-24 + KBP-25).
- **L55 ref update:** "Validate via ACTIVE-snoopy-jingling-aurora pipeline (prerequisite)" → "ACTIVE-snoopy-jingling-aurora shipped S204 (archived plans/archive/S204-snoopy-jingling-aurora.md)"
- **L63-76 S227 block:** align com HANDOFF S227 TARGETS. Was "Semantic memory ship only"; now include P0 BACKLOG #34 + Track A semantic memory + DE Fase 2 carried from S226.
- **L161 Critical files table S226 row:** update com actual artifacts (docs/adr/0002-*, .claude/rules/anti-drift.md §6 additions, etc).
- **L161 Critical files table S227 row:** adjust per new S227 scope.

**Sections preserved:** Context, Thesis, S228-S230, KPIs, Risks, Success definition, Out of scope, Gate review.

### B. Archive snoopy (shipped S204)

1. Edit `ACTIVE-snoopy-jingling-aurora.md` — add archive header (1 line at top):
   ```
   <!-- SHIPPED S204 (commit a940234 "Pipeline I/O Hardening"). E1-E5 artifacts verified em qa-capture.mjs + gemini-qa3.mjs. Archived S226 post-close. -->
   ```
2. `git mv .claude/plans/ACTIVE-snoopy-jingling-aurora.md .claude/plans/archive/S204-snoopy-jingling-aurora.md`

### C. Rename memory-to-living-html S226→S227

1. Edit status header L3:
   ```
   > Status: DESIGN (proposto S225 iter 3, execução S226)
   ```
   →
   ```
   > Status: DESIGN (proposto S225 iter 3, reprogramado S227 non-P0 per HANDOFF target #4 / BACKLOG #36)
   ```
2. `git mv .claude/plans/ACTIVE-S226-memory-to-living-html.md .claude/plans/ACTIVE-S227-memory-to-living-html.md`

### D. HANDOFF cross-ref update

Line 6 of HANDOFF.md currently references `.claude/plans/ACTIVE-S226-memory-to-living-html.md`. Update to `.claude/plans/ACTIVE-S227-memory-to-living-html.md`.

Also check HANDOFF for other refs to snoopy plan or memory-to-living path — update if found.

---

## Critical files (modification list)

| File | Action | Risk |
|------|--------|------|
| `.claude/plans/ACTIVE-S225-SHIP-roadmap.md` | Edit (6 targeted ranges) | LOW |
| `.claude/plans/ACTIVE-snoopy-jingling-aurora.md` | Edit (header) + git mv → archive | LOW |
| `.claude/plans/ACTIVE-S226-memory-to-living-html.md` | Edit (status header) + git mv → S227 naming | LOW |
| `HANDOFF.md` | Edit (1+ ref updates) | LOW |

---

## Verification

1. `ls .claude/plans/ACTIVE-*.md` → retorna 2 files: `ACTIVE-S225-SHIP-roadmap.md` + `ACTIVE-S227-memory-to-living-html.md` (snoopy gone)
2. `ls .claude/plans/archive/S204-snoopy-jingling-aurora.md` → exists
3. `grep -n "ACTIVE-S226-memory" HANDOFF.md` → 0 matches (stale ref removed)
4. `grep -n "ACTIVE-snoopy" HANDOFF.md .claude/plans/ACTIVE-*.md` → 0 matches ou só refs to archive path
5. Git log shows single commit com rename registered via `git mv` (preserves history)
6. `git status --short` clean post-commit

---

## Budget

~15-20min:
- SHIP roadmap edits (~8min, 6 small Edits no mesmo file)
- Header edits snoopy + memory (~2min)
- 2 git mv (~1min)
- HANDOFF ref update (~2min)
- Commit + push (~2min)

---

## Commits

Single atomic commit:
```
S226 post-close+: sync 3 active plans to reality

- SHIP roadmap: mark S225 DONE, S226 pivot noted, S227 realigned
- Archive snoopy-jingling-aurora (shipped S204, artifacts verified)
- Rename memory-to-living-html S226→S227 (HANDOFF target #4)
- Cross-refs updated em HANDOFF + SHIP roadmap

Post-sync state: 2 active plans + 1 new archived.
```

Push origin/main após commit.

---

## Risks + mitigations

- **LOW — git mv em untracked files:** se memory-to-living-html nunca foi committed, `git mv` behaves como regular mv (untracked). Mitigation: check `git ls-files .claude/plans/` antes; fallback para regular `mv` se untracked.
- **LOW — HANDOFF Edit precision:** file recently rewritten (Phase E commit 2e4d836). Old_string precisa match exato. Mitigation: Read region antes de Edit (per KBP-25 shipped rule).
- **LOW — SHIP roadmap S226 rewrite grande:** 12 linhas modificadas. Mitigation: Edit surgical per section, não Write full (preserve S228-S230 intacto per anti-drift §State files).

---

## Out of scope

- Rewriting SHIP roadmap S228-S230 (future planning, não precisa update now)
- Updating ACTIVE-S227-memory-to-living-html.md content interno (só naming+status sync)
- Any new rules, hooks, or infra
- Reviewing if Melhorias1.1 discipline rules ainda relevantes (kept em HANDOFF como target #5 para Lucas decidir)

---

## Decision points Lucas

None — B approved, proceed após este plan approved. Executar imediatamente após ExitPlanMode.

---

Coautoria: Lucas + Opus 4.7 | S226 post-close+ sync plan | 2026-04-17
