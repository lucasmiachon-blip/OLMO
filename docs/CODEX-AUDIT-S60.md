# Codex Audit S60 — Dual-Frame (Objetivo + Adversarial)

> 2026-04-03 | Codex GPT-5.4 via Claude Code rescue
> Frame: Objetivo (audit tecnico) + Adversarial (red team)

## Status Tracker

| # | Sev | Finding | Status |
|---|-----|---------|--------|
| O1 | HIGH | guard-generated.sh fail-open on bad JSON | [ ] |
| O2 | MED | guard-product-files.sh missing _manifest.js | [x] FIXED B1 |
| O3 | MED | guard-secrets.sh exit 1 instead of exit 2 | [ ] |
| O4 | HIGH | guard-bash-write.sh JSON truncation (sed) | [ ] |
| O5 | HIGH | guard-bash-write.sh missing cp/mv/dd/install/rsync/perl | [ ] |
| O6 | HIGH | guard-lint-before-build.sh only runs lint-slides | [ ] |
| O7 | HIGH | guard-lint-before-build.sh same JSON parsing fragility | [ ] |
| O8 | MED | build-monitor.sh no aula resolution for build-html.ps1 | [ ] |
| O9 | MED | build-monitor.sh writes NOTES.md outside guard path | [ ] |
| O10 | LOW | session-start.sh session number regression | [ ] |
| O11 | MED | stop-hygiene.sh ignores staged changes | [ ] |
| O12 | HIGH | Bash(*) broad permission despite incomplete guards | [ ] |
| O13 | HIGH | lint-slides.js ignores --aula argument | [ ] |
| O14 | LOW | lint-case-sync.js unreachable branch | [ ] |
| O15 | MED | lint-narrative-sync.js silent default to cirrose | [ ] |
| O16 | LOW | guard-pause.sh whitelist inconsistency file_path vs path | [ ] |
| A1 | HIGH | Tool choice bypass: cp/mv/dd bypass guards | [ ] |
| A2 | HIGH | Pattern evasion: JSON truncation hides writes | [ ] |
| A3 | HIGH | Symlink traversal bypasses path guards | [ ] |
| A4 | HIGH | Fail-open: malformed JSON disables 4 guards | [ ] |
| A6 | **CRIT** | Config attack: Edit settings.local.json removes hooks | [x] FIXED B1 |
| A8 | MED | Compaction exploit: post-compact loses rules | [ ] |
| A9 | HIGH | Script evasion: npm run build / npx vite build bypass | [ ] |
| A10 | **CRIT** | Secret exfiltration: Read .env + WebFetch | [x] FIXED B1 |

Note: A5 (race conditions) and A7 (memory poisoning) had no proven PoC — excluded.
O4=A2, O5=A1, O1/O7=A4 overlap — fix once covers both frames.

## Batch Plan

### Batch 1: CRITICAL — Config & Secret Protection
- A6: Add guard blocking edits to settings.local.json and hooks/
- A10: Add guard blocking Read of .env, .pem, credential files

### Batch 2: HIGH — JSON Parsing Hardening
- O4/A2/O7/A4/O1: Replace sed JSON parsing with node in ALL hooks
- Fail-closed default (exit 2) on parse failure

### Batch 3: HIGH — Missing Write Primitives
- O5/A1: Add cp, mv, dd, install, rsync, perl to guard-bash-write
- A9/O6: Expand build detection + add case-sync/narrative-sync lints

### Batch 4: MEDIUM — Guard Consistency
- O2: Add _manifest.js to guard-product-files
- O3: Fix guard-secrets exit codes (1 → 2)
- O8: Add build-html.ps1 aula resolution in build-monitor
- O9: build-monitor writes to temp instead of repo
- O11: stop-hygiene.sh check staged + unstaged
- O15: lint-narrative-sync.js require explicit aula

### Batch 5: LOW — Polish
- O10: session-start.sh take max session number
- O14: lint-case-sync.js remove dead branch
- O16: guard-pause.sh normalize path extraction

---

## Detailed Findings

### OBJECTIVE FRAME

#### O1: guard-generated.sh fail-open on bad JSON
**Severity:** HIGH
**File:** `.claude/hooks/guard-generated.sh:9`
**Issue:** Node JSON parse suppressed with 2>/dev/null. If stdin is malformed, FILE_PATH is empty, script exits 0 (ALLOW). Should exit 2 (BLOCK).
**Fix:** Add `|| exit 2` after node parse. Treat empty FILE_PATH on Write/Edit as block.

#### O2: guard-product-files.sh missing _manifest.js
**Severity:** MEDIUM
**File:** `.claude/hooks/guard-product-files.sh:42`
**Issue:** Patterns cover slides HTML, CSS, shared JS, slide-registry.js, index.html — but NOT `slides/_manifest.js` which defines production slide ordering.
**Fix:** Add `content/aulas/[^/]+/slides/_manifest\.js$` to PRODUCT_PATTERNS.

#### O3: guard-secrets.sh exit 1 instead of exit 2
**Severity:** MEDIUM
**File:** `.claude/hooks/guard-secrets.sh:56`
**Issue:** Symlink and .env blocking branches use `exit 1` instead of the documented `exit 2` for blocks. Inconsistent with other guards.
**Fix:** Replace `exit 1` with structured JSON error + `exit 2`.

#### O4: guard-bash-write.sh JSON truncation
**Severity:** HIGH
**File:** `.claude/hooks/guard-bash-write.sh:10`
**Issue:** `sed` regex stops at first `"` in JSON. Commands with embedded quotes (e.g., `bash -lc "echo > file"`) are truncated before the write primitive.
**Fix:** Parse with `node -e` instead of sed. Fail-closed on parse error.

#### O5: guard-bash-write.sh missing primitives
**Severity:** HIGH
**File:** `.claude/hooks/guard-bash-write.sh:23`
**Issue:** Missing: cp, mv, dd, install, rsync, perl -pi, ruby -e, truncate, touch (content write).
**Fix:** Expand pattern list or invert to allowlist approach.

#### O6: guard-lint-before-build.sh only runs lint-slides
**Severity:** HIGH
**File:** `.claude/hooks/guard-lint-before-build.sh:45`
**Issue:** Only runs lint-slides.js. lint-case-sync.js and lint-narrative-sync.js never enforced.
**Fix:** Run all three linters. Block if any fails.

#### O7: guard-lint-before-build.sh JSON parsing fragility
**Severity:** HIGH
**File:** `.claude/hooks/guard-lint-before-build.sh:12`
**Issue:** Same sed-based extraction as guard-bash-write. Same truncation vulnerability.
**Fix:** Parse with node. Fail-closed.

#### O8: build-monitor.sh no aula for build-html.ps1
**Severity:** MEDIUM
**File:** `.claude/hooks/build-monitor.sh:38`
**Issue:** Direct `powershell -File metanalise/scripts/build-html.ps1` on non-matching branch produces no failure log.
**Fix:** Parse `<aula>/scripts/build-html.ps1` from command path.

#### O9: build-monitor.sh writes outside guards
**Severity:** MEDIUM
**File:** `.claude/hooks/build-monitor.sh:57`
**Issue:** Appends to NOTES.md from PostToolUse — bypasses guard-pause.
**Fix:** Write to /tmp or a dedicated log file outside repo.

#### O10: session-start.sh number regression
**Severity:** LOW
**File:** `hooks/session-start.sh:15`
**Issue:** Uses first match, not latest. Can regress session numbering.
**Fix:** Take numeric max of all matched session numbers.

#### O11: stop-hygiene.sh ignores staged
**Severity:** MEDIUM
**File:** `hooks/stop-hygiene.sh:17`
**Issue:** Only checks `git diff --name-only`. Staged updates to HANDOFF/CHANGELOG not detected.
**Fix:** Combine `git diff --name-only` with `git diff --cached --name-only`.

#### O12: Bash(*) broad permission
**Severity:** HIGH
**File:** `.claude/settings.local.json:4`
**Issue:** Allows arbitrary shell. Guards are regex-based and incomplete.
**Note:** Not actionable without major workflow changes. Document as accepted risk.

#### O13: lint-slides.js ignores --aula
**Severity:** HIGH
**File:** `content/aulas/scripts/lint-slides.js:10`
**Issue:** Walks entire content/aulas tree regardless of --aula argument. Unrelated aula errors block current build.
**Fix:** Parse --aula and scope to that directory.

#### O14: lint-case-sync.js dead branch
**Severity:** LOW
**File:** `content/aulas/scripts/lint-case-sync.js:162`
**Issue:** Unreachable condition in manifest loop.
**Fix:** Remove dead branch.

#### O15: lint-narrative-sync.js silent default
**Severity:** MEDIUM
**File:** `content/aulas/scripts/lint-narrative-sync.js:33`
**Issue:** Defaults to cirrose when no arg and branch doesn't match pattern.
**Fix:** Require explicit aula or fail with error message.

#### O16: guard-pause.sh whitelist inconsistency
**Severity:** LOW
**File:** `.claude/hooks/guard-pause.sh:21`
**Issue:** Extracts path from both file_path and path keys, but whitelist only re-checks file_path.
**Fix:** Use already-extracted normalized path for whitelist check.

### ADVERSARIAL FRAME

#### A6: Config attack — Edit settings.local.json
**Severity:** CRITICAL
**File:** `.claude/settings.local.json`
**PoC:** `Edit .claude/settings.local.json` → remove PreToolUse hooks → no guards for rest of session.
**Impact:** One approved edit disables entire guard stack.
**Fix:** Block writes to `.claude/settings.local.json` and `.claude/hooks/*` with exit 2.

#### A10: Secret exfiltration — Read .env
**Severity:** CRITICAL
**File:** (no hook on Read tool)
**PoC:** `Read .env` → print contents → or WebFetch to external URL.
**Impact:** Agent can disclose secrets without triggering any guard.
**Fix:** Add PreToolUse(Read) hook blocking .env, .pem, credentials.json, *_key files.

---

Coautoria: Lucas + Opus 4.6 + Codex GPT-5.4 | 2026-04-03
