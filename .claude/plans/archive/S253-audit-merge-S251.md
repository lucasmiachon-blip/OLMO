# Audit Merge S251 — Phase 1 Decision Matrix (3-model independent review)

> **Phase 1 deliverable** | Sessão S250 | 2026-04-25 | Coautoria: Lucas + Opus 4.7
> **Source plan:** `.claude/plans/validated-noodling-codd.md` Batch C
> **Phase 2+ execution:** S251+ (após Lucas review desta matriz)

---

## Method

3 independent model voices ran the same audit prompt + JSON schema:

| Voice | Model | Tool | Output stats |
|-------|-------|------|--------------|
| Opus 4.7 | claude-opus-4-7[1m] | internal reasoning | 10 merges, 3 SOTA gaps, 7 no-action, 6 meta |
| Gemini 3.1 Deep Think | gemini-3.1-pro-preview + google_search | `gemini-research.mjs` | 9 merges, 3 gaps, 3 no-action, 3 meta |
| ChatGPT 5.5 xhigh | gpt-5.5 + Codex CLI | `codex exec --output-schema` | 11 merges, 7 gaps, 5 no-action, 4 meta |

**Convergence rules:**
- **3/3 high** → ADOPT-NOW (cheap + verified)
- **2/3** → DEFER pending Phase 2 spot-check
- **1/3 high** → flag as FP candidate (evidence-anchored opinion overrides solo-voice)
- **Divergence** → Opus orchestrator arbitrates citing local evidence (KBP-32 spot-check)

**Spot-check operations performed mid-synthesis:**
- Confirmed janitor SKILL.md description vs repo-janitor.md description (ChatGPT 1/3 candidate validated)
- Confirmed chaos-inject-post.sh L7 ordering comment exists (ChatGPT claim validated)
- Confirmed all 32 hooks registered in `.claude/settings.json` (69 cmd-instances, refutes Gemini "orphan" hypothesis)
- Confirmed `.claude/skills/research/SKILL.md` L65-67 orchestrates 3 research agents (refutes Opus initial "lacks orchestrator" gap)
- Confirmed automation/improve/continuous-learning are 3 distinct domains via grep description fields (refutes Gemini MERGE)

---

## Section 1 — Convergence Matrix (Lucas-flagged 7 hypotheses)

| # | Components | Opus | Gemini | ChatGPT | Convergence | Final action |
|---|------------|------|--------|---------|-------------|--------------|
| H1 | evidence-researcher vs researcher | KEEP_SEPARATE high | KEEP_SEPARATE high | KEEP_SEPARATE high | **3/3** | **KEEP_SEPARATE** + rename `researcher` → `codebase-explorer` (P2 clarity) |
| H2 | sentinel vs repo-janitor | KEEP_SEPARATE high | MERGE medium | KEEP_SEPARATE high | **2/3** + Gemini lacks evidence_external | **KEEP_SEPARATE** (Gemini = FP) |
| H3 | quality-gate vs qa-engineer | KEEP_SEPARATE high | KEEP_SEPARATE high | KEEP_SEPARATE high | **3/3** | **KEEP_SEPARATE** + optional rename `quality-gate` → `precommit-lint`, `qa-engineer` → `slide-qa-gemini` (P2 clarity) |
| H4 | systematic-debugging skill vs debug-team skill | DEFER high | CUT high | MERGE high | **3/3 want change**, action varies | **MERGE** systematic-debugging into debug-team as lightweight/solo fallback section + remove standalone trigger (ChatGPT specific proposal) |
| H5 | automation vs improve vs continuous-learning | KEEP_SEPARATE high | MERGE high | KEEP_SEPARATE high | **2/3** Opus+ChatGPT vs Gemini | **KEEP_SEPARATE** (Gemini lacked grep verification, refuted by spot-check 2026-04-25) |
| H6 | insights skill vs sentinel agent | KEEP_SEPARATE medium | KEEP_SEPARATE medium | KEEP_SEPARATE high | **3/3** | **KEEP_SEPARATE** (producer/consumer relationship, not merge) |
| H7 | docs-audit skill vs repo-janitor agent | DEFER medium | KEEP_SEPARATE medium | KEEP_SEPARATE high | **2/3 KEEP** | **KEEP_SEPARATE** with optional repo-janitor → docs-audit delegation for deep doc quality (ChatGPT meta-finding) |

---

## Section 2 — Beyond Lucas-flagged (ChatGPT-discovered)

| # | Components | Opus | Gemini | ChatGPT | Convergence | Final action |
|---|------------|------|--------|---------|-------------|--------------|
| X1 | **janitor skill vs repo-janitor agent** | NOT_RAISED | NOT_RAISED | MERGE high | **1/3 high + spot-check confirmed** | **ADOPT-NEXT** (Phase 2): keep repo-janitor as executor, janitor skill becomes thin wrapper or delete |
| X2 | systematic-debugger AGENT vs debug-team agents | CUT high | NOT_ADDRESSED | DEFER medium | **2/3 want change** | **DEFER** Phase 2 measurement: after H4 merge, measure if systematic-debugger agent gets distinct successful use; otherwise CUT or map to debug-strategist |
| X3 | **chaos-inject-post + model-fallback-advisory hooks ordering** | NOT_RAISED | NOT_RAISED | MERGE high | **1/3 high + spot-check confirmed comment L7** | **ADOPT-NEXT** (Phase 2): merge into single ordered handler OR change chaos to affect next-cycle only (ordering invariant invalid under hook parallelism per Anthropic docs) |
| X4 | debug-architect vs debug-patch-editor | KEEP (no_action) | KEEP (no_action) | KEEP_SEPARATE high (Aider pattern) | **3/3** | **KEEP_SEPARATE** confirmed Aider Architect/Editor SOTA (S27 evidence) |

---

## Section 3 — Refuted hypotheses (Gemini false positives)

| Claim | Gemini said | Spot-check result | Verdict |
|-------|-------------|-------------------|---------|
| MERGE 4× stop-* hooks (`stop-quality`, `stop-metrics`, `stop-failure-log`, `stop-notify`) | high confidence "MERGE saves 1.2s overhead" | ChatGPT meta-obs cite `.claude/hooks/README.md:145-178` — these are ALREADY consolidation targets | **REFUTED** — already consolidated |
| MERGE hooks/ vs .claude/hooks/ paths | high confidence "config drift" | All 32 hooks registered active in settings.json (verified); both paths intentional | **REFUTED** — both paths active |
| MERGE many hooks "likely dead/unused, settings.json audit needed" | high confidence | Verified 32 unique paths registered, 69 cmd-instances total | **REFUTED** — zero orphans |

---

## Section 4 — SOTA Gaps Consolidated

Cross-voice strongest gaps (P0-P1):

| # | Component | Gap | Priority | Source | Voices |
|---|-----------|-----|----------|--------|--------|
| G1 | **Read-only audit agents** (debug-symptom-collector, repo-janitor, researcher, sentinel, systematic-debugger, quality-gate) | Use `disallowedTools` denylist instead of explicit `tools` allowlist. Per Claude docs, omitted tools INHERIT parent tool pool including MCP tools — denylist is leakier than expected | **P1 high** | https://code.claude.com/docs/en/subagents | ChatGPT |
| G2 | **debug-team durable state** | Ad-hoc `.claude-tmp/` JSON + markdown plan; no checkpointer/thread-id/idempotent task boundary equivalent. Crash recovery is stale-flag based | **P1 high** | https://docs.langchain.com/oss/javascript/langgraph/durable-execution | ChatGPT |
| G3 | **debug-team routing calibration + token tracking** | complexity_score threshold=75 hardcoded conservadora; Phase metrics field "tokens / wall-clock" pending. Multi-agent SOTA emphasizes tracing + evals + token budgets + coordination overhead | **P1 high** | https://www.anthropic.com/engineering/multi-agent-research-system | ChatGPT + Opus |
| G4 | **chaos-inject-post hook ordering** | `model-fallback-advisory.sh` L7 assumes sequential ordering; Anthropic docs say all matching hooks run in parallel | **P1 high** | https://code.claude.com/docs/en/hooks | ChatGPT |
| G5 | **Agent Teams native pattern** | Not evaluated for /debug-team competing-hypotheses phase. Native Agent Teams provide shared tasks + teammate-to-teammate challenge/debate. Adopt only behind measured pilot (experimental) | **P2 high** | https://code.claude.com/docs/en/agent-teams | ChatGPT |
| G6 | **systematic-debugging skill missing modern fields** | Lacks `disable-model-invocation`, `context: fork`, `agent` (used in debug-team SKILL). If kept, add to avoid accidental auto-load + main-context pollution | **P2 high** | https://code.claude.com/docs/en/skills | ChatGPT |
| G7 | **Hooks unit/golden test harness** | No test files found via spot-check (`rg --files | rg test|spec ... bats|shellcheck`). 32 hooks + zero hook tests = regression risk | **P2 low** (source not independently verified) | null | ChatGPT |
| G8 | **Hooks self-disable gates** | Most hooks lack S249 loop-guard.sh self-disable pattern (zero overhead in non-relevant sessions). Some already gated by event matchers; needs measurement before claim | P2 low | null | Opus + Gemini |

---

## Section 5 — ADOPT-NEXT (S251+ execution priority)

**3/3 convergence + cheap + verified** = first-priority Phase 2:

1. **None of Lucas's 7 hypotheses meet 3/3 ADOPT criterion** — all converge on KEEP_SEPARATE or are split DEFER/MERGE/CUT requiring more thought.

**1/3-high-with-spot-check-confirmed (strong evidence overcomes solo-voice):**

1. **X1 — janitor skill → repo-janitor agent MERGE.** Strongest concrete merge. Phase 2 cost ~30min. Effect: -1 skill (janitor → thin wrapper or cut), repo-janitor agent stays canonical executor.
2. **X3 — chaos-inject-post + model-fallback-advisory ordering bug.** Real schema-level invariant violation. Phase 2 cost ~1h: either merge into single ordered handler OR refactor chaos to affect next-cycle. **Risk if not fixed:** chaos engineering tests are unreliable (KBP-21 calibration data corrupted).
3. **H4 — systematic-debugging skill into debug-team.** ChatGPT proposal: fold as lightweight/solo fallback section. Phase 2 cost ~1h: refactor SKILL.md, remove standalone trigger.

**SOTA gaps P1 (research-then-decide):**

4. **G1 — disallowedTools → explicit tools allowlist** for 6 read-only agents. Phase 2 cost ~2h (read each agent + map minimal tools). Hardening, not refactor.
5. **G2 — debug-team durable state** → checkpointer pattern. Phase 2 cost: research dedicated (LangGraph durable-execution + alternatives). Likely multi-session.
6. **G3 — debug-team metrics instrumentation** (tokens + wall-clock per phase). Currently field exists in plan template but populated post-hoc; instrument in SKILL.md state writes.
7. **G4 — chaos+model-fallback hooks** = same as X3 above (G4 is the SOTA-source view, X3 is the merge-action view).

**Defer to S252+ (research-heavy):**

8. **G5 — Agent Teams pilot** (native Anthropic experimental pattern). Quick research first to assess GA timeline.
9. **X2 — systematic-debugger AGENT** measurement post H4 merge.

---

## Section 6 — Cut candidates (1/3 confidence + refuted by spot-check OR aspirational)

None hard-cut from this matrix. All 1/3 candidates either:
- Confirmed by spot-check → ADOPT-NEXT (X1, X3)
- Aspirational without source → DEFER as research probe (G7, G8)

---

## Section 7 — Meta observations (synthesized)

1. **Convergence pattern:** Lucas's 7 flagged hypotheses are mostly **correctly-scoped boundaries** that look like overlap from naming alone. Real merges came from ChatGPT's broader sweep (janitor, chaos-hook ordering). Lesson: **2/3 voices saw inventory and inferred semantic similarity; ChatGPT did file-grep evidence work that surfaced concrete invariant violations**.

2. **3-model methodology validated:** Each voice caught false positives others missed. Gemini's 4 MERGE recommendations: 3 refuted by Opus or ChatGPT spot-check. Opus's "research lacks orchestrator" SOTA gap: self-refuted by reading SKILL.md L65-67. ChatGPT's xhigh reasoning + grep tool use: surfaced 2 high-confidence merges + 7 SOTA gaps with sources. **No single voice would have produced this matrix solo.**

3. **xhigh reasoning ROI:** ChatGPT 5.5 xhigh took ~22min (vs Opus internal ~3min, Gemini ~2min) — but produced quantitatively + qualitatively more (11 merges + 7 gaps with strong source citations). For audit decisions where false-negative cost > waiting cost, xhigh effort earns its time.

4. **Post-S248 debug-team is close to modern orchestrator-worker SOTA.** Next steps are **measurement and durable state** (G2 + G3), NOT adding more agents (Lucas instinct correct: "muitos longe do SOTA" applies less to debug-team than to legacy systematic-debugger + meta-skills).

5. **KBP-32 spot-check methodology paid off in cross-validation:** caught 4+ false positives across 3 voices. Recommendation: enshrine in /research-style skill canonical orchestration (3-model + spot-check loop).

6. **Hook count drift (32 vs 33 vs 13):** ChatGPT meta-obs noted README.md:3-4 says 33 registrations, hooks/ has 13 scripts, settings.json has 32 unique paths. Treat **`.claude/settings.json` as canonical** (executable truth); update `.claude/hooks/README.md` to match.

---

## Section 8 — Phase 2+ execution map (S251+)

**Suggested commit sequence (ship-able independente):**

```
S251.A — H4 systematic-debugging skill → debug-team merge (1 commit, ~1h)
S251.B — X1 janitor skill → repo-janitor merge (1 commit, ~30min)
S251.C — X3 chaos-inject-post ordering fix (1 commit, ~1h, Phase B verifies via test)
S251.D — G1 disallowedTools → tools allowlist 6 agents (1-2 commits, ~2h)
S251.E — G3 debug-team metrics instrumentation (1 commit, ~1h)

S252+ research-heavy:
- G2 durable state checkpointer research + ADR
- G5 Agent Teams pilot evaluation
- X2 systematic-debugger AGENT measurement
```

**Total estimated effort S251:** ~6h (1 session). S252+ multi-session.

---

## Appendix — Raw model outputs (for traceability)

- `.claude-tmp/audit-opus-output.json` (10 merges, 3 gaps, 7 no-action, 6 meta)
- `.claude-tmp/audit-gemini-output.json` (9 merges, 3 gaps, 3 no-action, 3 meta)
- `.claude-tmp/audit-chatgpt-output.json` (11 merges, 7 gaps, 5 no-action, 4 meta)
- `.claude-tmp/audit-prompt-S250.md` + `audit-prompt-S250-codex.md` (input prompts)
- `.claude-tmp/audit-schema.json` (JSON Schema enforced via codex `--output-schema`)

These remain in `.claude-tmp/` as evidence. Do NOT commit (per `.gitignore` `.claude-tmp/`).

---

Coautoria: Lucas + Opus 4.7 (Claude Code) + Gemini 3.1 Deep Think + ChatGPT 5.5 (xhigh) | S250 Batch C Phase 1 | 2026-04-25
