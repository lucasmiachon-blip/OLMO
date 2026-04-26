# Audit P5 (anti-teatro) + P6 (E2E + WHY-first) — Conductor 2026 P0 (d)

> **Status:** v1.2 — S251 P0 in-progress (20/67 components audited; 47 pending — P0 continues S252+)
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

## AUDITED (20/67) — batches A + B + C

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
| 15 | `debug-symptom-collector` | agent | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ✓ | ✗ | **PART 2/4** | add WHY + VERIFY |
| 16 | `debug-archaeologist` | agent | ✓ | ✓ | ✓ | **PASS** | ✓ | ✓† | ✓ | ✗ | **PART 3/4** | add VERIFY |
| 17 | `lint-on-edit.sh` | hook | ✓ | ✓ | ✓ | **PASS** | ✓ | ✓‡ | ✓ | ✗ | **PART 3/4** | add VERIFY |
| 18 | `guard-bash-write.sh` | hook | ✓ | ✓ | ✓ | **PASS** | ✓ | ✓§ | ✓ | ✗ | **PART 3/4** | add VERIFY |
| 19 | `evidence-audit` | skill | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ✓ | ✗ | **PART 2/4** | add WHY + VERIFY |
| 20 | `automation` | skill | ~ | ✓ | ? | **PART** | ✓ | ✗ | ~ | ✗ | **FAIL 1-2/4** | full refactor (trigger + consumer + WHY + HOW + VERIFY) |

\* repo-janitor 5c: ambíguo (`--fix` Lucas-approve OK; default REPORT unclear)
\*\* debug-architect 6b: Aider 2024-09 study T1 "85% vs 75% solo" — exemplary
\*\*\* guard-write-unified 6b: "S194 Fase 2 merge — 0 node spawns (was 4)"
\*\*\*\* debug-team 6b: Anthropic nível 6 + S248 archive + sota-synthesis 60 fontes
\*\*\*\*\* knowledge-ingest 6b: §"Por que isso importa" section explícita
† debug-archaeologist 6b: cita "Gemini 3.1 Pro 1M ctx" rationale + D8 MAS path
‡ lint-on-edit 6b: cita "Antifragile L5" + "L1 retry S89: jitter"
§ guard-bash-write 6b: cita "Codex audit S57" + "jq 10x faster than node S193" — concrete benchmarks

### Observed pattern (confidence: high — n=20)

**P5 (anti-teatro):** 18/20 PASS (90%), 2/20 PARTIAL (repo-janitor consumer; automation trigger+consumer+HOW). Sem teatro flagrante mas `automation` é early warning — frontmatter description tão vague que nem trigger objetivo emerge.

**P6 (WHY-first + VERIFY):** 0/20 PASS. Stratification:
- **9/20 com P6 3/4** (close — só falta VERIFY 6d): debug-architect, debug-validator, debug-strategist, debug-team, knowledge-ingest, guard-write-unified, debug-archaeologist, lint-on-edit, guard-bash-write
- **9/20 com P6 2/4** (WHY+VERIFY ausentes): sentinel, repo-janitor, qa-engineer, research, improve, insights, ambient-pulse, debug-symptom-collector, evidence-audit
- **2/20 com P6 ≤1.5/4 FAIL**: evidence-researcher, automation

**Insight reforçado:** **dois clusters distintos** —
- **High-quality** (S194+ + debug-team subgraph): citam sessions/papers/benchmarks concretos — **simplesmente falta smoke test (VERIFY)**
- **Legacy** (pré-S248 agents/skills brief): WHAT-only frontmatter; **precisam refactor doc completo** (WHY+VERIFY)

**Implicação P1+:** 9 componentes alta-qualidade só precisam template `VERIFY: scripts/smoke/{name}.sh` adicionado — trabalho mecânico. 9-11 legacy precisam full WHY refactor (~10-15 min cada). Priority order já clara.

---

## PENDING audit (61/67)

### Agents (7 pending of 16; 9 audited)
- [ ] `mbe-evaluator`
- [ ] `quality-gate`
- [ ] `researcher`
- [ ] `systematic-debugger`
- [ ] `reference-checker`
- [ ] `debug-adversarial`
- [ ] `debug-patch-editor`

### Skills (12 pending of 19; 7 audited)
- [ ] `docs-audit`
- [ ] `brainstorming`
- [ ] `concurso`
- [ ] `systematic-debugging` (likely fold post-H4 merge)
- [ ] `exam-generator`
- [ ] `janitor` (likely delete post-X1 merge)
- [ ] `skill-creator`
- [ ] `nlm-skill`
- [ ] `teaching`
- [ ] `continuous-learning`
- [ ] `review`
- [ ] (1 reserve slot — may add)

### Hooks (32 pending of 32)

`.claude/hooks/` (14 pending; 3 audited):
- [ ] `guard-secrets.sh`
- [ ] `allow-plan-exit.sh`
- [ ] `chaos-inject-post.sh` (likely refactor post-X3)
- [ ] `coupling-proactive.sh`
- [ ] `guard-mcp-queries.sh`
- [ ] `guard-read-secrets.sh`
- [ ] `guard-research-queries.sh`
- [ ] `model-fallback-advisory.sh` (likely refactor post-X3)
- [ ] `momentum-brake-clear.sh`
- [ ] `nudge-checkpoint.sh`
- [ ] `post-bash-handler.sh`
- [ ] `guard-lint-before-build.sh`
- [ ] `post-global-handler.sh`
- [ ] `momentum-brake-enforce.sh`

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
| Components audited | 20/67 (29.9%) | 67/67 (100%) |
| P5 PASS rate | 18/20 (90%) | TBD |
| P6 PASS rate | 0/20 (0%) | TBD |
| P6 PARTIAL 3/4 (close — só VERIFY) | 9/20 (45%) | TBD |
| P6 PARTIAL 2/4 | 9/20 (45%) | TBD |
| P6 FAIL ≤1/4 | 2/20 (10%) | TBD |

**Hypothesis refinada (confidence: high — n=20):** Dois clusters distintos confirmed —
- **Alta-qualidade (45%)**: cite evidence T1/T2 — só falta VERIFY mecânico
- **Legacy/brief (45%)**: WHAT-only — precisam WHY+VERIFY refactor
- **Falha estrutural (10%)**: frontmatter tão vague que comprometem trigger/consumer/HOW também

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
