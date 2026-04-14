# HANDOFF - Proxima Sessao

> Sessao 188 | HETERO-POLISH

## ESTADO ATUAL

Monorepo funcional. CI verde. Build PASS (**16 slides** metanalise, build via Node.js).
**Agentes: 10.** **Hooks: 38.** **Rules: 11.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 18.** **Skills: 19.** **Memory: 20/20.** **Backlog: 22 items.**

## P0 — evidence/s-tipos-ma.html (S187 — ENRICHED, BENCHMARK CSS)

- **16 refs VERIFIED + 1 book** (Cochrane Handbook v6.5). ~480 linhas. Benchmark CSS (pre-reading-heterogeneidade.html).
- **3-layer content:** conceitos-chave (initial) → taxonomia + exemplos (intermediate) → 5 deep-dive accordions (advanced/Lucas).
- **Enrichment fixes:** Welton 2009 DOI/journal corrigidos (era Stat Med → Am J Epidemiol), Wang 2021 "64%" → abstract-verified "39%", AllTrials claim genericizado.
- **Pendente:** (1) Lucas decide quantos slides e posicao no manifest; (2) h2 = Lucas; (3) nenhum slide criado ainda.

## P0 — evidence/s-quality-grade-rob.html (S187 — ENRICHED, BENCHMARK CSS)

- **14 refs VERIFIED** (incluindo Guyatt 2011 PMID 21839614 — GRADE imprecision, verificado NCBI). ~420 linhas. Benchmark CSS.
- **3-layer content:** conceitos-chave (initial) → framework 3 niveis + tools (intermediate) → 4 deep-dive accordions (advanced/Lucas).
- **Enrichment fixes:** ROBINS-I "88%" → "12% no nivel do desfecho", Yan "5 de 10" → abstract-verified language.
- **Pendente:** (1) Lucas decide quantos slides e posicao no manifest; (2) h2 = Lucas; (3) nenhum slide criado ainda.

## P0 — s-heterogeneity (DONE S188) + s-fixed-random (DRAFT — precisa rewrite)

- **s-heterogeneity:** DONE. SVG forest plots, 3 clicks, QA fino (hierarchy+legibility PASS). CI stroke 2.5, PI band 0.22, italic removido, margin insight. System tokens only.
- **s-i2:** ABSORBED into s-heterogeneity (S188). HTML em slides/09b-i2.html fora do build.
- **s-fixed-random:** DRAFT. Tem DSL/REML/HKSJ (fora de escopo residentes), tokens privados (--fr-*), CSS amador (~140 linhas). Precisa rewrite completo forest-plot-first.
- **Evidence intacto:** `evidence/s-heterogeneity.html` — 17 refs (12 PMID-VERIFIED).
- **Pendente:** (1) rewrite s-fixed-random; (2) verificar 2 DOIs pendentes (Higgins 2025, Siemens 2025).

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

→ `.claude/BACKLOG.md` (21 items; #10 RESOLVED S156, #12 RESOLVED S158, #17-20 novos)
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
- `s-takehome` (17) — MANTIDO por enquanto.

## CLEANUP PENDENTE

- `.claude/plans/`: ~11 plans untracked. Lucas decide per-file.
- `.claude/workers/`: workers de S178 + S181 (vies-pub-research). Lucas decide manter/remover.
- `assets/rob-calibrator.html`: ferramenta temp de calibracao. Lucas decide manter/remover.
- `capture-deck.mjs`: utilitario deck. Lucas decide manter/remover.

---
Coautoria: Lucas + Opus 4.6 | S188 2026-04-14
