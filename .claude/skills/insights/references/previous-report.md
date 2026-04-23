# [archived — see latest-report.md for S240] /insights S230 — 2026-04-19 (Phase G.1)

> Scope: S220-S230 (11 days, ~163 substantive sessions, 24 commits S227-S230 analyzed in detail)
> Phases: SCAN → AUDIT → DIAGNOSE → PRESCRIBE → QUESTION
> Verdict: **STABLE com regressão localizada em KBP-23 (Read sem limit)**
> Trigger: Phase G of bubbly-forging-cat — pre-decision evidence for momentum-brake fate

---

## Phase 1 — SCAN

### Signal sources

| Source | Count | Notes |
|---|---|---|
| Sessions analyzed | 163 substantive (>50KB) in 11d | Last full /insights: Apr 8 (S193) |
| Success-log entries | 226 total; 24 in S227-S230 | Clean commits per session: S227=4, S228=5, S229=9, S230=6 |
| Hook-stats firings | 247 total | nudge-commit 131x, nudge-checkpoint 79x, model-fallback 37x |
| Hook-log warnings | 80 PostToolUseFailures | 47 Bash, 27 Read, 4 WebFetch, 1 TestTool |
| Tool errors S230 | 6 in current session | git add gitignored, rm Directory not empty, git add deleted file, etc |

### Key patterns

- **5 sessões consecutivas de meta-trabalho** (S226 purga → S227 docs → S228 audit → S229 slim → S230 audit). Zero sessões de slide work em 11 dias. R3 a 225 dias.
- **Phase F+G de S230 são user-driven extensions** (Lucas pediu explicit), NÃO scope drift do agente.
- **27 Read errors** (~2.5/day) — KBP-23 First-Turn Context Explosion existe mas é violado regularmente. Mais comum: Read sem limit em arquivo >25k tokens.
- **47 Bash errors** — predominantemente cleanup pós-delete (git rm + rm pasta vazia) e git operations em gitignored files.

### Hook calibration

- `nudge-commit` 131 firings/11d ≈ 12/day. Frequency consistent com batched session pattern. **OK**.
- `nudge-checkpoint` 79 firings/11d ≈ 7/day. **OK**.
- `model-fallback` 37 firings/11d. L2 antifragile fallback working. Verify rate vs. actual model unavailability separately.

---

## Phase 2 — AUDIT

| Rule | Status | Evidence |
|---|---|---|
| anti-drift §Momentum brake (KBP-01) | **FOLLOWED** S227-S230 | Zero scope drift events em 24 commits analisados |
| anti-drift §First-turn discipline (KBP-23) | **VIOLATED** ~27x em 11d | hook-log 27 Read pattern errors (file >25k tokens) |
| anti-drift §EC loop (KBP-22) | **PARTIAL** | EC pre-action visível em S230 phases; falha em outros plays |
| anti-drift §Edit discipline (KBP-25) | **FOLLOWED** | Pre-Edit Read full em S230; zero whitespace mismatches |
| anti-drift §State files | **FOLLOWED** | HANDOFF + CHANGELOG via Edit (não Write); preservation OK |
| anti-drift §Plan execution (≥4 phases = TaskCreate batch) | **FOLLOWED** S230 | 5+1 tasks created upfront, marked in_progress/completed in real time |
| anti-drift §Failure response (KBP-07) | **FOLLOWED** | S230 Bash blocked → asked Lucas (rmdir, python -c, pytest, rm -rf) |
| anti-drift §Verification (KBP-13) | **FOLLOWED** | pytest + ruff + sanity check entre cada commit S230 |
| anti-drift §Delegation gate (KBP-17) | **FOLLOWED** | S230 zero gratuitous Agent spawns — direct Read/Grep |
| qa-pipeline.md (S230 absorbed) | **NEW canonical** | metanalise §QA → qa-pipeline.md; zero data loss verified |
| KBP-26 (CC permissions.ask broken) | **CONFIRMED in S230** | 4 popups bloqueados (rmdir, python -c, pytest, rm -rf) — pattern reaffirmed |
| KBP-27 (Crosstalk pattern) | **APPLIED S229+** | Notion via Claude Code + MCP direct funcionando |

---

## Phase 3 — DIAGNOSE

| Finding | Category | Frequency | Priority |
|---|---|---|---|
| Read sem `limit` em arquivos >25k tokens | RULE_VIOLATION (KBP-23 recurrence) | 27/11d | **HIGH** |
| Cleanup pós git rm não automático (pasta vazia + __pycache__) | RULE_GAP | 1/S230 | MEDIUM |
| Momentum brake teatro (Bash blanket exempt) | PATTERN_REPEAT (zero firings real) | 0/11d | **HIGH** (delete candidate) |
| KPI Reflection Loop (200-call interval) | PATTERN_REPEAT (zero firings) | 0/11d | **HIGH** (delete candidate) |
| Cost BLOCK threshold (400 calls) | PATTERN_REPEAT (zero firings) | 0/11d | **HIGH** (delete candidate) |
| metrics.tsv stale (regex bug) | RULE_VIOLATION (data hygiene) | 7 sessões missing | MEDIUM (Phase G.2 fix) |
| 5 sessões consecutivas meta-work | PATTERN_REPEAT (avoidance) | 5/5 | **HIGH** (R3 prep blocked) |
| /insights ritual broken | SKILL_UNDERTRIGGER | 1 run / 30+ sessões | MEDIUM (Phase G.5 fix) |

---

## Phase 4 — PRESCRIBE

### [PATTERN_REPEAT] Momentum brake é teatro confirmed

**Evidence:** 24 commits S227-S230 analisados — **zero scope drift events agente-driven**. Phase F+G de S230 são user-driven (Lucas pediu explicit). Bash blanket exempt em `momentum-brake-enforce.sh:46` faz brake nunca disparar para escritas via bash. KBP-01 status: **FOLLOWED**.

**Root cause:** brake desenhado para era pré-S229 (ecosystem mais ativo, mais Edit/Write per session). Slim atual = Bash-dominado = exempt → zero firings.

**Proposed fix:**
- **Target:** `.claude/hooks/momentum-brake-{clear,enforce}.sh` + `.claude/hooks/post-global-handler.sh:42-43` + `.claude/settings.json` registrations
- **Change:** **DELETE** brake infrastructure inteira
- **Justification:** Phase D pattern (ModelRouter teatro) aplicável — código que não é consumed = honest delete > pretend it works

### [RULE_VIOLATION] KBP-23 violations recorrentes (27/11d)

**Evidence:** hook-log 27 Read pattern errors `File content (N tokens) exceeds maximum allowed tokens (25000)`. Padrão: agente faz Read sem `limit` em arquivos médios-grandes; CC tool retorna error; agente retry com `offset/limit`.

**Root cause:** KBP-23 pointer existe em `anti-drift.md §First-turn discipline` mas é qualitativa ("APL=HIGH strict"). Não há enforcement automático.

**Proposed fix:**
- **Target:** `hooks/post-tool-use-failure.sh` (já existe, captura PostToolUseFailure)
- **Change:** quando pattern=Read AND error contains "exceeds maximum allowed tokens", inject systemMessage: "[KBP-23] Read sem limit em arquivo grande — sempre passe `limit:50` primeiro, depois Grep targeted."
- **Draft:** linha após `category:tool-error` no `post-tool-use-failure.sh`:
```bash
if [[ "$PATTERN" == "Read" ]] && [[ "$DETAIL" =~ "exceeds maximum allowed tokens" ]]; then
  inject_message "[KBP-23] Read sem limit. Use 'limit: 50' primeiro, depois Grep targeted."
fi
```

### [PATTERN_REPEAT] 5 sessões consecutivas meta-work — R3 prep avoidance

**Evidence:** S226 purga → S227 docs → S228 audit → S229 slim → S230 audit. Zero commits em `content/aulas/` em 11 dias. R3 Clinica Medica está a 225 dias.

**Root cause:** infraestrutura confortável; produto difícil. Sistema sem signal explícito de "tempo até R3 vs trabalho de produto".

**Proposed fix:**
- **Target:** `hooks/session-start.sh` (já tem APL `R3 Clinica Medica: 225 dias`)
- **Change:** detectar 3+ sessões consecutivas sem commits em `content/aulas/` → output banner amarelo "ATENÇÃO: 3 sessões sem produto. R3 a 225 dias."
- **Draft:** ~10 linhas em session-start.sh comparando `git log --since="last 3 sessions" -- content/aulas/` vs total commits

### [PATTERN_REPEAT] KPI Reflection Loop + Cost BLOCK = teatro

**Evidence:** zero firings em hook-log 11d. 200-call interval = sessões curtas nunca atingem. 400-call BLOCK threshold idem. Phase G.3 plan já cobre delete.

**Proposed fix:** **EXECUTE Phase G.3** (delete `post-global-handler.sh:26-32, 45-146`).

### [SKILL_UNDERTRIGGER] /insights ritual broken

**Evidence:** Apenas 4 reports nos archives (S193 + 3 anteriores). 11d gap entre runs S193→S230. Skill funciona perfeitamente quando invocada (este report = proof).

**Proposed fix:** **EXECUTE Phase G.5** (SessionStart reminder se sexta + last_insights >7d).

---

## Phase 4.5 — QUESTION (Double-Loop Audit)

| KBP/Rule | Verdict | Evidence | Action |
|----------|---------|----------|--------|
| KBP-01 Scope Creep → momentum-brake | **DEPRECATE the brake, KEEP KBP** | Zero scope drift events em 24 commits; brake exempt = teatro | Delete brake hooks; KBP-01 stays as concept (anti-drift rule) |
| KBP-23 First-Turn Context Explosion | **STRENGTHEN** | 27 violations em 11d; rule qualitativa demais | Add hook enforcement (proposed above) |
| KBP-26 CC permissions.ask broken | **CONFIRMED** | 4 popups bloqueados em S230 (rmdir, python -c, pytest, rm -rf) | KEEP, mas acelerar BACKLOG #34 manual follow-up |
| KBP-27 Crosstalk Pattern | **VALIDATED** | S229 Notion writes via crosstalk worked perfectly | KEEP |
| `.claude/rules/qa-pipeline.md` | **EXPANDED CORRECTLY S230 Batch 2** | metanalise §QA absorbed sem perda; no more duplication | KEEP |
| `.claude/rules/anti-drift.md` | **HEAVY USE S230** | EC loop, State files, Plan execution todos exercidos | KEEP |
| `.claude/rules/known-bad-patterns.md` | **POINTER FORMAT VIOLATED then FIXED Batch 2** | KBP-26+27 prose extracted | KEEP, monitor for new violations |
| `.claude/rules/design-reference.md` + `slide-rules.md` | **NO DATA — zero slide work 11d** | Não exercidas | KEEP (defer overlap audit per Batch 2 item 6 parking) |
| `.claude/skills/insights/SKILL.md` | **WORKS WHEN RUN** | This report proof | Add ritual reminder (Phase G.5) |

**No KBPs to deprecate.** Concepts remain valid; only some implementations (brake) are theater.

---

## Phase 5 — Failure Registry Update

`.claude/insights/failure-registry.json` does not exist. **Initialize with this S230 entry:**

```json
{
  "version": 1,
  "sessions": [
    {
      "id": "S230",
      "date": "2026-04-19",
      "metrics": {
        "sessions_in_sample": 163,
        "user_corrections_total": "qualitative — see report",
        "user_corrections_per_session": "n/a",
        "kbp_violations": {
          "KBP-01_scope_creep": 0,
          "KBP-23_context_explosion": 27,
          "KBP-26_permissions_ask_broken": 4
        },
        "kbp_total": 31,
        "kbp_per_session": "n/a (sessões mistas)",
        "tool_errors": 80,
        "retries": "n/a"
      },
      "insights_run": true,
      "new_kbps_added": 0,
      "proposals_accepted": 0,
      "proposals_rejected": 0
    }
  ],
  "trend": {
    "first_run": true,
    "direction": "baseline"
  }
}
```

**Trend:** First entry — no comparison possible. Future runs compare 5-session rolling avg.

**Constrained optimization:** N/A first run.

---

## Evolution Metrics

Compared to previous report (S193, Apr 14):
- Categories of error PERSISTED: KBP-23 (Read sem limit) — both runs flagged
- Categories of error NEW: KBP-26 (permissions.ask broken) — discovered S227, persists S230
- Categories of error RESOLVED: nudge-commit calibration (S193 flagged 79 firings/3d; current 131/11d ≈ 12/day = stable, no longer anomaly)
- New rules added since S193: anti-drift §Edit discipline (KBP-25), §State files, §Plan execution, §EC loop §Propose-before-pour, §Budget gate em scope extensions

---

## Save metadata

- Report saved to: `.claude/skills/insights/references/latest-report.md`
- Previous report: `references/previous-report.md` (S193 — kept as historical)
- `.last-insights` updated to current epoch (Phase G.1 commit)
- Coautoria: Lucas + Opus 4.7 | S230 Phase G.1 (insights restoration)

---

## Structured JSON output

```json
{
  "insights_run": "2026-04-19",
  "sessions_analyzed": 163,
  "proposals": [
    {
      "id": "P001",
      "category": "PATTERN_REPEAT",
      "title": "DELETE momentum-brake teatro",
      "target_file": ".claude/hooks/momentum-brake-{clear,enforce}.sh + .claude/hooks/post-global-handler.sh:42-43 + .claude/settings.json",
      "priority": "high",
      "frequency": 0,
      "draft": "rm .claude/hooks/momentum-brake-clear.sh .claude/hooks/post-global-handler.sh:42-43 (LOCK_DIR block) + remove 2 hook registrations from settings.json (lines 123 UserPromptSubmit + 248 PreToolUse)"
    },
    {
      "id": "P002",
      "category": "RULE_VIOLATION",
      "title": "Add KBP-23 hook enforcement for Read sem limit",
      "target_file": "hooks/post-tool-use-failure.sh",
      "priority": "high",
      "frequency": 27,
      "draft": "if [[ \"$PATTERN\" == \"Read\" ]] && [[ \"$DETAIL\" =~ \"exceeds maximum allowed tokens\" ]]; then inject_message '[KBP-23] Read sem limit em arquivo grande. Use limit:50 primeiro, depois Grep targeted.'; fi"
    },
    {
      "id": "P003",
      "category": "PATTERN_REPEAT",
      "title": "DELETE KPI Reflection Loop + Cost BLOCK",
      "target_file": ".claude/hooks/post-global-handler.sh:26-32,45-146",
      "priority": "high",
      "frequency": 0,
      "draft": "Delete linhas 26-32 (Cost BLOCK arm) + linhas 45-146 (KPI Reflection Loop). Manter apenas Cost WARN + momentum-arm (mas se P001 aprovado, momentum-arm também sai)."
    },
    {
      "id": "P004",
      "category": "RULE_VIOLATION",
      "title": "Fix metrics.tsv SESSION_NUM regex",
      "target_file": "hooks/stop-metrics.sh:96",
      "priority": "medium",
      "frequency": 7,
      "draft": "if [[ \"$LATEST_COMMIT_MSG\" =~ ^S([0-9]+)([[:space:]]|:) ]]; then"
    },
    {
      "id": "P005",
      "category": "PATTERN_REPEAT",
      "title": "Anti-meta-loop banner: 3+ sessões sem produto",
      "target_file": "hooks/session-start.sh",
      "priority": "high",
      "frequency": 5,
      "draft": "Append: 'AULAS_COMMITS=$(git log -3 --pretty=format:%H -- content/aulas/ | wc -l); if [ $AULAS_COMMITS -lt 1 ]; then echo \"⚠️ 3+ sessões sem produto (aulas/). R3 a $(cat .claude/apl/deadline-days.txt)d.\"; fi'"
    },
    {
      "id": "P006",
      "category": "SKILL_UNDERTRIGGER",
      "title": "/insights ritual reminder Friday",
      "target_file": "hooks/session-start.sh",
      "priority": "medium",
      "frequency": 1,
      "draft": "Append: 'DOW=$(date +%u); LAST_INS=$(stat -c %Y .claude/.last-insights 2>/dev/null || echo 0); GAP=$(( ($(date +%s) - LAST_INS) / 86400 )); if [ \"$DOW\" -eq 5 ] && [ \"$GAP\" -gt 7 ]; then echo \"🔬 sexta + ${GAP}d sem /insights. Considere rodar.\"; fi'"
    }
  ],
  "kbps_to_add": [],
  "pending_fixes_to_add": [
    {
      "item": "BACKLOG #34 manual follow-up: /clear + observe popup stability + close",
      "priority": "P1",
      "target": ".claude/BACKLOG.md (#34 already exists, status check)"
    }
  ],
  "metrics": {
    "rule_violations": 31,
    "user_corrections": "see PATTERN_REPEAT 5 sessões meta-work",
    "retries": 80,
    "patterns_resolved_since_last": 1,
    "patterns_new": 2
  }
}
```
