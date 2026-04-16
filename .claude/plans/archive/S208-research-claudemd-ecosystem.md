# CLAUDE.md Ecosystem Research — Findings for Redesign

## Executive Summary

Your current OLMO ecosystem has **~1,178 lines across 14 files** (~51KB total). This is significantly above every benchmark found. The research converges on a single principle: **less instruction, properly chosen, produces more compliance**. Your ecosystem is at maturity Level 5-6 (highest documented), but suffers from the primary failure mode of advanced setups: context pollution from over-instrumentation.

---

## 1. Hard Numbers: The Instruction Budget

| Metric | Value | Source |
|--------|-------|--------|
| Model instruction capacity | ~150-200 discrete instructions | Multiple sources, community consensus |
| System prompt consumption | ~50 instructions (4,200 tokens) | Anthropic context window visualization |
| Remaining budget for YOU | **100-150 instructions** | Derived |
| Anthropic recommended CLAUDE.md size | **Under 200 lines** | Official docs (code.claude.com/docs/en/memory) |
| Optimal performance range | **300-350 words** (~80-100 lines) | Analysis of 2,500+ AGENTS.md repos |
| Diminishing returns begin | **500+ words** | Same study |
| Negative correlation with performance | **1,000+ words** | Same study |
| Your current total | **~1,178 lines / ~51KB** | Measured |

**Key finding:** "Past that threshold, degradation is uniformly distributed -- every low-value rule added dilutes the compliance probability of every high-value rule equally." There is no "this rule is important enough to keep." Every rule competes with every other rule for attention.

---

## 2. Context Window Token Economics (Anthropic Official)

Startup token allocation for a typical session:

| Component | Tokens | % of 200K |
|-----------|--------|-----------|
| System prompt | 4,200 | 2.1% |
| Auto memory (MEMORY.md) | 680 | 0.3% |
| Environment info | 280 | 0.1% |
| MCP tools (deferred) | 120 | 0.06% |
| Skill descriptions | 450 | 0.2% |
| ~/.claude/CLAUDE.md | 320 | 0.16% |
| Project CLAUDE.md | 1,800 | 0.9% |
| .claude/rules/* (unconditional) | loads at startup | varies |
| Path-scoped rules | on-demand only | varies |
| Auto-compact buffer | 33,000 | 16.5% |
| **Total overhead before first prompt** | **~40,000+** | **~20%+** |

Your OLMO ecosystem likely consumes **~15,000-20,000 tokens** in rules alone (51KB of markdown), eating into the 167K usable conversation space before you type anything.

---

## 3. Why Rules Get Ignored — The Three Mechanisms

From Yajin Zhou's empirical analysis ("Why AI Agents Break Their Own Rules"):

### Mechanism 1: Attention Allocation Under Load
When multiple requests arrive, Claude prioritizes task completion over process compliance. Explicit requests outweigh configuration-file rules.

### Mechanism 2: Context Compaction Memory Decay
Compaction preserves **"what to do"** (task objectives) while deprioritizing **"how to do it"** (process standards). Your behavioral discipline rules (elite-conduct, anti-drift) are the FIRST things lost during compaction.

### Mechanism 3: Probabilistic Risk Assessment
Claude performs internal judgment calls on rule importance. It reads your explicit rules, then decides whether the situation qualifies for exemption. Rules function as **"suggestions" not "laws"** -- Claude can selectively disregard them.

**Implication for OLMO:** Your most elaborate rules (elite-conduct's [EC] checkpoint, anti-drift's momentum brake, delegation gate) are precisely the type that gets ignored under load. They're process-oriented, require contextual judgment, and are buried in long files.

---

## 4. What Makes Rules Effective vs. Ineffective

### Rules that STICK:
- Ultra-concise (5-10 lines per topic)
- Binary, non-negotiable constraints ("ALWAYS X" / "NEVER Y")
- Positive framing ("Use named exports") > Negative framing ("Don't use default exports")
- Positioned at top or bottom of file (primacy/recency bias)
- Backed by hooks (deterministic enforcement)
- Specific enough to verify ("2-space indentation" not "format properly")

### Rules that GET IGNORED:
- Long, detailed rule sets (200+ lines showed "very low rule compliance")
- Process-oriented rules ("stop and reflect before editing")
- Rules requiring contextual judgment
- Middle-positioned rules in long files
- Rules Claude can infer from code (waste of instruction budget)
- Negative rules ("Do NOT...") -- models struggle with negation

### The Paradox:
Your most carefully crafted rules (elite-conduct's 3-question loop, anti-drift's momentum brake) are architecturally in the LEAST effective category: process-oriented, requiring judgment, buried in long files.

---

## 5. Anthropic's Official Guidance (Consolidated)

From code.claude.com/docs/en/memory and code.claude.com/docs/en/best-practices:

### What to include:
- Bash commands Claude can't guess
- Code style rules that differ from defaults
- Testing instructions and preferred test runners
- Repository etiquette (branch naming, PR conventions)
- Architectural decisions specific to your project
- Developer environment quirks (required env vars)
- Common gotchas or non-obvious behaviors

### What to EXCLUDE:
- Anything Claude can figure out by reading code
- Standard language conventions Claude already knows
- Detailed API documentation (link to docs instead)
- Information that changes frequently
- Long explanations or tutorials
- File-by-file descriptions of the codebase
- Self-evident practices like "write clean code"

### Key quotes from official docs:
- "Keep it concise. For each line, ask: 'Would removing this cause Claude to make mistakes?' If not, cut it."
- "Bloated CLAUDE.md files cause Claude to ignore your actual instructions!"
- "If Claude keeps doing something you don't want despite having a rule against it, the file is probably too long and the rule is getting lost."
- "Unlike CLAUDE.md instructions which are advisory, hooks are deterministic and guarantee the action happens."
- "Treat CLAUDE.md like code: review it when things go wrong, prune it regularly, and test changes by observing whether Claude's behavior actually shifts."

---

## 6. How Anthropic Structures Their Own CLAUDE.md

The `anthropics/claude-code-action` repository's CLAUDE.md is ~60 lines covering:
1. **Commands** -- 4 lines of build/test commands
2. **What This Is** -- 1 paragraph of architecture
3. **How It Runs** -- 1 paragraph of execution flow
4. **Key Concepts** -- 3 bullet points on auth, modes, prompts
5. **Things That Will Bite You** -- 5 specific gotchas
6. **Code Conventions** -- 4 bullet points

No behavioral rules. No process enforcement. No meta-rules about how to write rules. Just **facts that Claude can't infer from code**.

---

## 7. The Maturity Framework (Meszaros, 2026)

| Level | Description | OLMO Status |
|-------|-------------|-------------|
| L0: Absent | No instruction file | -- |
| L1: Basic | File exists, tracked in VCS | Past this |
| L2: Scoped | Explicit MUST/MUST NOT constraints | Past this |
| L3: Structured | Multiple files, main file as router | Past this |
| L4: Abstracted | Path-scoped loading for different areas | **Partially** (no path-scoped rules) |
| L5: Maintained | Active upkeep, regular reviews | **Yes** |
| L6: Adaptive | Dynamic skill loading, MCP integration | **Yes** |

OLMO is L5-L6 in maturity but L1-L2 in effectiveness because the sheer volume overwhelms the instruction budget.

---

## 8. Self-Improvement Loops That Actually Work

### What works (Addy Osmani, claude-meta project, community evidence):
1. **Atomic task execution** with memory persistence (git history, progress logs, task state)
2. **Session-based learning**: mistake in session N becomes rule for session N+1 (but ONLY if concise)
3. **Binary eval criteria**: 4-6 yes/no questions, not subjective assessments
4. **Lead-by-example**: maintain high-quality tests/code; Claude mimics patterns it sees
5. **Progressive sophistication**: session 1 catches basic mistakes, session 3+ catches architectural issues

### What doesn't work:
1. **Accumulating rules without pruning** -- the main anti-pattern. Each `/insights` adds "clarity" without checking if the instruction budget is exceeded
2. **Naive parallel agents** -- get stuck or become risk-averse
3. **Context bloat from memory files** -- must keep MEMORY.md focused and periodically archived
4. **Rules about rules** (meta-rules) -- consume instruction budget for process overhead, not task guidance
5. **Forgetfulness without injection** -- memory files only help if actually loaded and read

### The OLMO-specific risk:
Your `/insights` and `/dream` systems add rules over time. The known-bad-patterns.md already has 21 KBPs. Each one consumes instruction budget. The self-improvement loop is working as designed but the OUTPUT of the loop (more rules) is degrading the system it's trying to improve. This is a classic feedback loop instability.

---

## 9. The Hooks vs Rules Decision Framework

| Need | Mechanism | Why |
|------|-----------|-----|
| MUST happen every time, zero exceptions | **Hook** | Deterministic. Cannot be ignored. |
| Style preference, usually right | **CLAUDE.md rule** | Advisory but effective if concise |
| Domain-specific, only relevant sometimes | **Path-scoped rule** | Loads on demand, saves budget |
| Multi-step workflow, invoked explicitly | **Skill** | Not loaded until invoked |
| Reference documentation | **@import** or skill | Not in startup context |

**Anthropic's own framing:** "CLAUDE.md = probably listens. Hook = always enforces." Move everything non-negotiable to hooks; everything negotiable to concise rules.

---

## 10. Architectural Pattern: Orthogonal Context Loading

The CloudRepo case study (13 CLAUDE.md files, 12 agents, 28 skills) achieved:
- **~15% of total documented context loads for any given task**
- **~85% remains unloaded** during typical assignments

They organize by directory hierarchy:
- Root CLAUDE.md: universal conventions only (~50 lines)
- Directory-level CLAUDE.md: domain-specific (frontend/, backend/, infra/)
- Path-scoped rules: file-type specific (*.test.ts, src/api/**)
- Skills: workflow-specific, loaded on demand

This is the opposite of OLMO's current pattern where ALL rules load for EVERY session regardless of task.

---

## 11. Recommendations for OLMO Redesign

### Phase 1: Audit & Triage (immediate)
For each rule in the current ecosystem, ask three questions:
1. **Does Claude make this mistake WITHOUT the rule?** If not, delete it.
2. **Is this a FACT or a PROCESS?** Facts stay; processes move to hooks or get deleted.
3. **Is this UNIVERSAL or DOMAIN-SPECIFIC?** Universal stays in CLAUDE.md; domain-specific moves to path-scoped rules or skills.

### Phase 2: Restructure (after audit)
Target architecture:
- `CLAUDE.md`: **50-80 lines max**. Build commands, architecture, 5-10 critical gotchas. Facts only.
- `.claude/rules/`: **Path-scoped rules** with YAML frontmatter. Load only when relevant.
- `.claude/skills/`: Multi-step workflows (QA pipeline, research, etc.) -- loaded on demand.
- Hooks: All non-negotiable enforcement (file protection, format checks, etc.) -- already strong.
- Auto memory: Let Claude learn organically; prune periodically.

### Phase 3: Measure (ongoing)
- Run `/context` at session start to see actual token consumption
- Track rule violations per session -- if a rule is violated consistently, it's either too long (lost in noise) or should be a hook
- Review rule effectiveness every 5 sessions: delete rules that aren't needed, promote effective rules to hooks

### What to CUT from current ecosystem:
- **elite-conduct.md** (120 lines): The [EC] checkpoint is a process rule requiring judgment. Claude ignores these under load. Move to hook (pre-edit linter) or accept it's advisory.
- **anti-drift.md** (149 lines): Largest file. Most rules are meta-process. Consolidate to 10-15 critical lines; move enforcement to hooks.
- **known-bad-patterns.md** (73 lines): Currently a pointer index. Keep but freeze -- stop accumulating KBPs unless one gets deleted first.
- **session-hygiene.md** (64 lines): Most of this is process Claude can infer or that hooks enforce. Reduce to 10 lines.
- **proven-wins.md** (43 lines): Meta-framework about frameworks. Claude doesn't need a maturity model for rules -- it needs rules.

### What to KEEP:
- Build commands and architecture (from CLAUDE.md)
- Coauthorship rule (31 lines, specific, verifiable)
- MCP safety (50 lines, specific, prevents real errors)
- Hook configurations (already deterministic)
- Path-scoped rules for slides (design-reference, slide-rules) -- but only if scoped to `content/aulas/**`

---

## Sources

### Official Anthropic Documentation
- [Best Practices for Claude Code](https://code.claude.com/docs/en/best-practices) -- Anthropic's official guide
- [How Claude remembers your project](https://code.claude.com/docs/en/memory) -- Official CLAUDE.md docs
- [Explore the context window](https://code.claude.com/docs/en/context-window) -- Token economics visualization
- [How Anthropic teams use Claude Code](https://claude.com/blog/how-anthropic-teams-use-claude-code) -- Internal practices
- [claude-code-action CLAUDE.md](https://github.com/anthropics/claude-code-action/blob/main/CLAUDE.md) -- Anthropic's own example

### Research & Analysis
- [Why AI Agents Break Their Own Rules](https://yajin.org/blog/2026-03-22-why-ai-agents-break-rules/) -- Three mechanisms of rule-breaking
- [Your CLAUDE.md Is Probably Too Long](https://tianpan.co/blog/2026-02-14-writing-effective-agent-instruction-files) -- Instruction budget analysis
- [Self-Improving Coding Agents](https://addyosmani.com/blog/self-improving-agents/) -- Addy Osmani's comprehensive guide
- [Context Buffer Management](https://claudefa.st/blog/guide/mechanics/context-buffer-management) -- 33K-45K buffer analysis
- [Rules Directory Analysis](https://claudefa.st/blog/guide/mechanics/rules-directory) -- Path-scoped rules deep dive

### Community Best Practices
- [5 Patterns That Make Claude Code Follow Rules](https://dev.to/docat0209/5-patterns-that-make-claude-code-actually-follow-your-rules-44dh) -- Empirical patterns
- [CLAUDE.md: From Basic to Adaptive](https://dev.to/cleverhoods/claudemd-best-practices-from-basic-to-adaptive-9lm) -- Maturity framework (L0-L6)
- [Stop Blaming Claude, Your Context Window is the Problem](https://www.cloudrepo.io/articles/stop-blaming-claude-context-window-optimization) -- Orthogonal architecture
- [Claude Code Best Practices from Real Projects](https://ranthebuilder.cloud/blog/claude-code-best-practices-lessons-from-real-projects/) -- Practical lessons
- [claude-meta: Self-Improving CLAUDE.md](https://github.com/aviadr1/claude-meta) -- Self-improvement architecture

### Curated Collections
- [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) -- Curated list of skills, hooks, agents
- [awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit) -- Comprehensive toolkit
- [claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice) -- Best practice examples
