# HANDOFF - Proxima Sessao

> Sessao 130 | 2026-04-09
> Foco: CONSOLIDATION + SAFETY

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (18 slides metanalise).
**Agentes: 10.** **Hooks: 37 registrations.** **Rules: 10**. **MCPs: 3 ativos (PubMed, SCite, Consensus) + 9 frozen**. **KBPs: 10.**
**Skills: 20.** **Memory: 20/20.** **.claudeignore: criado S128.**

## P0 — Evidence HTML: refactor para coerencia

`s-importancia.html` precisa refactor:
1. **Prosa muito longa** — encurtar paragrafos, densidade sobre extensao
2. **Usar `pre-reading-heterogeneidade.html` como template/benchmark** — mesmo estilo, mesma estrutura
3. **Coerencia entre TODOS os evidence HTMLs** — formato unificado
4. Dados consolidados (26 refs, GRADE, TSA, NNT, Riley) — conteudo OK, apresentacao precisa melhorar

Benchmark: `content/aulas/metanalise/evidence/pre-reading-heterogeneidade.html`

## P0 — Pre-reading HTML: gerar

7 artigos core aprovados (output em `.claude/workers/pre-reading-research/output_2026-04-09T1730.md`):
- Forest plot: #1 Dettori 2021, #2 Andrade 2020
- RoB: #5 Sterne 2019, #6 Phillips 2021
- Pub bias: #9 Page 2021, #10 Afonso 2024, #11 Sterne 2011

**Template:** `pre-reading-heterogeneidade.html`. Output: `evidence/pre-reading-forest-plot-vies.html`

## P1 — Slide s-importancia

h2 = Lucas decide. Evidence pronto (pos-refactor). Falta: `slides/02-importancia.html` + `_manifest.js` + CSS.

## P2 — Pernas pendentes

- Perna 2 (evidence-researcher): NAO lancada. Evidence em 7.9/10. Valor marginal.
- Perna 6 (NLM): Requer `! nlm login`. NAO lancada.

## P3 — Outros

| # | Item | Detalhe |
|---|------|---------|
| 1 | **Adversarial deferred: M-01, M-10** | Policy decisions (Bash granularity, Canva MCP wildcard) |
| 2 | **Pipeline DAG end-to-end** | cowork→NLM→wiki. Pos-deadline. |
| 3 | **medicina-clinica stubs** | 4 concepts stub/low aguardam Cowork harvest |

## DECISOES ATIVAS

- **Multi-window S114:** orquestrador edita, workers read-only. Hooks enforce.
- **Gemini S114:** CLI FROZEN. API via GEMINI_API_KEY, gemini-3.1-pro-preview.
- **Wiki S111:** SCHEMA.md, wiki-index v1, wiki-lint, Dream auto-trigger (Stop hook).
- **Living HTML = source of truth = SINTESE CURADA.**
- **Memory cap 20. Dream auto-trigger via stop-should-dream.sh (24h cycle).**
- **Estilo narrativo S119:** foco em metodologia, exemplos pontuais, prosa sobre conceito nao estudo.

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro.
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- Anti-workaround (KBP-07): diagnosticar → reportar → listar opcoes → STOP.
- Anti-substituicao (KBP-08): perna falhou = reportar e pular.
- Anti-routing (KBP-09): Gemini/Perplexity = Bash/API, NUNCA MCP.
- **Anti-destructive (KBP-10):** NUNCA rm/delete sem aprovacao explicita. Hook hard-blocks rm em .claude/workers/. S130.
- **Referential integrity:** ao deletar arquivo, remover TODAS as referencias.
- **MCP freeze ate 2026-04-14:** Gmail, Calendar, Excalidraw, Canva, Context7, Notion.
- **MCP freeze permanente S128:** Scholar Gateway, Zotero, Playwright MCP.
- **Consensus FLAG:** marketing injection. Manter por ora.
- **PubMed MCP:** session expirou S129. Precisa reconectar.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S130 2026-04-09
