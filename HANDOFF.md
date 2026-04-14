# HANDOFF - Proxima Sessao

> Sessao 197 | Audit-driven fixes DONE, backlog atualizado

## ESTADO ATUAL

Monorepo funcional. Build PASS (**17 slides** metanalise).
**Agentes: 10.** **Hooks: 29 registros, 29 scripts.** **Rules: 13.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 19.** **Skills: 22 project + 3 user.** **Memory: 20/20.** **Backlog: 32 items (4 resolved S196).**

## P0 — s-tipos-ma (evidence DONE S187, slide PENDENTE)

- Evidence `evidence/s-tipos-ma.html`: 16 refs VERIFIED + 1 book, ~480 linhas.
- **Pendente:** Lucas decide quantos slides, posicao no manifest, h2.

## P1 — Audit deferred items

- 4 scripts com node→jq pendente (backlog #32)
- guard-lint-before-build: hardcoded absolute path (backlog #32 ou fix avulso)
- Sentinel quality improvement (backlog #31)
- Orchestration audit re-run (S196 truncou)

## P1 — Prompt hardening propagacao (backlog #30)

## P1 — /insights stale (40+ sessoes atras, last S154)

## DECISOES ATIVAS

- Gemini QA temp = 0.2. Format C+ pointer-only. OKLCH obrigatorio.
- Living HTML = source of truth. Benchmark CSS = `pre-reading-heterogeneidade.html` (READ-ONLY).
- Agent effort: max (degrada para high em Sonnet/Haiku).
- Hook scripts: Edit BLOCK + deploy via Write→cp (guard-bash-write asks). Settings: Edit ASK.
- **Elite-conduct loop:** `.claude/rules/elite-conduct.md` (promoted S195).
- **Proven-wins rule:** `.claude/rules/proven-wins.md` — maturity tiers (unaudited→proven). Audit antes de confiar.

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro (LLM).
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- **h2 = trabalho do Lucas.** NUNCA remover/reescrever sem instrucao EXPLICITA.
- **Sentinel claims: verificar antes de agir.** S196: 1 FP (apl-cache-refresh), 1 truncado.

## BACKLOG

→ `.claude/BACKLOG.md` (32 items, 6 resolved)

## CLEANUP PENDENTE

- `.claude/workers/`: S178 + S181. Lucas decide.
- `02-contrato.html` menciona slides demolidos.

---
Coautoria: Lucas + Opus 4.6 | S196 2026-04-14
