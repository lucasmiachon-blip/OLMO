# /insights -- Full Retrospective Report S108

> Period: 2026-04-07 (sessions S100-S107)
> Analyst: Opus 4.6
> Method: SCAN -> AUDIT -> DIAGNOSE -> PRESCRIBE
> Previous report: S91 (13 sessions, zero incidents -- planning/infra only)
> Sessions analyzed: 9 main sessions + 28 subagent invocations

---

## Executive Summary

9 main sessions scanned (S100a/b, S101-S107). This is the first period with **active QA, slide-authoring, and research sessions** since the S82 enforcement mechanisms were deployed. Unlike S91 (which was all planning/infra and had zero incidents), this period is the real stress test.

**Key metrics:**

| Metric | S82 baseline | S91 | S108 | Delta vs baseline |
|--------|-------------|-----|------|-------------------|
| Sessions analyzed | 20 | 13 | 9 | -- |
| User corrections total | 40 | 0 | 12 | -70% |
| User corrections/session | 2.0 | 0.0 | 1.33 | -33% |
| KBP violations total | 61 | 0 | 8 | -87% |
| KBP violations/session | 3.05 | 0.0 | 0.89 | -71% |
| Tool errors | 61 | 0 | 0 | -100% |
| Retries | 9 | 0 | 0 | -100% |
| New KBPs added | 5 | 0 | 2 (KBP-06, KBP-07) | -- |

**Interpretation:** The enforcement mechanisms are working but not perfect. When sessions shifted from planning/infra to active QA and slide authoring, corrections resurfaced -- primarily KBP-01 (scope creep, 5 instances), KBP-04 variant (criteria source, 2 instances), and KBP-06 (delegation failure, 1 instance). The system learned and self-corrected in-session: KBP-07 was created in S104 as a direct response to a workaround pattern. No corrections observed in S101, S102, S105, or S107.

**Session type breakdown:**

| Type | Sessions | Corrections | Notes |
|------|----------|-------------|-------|
| Infra/hooks | S100a, S100b, S101, S102 | 3 | KBP-06 in S100a, KBP-01 variant in S100b |
| QA/Slides | S103, S104, S105 | 7 | KBP-01 dominant (3x in S103) |
| Research/Build | S106, S107 | 2 | Pipeline consolidation, redundancy found |

---

## Phase 1: SCAN -- Incident Summary

### INC-01: Agent delegation failure (S100, 57891c82)
- **Category:** KBP-06 (agent delegation without verification)
- **Severity:** HIGH
- **What happened:** Orchestrator launched 2 Codex batches via `codex:codex-rescue` agent, which delegates to external Codex CLI rather than performing review internally. Both returned empty outputs. User directed agent to diagnose the systemic failure.
- **User signal:** Instructed to only act after questioning, asked what went wrong and to find the systemic failure for learning.
- **Outcome:** KBP-06 created, memory saved (feedback_agent_delegation.md). Fix: pre-launch checklist (verify agent type, confirm output is capturable, get approval).

### INC-02: Scope creep -- editing without approval (S103, 79d88f0e)
- **Category:** KBP-01 (scope creep)
- **Severity:** HIGH (3 instances in single session)
- **What happened:** (a) Used archetypes.md in QA workflow without understanding its purpose -- user had to explain it was constraining creativity. (b) After Gemini editorial returned, agent edited HANDOFF without asking. (c) After being told to learn from the error, agent classified it as "feedback" instead of fixing the hook.
- **User signals:** User noted agent did not ask for opinion before editing, told agent to learn from the error, and clarified it needed to be fixed not just logged.
- **Outcome:** Archetypes removed from QA pipeline. KBP-01 recurrence documented. Momentum-brake hook identified as not functioning correctly.

### INC-03: QA criteria fabrication (S103, 79d88f0e -- pre-S100 session f2ddf33a)
- **Category:** KBP-04 variant
- **Severity:** HIGH
- **What happened:** Agent entered QA workflow without following the established pipeline steps, evaluated slides using subjective criteria instead of script-defined checks, and did not enter the correct loop position.
- **User signals:** User corrected that agent enters before Gemini, criteria exist and should not be fabricated, and agent must follow the established QA workflow.
- **Outcome:** QA pipeline rule reinforced. Agent acknowledged the error chain.

### INC-04: Workaround without diagnosis (S104, f094e745)
- **Category:** KBP-07 (new -- created this session)
- **Severity:** MEDIUM
- **What happened:** Agent edited a canonical prompt file without asking Lucas's approval. When MAX_TOKENS was hit on Gemini call, agent proposed workaround (modify prompt constraints) instead of diagnosing root cause (token budget insufficient).
- **User signal:** User noted approval was not requested and asked for a structural lock against workarounds.
- **Outcome:** KBP-07 created. Anti-workaround gate added to anti-drift.md. guard-product-files.sh created to protect canonical scripts/prompts.

### INC-05: Research pipeline redundancy (S106, fff63db6)
- **Category:** RULE_GAP (documentation hygiene)
- **Severity:** MEDIUM
- **What happened:** Agent attempted to use content-research.mjs (which should have been replaced by /research skill) and found Perplexity and NLM not properly integrated in the research pipeline. User had to direct the consolidation.
- **User signals:** User noted cross-reference cannot fail, asked where documentation was, directed pipeline consolidation and archive of the .mjs file.
- **Outcome:** /research v2.0 created with 6 legs. content-research.mjs archived. Cross-refs updated across docs.

### INC-06: Permission scope confusion (S100b, bbdef4ac + S102, 4cf11777)
- **Category:** KBP-01 variant (autonomous action scope)
- **Severity:** LOW
- **What happened:** In S100b, agent was reminded that stopping to ask permission is fine but acting without permission is not. In S102, user clarified that Bash read-only commands (ls, etc.) do not need approval.
- **User signals:** User clarified permission boundaries for tool usage.
- **Outcome:** Memory updated (feedback_tool_permissions.md). Momentum brake exemptions refined.

### INC-07: Vite port conflict (S103, 79d88f0e)
- **Category:** Process issue (minor)
- **Severity:** LOW
- **What happened:** Vite would not open on expected port; previous process still running.
- **Outcome:** Killed old process, restarted. No systemic fix needed.

---

## Phase 2: AUDIT -- Rule Compliance Matrix

| Rule file | Status | Evidence |
|-----------|--------|----------|
| anti-drift.md | VIOLATED x3 | INC-02 (HANDOFF edit without approval), INC-04 (prompt edit without approval). Anti-workaround gate ADDED as response. |
| coauthorship.md | FOLLOWED | All commits have co-authorship. |
| design-reference.md | FOLLOWED | PMID verification protocol followed in S106-S107 (40% Gemini error rate caught). |
| known-bad-patterns.md | EXTENDED | KBP-06 and KBP-07 added. KBP-01 recurred 5x. KBP-04 variant 2x. KBP-06 1x. |
| mcp_safety.md | FOLLOWED | No Notion write incidents. MCP calls properly gated. |
| notion-cross-validation.md | UNTESTED | No Notion reorganization workflows triggered. |
| process-hygiene.md | MINOR VIOLATION | INC-07 (port conflict). Process was killed and restarted correctly. |
| qa-pipeline.md | FOLLOWED after correction | INC-03 showed pipeline was not followed initially. After S103 corrections, archetypes removed and pipeline steps enforced. |
| session-hygiene.md | FOLLOWED | HANDOFF and CHANGELOG updated each session. |
| slide-rules.md | FOLLOWED | CSS edits followed scopeing rules. h2 decisions deferred to Lucas. |

**Summary:** 2/10 VIOLATED (anti-drift x3, process-hygiene x1 minor), 1/10 CORRECTED mid-session (qa-pipeline), 1/10 UNTESTED (notion-cross-validation), 6/10 FOLLOWED, 1/10 EXTENDED (known-bad-patterns).

### Skill trigger analysis

| Skill | Expected triggers | Actual triggers | Gap? |
|-------|-------------------|-----------------|------|
| research | S106 research | S106 (partial), S107 | No -- v2.0 consolidation happened |
| slide-authoring | S103-S105 | Yes | No |
| insights | S100 | Yes (S91 report generated) | No |
| dream | S100b | Triggered but system noise in output | MINOR -- dream invocation produces noisy system messages |
| organization | S100b (APL reform) | Yes | No |

### Rule staleness check

| Rule | Last modified | References valid? | Stale? |
|------|--------------|-------------------|--------|
| anti-drift.md | S104 (KBP-07 gate added) | Yes | No |
| coauthorship.md | Pre-S100 | Yes | No |
| design-reference.md | S103 (PMID rates updated) | Yes | No |
| known-bad-patterns.md | S104 (KBP-07 added) | Yes | No |
| mcp_safety.md | Pre-S100 | Yes | No |
| notion-cross-validation.md | Pre-S100 | Template path valid | LOW -- dormant |
| process-hygiene.md | Pre-S100 | Port table current | No |
| qa-pipeline.md | S103 (archetypes removed) | All script refs valid | No |
| session-hygiene.md | Pre-S100 | Yes | No |
| slide-rules.md | Pre-S100 | Yes | No |

---

## Phase 3: DIAGNOSE -- Prioritized Findings

### [PATTERN_REPEAT] F001: KBP-01 persists despite structural enforcement (5 instances)
- **Sessions:** S100a (codex without approval), S100b (permission scope), S103 (HANDOFF edit x2), S104 (prompt edit)
- **Frequency:** 5 across 9 sessions = 0.56/session (down from 1.2/session at S82)
- **Root cause:** Momentum-brake hooks were deployed S99 but had 3 bugs (B5-02/04/05) that were only fixed S100-S102. The hooks were structurally incomplete during S103-S104 when violations occurred. Post-fix (S105+), zero KBP-01 violations.
- **Category:** PATTERN_REPEAT
- **Fix assessment:** Hooks fixed. Trend is correct (0 violations post-fix). Monitor S109+.

### [RULE_VIOLATION] F002: QA pipeline not followed on first attempt (S103)
- **Sessions:** S103 (pre-S100 session f2ddf33a also showed this)
- **Frequency:** 2 sessions
- **Root cause:** Agent entered QA workflow without reading the pipeline steps first. Used subjective visual criteria instead of script-defined checks. The 11-step linear path in qa-pipeline.md was not followed.
- **Category:** RULE_VIOLATION
- **Fix assessment:** Pipeline was corrected mid-session. Archetypes removed (reducing confusion). The qa-pipeline.md Steps 3-5 are clear but the agent skipped them. A structural gate (hook) at QA invocation could force reading criteria first.

### [RULE_GAP] F003: No protection against canonical file edits
- **Sessions:** S104
- **Frequency:** 1 (but created KBP-07)
- **Root cause:** Agent edited prompt files (gate4-call-b-uxcode.md) without approval. No hook existed to protect these files.
- **Category:** RULE_GAP (now fixed)
- **Fix assessment:** guard-product-files.sh created S104. RESOLVED.

### [RULE_GAP] F004: Research pipeline had undocumented redundancy
- **Sessions:** S106
- **Frequency:** 1
- **Root cause:** content-research.mjs and /research skill coexisted with overlapping functionality. Perplexity and NLM were not integrated into /research. No single source of truth for the research pipeline.
- **Category:** RULE_GAP (now fixed)
- **Fix assessment:** /research v2.0 with 6 legs. content-research.mjs archived. Cross-refs cleaned. RESOLVED.

### [SKILL_UNDERTRIGGER] F005: Dream skill produces noisy system output
- **Sessions:** S100b, S107
- **Frequency:** 2
- **Root cause:** When /dream is invoked, the skill base directory and SKILL.md content appear as user messages in the session, creating noise in signal detection. This is a Claude Code SDK behavior, not a dream skill bug.
- **Category:** SKILL_UNDERTRIGGER (cosmetic)
- **Fix assessment:** No fix needed -- this is SDK behavior for skill invocations. Flag as known noise for future /insights scans.

### [PATTERN_REPEAT] F006: Gemini PMID error rate remains high (40%)
- **Sessions:** S107 (deep-search v2: 6/15 PMIDs wrong)
- **Frequency:** Consistent across sessions (56% S82, 40% S107)
- **Root cause:** LLM-generated PMIDs are unreliable. Gemini 3.1 Pro generates plausible but incorrect PMIDs ~40% of the time.
- **Category:** PATTERN_REPEAT
- **Fix assessment:** NLM verification leg added to /research v2.0. PMID verification protocol in design-reference.md is working (catching errors). The pattern is MITIGATED (detection works) but not RESOLVED (source error persists). No fix possible -- this is an LLM limitation.

---

## Phase 4: PRESCRIBE -- Proposals

### P001: QA Pipeline structural pre-read gate
- **Finding:** F002
- **Target:** `.claude/rules/qa-pipeline.md` (lines 16-40)
- **Proposed action:** Add explicit instruction that the agent MUST read qa-pipeline.md Steps 3-5 (criteria sources) BEFORE any visual evaluation. Currently the steps exist but the agent can skip them.
- **Priority:** MEDIUM
- **Draft:** Add after line 16:
  ```
  ## 0. Pre-Read Gate (OBRIGATORIO antes de qualquer avaliacao)
  ANTES de avaliar qualquer slide, o agente DEVE:
  1. Ler qa-pipeline.md Steps 3-5 (este arquivo)
  2. Ler design-reference.md secoes 1-2 (cor semantica, tipografia)
  3. Ler slide-rules.md secao 2 (checklist pre-edicao)
  Se o agente nao leu estes 3 arquivos na sessao atual, PARAR e ler antes de avaliar.
  ```

### P002: KBP-01 update -- momentum brake status and post-fix validation
- **Finding:** F001
- **Target:** `.claude/rules/known-bad-patterns.md` (KBP-01 entry)
- **Proposed action:** Update KBP-01 to note that structural hooks are now working post-S102 fixes and that S105-S107 had zero recurrences. Mark the variant as MITIGATED.
- **Priority:** LOW (documentation only)
- **Draft:** Append to KBP-01 Fix section:
  ```
  **Post-S102 status:** 3 hook bugs fixed (B5-02/04/05). S105-S107: 0 recurrences. Hooks structurally enforce ask-before-act. Monitor S109+.
  ```

### P003: Skill invocation noise -- flag for future /insights
- **Finding:** F005
- **Target:** `.claude/skills/insights/SKILL.md` (Phase 1, Step 2)
- **Proposed action:** Add a note to the SCAN phase that skill invocations produce system messages containing the SKILL.md content, which grep will pick up as false positives. Filter them out.
- **Priority:** LOW
- **Draft:** Add to Phase 1, Step 2 after the grep examples:
  ```
  **Known false positives:** Skill invocations (via Skill tool) inject the SKILL.md content as
  user messages. Grep hits on these are noise -- filter out messages starting with
  "Base directory for this skill:" or containing "# [SkillName] --" header patterns.
  ```

### P004: No new proposals for S91 P001-P005
- **S91 P001 (notion-cross-validation):** Still dormant. No Notion reorganization workflows. DEFER.
- **S91 P002 (qa-pipeline state enum):** States referenced correctly in CHANGELOG/HANDOFF. DEFER.
- **S91 P003 (KBP advisory to structural):** Archetypes removed. qa-pipeline.md now clearer. Momentum brake hooks provide structural enforcement. PARTIALLY RESOLVED.
- **S91 P004/P005:** No action needed. Still valid assessments.

---

## Evolution Metrics (vs S91 and S82 baseline)

| Metric | S82 baseline | S91 | S108 | Trend |
|--------|-------------|-----|------|-------|
| User corrections/session | 2.0 | 0.0 | 1.33 | Improving (real workloads now tested) |
| KBP violations/session | 3.05 | 0.0 | 0.89 | Improving |
| Tool errors | 61 | 0 | 0 | Stable at zero |
| Retries | 9 | 0 | 0 | Stable at zero |
| New KBPs | 5 | 0 | 2 | System learning |
| Proposals | 6 accepted | 5 proposed | 3 proposed | -- |

**Interpretation:** S91 showed zero incidents but was all planning/infra -- a false calm. S108 is the first stress test with real QA, slide authoring, and research. Corrections resurfaced but at 1.33/session (vs 2.0 baseline) and concentrated in S103-S104 before hook fixes took effect. S105-S107 show zero KBP-01 violations, suggesting the structural enforcement is working. The system demonstrated in-session learning: KBP-07 was created from a real failure in S104.

**Caution:** 2 of the 7 KBPs (KBP-04, KBP-05) were not tested in this period. Next QA session with batch slides or criteria evaluation will be the definitive test.

---

## Structured JSON Output

```json
{
  "insights_run": "2026-04-07",
  "sessions_analyzed": 9,
  "proposals": [
    {
      "id": "P001",
      "category": "RULE_VIOLATION",
      "title": "QA pipeline pre-read gate",
      "target_file": ".claude/rules/qa-pipeline.md",
      "priority": "medium",
      "frequency": 2,
      "draft": "## 0. Pre-Read Gate (OBRIGATORIO antes de qualquer avaliacao)\nANTES de avaliar qualquer slide, o agente DEVE:\n1. Ler qa-pipeline.md Steps 3-5 (este arquivo)\n2. Ler design-reference.md secoes 1-2 (cor semantica, tipografia)\n3. Ler slide-rules.md secao 2 (checklist pre-edicao)\nSe o agente nao leu estes 3 arquivos na sessao atual, PARAR e ler antes de avaliar."
    },
    {
      "id": "P002",
      "category": "PATTERN_REPEAT",
      "title": "KBP-01 momentum brake post-fix status update",
      "target_file": ".claude/rules/known-bad-patterns.md",
      "priority": "low",
      "frequency": 5,
      "draft": "**Post-S102 status:** 3 hook bugs fixed (B5-02/04/05). S105-S107: 0 recurrences. Hooks structurally enforce ask-before-act. Monitor S109+."
    },
    {
      "id": "P003",
      "category": "SKILL_UNDERTRIGGER",
      "title": "Insights SCAN phase false positive filter for skill invocations",
      "target_file": ".claude/skills/insights/SKILL.md",
      "priority": "low",
      "frequency": 2,
      "draft": "**Known false positives:** Skill invocations (via Skill tool) inject the SKILL.md content as user messages. Grep hits on these are noise -- filter out messages starting with 'Base directory for this skill:' or containing SKILL.md header patterns."
    }
  ],
  "kbps_to_add": [],
  "pending_fixes_to_add": [],
  "metrics": {
    "rule_violations": 6,
    "user_corrections": 12,
    "retries": 0,
    "patterns_resolved_since_last": 2,
    "patterns_new": 0
  }
}
```

---

Coautoria: Lucas + Opus 4.6 | S108 2026-04-07
