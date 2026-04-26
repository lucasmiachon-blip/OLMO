# Audit P5 (anti-teatro) + P6 (E2E + WHY-first) — Conductor 2026 P0 (d)

> **Status:** v1.3 — S251 P0 in-progress (24/67 components audited; 43 pending — P0 continues S252+)
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

## AUDITED (24/67) — batches A + B + C + D

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
| 21 | `debug-adversarial` | agent | ✓ | ✓ | ✓ | **PASS** | ✓ | ✓¶ | ✓ | ✗ | **PART 3/4** | add VERIFY |
| 22 | `researcher` | agent | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ✓ | ✗ | **PART 2/4** | add WHY + VERIFY |
| 23 | `teaching` | skill | ~ | ✓ | ✓ | **PART** | ✓ | ✓# | ✓ | ✗ | **PART 3/4** | clarify trigger + VERIFY |
| 24 | `stop-quality.sh` | hook | ✓ | ✓ | ✓ | **PASS** | ✓ | ✓** | ✓ | ✗ | **PART 3/4** | add VERIFY |

¶ debug-adversarial 6b: Codex max + KBP-28 explicit ("atacando o frame que collector estabeleceu")
\# teaching 6b: cita Kawasaki 10-20-30 + Michael Alley assertion-evidence + Reynolds (Presentation Zen) + Duarte (Resonate) + Tufte (T1-T2 multi-source)
\*\* stop-quality 6b: "S213 self-improvement loop step 1" + merge history (crossref-check + detect-issues + hygiene Fase 2)

\* repo-janitor 5c: ambíguo (`--fix` Lucas-approve OK; default REPORT unclear)
\*\* debug-architect 6b: Aider 2024-09 study T1 "85% vs 75% solo" — exemplary
\*\*\* guard-write-unified 6b: "S194 Fase 2 merge — 0 node spawns (was 4)"
\*\*\*\* debug-team 6b: Anthropic nível 6 + S248 archive + sota-synthesis 60 fontes
\*\*\*\*\* knowledge-ingest 6b: §"Por que isso importa" section explícita
† debug-archaeologist 6b: cita "Gemini 3.1 Pro 1M ctx" rationale + D8 MAS path
‡ lint-on-edit 6b: cita "Antifragile L5" + "L1 retry S89: jitter"
§ guard-bash-write 6b: cita "Codex audit S57" + "jq 10x faster than node S193" — concrete benchmarks

### Observed pattern (confidence: high — n=24)

**P5 (anti-teatro):** 21/24 PASS (87.5%), 3/24 PARTIAL — repo-janitor (consumer), automation (trigger + consumer + HOW), teaching (trigger). **NEW pattern emerging:** trigger-vague frontmatter é segundo modo de falha P5 (3/24 = 12.5%).

**P6 (WHY-first + VERIFY):** 0/24 PASS. Stratification atualizada:
- **12/24 com P6 3/4** (50%, close — só falta VERIFY): debug-architect, debug-validator, debug-strategist, debug-team, knowledge-ingest, guard-write-unified, debug-archaeologist, lint-on-edit, guard-bash-write, debug-adversarial, teaching, stop-quality
- **10/24 com P6 2/4** (42%, WHY+VERIFY ausentes): sentinel, repo-janitor, qa-engineer, research, improve, insights, ambient-pulse, debug-symptom-collector, evidence-audit, researcher
- **2/24 com P6 ≤1.5/4 FAIL** (8%): evidence-researcher, automation

**Insights consolidados (n=24):**
- **Two failure modes P5:** consumer ambíguo (1) + trigger vague (3). Trigger-vague é mais comum — frontmatter description deve SEMPRE incluir trigger explícito.
- **Doc-quality temporal pattern persiste:** debug-team subgraph + componentes S194+ (guards/lint/stop-quality) + skills com referências authoritativas (teaching cita Kawasaki/Alley/Reynolds/Duarte/Tufte) → P6 3/4. Componentes brief frontmatter pré-S248 → P6 2/4.

**Implicação P1+ refinada:**
- 12 mecânicos (template VERIFY only): ~5min cada = ~1h total
- 10 doc-only (WHY+VERIFY): ~10-15min cada = ~2h total
- 2 structural FAIL: ~30min cada = ~1h total (full WHY+HOW+trigger refactor)
- 3 trigger-clarify (subset of partials): ~5min cada = ~15min

---

## PENDING audit (61/67)

### Agents (5 pending of 16; 11 audited)
- [ ] `mbe-evaluator`
- [ ] `quality-gate`
- [ ] `systematic-debugger`
- [ ] `reference-checker`
- [ ] `debug-patch-editor`

### Skills (11 pending of 19; 8 audited)
- [ ] `docs-audit`
- [ ] `brainstorming`
- [ ] `concurso`
- [ ] `systematic-debugging` (likely fold post-H4 merge)
- [ ] `exam-generator`
- [ ] `janitor` (likely delete post-X1 merge)
- [ ] `skill-creator`
- [ ] `nlm-skill`
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

`hooks/` (13 pending; 2 audited):
- [ ] `notify.sh`
- [ ] `stop-notify.sh`
- [ ] `nudge-commit.sh`
- [ ] `session-compact.sh`
- [ ] `session-end.sh`
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
| Components audited | 24/67 (35.8%) | 67/67 (100%) |
| P5 PASS rate | 21/24 (87.5%) | TBD |
| P5 PARTIAL (trigger/consumer ambíguo) | 3/24 (12.5%) | TBD |
| P6 PASS rate | 0/24 (0%) | TBD |
| P6 PARTIAL 3/4 (close — só VERIFY) | 12/24 (50%) | TBD |
| P6 PARTIAL 2/4 | 10/24 (42%) | TBD |
| P6 FAIL ≤1.5/4 | 2/24 (8%) | TBD |

**Hypothesis n=24:** Dois failure modes P5 + três clusters P6 estáveis. Total time-to-completion P1+ estimado ~4h (mecânico+doc+structural+trigger-clarify).

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
