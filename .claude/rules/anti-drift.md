# Anti-Drift

> Declare intent. Follow the plan. Implement only what was asked.

## Transparency
- State WHAT and WHY before acting. Make technical choices visible: "I chose X because Y."
- When uncertain, say so and ask. Fabrication is never valid.

## Scope
- Implement exactly what requested. Adjacent code untouched. One concern per commit.
- Research pinned to specific deliverable named in request. Scope expansion requires explicit ask.
- Scope reductions: report skipped items in HANDOFF with reason. Silent skips = drift.

## Failure response (KBP-07)
1. Read COMPLETE error message
2. Diagnose ROOT CAUSE (verify before claiming)
3. Report: what failed, why, evidence
4. List options (retry / fix root cause / defer / do nothing)
5. STOP — wait for Lucas

## Momentum brake
After any discrete action: STOP and report result. Next step requires explicit instruction.
Exception: within approved multi-step plan where all steps listed upfront.

## Delegation gate (KBP-17)
Before ANY Agent spawn, 3 questions:
1. Read/Grep/Glob resolves directly? → SKIP agent
2. Lucas gave specific files/PMIDs/paths? → SKIP agent, read what he cited
3. Agent brings concrete gain (parallelism + massive context + exclusive tool)? No named reason → SKIP
4. Agent produces research → result written to plan file BEFORE reporting to user. Context is volatile, plan file persists.

## First-turn discipline (KBP-23)
First response after /clear already loads ~25KB auto-content (CLAUDE.md + rules + skills list + HANDOFF + MCP instructions). Additional tool use compounds. Discipline:
1. **Read with `limit`:** files >100 lines → `limit: 50` first. Expand only after targeted Grep locates the relevant range.
2. **Skill invocation gate:** heavy skills (>100 li — systematic-debugging, /dream, brainstorming, frontend-design) only when task explicitly requires the framework. Read-only audits use direct logic.
3. **ToolSearch targeted:** fetch schemas only for tools about to be called in THIS turn. No prefetch.
4. **Agent dispatch for broad scans:** 3+ Reads + 2+ Greps in unknown area → delegate to Explore/general-purpose. Agent returns ~2KB report vs 30-50KB raw content.

## Verification
1. Identify verification command (test, build, lint, manual check)
2. Execute fully. Read complete output.
3. Confirm output matches your claim. Only then assert.

File not found → Glob. Error → read actual message. Claim about code → read the file.
Claim about state → read source-of-truth file. Claim about history → `git log -S` / `git blame`.

## State files (HANDOFF, CHANGELOG, BACKLOG)
- NEVER rewrite with Write. Use Edit to add/modify specific sections.
- Write overwrites silently — forgotten sections vanish without warning.
- Before touching a state file: Read it, list sections present, verify all sections survive after edit.
- Adding S(N) content: append new section, do NOT remove S(N-1) history unless anti-drift §Session docs explicitly says to.

## EC loop (pre-action gate)
Before EACH Edit/Write, answer visibly:
```
[EC] Verificacao: <what I checked>
[EC] Mudanca: <1 sentence>
[EC] Elite: <(1) por que esta abordagem e melhor que alternativas, (2) o que seria mais profissional>
```
"Elite: sim" PROIBIDO — must contain: (1) por que esta abordagem e melhor que alternativas descartadas, (2) o que um engenheiro de elite faria diferente. Reflexao de seguranca nao basta — reflexao de excelencia. Enforced por Stop[0] silent execution check (S219).
CSS/GSAP changes: verification includes screenshot via `qa-capture.mjs`.
Touching a CSS section: audit ENTIRE section (raw px, off-palette, redundant tokens — KBP-21).

## Session docs
- **HANDOFF.md:** pendencias only, max ~50 lines. No history — only future.
- **CHANGELOG.md:** append-only, 1 line per change.
- Update both every session with commits/state changes.
- P0 items in HANDOFF: surface to Lucas at session start before feature work.

## Script primacy
Scripts in `content/aulas/scripts/` are canonical. Agents reference, never reimplement.

## Budget
Local first (regex, cache, file search) before API. Cheapest model that solves the task.
