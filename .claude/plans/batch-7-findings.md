# Batch 7 Findings -- Antifragile Health Audit
> Date: 2026-04-07 | Auditor: general-purpose agent
> **CLOSED S102** (2026-04-07): B7-01=FP, B7-08=fixed S101, B7-06/B7-10=fixed S102, 5 accepted, B7-09=deferred (chaos test)

## KBP Enforcement Status

| KBP | Fix Declared | Implemented? | Bypass Risk | Evidence |
|-----|-------------|-------------|-------------|----------|
| KBP-01 (scope creep) | Momentum brake (anti-drift.md) | YES -- structural hooks | LOW -- hooks are infrastructure-guarded | 3 hooks: `momentum-brake-arm.sh` (PostToolUse .*), `momentum-brake-enforce.sh` (PreToolUse .*), `momentum-brake-clear.sh` (UserPromptSubmit). Arm->enforce->clear cycle verified. Exempt tools: Read/Grep/Glob/AskUserQuestion/EnterPlanMode (observation only). Write/Edit exempt because `guard-pause.sh` already forces "ask". |
| KBP-02 (context overflow) | Proactive checkpoints (session-hygiene.md) | YES -- hooks exist | MEDIUM -- relies on behavioral compliance | `pre-compact-checkpoint.sh` (PreCompact hook) saves git status + recent files to `.claude/.last-checkpoint`. `session-compact.sh` (SessionStart compact matcher) re-injects `context-essentials.md` + HANDOFF + checkpoint. The "after 2 complex subagent tasks: commit" rule is DOCUMENT-ONLY -- no hook enforces the 2-task limit. |
| KBP-03 (script redundancy) | Script primacy (anti-drift.md) | YES -- agents reference scripts | LOW | All 3 agents touching scripts (qa-engineer, evidence-researcher, quality-gate) use `node scripts/...` commands, not reimplemented logic. qa-engineer.md lines 42,76,85 reference qa-capture.mjs and gemini-qa3.mjs. evidence-researcher.md lines 60-65 reference content-research.mjs. quality-gate.md lines 19-22 reference lint-slides.js, lint-case-sync.js, lint-narrative-sync.js, validate-css.sh. |
| KBP-04 (QA criteria invented) | Criteria-source mandate (qa-pipeline.md) | YES -- agent definition mandates | MEDIUM -- no hook enforces read-before-evaluate | qa-engineer.md Preflight section: "PRE-GATE -- ler criterios ANTES de avaliar (KBP-04)". Lists 3 specific source files (design-reference.md, slide-rules.md, archetypes.md). Post-check: "Report contem EXATAMENTE 4 dims. Mais = inventei. Menos = pulei." But enforcement is prompt-only; no hook verifies the agent actually Read those files before evaluating. |
| KBP-05 (batch QA multi-slide) | Single-slide convention (qa-engineer.md) | YES -- agent definition + maxTurns | LOW-MEDIUM | qa-engineer.md: "UM slide, UM gate por invocacao" at both primacy and recency anchors. "SINGLE SLIDE GUARD: No inicio da invocacao, identificar o UM slide. Se referenciar um segundo slide ID ou arquivo, PARAR." maxTurns=12 backstop. No structural hook enforces this -- relies on agent prompt compliance + turn budget exhaustion. |

## Self-Healing Loop Status

### Loop: stop-detect-issues.sh -> pending-fixes.md -> session-start surfaces

**FUNCTIONAL.** The three-stage loop is correctly wired:

1. **Detection** (`hooks/stop-detect-issues.sh`, Stop hook, 5s timeout):
   - Check 1: Slide HTML modified without _manifest.js update
   - Check 2: Evidence HTML modified without slide HTML update
   - Check 3: _manifest.js modified without index.html rebuild
   - Check 4: HANDOFF/CHANGELOG not updated (with 3-commit lookback to avoid false positives)
   - Writes issues to `.claude/pending-fixes.md` with timestamp

2. **Persistence** (`.claude/pending-fixes.md`):
   - Currently: **file does not exist** (no pending issues -- either everything is clean, or issues were already surfaced and archived)
   - Previous archives would be named `pending-fixes-YYYYMMDD-HHMM.md`

3. **Surfacing** (`hooks/session-start.sh`, SessionStart hook, 5s timeout):
   - Checks if pending-fixes.md exists and is non-empty
   - Outputs full contents with header "=== PENDING FIXES (from previous session) ==="
   - Instructs: "Address these before starting new work"
   - Archives (mv, not rm) with timestamp -- preserves audit trail
   - Silently fails if rename fails (mv ... || true)

**Verdict:** The loop is real and functional. Detection covers the 4 most common cross-ref issues. Archiving preserves history. No pending-fixes.md currently exists, which is consistent with a healthy state.

## Cost & Circuit Breaker Status

### `.claude/hooks/cost-circuit-breaker.sh` (PostToolUse .*, every tool call)

**Thresholds:**
- WARN: 100 tool calls (configurable via `CC_COST_WARN_CALLS`)
- BLOCK: 400 tool calls (configurable via `CC_COST_BLOCK_CALLS`)

**Behavior:**
- WARN: Warning every 10 calls after threshold ("Considere encerrar logo")
- BLOCK: Injects stop instruction in agent context (does NOT actually block -- exit 0 always)

**Assessment:**
- **Proxy-only**: Counts tool calls, not actual USD cost. TODO comment at line 7 says "substituir por custo USD real quando OTel/Langfuse estiver configurado."
- **Session ID = hourly**: Counter resets every hour (date '+%Y%m%d_%H'). A session spanning midnight resets silently.
- **Warn-only at BLOCK**: Despite the name "BLOCK", it exits 0 with a message. It does NOT use exit 2 or permissionDecision to actually halt the agent. The agent can ignore the message.
- **Thresholds reasonable**: 100 warn / 400 block for an hourly window is sensible for a Max subscription ($0 API cost). The real risk is context bloat, not dollars.

## Chaos Injection Status

### `.claude/hooks/chaos-inject-post.sh` + `.claude/hooks/lib/chaos-inject.sh`

**Activation:** CHAOS_MODE=1 (default: OFF). Probability: 5% per call (configurable via CHAOS_PROBABILITY).

**Vectors (4):**
1. `inject_http_429` -- Appends fake rate_limit entry to `/tmp/cc-model-failures.log` (tests L2 model-fallback-advisory)
2. `inject_socket_timeout` -- Appends fake overloaded entry (tests L2)
3. `inject_model_unavailable` -- Appends fake model_not_available entry (tests L2)
4. `inject_rapid_calls` -- Inflates `/tmp/cc-calls-{session}.txt` by +50 (tests L3 cost-circuit-breaker)

**Safety:** YES -- safe. All vectors write to /tmp state files only. They do NOT:
- Modify source code
- Corrupt git state
- Delete files
- Make API calls
- Affect real model routing

**Reporting:** `hooks/stop-chaos-report.sh` (Stop hook):
- Reads `/tmp/cc-chaos-log.jsonl` for injection counts per vector
- Cross-references with L2 failure log and L3 call counter
- Reports gaps: "L2 injections but no failures" or "L3 injection but counter low"
- Beautiful ASCII box report

**Assessment:** Well-designed. The chaos system tests exactly what it claims: whether L2 (model-fallback-advisory) and L3 (cost-circuit-breaker) defense hooks activate when they should. The gap detection in the report is genuine verification.

## Findings

| ID | Category | Severity | Description | Evidence | Suggested Fix |
|----|----------|----------|-------------|----------|---------------|
| B7-01 | GAP | P1 | Cost circuit breaker is warn-only -- never actually blocks | `cost-circuit-breaker.sh` exits 0 always. At 400 calls it prints a message but does not use exit 2 or permissionDecision to halt. Agent can ignore. | At BLOCK threshold, output `{"hookSpecificOutput":{"hookEventName":"PostToolUse","permissionDecision":"block"}}` or exit 2 to actually stop the agent. |
| B7-02 | GAP | P2 | KBP-02 "after 2 complex subagent tasks: checkpoint" has no structural enforcement | `session-hygiene.md` and `context-essentials.md` state this rule, but no hook counts Agent tool uses or forces checkpoints. Relies entirely on the model reading and obeying the rule. | Create a counter in PostToolUse for Agent matcher. After 2 Agent calls, inject advisory: "2 subagent tasks done. Consider committing and updating HANDOFF." |
| B7-03 | GAP | P2 | KBP-04 "read criteria before evaluating" has no structural enforcement | qa-engineer.md says "PRE-GATE -- ler criterios ANTES de avaliar (KBP-04)" but nothing verifies the agent actually issued Read calls for design-reference.md, slide-rules.md, and archetypes.md before producing its evaluation. | Could add a PreToolUse hook for Agent that checks if tool_name=Agent and agent_name=qa-engineer, then inject reminder. Or: qa-capture.mjs could emit a preflight checklist that the agent must fill in with file hashes. |
| B7-04 | KBP | P2 | Momentum brake exempts Write and Edit (guard-pause.sh handles them) but guard-pause.sh whitelists memory/ and .claude/plans/ silently | `guard-pause.sh` lines 22-28: writes to `/memory/` and `/.claude/plans/` exit 0 silently (no ask). This means the momentum brake also does not fire for these paths, since Write/Edit is excluded from momentum-brake-enforce. An agent could chain unlimited memory/plan writes without user approval. | Acceptable for memory/plans (low risk), but document the gap. If concerned, add a counter-based advisory after 3+ plan file writes. |
| B7-05 | SELF-HEAL | P2 | stop-detect-issues.sh Check 4 (HANDOFF/CHANGELOG) can false-negative with the 3-commit lookback | If HANDOFF was updated 4+ commits ago but meaningful work was done since, the check passes because `git log -3` found the old update. The 3-commit window is reasonable but not airtight. | Increase lookback to 5 or use time-based window (e.g., files modified in the last session). Low priority -- the current heuristic is good enough for most sessions. |
| B7-06 | COST | P2 | Circuit breaker counter resets hourly, not per session | `date '+%Y%m%d_%H'` means a 3-hour session gets 3 separate 400-call budgets (1200 total). A session starting at HH:59 gets a near-full reset at HH+1:00. | Use a session-scoped counter (e.g., written by session-start.sh) instead of hourly clock. Or: use cumulative counter that session-start.sh resets. |
| B7-07 | CHAOS | P2 | Chaos injection writes to same /tmp files that defense hooks read -- but does not verify timing | `chaos-inject-post.sh` fires on PostToolUse, `model-fallback-advisory.sh` also fires on PostToolUse. The comment says chaos must be registered BEFORE model-fallback-advisory in settings.local.json. Verified: chaos-inject-post is at line 227, model-fallback-advisory at line 237. Order is correct. But both fire on the same event cycle -- the defense hook may not see the injected state until the NEXT tool call. | The chaos report at session end cross-references, so gaps are detected post-facto. This is acceptable for L6 chaos testing. Low priority. |
| B7-08 | GAP | P1 | guard-product-files.sh blocks edits to hook .sh files (exit 2), but settings.local.json block is only checked if the path contains `.claude/settings.local.json` -- an agent could add a NEW hook file outside the guarded directories | The INFRA_BLOCK_PATTERNS array blocks `\.claude/hooks/[^/]+\.sh$` and `hooks/[^/]+\.sh$` and `\.claude/settings\.local\.json$`. But an agent could create a hook in a subdirectory (e.g., `.claude/hooks/lib/evil.sh`) or modify `lib/chaos-inject.sh` (which is `.claude/hooks/lib/` not `.claude/hooks/[^/]+\.sh$`). | Expand pattern to `\.claude/hooks/.*\.sh$` (recursive) and `hooks/.*\.sh$` (recursive). Also add `\.claude/settings\.json$` pattern. |
| B7-09 | GAP | P1 | Antifragile L6 chaos is OFF by default (CHAOS_MODE!=1) and there is no evidence it has ever been run in a real session | CHAOS_MODE defaults to off. No `.env` file sets it. No session log or archived chaos report was found. The system is well-built but may be untested in production. | Run a chaos session: `CHAOS_MODE=1 CHAOS_PROBABILITY=20` for one session, review the stop-chaos-report output, and archive the results. This validates the entire L2/L3/L6 chain. |
| B7-10 | GAP | P2 | pre-compact-checkpoint.sh uses `stat --format` and `date -d` which are GNU-specific -- may fail silently on Windows/Git Bash | Line 17-19: `stat --format='%Y %n'` and `date -d '10 minutes ago'` are GNU coreutils. Git Bash on Windows may or may not have these. Script exits 0 regardless (exit 0 at end), so failures are silent. The checkpoint file might be incomplete. | Use `stat -c '%Y %n'` (same as --format on GNU) or test with Windows Git Bash and add fallback. Low priority since the checkpoint is advisory. |

## Summary

**What works well:**
- KBP-01 momentum brake is the strongest enforcement: 3 structural hooks with correct arm/enforce/clear cycle
- Self-healing loop (detect -> persist -> surface) is genuine and correctly wired
- Agent definitions properly reference scripts (KBP-03 fixed)
- Chaos injection system is well-designed with gap detection
- Guard infrastructure (guard-pause, guard-generated, guard-product-files) is layered and fail-closed
- Context-essentials.md post-compaction re-injection is functional

**Weakest links:**
1. Cost circuit breaker is advisory-only at all thresholds (B7-01)
2. KBP-02 and KBP-04 fixes are prompt-only with no structural hooks (B7-02, B7-03)
3. Hook infrastructure guard has a recursive-path gap in .claude/hooks/lib/ (B7-08)
4. Chaos system has never been exercised in production (B7-09)

**Overall antifragile health: 7/10** -- The structural hooks (momentum brake, self-healing loop, guard system) are real and functional. The prompt-only fixes (KBP-02, KBP-04) are the main gap between declared and implemented protection. The chaos system is the most sophisticated component but remains untested.
