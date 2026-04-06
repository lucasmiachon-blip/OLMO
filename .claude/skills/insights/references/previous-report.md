# /insights — Full Retrospective Report S82

> Period: 2026-03-29 to 2026-04-05 (S75-S81, 58 sessions in 7 days)
> Analyst: Opus 4.6
> Method: SCAN -> AUDIT -> DIAGNOSE -> PRESCRIBE
> Previous report: 2026-04-03 (Focused Error Audit, 20 sessions)
> Last insights timestamp: 1775246603

---

## Executive Summary

58 main sessions scanned. 20 analyzed in depth (most recent + highest signal). The agent ecosystem underwent major consolidation (S79-S81): 11 agents reduced to 8, adversarial audits from both Opus and Codex GPT-5.4. Despite structural improvement, 3 behavioral patterns persist from the previous report and 2 new systemic issues emerged.

**Key metric:** User corrections requiring explicit behavioral redirection = 24 (scope_creep) + 9 (wrong_criteria) + 7 (batch_violation) = 40 high-signal interventions across 20 sessions (2.0 per session average).

---

## Phase 1: SCAN — Incident Summary

### Signal Counts (20 sessions analyzed)

| Category | Hits | Sessions Affected |
|----------|------|-------------------|
| User corrections (total) | 215 | 18/20 |
| Scope creep / unauthorized action | 24 | 8 |
| Context loss / rehydration needed | 11 | 6 |
| Redundancy complaints | 10 | 5 |
| Wrong criteria (agent inventing vs following scripts) | 9 | 3 |
| Batch violation (multi-slide when 1 requested) | 7 | 3 |
| Permission skip | 4 | 3 |
| Errors (tool failures, FAIL signals) | 61 | 12 |
| Retries / workarounds | 9 | 5 |
| Rule violation mentions | 14 | 6 |

### Highest-Signal Sessions

| Session | Date | Theme | Key User Corrections |
|---------|------|-------|---------------------|
| 8cc72d17 | Apr 3 | QA pipeline | "nao aplicou os criterios", "com os criterios nao da sua cabeca", "esta rodando tudo errado eh um slide por vez", "pare tudo e organize a casa", "tem muita redundancia entre os scripts e os agentes" |
| 1cfc1f1c | Apr 5 | Adversarial audit + janitor | "reflita antes de fazer nao aceite", "um por vez e se nao tiver confianca alta me pergunte", "cuidado com o env" |
| 20706c01 | Apr 5 | Agent consolidation (S79) | "primeiro foque nos criticos e eliminar redundancia e seguir os scripts nao criar novos", "nao se vc da conta tudo bem sem complexidade" |
| 3a47931d | Apr 4 | QA s-objetivos | "eu preciso que vc avalie visual conforme o scrip e o pipeline tem um md especifico", "pare pequenas mudancas sempre com minha permissao" |
| 5559f171 | Apr 5 | Agent audit 2 (S80) | "rodou indefinidamente, tem redundancia com scripts", "maxturna 20 nao eh muito?" |

---

## Phase 2: AUDIT — Rule Compliance Matrix

### Rule Staleness Check

| Rule File | Status | Notes |
|-----------|--------|-------|
| `anti-drift.md` | **ACTIVE, VIOLATED** | Scope creep persists (24 incidents). Rule text is clear but not enforced by hooks. |
| `coauthorship.md` | ACTIVE, FOLLOWED | Co-Authored-By present in all commits. |
| `session-hygiene.md` | ACTIVE, FOLLOWED | HANDOFF/CHANGELOG updated. Post-consolidation checklist added S80. |
| `qa-pipeline.md` | ACTIVE, **VIOLATED** | Batch violations (7 incidents). Agent ran multi-slide QA despite "1 slide por vez" rule. |
| `process-hygiene.md` | ACTIVE, FOLLOWED | PID-specific kills used. Ports respected. |
| `slide-rules.md` | ACTIVE, FOLLOWED | Assertion-evidence, data-animate, CSS scoping. |
| `design-reference.md` | ACTIVE, FOLLOWED | Color semantics, PMID verification protocol. |
| `mcp_safety.md` | ACTIVE, DORMANT | Notion MCP not exercised in S75-S81. |
| `notion-cross-validation.md` | ACTIVE, DORMANT | Not exercised. |

### Referenced Files Verification

All referenced files in rules exist and are current, EXCEPT:

| Rule | Reference | Issue |
|------|-----------|-------|
| `notion-cross-validation.md` | `templates/chatgpt_audit_prompt.md` | EXISTS but has not been used/updated recently |
| HANDOFF.md | `repo-janitor: falta maxTurns` | **STALE** — maxTurns: 12 already added (verified in agent file) |
| HANDOFF.md | `evidence-db.md` deprecated | File still exists (not deleted), agents reference "living HTML is canonical" |
| CLAUDE.md | Python 4-agent architecture | `orchestrator.py` exists but scaffold never fully implemented (DOC-1 in HANDOFF) |

### Security Audit Status (from S81 adversarial audit)

| Finding | Status | Verified |
|---------|--------|----------|
| SEC-002: NLM shell injection (content-research.mjs:933) | **OPEN** | Confirmed: `execSync(cmd)` with string-interpolated user query |
| SEC-003: Gemini API key in URL query string | **OPEN** | Confirmed: 6 instances across gemini-qa3.mjs + content-research.mjs |
| SEC-NEW: done-gate.js aula arg without allowlist | **OPEN** | Not verified this session |
| guard-secrets.sh | FIXED (S51) | Fail-closed confirmed, staged blob scanning |

### Skill Compliance

| Skill | Triggered | Issue |
|-------|-----------|-------|
| `insights` | Weekly (this run) | OK |
| `dream` | Auto-trigger via hook | OK (daily consolidation) |
| `slide-authoring` | Multiple sessions | OK |
| `research` | S75 (3-leg pipeline) | OK |
| `janitor` | S81 | OK |
| `qa-pipeline` (via qa-engineer agent) | S76, S77b | **UNDERTRIGGERED** — agent used own criteria instead of script criteria |
| `review` | Not exercised S75-S81 | DORMANT |

---

## Phase 3: DIAGNOSE — Categorized Findings

### Priority Matrix (frequency x impact x fixability)

| # | Finding | Category | Freq | Impact | Fix |
|---|---------|----------|------|--------|-----|
| 1 | Agent uses own QA criteria instead of script-defined criteria | RULE_VIOLATION | 9 | HIGH | HIGH |
| 2 | Scope creep — acting without permission | RULE_VIOLATION | 24 | HIGH | MED |
| 3 | Batch violation — multi-slide QA when 1 slide requested | RULE_VIOLATION | 7 | HIGH | HIGH |
| 4 | Context overflow cascading to lost thread | PATTERN_REPEAT | 11 | HIGH | MED |
| 5 | Agent-script redundancy — agent reimplements script logic | PATTERN_REPEAT | 10 | MED | HIGH |
| 6 | SEC-002/003 security issues unfixed across 2 sessions | RULE_GAP | 2 | HIGH | HIGH |
| 7 | HANDOFF.md stale entries (repo-janitor maxTurns) | RULE_STALE | 1 | LOW | HIGH |
| 8 | evidence-db.md deprecated but still exists on disk | RULE_STALE | 1 | LOW | MED |
| 9 | Python architecture in CLAUDE.md never implemented | RULE_STALE | 1 | LOW | MED |

---

## Phase 4: PRESCRIBE — Concrete Proposals

### [RULE_VIOLATION] #1: Agent Uses Own QA Criteria Instead of Script-Defined Criteria

**Evidence:** Session 8cc72d17 — User said "nao aplicou os criterios de analis visual" (L54) and "com os criterios nao da sua cabeca" (L87). Agent evaluated slides using general knowledge instead of the specific checks defined in `content/aulas/scripts/lint-slides.js` and `gemini-qa3.mjs`.

**Root cause:** The qa-engineer agent description says "scripts existentes" but doesn't explicitly mandate which criteria source to use. When the agent does DOM inspection, it invents criteria from training data rather than reading the script's check definitions first.

**Proposed fix:**
- **Target:** `.claude/rules/qa-pipeline.md` section 1
- **Change:** Add after "Gates sequenciais" line:
```markdown
- Criteria source: ALWAYS read the script's check definitions BEFORE evaluating.
  - Preflight: `lint-slides.js` checks array + `qa-batch-screenshot.mjs` metrics
  - Inspect/Editorial: `gemini-qa3.mjs` gate prompts in `docs/prompts/`
  - NEVER invent criteria from training data. If a check is not in the script, it does not exist.
```

### [RULE_VIOLATION] #2: Scope Creep — Acting Without Permission

**Evidence:** 24 scope_creep signals. Session 8cc72d17 L172: "calma primeiro mova o slide depois eu falo proximo passo". Session 8cc72d17 L328: "pare tudo e organize a casa". Session 3a47931d L242: "pare pequenas mudancas sempre com minha permissao".

**Root cause:** The ENFORCEMENT rule "espere OK" is text-only with no enforcement mechanism. The agent understands the rule but momentum causes it to chain actions without pausing. This is the most frequent user correction category.

**Proposed fix:**
- **Target:** `.claude/rules/anti-drift.md` > Scope discipline section
- **Change:** Add:
```markdown
## Momentum brake

After completing any discrete action (edit, build, commit, QA check):
STOP and report the result. Do NOT chain to the next logical step.
The next step requires Lucas's explicit instruction — not implicit permission.
Exception: within an approved multi-step plan where all steps were listed upfront.
```

### [RULE_VIOLATION] #3: Batch QA Violation

**Evidence:** Session 8cc72d17 L319: "esta rodando tudo errado eh um slide por vez". Session 8cc72d17 L370: "trave sempre para fazer um slide por vez". Already documented in qa-pipeline.md but violated.

**Root cause:** qa-engineer maxTurns (12) is sufficient for a full gate but does not enforce single-slide discipline. The agent can begin a second slide within the same invocation.

**Proposed fix:**
- **Target:** `.claude/agents/qa-engineer.md` ENFORCEMENT section
- **Change:** Add explicit guard:
```markdown
4. **SINGLE SLIDE GUARD:** At the start of every invocation, identify the ONE slide being evaluated. If you find yourself referencing a second slide's ID or file, STOP — you are violating the single-slide rule.
```

### [PATTERN_REPEAT] #4: Context Overflow Cascade

**Evidence:** 11 context_loss signals. Session 1cfc1f1c L398: "organize todos seus achados em um md para depois nao se perder no contexto". Session 3a47931d L394: "vai comitar atualizar tudo pq o contexto esta estourando".

**Root cause:** Same as previous report. Sessions with multiple subagent runs (Codex, research legs, QA) accumulate context rapidly. The previous report proposed proactive checkpoints — not yet implemented.

**Proposed fix:** (REPEAT from previous report — escalate priority)
- **Target:** `.claude/rules/session-hygiene.md`
- **Change:** Add:
```markdown
## Proactive Checkpoints

After completing 2 complex subagent tasks in a session:
1. Commit any uncommitted work
2. Update HANDOFF.md with current state
3. Suggest /clear to user if task is switching

When a continuation summary appears after compaction:
1. Immediately re-read HANDOFF.md (the summary is lossy)
2. Do NOT rely on memory of pre-compaction context
```

### [PATTERN_REPEAT] #5: Agent-Script Redundancy

**Evidence:** Session 8cc72d17 L433: "tem muita redundancia entre os scripts e os agentes, muitos scripts criados que nao deveriam existir". Session 20706c01 L129: "eliminar redundancia e seguir os scripts nao criar novos". Session 5559f171 L265: "tem redundancia com scripts".

**Root cause:** Agent definitions duplicate logic already in scripts (e.g., QA check definitions, research prompts). When agent and script disagree, agent follows its own definition, causing the wrong-criteria issue (#1).

**Proposed fix:**
- **Target:** `.claude/rules/anti-drift.md` > Code quality section
- **Change:** Add:
```markdown
## Script Primacy

Scripts in `content/aulas/scripts/` are the canonical implementation.
Agent definitions (.claude/agents/*.md) MUST reference scripts, not reimplement their logic.
When agent behavior diverges from script behavior: the script is correct.
NEVER create new scripts without Lucas's explicit request.
```

### [RULE_GAP] #6: Security Issues Persist Across Sessions

**Evidence:** SEC-002 (shell injection at content-research.mjs:933) and SEC-003 (API key in URL, 6 instances) documented in S81 adversarial audit but remain unfixed after 2 sessions.

**Root cause:** No mechanism tracks P0 security items to resolution. They are listed in HANDOFF but compete with feature work for attention.

**Proposed fix:**
- **Target:** `.claude/rules/session-hygiene.md`
- **Change:** Add:
```markdown
## P0 Security Gate

At session start, if HANDOFF.md lists P0 SECURITY items:
1. Surface them to Lucas immediately
2. Do NOT begin new feature work until Lucas explicitly defers them
This ensures security items are not buried by momentum.
```

### [RULE_STALE] #7: HANDOFF.md Stale Entries

**Evidence:** HANDOFF says "repo-janitor: falta maxTurns" but the agent file already has `maxTurns: 12`. This was fixed in S81 but HANDOFF was not updated.

**Root cause:** Post-fix HANDOFF cleanup was skipped.

**Proposed fix:**
- **Target:** HANDOFF.md (when Lucas approves changes)
- **Change:** Remove "Falta maxTurns" from repo-janitor row, update status to "OK (model: haiku)"

---

## Evolution from Previous Report (2026-04-03)

| Previous Finding | Status Now |
|------------------|------------|
| Context Overflow (50%) | **PERSISTS** (11 signals). Proposed fix not yet implemented. Escalated. |
| Scope Drift (40%) | **PERSISTS** (24 signals). New momentum brake proposed. |
| Encoding cp1252 (35%) | **IMPROVED** — only 2 explicit encoding complaints in new data (vs 7 previously). Scripts using PYTHONIOENCODING. |
| Lost Thread (30%) | **PERSISTS** — merged into context overflow cascade. |
| Output Invisible (25%) | **IMPROVED** — fewer complaints in S75-S81 (dual-file edit rule is working). |

**New findings this cycle:**
- Wrong criteria (#1) — 9 incidents, new pattern not in previous report
- Agent-script redundancy (#5) — 10 incidents, systemic root cause
- Security persistence (#6) — structural gap in how P0 items are tracked

**Net:** 2 improved, 3 persisting, 3 new.

---

## Compliance Matrix Summary

| Rule | Status | Incidents |
|------|--------|-----------|
| anti-drift.md | VIOLATED | 24 scope, 10 redundancy |
| qa-pipeline.md | VIOLATED | 7 batch, 9 criteria |
| session-hygiene.md | FOLLOWED (text) / GAP (enforcement) | 11 context loss |
| coauthorship.md | FOLLOWED | 0 |
| process-hygiene.md | FOLLOWED | 0 |
| slide-rules.md | FOLLOWED | 0 |
| design-reference.md | FOLLOWED | 0 |
| mcp_safety.md | DORMANT | 0 |
| notion-cross-validation.md | DORMANT | 0 |

---

## Action Items (ordered by impact x fixability)

| # | Action | Target | Category |
|---|--------|--------|----------|
| 1 | Add criteria-source mandate to QA pipeline | qa-pipeline.md | RULE_VIOLATION |
| 2 | Add momentum brake to anti-drift | anti-drift.md | RULE_VIOLATION |
| 3 | Add single-slide guard to qa-engineer | qa-engineer.md | RULE_VIOLATION |
| 4 | Add proactive checkpoint rule (ESCALATED) | session-hygiene.md | PATTERN_REPEAT |
| 5 | Add script primacy rule | anti-drift.md | PATTERN_REPEAT |
| 6 | Add P0 security gate | session-hygiene.md | RULE_GAP |
| 7 | Fix HANDOFF stale entry (repo-janitor maxTurns) | HANDOFF.md | RULE_STALE |

All proposals modify existing files. No new files needed.

---

> Coautoria: Lucas + Opus 4.6
> Report generated by /insights (Full 4-Phase Retrospective)
> Date: 2026-04-05 | Session: S82
