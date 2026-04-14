# HANDOFF - Proxima Sessao

> Sessao 184 | ROB2_COLOR_FIX

## ESTADO ATUAL

Monorepo funcional. CI verde. Build PASS (**18 slides** metanalise, build via Node.js).
**Agentes: 10.** **Hooks: 38.** **Rules: 11.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 18.** **Skills: 19.** **Memory: 20/20.** **Backlog: 21 items.**

## P0 — s-pubbias (vies de publicacao — 2 slides novos)

- **Living HTML DONE:** `evidence/s-pubbias.html` — 11 refs (6 PMID-VERIFIED + 5 DOI-VERIFIED)
- **s-pubbias2 DONE (S184).**
- **s-pubbias1 PENDENTE:** slide conceitual. h2 e layout = Lucas decide.
- **Posicao:** F2, apos s-rob2, antes de s-heterogeneity.
- **FOUC FIXED (S182):** opacity:0 + GSAP auto-reveal + failsafes completos.

## P0 — s-rob2 (DONE S184)

- **S184:** paleta NEJM/JACC (slate monochrome + brick accent), termos kappa Landis&Koch, ROBINS-I removido, dead CSS limpo.
- **Pendente:** h2 padronizar (Lucas decide). Verificar contraste brick a 10m no projetor real.

## P0 — Forest plot slides

- **s-forest1 + s-forest2 — DONE.** Gates completos (S172-S173).
- **FOUC fix S181+S182:** opacity:0 na img CSS + failsafes. Todos slides com mix-blend-mode corrigidos.
- **Completar overlap:** Lucas baixa PDFs das 11 MAs restantes via CAPES.
- **h2 provisorios:** Lucas pode reescrever a qualquer momento.

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

## CLEANUP PENDENTE

- `.claude/plans/`: 14 plans untracked (13 anteriores + witty-scribbling-harbor S183). Lucas decide per-file.
- `.claude/workers/`: workers de S178 + S181 (vies-pub-research). Lucas decide manter/remover.
- `assets/rob-calibrator.html`: ferramenta temp de calibracao. Lucas decide manter/remover.
- `assets/funnel-calibrator.html`: ferramenta calibracao zonas funnel plot (v2). Lucas decide manter/remover.
- `capture-deck.mjs`: utilitario deck. Lucas decide manter/remover.

---
Coautoria: Lucas + Opus 4.6 | S184 2026-04-13
