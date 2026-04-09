# HANDOFF - Proxima Sessao

> Sessao 121 | 2026-04-09
> Foco: Agent Hardening

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (18 slides metanalise).
**Agentes: 10.** **Hooks: 34 registrations** (36 scripts; 2 pre-commit). **Rules: 11**. **MCPs: 12**. **KBPs: 7.**
**Adversarial S117:** 13/23 fixados. 5 by-design. 5 deferred (M-01/04/05/10/13).
**Wiki:** F1-F7 done. 6 concepts + 3 topics compilados (sistema-olmo). Indices atualizados.
**Memory: 20/20. Dream ran S118. Next review: S121. Next /insights: S120.**
**Evidence:** s-importancia (evidence limpo, slide pendente h2), pre-reading-heterogeneidade (DONE — resident-ready).

## PROXIMOS PASSOS

| # | Item | Detalhe | Complexidade |
|---|------|---------|--------------|
| 1 | **s-importancia: criar slide HTML** | h2 = Lucas decide. Evidence limpo. Falta criar slides/02-importancia.html + manifest + CSS | Normal |
| 2 | **Research s-importancia (REDO)** | 1-2 historias onde MA mudou pratica clinica. Para slide. | Normal |
| 3 | **medicina-clinica stubs** | 4 concepts stub/low aguardam Cowork harvest | Facil |
| 5 | **Adversarial deferred: M-01, M-10** | Policy decisions (Bash granularity, Canva MCP wildcard) | Lucas decide |
| 6 | **Pipeline DAG end-to-end** | Executar cowork→NLM→wiki com dados reais | Normal |
| 7 | **Notion-ops write tools** | Agente P1: so read. Adicionar write capability | Normal |

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

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S121 2026-04-09
