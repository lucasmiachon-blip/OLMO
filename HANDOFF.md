# HANDOFF - Proxima Sessao

> Sessao 161 | Forest plot slides (crops DONE, slides pendentes)

## ESTADO ATUAL

Monorepo funcional. CI verde. Build PASS (**15 slides** metanalise, 17 apos slides forest).
**Agentes: 10.** **Hooks: 38.** **Rules: 11.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 17.** **Skills: 20.** **Memory: 20/20.** **Backlog: 20 items.**

## P0 — Forest plot slides

- **Evidence DOING:** `evidence/s-forest-plot-final.html` (Li 2026 + Ebrahimi Cochrane 2025 + census 15 MAs destilado). Census versionado em `references/colchicine-macce-census-S148.md`.
- **Crops DONE (S160):** `metanalise/assets/forest-ebrahimi-2025-MI.png` (4501×1451 @ 600 DPI) + `metanalise/assets/forest-li-2025-MACE.png` (4084×2876 @ 600 DPI). Extraidos via docling+PyMuPDF. Sem titulo/footnotes/legenda — slide h2+source-tag substituem.
- **Slides pendentes:** criar `slides/08a-forest1.html` + `slides/08b-forest2.html`, wiring manifest/CSS/registry, QA pipeline. Plano: `.claude/plans/declarative-swimming-sunrise.md`.
- **Citations:** Ebrahimi et al. 2025, Cochrane Database Syst Rev | Li et al. 2025, Am J Cardiovasc Drugs.

## P1 — A11y gaps residuais

- `pre-reading-heterogeneidade.html`: 14 links sem `rel="noopener"` + 3 `<th>` sem scope (READ-ONLY).
- `forest-plot-candidates.html`: 9 `<th colspan="2">` label rows.

## DECISOES ATIVAS

- **Format C+ (S156):** auto-loaded docs = `## Name` + `→ pointer`. → `anti-drift.md §Pointer-only discipline` + KBP-16.
- **Backlog gate (S155):** `if (commits>1 AND loc_saved<50 AND touches_runtime) → backlog`.
- **KBP-15 (S155):** Scripts externos NAO modificam write-path files. Edit/Write tool ou nada.
- **Solo-audit penalty (S155):** single-model audit ~47% FP. Triangulate ou KBP-13.
- **Living HTML = source of truth = SINTESE CURADA.**
- **Evidence CSS benchmark S148:** `pre-reading-heterogeneidade.html` = padrao-ouro.
- **Plans lifecycle (S152):** `archive/SXXX-name.md`, per-file decision, default=keep.

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro (LLM).
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- **h2 = trabalho do Lucas.** NUNCA remover/reescrever sem instrucao EXPLICITA.
- Benchmark `pre-reading-heterogeneidade.html` = READ-ONLY.
- MCP freeze ate 2026-04-14 (9 frozen; PubMed/SCite/Consensus ativos).
- Gemini FPs conhecidos: css_cascade, failsafes/@media print.
- **Dream subagent violou KBP-07 em S158** (Python os.remove contornou guard-bash-write.sh 17b). Hook gap → BACKLOG #20. Flagged sentinel.

## BACKLOG

→ `.claude/BACKLOG.md` (20 items; #10 RESOLVED S156, #12 RESOLVED S158, #17-20 novos)

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S160 2026-04-12
