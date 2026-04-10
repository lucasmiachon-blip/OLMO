# HANDOFF - Proxima Sessao

> Sessao 136 | 2026-04-10
> Foco: build slides + poda

## ESTADO ATUAL

Monorepo funcional. CI verde. Build OK (16 slides metanalise — 3 removidos, s-importancia adicionado).
**Agentes: 10.** **Hooks: 39 registrations.** **Rules: 10**. **MCPs: 3 ativos (PubMed, SCite, Consensus) + 9 frozen**. **KBPs: 10.**
**Skills: 18.** **Memory: 19/20.** **.claudeignore: criado S128.**

## P0 — QA s-importancia

Slide criado S135, built S136. Proximo: QA pipeline.
1. Preflight (dims objetivas: cor, tipografia, hierarquia)
2. `gemini-qa3.mjs --inspect` (Gate 0)
3. `gemini-qa3.mjs --editorial` (Gate 4)

## P1 — QA restantes (12 slides LINT-PASS)

Lucas decide qual slide. Pipeline: 1 slide/vez, 3 gates.

## BACKLOG (pos-deadline)

| # | Item | Detalhe |
|---|------|---------|
| 1 | Refatorar 6 evidence HTMLs | s-hook, s-pico, s-rs-vs-ma, s-objetivos, s-checkpoint-1, s-ancora → benchmark |
| 2 | Pernas pendentes (research) | Perna 2 (evidence-researcher), Perna 6 (NLM: requer login) |
| 3 | Adversarial deferred: M-01, M-10 | Policy decisions (Bash granularity, Canva MCP wildcard) |
| 4 | Hook/config system review | JSON adequado? YAGNI audit |
| 5 | Pipeline DAG end-to-end | cowork→NLM→wiki |
| 6 | medicina-clinica stubs | 4 concepts stub/low aguardam Cowork harvest |
| 7 | Skill de slides consolidada | Usar skill-creator para criar skill nova |

## DECISOES ATIVAS

- **Living HTML = source of truth = SINTESE CURADA.**
- **Evidence benchmark S131:** TODOS evidence HTMLs = estrutura pre-reading-heterogeneidade.
- **Estilo narrativo S119:** foco em metodologia, exemplos pontuais.
- **Dual creation S135:** Gemini + Claude geram mockups HTML independentes. NUNCA Claude reescreve Gemini.
- **Pedagogia adultos S135:** sem formulas em slides (1/√N proibido), numeros concretos SIM.
- **Speaker notes S135:** vao para evidence HTML, NAO aside no slide.
- **Archetype removal S136:** campo archetype removido do manifest. Liberdade artistica.

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro.
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- KBP-07 anti-workaround, KBP-08 anti-substituicao, KBP-09 anti-routing, KBP-10 anti-destructive.
- MCP gate + Research gate: hooks force "ask" antes de MCP/research calls.
- MCP freeze ate 2026-04-14. PubMed session expirou S129.
- Projetor metanalise: ~10m distancia. Legibilidade = constraint #1.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S136 2026-04-10
