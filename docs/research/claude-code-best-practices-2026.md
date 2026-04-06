# Claude Code Best Practices 2026 — State of the Art

> Pesquisa profunda: agents, subagents, skills, hooks, tools, memory, orchestracao avancada.
> Compilado para aplicacao no projeto OLMO.
>
> Data: 2026-04-06 | Coautoria: Lucas + Opus 4.6

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Agents & Subagents](#2-agents--subagents)
3. [Skills](#3-skills)
4. [Hooks](#4-hooks)
5. [Tools & MCP](#5-tools--mcp)
6. [Memory & Context](#6-memory--context)
7. [Rules & CLAUDE.md](#7-rules--claudemd)
8. [Multi-Model Orchestration](#8-multi-model-orchestration)
9. [OLMO Assessment](#9-olmo-assessment)
10. [Recomendacoes Priorizadas para OLMO](#10-recomendacoes-priorizadas-para-olmo)
11. [Fontes](#11-fontes)

---

## 1. Executive Summary

### Top 10 Takeaways

1. **Context is THE constraint.** Performance degrades as the context window fills. Every best practice orbits this fact. Auto-compaction fires at ~83.5% and is lossy (retains ~20-30% of details). Target: never exceed 60% capacity voluntarily.

2. **26 hook lifecycle events exist** (up from the original 5-6). PreToolUse is the most powerful — it can approve/deny/modify tool inputs before execution. PostToolUse creates feedback loops (lint→fix→lint). The full event list includes SessionStart, UserPromptSubmit, PreToolUse, PostToolUse, PostToolUseFailure, PermissionRequest, PermissionDenied, Stop, StopFailure, SubagentStart, SubagentStop, Notification, TaskCreated, TaskCompleted, TeammateIdle, InstructionsLoaded, ConfigChange, CwdChanged, FileChanged, WorktreeCreate, WorktreeRemove, PreCompact, PostCompact, Elicitation, ElicitationResult, SessionEnd.

3. **Skills follow the Agent Skills open standard** (agentskills.io). Key frontmatter: `context: fork` runs in a subagent, `disable-model-invocation: true` prevents auto-trigger, `paths:` scopes to file globs. Description budget is 250 chars per skill, total budget scales at 1% of context window.

4. **Subagents have 3 built-in types** (Explore/Plan/general-purpose) plus unlimited custom ones. Key frontmatter fields: `model`, `isolation: worktree`, `memory: user|project|local`, `background: true`, `effort`, `maxTurns`, `skills` (preloaded), `hooks` (scoped). Subagents cannot spawn sub-subagents.

5. **Agent Teams** are a distinct feature from subagents — they coordinate multiple separate Claude Code sessions with shared task lists, dependency tracking, and peer-to-peer messaging via SendMessage and TaskCreate tools. Cost: 3-7x single session.

6. **Four memory layers exist:** CLAUDE.md (you write), Auto Memory (Claude writes per session), Session Memory (conversation continuity), Auto Dream (periodic consolidation). Dream runs 4 phases: Orient → Gather Signal → Consolidate → Prune & Index. MEMORY.md loads first 200 lines or 25KB.

7. **CLAUDE.md target: under 200 lines.** Files beyond that reduce adherence. Use `@path` imports and `.claude/rules/` for modularity. Path-scoped rules (`paths:` frontmatter) only load when working with matching files. HTML comments are stripped before injection.

8. **Multi-model routing is production-ready:** `model: haiku` for Explore agents (~$0.01/task), `model: sonnet` for balanced work, `model: opus` for deep analysis. The `CLAUDE_CODE_SUBAGENT_MODEL` env var overrides all. Effort levels: low/medium/high/max (max = Opus 4.6 only).

9. **Plugin ecosystem is mature:** 101+ plugins in official marketplace, 33 Anthropic-built. Plugins bundle skills + hooks + agents + MCP servers. Three installation scopes: user, project, local.

10. **/batch is the killer feature for scale:** Decomposes work into 5-30 units, spawns one background agent per unit in isolated git worktrees, each runs tests + /simplify + opens a PR. Handles migrations of hundreds/thousands of files.

---

## 2. Agents & Subagents

### 2.1 Built-in Subagents

| Agent | Model | Tools | Purpose |
|-------|-------|-------|---------|
| **Explore** | Haiku | Read-only | File discovery, code search, codebase exploration. Supports thoroughness levels: quick/medium/very thorough |
| **Plan** | Inherits | Read-only | Codebase research for plan mode. Cannot spawn sub-subagents |
| **general-purpose** | Inherits | All | Complex research, multi-step operations, code modifications |
| **statusline-setup** | Sonnet | — | Configures status line via `/statusline` |
| **Claude Code Guide** | Haiku | — | Answers questions about Claude Code features |

### 2.2 Custom Subagent Configuration

**File location hierarchy (higher priority wins):**

| Priority | Location | Scope |
|----------|----------|-------|
| 1 (highest) | Managed settings | Organization-wide |
| 2 | `--agents` CLI flag | Current session only |
| 3 | `.claude/agents/` | Current project |
| 4 | `~/.claude/agents/` | All projects |
| 5 (lowest) | Plugin `agents/` directory | Where plugin is enabled |

**Complete frontmatter schema:**

```yaml
---
name: my-agent            # Required. Lowercase + hyphens. Unique identifier
description: When to use  # Required. Drives auto-delegation decisions
tools: Read, Grep, Glob   # Optional. Allowlist (inherits all if omitted)
disallowedTools: Write     # Optional. Denylist (applied before tools)
model: sonnet              # Optional. sonnet|opus|haiku|inherit|full-model-id
permissionMode: auto       # Optional. default|acceptEdits|auto|dontAsk|bypassPermissions|plan
maxTurns: 20               # Optional. Max agentic turns before stop
skills:                    # Optional. Full skill content injected at startup
  - api-conventions
  - error-handling
mcpServers:                # Optional. Inline or reference existing servers
  - playwright:
      type: stdio
      command: npx
      args: ["-y", "@playwright/mcp@latest"]
  - github               # Reference by name
hooks:                     # Optional. Scoped to subagent lifecycle
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./validate.sh"
memory: project            # Optional. user|project|local
background: false          # Optional. true = concurrent execution
effort: high               # Optional. low|medium|high|max
isolation: worktree        # Optional. Isolated git worktree copy
color: blue                # Optional. UI color identifier
initialPrompt: "/setup"    # Optional. Auto-submitted first turn (--agent mode)
---

System prompt markdown body here.
```

### 2.3 Orchestration Patterns

#### Pattern: Context Isolation (most common)

```
Main Session (Opus) ──delegates──> Explore Agent (Haiku, read-only)
                                   Reads 50 files, returns 10-line summary
                                   Main context stays clean
```

**When:** Codebase exploration, test running, log analysis, documentation fetching.
**Source:** Official docs — "One of the most effective uses for subagents is isolating operations that produce large amounts of output."

#### Pattern: Parallel Research

```
Main Session ──spawns──> Agent A (auth module)
             ──spawns──> Agent B (database layer)
             ──spawns──> Agent C (API endpoints)
                         All return summaries concurrently
```

**When:** Independent investigation domains. Explicitly request: "Research the authentication, database, and API modules in parallel using separate subagents."

#### Pattern: Writer/Reviewer (separate sessions)

```
Session A (Writer): "Implement rate limiter"
Session B (Reviewer): "Review @src/middleware/rateLimiter.ts for edge cases, race conditions"
Session A: "Address this review feedback: [B's output]"
```

**When:** Quality-critical code. Fresh context prevents bias toward own code.
**Source:** Official best practices.

#### Pattern: /batch Fan-Out

```
/batch "migrate src/ from Solid to React"
   Orchestrator enters plan mode
   └─> Explore agents research codebase
   └─> Decomposes into 5-30 units
   └─> Spawns 1 agent per unit (worktree isolation)
       Each agent: implement → /simplify → test → commit → PR
```

**When:** Large-scale migrations, refactors across hundreds of files.
**Source:** Built-in bundled skill.

#### Pattern: Agent Teams (multi-session coordination)

```
Team Lead ──creates tasks──> Shared Task List
  ├── Teammate "frontend" (claims frontend tasks)
  ├── Teammate "backend" (claims backend tasks)
  └── Teammate "tests" (claims test tasks)
      All communicate via SendMessage + TaskCreate
```

**When:** Cross-layer changes requiring coordination. Experimental feature (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`).
**Cost:** 3-7x single session tokens.

### 2.4 Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| **Vague description** | Claude can't decide when to delegate | Front-load the use case in `description` |
| **Subagent spawning subagents** | Not supported; will fail silently | Design flat delegation from main session |
| **Background without pre-approved permissions** | Fails on permission prompts | Pre-approve tools or use `permissionMode: auto` |
| **Too many parallel agents** | Context thrashing, merge conflicts | Start with 3-5 teammates maximum |
| **No maxTurns** | Agent can run indefinitely | Set maxTurns = estimated turns + 20% margin |

### 2.5 Subagent Memory

Persistent memory lets subagents accumulate knowledge across sessions:

| Scope | Location | Use Case |
|-------|----------|----------|
| `user` | `~/.claude/agent-memory/<name>/` | Cross-project knowledge |
| `project` | `.claude/agent-memory/<name>/` | Project-specific, shareable via git |
| `local` | `.claude/agent-memory-local/<name>/` | Project-specific, not in git |

When memory is enabled, Read/Write/Edit tools are auto-enabled. First 200 lines / 25KB of the agent's MEMORY.md are injected at startup.

**Tip:** Include memory instructions in the agent's system prompt: "Update your agent memory as you discover codepaths, patterns, library locations, and key architectural decisions."

---

## 3. Skills

### 3.1 Anatomy of a Well-Built Skill

```
my-skill/
├── SKILL.md              # Main instructions (REQUIRED)
├── template.md           # Template for Claude to fill in
├── examples/
│   └── sample.md         # Example output showing expected format
├── scripts/
│   └── validate.sh       # Script Claude can execute
└── reference.md          # Detailed docs (loaded on demand)
```

**Rule of thumb:** SKILL.md under 500 lines. Move detailed reference to separate files.

### 3.2 Frontmatter Reference

```yaml
---
name: my-skill                    # /slash-command name. Lowercase + hyphens, max 64 chars
description: What + when          # RECOMMENDED. 250 char max in listings. Front-load key use case
argument-hint: "[issue-number]"   # Autocomplete hint
disable-model-invocation: true    # Only user can invoke (side-effects protection)
user-invocable: false             # Only Claude can invoke (background knowledge)
allowed-tools: Read Grep Glob     # Space-separated or YAML list
model: sonnet                     # Model override
effort: high                      # low|medium|high|max
context: fork                     # Run in isolated subagent context
agent: Explore                    # Subagent type when context: fork (default: general-purpose)
hooks:                            # Scoped hooks
  PostToolUse:
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: "./lint.sh"
paths:                            # Glob patterns. Skill only activates for matching files
  - "src/api/**/*.ts"
  - "tests/**/*.test.ts"
shell: bash                       # bash (default) or powershell
---

Skill content here.
Reference supporting files: see [reference.md](reference.md) for details.
```

### 3.3 String Substitutions

| Variable | Description |
|----------|-------------|
| `$ARGUMENTS` | All arguments passed to the skill |
| `$ARGUMENTS[N]` or `$N` | N-th argument (0-based) |
| `${CLAUDE_SESSION_ID}` | Current session ID |
| `${CLAUDE_SKILL_DIR}` | Directory containing the SKILL.md |

### 3.4 Invocation Control Matrix

| Frontmatter | User Can Invoke | Claude Can Invoke | Context Loading |
|------------|----------------|-------------------|-----------------|
| (default) | Yes | Yes | Description always in context, full loads when invoked |
| `disable-model-invocation: true` | Yes | No | Description NOT in context |
| `user-invocable: false` | No | Yes | Description always in context |

### 3.5 Dynamic Context Injection

The `` !`command` `` syntax runs shell commands BEFORE the skill is sent to Claude:

```yaml
---
name: pr-summary
context: fork
agent: Explore
---
## PR Context
- PR diff: !`gh pr diff`
- Changed files: !`gh pr diff --name-only`

Summarize this pull request...
```

Multi-line version with fenced code block:

````markdown
```!
node --version
npm --version
git status --short
```
````

This is preprocessing, not something Claude executes. Claude only sees the output.

### 3.6 Skill Patterns from Top Repos

#### Pattern: Fix-Issue Workflow

```yaml
---
name: fix-issue
description: Fix a GitHub issue
disable-model-invocation: true
---
Fix GitHub issue $ARGUMENTS:
1. `gh issue view` to get details
2. Search codebase for relevant files
3. Implement fix
4. Write and run tests
5. Commit with descriptive message
6. Push and create PR
```
**Source:** Official best practices.

#### Pattern: API Conventions (reference skill)

```yaml
---
name: api-conventions
description: REST API design patterns for this codebase
user-invocable: false
---
When writing API endpoints:
- Use kebab-case for URL paths
- Use camelCase for JSON properties
- Always include pagination for list endpoints
```
**Source:** Official docs. Note `user-invocable: false` — Claude auto-applies when relevant.

#### Pattern: Codebase Visualizer (bundled scripts)

A skill that bundles a Python script to generate interactive HTML tree views. The skill instructs Claude to run the script; Claude orchestrates while the script does heavy lifting. Works for dependency graphs, test coverage reports, API docs, DB schema visualizations.

**Source:** Official docs example.

### 3.7 Bundled Skills

| Skill | Purpose |
|-------|---------|
| `/batch <instruction>` | Parallel fan-out across worktrees (5-30 units) |
| `/claude-api` | Claude API + Agent SDK reference for your language |
| `/debug [description]` | Enable debug logging and troubleshoot |
| `/loop [interval] <prompt>` | Repeat a prompt on an interval |
| `/simplify [focus]` | 3-agent parallel review + fix for recently changed files |

### 3.8 Skill Token Budget

Skill descriptions are loaded into context for Claude to know what's available. Budget: **1% of context window** with 8,000 character fallback. Each description capped at 250 chars. Override with `SLASH_COMMAND_TOOL_CHAR_BUDGET` env var.

**Implication for OLMO:** With 20+ skills, descriptions must be extremely concise and front-loaded.

---

## 4. Hooks

### 4.1 Complete Lifecycle Events (26 events)

| Event | When | Blockable | Matcher |
|-------|------|-----------|---------|
| `SessionStart` | Session begins/resumes | No | startup, resume, clear, compact |
| `UserPromptSubmit` | User submits prompt | Yes | None |
| `PreToolUse` | Before tool execution | Yes | Tool names |
| `PermissionRequest` | Permission dialog appears | Yes | Tool names |
| `PermissionDenied` | Auto mode denies tool | No | Tool names |
| `PostToolUse` | After tool succeeds | No* | Tool names |
| `PostToolUseFailure` | After tool fails | No | Tool names |
| `Notification` | Notification sent | No | permission_prompt, idle_prompt, auth_success, elicitation_dialog |
| `SubagentStart` | Subagent spawned | No | Agent type |
| `SubagentStop` | Subagent finishes | Yes | Agent type |
| `TaskCreated` | Task created (agent teams) | Yes | None |
| `TaskCompleted` | Task completed | Yes | None |
| `Stop` | Claude finishes responding | Yes | None |
| `StopFailure` | Turn ends due to API error | No | rate_limit, authentication_failed |
| `TeammateIdle` | Agent team member goes idle | Yes | None |
| `InstructionsLoaded` | CLAUDE.md/rules files load | No | session_start, nested_traversal, path_glob_match, include, compact |
| `ConfigChange` | Config file changes | Yes | user_settings, project_settings, local_settings, policy_settings, skills |
| `CwdChanged` | Working directory changes | No | None |
| `FileChanged` | Watched file changes | No | Filename (basename) |
| `WorktreeCreate` | Worktree being created | Yes | None |
| `WorktreeRemove` | Worktree being removed | No | None |
| `PreCompact` | Before context compaction | No | manual, auto |
| `PostCompact` | After compaction | No | manual, auto |
| `Elicitation` | MCP requests user input | Yes | MCP server names |
| `ElicitationResult` | User responds to MCP | Yes | MCP server names |
| `SessionEnd` | Session terminates | No | clear, resume, logout |

*PostToolUse can return `decision: "block"` with a reason, which injects feedback for Claude to fix the issue.

### 4.2 Handler Types (4 types)

#### Command Hooks (most common)
```json
{
  "type": "command",
  "command": "bash ./my-hook.sh",
  "shell": "bash|powershell",
  "async": false,
  "timeout": 600,
  "if": "Bash(git *)",
  "statusMessage": "Checking..."
}
```
Communication: JSON via stdin → JSON to stdout (exit 0) or error to stderr.
Exit codes: 0 = success, 2 = blocking error, other = non-blocking.

#### HTTP Hooks
```json
{
  "type": "http",
  "url": "http://localhost:8080/hook",
  "headers": { "Authorization": "Bearer $MY_TOKEN" },
  "allowedEnvVars": ["MY_TOKEN"],
  "timeout": 30
}
```
POST body = hook input JSON. 2xx = success, non-2xx = non-blocking error.

#### Prompt Hooks
```json
{
  "type": "prompt",
  "prompt": "Evaluate if this is safe: $ARGUMENTS",
  "model": "claude-opus-4",
  "timeout": 30
}
```
Claude evaluates and returns yes/no decision as JSON.

#### Agent Hooks
```json
{
  "type": "agent",
  "prompt": "Verify security compliance: $ARGUMENTS",
  "timeout": 60
}
```
Spawns a subagent to verify conditions.

### 4.3 PreToolUse Output Schema (the most important hook)

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow|deny|ask|defer",
    "permissionDecisionReason": "Reason shown to Claude",
    "updatedInput": {
      "command": "modified command"
    },
    "additionalContext": "Extra context injected for Claude"
  }
}
```

**Decision values:**
- `allow` — Skip permission prompt, proceed
- `deny` — Block tool call entirely
- `ask` — Show permission dialog to user
- `defer` — Exit gracefully (non-interactive mode only)

**Input modification (v2.0.10+):** `updatedInput` lets hooks transparently modify tool parameters before execution — automatic sandboxing, security enforcement, convention adherence without blocking + retrying.

### 4.4 Advanced Hook Patterns

#### Pattern: Lint-on-Write Feedback Loop

```json
{
  "PostToolUse": [{
    "matcher": "Write|Edit",
    "hooks": [{
      "type": "command",
      "command": "bash ./lint-check.sh"
    }]
  }]
}
```
lint-check.sh runs linter → if errors, outputs `{"decision":"block","reason":"Lint errors: ..."}` → Claude auto-fixes → hook runs again. Continuous quality enforcement without human intervention.

**Source:** Multiple production reports.

#### Pattern: Guard Chain (defense in depth)

```json
{
  "PreToolUse": [
    { "matcher": "Bash", "hooks": [{ "type": "command", "command": "./guard-secrets.sh" }] },
    { "matcher": "Bash", "hooks": [{ "type": "command", "command": "./guard-destructive.sh" }] },
    { "matcher": "Write|Edit", "hooks": [{ "type": "command", "command": "./guard-product-files.sh" }] },
    { "matcher": "Read", "hooks": [{ "type": "command", "command": "./guard-read-secrets.sh" }] }
  ]
}
```
Multiple hooks on the same event run sequentially. Any one can block. Order matters: cheapest/fastest checks first.

**Performance note:** Each hook runs synchronously. If a PostToolUse hook adds >500ms to every file edit, the session feels sluggish.

#### Pattern: Stop Hook Hygiene Check

```json
{
  "Stop": [{
    "hooks": [{
      "type": "command",
      "command": "./stop-hygiene.sh"
    }]
  }]
}
```
Checks session documentation, cross-references, pending issues. Returns `{"decision":"block","reason":"..."}` to force Claude to continue if hygiene incomplete.

#### Pattern: PreCompact Context Preservation

```json
{
  "PreCompact": [{
    "matcher": "auto",
    "hooks": [{
      "type": "command",
      "command": "./save-context-essentials.sh"
    }]
  }]
}
```
Fires before auto-compaction. Save critical state to disk so it survives lossy compaction.

#### Pattern: OTel Observability

Hook scripts forward event data to OpenTelemetry collectors for real-time dashboards. Track tool calls, agent lifecycle, file changes, and costs across multi-agent sessions.

**Tools:** `claude-code-otel` (ColeMurray), `agents-observe` (simple10), `claude-code-hooks-multi-agent-observability` (disler).

### 4.5 Environment Variables in Hooks

| Variable | Available In | Description |
|----------|-------------|-------------|
| `$CLAUDE_PROJECT_DIR` | All hooks | Project root |
| `${CLAUDE_PLUGIN_ROOT}` | Plugin hooks | Plugin installation directory |
| `${CLAUDE_PLUGIN_DATA}` | Plugin hooks | Plugin persistent data directory |
| `$CLAUDE_CODE_REMOTE` | All hooks | "true" if running in remote web environment |
| `$CLAUDE_ENV_FILE` | SessionStart, CwdChanged, FileChanged | Write-only file for persistent env vars |

### 4.6 Configuration Hierarchy

Settings files are merged in this order (higher overrides lower):

1. Managed policy settings (admin-controlled)
2. `~/.claude/settings.json` (user-level)
3. `.claude/settings.json` (project-level, shareable)
4. `.claude/settings.local.json` (project-level, local only)
5. Plugin hooks/hooks.json
6. Skill/Agent frontmatter hooks

---

## 5. Tools & MCP

### 5.1 Built-in Tools

Claude Code's internal tools: Read, Write, Edit, Glob, Grep, Bash, Agent (formerly Task), WebFetch, WebSearch, AskUserQuestion, EnterPlanMode, ExitPlanMode, EnterWorktree, ExitWorktree, NotebookEdit, Skill.

### 5.2 MCP Integration

MCP (Model Context Protocol) is the open standard for connecting AI agents to external tools and data. MCP tools follow the naming pattern `mcp__<server>__<tool>`.

**Configuration in `.mcp.json`:**
```json
{
  "mcpServers": {
    "github": {
      "type": "stdio",
      "command": "gh",
      "args": ["mcp-server"]
    }
  }
}
```

**Permission control:**
```json
{
  "permissions": {
    "allow": ["mcp__github__*"],
    "deny": ["mcp__github__delete_*"]
  }
}
```

Wildcards (`*`) let you allow/deny all tools from a server. Deny rules take precedence.

### 5.3 MCP Safety Patterns

**Principle: Scope tool access tightly.** If an integration only needs to read repository metadata, it shouldn't have credentials that can delete branches.

**Pattern: Subagent-Scoped MCP**
Define MCP servers inline in a subagent's frontmatter to keep them out of the main conversation context entirely:

```yaml
---
name: browser-tester
mcpServers:
  - playwright:
      type: stdio
      command: npx
      args: ["-y", "@playwright/mcp@latest"]
---
```

The subagent gets the tools; the parent conversation does not. This saves context tokens and reduces accidental tool use.

### 5.4 Custom Tools (Agent SDK)

For programmatic use, the Agent SDK supports custom tools as in-process MCP servers:

```python
from claude_agent_sdk import create_sdk_mcp_server

@tool
def search_database(query: str, limit: int = 10) -> list:
    """Search the project database."""
    return db.search(query, limit=limit)

server = create_sdk_mcp_server([search_database])
```

### 5.5 CLI Tools as First-Class Integration

Claude Code works exceptionally well with CLI tools: `gh`, `aws`, `gcloud`, `sentry-cli`, `docker`, etc. CLI tools are the most context-efficient way to interact with external services.

**Tip:** "Use 'foo-cli-tool --help' to learn about foo tool, then use it to solve A, B, C."

---

## 6. Memory & Context

### 6.1 Four Memory Layers

| Layer | Who Writes | Loaded | Scope |
|-------|-----------|--------|-------|
| **CLAUDE.md** | You | Every session (full) | Project, user, or org |
| **Auto Memory** | Claude | Every session (first 200 lines / 25KB of MEMORY.md) | Per working tree |
| **Session Memory** | System | Conversation continuity within session | Current session |
| **Auto Dream** | Claude (background) | Consolidates into Auto Memory | Periodic (24h default) |

### 6.2 CLAUDE.md Loading Order

Claude walks UP the directory tree from CWD, loading `CLAUDE.md` + `CLAUDE.local.md` at each level. Files in subdirectories load on demand when Claude reads files there.

**Full resolution order (all concatenated, not overriding):**
1. Managed policy CLAUDE.md (cannot be excluded)
2. User `~/.claude/CLAUDE.md`
3. Parent directories (walking up from CWD)
4. Project root `./CLAUDE.md` or `./.claude/CLAUDE.md`
5. `./CLAUDE.local.md` (gitignored, personal)
6. `.claude/rules/*.md` (modular, path-scopable)
7. Subdirectory CLAUDE.md files (on demand)

Within each directory, `CLAUDE.local.md` appends after `CLAUDE.md`.

### 6.3 Auto Memory Details

**Storage:** `~/.claude/projects/<project>/memory/`
- `MEMORY.md` — lean index, loaded every session
- Topic files (e.g., `debugging.md`, `api-conventions.md`) — loaded on demand

**What Claude saves:** Build commands, debugging insights, architecture notes, code style preferences, workflow habits.

**Limits:** First 200 lines or 25KB of MEMORY.md (whichever first). Topic files not loaded at startup.

**Override storage:** Set `autoMemoryDirectory` in user or local settings.

### 6.4 Auto Dream (Memory Consolidation)

Inspired by human sleep/memory consolidation. Runs as a background subagent:

**4 phases:**
1. **Orient** — Read current memory directory
2. **Gather Signal** — Scan recent session transcripts (targeted grep, not exhaustive)
3. **Consolidate** — Merge new findings into existing memory
4. **Prune & Index** — Rebuild MEMORY.md under 200 lines

**Safety:**
- Write access limited to memory files only (never source code)
- Lock file prevents concurrent dream cycles
- Converts relative dates to absolute dates
- Deletes contradicted facts and stale memories

### 6.5 Context Window Management

**Key numbers:**
- System prompt + tool definitions + skills = 50-70K tokens BEFORE you type anything
- Auto-compaction fires at ~83.5% capacity
- Compaction retains ~20-30% of details (lossy)
- CLAUDE.md fully survives compaction (re-read from disk)
- Conversation-only instructions do NOT survive compaction

**Strategies:**
1. `/clear` between unrelated tasks (most effective)
2. After 2 failed corrections, `/clear` and rewrite the prompt
3. Use subagents for exploration (isolates verbose output)
4. `/compact <instructions>` for manual compaction with focus
5. `Esc + Esc` or `/rewind` → "Summarize from here" for partial compaction
6. `/btw` for side questions that don't enter history
7. Custom compaction instructions in CLAUDE.md: "When compacting, always preserve the full list of modified files"
8. StatusLine for continuous context usage monitoring

**StatusLine JSON input fields:** model, context_window_usage (percentage), cost, workspace, worktree_name, rate_limits (5h and 7d).

### 6.6 Compaction Survival Patterns

| Content | Survives Compaction? |
|---------|---------------------|
| CLAUDE.md | Yes (re-read from disk) |
| Auto Memory | Yes (re-read from disk) |
| Rules files | Yes (re-read from disk) |
| Conversation context | Partially (lossy summary) |
| Subagent results | Only the summary returned |
| File contents read | Lost unless re-read |
| Important decisions | Only if explicitly noted |

**Pattern: PreCompact hook saves critical state:**
```bash
#!/bin/bash
# Save session essentials to a file
echo "$IMPORTANT_STATE" >> "$CLAUDE_PROJECT_DIR/.claude/context-essentials.md"
```

**Pattern: PostCompact hook re-injects context:**
Re-read HANDOFF.md and context-essentials after compaction to recover what the summary lost.

---

## 7. Rules & CLAUDE.md

### 7.1 Structure Best Practices

**Target:** Under 200 lines per CLAUDE.md file. Over that, rules get lost in noise.

| Include | Exclude |
|---------|---------|
| Bash commands Claude can't guess | What Claude infers from code |
| Code style differing from defaults | Standard language conventions |
| Testing instructions, preferred runners | Detailed API docs (link instead) |
| Branch naming, PR conventions | Frequently changing information |
| Architectural decisions | Long explanations or tutorials |
| Dev environment quirks, required env vars | "Write clean code" |
| Common gotchas, non-obvious behaviors | File-by-file codebase descriptions |

**Emphasis works:** "IMPORTANT" or "YOU MUST" improves adherence for critical rules.

### 7.2 Import Syntax

```markdown
See @README.md for project overview and @package.json for npm commands.

# Additional Instructions
- Git workflow: @docs/git-instructions.md
- Personal: @~/.claude/my-project-instructions.md
```

- Relative paths resolve relative to the file containing the import
- Max import depth: 5 hops
- First-time external imports show an approval dialog

### 7.3 Path-Scoped Rules

```markdown
---
paths:
  - "src/api/**/*.ts"
  - "tests/**/*.test.ts"
---
# API Development Rules
- All endpoints must include input validation
```

| Pattern | Matches |
|---------|---------|
| `**/*.ts` | All TypeScript files in any directory |
| `src/**/*` | All files under src/ |
| `*.md` | Markdown in project root only |
| `src/components/*.tsx` | React components in specific dir |
| `src/**/*.{ts,tsx}` | Brace expansion for multiple extensions |

Rules without `paths` load unconditionally. Path-scoped rules trigger when Claude reads matching files.

### 7.4 Modular Rules Structure

```
.claude/
├── CLAUDE.md           # Main project instructions (<200 lines)
└── rules/
    ├── code-style.md   # Always loaded
    ├── testing.md      # Always loaded
    ├── security.md     # Always loaded
    ├── api-design.md   # Path-scoped to src/api/**
    └── frontend/
        └── react.md    # Path-scoped to src/components/**
```

Symlinks are supported for sharing rules across projects:
```bash
ln -s ~/shared-claude-rules .claude/rules/shared
```

### 7.5 Large Teams: Monorepo Patterns

Use `claudeMdExcludes` to skip irrelevant CLAUDE.md files from other teams:

```json
{
  "claudeMdExcludes": [
    "**/monorepo/CLAUDE.md",
    "/home/user/monorepo/other-team/.claude/rules/**"
  ]
}
```

Managed policy CLAUDE.md cannot be excluded.

### 7.6 HTML Comments for Token Economy

Block-level HTML comments (`<!-- notes -->`) in CLAUDE.md are stripped before context injection. Use for maintainer notes without spending tokens. Comments inside code blocks are preserved.

---

## 8. Multi-Model Orchestration

### 8.1 Model Routing Strategy

| Complexity | Model | Cost | Use Case |
|-----------|-------|------|----------|
| Trivial | Ollama (local, $0) | Free | Formatting, simple lookups |
| Simple | Haiku | ~$0.01/task | Explore agents, code search, file discovery |
| Medium | Sonnet | ~$0.03/task | Balanced work, code review, implementation |
| Complex | Opus | ~$0.06/task | Architecture, deep analysis, orchestration |

### 8.2 Model Resolution Order

For subagents, model is resolved in this priority:
1. `CLAUDE_CODE_SUBAGENT_MODEL` env var (overrides everything)
2. Per-invocation `model` parameter (Claude's choice at delegation time)
3. Subagent definition's `model` frontmatter
4. Main conversation's model (inherited)

### 8.3 Effort Levels

| Level | Behavior | Available On |
|-------|----------|--------------|
| `low` | Fast, minimal reasoning | Opus 4.6, Sonnet 4.6 |
| `medium` | Default balanced | Opus 4.6, Sonnet 4.6 |
| `high` | Deeper reasoning | Opus 4.6, Sonnet 4.6 |
| `max` | Maximum thinking (extended) | Opus 4.6 only |

Override per-skill or per-agent via `effort` frontmatter.

### 8.4 Practical Multi-Model Architecture

```
Opus 4.6 (main orchestrator)
├── Haiku (Explore agents — fast codebase search)
├── Sonnet (implementation agents — balanced)
├── Sonnet (review agents — code quality)
└── Opus (architecture review — deep analysis)
```

**Cost optimization:** Running Explore on Haiku instead of Opus saves ~85% per exploration task. For a session with 20 explorations, this saves significant tokens.

### 8.5 Extended Thinking

Include "ultrathink" in a skill's content to enable extended thinking mode for that skill. This activates deeper reasoning chains for complex analysis tasks.

---

## 9. OLMO Assessment

### 9.1 Current OLMO Stack

| Component | Count | Details |
|-----------|-------|---------|
| **Agents** | 8 | researcher, quality-gate, notion-ops, repo-janitor, reference-checker, evidence-researcher, mbe-evaluator, qa-engineer |
| **Skills** | 20 | Research, medical, teaching, organization, automation, review, debugging, etc. |
| **Hooks** | 13 | SessionStart (2), PreToolUse (8), PostToolUse (1), Notification (1), Stop (5) |
| **Rules** | 10 | anti-drift, coauthorship, session-hygiene, slide-rules, etc. |
| **Memory Files** | 16 | With MEMORY.md index, cap at 20 |
| **MCP Integrations** | 9 | Notion, Gmail, Calendar, PubMed, Consensus, Excalidraw, Canva, Scholar Gateway, SCite |
| **StatusLine** | Yes | Custom bash script |
| **Plans Directory** | Yes | `.claude/plans` configured |

### 9.2 What OLMO Does Well (State of the Art)

1. **Hook chain is extensive and well-designed:** 13 hooks covering SessionStart, PreToolUse (secrets, pause, generated, product files, plan exit, bash-secrets, bash-write, lint-before-build), PostToolUse (build monitor), Notification, and Stop (5 hooks: pre-compact checkpoint, crossref, detect issues, hygiene, notify). This is above-average complexity.

2. **Guard pattern is defense-in-depth:** Multiple PreToolUse guards layered (secrets → destructive → product files → lint). Matches the recommended pattern exactly.

3. **Stop hook chain is sophisticated:** Pre-compact checkpoint → crossref check → detect issues → hygiene → notify. This is a proper quality gate chain.

4. **Memory governance is explicit:** Cap at 20 files, consolidation trigger, review cadence, merge test. The `/dream` skill handles consolidation.

5. **Anti-drift rules are among the most thorough I've seen:** 5-step verification gate, momentum brake, scope discipline, transparency requirements, budget awareness.

6. **Path-scoped rules are used correctly:** `mcp_safety.md` and `notion-cross-validation.md` have `paths:` frontmatter.

7. **Propagation Map is unique and valuable:** Explicit dependency tracking (if X changed, update Y) is not common in community CLAUDE.md files.

8. **Coauthorship rule is well-implemented:** Explicit AI attribution across all output formats.

9. **9 MCP integrations** covering research, publishing, communication, calendar, and visual tools.

10. **StatusLine is configured** for continuous session monitoring.

### 9.3 Gaps vs State of the Art

| Gap | Current State | State of the Art | Priority |
|-----|--------------|-----------------|----------|
| **Agent `model` routing** | Most agents likely inherit Opus | Should route: Explore→Haiku, review→Sonnet, orchestration→Opus | P1 |
| **Agent `memory` field** | Not configured in agents | Agents should accumulate knowledge: `memory: project` for qa-engineer, reference-checker | P1 |
| **Agent `maxTurns`** | Mentioned in rules but may not be in all agent frontmatter | Every agent needs maxTurns (estimated + 20% margin) | P1 |
| **`isolation: worktree`** | Not used | Should be used for research/QA agents that don't need to modify main tree | P2 |
| **Skill `context: fork`** | Unknown if used | Research/QA skills should fork to preserve main context | P2 |
| **Hook types beyond `command`** | Only command hooks | HTTP hooks for observability, prompt hooks for semantic evaluation | P3 |
| **PostToolUse feedback loops** | Only build-monitor.sh | Could add lint-on-edit feedback loops for slides (auto-fix HTML issues) | P2 |
| **PreCompact/PostCompact hooks** | Not configured (uses pre-compact-checkpoint in Stop) | Move to actual PreCompact event for guaranteed timing | P1 |
| **InstructionsLoaded hook** | Not configured | Useful for debugging which rules load and when | P3 |
| **Agent Teams** | Not used | Could coordinate slide authoring + QA + evidence research in parallel | P3 |
| **FileChanged hook** | Not configured | Could watch `.env` or critical config files | P3 |
| **Plugin ecosystem** | Not explored | Code intelligence plugins for HTML/JS, Playwright plugin | P2 |
| **Skill `allowed-tools`** | Unknown if used | Should restrict read-only agents to Read/Grep/Glob only | P2 |
| **CLAUDE.md size** | Potentially large (many sections) | Target under 200 lines. Move detail to rules/skills | P1 |
| **`effort` field** | Not used in agents/skills | Low effort for simple tasks, max for architecture decisions | P2 |
| **Batch/fan-out** | Not used | `/batch` for large-scale slide migrations or evidence generation | P3 |
| **Agent `background: true`** | Not used | QA checks could run in background while authoring continues | P2 |
| **AGENTS.md import** | Not applicable | N/A — OLMO is single-user | N/A |

---

## 10. Recomendacoes Priorizadas para OLMO

### P0 — Immediate (this session or next)

1. **Audit CLAUDE.md line count.** If >200 lines, split into rules files. Move detailed instructions into `.claude/rules/` with path-scoping.

2. **Migrate pre-compact-checkpoint from Stop to PreCompact hook.** The PreCompact event guarantees timing before compaction starts:
   ```json
   "PreCompact": [{
     "matcher": "auto",
     "hooks": [{
       "type": "command",
       "command": "bash /c/Dev/Projetos/OLMO/hooks/pre-compact-checkpoint.sh",
       "timeout": 5000
     }]
   }]
   ```

3. **Add `maxTurns` to all 8 agents.** Estimate actual turns needed + 20% margin. Prevents runaway agents.

### P1 — High Priority (next 2-3 sessions)

4. **Add `model` routing to agents.** Recommended mapping:
   - `evidence-researcher` → `model: sonnet` (balanced research)
   - `reference-checker` → `model: haiku` (fast lookup)
   - `mbe-evaluator` → `model: sonnet` (needs reasoning)
   - `qa-engineer` → `model: sonnet` (needs visual + reasoning)
   - `researcher` → `model: sonnet` (balanced)
   - `repo-janitor` → `model: haiku` (simple cleanup)
   - `quality-gate` → `model: sonnet` (needs judgment)
   - `notion-ops` → `model: haiku` (API calls, simple logic)

5. **Add `memory: project` to key agents.** At minimum: `qa-engineer` (learns recurring issues), `reference-checker` (remembers citation patterns), `evidence-researcher` (builds topic knowledge).

6. **Add `skills` preloading to agents.** Example: `qa-engineer` should preload `slide-authoring` skill for design system knowledge.

7. **Add PostCompact hook.** Re-read HANDOFF.md and context-essentials after compaction:
   ```json
   "PostCompact": [{
     "matcher": "auto",
     "hooks": [{
       "type": "command",
       "command": "bash /c/Dev/Projetos/OLMO/hooks/post-compact-reinject.sh",
       "timeout": 5000
     }]
   }]
   ```

### P2 — Medium Priority (next 5 sessions)

8. **Add `context: fork` to heavy skills.** Skills like `research`, `medical-researcher`, `deep-search` should fork to avoid flooding main context.

9. **Add `allowed-tools` to read-only agents.** `evidence-researcher` and `reference-checker` probably don't need Write/Edit.

10. **Explore code intelligence plugin.** `/plugin install` a language server plugin for HTML/JS/CSS to give Claude precise symbol navigation in slide code.

11. **Add `effort` field strategically.** `effort: max` for `medical-researcher` (complex analysis), `effort: low` for `repo-janitor` (simple tasks).

12. **Add lint-on-edit PostToolUse feedback loop.** Run `lint-slides.js` after every Write|Edit on slide HTML files, injecting errors as additionalContext so Claude auto-fixes.

13. **Add `background: true` to QA agents.** Let QA run concurrently while slide authoring continues.

### P3 — Low Priority (when time permits)

14. **Experiment with Agent Teams.** Use for cross-domain work: one teammate on evidence HTML, another on slide HTML, another on narrative.md.

15. **Add InstructionsLoaded hook for debugging.** Log which rules/CLAUDE.md files load and when.

16. **Explore OTel integration.** Hook-based observability for tracking agent performance, token usage, and error patterns over time.

17. **Evaluate /batch for evidence generation.** If you need evidence HTML for 20+ slides, /batch could parallelize the work.

18. **Add FileChanged hook for .env monitoring.** Watch critical config files and inject warnings when they change.

19. **Create a "OLMO Orchestrator" agent definition.** A top-level agent with `tools: Agent(qa-engineer, evidence-researcher, reference-checker)` that coordinates multi-agent workflows.

---

## 11. Fontes

### Official Anthropic Documentation
- [Create custom subagents — Claude Code Docs](https://code.claude.com/docs/en/sub-agents)
- [Extend Claude with skills — Claude Code Docs](https://code.claude.com/docs/en/skills)
- [Hooks reference — Claude Code Docs](https://code.claude.com/docs/en/hooks)
- [Best Practices for Claude Code — Claude Code Docs](https://code.claude.com/docs/en/best-practices)
- [How Claude remembers your project — Claude Code Docs](https://code.claude.com/docs/en/memory)
- [Configure permissions — Claude Code Docs](https://code.claude.com/docs/en/permissions)
- [Model configuration — Claude Code Docs](https://code.claude.com/docs/en/model-config)
- [Manage costs effectively — Claude Code Docs](https://code.claude.com/docs/en/costs)
- [Customize your status line — Claude Code Docs](https://code.claude.com/docs/en/statusline)
- [Discover and install prebuilt plugins — Claude Code Docs](https://code.claude.com/docs/en/discover-plugins)
- [Common workflows — Claude Code Docs](https://code.claude.com/docs/en/common-workflows)
- [Extend Claude Code — Claude Code Docs](https://code.claude.com/docs/en/features-overview)
- [Agent SDK overview — Claude API Docs](https://platform.claude.com/docs/en/agent-sdk/overview)
- [Orchestrate teams of Claude Code sessions — Claude Code Docs](https://code.claude.com/docs/en/agent-teams)
- [Claude Code Advanced Patterns (Webinar)](https://www.anthropic.com/webinars/claude-code-advanced-patterns)

### GitHub Repositories
- [anthropics/skills — Official Agent Skills repository](https://github.com/anthropics/skills)
- [anthropics/claude-code — Official Claude Code repository](https://github.com/anthropics/claude-code)
- [anthropics/claude-plugins-official — Official plugins directory](https://github.com/anthropics/claude-plugins-official)
- [hesreallyhim/awesome-claude-code — Curated list of skills, hooks, agents, plugins](https://github.com/hesreallyhim/awesome-claude-code)
- [travisvn/awesome-claude-skills — Curated Claude Skills collection](https://github.com/travisvn/awesome-claude-skills)
- [rohitg00/awesome-claude-code-toolkit — 135 agents, 35 skills, 42 commands, 150+ plugins](https://github.com/rohitg00/awesome-claude-code-toolkit)
- [VoltAgent/awesome-agent-skills — Official + community skills from dev teams](https://github.com/VoltAgent/awesome-agent-skills)
- [disler/claude-code-hooks-mastery — Hooks patterns and examples](https://github.com/disler/claude-code-hooks-mastery)
- [disler/claude-code-hooks-multi-agent-observability — OTel hook monitoring](https://github.com/disler/claude-code-hooks-multi-agent-observability)
- [ColeMurray/claude-code-otel — OpenTelemetry for Claude Code](https://github.com/ColeMurray/claude-code-otel)
- [0xrdan/claude-router — Intelligent model routing](https://github.com/0xrdan/claude-router)
- [shanraisshan/claude-code-best-practice — Practice collection](https://github.com/shanraisshan/claude-code-best-practice)
- [OthmanAdi/planning-with-files — Persistent markdown planning](https://github.com/OthmanAdi/planning-with-files)

### Community Articles & Guides
- [How I Use Every Claude Code Feature — Shrivu Shankar](https://blog.sshh.io/p/how-i-use-every-claude-code-feature)
- [Claude Code CLI: The Complete Guide — Blake Crosley](https://blakecrosley.com/guides/claude-code)
- [Claude Code Hooks Tutorial: 5 Production Hooks — Blake Crosley](https://blakecrosley.com/blog/claude-code-hooks-tutorial)
- [Claude Code Hooks Reference: All 12 Events — Pixelmojo](https://www.pixelmojo.io/blogs/claude-code-hooks-production-quality-ci-cd-patterns)
- [How I Automated My Entire Claude Code Workflow — DEV Community](https://dev.to/ji_ai/how-i-automated-my-entire-claude-code-workflow-with-hooks-5cp8)
- [The Ultimate Claude Code Guide — DEV Community](https://dev.to/holasoymalva/the-ultimate-claude-code-guide-every-hidden-trick-hack-and-power-feature-you-need-to-know-2l45)
- [Claude Code Customization: CLAUDE.md, Skills, Subagents — alexop.dev](https://alexop.dev/posts/claude-code-customization-guide-claudemd-skills-subagents/)
- [From Tasks to Swarms: Agent Teams — alexop.dev](https://alexop.dev/posts/from-tasks-to-swarms-agent-teams-in-claude-code/)
- [CLAUDE.md Examples and Best Practices 2026 — Morph](https://www.morphllm.com/claude-md-examples)
- [Claude Code Memory Management: Complete Guide 2026 — Medium](https://medium.com/data-science-collective/claude-code-memory-management-the-complete-guide-2026-b0df6300c4e8)
- [Claude Code Context Buffer: The 33K-45K Token Problem — claudefa.st](https://claudefa.st/blog/guide/mechanics/context-buffer-management)
- [Claude Code 1M Context Window — claudefa.st](https://claudefa.st/blog/guide/mechanics/1m-context-ga)
- [Multi-agent orchestration for Claude Code — Shipyard](https://shipyard.build/blog/claude-code-multi-agent/)
- [You (probably) don't understand Claude Code memory — Substack](https://joseparreogarcia.substack.com/p/claude-code-memory-explained)
- [Claude Code Dreams: Auto-Dream Memory Consolidation — claudefa.st](https://claudefa.st/blog/guide/mechanics/auto-dream)
- [Anatomy of the .claude/ Folder — Daily Dose of DS](https://www.dailydoseofds.com/p/anatomy-of-the-claude-folder/)
- [Bringing Observability to Claude Code: OTel — SigNoz](https://signoz.io/blog/claude-code-monitoring-with-opentelemetry/)
- [Skill System — DeepWiki](https://deepwiki.com/anthropics/claude-code/3.7-custom-slash-commands)
- [Multi-Agent Orchestration with Smart Routing — BSWEN](https://docs.bswen.com/blog/2026-03-22-claude-code-multi-agent-routing/)
- [Claude Code Subagents and Coordination — Rick Hightower](https://medium.com/@richardhightower/claude-code-subagents-and-main-agent-coordination-a-complete-guide-to-ai-agent-delegation-patterns-a4f88ae8f46c)
- [Four Memory Layers of Claude Code — Sakeeb Rahman](https://www.threads.com/@sakeeb.rahman/post/DWSKluJEdWG/)
- [How Claude Code Got Better by Protecting Context — Hyperdev](https://hyperdev.matsuoka.com/p/how-claude-code-got-better-by-protecting)
- [What is Plan Mode? — Armin Ronacher](https://lucumr.pocoo.org/2025/12/17/what-is-plan-mode/)

---

*Documento compilado em 2026-04-06. Fontes verificadas via WebSearch + WebFetch.*
*Coautoria: Lucas + Opus 4.6 (orquestracao + redacao)*
