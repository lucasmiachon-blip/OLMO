# S269 - Research Agents/Subagents Contract

> Status: active design note. Goal: improve Lane B without deleting legacy runners or chatty experimental agents.
> Full next-session hydration and gap register: `docs/research/S269-dlite-rehydration.md`.

## Problem

Lane B had a false binary framing: `.mjs` scripts versus agents. The S264.c bench already showed the real split:

- Direct `.mjs` runners emitted reliably.
- `codex-xhigh-researcher` emitted reliably because the agent is thin and delegates the hard work to a deterministic subprocess with schema enforcement.
- `gemini-deep-research` and `perplexity-sonar-research` were chatty wrappers with many conversational phases, which added turn overhead before final emit.

The professional target is therefore not "replace scripts with agents". It is:

1. Keep deterministic runners for external API calls.
2. Use agents/subagents as thin policy wrappers when context isolation or tool permissions matter.
3. Enforce structured input/output contracts at the runner boundary.
4. Benchmark before promoting any path to canonical.

## Pipeline Diagram

```text
                     OPEN RESEARCH QUESTION
                              |
                              v
                    ResearchRunSpec v1.0
         (id, question, mode, domain, budget, schema)
                              |
              +---------------+---------------+
              |                               |
              v                               v
      LEGACY BASELINE                    D-LITE CANDIDATE
  .mjs hot path kept                 thin agents + runner
  for comparison                     no legacy deletion
              |                               |
   +----------+----------+        +-----------+-----------+-------------+
   |                     |        |           |           |             |
   v                     v        v           v           v             v
gemini-research.mjs   perplexity  Gemini    Perplexity   Codex/       evidence-
                      research.mjs D-lite    D-lite       ChatGPT-5.5  researcher
                                                        xhigh perna   MCPs
   |                     |        |           |           |             |
   +----------+----------+--------+-----------+-----------+-------------+
                              |
                              v
                    HIGH-RECALL CAPTURE
          Tier 1 indexed sources, reference books, guidelines,
          landmark trials, SOTA to current date, candidate-heavy
                              |
                              v
                    OPUS / ORCHESTRATOR TRIAGE
          keep | reject false positive | defer | expected missing docs
                              |
                              v
                    RIGOROUS CONFIRMATION
          PubMed/NCBI, DOI/CrossRef, Scite, Consensus, MCP/web checks
                              |
                              v
                    CLOSED FINAL BOUNDARY
          ResearchPernaOutput JSON + local validator + artifacts
                              |
                              v
                    COMPARISON MATRIX
       recall | novelty yield | false positive rate | verified yield
       missed anchors | cost/time | final usefulness
                              |
                              v
                      PROMOTE / KEEP / ARCHIVE
```

The key separation is deliberate: discovery stays open; downstream automation stays closed and auditable.
Codex/ChatGPT-5.5 xhigh is a real perna in the ensemble: it contributes independent cross-family candidate capture and can also validate existing perna JSON via `--validate-file`. It does not replace Gemini/Perplexity because Google AI Studio/Gemini search grounding had high recall and useful non-obvious outputs in the legacy path.

## SOTA Readout

Primary-source synthesis as of 2026-04-28:

- Anthropic's agent guidance favors simple, composable workflows and warns against complex frameworks when a simpler workflow works.
- Claude Code subagents are for isolated, self-contained, verbose side tasks with tool restrictions and summarized return, not for replacing every script.
- OpenAI's agent guide recommends starting with a capable baseline, adding evals, then optimizing cost/latency; Agents SDK exposes max-turn loops, handoffs, guardrails, and tracing.
- Google ADK separates deterministic workflow agents from LLM agents and explicitly supports combining deterministic control with flexible LLM sub-agents.
- Gemini, OpenAI, and Perplexity all support JSON Schema structured outputs; schema validity still requires semantic validation downstream.
- MCP tools model both `inputSchema` and optional `outputSchema`; tool execution should keep human denial/approval available for risky operations.
- LangGraph durable execution guidance maps cleanly to this repo's need: side effects and nondeterministic operations must be wrapped and made replay-safe.

Sources:

- Anthropic: https://www.anthropic.com/engineering/building-effective-agents
- Claude Code subagents: https://code.claude.com/docs/en/sub-agents
- Claude Code hooks: https://code.claude.com/docs/en/hooks
- OpenAI agent guide: https://openai.com/business/guides-and-resources/a-practical-guide-to-building-ai-agents/
- OpenAI structured outputs: https://developers.openai.com/api/docs/guides/structured-outputs
- Google ADK workflow agents: https://adk.dev/agents/workflow-agents/
- Gemini structured outputs: https://ai.google.dev/gemini-api/docs/structured-output
- Perplexity structured outputs: https://docs.perplexity.ai/docs/sonar/features
- MCP tools: https://modelcontextprotocol.io/specification/2025-06-18/server/tools
- LangGraph durable execution: https://docs.langchain.com/oss/python/langgraph/durable-execution

## Contract

### ResearchRunSpec

Minimum request object for a research perna:

```json
{
  "schema_version": "1.0",
  "provider": "gemini|perplexity|codex",
  "research_question_id": "R1",
  "research_question": "verbatim question",
  "mode": "exploratory|deterministic",
  "domain_context": "optional clinical focus",
  "output_schema": ".claude/schemas/research-perna-output.json",
  "budget": {
    "timeout_ms": 120000,
    "max_output_tokens": 8000,
    "max_cost_usd": 0.3
  }
}
```

### ResearchPernaOutput

Canonical output remains `.claude/schemas/research-perna-output.json`.

Provider-specific fields that do not fit the current schema are recorded inside existing generic fields:

- `external_brain_used`: provider/model description.
- `codex_cli_version`: reused temporarily for provider runtime/model version until a schema v1.1 renames it.
- `candidate_pmids_unverified`: never final evidence.
- `gaps`: required for preflight/API/schema failures.

No final medical claim may be promoted from this output without PMID/DOI/URL verification by downstream evidence checks.

### ResearchCandidateSet

High-recall capture uses `.claude/schemas/research-candidate-set.json`.

This schema exists to preserve the old scripts' useful behavior: Gemini/Perplexity/Google AI Studio and Codex/ChatGPT-5.5 xhigh may surface many candidates, including non-obvious documents. False positives are acceptable at this layer if they remain explicitly unverified and go through Opus/MCP triage.

Allowed candidate source classes:

- Tier 1 indexed journals and databases.
- Guidelines and consensus statements from major societies.
- Cochrane/systematic reviews/meta-analyses.
- Landmark or practice-changing RCTs.
- Reference books/textbooks with ISBN or publisher/org fallback ID.
- Current SOTA sources up to the run date, when index/ranking signal is explicit.

Not allowed: final medical synthesis directly from candidate capture.

## Deterministic vs Exploratory

The architecture separates freedom from determinism:

| Layer | Purpose | Freedom level | Enforcement |
|---|---|---:|---|
| Research question | Open topic, source discovery | high | prompt/context only |
| Candidate capture | Gemini/Perplexity/Codex explores | high | candidate schema, no final claims |
| Opus triage | reject false positives, flag missing anchors | medium | keep/reject/defer rationale |
| Verification | PubMed/CrossRef/Scite/Consensus/source checks | deterministic | explicit PASS/FAIL |
| Final boundary output | JSON object | low | final schema + local validation |
| Synthesis | convergence/divergence | bounded | rules in research skill |

This keeps the model free where discovery matters and deterministic where downstream automation depends on shape and provenance.
Runner `--mode exploratory` preserves provider-specific research sampling defaults. Runner `--mode deterministic` lowers sampling temperature to 0 for repeatable contract checks; it is still not treated as medical evidence without downstream source verification.

## Anti-overengineering Rules

1. No new multi-phase agent body for external APIs.
2. No replacement of a working runner until a benchmark beats it.
3. No deletion of legacy `.mjs` or old agents during D-lite.
4. New agents must be thin: one deterministic command, bounded context, JSON output.
5. Smoke tests must run without API keys.
6. Live tests with API keys are optional and cost-gated.

## New S269 Components

- `.claude/scripts/research-dlite-runner.mjs`: deterministic runner facade with dry-run, payload generation, provider schema hardening, output parsing, raw failure artifacts, and local schema spot-check. Default output is now high-recall `--output-kind candidates`.
- `.claude/schemas/research-candidate-set.json`: high-recall candidate-capture schema for Tier 1 documents, reference books, guidelines, landmark trials, and SOTA sources before Opus/MCP verification.
- Optional `--verify-pmids`: post-schema NCBI ESummary check that marks supporting PMID sources as verified, keeps unverified/fabricated IDs as candidates, and resets non-PMID `verified=true` flags unless a future DOI/URL verifier is added.
- Optional `--validate-file`: applies the same local validation/PMID verification boundary to existing perna outputs, including `codex-xhigh-researcher` files.
- `.claude/agents/gemini-dlite-research.md`: thin Claude Code subagent for Gemini D-lite testing.
- `.claude/agents/perplexity-dlite-research.md`: thin Claude Code subagent for Perplexity D-lite testing.
- `scripts/smoke/research-dlite-contract.mjs`: no-network smoke for runner payloads, schema validation, and anti-chattiness checks.

Legacy components remain available:

- `.claude/scripts/gemini-research.mjs`
- `.claude/scripts/perplexity-research.mjs`
- `.claude/agents/gemini-deep-research.md`
- `.claude/agents/perplexity-sonar-research.md`

Implementation note: the runner sends a provider-compatible JSON Schema subset to Gemini/Perplexity and keeps the stricter local validator as the final boundary. This avoids coupling live provider calls to every JSON Schema 2020-12 keyword in the canonical repo schema.

## Promotion Gate

D-lite can become canonical only if a re-bench passes:

| Metric | Threshold |
|---|---:|
| Local smoke | PASS |
| Live emit rate | 6/6 |
| JSON schema valid | 6/6 |
| PMID fabrication in spot-check | <=10% |
| Cost per question | <= $0.30 unless Lucas approves |
| Output usefulness | >= legacy path in blind review |

If D-lite fails, keep the legacy `.mjs` hot path and archive the D-lite agents as experimental notes.

## Comparison Plan

We compare the paths as engineering systems, not as "agent vibes":

| Dimension | Legacy `.mjs` baseline | D-lite candidate | Pass criterion |
|---|---|---|---|
| Emit reliability | Existing Gemini/Perplexity scripts | Gemini/Perplexity D-lite + Codex validate-file | D-lite emits at least as reliably as baseline |
| Recall | Broad candidate table | `ResearchCandidateSet` | D-lite finds at least as many useful candidate docs |
| Novelty yield | Non-obvious docs from scripts | Non-obvious docs from D-lite | D-lite preserves or improves unique useful finds |
| Output shape | Markdown/table parse contract | Candidate JSON + final JSON | 6/6 schema-valid outputs |
| Evidence integrity | PMIDs remain candidates downstream | Opus/MCP triage + `--verify-pmids` on final outputs | PMID fabrication <=10%; unverified stays candidate |
| Failure handling | Console/script errors | `.failure.json` + raw provider artifact when available | Every live failure leaves auditable artifact |
| Research freedom | Open prompt in script | Open prompt in provider call | No forced deterministic prompt that narrows discovery |
| Determinism | Script parameters | Runner parameters + schema boundary | Repeatable payload/dry-run + deterministic validation |
| Agent overhead | None | Thin subagent wrapper only | No multi-phase narrative; maxTurns <=6 |
| Cost/latency | Measured baseline | Measured live smoke/re-bench | <= $0.30/question unless Lucas approves |
| Usefulness | Blind review of findings | Blind review of candidate set + final synthesis | D-lite >= baseline usefulness |

Decision rule:

```text
if D-lite >= legacy on reliability + validity + evidence integrity + usefulness:
  promote D-lite
elif D-lite fixes a subset but not all:
  keep legacy canonical, keep D-lite experimental
else:
  archive D-lite as failed experiment
```

## Verification

Local, no API:

```bash
node scripts/smoke/research-dlite-contract.mjs
```

Optional live smoke, cost-gated:

```bash
node .claude/scripts/research-dlite-runner.mjs --provider gemini --output-kind candidates --question-id smoke --question "What is PRISMA 2020?" --out .claude/.research-tmp/gemini-candidates-smoke.json
node .claude/scripts/research-dlite-runner.mjs --provider perplexity --output-kind candidates --question-id smoke --question "What is PRISMA 2020?" --out .claude/.research-tmp/perplexity-candidates-smoke.json
node .claude/scripts/research-dlite-runner.mjs --output-kind final --validate-file .claude/.research-tmp/codex-smoke.json --verify-pmids --out .claude/.research-tmp/codex-smoke.verified.json
```

Live smoke requires `GEMINI_API_KEY` or `PERPLEXITY_API_KEY` and network access.

## Live Smoke S269

Question: "What is PRISMA 2020 and what changed from PRISMA 2009?"

| Perna | Result | Evidence |
|---|---|---|
| Gemini D-lite | BLOCKED | First live call reached Gemini but returned truncated JSON before validation; after provider-schema hardening, retry returned `429 RESOURCE_EXHAUSTED`. No further retry. |
| Perplexity D-lite | PASS | Wrote `.claude/.research-tmp/perplexity-dlite-smoke-prisma.json`; schema valid; NCBI ESummary verified 2/2 checked PMIDs. |
| Codex xhigh | PASS | Wrote `.claude/.research-tmp/codex-dlite-smoke-prisma.json`; `--validate-file --verify-pmids` wrote `.claude/.research-tmp/codex-dlite-smoke-prisma.verified.json`; NCBI ESummary verified 4/4 checked PMIDs. |

Decision: D-lite is improved but **not promoted**. Required next step is a broader live re-bench once Gemini quota is available, with at least 6/6 emits and the existing promotion gate satisfied.
