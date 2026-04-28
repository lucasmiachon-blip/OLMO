# S261 — Multi-Arm Research Migration (Path A: harden bridge → S262+ wholesale)

> **Status:** PROPOSTA Phase 4 (S261) — pendente ExitPlanMode
> **Path:** A (harden in-place) **como bridge** para S262+ wholesale migrate (skills/agents/subagentes). Lucas confirmou sequência turn 3+4.
> **Sources:** SOTA report (general-purpose agent) + Explore agent line-cited inspection + Lucas directive verbatim
> **Sequencing:** S261 reduz fragilidade (defensive checks) → estabiliza pipeline → S262+ migra .mjs → agents/skills com confiança baseada em telemetria coletada na S261

---

## Context

Lucas (S261 turn 1, verbatim):
> "vamos incorporar o chatgpt5.5 xhigh em nosso braco de pesquisa e vamos migraar o mjs de pesquisa fragil mas eficiente, para agents subagents e skill, nao ha espaco para erro, nao ha workaorund, todos os bracos sempre trabalham, houve falhas varias vezes de woroukaror ou prompts payloads inadequaados, seja profissional"

Lucas (S261 turn 4, verbatim — sequenciamento):
> "harden in place para depois migrar todo para sistema de skills agents e subagntes"

**Problema:** research arm tem (a) braço único Anthropic-only (sem cross-family validation contra hallucination compartilhada), (b) 2 .mjs hot-path com fragilidades silenciosas (HTTP errors mascarados, timeouts ausentes, prompts/payloads sem validação), (c) `codex-xhigh-researcher.md` agent existe (POC S259) mas nunca foi wirado como perna paralela em `/research`.

**Outcome desejado:** segundo braço (GPT-5.5 xhigh) ativo em `/research` + .mjs research defensivos (zero silent fail, zero workaround, payloads explícitos). Preserva eficiência hot-path dos .mjs (Lucas: "fragil **mas eficiente**" — preservar a parte eficiente).

**Reframe SOTA-driven (S261 bridge → S262+ destination):** S261 = harden defensive in-place (estabiliza fragilidades silenciosas, coleta telemetria). S262+ = wholesale migrate `.mjs` → skills/agents/subagentes (Lucas explicit destination, turn 4). Sequência:
1. S261 = bridge — Codex agent hardened + Perna 7 wired + 2 .mjs research defensivos
2. S261 telemetria (POC métricas, exit code logs, timeout events) = evidence-base pra S262 migration design
3. S262+ = wholesale conversion (gemini-research.mjs → agent + Bash invocation, perplexity idem, gemini-qa3.mjs → /gemini-qa skill, etc)

**Por que bridge primeiro, migration depois:** migrar .mjs frágeis = arrasta bugs silenciosos pra arquitetura nova. Hardening primeiro torna failures visíveis (exit codes, stderr JSON), o que vira spec pra agents nativos da S262. Lucas approve Path A turn 3 + sequência turn 4.

---

## Scope

**IN scope (S261):**
- `.claude/agents/codex-xhigh-researcher.md` — hardening com `--output-schema`
- `.claude/schemas/research-perna-output.json` — NEW JSON Schema (diretório novo)
- `.claude/skills/research/SKILL.md` — wire Perna 7 (Codex xhigh) paralela
- `.claude/scripts/gemini-research.mjs` — 5 fixes defensivos (line-cited)
- `.claude/scripts/perplexity-research.mjs` — 6 fixes defensivos (line-cited)
- `.claude/metrics/codex-xhigh-poc-{date}.tsv` — POC métricas committed

**DEFERRED a S262+ (wholesale migration ADITIVA não-destrutiva — Lucas turn 4+5):**

Princípio: build new ALONGSIDE old, never destroy. Run lado-a-lado, mede empiricamente, Lucas decide merge ou keep-separate. Pattern espelha audit-merge-S251 (KBP-39 convergence rules).

Targets (S262+, ordem TBD):
- `gemini-research.mjs` → NEW agent `gemini-deep-research` + thin Bash wrapper. **Original .mjs PERMANECE runnable.**
- `perplexity-research.mjs` → NEW agent `perplexity-sonar-research`. **Original PERMANECE.**
- `gemini-qa3.mjs` → NEW `/gemini-qa` skill. **Original PERMANECE.**
- `gemini-review.mjs` → NEW agent `gemini-code-reviewer`. **Original PERMANECE.**
- Possibly: NEW skill `/research-pipeline` que pode dispatch tanto .mjs quanto agents (toggle flag)

**Side-by-side validation phase (S262 dedicated):**
1. Run mesma input via .mjs (legacy) E via agent (new) — paralelo
2. Capture outputs em `.claude/.parallel-runs/{date}-{question}/{legacy,new}/`
3. Métricas comparativas: latência, custo, fab rate, output quality (Lucas judgment), schema compliance, error path coverage
4. Após N=10+ runs (≥3 questions × 3-4 categorias): **Lucas decide per-target**:
   - **MERGE** (sunset .mjs, agent é canonical) — agent wins clear
   - **KEEP-SEPARATE** (both stay, specialized roles) — diferentes strengths (e.g., agent melhor pra cross-family research, .mjs melhor pra hot-path quick query)
   - **MERGE-BACK** (sunset agent, .mjs é canonical) — overhead agent não justifica

**OUT scope permanente (não migration candidates):**
- `build-html.mjs`, `qa-capture.mjs`, lint scripts, `kpi-snapshot.mjs` — pure-computational sem LLM-judgment, correctly placed
- Agent teams adoption (experimental status, espera GA)

---

## Phases (ordered, gate por commit)

### Phase A — Preflight + S260 housekeeping (~10min)

- **A.1** Resolve pending-fix: `cd content/aulas/metanalise && node ../scripts/build-html.mjs --aula metanalise` (rebuild index.html — invariante quebrado por S260)
- **A.2** Lucas decision: commit S260 heterogeneity-evolve (5 files) AGORA antes de S261 work, ou batch final?
- **A.3** Codex CLI preflight: `command -v codex && codex --version && codex --help | head` — confirma install + auth OAuth max plan

**Gate A→B:** index.html rebuilt + Codex CLI ≥0.125.0 + auth OK.

### Phase B — Codex xhigh hardening (~30min)

- **B.1** NEW `.claude/schemas/research-perna-output.json` (~50 li) — JSON Schema strict. Anchors: `schema_version`, `produced_at`, `research_question_id`, `findings[]` (claim, supporting_sources[], confidence, convergence_signal), `candidate_pmids_unverified[]`, `convergence_flags[]`, `confidence_overall`, `gaps[]`. Mirror exato de Phase 0 do agent atual.
- **B.2** Edit `.claude/agents/codex-xhigh-researcher.md` Phase 3 cmd block — adicionar:
  ```bash
  --output-schema "$OLMO_ROOT/.claude/schemas/research-perna-output.json"
  --json
  ```
- **B.3** Edit Phase 4 — substituir markdown section parsing por `JSON.parse` + schema validation. Falha schema = retry 1× com error feedback; 2 falhas = return JSON gap + flag schema_drift.
- **B.4** Edit Hard constraints — PMID spot-check ≥**2** (não ≥1) durante POC (S187 Perplexity 0/8 baseline; xhigh untested).
- **B.5** Smoke test: 1 invocação manual com placeholder question; verifica schema enforcement + fab rate baseline + cost actual.

**Gate B→C:** schema commited + agent edits commited + smoke OK (exit 0, JSON válido).

### Phase C — Wire Perna 7 em /research SKILL.md (~20min)

- **C.1** Edit Step 2 dispatch table — ADD row 7: `codex-xhigh-researcher` (Subagent), GPT-5.5 xhigh, "Sempre" (ou condicional ao Lucas D5 gate), input=research_question, output=JSON to orchestrator
- **C.2** Edit Step 2.5 validação — branch para JSON output (parse + schema validate, score 4/4 critérios: parsable JSON, findings ≥1, PMIDs cited, no schema_drift flag)
- **C.3** Edit Step 3.b convergências — Codex perna como peer com Perplexity/Gemini. §3c hierarquia: Codex xhigh = peer Perplexity (web-grounded), abaixo de MCPs estruturados (PubMed verified > Codex candidate)
- **C.4** Edit ENFORCEMENT — Perna 7 indisponível ≠ substituir (KBP-08). Reportar (codex auth fail, timeout, schema fail) e pular. NUNCA WebSearch fallback.

**Gate C→D:** SKILL.md updates commited + lint:case-sync passa.

### Phase D — Harden gemini/perplexity .mjs in-place (~45min)

`gemini-research.mjs` fixes (5):
- **D.1** Add `if (!res.ok) throw new Error(...)` antes de `res.json()` (atual L44 sem guard)
- **D.2** Add `AbortSignal.timeout(60_000)` em fetch options (atual sem timeout = hang potencial)
- **D.3** Inspect `data.error` field; fail loud com `process.exit(3)` + stderr JSON com error.code/message (atual: silent confusion via "no candidates")
- **D.4** MAX_TOKENS = `process.exit(4)` não warning (atual L46 warns + continues — caller pode ingerir output truncado)
- **D.5** Pre-check prompt length: warn stderr se prompt > 50% thinkingBudget (atual: L49 thinking pode consumir todos tokens, output 0)

`perplexity-research.mjs` fixes (6):
- **D.6** Add `if (!res.ok) throw new Error(...)` antes de `res.json()` (atual L48)
- **D.7** Add `AbortSignal.timeout(120_000)` (sonar-deep-research é mais lento)
- **D.8** `temperature: 0.8 → 0.2` (atual L44; research = deterministic, não criativo)
- **D.9** Parameterize SYSTEM_PROMPT (atual L27 hardcoded) — aceitar `--domain-context "..."` flag pra inject clinical specificity (e.g., "hepatology", "rheumatology"). Default mantém current behavior.
- **D.10** Replace silent fallback `data.choices?.[0]?.message?.content || JSON.stringify(data)` (atual L49) com explicit error: log raw to stderr + `process.exit(5)`. Caller sabe que falhou.
- **D.11** Add `data.error` field check (mesma falha mode que gemini)

Smoke tests Phase D (each .mjs):
```bash
# 1. Happy path
node .claude/scripts/gemini-research.mjs "test prompt" && echo "PASS"

# 2. Auth failure injection
GEMINI_API_KEY="invalid" node .claude/scripts/gemini-research.mjs "test" 2>&1 | grep "exit 3" && echo "PASS"

# 3. Timeout injection (block network 5s — manual)
# Verifica AbortSignal.timeout fires
```

**Gate D→E:** ambos .mjs runnable + 3 smoke tests cada PASS + commited.

### Phase E — POC validation Perna 7 (~30-60min)

- **E.1** Pick 3 research questions concretas:
  - **R3** `s-quality` ROB2 nuances (já tem evidence HTML em metanalise — convergence target conhecido)
  - **R5** `s-heterogeneity` τ² interpretation (S260 acabou de finalizar — fresh content)
  - **R11** `s-contrato` (HANDOFF flag inconsistência R11=5.7 — Codex xhigh pode resolver)
- **E.2** Run `/research` com 7 pernas dispatched paralelo. Capture per-perna outputs em `.claude/.research-tmp/{question-id}/perna{N}-output.json`
- **E.3** Métricas em `.claude/metrics/codex-xhigh-poc-{date}.tsv` (columns: question_id, perna_id, pmid_cited_count, pmid_verified_count, pmid_fab_rate, convergence_with_other_pernas (0-5), latency_ms, cost_usd, notes)
- **E.4** Decision matrix:
  - fab≤10% **AND** conv≥60% (i.e., aligns with ≥3 of 5 other pernas avg) → **ADOPT-NOW** (Perna 7 ativa default em `/research`)
  - fab 10-20% **OR** conv 40-60% → **ADOPT-NEXT** (manual invocation only via flag, candidate-only PMIDs)
  - fab>20% **OR** conv<40% → **DEFER** (agent stays installed, `/research` não dispatch)

**Gate E→F:** TSV commited + Lucas review métricas + decision logged em HANDOFF S261.

### Phase F — Documentation + S262 handoff (~20min)

- **F.1** HANDOFF.md S261 entry (≤10 li per anti-drift §Session docs) — citar fab rate + convergence + decision matrix outcome + **S262 migration unblocked**
- **F.2** CHANGELOG.md S261 entries (1 li per phase, 6 lines total)
- **F.3** known-bad-patterns.md — KBP-44 candidate: "Bridge antes de wholesale migrate: hardening in-place torna failures visíveis (exit codes), o que vira spec pra agents nativos. Wholesale-migrate código frágil = arrasta bugs silenciosos pra arquitetura nova."
- **F.4** Conductor 2026 plan §11d — note Perna 7 status (ATIVA / NEXT / DEFER conforme E.4)
- **F.5** NEW `.claude/plans/S262-research-mjs-additive-migration.md` — handoff doc pra próxima sessão. Conteúdo:
  - Telemetria S261 collected (exit code distribution, timeout events, fab rate per perna)
  - Migration mapping (`.mjs` source → NEW agent/skill — **`.mjs` ORIGINAIS PERMANECEM**)
  - Schema patterns reused (`research-perna-output.json` é template)
  - **Side-by-side validation methodology**: paths `.claude/.parallel-runs/{date}-{question}/{legacy,new}/`, métricas comparativas TSV, N≥10 runs antes de Lucas decide
  - Decision matrix per-target: MERGE / KEEP-SEPARATE / MERGE-BACK (com critérios)
  - Estimated phases S262 (~12-16h: agent specs × 4, skill spec × 1, parallel runs infra, telemetry, Lucas decision sessions)

**Gate F→done:** Lucas final review + sessão close + S262 handoff doc commited.

---

## Critical files (action map)

| File | Action | Phase | Why |
|---|---|---|---|
| `.claude/agents/codex-xhigh-researcher.md` | Edit | B | `--output-schema` flag + JSON parse + spot-check ≥2 |
| `.claude/schemas/research-perna-output.json` | NEW | B | Schema enforcement (diretório novo) |
| `.claude/skills/research/SKILL.md` | Edit | C | Wire Perna 7 (Step 2/2.5/3/ENFORCEMENT) |
| `.claude/scripts/gemini-research.mjs` | Edit | D | 5 defensive fixes line-cited (L26, L44, L46, L49) |
| `.claude/scripts/perplexity-research.mjs` | Edit | D | 6 defensive fixes line-cited (L27, L29, L44, L48-49) |
| `.claude/metrics/codex-xhigh-poc-{date}.tsv` | NEW | E | POC métricas committed |
| `HANDOFF.md` + `CHANGELOG.md` | Edit | F | Session docs |

**Existing utilities reused (no rewrite):**
- `evidence-researcher` agent (Perna 2, MCPs)
- `mbe-evaluator` agent (Perna 3)
- `reference-checker` agent (Perna 4)
- NCBI E-utilities curl pattern (já em codex-xhigh-researcher Phase 4)
- `gemini-research.mjs` runtime (Perna 1) — mantido + hardenado
- `perplexity-research.mjs` runtime (Perna 5) — mantido + hardenado
- 6-perna dispatch infra em `/research` SKILL.md Step 2

---

## Confidence per recommendation

| Decisão | Confidence | Fonte |
|---|---|---|
| Codex CLI flag syntax (`-c reasoning.effort=xhigh`, `--sandbox read-only`, `--output-schema`) | **HIGH** | developers.openai.com/codex/cli/reference (acessado 2026-04-26 via SOTA agent) |
| GPT-5.5 disponível Codex CLI | **HIGH** | developers.openai.com/codex/models (2026-04-26) |
| `--output-schema` reduz fab rate vs markdown parse (near-zero vs 2-3%) | **HIGH** | tianpan.co structured-outputs Oct 2025 |
| Selective migration (.mjs research stay scripts) | **HIGH** | SOTA + Explore line-cited (63+54 li, hot-path, zero judgment) |
| Hardening fixes line-cited (HTTP guard, AbortSignal, temp 0.2) | **HIGH** | Bug evidence direta no código (Explore agent L44, L46, L49 etc) |
| Wire Perna 7 paralelo (não replacement) | **HIGH** | Aider Architect+Editor 85% pass + research/SKILL.md design (Perna 6 NLM já paralela) |
| Codex PMID fab rate (GPT-5.5 xhigh specifically) | **LOW** | UNTESTED — POC E.3 mede. S187 Perplexity 0/8 é único OLMO datapoint |
| Convergence rate Perna 7 vs outras 5 | **LOW** | UNTESTED — POC mede |
| Latency xhigh em pipeline 6-perna | **MEDIUM** | OpenAI docs "very long rollouts" (qualitativo); wall-clock unmeasured em OLMO |

---

## Risks (top 5) + mitigation

1. **Codex auth fragility** (OAuth max plan token rotation = silent 401)
   → Mitigation: Phase A.3 preflight gate. 401 → return JSON gap, NÃO retry, Lucas fixa manual via `codex login`.

2. **xhigh latency bloqueia /research pipeline** (wall-clock minutos por question)
   → Mitigation: dispatch async em Phase C wire; timeout 3min em /research Step 2; degrade `xhigh→high` retry 1×; depois skip perna report gap.

3. **PMID fab rate GPT-5.5 xhigh unknown** (zero baseline OLMO)
   → Mitigation: Phase B.4 spot-check ≥2 PMIDs/run × 3 questions = ≥6 datapoints. Rate >10% → Perna 7 ADOPT-NEXT only. Phase E.3 TSV é evidence permanente.

4. **Defensive .mjs hardening regression** (HTTP changes break callers downstream)
   → Mitigation: Phase D smoke test PASS antes commit (3 cenários cada .mjs); rollback path = `git revert <SHA>`; mantém scripts runnable mesmo se exit codes mudam (callers que não checavam exit code já estavam quebrados silenciosamente).

5. **Perna 7 divergência sistemática** (Codex sempre disagree com 5 pernas)
   → Mitigation: explicit `convergence_flags.type: "divergence"` no schema (B.1); /research §3c hierarquia já trata divergence (Lucas decide); divergence ≠ wrong, é sinal — escrever em `.claude/metrics/`.

---

## Verification (end-to-end)

After all phases commited, run:

```bash
# 1. Codex agent smoke
codex exec --model gpt-5.5 -c reasoning.effort=xhigh \
  --output-schema .claude/schemas/research-perna-output.json \
  --sandbox read-only --ephemeral --skip-git-repo-check --json \
  "Research question: prevalência de HRS-AKI em cirrose descompensada"
# expect: JSON válido, findings ≥1, PMIDs cited, schema_validation pass

# 2. .mjs error injection (gemini)
GEMINI_API_KEY="invalid" node .claude/scripts/gemini-research.mjs "test" 2>&1
echo "exit code: $?"
# expect: exit 3 + stderr JSON com error details

# 3. .mjs error injection (perplexity)
PERPLEXITY_API_KEY="invalid" node .claude/scripts/perplexity-research.mjs "test" 2>&1
echo "exit code: $?"
# expect: exit 5 + raw response logged stderr

# 4. /research full pipeline 7-perna
# Manual: invocar Skill /research s-quality
# expect: 7 pernas dispatched, todas retornam (ou reportam pulada com motivo)
# Convergence section em output inclui Perna 7

# 5. POC métricas
cat .claude/metrics/codex-xhigh-poc-*.tsv
# expect: TSV com 3 questions × 7 pernas = ~21 rows, fab/conv columns populated
```

---

## Decision gates (Lucas)

- **AGORA (ExitPlanMode):** approve Path A (este plan) ou push back?
- **After Phase A.2:** commit S260 antes de S261 work, ou final batch?
- **After Phase B.5:** smoke OK ou rollback Codex changes?
- **After Phase D smoke:** ambos .mjs PASS ou rollback fixes?
- **After Phase E POC:** Perna 7 ADOPT-NOW / ADOPT-NEXT / DEFER?

---

## Why this plan vs alternatives

**Path A (este S261 plan)** é antifragile + bridge: scripts hardenados ficam mais robustos a cada falha (defensive checks acumulam evidence em stderr); Codex agent hardenado expande capability sem regressar existente; POC mede risk antes de wire ativa. **Telemetria coletada em S261 = spec input pra S262+ migration**.

**Wholesale migrate em S261** rejected: arrasta bugs silenciosos (.mjs sem exit codes corretos) pra arquitetura nova (agents). Hardening primeiro = failures viram visíveis = spec correto pra agent design.

**S262+ wholesale migration ADITIVA** approved (Lucas turn 4+5): build new alongside old, run side-by-side N≥10 runs, Lucas decide per-target MERGE / KEEP-SEPARATE / MERGE-BACK baseado em métricas (latência, custo, fab rate, quality). Pattern espelha audit-merge-S251 KBP-39. Não destroi .mjs até evidência concreta justificar.

**KBP-37 alignment:** cada fase tem gate Lucas + cost ≤45min (não bench/research expand). KBP-41 (cut bias check): nada cut sem evidence — todos os items "harden" são "doing now" (cost <5min cada × 11 fixes = ~45min total Phase D).

**Total estimated time:** ~3h sequential (A:10 + B:30 + C:20 + D:45 + E:60 + F:15 = 180min). Achievable in S261 if commit cadence é 1-fase-per-commit per anti-drift §Plan execution.

---

## Coautoria

`Coautoria: Lucas + Claude Code (Opus 4.7) + general-purpose agent (SOTA report) + Explore agent (line-cited inspection) + Codex (GPT-5.5 xhigh, Phase E POC)`
