# Claude Code Hooks Ecosystem: State of the Art (April 2026)

Research for OLMO project. Current state: 29 bash scripts, 8/27 events, all `type: "command"`, version 2.1.110.

---

## 1. Hookify (Official Anthropic Plugin)

### Status: PRODUCTION, actively maintained

Hookify is a **first-party Anthropic plugin** (lives in `anthropics/claude-code/plugins/hookify`). It is NOT a replacement for raw hooks in settings.json — it is a **simplification layer on top of them**. Think of it as a markdown-driven rule compiler.

### How it works

1. You create `.claude/hookify.<rule-name>.local.md` files in your project
2. Each file has YAML frontmatter defining: event type, action (warn/block), pattern (regex), conditions
3. Hookify compiles these into the hook system at runtime — no manual `settings.json` editing
4. The markdown body below the frontmatter is the **message shown to the user** when the rule triggers

### YAML Frontmatter fields

```yaml
---
name: block-destructive-ops      # unique identifier
enabled: true                     # toggle without deleting
event: bash|file|stop|prompt|all  # what to intercept
action: warn|block                # warn = advisory, block = hard stop
pattern: rm\s+-rf|dd\s+if=       # Python regex
conditions:                       # optional, for multi-field matching
  - field: file_path
    operator: regex_match
    pattern: \.env$
  - field: new_text
    operator: contains
    pattern: API_KEY
---
```

### Event mapping (5 Hookify events -> native hook events)

| Hookify event | Maps to               |
|---------------|-----------------------|
| `bash`        | PreToolUse (Bash)     |
| `file`        | PreToolUse (Edit/Write/MultiEdit) |
| `stop`        | Stop                  |
| `prompt`      | UserPromptSubmit      |
| `all`         | All events            |

### Commands

```
/hookify "block rm -rf commands"   # AI-assisted rule creation
/hookify                           # analyze conversation for patterns
/hookify:list                      # show all loaded rules
/hookify:configure                 # interactive enable/disable
```

### What it CAN'T do (limitations vs raw hooks)

- **Only 2 actions**: warn and block. Cannot return `updatedInput`, `additionalContext`, `permissionDecision: "ask"`, or `permissionDecision: "defer"`.
- **No complex branching**: One pattern per rule. If you need "if X and not Y unless Z", you need raw hooks.
- **No http/agent/prompt handler types**: Hookify generates `command` type hooks only.
- **5 event types only**: No access to the 22 other native events (SubagentStart, PermissionDenied, FileChanged, etc.).
- **No `if` field support**: Cannot use the v2.1.85+ permission-rule filtering.
- **No async/asyncRewake**: All rules are synchronous.

### Installation

```bash
# Auto-discovery from Claude Code Marketplace (built-in)
# Manual:
claude --plugin-dir /path/to/hookify
```

Requirements: Python 3.7+ (stdlib only, no deps).

### ROI for OLMO

**LOW-MEDIUM.** Your 29 scripts are already more sophisticated than what Hookify generates. Hookify is ideal for teams starting from zero or for quickly adding simple warn/block rules. Your guard-bash-write.sh (which returns `updatedInput` and `permissionDecision`) cannot be replicated in Hookify.

**Useful for**: Quickly adding new simple warn/block rules without touching settings.json. Good complement to your existing hooks, not a replacement.

### Windows 11 + Git Bash

Works (Python-based, no shell dependency). The `.local.md` suffix means rules are gitignored by default.

---

## 2. `prompt` Type Hooks

### Status: PRODUCTION (fixes still landing — v2.1.92, v2.1.98, v2.1.101 all patched prompt hook bugs)

### How it works

A `prompt` hook sends a **single-turn evaluation** to a fast Claude model (Haiku by default). The model reads the hook's JSON input (via `$ARGUMENTS` placeholder) and returns a structured decision.

### Syntax

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Review the assistant's final response. Did it complete ALL tasks the user asked for, or did it rationalize skipping something? If it skipped work, say BLOCK. $ARGUMENTS",
            "model": "fast-model",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### What the model returns

The model returns JSON matching the standard hook output schema. For Stop hooks, it returns `{ "decision": "block", "reason": "..." }` or lets it through. The model is instructed by the system to return structured JSON.

### Cost per invocation

- Uses Haiku 4.5 (the "fast-model" default): **$1/M input, $5/M output**
- Typical hook input is ~500-2000 tokens. Typical output is ~50-100 tokens.
- **Estimated cost per invocation: $0.001-$0.003** (fractions of a cent)
- On Max subscription ($0 API cost): **FREE** — Haiku calls within Claude Code Max do not count as separate API calls
- **Latency: ~1-3 seconds** per invocation (Haiku is fast, but it's still an LLM round-trip)

### Can it replace a 100+ line bash guard?

**Partially.** A prompt hook excels at semantic/intent evaluation ("is this command dangerous?") but is non-deterministic. A bash script checking `grep -q 'rm -rf'` always matches; a prompt hook checking "is this destructive?" might miss edge cases or false-positive on safe commands.

**Best pattern**: Use prompt hooks for **semantic judgment** (Stop anti-rationalization, UserPromptSubmit intent validation) and bash hooks for **deterministic pattern matching** (regex guards, file path checks).

### Known bugs (recently fixed)

- v2.1.92: Stop prompt hooks incorrectly failing when model returns `ok:false`
- v2.1.98: prompt-type Stop/SubagentStop hooks failing on long sessions
- v2.1.101: hook evaluator API errors showing wrong message

### ROI for OLMO

**HIGH for Stop event.** Trail of Bits uses a prompt-type Stop hook as an "anti-rationalization gate" — exactly the semantic check that bash cannot do well. Your `stop-quality.sh` could be enhanced or replaced.

**MEDIUM for PreToolUse.** Your deterministic guards (guard-bash-write.sh etc.) are better as bash. But a prompt hook could add a "second opinion" layer for edge cases.

### Windows 11 + Git Bash

No shell dependency — runs inside Claude Code's runtime. Works identically on all platforms.

---

## 3. `if` Conditions (v2.1.85+)

### Status: PRODUCTION (since March 26, 2026)

### What it does

The `if` field uses **permission rule syntax** to narrow when a hook fires, so the hook process only spawns when the specific condition matches. This reduces overhead (no bash process spawn for non-matching calls).

### Syntax

```json
{
  "type": "command",
  "if": "Bash(git *)",
  "command": "bash \"$CLAUDE_PROJECT_DIR\"/.claude/hooks/check-git.sh"
}
```

### Pattern syntax (same as permission rules)

```
"if": "Bash(rm *)"           // Only rm commands
"if": "Edit(*.ts)"           // Only TypeScript edits
"if": "Bash(git pull)"       // Exact command prefix
"if": "WebFetch(*api*)"      // URL contains 'api'
"if": "Bash(npm run build*)" // npm build commands
```

### Which events support `if`

**ONLY tool events:**
- PreToolUse
- PostToolUse
- PostToolUseFailure
- PermissionRequest
- PermissionDenied

**NOT supported on:** UserPromptSubmit, Stop, SessionStart, PreCompact, etc. (hooks with `if` on non-tool events **silently never fire**).

### OLMO already uses this

Your settings.json already has two `if` conditions:
```json
"if": "Bash(*git *)"          // guard-secrets.sh
"if": "Bash(*npm run build*)" // guard-lint-before-build.sh
```

### ROI for OLMO

**HIGH, zero-cost improvement.** Several of your PreToolUse hooks check the tool input inside the bash script and exit 0 early if not relevant. Moving that filter to `if` saves a process spawn entirely.

**Candidates for `if` migration:**
- `guard-bash-write.sh` on Bash matcher: could add `if` to narrow to write-like commands
- `guard-research-queries.sh` on Skill matcher: could filter to specific skills
- `guard-mcp-queries.sh`: could use `if` with `mcp__*__write*` pattern

### Windows 11 + Git Bash

No shell dependency — evaluated inside Claude Code before spawning any process.

---

## 4. `$CLAUDE_PROJECT_DIR`

### Status: PRODUCTION, works on all platforms

### What it is

An environment variable set by Claude Code when spawning hook processes. Contains the **absolute path to the project root** (where `.claude/` directory lives).

### How to use

```json
{
  "type": "command",
  "command": "bash \"$CLAUDE_PROJECT_DIR\"/.claude/hooks/my-hook.sh"
}
```

Note the **double quotes** around `$CLAUDE_PROJECT_DIR` — essential for paths with spaces.

### Inside hook scripts

```bash
#!/usr/bin/env bash
set -euo pipefail
PROJECT="$CLAUDE_PROJECT_DIR"
source "$PROJECT/hooks/lib/common.sh"
```

### Other available environment variables

| Variable | Available in | Purpose |
|----------|-------------|---------|
| `$CLAUDE_PROJECT_DIR` | All hooks | Project root |
| `$CLAUDE_ENV_FILE` | SessionStart, CwdChanged, FileChanged | Write env vars to persist |
| `$CLAUDE_CODE_REMOTE` | All hooks | "true" if web environment |
| `${CLAUDE_PLUGIN_ROOT}` | Plugin hooks only | Plugin install dir |
| `${CLAUDE_PLUGIN_DATA}` | Plugin hooks only | Plugin data dir |

### Windows (MSYS/Git Bash) behavior

- On Windows with Git Bash, `$CLAUDE_PROJECT_DIR` contains a **MSYS-style path**: `/c/Dev/Projetos/OLMO`
- This works natively in Git Bash scripts
- **MSYS path mangling caveat**: Set `MSYS_NO_PATHCONV=1` if paths are being mangled
- **CRLF caveat**: Hook `.sh` files MUST use LF line endings. Set `.gitattributes`:
  ```
  hooks/*.sh text eol=lf
  .claude/hooks/*.sh text eol=lf
  ```

### ROI for OLMO

**HIGH, easy migration.** Your current settings.json has **all 29 hooks hardcoded** to `/c/Dev/Projetos/OLMO/...` paths. Migrating to `"$CLAUDE_PROJECT_DIR"` makes:
1. Config portable across machines
2. Paths resilient to directory renames
3. Easier to share `.claude/settings.json` (project-level) with collaborators

**Migration is mechanical**: find-replace `/c/Dev/Projetos/OLMO` with `"$CLAUDE_PROJECT_DIR"` in settings.json. Example:

Before:
```json
"command": "bash /c/Dev/Projetos/OLMO/hooks/session-start.sh"
```

After:
```json
"command": "bash \"$CLAUDE_PROJECT_DIR\"/hooks/session-start.sh"
```

---

## 5. `http` and `agent` Handler Types

### 5a. HTTP Hooks (`type: "http"`)

**Status: PRODUCTION**

Sends the hook's JSON input as an HTTP POST to an endpoint. The endpoint returns the standard hook JSON output schema.

```json
{
  "type": "http",
  "url": "http://localhost:8080/hooks/pre-tool-use",
  "timeout": 30,
  "headers": {
    "Authorization": "Bearer $MY_TOKEN"
  },
  "allowedEnvVars": ["MY_TOKEN"]
}
```

**Response handling:**
- 2xx + empty body = success (pass)
- 2xx + JSON body = parsed as hook output (can block/allow/modify)
- Non-2xx = non-blocking error, continues
- Connection failure/timeout = non-blocking error, continues (fail-open)

**Use cases:**
- Central hook server for team-wide policy enforcement
- Integration with external services (Slack notifications, CI triggers)
- Webhook-based audit logging
- WorktreeCreate with `hookSpecificOutput.worktreePath`

**ROI for OLMO: LOW.** You're a solo developer. HTTP hooks add infrastructure (must run a server). Only useful if you later build a central policy server or integrate with external APIs.

### 5b. Agent Hooks (`type: "agent"`)

**Status: PRODUCTION (documented but no changelog entry for introduction)**

Spawns a Claude subagent with access to Read, Grep, and Glob tools. The agent evaluates the condition and returns a structured decision.

```json
{
  "type": "agent",
  "prompt": "Check if this file edit follows our coding conventions. Look at similar files in the same directory for patterns. $ARGUMENTS",
  "timeout": 60
}
```

**Characteristics:**
- Default timeout: 60s (longer than prompt hooks)
- Has tool access: can read files, search codebase
- Consumes tokens (multiple LLM turns possible)
- Most expensive and slowest hook type
- Best for checks requiring **multi-file context** (e.g., "does this migration have matching RLS policy?")

**ROI for OLMO: LOW-MEDIUM.** High latency and token cost per invocation make it impractical for frequent events like PreToolUse. Could be valuable for rare, high-stakes checks (e.g., pre-commit validation of evidence HTML). But your current bash hooks are faster and cheaper for the checks you run.

### Windows 11 + Git Bash

Both work identically on all platforms — no shell dependency.

---

## 6. Community Projects

### 6a. disler/claude-code-hooks-mastery

**Stars: significant. Actively maintained.**

**Architecture:**
- 13 hook events implemented as standalone Python UV scripts
- Each script has inline dependency declarations (PEP 723):
  ```python
  # /// script
  # requires-python = ">=3.10"
  # dependencies = ["requests", "anthropic"]
  # ///
  ```
- Run via `uv run $CLAUDE_PROJECT_DIR/.claude/hooks/[hook_name].py`
- Organized in `.claude/hooks/` with `validators/` and `utils/` subdirectories

**Key patterns:**
- **Builder/Validator**: Two-agent teams — builders execute, validators verify (read-only)
- **TTS priority**: ElevenLabs > OpenAI > pyttsx3 for audio feedback
- **Security blocking**: PreToolUse blocks dangerous patterns with exit code 2
- **UserPromptSubmit**: Validates and enhances prompts before Claude sees them

**Relevance for OLMO:** The UV single-file script pattern is elegant but requires Python + UV on the machine. Your bash scripts are simpler and have no runtime dependency. The builder/validator pattern is interesting for future QA workflows.

### 6b. trailofbits/claude-code-config

**Security-focused. Minimal by design.**

**Philosophy:** "Hooks are not a security boundary — a prompt injection can work around them. They are structured prompt injection at opportune times."

**Baseline (only 2 hooks recommended):**
1. Block `rm -rf` (suggest `trash` instead)
2. Block direct push to main/master

**Notable patterns:**
- **Anti-rationalization gate**: A `type: "prompt"` Stop hook that sends Claude's response to Haiku to judge whether it rationalized skipping work
- **Audit logging**: Classifying CLI mutations as reads vs writes, logging only mutations
- Both hooks use `jq` to parse stdin JSON, exit 2 to block

**Relevance for OLMO:** The anti-rationalization prompt hook is directly applicable to your `stop-quality.sh`. Their minimalist philosophy ("2 hooks baseline") contrasts with your 29, suggesting consolidation is warranted.

### 6c. Other notable projects (2026)

- **adrozdenko/hookify-plus**: Enhanced hookify with `not_regex_match`, `value` key, and `read` event support — extends Hookify's capabilities
- **aaronvstory/claude-code-windows-setup**: Production-ready setup for Windows with path translation and Git Bash integration — relevant for your Windows environment
- **shanraisshan/claude-code-best-practice**: Community best practices collection
- **obra/superpowers**: Advanced hook patterns (noted issue: Stop hook hangs when Haiku API times out)

---

## 7. Hook Consolidation Patterns

### Current OLMO state

8 events used, 29 scripts:
- SessionStart: 3 scripts
- UserPromptSubmit: 3 scripts
- PreToolUse: 9 scripts (7 matchers)
- PostToolUse: 7 scripts (5 matchers)
- Notification: 1 script
- PreCompact: 1 script
- PostCompact: 1 script
- Stop: 4 scripts

### Performance impact

All hooks are synchronous. **PreToolUse fires on every tool call.** With 9 hooks registered (some on `.*` matcher), that's potentially 9 bash process spawns per tool call. At ~200-500ms each on Windows, that's 2-4.5 seconds of latency per tool call.

### Consolidation strategies

**Strategy 1: Merge same-matcher hooks into single scripts**

Before (3 separate Bash matchers in PreToolUse):
```json
{ "matcher": "Bash", "hooks": [{ "command": "guard-secrets.sh", "if": "Bash(*git *)" }] },
{ "matcher": "Bash", "hooks": [{ "command": "guard-bash-write.sh" }] },
{ "matcher": "Bash", "hooks": [{ "command": "guard-lint-before-build.sh", "if": "Bash(*npm run build*)" }] }
```

After (1 matcher, `if` narrows scope):
```json
{
  "matcher": "Bash",
  "hooks": [
    { "command": "guard-bash-unified.sh", "timeout": 5000 },
    { "command": "guard-secrets.sh", "if": "Bash(*git *)", "timeout": 5000 },
    { "command": "guard-lint-before-build.sh", "if": "Bash(*npm run build*)", "timeout": 30000 }
  ]
}
```

Note: hooks within the same matcher group run in parallel.

**Strategy 2: Use `if` to prevent spawning**

Move regex checks from inside scripts to `if` field:
```json
{
  "matcher": "Bash",
  "hooks": [
    {
      "type": "command",
      "if": "Bash(*rm *|*mv *|*cp *|*> *|*>> *)",
      "command": "guard-bash-write.sh"
    }
  ]
}
```

**Strategy 3: Replace advisory hooks with prompt type**

Hooks that only add context/warnings (not block) could become prompt hooks:
- `nudge-commit.sh` -> prompt hook ("remind user if many uncommitted changes")
- `nudge-checkpoint.sh` -> prompt hook
- `model-fallback-advisory.sh` -> prompt hook

**Strategy 4: Consolidate catch-all `.*` matchers**

`momentum-brake-enforce.sh` (PreToolUse `.*`) and `post-global-handler.sh` (PostToolUse `.*`) fire on EVERY tool call. Consider whether `if` conditions or async execution could reduce their cost.

**Strategy 5: Use async for non-blocking hooks**

Hooks that only log/notify and don't affect behavior should be `"async": true`:
- `stop-metrics.sh`
- `stop-notify.sh`
- `chaos-inject-post.sh`
- `model-fallback-advisory.sh`

---

## Prioritized Action List

### Tier 1: Zero-cost, immediate ROI

| # | Action | Effort | Impact |
|---|--------|--------|--------|
| 1 | **Replace all 29 hardcoded paths** with `"$CLAUDE_PROJECT_DIR"` | 15 min | Portability, correctness |
| 2 | **Add `set -euo pipefail`** to the 26 scripts missing `set -u` | 30 min | Prevent undefined variable bugs |
| 3 | **Add `"async": true`** to non-blocking hooks (metrics, notify, chaos) | 5 min | Reduce latency on Stop and PostToolUse |
| 4 | **Add `if` conditions** to PreToolUse Bash hooks that filter internally | 20 min | Skip process spawns |

### Tier 2: Medium effort, high impact

| # | Action | Effort | Impact |
|---|--------|--------|--------|
| 5 | **Consolidate 3 Bash PreToolUse matchers** into 1 matcher group | 1h | Fewer JSON entries, parallel execution |
| 6 | **Replace stop-quality.sh with prompt-type hook** | 1h | Semantic anti-rationalization check (a la Trail of Bits) |
| 7 | **Fix 3 security vulns** (printf injection, eval injection, JSON hand-assembly) | 1-2h | Security hygiene |
| 8 | **Audit orphaned scripts** (scripts in hooks/ not referenced in settings.json) | 30 min | Remove dead code |

### Tier 3: Architectural modernization

| # | Action | Effort | Impact |
|---|--------|--------|--------|
| 9 | **Install Hookify** for quick warn/block rules | 30 min | Faster rule creation for simple cases |
| 10 | **Evaluate Python UV** (disler pattern) for complex hooks | 2-4h | Better maintainability for complex logic, but adds UV dependency |
| 11 | **Add agent-type hook** for pre-commit evidence HTML validation | 2h | Deep verification before critical operations |
| 12 | **Migrate from `.*` catch-all** to explicit per-tool matchers | 1-2h | Reduce unnecessary hook execution |

### Skip (low ROI for solo dev)

- HTTP hooks (need server infrastructure)
- Full rewrite to Python (bash works, 29 scripts already invested)
- Agent hooks on frequent events (too slow, too expensive)

---

## Key Takeaways

1. **Your version (2.1.110) supports everything.** All features discussed are in production.
2. **`$CLAUDE_PROJECT_DIR` + `if` conditions** = highest ROI per minute invested.
3. **Prompt hooks for Stop** = the one semantic improvement that bash cannot replicate.
4. **Hookify complements, never replaces** your existing hooks. Good for quick additions.
5. **Windows deadlock issue** (issue #34457 on v2.1.73) has been partially addressed in v2.1.90, but monitor if you experience hangs. Your current setup at v2.1.110 should be stable.
6. **Consolidation priority**: reduce PreToolUse hooks (9 -> 5 entries), add async flags, add `if` conditions.

---

## Sources

- [Hooks Reference - Official Docs](https://code.claude.com/docs/en/hooks)
- [Hooks Guide - Official Docs](https://code.claude.com/docs/en/hooks-guide)
- [Changelog - Official Docs](https://code.claude.com/docs/en/changelog)
- [Hookify Plugin - anthropics/claude-code](https://github.com/anthropics/claude-code/tree/main/plugins/hookify)
- [disler/claude-code-hooks-mastery](https://github.com/disler/claude-code-hooks-mastery)
- [trailofbits/claude-code-config](https://github.com/trailofbits/claude-code-config)
- [adrozdenko/hookify-plus](https://github.com/adrozdenko/hookify-plus)
- [aaronvstory/claude-code-windows-setup](https://github.com/aaronvstory/claude-code-windows-setup)
- [Windows hooks deadlock - Issue #34457](https://github.com/anthropics/claude-code/issues/34457)
- [Fixing Claude Code's PowerShell Problem with Hooks](https://blog.netnerds.net/2026/02/claude-code-powershell-hooks/)
- [Claude Code Hooks - Pixelmojo](https://www.pixelmojo.io/blogs/claude-code-hooks-production-quality-ci-cd-patterns)
- [Claude Code Hooks - SmartScope](https://smartscope.blog/en/generative-ai/claude/claude-code-hooks-guide/)
