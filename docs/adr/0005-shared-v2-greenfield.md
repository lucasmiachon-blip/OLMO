# ADR-0005: shared-v2 Greenfield (não refactor incremental de shared/)

- **Status:** accepted
- **Data:** 2026-04-21
- **Deciders:** Lucas + Claude (Opus 4.7)
- **Sessão:** S237-Beggining_GRADE_V2

## Contexto

`content/aulas/shared/` é infra CSS/JS atual consumida por aulas cirrose (11 slides em produção) e metanalise (19 slides, 16 editorial pendentes). Tech debt acumulado:

- **`scaleDeck()` bug estrutural:** fórmula `Math.min(vw/1280, vh/720)` combinada com `zoom` CSS em certos paths de cascade produz double-scaling em aspect ratios não-16:9 (known issue pre-S237, mitigated ad-hoc por slide).
- **Stack aging:** deck.js + GSAP + archetype classes single-file não suportam fluid type (cqi), container queries, motion nativo (WAAPI), View Transitions API.
- **Presenter-safe gap:** sem isolation entre clipboard/notes do apresentador e DOM do slide (note-bleeding em apresentações HDMI reais).

S237 P0 define **grade-v2 greenfield** com stack target D2-D8: **tokens 3-camadas (primitives → semantic → component) + fluid type cqi + container queries + motion WAAPI + View Transitions + presenter-safe.js**. Essa expansão é incompatível com `shared/` atual sem refactor massivo.

Deadline grade-v2 é **30/abr/2026 (T-9d)**; budget apertado aumenta custo relativo de refactor sustentado (debug + regression risk em cirrose/metanalise ativas).

## Decisão

Criar `content/aulas/shared-v2/` **greenfield**, paralelo a `shared/` atual (não substituição imediata).

- `shared/` **intocada** durante dev grade-v2. Cirrose + metanalise continuam consumindo `shared/` sem regression.
- `shared-v2/` nasce com stack target D2-D8; freedom de redesign de primitives sem backward-compat constraint.
- grade-v2 é **first consumer** de shared-v2 (validação empírica em aula nova antes de migração).
- Migration `shared/ → shared-v2/` de cirrose + metanalise **pós-30/abr**, após shared-v2 validado em grade-v2.

### Phases (scheduled)

| Commit | Scope |
|---|---|
| **C4** | shared-v2 Day 1 — tokens 3-camadas + fluid type scale cqi + layout primitives container queries + 2 mocks (hero, evidence); motion + dialog mock adiados para C5 (requer JS coupling) |
| **C5** | shared-v2 Day 2 — motion/tokens.css + motion/transitions.css + js/motion.js + dialog.html mock (originalmente planejado C4, re-scoped por coupling com JS layer) + deck-v2.js (substitui deck.js sem scaleDeck bug) + presenter-safe.js (clipboard/notes isolation) + reveal-v2.js (WAAPI-based reveal primitives) + ensaio HDMI residencial com mocks |

## Consequências

### Positivas

- **`scaleDeck()` bug eliminado by design:** stack novo não depende de CSS `zoom` double-scaling; fluid type cqi + container queries substituem lógica quebrada.
- **Freedom de redesign de primitives:** sem constraint de backward-compat com `shared/` legacy.
- **Incremental migration isolada:** cirrose + metanalise migram uma de cada vez pós-validação grade-v2, com rollback barato (`shared/` ainda existe).
- **grade-v2 é proving ground:** valida shared-v2 em aula nova antes de aplicar em produção (reduz blast radius).

### Negativas

- **Dupla manutenção temporária:** `shared/` + `shared-v2/` paralelos durante fase grade-v2 + migration (~2 meses estimados). Bugs em `shared/` ainda precisam fix até migration complete.
- **Risco de drift/abandonment:** se migration não for priorizada pós-grade-v2, `shared-v2/` vira tech debt paralelo (2 sistemas, nenhum canônico).
- **Upfront cost 2 dias (C4+C5):** orçamento sai do budget de 9d total grade-v2.

## Alternativas consideradas

1. **Refactor incremental de `shared/`** — rejected. Debug `scaleDeck` + stack upgrade simultâneos em codebase ativa (cirrose/metanalise) custaria debug sustentado sem isolamento. 9d budget insuficiente para refactor cross-cutting.
2. **Greenfield substituindo `shared/` imediatamente (nuke + replace)** — rejected. Quebra cirrose + metanalise antes de validação empírica do stack novo (16 slides editorial pendentes em metanalise não podem ficar bloqueados).
3. **Fork `shared/` + evolve (shared/ permanece, shared-evolved/ branch)** — rejected. Mesmo tech debt renomeado; estrutura nova não cresce desde primitives.
4. **Adotar framework externo (Astro/Slidev/Reveal.js)** — rejected. Stack proprietário OLMO tem customizações profundas (OKLCH tokens + slide-rules.md discipline + CSS scoping E07/E20-E52); framework externo imporia convenções incompatíveis.

## Ref cruzada

- `.claude/plans/foamy-wiggling-hartmanis.md` (S237 plan file origin)
- `HANDOFF.md §P0b shared-v2 greenfield` (scope reference pós-C1)
- `.claude/BACKLOG.md #53 shared-v2 greenfield` (tracking)
- `ADR-0004` (archive policy predecessor — grade-v1 archived neste ciclo)
- Commits C4 + C5 (execution, pendentes)

## Enforcement

- **`shared/` intocada** até migration formal pós-30/abr; qualquer Edit em `shared/` requer OK explícito Lucas + justificativa (rollback-only).
- Novos aulas (pós-grade-v2) usam **shared-v2 exclusivamente**.
- Aulas existentes (cirrose, metanalise) migrate incremental; migration commit requer **§Migration section** no CLAUDE.md da aula especificando breaking changes + rollback path.
- Se C5 ensaio HDMI residencial falhar, shared-v2 é rejeitada e grade-v2 faz fallback para `shared/` (rollback point).

## Browser Targets

Baseline: evergreen 2024+ (Chromium/WebKit/Gecko). Chrome 121+ target efetivo para stack completo. `@supports` gates cobrem ausência de features:

- View Transitions API (Chrome 111+) → fallback cut instantâneo entre slides
- `@starting-style` (Chrome 117+) → fallback snap reveal inicial
- Container queries + cqi (Chrome 105+) → baseline estável, sem fallback necessário
- WAAPI `Element.animate()` (universal desde Chrome 36+) → baseline

Browser muito antigo ou totalmente incompatível = fallback via PDF (L3 build export) ou PPTX (L4 export). `done-gate.js` enforça exports frescos <24h per HANDOFF §D6. Validação prática no ensaio HDMI residencial (C5 Day 2): laptop HC-FMUSP institucional é unknown version; ensaio proxy define se shared-v2 é viável ou se grade-v2 faz fallback para `shared/` legacy.

## A11y

`prefers-reduced-motion: reduce` **obrigatório e não-negociável**:

- Neutralização em `tokens/system.css` via `@media (prefers-reduced-motion: reduce)` block: todas durations `--motion-*-dur` colapsam para `--dur-instant`.
- JS layer (C5) consulta `window.matchMedia('(prefers-reduced-motion: reduce)').matches` antes de qualquer `element.animate()`.

Fundamento: 60 residentes no auditório ⇒ estatisticamente presentes pessoas com vestibular disorders / ansiedade / epilepsia fotossensível. Omitir reduction em código novo 2026 = WCAG 2.2 AA violation + falha grosseira editorial.

APCA contrast:
- Body text sobre `--surface-canvas`: Lc ≥ 75 (validated via semantic hierarchy neutral-7 → neutral-1).
- On-solid text sobre state solids: Lc ≥ 60 via `--warning-on-solid` explícito (P1 fix S237 C4).
