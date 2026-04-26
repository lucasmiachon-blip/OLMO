# Audit P5 (anti-teatro) + P6 (E2E + WHY-first) — Conductor 2026 P0 (d)

> **Status:** v1.5 — S252 P0 in-progress (38/66 = 58% audited; 28 pending; batch F added 8 — 3 agents + 3 .claude/hooks + 2 hooks/)
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

## AUDITED (38/66) — batches A + B + C + D + E + F

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
| 25 | `mbe-evaluator` | agent | ✓ | ✓ | ✓ | **PASS** | ✓ | ✓†† | ✓ | ✗ | **PART 3/4** | add VERIFY |
| 26 | `debug-patch-editor` | agent | ✓ | ✓ | ✓ | **PASS** | ✓ | ✓‡‡ | ✓ | ✗ | **PART 3/4** | add VERIFY |
| 27 | `docs-audit` | skill | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ✓ | ✗ | **PART 2/4** | add WHY + VERIFY |
| 28 | `exam-generator` | skill | ✓ | ✓ | ✓ | **PASS** | ✓ | ✓✦ | ✓ | ✗ | **PART 3/4** | add VERIFY (best evidence citation seen) |
| 29 | `post-bash-handler.sh` | hook | ✓ | ✓ | ✓ | **PASS** | ✓ | ✓§§ | ✓ | ✗ | **PART 3/4** | add VERIFY |
| 30 | `post-tool-use-failure.sh` | hook | ✓ | ✓ | ✓ | **PASS** | ✓ | ✓¶¶ | ✓ | ✗ | **PART 3/4** | add VERIFY |
| 31 | `quality-gate` | agent | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ✓ | ✗ | **PART 2/4** | add WHY + VERIFY |
| 32 | `systematic-debugger` | agent | ✓ | ✓ | ✓ | **PASS** | ✓ | ✓⁋ | ✓ | ✗ | **PART 3/4** | add VERIFY |
| 33 | `reference-checker` | agent | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ✓ | ✗ | **PART 2/4** | add WHY + VERIFY |
| 34 | `guard-secrets.sh` | hook | ✓ | ✓ | ✓ | **PASS** | ✓ | ✓‖ | ✓ | ✗ | **PART 3/4** | add VERIFY |
| 35 | `guard-mcp-queries.sh` | hook | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ✓ | ✗ | **PART 2/4** | add WHY + VERIFY |
| 36 | `nudge-checkpoint.sh` | hook | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ✓ | ✗ | **PART 2/4** | add WHY + VERIFY |
| 37 | `session-compact.sh` | hook | ✓ | ✓ | ✓ | **PASS** | ✓ | ✗ | ✓ | ✗ | **PART 2/4** | add WHY + VERIFY |
| 38 | `session-start.sh` | hook | ✓ | ✓ | ✓ | **PASS** | ✓ | ✓※ | ✓ | ✗ | **PART 3/4** | add VERIFY |

¶ debug-adversarial 6b: Codex max + KBP-28 explicit ("atacando o frame que collector estabeleceu")
\# teaching 6b: cita Kawasaki 10-20-30 + Michael Alley assertion-evidence + Reynolds (Presentation Zen) + Duarte (Resonate) + Tufte (T1-T2 multi-source)
\*\* stop-quality 6b: "S213 self-improvement loop step 1" + merge history (crossref-check + detect-issues + hygiene Fase 2)
†† mbe-evaluator 6b: GRADE + Oxford CEBM + CONSORT/STROBE/PRISMA (multi-framework T1)
‡‡ debug-patch-editor 6b: "Aider Editor role" + KBP-01 violation enforcement + "ÚNICO agent in /debug-team que escreve"
✦ exam-generator 6b: **exemplary** — 8 citations T1 cientificas (49% LLM item-writing flaws, 22% factual errors, 39% free-response gap, etc) + Position bias [6] + Cognitive bias [7] + correctness signal [8]
§§ post-bash-handler 6b: "Replaces build-monitor + success-capture + hook-calibration. S195 Fase 2 step 4. 0 node spawns, 1 jq parse" (concrete merge + perf benchmark)
¶¶ post-tool-use-failure 6b: 3 sessions referenced — S225 Issue #7 defensive cat fallback, S230 G.7 KBP-23 enforcement, S248 #57 schema fix additionalContext (exemplary version history)

\* repo-janitor 5c: ambíguo (`--fix` Lucas-approve OK; default REPORT unclear)
\*\* debug-architect 6b: Aider 2024-09 study T1 "85% vs 75% solo" — exemplary
\*\*\* guard-write-unified 6b: "S194 Fase 2 merge — 0 node spawns (was 4)"
\*\*\*\* debug-team 6b: Anthropic nível 6 + S248 archive + sota-synthesis 60 fontes
\*\*\*\*\* knowledge-ingest 6b: §"Por que isso importa" section explícita
† debug-archaeologist 6b: cita "Gemini 3.1 Pro 1M ctx" rationale + D8 MAS path
‡ lint-on-edit 6b: cita "Antifragile L5" + "L1 retry S89: jitter"
§ guard-bash-write 6b: cita "Codex audit S57" + "jq 10x faster than node S193" — concrete benchmarks
⁋ systematic-debugger 6b: cita KBP-07 explícito (anti-workaround taxonomy) + "3 FAILS STOP" rule (architectural signal heuristic)
‖ guard-secrets 6b: S51 (scan staged blobs) + S194 (node→jq migration Fase 2) — multi-fix history T2 OLMO commit refs
※ session-start 6b: extensive S-history (S225 #4/#10 namespace + reset + S230 G.5/G.8 + S236 P008 hook-log rotate + S102 B7-06 cost brake + Codex S60 O10 sort-numeric) — best-of-batch P6 reference density

### Observed pattern (confidence: high — n=38)

**P5 (anti-teatro):** 35/38 PASS (92%) — batch F all 8 PASS (zero novo PARTIAL). 3/38 PARTIAL (repo-janitor consumer¹, automation trigger+consumer+HOW, teaching trigger).

¹ Note: repo-janitor was expanded S251 X1 merge — `--mode generic` clarifies consumer; future re-audit may upgrade to PASS.

**P6 (WHY-first + VERIFY):** 0/38 PASS ainda — universal VERIFY gap persiste. Stratification:
- **20/38 com P6 3/4** (53%, close — só falta VERIFY): batch F adicionou 3 (systematic-debugger KBP-07, guard-secrets S51+S194, session-start S225+S230+S236 multi-history)
- **16/38 com P6 2/4** (42%, WHY+VERIFY ausentes): batch F adicionou 5 (quality-gate, reference-checker, guard-mcp-queries, nudge-checkpoint, session-compact)
- **2/38 com P6 ≤1.5/4 FAIL** (5%): evidence-researcher, automation

**Insight reinforced n=38:**
Doc-quality cluster stratification estável. Batch F caiu cluster 3/4 de 57% → 53% (5 novos PART 2/4 vs 3 PART 3/4). Range mantém-se dentro de margin n=8-batch — pattern domina majority high-quality. Implicação: P1+ work mecânico **add VERIFY** continua majority path (~5min × 20 = ~1.7h), heavy WHY refactor cresceu marginal (5 novos componentes precisam WHY+VERIFY).

**Time-to-completion P1+ refinado n=38:**
- 20 mecânicos (VERIFY only): ~1.7h
- 16 doc-only (WHY+VERIFY): ~3-4h
- 2 structural FAIL: ~1h
- 3 trigger-clarify: ~15min
- **Total: ~6h** spread (provavelmente 3 sessões dedicated mechanical work)

---

## PENDING audit (28/66)

### Agents (0 pending of 16; 16 audited — **COMPLETE**)
- ~~quality-gate~~ (audited #31, batch F)
- ~~systematic-debugger~~ (audited #32, batch F)
- ~~reference-checker~~ (audited #33, batch F)

### Skills (8 pending of 18; 10 audited; janitor REMOVED S251 X1)
- [ ] `brainstorming`
- [ ] `concurso`
- [ ] `systematic-debugging` (likely fold post-H4 merge)
- [ ] `skill-creator`
- [ ] `nlm-skill`
- [ ] `continuous-learning`
- [ ] `review`
- [ ] (1 reserve slot — may add)

### Hooks (20 pending of 32; 12 audited)

`.claude/hooks/` (10 pending; 7 audited):
- ~~guard-secrets.sh~~ (audited #34, batch F)
- [ ] `allow-plan-exit.sh`
- [ ] `chaos-inject-post.sh` (likely refactor post-X3)
- [ ] `coupling-proactive.sh`
- ~~guard-mcp-queries.sh~~ (audited #35, batch F)
- [ ] `guard-read-secrets.sh`
- [ ] `guard-research-queries.sh`
- [ ] `model-fallback-advisory.sh` (likely refactor post-X3)
- [ ] `momentum-brake-clear.sh`
- ~~nudge-checkpoint.sh~~ (audited #36, batch F)
- [ ] `guard-lint-before-build.sh`
- [ ] `post-global-handler.sh`
- [ ] `momentum-brake-enforce.sh`

`hooks/` (10 pending; 5 audited):
- [ ] `notify.sh`
- [ ] `stop-notify.sh`
- [ ] `nudge-commit.sh`
- ~~session-compact.sh~~ (audited #37, batch F)
- [ ] `session-end.sh`
- [ ] `pre-compact-checkpoint.sh`
- ~~session-start.sh~~ (audited #38, batch F)
- [ ] `stop-metrics.sh`
- [ ] `stop-failure-log.sh`
- [ ] `apl-cache-refresh.sh`
- [ ] `post-compact-reread.sh`
- [ ] `loop-guard.sh`

---

## Aggregate (will update each session)

| Metric | Current | After full P0 |
|--------|---------|----------------|
| Components audited | 38/66 (57.6%) | 66/66 (100%) |
| P5 PASS rate | 35/38 (92%) | TBD |
| P5 PARTIAL (trigger/consumer ambíguo) | 3/38 (8%) | TBD |
| P6 PASS rate | 0/38 (0%) | TBD |
| P6 PARTIAL 3/4 (close — só VERIFY) | 20/38 (53%) | TBD |
| P6 PARTIAL 2/4 | 16/38 (42%) | TBD |
| P6 FAIL ≤1.5/4 | 2/38 (5%) | TBD |

**Hypothesis n=38:** Pattern estável n=30→38. P5 PASS marginal up (90→92%, n=8 batch all PASS). P6 close-to-PASS cluster marginal down (57→53%, batch F skewed toward 2/4 cluster — 5 vs 3). Total P1+ estimated ~6h (1.7h mecânico VERIFY + 3-4h doc WHY+VERIFY + 1h structural + 15min trigger).

**Agents milestone (S252 batch F):** 16/16 agents audited — 100% complete. Pendentes restantes: 8 skills + 20 hooks (28 components total).

**Janitor X1 merge (S251):** total 67→66. janitor SKILL absorved into repo-janitor agent (commit 3082c39). Audit baseline adjusted accordingly.

---

## Next session continuation prompt

```
Continue audit-p5-p6-violations.md — audit next 6-10 components from PENDING list (28 remaining).
Agents COMPLETE (16/16). Priority shifts to:
(1) skills pending (8): brainstorming, concurso, systematic-debugging (likely fold post-H4),
    skill-creator, nlm-skill, continuous-learning, review;
(2) hooks .claude/hooks/ pending (10): allow-plan-exit, chaos-inject-post (refactor post-X3),
    coupling-proactive, guard-read-secrets, guard-research-queries, model-fallback-advisory,
    momentum-brake-clear, guard-lint-before-build, post-global-handler, momentum-brake-enforce;
(3) hooks hooks/ pending (10): notify, stop-notify, nudge-commit, session-end,
    pre-compact-checkpoint, stop-metrics, stop-failure-log, apl-cache-refresh,
    post-compact-reread, loop-guard.
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
