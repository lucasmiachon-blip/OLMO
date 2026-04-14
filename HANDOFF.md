# HANDOFF - Proxima Sessao

> Sessao 195 | Hooks Fase 2 parcial (3/5 steps)

## ESTADO ATUAL

Monorepo funcional. Build PASS (**17 slides** metanalise).
**Agentes: 10.** **Hooks: 34 registros, 34 scripts (era 37).** **Rules: 11.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 19.** **Skills: 22 project + 3 user.** **Memory: 20/20.** **Backlog: 30 items.**

## P0 — s-tipos-ma (evidence DONE S187, slide PENDENTE)

- Evidence `evidence/s-tipos-ma.html`: 16 refs VERIFIED + 1 book, ~480 linhas.
- **Pendente:** Lucas decide quantos slides, posicao no manifest, h2.

## P1 — Hooks Fase 2 (steps 4-5 pendentes)

- Plano ativo: `.claude/plans/crispy-munching-blum.md`
- **DONE:** Step 1 (PostToolUse .* 2→1), Step 2 (Write|Edit 3→1 + 4 node→0), Step 3 (guard-secrets node→jq)
- **PENDENTE:** Step 4 (PostToolUse Bash 3→1, script ja escrito nao deployado), Step 5 (Stop 7→4)
- Divergencia do plano original: guard-secrets + guard-bash-write mantidos separados (nao-elite merge)
- Projecao final: 34→29 registros quando steps 4-5 completos

## P1 — Prompt hardening propagacao (backlog #30)

## P1 — /insights stale (40 sessoes atras, last S154)

## DECISOES ATIVAS

- Gemini QA temp = 0.2. Format C+ pointer-only. OKLCH obrigatorio.
- Living HTML = source of truth. Benchmark CSS = `pre-reading-heterogeneidade.html` (READ-ONLY).
- Agent effort: max (degrada para high em Sonnet/Haiku).
- Hook scripts: Edit BLOCK + deploy via Write→cp (guard-bash-write asks). Settings: Edit ASK.
- **Elite-conduct loop:** antes de implementar, refletir "isso e conduta de elite?" Se sim, implementar.

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro (LLM).
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- **h2 = trabalho do Lucas.** NUNCA remover/reescrever sem instrucao EXPLICITA.

## BACKLOG

→ `.claude/BACKLOG.md` (30 items)

## CLEANUP PENDENTE

- `.claude/workers/`: S178 + S181. Lucas decide.
- `02-contrato.html` menciona slides demolidos.

---
Coautoria: Lucas + Opus 4.6 | S194 2026-04-14
