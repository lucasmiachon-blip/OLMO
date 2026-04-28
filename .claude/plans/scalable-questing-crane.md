# Plan — S274 tipos-ma-7pernas

## Context

### Por que esta sessão
Lucas pediu re-rodar pipeline `/research` 7 pernas no tópico **Tipos de Meta-Análise** usando o evidence existente como base. Dois objetivos paralelos:
1. **Construir HTML mais completo** para o slide futuro `s-tipos-ma` (decisão de criação = Phase 7, fora do execution)
2. **Bench live dos agents/scripts** — observar erros, divergências, falhas para ajustar SKILL.md / agents .md ("sem inércia, depois o foco é construir o html para depois o slide" — Lucas turn 2)

### Estado atual (mapeado, não fabricar)
- **Evidence existente:** `content/aulas/metanalise/evidence/s-tipos-ma.html` (524 li, S187 com 4 pernas: Gemini API + NLM + evidence-researcher + orchestrador NCBI). 16 PMIDs verificados via PubMed. Taxonomia 5 tipos centrais (Pairwise/NMA/IPD/DTA/Prevalence) + 4 especializados (Dose-response/Bayesian/Living/Umbrella) + 3 abordagens transversais. Glossário, exemplos, deep-dive (5 details), refs completas, convergence 3/3.
- **Pernas faltantes em S187:** Perplexity Sonar (recusou — "tabela genérica") + Codex xhigh (não existia em S187).
- **Pre-flight S274 confirmado:** Gemini ✓, Perplexity ✓, Codex 0.125.0 ✓, NLM CLI ✓.
- **Manifest atual:** 17 slides, **NÃO** inclui `s-tipos-ma`. Slide é decisão Lucas pós-bench.
- **D-lite Lane B (S269):** estado experimental — bench oportunidade para Gemini quota teste.
- **MD com info inicial:** assumindo Lucas referiu-se ao próprio HTML existente (524 li); confirmar no Phase 0 se não.

### Outcome esperado
- HTML s-tipos-ma.html refresh com pipeline 7-pernas (footer S187→S274, convergence table 3/3→7/7)
- Capture report transparente sobre falhas/divergências cross-perna
- Decisão informada D-lite vs hot path (Lane B input)
- Aprendizados consolidados em SKILL.md / agents .md SE evidence supports change

---

## Phase 0 — Setup

- 0.1. `echo -n "tipos-ma-7pernas-S274" > .claude/.session-name`
- 0.2. TaskCreate batch (7 phases tracking, conforme anti-drift §Plan execution)
- 0.3. Confirmar com Lucas se "md com info inicial" = HTML existente OU outro arquivo não localizado
- 0.4. Lucas roda `! nlm login` (interativo, sessão ~20min; necessário Perna 6)
- 0.5. Worker mode check (`test -f .claude/.worker-mode`)

## Phase 1 — Diagnostic

- 1.1. Cross-ref s-tipos-ma.html (já lido, 524 li) contra SKILL §3b 11 seções + benchmark `pre-reading-heterogeneidade.html`
- 1.2. **Gap list explícita** (informa prompts):
  - Component NMA real-world example (mencionado, sem caso concreto)
  - Dose-response J-shape com números (alcohol-cirrhosis dose specifics)
  - Bayesian priors selection práticos (vague/informative/skeptical comparison)
  - Living SR alpha-spending mecânica (REACT WHO concrete)
  - Wang 2021 IPD recovery bias detalhes (39% < 90% data point)
  - Updates >2024 (DTA splines? NMA SUCRA críticas pós-2022?)
- 1.3. Output: gap list curta como input dos prompts Phase 2

## Phase 2 — Dispatch 7 pernas (1 mensagem, paralelo)

**Prompt master Open+Closed (SKILL §I/O P145):**

```
OPEN: "What's the SOTA on types of meta-analysis (focus 2022-2026)?
Cover NMA transitivity verification methods, IPD-MA recovery bias (Wang 2021 BMJ),
DTA-MA bivariate vs HSROC choice, prevalence MA prediction intervals
(Migliavaca 2022), dose-response splines (Greenland-Longnecker 1992 + RCS),
bayesian priors selection rationale, living SR alpha-spending mechanics,
umbrella overlap matrices (CCA). What changed since 2022?
Provide quantitative examples where possible."

CLOSED: schema suffix SKILL §Output Schema Suffix (markdown table com PMID/DOI/PICO/efeito)
```

**Dispatch (1 mensagem, todos paralelos):**

| # | Perna | Execution |
|---|-------|-----------|
| 2.1 | Perna 1 — Gemini.mjs | `node .claude/scripts/gemini-research.mjs "<prompt>"` (Bash) |
| 2.2 | Perna 5 — Perplexity.mjs | `node .claude/scripts/perplexity-research.mjs "<prompt>"` (Bash) |
| 2.3 | Perna 6 — NLM | `nlm notebook query a274cffb-8f41-4015-8b9b-abf81c6b260a "<query>" --json` (Bash) |
| 2.4 | D-lite Gemini | Agent `gemini-dlite-research` (candidate-first capture) |
| 2.5 | D-lite Perplexity | Agent `perplexity-dlite-research` (candidate-first capture) |

**SKIP justificado (Lucas turn 4):**
- **Perna 2 (evidence-researcher):** Sonnet model "sem sentido" → verificação PMID via PubMed MCP **direto no orchestrator** Phase 4.4 (não via subagent)
- **Perna 7 (codex-xhigh-researcher):** "não é para gerar custo" → cross-family validation perdida; mitigation = spot-check Tier 1 manual
- **Pernas 3 (mbe-evaluator) + 4 (reference-checker):** exigem slide HTML existente; tipos-ma só tem evidence

KBP-47 deviation: subset autorizado por Lucas (cost gate). Documentado para audit trail.

## Phase 3 — Validação pós-retorno (SKILL §Step 2.5)

- Schema check por perna:
  - Pernas 1/5/6: markdown table com `|` em ≥3 linhas + PMID/DOI presente + <5000 chars + finishReason ≠ MAX_TOKENS
  - D-lite 2.4/2.5: candidate-first JSON (research-dlite-runner schema)
- Coverage check vs gap list Phase 1
- **D-lite bench live (Lane B re-bench):**
  - Emit rate (target 6/6 questions, mas estamos em single question — adaptar)
  - JSON validity (target 6/6)
  - PMID fabrication % (target ≤10%)
  - Cost/question (target ≤$0.30 — KBP-48 thresholds)
- Gates: ≥2 falhas → STOP; perna parcial → flag, não auto-prosseguir

## Phase 4 — Síntese cruzada (SKILL §Step 3)

- 4.1. Síntese narrativa 5-10 li (prosa "para o professor", não tabular)
- 4.2. Tabela cross-perna achados (nova convergence matrix 7-fonte)
- 4.3. Resolução conflitos via hierarquia §3c (Cochrane Handbook v6.5 > MAs metodológicas verificadas > web search > opinion). Registrar regra usada inline
- 4.4. **Spot-check PMIDs CANDIDATE via PubMed MCP** (KBP-32 + KBP-36): 3-5 PMIDs random de Gemini.mjs/Perplexity.mjs/D-lite Gemini/D-lite Perplexity diretamente via MCP no orchestrator (substitui evidence-researcher subagent)

## Phase 5 — Update evidence/s-tipos-ma.html

**Tier-S Edit** (governing aula doc per slide-rules.md). EC loop visível antes de cada Edit:

- Read full HTML (já feito Phase 0 — preserva estado)
- Updates pretendidos:
  - Header: pipeline S187 4-pernas → S274 7-pernas + data abril 2026
  - `<details>` convergence: 3/3 matrix → 7-perna matrix
  - Adicionar novas refs verificadas SE descobertas (footer count atualizado)
  - Preencher gaps Phase 1 SE ≥2 pernas convergem com fonte verificável
- **NÃO** auto-rewrite seções existentes que pernas novas contradizem — flag para Lucas decidir (preserva 16 PMIDs S187 já verificados)

## Phase 6 — Capture aprendizados pipeline (Tier-S meta-edit)

- Bench results: D-lite vs .mjs (cost/recall/novelty/fab%) — input Lane B decisão
- Análise de pernas que falharam (auth? quota? schema? prompt design?)
- Update SKILL.md ou agents .md **SE** evidence supports change (separate Edit, novo EC loop, KBP-34 ler governing docs antes)
- KBP candidate se padrão recorrente (commit em known-bad-patterns.md antes session close — KBP-31)
- HANDOFF.md entry S274 (cap ≤60 li)
- CHANGELOG.md append S274 (≤5 li/session)

## Phase 7 — Decisão de slide (FORA do execution)

Apresentar dados ao Lucas. Decisão dele:
- Criar slide novo `s-tipos-ma` (posição F2 — onde?)
- Manter evidence-only como pre-reading material
- Adiar pós-aula

**Phase 7 requer aprovação separada — NÃO incluído neste execution.**

---

## Verification

**Phase 2 dispatch:**
- Cada perna retorna output não-vazio (text OR JSON parseável)
- Schema check passa por perna (variant da SKILL §Step 2.5)
- Coverage: cada gap Phase 1 abordado por ≥1 perna

**Phase 3 D-lite bench:**
- 6/6 emit (single question — adaptar a 1/1)
- JSON validity ✓ via `node .claude/scripts/research-dlite-runner.mjs --validate-file`
- Cost ≤$0.30 reportado

**Phase 5 HTML update:**
- `git diff content/aulas/metanalise/evidence/s-tipos-ma.html` mostra apenas seções alvo
- HTML válido (open `<html>` → close `</html>`)
- 16 PMIDs S187 preservados (não-quebra de refs verificadas)
- Browser render OK (open file:// local)

**Phase 6 docs:**
- HANDOFF S274 entry visível com lane pointers
- CHANGELOG S274 append-only com 1 line/change
- Se SKILL/agent edit: rationale evidence-citado (Tier-S Edit, EC loop separado)

---

## Critical files

| Path | Role | Phase |
|------|------|-------|
| `.claude/skills/research/SKILL.md` | Pipeline definition | Reference (potencial Phase 6 edit) |
| `.claude/scripts/gemini-research.mjs` | Perna 1 hot path | Phase 2.1 |
| `.claude/scripts/perplexity-research.mjs` | Perna 5 hot path | Phase 2.2 |
| `.claude/scripts/research-dlite-runner.mjs` | D-lite runner | Phase 2.6/2.7 + Phase 3 validation |
| `.claude/agents/codex-xhigh-researcher.md` | Perna 7 cross-family | Phase 2.4 |
| `.claude/agents/evidence-researcher.md` | Perna 2 MCPs | Phase 2.5 |
| `.claude/agents/{gemini,perplexity}-dlite-research.md` | D-lite paralelos | Phase 2.6/2.7 |
| `content/aulas/metanalise/evidence/s-tipos-ma.html` | Alvo update | Phase 5 |
| `content/aulas/metanalise/HANDOFF.md` | Lane A state | Phase 6 |
| `HANDOFF.md` (raiz) | Roadmap | Phase 6 |
| `CHANGELOG.md` | Append-only | Phase 6 |
| `.claude/.session-name` | Statusline | Phase 0 |

---

## Out of scope (explicit)

- **Slide creation** `s-tipos-ma` (Phase 7 = decisão pós-bench, requer aprovação separada)
- **QA preflight** forest1/forest2 (HANDOFF defer S273+)
- **D-lite full migration** (Lane B residual — este bench INFORMA decisão, não executa)
- **Pending fixes** session anterior (_manifest.js sync, index.html rebuild) — separados, não bloqueiam research
- **mbe-evaluator + reference-checker** (Pernas 3/4) — precisam slide existente
- **Outros slides** QA pendentes (s-objetivos, s-rs-vs-ma, s-pico) — fora do escopo desta sessão

---

## Pre-mortem (Gary Klein)

1. **NLM auth expira mid-research** → Mitigation: Lucas confirma `! nlm login` Phase 0; se expirar Phase 2, degradar 6 pernas; reportar transparente
2. **Gemini API 429 (cota)** → HANDOFF mencionou issue Lane B. Mitigation: graceful degrade, continuar com pernas restantes; flag para next session
3. **D-lite candidates verbose / signal-to-noise pior** → Mitigation: comparar quantitativamente Phase 3 (recall vs novelty vs fab%)
4. **PMID fabrication >10% (Codex/Perplexity tradicional)** → Mitigation: KBP-32 spot-check 3-5 PMIDs random Phase 4.4 antes de merge HTML
5. **Evidence atual contradito por novas pernas em achado central** → Mitigation: NÃO auto-rewrite, flag para Lucas; preserve S187 conteúdo onde não há consenso
6. **Codex CLI auth pendente** → pre-flight passou (0.125.0), mas dispatch pode falhar se auth expirou; reportar e pular Perna 7
7. **APL HIGH custo (586 calls)** → Mitigation: dispatch paralelo 1 mensagem, NÃO sequencial; subagents trazem retorno compacto vs raw output

## Stop-loss

- ≥2 pernas falham Phase 2 → STOP, NÃO sintetizar; reportar
- PMID fab >10% Phase 4.4 → STOP merge HTML; retornar ao Lucas
- Contradição grave 7 pernas em achado central → STOP, escalar
- D-lite bench falha 0/2 emit → preservar hot path; reportar Lane B
- Custo total >$3.00 → flag, pausar antes de continuar

---

## Estimated cost

| Item | Cost |
|------|------|
| Gemini.mjs (Perna 1) | ~$0.05 |
| Perplexity.mjs (Perna 5) | ~$0.80 |
| Codex xhigh (Perna 7) | ~$0.30 |
| D-lite Gemini (2.6) | ~$0.05 |
| D-lite Perplexity (2.7) | ~$0.80 |
| NLM (Perna 6) | gratuito |
| evidence-researcher (Perna 2, Sonnet via MCP) | ~$0.10 |
| **Total** | **~$2.10** |

---

---

## EXECUTION OUTCOME (S274 close)

### Wins
- **HTML criado:** `content/aulas/metanalise/evidence/pre-reading-tipos-ma.html` (~600 li, formato canonical pre-reading-* style, 30+ PMIDs verified, badges V/C convention aplicada).
- **3/7 pernas emit success:**
  - NLM (44.7KB rich content, 9 tipos cobertos com premissa/landmark/gotcha)
  - Codex effort=medium (9 findings JSON, 36 PMIDs verified, JSON salvo em `.claude/.research-tmp/codex-R-tipos-ma-S274.json`)
  - Evidence-Researcher Opus async (16/16 PMIDs S187 verified via WebFetch fallback + 9 novas refs 2024-2026)
- **9 novas refs descobertas (2024-2026):** Veroniki PRISMA-NMA 2025 (PMID 40976519), Mazzinari Bayesian IPD-MA 2025 (PMID 39042027), Ying wCCA 2025 (PMID 41626914), Nevill 168 LSRs (PMID 40712752), Butler LSR cost (PMID 38043829), Iannizzi LSR guidance (PMID 38098023), Crippa one-stage 2019 (PMID 29742975), Crippa continuous 2016 (PMID 27485429), Kirvalidze CCA pairwise 2023 (PMID 37501239).
- **Cost-conscious overrides:** Codex effort=medium (vs xhigh padrão) reduziu custo significativamente; Evidence-Researcher Opus model override (Max plan = $0).
- **Resilience:** Evidence-Researcher Opus usou WebFetch fallback quando PubMed MCP esteve DOWN (HTTP 400 all endpoints) — não bloqueou.
- **Não-destrutivo:** s-tipos-ma.html S187 (524 li, 16 PMIDs verified) preservado intacto. Lucas decide later: keep both, merge, ou substitute.
- **Convenção V/C aplicada** após correção Lucas (PMID não no texto, só link "PubMed" + badge azul V / vermelho C).

### Failures (root causes confirmados, evidence-based)
- **Gemini.mjs:60 timeout 60s insuficiente** — curl test mediu 91s real para payload equivalente (thinking 16384 + grounding + maxTokens 32768). Pre-S261 sem AbortSignal funcionava. **Fix:** voltar atrás (remover linha 60) OU aumentar para 300s+.
- **Perplexity.mjs:77 timeout 120s NÃO é root cause** — Cloudflare drops idle connections at exactly 60s server-side (confirmado via WebSearch Perplexity community forums). Solução real = `stream: true` SSE (refactor não-trivial).
- **D-lite Gemini 400 INVALID_ARGUMENT** — root cause NÃO identificado. NÃO é o combo `tools[google_search]+responseJsonSchema` (Gemini 3 docs + curl test 200 OK confirmam compat). Failure JSON salvo em `.claude/.research-tmp/gemini-dlite-R-tipos-ma-S274.failure.json`. Investigation pendente próxima sessão dedicada.
- **PubMed MCP HTTP 400 all endpoints** — issue do MCP server `@cyanheads/pubmed-mcp-server`. Não bloqueou: Evidence-Researcher Opus usou WebFetch fallback resilientemente.

### KBP-54 candidate (KBP-31 — registrar antes session close)
**"API timeouts hardcoded decay sem gate periódico"**
- Evidence: S264 9/9 emit (HANDOFF) → S274 3/7 emit em 4 meses (sem CI bench detect regression silently)
- Pointer: `.claude/rules/known-bad-patterns.md` + sugestão `/loop` mensal bench API latency

### KBP-36 self-corrections (Lucas reforçou: "evidência quando dúvida pesquise sempre")
Tive que corrigir 2 inferências sem evidência:
1. ❌ "Modelo `gemini-3.1-pro-preview` deprecated" — ERRADO. Modelo existe; cortei output da listagem em 100 linhas (modelo aparecia depois).
2. ❌ "responseJsonSchema + google_search incompat → causa do D-lite 400" — ERRADO. Gemini 3 docs explicitamente suporta combo; curl test passou 200 OK.

Aprendizado: WebSearch/curl test ANTES de afirmar root cause. Especialmente em domínio fast-moving ("todo dia há coisas novas" — Lucas).

---

## Phase 6 — Detailed Plan (executar antes de session close)

### 6.1 Documentation updates

| File | Change | Tier |
|---|---|---|
| `HANDOFF.md` (raiz) | S274 entry + atualizar Lane A pointer (pre-reading-tipos-ma.html criado) + adicionar Lane C residual (Gemini.mjs revert TODO + D-lite 400 investigation TODO + PubMed MCP HTTP 400 TODO) | Tier-S (governing doc) |
| `content/aulas/metanalise/HANDOFF.md` | Atualizar §Estado: novo evidence file existe; s-tipos-ma slide ainda não criado (Phase 7 next session); preserva s-tipos-ma.html S187 | Tier-M |
| `CHANGELOG.md` | S274 append-only ≤5 li (pipeline 7-pernas 3/7 emit + HTML criado + KBP-54 candidate) | Tier-S |
| `.claude/rules/known-bad-patterns.md` | KBP-54 entry pointer (~3 li per format) | Tier-S |

### 6.2 Commit (cirúrgico, NUNCA `-A`)

`git add`:
- `content/aulas/metanalise/evidence/pre-reading-tipos-ma.html` (novo)
- `.claude/.research-tmp/codex-R-tipos-ma-S274.json` (research artifact verified)
- `.claude/.research-tmp/gemini-dlite-R-tipos-ma-S274.failure.json` (debug evidence)
- `.claude/.research-tmp/perplexity-dlite-R-tipos-ma-S274.failure.json` (debug evidence)
- `.claude/.session-name` (modified)
- `HANDOFF.md` (raiz)
- `content/aulas/metanalise/HANDOFF.md`
- `CHANGELOG.md`
- `.claude/rules/known-bad-patterns.md`
- `.claude/plans/scalable-questing-crane.md` (este plan file, final state)

**Skip:** `.claude/stop1-telemetry.jsonl` (já modified pre-existente, NÃO tocar — telemetria runtime).

**Commit message (HEREDOC):**
```
feat(metanalise/S274): evidence HTML tipos-ma — 7-pernas pipeline (3/7 emit)

- pre-reading-tipos-ma.html criado (~600 li, formato canonical) cobrindo 9 tipos de MA
- 30+ PMIDs verified (Codex effort=medium spot-check NCBI + Evidence-Researcher Opus WebFetch fallback)
- 9 novas refs 2024-2026 (Veroniki PRISMA-NMA, Mazzinari Bayesian IPD, Ying wCCA, Nevill 168 LSRs, etc)
- Pipeline failures registered: Gemini.mjs timeout 60s vs ~91s real, Perplexity Cloudflare 60s idle drop, D-lite 400 root cause pendente
- KBP-54 candidate: API timeouts hardcoded decay sem gate periódico

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
```

### 6.3 Push
- `git push origin main` (sem force, sem skip hooks)

---

## Phase 7 — Next Session Handoff (após /clear)

**Foco:** Criar slide `s-tipos-ma` baseado no pre-reading HTML.

**Inputs disponíveis:**
- Source: `content/aulas/metanalise/evidence/pre-reading-tipos-ma.html` (S274)
- Wiki backup: `content/aulas/metanalise/evidence/s-tipos-ma.html` (S187, 524 li)

**Decisões pendentes Lucas (turn inicial):**
1. **Posição no deck:** F2 — após qual slide? Sugestão: após `s-rs-vs-ma` (introduz família antes de pairwise/forest)
2. **Filename:** `slides/NNa-tipos-ma.html` (NN dependente da posição)
3. **clickReveals:** 0 (auto-only contemplativo) OU 3 (matching trilha 3 grupos)?
4. **customAnim:** criar `s-tipos-ma` em `slide-registry.js` ou reutilizar pattern existente?
5. **Evidence link no manifest:** `evidence: 'pre-reading-tipos-ma.html'` (S274 novo) OU `s-tipos-ma.html` (S187 wiki)?

**Workflow:**
1. Decisões 1-5 com Lucas
2. Criar `slides/NNa-tipos-ma.html` (deck format ≠ pre-reading format — slide é compressão pedagógica)
3. Adicionar entry em `_manifest.js`
4. `npm --prefix content/aulas run build:metanalise` (gera index.html)
5. `npm --prefix content/aulas run lint:slides` (PASS antes de QA)
6. QA preflight: `node content/aulas/scripts/gemini-qa3.mjs --aula metanalise --slide s-tipos-ma --inspect`
7. Lucas OK → editorial → DONE

---

## Out of scope (defer)

- **Gemini.mjs timeout fix (single-line revert)** — Lucas pediu "voltar atrás", evidence supports. Pode acompanhar Phase 6 commit SE Lucas autorizar agora, OR defer próxima sessão de infra-fixes.
- **Perplexity.mjs stream:true refactor** — sessão dedicada (não-trivial, refactor SSE parser).
- **D-lite Gemini 400 root cause investigation** — sessão dedicada de debug.
- **PubMed MCP HTTP 400 troubleshooting** — infra externa, fora do escopo aula.
- **s-tipos-ma slide creation** — Phase 7 explicitly defer to next session post-/clear.
- **Lane B D-lite re-bench full migration** — informado pelos resultados S274 (D-lite 400 + Cloudflare). Decisão off-thread Lucas.

---

## Coautoria
Plan: Lucas (decisão clínica + escopo + correções KBP-36) · Opus 4.7 (orquestração + estrutura + execução).
