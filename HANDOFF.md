# HANDOFF - Proxima Sessao

> S238 closed: hotfix C4.5 (@import order) + transient compute override. shared-v2 Day 1 agora spec-compliant. Audit adversarial Item 1/13 fechado; Items 2-13 pendentes. Próximo: C5 Day 2 (motion + JS + ensaio HDMI) OU continuação audit Items 2-13 (via `.claude-tmp/`). Deadline 30/abr/2026 (T-9d).

## HYDRATION (obrigatória, 3 passos)

1. Ler este HANDOFF completo.
2. `git log --oneline -10` — confirma últimos commits (S238: B `4b9b80c` hotfix @import, A `815f6f1` CLAUDE.md override, docs S238; S237: C1-C4 + archive + refresh).
3. Escolher: **(a)** C5 Day 2 (motion + JS + ensaio HDMI), **(b)** continuação audit shared-v2 Items 2-13 (OKLCH gamut + APCA + fluid type + skip-chain + etc — usa `.claude-tmp/`), **(c)** C6 grade-v2 scaffold, **(d)** C7 qa-pipeline v2. Ordem canônica: a→b→c→d.

---

## P0 — shared-v2 + grade-v2 + qa-pipeline v2 (deadline 30/abr/2026)

### P0a C5 — shared-v2 Day 2 (PRÓXIMO)

- `content/aulas/shared-v2/motion/tokens.css` + `motion/transitions.css`
- `content/aulas/shared-v2/js/motion.js` (WAAPI helpers + VT wrapper + reduced-motion guard)
- `content/aulas/shared-v2/js/deck.js` (navegação, keybindings, hashchange)
- `content/aulas/shared-v2/js/presenter-safe.js` (?lock=1 letterbox + ResizeObserver clamp)
- `content/aulas/shared-v2/js/reveal.js` (data-reveal declarativo)
- `content/aulas/shared-v2/css/presenter-safe.css`
- `content/aulas/shared-v2/_mocks/dialog.html`
- **ENSAIO HDMI RESIDENCIAL OBRIGATÓRIO** antes de commit C5 — testa presenter-safe em monitor externo com mudança de resolução.

### P0b C6 — grade-v2 scaffold

`content/aulas/grade-v2/` com slides/ + evidence/ + exports/ + qa-rounds/ + variants/ + CLAUDE.md + HANDOFF.md + CHANGELOG.md + _manifest.js 18 slots placeholder + grade-v2.css mínimo.

### P0c C7 — qa-pipeline v2 Gate 0+1

`content/aulas/scripts/qa-pipeline/` com index.mjs + gate0-local.mjs + gate1-flash.mjs + shared/utilities + prompts/. Gate 2 Pro + Gate 3 Designer adiados (skippable via flag).

### P0.5 — QA editorial metanalise (paralelo)

16 slides pendentes (3/19 done). Usa qa-pipeline v2 quando Gate 0+1 operacional.

### P1 — R3 infra + Anki

Deferred pós-30/abr.

---

## Fallback multi-camada (ADR-0005 §D6)

- L0 Vite dev server (porta 4103 shared-v2 / 4100 cirrose / 4102 metanalise)
- L3 PDF em `{aula}/exports/` (DeckTape, fresh <24h, done-gate.js enforça)
- L4 PPTX em `{aula}/exports/` (manual primeiro, automatizado pós-30/abr)
- L2 GitHub Pages pós-30/abr

---

## Âncoras de leitura (sob demanda)

- `CLAUDE.md §ENFORCEMENT` — primacy anchor
- `.claude/rules/anti-drift.md` — propose-before-pour + EC loop + failure response
- `.claude/rules/slide-rules.md` — E07 + E20-E52
- `docs/adr/0004-grade-v1-archived.md` — rationale grade-v1 archive + 3-2-1 backup
- `docs/adr/0005-shared-v2-greenfield.md` — arquitetura shared-v2 + §Browser Targets + §A11y
- `content/aulas/shared-v2/README.md` — doutrina de consumo da biblioteca
- `content/aulas/shared-v2/tokens/` — 3 arquivos calibrados pelo Lucas (NÃO regenerar)
- `.claude/plans/archive/foamy-wiggling-hartmanis.md` — S237 C4 close plan (histórico)

---

## S238 residual (auditoria adversarial 13-item)

- **Item 1** at-rules order: FAIL crítico → fechado via commit B `4b9b80c`.
- **Items 2-13** pendentes (deferidos por escopo em S238): OKLCH gamut sRGB, APCA contrast, fluid type clamp math, skip-chain violations, hardcoded literals, seletores genéricos, branching em primitives, reduced-motion compliance, ADR vs realidade C4, colisão `.cols`, mocks compliance, git hygiene. Candidatos a retomada em S239+ via `.claude-tmp/` (scratchpad convencionado).
- **Slide-rule E22** (@import order lint): deferido para ciclo separado pós-push.
- **TTL auto `.claude-tmp/` via Stop hook:** deferido (requer edit settings.json, self-mod).
- **Fechamento deny-list `node -p`:** deferido (equivalente a -e, self-mod).

## Estado factual

- **Git HEAD:** será preenchido com hash do commit docs S238 (sequência após `815f6f1`).
- **Aulas:** cirrose 11 slides produção + shared/; metanalise 19 slides QA 3/19; grade-v2 scaffold pendente (C6); grade-v1 archived (branch `legacy/grade-v1` + tag `grade-v1-final` em `ccbaefe` + tar externo `C:\Dev\Projetos\OLMO_primo\grade-v1-qa-snapshot-2026-04-21.tar.gz`).
- **shared-v2:** tokens + type + layout + entry + mocks hero/evidence DONE, `@import` order fixed (S238 B). Motion + JS + dialog mock pendentes C5.
- **`.claude-tmp/`:** scratchpad dir operacional para transient compute (gitignored, ver CLAUDE.md §Transient compute).
- **R3 Clínica Médica:** 222 dias (Dez/2026). Setup infra em 0.
- **Deadline GRADE v2:** 30/abr/2026 quinta-feira. T-9d.

Coautoria: Lucas + Opus 4.7 (Claude Code) + Opus 4.7 (Claude.ai adversarial review) | S238 correcao_rota | 2026-04-21
