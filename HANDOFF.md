# HANDOFF - Proxima Sessao

> S237 mid-execution: C1-C4 committed. shared-v2 Day 1 (tokens + type + layout + mocks) operacional em porta 4103. Próximo: C5 Day 2 (motion CSS + JS layer + dialog mock + ensaio HDMI residencial). Deadline 30/abr/2026 (T-9d).

## HYDRATION (obrigatória, 3 passos)

1. Ler este HANDOFF completo.
2. `git log --oneline -10` — confirma últimos commits S237 (C1 state refresh, C2 grade-v1 archive, C3 ADRs 0004+0005, C4 shared-v2 Day 1, chore archive plan, docs refresh).
3. Escolher: **(a)** C5 Day 2 (motion + JS + ensaio HDMI), **(b)** C6 grade-v2 scaffold, **(c)** C7 qa-pipeline v2. Ordem canônica: a→b→c.

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

## Estado factual

- **Git HEAD:** `<hash pós-commit docs>` (preencher após commit docs — será [hash3] na sequência S237).
- **Aulas:** cirrose 11 slides produção + shared/; metanalise 19 slides QA 3/19; grade-v2 scaffold pendente (C6); grade-v1 archived (branch `legacy/grade-v1` + tag `grade-v1-final` em `ccbaefe` + tar externo `C:\Dev\Projetos\OLMO_primo\grade-v1-qa-snapshot-2026-04-21.tar.gz`).
- **shared-v2:** tokens + type + layout + entry + mocks hero/evidence DONE. Motion + JS + dialog mock pendentes C5.
- **R3 Clínica Médica:** 223 dias (Dez/2026). Setup infra em 0.
- **Deadline GRADE v2:** 30/abr/2026 quinta-feira. T-9d.

Coautoria: Lucas + Opus 4.7 (Claude Code) + Opus 4.7 (Claude.ai adversarial review) | S237 mid-execution | 2026-04-21
