# Sleepy Wandering Firefly — S264 Bench Execution Slice (Phases 2-5)

> **Predecessor:** `splendid-munching-swing.md` (S263 master plan, 9 phases). Phase 0+1 commitados em `c353f53`. Este plano = **execution slice S264** das phases 2-5 (bench + comparison + decision). Phases 6-8 (Living HTML + slide + QA) deferred S265.
> **Coautoria:** Lucas + Claude Code (Opus 4.7).
> **Sessão:** 264.a — Comparação.

---

## Context

**Por que esta slice agora.** S263 fechou Phase 0 (KBP-47 + KBP-48 registradas) e Phase 1 (specs `.md` dos 2 novos agents `gemini-deep-research` + `perplexity-sonar-research`). O bench em si (Phases 2-5) ficou bloqueado por **KBP-38**: window-restart insuficiente pra refrescar Agent tool registry; precisava daemon Ctrl+Q + reopen. Com S264 começando pós-restart, o bench fica empiricamente executável.

**Outcome desta slice (S264):**
1. `path-a/` populated (scripts) — 6 pernas × 3 questions = 18 outputs + timing/cost
2. `path-b/` populated (agents) — idem
3. `comparison.tsv` filled com 12 colunas spec'd (timing, cost, PMID fab rate, coverage, schema, lucas_judgment_blind)
4. `decision.md` registrado (Lucas-driven Phase 5 — MERGE/KEEP/MERGE-BACK)
5. HANDOFF S265 atualizado com decisão + carryover Phases 6-8

**Bias esperado (Lucas S263 turn 5 já fixou regra wrap=agente):** vies confirmatório → MERGE provável. Mitigation = Phase 4 blind read com labels Path A/B escondidos (KBP-39 anti-confirmation guard).

---

## Pre-bench validation (✅ GREEN — 2026-04-27)

| Check | Status | Evidence |
|---|---|---|
| Git chain S263 | ✅ | `270903c` docs + `c353f53` substance |
| Env keys | ✅ | `GEMINI:AIza` `PERPLEXITY:pplx` `CODEX:0.125.0` |
| Agent registry | ✅ | `claude agents` lista `gemini-deep-research`, `perplexity-sonar-research`, `codex-xhigh-researcher` (project memory) |
| Scripts existence | ✅ | `.claude/scripts/{gemini,perplexity}-research.mjs` |
| Skill invocation policy | ⚠️ KNOWN | `/research` `disable-model-invocation: true` → manual dispatch obrigatório |
| `nlm whoami` | N/A | comando inexistente; TTL check via `nlm notebook list` ou primeiro query |

**Lucas-driven gates pendentes:**
- 🔴 **NOW:** Ctrl+Q + reopen daemon (KBP-38) — apesar de `claude agents` CLI listar, Agent tool runtime resolver depende de daemon-level refresh.
- 🟡 **Mid-Phase 2 ou 3 se Perna 6 falhar:** `! nlm login` (TTL ~20min OAuth) — Lucas-only action.

---

## Bench design constants (held constant ambos paths)

**3 questions** (Lucas turn 3 fixou taxonomia 3 eixos):
- **Q1** "Como meta-análises diferem entre design primário (RCT clássica vs coorte/observacional vs acurácia diagnóstica)? Premissas estatísticas, ferramentas RoB, exemplos seminais."
- **Q2** "IPD-MA vs aggregate-level pooled MA: quando IPD é necessário, custo, exemplos práticos comparativos."
- **Q3** "Pairwise MA vs Network MA: assumptions (transitivity, consistency), CINeMA framework, indications vs limits."

**Workspace:** `.claude/.parallel-runs/2026-04-27-ma-types/{path-a,path-b}/`

**Synthesis layer:** Claude orchestrator (eu) — held constant. Bench varia upstream research source apenas.

**Variable bench compares:** Pernas 1 + 5 invocation method (script `.mjs` vs agent wrap). Pernas 2, 6, 7 idênticas ambos paths. Perna 3 mbe-evaluator skip (slide ainda não existe). Perna 4 reference-checker skip (sem evidence ainda).

---

## Phase 2 — Path A run (script-orchestrated, ~30min)

**Workspace:** `.claude/.parallel-runs/2026-04-27-ma-types/path-a/`

**Manual dispatch (skill blocked-from-model):**

| Perna | Method | ×N | Output path |
|---|---|---|---|
| 1 Gemini | `node .claude/scripts/gemini-research.mjs "<Qn>"` | 3 | `path-a/perna1-gemini-q{1,2,3}.md` |
| 5 Perplexity | `node .claude/scripts/perplexity-research.mjs "<Qn>"` | 3 | `path-a/perna5-perplexity-q{1,2,3}.md` |
| 6 NLM | `nlm notebook query <id> "<Qn>"` (notebook id TBD se mapeado, senão pula) | 3 | `path-a/perna6-nlm-q{1,2,3}.md` |
| 2 Evidence | `evidence-researcher` Agent (slide novo, queries MCP academicos) | 1 | `path-a/perna2-evidence-researcher.md` |
| 7 Codex | `codex-xhigh-researcher` Agent (JSON schema-strict) | 3 | `path-a/perna7-codex-q{1,2,3}.json` |

**Timing capture:** wrap cada dispatch em `time` (Bash) — total wall-clock per perna em `path-a/timing.txt`.

**Cost capture:** Codex stdout reporta tokens; Gemini/Perplexity .mjs já loga; NLM ~$0 (max plan); evidence-researcher MCP ~$0 (Anthropic-side conta).

**Anti-rate-limit:** Pernas 1+5 sequential dentro do path; entre Q1/Q2/Q3 throttle 5s explicit.

---

## Phase 3 — Path B run (agent-orchestrated, ~30min)

**Workspace:** `.claude/.parallel-runs/2026-04-27-ma-types/path-b/`

**Custom dispatch (orchestrator manual override do skill):**

| Perna | Method | ×N | Output path |
|---|---|---|---|
| 1 Gemini | Agent `gemini-deep-research` via Agent tool (NÃO Bash) | 3 | `path-b/perna1-gemini-q{1,2,3}.md` |
| 5 Perplexity | Agent `perplexity-sonar-research` | 3 | `path-b/perna5-perplexity-q{1,2,3}.md` |
| 6 NLM | same Bash CLI (não migratable — OAuth interactive) | 3 | `path-b/perna6-nlm-q{1,2,3}.md` |
| 2 Evidence | same `evidence-researcher` Agent | 1 | `path-b/perna2-evidence-researcher.md` |
| 7 Codex | same `codex-xhigh-researcher` Agent | 3 | `path-b/perna7-codex-q{1,2,3}.json` |

**Important:** Path A and B run **sequentially**, não paralelo (rate-limit + isolated timing measurement, plan §170).

**Subagent prompt fidelity check (mid-phase):** depois do primeiro Q1 dispatch em Path B, Read `.claude/agents/gemini-deep-research.md` body + comparar com `gemini-research.mjs` SYSTEM_PROMPT — divergência semântica = abort + report. (KBP-32 spot-check obrigatório, não over-engineering.)

---

## Phase 4 — Comparison TSV (~30min)

**Path:** `.claude/.parallel-runs/2026-04-27-ma-types/comparison.tsv`

**Columns (ambos paths × 12):**

| Column | Source |
|---|---|
| `path` | "A-script" / "B-agent" (label hidden quando Lucas reads) |
| `total_wallclock_s` | Σ `path-{a,b}/timing.txt` |
| `cost_usd_estimate` | API tokens × rate (Codex stdout, Gemini/Perplexity .mjs log) |
| `pmid_count` | unique PMIDs across pernas (regex extract) |
| `pmid_fab_rate` | NCBI E-utils spot-check 5 random / 5 (esummary `.title // "FAB"`) |
| `coverage_q1_design` | 0-3 (uncovered/sparse/adequate/deep) — eu rate post-blind |
| `coverage_q2_ipd` | 0-3 |
| `coverage_q3_nma` | 0-3 |
| `schema_compliance_perna1` | Path A=`n/a` (markdown), Path B=bool (JSON valid?) |
| `schema_compliance_perna5` | idem |
| `error_path_quality` | exit codes informativos? structured stderr? |
| `lucas_judgment_blind` | 1-5 (Lucas reads outputs com labels escondidos — Phase 4 gate) |
| `notes` | livre |

**PMID spot-check Bash (já no plan original):**
```bash
for pmid in $(shuf -n 5 pmids.txt); do
  curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=pubmed&id=${pmid}&retmode=json" | jq '.result["'$pmid'"].title // "FAB"'
done
```

**Blind read protocol:**
1. Eu construo `path-a/blind/` e `path-b/blind/` symlinks (ou copies) renomeados pra `set-1/` `set-2/` (random which is which).
2. Lucas lê apenas `set-1/` e `set-2/`.
3. Lucas scores 1-5 cada set + notes qualitativos.
4. Eu mapeio set-N → path-{a,b} pós-rating.

---

## Phase 5 — Decision per S262 matrix (~15min)

**Lucas-driven** com tech metrics como input:

| Outcome | Trigger | Action |
|---|---|---|
| **MERGE** (sunset .mjs) | Path B wins ≥4/6 metrics + Lucas judgment ≥4 | `.mjs` deprecated em SKILL.md; mover `_archived/` (6mo retention); subagents canonical |
| **KEEP-SEPARATE** | Diff strengths (e.g., scripts melhor hot-path, agents melhor cross-family) | SKILL.md document role differentiation; both dispatched conditionally |
| **MERGE-BACK** | Path A wins claramente | Archive `.claude/agents/_archived/`; `.mjs` stays canonical; subagent experiment failed |

**Lucas-override rule (KBP-39):** se technical metrics suggest X mas Lucas decide Y, document como `decision_override.md` com reasoning explícito.

**Decision documented em:**
- `.claude/.parallel-runs/2026-04-27-ma-types/decision.md`
- HANDOFF S265 P0 (carryover Phases 6-8)
- KBP-47 update se relevante

---

## Verification (end-of-S264)

1. **Bench artifacts existem:**
   - `path-a/` populated 18 outputs (3×6) + `timing.txt` + `cost-estimate.txt`
   - `path-b/` idem
   - `comparison.tsv` filled 12 colunas × 2 rows
   - `decision.md` written com Lucas signoff explícito

2. **Subagents Phase 1 functional (smoke confirmed mid-bench):**
   - `gemini-deep-research` retorna text + sources block, exit 0, schema-valid se applicable
   - `perplexity-sonar-research` retorna table format Tier 1, all PMIDs CANDIDATE flagged

3. **Cross-ref propagation:**
   - HANDOFF.md S265 P0 registrado com decision outcome
   - CHANGELOG.md S264 line ≤5 linhas (Aprendizados + residual)

4. **No carryover violations:**
   - KBP-47 still cited em SKILL.md (não removido)
   - KBP-48 idem
   - Decision aligned with KBP-39 process (blind read + override doc se aplicável)

---

## Lucas-only checkpoints (5)

| # | When | Action | Cost Lucas |
|---|---|---|---|
| 1 | **NOW** | Ctrl+Q + reopen Claude Code (UI) — KBP-38 daemon refresh | ~30s |
| 2 | Phase 2/3 se Perna 6 falhar | `! nlm login` (OAuth Chrome popup) — TTL relogin | ~1min |
| 3 | Phase 4 end | Blind read `set-1/` + `set-2/` + score 1-5 cada + notes | ~15-20min |
| 4 | Phase 5 | MERGE / KEEP-SEPARATE / MERGE-BACK decision com reasoning | ~5min |
| 5 | Session close | CHANGELOG.md S264 line + HANDOFF S265 carryover OK | ~2min |

Resto orchestrator-driven (eu).

---

## Critical files

### Create (S264 scope)

- `.claude/.parallel-runs/2026-04-27-ma-types/path-a/perna{1,5,6}-*-q{1,2,3}.md` (15 files)
- `.claude/.parallel-runs/2026-04-27-ma-types/path-a/perna2-evidence-researcher.md`
- `.claude/.parallel-runs/2026-04-27-ma-types/path-a/perna7-codex-q{1,2,3}.json`
- `.claude/.parallel-runs/2026-04-27-ma-types/path-a/{timing,cost-estimate}.txt`
- `.claude/.parallel-runs/2026-04-27-ma-types/path-b/*` (idem layout)
- `.claude/.parallel-runs/2026-04-27-ma-types/comparison.tsv`
- `.claude/.parallel-runs/2026-04-27-ma-types/decision.md`

### Modify (final commit S264)

- `HANDOFF.md` — fechar S264 P0, abrir S265 P0 com Phases 6-8 carryover
- `CHANGELOG.md` — S264 line (Aprendizados + residual ≤5 linhas)

### Untouched this slice

- `.claude/agents/{gemini-deep,perplexity-sonar}-research.md` — specs já S263 commit
- `.claude/skills/research/SKILL.md` — KBP-47/48 já S263 commit
- `content/aulas/metanalise/**` — Phases 6-8 deferred S265

---

## Estimate + risks

**Total wall-clock S264:** ~90-120min (HANDOFF estimou 60-90 mas blind read + decision adds buffer).

**Costs:**
- Codex 2× × 3 Q = 6 calls — **$0** (quota Lucas + CLI local `codex 0.125.0`)
- Gemini 2× × 3 Q = 6 calls — **$0** (max plan; **manter API REST** mesmo CLI disponível — Lucas reporta API com respostas melhores; agent já é curl, não CLI — `splendid-munching-swing.md:98`)
- Perplexity 2× × 3 Q = 6 calls × ~$0.05-0.10 = **~$0.30-0.60** (única perna paid)
- NLM **$0** (max plan)
- **Total estimated:** $0.30-0.60 (~80% redução vs estimativa inicial)

**Risks:**
1. **NLM TTL ~20min mid-bench** → Perna 6 cai em ambos paths (não enviesa A vs B). Mitigation: rerun Perna 6 depois de relogin se necessário.
2. **Subagent prompt fidelity drift** → bench compara two systems não strictly equivalent. Mitigation: spot-check Phase 3 mid-run (KBP-32).
3. **Ctrl+Q + reopen falha refresh** → Agent tool não resolve `gemini-deep-research` apesar de `claude agents` CLI listar. Detection: primeiro Agent dispatch retorna "agent not found". Recovery: rerun Ctrl+Q ou Lucas debug daemon.
4. **PMID fab rate alta (>20%)** ambos paths → flag "research quality issue" general, não bench-specific. Document em comparison.tsv `notes`.
5. **Lucas blind judgment empate** → both sets scored 3.0 → fallback regra: tech metrics decide (≥4/6 = MERGE).

---

## References

- Master plan: `.claude/plans/splendid-munching-swing.md` (Phases 0+1 done, 2-5 esta slice, 6-8 S265+)
- S262 migration plan: `.claude/plans/S262-research-mjs-additive-migration.md`
- Decision matrix anchor: KBP-39 (blind read) + KBP-47/48 (canonical pattern S263 fixed)
- HANDOFF S264 P0 source: `HANDOFF.md`
- Skill blocked-from-model frontmatter: `.claude/skills/research/SKILL.md:3`

---

## S264.a Mid-Session Pivot — Agent Fixes + Substrate Org (Phase 6-8 deste plan)

> **Trigger:** Phase 2 Path A partial execution surfaced 3 agent/orchestration issues + Lucas APL pivoted para `qa-editorial-metanalise` (outro agente ativo em paralelo — cross-window protocol KBP-25/KBP-40 ATIVA).
> **Outcome S264.a:** agents fixed empiricamente, smoke outputs preservados como bench substrate, Phase 2 NLM Q2+Q3 e Phase 3-5 deferred S265 com state limpo.
> **Coautoria:** Lucas + Claude Code (Opus 4.7).

### Context

Phase 2 Path A executou 4/5 pernas Q1 + 2/3 pernas Q2:
- ✅ Gemini.mjs Q1+Q2 (~32-60s each, ~7600 chars output)
- ✅ Perplexity.mjs Q1+Q2 (~112-180s, prose extensa — IGNORA system_prompt "table only" quando user query pede narrative; bench finding documentado)
- ✅ NLM Q1 (~62s, 23 citations cross-ref); Q2 killed via TaskStop após NLM TTL expirou (~20min OAuth gate)
- ✅ Codex Q1 via codex-xhigh-researcher Agent (240s, 4 findings, 0% PMID fab — strongest perna)
- ❌ Evidence-Researcher Q1 — 600s watchdog stall pre-MCP-init

**Empirical findings agent-level (Phase 2 surface):**
1. **Evidence-Researcher 600s stall — root cause likely Phase 1 body protocol:** spec body §Fase 1 step 1-3 reads `content/aulas/{aula}/slides/{file}.html` + `evidence/s-{id}.html` + aula CLAUDE.md. Para slide novo (`s-ma-types` não existe ainda) → file-not-found cascade → agent stall (não MCP cold-start primário, hipótese inicial).
2. **3-Q batch violou §ENFORCEMENT #2 "1 slide/tema por execucao":** meu dispatch enviou 3 questions em uma execução = violação dual (escopo + protocolo).
3. **MCP fan-out 5 servers (pubmed/crossref/semantic-scholar/scite/biomcp):** biomcp via `uvx` Python = slowest cold-start path; redundante pra meta-analysis methodology queries (biomcp foco genomic/farmacovigilância). Safe drop.
4. **Perplexity-sonar-research maxTurns:15** insuficiente — smoke evidenciou 15/15 turns esgotados antes de stdout final JSON (data on disk OK).
5. **cwd-trap pattern:** Bash cwd persiste cross-tool-call. Relative paths from `cd` em call N quebraram em call N+1. **Lição:** absolute paths sempre em dispatches sequenciais. KBP-Candidate.

### Phase 6 — Agent fixes (~15min, ESTA sessão)

#### 6.1 `perplexity-sonar-research.md` — VERIFY ONLY (já edited turn anterior)

`maxTurns: 15 → 25` confirmed via Read line 10. Sem mais edits aqui.

#### 6.2 `evidence-researcher.md` — 2 fixes complementares

**A) Drop `biomcp` (uvx Python cold-start, redundante MA methodology):**
- Remove `mcp:biomcp` from `tools:` array (line 13)
- Remove `biomcp:` block from `mcpServers:` (lines 36-39)
- Update §MCP Toolkit table line ~67: remove biomcp row → 4 MCPs
- Description line 3: remove "BioMCP" reference → "PubMed, CrossRef, Semantic Scholar, Scite"

**B) Add §Bench Mode subsection (body, ~12 linhas após §Fase 1):**
```
### Fase 1.5 — Bench mode (slide ainda não existe)

Trigger: orchestrator dispatch sem slide HTML pré-existente (S264 bench
splendid-munching-swing.md Phase 2-3, slide `s-ma-types` em construção).

Adapt:
1. SKIP Fase 1 file reads (slide HTML/evidence HTML/aula CLAUDE.md inexistentes).
2. Receber `synthetic_context` inline do orchestrator prompt.
3. Single-Q only por dispatch (3-Q batch viola §ENFORCEMENT #2). 1 dispatch = 1 question.
4. Output path override: orchestrator especifica path em prompt (default
   `qa-screenshots/{slideId}/content-research.md` não aplica — slide path inexistente).
5. MCP cold-start: accept 30-60s primeiro spawn (npx install). Não stall watchdog.
```

#### 6.3 (NÃO mexer) `gemini-deep-research.md` + `codex-xhigh-researcher.md`

Smoke + Phase 2 Codex Q1 = clean. Sem ajustes necessários.

### Phase 7 — Substrate organization (~5min)

#### 7.1 Move smoke artifacts

```bash
mkdir -p .claude/.parallel-runs/2026-04-27-ma-types/smoke/
mv .claude/.research-tmp/{gemini,perplexity}-smoke-i2-threshold*.json \
   .claude/.research-tmp/payload-smoke-i2-threshold.json \
   .claude/.research-tmp/prose-i2.txt \
   .claude/.parallel-runs/2026-04-27-ma-types/smoke/
```

5 files → smoke/ (gemini raw + validated, perplexity raw + validated, payload, prose).

#### 7.2 Create `bench-log.md`

Path: `.claude/.parallel-runs/2026-04-27-ma-types/bench-log.md`

Conteúdo (~50 li markdown):
- S264.a timeline (smoke → Phase 2 Q1 → cwd-trap → Q2 retry → NLM TTL kill)
- Per-perna outcomes table (path-a)
- KBP-Candidates surfaced:
  - **KBP-Candidate-A:** Bash cwd persiste cross-call; absolute paths obrigatórios em sequenciais
  - **KBP-Candidate-B:** Evidence-Researcher Phase 1 file-reads stall when slide novo; bench mode override needed
  - **KBP-Candidate-C:** Perplexity sonar API ignora system_prompt "table only" quando user query pede narrative; agent body deve repetir constraint em user message para hard enforcement
- Bench-relevant Perplexity behavior: confirma `<think>` confessional (exposed S262 finding S264 reaffirmed)

#### 7.3 Create `agent-adjustments.md`

Path: `.claude/.parallel-runs/2026-04-27-ma-types/agent-adjustments.md`

Conteúdo (~30 li):
- `perplexity-sonar-research.md`: maxTurns 15→25 — rationale (smoke cap), evidence (15/15 turns burned, JSON disk OK), commit S264 turn ?
- `evidence-researcher.md`: drop biomcp + add §Bench Mode — rationale (Phase 1 body conflict + uvx slow), evidence (600s stall pre-MCP), commit S264 turn ?
- Per-edit diff blocks (old → new).

### Phase 8 — Verification (read-only spot-checks)

1. `Read .claude/agents/perplexity-sonar-research.md` line 10 → `maxTurns: 25` ✅
2. `Read .claude/agents/evidence-researcher.md` → biomcp ausente em tools/mcpServers/§MCP Toolkit; §Bench Mode presente após §Fase 1 ✅
3. `ls .claude/.parallel-runs/2026-04-27-ma-types/smoke/` → 5 files ✅
4. `Read bench-log.md` → narrativa coerente, KBP-candidates listados ✅
5. `Read agent-adjustments.md` → diffs + rationale ✅
6. **Smoke-retest Evidence-Researcher single-Q (DEFER S265):** validar fix antes de Phase 3 dispatch. Não esta sessão (cross-window risk + APL pivot).

### Cross-window guards (NÃO TOCAR esta sessão)

Outro agente em `qa-editorial-metanalise` scope. Files M no git status (NÃO modificar):
- `HANDOFF.md`, `GEMINI.md`, `CHANGELOG.md`
- `content/aulas/metanalise/.slide-integrity`
- `content/aulas/metanalise/HANDOFF.md`
- `content/aulas/metanalise/evidence/{evidence-harvest-S112.md,meta-narrativa.html,research-gaps-report.md,s-ancora.html,s-contrato.html,s-forest-plot-final.html,s-objetivos.html}`
- `content/aulas/metanalise/slides/08a-forest1.html`

**Safe edits esta sessão:** `.claude/agents/{evidence-researcher,perplexity-sonar-research}.md` + `.claude/.parallel-runs/2026-04-27-ma-types/**` + `.claude/plans/sleepy-wandering-firefly.md` (este plan).

### Critical files

#### Create
- `.claude/.parallel-runs/2026-04-27-ma-types/smoke/` (5 files moved into)
- `.claude/.parallel-runs/2026-04-27-ma-types/bench-log.md`
- `.claude/.parallel-runs/2026-04-27-ma-types/agent-adjustments.md`

#### Modify
- `.claude/agents/evidence-researcher.md` — drop biomcp (4 locations) + add §Bench Mode (1 insertion)

#### Verify only (already edited prior turn)
- `.claude/agents/perplexity-sonar-research.md` — maxTurns 25

#### Untouched (cross-window protocol)
- HANDOFF.md, GEMINI.md, CHANGELOG.md, content/aulas/metanalise/**

### Estimate

**Total ~25min** (Phase 6 ~15min + Phase 7 ~5min + Phase 8 ~5min). APL focus já estourou 20min target — overrun aceitável dado scope-shift Lucas-driven.

### S265 carryover (after this pivot lands)

- ~~Smoke-retest Evidence-Researcher single-Q post-fixes~~ — DONE S264.a turn ~10 (Q1 ✅ 9 sources MCP-verified, ROBINS-I bonus, §Fase 1.5 fix CONFIRMED empirically)
- ~~Phase 2 completion: NLM Q2 + all pernas Q3~~ — DONE S264.a (NLM 3/3 post-relogin; Q3 across script pernas all ✅)
- ~~Phase 3 Path B (4 agents × 3 Q = 12 dispatches)~~ — Reframed: per plan §164-165, Path B reuses Codex+Evidence-Researcher do Path A; só gemini-deep + perplexity-sonar são new wraps. **6 dispatches done, 1/6 clean validated JSON** (gemini Q3 só). Vide §S264.b post-mortem abaixo.
- Phase 4-5 comparison + decision — gated em §S264.b decision

---

## S264.b — Path B post-mortem + decision (Phase 9 deste plan)

> **Trigger:** 6 Path B dispatches (gemini-deep ×3 + perplexity-sonar ×3) convergidos pos-S264.a fixes. Estado real surfacing agent-chattiness empírico — NÃO previsto antes do bench.
> **Lucas turn:** "quero o plan escrito com justificativas e o que acha que vai ficar melhor com justificativa que sera verifiacada por outro agente".
> **Coautoria:** Lucas + Claude Code (Opus 4.7).

### State briefing — substrate inventory (verified em disk)

#### Path A (path-a/) — 14 outputs validated, 1 deferred

| Perna | Q1 | Q2 | Q3 | Substrate |
|---|---|---|---|---|
| 1 gemini.mjs | ✅ 32s 7.6KB | ✅ 38s 7.6KB | ✅ ~30s | prose markdown |
| 5 perplexity.mjs | ✅ 112s 33KB | ✅ 180s 44KB | ✅ ~120s | **prose IGNOROU system_prompt "table only"** — `<think>` confessou override. Mistura PMC/grey-lit, não Tier 1 puro. |
| 6 nlm | ✅ 62s 39KB | ✅ post-relogin | ✅ post-relogin | JSON-formatted answer com 23+ citations cross-ref |
| 2 evidence-researcher | ✅ 1067s, 9 sources MCP-verified, 0 CANDIDATE (post §Fase 1.5 fix) | – defer | – defer | markdown estruturado por eixo |
| 7 codex (xhigh) | ✅ 240s, 4 findings, 4/4 PMIDs verified | ✅ 285s, 5 findings, 6/6 PMIDs verified, **cisplatin ovarian killer divergence** | ✅ 263s, 5 findings, 4/4 PMIDs verified (Salanti/CINeMA/Cipriani/Psaty) | **JSON schema-strict, 0% fab consistent across 14 PMIDs** |

#### Path B (path-b/) — 1 validated, 5 raw-only em research-tmp/

| Perna | Q1 | Q2 | Q3 |
|---|---|---|---|
| 1 gemini-deep | ⚠️ raw 26KB OK, **hit maxTurns:15 cap** pré-emit Phase 6 | ❌ 88s, raw 0 bytes — **HTTP error 429 rate-limit** (3 dispatches simultâneos contra single API key) | ✅ 200s, 12/15 turns, 4 findings, **7/7 PMIDs NCBI-verified** (Cipriani 29477251, CINeMA 32243458, Salanti 23826681, Psaty NMA antihipertensivos), 4.5KB JSON path-b/ |
| 5 perplexity-sonar (maxTurns:25 post S264.a) | ⚠️ 418s, 15 turns, raw 25KB, **stop natural pré-emit** — text "Now assembling final output JSON" mas não Write. **4/4 PMIDs Tier 1 verified** (BMJ ×2, Ann Intern Med ×2) | ⚠️ 282s, 16 turns, raw 60KB, stop mid-Phase 5 spot-check | ⚠️ 375s, 15 turns, raw 61KB, stop mid-extraction PMIDs |

#### Codex bracket (shared Path A+B per plan §164-165) — 3/3 ✅

- **Strongest perna empírica**: 0% fab across 14 sampled PMIDs (verified inline NCBI), 100% schema compliance, ~262s avg
- Body Codex (S259 POC) = 1 phase (Codex CLI subprocess produz JSON nativo). Sem chattiness.

### O que deu certo (com justificativa)

1. **Codex bracket**: body design Codex = single Codex-CLI invocation produces JSON nativo. Agent só wraps + NCBI spot-check inline. Resultado: zero overhead phases, 0% fab, schema-strict. **Pattern canonical mais robusto observado**.
2. **Evidence-researcher post-§Fase 1.5 fix**: hipótese root-cause (file-not-found cascade slide novo) confirmada — Q1 retest funcionou com synthetic_context inline. Bonus: ROBINS-I (PMID 27733354) emergiu como tool preferred over Newcastle-Ottawa para observacional, signal substantivo pra slide.
3. **Path A scripts ×9**: prose markdown reliable, sem schema mas COMPLETENESS 100%. Direct script invocation = no orchestration tax.
4. **Perplexity-sonar Q1 (Tier 1 filtering)**: 4/4 PMIDs verified de BMJ + Ann Intern Med — única perna com filtragem real Tier 1. Justifica wrap value-add vs perplexity.mjs (que IGNORA system_prompt).

### O que deu errado (com justificativa)

1. **Agent-chattiness** (Path B core issue): perplexity-sonar body has 6 phases (preflight + ingest + API + parse + validate + spot-check + emit). Each phase = 1+ text turn for "I'll do X next" reasoning + 1+ tool call. Empírico: agent termina ~15-16 turns NATURALMENTE (não cap-hit, maxTurns:25 não esgotado) sem reach Phase 6 emit. **Wrap canonical adiciona turn-overhead vs script direto** — bench finding genuíno (not bug, é caracter de wrap layer).
2. **Gemini-deep maxTurns:15** edit oversight (S264.a turn ~7): só perplexity bumped. Mesma chatty pattern + cap mais apertado = Q1+Q2 não emit.
3. **Gemini Q2 HTTP error 429**: rate-limit, 3 gemini-deep simultâneos contra single Gemini API key. Stagger entre dispatches resolveria.
4. **Perplexity.mjs (Path A) ignora system_prompt**: bench finding adicional — modelo Perplexity sonar-deep-research treats system_prompt como "personalization" (lower priority), user query semantics como "report_format" (higher). Hardcoded `SYSTEM_PROMPT = "Return findings as markdown tables ONLY"` (perplexity-research.mjs:55) = teatro. Same fragility no wrap agent (Q2/Q3 raws contém prose-then-extract pattern).

### 3 opções decisão (Path B incompleteness)

| Opt | Ação | Custo | Tempo | Risco | Effect on bench |
|---|---|---|---|---|---|
| **A** | Re-dispatch 5 missing com maxTurns:50+ + 5s stagger | +5 perplexity ~$0.30 + 2 gemini $0 | ~30min wall | Agent ainda termina pré-emit (chattiness ≠ cap-hit) | Mais empirical samples, valida hipótese chattiness |
| **B** | Orchestrator-parse raws (eu faço Phase 6 emit) | $0 + ~30min | ~30min | Bench fairness DEGRADED — orchestrator faz trabalho do agente | Path B "limpa" mas favorece agentes (mascara issue) |
| **C** | Aceitar partial + documentar bench finding | $0 + ~5min | ~5min | Lucas pode preferir mais samples → fallback A | **Bench finding HONESTO** — wrap chattiness é signal, não bug |

### Recomendação: **Opção C**

#### Justificativas (verificáveis por outro agente)

1. **Honest > masked**: agent chattiness é diferença REAL entre Path A scripts e Path B agents. Documentar (C) informa decisão MERGE/KEEP/MERGE-BACK honestamente. Mascarar (B) ou tentar mais (A) pode perder o signal.

2. **Cost-benefit aritmética**: A = +$0.30 + 30min para improvement INCERTO (chattiness ≠ cap, maxTurns:50 talvez não resolva). B = $0 + 30min mas undermines fairness. C = $0 + 5min + signal preserved.

3. **"Comparacao justa" interpretation (Lucas frame)**: fair = honest reporting de each path's intrinsic behavior. NÃO forcing parity by orchestrator labor (B) ou extra resources (A). Path A scripts emit prose reliably; Path B agents têm quality variance + emit reliability issue. **Esta é a comparação**.

4. **Decision matrix calibração** (KBP-39): com Option C state, comparison.tsv preenche:
   - Path A: completeness 14/15, codex shines, perplexity prose pollution
   - Path B: completeness 1/6 emit + Perplexity Q1 Tier 1 winning quality + Codex shines (shared) + Gemini Q3 7/7 verified
   - Conclusion likely: **HYBRID/KEEP-SEPARATE** (não MERGE wholesale, não MERGE-BACK wholesale). Cada path tem strengths empíricas distintas.

5. **Bench substrate preservation**: 5 raws em research-tmp/ ficam disponíveis pra orchestrator-parse FUTURO se Lucas quiser opt-in. Não preciso decidir agora — defer reversível.

6. **Fast iteration > exhaustive iteration**: APL marcou ~720 tool calls, custo HIGH. Optar por documentação rápida + commit checkpoint > re-dispatch que pode falhar mesma forma.

#### Counter-positions antecipadas (para verifier challenge)

- **"maxTurns:25 era cap?"** → Não. Perplexity Q2 usou 16 turns (cap 25), Q1 usou 15 turns. Stop foi NATURAL termination pre-emit, não exhaustion. Pattern consistente 3/3 perplexity dispatches.
- **"Sample size 6 muito small?"** → Sample small mas variance alta IS the signal: 1/6 success rate é estatisticamente meaningful para "system unreliable", e o failure mode é CONSISTENT (5/6 stop pre-emit, 1/6 HTTP error). Não é random noise.
- **"Refactor agent body skip phases?"** → Option D (não listada acima): re-write para single-turn-emit. Heavy refactor (~2-3h), risk breakage, perde spot-check quality gate. Defer S265+ se Lucas quiser Path B canonical post-bench.
- **"Por que evidence-researcher Q1 funcionou (45 turns)?"** → evidence-researcher tem maxTurns:35 + body NÃO tem 7-phase emit cycle (escreve report direto via Write tool, não JSON-validate-spot-check chain). Pattern diferente.

### Critical files

#### Modify (Option C execution post-approval)

1. `.claude/.parallel-runs/2026-04-27-ma-types/comparison.tsv` — **CREATE** com 12 colunas spec'd (S264 plan §174). Linhas Path A vs Path B.
2. `.claude/.parallel-runs/2026-04-27-ma-types/decision.md` — **CREATE** com Lucas signoff + recommended outcome (KEEP-SEPARATE provável).
3. `.claude/.parallel-runs/2026-04-27-ma-types/bench-log.md` — **APPEND** §S264.b findings + KBP-Candidate-D agent chattiness.
4. `.claude/.parallel-runs/2026-04-27-ma-types/path-b/` — **MOVE** raws de research-tmp/ pra path-b/ (preservation, não validation): `gemini-Q{1,2,3}-pathB-raw.json`, `perplexity-Q{1,2,3}-pathB-raw.json`, `*-payload.json` per Q.

#### Untouched

- HANDOFF.md, GEMINI.md, CHANGELOG.md (cross-window outro agente)
- `.claude/agents/*.md` — fixes S264.a já aplicados
- Path A files (preserved as-is)

### Verification (how verifier should check this plan)

1. **State claims:** verify path-b/ has 1 validated JSON (`perna1-gemini-q3.json` 4.5KB) + 1 zero-byte (`perna5-perplexity-q1.json`). Verify research-tmp/ has 5 raws ≥25KB except Q2 gemini = 0 bytes (HTTP error).
2. **Codex 0% fab claim:** spot-check 3 PMIDs across path-a/perna7-codex-q{1,2,3}.json via NCBI E-utils. Real fab rate = (failures / 3 sampled) — should be 0/3.
3. **Agent chattiness root cause:** Read `.claude/agents/perplexity-sonar-research.md` body. Count phases. Confirm ≥6 phases each with text reasoning. Compare Codex agent body (`.claude/agents/codex-xhigh-researcher.md`) — count phases. Codex should have ≤3 phases.
4. **Option C tradeoff math:** verify Lucas's HIGH cost flag justifies fast-close path. APL counter at ~720 calls = real signal.
5. **Decision matrix call** (KBP-39): re-derive MERGE / KEEP-SEPARATE / MERGE-BACK from current data. Justify against my "HYBRID likely" prediction.

### Estimate Option C execution

- ~5min documentation (bench-log append + decision.md draft)
- ~5min comparison.tsv build (Path A vs B columns from current substrate)
- ~5min raw move research-tmp → path-b
- ~10min Lucas blind read + signoff
- **Total ~25min** to S264.b close

### S265 carryover (post Option C)

- Phases 6-8 master plan (`splendid-munching-swing.md`): Living HTML `s-ma-types.html` + slide build + QA
- KBP-Candidate-D formalize: agent chattiness pattern (perplexity-sonar/gemini-deep wrap layer turn-overhead — needs body refactor OR alternative dispatch pattern)
- Optional: Option A re-dispatch experiment se Lucas quiser maior sample (defer until decision matrix locked)
- Cross-window release: CHANGELOG S264 + HANDOFF S265 P0 (post outro-agente-finish)

---

## S264.c — Codex peer-review integration + recalibrated recommendation

> **Trigger:** Lucas pasted Codex CLI peer review (segundo modelo GPT-5.5) em outra janela. Findings materiais (P1+P2) corrigem o plano §S264.b. Esta secção amenda recomendação para refletir review.
> **Lucas turn:** "entre em plan e proponha".
> **Coautoria:** Lucas + Claude Code (Opus 4.7) + Codex CLI peer-review.

### Context (por que recalibrar)

Codex peer-review identificou **3 erros materiais** + **4 blind spots** + **counter-argument forte** que invalidam parcialmente §S264.b. Não é refutação total — é refinamento de framing. Plan §S264.b mantém-se como state briefing; §S264.c re-frames recomendação.

### Findings materiais Codex (P1/P2 corrigidos)

| ID | Issue (§S264.b claim) | Correção (Codex) | Severity |
|---|---|---|---|
| **F1** | "14 outputs Path A" | Real = **13 substantive outputs** (gemini ×3 + perplexity ×3 + nlm ×3 + codex ×3 + evidence-researcher ×1 = 13). | P1 — verifiable, my count error |
| **F2** | "Gemini Q2 HTTP 429 = agent failure" | **Orchestration confound MEU**: 3 gemini-deep dispatched simultaneously contra plan §170 que mandava sequencial. NÃO falha arquitetural. | P1 — meu erro, não evidência contra Path B |
| **F3** | "Agent chattiness é root cause" | Formulação forte demais. maxTurns docs (Agent SDK) = limita "turns agentic/tool-use", não mensagens totais. Stop natural pode ser `end_turn`, budget self-regulation, OR chattiness. **Precisa transcript + ResultMessage.subtype + stop_reason pra virar KBP**. Atual = "principal hipótese suportada por transcript". | P2 — downgrade strength |

### Strongest counter-argument (Codex, concedido)

**Bench não comparou ".mjs vs agents".** Comparou ".mjs determinístico" contra "agents chatty 6-phase com parse/validate/spot-check/emit conversacional". Isso enviesou contra Path B.

Codex auto-prova: **agent CAN be robust quando design = thin wrapper + deterministic runner** (`codex-xhigh-researcher` body = 1 phase, `codex exec --output-schema` enforces JSON nativo, 0% fab consistent). Conclusão correta:

> *"Scripts vencem ESTES wrappers chatty (gemini-deep, perplexity-sonar). Thin-agent + deterministic runner é o melhor padrão (codex-xhigh-researcher prova)."*

NÃO "scripts vencem agents geral".

### Blind spots críticos (Codex)

1. **maxTurns ≠ "mensagens totais":** Anthropic Agent SDK doc — loop termina quando Claude produz resposta sem tool calls. maxTurns limita TURNS AGENTIC/TOOL-USE. "15 turns natural stop" precisa transcript + stop_reason antes de virar KBP-Candidate.
2. **SubagentStop hooks (Claude Code) = alternativa arquitetural:** em vez de bump maxTurns, usar hook quality "output JSON exists+validates" pode prevent subagent stop pre-emit. **Não explorado §S264.b**.
3. **KBP-48 forte demais:** "wrap = sempre agente" não é o que dados favorecem. Reformulação suportada: *"APIs externas devem ter contrato determinístico/auditável; if wrapped por agent, agent precisa ser thin + verifiable"*.
4. **Perplexity ignora system_prompt afeta `.mjs` E agent:** mesmo modelo/API. **Não é evidência limpa contra scripts** — bug API contract Perplexity, ortogonal a wrap-vs-direct.

### Recomendação recalibrada: **Option C provisional + KEEP-SEPARATE provisional + D-lite track**

#### Three-layer decision

**Layer 1 — Bench close (Option C provisional):**
- Aceitar Path B partial (1/6 emit) + 5 raws preserved
- Documentar bench finding HONESTO (com correções F1/F2/F3 aplicadas)
- Build comparison.tsv com framing corrigido (não "agents pior", e sim "thin-agent venceu, chatty-wrap falhou")

**Layer 2 — Decision matrix outcome: KEEP-SEPARATE provisional**
- `.mjs` canonical Gemini/Perplexity hot path (9/9 ✅ completed reliably) — não MERGE-BACK porque .mjs tem prose-pollution issue (Perplexity ignora system_prompt)
- `codex-xhigh-researcher` canonical agent robusto — thin wrapper + Codex CLI subprocess schema-enforced (POC S259 validated empirically)
- `evidence-researcher` canonical pos-§Fase 1.5 fix (4 MCPs sem biomcp, MCP-grounded ground truth)
- `gemini-deep-research` + `perplexity-sonar-research` = **EXPERIMENTAL** track até D-lite refactor + re-bench

**Layer 3 — D-lite refactor track (S265+):**
Codex argumenta D-lite NÃO é "heavy 2-3h" — corpo dos agents já tem comandos. Custo real = validação, não rewrite. D-lite spec:
- `gemini-deep-research` + `perplexity-sonar-research` collapsed para single-Bash deterministic call: API call → save raw → extract JSON → print final
- Mirror codex-xhigh-researcher pattern (thin agent + deterministic subprocess)
- Smoke + re-bench post-refactor (Phase 1.3 + Phase 3 single-Q)
- Decision: se D-lite versão 6/6 emit ✅ → **MERGE** (sunset .mjs); se ainda flaky → MERGE-BACK Path B specs.

### Justificativas (verificáveis pelo verifier original — Codex)

1. **Honesty gain post-correction:** F1/F2/F3 fixes change bench narrative from "agents are worse" to "chatty-wrap failed, thin-agent winning evidence". Comparison.tsv reflete isso accurately.
2. **Codex own evidence supports KEEP-SEPARATE:** codex-xhigh-researcher 0% fab + 100% schema = thin-agent works. perplexity-sonar 1/3 emit + chatty body = thin-agent doesn't apply yet to that perna. Different patterns, different verdicts per perna.
3. **D-lite cost-benefit favorable:** if Codex right that body já tem comandos, refactor is ~30-60min (não 2-3h). Worth doing in S265 antes de policy lock.
4. **KBP-48 reformulation more defensible:** "thin + verifiable" > "wrap = sempre agente". Holds against future scrutiny. Ainda satisfaz Lucas turn 5 S263 intent (cross-family Codex pattern); refines vs blanket policy.
5. **SubagentStop hooks blind spot acknowledged:** S265+ exploration ANTES de assumir maxTurns is the lever.

### Critical files (S264.c execution)

#### Modify (post-approval)

1. `.claude/.parallel-runs/2026-04-27-ma-types/comparison.tsv` — **CREATE** com framing corrigido (13 outputs, F2 confound noted, F3 chattiness "hipótese principal" not "root cause")
2. `.claude/.parallel-runs/2026-04-27-ma-types/decision.md` — **CREATE** com Lucas signoff + outcome **"KEEP-SEPARATE provisional + D-lite track S265+"**
3. `.claude/.parallel-runs/2026-04-27-ma-types/bench-log.md` — **APPEND** §S264.c findings + Codex peer-review summary + 3 P1/P2 corrections + KBP-Candidate-D revised ("thin-agent vs chatty-wrap pattern, requires transcript proof")
4. `.claude/.parallel-runs/2026-04-27-ma-types/codex-peer-review.md` — **CREATE** preserves Codex review verbatim como bench substrate (review é ele próprio finding)
5. `.claude/.parallel-runs/2026-04-27-ma-types/path-b/` — **MOVE** raws de research-tmp → path-b/

#### Untouched (cross-window outro agente em qa-editorial-metanalise)

- HANDOFF.md, GEMINI.md, CHANGELOG.md
- content/aulas/metanalise/**

### Verification (re-spot-checks)

1. **F1 count fix:** `ls path-a/*.{md,json} | wc -l` should = 13 substantive (excluindo .err, .timing). Confirm.
2. **F3 transcript proof:** read `tasks/*output` files de perplexity-sonar dispatches OR re-spawn 1× with `subagent_stop_reason` capture for KBP formalization. **Defer S265.**
3. **D-lite cost validate:** Read perplexity-sonar-research.md body lines counting Phase 1-6 actual code. If <30 li tooling-relevant, D-lite refactor confirmed cheap.
4. **SubagentStop hooks doc:** WebFetch Anthropic docs for SubagentStop hook usage pattern + apply to gemini-deep/perplexity-sonar bodies como S265+ exploration.

### Estimate (S264.c execution, ~25min total)

- ~5min comparison.tsv build (com framing corrigido)
- ~10min bench-log.md append + decision.md write + codex-peer-review.md preserve
- ~5min raw move research-tmp → path-b
- ~5min Lucas signoff
- Cross-window CHANGELOG + HANDOFF defer S265 (avoid collision)

### S265 carryover (post-S264.c close)

- **D-lite refactor track:** gemini-deep + perplexity-sonar bodies collapsed to thin-deterministic-runner pattern (mirror codex-xhigh-researcher); smoke + re-bench
- **KBP-Candidate-D formalization:** ONLY after D-lite re-bench OR transcript/stop_reason proof. Não pre-formalize "chattiness root cause" sem evidence material (concedido a Codex).
- **KBP-48 reformulation:** soften texto em `.claude/skills/research/SKILL.md` + `known-bad-patterns.md` para "thin + verifiable" framing
- **SubagentStop hooks experiment:** explore como alternative architectural lever vs maxTurns
- **Phases 6-8 master plan** (Living HTML + slide + QA): unblocked após D-lite decision lock
