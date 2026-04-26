# Plan S255 Phase 3 + S256 — Resolver hooks teatro sem deixar backlog

> **Status:** PROPOSTA pendente Lucas approval via ExitPlanMode
> **Origem:** S255 Phase 2 audit 5 voices (Opus×3 + Gemini + Codex) com convergence §6.1 strict
> **Mandato Lucas:** "vamos resolver (ou tentar resolver o problema sem deixar backlog)"
> **Coautoria:** Lucas + Opus 4.7 (Claude Code) | S255 debug-team-hooks Phase 3 | 2026-04-26

---

## 1. Context

S255 Phase 1 fixou 4 hook teatros mecânicos (A1+A2+A3+A6 commits `20e1e9a` → `9d91c8b`). Phase 2 lançou council pattern §6 — 5 voices independent (Gemini historical + 3 Opus uniformes + Codex adversarial cross-architecture) auditando 35 hooks contra 7 dimensões (adversarial · redundante · não funcionam · merge · sem stats · subutilizados · disparo silencioso).

Resultado Phase 2: **6 ADOPT-tier findings + 5 NOTE Codex-unique findings + 4 false positives filtrados via KBP-32 spot-check + 7 DEFER items**. Detalhes synthesis em chat S255 Phase 2 + presente plan abaixo.

**Phase 3 objetivo (este plan):** executar TUDO sem deixar backlog. Realista em 2 sessões disciplined (S255 close + S256 dedicated) — aprox. 7h trabalho total. Honra mandato "no backlog" cross-session.

**Honest scope assessment (sem sycophancy):**
- Block A mecânico (S255 close): ~2h, 7-8 commits
- Block B decisão+exec (S255 close): ~30min decisões + ~1h exec, 4 commits
- Block C BACKLOG #63 systematic (S256): ~1.5-2h, 3-5 commits
- Block D smoke tests T4 (S256): ~1.5-2.5h, 7 commits
- **Total: ~6-8h** distribuído em 2 sessões = realista, sem perpetuar defer

---

## 2. §6.1 Convergence recalibration honesta (5 voices)

Original §6.1 era 3/3 voices = ADOPT-NOW. Com 5 voices, threshold strict honesto:

| Threshold | Verdict | Items |
|-----------|---------|-------|
| 4+/5 high | **ADOPT-NOW STRICT** | A2 chaos no-op (4/5), A3 integrity silent (4/5) |
| 3/5 high | **ADOPT-NEXT** (Lucas spot-check) | A1 dream-pending, A4 banner envelope, A5 Stop[1] redundancy, A6 notify+stop-notify |
| 1-2/5 + Codex cross-arch high | **ADOPT-NEXT Codex-unique** | B1 secret bypass, B2 hook-log JSON, B3 guard-bash dead branches, B4 pre-compact timing, B5 fallback |
| 2/5 OR low cost-benefit | **DEFER conscious** | stop-metrics async, 5 guards no hook_log, parse_handoff DRY (single voice 1/5) |
| FP filtrado | **REJECTED** | 4 claims (integrity not found, ambient-pulse alignment, Stop[1] staged FN, S254 counter variance) |

---

## 3. BLOCK A — S255 Mecânico (no decisions, low blast, ~2h, 8 commits)

Sequenciado por blast crescente. Cada commit isolado.

### A.1 Doc drift fixes (10min, 1 commit)
**Files:** `.claude/hooks/README.md`, `.claude/hooks/chaos-inject-post.sh:7`
- README.md: 33→35 hook count + add StopFailure to "Events Covered" (atual lista 10, real 11)
- chaos-inject-post.sh:7 comment: "settings.local.json" → "settings.json" (current reality)
- Zero behavioral change. Pure doc accuracy.

### A.2 parse_handoff_pendentes lib extract (25min, 1 commit)
**Files NEW:** `hooks/lib/handoff-utils.sh`
**Files modify:** `hooks/stop-metrics.sh:26-33`, `hooks/apl-cache-refresh.sh:51-58`
- Função copy-pasted IDÊNTICA em 2 hooks (8 li each).
- Extract pra lib + source em ambos. Pattern canonical já estabelecido (hook-log.sh, banner.sh).
- KBP-19 deploy: Write `.claude-tmp/handoff-utils.sh.new` → cp pattern.

### A.3 A6 notify + stop-notify lib extract (20min, 1 commit)
**Files NEW:** `hooks/lib/toast.sh` com `show_toast(title, text, duration_ms)`
**Files modify:** `hooks/notify.sh:7-19`, `hooks/stop-notify.sh:10-21`
- PowerShell NotifyIcon block byte-near-identical (só BalloonTipText difere).
- Lib `show_toast(title, text, ms)` aceita params. Callers viram 1-line wrappers.
- Future-proof: se Windows toast quebrar, fix em 1 lugar.

### A.4 A4 banner envelope log (15min, 1 commit)
**Files modify:** `hooks/session-start.sh:98`
- Atual: `if . "$PROJECT_ROOT/hooks/lib/banner.sh" 2>/dev/null; then` — `2>/dev/null` absorve QUALQUER erro silencioso.
- Fix: capturar stderr em var, source banner.sh, se stderr não-vazio → `hook_log` com severity warn.
- A6 Phase 1 fix idempotent guard resolveu readonly recursion; este fix resolve envelope blindspot remaining.

### A.5 A3 integrity.sh surface in session-start (15min, 1 commit)
**Files modify:** `hooks/session-start.sh` (após pending-fixes block linha ~80)
- integrity-report.md escrito por tools/integrity.sh Stop[5] async + `>/dev/null` redirect = invisível.
- Add session-start surface: `if [ -f .claude/integrity-report.md ] && grep -q '\[FAIL\]' .claude/integrity-report.md; then echo "=== INTEGRITY VIOLATIONS ==="; grep '\[FAIL\]' .claude/integrity-report.md | head -10; fi`
- Pattern análogo a pending-fixes surfacing já em session-start.sh:74-84.

### A.6 B5 post-global-handler fallback fix (10min, 1 commit)
**Files modify:** `.claude/hooks/post-global-handler.sh:21` (fallback line)
- Atual: `SESSION_ID=$(cat ... || date '+%Y%m%d_%H%M%S')` — fallback gera format orphan que volta a quebrar consumers.
- Fix: `SESSION_ID=$(cat ... || echo "unknown_${REPO_SLUG}_$(date '+%Y%m%d_%H%M%S')")` — fallback file recognizable como anomaly via prefix `unknown_`.
- Bonus: TTL one-liner em session-start.sh: `find /tmp -maxdepth 1 -name 'cc-calls-unknown_*.txt' -mtime +1 -delete 2>/dev/null || true`

### A.7 B4 pre-compact-checkpoint timing fix (15min, 1 commit)
**Files modify:** `hooks/pre-compact-checkpoint.sh:15-61`
- Atual: `> $CHECKPOINT` (truncate) inside block que depois usa `find -newer $CHECKPOINT` → checkpoint mtime IS reference → "Recent Plan Files" sempre vazio.
- Fix: capturar `OLD_MTIME=$(stat -c %Y "$CHECKPOINT" 2>/dev/null || echo 0)` ANTES do truncate, usar como `find -newermt @$OLD_MTIME` reference.

### A.8 B2 hook-log.sh JSON escape via jq (25min, 1 commit)
**Files modify:** `hooks/lib/hook-log.sh:17-22`, `hooks/post-tool-use-failure.sh:28-30,36-40`
- Atual: `printf '{"ts":"%s","event":"%s",..."detail":"%s"}\n' ...` — interpolação raw, ERROR_MSG com quotes/newlines corrompe JSONL.
- Fix: replace por `jq -cn --arg ts "$ts" --arg event "$event" ... '{ts:$ts,event:$event,...}'`
- Validation: post-fix, write entry com `"foo \"bar\"\n` em detail, parse via `jq` confirma valid.

**Block A total:** 8 commits, ~2h, zero decisions, low blast. Verification: bash -n + manual trigger + observe.

---

## 4. BLOCK B — S255 Decision-required (4 Lucas decisions upfront, ~1h exec)

**Approach:** Apresentar 4 decisões via AskUserQuestion **batch** ANTES de qualquer Edit. Lucas picks once, eu executo decided items sequencialmente.

### D1 — A2 chaos (decision required)

**Question:** O sistema chaos antifragile L6 está in-place mas CHAOS_MODE never set → 100% no-op. Como resolver?

- **(a)** Set `CHAOS_MODE=1` em settings.json env (sempre on em produção) — antifragile L6 ativo + adds noise via fake failures
- **(b)** Document como opt-in manual via `CHAOS_MODE=1 claude code ...` em README + comment em chaos-inject-post.sh — preserves capability, zero overhead default
- **(c)** Remove hooks chaos-inject-post + lib + chaos report block em stop-metrics + revert L6 claim em Conductor §4.9 — admit deprecation honestamente

### D2 — A5 Stop[1] inline agent (decision required)

**Question:** Stop[1] inline agent verifica HANDOFF/CHANGELOG hygiene via Sonnet model invocation; stop-quality.sh:82-100 já verifica MESMO via bash. Custo ~$0.003-0.01/sessão sem added safety. Como resolver?

- **(a)** Remove Stop[1] inteiro (rely stop-quality.sh) — economia + simplicidade
- **(b)** Keep Stop[1] mas restrict prompt a checks stop-quality.sh NÃO PODE (ex: parse semântico)
- **(c)** Keep status quo (accept cost para defense-in-depth)

### D3 — B1 secret protection Grep/Glob bypass (decision required)

**Question:** guard-read-secrets.sh só matcher `Read`. Permissions allow `Glob` + `Grep`. Agent pode `Glob '**/.env'` ou `Grep "AWS_KEY" *.env*` para vazar secrets sem trigger. Como resolver?

- **(a)** Add PreToolUse matchers Grep + Glob ao guard-read-secrets.sh com mesma path basename rules
- **(b)** Add `permissions.deny` patterns para credential paths (`Glob(**/.env)`, `Grep(*key*)`, etc) — defense layer different
- **(c)** Both (defense-in-depth — recomendo)

### D4 — B3 guard-bash-write settings if vs internal detectors (decision required)

**Question:** settings.json:226 `if Bash(*>*|*>>*|*rm *|*mv *|*cp *|*chmod*|*kill*)` filtra; script tem detectors UNREACHABLE (sed -i, tee, curl, python, touch, mkdir, ln, patch, tar/unzip, awk system, find -exec, xargs, make). Como resolver?

- **(a)** Broaden settings if matcher para cobrir all internal detectors (~30 padrões) — perf cost mas defense ativa
- **(b)** Remove settings if filter, let script self-filter (perde quick-skip em commands óbvios safe)
- **(c)** Keep current + remove dead detectors do script (admit que defesa é só os 7 padrões settings)

**Após Lucas pick D1-D4 → exec:**

- B.1 D1 chaos action — 5min remove OR 10min document OR 15min activate (depends choice)
- B.2 D2 Stop[1] action — 10min (a) OR 15min (b)
- B.3 D3 secret protection — 15min (a) OR 20min (b) OR 30min (c)
- B.4 D4 guard-bash-write — 10min (c) OR 25min (a) OR 15min (b)

**Block B total:** 4 commits, ~30min decisões + 30-90min exec depending Lucas picks.

---

## 5. BLOCK C — S256 BACKLOG #63 systematic-debug dream-pending (~1.5-2h, 3-5 commits)

A1 dream-pending broken end-to-end requer BACKLOG #63 done first. Steps a-e do BACKLOG:

### Step a — Audit /insights skill (.claude/skills/insights/SKILL.md)
- Identificar quando `.last-insights` é escrito (write-on-open vs write-on-close)
- Trace lifecycle: when does file get updated? Onde está bug que causa "recurring false positive"?

### Step b — Audit /dream skill (.claude/skills/dream/SKILL.md)
- Identificar quando `~/.claude/.dream-pending` é deletado
- Trace: session-end.sh:34 cria, /dream skill deleta? Quando?

### Step c — Identify lifecycle bug
- Hipótese mais provável: `.last-insights` write-on-OPEN (em vez de close) → file always reflects current run start, never run completion → reminder threshold sempre passa false → recurring FP
- Confirmar via Read + git log -S "last-insights"

### Step d — Fix lifecycle (em SKILL.md ou novo hook PostSkillUse equiv)
- Move write para skill end (Stop hook? PostSkillUse hook se existe? OR session-end.sh enrichment)
- Test: invocar /insights, verificar `.last-insights` updated DEPOIS skill completou

### Step e — Re-enable session-start.sh blocks
- Toggle `if false` → `if true` para AMBOS blocks (linhas ~86-95 dream, ~107-118 insights)
- Test session start: dream-pending surface visible, /insights reminder visible quando GAP_DAYS ≥ 2

### Step f — Verification
- Trigger /dream end-to-end: `~/.claude/.dream-pending` cleared
- Trigger /insights end-to-end: `.last-insights` updated, banner not duplicate-firing
- Run 3 fake sessions, observe banners fire correto (não FP, não silent)

**Block C total:** 3-5 commits, 1.5-2h. Re-enables 2 CLAUDE.md contractual features.

---

## 6. BLOCK D — S256 Smoke tests debug-team T4 fix (~1.5-2.5h, 7 commits)

Cada agent .md tem secao `## VERIFY` com spec do que smoke test deve validar. Atual: TODOS 7 ausentes (`scripts/smoke/debug-*.sh` Glob "no files").

### D.1 scripts/smoke/debug-symptom-collector.sh (~15min)
**Spec from agent .md:** "validates JSON output schema canonical, complexity_score field present, gaps field non-null when input incomplete"
- Test: pipe synthetic symptom, verify JSON valid, complexity_score in 0-100, schema_version "1.0"

### D.2 scripts/smoke/debug-strategist.sh (~20min)
**Spec:** "validates first-principles JSON output (no git history calls, no adversarial reframing, no patch suggestions), confidence_overall present, ≥1 hypothesis with what_would_disprove field, architectural_lens_view inclui design_flaw|bug claim + boundary + alternative_design"
- Test: pipe canonical collector JSON, verify output absent of git/adversarial/patch keywords + required fields

### D.3 scripts/smoke/debug-archaeologist.sh (~20min)
**Spec:** "Gemini CLI preflight executed (fail-closed em ausência), JSON output schema canonical, SHAs Gemini-returned spot-checked via `git log <sha>` local (KBP-32), gaps field non-null quando validation incomplete"
- Test: stub gemini call, verify SHAs in output exist via `git log`

### D.4 scripts/smoke/debug-adversarial.sh (~20min)
**Spec:** "Codex CLI preflight executed (fail-closed em ausência), challenges target real collector assumptions (não inventar — KBP-32), KBP-28 frame-bound checklist applied if security-related, failure_mode_categories_unexamined field present"
- Test: stub codex call, verify challenges reference assumptions present in input collector

### D.5 scripts/smoke/debug-architect.sh (~20min)
**Spec:** "agent receives multi-voice JSON inputs (collector + strategist + ±archaeologist + ±adversarial), produces markdown TEXT plan (not JSON tool calls — D7 critical), READ-ONLY enforcement (zero Edit/Write/Bash mutations attempted), KBP-32 path spot-check before Proposed Changes"
- Test: pipe synthetic voices, verify markdown output (not JSON), verify no Edit/Write attempted

### D.6 scripts/smoke/debug-patch-editor.sh (~20min)
**Spec:** "edits APENAS files listados em architect plan (KBP-01 anti-scope-creep), KBP-19 protected files via Write→temp→cp pattern, edit-log honest (errors registered + matches_architect_intent), zero-edit valid output quando architect prescribed upstream-only ou KBP-35"
- Test: pipe synthetic architect plan with zero-edit + with valid edits, verify behavior matches

### D.7 scripts/smoke/debug-validator.sh (~20min)
**Spec:** "READ-ONLY Bash only (test/lint/git status — zero mutations), verdict field ∈ {pass, partial, fail}, loop_back_input_to_architect non-null when verdict=fail, zero-edit case handled (verdict=pass when architect prescribed zero AND editor honored AND git status clean)"
- Test: pipe synthetic edit-log + collector reproduction, verify verdicts

### Common smoke test patterns:
- Bash script wrapping `claude agents call <agent> < input.json > output.json`
- Verify exit code, JSON validity, required fields via `jq -e`
- Optional: time budget check (each agent should respond in <60s for trivial input)

**Block D total:** 7 commits, ~1.5-2.5h. Converts T4 teatro (VERIFY claim performativo) → T4 ATIVO (validation reproducible).

---

## 7. Critical files map

### Files modified Block A (S255 close):
- `.claude/hooks/README.md` (A.1 doc)
- `.claude/hooks/chaos-inject-post.sh` (A.1 doc)
- `hooks/lib/handoff-utils.sh` NEW (A.2)
- `hooks/stop-metrics.sh` (A.2 + A.6 if applicable)
- `hooks/apl-cache-refresh.sh` (A.2)
- `hooks/lib/toast.sh` NEW (A.3)
- `hooks/notify.sh` (A.3)
- `hooks/stop-notify.sh` (A.3)
- `hooks/session-start.sh` (A.4 + A.5 + A.6 TTL bonus)
- `.claude/hooks/post-global-handler.sh` (A.6)
- `hooks/pre-compact-checkpoint.sh` (A.7)
- `hooks/lib/hook-log.sh` (A.8)
- `hooks/post-tool-use-failure.sh` (A.8)

### Files modified Block B (S255 close, depends Lucas decisions):
- `.claude/settings.json` (D1, D2, D3, D4 maybe)
- `.claude/hooks/chaos-inject-post.sh` + `.claude/hooks/lib/chaos-inject.sh` + maybe Conductor §4.9 (D1)
- `.claude/hooks/guard-read-secrets.sh` + maybe permissions deny (D3)
- `.claude/hooks/guard-bash-write.sh` (D4)

### Files modified Block C (S256):
- `.claude/skills/insights/SKILL.md` (audit + fix lifecycle)
- `.claude/skills/dream/SKILL.md` (audit + fix lifecycle)
- `hooks/session-start.sh` (re-enable 2 blocks)
- `hooks/session-end.sh` (maybe lifecycle improvements)
- `.claude/BACKLOG.md` (mark #63 RESOLVED)

### Files modified Block D (S256):
- `scripts/smoke/debug-symptom-collector.sh` NEW
- `scripts/smoke/debug-strategist.sh` NEW
- `scripts/smoke/debug-archaeologist.sh` NEW
- `scripts/smoke/debug-adversarial.sh` NEW
- `scripts/smoke/debug-architect.sh` NEW
- `scripts/smoke/debug-patch-editor.sh` NEW
- `scripts/smoke/debug-validator.sh` NEW

---

## 8. Existing patterns to reuse

| Pattern | Source | Usage in plan |
|---------|--------|---------------|
| `cat >/dev/null 2>&1 \|\| true` (drain stdin) | `hooks/stop-metrics.sh:14` | já 7+ hooks (S255 Phase 1 A1) |
| `hook_log <event> <hook> <category> <pattern> <severity> <detail>` | `hooks/lib/hook-log.sh:9` | A.8 refactor + A.4 envelope log + Block B audits |
| `[[ -n "${_LIB_LOADED:-}" ]] && return 0` (idempotent include) | `hooks/lib/banner.sh:10` (S255 Phase 1 A6) | A.2 + A.3 new libs precisam |
| `jq -cn --arg key "$val" '{key:$key}'` (safe JSON) | `hooks/post-compact-reread.sh:17` | A.8 refactor |
| `REPO_SLUG=$(printf '%s' "$DIR" \| sha256sum \| cut -c1-8)` | `hooks/session-start.sh:17-19`, `hooks/stop-metrics.sh:21-23` | A.6 já reusado em post-global-handler S255 Phase 1 A2 (DRY candidate future) |
| Write→`.claude-tmp/X.new`→cp (KBP-19 protected files) | `.claude/rules/known-bad-patterns.md` KBP-19 | A.2, A.3, A.4, A.5, A.6, A.7, A.8 (todos hooks/) |
| Surface block pattern (read file + cat if non-empty) | `hooks/session-start.sh:74-84` (pending-fixes) | A.5 integrity surface |
| Drain stderr capture: `STDERR=$(. file 2>&1 >/dev/null)` | bash idiom | A.4 banner envelope |
| `git rev-list --count origin/main..HEAD` (KBP-40 branch awareness) | S255 Phase 1 lesson | Pre-push verification gate |

---

## 9. Verification approach

### Per fix (Block A + B):
1. `bash -n <hook>` — syntax check
2. Manual trigger via stdin pipe + observe stdout/stderr/exit code
3. Verify intended side-effect (file written, log appended, etc)
4. Verify NO unintended side-effect (git status check)

### Block C (BACKLOG #63):
1. Trigger /dream skill end-to-end (real invocation)
2. Verify `~/.claude/.dream-pending` cleared post-completion
3. Trigger /insights skill end-to-end
4. Verify `.last-insights` updated DEPOIS completion (não open)
5. Restart session 3x, observe banners fire correto (não FP, não silent)
6. Re-enable session-start.sh blocks, observe surface

### Block D (smoke tests):
1. `bash scripts/smoke/debug-<agent>.sh` — verify exit 0
2. JSON output valid via `jq -e`
3. Required fields present per agent .md VERIFY spec
4. Time budget: each completes in <60s for trivial input

### End-to-end Phase 3 verification:
1. **Re-run audit Explore agent post-fixes** — expect findings count drop from current 11 ADOPT-tier to 0-2 (only DEFER conscious items remain)
2. **APL CALLS counter continua working** — already validated S255 Phase 1 (A2 fix)
3. **`/tmp` cleanliness:** counter files <10 (TTL working from A.6 bonus)
4. **No SessionStart errors** — already validated (A1 fix)
5. **CHANGELOG accuracy:** Block A + B + C + D commits documented com LOC delta + Aprendizados

---

## 10. Sequence proposta (Lucas approval gate per Block)

### S255 close (this session, ~3h budget remaining):

1. **Lucas approves Block A** → execute A.1 → A.8 sequencial (1 commit per fix, ~2h)
2. **Lucas decides D1-D4** via AskUserQuestion batch (~30min decisões)
3. **Lucas approves Block B execution** → execute B.1 → B.4 (~30-90min depending picks)
4. **S255 docs close:** HANDOFF + CHANGELOG update + commit + push
5. **S255 final commit:** `chore(S255): Phase 3 close — 12+ fixes shipped, BACKLOG #63 + smoke tests → S256`

### S256 dedicated (next session, ~4h):

6. **Block C BACKLOG #63 systematic-debug** (1.5-2h, 3-5 commits)
7. **Block D smoke tests T4** (1.5-2.5h, 7 commits)
8. **S256 docs close:** HANDOFF + CHANGELOG + push
9. **S256 final commit:** `chore(S256): Phase 3 complete — debug-team smoke tests + BACKLOG #63 RESOLVED — zero teatro residual`

### Post-S256 state esperado:

- Hooks teatro: 0 ADOPT-tier remaining (apenas DEFER conscious items: stop-metrics async, 5 guards observability gap)
- Smoke tests debug-team: 7/7 ATIVO
- BACKLOG #63 RESOLVED
- CLAUDE.md contracts (dream + insights) honored
- Push state: all S255 + S256 commits in origin/main
- HANDOFF: pure forward signal sem hooks-teatro residual

---

## 11. KBP candidates emergentes (codify se padrão repete)

- **"Files written but never read" invariant** (S255 Phase 1 + A.5 integrity gap): producer-without-consumer = teatro detectable apenas via forensic. Antidoto: stop-quality.sh ou sentinel pre-commit invariant. Codify como KBP se padrão se repetir em outras audits.
- **"Async Stop hooks output não injetam conversation"** (Phase 2 Voice 1 finding): async + Stop = stdout swallow. Documentar em cc-gotchas.md se confirmado via spot-check direto.
- **"Settings if matcher vs script internal detectors"** (Codex B3 finding): pattern arquitetural com tradeoffs documentar como ADR ou cc-gotchas se repetir em outros guards.
- **"Test setup deletes state files"** (S255 self-inflicted: A1 test deleted .session-name): hooks com side-effects destrutivos requerem cleanup-pre-test fixture. Documentar.

---

## 12. Out of scope (explicit)

- **H4/X2/X3 redundâncias** (Conductor §6.2-6.3): destrutivos requer Lucas explicit OK por commit; defer pra session dedicated post-Phase 3.
- **Lib refactor consolidado** (drain_stdin + REPO_SLUG calc): emergentes Phase 1+2; defer S256+ session dedicated lib audit.
- **Rest of Conductor §4 arms** (12 braços auditing): Phase 3 só DEBUG arm. Other arms (MEMORY, KNOWLEDGE, RESEARCH, BACKEND, FRONTEND, CONTENT, PRODUCTIVITY, SELF_EVOLVING, TOOLING, ORQUESTRACAO, CUSTOM) require own audit cycles.
- **Push automation:** Lucas explicit OK per push event (não autonomous pushing).
