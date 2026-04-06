# CLAUDE.md Best Practices -- Research Report

Date: 2026-04-06 (S82)
Coautoria: Lucas + Opus 4.6

---

## 1. Official Anthropic Guidance

### Hierarchy of CLAUDE.md Files

Claude Code loads CLAUDE.md files from multiple locations, with more specific scopes taking precedence over broader ones. The full hierarchy (highest to lowest priority):

| Scope | Location | Shared with |
|-------|----------|-------------|
| **Managed policy** | `C:\Program Files\ClaudeCode\CLAUDE.md` (Win) | All org users |
| **Project** | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Team (version control) |
| **User** | `~/.claude/CLAUDE.md` | Just you (all projects) |
| **Local** | `./CLAUDE.local.md` (gitignored) | Just you (this project) |

Files are **concatenated**, not overridden. Within each directory, `CLAUDE.local.md` appends after `CLAUDE.md`, so personal notes are read last at that level. Walking up the directory tree, files from parent directories are also loaded (e.g., if CWD is `foo/bar/`, both `foo/bar/CLAUDE.md` and `foo/CLAUDE.md` load).

### /init Command

Running `/init` generates a starter CLAUDE.md by analyzing the codebase. If a CLAUDE.md already exists, `/init` suggests improvements instead of overwriting. Setting `CLAUDE_CODE_NEW_INIT=1` enables an interactive multi-phase flow that asks which artifacts to set up (CLAUDE.md, skills, hooks), explores the codebase with a subagent, and presents a reviewable proposal before writing.

Community opinion on /init is mixed -- HumanLayer's guide calls /init output "low quality" and recommends manual crafting. Starting small and adding rules based on actual mistakes is consistently recommended over comprehensive auto-generation.

### Recommended Size

Anthropic's official docs: **under 200 lines per CLAUDE.md file**. Longer files consume more context and reduce adherence. HumanLayer says under 300 lines, ideally shorter. Their own root file is under 60 lines.

Research from Anthropic suggests frontier LLMs can follow approximately **150-200 instructions** with reasonable consistency. The Claude Code system prompt already contains ~50 instructions, leaving roughly 100-150 for user rules. This is a soft budget, not a hard limit.

### HTML Comments Stripped

Block-level HTML comments (`<!-- notes -->`) in CLAUDE.md are stripped before injection into context. Use them for human-readable documentation without spending tokens. Comments inside code blocks are preserved.

Sources:
- [How Claude remembers your project -- Claude Code Docs](https://code.claude.com/docs/en/memory)
- [Using CLAUDE.MD files -- Anthropic Blog](https://claude.com/blog/using-claude-md-files)
- [Writing a good CLAUDE.md -- HumanLayer](https://www.humanlayer.dev/blog/writing-a-good-claude-md)

---

## 2. Subdirectory CLAUDE.md Files

### On-Demand Loading

Subdirectory CLAUDE.md files are **not** loaded at launch. They are included when Claude reads files in those directories. This means a `content/aulas/metanalise/CLAUDE.md` only loads when Claude opens a file inside `content/aulas/metanalise/`.

### When to Use Subdirectory CLAUDE.md

Use subdirectory CLAUDE.md for context that is **only relevant when working in that subdirectory**:
- Aula-specific constraints (scope, narrative structure, anchors)
- Module-specific build commands
- Domain-specific terminology or rules

Use the **root CLAUDE.md** for universally applicable rules (coding standards, workflow patterns, enforcement anchors).

### Merging Behavior

All discovered CLAUDE.md files are concatenated -- they do not override each other. When instructions conflict between levels, Claude may pick arbitrarily. The more specific (subdirectory) file is read last, giving it slight recency advantage.

### Known Bug

A fixed bug (pre-2026) caused nested CLAUDE.md files to be re-injected dozens of times in long sessions. Current versions handle this correctly, but it illustrates why keeping subdirectory files lean matters.

### Excluding Irrelevant Files (Monorepos)

The `claudeMdExcludes` setting in `.claude/settings.local.json` skips specific files by path or glob:

```json
{
  "claudeMdExcludes": [
    "**/other-team/CLAUDE.md",
    "/path/to/irrelevant/.claude/rules/**"
  ]
}
```

Managed policy CLAUDE.md cannot be excluded.

Sources:
- [How Claude remembers your project -- Claude Code Docs](https://code.claude.com/docs/en/memory)
- [Anatomy of the .claude/ Folder -- Daily Dose of DS](https://www.dailydoseofds.com/p/anatomy-of-the-claude-folder)

---

## 3. .claude/rules/ vs CLAUDE.md

### Decision Framework

| Put in CLAUDE.md | Put in .claude/rules/ |
|------------------|-----------------------|
| Universal project context (architecture, stack) | Topic-specific rules (testing, security, API design) |
| Build/test/lint commands | Rules that apply only to certain file types |
| Team workflow standards | Lengthy domain rules that would bloat CLAUDE.md |
| Enforcement anchors | Rules that benefit from path-scoping |

### paths: Frontmatter

Rules support YAML frontmatter for conditional loading. Rules **without** `paths:` load globally at launch (same priority as CLAUDE.md). Rules **with** `paths:` load only when Claude reads matching files.

```yaml
---
paths:
  - "src/api/**/*.ts"
  - "tests/**/*.test.ts"
---

# API Testing Rules
...
```

Glob patterns supported:
- `**/*.ts` -- all TypeScript files in any directory
- `src/**/*` -- all files under src/
- `*.md` -- markdown files in project root only
- `src/**/*.{ts,tsx}` -- brace expansion for multiple extensions

### Known Limitation with paths:

There was a reported issue (GitHub #16299) where path-scoped rules loaded globally regardless of `paths:` frontmatter. More recent issues (#23478) indicate `paths:` rules only trigger on Read tool, not Write tool. These are edge cases but worth knowing -- test that your path-scoped rules actually load conditionally.

### alwaysApply:

The official documentation does **not** document an `alwaysApply:` field. Rules without `paths:` frontmatter are effectively always-apply. The mechanism is: no frontmatter = global load; `paths:` frontmatter = conditional load. There is no explicit `alwaysApply: true/false` toggle in the current docs.

### Performance Implications

Path-scoped rules improve context efficiency. A monolithic CLAUDE.md with 400 lines of mixed rules causes "priority saturation" -- when everything is high priority, nothing is. Distributing domain-specific rules into path-scoped files means they only consume context tokens when relevant.

The key insight: rules load at the **same priority level** as CLAUDE.md. Un-scoped rules compete for attention with CLAUDE.md content. Path-scoped rules only receive elevated attention when contextually appropriate.

### Symlinks

`.claude/rules/` supports symlinks for sharing rules across projects:
```bash
ln -s ~/shared-claude-rules .claude/rules/shared
```

### User-Level Rules

Personal rules in `~/.claude/rules/` apply to every project. They load **before** project rules, giving project rules higher priority.

Sources:
- [How Claude remembers your project -- Claude Code Docs](https://code.claude.com/docs/en/memory)
- [Claude Code Rules Directory -- ClaudeFast](https://claudefa.st/blog/guide/mechanics/rules-directory)
- [Path-based rules issues -- GitHub](https://github.com/anthropics/claude-code/issues/16299)
- [Claude Code Gets Path-Specific Rules -- Paddo](https://paddo.dev/blog/claude-rules-path-specific-native/)

---

## 4. Community Best Practices

### Anthropic's Internal Practice (Boris Cherny)

Boris Cherny (Claude Code creator) shares a single CLAUDE.md for the entire repo. The whole team contributes to it multiple times a week. The practice: **any time Claude does something wrong, add a note so it doesn't repeat the mistake**. Over 80% of Anthropic's engineers use Claude Code daily.

### anthropics/skills Repo Patterns

The official skills repository demonstrates a key pattern: **skills vs rules**. Rules load into context every session (or when path-matched files open). Skills load **only when invoked** or when Claude determines relevance. For task-specific instructions that don't need to be in context all the time, skills are more token-efficient than rules.

### Jesse Vincent's Superpowers Framework

Superpowers (github.com/obra/superpowers) enforces disciplined workflows through composable skills. Key insight: **a single instruction is a suggestion; an enforced process is reliable**. After 3-4 tasks in a long session, suggestions quietly get skipped as context grows. Superpowers addresses this with:
- Session-start hooks that inject instructions
- Gated workflows (each step gates the next)
- TDD enforcement, systematic debugging, Socratic brainstorming

### Community Templates (Notable Repos)

- **shanraisshan/claude-code-best-practice** -- comprehensive template with token management
- **abhishekray07/claude-md-templates** -- templates by project type
- **hesreallyhim/awesome-claude-code** -- curated skills, hooks, and plugins
- **awattar/claude-code-best-practices** -- workflows and safe automation patterns

### Concrete Structure Recommendations

Multiple sources converge on these essential sections:
1. **Project summary** -- what this is, who it's for
2. **Architecture / key directories** -- map of the codebase
3. **Build / test / lint commands** -- the 3-5 commands Claude needs most
4. **Code style** -- only what a linter can't enforce
5. **Workflows** -- step-by-step for common tasks
6. **Domain terminology** -- business terms mapped to code

### Anti-Patterns (Consolidated)

| Anti-Pattern | Why It Fails | Fix |
|-------------|--------------|-----|
| Over 400 lines | Adherence drops, rules get ignored | Split into rules/ with paths: |
| Style rules in CLAUDE.md | LLMs are slow/expensive linters | Use ruff, eslint, prettier |
| "Be a senior engineer" | Wastes tokens, Claude already has system instructions | Delete |
| "Think step by step" | Already built into system prompt | Delete |
| Unconditional @imports of large files | Every import loads every session | Use conditional guidance instead |
| Pure negative constraints ("never do X") | Analysis paralysis without alternative | Always provide the alternative |
| Auto-generated /init without editing | Generic, misses project-specific nuance | Manual crafting + iterative refinement |
| Duplicating code snippets | Become stale, waste tokens | Use file:line references |
| Contradictory rules across files | Claude picks arbitrarily | Periodic review for conflicts |
| Secrets in CLAUDE.md | Committed to version control | Use env vars or .local.md |

Sources:
- [Superpowers -- Jesse Vincent](https://blog.fsck.com/2025/10/09/superpowers/)
- [Superpowers GitHub](https://github.com/obra/superpowers)
- [Best Practices -- Claude Code Docs](https://code.claude.com/docs/en/best-practices)
- [50 Claude Code Tips -- Builder.io](https://www.builder.io/blog/claude-code-tips-best-practices)
- [shanraisshan/claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice)
- [Boris Cherny setup -- XDA Developers](https://www.xda-developers.com/set-up-claude-code-like-boris-cherny/)

---

## 5. @include and Modular Patterns

### Syntax

Use `@path/to/file` anywhere in CLAUDE.md to import additional files:

```markdown
See @README for project overview and @package.json for available commands.

# Additional Instructions
- Git workflow: @docs/git-instructions.md
```

### Resolution Rules

- Relative paths resolve relative to the **file containing the import**, not the working directory
- Absolute paths also supported
- Imported files can recursively import other files
- **Maximum depth: 5 hops** (prevents circular imports)
- First-time external imports trigger an approval dialog

### Patterns

**Progressive disclosure (recommended):**
```markdown
# CLAUDE.md (lean, ~50 lines)
## Architecture
See @docs/ARCHITECTURE.md for full system design.

## Build
npm run dev | npm test | npm run lint

## Rules
Domain rules in .claude/rules/ (path-scoped, load on demand).
```

**Over-inclusion (anti-pattern):**
```markdown
# CLAUDE.md
@docs/api-guide.md       # 200 lines, loads EVERY session
@docs/testing-guide.md   # 150 lines, loads EVERY session
@docs/security-policy.md # 100 lines, loads EVERY session
# Result: 450+ extra tokens every request, most irrelevant
```

**Conditional guidance (better):**
```markdown
When working on API endpoints, read docs/api-guide.md first.
When writing tests, consult docs/testing-guide.md for patterns.
```

### Cross-Worktree Imports

For personal instructions shared across git worktrees:
```markdown
@~/.claude/my-project-instructions.md
```

### AGENTS.md Compatibility

If the repo uses AGENTS.md for other tools:
```markdown
@AGENTS.md

## Claude Code Specific
Use plan mode for changes under src/billing/.
```

Sources:
- [How Claude remembers your project -- Claude Code Docs](https://code.claude.com/docs/en/memory)

---

## 6. Context Window Economics

### How CLAUDE.md Consumes Context

CLAUDE.md is injected into **every single request** -- every turn, every follow-up, every fresh start. A 5,000-token CLAUDE.md costs 5,000 tokens on every interaction before Claude reads any code. This compounds across a session.

### Measuring Consumption

Use `/context` to see exactly where tokens go:
- System prompt
- System tools + MCP tools
- Custom agents
- Memory files (CLAUDE.md + auto memory + rules)
- Skills
- Messages (conversation history)
- Free space
- Autocompact buffer (~33K tokens reserved)

If memory files consume 15%+ of the window before any work begins, that's a problem to fix.

### Context Window Sizes (2026)

| Plan | Context Window |
|------|---------------|
| Standard | 200K tokens |
| Enterprise | 500K tokens |
| 1M beta | 1M tokens (~750K words) |

Opus 4.6 and Sonnet 4.6 support 1M context. With Max subscription, the standard 200K applies unless opted into 1M beta.

### Token Efficiency Strategies

1. **Keep CLAUDE.md under 200 lines** -- every line taxes every request
2. **Use path-scoped rules** -- domain rules only load when relevant
3. **Use skills instead of rules** for task-specific instructions (skills load on demand)
4. **Prefer pointers over copies** -- `file:line` references instead of embedded code
5. **HTML comments for human notes** -- stripped before context injection
6. **Use `/compact` at task boundaries** -- reduces accumulated context
7. **Use `/clear` between unrelated tasks** -- full context reset
8. **Conditional @imports** -- "read X when working on Y" instead of unconditional @import
9. **Linters > CLAUDE.md for style** -- don't waste LLM tokens on formatting
10. **Periodic review** -- remove rules Claude no longer violates

### The Compounding Problem

Token consumption compounds:
- Turn 1: system prompt + CLAUDE.md + rules + your message
- Turn 5: all of the above + 4 turns of conversation history
- Turn 20: approaching compaction threshold

A lean CLAUDE.md (500 tokens) vs a bloated one (2,000 tokens) means 1,500 fewer tokens per turn. Over 20 turns, that's 30,000 tokens saved -- enough context for Claude to hold several more files in working memory.

Sources:
- [Context Management -- ClaudeFast](https://claudefa.st/blog/guide/mechanics/context-management)
- [Track Token Usage with /context -- wmedia.es](https://wmedia.es/en/tips/claude-code-context-command-token-usage)
- [6 Ways I Cut Token Usage in Half -- Sabrina](https://www.sabrina.dev/p/6-ways-i-cut-my-claude-token-usage)
- [Manage costs effectively -- Claude Code Docs](https://code.claude.com/docs/en/costs)

---

## 7. Recommendations for OLMO

### Current State Assessment

**Root CLAUDE.md: 91 lines** -- within the recommended 200-line budget. Well-structured with enforcement anchors (primacy + recency), architecture overview, key commands, and conventions.

**Rules files: 9 files, 656 lines total.** Breakdown:
- `slide-rules.md` -- 173 lines (largest)
- `design-reference.md` -- 119 lines
- `qa-pipeline.md` -- 86 lines
- `anti-drift.md` -- 74 lines
- `session-hygiene.md` -- 63 lines
- `mcp_safety.md` -- 50 lines
- `notion-cross-validation.md` -- 34 lines
- `coauthorship.md` -- 31 lines
- `process-hygiene.md` -- 26 lines

**Path-scoped rules (6/9):** `slide-rules.md`, `design-reference.md`, `qa-pipeline.md`, `process-hygiene.md`, `mcp_safety.md`, `notion-cross-validation.md` all use `paths:` frontmatter.

**Global rules (3/9):** `anti-drift.md`, `session-hygiene.md`, `coauthorship.md` load every session.

**Subdirectory CLAUDE.md: 1** -- `content/aulas/metanalise/CLAUDE.md` (97 lines). Well-scoped with aula-specific constraints.

### What OLMO Does Well

1. **Path-scoping is exemplary.** 6 of 9 rules use `paths:` frontmatter. Slide/design/QA rules only load when touching `content/aulas/**`. MCP/Notion rules only load when touching `**/*notion*` or `**/*mcp*`. This is exactly the pattern recommended by Anthropic's docs and community best practices.

2. **Enforcement anchors.** The primacy + recency pattern (duplicating the 3 enforcement rules at top and bottom of CLAUDE.md) is a known technique for improving adherence in long contexts. Well-applied.

3. **Root CLAUDE.md is lean.** At 91 lines, it's well under the 200-line threshold. Content is project-universal (architecture, commands, conventions). No domain-specific bloat.

4. **Subdirectory CLAUDE.md for metanalise.** Properly scoped aula-specific context that only loads when working in that directory. Good use of the lazy-loading mechanism.

5. **Separation of concerns.** Rules cover distinct topics (slides, design, QA, process, session hygiene, safety, coauthorship). One concern per file.

6. **Pointers, not copies.** CLAUDE.md references `docs/ARCHITECTURE.md`, `docs/TREE.md`, `.claude/rules/*.md` by path rather than embedding content.

### Potential Improvements

1. **Consider path-scoping `coauthorship.md`.** Currently global, but coauthorship rules are most relevant when creating commits or publishable content. Could scope to `**/*.md` + `**/*.py` + `content/**` to avoid loading during pure research/planning sessions. Trade-off: marginal token savings vs risk of missing coauthorship in edge cases. Verdict: keep global (it's only 31 lines).

2. **Missing `content/aulas/CLAUDE.md`.** The `content/aulas/` directory has no CLAUDE.md, only `metanalise/` does. Consider creating a thin `content/aulas/CLAUDE.md` with shared aulas rules (build commands, shared/ design system reference, naming conventions). This would load for any work in any aula, reducing reliance on the 6 path-scoped rules that all target `content/aulas/**`. Trade-off: adds another file to maintain vs cleaner scope separation.

3. **`slide-rules.md` at 173 lines is heavy.** It's path-scoped (good), but when loaded it's a significant context hit. Consider splitting into `slide-structure.md` (~50 lines: sections 1-4), `slide-css.md` (~60 lines: sections 5, 10, 11), and `slide-gsap.md` (~60 lines: sections 7, 9). Each could have the same `paths:` scope. Trade-off: more files to maintain vs more granular loading if Claude only needs CSS info, not GSAP info. Verdict: low priority since they all share the same path scope anyway.

4. **Propagation Map in CLAUDE.md.** Lines 68-80 contain a propagation table that's specific to aulas workflow. Consider moving to a path-scoped rule (or into the aulas CLAUDE.md suggested in point 2). This would save ~15 lines from the global CLAUDE.md. The same table appears more detailed in `qa-pipeline.md` section 5.

5. **Use `/context` periodically.** Run `/context` at session start to measure actual token consumption of the current setup. This gives empirical data rather than estimates.

6. **Auto memory governance.** OLMO's memory governance (cap 20 files, consolidation triggers) is more structured than typical projects. The official docs say first 200 lines or 25KB of MEMORY.md load at startup. Current MEMORY.md is well within that limit.

7. **Consider `CLAUDE.local.md` for development overrides.** Lucas could have a personal `CLAUDE.local.md` with dev-specific preferences (e.g., preferred port assignments, local tool paths) that don't need to be in version control.

### Summary Scorecard

| Criterion | OLMO Status | Best Practice |
|-----------|-------------|---------------|
| Root CLAUDE.md size | 91 lines | Under 200 |
| Path-scoped rules | 6/9 (67%) | As many as possible |
| Global rules | 3 (168 lines total) | Minimize |
| Subdirectory CLAUDE.md | 1 (metanalise) | Where needed |
| Enforcement anchors | Primacy + recency | Recommended |
| Pointers over copies | Yes | Yes |
| No secrets in CLAUDE.md | Yes | Yes |
| Periodic review | Session-driven | Recommended |
| /context measurement | Not documented | Recommended |

**Overall: OLMO's CLAUDE.md architecture is well above average.** The path-scoping, enforcement anchors, and lean root file align with all major best practices. The main opportunities are incremental: a shared aulas CLAUDE.md, moving the propagation map out of root, and empirical token measurement.
