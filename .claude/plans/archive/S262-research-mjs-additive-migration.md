# S262 — Research .mjs Additive Migration (não-destrutivo, side-by-side)

> **Status:** HANDOFF S261 → S262. Plano executável após Lucas approval session-start.
> **Predecessor:** `concurrent-nibbling-teacup.md` (S261 plan, Path A bridge approved + commited).
> **Princípio (Lucas turn 5, S261):** "migrar mas sem apagar depois faremos um run lado a lado para ver qual sistema esta melhor em que fazer merge ou deixar separador"

---

## Context

S261 hardenou os 2 .mjs research (`gemini-research.mjs`, `perplexity-research.mjs`) com 11 fixes line-cited e wirou Codex xhigh como Perna 7 paralela. Telemetria coletada na S261 (exit codes, structured stderr JSON, smoke results) é o **input spec** pra S262.

S262 = **migração ADITIVA não-destrutiva**: build new agents/skills ALONGSIDE old .mjs, run side-by-side N≥10 runs, Lucas decide per-target MERGE / KEEP-SEPARATE / MERGE-BACK baseado em métricas empíricas.

**Não destruir** os .mjs até evidência concreta. Pattern espelha audit-merge-S251 (KBP-39 convergence rules).

---

## Migration targets (4 + 1 new capability = 5 candidates)

| Source | Target type | New agent/skill name | Justificativa migration |
|---|---|---|---|
| `.claude/scripts/gemini-research.mjs` | NEW agent | `gemini-deep-research` (subagent) | Versionar prompts em SKILL.md + frontmatter model field |
| `.claude/scripts/perplexity-research.mjs` | NEW agent | `perplexity-sonar-research` (subagent) | Idem + parameterized SYSTEM_PROMPT já em D.9 |
| `content/aulas/scripts/gemini-qa3.mjs` | NEW skill | `/gemini-qa` (skill com `context: fork`) | Gates LLM-judgment naturais como skill phases |
| `.claude/scripts/gemini-review.mjs` | NEW agent | `gemini-code-reviewer` (subagent) | Code review = subagent role natural |
| **NEW capability** (S262+, Lucas turn 6 S261) | NEW agent OR skill | `research-triangulator` ou `/research-synthesize` | **Verification + triangulation system** + Living HTML construction |

**OUT scope permanente** (not migration candidates):
- `build-html.mjs`, `qa-capture.mjs`, lint scripts, `kpi-snapshot.mjs` — pure-computational, correctly placed

---

## NEW capability: Verification + Triangulation + HTML output (S262+)

**Lucas directive (S261 turn 6):** "os agents te pesquisa ao final tb devem ser capazees de gerar um sistemas de verificacao de dados e triangulacao, com possivel construcao de um html igual o script menciona"

**Scope:**
- Research agents (current Pernas + future migrated agents) produzem JSON schema-validated (`research-perna-output.json`)
- NEW agent/skill `research-triangulator` (S262+) consome ALL perna JSON outputs e produz:
  1. **Verification layer:** PMID/DOI cross-check via NCBI E-utilities + CrossRef MCPs (triangulação cross-source). Flagging fab rate per perna.
  2. **Triangulation matrix:** convergence/divergence per claim across pernas (already conceptually in /research SKILL.md §3.b; explicit em JSON output)
  3. **Resolution:** §3.c hierarchy applied programmatically (não orchestrator inline)
  4. **Living HTML construction:** gera `content/aulas/{aula}/evidence/{slide-id}.html` per spec atual /research SKILL.md Step 4 §11 sections (Header, Síntese Narrativa, Speaker Notes, Posicionamento Pedagogico, GRADE Assessment, Numeros-Chave, Convergencia, Footer)

**Architecture suggestion (for S262 design phase):**
- 7+ perna agents output → `.claude/.research-tmp/perna{N}-output.json` (schema-strict)
- `research-triangulator` agent invoked by orchestrator: reads all perna JSONs, runs verification (NCBI curl loop), builds triangulation matrix, applies §3.c resolution, writes Living HTML to `content/aulas/{aula}/evidence/{slide-id}.html`
- Output: confirmation JSON + path to Living HTML

**Why agent vs skill for triangulator?**
- Agent: subagent isolation, can have specific tools (Bash for curl + Write for HTML), schema-locked input
- Skill: composability, `context: fork`, can chain naturally with /research dispatch
- **Recommendation S262 design:** start as skill (`/research-synthesize`) within /research SKILL.md Step 3.b/3.c expansion. If skill becomes too heavy, refactor to agent.

**Reference HTML schema (canônico, 11 sections):**
`content/aulas/metanalise/evidence/pre-reading-heterogeneidade.html` (S148 benchmark visual per /research SKILL.md Step 4)

**S262 phases impacted:**
- Add S262-G (~3-4h): research-triangulator design + implementation + smoke test
- Add S262-H (~2h): integration with parallel runs comparison.tsv (triangulator output = additional metric column)

---

## Side-by-side validation methodology

### Phase 1 — Build new alongside old (no deletion)
- For each target, create the NEW agent/skill .md file
- Original `.mjs` PERMANECE runnable, untouched
- Add a toggle flag in `/research` SKILL.md Step 2 dispatch to route:
  - `--legacy` flag → use .mjs
  - default → use new agent
  - `--parallel` flag → run BOTH (for comparison)

### Phase 2 — Parallel runs (N ≥ 10)

For each target, run minimum 10 parallel comparisons:
- 3 research questions × ~3-4 categorias (clinical prevalence, RCT result, framework definition, guideline statement)
- Same input → both .mjs (legacy) AND new agent
- Outputs captured em paralelo

Storage:
```
.claude/.parallel-runs/
  {date}-{question-id}/
    legacy/
      gemini-research-output.txt   # stdout from .mjs
      gemini-research-stderr.txt   # error path
      timing.txt                    # wall-clock
    new/
      gemini-deep-research-output.json  # subagent return
      gemini-deep-research-debug.txt    # internal trace
      timing.txt
    comparison.tsv                  # per-criterion side-by-side
```

### Phase 3 — Métricas comparativas (TSV committed)

Path: `.claude/metrics/migration-{target}-{date}.tsv`

Columns:
| Column | Description |
|---|---|
| `question_id` | R-poc-N or topic-slug |
| `target` | gemini-research / perplexity / qa3 / review |
| `system` | legacy (.mjs) ou new (agent) |
| `latency_ms` | wall-clock |
| `cost_usd` | API call cost (parsed from CLI output if available) |
| `pmid_count` | total PMIDs cited in output |
| `pmid_fab_rate` | NCBI spot-check failure ratio (≥2 spot-checked) |
| `output_quality_lucas` | Lucas judgment 1-5 (after blind review) |
| `schema_compliance` | for new agents only — JSON schema validation pass/fail |
| `error_path_coverage` | stderr structured (yes/no), exit code informative (yes/no) |
| `notes` | free text |

### Phase 4 — Lucas decision per-target

After N≥10 runs collected, Lucas reviews comparison.tsv per target:

**Decision matrix:**

| Outcome | Criteria | Action |
|---|---|---|
| **MERGE** (sunset .mjs, agent canonical) | new agent wins on ≥4/6 metrics (latency, cost, fab rate, quality, schema, error path) AND Lucas judgment positive | Mark .mjs as deprecated; remove dispatch; keep .mjs file in `_archived/` for 6 months |
| **KEEP-SEPARATE** (both stay, specialized) | metrics show diff strengths (e.g., agent better cross-family research, .mjs better hot-path quick query) | Document role differentiation in SKILL.md; both dispatched conditionally |
| **MERGE-BACK** (sunset agent, .mjs canonical) | agent overhead ≥2× .mjs without clear quality gain | Document agent as failed exp; archive new agent .md; .mjs stays as Perna canonical |

**Lucas-override rule** (from KBP-39 S250 lesson): if technical metrics suggest X but Lucas explicit decision is Y, document the override as `decision_override.md` with reasoning. Single overrides OK; pattern of overrides = recalibrate metrics.

---

## Estimated phases S262 (~12-16h total)

| Phase | Duration | Description |
|---|---|---|
| S262-A | ~3h | NEW agent specs × 2 (gemini-deep-research + perplexity-sonar-research) — adapta hardened .mjs prompts em frontmatter + SKILL pattern |
| S262-B | ~2h | NEW agent spec × 1 (gemini-code-reviewer) — adapta gemini-review.mjs |
| S262-C | ~3h | NEW skill `/gemini-qa` — adapta gemini-qa3.mjs gates como skill phases |
| S262-D | ~2h | Toggle flag infra em `/research` Step 2 (--legacy / --parallel) + smoke tests |
| S262-E | ~3-4h | 10+ parallel runs collected (3 questions × 3-4 categorias) + Lucas review per-target |
| S262-F | ~1h | Documentação + decision per-target + archive plan |

---

## Telemetria S261 input (consumir como spec)

Coletada durante S261 (commits S261-A, B, C, D, E):

### Exit code distribution (post-D fixes)
- gemini-research.mjs: 0 (ok), 1 (usage/key), 2 (empty thinking), 3 (API/HTTP), 4 (truncated)
- perplexity-research.mjs: 0 (ok), 1 (usage/key), 3 (API/HTTP), 4 (timeout), 5 (malformed)

Migration spec implication: new agents devem mapear exit codes a structured failure categories (não silent swallow).

### Failure modes documentadas (pre-D, devem ser preserved no agent design)
- gemini: thinking_consumed_all_tokens, MAX_TOKENS truncated, API key invalid, quota exceeded
- perplexity: silent_fallback_dump (RESOLVIDO D.10), invalid_api_key, malformed_response, timeout

### S261 SOTA report findings (relevant)
- Subagent frontmatter spec 2026: tools, model, maxTurns, effort, skills (preload), mcpServers (inline), hooks
- Skill `context: fork` para QA pipeline (gemini-qa3 → /gemini-qa)
- `--output-schema` enforcement at API boundary (~0% fail vs markdown 2-3%)
- Cross-family value (Anthropic vs OpenAI training data) = anti-shared-hallucination

---

## Open questions for Lucas (S262 session-start)

1. **Order de migration?** Sugestão: gemini-research → perplexity-research (high-value research) → gemini-qa3 (next priority QA pipeline) → gemini-review (last). Confirmar ou re-priorizar.
2. **Side-by-side window:** N=10 runs minimum ok ou prefere N=20 antes de decisão?
3. **Lucas judgment scale:** 1-5 ok? Ou 1-7 (mais granular)?
4. **Archive policy:** 6 months keep .mjs em `_archived/` ok? Ou prefere keep indefinitely?
5. **Cost budget S262:** ~$5-10 total (4 targets × 10 runs × ~$0.20 each). Ok?

---

## References

- S261 plan: `.claude/plans/concurrent-nibbling-teacup.md`
- S261 commits: `git log --grep="S261" --oneline`
- S187 PMID baseline: HANDOFF S187 (Perplexity 0/8 fab rate)
- KBP-39 convergence rules: `.claude/plans/immutable-gliding-galaxy.md` §6.1
- Audit-merge-S251 methodology: anchor pattern para per-target decision
- Codex CLI docs: developers.openai.com/codex/cli/reference (acessado 2026-04-26 via SOTA report)

---

## S261 carryover (pending S262 P0)

Items deferred from S261 turns 5-7:

1. **Specialty cleanup remaining** (Lucas S261 turn: "tire de todo lugar que eu sou cardiologista gastroenterologista hepatologista"):
   - VALUES.md L12 + L63 — DONE S261
   - perplexity-research.mjs comment example — DONE S261
   - `.claude/plans/immutable-gliding-galaxy.md` L25, L134, L137, L316, L393, L506, L520, L591 — **PENDING** (~8 edits, active plan, recommend coordinated edit + ADR note)
   - `.claude/plans/archive/S242-glimmering-coalescing-ullman.md:408` — historical archive, KEEP unless Lucas explicit
   - `~/.claude/CLAUDE.md` (user global) — out of project scope, Lucas handle manual

2. **Per-agent Tone propagation** (Lucas S261 turn: "coloque em todos os agents claude gemini md para be terse a menos que eu indique"):
   - `.claude/rules/anti-drift.md §Tone` — DONE S261 (global rule)
   - 16 individual agents in `.claude/agents/*.md` — **PENDING** (each gets 1-2 line tone directive after frontmatter close). Recommended pattern:
     ```markdown
     **Tone:** terse default (anti-drift.md §Tone). Verbose só com Lucas indica explicit.
     ```
   - Possibly AGENTS.md (root) + GEMINI.md (root) if exist

3. **Codex agent `--model` flag adjustment** (S261 POC empirical):
   - `.claude/agents/codex-xhigh-researcher.md` Phase 3 cmd — `--model gpt-5.5` REMOVED, deixar `~/.codex/config.toml` default aplicar — DONE S261
   - Verificar S262 que side-by-side runs respeitam essa convenção

4. **POC scale-up** (lightweight 1-question → full 3-question):
   - S261 Phase E ran 1 question (5/5 PMID verified, 3m08s, ~$0)
   - S262 expand to 3 questions (R3 s-quality, R5 s-heterogeneity, R11 s-contrato per concurrent-nibbling-teacup.md §Phase E.1) + capture metrics TSV
   - Decision: ADOPT-NOW already met threshold; multi-question = stress test + convergence rate measurement

## Coautoria

`Coautoria: Lucas + Claude Code (Opus 4.7) | herdado da S261`
