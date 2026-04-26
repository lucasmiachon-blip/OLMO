# Plan S258 — hookscont (consolidate S256 residual + forward signal hygiene)

> **Status:** PROPOSTA pendente Lucas approval via ExitPlanMode
> **Origem:** consolida HANDOFF P0 (Phase 4 Block D smoke tests, S256 residual) + HANDOFF P1 (metanálise QA resume, S240 dormant) + BACKLOG P0 conflito (content delivery deadline-driven)
> **Mandato Lucas (S258 abertura):** "incorporar os planos referenciados pelo HANDOFF e mover os antigos para nao acumular ruido"
> **Coautoria:** Lucas + Opus 4.7 (Claude Code) | S258 hookscont | 2026-04-26

---

## 1. Context

S256 fechou Phase 0+1+2+3 (11 commits). Resta **Phase 4 Block D — 7 smoke tests debug-team** com `## VERIFY` claim performativo (T4 teatro). HANDOFF marca P0 S257 (que virou S258).

**Estado real plans/ root pós-investigação:**
- `S256-hooks-execute-and-close.md` → JÁ archived (S256 Phase 0 hygiene)
- `S255-S256-debug-team-hooks.md` → JÁ archived (S256 Phase 0)
- `S240-DEFERRED-lovely-sparking-rossum.md` → JÁ archived (S256 Phase 0, BACKLOG #64 pointer preserva commitment)
- `immutable-gliding-galaxy.md` → KEEP active (P1 BACKGROUND, Conductor 2026 reference, low context cost)

**Não há "planos antigos para mover" — S256 Phase 0 já fez essa hygiene.** Único plan root é Conductor reference (intencional). O que precisa: este plano novo é archived post-completion (Phase B.2 abaixo).

**Pendências consolidadas para forward signal:**
1. **HANDOFF P0:** Phase 4 Block D — 7 smoke tests debug-team (S256 §6 spec D.1-D.7)
2. **HANDOFF P1:** Metanálise QA editorial resume — 12 slides LINT-PASS pendentes + 1 QA-in-progress (S240 plan dormant)
3. **BACKLOG P0a/b/c (stale vs HANDOFF):** content delivery shared-v2/grade-v2/qa-pipeline-v2 deadline 30/abr T-4d

**Outcome desejado S258:**
- Hooks domain fecha completo (Phase 4 ATIVO, T4 teatro → tested)
- KBP-32 finding endereçado (`debug-symptom-collector.md` sem `## VERIFY`)
- HANDOFF refreshed pure forward signal pós-S258
- Plan archived (continuity hygiene)

---

## 2. Decisão upfront (G0)

4 caminhos viáveis para S258 — Lucas pickar via ExitPlanMode comments:

| Opt | Escopo | Tempo | Commits | Justificativa |
|-----|--------|-------|---------|---------------|
| **A (recommended)** | Phase 4 smoke tests + KBP-32 fix + close | ~2-2.5h | 8-10 | Fecha hooks domain limpo; Phase 4 era "defer S257", mais defer = stale risk; bounded scope |
| B | Metanálise QA loop (S240 Loop A pipeline) | variable (1-3 slides) | 3-9 | Lucas commitment BACKLOG #64; mas open-ended e melhor com sessão dedicada |
| C | Phase 4 (~2h) + 1 slide metanálise piloto | ~3.5h | 9-11 | Mixed P0+P1, mas cansaço risk; dois domains diferentes |
| D | BACKLOG content delivery (shared-v2/grade-v2/qa-pipeline-v2) | exige plan separado | — | Deadline-driven 30/abr T-4d, mas plan structure ausente — não viável esta sessão sem prep |

**Recomendação: Option A.** Razão SIM: Phase 4 é concrete + bounded + 7 commits well-scoped; libera S259 para metanálise full focus. Razão NÃO: deadline 30/abr T-4d puxa pra content (Option D), mas D exige plan separado que não cabe nesta sessão.

**Resto do plan assume Option A.** Se Lucas pickar B/C/D, replan Phase A.

---

## 3. Phase A — Phase 4 Block D smoke tests (~1.5-2.5h, 8 commits)

Specs canonical: `archive/S256-hooks-execute-and-close.md §6 D.1-D.7`. Common pattern em §6.1.

### 3.1 A.0 KBP-32 finding fix — debug-symptom-collector ## VERIFY (~15min, 1 commit)

**Finding:** Grep `^##\s+VERIFY` em `.claude/agents/debug-*.md` retornou 6/7 files. **`debug-symptom-collector.md` NÃO tem `## VERIFY`** — HANDOFF afirma "Cada agent .md tem secao VERIFY" tem erro factual (S256 hygiene gap).

**Decision sub G0.1:**
- (a) **Add `## VERIFY` section** to `debug-symptom-collector.md` antes dos smoke tests — 1 commit, contract source-of-truth uniforme
- (b) Inferir critérios direto do schema canonical — 0 commit, inconsistência permanece

**Recommend (a).** Critérios proposed:
- emite JSON canonical schema (todos os 9 top-level fields: schema_version, ingested_at, error_signature, affected_surface, reproduction, suspected_scope, complexity_score, evidence_artifacts, gaps, downstream_hints)
- `complexity_score.value` ∈ [0,100]
- `routing_decision` derivado correto (>75 → "single_agent" | ≤75 → "mas")
- `gaps` non-empty quando overall confidence ≤ medium
- ZERO Edit/Write/Agent invocations (anti-fabrication enforcement, `disallowedTools` honored)

**File modify:** `.claude/agents/debug-symptom-collector.md` (append `## VERIFY` ~15-25 li após Fase 3 Report)

**Commit:** `feat(S258): A.0 add ## VERIFY to debug-symptom-collector — fills KBP-32 gap`

### 3.2 A.1-A.7 7 smoke tests (1 commit each, ~15-20min cada)

**Scaffold:**
```
scripts/smoke/
├── debug-symptom-collector.sh
├── debug-strategist.sh
├── debug-archaeologist.sh
├── debug-adversarial.sh
├── debug-architect.sh
├── debug-patch-editor.sh
├── debug-validator.sh
└── fixtures/
    └── {agent}-input.json (7)
```

**Common pattern (S256 §6.1):**
```bash
#!/usr/bin/env bash
set -euo pipefail
INPUT_FIXTURE="scripts/smoke/fixtures/<agent>-input.json"
OUTPUT="$(claude agents call <agent> < $INPUT_FIXTURE 2>&1)"
echo "$OUTPUT" | jq -e '<required field>' || { echo "FAIL: <reason>"; exit 1; }
echo "$OUTPUT" | jq -e '<another invariant>' || { echo "FAIL"; exit 1; }
echo "PASS"
```

| Sub | Test | Spec gate (from agent .md ## VERIFY) | Risk |
|-----|------|---------------------------------------|------|
| A.1 | D.1 symptom-collector | JSON canonical schema, complexity_score 0-100, schema_version "1.0", gaps non-null when incomplete | Depends A.0 commit landed |
| A.2 | D.2 strategist | first-principles output absent of git/adversarial/patch keywords + confidence_overall + ≥1 hypothesis with what_would_disprove | — |
| A.3 | D.3 archaeologist | Gemini CLI preflight (fail-closed), SHAs spot-checked via `git log` (KBP-32) | **Codex/Gemini CLI ausente em CI** → SMOKE_STUB=1 |
| A.4 | D.4 adversarial | Codex CLI preflight (fail-closed), challenges reference real assumptions, KBP-28 frame-bound check | **Codex CLI ausente** → SMOKE_STUB=1 |
| A.5 | D.5 architect | markdown output (NOT JSON), READ-ONLY enforcement, KBP-32 path spot-check | — |
| A.6 | D.6 patch-editor | edits ONLY architect-listed files (KBP-01), KBP-19 protected files, edit-log honest, zero-edit valid | Stateful test (file ops) — fixture isolated tmpdir |
| A.7 | D.7 validator | READ-ONLY Bash, verdict ∈ {pass, partial, fail}, loop_back non-null when fail | — |

**Risk mitigation:**
- **G1 — Codex/Gemini CLI ausente:** SMOKE_STUB=1 env var (skip preflight, use canned JSON output). Pattern já preparado em S256 §14 risk table.
- **`claude agents call <name>` CLI shape unknown:** A.1 trial primeiro (simplest agent) antes 7-batch.
- **Smoke test reveals agent bug:** defer fix S259, document em CHANGELOG (KBP-01 anti-scope-creep, S256 §14 mitigation).

**Files NEW Phase A.1-A.7:** 14 NEW (7 .sh + 7 .json fixtures)

**Commit per test:** `feat(S258): A.X D.N <agent> smoke test ATIVO — VERIFY <spec gist>`

**Verification end Phase A:**
- `bash scripts/smoke/debug-<agent>.sh` exit 0 para todos 7
- Time budget <60s trivial input per test
- Total Phase A: 8 commits (A.0 + A.1-A.7)

---

## 4. Phase B — Plan close + sync (~15-20min, 2 commits)

### 4.1 B.1 HANDOFF + CHANGELOG sync (~10min, 1 commit)

**HANDOFF.md (Edit, NEVER Write — anti-drift §State files):**
- Remove P0 Phase 4 smoke tests (RESOLVED Phase A)
- Promote P1 Metanálise QA → P0 (next session priority — BACKLOG #64 commitment)
- Refresh Cautions ativas (drop S256-specific items consumed)
- Refresh Hidratação S259 steps (3-step pattern)
- Add `Plans active (1)` line — só immutable-gliding-galaxy.md remain post-archive

**CHANGELOG.md (Edit append-only):**
- §S258 — phases shipped (A.0 + A.1-A.7) + LOC delta + 8-9 commits
- Aprendizados (max 5 li):
  - KBP-32 finding: HANDOFF claims sobre agent .md sections requerem spot-check (precedente para state files lint sync)
  - SMOKE_STUB=1 env var pattern validated (Codex/Gemini CLI fail-closed friendly)
  - `claude agents call <name>` CLI shape captured per agent (D.6 patch-editor stateful = mais complex)

**BACKLOG.md (Edit):**
- Mark items resolved se aplicável (Phase 4 was tracked? — confirmar pre-edit)

**Commit:** `docs(S258): close — Phase A 7/7 smoke ATIVO + KBP-32 VERIFY add + HANDOFF/CHANGELOG sync`

### 4.2 B.2 Archive this plan (~5min, 1 commit)

- `git mv .claude/plans/async-moseying-pebble.md .claude/plans/archive/S258-hookscont.md`
- `.claude/plans/README.md` Edit:
  - Histórico recente: append `archive/S258-hookscont.md | S258 | HISTORICAL — Phase 4 smoke tests done + KBP-32 fix`
  - Active count remains 1 (immutable-gliding-galaxy.md only)

**Commit:** `chore(S258): plan archived as S258-hookscont.md — README sync`

---

## 5. Critical files map

### Phase A.0
- `.claude/agents/debug-symptom-collector.md` (append `## VERIFY` ~15-25 li após Fase 3)

### Phase A.1-A.7 (NEW — 14 files)
- `scripts/smoke/debug-symptom-collector.sh`
- `scripts/smoke/debug-strategist.sh`
- `scripts/smoke/debug-archaeologist.sh`
- `scripts/smoke/debug-adversarial.sh`
- `scripts/smoke/debug-architect.sh`
- `scripts/smoke/debug-patch-editor.sh`
- `scripts/smoke/debug-validator.sh`
- `scripts/smoke/fixtures/{symptom-collector,strategist,archaeologist,adversarial,architect,patch-editor,validator}-input.json`

### Phase B
- `HANDOFF.md` (Edit, anti-drift §State files)
- `CHANGELOG.md` (Edit append-only)
- `.claude/BACKLOG.md` (Edit — confirm cross-ref)
- `.claude/plans/README.md` (Edit histórico recente)
- `.claude/plans/async-moseying-pebble.md` → `.claude/plans/archive/S258-hookscont.md` (git mv)

---

## 6. Existing patterns to reuse (DRY)

| Pattern | Source | Used in |
|---------|--------|---------|
| `set -euo pipefail` | bash std | All 7 smoke tests |
| `jq -e '<field>'` validation | S256 §9 + bash idiom | All 7 smoke tests |
| `SMOKE_STUB=1` env var stub strategy | S256 §14 risk mitigation | A.3 archaeologist + A.4 adversarial |
| `## VERIFY` section format | 6/7 agents .md (debug-strategist as model) | A.0 add to symptom-collector |
| `claude agents call <name>` CLI invocation | Claude Code native | All 7 smoke tests |
| KBP-32 spot-check before claim → edit | anti-drift.md §Delegation gate | Aplicado upfront (revelou symptom-collector gap) |

---

## 7. KBP gates ativos durante exec

- **KBP-01 anti-scope-creep:** smoke test reveal agent bug → defer S259, não fix in-place
- **KBP-19 protected files:** `scripts/smoke/*` é content novo não-protegido — Write direto OK
- **KBP-25 Edit precision:** Read full range ±20li antes de Edit em `debug-symptom-collector.md`
- **KBP-32 spot-check:** já aplicado upfront (revelou symptom-collector ## VERIFY ausente)
- **KBP-37 Elite faria diferente — actionable:** EC loop por commit, não pseudo-confessional
- **KBP-40 branch awareness:** `git branch --show-current` antes commit (atual: main, confirmed)
- **KBP-41 Cut calibration:** se 2+ Cut na sessão, recalibrar threshold
- **EC loop pré-Edit:** Verificacao + Mudanca + Elite (1) por que melhor (2) o que elite faria diferente

---

## 8. Sequencia Lucas approval gates

| Gate | Quando | O que requer aprovação |
|------|--------|------------------------|
| **G0** | Pre-Phase A | Approve este plan via ExitPlanMode + decide Option A/B/C/D |
| **G0.1** | Pre-Phase A.0 | (a) add `## VERIFY` to symptom-collector OU (b) inferir critérios — recommend (a) |
| **G1** | Pre-Phase A.3/A.4 | SMOKE_STUB=1 stub strategy OK pra Codex/Gemini CLI? |
| **G2** | Pos-Phase A.1 trial | `claude agents call` CLI shape working? Continuar 7-batch ou ajustar? |
| **G3** | Pos-Phase A | Continuar Phase B mesma sessão OU split S259? |
| **G4** | Pre-push | Push to origin/main? (KBP-40 verify branch antes) |

**Sem gates intermediários por commit dentro de Phase A** — anti-drift §Plan execution permite multi-step se all phases listed upfront (este plan ✓).

---

## 9. Out of scope (defer S259+)

- **HANDOFF P1 metanálise QA editorial** — full focus session dedicada (12 slides LINT-PASS pendentes + 1 QA-in-progress; Lucas commitment via BACKLOG #64; S240 plan archived ainda válido)
- **BACKLOG P0a/P0b/P0c content delivery** — shared-v2 Day 2 (#53), grade-v2 scaffold (#52), qa-pipeline v2 (#54). Deadline 30/abr T-4d — exige session dedicada com plan separado
- **Lib refactor consolidado** (drain_stdin 7+ hooks, REPO_SLUG calc 3 hooks, safe_source pattern) — Conductor §6.X
- **H4/X2/X3 redundâncias debug-team** (Conductor §6.2-6.3 destrutivos) — MERGE systematic-debugging into debug-team
- **Conductor §6.5 G9 Maturity layers** (SDL/SAMM/OpenSSF/CMMI) SOTA radar
- **KBP-42 codify** (WebFetch URL lifecycle 7 fires) — defer P2 sota-intake skill
- **/insights P253-001 backlog triage** (41 items STAGNANT 19+ sessões)
- **Conductor §16 sync com S254/S255/S256/S258 state** + per-arm matrix
- **R3 Clínica Médica prep** — 218 dias
- **2 KBP candidates S256 emergent codify:**
  - "Producer-consumer path contracts" — files written por X read por Y require path equality OR co-evolve
  - "State files staleness recursive" — README/HANDOFF/BACKLOG counts/paths require lint sync vs Glob real (KBP-40 análogo)
- **`.claude/.last-insights` repo-local cleanup** — tracked file frozen S225-era; redundant pós dual-write fix S256

---

## 10. Verification end-to-end S258

1. **7 smoke tests pass:** `bash scripts/smoke/debug-<agent>.sh` exits 0 (com SMOKE_STUB=1 onde necessário)
2. **debug-symptom-collector.md ## VERIFY** added (Grep `^##\s+VERIFY` em 7/7 agents)
3. **CHANGELOG §S258** com Aprendizados ≤5 li (KBP-32 finding + SMOKE_STUB validation noted)
4. **HANDOFF refresh** P0 forward (P1 metanálise → P0 next)
5. **Plan archived** as `archive/S258-hookscont.md`, README updated, active count = 1
6. **No git status surprise** pre-push (KBP-40 corollary check)
7. **Hooks teatro audit:** Phase 4 T4 → ATIVO (S256 carry-forward debt closed)

---

## 11. Risk + mitigation

| Risk | Mitigation |
|------|------------|
| `claude agents call <name>` CLI não existe / shape diferente do esperado | Phase A.1 trial run primeiro (D.1 symptom-collector simples) antes 7-batch; replan se shape unknown |
| Codex/Gemini CLI fail-closed bloqueia A.3/A.4 sem stub | SMOKE_STUB=1 env var pattern (S256 §14) — fixture inclui canned output |
| Smoke test reveals agent bug | Defer fix S259, document CHANGELOG (KBP-01); Phase A continues mesmo com 1-2 FAIL flagged |
| Lucas pivot Option B/C/D mid-session | Phase A pausável commit-by-commit (~15-20min cada) — checkpoint pos-A.0 |
| Phase A demora >2.5h | Hard checkpoint pos-A.4 (4 tests done) — Lucas decide split S259 |
| 30/abr T-4d puxa pra content (Option D) | Flagged em §2 + §9; Lucas decide G0 |
| s-contrato R11=5.7 inconsistência | Não relevante Option A; flagged em S240 plan se Option B chosen |
| HANDOFF afirmação "Cada agent .md tem ## VERIFY" stale (KBP-32 found) | Already addressed Phase A.0; broader pattern (state files lint) deferred S259+ as KBP candidate |

---

Coautoria: Lucas + Opus 4.7 (Claude Code) | S258 hookscont plan | 2026-04-26
