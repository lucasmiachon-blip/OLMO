# Patch Architecture Plan

> Bug: Hook silent timeout (codex Stop hook stdin block on Windows)
> Routing: mas
> Confidence: high

## Source Inputs Considered

- collector (complexity_score 75)
- strategist (top hypothesis: fs.readFileSync(0) blocks before stopReviewGate flag check — design flaw "gate-before-side-effect" violation)
- archaeologist (top historical: KBP-35 + cc-gotchas tracking; OLMO has no local patch policy for plugin bugs; issue #191 OPEN since 2026-04-09)
- adversarial (top challenge: Windows-specific assumption may be wrong; manifest timeout 5ms in S/E hooks is unreachable; resource exhaustion category not considered)

## Cross-Validation

### Root causes appearing in ≥2 sources

- **stdin block before flag check**: strategist (first-principles design analysis) + archaeologist (KBP-35 tracking confirms this exact diagnose). HIGH confidence cross-validated.

### Root causes unique to one source

- **Manifest timeout 5ms unreachable** (adversarial only): config drift across hooks beyond Stop. Not corroborated by strategist or archaeologist. MEDIUM-LOW confidence — separate bug, not the Stop bug primario.

### Sources discordam em

- Strategist + archaeologist treat #191 as Windows-specific stdin handling. Adversarial challenges with "may be cross-platform with different prevalence" — sample size 1 issue, no Linux comments, inconclusive. Tension unresolved but NOT decisive (KBP-35 policy applies independently of platform scope).

## Root Cause Decision

**Primary root cause:** Plugin codex@openai-codex (`stop-review-gate-hook.mjs`) calls `fs.readFileSync(0)` (sync stdin read) BEFORE checking `config.stopReviewGate` flag. On Windows Git Bash, parent process does not close stdin pipe, causing infinite block until manifest timeout (900ms) silently terminates the hook.

**Rationale:** strategist's first-principles "gate-before-side-effect" design analysis is corroborated by archaeologist's tracking of KBP-35 (already documented this exact diagnose in cc-gotchas.md). High cross-validated confidence.

**Secondary contributing factor (per adversarial):** manifest timeout 5ms in SessionStart/SessionEnd hooks of the same plugin manifest is also unreachable — separate config drift issue, NOT the Stop bug. Documented for separate tracking.

## Proposed Changes

**ZERO local file changes.** Per KBP-35 policy: plugin bugs in third-party packages are NEVER patched locally. Local patches in `~/.claude/plugins/cache/` are overwritten on plugin update; wrapper scripts depend on fragile internals.

**Action items (non-code):**

### File: .claude/rules/cc-gotchas.md (Upstream plugin bugs section)

Already updated in S247 commit cb86724. No further edit needed — entry exists tracking issue #191. Confirmation: Read cc-gotchas.md confirms `## Upstream plugin bugs` section + codex#191 entry.

### File: (no others — KBP-35 mandates upstream-only resolution)

## Risks

- **Risco 1**: Bug noise persists in session logs (.stop-failure-sentinel) until upstream merges fix. **Mitigacao**: noise is non-blocking (config.stopReviewGate=false default → hook function = no-op). Aceito como residual per KBP-35 documentado em cc-gotchas.md.
- **Risco 2**: Plugin update could change manifest schema. **Mitigacao**: re-validate KBP-35 entry quando plugin atualizar (current 1.0.3, monitor for 1.0.5+).

## Rollback Plan

N/A — no local changes. Upstream issue #191 tracking only.

## KBP References

- KBP-35: Plugin bug local-patch trap (workaround entulho) — defines policy "NEVER patch in third-party plugin cache"
- KBP-32: Spot-check AUSENTE claims — applied here (archaeologist claim "OLMO has no patch" confirmed via Grep cc-gotchas.md)

## Validation Pre-Patch (Lucas confirm gate — D10)

- [ ] Lucas confirma KBP-35 policy aplica (no local patch even if technically possible)
- [ ] Lucas valida que upstream comment em #191 esta postado (ou autoriza posting)
- [ ] Lucas confirma que noise no .stop-failure-sentinel e aceitavel ate upstream merge

## Validation Post-Patch (validator — Phase 5)

- [ ] cc-gotchas.md entry para #191 ainda existe (no regression in S247 commit)
- [ ] Sentinel log continua registrando (esperado — bug ainda externo)
- [ ] Nenhum arquivo no plugin cache foi modificado (negative test — `git status` shows zero changes outside `.claude-tmp/`)
