# HANDOFF - Proxima Sessao

> Sessao 180 | ROB2.1

## ESTADO ATUAL

Monorepo funcional. CI verde. Build PASS (**17 slides** metanalise, build via Node.js).
**Agentes: 10.** **Hooks: 38.** **Rules: 11.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 18.** **Skills: 19.** **Memory: 20/20.** **Backlog: 21 items.**

## P0 — Gemini QA Pipeline Hardening (S178)

- **Temperature corrigida (M1):** Calls A/B/C 1.0→0.2, Call D 1.0→0.1. Gate 0 ja era 0.1.
- **Design tokens injetados (M2):** Call B recebe oklch colors, 8px grid, typography mins.
- **Schema fixes estruturado (M3):** `fixes: [string]` → `[{target, change, reason}]` em DIM_PROP.
- **IGNORE_LIST failsafes (M4):** `.no-js, .stage-bad, @media print, [data-qa]` whitelisted no Call B.
- **Call C sem JS (S1):** Modelo recebe so video+PNGs, forcado a observar em vez de inferir do codigo.
- **24px threshold (S2):** Call A tem regra concreta: texto critico < 24px no viewport = FAIL.
- **Math verification (S3):** Script calcula media local e alerta se Call D diverge >1.5.
- **S2 evaluation scope (S4):** S2 avaliado SO para defeitos mecanicos, NAO cognitive load.
- **Gate 0 contradicao fix:** "beneficio da duvida" removido (todas 3 aulas).
- **Few-shot Call B (C1):** 2 exemplos (pass + fail) com css_cascade e information_design.
- **Propagacao parcial:** Gate 0 fix propagado para cirrose/grade. Call A/B/C hardening PENDENTE para cirrose/grade.
- **Prompt refinements (S179):** threshold table tipografia, kappa KNOWN DECISIONS, ceiling cap 10→9.

## P0 — s-rob2 (layout redesign pendente)

- **QA r14-r15 (S180):** score 7.3→5.0 apos Call D. Sobreposicao kappa-note/source-tag confirmada.
- **Call focada (S180):** tipografia 4, varredura 5, legibilidade **3**, hierarquia 5, disposicao 4, sobreposicao **2**. Slide tem problema **estrutural** de densidade (8 elementos, sem heroi).
- **Herois confirmados:** crop RoB + dominios D1-D5. Kappa bars e cards = apoio.
- **CSS experiments (S180):** tentativas incrementais falharam (remendos sem visao global). Revertido a HEAD.
- **Proxima sessao:** redesign coerente do layout com grid rows explicitas (3fr/2fr), crop preenchendo celula, EN text hidden. Pensar ANTES, 1 rewrite, nao patches.
- **Call D hardening pendente:** adicionar coverage audit ("defeitos que nenhuma call mencionou") + call especifica tipografia/hierarquia/legibilidade.

## P0 — Forest plot slides

- **s-forest1 (Li 2026) — DONE.** Gate 4 completo (S172).
- **s-forest2 (Ebrahimi Cochrane) — DONE.** Gate 4 completo (S173).
- **Completar overlap:** Lucas baixa PDFs das 11 MAs restantes via CAPES.
- **h2 provisorios:** Lucas pode reescrever a qualquer momento.
- **CSS pendente:** Lucas indicou mudancas globais — nao otimizar ainda.

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

- `.claude/plans/`: 11 plans untracked (10 anteriores + 1 de S178). Lucas decide per-file.
- `.claude/workers/`: 3 arquivos temp de S178 hardening (script + JSON + thinking). Lucas decide manter/remover.
- `assets/rob-calibrator.html`: ferramenta temp de calibracao. Lucas decide manter/remover.
- `agents/ai_update/ai_update_agent.py:112`: registra "Gemini 2.0" — stale.

---
Coautoria: Lucas + Opus 4.6 | S180 2026-04-13
