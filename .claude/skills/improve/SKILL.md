---
name: improve
disable-model-invocation: true
description: "System-wide improvement cycle — health snapshot, double-loop rule audit, cross-component synthesis, NeoSigma trend. Connects /dream (memory), /insights (retrospective), sentinel (scan), backlog, and self-healing into one nervous system. Use when user says /improve, 'system health', 'improvement cycle', 'audit the system', 'double-loop', or 'how healthy is the project'."
version: 1.0.0
context: fork
agent: general-purpose
allowed-tools: Read, Grep, Glob, Bash
---

# Improve — System-Wide Improvement Cycle

> The nervous system that connects the organs.
> /dream consolidates memory. /insights reviews sessions. sentinel scans code.
> /improve connects them all and questions whether the system itself is improving.

Operate on: `$ARGUMENTS` (mode). Default: `health`.

## What This Skill Is NOT

- NOT a replacement for /dream (memory) or /insights (retrospective) or sentinel (code scan)
- NOT an auto-fixer. Every proposal requires Lucas's approval
- NOT a code review tool. It reviews the improvement SYSTEM, not the code

## Modes

### `/improve health` (default, ~5 min)

Quick system health snapshot. Read these files and synthesize:

1. **Failure registry:** `.claude/skills/insights/references/failure-registry.json`
   - Last run date, rolling averages, trend direction
   - If regression detected: flag prominently

2. **Backlog:** `.claude/BACKLOG.md`
   - Total items, open vs resolved, oldest open item
   - Items older than 15 sessions without progress

3. **KBPs:** `.claude/rules/known-bad-patterns.md`
   - Total count, any marked RESOLVED
   - Cross-check: does each pointer target still exist? (Glob the path)

4. **Infrastructure counts:** Verify against HANDOFF.md claims
   - `ls .claude/agents/*.md | wc -l` (agents)
   - `ls .claude/skills/*/SKILL.md | wc -l` + `ls ~/.claude/skills/*/SKILL.md | wc -l` (skills)
   - `grep -c '"command"' .claude/settings.local.json` (approximate hook count)
   - `ls .claude/rules/*.md | wc -l` (rules)

5. **Self-healing:** `.claude/pending-fixes.md`
   - Any outstanding fixes? How old?

6. **Dream/Insights recency:**
   - `cat ~/.claude/projects/*/memory/.last-dream 2>/dev/null` (when last dream ran)
   - `cat .claude/.last-insights 2>/dev/null` (when last insights ran)

Output: a structured dashboard with health indicators (OK / STALE / REGRESSION / MISSING).

### `/improve audit` (~15 min)

Double-loop learning. The only component that QUESTIONS existing rules.

For each KBP in `known-bad-patterns.md`:
1. Read the pointer target
2. Search recent session transcripts (last 7 days) for evidence of:
   - **Correctly applied:** pattern was caught and avoided
   - **False positive:** pattern triggered but the action was actually correct
   - **False negative:** pattern should have triggered but didn't
   - **Irrelevant:** pattern covers something that never came up
3. Propose: KEEP / MODIFY (with draft) / DEPRECATE (with rationale)

For each rule in `.claude/rules/`:
1. Check: do all referenced files/paths still exist?
2. Check: was this rule relevant in the last 10 sessions? (grep session transcripts)
3. If no evidence of relevance in 10+ sessions: flag as candidate for review

For each skill in `.claude/skills/*/SKILL.md`:
1. Check: was this skill invoked in the last 10 sessions? (grep for skill name in transcripts)
2. If never invoked: flag as candidate for description improvement or archival

Output: compliance matrix + staleness report + proposals.

### `/improve trend` (~10 min)

NeoSigma analysis of the failure registry.

1. Read `failure-registry.json`
2. Compute 5-session rolling averages for:
   - User corrections per session
   - KBP violations per session
   - Tool errors per session
3. Direction: improving / stable / regressing
4. If regressing: identify which metric is driving the regression
5. Cross-reference with recent /insights proposals: were accepted proposals effective?

Output: trend chart (ASCII), direction, analysis.

### `/improve cycle` (~30 min)

Full cycle: health → audit → trend → synthesis.

Runs all three modes sequentially, then adds a synthesis phase:
- Cross-reference findings across all three
- Identify patterns that appear in 2+ components (convergent evidence)
- Identify contradictions between components
- Produce a unified prioritized action list

## Gotchas

- Session transcripts are in `~/.claude/projects/C--Dev-Projetos-OLMO/` as .jsonl files. Use `find` + targeted `grep`, never full reads.
- Grep false positives: skill invocations inject SKILL.md content as user messages. Filter messages containing SKILL.md headers.
- HANDOFF.md counts (agents, hooks, skills) may be stale. Always verify by counting actual files.
- failure-registry.json may not exist yet. If missing, report "No failure registry — run /insights first."
- Rules use Format C+ (pointer-only). The pointer target is what to audit, not the pointer itself.
- NEVER modify rules, skills, hooks, or memory. Report proposals. Lucas decides.
- Double-loop is not about finding MORE rules. It's about finding WRONG rules. Via Negativa: removing a bad rule > adding a good one.

## Safety

- Read-only by default. This skill NEVER writes files.
- Session transcripts are sensitive. Paraphrase, never quote user messages verbatim.
- Proposals are suggestions. Lucas decides what to implement.
- If the system is healthy: say so. Don't invent problems to justify the skill's existence.
