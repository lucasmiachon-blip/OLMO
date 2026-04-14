# HANDOFF - Proxima Sessao

> Sessao 191 | s-quality + s-etd

## ESTADO ATUAL

Monorepo funcional. CI verde. Build PASS (**17 slides** metanalise, build via Node.js).
**Agentes: 10.** **Hooks: 38.** **Rules: 11.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 18.** **Skills: 22 project + 3 user.** **Memory: 20/20.** **Backlog: 28 items.**

## P0 — evidence/s-tipos-ma.html (S187 — ENRICHED, BENCHMARK CSS)

- **16 refs VERIFIED + 1 book** (Cochrane Handbook v6.5). ~480 linhas. Benchmark CSS (pre-reading-heterogeneidade.html).
- **3-layer content:** conceitos-chave (initial) → taxonomia + exemplos (intermediate) → 5 deep-dive accordions (advanced/Lucas).
- **Enrichment fixes:** Welton 2009 DOI/journal corrigidos (era Stat Med → Am J Epidemiol), Wang 2021 "64%" → abstract-verified "39%", AllTrials claim genericizado.
- **Pendente:** (1) Lucas decide quantos slides e posicao no manifest; (2) h2 = Lucas; (3) nenhum slide criado ainda.

## P0 — s-quality (DONE S191) + s-etd (DONE S191)

- **s-quality:** 1 slide, 3 click-reveals (F2). 3 níveis de "qualidade" em MA. Adversarial review Gemini+Codex. Evidence: `evidence/s-quality-grade-rob.html`.
- **s-etd:** 1 slide, 3 click-reveals (F3). Valgimigli 2025 EtD: 4 endpoints /1.000 PA, badges (Moderado/Importante/NS), NNT caveat. CSS Grid `auto`, color-mix badges, MutationObserver dark-bg. Multi-model data: Gemini+GPT full paper.
- **s-ancora:** REMOVIDO S191. Replaced by s-etd. Dead CSS cleaned (−43 lines).
- **s-takehome:** REESCRITO S191. 3 mensagens concisas, aside.notes removido.
- **s-title:** Co-autor Samoel Masao adicionado S191.

## P0 — s-heterogeneity (DONE S188) + s-fixed-random (DONE S188 — polish pendente)

- **s-heterogeneity:** DONE. SVG forest plots, 3 clicks, QA fino (hierarchy+legibility PASS). System tokens only.
- **s-i2:** ABSORBED into s-heterogeneity (S188). HTML em slides/09b-i2.html fora do build.
- **s-fixed-random:** DONE (rewrite S188). SVG forest plots side-by-side (FE vs RE, mesmos dados). 3 clicks. System tokens only. CSS 185→67 linhas, 5→0 tokens privados. DSL/REML/HKSJ removidos. h2 = Lucas ("Mesmos dados, conclusoes diferentes").
- **Evidence intacto:** `evidence/s-heterogeneity.html` — 17 refs (12 PMID-VERIFIED).
- **Pendente:** (1) polish visual fino amanha; (2) verificar 2 DOIs pendentes (Higgins 2025, Siemens 2025).

## P0 — Skills ecosystem (S189-S190)

- **evidence-audit:** DONE S189. context:fork, NCBI E-utilities only.
- **`/backlog`:** DONE S190. Inline skill, CRUD + auto-scoring + triage interativo.
- **`/improve`:** DONE S190. context:fork. Health + double-loop audit + NeoSigma trend. System nervous system.
- **`/insights` extension:** DONE S190. Phase 4.5 QUESTION (double-loop — questions existing KBPs/rules).
- **Research-backed:** Reflexion (Shinn 2023), Voyager (Wang 2023), PDSA (Deming), Double-loop (Argyris), Boris Cherny design principles.
- **Backlog #24-28:** ambitious patterns deferred (Voyager extraction, Kaizen tests, DGM archive, metaprompt, Reflexion embed).

## P0 — s-pubbias, s-rob2, Forest plots (DONE)

- **s-pubbias1 (S185), s-pubbias2 (S184), s-rob2 (S184), s-forest1+s-forest2 (S172-S173):** todos DONE.
- **h2 sizing:** FIXED S188 — s-rob2 e s-pubbias1 agora herdam --text-h2 (34px). Overrides removidos.
- **Pendente:** s-rob2 contraste brick verificar em projetor real.

## P1 — Build modernization

- **DONE:** `scripts/build-html.mjs` unificado. PS1 antigos preservados.
- **Pendente:** decisao sobre remover os 3 PS1 antigos.

## P1 — Prompt hardening propagacao (NEW S178)

- **Pendente:** propagar Call A/B/C hardening para cirrose e grade (design tokens, IGNORE_LIST, schema fixes, few-shot, S2 scope). Gate 0 ja propagado.
- **C2 (pipeline sequencial A→B):** avaliado como COULD — implementar se FPs persistirem apos hardening.

## P2 — A11y gaps residuais

- `pre-reading-heterogeneidade.html`: 14 links sem `rel="noopener"` + 3 `<th>` sem scope (READ-ONLY).
- `forest-plot-candidates.html`: 9 `<th colspan="2">` label rows.

## DECISOES ATIVAS

- **Gemini QA temp (S178):** editorial = 0.2 (nao mais 1.0). Override via `--temp`.
- **Format C+ (S156):** auto-loaded docs = `## Name` + `→ pointer`. → `anti-drift.md §Pointer-only discipline` + KBP-16.
- **Backlog gate (S155):** `if (commits>1 AND loc_saved<50 AND touches_runtime) → backlog`.
- **KBP-15 (S155):** Scripts externos NAO modificam write-path files.
- **Solo-audit penalty (S155):** single-model audit ~47% FP. Triangulate ou KBP-13.
- **Living HTML = source of truth = SINTESE CURADA.**
- **Evidence CSS benchmark S148:** `pre-reading-heterogeneidade.html` = padrao-ouro.
- **Plans lifecycle (S152):** `archive/SXXX-name.md`, per-file decision, default=keep.
- **aside.notes PROIBIDO (S161):** slides novos NAO incluem aside notes.
- **Docling = caminho canonico para PDFs (S162).**
- **OKLCH obrigatorio (S171):** rgba/rgb PROIBIDO em CSS novo/editado.
- **Gemini model canonical (S175):** Pro = `gemini-3.1-pro-preview`, Flash = `gemini-3-flash-preview`.

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro (LLM).
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- **h2 = trabalho do Lucas.** NUNCA remover/reescrever sem instrucao EXPLICITA.
- Benchmark `pre-reading-heterogeneidade.html` = READ-ONLY.
- MCP freeze ate 2026-04-14 (9 frozen; PubMed/SCite/Consensus ativos).
- Gemini FPs: css_cascade mitigado por IGNORE_LIST (S178). Monitorar se persistem.
- **clip-path nao desabilita pointer-events** — usar pointer-events:none.
- **overflow:hidden em flex + min-height:0** corta conteudo.
- **transform:scale() com transformOrigin nao centraliza** — requer translate combinado.
- **KBP-18:** NAO insistir na mesma estrategia falhada — 1 falha = repensar.
- **NUNCA escrever "Gemini 2.5"** — canonical: `gemini-3.1-pro-preview`.

## BACKLOG

→ `.claude/BACKLOG.md` (28 items; #10 RESOLVED S156, #12 RESOLVED S158, #24-28 novos S190)
- **Candidato backlog:** hook guard para grep "Gemini 2\." em arquivos novos

## CONFLITOS

(nenhum ativo)

## FLAG — s-contrato precisa update

`02-contrato.html` menciona "heterogeneidade", "efeito absoluto + aplicabilidade". Com s-aplicabilidade e s-absoluto removidos, contrato promete conteudo que nao sera entregue. Lucas decide se atualiza.

## SLIDES DEMOLIDOS (S186) — status atualizado S188

- `s-heterogeneity` (09) — REBUILT S188. SVG forest plots profissional.
- `s-i2` (09b) — ABSORBED S188 into s-heterogeneity. HTML em slides/ fora do build.
- `s-checkpoint-2` (12) — REMOVIDO S186. I2 phase eliminada.
- `s-aplicabilidade` (15) — REMOVIDO S186. pico-* CSS mantido (usado por s-pico).
- `s-absoluto` (16) — REMOVIDO S186. CSS conversion removido.
- `s-takehome` (17) — REESCRITO S191. 3 mensagens, aside.notes removido.
- `s-ancora` (13) — REMOVIDO S191. Replaced by s-etd.

## CLEANUP PENDENTE

- `.claude/plans/`: ~15 plans untracked (5 tracked deletados S191). Lucas decide per-file.
- `.claude/workers/`: workers de S178 + S181 (vies-pub-research). Lucas decide manter/remover.
- `assets/rob-calibrator.html`: ferramenta temp de calibracao. Lucas decide manter/remover.
- `capture-deck.mjs`: utilitario deck. Lucas decide manter/remover.

---
Coautoria: Lucas + Samoel Masao + Opus 4.6 | S191 2026-04-14
