# HANDOFF - Proxima Sessao

> Sessao 157 | 2026-04-11 | Fase calmaria (pos-rule-level fix)
> Foco: forest plot s-forest1 + s-forest2 pendentes

## ESTADO ATUAL

Monorepo funcional. CI verde. Build PASS (**15 slides** metanalise, 2 novos em execucao S157).
**Agentes: 10.** **Hooks: 38.** **Rules: 11.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 17.** **Skills: 20.** **Memory: 20/20.**

## P0 — S157 em execucao

- **Context melt fix:** RESOLVED commit 20dcc3e (KBP-17 + `anti-drift.md §Delegation gate`). Rule auto-loaded. Monitorar spikes futuros.
- **Forest plot slides:** s-forest1 (Li 2026 AJCD, PMID 40889093 VERIFIED) + s-forest2 (Ebrahimi 2025 Cochrane, PMID 41224205 VERIFIED). Evidence unico denso: `s-forest-plot.html` (a criar). Plano: `.claude/plans/abundant-pondering-zebra.md`

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
Coautoria: Lucas + Opus 4.6 | S157 2026-04-11
