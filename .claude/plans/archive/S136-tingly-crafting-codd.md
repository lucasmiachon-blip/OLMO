# S136: build slides + poda

## Context

S135 created s-importancia (all source files) but never rebuilt index.html. Lucas wants to remove 3 slides (s-grade, s-abstract, s-aplicacao) and prune 1 memory file. GRADE mentions in remaining slides stay untouched.

---

## P0 — Build s-importancia

All source files exist and are complete. Only the build is missing.

1. Run `cd /c/Dev/Projetos/OLMO/content/aulas && npm run build:metanalise`
   - Lint runs automatically via `guard-lint-before-build.sh` hook
2. Verify: grep index.html for `s-importancia` (should appear between s-hook and s-rs-vs-ma)
3. STOP. Report.
4. Delete mockups: `.claude/mockup-importancia-A.html`, `.claude/mockup-importancia-B.html`

---

## P1 — Remove 3 slides

### Slide 1: s-grade
- Delete `slides/08-grade.html`
- Remove manifest line 29
- Remove CSS lines 548-593 (`.grade-stack`, `.grade-level`, `.grade-label`, `.grade-meaning`, `.grade-icon`, color variants)
- KEEP CSS lines 1022-1030 (`.checkpoint-grade`) — used by s-checkpoint-2
- Delete `qa-screenshots/s-grade/` directory

### Slide 2: s-abstract
- Delete `slides/05-abstract.html`
- Remove manifest line 26
- Remove CSS lines 466-505 (`.pipeline-flow`, `.pipeline-step`, `.pipeline-arrow`, `.pipeline-label`, `.pipeline-detail`)
- Delete `qa-screenshots/s-abstract/` directory

### Slide 3: s-aplicacao
- Delete `slides/14-aplicacao.html`
- Remove manifest line 38
- KEEP `.compare-footer` CSS — shared with s-rs-vs-ma, s-fixed-random, s-benefit-harm
- Remove `.compare-footer--gap` CSS (line 1305) — only used by s-aplicacao
- Delete `qa-screenshots/s-aplicacao/` directory

### Cross-references to update
- `narrative.md` lines 88, 91, 130, 135, 139: remove slide-specific references to abstract (item 3), GRADE slide (item 6), aplicacao (slide 14). GRADE as concept stays.
- `blueprint.md`: remove status entries for slides 05, 08, 14
- `_archived/archetypes.md`: leave as-is (already archived reference)
- `HANDOFF.md` (metanalise): remove from deck order + slide table

### NOT touched (GRADE mentions stay)
- slides/01-hook.html, 02-contrato.html, 04-pico.html, 07-benefit-harm.html
- slides/12-checkpoint-2.html, 16-absoluto.html, 17-takehome.html
- Manifest headlines for benefit-harm, checkpoint-2, aplicacao references in OTHER slides

### After all removals
- `npm run build:metanalise` (rebuild with 16 slides instead of 19)
- `npm run lint:slides` verify

---

## P2 — Memory pruning

- DELETE: `reference_notion_databases.md` (Notion froze)
- KEEP: all others (adversarial_review, self_improvement, all feedback/patterns/project files)
- Update `MEMORY.md` index: remove Notion entry, update count to 19/20

---

## Execution order

```
P0.1 build   → P0.2 verify   → P0.3 mockup cleanup
  → P1.1 delete 3 slides + CSS + manifest
  → P1.2 rebuild
  → P1.3 update narrative/blueprint/HANDOFF references
  → P2 memory prune
  → commit + session HANDOFF/CHANGELOG
```

## Verification

- P0: `grep "s-importancia" index.html` > 0 matches
- P1: `grep "s-grade\|s-abstract\|s-aplicacao" index.html` = 0 matches; slide count = 16
- P1: lint passes
- P2: `ls memory/*.md | wc -l` = 20 (19 topics + MEMORY.md)

## Files touched

| File | Action |
|------|--------|
| `metanalise/index.html` | Rebuilt (2x) |
| `slides/08-grade.html` | DELETE |
| `slides/05-abstract.html` | DELETE |
| `slides/14-aplicacao.html` | DELETE |
| `slides/_manifest.js` | Remove 3 entries |
| `metanalise.css` | Remove ~92 lines (grade + pipeline + compare-footer--gap) |
| `qa-screenshots/s-grade/` | DELETE dir |
| `qa-screenshots/s-abstract/` | DELETE dir |
| `qa-screenshots/s-aplicacao/` | DELETE dir |
| `references/narrative.md` | Update F2/F3 content lists |
| `references/blueprint.md` | Remove 3 slide entries |
| `metanalise/HANDOFF.md` | Update deck order + counts |
| `.claude/mockup-importancia-*.html` | DELETE (2 files) |
| `memory/reference_notion_databases.md` | DELETE |
| `memory/MEMORY.md` | Update index |
