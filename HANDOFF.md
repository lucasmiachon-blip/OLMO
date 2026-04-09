# HANDOFF - Proxima Sessao

> Sessao 123 | 2026-04-09
> Foco: Brainstorming Skill

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (18 slides metanalise).
**Agentes: 10.** **Hooks: 35 registrations** (37 scripts; 2 pre-commit). **Rules: 11**. **MCPs: 12**. **KBPs: 7.**
**Adversarial S117:** 13/23 fixados. 5 by-design. 5 deferred (M-01/04/05/10/13).
**Wiki:** F1-F7 done. 6 concepts + 3 topics compilados (sistema-olmo).
**Skills: 20.** **Memory: 20/20. Dream ran S118. Next review: S124. Next /insights: S123.**
**Evidence:** s-importancia (evidence limpo, slide pendente h2), pre-reading-heterogeneidade (DONE).
**Workers S117-S119:** synthesis consumido. 5 itens incorporados abaixo. Stale workers apagados.

## PROXIMOS PASSOS

| # | Item | Detalhe | Complexidade |
|---|------|---------|--------------|
| 1 | **s-importancia: criar slide HTML** | h2 = Lucas decide. Evidence limpo. Falta criar slides/02-importancia.html + manifest + CSS | Normal |
| 2 | **Research s-importancia (REDO)** | 1-2 historias onde MA mudou pratica clinica. Para slide | Normal |
| 3 | ~~brainstorming skill~~ | DONE S123. `.claude/skills/brainstorming/SKILL.md` | — |
| 4 | **success pattern capture hook** | Hook post-commit → success-log.jsonl. Feeds /insights + /dream (Ruflo) | Normal |
| 5 | **hook auto-calibration counters** | Contadores disparos/aceites/ignores por hook proativo → /insights (Ruflo) | Normal |
| 6 | **Auditar 12 MCPs para tool poisoning** | Zero-width chars, unicode, base64 em tool descriptions. P1 SECURITY | Normal |
| 7 | **medicina-clinica stubs** | 4 concepts stub/low aguardam Cowork harvest | Facil |
| 8 | **Adversarial deferred: M-01, M-10** | Policy decisions (Bash granularity, Canva MCP wildcard) | Lucas decide |
| 9 | **Pipeline DAG end-to-end** | Executar cowork→NLM→wiki com dados reais | Normal |
| 10 | **Notion-ops write tools** | Agente P1: so read. Adicionar write capability | Normal |

Sequencia sugerida: #4+#5 (infra learning, 1 sessao) → #1+#2 (s-importancia).

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
- **MCP tool poisoning:** 12 MCPs (PubMed, Consensus, SCite, etc.) NUNCA auditados para instrucoes ocultas (zero-width chars, unicode, base64). Risco real em MCPs de terceiros. Claude Code v2.1.97 (safe — CVE 50-subcommand patched v2.1.90).

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S123 2026-04-09
