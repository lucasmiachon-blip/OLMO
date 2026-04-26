# Plan S258 Phase D — Hooks improvements (não-amador)

> **Status:** PROPOSTA pendente Lucas approval via ExitPlanMode
> **Origem:** Phase C audit revelou 0 teatro (todos hooks alimentam consumer real) + 4 improvement vectors substantivos. Lucas: "arrumar hooks nessa, agents ficam pra proxima"
> **Coautoria:** Lucas + Opus 4.7 (Claude Code) | S258 hookscont Phase D | 2026-04-26

---

## 1. Context

Phase C audit (24 calls após Phase B close) revelou:

**Achados validados:**
- ✅ 0/32 hooks teatro — todos alimentam consumer real (post-bash-handler → /insights skill, stop-metrics → APL, stop-quality → next session-start surface, etc.)
- ✅ hooks-health.sh built + PASS 9/9 (trial Tier 1) — uncommitted
- ✅ Producer-consumer pattern emergent → KBP-43 candidate codify

**Gaps observados:**
- 🟡 **Direct fire confidence 50%** (15 stand-by hooks sem mock test)
- 🟡 **DRY hygiene:** drain_stdin pattern repetido em **12 hooks** (`.claude/hooks/{allow-plan-exit,momentum-brake-clear,post-global-handler}.sh` + `hooks/{notify,post-compact-reread,pre-compact-checkpoint,session-compact,session-end,session-start,stop-metrics,stop-notify,stop-quality}.sh`) — copy-paste vulnerable a inconsistency
- 🟡 **`rm <single-file>` bypassa friction** — Pattern 17 `\b(rm|rmdir)\b` matches mas hook não fired/blocked (deeper investigation S259+ — settings filter precedence vs Bash(*) allow vs hook output)
- 🟡 **Producer-consumer matrix não-documentado** — descoberta esta sessão lost se não persistir

**Outcome desejado:**
- Confidence runtime 50% → 75%+ via mock tests +5 critical guards
- DRY refactor 12 → 1 (drain_stdin lib extract)
- Knowledge persisted (audit doc + KBP-43)
- 0 broken hooks após work
- Não-amador: substantivo (não bureaucracy), reversível, evidence-based

**Honest scope sem sycophancy:**
- ~2-2.5h, 4-5 commits, real defense improvement
- Dispenses "fix rm bypass" — escopo expandido + risk de over-engineering. Defer S259 com investigation completa (settings precedence + hook output semantics).

---

## 2. Phase D.1 — Commit hooks-health.sh + extend +5 mock tests (~45min, 1 commit)

**Atual:** `scripts/smoke/hooks-health.sh` (built esta sessão, uncommitted) — 9 PASS:
T1 disk count · T2 chmod · T3 INV-2 · T4 hook-log populated · T4b distinct · T5 APL fresh · T6 guard-read-secrets · T7 guard-bash-write · T8 settings parseable

**Extend +5 critical guards via mock input pattern (Tier 1):**

| Test | Hook | Mock input | Expected |
|------|------|-----------|----------|
| T9 | guard-write-unified | `{"tool_name":"Write","tool_input":{"file_path":".claude/hooks/test.sh","content":"x"}}` | block (protected) |
| T10 | guard-secrets | `{"tool_name":"Bash","tool_input":{"command":"git commit"}}` (with mock .env in stage) | block |
| T11 | guard-mcp-queries | `{"tool_name":"mcp__pubmed__search","tool_input":{...}}` | ask |
| T12 | guard-research-queries | `{"tool_name":"Skill","tool_input":{"skill":"research"}}` | ask |
| T13 | guard-lint-before-build | `{"tool_name":"Bash","tool_input":{"command":"npm run build:metanalise"}}` | block (lint check) |

**Confidence delta:** 50% → 75% direct mock-test coverage.

**Files modify:**
- `scripts/smoke/hooks-health.sh` (extend +5 cases ~30 li)

**Verification:**
- `bash scripts/smoke/hooks-health.sh` exits 0 com 14/14 PASS (era 9/9)
- Each new test reproduzível por Lucas anytime

**Commit:** `feat(S258): D.1 hooks-health.sh +5 mock tests — confidence 50%→75% (14/14 PASS)`

---

## 3. Phase D.2 — drain_stdin lib extract (~45min, 1 commit)

**Pattern repetido em 12 hooks:**
```bash
cat >/dev/null 2>&1 || true  # consume stdin (hook protocol)
```

**Risk de copy-paste:** se padrão evolui (e.g., timeout, logging), manual sync 12 files = drift potencial (KBP candidate "DRY across hooks").

**Solução:** extract to `.claude/hooks/lib/drain-stdin.sh`:
```bash
#!/usr/bin/env bash
# .claude/hooks/lib/drain-stdin.sh — consume stdin (hook protocol)
# Source: . "$(dirname "$0")/lib/drain-stdin.sh"; drain_stdin
# OR cross-dir: . "$PROJECT_ROOT/.claude/hooks/lib/drain-stdin.sh"
drain_stdin() {
  cat >/dev/null 2>&1 || true
}
```

**Replace inline em 12 hooks:**
```bash
# Antes:
cat >/dev/null 2>&1 || true

# Depois:
. "$(dirname "${BASH_SOURCE[0]}")/lib/drain-stdin.sh" 2>/dev/null || \
  . "$PROJECT_ROOT/.claude/hooks/lib/drain-stdin.sh" 2>/dev/null
drain_stdin
```

**Cuidado:** `hooks/` (15 scripts) está em diretório DIFERENTE de `.claude/hooks/lib/`. Source path precisa ser absoluto via `$PROJECT_ROOT`. Pattern já existente em hooks/stop-failure-log.sh L7 (`. "$PROJECT_ROOT/hooks/lib/hook-log.sh"`).

**Ajuste arquitetura:** lib/drain-stdin.sh em `hooks/lib/` (não `.claude/hooks/lib/`) — consistência com `hooks/lib/hook-log.sh` + `hooks/lib/toast.sh`. Cross-dir source from `.claude/hooks/`:
```bash
. "$PROJECT_ROOT/hooks/lib/drain-stdin.sh"
drain_stdin
```

**Files modify (13):**
- `hooks/lib/drain-stdin.sh` (NEW)
- `.claude/hooks/{allow-plan-exit,momentum-brake-clear,post-global-handler}.sh` (3 — cross-dir source)
- `hooks/{notify,post-compact-reread,pre-compact-checkpoint,session-compact,session-end,session-start,stop-metrics,stop-notify,stop-quality}.sh` (9 — local source)
- 12 hooks total replace

**Risk + mitigation:**
- **KBP-19 protected files:** `.claude/hooks/*` is protected — Edit via Write→tmp→cp pattern (S256 deploy)
- **Idempotency check:** `[[ -n "${_DRAIN_STDIN_LOADED:-}" ]] && return 0` em lib (per S255 A6 banner.sh pattern)
- **Source-fallback fail:** if lib missing, drain via inline fallback (defensive)

**Verification:**
- `bash hooks/lib/drain-stdin.sh` source-able (`source` test)
- Mock input feeds (jq sample) cada modified hook → all consume + exit 0
- `bash scripts/smoke/hooks-health.sh` continua 14/14 PASS (regression check)
- `git diff --stat` mostra ~24 linhas changed (12 inline removed + 12 source added)

**Commit:** `refactor(S258): D.2 drain_stdin lib extract — DRY 12 hooks → 1 lib + 12 source`

---

## 4. Phase D.3 — Producer-consumer audit doc + KBP-43 codify (~30min, 1 commit)

**4.1 Audit doc:** `docs/audit/hooks-runtime-S258.md` (NEW ~150 li)

Conteúdo:
- Per-hook (32) producer + consumer + evidence (matriz já elaborada na conversa)
- Numerical aggregate (62% direct, 16% paired, 16% Lucas-visual, 16% Claude-warn, 0% teatro)
- Findings: rm <single-file> bypass investigation pendente S259, drain_stdin DRY done D.2
- Cross-ref: `.claude/hooks/README.md` (32 hooks index), `scripts/smoke/hooks-health.sh` (Tier 1 mock tests), CHANGELOG §S258 Phase D

**4.2 KBP-43 codify** em `.claude/rules/known-bad-patterns.md`:

```markdown
## KBP-43 Hook silent without consumer = teatro
→ docs/audit/hooks-runtime-S258.md (producer-consumer matrix template)
```

Pattern detection: `grep producer files in scripts → reverse grep readers in skills/agents/hooks → no reader = teatro candidate`. Apply when auditing new hooks.

**4.3 Update governance counters em known-bad-patterns.md:** "Next: KBP-44" (era 42; jumped 42→43 esta sessão).

**Files NEW:**
- `docs/audit/hooks-runtime-S258.md` (NEW ~150 li)

**Files modify:**
- `.claude/rules/known-bad-patterns.md` (add KBP-43 entry, update next #)

**Verification:**
- Doc exists + parseable Markdown
- `grep KBP-43 .claude/rules/known-bad-patterns.md` matches
- Cross-refs valid (paths real)

**Commit:** `docs(S258): D.3 hooks runtime audit doc + KBP-43 codify (producer-consumer pattern)`

---

## 5. Phase D.4 — HANDOFF + CHANGELOG sync + plan archive (~20min, 2 commits)

**5.1 HANDOFF.md update (Edit, anti-drift §State files):**
- Phase D shipped: 14/14 mock tests + drain_stdin lib + audit doc + KBP-43
- P0 promoted: agents runtime invoke + non-redundancy (Phase C.2/C.3 deferred S259)
- New P1: rm <single-file> investigation (root cause settings filter precedence)
- Update Cautions ativas

**5.2 CHANGELOG §S258 append (Phase D bloco):**
- D.1 commit + D.2 + D.3 (3 commits Phase D)
- Aprendizados delta (≤3 li novas — total ≤8 li per session relax):
  - Producer-consumer audit pattern (KBP-43 codified)
  - drain_stdin DRY 12→1 (hook lib pattern matures)
  - Mock-test confidence escalation: smoke Tier 1 = static + fixture; hooks-health Tier 1 = registration + mock input

**Commit:** `docs(S258): D.4 close — Phase D shipped + sync forward signal S259`

**5.3 Plan archive:**
- `mv .claude/plans/async-moseying-pebble.md .claude/plans/archive/S258-hookscont-phase-D.md` (preserve Phase A+B+D in 1 archived plan? OR 2 separate?)

Decision: this plan focuses Phase D — separate archive `S258-hookscont-phase-D.md` (Phase A+B already archived `S258-hookscont.md` post-B.2).

**Commit:** `chore(S258): D.4 plan Phase D archived as S258-hookscont-phase-D.md`

---

## 6. Critical files map

### Phase D.1
- `scripts/smoke/hooks-health.sh` (extend +5 cases)

### Phase D.2 (NEW + 12 modify)
- `hooks/lib/drain-stdin.sh` (NEW lib)
- `.claude/hooks/{allow-plan-exit,momentum-brake-clear,post-global-handler}.sh` (KBP-19 deploy)
- `hooks/{notify,post-compact-reread,pre-compact-checkpoint,session-compact,session-end,session-start,stop-metrics,stop-notify,stop-quality}.sh`

### Phase D.3
- `docs/audit/hooks-runtime-S258.md` (NEW)
- `.claude/rules/known-bad-patterns.md` (KBP-43 entry)

### Phase D.4
- `HANDOFF.md` (Edit)
- `CHANGELOG.md` (Edit append)
- `.claude/plans/async-moseying-pebble.md` → `.claude/plans/archive/S258-hookscont-phase-D.md`
- `.claude/plans/README.md` (histórico recente)

---

## 7. Existing patterns to reuse (DRY)

| Pattern | Source | Used in |
|---------|--------|---------|
| `[[ -n "${_X_LOADED:-}" ]] && return 0` (idempotent include) | `hooks/lib/banner.sh` (S255 A6) | D.2 drain-stdin.sh lib guard |
| `. "$PROJECT_ROOT/hooks/lib/X.sh"` cross-dir source | `hooks/stop-failure-log.sh:L7` (hook-log.sh) | D.2 source pattern |
| Write→tmp→cp protected file deploy (KBP-19) | S256 hook fixes | D.2 .claude/hooks/* edits |
| `bash scripts/smoke/X.sh` mock-test pattern | S258 Phase A (debug-* smoke) | D.1 +5 cases |
| Producer-consumer evidence enumeration | S258 Phase C audit | D.3 doc + KBP-43 |

---

## 8. KBP gates ativos durante exec

- **KBP-01 anti-scope-creep:** rm <single-file> investigation defer S259 (root cause exige settings filter exploration)
- **KBP-19 protected files:** `.claude/hooks/*` Edit via Write→tmp→cp deploy
- **KBP-25 Edit precision:** Read full hook ±20li antes de Edit
- **KBP-32 spot-check:** mock test fixtures match real hook script behavior
- **KBP-37 Elite faria diferente — actionable:** EC loop por commit
- **KBP-40 branch awareness:** `git branch --show-current` antes commit (atual: main)
- **KBP-41 Cut calibration:** zero "Cut" decisions neste plano; tudo "Doing now" ou "Defer S259+ gate-justified"
- **EC loop pré-Edit:** Verificacao + Mudanca + Elite (1) por que melhor (2) o que elite faria diferente

---

## 9. Sequencia Lucas approval gates

| Gate | Quando | O que requer aprovação |
|------|--------|------------------------|
| **G0** | Pre-Phase D.1 | Approve plan via ExitPlanMode |
| **G1** | Pos-Phase D.2 trial | drain_stdin lib working em 1-2 hooks pre-batch? |
| **G2** | Pre-Phase D.4 | HANDOFF P0 promotion (agents runtime → S259) confirma? |
| **G3** | Pre-push | Push to origin/main (KBP-40 verify) |

---

## 10. Out of scope (defer S259+)

- **Phase C.2 agents runtime invoke** (5 agents Task tool) — Lucas explicit "agents ficam pra proxima"
- **Phase C.3 non-redundancy live comparison** (3 paralelos same-task) — depends Phase C.2
- **rm <single-file> bypass root cause investigation** — settings filter precedence vs Bash(*) allow vs hook output semantics — defer S259 com plan dedicado
- **+10 mock tests para 100% confidence** (D.1 entrega 75%, restante stand-by hooks low priority)
- **H4 systematic-debugger merge** (already P2 #62 BACKLOG)
- **Lib refactor REPO_SLUG calc** (3 hooks repetition) — same DRY pattern, defer S259+ se repete
- **lint-on-edit smoke** (slide HTML edit triggered)
- **30/abr T-4d content delivery** (separate plan needed)
- **ARCHITECTURE.md/TREE.md update** (counts 9→16 agents, 30→32 hooks, S232/S245→S258) — defer post-merges

---

## 11. Verification end-to-end Phase D

1. **`bash scripts/smoke/hooks-health.sh`** exit 0 com **14/14 PASS** (era 9/9)
2. **drain_stdin lib source-able:** `bash -c '. hooks/lib/drain-stdin.sh; drain_stdin </dev/null'` exit 0
3. **12 hooks regression:** `for h in <12 modified>; do echo '{}' | bash $h; done` exit 0 cada
4. **`docs/audit/hooks-runtime-S258.md`** exists + parseable
5. **KBP-43** em known-bad-patterns.md (Grep `^## KBP-43`)
6. **CHANGELOG §S258 Phase D** appended ≤8 li Aprendizados total session
7. **HANDOFF refresh** P0 forward (agents runtime → P0 next)
8. **Plan archived** `archive/S258-hookscont-phase-D.md`, README +1 entry
9. **Working tree clean** pre-push (KBP-40 corollary)

---

## 12. Risk + mitigation

| Risk | Mitigation |
|------|------------|
| drain_stdin lib source path break em algum hook (Windows path separator?) | Phase D.2 trial em 1 hook pre-batch (Gate G1); rollback se path issue |
| Mock test fixture diverge real hook behavior | Phase D.1 each test exits 0 antes commit; reproduce real if possível |
| KBP-19 protected file Edit fails (`.claude/hooks/*`) | Write→tmp→cp pattern deploy (S256 precedent) |
| Lucas pivot pra outro escopo mid-session | Phase D.1/D.2/D.3/D.4 commit-by-commit pausável |
| Phase D demora >3h | Hard checkpoint pos-D.2 (Gate G1) — Lucas decide split |
| rm bypass investigation tempting durante exec | KBP-01 anti-scope-creep; logged S259+ in HANDOFF |
| Sentinel hook detection / scoring overlap | N/A esta phase (defer S259+ agents) |

---

Coautoria: Lucas + Opus 4.7 (Claude Code) | S258 hookscont Phase D plan | 2026-04-26
