# HANDOFF - Proxima Sessao

> Sessao 132 | 2026-04-09
> Foco: P0 polish s-importancia + pre-reading forest-plot-vies

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (18 slides metanalise).
**Agentes: 10.** **Hooks: 39 registrations.** **Rules: 10**. **MCPs: 3 ativos (PubMed, SCite, Consensus) + 9 frozen**. **KBPs: 10.**
**Skills: 20.** **Memory: 20/20.** **.claudeignore: criado S128.**

## P0 — s-importancia.html: DONE

Refatorado S131, polido S132: PMIDs removidos, deep-dives expandidos (TSA/GIGO/Pub Bias ~350 palavras cada), trials trimados (16 refs: 9 metodo + 1 meta-pesquisa + 6 emblematicos), key-takeaways verificados.
**Speaker notes esvaziadas** — slide nao construido.

## P0 — Pre-reading forest-plot-vies.html: DONE

7 artigos core, 3 blocos (forest plot, RoB, pub bias), hibrido temas+steps, 3 camadas (basico/intermediario/avancado), zero PMIDs.

## P1 — Slide s-importancia

h2 = Lucas decide. Evidence pronto (pos-S132). Falta: `slides/02-importancia.html` + `_manifest.js` + CSS.

## P2 — Pernas pendentes (lancar)

- **Perna 2 (evidence-researcher):** NAO lancada. Scite, CrossRef, Semantic Scholar, BioMCP.
- **Perna 6 (NLM):** Requer `! nlm login`. Query notebook metanalise (a274cffb).
- Queries co-designed com Lucas ANTES de lancar (hooks enforcem).

## BACKLOG (pos-deadline)

| # | Item | Detalhe |
|---|------|---------|
| 1 | Refatorar 6 evidence HTMLs | s-hook, s-pico, s-rs-vs-ma, s-objetivos, s-checkpoint-1, s-ancora → benchmark |
| 2 | Adversarial deferred: M-01, M-10 | Policy decisions (Bash granularity, Canva MCP wildcard) |
| 3 | Pipeline DAG end-to-end | cowork→NLM→wiki |
| 4 | medicina-clinica stubs | 4 concepts stub/low aguardam Cowork harvest |

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
- **Key-takeaway boxes:** triplamente verificadas S132. Afirmacoes em verde sao as mais memorizadas.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S132 2026-04-09
