# Plan S273 — Remover overlays s-forest1 + s-forest2

> **Sessão:** S273 · **Lane:** A (metanalise) · **Foco:** remoção limpa de `.forest-zone` overlays
> **Plan-file:** `.claude/plans/swift-plotting-tome.md`
> **Tier (anti-drift §EC tiers):** M (refactor ≥3 files: 2 HTML + 1 CSS + 1 JS + 1 manifest)

---

## Context

Lucas julgou (turno 4): "tire os overlays do s-forest1 e 2 estão muito ruins". Os overlays são `.forest-zone` divs absolutamente posicionadas com cor translúcida (Tol palette) que destacam regiões do forest plot (CI, weight, events, studies, het, diamond, RoB) — clicáveis em sequência via GSAP fade-in. O sistema foi planejado pra refinamento (plan vigente `curious-enchanting-tarjan.md` Phases B+C+D: calibration + tokens + glassmorphism premium), mas o veredicto pedagógico do Lucas é que os overlays não funcionam — distração visual em vez de guia.

Decisões Lucas (AskUserQuestion turno 5):
1. **s-forest1** vira **auto-only** (img + h2). clickReveals: 5→0. Professor narra anatomia oralmente.
2. **s-forest2** preserva **3 beats não-overlay**: badge "15 MAs" (era beat 6), Cochrane logo clipPath (era beat 7), zoom RoB no `.forest-annotated` (era beat 8). Renumerar como beats 1→3. clickReveals: 8→3.
3. **Slide novo "criar um"** (pedido inicial) **deferred S274+**. Sessão atual = só remoção limpa.

Outcome esperado: 2 forest slides simplificados, plan vigente `curious-enchanting-tarjan.md` Phases B+C+D marcadas SUPERSEDED, lint+build PASS, slides ainda em LINT-PASS state (re-QA pós-remoção em sessão futura — fora de escopo desta janela).

---

## Anatomia da remoção (file × range × out/in)

### `slides/08a-forest1.html` — REMOVE L12-30 (10 `.forest-zone` divs)

Mantém: `<section>` + `<div class="slide-inner">` + `<h2>` + `<div class="forest-fig">` + `<div class="forest-annotated">` + `<img>` + `<p class="source-tag">`. Remove os 4 blocos de comentário "Click N:" + 10 divs `<div class="forest-zone forest-zone--*" data-reveal="N"></div>`.

### `slides/08b-forest2.html` — REMOVE L12-31 (7 `.forest-zone` divs) + RENUMERA `data-reveal` em 3 elementos restantes

Remove:
- L12-26: zones beats 1-5 (ci, diamond-1, weight, events, studies, het-2)
- L29-31: zone `--rob` beat 8 (já era zone-only morto — JS faz só zoom no `.forest-annotated`, ver slide-registry L353-361 comment "RoB: zoom only — no yellow overlay")

Mantém + renumera `data-reveal`:
- L34-41: `forest-ma-stat` `data-reveal="6"` → `data-reveal="1"`
- L44-48: `cochrane-logo` `data-reveal="7"` → `data-reveal="2"`
- (zoom RoB beat 3 = JS-only no `.forest-annotated`, sem `data-reveal` no HTML)

### `metanalise.css` — REMOVE L1070-1185 (forest1 zones) + L1232-1299 (forest2 zones) + L1359-1379 (forest2 RoB zone) + UPDATE failsafes L1188-1201 e L1381-1396

Mantém intacto:
- L1042-1068: `.slide-inner`, `.forest-fig`, `.forest-annotated`, `.forest-annotated img` (forest1 structural)
- L1203-1230: structural forest2 (idem)
- L1301-1340: `.forest-ma-stat` + `.forest-ma-number` + `.forest-ma-text` + `.forest-ma-title` + `.forest-ma-sub`
- L1342-1357: `.cochrane-logo`

Atualiza failsafes:
- L1187-1201 forest1: remover refs `.forest-zone` dos selectors `.no-js`/`.stage-bad`/`[data-qa]`/`@media print`. Mantém só `.forest-annotated img`.
- L1381-1396 forest2: remover refs `.forest-zone` dos selectors. Mantém `.forest-annotated img` + `.cochrane-logo` + `.forest-ma-stat`.

Remove o palette comment block L1070-1078 (Tol HEX → OKLCH lookup table) — não é mais consumido.

### `slide-registry.js` — REWRITE s-forest1 (L395-435) + REWRITE s-forest2 (L317-393)

**s-forest1 nova versão (~10 li):**
```js
's-forest1': (slide, gsap) => {
  const img = slide.querySelector('.forest-annotated img');
  if (img) {
    gsap.fromTo(img,
      { opacity: 0, y: 20 },
      { opacity: 1, y: 0, duration: 0.7, ease: 'power3.out' }
    );
  }
  // Auto-only — sem click-reveal (overlays removidos S273)
},
```

Remove: `advance`/`retreat`/`__clickRevealNext`/`__hookRetreat`/`__hookCurrentBeat`. Engine de slides com `clickReveals: 0` (manifest) avança direto pro próximo slide ao clicar.

**s-forest2 nova versão (~50 li, 3 beats):**

Mantém estrutura geral mas: `MAX = 3` (era 8); beats 1=ma-stat fade-in (era beat 6) | 2=cochrane clipPath (era beat 7) | 3=zoom RoB no `.forest-annotated` (era beat 8). Lógica `getGroup(n)` busca `[data-reveal="N"]` — funciona após renumeração HTML. `retreat()` reverte simétrico.

### `slides/_manifest.js` — UPDATE 2 entries

- L25 s-forest1: `clickReveals: 5` → `clickReveals: 0`
- L26 s-forest2: `clickReveals: 8` → `clickReveals: 3`

### `.claude/plans/curious-enchanting-tarjan.md` — MARK SUPERSEDED Phases B+C+D

Adicionar header banner no topo:

```markdown
> **🚨 SUPERSEDED S273:** Phases B (calibration), C.1 (tokens), C.2 (zoom architectural), C.3 (rodapé seguro), D (motion staggering) eram refinamento dos `.forest-zone` overlays. Lucas decidiu remover overlays integralmente (`/plans/swift-plotting-tome.md`). Phase A (s-quality) permanece DONE. Phase E (build/lint), Phase F (QA cycle), Phase G (commit) podem ser re-aplicadas pós-remoção em sessão futura, mas o escopo de slides muda (s-forest1+2 simplificados).
```

Mantém o resto do plan intacto pra audit trail.

### `content/aulas/metanalise/HANDOFF.md` — UPDATE L62-63

```diff
- | 9 | s-forest1 | LINT-PASS | Refactor architectural + QA pendentes (S264 pós-clear). Tokens + glassmorphism + motion stagger. Plan: `.claude/plans/curious-enchanting-tarjan.md` Phases C.1+D. |
- | 10 | s-forest2 | LINT-PASS | Refactor architectural + QA pendentes (S264 pós-clear). Calibration + tokens + aspect-ratio + bottom-row + motion. Plan: `.claude/plans/curious-enchanting-tarjan.md` Phases B+C+D. |
+ | 9 | s-forest1 | LINT-PASS | Overlays removidos S273 (`/plans/swift-plotting-tome.md`). Auto-only contemplativo (img + h2). clickReveals: 0. QA pendente. |
+ | 10 | s-forest2 | LINT-PASS | Overlays removidos S273 (`/plans/swift-plotting-tome.md`). Preserva 3 beats: badge "15 MAs", Cochrane logo, zoom RoB. clickReveals: 3. QA pendente. |
```

---

## Implementation order (sequencial — 1 EC loop por file, batch de Edits coerente por file)

Pre-flight (antes de qualquer Edit): `bash tools/integrity.sh` (Lucas pediu na abertura) + confirmar M6 telemetry growing (`.claude/stop1-telemetry.jsonl`).

1. **Edit `slides/08a-forest1.html`** — remove 10 zones + 4 comment blocks
2. **Edit `slides/08b-forest2.html`** — remove 7 zones + renumera 2 `data-reveal` (6→1, 7→2)
3. **Edit `metanalise.css`** — remove zone rules + palette comment + atualiza failsafes (3 Edits no mesmo file: forest1 zones bloco / forest2 zones bloco / failsafes)
4. **Edit `slide-registry.js`** — rewrite s-forest1 function (auto-only ~10 li) + rewrite s-forest2 function (3 beats ~50 li)
5. **Edit `slides/_manifest.js`** — clickReveals 5→0 e 8→3 (2 Edits)
6. **Edit `.claude/plans/curious-enchanting-tarjan.md`** — banner SUPERSEDED no topo
7. **Edit `content/aulas/metanalise/HANDOFF.md`** — L62-63 notas atualizadas
8. **Verification:**
   - `npm --prefix content/aulas run lint:slides` PASS
   - `npm --prefix content/aulas run build:metanalise` PASS (regen index.html, 17 slides)
   - Lucas check live preview port 4102 (forest1 = só img; forest2 = 3 cliques: badge, Cochrane, zoom RoB)
9. **Commit (Lucas decide):** `feat(metanalise/S273): remove forest-zone overlays — auto-only forest1 + 3 beats forest2`

Cada step = 1 EC loop visível (Verificação + Evidência + Mudança proposta + Pre-mortem + Rollback + Pós-verificação + Learning capture). Lucas autoriza step-by-step ou em batch coerente (a critério dele).

---

## Out of scope desta janela

- **Criar slide novo** (pedido inicial "criar um") — deferred S274+ (Lucas decisão Q3).
- **QA cycle** (preflight + inspect + editorial) pós-remoção — slides voltam a estado LINT-PASS, QA fica pra sessão dedicada.
- **`curious-enchanting-tarjan.md` Phase A re-confirm** — Phase A (s-quality wrapper `.term-content-block`) está committed S265, não tocar.
- **Refactor outras zonas do projeto** (KBP-21 calibrate-before-block) — só código que vira morto pela remoção sai. CSS structural `.forest-fig`/`.forest-annotated` permanece intacto pro próximo design.
- **Lane DECISIONS** (4 findings deferred S272: B2/M5/M4/B1) — fora desta janela, Lucas pode iniciar separado.
- **Sessão-DECISIONS** mencionada na abertura — não escolhida nesta lane.

---

## Critical files (referências sem chance de erro)

| Arquivo | Linhas críticas | Tipo Edit |
|---------|-----------------|-----------|
| `content/aulas/metanalise/slides/08a-forest1.html` | L12-30 (remove) | Single Edit (apaga bloco) |
| `content/aulas/metanalise/slides/08b-forest2.html` | L12-31 remove + L34/L44 renumera `data-reveal` | 3 Edits (zones bloco / badge / logo) |
| `content/aulas/metanalise/metanalise.css` | L1070-1185 (forest1 zones) · L1232-1299 (forest2 zones) · L1359-1379 (forest2 RoB) · L1187-1201 (forest1 failsafes) · L1381-1396 (forest2 failsafes) | 5 Edits |
| `content/aulas/metanalise/slide-registry.js` | L317-393 (s-forest2) · L395-435 (s-forest1) | 2 Edits (rewrite functions) |
| `content/aulas/metanalise/slides/_manifest.js` | L25 (forest1 clickReveals) · L26 (forest2 clickReveals) | 2 Edits |
| `.claude/plans/curious-enchanting-tarjan.md` | top banner SUPERSEDED | 1 Edit |
| `content/aulas/metanalise/HANDOFF.md` | L62-63 | 1 Edit |

Total: ~14 Edit calls, 7 files. Lint+build cobrem regression.

---

## Verification end-to-end

```bash
# Pre-flight
bash tools/integrity.sh
ls -la .claude/stop1-telemetry.jsonl   # confirm growing

# Lint + build
npm --prefix content/aulas run lint:slides
npm --prefix content/aulas run build:metanalise

# Visual (Lucas dev server port 4102 strictPort — Lucas owns)
# Navigate forest1 → confirm img only, no overlays
# Navigate forest2 → confirm 3 clicks: badge → Cochrane logo → zoom RoB
# No console errors related to forest-zone selectors
```

PASS criteria:
1. `lint:slides` exit 0
2. `build:metanalise` exit 0, `metanalise/index.html` regen sem warnings
3. Forest1: imagem aparece, cliques avançam direto pro próximo slide (s-forest2)
4. Forest2: clique 1 = badge surge bottom-left | clique 2 = Cochrane logo curtain L→R | clique 3 = zoom 2× xPercent -35 transformOrigin 88% 25% (coluna RoB visível) | clique 4 = avança pro próximo slide
5. Console limpo (sem QuerySelector misses por `.forest-zone`)

---

## Pre-mortem (Gary Klein)

**Cenário falha 1:** `[data-reveal="6"]` ou `[data-reveal="7"]` órfão em algum lugar (CSS rule, JS query, manifest comment) que eu não mapeei → reveal quebrado silenciosamente. **Mitigação:** após Edits HTML+CSS+JS, rodar `Grep "data-reveal=\"[6-8]\"" content/aulas/metanalise/` — deve retornar 0 matches.

**Cenário falha 2:** failsafes mal-atualizados causam `.forest-annotated img` ficar `opacity: 0` em produção (selector composto removido errado). **Mitigação:** Edit conservador — preservar regra `img` intacta, remover só refs `.forest-zone` dos selectors agrupados.

**Cenário falha 3:** zoom RoB beat 3 (forest2) calibration `xPercent: -35` + `transformOrigin: '88% 25%'` foi calibrado pra o aspect-ratio atual; remoção de overlays não muda aspect-ratio do `.forest-annotated`, mas vale confirmar visual. **Mitigação:** Lucas testa beat 3 ao vivo no preview.

**Cenário falha 4:** plan superseded com "manter rest intacto" pode confundir hidratação futura (alguém abre `curious-enchanting-tarjan.md` sem ver banner). **Mitigação:** banner em formato `🚨 SUPERSEDED` no L1 do plan, antes do título.

**Rollback/stop-loss:** se lint falhar pós-Edits CSS, `git diff metanalise.css` e revert seção problemática. Se build falhar, `git restore --staged content/aulas/metanalise/` e re-applicar Edit-by-Edit pra isolar o quebrado.

---

## Reference docs

- `.claude/rules/anti-drift.md` — EC tiers (Tier M aplicável), Edit discipline KBP-25
- `.claude/rules/slide-rules.md` — h2 = clinical assertion (não tocamos h2), scoped CSS
- `.claude/rules/qa-pipeline.md` — state machine (slides retornam pra LINT-PASS pós-remoção)
- `.claude/rules/known-bad-patterns.md` — KBP-21 (Narrow Fix in Dirty Section): mantém só CSS structural, remove zones + palette comment juntos
- `content/aulas/CLAUDE.md` — build:slides, never edit `index.html` direto
- `content/aulas/metanalise/CLAUDE.md` — assertion-evidence (não tocamos), F2 sem artigo (forest plots permanecem F2)
- `.claude/plans/curious-enchanting-tarjan.md` — vai receber banner SUPERSEDED nesta sessão

---

## Histórico de decisão (turn references)

- Turno 1 (Lucas): "Lane A foco" + "Sessão-DECISIONS"
- Turno 3 (Lucas): "midexe entre em plano e me proponha vamos melhorslides e criar um"
- Turno 4 (Lucas, durante plan mode): "tire os overlays do S forest 1 e 2 estao muito ruins" — pivot completo, supersede pedido anterior
- Turno 5 (Lucas via AskUserQuestion):
  - Q1 forest1 → "Auto-only (img + h2)"
  - Q2 forest2 → "Manter os 3 (renumerar 1→3)"
  - Q3 slide novo → "Só remoção hoje, slide novo em sessão futura"
