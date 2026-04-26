# Plan S256 — Hooks finish + Plans hygiene + sequence locked

> **Status:** PROPOSTA pendente Lucas approval via ExitPlanMode
> **Origem:** consolida pendências de `dreamy-yawning-kite.md` (P0 ATIVO) + triage de `lovely-sparking-rossum.md` (P2 PAUSED) + reference `immutable-gliding-galaxy.md` (P1 BACKGROUND)
> **Mandato Lucas (S256 abertura):** "incorporar os planos e mover os antigos para o arquivo classificados para nao poluir seu contexto"
> **Coautoria:** Lucas + Opus 4.7 (Claude Code) | S256 hooks | 2026-04-26

---

## 1. Context

S255 fechou Phase 1 (4 hook teatros) + Phase 2 (5-voice council audit) + Phase 3 Block A 5/8. Restam **3 fixes mecânicos Block A + 4 decisions Block B + Block C BACKLOG #63 + Block D 7 smoke tests**, cross-distribuídos em 3 plan files separados:

- `dreamy-yawning-kite.md` (350 li) — canonical Phase 3 plan; Blocks A.6/A.7/A.8 + B + C + D specs intactos
- `lovely-sparking-rossum.md` (S240) — 16 sessões dormant (README triage rule: ≥3 dormant = reclassify)
- `immutable-gliding-galaxy.md` — Conductor 2026 single source of truth (background reference doc, low context cost)

**Problema:** README.md afirma "Active plans (0)" — desatualizado. 3 planos no raiz poluem context inicial. Lucas quer hygiene + execution clara.

**Outcome desejado:**
1. Plans hygiene: README sync, naming convention aplicada, dormant plans archived com BACKLOG pointer (preserva commitment)
2. S256 P0 closure: hooks teatro residual ZERO (Block A finish + B exec)
3. S256 P1 closure: BACKLOG #63 RESOLVED + 7 smoke tests ATIVO (Block C + D)
4. HANDOFF puro forward signal pós-S256

**Honest scope (sem sycophancy):**
- Phase 0 hygiene: ~20min, 1 commit
- Phase 1 Block A finish: ~50min, 3 commits
- Phase 2 Block B decisions+exec: ~30min decisões + 30-90min exec, 4 commits
- Phase 3 Block C systematic: ~1.5-2h, 3-5 commits
- Phase 4 Block D smoke tests: ~1.5-2.5h, 7 commits
- Phase 5 close: ~20min, 1 commit
- **Total: ~5-7h.** Realista one-session se Lucas committed; split S256+S257 se preferir.

---

## 2. Phase 0 — Plans hygiene (~20min, 1 commit)

### 2.1 Triage decision matrix

| Plan | Status atual | Ação proposta | Justificativa |
|------|--------------|---------------|---------------|
| `dreamy-yawning-kite.md` (untracked, 350 li) | P0 ATIVO S255+S256 | KEEP ativo durante exec; rename `S255-S256-debug-team-hooks.md` na Phase 5 close + commit ao archive | Naming convention §README pre-archival; auto-gen name aceitável durante execution |
| `immutable-gliding-galaxy.md` | P1 BACKGROUND Conductor 2026 reference | **KEEP ativo** — não archive. É reference doc consultado em sessões futures (12-arms taxonomy + KPIs); §16 backlog reference | Low context cost (não Read durante hot session a menos que seja Conductor work); high value cross-session |
| `lovely-sparking-rossum.md` (S240) | P2 PAUSED metanálise | **ARCHIVE** como `archive/S240-DEFERRED-lovely-sparking-rossum.md` + add BACKLOG pointer "metanálise QA resume post-hooks-complete" | 16 sessões dormant >> README threshold ≥3; commitment preserved via BACKLOG (Lucas pode invocar resume signal a qualquer momento, plan readable em archive) |

### 2.2 README.md update

Atual:
```
## Active plans (0)
**Status:** vazio pós-S232.
```

Novo (factual):
```
## Active plans (2)
- **[P0 ACTIVE]** dreamy-yawning-kite.md (S255-S256 debug-team-hooks Phase 3) — finishing S256
- **[P1 BACKGROUND]** immutable-gliding-galaxy.md (Conductor 2026 single source of truth) — reference doc cross-session
```

Histórico recente: appendar linhas S255+S256.

### 2.3 BACKLOG.md addition

Add pointer item:
```
## Pendências background ativas

- **#NN metanálise QA resume** — `archive/S240-DEFERRED-lovely-sparking-rossum.md` plan persisted; resume signal post-hooks-complete (Block C+D done). Lucas commitment.
```

### 2.4 Commit Phase 0

`chore(S256): plans hygiene — README sync, S240 lovely-sparking-rossum archived w/ BACKLOG pointer, dreamy-yawning-kite stamped pending S256 close-archive`

**Files modify Phase 0:**
- `.claude/plans/README.md`
- `.claude/plans/lovely-sparking-rossum.md` → `git mv` para `.claude/plans/archive/S240-DEFERRED-lovely-sparking-rossum.md`
- `.claude/BACKLOG.md`

**Verification:** Glob `.claude/plans/*.md` retorna 3 files (README + dreamy + immutable). Archive Glob retorna +1 (S240).

---

## 3. Phase 1 — Block A finish (~50min, 3 commits)

Specs canonical: `dreamy-yawning-kite.md §3.6 + §3.7 + §3.8`.

### 3.1 A.6 post-global-handler fallback fix + TTL (~10min, 1 commit)

**Files modify:** `.claude/hooks/post-global-handler.sh:21`, `hooks/session-start.sh` (TTL bonus)

- Fallback `unknown_${REPO_SLUG}_$(date)` recognizable como anomaly
- session-start TTL one-liner: `find /tmp -maxdepth 1 -name 'cc-calls-unknown_*.txt' -mtime +1 -delete`

**Commit:** `fix(S256): A.6 post-global-handler fallback recognizable + TTL cleanup`

### 3.2 A.7 pre-compact-checkpoint timing fix (~15min, 1 commit)

**Files modify:** `hooks/pre-compact-checkpoint.sh:15-61`

- Capturar `OLD_MTIME=$(stat -c %Y "$CHECKPOINT" 2>/dev/null || echo 0)` ANTES do truncate
- `find -newermt @$OLD_MTIME` reference (não checkpoint atual)

**Commit:** `fix(S256): A.7 pre-compact-checkpoint timing — find -newermt OLD_MTIME`

### 3.3 A.8 hook-log.sh JSON escape via jq (~25min, 1 commit)

**Files modify:** `hooks/lib/hook-log.sh:17-22`, `hooks/post-tool-use-failure.sh:28-30,36-40`

- Replace `printf '{"ts":"%s",...}'` por `jq -cn --arg ts "$ts" --arg event "$event" ... '{ts:$ts,event:$event,...}'`
- Validation: post-fix write entry com `"foo \"bar\"\n` em detail, `jq` parse confirma valid

**Commit:** `fix(S256): A.8 hook-log JSON escape via jq — defends against quotes/newlines`

**Verification per fix Phase 1:**
1. `bash -n <hook>` syntax check
2. Manual stdin trigger + observe stdout/stderr/exit code
3. Verify intended side-effect (file written, log appended)
4. Verify NO unintended (git status check)

---

## 4. Phase 2 — Block B decisions + exec (~1-1.5h, 4 commits)

### 4.1 Decisions batch via AskUserQuestion (D1-D4, ~30min)

Apresentar 4 questions PARALELAS antes de qualquer Edit. Lucas pick once, eu exec sequencial. Specs em `dreamy-yawning-kite.md §4 D1-D4`.

- **D1 chaos:** (a) always-on | (b) opt-in document | (c) remove + revert Conductor §4.9
- **D2 Stop[1] inline:** (a) remove | (b) restrict prompt | (c) status quo
- **D3 secret bypass Grep/Glob:** (a) PreToolUse matchers | (b) permissions.deny | (c) both *(recommend)*
- **D4 guard-bash-write filter:** (a) broaden settings if | (b) remove filter | (c) keep + remove dead detectors

### 4.2 Execution sequenciado (depends Lucas picks)

| Sub | Files modify (depends pick) | Estimate |
|-----|------------------------------|----------|
| B.1 D1 chaos | settings.json env OR README docs OR rm hooks + lib + Conductor §4.9 | 5-15min |
| B.2 D2 Stop[1] | settings.json (remove agent) OR prompt edit | 10-15min |
| B.3 D3 secrets | guard-read-secrets.sh + maybe permissions.deny | 15-30min |
| B.4 D4 guard-bash-write | settings.json:226 broaden OR script clean | 10-25min |

**Commits:** 4× `fix(S256): B.X DN <action>` per fix.

**Verification per fix:** mesma do Phase 1 (bash -n + manual + side-effect + no-side-effect).

---

## 5. Phase 3 — Block C BACKLOG #63 systematic-debug (~1.5-2h, 3-5 commits)

Specs canonical: `dreamy-yawning-kite.md §5`.

### 5.1 Audit /insights + /dream lifecycle (~30min, 0 commits)

**Files read-only:** `.claude/skills/insights/SKILL.md`, `.claude/skills/dream/SKILL.md`, `hooks/session-end.sh`, `hooks/session-start.sh:88-127`

- Trace: when does `.last-insights` get written? (open vs close)
- Trace: when does `~/.claude/.dream-pending` get deleted?
- Hipótese leading: write-on-OPEN inverted causa recurring FP

### 5.2 Fix lifecycle bug (~30-45min, 1-2 commits)

**Files modify (depends finding):** likely `.claude/skills/insights/SKILL.md` + `hooks/stop-quality.sh` OR new `hooks/post-skill-use.sh`

- Move `.last-insights` write para skill end (não open)
- Same for dream-pending if applicable

**Commit:** `fix(S256): C insights lifecycle write-on-close — eliminates recurring FP banner`

### 5.3 Re-enable session-start.sh blocks (~10min, 1 commit)

**Files modify:** `hooks/session-start.sh` (linhas ~88-95 dream + ~117-127 insights)

- Toggle `if false` → `if true` AMBOS blocks

**Commit:** `feat(S256): C re-enable dream + insights surface in session-start`

### 5.4 BACKLOG mark RESOLVED (~5min, 1 commit)

**Files modify:** `.claude/BACKLOG.md`

- Mark #63 RESOLVED com pointer ao commit fix

**Commit:** `docs(S256): C BACKLOG #63 RESOLVED — dream-pending + insights lifecycle E2E`

**Verification Phase 3:**
1. Trigger /dream end-to-end: `~/.claude/.dream-pending` cleared post-completion
2. Trigger /insights end-to-end: `.last-insights` updated DEPOIS skill completou
3. Restart session 3x, observe banners fire correto (não FP, não silent)

---

## 6. Phase 4 — Block D smoke tests debug-team T4 fix (~1.5-2.5h, 7 commits)

Specs canonical: `dreamy-yawning-kite.md §6 D.1-D.7`. Cada agent .md tem `## VERIFY` section.

### 6.1 Common pattern per smoke test

```bash
#!/usr/bin/env bash
set -euo pipefail
INPUT_FIXTURE="scripts/smoke/fixtures/<agent>-input.json"
OUTPUT="$(claude agents call <agent> < $INPUT_FIXTURE 2>&1)"
echo "$OUTPUT" | jq -e '<required field>' || { echo "FAIL: <reason>"; exit 1; }
echo "$OUTPUT" | jq -e '<another invariant>' || { echo "FAIL"; exit 1; }
echo "PASS"
```

### 6.2 7 smoke tests (1 commit each, ~20min cada)

| Test | Spec gate (from agent .md VERIFY) |
|------|------------------------------------|
| D.1 symptom-collector | JSON canonical schema, complexity_score 0-100, schema_version "1.0", gaps non-null when incomplete |
| D.2 strategist | first-principles output absent of git/adversarial/patch keywords + confidence_overall + ≥1 hypothesis with what_would_disprove |
| D.3 archaeologist | Gemini CLI preflight (fail-closed), SHAs spot-checked via `git log` (KBP-32) |
| D.4 adversarial | Codex CLI preflight (fail-closed), challenges reference real assumptions, KBP-28 frame-bound check |
| D.5 architect | markdown output (NOT JSON), READ-ONLY enforcement, KBP-32 path spot-check |
| D.6 patch-editor | edits ONLY architect-listed files (KBP-01), KBP-19 protected files, edit-log honest, zero-edit valid |
| D.7 validator | READ-ONLY Bash, verdict ∈ {pass, partial, fail}, loop_back non-null when fail |

**Files NEW Phase 4:**
- `scripts/smoke/debug-symptom-collector.sh`
- `scripts/smoke/debug-strategist.sh`
- `scripts/smoke/debug-archaeologist.sh`
- `scripts/smoke/debug-adversarial.sh`
- `scripts/smoke/debug-architect.sh`
- `scripts/smoke/debug-patch-editor.sh`
- `scripts/smoke/debug-validator.sh`
- `scripts/smoke/fixtures/<agent>-input.json` (7 fixtures)

**Verification Phase 4:** cada `bash scripts/smoke/debug-<agent>.sh` exits 0; time budget <60s trivial input.

---

## 7. Phase 5 — S256 close (~20min, 1 commit)

### 7.1 Update HANDOFF + CHANGELOG

- HANDOFF: pure forward signal — what's next S257 (P2 advance items: lovely-sparking-rossum resume, lib refactor, H4/X2/X3 redundâncias, Conductor §16 sync, R3 prep)
- CHANGELOG: §S256 com phases shipped + LOC delta + Aprendizados (max 5 li)

### 7.2 Archive dreamy-yawning-kite (post-completion)

- `git mv .claude/plans/dreamy-yawning-kite.md .claude/plans/archive/S255-S256-debug-team-hooks.md`
- README.md update: remover de active, adicionar histórico recente

### 7.3 Final commit + push gate

`chore(S256): close — Phase 3 complete, hooks teatro 0/35 residual, debug-team smoke tests 7/7 ATIVO, BACKLOG #63 RESOLVED, dreamy-yawning-kite archived`

Push: Lucas explicit OK (não autonomous).

---

## 8. Critical files map

### Phase 0 hygiene
- `.claude/plans/README.md`
- `.claude/plans/lovely-sparking-rossum.md` → `archive/S240-DEFERRED-lovely-sparking-rossum.md`
- `.claude/BACKLOG.md`

### Phase 1 Block A
- `.claude/hooks/post-global-handler.sh:21` (A.6)
- `hooks/session-start.sh` (A.6 TTL bonus)
- `hooks/pre-compact-checkpoint.sh:15-61` (A.7)
- `hooks/lib/hook-log.sh:17-22` (A.8)
- `hooks/post-tool-use-failure.sh:28-30,36-40` (A.8)

### Phase 2 Block B (depends Lucas picks)
- `.claude/settings.json` (D1, D2, D3, D4 maybe)
- `.claude/hooks/chaos-inject-post.sh` + lib + Conductor §4.9 (D1)
- `.claude/hooks/guard-read-secrets.sh` + permissions (D3)
- `.claude/hooks/guard-bash-write.sh` (D4)

### Phase 3 Block C
- `.claude/skills/insights/SKILL.md`
- `.claude/skills/dream/SKILL.md`
- `hooks/session-start.sh` (re-enable 2 blocks ~88-127)
- `hooks/session-end.sh` (maybe lifecycle improvements)
- `.claude/BACKLOG.md` (#63 RESOLVED)

### Phase 4 Block D
- 7 NEW `scripts/smoke/debug-*.sh`
- 7 NEW `scripts/smoke/fixtures/<agent>-input.json`

### Phase 5 close
- `HANDOFF.md` (Edit, NEVER Write — anti-drift §State files)
- `CHANGELOG.md` (Edit append-only)
- `.claude/plans/dreamy-yawning-kite.md` → `archive/S255-S256-debug-team-hooks.md`
- `.claude/plans/README.md`

---

## 9. Existing patterns to reuse (DRY)

| Pattern | Source | Used in |
|---------|--------|---------|
| `[[ -n "${_LIB_LOADED:-}" ]] && return 0` (idempotent include) | `hooks/lib/banner.sh` (S255 A6) | Phase 1+ if new libs |
| `jq -cn --arg key "$val" '{key:$key}'` (safe JSON) | `hooks/post-compact-reread.sh:17` | Phase 1 A.8 |
| `hook_log <event> <hook> ...` envelope | `hooks/lib/hook-log.sh:9` | Phase 1 + Phase 2 |
| Write→`.claude-tmp/X.new`→cp (KBP-19 protected) | `.claude/rules/known-bad-patterns.md` KBP-19 | All Phase 1+2 hook edits |
| Surface block pattern (read + cat if non-empty) | `hooks/session-start.sh:74-84` (pending-fixes) | Phase 3 if needed |
| `git rev-list --count origin/main..HEAD` (KBP-40 branch awareness) | S255 lesson | Pre-push gate |
| `jq -e '<field>'` validation | bash idiom | All Phase 4 smoke tests |

---

## 10. KBP gates ativos durante exec

- **KBP-01 anti-scope-creep:** cada commit isolado, 1 phase = 1 concern, sem refactor adjacente
- **KBP-19 protected files:** `.claude/hooks/*` editar via Write→tmp→cp (não Bash heredoc)
- **KBP-25 Edit precision:** Read full range ±20li antes Edit; copy old_string direto do output
- **KBP-32 spot-check:** todo claim AUSENTE em audit confirmar via Grep antes Edit
- **KBP-37 Elite faria diferente — actionable:** EC loop não vira pseudo-confessional
- **KBP-40 branch awareness:** `git branch --show-current` antes commit
- **KBP-41 Cut calibration:** se 2+ Cut na sessão, recalibrar threshold
- **EC loop pré-Edit:** Verificacao + Mudanca + Elite (1) por que melhor (2) o que elite faria diferente

---

## 11. Sequencia Lucas approval gates

| Gate | Quando | O que requer aprovação |
|------|--------|------------------------|
| **G0** | Pre-Phase 0 | Approve todo o plan via ExitPlanMode |
| **G1** | Pre-Phase 2 | D1-D4 batch decisions via AskUserQuestion |
| **G2** | Pos-Phase 2 (opcional) | Continuar Phase 3+4 nesta sessão OU split S257? |
| **G3** | Pre-Phase 5 commit final | Push to origin/main? (KBP-40 verify branch) |

**Sem gates intermediários por commit** — anti-drift §Plan execution permite multi-step se all phases listed upfront (este plan ✓).

---

## 12. Out of scope (explicit S257+)

- **H4/X2/X3 redundâncias** (Conductor §6.2-6.3 destrutivos): MERGE systematic-debugging into debug-team
- **Lib refactor consolidado** (drain_stdin 7+ hooks, REPO_SLUG calc 3 hooks, safe_source pattern): session dedicada lib audit
- **lovely-sparking-rossum resume** (metanálise QA): post-Block C+D resume signal
- **Conductor §16 sync com S254/S255/S256 state** + per-arm matrix §17.1-§17.12
- **R3 Clínica Médica prep** — 217 dias
- **Slides metanálise + scripts migration** (P0 original S254/S255 deferred): 2-3 slides + 4 JS scripts → agents/skills + chatgpt-research.mjs NEW
- **KBP-42 codify** (WebFetch URL lifecycle 7 fires): defer P2 sota-intake skill
- **/insights P253-001** backlog triage (41 items STAGNANT 19 sessões)

---

## 13. Verification end-to-end S256

1. **Hooks teatro audit re-run** (Phase 2 council pattern compressed): expect 0-2 ADOPT-tier remaining (apenas DEFER conscious)
2. **APL CALLS counter** continua working (validated S255)
3. **`/tmp` cleanliness:** counter files <10 (TTL working from A.6 bonus)
4. **No SessionStart errors** (validated S255 A.1)
5. **integrity-report.md surface ativo** (validated S255 A.5)
6. **Dream + insights banners** fire correto, não FP, não silent
7. **7 smoke tests debug-team** all pass `bash scripts/smoke/debug-<agent>.sh`
8. **CHANGELOG + HANDOFF** accurate, push state real (not stale)
9. **Plans hygiene:** README factual, 2 active (dreamy archived post-close), lovely-sparking in archive com BACKLOG pointer

---

## 14. Risk + mitigation

| Risk | Mitigation |
|------|------------|
| Block C audit reveals lifecycle bug mais complexo que write-on-OPEN | Phase 3.1 audit-only step (zero commits) — re-plan se finding ≠ hipótese |
| Block D Codex/Gemini CLI preflight falha em CI/local | Smoke test stub the call (KBP-32 spot-check skip via env var SMOKE_STUB=1) |
| Lucas D1-D4 picks revelam novo escopo (e.g., ADR para D4) | Pause Phase 2 exec, return to plan, propose adjustment |
| Phase 4 smoke tests revelam agent bugs (não só ausência de teste) | Documentar findings em CHANGELOG, defer fix S257 (anti-scope-creep KBP-01) |
| 5-7h é otimista — sessão cansa | Hard checkpoint pos-Phase 2 (Gate G2) — Lucas decide split |
| dreamy-yawning-kite untracked file lost se window crash | Commit-as-archive ASAP no Phase 5; Phase 0 commit já adiciona pointer indireto via README |
