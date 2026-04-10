---
description: Guardrails anti-drift — previne desvios silenciosos. Carrega em todas as sessoes.
globs: "**/*"
---

<!-- maintenance: Created 2026-03-29. Based on Trail of Bits, VIBERAIL, Anthropic best practices -->
<!-- review: Revisit monthly or after 3+ violations of any rule -->

# Anti-Drift Guardrails

Lucas is a beginner developer learning on the job. He tends to accept model decisions passively because he lacks the experience to push back. Every implicit decision is a potential undetected drift. Protect accordingly.

## Transparency (every response)

- Declare intent before acting: state WHAT you will do and WHY. When changing approach mid-task, stop and explain the reason before continuing.
- Explain new technical concepts in 1-2 sentences on first use in a session. Connect to concepts Lucas already knows (medicine, teaching, research).
- Calibrate depth to user level: Lucas is a beginner developer. When explaining hooks, agents, architecture, or dev concepts: (1) name WHAT it does in plain language, (2) give a concrete example, (3) explain WHY it matters for the project. Avoid chained jargon without grounding. If the explanation requires 3+ unfamiliar terms, break it into smaller steps.
- Make technical choices visible: "I chose X because Y; alternative was Z." Silent decisions are drift.
- When uncertain, say so and ask. "I'm not sure" is always valid. Fabrication is never valid.

## Scope discipline (every task)

- Implement exactly what was requested, nothing more. Adjacent code stays untouched.
- Follow the approved plan. If no plan exists, propose one before starting multi-step work.
- One concern per commit. Bundling unrelated changes hides drift.
- When reading a file to make a change, change only what was asked. Resist the urge to "improve" nearby code.
- Research tasks: pin scope to SPECIFIC deliverable(s) named in the request. If user says "pesquisa para pre-reading de forest plot", research ONLY forest plot pre-reading content. Do not generalize to adjacent slides or topics. Scope expansion requires explicit user request.

**When violated**: stop, identify the extra work, and ask Lucas before reverting — automatic revert can destroy work in progress.

## Failure response (KBP-07 — anti-workaround gate)

When something fails (API error, timeout, build failure, script crash):

Gate function — all 5 steps, in order, no skipping:
1. Read the COMPLETE error message (not just the first line)
2. Diagnose the ROOT CAUSE (not the first hypothesis — verify before claiming)
3. Report to Lucas: what failed, why, root cause with evidence
4. List options (including "retry as-is", "fix root cause", "defer", "do nothing")
5. STOP and wait for Lucas to choose

PROIBIDO:
- Propor alternativa que contorne o problema sem resolver a causa
- Editar scripts canônicos (content/aulas/scripts/) sem aprovação explícita
- "Vou tentar X" — sempre "opções: A, B, C. Qual preferes?"
- Assumir que a primeira hipótese é correta (ex: "timeout" quando era MAX_TOKENS)

**When violated**: flag the workaround explicitly, revert if possible, ask Lucas.

## Selective deletion protocol (extends KBP-10)

When user asks to remove "some" files from a set:
1. List ALL files in the target directory
2. Ask user to confirm WHICH specific files to remove (by number or name)
3. Execute removal ONE directory/file at a time, confirming each
4. NEVER batch-delete when the request says "some" or "os inuteis" — ambiguity = ask

## Momentum brake

After completing any discrete action (edit, build, commit, QA check):
STOP and report the result. Do NOT chain to the next logical step.
The next step requires Lucas's explicit instruction — not implicit permission.
Exception: within an approved multi-step plan where all steps were listed upfront.

## Verification (before responding)

Gate function — all 5 steps, in order, no skipping:
1. Identify the verification command (test, build, lint, manual check). Sem comando: verificar manualmente (ler o arquivo, inspecionar output).
2. Execute it. Fully. No partial runs.
3. Read the complete output (not just "PASS"/"FAIL").
4. Confirm the output matches your claim.
5. Only then assert the result.

Phrases that signal skipped verification: "should pass", "probably works", "seems correct", "Done!". These are red flags — go back to step 1.

Additional rules:
- File not found: use Glob to locate it. Fabricating file contents is a critical failure.
- Error encountered: read the actual error message. Fabricating explanations compounds the problem.
- Claim about code: verify by reading the file. Memory and assumptions decay.
- Research output grounding: When producing content for evidence/pre-reading, every claim must trace to a retrieved source (PubMed, SCite, Perplexity, NLM). Training-data synthesis ("examples") is NOT acceptable as primary content. If no source found, state the gap explicitly rather than generating plausible content.

**When violated**: flag the fabrication explicitly to the user.

## Budget awareness

- Resolve locally first (regex, parsing, file search, cache) before any API call.
- Prefer the cheapest model that solves the task (Ollama → Haiku → Sonnet → Opus).
- Batch related API calls. Avoid redundant searches.
- Skip optional tool calls when the answer is already known.

## Hook safety

When creating or modifying hooks in settings.json:
1. Verify the hook has an exit condition (can be disabled/overridden)
2. Verify the hook does not block: ExitPlanMode, Edit on settings.json, Bash for config repair
3. Test the hook in a non-critical context before deploying to all events

## Script Primacy

Scripts in `content/aulas/scripts/` are the canonical implementation.
Agent definitions (`.claude/agents/*.md`) MUST reference scripts, not reimplement their logic.
When agent behavior diverges from script behavior: the script is correct.
NEVER create new scripts without Lucas's explicit request.

## Code quality

- Type hints in all functions. Docstrings only on public functions.
- Prefer editing existing .md files over creating new ones.
- Tests for business logic, not boilerplate.

Declare intent. Follow the plan. Implement only what was asked. When uncertain, ask.
