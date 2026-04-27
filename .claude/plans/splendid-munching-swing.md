# Splendid Munching Swing — Bench Script-Orchestrated × Agent-Orchestrated Research

> **Status:** S263 plan (BUILD_METANALISES). Predecessor: `S262-research-mjs-additive-migration.md`.
> **Princípio (Lucas S263 turn 3):** "iamos testar o script rodando **todas as pernas sempre** x os agents/skills rodando **todas as pernas sempre**" — ensemble obrigatório em ambos paths, never subset. Esta regra não estava registrada (KBP-31 candidate sem commit em sessão anterior, agora sendo formalizada Phase 0).
> **Coautoria:** Lucas + Claude Code (Opus 4.7).

---

## Context

**Por que isto agora.** O `/research` skill atual (7 pernas) mistura dois paradigms de invocação:
- Pernas 1, 5 via **scripts** Node.js (`gemini-research.mjs`, `perplexity-research.mjs`) — orchestration via Bash subprocess
- Pernas 2, 3, 4, 7 via **subagents** (Agent tool) — orchestration via Anthropic agent runtime
- Perna 6 via Bash CLI (`nlm notebook query`)

Lucas (S261 turn 5) propôs migration aditiva non-destrutiva: build agent equivalents alongside scripts, run side-by-side, decide canonical empiricamente. S262 plan formalizou metodologia (`/migration-targets`, `/decision-matrix`). S263 = primeira execução real do bench, ancorada em deliverable concreto: **Living HTML + slide sobre tipos de meta-análise** que entra na lecture metanalise.

**Outcome esperado:**
1. Decisão empírica per-target (MERGE / KEEP-SEPARATE / MERGE-BACK) por S262 matrix
2. Living HTML `s-ma-types.html` produzido pelo path vencedor (ou hybrid)
3. Slide `06-ma-types.html` integrado ao deck metanalise
4. Regra "ensemble sempre" formalizada em SKILL.md + KBP-47 (debt antiga, KBP-31 violation correção)

---

## Bench design

### Constants (held constant em ambos paths)

- **Topic:** "Tipos de meta-análise" — 3 eixos taxonômicos:
  1. **Design do estudo primário:** RCT clássica × coorte/observacional × acurácia diagnóstica (DTA)
  2. **Nível do dado:** IPD (Individual Patient Data) × aggregate-level (pooled summary statistics)
  3. **Estrutura de comparação:** pairwise (2 arms) × Network MA (NMA, indirect evidence multi-arm)
- **Slide framing:** Brief teaching de todos eixos (Lucas turn 3 Q1) — cada eixo recebe ~30-40s de explicação substantiva. Override de `meta-narrativa.html:61` out-of-scope (precisa update — Phase 7).
- **Living HTML schema:** Full pre-reading style 6 sections (Lucas turn 3 Q4) — espelha `evidence/pre-reading-heterogeneidade.html`.
- **Synthesis layer:** Claude orchestrator (held constant). Bench varia upstream research source.
- **Ensemble rule:** ALL applicable pernas em CADA path. Never subset.

### Variable (bench compares this)

**How Pernas 1 + 5 são invocadas:**
- **Path A (script-orchestrated):** Pernas 1, 5 via `.mjs` Bash subprocess (status quo)
- **Path B (agent-orchestrated):** Pernas 1, 5 via NEW dedicated subagents (`gemini-deep-research`, `perplexity-sonar-research`) — built Phase 1

Pernas 2, 4, 6, 7 idênticas em ambos paths (Perna 3 mbe-evaluator não aplicável — slide ainda não existe).

---

## Phase 0 — Setup + rule registration (~30min)

### 0.1 Register architectural rules (debt KBP-31, Lucas S263 turns 3 + 5)

Two rules registered atomically (same Lucas-turn pair, same architectural concern: research dispatch canonical pattern):

- **`.claude/skills/research/SKILL.md` §ENFORCEMENT item 4 (KBP-47):** *"Ensemble obrigatorio. Cada `/research` invocation dispatches ALL applicable pernas (subject to Step 1 mode + Step 1.5 pre-flight). Never subset, never 'so Perna X'. Subset = research subset trap; o valor da pipeline esta em convergencia/divergencia cross-fonte."* (Lucas turn 3)
- **`.claude/skills/research/SKILL.md` §ENFORCEMENT item 5 (KBP-48):** *"Wrap = sempre agente orquestrador. External APIs/CLIs/MCPs sao wrappados como agentes (Anthropic subagent runtime), NUNCA como scripts `.mjs` solitarios. Scripts atuais (gemini-research.mjs, perplexity-research.mjs) sao legacy a migrar (S262 plan). Codex (codex-xhigh-researcher) e evidence-researcher seguem o padrao canonico."* (Lucas turn 5)
- **`.claude/rules/known-bad-patterns.md`:** KBP-47 + KBP-48 entries pointing to SKILL.md §ENFORCEMENT items 4-5. Next pointer bumped to KBP-49.

**Implication for Path A vs Path B framing:** o bench não é hipótese aberta (script ou agent canonical) — Lucas já fixou a regra (wrap = agente). O bench vira **confirmatório**: documentar empiricamente a transição script→agent com métricas, não decidir. Decision matrix S262 ainda aplica per-target, mas vies esperado = MERGE (sunset .mjs).

### 0.2 Define research questions (3 sub-queries dispatched together)

```
Q1: "Como meta-análises diferem entre design primário (RCT clássica vs coorte/observacional vs acurácia diagnóstica)? Premissas estatísticas, ferramentas RoB, exemplos seminais."
Q2: "IPD-MA vs aggregate-level pooled MA: quando IPD é necessário, custo, exemplos práticos comparativos."
Q3: "Pairwise MA vs Network MA: assumptions (transitivity, consistency), CINeMA framework, indications vs limits."
```

### 0.3 Slide spec confirm

- **id:** `s-ma-types`
- **file:** `06-ma-types.html` (next free integer; avoids `04a/04b` collision)
- **Manifest position:** 6 (após `s-rs-vs-ma`, antes `s-quality`)
- **Phase:** F2 (Metodologia)
- **Timing:** 120-150s (3 eixos × ~30-40s teaching)
- **Evidence:** `s-ma-types.html` (Phase 6)

---

## Phase 1 — Build Path B subagent equivalents (~2-3h)

**Necessário:** `gemini-deep-research` e `perplexity-sonar-research` agents não existem (S262-A target). Sem eles, Path B não tem representação canônica.

### 1.1 `.claude/agents/gemini-deep-research.md`

Frontmatter:
```yaml
name: gemini-deep-research
description: "Perna 1 (broad orchestrator) via subagent. Wraps Gemini 3.1 Pro API call com same prompt convention que gemini-research.mjs. Cross-family vs Anthropic-trained agents."
tools: [Bash, Read]
model: sonnet
maxTurns: 5
timeout: 90s
```

Body:
- System prompt = current gemini-research.mjs prompt + output-schema suffix
- Bash invocation: `curl https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-pro-preview:generateContent` com config equivalente (temp 1, maxTokens 32768, thinkingBudget 16384, google_search tool)
- Output: text response + sources block (mesmo format que .mjs)
- Exit codes mapped to structured failure JSON

### 1.2 `.claude/agents/perplexity-sonar-research.md`

Frontmatter idem (model sonnet, tools Bash, timeout 150s).
Body wraps `perplexity-research.mjs` — same hardcoded SYSTEM_PROMPT (Tier 1 sources, table format, all PMIDs CANDIDATE), same temp 0.2, same `--domain-context` flag.

### 1.3 Smoke test cada agent — BLOCKED on daemon restart (KBP-38)

Agent tool registry só refresha com **daemon Ctrl+Q + reopen** (window restart insuficiente, KBP-38 / cc-gotchas.md §Agent tool registry refresh). Pos-restart:

```bash
# Verify new agents loaded
claude agents | grep -E "gemini-deep-research|perplexity-sonar-research"
```

Smoke test sequence (1 question each, "What is heterogeneity I² threshold for substantial?"):
1. Spawn `gemini-deep-research` via Agent tool. Verify: JSON output schema-valid, PMIDs spot-checked, timing ~30-90s, exit clean.
2. Spawn `perplexity-sonar-research`. Idem (timing ~60-150s).
3. Compare with .mjs equivalents (`node .claude/scripts/gemini-research.mjs "..."` + `node perplexity-research.mjs "..."`) for parity check.
4. Cost approximate: Gemini ~$0 (max plan free tier), Perplexity ~$0.20-0.50.

**S263 commit gate:** Phase 0+1.1+1.2 commitable agora (rules + agent specs). Smoke test (1.3) + bench (Phase 2-8) defer post-daemon-restart.

---

## Phase 2 — Path A run (script-orchestrated, ~30min wall-clock)

```bash
# Workspace
mkdir -p .claude/.parallel-runs/2026-04-27-ma-types/path-a/
cd .claude/.parallel-runs/2026-04-27-ma-types/path-a/
```

Invocar `/research` skill com argumentos:
```
/research s-ma-types --after s-rs-vs-ma --queries "Q1: design primário; Q2: IPD vs pooled; Q3: pairwise vs NMA"
```

Skill dispatches (Step 2 tabela):
- Perna 1: `node .claude/scripts/gemini-research.mjs` (3× — 1 per Q)
- Perna 5: `node .claude/scripts/perplexity-research.mjs` (3×)
- Perna 6: `nlm notebook query` (3×, se notebook mapeado)
- Perna 2: `evidence-researcher` Agent (slide novo, queries MCP)
- Perna 4: `reference-checker` Agent (skip — slide novo, sem evidence ainda)
- Perna 7: `codex-xhigh-researcher` Agent (3×, JSON schema-strict)

Capture per-perna:
- `path-a/perna1-gemini-q{1,2,3}.md` (stdout)
- `path-a/perna5-perplexity-q{1,2,3}.md`
- `path-a/perna6-nlm-q{1,2,3}.md` (se aplicável)
- `path-a/perna2-evidence-researcher.md` (subagent return)
- `path-a/perna7-codex-{q1,q2,q3}.json`
- `path-a/timing.txt` (wall-clock per perna + total)
- `path-a/cost-estimate.txt` (token counts onde disponível, USD onde calculável)

---

## Phase 3 — Path B run (agent-orchestrated, ~30min wall-clock)

Workspace `path-b/`. Same Q1-Q3.

Custom dispatch (orchestrator manual override do skill):
- Perna 1: Agent `gemini-deep-research` (3× via Agent tool, NOT Bash)
- Perna 5: Agent `perplexity-sonar-research` (3×)
- Perna 6: same Bash CLI (não migratable — OAuth interactive)
- Perna 2, 4, 7: same agents que Path A

Capture per-perna idem Phase 2 layout em `path-b/`.

**Important:** Path A and B run **sequentially**, não em paralelo (evita rate-limit + isola timing measurement).

---

## Phase 4 — Comparison TSV (~30min)

**Path:** `.claude/.parallel-runs/2026-04-27-ma-types/comparison.tsv`

**Columns:**

| Column | Path A measure | Path B measure |
|---|---|---|
| `path` | "A-script" | "B-agent" |
| `total_wallclock_s` | sum perna times | idem |
| `cost_usd_estimate` | API tokens × $rate | idem |
| `pmid_count` | unique PMIDs across pernas | idem |
| `pmid_fab_rate` | NCBI E-utils spot-check 5 random / N | idem |
| `coverage_q1_design` | 0-3 (uncovered/sparse/adequate/deep) | idem |
| `coverage_q2_ipd` | 0-3 | idem |
| `coverage_q3_nma` | 0-3 | idem |
| `schema_compliance_perna1` | n/a (markdown) | bool (if subagent outputs JSON) |
| `schema_compliance_perna5` | n/a | bool |
| `error_path_quality` | exit codes informative? structured stderr? | idem |
| `lucas_judgment_blind` | 1-5 (Lucas reads outputs label-hidden) | idem |
| `notes` | livre | livre |

**PMID spot-check method** (NCBI E-utils):
```bash
for pmid in $(shuf -n 5 pmids.txt); do
  curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=pubmed&id=${pmid}&retmode=json" | jq '.result["'$pmid'"].title // "FAB"'
done
```

---

## Phase 5 — Decision per S262 matrix (~15min)

Aplicar `S262-research-mjs-additive-migration.md:118-127` decision matrix com bench results:

| Outcome | Trigger | Action |
|---|---|---|
| **MERGE** (sunset .mjs) | Path B wins ≥4/6 metrics + Lucas judgment ≥4 | Mark `.mjs` deprecated em SKILL.md; mover para `_archived/` (6mo retention); subagents canonical |
| **KEEP-SEPARATE** | Diff strengths (e.g., scripts melhor hot-path, agents melhor cross-family) | SKILL.md document role differentiation; both dispatched conditionally por flag |
| **MERGE-BACK** | Path A wins claramente | Document subagent experiment como failed; archive `.claude/agents/_archived/`; `.mjs` stays canonical |

**Lucas-override rule** (KBP-39): se technical metrics suggest X mas Lucas explicit decision Y, document como `decision_override.md` com reasoning.

Decision documented em:
- `.claude/.parallel-runs/2026-04-27-ma-types/decision.md`
- HANDOFF S264 P0
- KBP-47 update se relevante

---

## Phase 6 — Living HTML construction (~90min)

**File:** `content/aulas/metanalise/evidence/s-ma-types.html`
**Reference template:** `content/aulas/metanalise/evidence/pre-reading-heterogeneidade.html`
**Schema:** Full pre-reading 6 sections (Lucas turn 3 Q4):

1. **`<header>`** — Title "Tipos de Meta-análise: taxonomia para leitura crítica" + meta + objetivos (3-4 bullets)
2. **`<section id="concepts">`** — 3 eixos definidos: design × dado × estrutura. Tabela 3 colunas com sub-types, premissas, ferramentas RoB. Formula div se aplicável (e.g., NMA transitivity assumption).
3. **`<section id="narrative">`** — Por que importa: residente encontra IPD/NMA crescente em literatura recente; saber identificar = leitura crítica.
4. **`<section id="core-path">`** — 5 artigos seminais (mistura: 1-2 RCT-MA pairwise, 1 IPD-MA exemplo, 1 NMA com CINeMA, 1 DTA-MA com QUADAS-2):
   - Cada `.core-step` div: bold author + PMID link + key-takeaway callout + 1-2 paragraphs explicação
5. **`<section id="glossary">`** — 7-8 termos: IPD, aggregate, pairwise, NMA, transitivity, consistency, indirect evidence, CINeMA, etc.
6. **`<section id="deep-dive">`** — 4 `<details>` accordions:
   - A) "Como CINeMA difere de GRADE para NMA"
   - B) "Quando IPD-MA muda conclusão vs aggregate"
   - C) "DTA-MA: bivariate vs HSROC"
   - D) "Network meta-regression: ajustando moderadores"
7. **`<details>` complementar** — tabela 6 papers extras (Cochrane methods chapters, GIN guidelines)
8. **`<footer>`** — autoria, disclaimer, verification date

**Inputs:** outputs do path vencedor (Phase 5). PMIDs verificados via NCBI cross-check antes de citar.

---

## Phase 7 — Slide build (~60min)

**File:** `content/aulas/metanalise/slides/06-ma-types.html`

Structure (per slide-rules.md):
```html
<section id="s-ma-types" data-timing="135">
  <div class="slide-inner">
    <h2>Antes de aceitar uma MA, identifique o tipo: design, dado e estrutura definem como ler.</h2>
    <div class="ma-types-grid">
      <div class="ma-axis ma-axis--design" data-reveal="1">
        <h3 class="axis-title">Design primário</h3>
        <!-- RCT × coorte × DTA, premissas, ferramentas -->
      </div>
      <div class="ma-axis ma-axis--data" data-reveal="2">
        <h3 class="axis-title">Nível do dado</h3>
        <!-- IPD × aggregate -->
      </div>
      <div class="ma-axis ma-axis--structure" data-reveal="3">
        <h3 class="axis-title">Estrutura</h3>
        <!-- pairwise × NMA -->
      </div>
    </div>
    <p class="source-tag">Cochrane Handbook 2024 · CINeMA framework · QUADAS-2</p>
  </div>
  <aside class="notes">
    [00:00] Contrato: residente vai topar IPD-MA e NMA na literatura recente — saber identificar é leitura crítica.
    [00:30] Eixo 1 design...
    [01:00] Eixo 2 dado...
    [01:30] Eixo 3 estrutura...
  </aside>
</section>
```

CSS scoped em `metanalise.css` — `section#s-ma-types .ma-types-grid` (3-col grid), tokens shared/css/base.css. Sem cores literais (KBP-43).

### 7.1 `_manifest.js` insert position 6

```js
{ id: 's-ma-types', file: '06-ma-types.html', phase: 'F2',
  headline: 'Antes de aceitar uma MA, identifique o tipo: design, dado e estrutura definem como ler.',
  timing: 135, clickReveals: 3, customAnim: 's-ma-types',
  narrativeRole: 'setup', tensionLevel: 1, narrativeCritical: false,
  evidence: 's-ma-types.html' },
```

### 7.2 `meta-narrativa.html:61` scope update

Atual: *"Não e: NMA, IPD, bayesiana, dose-response."*
Updated: *"Foco metodológico em pairwise RCT-MA. NMA, IPD, bayesiana, dose-response são apresentados como **taxonomia de orientação** (s-ma-types) mas methodology profunda fica fora; dose-response permanece out-of-scope."*

### 7.3 Build

```bash
npm run lint:slides           # Gate 2 SYNCED→LINT-PASS
npm run build:metanalise      # Gate 3 LINT-PASS→QA
```

---

## Phase 8 — QA pipeline (~60min)

Per `.claude/rules/qa-pipeline.md` Gate 4 (3-gate sequence com Lucas OK entre cada):

```bash
node scripts/gemini-qa3.mjs --aula metanalise --slide s-ma-types --preflight
# [Lucas OK]
node scripts/gemini-qa3.mjs --aula metanalise --slide s-ma-types --inspect
# [Lucas OK]
node scripts/gemini-qa3.mjs --aula metanalise --slide s-ma-types --editorial
# [Lucas OK = DONE]
```

**Anti-Sycophancy reminder (E069):** rubric ceiling = 6-8 medical GSAP. Score < 7 = checkpoint Lucas.

---

## Verification

End-to-end checks:

1. **Bench artifacts existem:**
   - `.claude/.parallel-runs/2026-04-27-ma-types/path-a/` populated com per-perna outputs
   - `path-b/` idem
   - `comparison.tsv` filled
   - `decision.md` written

2. **Subagents Phase 1 functional:**
   - `.claude/agents/gemini-deep-research.md` smoke-tested green
   - `.claude/agents/perplexity-sonar-research.md` idem

3. **Living HTML:**
   - `evidence/s-ma-types.html` opens no browser, 6 sections rendered
   - All PMIDs verified via NCBI (zero `[CANDIDATE]` no final HTML)
   - Tier 1 sources only

4. **Slide build:**
   - `npm run lint:slides` PASS
   - `npm run build:metanalise` PASS sem orphans
   - Slide aparece no deck position 6
   - Click-reveals 1-3 funcionam (data-reveal attrs)

5. **QA pipeline:**
   - Preflight dims OK (≥18px font, palette tokens, no `vw` font-size)
   - Inspect score ≥7
   - Editorial Lucas approved

6. **Rule registered:**
   - Grep `.claude/skills/research/SKILL.md` returns "ensemble obrigatório"
   - KBP-47 listed em `known-bad-patterns.md`

7. **Cross-ref propagation (per content/aulas/CLAUDE.md table):**
   - `_manifest.js` updated → `index.html` rebuilt
   - `evidence/meta-narrativa.html:61` reflects scope expansion
   - HANDOFF S264 atualizado

---

## Critical files to create/modify

### Create

- `.claude/agents/gemini-deep-research.md` (Phase 1.1)
- `.claude/agents/perplexity-sonar-research.md` (Phase 1.2)
- `.claude/.parallel-runs/2026-04-27-ma-types/{path-a,path-b}/*` (Phase 2-3)
- `.claude/.parallel-runs/2026-04-27-ma-types/comparison.tsv` (Phase 4)
- `.claude/.parallel-runs/2026-04-27-ma-types/decision.md` (Phase 5)
- `content/aulas/metanalise/evidence/s-ma-types.html` (Phase 6)
- `content/aulas/metanalise/slides/06-ma-types.html` (Phase 7)

### Modify

- `.claude/skills/research/SKILL.md` — §ENFORCEMENT add ensemble rule (Phase 0.1)
- `.claude/rules/known-bad-patterns.md` — KBP-47 entry (Phase 0.1)
- `content/aulas/metanalise/slides/_manifest.js` — insert position 6 (Phase 7.1)
- `content/aulas/metanalise/evidence/meta-narrativa.html` — line 61 scope update (Phase 7.2)
- `content/aulas/metanalise/index.html` — regenerated by `npm run build:metanalise` (Phase 7.3)
- `HANDOFF.md` — close debt + S264 carryover (final)
- `CHANGELOG.md` — S263 line (final)

---

## Estimate + scope split suggestion

**Total:** ~7-9h. Multi-session.

| Sessão | Phases | Tempo | Output |
|---|---|---|---|
| **S263 (today)** | 0, 1, 2, 3, 4, 5 | ~4-5h | Rule registered, subagents built+smoke, bench rodado, decision documented |
| **S264** | 6, 7, 8 | ~3-4h | Living HTML + slide + QA DONE |

Alternative: S263 só Phase 0 + 1 (rule + subagents), S264 bench, S265 slide. Mais conservador.

---

## Open questions / risks

1. **Codex CLI cost:** Path A roda Perna 7 1×, Path B roda 1× — total 2× per question × 3 questions = 6 codex calls × $0.05-0.20 = ~$0.30-1.20. OK.
2. **NLM Perna 6 OAuth:** se TTL (~20min) expirar mid-bench, Perna 6 cai em ambos paths. Acceptable degradation (não enviesa A vs B).
3. **MCP gaps Path B Perna 2:** crossref/semantic-scholar/biomcp não em `config/mcp/servers.json` global — declarados inline no agent frontmatter. First-spawn npx/uvx install pode adicionar latency ou silently fail. Mitigation: smoke test antes de bench commit.
4. **Subagent prompt fidelity (Phase 1):** se prompt no agent .md divergir de `.mjs` literal, bench compara two systems não strictly equivalent. Mitigation: copy-paste prompts, frontmatter spec idêntico onde possível.
5. **`pre-reading-heterogeneidade.html` schema é 6 sections, não 11:** SKILL.md ref desatualizada (Phase 1 finding). Living HTML Phase 6 segue 6-section real, não 11 mítico. SKILL.md cleanup deferred (S265+).

---

## References

- S262 plan: `.claude/plans/S262-research-mjs-additive-migration.md`
- S261 plan: `.claude/plans/concurrent-nibbling-teacup.md`
- `/research` skill: `.claude/skills/research/SKILL.md`
- Living HTML benchmark: `content/aulas/metanalise/evidence/pre-reading-heterogeneidade.html`
- Decision matrix anchor: KBP-39 + audit-merge-S251 methodology
- Lucas turn 3 S263: ensemble rule directive ("não existe rodar pernas isoladas")
- KBP-31 violation closing: rule formerly candidate sem commit, agora formalized

---

## Coautoria

`Coautoria: Lucas + Claude Code (Opus 4.7) | S263`
