# S269 D-lite Research Rehydration

> Purpose: let the next session restart Lane B with the full mental model, without rereading the whole conversation.

## Cross-Reference Map

This file is the detailed source of truth for S269 D-lite rehydration.

Keep other files short:

- `CLAUDE.md`: Claude Code start pointer and non-negotiable invariant.
- `AGENTS.md`: Codex/Gemini start pointer and cross-CLI invariant.
- `.claude/context-essentials.md`: compact auto-rehydration pointer.
- `HANDOFF.md`: lane router and short gap list.
- `docs/research/sota-S269-agents-subagents-contract.md`: architecture/contract reference.
- `.claude/skills/research/SKILL.md`: executable research-skill behavior.
- `CHANGELOG.md`: historical record only.

If details conflict, prefer this file for S269 D-lite state, then update the short pointers.

## Current Decision

D-lite is **experimental**. The legacy `.mjs` research scripts remain canonical until a live re-bench proves D-lite preserves or improves:

- high recall of useful documents;
- novelty yield from Gemini/Perplexity/Google AI Studio;
- cross-family signal from Codex/ChatGPT-5.5 xhigh;
- downstream verification via Opus, Scite, Consensus, PubMed/NCBI, CrossRef/DOI, MCPs, and source checks;
- cost, latency, and failure auditability.

Do not promote D-lite because the current live sample is partial:

- Perplexity D-lite emitted valid JSON once.
- Codex xhigh emitted valid JSON once and validated through the runner.
- Gemini D-lite is blocked by API quota (`429 RESOURCE_EXHAUSTED`) and earlier showed a JSON truncation failure.

## Core Correction

The first D-lite shape was too narrow: it asked Gemini/Perplexity to emit 3-5 final findings immediately. That reduces false positives but can kill the behavior that made the old scripts valuable: broad, creative capture of non-obvious documents.

The corrected architecture is:

```text
OPEN QUESTION
     |
     v
HIGH-RECALL CAPTURE
Gemini / Google AI Studio
Perplexity
Codex / ChatGPT-5.5 xhigh
Evidence-researcher / MCPs
NLM when available
     |
     v
ResearchCandidateSet
many candidates, explicit unverified status
     |
     v
OPUS / ORCHESTRATOR TRIAGE
keep | reject false positive | defer | missing expected docs
     |
     v
RIGOROUS VERIFICATION
PubMed/NCBI | DOI/CrossRef | Scite | Consensus | MCP | source/web
     |
     v
ResearchPernaOutput
final structured evidence, only after verification
```

The rule is **sensitivity first, specificity second**.

## What Stayed Canonical

### Legacy Gemini Script

Path: `.claude/scripts/gemini-research.mjs`

Status: canonical hot path for Perna 1 until D-lite re-bench passes.

Why it stays:

- It uses Gemini API with Google Search grounding.
- It preserves creative/open discovery from the original pipeline.
- It runs `temperature: 1`, `maxOutputTokens: 32768`, and `thinkingBudget: 16384`.
- It surfaces grounding sources after the generated text.
- It has hardening already present from prior work:
  - HTTP guard before JSON parse;
  - 60s timeout;
  - API error field inspection;
  - `MAX_TOKENS` exits non-zero instead of ingesting truncated output;
  - empty text output exits non-zero.

What S269 changed:

- S269 did **not** edit this script.
- S269 documented that this script remains baseline because it emitted reliably in S264.c and historically found useful non-obvious sources.

### Legacy Perplexity Script

Path: `.claude/scripts/perplexity-research.mjs`

Status: canonical hot path for Perna 5 until D-lite re-bench passes.

Why it stays:

- It uses `sonar-deep-research`.
- It requests citations and `search_context_size: high`.
- It remains a separate web-grounded perna from Gemini and MCPs.
- It preserves discovery of documents that conventional PubMed-first search may miss.
- It has hardening already present from prior work:
  - HTTP guard before JSON parse;
  - 120s timeout;
  - `temperature: 0.2` after S261 hardening;
  - optional `--domain-context`;
  - no silent fallback to stringified raw API;
  - explicit API error inspection.

What S269 changed:

- S269 did **not** edit this script.
- S269 corrected the research skill documentation to say `temperature 0.2`, matching the actual script.

## What Was Created In S269

### New Runner

Path: `.claude/scripts/research-dlite-runner.mjs`

Purpose:

- deterministic facade around Gemini and Perplexity API calls;
- generate provider payloads;
- send provider-compatible JSON Schema subsets;
- parse provider outputs;
- validate locally with stricter schema checks;
- write structured failure artifacts;
- verify PMIDs for final outputs;
- validate existing Codex/ChatGPT-5.5 outputs through the same boundary.

Important options:

```bash
node .claude/scripts/research-dlite-runner.mjs --provider gemini --output-kind candidates --question-id <ID> --question "<OPEN_PROMPT>" --out .claude/.research-tmp/gemini-dlite-<ID>.json
node .claude/scripts/research-dlite-runner.mjs --provider perplexity --output-kind candidates --question-id <ID> --question "<OPEN_PROMPT>" --out .claude/.research-tmp/perplexity-dlite-<ID>.json
node .claude/scripts/research-dlite-runner.mjs --output-kind final --validate-file .claude/.research-tmp/codex-<ID>.json --verify-pmids --out .claude/.research-tmp/codex-<ID>.verified.json
node .claude/scripts/research-dlite-runner.mjs --output-kind candidates --validate-file .claude/.research-tmp/codex-candidates-<ID>.json --out .claude/.research-tmp/codex-candidates-<ID>.validated.json
```

Output kinds:

- `candidates`: high-recall capture. This is the default.
- `final`: final evidence output after triage/verification. Use this with `--verify-pmids`.

Key improvement over old scripts:

- It does not replace their discovery behavior.
- It adds an auditable contract around the discovery output.
- It creates `.failure.json` on provider call/schema/parse failures.
- It prevents DOI/URL from staying `verified=true` when the runner only performed NCBI PMID verification.

### New Candidate Schema

Path: `.claude/schemas/research-candidate-set.json`

Purpose:

- preserve high recall before triage;
- accept many candidates while keeping them explicitly unverified;
- support Tier 1 indexed sources, guidelines, reference books, landmark trials, consensus statements, registry/web fallback IDs, and SOTA sources to the run date.

Important fields:

- `capture_perna`: `gemini`, `perplexity`, `codex-xhigh`, `evidence-researcher`, `nlm`, or `opus-triage`.
- `capture_mode`: `high_recall`, `triage`, or `verification`.
- `candidate_documents[]`: structured candidate documents.
- `source_tier`: `tier1`, `tier2`, `reference_book`, or `candidate_uncertain`.
- `triage_status`: `candidate`, `triage_keep`, `triage_reject`, or `defer`.
- `validation_status`: `unverified`, `pmid_verified`, `doi_verified`, `url_verified`, or `rejected_false_positive`.

This schema is not final medical evidence.

### Existing Final Schema

Path: `.claude/schemas/research-perna-output.json`

Status: still canonical for final perna output.

Use only after the candidate set has gone through triage and verification, or for Codex xhigh outputs that are already intended as final findings.

### New Smoke Test

Path: `scripts/smoke/research-dlite-contract.mjs`

Purpose:

- no-network local test;
- checks runner exists;
- checks final schema exists;
- checks candidate schema exists;
- checks D-lite agents exist;
- runs runner self-test;
- validates final fixture;
- validates candidate fixture;
- dry-runs Gemini and Perplexity payloads;
- confirms deterministic mode sets temperature to 0;
- enforces thin-agent anti-chattiness checks;
- checks contract doc has required sections.

Current PASS command:

```bash
node scripts/smoke/research-dlite-contract.mjs
```

## What Stayed Agent

### Existing Canonical Codex/ChatGPT-5.5 Perna

Path: `.claude/agents/codex-xhigh-researcher.md`

Status: canonical perna #7.

Role:

- cross-family reasoning with GPT-5.5 / Codex xhigh;
- schema-enforced output via Codex CLI;
- independent signal against shared hallucination from Anthropic/Gemini/Perplexity families;
- can do both broad candidate discovery and final structured reasoning, depending on prompt/schema;
- outputs can now be validated by `research-dlite-runner.mjs --validate-file`.

This perna does **not** replace Gemini/Perplexity. It adds diversity.

### Existing Evidence Researcher

Path: `.claude/agents/evidence-researcher.md`

Status: canonical verification/research perna.

Role:

- academic MCP-backed search and verification;
- PubMed/MCP, CrossRef/DOI, Scite, Consensus, and related structured sources where available;
- stronger for verification than web-grounded LLM search when evidence level is equal.

### New D-lite Gemini Agent

Path: `.claude/agents/gemini-dlite-research.md`

Status: experimental.

Role:

- thin wrapper around `research-dlite-runner.mjs`;
- default output is `ResearchCandidateSet`;
- no Write/Edit/MultiEdit/Agent tools;
- no multi-phase narrative;
- should only run for D-lite smoke/re-bench until promoted.

### New D-lite Perplexity Agent

Path: `.claude/agents/perplexity-dlite-research.md`

Status: experimental.

Role:

- thin wrapper around `research-dlite-runner.mjs`;
- default output is `ResearchCandidateSet`;
- no Write/Edit/MultiEdit/Agent tools;
- no multi-phase narrative;
- should only run for D-lite smoke/re-bench until promoted.

### Old Chatty Experimental Agents

Paths:

- `.claude/agents/gemini-deep-research.md`
- `.claude/agents/perplexity-sonar-research.md`

Status: keep, do not delete, but do not promote.

Reason:

- S264.c suggested chatty wrappers spend turns on conversational phases and are worse than direct runners/thin wrappers.
- They remain as historical/experimental references.

## What Stayed Skill

### Research Skill

Path: `.claude/skills/research/SKILL.md`

Status: updated, still the orchestration contract.

What changed:

- D-lite documented as experimental, not canonical.
- Codex/ChatGPT-5.5 xhigh documented as explicit perna #7.
- D-lite commands now default to `--output-kind candidates`.
- Capture vs triage vs verification is explicit.
- Perplexity temperature doc corrected to 0.2.

### No New Research Skill

S269 did not create a new research skill. It created:

- a runner script;
- a candidate schema;
- two thin agents;
- one smoke test;
- one research contract doc;
- this rehydration doc.

If `.claude/skills/document-conversion/` is present, that is Lane D and unrelated to Lane B research D-lite. Do not mix it into Lane B commits or decisions.

## What Improved Relative To The Old Scripts

The legacy scripts were valuable because they captured non-obvious sources. S269 does not remove that. The improvement is the layer around them:

| Capability | Old scripts | S269 D-lite addition |
|---|---|---|
| Broad discovery | Yes | Preserved via `ResearchCandidateSet` |
| Gemini/Google grounded search | Yes | Kept as baseline and D-lite candidate path |
| Perplexity deep research | Yes | Kept as baseline and D-lite candidate path |
| ChatGPT-5.5/Codex cross-family signal | Separate agent | Explicit perna #7 in the comparison |
| Structured candidate capture | Markdown table | JSON candidate schema |
| Final output validation | Partial/manual | JSON final schema + local validator |
| PMID verification | Downstream/manual | `--verify-pmids` for final outputs |
| Failure audit | Console errors | `.failure.json` and raw provider artifact when available |
| Anti-overengineering | Direct scripts | Thin-agent + deterministic runner |
| Promotion discipline | Empirical but scattered | Explicit recall/novelty/schema/cost benchmark |

## Current Live Evidence

Question used: "What is PRISMA 2020 and what changed from PRISMA 2009?"

| Perna | Result | Notes |
|---|---|---|
| Gemini D-lite | BLOCKED | First run returned truncated JSON; later run hit `429 RESOURCE_EXHAUSTED`. No promotion. |
| Perplexity D-lite | PASS | Final-output live smoke wrote `.claude/.research-tmp/perplexity-dlite-smoke-prisma.json`; NCBI checked 2/2 unique PMIDs. |
| Codex/ChatGPT-5.5 xhigh | PASS | Codex CLI 0.125.0 wrote `.claude/.research-tmp/codex-dlite-smoke-prisma.json`; runner revalidated and NCBI checked 4/4 unique PMIDs. |

Important limitation:

- These live tests happened before the candidate-first correction.
- Candidate-first D-lite still needs a real live re-bench.

## Open Gaps

### P0 - Promotion Blockers

1. **Gemini API quota unresolved.**
   - Evidence: D-lite retry returned `429 RESOURCE_EXHAUSTED`.
   - Impact: cannot compare Gemini D-lite vs legacy Gemini.
   - Next: check Google AI Studio/API project quota and billing; do not assume Google AI Ultra app subscription raises API quota.

2. **No candidate-first live benchmark yet.**
   - Evidence: the passing Perplexity/Codex live tests used final output style.
   - Impact: we do not know whether D-lite preserves old-script recall/novelty.
   - Next: run candidate capture for Gemini, Perplexity, and Codex on the same topic as legacy scripts.

3. **No head-to-head legacy vs D-lite comparison.**
   - Evidence: no matrix yet comparing recall, novelty yield, false-positive rate, verified yield, missed anchors, cost/time.
   - Impact: D-lite cannot be canonical.
   - Next: run old scripts and D-lite on the same 2-3 topics, then triage blind.

4. **Opus triage is not yet codified as an executable contract.**
   - Evidence: schema has `triage_status`, but no dedicated triage runner/agent was added.
   - Impact: candidate sets can accumulate without consistent keep/reject/defer decisions.
   - Next: create either a thin `research-triage` agent or a runner mode that emits triage decisions.

### P1 - Verification Gaps

5. **DOI/URL verification is not implemented in the runner.**
   - Current behavior: only PMIDs can be verified by NCBI ESummary.
   - Safe behavior: DOI/URL `verified=true` is reset to false unless a future verifier exists.
   - Next: add CrossRef DOI verification and URL/source identity checks.

6. **Scite and Consensus are documented but not wired into the D-lite runner.**
   - Current behavior: evidence-researcher/skill references them.
   - Gap: candidate set does not yet record Scite/Consensus verdicts as structured fields.
   - Next: triage/verification layer should add `indexing_signal` and validation notes from Scite/Consensus.

7. **Reference books need separate validation.**
   - Current schema supports `document_type=book` and `fallback_id` such as ISBN.
   - Gap: no ISBN/publisher verifier.
   - Next: add manual or API-backed ISBN/publisher check if books become common candidates.

8. **Candidate PMIDs in `ResearchCandidateSet` are not automatically verified.**
   - Rationale: candidate capture should stay high recall and unverified.
   - Gap: no batch verifier for candidate sets yet.
   - Next: build a verifier that converts `candidate_documents[].pmid` to `pmid_verified` or `rejected_false_positive`.

### P2 - Benchmark/Operations Gaps

9. **Cost telemetry is manual.**
   - Need: record approximate per-run cost for Gemini, Perplexity, Codex.
   - Threshold: <= $0.30/question unless Lucas approves.

10. **Latency telemetry is manual.**
    - Need: record runtime per perna in the comparison matrix.

11. **Provider schema compatibility is only smoke-tested locally.**
    - Need: live test candidate schema with Gemini and Perplexity after quota is available.

12. **Failure artifact coverage is improved but incomplete for all external tools.**
    - D-lite runner writes failure artifacts.
    - Legacy scripts still primarily report console errors.
    - Decide whether to backport `.failure.json` style to legacy scripts only if it helps comparison.

13. **No automated recall scoring yet.**
    - Need: a simple matrix or script that counts:
      - total candidates;
      - Tier 1 candidates;
      - unique useful candidates;
      - false positives after triage;
      - missed anchor documents.

14. **No commit yet in this thread.**
    - Current work is in the working tree.
    - Stage only Lane B files if committing; do not use `git add -A` if unrelated Lane D files are present.

## Next Session Playbook

Start:

```bash
git status --short
node scripts/smoke/research-dlite-contract.mjs
codex --version
```

Read:

```text
HANDOFF.md
docs/research/S269-dlite-rehydration.md
docs/research/sota-S269-agents-subagents-contract.md
.claude/skills/research/SKILL.md
```

If Gemini quota is still blocked:

- do not retry many times;
- keep Gemini D-lite as BLOCKED;
- use legacy Gemini only if its quota/project is confirmed working;
- continue with Perplexity/Codex/evidence-researcher for non-promotion experiments.

If Gemini quota is fixed:

1. Pick one topic with known anchor documents.
2. Run legacy Gemini and legacy Perplexity.
3. Run D-lite Gemini and D-lite Perplexity with `--output-kind candidates`.
4. Run Codex/ChatGPT-5.5 xhigh as candidate perna or final perna depending on the experiment.
5. Run Opus triage manually or via a future triage agent.
6. Verify with PubMed/NCBI, DOI/CrossRef, Scite, Consensus, and MCP/source checks.
7. Fill the comparison matrix.
8. Do not promote unless D-lite wins or ties on recall and wins on auditability.

## Comparison Matrix Template

| Topic | Path | Candidates | Tier 1 | Novel useful | False positives | Verified PMIDs | DOI/URL verified | Missed anchors | Cost | Latency | Verdict |
|---|---|---:|---:|---:|---:|---:|---:|---|---:|---:|---|
| TBD | legacy Gemini | | | | | | | | | | |
| TBD | legacy Perplexity | | | | | | | | | | |
| TBD | D-lite Gemini | | | | | | | | | | |
| TBD | D-lite Perplexity | | | | | | | | | | |
| TBD | Codex/ChatGPT-5.5 | | | | | | | | | | |

Verdict values:

- `promote`: D-lite >= legacy on recall and usefulness, and better on auditability.
- `keep-separate`: D-lite improves some pieces but does not beat legacy.
- `archive`: D-lite loses recall/novelty or creates too much operational burden.

## Invariants

- Do not delete legacy scripts or old agents during D-lite.
- Do not replace Gemini/Perplexity/Google AI Studio with Codex.
- Do not let JSON schema narrow discovery too early.
- Do not accept LLM PMIDs as final evidence.
- Do not resolve evidence conflicts by majority before checking evidence hierarchy.
- Do not promote without live re-bench.
- Do not mix Lane B research files with unrelated Lane D document-conversion files in a commit.

## Coauthorship

Coautoria: Lucas + GPT-5.5 (Codex xhigh)
