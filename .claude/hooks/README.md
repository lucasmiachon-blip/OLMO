# Hooks — Reference

> 33 command hooks + 2 inline prompts = 35 hook registrations across 11 events in `.claude/settings.json` (S272 INV-4 v2 audit-fix — S271 added Stop[1] tier-S Pre-mortem prompt bumping prompts 1→2).
> Scripts live in 2 dirs: `.claude/hooks/` (17 — tool guards + antifragile) and `hooks/` (15 — lifecycle + APL + loop/failure hooks) plus `tools/integrity.sh`.
> Config: `.claude/settings.json`. Local overrides (permissions only): `.claude/settings.local.json`.

## Events Covered

SessionStart · UserPromptSubmit · PreToolUse · PostToolUse · Notification · PreCompact · PostCompact · Stop · StopFailure · PostToolUseFailure · SessionEnd

---

## `.claude/hooks/` — Tool Guards + Antifragile (17 scripts)

### PreToolUse (Read)

| Script | Behavior | What it guards |
|--------|----------|----------------|
| `guard-read-secrets.sh` | **BLOCK** | `.env`, `.pem`, `.key`, `.p12`, `.pfx`, `.jks` and other credential files |

### PreToolUse (Write|Edit)

| Script | Behavior | What it guards |
|--------|----------|----------------|
| `guard-write-unified.sh` | **ASK/BLOCK** | Merged S194: protected files (hooks/, settings.local.json), generated artifacts (`content/aulas/*/index.html`). Silently allows `/memory/` and `.session-name` |

### PreToolUse (ExitPlanMode)

| Script | Behavior | What it guards |
|--------|----------|----------------|
| `allow-plan-exit.sh` | **ASK** | Prompts user to approve plan before exiting plan mode |

### PreToolUse (Bash)

| Script | Behavior | What it guards |
|--------|----------|----------------|
| `guard-secrets.sh` | **BLOCK** | `git commit/add` with staged files containing API keys, tokens, PATs |
| `guard-bash-write.sh` | **ASK/BLOCK** | Shell write patterns. Redirect/cp/mv/chmod ask; `rm/rmdir` block while KBP-26 makes ask unreliable |
| `guard-lint-before-build.sh` | **BLOCK** | Build commands without passing 3 linters first (timeout: 30s) |

### PreToolUse (Skill)

| Script | Behavior | What it guards |
|--------|----------|----------------|
| `guard-research-queries.sh` | **ASK/BLOCK** | Research/evidence skill queries validation (matches `Skill(research*|evidence*)`) |

### PreToolUse (mcp__.*)

| Script | Behavior | What it guards |
|--------|----------|----------------|
| `guard-mcp-queries.sh` | **ASK/BLOCK** | MCP call validation (query shape, destructive ops on shared systems) |

### PreToolUse (.*) — Momentum Brake

| Script | Behavior | What it does |
|--------|----------|--------------|
| `momentum-brake-enforce.sh` | **ASK** | If momentum brake armed + tool not exempt: forces permissionDecision:ask. Exempt: Read/Grep/Glob/Bash/ToolSearch/AskUserQuestion/EnterPlanMode/ExitPlanMode |

### PostToolUse (Bash)

| Script | Behavior | What it does |
|--------|----------|--------------|
| `post-bash-handler.sh` | **LOG** | Post-Bash processing (session tracking, command classification) |

### PostToolUse (Write|Edit)

| Script | Behavior | What it does |
|--------|----------|--------------|
| `lint-on-edit.sh` | **WARN** | Auto-lint slides on edit. L5 self-healing (timeout: 15s) |

### PostToolUse (Agent)

| Script | Behavior | What it does |
|--------|----------|--------------|
| `nudge-checkpoint.sh` | **LOG** | Commit reminder after significant subagent work |

### PostToolUse (Edit)

| Script | Behavior | What it does |
|--------|----------|--------------|
| `coupling-proactive.sh` | **WARN** | Detects coupled files that should be updated together (propagation map) |

### PostToolUse (Agent|Bash) — Antifragile

| Script | Behavior | What it does |
|--------|----------|--------------|
| `chaos-inject-post.sh` | **INJECT** | L6 chaos: injects fake failures into `/tmp` state files. **Opt-in by default** — activate via `CHAOS_MODE=1 claude code` (session-scoped). Zero overhead when off (S256 B.1 D1 confirmed Lucas). Async |
| `model-fallback-advisory.sh` | **WARN** | L2 fallback: detects model errors, suggests downgrade. Circuit breaker (2 fails/5min). Async |

### PostToolUse (.*)

| Script | Behavior | What it does |
|--------|----------|--------------|
| `post-global-handler.sh` | **LOG** | Global post-tool-use pipeline (telemetry, generic post-processing) |

### UserPromptSubmit

| Script | Matcher | What it does |
|--------|---------|--------------|
| `momentum-brake-clear.sh` | (unconditional) | Clears momentum-brake lock when user sends message |

---

## `hooks/` — Session Lifecycle + APL (15 scripts)

### UserPromptSubmit — APL + Nudges

| Script | What it does |
|--------|--------------|
| `ambient-pulse.sh` | APL: 1-line rotating nudge per prompt (QA/focus/commit/deadline/cost) |
| `nudge-commit.sh` | Warns when uncommitted work accumulates (idle since last commit) |

### SessionStart

| Script | Matcher | What it does |
|--------|---------|--------------|
| `session-start.sh` | (unconditional) | Injects project name, date, session number, HANDOFF.md |
| `session-compact.sh` | `compact` | Re-injects critical rules + HANDOFF after context compaction |
| `apl-cache-refresh.sh` | (unconditional) | APL: initializes session timer + caches BACKLOG, QA coverage, deadline |

### Notification

| Script | What it does |
|--------|--------------|
| `notify.sh` | Windows 11 toast "Aguardando input" (visual only, no beep). Async |

### PreCompact

| Script | What it does |
|--------|--------------|
| `pre-compact-checkpoint.sh` | Saves critical context before compaction |

### PostCompact

| Script | What it does |
|--------|--------------|
| `post-compact-reread.sh` | Re-reads essential context after compaction completes |

### PostToolUse

| Script | What it does |
|--------|--------------|
| `loop-guard.sh` | Detects repeated tool/action loops and surfaces corrective guidance |

### Stop (5 registrations: 1 inline + 4 scripts)

> **S256 B.2:** Removido Stop[1] inline agent (HANDOFF/CHANGELOG hygiene check via Sonnet) — era redundante com `stop-quality.sh:82-100` que faz mesma verificação via bash. Lucas decision D2 (a) remove. ~$0.10-0.50/mês economia. Stop array indices shifted: Stop[4] era integrity (was Stop[5]).

| Hook | Type | What it does |
|------|------|--------------|
| (inline `prompt`) | CHECK | Silent execution guard + KBP-22: flags 3+ action tool calls without user-facing explanation. Also skip-rationalization detector |
| `stop-quality.sh` | CHECK | **Merged** `stop-crossref-check` + `stop-detect-issues` + `stop-hygiene`. Self-healing writes `.claude/pending-fixes.md` |
| `stop-metrics.sh` | METRICS | **Merged** `stop-scorecard` + `stop-chaos-report`. APL 2-line session summary. Async |
| `stop-notify.sh` | NOTIFY | Windows 11 toast "Pronto" (visual only). Async |
| `tools/integrity.sh` | VERIFY | Repo integrity check (cross-refs). Async |

### StopFailure

| Script | What it does |
|--------|--------------|
| `stop-failure-log.sh` | Logs Stop hook failures + API errors to `hook-log.jsonl` + sentinel `.stop-failure-sentinel` (KBP-26 monitoring) |

### PostToolUseFailure

| Script | What it does |
|--------|--------------|
| `post-tool-use-failure.sh` | Logs tool failures to `hook-log.jsonl` + injects corrective guidance |

### SessionEnd

| Script | What it does |
|--------|--------------|
| `session-end.sh` | End-of-session cleanup. Async |

---

## Libraries (`.claude/hooks/lib/`)

| Script | Used by | Purpose |
|--------|---------|---------|
| `retry-utils.sh` | lint-on-edit, guard-lint-before-build | L1: exponential backoff + jitter |
| `chaos-inject.sh` | chaos-inject-post.sh | L6: chaos injection vectors + probability roll |

---

## History

**Merged (pre-S230):**
- `stop-quality.sh` ← `stop-crossref-check.sh` + `stop-detect-issues.sh` + `stop-hygiene.sh`
- `stop-metrics.sh` ← `stop-scorecard.sh` + `stop-chaos-report.sh`
- `guard-write-unified.sh` (S194) ← `guard-pause.sh` + `guard-generated.sh` + `guard-product-files.sh`

**Removed (no current implementation — L3 cost brake broken):**
- `build-monitor.sh` (PostToolUse Bash build telemetry)
- `cost-circuit-breaker.sh` (L3 cost brake WARN@100/BLOCK@400 — gap)
- `momentum-brake-arm.sh` (arm-after-tool; replaced by enforce + clear pattern)

---

## Exit Codes

- `0` = OK (allow). May include `systemMessage` in stdout JSON.
- `2` = BLOCK (deny). stderr becomes feedback for Claude.
- Other = non-blocking warning.

## JSON Input (stdin)

```json
{
  "session_id": "...",
  "tool_name": "Write",
  "tool_input": { "file_path": "...", "content": "..." }
}
```

Scripts use `node -e` for JSON parsing (single spawn, cross-platform).

## Configuration

All hooks wired in `.claude/settings.json` under the `"hooks"` key. Local permission overrides (not hooks) in `.claude/settings.local.json`. The `hooks/` directory is NOT git hooks — it contains Claude Code lifecycle scripts.
