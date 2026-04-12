# HANDOFF - Proxima Sessao

> Sessao 163 | Evidence enriched, slide content next

## ESTADO ATUAL

Monorepo funcional. CI verde. Build PASS (**16 slides** metanalise, build via Node.js).
**Agentes: 10.** **Hooks: 38.** **Rules: 11.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 17.** **Skills: 20.** **Memory: 20/20.** **Backlog: 20 items.**

## P0 — Forest plot slides: evidence → slide content

- **s-benefit-harm removido S162.** 16 slides no deck.
- **Evidence DONE:** `s-forest-plot-final.html` expandido S162 — sintese critica (full-text PMC), redundancia meta-research (Ioannidis 2016, Chapelle 2021, Kwok 2025, Ou 2025), matriz sobreposicao trials (Li vs Ebrahimi: 10/14 compartilhados, top 5 = 78-88% peso).
- **Pendente S163:**
  - **Pesquisar sobreposicao detalhada:** mapear quantas das 15 MAs compartilham os mesmos RCTs. Objetivo: tabela completa de overlap (15 MAs × 14 RCTs). Vai informar conteudo do slide 2.
  - **Icone clicavel no slide 2 (s-forest2):** adicionar link/icone que abre a pagina Cochrane da MA (URL: `https://www.cochranelibrary.com/cdsr/doi/10.1002/14651858.CD014808.pub2/full`). Lucas decidira posicao/design.
  - **Resultados para slides:** pesquisar mais sobre resultados dos trials para informar conteudo visual dos slides (efeitos, animacoes planejadas).
- **QA pendente:** pipeline Preflight → Inspect → Editorial, 1 slide por ciclo.
- **h2 provisorios:** Lucas pode reescrever h2 dos forest plots a qualquer momento.
- **CSS pendente:** Lucas indicou que CSS tera mais mudancas — nao unificar/otimizar ainda.

## P1 — Build modernization

- **DONE:** `scripts/build-html.mjs` unificado (Node.js, ghost canary + integrity). PS1 antigos preservados.
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
- **aside.notes PROIBIDO (S161):** slides novos NAO incluem aside notes. Speaker notes vivem no evidence HTML.
- **Docling = caminho canonico para PDFs (S162).** PDFs em `content/aulas/dist/assets/`. Repo: `C:\Dev\Projetos\docling-tools`.

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
Coautoria: Lucas + Opus 4.6 | S162 2026-04-12
