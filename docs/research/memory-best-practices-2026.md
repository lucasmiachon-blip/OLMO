# Memory Best Practices for Claude Code (April 2026)

Research report for OLMO project memory governance.
Date: 2026-04-06 | Session: S83
Coautoria: Lucas + Opus 4.6

---

## Table of Contents

1. [Claude Code Auto Memory — Official Architecture](#1-claude-code-auto-memory--official-architecture)
2. [Auto Dream and Memory Consolidation](#2-auto-dream-and-memory-consolidation)
3. [Memory vs CLAUDE.md vs Rules — When to Use Each Layer](#3-memory-vs-claudemd-vs-rules--when-to-use-each-layer)
4. [Memory Governance Patterns](#4-memory-governance-patterns)
5. [Community Memory Tools and Extensions](#5-community-memory-tools-and-extensions)
6. [Common Anti-Patterns](#6-common-anti-patterns)
7. [Advanced Patterns](#7-advanced-patterns)
8. [KAIROS and Future Directions](#8-kairos-and-future-directions)
9. [Assessment of OLMO's Memory System](#9-assessment-of-olmos-memory-system)
10. [Recommendations](#10-recommendations)

---

## 1. Claude Code Auto Memory — Official Architecture

### How Auto Memory Works

Claude Code has two complementary persistence mechanisms:

| Property          | CLAUDE.md files                    | Auto Memory (MEMORY.md)                        |
|:------------------|:-----------------------------------|:------------------------------------------------|
| Who writes it     | You                                | Claude                                          |
| What it contains  | Instructions and rules             | Learnings and patterns                          |
| Scope             | Project, user, or org              | Per working tree (shared across worktrees)      |
| Loaded into       | Every session (full file)          | Every session (first 200 lines OR 25KB)         |
| Use for           | Coding standards, workflows, arch  | Build commands, debugging insights, preferences |

Auto memory is **on by default** since v2.1.59. Claude decides what to save based on whether the
information would be useful in a future conversation. Not every session triggers a write.

### Loading Rules (Critical Constraints)

- **MEMORY.md**: first 200 lines OR first 25KB (whichever comes first) loaded at session start
- **Topic files** (e.g., `debugging.md`, `patterns.md`): NOT loaded at startup; read on demand
- **CLAUDE.md files**: loaded in full regardless of length (shorter = better adherence)
- **`.claude/rules/*.md`**: loaded at startup (unconditional) or on file access (path-scoped)

The 200-line cap is the single most important architectural constraint. Everything after line 200
is invisible to Claude unless it deliberately reads the file. This means MEMORY.md must function
as an **index of pointers**, not a document store.

### What Claude Saves (and Doesn't)

**Saves:** build commands, debugging insights, architecture notes, code style preferences,
workflow habits, corrections you make, patterns it discovers.

**Doesn't save:** obvious code facts (it reads files directly), session-specific details
(ephemeral), things already in CLAUDE.md (avoids duplication).

### Storage Location

`~/.claude/projects/<project>/memory/` — derived from git repo root. All worktrees share one
directory. Machine-local, not synced across machines or cloud.

Configurable via `autoMemoryDirectory` in user/local settings (not project settings, for security).

### Retrieval Mechanism

Per source code analysis: **grep-only retrieval**. No semantic search, no embeddings, no vector
store. Claude finds topic files by reading the MEMORY.md index and then using its standard file
tools. This means:

- **Keywords matter**: the index line must contain enough keywords to trigger retrieval
- **Semantic gaps cause misses**: if the index says "auth patterns" but you ask about "login flow",
  Claude may not find it
- **Structure is retrieval**: well-organized index > long descriptions

### Sources

- [Official docs: How Claude remembers your project](https://code.claude.com/docs/en/memory)
- [Claude Code Memory: 4 Layers of Complexity](https://dev.to/chen_zhang_bac430bc7f6b95/claude-codes-memory-4-layers-of-complexity-still-just-grep-and-a-200-line-cap-2kn9)
- [What Is Claude Code Auto-Memory (MindStudio)](https://www.mindstudio.ai/blog/what-is-claude-code-auto-memory)

---

## 2. Auto Dream and Memory Consolidation

### The Problem Dream Solves

Auto memory accumulates over time. Without consolidation, it develops:
- Relative timestamps that become meaningless ("yesterday we decided X")
- Contradictions from decision reversals
- Stale entries about deleted files or abandoned approaches
- Duplicate entries from multiple sessions noticing the same thing

### How Auto Dream Works — 4 Phases

| Phase          | Action                                                                   |
|:---------------|:-------------------------------------------------------------------------|
| 1. Orient      | Reads memory directory + MEMORY.md index to understand current state     |
| 2. Gather      | Scans session transcripts (JSONL) for corrections, preferences, patterns |
| 3. Consolidate | Merges findings, converts relative→absolute dates, resolves contradictions |
| 4. Prune/Index | Rebuilds MEMORY.md under 200 lines, removes dead pointers               |

### Activation Triggers (Dual-Gate)

Both conditions must be true:
1. **24+ hours** since last dream cycle
2. **5+ sessions** since last dream cycle

This prevents unnecessary consolidation on light-use projects while ensuring active projects
get regular cleanup. Manual triggering via `/dream` bypasses both gates.

### Safety Guarantees

- Read-only access to project code (can only modify memory files)
- Lock file prevents concurrent consolidation
- Background execution — does not block active sessions
- Performance: one case consolidated 913 sessions in ~8-9 minutes

### OLMO's Custom Implementation

OLMO uses a **custom /dream skill** with a cron-like trigger:
- `~/.claude/.dream-pending` flag file created by OS scheduler every 24h
- Session start checks for flag → runs /dream as background subagent → deletes flag
- Advantage: runs in a fresh context window, not at the end of a long degraded session

This is a **good pattern** — community consensus confirms dream should run fresh, not fatigued.

### Sources

- [Auto Dream Technical Architecture (claudefa.st)](https://claudefa.st/blog/guide/mechanics/auto-dream)
- [Auto Memory and Auto Dream (antoniocortes.com)](https://antoniocortes.com/en/2026/03/30/auto-memory-and-auto-dream-how-claude-code-learns-and-consolidates-its-memory/)
- [Does Claude Code Need Sleep? (DEV Community)](https://dev.to/akari_iku/does-claude-code-need-sleep-inside-the-unreleased-auto-dream-feature-2n7m)

---

## 3. Memory vs CLAUDE.md vs Rules — When to Use Each Layer

### The Three-Layer Model

```
CLAUDE.md (static, you write)
    "How I want Claude to operate"
    Loaded: always, in full
    Stability: high — changes rarely

.claude/rules/ (static, you write, topic-scoped)
    "How I want Claude to operate in context X"
    Loaded: always (no paths:) or on file access (with paths:)
    Stability: high

Auto Memory (dynamic, Claude writes)
    "What Claude has learned about this project"
    Loaded: MEMORY.md index always, topic files on demand
    Stability: medium — evolves with project
```

### Decision Matrix

| Content type                          | Where it belongs       | Why                                              |
|:--------------------------------------|:-----------------------|:-------------------------------------------------|
| Coding standards, style rules         | CLAUDE.md / rules      | Stable, universal, your authority                 |
| Build commands, test commands         | Auto memory            | Claude discovers + remembers automatically        |
| Architecture decisions (active)       | Auto memory (project)  | Evolves; promotes to CLAUDE.md when stable        |
| User preferences, communication style | CLAUDE.md (global)     | Stable across all projects                        |
| Debugging gotchas (non-obvious)       | Auto memory (feedback) | Claude discovers; may promote to rules if durable |
| External system pointers              | Auto memory (reference)| Changes when systems change                       |
| Recurring errors → corrections        | Auto memory → rule     | Start as memory, promote to rule if durable       |
| Ephemeral task state                  | HANDOFF.md / plans/    | Never in memory — too volatile                    |

### The Promotion Pipeline

```
Observation in session
    → Auto memory (feedback/project)
        → Durable correction? → .claude/rules/
            → Universal? → CLAUDE.md
```

OLMO already implements this implicitly ("Rules > memory" in `project_self_improvement.md`).
Making it explicit improves governance.

### Key Insight: CLAUDE.md is Not Enforced

CLAUDE.md content is delivered as a **user message after the system prompt**, not as part of the
system prompt. Claude actively judges relevance and may skip instructions it deems irrelevant.
Shorter, more specific instructions = higher adherence.

### Sources

- [3-Layer Architecture (Medium)](https://medium.com/@martin_50671/the-3-layer-architecture-that-made-my-claude-code-actually-useful-59b68efa88a8)
- [Claude Code Memory Explained (Substack)](https://joseparreogarcia.substack.com/p/claude-code-memory-explained)
- [Stop Repeating Yourself (Medium)](https://medium.com/@richardhightower/save-hours-stop-repeating-yourself-to-claude-skills-rules-memory-and-when-to-use-each-93ce3cf83aa8)

---

## 4. Memory Governance Patterns

### File Caps

No official cap exists. Community consensus:

| Project scale     | Recommended cap | Rationale                                          |
|:------------------|:----------------|:---------------------------------------------------|
| Small (1 person)  | 10-15 files     | Minimizes index bloat                              |
| Medium (OLMO)     | 15-20 files     | Enough coverage without context pollution          |
| Large (team)      | 20-30 files     | Needs path-scoped rules to compensate              |

OLMO's cap of **20 files** aligns with community best practice for a mature single-developer
project. The current **16 files** leaves healthy headroom.

### Review Cadence

| Source                          | Recommended cadence                              |
|:--------------------------------|:-------------------------------------------------|
| OLMO (current)                  | Every 3 sessions                                 |
| Community (theta55, GitHub)     | Monthly manual audit + continuous auto-dream      |
| Community (yurukusa, 140+ hrs)  | After major refactors + every 2 weeks            |
| Anthropic (official docs)       | "Review auto memory periodically"                |

Every-3-sessions is **aggressive but appropriate** for a project evolving as fast as OLMO.
Consider relaxing to every-5-sessions as the project stabilizes.

### Temporal Invalidation Patterns

Community-validated patterns for preventing stale memories:

**1. `review_by` frontmatter** (proposed in GitHub #34776):
```yaml
---
review_by: 2026-06-01
last_challenged: 2026-04-06
---
```
- `review_by`: date, event trigger ("after migration"), or "Durable" (permanent)
- `last_challenged`: last time the memory was verified against reality

**2. Confidence ratings**:
```yaml
---
confidence: high  # high (verified), medium (useful framework), low (hypothesis)
---
```

**3. Absolute dates**: Dream should convert "yesterday" → "2026-04-05". This prevents temporal
confusion as memories age.

**4. Memory type decay rates** (from external memory systems, informational):
- Architecture, decisions, patterns, gotchas: **permanent** (no decay)
- Progress: **7-day half-life**
- Context: **30-day half-life**

Claude Code's native system does not implement confidence/decay natively. These are conventions
you enforce through frontmatter and /dream logic.

### Index Management

The MEMORY.md index should follow the **index-only pattern**:
- Each line is a pointer to a topic file, not content
- Lines under 150 characters
- Grouped by type or topic
- Quick reference section for 1-2 most-used facts

OLMO's current MEMORY.md is **28 lines** — well within limits and well-structured.

### When to Merge vs Split

| Condition                                        | Action |
|:-------------------------------------------------|:-------|
| File A fits in <=3 lines inside file B           | Merge  |
| File exceeds 60 lines                            | Split  |
| Two files always consulted together               | Merge  |
| File covers 2+ unrelated topics                  | Split  |
| File hasn't been accessed in 5+ sessions         | Review for deletion |
| Content duplicates CLAUDE.md or rules             | Delete memory file  |

### Sources

- [Memory Governance Feature Request (GitHub #34776)](https://github.com/anthropics/claude-code/issues/34776)
- [Persistent Memory: What's Worth Keeping (DEV)](https://dev.to/ohugonnot/persistent-memory-in-claude-code-whats-worth-keeping-54ck)
- [Memory Optimization (claudefa.st)](https://claudefa.st/blog/guide/mechanics/memory-optimization)

---

## 5. Community Memory Tools and Extensions

### Claude-Mem (Auto-Capture Plugin)

**What:** Captures everything Claude does during sessions, compresses with Haiku, injects
relevant context into future sessions.

**Architecture:** Three-tier retrieval — L1 (lightweight index at startup), L2 (full observations
on demand), L3 (raw session records).

**When useful:** Projects where auto memory misses important operational details. Heavy tool-use
sessions where Claude's native heuristic for "worth remembering" is too conservative.

**Cost:** Uses existing Claude Code auth. Default compression model: Haiku (~$0.001/extraction).

**OLMO assessment:** Likely **overkill**. OLMO's custom /dream + memory governance + 16 files
already captures what matters. Claude-Mem's value is for users who don't curate memory manually.

### Mem0 MCP Integration

**What:** Managed memory platform with MCP server. Stores memories externally, provides semantic
search and knowledge graph (on Pro tier, $249/mo).

**Free tier:** 10,000 memories, 1,000 retrieval calls/month.

**When useful:** Multi-agent systems, customer support, healthcare apps where entity relationships
matter. Cross-tool memory (Claude + Cursor + other agents sharing one memory store).

**OLMO assessment:** **Not needed now**. OLMO is single-developer, single-tool. The overhead of
external memory management doesn't justify the benefit. Revisit if OLMO grows into a multi-machine
or multi-developer project.

### Graphiti/Zep (Temporal Knowledge Graphs)

**What:** Zep's open-source Graphiti engine builds temporal knowledge graphs where every fact has
a validity window (when it became true, when it was superseded).

**Performance:** 94.8% on Deep Memory Retrieval benchmark (vs 93.4% MemGPT). Up to 18.5%
accuracy improvement and 90% latency reduction vs baselines on LongMemEval.

**Architecture:** Neo4j + embeddings + bi-temporal model (event time + ingestion time).

**When useful:** Long-running agents that need to track how facts evolve. Domain-specific apps
(healthcare, CRM) where entity relationships are the core value.

**OLMO assessment:** **Intellectually interesting, practically premature**. The temporal validity
concept is excellent — OLMO could adopt the `review_by`/`last_challenged` convention from
GitHub #34776 to get 80% of the value at 0% of the infrastructure cost.

### MemCP (Recursive Language Model)

**What:** MCP server implementing the RLM framework — external persistent memory that stores,
organizes, and retrieves knowledge without consuming context window tokens.

**When useful:** When context window budget is the primary bottleneck. Large projects with many
memory files competing for space.

### memsearch (Milvus-backed)

**What:** Lightweight plugin using vector search for memory retrieval. Addresses the "grep-only"
limitation of native Claude Code memory.

**When useful:** When MEMORY.md keyword matching fails to retrieve relevant memories because of
semantic gaps.

### Selection Guide

| Need                                    | Tool                  | Cost      |
|:----------------------------------------|:----------------------|:----------|
| Native memory is sufficient             | Auto memory + /dream  | $0        |
| Want automatic session capture          | Claude-Mem            | ~$0.10/day|
| Need cross-tool shared memory           | Mem0 MCP              | $0-249/mo |
| Need temporal fact tracking             | Graphiti/Zep          | Infra cost|
| Need semantic memory retrieval          | memsearch             | Infra cost|
| Need external memory to save context    | MemCP                 | Infra cost|

### Sources

- [Claude-Mem (GitHub)](https://github.com/thedotmack/claude-mem)
- [Claude-Mem Guide (DataCamp)](https://www.datacamp.com/tutorial/claude-mem-guide)
- [Mem0 MCP Integration (Composio)](https://composio.dev/toolkits/mem0/framework/claude-code)
- [Memory Comparison 2026 (DEV)](https://dev.to/anajuliabit/mem0-vs-zep-vs-langmem-vs-memoclaw-ai-agent-memory-comparison-2026-1l1k)
- [Graphiti (GitHub)](https://github.com/getzep/graphiti)
- [memsearch Plugin (Milvus Blog)](https://milvus.io/blog/adding-persistent-memory-to-claude-code-with-the-lightweight-memsearch-plugin.md)

---

## 6. Common Anti-Patterns

### 1. The Documentation Trap

**Symptom:** Memory files that read like wiki articles or architecture documents.
**Why it's wrong:** Every line consumes context budget. Memory is retrieval cues, not documentation.
**Fix:** Keep entries to 1-2 lines. Reference external docs instead of duplicating.

**OLMO status:** Mostly avoids this. Some files (e.g., `user_mentorship.md` at 25 lines)
are on the verbose side but contain genuinely unique content.

### 2. Too Many Memory Files (Context Pollution)

**Symptom:** 30+ files, MEMORY.md index bloated, Claude reads irrelevant memories.
**Why it's wrong:** All index lines load every session. Each irrelevant line steals context from
useful information.
**Fix:** Cap files, merge aggressively, delete stale entries.

**OLMO status:** Good. 16 files, cap 20, well below pollution threshold.

### 3. Too Few Memory Files (Knowledge Loss)

**Symptom:** Everything crammed into 3-4 files. Files exceed 60 lines. Topics mixed.
**Why it's wrong:** Harder to find information. Harder for dream to maintain.
**Fix:** One file, one purpose. Split at 60 lines.

**OLMO status:** Good. Clear topic separation.

### 4. Stale Memories That Contradict Current Code

**Symptom:** Memory says "we use Redis" but the project switched to PostgreSQL 3 weeks ago.
**Why it's wrong:** Claude reads memory and may assert stale facts with high confidence.
**Fix:** `/dream` + `review_by` dates + periodic manual audit.

**OLMO status:** Moderate risk. No `review_by` dates. /dream runs but manual audit cadence
(every 3 sessions) is the primary defense.

### 5. Memory as Documentation (Wrong — That's CLAUDE.md's Job)

**Symptom:** Memory files containing "always do X" rules.
**Why it's wrong:** Rules belong in CLAUDE.md or `.claude/rules/`. Memory is for learned patterns.
The distinction matters: CLAUDE.md loads in full and is your authority. Memory is Claude's notes.
**Fix:** Promote durable corrections to rules. Delete the memory entry.

**OLMO status:** Some items in `feedback_*.md` files are effectively rules (e.g.,
"QA: 1 slide por vez, scripts existentes, max 2 agentes"). These could be promoted to
`.claude/rules/` for stronger adherence.

### 6. Over-reliance on Memory vs Re-reading Code

**Symptom:** Claude cites memory instead of reading current file state.
**Why it's wrong:** Memory is a point-in-time snapshot. Code is truth.
**Fix:** Include "self-distrust strategy" — instruct Claude to verify memory claims against code.

**OLMO status:** Good. The `anti-drift.md` rule already mandates verification.

### 7. Storing Ephemeral Task State in Memory

**Symptom:** "Currently working on feature X" or "TODO: fix the auth bug" in memory files.
**Why it's wrong:** Plans change too often. Memory should be stable knowledge, not task lists.
**Fix:** Use HANDOFF.md for pending work, `.claude/plans/` for active plans.

**OLMO status:** Good. HANDOFF.md + plansDirectory already handles this separation.

### 8. Duplicating CLAUDE.md Content in Memory

**Symptom:** Memory file says "use type hints" when CLAUDE.md already says the same.
**Why it's wrong:** Wastes context budget. Creates drift risk when one is updated but not the other.
**Fix:** Before creating a memory, check if the content is already in CLAUDE.md or rules.

**OLMO status:** Minor overlap exists. `project_self_improvement.md` contains some items that
overlap with CLAUDE.md conventions section.

### Sources

- [Claude Code Memory Explained (Substack)](https://joseparreogarcia.substack.com/p/claude-code-memory-explained)
- [Best Practices: Memory Management (cuong.io)](https://cuong.io/blog/2025/06/15-claude-code-best-practices-memory-management)
- [Persistent Memory: What's Worth Keeping (DEV)](https://dev.to/ohugonnot/persistent-memory-in-claude-code-whats-worth-keeping-54ck)

---

## 7. Advanced Patterns

### Memory as Retrieval Cues (Not Documentation)

The most important reframe: memory entries are **search hints**, not knowledge stores.
Claude's retrieval is grep-based. The index line needs the right keywords to trigger
Claude reading the topic file. Think of each MEMORY.md line as a search tag, not a summary.

**Example:**
```markdown
# Bad (documentation style)
- [project_auth.md](project_auth.md) — We decided on JWT auth with refresh tokens stored in
  HttpOnly cookies, replacing the previous session-based auth

# Good (retrieval cue style)
- [project_auth.md](project_auth.md) — JWT auth, refresh tokens, HttpOnly cookies, auth rewrite
```

OLMO's current index entries are **good retrieval cues** — concise with key terms.

### Progressive Memory Decay with TTL

While Claude Code doesn't natively support TTL, you can implement it conventionally:

```yaml
---
name: auth-migration-context
type: project
review_by: 2026-06-01
confidence: medium
last_challenged: 2026-04-06
---
```

Then instruct /dream to:
1. Check `review_by` dates during consolidation
2. Flag expired entries for human review
3. Downgrade `confidence` on unchallenged entries after N sessions

### Memory Versioning via Git

Memory files live in `~/.claude/projects/` which is NOT inside the git repo. This means:

- No version history by default
- No rollback capability
- Accidental deletion is permanent

**Mitigation options:**
1. Symlink memory directory into the repo (complex, breaks on clone)
2. Periodic backup via hook (`cp -r ~/.claude/projects/.../memory/ .claude/memory-snapshot/`)
3. Accept the risk — /dream can reconstruct from session transcripts

OLMO currently has **no memory versioning**. This is a gap for a project with 80+ sessions.

### Cross-Session Learning Loops

The pattern: `/insights` audits sessions → identifies patterns → writes to memory → /dream
consolidates → next session starts with updated knowledge → agent behaves better.

```
Session N → errors/corrections → /insights (weekly)
    → pattern identified → memory file created/updated
        → /dream (24h) → consolidation
            → Session N+1 → improved behavior
```

OLMO implements this loop: /insights writes to memory, /dream consolidates. The loop is active
but /insights is manual ("weekly" recommendation in skill description).

### Memory and Compaction Survival

Critical fact: **CLAUDE.md fully survives compaction**. Claude re-reads it from disk after /compact.
Memory (MEMORY.md index) also survives compaction because it's loaded at session start.

What does NOT survive compaction:
- In-conversation instructions
- Context from topic files read during the session
- Nuances from earlier in the conversation

This means: if a memory topic file was read mid-session and informed a decision, that context
is lost after compaction. The decision should be in HANDOFF.md or a plan file, not dependent
on memory re-reading.

OLMO's `context-essentials.md` + `pre-compact-checkpoint.sh` hooks already address this well.

### Memory and Subagent Memory

Since v2.1.33, subagents can maintain their own auto memory via `memory: true` frontmatter.
Each subagent gets its own persistent directory that survives across invocations.

**When useful:** Specialized agents that accumulate domain knowledge (e.g., qa-engineer learning
project-specific QA patterns, evidence-researcher learning citation conventions).

**Caution:** More memory directories = more maintenance. Only enable for agents invoked frequently
enough to benefit.

### Sources

- [Architecture of Persistent Memory (DEV)](https://dev.to/suede/the-architecture-of-persistent-memory-for-claude-code-17d)
- [Self-Improving Claude Code (GitHub Gist)](https://gist.github.com/ChristopherA/fd2985551e765a86f4fbb24080263a2f)
- [Session Memory Compaction (Anthropic Cookbook)](https://platform.claude.com/cookbook/misc-session-memory-compaction)
- [Context Engineering (Anthropic Cookbook)](https://platform.claude.com/cookbook/tool-use-context-engineering-context-engineering-tools)

---

## 8. KAIROS and Future Directions

### What Was Revealed

The March 2026 source code leak (v2.1.88) exposed 44 feature flags, including:

- **KAIROS** ("at the right time"): autonomous daemon mode with append-only logs, `<tick>` signals,
  and observe-think-act loop. Integrates with autoDream for continuous memory maintenance.
- **autoDream**: the internal name for Auto Dream. Uses the same 4-phase consolidation but with
  tighter integration into the KAIROS lifecycle.
- **BUDDY**: collaborative coding mode (pair programming with Claude)
- **Agent Swarms**: multi-agent collaboration

### What KAIROS Means for Memory

KAIROS makes Claude Code **persistent** — always running in the background, observing file changes,
thinking about the project. Memory becomes critical infrastructure rather than a nice-to-have:

- Continuous observation means more memories generated
- Need for stronger governance (caps, TTL, consolidation)
- Background dream cycles become automatic rather than triggered
- Memory becomes the primary mechanism for agent continuity

### Implications for OLMO

OLMO's current memory governance (cap 20, review every 3 sessions, custom /dream) is
**well-positioned** for KAIROS adoption. The infrastructure is already in place. When KAIROS
ships, the main changes would be:
1. Increase review frequency (continuous vs periodic)
2. Potentially increase file cap (more observations = more files)
3. Monitor memory growth rate more carefully

### Sources

- [Claude Code Source Code Leak Analysis](https://tech-insider.org/anthropic-claude-code-source-code-leak-npm-2026/)
- [KAIROS and Unreleased Features (techsy.io)](https://techsy.io/blog/claude-code-leaked-features-2026)
- [Anthropic Claude Code Leak (techresearchonline.com)](https://techresearchonline.com/news/anthropic-claude-code-leak-ai-features/)

---

## 9. Assessment of OLMO's Memory System

### Scorecard

| Dimension                        | Score | Notes                                                  |
|:---------------------------------|:-----:|:-------------------------------------------------------|
| File organization (by type)      | 9/10  | Clean prefix convention (user_, feedback_, project_, patterns_, reference_) |
| MEMORY.md as index               | 9/10  | 28 lines, pure pointers, good retrieval cues           |
| File cap governance              | 9/10  | Cap 20, currently 16, healthy headroom                 |
| Review cadence                   | 8/10  | Every 3 sessions — aggressive, appropriate for pace    |
| /dream implementation            | 9/10  | Custom skill, 24h cron trigger, runs fresh             |
| Content quality                  | 8/10  | Concise entries, good frontmatter, some verbosity      |
| Temporal invalidation            | 5/10  | No review_by dates, no confidence ratings, no TTL      |
| Memory versioning                | 3/10  | No backup, no git tracking, no rollback                |
| Promotion pipeline (memory→rule) | 6/10  | Implicit ("rules > memory") but not systematic         |
| Separation of concerns           | 8/10  | Good HANDOFF/plans/memory separation                   |
| Anti-stale mechanisms            | 7/10  | /dream + manual review, but no frontmatter metadata    |
| Subagent memory                  | 4/10  | Not enabled; 8 agents could benefit                    |
| CLAUDE.md/memory deduplication   | 7/10  | Minor overlaps exist                                   |

**Overall: 7.4/10** — Significantly above average for community practices. Main gaps are in
temporal metadata, versioning, and the promotion pipeline.

### What OLMO Does Right

1. **Index-only MEMORY.md**: 28 lines, pure pointers. Textbook implementation.
2. **Type-prefixed naming**: `feedback_`, `project_`, `patterns_`, `reference_`, `user_`.
   Makes intent clear and aids grep-based retrieval.
3. **Cap with headroom**: 20 cap, 16 used. Room to grow without emergency consolidation.
4. **Custom /dream**: 24h cron trigger, runs in fresh context. Better than end-of-session.
5. **Governance in CLAUDE.md**: Rules are codified, not just convention.
6. **Merge test**: "Does file A fit in <=3 lines inside file B?" — simple, effective.
7. **Session hygiene**: HANDOFF for ephemeral state, memory for durable knowledge.
8. **Anti-drift rule**: Verification mandate prevents stale memory from causing harm.

### What OLMO Could Improve

1. **No temporal metadata** on memory files (no `review_by`, no `last_challenged`, no `confidence`)
2. **No memory versioning** — 80+ sessions of accumulated knowledge with no backup
3. **Some feedback files are effectively rules** — should be promoted to `.claude/rules/`
4. **No subagent memory** enabled for frequently-used agents
5. **Minor CLAUDE.md/memory overlap** in `project_self_improvement.md`
6. **No memory audit command** — manual review only

---

## 10. Recommendations

### P0 — High value, low effort

**R1. Add `review_by` and `last_challenged` to all memory files.**
This is the single highest-ROI improvement. Add to frontmatter of every file:
```yaml
---
review_by: 2026-07-01  # or "Durable" for permanent entries
last_challenged: 2026-04-06
confidence: high
---
```
Teach /dream to check these dates and flag expired entries. Effort: ~30 min.

**R2. Promote durable feedback to rules.**
Review all `feedback_*.md` files. Any correction that has been stable for 3+ sessions and
applies universally should move to `.claude/rules/`. The memory entry gets deleted.
Candidates: `feedback_qa_use_cli_not_mcp.md`, `feedback_no_parameter_guessing.md`.

**R3. Add a memory backup hook.**
Add a Stop hook that periodically snapshots memory:
```bash
# In .claude/hooks/ — runs every session end
cp -r ~/.claude/projects/C--Dev-Projetos-OLMO/memory/ \
  .claude/memory-snapshots/$(date +%Y-%m-%d)/
```
Or simpler: track memory files in git via symlink or copy.

### P1 — High value, medium effort

**R4. Create a `/memory-audit` command.**
Save as `.claude/commands/memory-audit.md`:
- For each memory file: verify accuracy, check for staleness, confirm non-duplication
- Check MEMORY.md index matches actual files
- Report: files to merge, delete, promote, or update
- Update `last_challenged` on verified files

**R5. Enable subagent memory for high-frequency agents.**
Candidates: `evidence-researcher`, `qa-engineer`. These are invoked often enough to accumulate
useful domain knowledge. Add `memory: true` to their frontmatter.

**R6. Audit CLAUDE.md/memory overlap.**
Compare every memory file entry against CLAUDE.md and `.claude/rules/` content. Delete memory
entries that duplicate existing rules. Focus on `project_self_improvement.md`.

### P2 — Nice to have

**R7. Implement confidence decay in /dream.**
During dream consolidation, downgrade `confidence` on entries where `last_challenged` is >30 days
old. Entries that drop below "low" confidence get flagged for human review.

**R8. Add semantic keywords to MEMORY.md index.**
Since retrieval is grep-based, add extra keywords to index lines for common query variations:
```markdown
# Before
- [project_auth.md](project_auth.md) — JWT auth decisions

# After
- [project_auth.md](project_auth.md) — JWT auth, login, tokens, session, authentication decisions
```

**R9. Consider relaxing review cadence as project stabilizes.**
Every-3-sessions is appropriate now but will become burdensome. Move to every-5 when memory
governance is mature (after implementing R1-R4). Let /dream handle routine maintenance.

### NOT Recommended (Overkill for OLMO)

| Tool/Pattern                          | Why not                                                    |
|:--------------------------------------|:-----------------------------------------------------------|
| Mem0 MCP ($0-249/mo)                  | Single-developer, single-tool. Native memory sufficient.   |
| Graphiti/Zep knowledge graphs          | Infrastructure overhead >> benefit for current scale.       |
| Claude-Mem plugin                     | OLMO already has curated memory + /dream. Redundant.       |
| Vector-based semantic search          | Grep + good index keywords covers OLMO's 16 files.         |
| Blockchain-based memory (MemoClaw)    | Obviously overkill for a solo project.                     |
| Complex TTL/decay scoring             | `review_by` dates give 80% of value at 5% complexity.      |

---

## Summary

OLMO's memory system is **well above average** — the index-only pattern, type-prefixed naming,
file cap, custom /dream, and session hygiene separation are all community best practices that
most users don't implement. The main gaps are **temporal metadata** (review_by, confidence,
last_challenged), **memory versioning** (no backup/rollback), and a **systematic promotion
pipeline** from memory to rules. These three improvements would bring the system from 7.4/10
to approximately 9/10 with minimal effort.

The external tools (Mem0, Graphiti, Claude-Mem, memsearch) are interesting but premature for
OLMO's current scale. The native Claude Code memory system + good governance conventions +
custom /dream is the right architecture. Revisit external tools if OLMO becomes multi-machine
or multi-developer.
