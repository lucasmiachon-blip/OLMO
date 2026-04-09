# HANDOFF - Proxima Sessao

> Sessao 130 | 2026-04-09
> Foco: CONSOLIDATION + SAFETY

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (18 slides metanalise).
**Agentes: 10.** **Hooks: 37 registrations.** **Rules: 10**. **MCPs: 3 ativos (PubMed, SCite, Consensus) + 9 frozen**. **KBPs: 10.**
**Skills: 20.** **Memory: 20/20.** **.claudeignore: criado S128.**

## P0 — Research s-importancia: CONSOLIDADO

Evidence HTML atualizado (26 refs, 22 VERIFIED + 4 WEB-VERIFIED). Decisoes tomadas:

| # | Decisao | Escolha S130 |
|---|---------|--------------|
| 1 | V5 framework | Riley 2010 (PMID 20139215) em glossario/extras |
| 2 | TSA depth | Wetterslev 2008 (PMID 18083463) em collapsible details |
| 3 | GRADE formal | Tabela GRADE 5-dominios adicionada (V3/V4=ALTA, V1/V2/V5=MODERADA) |
| 4 | NNT ATC2002 | NNT 28 em speaker notes (nao no slide) |
| 5 | Borenstein ed. | Atualizado para 2021 2a edicao (ISBN 978-1-119-55835-4) |

PMIDs orfaos (20139215, 18083463) integrados. 18069721 = skip (fora escopo F1).
PMID fix 20212854: **RESOLVIDO** — arquivo perna1-gemini.md nao existe mais, PMID ruim nunca propagou.

## P0 — Pre-reading research: SELECAO APROVADA

7 artigos core aprovados (output em `.claude/workers/pre-reading-research/output_2026-04-09T1730.md`):
- Forest plot: #1 Dettori 2021, #2 Andrade 2020
- RoB: #5 Sterne 2019, #6 Phillips 2021
- Pub bias: #9 Page 2021, #10 Afonso 2024, #11 Sterne 2011

**Pendente:** Gerar `evidence/pre-reading-forest-plot-vies.html` com os 7 selecionados.

## P1 — Perna 2 (evidence-researcher) + Perna 6 (NLM)

- Perna 2: NAO lancada. Evidence ja em 7.9/10 (26 refs). Valor marginal — Lucas decide se lanca.
- Perna 6: Requer `! nlm login`. NAO lancada.

## P2 — Slide s-importancia

h2 = Lucas decide. Evidence pronto. Falta: `slides/02-importancia.html` + `_manifest.js` + CSS.

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
