# S252 "infra2" — Mechanical Phase (P0 finish + P1 bootstrap)

> **Plan ID:** fancy-imagining-crab
> **Session:** S252 "infra2" — 2026-04-25
> **Scope confirmed:** mechanical-only (Lucas AskUserQuestion S252-open) — destrutivos D/E/F/G deferred S253+
> **Notion harvest:** defer S253+ (Lucas confirmed; Chesterton's Fence T1)

---

## Context

S251 entregou Conductor 2026 baseline P0 a/b/d (75% — só c Notion bloqueado pendente Lucas export). Audit P5/P6 30/66 (45%) com pattern estável n=30:
- **P5 anti-teatro:** 90% PASS (27/30) · 10% PARTIAL (consumer/trigger ambíguo)
- **P6 E2E+WHY:** 0% PASS (0/30) — mas 57% close-to-PASS (17/30 com 3/4, só falta VERIFY) · 37% PARTIAL 2/4 · 7% FAIL ≤1.5/4

Insight: high-quality cluster é dominante; **trabalho mecânico repetitivo** (add VERIFY ~5min × 17 = ~1.5h) destrava primeiros P6 PASSes do projeto.

S252 ataca exatamente isso — sem destrutivos, sem propose-before-pour para merges arquiteturais. Outcome desejado:
- P0(d) audit: 30/66 → 38/66 (~58%)
- P1 mechanical: 8 components movem P6 PARTIAL 3/4 → **first PASSes 4/4**
- P0(c) calibration: 12 KPI thresholds Lucas-confirmed em baseline.md
- KBP-31 housekeeping: KBP-39 codified (S250 X1 convergence rules learning)

---

## Phases (5 — sequential, dependency-light)

### Phase 1 — KPI calibration (~15min, Lucas-paced)

**Goal:** mover 12 ACTIVE KPIs de "thresholds proposed" → "Lucas-confirmed" (preenche baseline.md §Calibration log).

**Deliverable:** `.claude/metrics/baseline.md` §Calibration log com 12 rows confirmed/edited/deferred.

**Method:**
1. Show Lucas tabela atual ACTIVE (12 rows com proposed thresholds + confidence)
2. Per-KPI Lucas marca: `confirm` | `edit X→Y` | `defer`
3. Edit `.claude/metrics/baseline.md` §Calibration log (Edit não Write — KBP state-files §)

**Evidence-tier:** baseline.md proposed thresholds têm confidence high/med/low explícito por KPI. Onde confidence=low (debug-team-pass-first-try, mcp-health-uptime, r3-questoes), Lucas conservar — não inflar baseline sem dados.

---

### Phase 2 — Audit batch F continuation (~1.5h, mechanical)

**Goal:** avançar audit P5/P6 de 30/66 → 38/66 (~58%). +8 components.

**Targets (priority order — agents primeiro, hooks core path depois):**

| # | Component | Type | Why this batch |
|---|-----------|------|----------------|
| 31 | `quality-gate` | agent | fechar agents pendentes (3 restantes) |
| 32 | `systematic-debugger` | agent | mesmo cluster; informa decisão future H4 |
| 33 | `reference-checker` | agent | research-side balance |
| 34 | `guard-secrets.sh` | hook | core security path |
| 35 | `guard-mcp-queries.sh` | hook | core MCP gate |
| 36 | `nudge-checkpoint.sh` | hook | productivity layer |
| 37 | `session-compact.sh` | hook | session lifecycle |
| 38 | `session-start.sh` | hook | session lifecycle |

**Method (per component, ~10min cada):**
1. Read frontmatter + first 50 li
2. Score 7 criteria per `audit-p5-p6-violations.md §Methodology`:
   - P5: 5a (trigger) · 5b (artefato) · 5c (consumer) → PASS/PARTIAL/FAIL
   - P6: 6a (WHAT) · 6b (WHY+evidence T1/T2) · 6c (HOW) · 6d (VERIFY path) → PASS/PARTIAL/FAIL
3. Add row à AUDITED tabela em `.claude/plans/audit-p5-p6-violations.md`
4. Decrement PENDING checklist

**Update Aggregate** após batch (Components audited / P5 PASS rate / P6 PASS rate / cluster stratification).

**Anti-sycophancy:** se um component aparecer FAIL (P6 ≤1.5/4) ou PARTIAL surpreendente, flag explicit — não suavizar pra "manter pattern".

**KBP-32 spot-check:** se algum component tiver claim "AUSENTE" no header (e.g., "doesn't use X"), Grep confirma antes de aceitar.

---

### Phase 3 — VERIFY headers mechanical batch (~1.5h)

**Goal:** mover 8 components de P6 PARTIAL 3/4 → **PASS 4/4** (first PASSes do projeto).

**Convention (proposta — Lucas confirma no execution):**

```markdown
## VERIFY

`scripts/smoke/{component-name}.sh` — smoke test reprodutível (P1+ creation pendente).
```

H2 section após frontmatter+WHY (canonical position). Smoke test path declared, criação dos `.sh` files = trabalho separado P1+ (Conductor §15).

**Por que só path declarado, não smoke creation?**
- Bem definido: separar declaração (audit close) de implementação (P1+ work cycle)
- ~5min × 8 = 40min header work; smoke creation seria ~30min × 8 = 4h adicional
- Mantém S252 mechanical/non-destructive

**Targets (top 8 close-to-PASS, ranked by impact — todos já 6a+6b+6c):**

| # | Component | Type | File path | Smoke target |
|---|-----------|------|-----------|--------------|
| 1 | `debug-team` | skill | `.claude/skills/debug-team/SKILL.md` | `scripts/smoke/debug-team.sh` |
| 2 | `debug-architect` | agent | `.claude/agents/debug-architect.md` | `scripts/smoke/debug-architect.sh` |
| 3 | `debug-strategist` | agent | `.claude/agents/debug-strategist.md` | `scripts/smoke/debug-strategist.sh` |
| 4 | `debug-validator` | agent | `.claude/agents/debug-validator.md` | `scripts/smoke/debug-validator.sh` |
| 5 | `debug-archaeologist` | agent | `.claude/agents/debug-archaeologist.md` | `scripts/smoke/debug-archaeologist.sh` |
| 6 | `debug-adversarial` | agent | `.claude/agents/debug-adversarial.md` | `scripts/smoke/debug-adversarial.sh` |
| 7 | `debug-patch-editor` | agent | `.claude/agents/debug-patch-editor.md` | `scripts/smoke/debug-patch-editor.sh` |
| 8 | `mbe-evaluator` | agent | `.claude/agents/mbe-evaluator.md` | `scripts/smoke/mbe-evaluator.sh` |

**Por que esses 8?**
- Todos já têm 6a+6b+6c — adicionar VERIFY = 4/4 PASS imediato
- 7/8 são debug-team subgraph — concentra lock-in para H4 future merge
- mbe-evaluator é gold-standard P6 (Conductor §6b cita GRADE+CEBM+CONSORT/STROBE/PRISMA)
- Após batch: P6 PASS rate sobe 0/30 → 8/38 (21%); cluster 3/4 cai

**KBP applied per Edit:**
- **KBP-25:** Read full file antes de Edit (VERIFY position consistente — após frontmatter, antes ou depois de primeira H2)
- **KBP-21:** audit ENTIRE frontmatter ao tocar — se ver off-spec field (e.g., `disable-model-invocation` em wrong place), flag não fix
- **EC loop** explícito por Edit (8× = 8 EC entries)

**Update audit-p5-p6-violations.md** após batch — 8 rows movem PART 3/4 → PASS 4/4.

---

### Phase 4 — KBP-39 commit (~10min)

**Goal:** codify S250 X1 KBP candidate per KBP-31 enforcement (Aprendizados → committed before close; lost otherwise).

**Source (HANDOFF S252 cautions):**
> S250 X1 ADOPT-NEXT classification flagged — was 1/3 + spot-check (should have been DEFER per convergence rules). Audit content showed scopes complementary, not redundant. Lucas explicit decision overrode → merge done. KBP candidate: "audit-merge convergence rules NOT followed strictly em S250 X1".

**Deliverable — Edit `.claude/rules/known-bad-patterns.md`:**

```markdown
## KBP-39 Audit-merge convergence rules followed loosely (1/3 + spot-check ≠ DEFER classification)
→ audit-merge-S251.md §Convergence rules + S250 X1 pattern
```

**Update counter:** `Next: KBP-39` → `Next: KBP-40` (line 3 do file).

**Pointer target prep (no execution, fora deste plan):** confirm `audit-merge-S251.md` path existe (provavelmente `.claude/plans/archive/` ou `docs/research/`); Phase 4 verify path antes de Edit.

**Counter-flag (Lucas optional override):** se Lucas considerar que S250 X1 outcome final foi correto (merge salutar), KBP-39 pode ser reframed como "convergence rules need calibration" não "violation". Plan execution apresenta as duas formas; Lucas escolhe.

---

### Phase 5 — Session close (~20min)

**Goal:** HANDOFF + CHANGELOG atualizados; S252 commits chain registrada.

**Updates:**

**HANDOFF.md (Edit):**
- Replace S251 commits chain → S252 commits chain
- Remove S252.A (Notion deferred — defer keep listed but lower priority), S252.C (calibration done), S252.H (VERIFY 8 done)
- Promote S252.D/E/F/G priority (now top — destrutivos remaining)
- Update HIDRATACAO S253 (5 passos atualizados)

**CHANGELOG.md (append-only):**
- Per-commit 1-line entry (estimate ~5-7 commits S252)
- Aprendizados ≤5 li (audit pattern reinforcement n=38; VERIFY convention adopted; KBP-39 lesson commit)

**Verify session-name:** `.claude/.session-name` = "infra2" (já escrito Phase 0 antes de plan mode).

**Anti-drift §Session docs:** Edit (não Write) ambos. List sections present antes de cada Edit.

---

## Critical files

### Read-only (state verification — Phase 0 done)
- `.claude/plans/audit-p5-p6-violations.md` (current 30/66)
- `.claude/metrics/baseline.md` (12 ACTIVE definitions)
- `.claude/rules/known-bad-patterns.md` (KBP catalog → 39 next)
- `audit-merge-S251.md` (path TBD — verify Phase 4)
- `VALUES.md` + `.claude/plans/immutable-gliding-galaxy.md` (frame)

### Modified by S252 (~13 files)

**Phase 1 (1):** `.claude/metrics/baseline.md`

**Phase 2 (1):** `.claude/plans/audit-p5-p6-violations.md`

**Phase 3 (8):**
- `.claude/skills/debug-team/SKILL.md`
- `.claude/agents/debug-architect.md`
- `.claude/agents/debug-strategist.md`
- `.claude/agents/debug-validator.md`
- `.claude/agents/debug-archaeologist.md`
- `.claude/agents/debug-adversarial.md`
- `.claude/agents/debug-patch-editor.md`
- `.claude/agents/mbe-evaluator.md`

**Phase 4 (1):** `.claude/rules/known-bad-patterns.md`

**Phase 5 (2):** `HANDOFF.md` + `CHANGELOG.md`

---

## Verification (smoke commands per phase)

```bash
# Phase 1 — calibration
grep -c "✓\|edited\|deferred" .claude/metrics/baseline.md
# Expected: ≥12 markers em §Calibration log

# Phase 2 — audit batch F
grep -cE "^\| 3[1-8]" .claude/plans/audit-p5-p6-violations.md
# Expected: 8 new rows (#31 → #38)

# Phase 3 — VERIFY headers
for f in .claude/skills/debug-team/SKILL.md \
         .claude/agents/debug-{architect,strategist,validator,archaeologist,adversarial,patch-editor,}.md \
         .claude/agents/mbe-evaluator.md; do
  grep -q "^## VERIFY" "$f" || echo "MISSING VERIFY: $f"
done
# Expected: empty stdout (all 8 OK)

# Phase 4 — KBP-39
grep -q "^## KBP-39" .claude/rules/known-bad-patterns.md && \
grep -q "Next: KBP-40" .claude/rules/known-bad-patterns.md
# Expected: exit 0 ambos

# Phase 5 — session docs
grep -q "S252" HANDOFF.md && grep -q "S252" CHANGELOG.md
# Expected: exit 0
```

---

## Out of scope (deferred S253+)

| Item | Reason for defer |
|------|------------------|
| **A — Notion harvest** | Lucas no export; Chesterton's Fence (HANDOFF caution) |
| **D — H4 systematic-debugging→debug-team merge** | Destrutivo; KBP-39 candidate (S250 X1 convergence rules); needs propose-before-pour + spot-check audit content |
| **E — X3 chaos-inject ordering** | Toca `.claude/settings.json` hooks array — destrutivo. Plan separado |
| **F — G1 disallowedTools→tools allowlist** | Mechanical mas amplo (6 agents); melhor batch dedicado |
| **G — G3 debug-team metrics instrumentation** | Depende de D done |
| **VERIFY headers restantes 9 components** | Após Phase 3 8 done, 9 mais close-to-PASS pendentes (sentinel, repo-janitor, qa-engineer, research, improve, insights, debug-symptom-collector, ambient-pulse, evidence-audit) — bandit S253 mechanical batch |
| **Smoke test creation** | `scripts/smoke/*.sh` files per declared path — P1+ work; ~30min × 8 = 4h dedicated session |

---

## Anti-drift / KBP applied (operational checklist)

- **EC loop visible** antes de cada Edit (Phase 3: 8× explicit)
- **KBP-21:** audit ENTIRE frontmatter section ao tocar (Phase 3)
- **KBP-25:** Read full file antes de Edit (VERIFY convention consistency cross-files)
- **KBP-31:** KBP candidate Aprendizados → committed (Phase 4 explicit)
- **KBP-32:** spot-check "AUSENTE" claims (Phase 2 audit)
- **KBP-36:** evidence cited per decision (convention defended via Conductor §15)
- **KBP-37:** Elite-faria-diferente actionable: (a) doing now Phase 3, (b) deferred com gate D/E/F/G, (c) cut aspirational
- **State-files Edit not Write** (Phase 1, 2, 4, 5 — never overwrite)
- **Anti-sycophancy:** Phase 2 stratify findings honestly; flag PARTIAL/FAIL surprises

---

## Estimated total

| Phase | Time | Lucas-paced? |
|-------|------|--------------|
| 1 — KPI calibration | 15min | yes (decisions) |
| 2 — Audit batch F | 1.5h | no |
| 3 — VERIFY 8 components | 1.5h | no |
| 4 — KBP-39 commit | 10min | optional flag review |
| 5 — Session close | 20min | no |

**Total: ~3.5-4h.** Realistic 1 session.

---

## Confidence: high

Plan é **defensável** (cada phase cita audit/baseline/HANDOFF source); **non-destructive** (zero merge/delete; só Edit aditivo + Edit em state-files); **bounded** (8+8+1+1 files modified — mensurável); **executable** (scope ≤ HANDOFF priorities A/B/C/H; D/E/F/G honest defer).

Pendência única: convention `## VERIFY` H2 vs frontmatter field — Lucas confirma execution OR aceita default. Plan execution prepared para ambos paths.
