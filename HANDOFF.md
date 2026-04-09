# HANDOFF - Proxima Sessao

> Sessao 129 | 2026-04-09
> Foco: PIPELINE-FIX + RESEARCH

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (18 slides metanalise).
**Agentes: 10.** **Hooks: 37 registrations.** **Rules: 10**. **MCPs: 3 ativos (PubMed, SCite, Consensus) + 9 frozen**. **KBPs: 9.**
**Skills: 20.** **Memory: 20/20.** **.claudeignore: criado S128.**

## P0 — Research s-importancia (consolidar)

| # | Item | Onde | Status |
|---|------|------|--------|
| 1 | **Consolidar pernas pesquisa** | Workers abaixo | Dados prontos, falta sintese |
| 2 | **Corrigir PMID em perna1-gemini.md** | 20212854 WRONG (optica!) → **20139215** (Riley BMJ 2010). Outros 2 VERIFIED: 18083463, 18069721 | Verificado S129 via PubMed MCP |
| 3 | **Perna 2 (evidence-researcher)** | Relancar com worker mode override (fix S129) | NAO lancada |
| 4 | **Perna 6 (NLM)** | Requer `! nlm login` do Lucas | NAO lancada |
| 5 | **5 decisoes Lucas** | V5 framework, TSA depth, GRADE formal, NNT ATC2002, Borenstein ed. | Apos consolidacao |

### Dados de pesquisa disponiveis

| Perna | Status | Arquivo |
|-------|--------|---------|
| 1 Gemini (5/5 eixos) | **DONE** | `.claude/workers/s-importancia-audit/perna1-gemini.md` |
| 5 Perplexity (3/5 eixos) | **DONE** | `.claude/workers/s-importancia-audit/perna5-perplexity.md` |
| 5 Perplexity (eixos 4-5) | **DONE S129** | `.claude/workers/s-importancia-audit/perna5-perplexity-axes4-5.md` |
| 3 MBE + S SCite + R Researcher | **DONE** | `.claude/workers/s-importancia-upgrade/2026-04-09-2200-output.md` |
| 2 evidence-researcher | **FALHOU** | Relancar (worker mode fix aplicado) |
| 4 reference-checker | **SKIPPED** | Consensus quota (KBP-08 correto) |
| 6 NLM | **NAO LANCADA** | Requer OAuth |

## P1 — Pre-reading research (relancar)

Worker `pre-reading-research/` foi apagado sem consumo. Resultado perdido: 13 artigos VERIFIED.
**Relancar /research** com escopo: artigos DIDATICOS (tutorials, primers) para residentes, 3 temas:
1. Forest plot — como ler e interpretar
2. Risk of Bias (RoB) — RoB 2, ROBINS-I
3. Publication bias — funnel plots, trim-and-fill, p-hacking

Criterios: didaticos, nivel intermediario, open access preferido, ingles, 2015-2025.
Benchmark: `pre-reading-heterogeneidade.html`. Output: 10-15 artigos com PMID verificado.

## P2 — Slide s-importancia

h2 = Lucas decide. Evidence em `metanalise/evidence/s-importancia.html` (253 linhas, rico).
Falta: `slides/02-importancia.html` + `_manifest.js` + CSS em `metanalise.css`.

## P3 — Outros

| # | Item | Detalhe |
|---|------|---------|
| 1 | **Adversarial deferred: M-01, M-10** | Policy decisions (Bash granularity, Canva MCP wildcard) |
| 2 | **Cleanup workers** | `rm` negado S129. Consumidos: 5 meta MDs em s-importancia-upgrade/ + 3 em s-importancia-audit/. Manter: 3 outputs (perna1, perna5, perna5-axes4-5) + 1 output.md |
| 3 | **Pipeline DAG end-to-end** | cowork→NLM→wiki. Pos-deadline. |
| 4 | **medicina-clinica stubs** | 4 concepts stub/low aguardam Cowork harvest |

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
- Anti-routing (KBP-09): Gemini/Perplexity = Bash/API, NUNCA MCP. Tabela corrigida S129.
- **Referential integrity:** ao deletar arquivo, remover TODAS as referencias.
- **MCP freeze ate 2026-04-14:** Gmail, Calendar, Excalidraw, Canva, Context7, Notion.
- **MCP freeze permanente S128:** Scholar Gateway, Zotero, Playwright MCP.
- **Consensus FLAG:** marketing injection. Manter por ora.
- **PubMed MCP:** session expirou S129. Pode precisar reconectar.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S129 2026-04-09
