# HANDOFF - Proxima Sessao

> Sessao 156 | 2026-04-11
> Foco: INFRA_3 — auto-load reduction (Format C+ + anti-drift anchor + HANDOFF compact)
> **Proxima sessao (S157) = SLIDES** (carry-over S154→S155→S156→S157)

## ESTADO ATUAL

Monorepo funcional. CI verde. Build PASS (**15 slides** metanalise).
**Agentes: 10.** **Hooks: 38.** **Rules: 11.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 16** (KBP-16 NEW S156). **Skills: 20.** **Memory: 20/20.**
**Auto-load: ~-2,350 tokens (S156 INFRA_3). Settings.local.json: 68→26 allow entries.**

## P0 — Carry-over slides (S154→S157)

- **Slide A:** Vaduganathan 2022 (SGLT2i/IC, PMID 36041474 VERIFIED) — anatomia basica
- **Slide B:** Colchicina — 3 MAs candidatas (Ebrahimi 2025 Cochrane + Samuel 2025 EHJ 40314333 + Li 2026 AJCD 40889093). Evidence: `forest-plot-candidates.html`

## P0 — Pendente S156

- **`.claude/tmp/` cleanup:** arquivos tmp dispatch S155 + `backup-pre-infra3-settings.json` (S156). **Nunca deletar sem ack (KBP-10).** Lucas decide batch ou individual.

## P1 — A11y gaps residuais

- Benchmark `pre-reading-heterogeneidade.html`: 14 links sem `rel="noopener"` + 3 `<th>` sem scope (read-only invariant).
- `forest-plot-candidates.html`: 9 `<th colspan="2">` label rows — fix semantico caso-a-caso.

## DECISOES ATIVAS

- **Format C+ (S156 NEW):** auto-loaded docs = `## Name` + `→ pointer`. Prose vive no pointer target. → `anti-drift.md §Pointer-only discipline` + KBP-16.
- **Backlog gate (S155):** `if (commits>1 AND loc_saved<50 AND touches_runtime) → backlog`.
- **KBP-15 (S155):** Scripts externos NAO modificam write-path files. Edit/Write tool ou nada.
- **Solo-audit penalty (S155):** single-model audit ~47% FP. Triangulate ou aplicar KBP-13.
- **Living HTML = source of truth = SINTESE CURADA.** Escrito direto, sem JSON intermediario.
- **Evidence CSS benchmark S148:** `pre-reading-heterogeneidade.html` = padrao-ouro.
- **Plans lifecycle (S152):** `archive/SXXX-name.md`, per-file decision, default=keep.

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro (LLM).
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- **h2 = trabalho do Lucas.** NUNCA remover/reescrever sem instrucao EXPLICITA.
- Benchmark `pre-reading-heterogeneidade.html` = READ-ONLY.
- MCP freeze ate 2026-04-14 (9 frozen; PubMed/SCite/Consensus ativos).
- Gemini FPs conhecidos: css_cascade, failsafes/@media print.

## BACKLOG

→ `.claude/BACKLOG.md` (11 items persistentes, nao auto-loaded)

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S156 2026-04-11
