# HANDOFF - Proxima Sessao

> Sessao 209 | Continuacao system-maturity Fase 1.

## ESTADO ATUAL

Monorepo funcional. Build PASS (**17 slides** metanalise).
**Agentes: 10.** **Hooks: 29.** **Rules: 5 (era 13).** **MCPs: 3 ativos + 9 frozen.** **KBPs: 21.** **Skills: 22 project + 3 user.** **Memory: 20/20.** **Backlog: 33 items (7 resolved).**

## P0 — System Maturity (S208 FEITO, Fase 1 completa)

**Rules reduction:** 1,102 → 315 linhas, 13 → 5 files (-71%).
- T2 unconditional: `anti-drift.md` (60 li), `known-bad-patterns.md` (73 li)
- T3 path-scoped: `slide-rules.md` (82 li), `design-reference.md` (51 li), `qa-pipeline.md` (49 li)
- T4 reference: `docs/aulas/slide-advanced-reference.md` (conhecimento tecnico migrado)
- Deletados: coauthorship, notion-cross-validation, mcp_safety, multi-window, proven-wins, session-hygiene, elite-conduct, slide-patterns

**Pendente Fase 1b — segundo passe (constraints-only):**
- Rules 315 → ~180: mover templates, tabelas, checklists de rules para T4 reference
- Manter SOMENTE constraints (proibicoes, gates) nos 3 files path-scoped

**Pendente Fase 2 (S209+):**
- Hookify: instalar e avaliar
- CSS verification loop (Boris pattern: edit→build→screenshot→verify)
- export-png.mjs (Playwright 1920x1080, substitui PDF)
- Baseline metrics: 0 novos raw px/sessao, rules <300
- `assets/` root: caminho canonico pendente

## P0 — Pendentes Anteriores

- s-quality: evidence HTML integration + narrativa pendente
- s-tipos-ma: slide PENDENTE (Lucas decide quantos, posicao, h2)
- drive-package: PDF stale, PNG export pendente
- Apresentacao S208: PDF cortou slides, HDMI comprimiu janela

## P1

- Wallace CSS-wide: 29 font-sizes raw, #162032 sem token, 20 !important
- TREE.md desatualizado (S93 → S208)
- Sentinel agent improvement (backlog #31)

## DECISOES ATIVAS

- Gemini QA temp: 1.0, topP 0.95. OKLCH obrigatorio.
- Living HTML = source of truth. Agent effort: max.
- CMMI maturity model. Hooks = freio (L2). Verification loops = melhoria (L3+).

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro.
- npm scripts: rodar de `content/aulas/`. h2 = trabalho do Lucas.

---
Coautoria: Lucas + Opus 4.6 | S208 2026-04-15
