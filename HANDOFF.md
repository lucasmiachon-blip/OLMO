# HANDOFF - Proxima Sessao

> Sessao 192 | cleanup + self-improvement + hardening

## ESTADO ATUAL

Monorepo funcional. Build PASS (**17 slides** metanalise). Apresentacao rodou bem na TV.
**Agentes: 10.** **Hooks: 38.** **Rules: 11.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 18.** **Skills: 22 project + 3 user.** **Memory: 20/20.** **Backlog: 30 items.**

## P0 — s-tipos-ma (evidence DONE S187, slide PENDENTE)

- Evidence `evidence/s-tipos-ma.html`: 16 refs VERIFIED + 1 book, ~480 linhas.
- **Pendente:** Lucas decide quantos slides, posicao no manifest, h2.

## P1 — Prompt hardening propagacao (backlog #30)

- Propagar Call A/B/C hardening para cirrose e grade. Detalhes no backlog.

## DECISOES ATIVAS

- Gemini QA temp = 0.2. Override via `--temp`.
- Format C+ pointer-only. OKLCH obrigatorio. aside.notes PROIBIDO.
- Living HTML = source of truth. Benchmark CSS = `pre-reading-heterogeneidade.html` (READ-ONLY).
- Gemini canonical: Pro = `gemini-3.1-pro-preview`, Flash = `gemini-3-flash-preview`.

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro (LLM).
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- **h2 = trabalho do Lucas.** NUNCA remover/reescrever sem instrucao EXPLICITA.

## BACKLOG

→ `.claude/BACKLOG.md` (30 items; #30 prompt hardening NEW S191)

## CLEANUP PENDENTE

- `.claude/workers/`: workers de S178 + S181. Lucas decide manter/remover.

## FLAG — s-contrato precisa update

`02-contrato.html` menciona slides demolidos (s-aplicabilidade, s-absoluto). Lucas decide se atualiza.

---
Coautoria: Lucas + Samoel Masao + Opus 4.6 | S192 2026-04-14
