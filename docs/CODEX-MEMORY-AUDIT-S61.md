# Codex Memory & Docs Audit — S61

> 2026-04-04 | Codex GPT-5.4 via Claude Code rescue
> Frame: Objetivo (round 1 complete) + Adversarial (pending) + Cross-ref (pending)
> Status: PARTIAL — 1/4 reports received. Will be updated as remaining arrive.
>
> **AVISO:** Verdicts do Codex NAO foram validados com cross-reference real.
> Cada file precisa de leitura + grep nos canonicos antes de qualquer acao.
> 6 files foram movidos para archive prematuramente e restaurados na mesma sessao.

## Summary (Objective Round 1)

- **Total memory files:** 38 (+ MEMORY.md index, + 2 runtime markers)
- **Estimated tokens:** ~13.5k across all memories
- **Stale:** 3 | **Redundant:** 17 | **Should-never-exist:** 10

## Actions Taken (S61)

### Archived (6 files → memory/.archive/)
| File | Reason |
|------|--------|
| `facts_teaching.md` | Ephemeral self-assessment, belongs in lesson notes |
| `project_metanalise_deadline.md` | Deadline snapshot, already in HANDOFF |
| `project_metanalise_projetor.md` | One-off presentation setup note |
| `project_metanalise_reorientation.md` | Session-specific recovery, already in CHANGELOG |
| `reference_css_mcp_fallback.md` | Transient debug fallback plan |
| `reference_screenshots_path.md` | Environment-specific path, belongs in prefs/docs |

### Kept (Codex said DELETE, we disagree)
| File | Reason to keep |
|------|----------------|
| `.last-dream` | Runtime marker for /dream skill, NOT a memory |
| `.last-insights` | Runtime marker for /insights skill, NOT a memory |
| `reference_notion_databases.md` | Notion DB IDs not stored anywhere else in codebase |

## Pending: CONSOLIDATE (17 files)

These memories duplicate content in rules/CLAUDE.md. Each needs review before action:
consolidate = merge unique content into the rule/doc, then delete the memory.

| Memory | Duplicates | Action needed |
|--------|-----------|---------------|
| `feedback_anti-sycophancy.md` | global CLAUDE.md Communication + project ENFORCEMENT | Review if any unique content |
| `feedback_context_rot.md` | CLAUDE.md Self-Improvement + HANDOFF CUIDADOS | Review |
| `feedback_h2_assertions.md` | CLAUDE.md + slide-rules.md h2-as-assertion | Review |
| `feedback_living_html_validated.md` | CLAUDE.md living-HTML workflow | Review |
| `feedback_mentor_autonomy.md` | global + project CLAUDE.md autonomy rules | Review |
| `feedback_monorepo_migration.md` | CLAUDE.md Key Files / migration warnings | Review |
| `feedback_narrative_citation_format.md` | slide-rules.md §3 / design-reference.md §3 | Review |
| `feedback_no_parameter_guessing.md` | anti-drift.md verification gate | Review |
| `feedback_qa_screenshots_cleanup.md` | HANDOFF CUIDADOS + QA workflow | Review |
| `feedback_qa_use_cli_not_mcp.md` | content/aulas/README.md scripts | Review |
| `feedback_rebuild_before_qa.md` | HANDOFF + content/aulas/README.md | Review |
| `feedback_slides_build_pipeline.md` | content/aulas/README.md + slide-rules.md | Review |
| `patterns_fail_closed.md` | mcp_safety.md fail-closed policy | Review |
| `patterns_staged_blob.md` | CLAUDE.md staged-blob guidance | Review |
| `project_codex_doc_review_bug.md` | project_tooling_pipeline.md + CHANGELOG | Review |
| `project_living_html_roadmap.md` | CLAUDE.md + CHANGELOG roadmap | Review |
| `project_nlm_research_leg.md` | project_tooling_pipeline.md + CHANGELOG S56 | Review |

## Pending: UPDATE (3 files)

| File | Issue |
|------|-------|
| `feedback_css_inline.md` | Conflicts with slide-rules.md §1/§2 — needs tighter wording |
| `feedback_hook_events_valid.md` | Missing current hook events, stale list |
| `MEMORY.md` | Index stale, mixes status/policy, quick-ref counts wrong |

## Pending: Docs

| Item | Issue |
|------|-------|
| `.claude/hooks/README.md` | Documents retired hooks, missing 8 current hooks |
| `CLAUDE.md` | Some sections should be path-scoped rules (aulas workflow, hooks, Notion, QA) |
| `MEMORY.md` quick-reference | Says "5 path-scoped rules" but there are 6 |

## Governance Proposals (from Codex)

1. **Cap at 20 active memory files.** Archive/delete before adding new.
2. **Create only if:** durable + non-derivable + not in CLAUDE/rules/HANDOFF/CHANGELOG + unique
3. **Session state → HANDOFF.** History → CHANGELOG. Never both as memory.
4. **Policy/invariant → rules/ or CLAUDE.md**, not memory.
5. **Consolidate first, create second.** If concept has a memory, update it.

## Remaining Reports (pending)

- [ ] Adversarial round 1 — submitted, running
- [ ] Objective round 2 (forced cross-ref + attention loss research) — submitted, running
- [ ] Adversarial round 2 (forced cross-ref + attention loss research) — submitted, running

Findings from these will be appended when they arrive.

---
Coautoria: Lucas + Opus 4.6 + Codex GPT-5.4 | 2026-04-04
