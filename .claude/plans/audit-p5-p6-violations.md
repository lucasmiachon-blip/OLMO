# Audit P5 (anti-teatro) + P6 (E2E + WHY-first) — Conductor 2026 P0 (d)

> **Status:** v1.0 — S251 P0 in-progress (6/67 components audited; 61 pending — P0 continues S252+)
> **Plan ref:** `.claude/plans/immutable-gliding-galaxy.md` §2 P5/P6 + §12 P0(4)
> **Methodology:** read frontmatter + first 50 li of each component, score against 7 criteria
> **Cadence:** ~6-10 components per session; full P0 audit completes in ~7-10 sessions

---

## Methodology — 7 criteria (P5: 3 + P6: 4)

| Code | Criterion | What to check |
|------|-----------|---------------|
| **5a** | Trigger objetivo | Declared invocation condition (frontmatter + body — não "quando parecer útil") |
| **5b** | Artefato concreto | Output file/format/structure documented |
| **5c** | Consumer real | Who/what consumes the artifact downstream (não vacuum) |
| **6a** | WHAT (1-line) | Frontmatter `description:` (canonical Anthropic spec) |
| **6b** | WHY (problem + evidence T1/T2) | Section/header explica problema solved + cita source |
| **6c** | HOW (1-line architecture) | Pipeline/phases/algorithm visível |
| **6d** | VERIFY (smoke test path) | `scripts/smoke/{name}.sh` ou equivalent reprodutível |

**Score per component:** P5 (3-of-3 PASS / 2-of-3 PARTIAL / ≤1 FAIL); P6 (4-of-4 PASS / 2-3 PARTIAL / ≤1 FAIL)

**Action thresholds:**
- P5 FAIL → backlog purge candidate (teatro)
- P6 FAIL → backlog refactor (add WHY + VERIFY headers; não destrutivo)
- P5 PARTIAL → flag, monitor (consumer ambíguo é early warning)
- P6 PARTIAL → backlog incremental (add missing criterion)

---

## AUDITED (6/67) — first batch

| # | Component | Type | 5a | 5b | 5c | P5 | 6a | 6b | 6c | 6d | P6 | Action |
|---|-----------|------|----|----|----|----|----|----|----|----|----|--------|
| 1 | `sentinel` | agent | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ✓ | ✗ | **PARTIAL 2/4** | add WHY + VERIFY |
| 2 | `repo-janitor` | agent | ✓ | ✓ | ?* | **PARTIAL** | ✓ | ✗ | ✓ | ✗ | **PARTIAL 2/4** | clarify consumer + add WHY/VERIFY |
| 3 | `qa-engineer` | agent | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ✓ | ✗ | **PARTIAL 2/4** | add WHY + VERIFY |
| 4 | `research` | skill | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ✓ | ✗ | **PARTIAL 2/4** | add WHY + VERIFY |
| 5 | `improve` | skill | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ✓ | ✗ | **PARTIAL 2/4** | add WHY + VERIFY |
| 6 | `insights` | skill | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ✓ | ✗ | **PARTIAL 2/4** | add WHY + VERIFY |

*repo-janitor 5c: consumer ambíguo (orchestrator ou Lucas direto? `--fix` mode mentions Lucas approve mas default REPORT mode unclear consumption)

### Observed pattern (confidence: high — n=6)

**P5 (anti-teatro):** 5/6 PASS, 1/6 PARTIAL. OLMO components ARE functionally sound — triggers + artifacts + consumers existem. Não há "teatro flagrante" em camada agent/skill alta-frequência.

**P6 (WHY-first + VERIFY) cross-cutting violation:** 6/6 PARTIAL — todos têm WHAT + HOW; ZERO têm WHY com evidence T1/T2 cited; ZERO têm smoke test. Confirma Lucas diagnose "explicar SEMPRE" gap. Não é "teatro" mas é débito documental sistemático.

**Implicação:** P0 audit não justifica purge — justifica REFACTOR doc headers. P1+ priority: template `WHY:` + `VERIFY:` em CADA agent/.md, skill/SKILL.md, hook/.sh.

---

## PENDING audit (61/67)

### Agents (13 pending of 16)
- [ ] `mbe-evaluator`
- [ ] `quality-gate`
- [ ] `researcher`
- [ ] `systematic-debugger`
- [ ] `evidence-researcher`
- [ ] `reference-checker`
- [ ] `debug-symptom-collector`
- [ ] `debug-strategist`
- [ ] `debug-archaeologist`
- [ ] `debug-adversarial`
- [ ] `debug-architect`
- [ ] `debug-patch-editor`
- [ ] `debug-validator`

### Skills (16 pending of 19)
- [ ] `docs-audit`
- [ ] `brainstorming`
- [ ] `concurso`
- [ ] `systematic-debugging` (likely fold post-H4 merge)
- [ ] `exam-generator`
- [ ] `janitor` (likely delete post-X1 merge)
- [ ] `skill-creator`
- [ ] `evidence-audit`
- [ ] `nlm-skill`
- [ ] `knowledge-ingest`
- [ ] `automation`
- [ ] `teaching`
- [ ] `continuous-learning`
- [ ] `review`
- [ ] `debug-team`
- [ ] (1 reserve slot — may add)

### Hooks (32 pending of 32)

`.claude/hooks/` (17):
- [ ] `guard-secrets.sh`
- [ ] `allow-plan-exit.sh`
- [ ] `chaos-inject-post.sh` (likely refactor post-X3)
- [ ] `coupling-proactive.sh`
- [ ] `guard-mcp-queries.sh`
- [ ] `guard-read-secrets.sh`
- [ ] `guard-research-queries.sh`
- [ ] `lint-on-edit.sh`
- [ ] `model-fallback-advisory.sh` (likely refactor post-X3)
- [ ] `momentum-brake-clear.sh`
- [ ] `nudge-checkpoint.sh`
- [ ] `post-bash-handler.sh`
- [ ] `guard-lint-before-build.sh`
- [ ] `post-global-handler.sh`
- [ ] `momentum-brake-enforce.sh`
- [ ] `guard-bash-write.sh`
- [ ] `guard-write-unified.sh`

`hooks/` (15):
- [ ] `notify.sh`
- [ ] `stop-notify.sh`
- [ ] `ambient-pulse.sh`
- [ ] `nudge-commit.sh`
- [ ] `session-compact.sh`
- [ ] `session-end.sh`
- [ ] `stop-quality.sh`
- [ ] `pre-compact-checkpoint.sh`
- [ ] `session-start.sh`
- [ ] `stop-metrics.sh`
- [ ] `stop-failure-log.sh`
- [ ] `apl-cache-refresh.sh`
- [ ] `post-compact-reread.sh`
- [ ] `post-tool-use-failure.sh`
- [ ] `loop-guard.sh`

---

## Aggregate (will update each session)

| Metric | Current | After full P0 |
|--------|---------|----------------|
| Components audited | 6/67 (8.9%) | 67/67 (100%) |
| P5 PASS rate | 5/6 (83%) | TBD |
| P6 PASS rate | 0/6 (0%) | TBD |
| P6 PARTIAL (≥1 criterion) | 6/6 (100%) | TBD |
| P6 FAIL (≤1 criterion) | 0/6 (0%) | TBD |

**Hypothesis (confidence: medium):** P6 PARTIAL ratio holds at ≥80% across full 67. WHY-first headers + VERIFY smoke tests are systematic gap, not isolated.

---

## Next session continuation prompt

```
Continue audit-p5-p6-violations.md — audit next 6-10 components from PENDING list.
Priority order: (1) high-usage agents (debug-* family + evidence-researcher);
(2) hooks core path (guard-write-unified, guard-bash-write, lint-on-edit, ambient-pulse);
(3) skills high-impact (debug-team, knowledge-ingest, evidence-audit, automation).
Update Aggregate table after each batch.
```

---

## Smoke test (P6 deliverable for THIS file — meta)

`scripts/smoke/audit-p5-p6.sh` (P1+ NEW):
- Verifies file exists + parses methodology section + 7 criteria + AUDITED + PENDING tables
- Counts AUDITED rows + PENDING checkboxes; sum = 67
- Greps Aggregate table for "Components audited" + extracts ratio
- Exit 0 if file structurally valid

(Recursive verify — this audit doc itself audited via this smoke test.)
