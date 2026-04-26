# Plan — C5 shared-v2 Day 2 continuation (post-/clear hydration)

## Context

S239 committed C4.6 hotfix (`9da4f30`) + C5 Grupo A complete + Grupo B parcial (motion.js + reveal.js + mock edits em commit S239 partial seguinte). Pendente: deck.js + presenter-safe.js + presenter-safe.css + dialog.html + ensaio HDMI obrigatório. Deadline 30/abr/2026 (T-8d).

**Escopo travado pelo brief C5 inicial + respostas Q1-Q7 + R1-R3 do usuário; não re-debater.** Este plan consolida decisões para hydration sem perda pós-/clear.

## API já exported (não redefinir)

### js/motion.js (~95 li — committed)
- `animate(el, keyframes, options) -> Promise` — WAAPI wrapper. Reduced-motion: aplica final state via el.style + Promise.resolve().
- `transition(callback) -> ViewTransition | duck-mock` — VT wrapper. Fallback retorna `{finished, ready, updateCallbackDone}` (3 Promises resolvidas).
- `prefersReducedMotion() -> boolean` — cached matchMedia + `html[data-reduced-motion="forced"]` check.
- Default export: `{animate, transition, prefersReducedMotion}`.

### js/reveal.js (~90 li — committed)
- `setupReveal(root=document)` — scan `[data-reveal]` + IntersectionObserver setup + applyStagger.
- `revealAll(slide)` — força `.revealed` em todos `[data-reveal]` + unobserve.
- `resetReveal(slide)` — remove `.revealed` + re-`observe()`.
- Default export: `{setupReveal, revealAll, resetReveal}`.
- Stagger: `data-reveal-stagger="fast|base|slow"` auto-cumulative via `:scope >` sibling index. Escape hatch: `data-reveal-delay="<raw>"`.

## Pendentes (próximos em ordem)

### 1. js/deck.js (~135 li)

**API:**
- `setupDeck({slidesSelector='[data-slide]'})` — DOMContentLoaded
- `nextSlide / prevSlide / firstSlide / lastSlide / goToSlide(key)`

**Keybindings:**
- `ArrowRight`, `Space`, `PageDown` → next
- `ArrowLeft`, `PageUp` → prev
- `Home` → first; `End` → last
- `F`, `B`, `?` → **presenter-safe.js EXCLUSIVE** (deck.js NÃO intercepta)
- `Esc` → reservado futuro
- Skip se modifier (ctrl/alt/meta) ou input/textarea/contenteditable focus

**Hash/popstate:** `location.hash = '#{data-slide}'`. history.pushState em nav. hashchange + popstate ambos listeners (redundância; setActive idempotente).

**Visibility:** `[hidden]` attribute (semantic + ARIA-tree removal).

**Announcer:** `aria-live="polite" aria-atomic="true"` container criado inline via JS (sr-only styled, zero surface CSS extra). Anuncia `"Slide X de Y: {título}"` em nav. Título query: `h1, h2, .slide-headline, .slide-claim`.

**Integração:** `import {revealAll, resetReveal} from './reveal.js'` + `import {transition} from './motion.js'`. `setActive()` envolve DOM mutations (hidden toggle + reveal reset) em `transition(() => {...})` para VT API fotografar corretamente.

### 2. js/presenter-safe.js (~80 li)

**Setup (DOMContentLoaded):**
- `new URLSearchParams(location.search)` (não regex)
- `get('lock') === '1'` → `document.documentElement.setAttribute('data-presenter-mode', 'locked')`
- `get('safe') === '1'` → `document.documentElement.setAttribute('data-reduced-motion', 'forced')` (motion.js respeita)

**Letterbox wrapper (lock mode):**
- Element `#deck-wrapper` (ou similar) 1280×720 fixed centered via translate+scale
- `box-shadow: 0 0 0 100vmax #000` aplicado **no wrapper, NÃO body** (se body: tela inteira preta, letterbox invisível)
- Scale via `--deck-scale` CSS custom property

**ResizeObserver:**
- Observa `document.documentElement` (ou body — ResizeObserver NÃO observa window)
- `rawScale = Math.min(viewportWidth/1280, viewportHeight/720)`
- `clamped = Math.max(0.5, Math.min(2.5, rawScale))`
- `document.documentElement.style.setProperty('--deck-scale', clamped)`
- `console.warn('[presenter-safe] scale clamped', {raw, clamped})` se `raw !== clamped`

**Redundant listeners (HDMI):**
- `screen.orientation?.addEventListener('change', recompute)` (optional chain — Safari gap)
- `matchMedia('(orientation: landscape)').addEventListener('change', recompute)`

**Keybindings (LOCK MODE ONLY — listener adicionado apenas se lock=1):**
- `F` → toggle fullscreen via `requestFullscreen()` / `document.exitFullscreen()`
- `B` → toggle blackout overlay (fullscreen div `#000`)
- `?` (shift+/) → toggle help overlay listing keybindings
- Listener distinto do deck.js; nenhum conflito por design

**?lock=1 + ?safe=1 = apresentação real.**

### 3. css/presenter-safe.css (~40 li)

Scope: `html[data-presenter-mode="locked"]`.

**Wrapper:**
```css
html[data-presenter-mode="locked"] #deck-wrapper {
  position: fixed;
  top: 50%;
  left: 50%;
  width: 1280px;
  height: 720px;
  translate: -50% -50%;
  transform: scale(var(--deck-scale, 1));
  transform-origin: center center;
  box-shadow: 0 0 0 100vmax oklch(0% 0 0);
  z-index: var(--z-presenter);  /* 9999 em reference.css */
  overflow: hidden;
}
```

**Blackout overlay:** `display: none` default; class `.blackout-active` → fullscreen cover.

**Help overlay:** similar toggle, texto listando keybindings, center.

### 4. _mocks/dialog.html (~40 li)

Arquétipo 2-coluna comparação via `.cols` primitive. Conteúdo clínico plausível (não Lorem):
- Tema: **Clopidogrel vs Aspirina — MACE 30d pós-SCA** (reusa narrativa Valgimigli sem copiar números)
- Estrutura: `<h2 class="slide-claim">` comparativa + `<div class="cols">` com 2 `<aside class="evidence">` (esq: clopidogrel, dir: aspirina) + chips GRADE (high + mod) no `.cluster` final.
- `data-reveal` com `stagger="base"` nos elements principais.
- `<script type="module">` com setupReveal + setupDeck + (presenter-safe auto-run sem export).

### 5. index.css edits finais

Adicionar:
- `@import url("../css/presenter-safe.css") layer(utilities);` (ou nova `layer(presenter)` se preferir distinguir)
- Mocks atualizam com `<script type="module">` importando deck.js + reveal.js + presenter-safe.js conforme necessidade

### 6. Ensaio HDMI (protocolo Q7 — MANDATORY antes de commit C5)

**Pré-ensaio:** `npm run dev:shared-v2` (port 4103).

**Checklist:**
1. Abrir `http://localhost:4103/_mocks/dialog.html?lock=1&safe=1` em laptop
2. Conectar monitor HDMI externo (TV residencial)
3. **`Win+P → Extend`** (NÃO Duplicate — mascara bug de resolução)
4. Observar letterbox + conteúdo escala. **Screenshot #1** (initial state)
5. Mudar resolução do monitor externo (Configurações de Tela ou reconectar)
6. Observar console `[presenter-safe] scale clamped` logs. **Screenshot #2 pré, #3 pós-clamp**
7. Toggle reduced-motion OS (`Win+U` → animações OFF). Verificar motion.js guard respeita. **Screenshot #4**
8. Testar teclas presenter-safe: `F` fullscreen, `B` blackout, `?` help overlay
9. Testar teclas deck nav: arrows, Space, PageDown/Up, Home, End
10. Screenshots salvos em `_mocks/hdmi-rehearsal/` (commitado com C5 OU embedded em commit message)

**Critério de aceite:** qualquer falha (letterbox some, scale degenera, ResizeObserver não dispara, motion escapa guard, tecla não responde) = **HALT**. Corrige, **repete ensaio do ZERO**. Sem passada limpa end-to-end ≠ commit C5. Este ensaio substitui o que não foi feito antes da metanalise.

## Non-goals C5 (não expandir)

- Named slide→slide View Transitions (Q2: cross-fade root é suficiente)
- Overview mode via `Esc` (reservado futuro)
- Helpers `fadeIn`/`slideUp` em motion.js (mantém-se em slide-registry futuro)
- Grade-v2 scaffold (C6)
- qa-pipeline v2 (C7)
- `--chip-padding` literal (Item 6 audit deferido)

## Evidência

- Audit adversarial shared-v2 13-item: `.claude/plans/snoopy-bubbling-moore.md` (retained como audit evidence)
- Commits: S239 C4.6 `9da4f30`; S239 C5 partial `<hash>` (após este commit docs)
- ADR: `docs/adr/0005-shared-v2-greenfield.md` §Phases C4/C5 re-scoped em C4.6
- README: `content/aulas/shared-v2/README.md` (doutrina de consumo)
