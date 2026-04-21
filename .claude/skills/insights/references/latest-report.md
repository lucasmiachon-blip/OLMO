# /insights S236 — 2026-04-21 (dream+insights combined run)

> Scope: S231-S235b (5 sessions, Apr 19-20) + dream consolidation signal
> Previous: S230 report (6 proposals P001-P006, pending review)
> Phases: SCAN → AUDIT → DIAGNOSE → PRESCRIBE → QUESTION → REGISTRY
> Verdict: **Security-hygiene ciclo produziu 3 novos KBPs (26/27/28) + rules anti-drift ampliadas. Enforcement reative ainda pendente. KPI collection infra DEGRADED (metrics.tsv S224-S235 backfill/ausente).**

---

## Phase 1 — SCAN

### Hook-log window 2026-04-16 → 2026-04-21 (722 entries pre-rotation)
| pattern | cat | count | sev | status |
|---------|-----|-------|-----|--------|
| brake-fired:Edit | info | 160 | info | OK (hook working) |
| brake-fired:Skill | info | 54 | info | OK |
| brake-fired:Write | info | 26 | info | OK |
| lifecycle:session-closed | info | 17 | info | OK |
| tool-error:Bash | warn | 7 | warn | KNOWN (KBP-07) — persists but contextually benign (CRLF warnings) |
| cross-ref:agent-without-handoff | warn | 7 | warn | **CANDIDATE** — no KBP match, count≥3 |
| brake-fired:Agent | info | 6 | info | OK |
| tool-error:WebFetch | warn | 5 | warn | (sub-threshold by cause — need breakdown) |
| tool-error:Read | warn | 4 | warn | Possibly KBP-23 trigger (Read without limit) |

**Rotation executed this session:** 222 oldest → `hook-log-archive/hook-log-2026-04-21.jsonl` (active = 500 newest).

### Proactive hook calibration (hook-stats.jsonl)
| hook | firings | calibration signal |
|------|---------|--------------------|
| nudge-commit | 145 | HIGH — user committed 11x S232-S235b (~13% action rate). Consider threshold raise |
| nudge-checkpoint | 80 | HIGH — unknown action rate |
| model-fallback | 45 | MODERATE — warns on potential model switch |

### Success-log highlights (successful clean commits)
- S232 v6: 8 commits clean
- S233 substrate: 1 commit clean
- S234: 2 commits clean
- S235/S235b: 4 commits clean (session field empty — telemetry bug)

### KPI metrics.tsv state (CRITICAL)
Real data rows: 7 (S217-S223). Backfill rows: 24 (S190-S216, S224-S230). **S231-S235 entirely absent.**
- Backlog_open frozen at 26, backlog_resolved frozen at 7 across 7 sessions (S217-S223) — velocity stagnant at 21%.
- Handoff_pendentes: 52→17→14→14→18→18→11 (improving trend).
- Rework_files: 5,2,3,0,1,11,1 (S222 anomaly spike).

### Transcripts / CHANGELOG signal (S226-S235b)
- 3 new KBPs added: KBP-26/27/28 (all documented in CHANGELOG narratives)
- anti-drift.md grew +72 li (First-turn, Propose-before-pour, Budget gate, Edit discipline, Adversarial review, Plan execution)
- Python runtime stack deleted S232 (ADR-0002 enforcement end-to-end)
- Content moratorium S234 → encerrado S235 (grade-v2 nova aula pivotada)

---

## Phase 2 — AUDIT (rule compliance matrix)

| rule | followed | violated | evidence |
|------|----------|----------|----------|
| anti-drift §Momentum brake | Mixed | S226 velocity mode | Aceitou +15min sem gate explícito (documented em §Budget gate) |
| anti-drift §First-turn discipline (KBP-23) | Partial | S226 Phase A | 3 Reads integrais com APL já HIGH — violação no próprio rule |
| anti-drift §Edit discipline (KBP-25) | Weak | S226 Phase A | 3 Edits falhados por whitespace; rule criada *post-hoc* |
| anti-drift §Propose-before-pour | New (S226) | — | No post-rule evidence yet |
| anti-drift §Budget gate | New (S226) | — | No post-rule evidence yet |
| anti-drift §Plan execution (TaskCreate) | THIS SESSION ✓ | S226 8 phases | Dream+insights com 9 tasks no approval; S226 8 phases sem tracking |
| anti-drift §Adversarial review (KBP-28) | New (S235b) | — | S227 era violador original; rule criada em resposta S235b |
| anti-drift §Script primacy | OK S232 | — | Scripts `.claude/scripts/{gemini,perplexity}-research.mjs` criados pela regra |
| anti-drift §State files (HANDOFF/CHANGELOG) | OK | — | S234-S235b all Edit not Write |
| anti-drift §Delegation gate (KBP-17) | OK this session | — | 0 agent spawns in dream+insights (Grep/Read direto) |

---

## Phase 3 — DIAGNOSE

| # | Finding | Category | Priority | Freq |
|---|---------|----------|----------|------|
| F1 | KPI collection infra degraded (metrics.tsv gaps S224-S235) | HOOK_GAP | high | PATTERN_REPEAT |
| F2 | Hook-log auto-rotation not automated (dream does it manually) | HOOK_GAP | medium | 1 |
| F3 | `cross-ref:agent-without-handoff` 7x warn — no KBP | SKILL_GAP / HOOK_GAP | medium | PATTERN_REPEAT |
| F4 | nudge-commit fires 145x with low action rate | SKILL_UNDERTRIGGER | low | calibration |
| F5 | `.dream-pending` flag can't be removed (rm policy deny) | HOOK_GAP | low | 1 |
| F6 | S226 rule violations added rules but enforcement mechanical ≠ landed | RULE_GAP | medium | PATTERN_REPEAT |
| F7 | Success-log session field empty for S235b commits | RULE_STALE | low | 1 |
| F8 | MEMORY.md infra counts required manual Glob audit | RULE_GAP | low | — |

---

## Phase 4 — PRESCRIBE

### [HOOK_GAP] F1 — KPI collection degraded

**Evidence:** metrics.tsv tem `-` em leading indicators S224-S230 (backfill), S231-S235 ausentes. Real data parou em S223 (2026-04-17).

**Root cause:** `stop-metrics.sh` regex corrigida S230 para `[[:space:]]|:`, mas a partir de S231 o sistema APL session-name mudou — sessões rodam sem o banner no formato esperado. Provavelmente `.claude/.session-name` está presente mas não sendo lido pelo stop-metrics.

**Proposed fix:**
- **Target:** `hooks/stop-metrics.sh`
- **Change:** Fallback via `.claude/.session-name` file + `git rev-list --count` proxy.
- **Priority:** high — "funciona sem metrica = achismo" (S214) violado pelo próprio sistema.

### [HOOK_GAP] F2 — Hook-log auto-rotation

**Evidence:** hook-log.jsonl chegou a 722 li antes de rotação manual desta sessão.

**Proposed fix:**
- **Target:** `hooks/session-start.sh`
- **Draft:**
```sh
HOOKLOG="$CLAUDE_PROJECT_DIR/.claude/hook-log.jsonl"
if [ -f "$HOOKLOG" ] && [ "$(wc -l < "$HOOKLOG")" -gt 500 ]; then
  mkdir -p "$CLAUDE_PROJECT_DIR/.claude/hook-log-archive"
  excess=$(($(wc -l < "$HOOKLOG") - 500))
  head -"$excess" "$HOOKLOG" > "$CLAUDE_PROJECT_DIR/.claude/hook-log-archive/hook-log-$(date -I).jsonl"
  tail -500 "$HOOKLOG" > "$HOOKLOG.tmp" && cat "$HOOKLOG.tmp" > "$HOOKLOG" && rm -f "$HOOKLOG.tmp"
fi
```
- **Priority:** medium.

### [CANDIDATE KBP-29] F3 — `cross-ref:agent-without-handoff`

**Evidence:** 7 warn events em 5 dias. Hook detectou ausência HANDOFF update após agent spawn.

**Proposed fix:**
- **Target:** `.claude/rules/known-bad-patterns.md`
- **Draft (append):**
```markdown
## KBP-29 Agent Spawn Without HANDOFF/Plan Persistence
→ anti-drift.md §Delegation gate
```
- **Priority:** medium — hook catches; KBP-16 pointer-only respected.

### [SKILL_UNDERTRIGGER] F4 — nudge-commit calibration

**Proposed fix:**
- **Target:** `hooks/nudge-commit.sh`
- **Change:** Raise threshold. Fire only when >=3 modified files AND >=30min uncommitted.
- **Priority:** low.

### [HOOK_GAP] F5 — `.dream-pending` removal

**Proposed fix:**
- **Target:** `.claude/settings.json` ou `~/.claude/skills/dream/should-dream.sh`
- **Change:** Mover flag para `$CLAUDE_PROJECT_DIR/.claude/.dream-pending` (scope projeto, allowed path) em vez de `~/.claude/.dream-pending`.
- **Priority:** low.

### [RULE_GAP] F6 — S226 rule mechanical enforcement

**Proposed fix:** Existing P002 from S230 covers Read-without-limit auto-warn (already in `post-tool-use-failure.sh:+6 li` S230 G.7 per CHANGELOG). Accept P002.

### [RULE_STALE] F7 — success-log session empty

**Proposed fix:**
- **Target:** Hook writing to success-log (Grep `success-log.jsonl`)
- **Priority:** low (telemetry cosmetic).

### [RULE_GAP] F8 — Memory count audit

**Proposed fix:** Dream skill Phase 1 enhancement — auto-Glob counts at ORIENT time.
- **Priority:** low — this dream caught it.

---

## Phase 4.5 — QUESTION (Double-Loop Audit)

| KBP/Rule | Verdict | Evidence | Action |
|----------|---------|----------|--------|
| KBP-01 Scope Creep | KEEP | 0 observations | No action |
| KBP-02 Context Overflow | KEEP | 1 observation S226 (rule-level fix landed) | No action |
| KBP-17 Gratuitous Agent Spawning | KEEP | This dream 0 spawns — rule working | No action |
| KBP-22 Silent Execution Chains | KEEP | Stop[0] hook enforcement S219 | No action |
| KBP-23 First-Turn Context | RECURRING | S226 violation; this session used Grep frontmatter ✓ | P002 enforcement landed S230 G.7 |
| KBP-26 permissions.ask broken | KEEP | Fundamental CC bug; deny workaround | No action |
| KBP-28 Adversarial frame-bound | KEEP (NEW) | Created S235 | No action |

Rule-referenced paths check:
- `anti-drift.md §Momentum brake` → exists ✓
- `anti-drift.md §Adversarial review` → exists ✓ (S235b)
- `anti-drift.md §Edit discipline` → exists ✓ (S226 KBP-25)
- `anti-drift.md §First-turn discipline` → exists ✓ (S225 KBP-23)
- `docs/ARCHITECTURE.md §Notion Crosstalk Pattern` → not verified this session (KBP-27 pointer)
- `docs/adr/0002-external-inbox-integration.md` → exists (KBP-24 pointer)

---

## Evolution vs Previous Report (S230)

- **S230 findings:** 6 proposals P001-P006 pending acceptance.
- **S230 → S236 delta:**
  - KBPs 21→28 (+3: KBP-26/27/28)
  - Rules 198→271 li (+72 anti-drift expansion)
  - Memory stable 19/20
  - Metrics collection DEGRADED (was "real data epoch" S217; now gap S224-S235)
  - Plans 6/36 → 2/79 (heavy archival)

- **Pattern resolved:** None of S230's P001-P006 appear implemented — 11-day gap.
- **Pattern new:** KBP-26/27/28 added organically via session narrative. Healthy sign — system learning without formal /insights gates when events demand it.

---

## Recommendations (Lucas decide)

1. **Accept or reject S230 P001-P006** (currently blocking failure-registry trend computation).
2. **Implement F1 (metrics.tsv fallback)** — high priority; principle violated by own system.
3. **Implement F2 (hook-log auto-rotation)** — 10-line change.
4. **Accept F3 as KBP-29** — mechanical codification.
5. **Defer F4/F5/F7/F8** — cosmetic/low-impact.

---

Coautoria: Lucas + Opus 4.7 | S236 dream+insights combined | 2026-04-21

---

## JSON Structured Output

```json
{
  "insights_run": "2026-04-21",
  "sessions_analyzed": 5,
  "proposals": [
    {
      "id": "P007",
      "category": "HOOK_GAP",
      "title": "metrics.tsv session detection fallback",
      "target_file": "hooks/stop-metrics.sh",
      "priority": "high",
      "frequency": 5,
      "draft": "Add fallback: if APL banner parse fails, read session name from $CLAUDE_PROJECT_DIR/.claude/.session-name and use git rev-list --count HEAD as commit proxy. Restores data collection for S231+ sessions."
    },
    {
      "id": "P008",
      "category": "HOOK_GAP",
      "title": "hook-log auto-rotation at session-start",
      "target_file": "hooks/session-start.sh",
      "priority": "medium",
      "frequency": 1,
      "draft": "HOOKLOG=\"$CLAUDE_PROJECT_DIR/.claude/hook-log.jsonl\"\nif [ -f \"$HOOKLOG\" ] && [ \"$(wc -l < \"$HOOKLOG\")\" -gt 500 ]; then\n  mkdir -p \"$CLAUDE_PROJECT_DIR/.claude/hook-log-archive\"\n  excess=$(($(wc -l < \"$HOOKLOG\") - 500))\n  head -\"$excess\" \"$HOOKLOG\" > \"$CLAUDE_PROJECT_DIR/.claude/hook-log-archive/hook-log-$(date -I).jsonl\"\n  tail -500 \"$HOOKLOG\" > \"$HOOKLOG.tmp\" && cat \"$HOOKLOG.tmp\" > \"$HOOKLOG\" && rm -f \"$HOOKLOG.tmp\"\nfi"
    },
    {
      "id": "P009",
      "category": "RULE_GAP",
      "title": "KBP-29 Agent Spawn Without HANDOFF Persistence",
      "target_file": ".claude/rules/known-bad-patterns.md",
      "priority": "medium",
      "frequency": 7,
      "draft": "## KBP-29 Agent Spawn Without HANDOFF/Plan Persistence\n→ anti-drift.md §Delegation gate\n"
    },
    {
      "id": "P010",
      "category": "SKILL_UNDERTRIGGER",
      "title": "nudge-commit threshold calibration",
      "target_file": "hooks/nudge-commit.sh",
      "priority": "low",
      "frequency": 145,
      "draft": "Gate: fire only when (modified >= 3 OR duration_since_commit >= 30min). Current 13% action rate indicates over-fire."
    },
    {
      "id": "P011",
      "category": "HOOK_GAP",
      "title": "Move .dream-pending from HOME to project scope",
      "target_file": "~/.claude/skills/dream/should-dream.sh",
      "priority": "low",
      "frequency": 1,
      "draft": "Change path from $HOME/.claude/.dream-pending to $CLAUDE_PROJECT_DIR/.claude/.dream-pending (HOME rm blocked by deny policy; project scope allowed)."
    }
  ],
  "kbps_to_add": [
    {
      "pattern": "Agent Spawn Without HANDOFF/Plan Persistence",
      "trigger": "Agent produces research/findings but HANDOFF.md or plan file not updated in same commit window",
      "fix": "anti-drift.md §Delegation gate already covers: 'Agent produces research → result written to plan file BEFORE reporting to user'. KBP-29 codifies detection for hook cross-ref:agent-without-handoff (7x warn in 5 days)."
    }
  ],
  "pending_fixes_to_add": [
    {
      "item": "stop-metrics.sh session detection fallback — restore KPI collection S231+",
      "priority": "P0",
      "target": "hooks/stop-metrics.sh"
    },
    {
      "item": "hook-log auto-rotation — prevent unbounded growth between dream runs",
      "priority": "P1",
      "target": "hooks/session-start.sh"
    },
    {
      "item": "Review and accept/reject S230 P001-P006 (blocking failure-registry trend)",
      "priority": "P1",
      "target": ".claude/insights/failure-registry.json"
    }
  ],
  "metrics": {
    "rule_violations": 4,
    "user_corrections": 0,
    "retries": 0,
    "patterns_resolved_since_last": 0,
    "patterns_new": 3
  }
}
```
