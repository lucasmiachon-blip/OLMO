# HANDOFF - Proxima Sessao

> S239 partial: C4.6 hotfix closed audit Items 2+3+10 (`9da4f30` — gamut sRGB + APCA + ADR re-scope) + C5 Day 2 Grupo A complete + Grupo B parcial (motion.js + reveal.js + mock edits) em progresso. Pendente C5: deck.js + presenter-safe.js + presenter-safe.css + dialog.html + **ensaio HDMI residencial obrigatório**. Deadline 30/abr/2026 (T-8d).

## HYDRATION (obrigatória, 3 passos)

1. Ler este HANDOFF completo.
2. `git log --oneline -10` — confirma últimos commits (S239: C4.6 `9da4f30` + C5 partial `<hash>`; S238: `4b9b80c`/`815f6f1`/`161703e`; S237: C4 `a95a18d`).
3. Prosseguir C5 completion em ordem: deck.js → presenter-safe.js → presenter-safe.css → dialog.html → ensaio HDMI. Se ensaio falha = HALT antes de commit final C5.

---

## P0 — shared-v2 + grade-v2 + qa-pipeline v2 (deadline 30/abr/2026)

### P0a C5 — shared-v2 Day 2 (PARCIAL — em progresso)

**DONE (Grupo A + Grupo B parcial, commit S239 partial):**
- `motion/tokens.css` + `motion/transitions.css` (5 distance + 3 stagger + @starting-style + VT gate)
- `js/motion.js` (animate() + transition() duck-mock fallback + prefersReducedMotion() cached matchMedia)
- `js/reveal.js` (setupReveal + revealAll + resetReveal via IntersectionObserver + stagger index `:scope >`)
- `css/index.css` edits (`@layer motion` entre components/utilities + 2 `@import`)
- `_mocks/{hero,evidence}.html` data-reveal + script module inline

**PENDENTE (Grupo B final + Grupo C + ensaio):**
- `js/deck.js` (nav keybindings + hashchange/popstate + aria-live announcer)
- `js/presenter-safe.js` (?lock=1 letterbox + ResizeObserver clamp 0.5-2.5; ?safe=1 → `html[data-reduced-motion="forced"]`)
- `css/presenter-safe.css` (letterbox box-shadow 100vmax + transform origin)
- `_mocks/dialog.html` (arquétipo 2-coluna via `.cols`)
- **ENSAIO HDMI RESIDENCIAL OBRIGATÓRIO** — Extend (não Duplicate), mudar resolução externa, console logs [presenter-safe] scale clamped, teclas B/?/F, screenshots em `_mocks/hdmi-rehearsal/`. Falha = HALT + corrige + repete.

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
- `content/aulas/shared-v2/tokens/` — 3 arquivos calibrados pelo Lucas + re-gamut S239 C4.6
- `.claude/plans/S239-C5-continuation.md` — **specs completos C5 pendente (deck.js + presenter-safe + dialog + ensaio HDMI) — ler primeiro pós-/clear**
- `.claude/plans/snoopy-bubbling-moore.md` — audit S239 evidence (retained)
- `.claude/plans/archive/foamy-wiggling-hartmanis.md` — S237 C4 close plan (histórico)

---

## S238-239 residual (auditoria adversarial 13-item — encerrada)

- **Item 1** at-rules order: fechado S238 `4b9b80c`.
- **Items 2, 3, 10:** fechados S239 C4.6 `9da4f30` (gamut chroma-only bisection + APCA 4 fixes + ADR re-scope).
- **Items 4, 5, 7, 8, 9, 11, 12, 13:** PASS em ambas auditorias.
- **Item 6** (`--chip-padding: 0.25rem 0.65rem` literal em components.css): deferred (confidence 0.8, candidate S240+).
- **Expanded coverage S239:** Item 3 audit original 11 pares → 28 pares auditados; 2 FAILs adicionais (slide-body + case-panel-body em bg não-canvas) fixed via semantic switch (text-body → text-emphasis).
- **Slide-rule E22** (@import order lint): deferido para ciclo separado.
- **TTL auto `.claude-tmp/` via Stop hook:** deferido (requer settings.json, self-mod).
- **Fechamento deny-list `node -p`:** deferido (equivalente a -e, self-mod).

## Estado factual

- **Git HEAD:** será preenchido com hash do commit C5 partial S239 (sequência após `9da4f30`).
- **Aulas:** cirrose 11 slides produção + shared/; metanalise 19 slides QA 3/19; grade-v2 scaffold pendente (C6); grade-v1 archived.
- **shared-v2:** Day 1 DONE + C4.6 audit fixes DONE; Day 2 Grupo A + Grupo B parcial (motion.js + reveal.js + mocks data-reveal) DONE; deck.js + presenter-safe.js + presenter-safe.css + dialog.html + ensaio HDMI pendentes.
- **`.claude-tmp/`:** scratchpad convencionado (gitignored); audit S239 manteve evidence em `.claude/plans/snoopy-bubbling-moore.md` (plan file retained).
- **R3 Clínica Médica:** 222 dias (Dez/2026). Setup infra em 0.
- **Deadline GRADE v2:** 30/abr/2026 quinta-feira. T-8d.

Coautoria: Lucas + Opus 4.7 (Claude Code) + Codex CLI (audit external) | S239 C4.6 + C5 partial | 2026-04-22
