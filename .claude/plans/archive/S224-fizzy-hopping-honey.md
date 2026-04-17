# INFRA100.2 — Consolidar Evolução S224

> Session: S224 | 2026-04-17 | Scope: solidify stability evidence + isolate S223 root cause + document ctx_pct reduction + clean commit.
> Supersedes INFRA100.1 plan (diag done, evidence preserved in `s224-stop-dispatch-diag.md`).

---

## Context

Lucas perguntou: "estamos evoluindo profissionalmente? atingimos objetivo? testado com evidência?" — resposta honesta: parcialmente. N=1 era MVP; evidência mtime auxiliar (T=0 → T=1 delta +294s) elevou para N=2, mas ainda insuficiente para claim robusto. Lucas disse "pode ir maior" = expandir S224 para consolidar evolução antes de Track A/B.

**Evidência objetiva acumulada em S224 (até este planejamento):**

| Métrica | Valor | Fonte | Comparação |
|---------|-------|-------|------------|
| Stop[5] dispatch events | N=2 monotonic | mtime `09:27:35` → `10:37:35` → `10:42:29` | S223: 0 eventos em 8h22m |
| `ctx_pct` current | 58 | `.claude/apl/ctx-pct.txt` | S222=72, S223=82 (metrics.tsv) |
| Hooks registry | 31/31 valid | integrity-report.md | unchanged across S222-S224 |
| rework_files | tracking 1 (low) | APL KPI start-of-session | S222=11 (high), S223=1 |
| handoff_pendentes | em queda | HANDOFF diff | S222=18, S223=11 |

**O que AINDA não sabemos:**
1. Dispatch é estável por >2 eventos? (H3 degradação de sessão vs H4 reload-via-touch).
2. Por que S223 falhou 8h22m? Não isolado — `> /dev/null 2>&1` mascarou tudo.
3. ctx_pct S224 **máximo** — 58 é snapshot; `ctx_pct_max` requer observar toda a sessão.
4. Commits parados há 78min (nudge reportou); trabalho untracked sem backup.

**Why this matters:**
Defense-in-depth vale se prova **contínua** de funcionamento. Se H3 (degradação), S225 pode começar broken sem aviso, repetindo o teatro S222. Path B fix original pendente — comando original roda agora, mas não entendemos *por que antes não rodava*. Isolar root cause imuniza contra regressão.

---

## Scope (ampliação S224, não S225)

### Phase 1 — N≥3 stability proof (read-only observational)
**Sem mudanças em settings.json.** Cada turn substantivo começa com:
```bash
stat -c '%y %Y' .claude/integrity-report.md
```
Recordo delta vs turn anterior. N=3 consecutive monotonic = H4 confirmed (reload-via-touch estabilizou dispatch). Se mtime flat em algum turn = H3 partial (flaky) → investigar mais.

**Acceptance:** 3 deltas positivos consecutivos.

### Phase 2 — Root cause S223 silence via stderr capture
**Patch add-only** em Stop[5] — mantém comando original intacto, apenas redireciona stderr:

```diff
- "command": "bash $CLAUDE_PROJECT_DIR/tools/integrity.sh > /dev/null 2>&1 || echo '[INTEGRITY] violations -- see .claude/integrity-report.md'",
+ "command": "bash $CLAUDE_PROJECT_DIR/tools/integrity.sh 2>>/tmp/stop5-stderr.log >/dev/null || echo '[INTEGRITY] violations -- see .claude/integrity-report.md'",
```

Diferença: `2>>/tmp/stop5-stderr.log` em vez de `2>&1`. stderr goes to persistent file instead of merging/silencing.

**Why add-only:** se patch quebra (unlikely), restore é diff reverse idêntico. Instrumentation permanente se útil.

**Exercise:** 1-2 Stop events com patch aplicado.

**Read `/tmp/stop5-stderr.log`:**
- **Empty** → comando original não emite stderr; S223 failure foi transient/external (harness state, race, disk IO). Não é composicional. Restaurar original + aceitar residual risk.
- **`$CLAUDE_PROJECT_DIR: unbound variable` ou similar** → var expansion issue. Restore com `$(git rev-parse --show-toplevel)` ou hardcode path.
- **`integrity.sh: line N: ...`** → script internal error, fix specific script issue.
- **Timeout/race messages** → dispatch happens but completion race; tune `async` e timeout.

**Restore decision tree:**
- If stderr empty: restore original byte-por-byte (no additional fix). S223 = transient mystery.
- If stderr revela bug: restore com fix **exclusive ao bug identificado** (no scope creep).
- Keep `2>>/tmp/stop5-stderr.log` permanent (instrumentation > silence).

### Phase 3 — Context weight measurement official
Read `ctx-pct.txt` no início e fim da sessão. Document in CHANGELOG:
```
S224 ctx_pct: start=X, end=Y (vs S222=72, S223=82). CLAUDE_CODE_DISABLE_1M_CONTEXT kept removed = substancial redução confirmed if Y≤65.
```

Decision matrix para `CLAUDE_CODE_DISABLE_1M_CONTEXT`:
- End ≤ 65 → **keep removed** (hipótese Lucas confirmed empirically).
- End 66-75 → **keep removed**, observe S225.
- End >75 → **revert** (flag não era a causa; outra fonte de weight).

### Phase 4 — Clean commit
Trigger após Phase 1-3 converge.
- `git add .claude/settings.json .claude/plans/s224-stop-dispatch-diag.md .claude/plans/fizzy-hopping-honey.md HANDOFF.md CHANGELOG.md`
- Possibly add stderr log file to `.gitignore` (not commit it).
- Single commit msg separating diag, fix, stability, metrics into bullet list.
- Do NOT push; Lucas pushes manually.

### Phase 5 (OPTIONAL, time-permitting) — Track A research prep
Read-only scout: Glob `.claude/skills/**` + check which skills mention SessionStart triggers vs on-demand invocation. Deliver 1 bulleted list of 2-3 lazy-load candidates. **Zero implementation.** Deliverable anexado ao plan file.

### OUT of scope (FROZEN)
- Track B (semantic truth-decay: INV-3 pointer, INV-4 count, INV-1 md destino)
- Memory 9 merges (`/dream`)
- Wallace CSS (29 raw px etc)
- Slides (s-quality, s-tipos-ma, drive-package)
- Docling
- Obsidian plugins
- Codex backlog (40 findings S220)

---

## Critical files

| File | Role | Mutation |
|------|------|----------|
| `.claude/settings.json:370-379` | Stop[5] entry | Phase 2 add-only stderr patch + conditional final restore |
| `/tmp/stop5-stderr.log` | stderr sink (NEW) | Phase 2 creates; gitignored |
| `.claude/integrity-report.md` | mtime probe | Read-only |
| `.claude/apl/ctx-pct.txt` | current ctx_pct | Read-only |
| `.claude/apl/metrics.tsv` | historical ctx_pct | Read-only |
| `HANDOFF.md` | session doc | Edit (not Write) — add Phase 2 verdict |
| `CHANGELOG.md` | session doc | Edit — append Phase 1-3 lines |
| `.gitignore` | exclude tmp artifacts | Edit if needed (stop5-stderr.log) |

---

## Evolution framework (answer "did we evolve?")

Binary assessment at Phase 4 commit:

| Criterion | Pass if | Status hoje |
|-----------|---------|-------------|
| 1. Stop[5] stability | N≥3 monotonic mtime | N=2 (pending Phase 1) |
| 2. Root cause S223 | stderr evidence OR explicit deferral com razão | pending Phase 2 |
| 3. Context reduction | ctx_pct_max end-of-session ≤ 65 | 58 current, trajectory OK |
| 4. Docs honest | HANDOFF + CHANGELOG + plans refletem verdict | done minimally, refinar |
| 5. Clean commit | `git status` clean pós-commit | pending Phase 4 |

**≥4/5 PASS → evoluímos, S225 starts Track A.**
**<4 PASS → S225 carries remaining gap.**

---

## Verification

- Phase 1: per-turn `stat` logs visible; T=2, T=3 mtime > T=0 (1776433055) and > T=1 (1776433349).
- Phase 2: `cat /tmp/stop5-stderr.log` shows concrete evidence OR confirmed empty; `jq '.hooks.Stop[5]'` post-restore matches intended.
- Phase 3: `cat .claude/apl/ctx-pct.txt` at end of session; number appended to CHANGELOG.
- Phase 4: `git log -1 --stat`; `git status` empty.
- Phase 5 (if done): plan file has § "Lazy-load candidates (Track A prep)".

---

## Risk & reversibility

- **Phase 2 patch:** add-only modification, syntactically-valid JSON (same structure, only `2>&1` replaced by `2>>/tmp/...`). Pre-apply `jq '.hooks.Stop[5]' .claude/settings.json` sanity. Restore via Edit reverse ou `git checkout --`.
- **Phase 4 commit:** revertable via `git revert`. Do not push; Lucas decides timing.
- **Zero destructive ops.** No dependency changes. No CSS. No content (slides FROZEN). Settings.json `defaultMode: auto` surfaced em HANDOFF P0 para Lucas decidir em S225 — não remover neste plano.
- **Mid-plan abort:** Phase 2 patch reversible a qualquer momento. Phases 3, 4 read-only / commit — no harm.

---

## Success definition

Plan succeeds when:
1. Evolution framework shows **≥4/5 PASS** com evidência citável.
2. Stop[5] estado final é either (a) original byte-por-byte + stderr permanent instrumentation OR (b) fix targeted ao bug revelado por stderr — **nunca ambíguo**.
3. Clean single commit with message enumerating Phases 1-3 findings.
4. HANDOFF S225 START HERE points to Track A context weight OR explicit remaining gap with reason.
5. CHANGELOG S224 entry contains: N≥3 stability evidence + stderr root cause verdict + ctx_pct S224 numbers.

---

## Scope not to expand

Lucas disse "pode ir maior" — interpretação: maior DENTRO deste problema (stability, root cause, metrics, commit). **Não** maior para Track A/B/C, não Memory /dream, não slides, não CSS. Gate para Track A está em Phase 5 opcional (research only, read-only, zero impl).

Se Lucas quiser escopo maior (Track A implementação real neste sessão) = request explicit, NEW plan.
