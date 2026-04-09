# HANDOFF - Proxima Sessao

> Sessao 128 | 2026-04-09
> Foco: PRUNING

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (18 slides metanalise).
**Agentes: 10.** **Hooks: 37 registrations.** **Rules: 10**. **MCPs: 3 ativos (PubMed, SCite, Consensus) + 9 frozen**. **KBPs: 8.**
**Skills: 20.** **Memory: 20/20.** **.claudeignore: criado S128.**

## PROXIMOS PASSOS

| # | Item | Detalhe | Complexidade |
|---|------|---------|--------------|
| 1 | **Integrar worker pre-reading-research** | `.claude/workers/pre-reading-research/output_2026-04-09T1730.md`: 13 artigos VERIFIED (3 temas: forest plot, RoB, pub bias). Worker sugeriu 7 core. **Lucas precisa selecionar artigos.** Apos selecao: criar `evidence/pre-reading-forest-plot-vies.html` seguindo modelo `pre-reading-heterogeneidade.html`. Worker reportou problemas em MDs — verificar DONE.md. Intermediarios para apagar listados no DONE.md. | Normal |
| 2 | **Worker s-importancia outputs** | `.claude/workers/s-importancia-upgrade/`: 5 MDs (output, KBP-09, problema-pernas, aprimoramento-pipeline, prioridades) + audit report em `s-importancia-audit/`. Ler, decidir o que integrar, descartar resto. | Normal |
| 3 | **s-importancia: criar slide HTML** | h2 = Lucas decide. Evidence limpo em `metanalise/evidence/s-importancia.html`. Falta: `slides/02-importancia.html` + entrada em `_manifest.js` + CSS em `metanalise.css` | Normal |
| 4 | **Research s-importancia (REDO)** | 1-2 historias onde MA mudou pratica clinica (ex: corticoides prematuros, H. pylori). Para slide s-importancia | Normal |
| 5 | **Adversarial deferred: M-01, M-10** | Policy decisions (Bash granularity, Canva MCP wildcard) | Lucas decide |

### Pos-deadline (Notion, Wiki, DAG)
| # | Item | Detalhe |
|---|------|---------|
| 6 | **Pipeline DAG end-to-end** | cowork→NLM→wiki com dados reais. NLM via CLI OAuth. |
| 7 | **medicina-clinica stubs** | 4 concepts stub/low aguardam Cowork harvest |

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
- **Referential integrity:** ao deletar arquivo, remover TODAS as referencias.
- **MCP freeze ate 2026-04-14:** Gmail, Calendar, Excalidraw, Canva, Context7, Notion.
- **MCP freeze permanente S128:** Scholar Gateway, Zotero, Playwright MCP.
- **Consensus FLAG:** marketing injection. Manter por ora.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S128 2026-04-09
