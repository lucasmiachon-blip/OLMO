# HANDOFF - Proxima Sessao

> Sessao 187 | TIPOS-MA + QUALITY-GRADE-ROB

## ESTADO ATUAL

Monorepo funcional. CI verde. Build PASS (**17 slides** metanalise, build via Node.js).
**Agentes: 10.** **Hooks: 38.** **Rules: 11.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 18.** **Skills: 19.** **Memory: 20/20.** **Backlog: 22 items.**

## P0 — evidence/s-tipos-ma.html (NEW S187 — LIVING HTML COMPLETO)

- **Criado `evidence/s-tipos-ma.html`:** 15 refs VERIFIED + 1 book (Cochrane Handbook v6.5). ~340 linhas.
- **Pipeline:** /evidence S187, 4 pernas (Gemini API, NLM CLI, evidence-researcher MCPs, orchestrador NCBI). Perplexity FALHOU (recusou gerar tabela).
- **Taxonomia 3-tier:** (1) Centrais: Pairwise, NMA, IPD-MA, DTA-MA, Prevalence; (2) Especializados: Dose-response, Bayesian, Living SR, Umbrella; (3) Transversais: One-stage vs Two-stage, Component NMA, Aggregate vs IPD.
- **Conteudo:** tabela de tipos (definicao/dados/quando/forcas/limitacoes), 9 exemplos medicos reais (Cipriani 2018, Valgimigli 2025, etc.), checklist leitor critico (2 perguntas por tipo), conexao com slides existentes, convergencia 3/3 bracos.
- **Refs fundacionais (evidence-researcher):** Reitsma 2005 bivariate DTA (PMID 16168343), Greenland 1992 dose-response (PMID 1626547), Salanti 2012 NMA (PMID 26062083).
- **Pendente:** (1) Lucas decide quantos slides e posicao no manifest; (2) h2 = Lucas; (3) nenhum slide criado ainda.

## P0 — evidence/s-quality-grade-rob.html (NEW S187 — LIVING HTML COMPLETO)

- **Criado `evidence/s-quality-grade-rob.html`:** 13 refs VERIFIED. ~280 linhas.
- **Pipeline:** /evidence S187, 5 pernas (Gemini API, Perplexity Sonar, NLM CLI, evidence-researcher MCPs, orchestrador NCBI). Convergencia 5/5.
- **Framework 3 niveis:** (1) RoB 2/ROBINS-I = vies no estudo individual; (2) GRADE = certeza da evidencia por desfecho; (3) AMSTAR-2 = qualidade do processo da RS/MA.
- **Conteudo:** visual framework 3 niveis, tabela 7 dominios criticos AMSTAR-2, tabela GRADE 8 dominios (5 downgrade + 3 upgrade), comparacao RoB 2 vs ROBINS-I, como RoB alimenta GRADE (dominio 1 de 5), 6 misconceptions documentadas com fontes, 4 cenarios clinicos (dissociacao AMSTAR-2/GRADE), analogia container/conteudo/ingredientes.
- **Mensagem central:** AMSTAR-2 = CONTAINER (processo). GRADE = CONTEUDO (evidencia). RoB = INGREDIENTES (estudos). RoB → GRADE (dominio 1/5). AMSTAR-2 INDEPENDENTE de GRADE.
- **Pendente:** (1) Lucas decide quantos slides e posicao no manifest; (2) h2 = Lucas; (3) nenhum slide criado ainda.

## P0 — s-heterogeneity + s-i2 + s-fixed-random (DRAFT — precisa refinamento)

- **3 slides criados (S187 HETERO_SLIDES):** build+lint PASS, 17 slides no manifest.
- **Status: DRAFT FUNCIONAL.** Lucas flagged: CSS/motion longe de profissional, requer polish significativo.
- **Pendente próxima sessão:** (1) revisar layout/tipografia a 10m; (2) motion refinement (timing, easing); (3) verificar color contrast em projetor; (4) Lucas decide h2 finais; (5) verificar 2 DOIs pendentes (Higgins 2025, Siemens 2025).
- **Evidence intacto:** `evidence/s-heterogeneity.html` — 17 refs (12 PMID-VERIFIED).
- **Gemini dual-creation:** feito. Merge adversarial documentado no plan `idempotent-exploring-tide.md`.

## P0 — s-pubbias, s-rob2, Forest plots (DONE)

- **s-pubbias1 (S185), s-pubbias2 (S184), s-rob2 (S184), s-forest1+s-forest2 (S172-S173):** todos DONE.
- **Pendente comum:** h2 padronizar (Lucas decide). s-rob2 contraste brick verificar em projetor real.

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

## SLIDES DEMOLIDOS (S186)

- `s-heterogeneity` (09) — slide removido, evidence MANTIDO, CSS removido. Rebuild em curso (outra janela).
- `s-checkpoint-2` (12) — slide + CSS + registry removidos. I2 phase eliminada.
- `s-aplicabilidade` (15) — slide removido, pico-* CSS mantido (usado por s-pico).
- `s-absoluto` (16) — slide + CSS conversion removidos.
- `s-takehome` (17) — MANTIDO por enquanto.

## CLEANUP PENDENTE

- `.claude/plans/`: ~11 plans untracked. Lucas decide per-file.
- `.claude/workers/`: workers de S178 + S181 (vies-pub-research). Lucas decide manter/remover.
- `assets/rob-calibrator.html`: ferramenta temp de calibracao. Lucas decide manter/remover.
- `capture-deck.mjs`: utilitario deck. Lucas decide manter/remover.

---
Coautoria: Lucas + Opus 4.6 | S187 2026-04-14
