# HANDOFF - Proxima Sessao

> Sessao 165 | tuning + forest 2

## ESTADO ATUAL

Monorepo funcional. CI verde. Build PASS (**16 slides** metanalise, build via Node.js).
**Agentes: 10.** **Hooks: 38.** **Rules: 11.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 17.** **Skills: 20.** **Memory: 20/20.** **Backlog: 20 items.**

## P0 — Forest plot slides

- **s-forest1 (Li 2026) — FUNCIONAL:** 4 faixas (CI+OR, events, weight, studies) + 3 destaques (weight-max, weight-min, diamond) + het sutil. Zonas realinhadas S165 (~90%). Fine-tune pendente via Gemini Gate 4.
- **s-forest2 (Ebrahimi Cochrane) — FUNCIONAL:** 4 auto-zones (reconhecimento forest1) + Cochrane logo clicavel (clipPath reveal) + RoB zoom (ultimo beat, gancho para slide de vieses). Fine-tune pendente.
- **PENDENTE prox sessao:**
  - Gemini Gate 4 (Inspect) nos dois forest slides — 10 must-fix suggestions
  - Fix global JS: advance/retreat nao retorna mesma sequencia sempre (afeta TODOS os slides)
  - Redesign forest2 layout (sketch em `dist/assets/Screenshot 2026-04-12 155443.png`): box info embaixo-esquerda (n MAs sobreposicao + estudo), Cochrane penultimo beat, RoB zoom ultimo beat. clickReveals 2→3
- **Completar overlap:** Lucas baixa PDFs das 11 MAs restantes via CAPES.
- **h2 provisorios:** Lucas pode reescrever a qualquer momento.
- **CSS pendente:** Lucas indicou mudancas globais — nao otimizar ainda.

## P1 — Build modernization

- **DONE:** `scripts/build-html.mjs` unificado. PS1 antigos preservados.
- **Pendente:** decisao sobre remover os 3 PS1 antigos.

## P2 — A11y gaps residuais

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
- **aside.notes PROIBIDO (S161):** slides novos NAO incluem aside notes.
- **Docling = caminho canonico para PDFs (S162).**
- **Animacoes forest slides (S163→S165):** zonas coloridas + Cochrane clipPath + RoB zoom. Sem texto overlay — professor narra. Proposito pedagogico obrigatorio.

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro (LLM).
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- **h2 = trabalho do Lucas.** NUNCA remover/reescrever sem instrucao EXPLICITA.
- Benchmark `pre-reading-heterogeneidade.html` = READ-ONLY.
- MCP freeze ate 2026-04-14 (9 frozen; PubMed/SCite/Consensus ativos).
- Gemini FPs conhecidos: css_cascade, failsafes/@media print.

## BACKLOG

→ `.claude/BACKLOG.md` (20 items; #10 RESOLVED S156, #12 RESOLVED S158, #17-20 novos)

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S165 2026-04-12
