# HANDOFF - Proxima Sessao

> Sessao 131 | 2026-04-09
> Foco: Evidence HTML + Pre-Reading

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (18 slides metanalise).
**Agentes: 10.** **Hooks: 39 registrations.** **Rules: 10**. **MCPs: 3 ativos (PubMed, SCite, Consensus) + 9 frozen**. **KBPs: 10.**
**Skills: 20.** **Memory: 20/20.** **.claudeignore: criado S128.**

## P0 — s-importancia.html: DONE (refactor) + 3 pendencias

Refatorado S131: CSS benchmark, 8 secoes, V1-V5 core-step, 26 refs.
**Pendente proxima sessao:**
1. **Remover PMIDs inline** — tirar todos os PMIDs restantes do corpo do HTML (core-path, glossario, deep-dive). Refs = Autor+Titulo+Journal+Ano. PMIDs so no pipeline de validacao.
2. **Expandir deep-dive** — TSA, GIGO, pub bias precisam explicacao didatica para Lucas (conceitos complexos curtos demais)
3. **Triplo check key-takeaways e core readings** — afirmacoes em verde (key-takeaway) e artigos core devem ser re-verificados

## P0 — Pre-reading HTML: gerar

7 artigos core aprovados (verificados S130):

| # | Tema | Autores | Titulo | Journal | Ano |
|---|------|---------|--------|---------|-----|
| 1 | Forest Plot | Dettori JR et al. | Seeing the Forest by Looking at the Trees | Global Spine J | 2021 |
| 2 | Forest Plot | Andrade C | Understanding Basics of MA and How to Read a Forest Plot | J Clin Psychiatry | 2020 |
| 3 | Risk of Bias | Phillips MR et al. | Risk of bias: why measure it, and how? | Eye | 2021 |
| 4 | Risk of Bias | Sterne JAC et al. | RoB 2: revised tool for assessing RoB in RCTs | BMJ | 2019 |
| 5 | Pub Bias | Page MJ et al. | Publication bias and reporting biases in MA | Res Synth Methods | 2021 |
| 6 | Pub Bias | Afonso J et al. | Perils of Misinterpreting Publication Bias | Sports Med | 2024 |
| 7 | Pub Bias | Sterne JAC et al. | Recommendations on funnel plot asymmetry tests | BMJ | 2011 |

**Template:** `pre-reading-heterogeneidade.html`. Output: `evidence/pre-reading-forest-plot-vies.html`
**Regra refs:** Autor+Titulo+Journal+Ano. Sem PMID/DOI no HTML final.

## P1 — Slide s-importancia

h2 = Lucas decide. Evidence pronto (pos-refactor). Falta: `slides/02-importancia.html` + `_manifest.js` + CSS.

## P2 — Pernas pendentes (lancar)

- **Perna 2 (evidence-researcher):** NAO lancada. Scite, CrossRef, Semantic Scholar, BioMCP.
- **Perna 6 (NLM):** Requer `! nlm login`. Query notebook metanalise (a274cffb).
- Queries co-designed com Lucas ANTES de lancar (hooks enforcem).

## P3 — Refatorar outros evidence HTMLs

6 arquivos pendentes para alinhar com benchmark (pre-reading-heterogeneidade.html):
`s-hook.html`, `s-pico.html`, `s-rs-vs-ma.html`, `s-objetivos.html`, `s-checkpoint-1.html`, `s-ancora.html`
Regra: benchmark + speaker notes. Refs em tabela.

## P4 — Outros

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
- **Evidence benchmark S131:** TODOS evidence HTMLs = estrutura pre-reading-heterogeneidade. Unica adicao: speaker notes.

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro.
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- Anti-workaround (KBP-07): diagnosticar → reportar → listar opcoes → STOP.
- Anti-substituicao (KBP-08): perna falhou = reportar e pular.
- Anti-routing (KBP-09): Gemini/Perplexity = Bash/API, NUNCA MCP.
- **Anti-destructive (KBP-10):** NUNCA rm/delete sem aprovacao explicita. Hook ask (S131: block→ask).
- **MCP gate (S130):** Hook `guard-mcp-queries.sh` force "ask" antes de qualquer MCP call.
- **Research gate (S130):** Hook `guard-research-queries.sh` force "ask" antes de /research.
- **Referential integrity:** ao deletar arquivo, remover TODAS as referencias.
- **MCP freeze ate 2026-04-14:** Gmail, Calendar, Excalidraw, Canva, Context7, Notion.
- **MCP freeze permanente S128:** Scholar Gateway, Zotero, Playwright MCP.
- **Consensus FLAG:** marketing injection. Manter por ora.
- **PubMed MCP:** session expirou S129. Precisa reconectar.
- **Key-takeaway boxes:** triplamente verificadas. Afirmacoes em verde sao as mais memorizadas.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S131 2026-04-09
