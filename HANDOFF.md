# HANDOFF - Proxima Sessao

> Sessao 159 | Volta ao fluxo normal (slides, research, ensino)

## ESTADO ATUAL

Monorepo funcional. CI verde. Build PASS (**15 slides** metanalise).
**Agentes: 10.** **Hooks: 38.** **Rules: 11.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 17.** **Skills: 20.** **Memory: 20/20.** **Backlog: 20 items.**

## P0 — Infra fixes pendentes (Lucas manual — guard-product-files.sh A6 bloqueia agent)

Diffs completos em CHANGELOG S158 §Fix 1 e §Fix 2. Apenas Lucas aplica via editor.

- **`.claude/settings.local.json` linhas 43-44**: remover `"Edit"` e `"Write"` do allow. Volta ao default=ask. Resolve BACKLOG #12.
- **`hooks/stop-should-dream.sh` linhas 18-20**: adicionar Python fallback ISO 8601 parse. Bug: dream dispara a cada Stop em Windows MSYS (`date -d` falha silenciosa em sufixo `Z`). Evidencia: S158 disparou ~4h46min apos S157, nao 24h.

## P0 — Slides (desbloqueado, fim da infra)

- **Forest plot slides:** s-forest1 (Li 2026 AJCD, PMID 40889093 VERIFIED) + s-forest2 (Ebrahimi 2025 Cochrane, PMID 41224205 VERIFIED). Evidence unico denso `s-forest-plot.html` a criar. Plano: `.claude/plans/abundant-pondering-zebra.md`.

## P0 — tmp cleanup S156

- `.claude/tmp/` arquivos dispatch S155 + `backup-pre-infra3-settings.json`. KBP-10 hard: Lucas decide individual, nunca batch.

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

→ `.claude/BACKLOG.md` (20 items; #10 RESOLVED S156, #12 pending-fix S158, #17-20 novos)

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S158 2026-04-11
