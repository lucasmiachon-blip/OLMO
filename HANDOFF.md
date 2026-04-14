# HANDOFF - Proxima Sessao

> Sessao 194 | pos hooks Fase 1

## ESTADO ATUAL

Monorepo funcional. Build PASS (**17 slides** metanalise).
**Agentes: 10 (hardened S192).** **Hooks: 37 (-1 dead code).** **Rules: 11.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 19 (+KBP-19 S193).** **Skills: 22 project + 3 user.** **Memory: 20/20.** **Backlog: 30 items.**

## P0 — s-tipos-ma (evidence DONE S187, slide PENDENTE)

- Evidence `evidence/s-tipos-ma.html`: 16 refs VERIFIED + 1 book, ~480 linhas.
- **Pendente:** Lucas decide quantos slides, posicao no manifest, h2.

## P1 — Hooks Fase 2 (consolidacao)

- Plano completo em `.claude/plans/polished-wibbling-cloud.md`
- Merge 3 Write|Edit guards → 1, 3 PostToolUse Bash → 1, 2 PreToolUse Bash → 1, 7 Stop → 2-3
- guard-worker-write.sh ainda tem 3-4 node spawns (unico nao migrado Fase 1)
- Estimativa: 37→~22 hooks, 0-1 node spawns por Edit

## P1 — Prompt hardening propagacao (backlog #30)

## P1 — /insights stale (39 sessoes atras, last S154)

## DECISOES ATIVAS

- Gemini QA temp = 0.2. Format C+ pointer-only. OKLCH obrigatorio.
- Living HTML = source of truth. Benchmark CSS = `pre-reading-heterogeneidade.html` (READ-ONLY).
- Agent effort: max (degrada para high em Sonnet/Haiku).
- Hook scripts: Edit BLOCK + deploy via Write→cp (guard-bash-write asks). Settings: Edit ASK.

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro (LLM).
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- **h2 = trabalho do Lucas.** NUNCA remover/reescrever sem instrucao EXPLICITA.

## BACKLOG

→ `.claude/BACKLOG.md` (30 items)

## CLEANUP PENDENTE

- `.claude/workers/`: S178 + S181. Lucas decide.
- `02-contrato.html` menciona slides demolidos.
- `.claude/plans/`: groovy-fluttering-bunny.md (S193 rascunho), polished-wibbling-cloud.md (S193 Fase 1-3 plano ativo).

---
Coautoria: Lucas + Opus 4.6 | S193 2026-04-14
