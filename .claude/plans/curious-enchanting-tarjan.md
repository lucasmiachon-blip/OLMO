# Plan: Refactor architectural s-quality + s-forest1 + s-forest2 (S264 — execução pós-clear)

> **Status (2026-04-27 S265):** Phase 1 dead-code cleanup committed `ac65ba6` (S264). **Phase A done S265** (uncommitted): wrapper `.term-content-block` resolve overflow vertical s-quality + quick wins contraste (chips 30%, label emphasis, borders 80%). **Phases B-G remain** (s-forest1/s-forest2). lint+build PASS. Lucas validou visualmente.

---

## 🔥 HIDRATAÇÃO próxima sessão (3 passos exatos)

1. **Read este plan inteiro:** `.claude/plans/curious-enchanting-tarjan.md`
2. **Confirm vite up** (Lucas owns): `npm --prefix content/aulas run dev:metanalise` (port 4102 strictPort) — outra janela pode tê-lo
3. **Start Phase A** (s-quality layout fix). Sequência sequencial: A → B → C → D → E → F → G. KBP-05 anti-batch entre slides na Phase F.

**Cross-window:** janela paralela = bench S264 P0 (`splendid-munching-swing.md` + `sleepy-wandering-firefly.md` + `archive/S259-jazzy-sniffing-rabbit.md` archived S265). Confirmado no-conflict: jazzy L31-32 declarou "s-forest1/2: Não tocar". s-quality não mencionado em planos da outra janela. Refactor seguro.

**Branch atual:** `main` · **Last commit:** `ac65ba6 feat(metanalise/S264): Phase 1 — dead-code cleanup s-absoluto + KBP-44`

---

## Sessão

- **Nome:** `qa-editorial-metanalise` (manter pós-clear via `.claude/.session-name`)
- **Foco operacional:** refactor architectural batch (3 slides) → QA cycle (3 slides) → commit + close
- **Phase 1 já comittada:** `ac65ba6` (12 files, +175/-24 — dead-code s-absoluto cleanup categorias A+B + KBP-44 fix `08a-forest1.html:34`)

---

## Context — 6 issues numerados (Lucas turn 7 da sessão atual)

| # | Issue | Slide(s) | Layer | Phase |
|---|-------|---------|-------|-------|
| 1 | `.term-dissociation` desaparece (overflow vertical clipa) — encapsular `.term-grid` + `.term-dissociation` em wrapper grid `1fr auto` | s-quality | HTML + CSS | A |
| 2 | Tokens vs oklch hardcoded + glassmorphism `.forest-annotated` premium card | s-forest1, s-forest2 | CSS | C.1 |
| 3 | Zoom RoB beat 8 architectural — verificar target container pai + aspect-ratio rígido | s-forest2 | CSS + JS | C.2 |
| 4 | Calibração via `calibrate-boxes.mjs` (anti-chute, percentagens reais Playwright) | s-forest2 | CSS run-driven | B |
| 5 | Rodapé seguro — grid `1fr auto` isolando figura central de MA-stat + Cochrane logo | s-forest2 | HTML + CSS | C.3 |
| 6 | Motion staggering — `stagger: 0.1` + `ease: power2.out` + cascata, não pisca | 3 slides | JS (slide-registry.js) | D |

Após refactor → QA cycle (preflight → inspect → editorial) per slide.

---

## Diff antes de cada Edit (regra cardinal Lucas)

1. Read full file (ou range ± 20 li) — KBP-25
2. Apresento `old_string` + `new_string` na proposta
3. Lucas OK por edit (ou batch coerente)
4. Execute Edit
5. Status post-edit

---

## Tokens disponíveis (verified via `shared/css/base.css`)

| Token | File:line | Valor | Uso refactor |
|-------|-----------|-------|--------------|
| `--shadow-subtle` | base.css:99 | `oklch(0% 0 0 / 0.04)` | premium card box-shadow |
| `--shadow-soft` | base.css:100 | `oklch(0% 0 0 / 0.06)` | hairline border |
| `--overlay-border` | base.css:101 | `oklch(0% 0 0 / 0.08)` | forest-zone translúcida |
| `--bg-card` | base.css:39 | `oklch(99% 0.003 258)` | `.forest-annotated` background fallback |
| `--v2-surface-panel` | shared-bridge.css | shared-v2 opt-in | `.forest-annotated` background primary |
| `--data-1` | base.css:85 | `#4477AA` (Tol Bright blue) | forest-zone--ci |
| `--data-2` | base.css:86 | `#EE6677` (pink) | forest-zone--weight |
| `--data-3` | base.css:87 | `#228833` (green) | forest-zone--events |
| `--data-4` | base.css:88 | `#CCBB44` (yellow) | forest-zone--studies |
| `--data-6` | base.css:90 | `#AA3377` (purple) | forest-zone--diamond-1/2 |
| `--warning` | base.css:64 | `oklch(60% 0.13 85)` | forest-zone--het-1/2 |
| `--radius-md` | base.css:122 | `12px` | premium card border-radius |
| `--radius-sm` | base.css:122 | `8px` | forest-zone border-radius |

Format canon (ver base.css:330-338): `color-mix(in oklch, var(--data-N) X%, transparent)`.

---

## Phases (ordem sequencial — não paralelizar)

### Phase A — Issue #1: s-quality layout fix

**Arquivos:** `slides/05-quality.html` · `metanalise.css` (§s-quality L334-540)

**Diagnóstico:** `.slide-inner` já é grid 4-row (`auto 1fr auto auto`: h2/grid/dissoc/tag), L351-358 com `overflow: hidden` + `block-size: 100%`. `.term-grid` (row 2 `1fr`) cresce com cards expandidos → dissociation (row 3 `auto`) clipped por overflow. `align-content: start` em term-grid (L362-367) não impede expansão dos cards.

**Fix arquitetônico (Lucas):** encapsular `.term-grid` + `.term-dissociation` em wrapper grid `1fr auto` — força clamp do grid e fixa dissociation no rodapé.

**Edits propostos:**

1. `slides/05-quality.html`: criar `<div class="term-content-block">` wrappingo lines 5-65 (`.term-grid` + `.term-dissociation`). NÃO mover h2 (L3) nem source-tag (L67).
2. `metanalise.css` §s-quality:
   - L351-358 `.slide-inner`: 4-row → 3-row (`grid-template-rows: auto 1fr auto`: h2/wrapper/source-tag)
   - **NOVO** `.term-content-block`: `display: grid; grid-template-rows: 1fr auto; gap: var(--space-md); min-height: 0; overflow: hidden`
   - L362-367 `.term-grid`: adicionar `min-height: 0` + `overflow: hidden` (defensive clamping)

**Verification:** `npm run lint:slides` PASS · `npm run build:metanalise` PASS · vite preview confirm dissociation 52% visível no rodapé final da animação (Beat 5).

---

### Phase B — Issue #4: Calibração s-forest2

**Pre-req:** vite rodando (port 4102 — Lucas owns).

**Run:**
```bash
node content/aulas/scratch/calibrate-boxes.mjs --aula metanalise --slide s-forest2
```

**O que faz** (verified via Read script L1-80): abre Playwright headless, navega para `localhost:4102/metanalise/index.html`, avança até `s-forest2`, extrai `getBoundingClientRect()` de `.forest-annotated` wrapper + cada `.forest-zone`. Calcula percentagens relativas ao wrapper. Output JSON no console com `top/left/width/height` precisos.

**Edits:** aplicar percentagens output em `metanalise.css` §s-forest2 (zonas atuais L1230-1283 + L1345-1357):
- `forest-zone--ci` (L1230-1237) · `--weight` (L1239-1246) · `--events` (L1248-1255) · `--studies` (L1257-1264) · `--diamond-1` (L1267-1275) · `--het-2` (L1277-1284) · `--rob` (L1345-1357)

Substituir valores atuais (chutados) pelos do script. **Não tocar** colors aqui — Phase C.1 trata.

---

### Phase C — Issues #2 + #3 + #5: s-forest1+2 architectural

**C.1 — Tokens + Glassmorphism (forest1 + forest2):**

`.forest-annotated` (ambos slides — `metanalise.css` L1040-1053 forest1 + L1200-1215 forest2) → premium card pattern:
```css
section#s-forest{1,2} .forest-annotated {
  position: relative;
  display: inline-block;
  background: var(--v2-surface-panel, var(--bg-card));
  border-radius: var(--radius-md);
  border: 1px solid var(--overlay-border);
  box-shadow:
    0 1px 2px var(--shadow-subtle),
    0 12px 32px var(--shadow-subtle);
  padding: var(--space-xs);
  line-height: 0;
}
```

`.forest-zone` (ambos — L1064-1073 forest1 + L1219-1228 forest2) → glassmorphism:
```css
section#s-forest{1,2} .forest-zone {
  position: absolute;
  opacity: 0;
  pointer-events: none;
  z-index: 5;
  border-radius: var(--radius-sm);
  backdrop-filter: blur(2px);
  -webkit-backdrop-filter: blur(2px);
  border: 1px solid var(--overlay-border);
}
section#s-forest{1,2} .forest-zone.revealed {
  opacity: 1;
}
```

Substituir oklch hardcoded em zonas individuais por `--data-N` tokens. Mapping (linhas a alterar em metanalise.css):
- forest1 `--ci` (L1077-1078) → `var(--data-1)`
- forest1 `--weight*` (L1086-1110) → `var(--data-2)`
- forest1 `--het-*` (L1113-1128) → `var(--warning)`
- forest1 `--events` (L1133-1138) → `var(--data-3)`
- forest1 `--diamond-*` (L1142-1159) → `var(--data-6)`
- forest1 `--studies` (L1163-1169) → `var(--data-4)`
- forest2 mesma mapping (L1230-1284 + L1306 forest-ma-number color → `var(--data-6)` + L1295-1296 forest-ma-stat bg/border)

Format por zone:
```css
section#s-forest1 .forest-zone--ci {
  background: color-mix(in oklch, var(--data-1) 12%, transparent);
  /* manter top/left/width/height existentes */
}
```

**C.2 — Zoom architectural s-forest2 (CSS):**

Adicionar `aspect-ratio` ao `.forest-annotated`:
```css
section#s-forest2 .forest-annotated {
  aspect-ratio: 4501 / 1451;  /* match img dims original — proporção rígida */
  max-height: 380px;
  width: auto;
}
section#s-forest2 .forest-annotated img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  /* remover max-height isolado L1209 */
}
```

`slide-registry.js` s-forest2 advance() beat 8 (L353-361): JÁ mira `annotated` (var declarada L321) — manter. Verificar pós-aspect-ratio se `transformOrigin: '88% 25%'` + `xPercent: -35` ainda faz sentido. Se desalinhar, recomputar via calibrate ou ajuste empírico.

**C.3 — Rodapé seguro s-forest2 (HTML + CSS):**

`slides/08b-forest2.html`: introduzir wrapper `.forest-bottom-row` envolvendo `.forest-ma-stat` (L34-41) + `.cochrane-logo` (L44-48):
```html
<div class="forest-fig">
  <div class="forest-annotated">...</div>
  <div class="forest-bottom-row">
    <div class="forest-ma-stat">...</div>
    <a class="cochrane-logo">...</a>
  </div>
</div>
```

`metanalise.css` §s-forest2:
- L1192-1198 `.forest-fig`: flex column → `display: grid; grid-template-rows: 1fr auto; align-items: center; justify-items: center; gap: var(--space-xs); min-height: 0`
- **NOVO** `.forest-bottom-row`: `display: flex; justify-content: space-between; align-items: center; width: 100%; gap: var(--space-md)`

Resultado: figura central isolada (1fr) + bottom row (auto) com MA-stat à esquerda + Cochrane logo à direita. Não atropelado durante zoom RoB beat 8.

---

### Phase D — Issue #6: Motion staggering

`slide-registry.js` updates nas 3 functions:

**s-quality** (L102-197): adicionar `stagger: 0.1` nas `revealRow` calls (Beats 2-4) onde múltiplos chips revelam por card. Beat 0 (cards) já tem stagger. Beat 1 (perguntas) já tem stagger.

**s-forest1** (L395-435): refactor advance() — atual:
```js
gsap.fromTo(items, { opacity: 0 }, { opacity: 1, duration: 0.35, ease: 'power2.out' });
```
Para:
```js
gsap.fromTo(items,
  { opacity: 0, y: 6 },
  { opacity: 1, y: 0, duration: 0.5, stagger: 0.1, ease: 'power2.out' }
);
```
(adicionar `y: 6` cascata visual + stagger entre múltiplas zones do mesmo beat. Beat 1 = ci+diamond-1+diamond-2 = 3 elements → stagger visível)

**s-forest2** (L317-393): mesmo pattern beats 1-6 (zones simples). Beat 7 (Cochrane clipPath L347-352) preservar — intencionalmente especial. Beat 8 (zoom L353-362) preservar — single element transform. Retreat L376-388: pode adicionar stagger se múltiplos elements.

**CSS** `.revealed` classes (3 slides): manter como state-only (sem transition CSS) — GSAP handle. Se houver flicker pós-refactor, considerar `transition: opacity 350ms ease` defensiva.

---

### Phase E — Build + lint + visual verification

```bash
npm --prefix content/aulas run lint:slides   # PASS
npm --prefix content/aulas run build:metanalise   # PASS, 17 slides regen
```

Lucas check vite live preview port 4102:
- s-quality: dissociation 52% visível no rodapé final
- s-forest1: zones com glassmorphism, cascata stagger visível
- s-forest2: zones aligned (post-Phase B calibration), zoom RoB sem quebrar, MA-stat + Cochrane intactos no bottom row

---

### Phase F — QA cycle (KBP-05 anti-batch — 1 slide × 1 gate × 1 invocação)

Per slide, sequência canon `qa-pipeline.md`:

```
Preflight ($0)        → [Lucas OK]
  ↓
Inspect (Gemini Flash) → [Lucas OK] + edits incidentais (diff-first)
  ↓
Editorial (Gemini Pro) → [Lucas approve] → DONE
```

```bash
# Por slide (substituir {id})
node content/aulas/scripts/gemini-qa3.mjs --aula metanalise --slide {id} --preflight
node content/aulas/scripts/gemini-qa3.mjs --aula metanalise --slide {id} --inspect
node content/aulas/scripts/gemini-qa3.mjs --aula metanalise --slide {id} --editorial
```

**Order:** s-quality (re-QA pós-refactor — era DONE em S262, mudou em Phase A) → s-forest1 → s-forest2.

**Threshold:** score < 7 → checkpoint Lucas. Anti-sycophancy ceiling (qa-pipeline.md §E069): medical GSAP **6-8** (uniform stagger max 7, countUp without pause max 6).

---

### Phase G — Commit + Session close

1. `git fetch && git status` cross-window
2. `git branch --show-current` confirm `main`
3. `git add` **explicit** (apenas files que toquei):
   - `slides/05-quality.html`, `slides/08b-forest2.html`
   - `metanalise.css`
   - `slide-registry.js`
   - `metanalise/HANDOFF.md`, `metanalise/CHANGELOG.md`
   - `HANDOFF.md` (root), `CHANGELOG.md` (root)
   - `.claude/.slide-integrity` (auto-touched)
   - `.claude/plans/curious-enchanting-tarjan.md` (este — mark phases done)
4. Commit message detalhado (refactor + QA, scope grouping)
5. **NÃO push** — Lucas owns

---

## Critical files (referências sem chance de erro)

| Arquivo | Phase | Tipo | Linhas críticas |
|---------|-------|------|-----------------|
| `content/aulas/metanalise/slides/05-quality.html` | A | Edit (wrapper insert) | inserção entre L4 e L5 + fechamento antes de L67 |
| `content/aulas/metanalise/slides/08a-forest1.html` | — | unchanged (KBP-44 fix em `ac65ba6`) | — |
| `content/aulas/metanalise/slides/08b-forest2.html` | C.3 | Edit (bottom-row wrapper) | inserção L34-48 (wrapping ma-stat + logo) |
| `content/aulas/metanalise/metanalise.css` §s-quality | A, D | Edit | L334-540 (4-row→3-row + wrapper rules) |
| `content/aulas/metanalise/metanalise.css` §s-forest1 | C.1, D | Edit | L1029-1186 (tokens, premium card, glass) |
| `content/aulas/metanalise/metanalise.css` §s-forest2 | B, C.1-3, D | Edit | L1188-1390 (calibration + tokens + aspect-ratio + rodapé grid) |
| `content/aulas/metanalise/slide-registry.js` | D | Edit (3 functions) | s-quality L102-197 · s-forest1 L395-435 · s-forest2 L317-393 |
| `content/aulas/shared/css/base.css` | — | read-only (tokens canon) | L80-101, L122 |
| `content/aulas/scratch/calibrate-boxes.mjs` | B | run only (Playwright headless) | run-driven, no edits |
| `content/aulas/metanalise/HANDOFF.md` | F, G | Edit minimal | L62-63 (slide states forest), L83-85 (counts) |
| `content/aulas/metanalise/CHANGELOG.md` | G | Append | top of file (S264 entry) |
| `HANDOFF.md` (root) | G | Edit minimal | L19 (final adjust pós-QA) |
| `CHANGELOG.md` (root) | G | Edit minimal | bloco S264 (append 1 linha refactor commit) |

---

## Out of scope desta janela

- s-contrato R11=5.9 REOPEN (2 MUST CSS failsafe + subgrid) — DEFERRED próxima sessão dedicada
- Phase 2 reconcile geral metanalise/HANDOFF.md (s-checkpoint-2/s-aplicabilidade/s-ancora não-no-manifest) — DEFERRED
- Outros 12 slides LINT-PASS preflight — fora escopo
- s-absoluto qa-screenshots/ dir delete — Lucas direta (`rm -rf "content/aulas/metanalise/qa-screenshots/s-absoluto"` — hook denied autonomous)
- Specialty cleanup carryover, tone propagation 14 agents, R3 prep
- S264 P0 bench script×agent — outra janela

---

## Reference docs (carregadas via SessionStart próxima sessão)

- `.claude/rules/qa-pipeline.md` — state machine + 3 gates + threshold
- `.claude/rules/slide-rules.md` — h2 = clinical assertion, scoped CSS, easing
- `.claude/rules/design-reference.md` — oklch only, weight ≥ 400, [TBD] sem fonte
- `.claude/rules/anti-drift.md` — Edit discipline (KBP-25), EC loop, state files
- `.claude/rules/known-bad-patterns.md` — KBP-05 anti-batch QA, KBP-44 PMID, KBP-46 subgrid contextual
- `content/aulas/CLAUDE.md` — build before QA, gemini-qa3 único, lint:slides PASS
- `content/aulas/metanalise/CLAUDE.md` — assertion-evidence, F1-F2 sem artigo, forest plot real
- `content/aulas/metanalise/slides/_manifest.js` — source of truth (17 slides)
- `content/aulas/shared/css/base.css` — tokens canon (Tol Bright + shadows)

---

## Dependências externas

- Vite dev server port 4102 (Lucas owns — outra janela ou manual)
- Playwright (já instalado — `package.json` devDependencies)
- `@google/generative-ai` para gemini-qa3 (idem)
- `GEMINI_API_KEY` env var (verificar TTL antes de Phase F)

---

## Histórico desta sessão (commit chain S264)

- `ac65ba6` — feat(metanalise/S264): Phase 1 — dead-code cleanup s-absoluto + KBP-44 (12 files, +175/-24)
- `270903c` — docs(S263): HANDOFF S264 + CHANGELOG S263 — bench post-restart hand-off
- `c353f53` — feat(S263): Phase 0+1 — wrap-canonical rules + 2 research agents

---

# 📌 Pré-clear docs updates (executar nesta sessão antes do `/clear`)

> Lucas turn 8: "deixe o plano para pos clear, atualize os documentos de forma profissional para nao haver confusao quando vc hidratar, referencie sem chance de erro."

**Escopo:** 4 Edits documentais minimais ancorados a este plan file. Sem executar Phases A-G refactor (pós-clear).

## Edit D1 · `HANDOFF.md` (root) L19 — add refactor pendente reference

`old_string`:
```
QA editorial em curso (S264): s-forest1 + s-forest2 (LINT-PASS, preflight pendente). s-contrato R11=5.9 (REOPEN: CSS failsafe unscoped + subgrid ausente). 12 LINT-PASS pendentes. Pipeline: gemini-qa3.mjs preflight→inspect→editorial. KBP-05 anti-batch. Bench Phase 6-8 (Living HTML + slide `s-ma-types` + QA) integra com este P0.
```

`new_string`:
```
QA editorial em curso (S264): refactor architectural batch + QA cycle pra `s-quality`, `s-forest1`, `s-forest2` planejado pós-clear. Plan: `.claude/plans/curious-enchanting-tarjan.md` (Phases A-G — 6 issues numerados Lucas turn 7). s-contrato R11=5.9 segue REOPEN (CSS failsafe + subgrid) — DEFERRED. 12 LINT-PASS pendentes total. KBP-05 anti-batch. Bench Phase 6-8 integra com este P0.
```

## Edit D2 · `CHANGELOG.md` (root) — append S264 entry no bloco existente

Localizar bloco `## S264` (provavelmente topo). Append linha após hash bench já registrado:

`new_string` (append):
```
- `ac65ba6` feat(metanalise): Phase 1 dead-code cleanup s-absoluto + KBP-44 fix (12 files, +175/-24). Refactor architectural Phases A-G deferred pós-clear (`.claude/plans/curious-enchanting-tarjan.md`).
```

(Read CHANGELOG root primeiro pra localizar exato anchor; se não houver bloco S264 ainda, criar `## S264 (2026-04-27)` no topo.)

## Edit D3 · `content/aulas/metanalise/HANDOFF.md` L62-63 — add refactor pendente nas notas forest

`old_string`:
```
| 9 | s-forest1 | LINT-PASS | QA pendente. |
| 10 | s-forest2 | LINT-PASS | QA pendente. |
```

`new_string`:
```
| 9 | s-forest1 | LINT-PASS | Refactor architectural + QA pendentes (S264 pós-clear). Tokens + glassmorphism + motion stagger. Plan: `.claude/plans/curious-enchanting-tarjan.md` Phase C.1+D. |
| 10 | s-forest2 | LINT-PASS | Refactor architectural + QA pendentes (S264 pós-clear). Calibration + tokens + aspect-ratio + bottom-row + motion. Plan: `.claude/plans/curious-enchanting-tarjan.md` Phases B+C+D. |
```

## Edit D4 · `content/aulas/metanalise/CHANGELOG.md` — append S264 entry no topo

Read primeiro pra ver formato existente. Bloco proposto (3 linhas):
```
## 2026-04-27 — S264 (Phase 1 done · refactor deferred pós-clear)

- Phase 1 dead-code cleanup `s-absoluto` (slide deletado S186, commit `ac65ba6`): state files A + evidence broken pointers B + KBP-44 fix `08a-forest1.html`. 11 refs stale removed. lint+build PASS.
- Phases A-G refactor architectural (s-quality + s-forest1 + s-forest2) deferred — plan completo em `.claude/plans/curious-enchanting-tarjan.md` (6 issues numerados Lucas turn 7: layout fix, calibration, tokens, glassmorphism, zoom architectural, rodapé seguro, motion staggering).
```

## Verification pré-clear

1. `git diff` — confirmar 4 files alterados (HANDOFF root, CHANGELOG root, metanalise/HANDOFF, metanalise/CHANGELOG)
2. Plan file `curious-enchanting-tarjan.md` permanece untouched (já comittado em `ac65ba6` após D-edits)
3. **NÃO commitar** — Lucas decide se commit pré-clear ou pós-clear post-refactor

## Pós-/clear hidratação (referência sem chance de erro)

3 passos exatos (já citados no topo deste plan):
1. Read `.claude/plans/curious-enchanting-tarjan.md` (este file — anchor doc completo)
2. Confirm vite up port 4102 (Lucas owns)
3. Start Phase A — Issue #1 s-quality layout fix
