# HANDOFF - Proxima Sessao

> Sessao 134 | 2026-04-09
> Foco: audit skills + refactor s-objetivos

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (18 slides metanalise).
**Agentes: 10.** **Hooks: 39 registrations.** **Rules: 10**. **MCPs: 3 ativos (PubMed, SCite, Consensus) + 9 frozen**. **KBPs: 10.**
**Skills: 18.** **Memory: 20/20.** **.claudeignore: criado S128.**

## P0 — Build slide s-importancia

Evidence pronto (S131-S132). Falta: `slides/02-importancia.html` + `_manifest.js` + CSS.
h2 = Lucas decide. Rules auto-loaded em content/aulas/**.

## BACKLOG (pos-deadline)

| # | Item | Detalhe |
|---|------|---------|
| 1 | Refatorar 6 evidence HTMLs | s-hook, s-pico, s-rs-vs-ma, s-objetivos, s-checkpoint-1, s-ancora → benchmark |
| 2 | Pernas pendentes (research) | Perna 2 (evidence-researcher: Scite/CrossRef/SemScholar/BioMCP), Perna 6 (NLM: requer login). Queries co-designed |
| 3 | Adversarial deferred: M-01, M-10 | Policy decisions (Bash granularity, Canva MCP wildcard) |
| 4 | Hook/config system review | JSON adequado? YAGNI audit. Esquema de config (ref: WhatsApp JPEG subagents post). Brainstorming + micropassos |
| 5 | Pipeline DAG end-to-end | cowork→NLM→wiki |
| 6 | medicina-clinica stubs | 4 concepts stub/low aguardam Cowork harvest |
| 7 | Skill de slides consolidada | Usar skill-creator para criar skill nova, migrar de rules para skill |

## DECISOES ATIVAS

- **Living HTML = source of truth = SINTESE CURADA.**
- **Evidence benchmark S131:** TODOS evidence HTMLs = estrutura pre-reading-heterogeneidade.
- **Estilo narrativo S119:** foco em metodologia, exemplos pontuais.
- **Insights S132:** 5 propostas aplicadas (anti-drift.md + multi-window.md).

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro.
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- KBP-07 anti-workaround, KBP-08 anti-substituicao, KBP-09 anti-routing, KBP-10 anti-destructive.
- MCP gate + Research gate: hooks force "ask" antes de MCP/research calls.
- MCP freeze ate 2026-04-14. PubMed session expirou S129.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S134 2026-04-09
