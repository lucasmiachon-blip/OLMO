# Audit P5 (anti-teatro) + P6 (E2E + WHY-first) — Conductor 2026 P0 (d)

> **Status:** v1.1 — S251 P0 in-progress (14/67 components audited; 53 pending — P0 continues S252+)
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

## AUDITED (14/67) — batches A + B

| # | Component | Type | 5a | 5b | 5c | P5 | 6a | 6b | 6c | 6d | P6 | Action |
|---|-----------|------|----|----|----|----|----|----|----|----|----|--------|
| 1 | `sentinel` | agent | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ✓ | ✗ | **PART 2/4** | add WHY + VERIFY |
| 2 | `repo-janitor` | agent | ✓ | ✓ | ?* | **PART** | ✓ | ✗ | ✓ | ✗ | **PART 2/4** | clarify consumer + WHY + VERIFY |
| 3 | `qa-engineer` | agent | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ✓ | ✗ | **PART 2/4** | add WHY + VERIFY |
| 4 | `research` | skill | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ✓ | ✗ | **PART 2/4** | add WHY + VERIFY |
| 5 | `improve` | skill | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ✓ | ✗ | **PART 2/4** | add WHY + VERIFY |
| 6 | `insights` | skill | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ✓ | ✗ | **PART 2/4** | add WHY + VERIFY |
| 7 | `debug-architect` | agent | ✓ | ✓ | ✓ | **PASS** | ✓ | ✓** | ✓ | ✗ | **PART 3/4** | add VERIFY only |
| 8 | `debug-validator` | agent | ✓ | ✓ | ✓ | **PASS** | ✓ | ~ | ✓ | ✗ | **PART 3/4** | strengthen WHY + VERIFY |
| 9 | `debug-strategist` | agent | ✓ | ✓ | ✓ | **PASS** | ✓ | ~ | ✓ | ✗ | **PART 3/4** | strengthen WHY + VERIFY |
| 10 | `evidence-researcher` | agent | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ~ | ✗ | **FAIL 1/4** | full WHY+HOW+VERIFY refactor |
| 11 | `guard-write-unified.sh` | hook | ✓ | ✓ | ✓ | **PASS** | ✓ | ✓*** | ✓ | ✗ | **PART 3/4** | add VERIFY |
| 12 | `ambient-pulse.sh` | hook | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ✓ | ✗ | **PART 2/4** | add WHY + VERIFY |
| 13 | `debug-team` | skill | ✓ | ✓ | ✓ | **PASS** | ✓ | ✓**** | ✓ | ✗ | **PART 3/4** | add VERIFY |
| 14 | `knowledge-ingest` | skill | ✓ | ✓ | ✓ | **PASS** | ✓ | ✓***** | ✓ | ✗ | **PART 3/4** | add VERIFY |

\* repo-janitor 5c: ambíguo (`--fix` Lucas-approve OK; default REPORT mode unclear consumption)
\*\* debug-architect 6b: cita Aider 2024-09 study (T1) "Architect+Editor 85% vs 75% solo" — exemplary
\*\*\* guard-write-unified 6b: comment cita "S194 Fase 2 merge — 0 node spawns (was 4)" — concrete benchmark
\*\*\*\* debug-team 6b: cita "Anthropic taxonomy nível 6" + S248 archive + sota-synthesis 60 fontes (T1+T2)
\*\*\*\*\* knowledge-ingest 6b: §"Por que isso importa" section explícita (Lucas roles + R3 + knowledge base)

### Observed pattern (confidence: high — n=14)

**P5 (anti-teatro):** 13/14 PASS (93%), 1/14 PARTIAL. OLMO components ARE functionally sound — triggers + artifacts + consumers existem. Não há teatro flagrante.

**P6 (WHY-first + VERIFY):** 0/14 PASS, 14/14 PARTIAL/FAIL. **Stratification:**
- **5/14 com P6 3/4** (close to PASS — apenas 6d VERIFY missing): debug-architect, debug-validator, debug-strategist, debug-team, knowledge-ingest, guard-write-unified
- **8/14 com P6 2/4** (WHY + VERIFY missing): sentinel, repo-janitor, qa-engineer, research, improve, insights, ambient-pulse, debug-validator/strategist (weak WHY)
- **1/14 com P6 1/4** (FAIL): evidence-researcher (only 6a)

**Insight refinado:** debug-team subgraph + skills com history claim (knowledge-ingest, guard-write-unified) já citam evidence T1/T2 (Aider study, Anthropic taxonomy, S194/S248 sessions). Agents legados (sentinel, repo-janitor, qa-engineer, evidence-researcher) carecem de WHY. **Padrão:** componentes recentes (S248+) têm doc-quality maior; legados precisam refactor.

**Implicação P1+:** template universal `WHY:` (1-line problem + 1-line evidence T1/T2) + `VERIFY:` (smoke test path) em todos os 67. Refactor não-destrutivo. Priority: 9 com P6 ≤2/4 primeiro.

---

## PENDING audit (61/67)

### Agents (9 pending of 16; 7 audited)
- [ ] `mbe-evaluator`
- [ ] `quality-gate`
- [ ] `researcher`
- [ ] `systematic-debugger`
- [ ] `reference-checker`
- [ ] `debug-symptom-collector`
- [ ] `debug-archaeologist`
- [ ] `debug-adversarial`
- [ ] `debug-patch-editor`

### Skills (14 pending of 19; 5 audited)
- [ ] `docs-audit`
- [ ] `brainstorming`
- [ ] `concurso`
- [ ] `systematic-debugging` (likely fold post-H4 merge)
- [ ] `exam-generator`
- [ ] `janitor` (likely delete post-X1 merge)
- [ ] `skill-creator`
- [ ] `evidence-audit`
- [ ] `nlm-skill`
- [ ] `automation`
- [ ] `teaching`
- [ ] `continuous-learning`
- [ ] `review`
- [ ] (1 reserve slot — may add)

### Hooks (32 pending of 32)

`.claude/hooks/` (16 pending; 1 audited):
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

`hooks/` (14 pending; 1 audited):
- [ ] `notify.sh`
- [ ] `stop-notify.sh`
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
| Components audited | 14/67 (20.9%) | 67/67 (100%) |
| P5 PASS rate | 13/14 (93%) | TBD |
| P6 PASS rate | 0/14 (0%) | TBD |
| P6 PARTIAL 3/4 (close to PASS) | 6/14 (43%) | TBD |
| P6 PARTIAL 2/4 | 7/14 (50%) | TBD |
| P6 FAIL ≤1/4 | 1/14 (7%) | TBD |

**Hypothesis refinada (confidence: high — n=14):** P6 gap concentrado em (a) ZERO smoke tests (6d FAIL universal), (b) WHY-first ausente em agents legados pré-S248. Componentes recentes (debug-team subgraph S248+, knowledge-ingest, guard-write-unified S194) já citam evidence — pattern de qualidade temporal: doc-quality melhora com data.

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
