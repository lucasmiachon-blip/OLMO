# Batch 6 Findings — Hooks Ecosystem Cross-Reference
> Date: 2026-04-07 | Auditor: general-purpose agent (Opus 4.6)
> **CLOSED S102** (2026-04-07): 20 fixed S101, 6 closed (4 intentional/OK, 2 timeout tuning)

## Summary
- Total script files: 30 (18 in `.claude/hooks/`, 12 in `hooks/`)
- Total registrations in settings.local.json: 28
- Library files (not registered, by design): 2 (`.claude/hooks/lib/retry-utils.sh`, `.claude/hooks/lib/chaos-inject.sh`)
- Pre-commit hooks (Git, not Claude): 2 (`guard-secrets-precommit.sh`, `crossref-precommit.sh`)
- Issues found: 14

## Part A — Cross-Reference

### Scripts existing but NOT registered
| Script | Reason / Status |
|--------|-----------------|
| `.claude/hooks/guard-secrets-precommit.sh` | Git pre-commit hook (NOT a Claude hook) — OK by design |
| `.claude/hooks/crossref-precommit.sh` | Git pre-commit hook (NOT a Claude hook) — OK by design |
| `.claude/hooks/lib/retry-utils.sh` | Shared library, sourced by other hooks — OK by design |
| `.claude/hooks/lib/chaos-inject.sh` | Shared library, sourced by chaos-inject-post.sh — OK by design |

### Registrations pointing to nonexistent scripts
None found. All 28 registered paths resolve to existing files.

### Duplicate registrations
None found. Each script is registered exactly once.

## Part B + C — Detailed Findings

| ID | Category | Severity | File | Description | Suggested Fix |
|----|----------|----------|------|-------------|---------------|
| B6-01 | STDIN | P2 | `.claude/hooks/guard-generated.sh` | Uses `INPUT=$(cat 2>/dev/null \|\| echo '{}')` — correct stdin consumption but lacks `set -euo pipefail` | Add `set -euo pipefail` or at minimum `set -u` for variable safety |
| B6-02 | STDIN | P1 | `.claude/hooks/guard-secrets.sh` | Passes stdin JSON via `process.argv[1]` to node instead of reading from stdin. Shell argument size limits (OS-dependent, typically 128KB-2MB) could truncate large tool_input JSON payloads. All other hooks use `readFileSync(0,'utf8')` (stdin) which has no size limit. | Refactor to read from stdin like peer hooks: `echo "$INPUT" \| node -e "const d=JSON.parse(require('fs').readFileSync(0,'utf8'));..."` |
| B6-03 | STDIN | P2 | `.claude/hooks/build-monitor.sh` | Same pattern as B6-02: passes JSON via `process.argv[1]` to node. Additionally passes the full `$INPUT` var (not just a field), compounding truncation risk. | Refactor to stdin-based parsing |
| B6-04 | STDIN | P2 | `.claude/hooks/model-fallback-advisory.sh` | Same pattern as B6-02: passes JSON via `process.argv[1]`. Consistent with guard-secrets.sh but inconsistent with the majority of hooks. | Refactor to stdin-based parsing for consistency |
| B6-05 | STDIN | P2 | `.claude/hooks/lint-on-edit.sh` | Same pattern: passes `$INPUT` via `process.argv[1]` to node at line 12-15. | Refactor to stdin-based parsing for consistency |
| B6-06 | ERROR-HANDLING | P2 | `.claude/hooks/guard-read-secrets.sh` | Fail-OPEN on no input (`exit 0` when `$INPUT` is empty), while comment says "fail-closed". A PreToolUse Read hook with no input is likely a legitimate edge case, but the comment is misleading. | Fix comment to say "fail-open: no input means no file path to check" or change to `exit 2` for true fail-closed |
| B6-07 | ERROR-HANDLING | P1 | `.claude/hooks/cost-circuit-breaker.sh` | Missing stdin consumption entirely — no `cat` or equivalent. Hook protocol requires consuming stdin even if unused. If stdin is not consumed, the parent process may stall waiting for pipe drain. | Add `cat >/dev/null 2>&1` at top of script |
| B6-08 | ERROR-HANDLING | P1 | `hooks/notify.sh` | Missing stdin consumption. The powershell.exe call will not read from stdin, so the hook pipe may remain unconsumed. | Add `cat >/dev/null 2>&1` before powershell.exe call |
| B6-09 | ERROR-HANDLING | P1 | `hooks/stop-notify.sh` | Same issue as B6-08: missing stdin consumption. | Add `cat >/dev/null 2>&1` before powershell.exe call |
| B6-10 | ERROR-HANDLING | P1 | `hooks/stop-hygiene.sh` | Missing stdin consumption. Reads project files directly but never drains stdin. | Add `cat >/dev/null 2>&1` at top of script |
| B6-11 | ERROR-HANDLING | P1 | `hooks/stop-crossref-check.sh` | Missing stdin consumption. | Add `cat >/dev/null 2>&1` at top of script |
| B6-12 | ERROR-HANDLING | P1 | `hooks/stop-detect-issues.sh` | Missing stdin consumption. | Add `cat >/dev/null 2>&1` at top of script |
| B6-13 | ERROR-HANDLING | P1 | `hooks/pre-compact-checkpoint.sh` | Missing stdin consumption. | Add `cat >/dev/null 2>&1` at top of script |
| B6-14 | ERROR-HANDLING | P1 | `hooks/stop-chaos-report.sh` | Missing stdin consumption. The script does file reads but never drains stdin pipe. | Add `cat >/dev/null 2>&1` at top of script |
| B6-15 | DOCS | P2 | `.claude/hooks/README.md` | Line 1: claims "28 Claude Code hook registrations" and "30 script files; 2 are pre-commit hooks". Actual count: 28 registrations (correct), 30 script files total including 2 libs + 2 precommit (correct). The README is accurate. | No fix needed — verified correct |
| B6-16 | DOCS | P2 | `.claude/hooks/README.md` | Table for `guard-secrets.sh` says behavior is "WARN" but the script actually exits with code 2 (BLOCK) on match. | Change README from "WARN" to "BLOCK" |
| B6-17 | DOCS | P2 | `.claude/hooks/README.md` | Table for `allow-plan-exit.sh` says behavior is "ALLOW" but the script returns `permissionDecision: "ask"`, not silent allow. | Change README from "ALLOW" to "ASK" |
| B6-18 | MATCHER | P2 | `.claude/hooks/momentum-brake-arm.sh` | Registered with matcher `.*` (all tools) but comment says "Write|Edit|Bash|Agent". The matcher is broader than documented — it arms on Read, Grep, Glob too, but those are exempt in the enforce hook. Technically harmless but misleading: the lock file is created/overwritten on every single tool use, including passive reads. | Consider narrowing matcher to `Write\|Edit\|Bash\|Agent` to reduce unnecessary file I/O, or update comment to match reality |
| B6-19 | MATCHER | P2 | `.claude/hooks/momentum-brake-enforce.sh` | Exempt list in comment includes `ExitPlanMode` but the `case` statement already handles it. The comment says "Write, Edit — already guarded by guard-pause.sh (avoid double-ask)" are exempt, but Write and Edit are NOT in the case exempt list. This means Write/Edit get BOTH guard-pause.sh ASK and momentum-brake-enforce.sh ASK — double prompting. | Add `Write\|Edit` to the exempt case in momentum-brake-enforce.sh, or document the intentional double-ask |
| B6-20 | ORDERING | P1 | `.claude/hooks/chaos-inject-post.sh` | Comment says "Must be registered BEFORE model-fallback-advisory.sh" but in settings.local.json the ordering is: chaos-inject-post (line 224) then model-fallback-advisory (line 233). Both are PostToolUse Agent|Bash. The registration order appears correct (chaos first, then fallback reads the injected state). Verified OK. | No fix needed — ordering is correct |
| B6-21 | EXIT-CODE | P2 | `.claude/hooks/allow-plan-exit.sh` | Missing stdin consumption — no `cat` call. As a PreToolUse hook, it receives JSON on stdin. Since it does not need to parse input (always returns "ask"), this is low-severity but violates hook protocol. | Add `cat >/dev/null 2>&1` for protocol compliance |
| B6-22 | TIMEOUT | P2 | `.claude/hooks/guard-lint-before-build.sh` | Timeout is 15000ms (15s). The script runs up to 3 lint scripts sequentially, each with up to 3 retry attempts with exponential backoff. Worst case: 3 scripts * 3 retries * (1+2+4s delays) = ~63s, far exceeding the 15s timeout. | Increase timeout to 30000ms, or reduce max_attempts to 2, or run linters in parallel |
| B6-23 | TIMEOUT | P2 | `.claude/hooks/lint-on-edit.sh` | Timeout is 15000ms (15s). Uses retry_with_jitter with 2 attempts and 1s base delay. Worst case: 2 * lint_time + 2s backoff. If lint-slides.js takes >6s, this can timeout. Less severe than B6-22 but worth noting. | Acceptable for now; monitor for timeout occurrences |
| B6-24 | ERROR-HANDLING | P2 | `hooks/session-start.sh` | Missing stdin consumption. SessionStart hooks receive stdin input per protocol. | Add `cat >/dev/null 2>&1` at top of script |
| B6-25 | ERROR-HANDLING | P2 | `hooks/stop-scorecard.sh` | Correctly consumes stdin with `cat > /dev/null 2>&1` — good. But uses hardcoded `PROJECT_ROOT="/c/Dev/Projetos/OLMO"` instead of deriving from script location. Not portable if project moves. | Use `PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"` like peer scripts |
| B6-26 | ERROR-HANDLING | P2 | `hooks/ambient-pulse.sh` | Same hardcoded path issue: `PROJECT_ROOT="/c/Dev/Projetos/OLMO"` | Use `PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"` |

## Severity Summary

| Severity | Count | Description |
|----------|-------|-------------|
| P0 | 0 | No security/data-loss issues found |
| P1 | 9 | Functional gaps: stdin not consumed (7 scripts), JSON via argv truncation risk (1), double-ask UX issue (1) |
| P2 | 17 | Quality/style: missing `set -euo`, misleading comments, doc inaccuracies, hardcoded paths, timeout edge cases |

## Key Patterns Observed

1. **Stdin consumption inconsistency**: 10 of 30 scripts do not consume stdin. The hook protocol requires it. Scripts in `.claude/hooks/` are generally better about this than scripts in `hooks/`. The momentum-brake and APL scripts properly consume stdin; the Stop lifecycle hooks generally do not.

2. **JSON parsing approach split**: Two approaches coexist:
   - **Stdin-based** (majority): `echo "$INPUT" | node -e "...readFileSync(0,'utf8')..."` — correct, no size limits
   - **Argv-based** (4 scripts): `node -e "..." "$INPUT"` — subject to OS arg size limits, inconsistent with peers

3. **Hardcoded paths**: 2 scripts in `hooks/` use absolute paths instead of deriving from `$0`. All `.claude/hooks/` scripts correctly use relative derivation.

4. **README accuracy**: The README is remarkably thorough and mostly accurate. Two minor behavior label mismatches (guard-secrets: WARN vs actual BLOCK; allow-plan-exit: ALLOW vs actual ASK).

5. **Double-ask on Write/Edit**: Both `guard-pause.sh` and `momentum-brake-enforce.sh` fire on Write/Edit, causing two consecutive "ask" prompts. The momentum-brake-enforce.sh comment says Write/Edit are exempt to avoid this, but the code does not implement the exemption.
