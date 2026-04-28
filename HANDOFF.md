# HANDOFF - Proxima sessao (S275)

> Reidrate por este arquivo primeiro. Nao leia `CHANGELOG.md` nem planos longos no inicio; use grep/range so quando a lane for escolhida.

## 0. Estado para reidratar em 90s

1. Rode `git status --short`.
2. Leia `.claude/context-essentials.md`.
3. **PRÓXIMA SESSÃO = SLIDE BUILD + AJUSTE DE PROBLEMAS** (Lucas turn 16). Lane A primeiro (slide), depois Lane C (infra fixes).
4. Abra `.claude/plans/scalable-questing-crane.md §Phase 7` (handoff explícito) + plano da lane escolhida.

**S274 closed** — `pre-reading-tipos-ma.html` criado (~600 li, 9 tipos MA, 30+ PMIDs verified com convenção V/C badges) via pipeline 7-pernas (3/7 emit: NLM + Codex effort=medium + Evidence-Researcher Opus). Failures registrados com root causes evidence-based: Gemini.mjs timeout 60s vs ~91s real, Perplexity Cloudflare 60s idle drop server-side (NÃO timeout script), D-lite Gemini 400 INVALID_ARGUMENT (root cause pendente), PubMed MCP HTTP 400 all endpoints. Plan: `.claude/plans/scalable-questing-crane.md` (Execution Outcome + Phase 7 handoff). **S273 closed** (overlays forest1/2 removidos): `CHANGELOG.md §S273`. **S272 closed** (audit + 6 fix): `CHANGELOG.md §S272`.

## ⭐ PRÓXIMA SESSÃO — DUAS TAREFAS EXPLÍCITAS (S275)

### Tarefa 1 — SLIDE BUILD `s-tipos-ma` (Lane A — prioridade)
**Inputs prontos:**
- Source HTML: `content/aulas/metanalise/evidence/pre-reading-tipos-ma.html` (S274 novo, formato pre-reading)
- Wiki backup: `content/aulas/metanalise/evidence/s-tipos-ma.html` (S187, 524 li, 16 PMIDs verified)
- Codex JSON: `.claude/.research-tmp/codex-R-tipos-ma-S274.json` (9 findings, 36 PMIDs)

**5 decisões Lucas (turn 1 da próxima sessão):**
1. Posição no deck F2 — após qual slide? Sugestão: após `s-rs-vs-ma` (introduz família antes de pairwise/forest)
2. Filename: `slides/NNa-tipos-ma.html` (NN dependente da posição)
3. clickReveals: 0 (auto-only contemplativo) OU 3 (matching trilha 3 grupos: comuns/especializados/abordagens)?
4. customAnim: criar `s-tipos-ma` em `slide-registry.js` ou reutilizar pattern existente?
5. Evidence link manifest: `evidence: 'pre-reading-tipos-ma.html'` (S274) OU `s-tipos-ma.html` (S187 wiki)?

**Workflow:** Decisões → criar slide HTML (deck format ≠ pre-reading) → `_manifest.js` entry → `npm --prefix content/aulas run build:metanalise` → lint:slides → `gemini-qa3.mjs --inspect` → Lucas OK → editorial → DONE.

### Tarefa 2 — AJUSTE DE PROBLEMAS (Lane C — infra)
**Pendentes evidence-based, root causes confirmados:**
- **Gemini.mjs:60** revert `AbortSignal.timeout(60_000)` → remover (pre-S261 funcionava). Lucas autorizou "voltar atrás" turn 12. Tier-S Edit single-line.
- **Perplexity.mjs:77** Cloudflare 60s idle drop = solução real `stream: true` SSE refactor (não-trivial). Decisão Lucas: refactor agora OR defer sessão dedicada?
- **D-lite Gemini 400 INVALID_ARGUMENT** — root cause NÃO identificado. Failure JSON em `.claude/.research-tmp/gemini-dlite-R-tipos-ma-S274.failure.json`. Investigar payload exato vs curl baseline.
- **PubMed MCP HTTP 400 all endpoints** — issue server `@cyanheads/pubmed-mcp-server`. Evidence-Researcher Opus usou WebFetch fallback OK; investigar se MCP voltou OU manter fallback como pattern.

## 1. Lane A - Metanalise (slide build + QA)

Triggers: "slides", "metanalise", "forest", "quality", "QA", "tipos-ma". Fonte: `content/aulas/metanalise/HANDOFF.md`. Plano S274: `.claude/plans/scalable-questing-crane.md §Phase 7`.
Estado: `s-quality` DONE; `s-forest1/s-forest2` overlays removidos S273 (LINT-PASS, QA pendente). **S274:** evidence `pre-reading-tipos-ma.html` criado (slide pendente). **PRÓXIMA Lane A: criar slide `s-tipos-ma`** (5 decisões Lucas — ver §0 ⭐ Tarefa 1). Regra: 1 slide × 1 gate × 1 invocação.
Build/QA: `npm --prefix content/aulas run build:metanalise && node content/aulas/scripts/gemini-qa3.mjs --aula metanalise --slide {id} --inspect`.

## 2. Lane B - Research D-lite

Triggers: "research", "pernas", "D-lite", "agents vs scripts", "migrar .mjs". Reidratação: `docs/research/S269-dlite-rehydration.md` (open-gaps incluem Gemini 429, Opus triage, DOI verifier, cost matrix). Plano: `.claude/plans/sleepy-wandering-firefly.md` (apenas §S264.c + §S265 carryover).
Estado: KEEP-SEPARATE provisional; `.mjs` Gemini/Perplexity = hot path canônico; `codex-xhigh-researcher` thin-agent canônico Codex; D-lite agents/runner paralelos experimentais.
Gate: `node scripts/smoke/research-dlite-contract.mjs`.

## 3. Lane C - Infra / auditoria

Triggers: "auditoria", "hardening", "gate", "harness", "seguranca", "integrity". Audit S272 fechado: `.claude/plans/purring-purring-bubble.md` (14 findings: 6 closed mecanicamente + 8 deferred com gate). Audits prévios: S267 (`docs/audit/codex-adversarial-audit-S267.md`), S270 (`.claude/plans/archive/S270-audit-adversarial-15-findings.md`).
Estado: S272 fechou A1+A2+A3+A4+M1+M6 (Wave 1-6). INV-4 v2 valida hook breakdown FS↔docs; M6 telemetry proxy ativa (.claude/stop1-telemetry.jsonl). Defer S273+: M2 (gate ≥3 sessions M6 data), M3/M4/M5/B1/B2/B3/B4 (decisão Lucas off-thread).

## 4. Roadmap constante

Now:
- `[S275 PRIORITY metanalise]` Slide build `s-tipos-ma` — ver §0 ⭐ Tarefa 1. Inputs: `pre-reading-tipos-ma.html` + Codex JSON. Plano: `.claude/plans/scalable-questing-crane.md §Phase 7`.
- `[S275 infra residual]` Ver §0 ⭐ Tarefa 2 — Gemini.mjs revert (Lucas autorizou) + Perplexity stream:true (decisão) + D-lite 400 (investigar) + PubMed MCP (esperar/fallback).
- `[S273 done metanalise]` overlays s-forest1/2 removidos; QA preflight pendente.
- `[S269 P0 D-lite]` `docs/research/sota-S269-agents-subagents-contract.md` + `.claude/scripts/research-dlite-runner.mjs` - local smoke PASS; S274 D-lite live failed (400+Cloudflare); decisão re-bench post-fixes.
- `[P1 BACKGROUND]` `.claude/plans/immutable-gliding-galaxy.md` - referencia, nao abrir no start.
- `[S275+ soak test]` Stop[1] hook + M6 telemetry: tier-S Pre-mortem detection + scope-extension `[budget]`.
- `[S275-280 catalog review]` `.claude/CATALOG.md` 6 `candidate-delete` skills decisão 1-a-1; bulk delete proibido.
- `[S275+ audit S272 deferred]` 8 findings (M3/M4/M5/B1/B2/B3/B4 + M2 regex). Plano archived.

Next:
- Lane B: quando Gemini quota voltar, rodar re-bench cost-gated Gemini/Perplexity/Codex em >=6 emits; comparar contra `.mjs`; promover D-lite so se thresholds do contrato passarem.
- Infra Lane C residual: M1 pytest nominal; opcional instalar hook local `pre-push`.

Later:
- Phases 6-8 master plan apos D-lite decision lock.
- Archived S268: `concurrent-nibbling-teacup.md`, `wobbly-foraging-pelican.md`, `S262-research-mjs-additive-migration.md`, `splendid-munching-swing.md`.

## 5. Regras de contexto

- `HANDOFF.md` + `.claude/context-essentials.md` sao suficientes para start.
- `CHANGELOG.md` e planos longos entram apenas por `rg -n "termo" arquivo`.
- Antes de editar state files: `git status --short`; se houver mudanca alheia, trabalhar com ela, nao reverter.
- Codex/Gemini default read-only no AGENTS; editar apenas quando Lucas aprovar escopo no thread atual.
