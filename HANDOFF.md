# HANDOFF - Proxima Sessao

> Sessao 127 | 2026-04-09
> Foco: Context Optimization

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (18 slides metanalise).
**Agentes: 10.** **Hooks: 37 registrations (37 scripts; 0 pre-commit).** **Rules: 10**. **MCPs: 12**. **KBPs: 8.**
**Adversarial S117:** 13/23 fixados. 5 by-design. 5 deferred (M-01/04/05/10/13).
**Wiki:** F1-F7 done. 6 concepts + 3 topics compilados (sistema-olmo).
**Skills: 20 (16 disable-model-invocation, 4 auto-trigger).** **Memory: 20/20. Next review: S127. Next /insights: S127.**
**Evidence:** s-importancia (evidence limpo, slide pendente h2), pre-reading-heterogeneidade (DONE).
**Context Optimization S127:** always-loaded 433→336 linhas (-22%). KBPs→pointers. process-hygiene.md deletado.

## PROXIMOS PASSOS

| # | Item | Detalhe | Complexidade |
|---|------|---------|--------------|
| 1 | **s-importancia: criar slide HTML** | h2 = Lucas decide. Evidence limpo. Falta criar slides/02-importancia.html + manifest + CSS | Normal |
| 2 | **Research s-importancia (REDO)** | 1-2 historias onde MA mudou pratica clinica. Para slide | Normal |
| 3 | **Context diet P1 restante** | model-fallback-advisory compression + .claudeignore | Facil |
| 5 | **Integrar worker pre-reading-research** | 13 artigos candidatos, selecao final Lucas, criar HTML | Normal |
| 6 | **Auditar 12 MCPs para tool poisoning** | Zero-width chars, unicode, base64 em tool descriptions. P1 SECURITY | Normal |
| 7 | **medicina-clinica stubs** | 4 concepts stub/low aguardam Cowork harvest | Facil |
| 8 | **Adversarial deferred: M-01, M-10** | Policy decisions (Bash granularity, Canva MCP wildcard) | Lucas decide |
| 9 | **Pipeline DAG end-to-end** | Executar cowork→NLM→wiki com dados reais | Normal |

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
- Anti-substituicao (KBP-08): perna falhou = reportar e pular. WebSearch removido de evidence-researcher S126.
- **Referential integrity:** ao deletar arquivo, remover TODAS as referencias (pre-commit, settings, agent tools). Incidente S126.
- **MCP tool poisoning:** 12 MCPs NUNCA auditados para instrucoes ocultas. P1 SECURITY.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S127 2026-04-09
