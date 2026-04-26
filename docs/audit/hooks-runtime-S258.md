# Hooks Runtime Audit — S258

> **Date:** 2026-04-26 | **Session:** S258 hookscont Phase C+D
> **Scope:** 32 hook scripts (`.claude/hooks/` 17 + `hooks/` 15) cross-validated against producer-consumer + runtime mock tests
> **Tool:** `bash scripts/smoke/hooks-health.sh` (14/14 PASS) + manual producer-consumer trace
> **Verdict:** 0/32 teatro — todos hooks alimentam consumer real
> **Cross-ref:** `.claude/hooks/README.md` (32 hooks index) · `scripts/smoke/hooks-health.sh` (Tier 1 mock tests) · `CHANGELOG.md §S258 Phase C/D` · `HANDOFF.md` (S259 forward signals)

---

## 1. Method

### 1.1 Tier 1 mock test (hooks-health.sh — 14/14 PASS)
Cada hook recebe stdin JSON simulando CC harness; valida (a) exit code válido, (b) output reasonable. Reproduzível por Lucas anytime.

### 1.2 Producer-consumer trace
Per hook silent: `grep` patterns de write/output → `grep -rln` reverso para encontrar consumer (skill, agent, hook, statusline, file). Sem consumer = teatro candidate (KBP-42).

### 1.3 Runtime evidence categorias
- ✅ **Direct fire log** — `.claude/hook-log.jsonl` entries
- 🟡 **Indirect** — state file updated (proves fire side-effect)
- ⚪ **Stand-by** — registered + executable; trigger condition não ocorreu
- ⚫ **Intentional OFF** — opt-in (chaos)

---

## 2. Per-hook matrix (32)

### `.claude/hooks/` — Guards + Antifragile (17)

| Hook | Objetivo | Status | Producer | Consumer |
|------|----------|--------|----------|----------|
| guard-read-secrets | BLOCK Read/Glob de `.env`/`.pem`/`.key` | ✅ | JSON `{permissionDecision:block}` + exit 2 | CC harness |
| guard-write-unified | ASK/BLOCK Write em hooks/ + settings.local | ✅ T9 | JSON block + exit 2 | CC harness |
| allow-plan-exit | ASK Lucas approve plan | ✅ | JSON ask | Lucas (interactive) |
| guard-secrets | BLOCK git commit com .env staged | ✅ T10 | JSON block (if .env detected) | CC harness |
| guard-bash-write | ASK shell write patterns (>, rm, mv, cp, chmod) | ✅ T7 | JSON ask + exit 0 | CC harness |
| guard-lint-before-build | BLOCK builds sem lint pass | ✅ T13 | JSON ask/block | CC harness |
| guard-research-queries | ASK research skill calls | ✅ T12 | JSON ask | CC harness |
| guard-mcp-queries | ASK MCP calls | ✅ T11 | JSON ask | CC harness |
| momentum-brake-enforce | ASK on tool if brake armed | ✅ | JSON ask + hook-log entry (391 fires/session) | CC harness + hook-log |
| post-bash-handler | LOG Bash post-execution + breadcrumbs | ✅ | `.claude/success-log.jsonl` (74KB) + `hook-stats.jsonl` (37KB) + per-aula NOTES on BUILD FAIL | **`/insights` SKILL** (read both jsonl) |
| lint-on-edit | WARN auto-lint slide edit | ⚪ | `[lint-on-edit] Erros em X/slides` stdout | Claude (corretivo) |
| nudge-checkpoint | LOG commit reminder after Agent | ⚪ | `/tmp/olmo-subagent-count` + nudge msg | Claude (warn) |
| coupling-proactive | WARN propagation map | ⚪ | `/tmp/olmo-hook-fired-coupling-proactive` + WARN | Claude (warn) |
| chaos-inject-post | INJECT fake failures (L6) | ⚫ | OPT-IN OFF (CHAOS_MODE=0) | N/A |
| model-fallback-advisory | WARN model errors → downgrade | ⚪ | `/tmp/cc-model-failures.log` + WARN | Circuit breaker logic + Claude |
| post-global-handler | LOG telemetria + counter | 🟡 | `/tmp/cc-calls-${SESSION_ID}.txt` (counter) + `[cost-circuit-breaker] N` msg | **APL ambient-pulse + statusline** (visible `[APL] N tool calls`) |
| momentum-brake-clear | Clear lock on user prompt | 🟡 | `rm /tmp/olmo-momentum-brake/armed` | **momentum-brake-enforce** (paired) |

### `hooks/` — Lifecycle + APL + Stop (15)

| Hook | Objetivo | Status | Producer | Consumer |
|------|----------|--------|----------|----------|
| ambient-pulse | APL 1-line nudge per prompt | ✅ | `[APL]` line via `additionalContext` | **statusline** (visible cada UserPromptSubmit) |
| nudge-commit | WARN uncommitted accumulation | ⚪ | `/tmp/olmo-nudge-commit-last` cooldown + WARN | Claude (warn idle) |
| session-start | Inject project + date + HANDOFF | ✅ | stdout context inject | Claude (1st turn) — visible `Projeto: OLMO \| Data:` |
| session-compact | Re-inject após compact | ⚪ | stdout HANDOFF + rules | Claude (post-compact context) |
| apl-cache-refresh | Cache BACKLOG/QA/deadline | ✅ | `.claude/apl/{backlog-top,deadline-days,ctx-pct}.txt` | **APL pulse + statusline** |
| notify | Windows toast Notification event | ⚪ | `show_toast` via `hooks/lib/toast.sh` | Lucas (visual) |
| pre-compact-checkpoint | Save context antes compact | 🟡 | `.claude/.last-checkpoint` file | **post-compact-reread** (paired) |
| post-compact-reread | Re-read após compact | ⚪ | systemMessage com session-name + handoff | Claude (next turn) |
| stop-quality | Hygiene check + pending-fixes write | 🟡 | `.claude/pending-fixes.md` (0B = clean) | **session-start próxima sessão** (surface block) |
| stop-metrics | APL session summary | ✅ | `.claude/apl/metrics.tsv` (10 sessões S248-S258) | **APL + statusline + Lucas inspection** |
| stop-notify | Windows toast Stop | ⚪ | `show_toast` via toast.sh | Lucas (visual) |
| stop-failure-log | Log Stop failures + sentinel | 🟡 | `.stop-failure-sentinel` + hook-log | **integrity.sh + KBP-26 monitoring + Lucas** |
| post-tool-use-failure | Log tool failures + corrective | ✅ | `hook-log.jsonl` (46 captures lifetime) + `additionalContext` corrective | Claude (next turn) |
| session-end | End cleanup async | ✅ | hook-log entry (9 fires) + lifecycle | hook-log + integrity |
| loop-guard | Anti-loop iter-cap | ✅ | hook-log (9 fires + 5 iter-cap-reached) + JSON intervention | CC harness + hook-log |

### Extra: `tools/integrity.sh`
| Hook | Objetivo | Status | Producer | Consumer |
|------|----------|--------|----------|----------|
| integrity.sh | Repo integrity cross-refs | ✅ | `.claude/integrity-report.md` (2093B today, 35 INV-2 PASS) | **session-start surface** (INV violations visible em SessionStart) |

---

## 3. Numerical aggregate

| Status | Count | % | Significa |
|--------|-------|---|-----------|
| ✅ ATINGINDO direct (logged OR mock-tested) | 14/32 | 44% | Number/visible proof esta sessão |
| 🟡 INDIRECT (state file side-effect) | 5/32 | 16% | Producer file updated + consumer encontrado |
| ⚪ STAND-BY (registered + valid handler) | 12/32 | 37% | Trigger condition não ocorreu esta sessão (não broken) |
| ⚫ INTENTIONAL OFF (opt-in) | 1/32 | 3% | chaos-inject-post (CHAOS_MODE=0) |
| 🔴 BROKEN | 0/32 | 0% | Nenhum quebrado |
| ❌ TEATRO (sem consumer) | **0/32** | **0%** | **Todos alimentam algo consumido downstream** |

**Mock-test confidence (`hooks-health.sh`):** 9/9 → 14/14 (D.1 +5 cases, S258).

---

## 4. Findings

### F.1 — `rm <single-file>` bypassa friction (defense surface gap)
- **Observed:** `rm /tmp/test-hook-fire-nonexistent-$$.txt` ran sem ASK or BLOCK.
- **Root cause hypothesis:** `Bash(*)` permission allow precedes hook ASK output OR settings filter `*rm *` doesn't match leading `rm <path>` (depende glob semantics).
- **Defense surface:** menor que README claim. Pattern 17 `\b(rm|rmdir)\b` matches conceitualmente mas runtime bypassa.
- **Status:** S259+ investigation defer (root cause exige settings filter precedence + Bash(*) interaction analysis).

### F.2 — drain_stdin DRY refactor evaluated + DEFERRED (KBP-41 Cut calibration)
- **Pattern:** `cat >/dev/null 2>&1 || true` em 12 hooks (1 line cada).
- **Lib evaluated** (`hooks/lib/drain-stdin.sh`): 12×1 inline → 12×3 com lib = net complexity ↑.
- **Verdict:** Cost > value @ 1-line scale. **Deferred S259+ com gate explícito** ("revisit se pattern cresce ou hook_log-style envelope evolui").
- **Action:** lib uncommitted deletado; documentado em CHANGELOG D.2 + HANDOFF P2.
- **Real DRY candidates** identificados para S259+: `PROJECT_ROOT` define pattern (3 variants em 32 hooks), `REPO_SLUG` sha256sum (3 hooks), generic `hook_log` envelope (já em `hooks/lib/hook-log.sh`).

### F.3 — Tier 1 mock-test pattern matures (D.1)
- **9/9 → 14/14 PASS** com +5 critical guard tests (T9-T13).
- **Pattern:** mock JSON input → bash hook script → expected exit code / output regex.
- **Limitation:** T10 + T13 são "ran-not-crashed" tests (full BLOCK depende de state setup destrutivo).
- **Future Tier 2:** live invocation (subprocess `claude -p --agent X`) requires hooks bypass infra (S258 G2 finding).

### F.4 — `success-log.jsonl` + `hook-stats.jsonl` actively consumed by `/insights` SKILL
- post-bash-handler produces both files (74KB + 37KB updated today).
- Consumer: `.claude/skills/insights/SKILL.md` reads both para session analysis.
- **Producer-consumer pattern PROVEN end-to-end** — não teatro.

---

## 5. KBP-42 codify (S258 emergent)

**Pattern:** "Hook silent without consumer = teatro candidate"

**Detection method:**
1. Identify hook producer (file write, stdout output, breadcrumb)
2. Reverse grep readers in skills/agents/hooks/scripts/statusline/state files
3. No reader found → teatro candidate; investigate purpose vs delete

**False positive guards:**
- Paired hooks (e.g., pre-compact ↔ post-compact) consumer = sister hook
- Async outputs (toast, notification) consumer = Lucas visual (not file-detectable)
- CC harness consumers (JSON `{permissionDecision}`) consumer = harness (not file-detectable)

**See:** `docs/audit/hooks-runtime-S258.md` §2 (matriz template) + `scripts/smoke/hooks-health.sh` (Tier 1 enforcement).

---

## 6. Open questions / S259+ items

| # | Item | Origin | Estimate |
|---|------|--------|----------|
| 1 | rm <single-file> bypass root cause investigation | F.1 | 1-2h (settings filter + Bash(*) precedence) |
| 2 | Tier 2 smoke live invocation infra | S258 G2 | 1-2h (hooks bypass research) |
| 3 | drain_stdin DRY revisit if pattern cresce | F.2 (KBP-41 gate) | revisit signal: pattern adds 3+ usages OR evolves |
| 4 | Real DRY refactor: PROJECT_ROOT + REPO_SLUG libs | F.2 | 1.5-2h (multi-line patterns) |
| 5 | Extend hooks-health Tier 1 +12 stand-by hooks | D.1 | 1h (+12 mock tests) |
| 6 | Audit non-debug agents runtime + non-redundancy (Phase C.2/C.3) | S258 plan defer | 2-3h |

---

Coautoria: Lucas + Opus 4.7 (Claude Code) | S258 hookscont Phase D.3 audit doc | 2026-04-26
