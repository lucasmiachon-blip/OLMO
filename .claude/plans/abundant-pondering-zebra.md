# S157 — Forest plot slides (s-forest1 + s-forest2)

> **Sessao:** 157 | **Data:** 2026-04-11
> **Estado:** Fase calmaria, pos rule-level fix
> **Prioridade:** 2 slides + 1 evidence HTML unico denso

---

## STATUS

**Context melt fix — RESOLVED S157 (calmaria phase):**
- Commit `20dcc3e` — `anti-drift.md §Delegation gate` + KBP-17 (rule auto-loaded)
- Commit `b25e039` — HANDOFF root cleanup (sem duplicacao de prose)
- Commit `e9da24d` — doc commit inicial S157
- Supersede hipotese inicial "fix comportamental, nao estrutural" → rule-level venceu (CLAUDE.md §1).
- Detalhes forense: `git log -S 'Delegation gate'` + `CHANGELOG.md` S157.

**Pendente nesta sessao:** Fases 1-7 (slides execution).

---

## 1. Slides forest plot — contexto

Lucas quer 2 slides na aula de metanalise ensinando anatomia de forest plot, com **UMA evidence HTML densa** contendo as 2 MAs:

- **Slide 1 — Li Y 2026** *Am J Cardiovasc Drugs*, PMID **40889093** VERIFIED, 14 RCTs, N=31,397. Ensina os 5 elementos anatomicos (square, bar, null line, diamond, weight).
- **Slide 2 — Ebrahimi F 2025** *Cochrane Database Syst Rev*, PMID **41224205** VERIFIED, DOI `10.1002/14651858.CD014808.pub2`, 12 RCTs, N~22,983. Adiciona RoB como meta-elemento + demo live Cochrane + fala de 10s fechando:

> *"Quinze metanalises em quatorze meses sobre o mesmo tema clinico. [pausa 1s] O que isso diz sobre o incentivo do campo?"*

**Base de trabalho (S148 census + S152 brainstorm, ja lidos, nao reabrir):**
- `.claude/workers/colchicine-macce-2025-2026/40-census-final.md` (15 MAs triangulated)
- `.claude/workers/s-forest-planning/2026-04-11-0001_scope-and-reflection.md` (436 L pedagogia)

**Decisoes estruturais:**
1. **UMA** evidence HTML (`s-forest-plot.html`), nao duas.
2. `forest-plot-candidates.html` pode ser arquivado/deletado.
3. Living HTML FIRST (ler PDFs, escrever evidence), DEPOIS slides.

---

## 2. Execution

### Fase 1 — Preservation + pre-flight visual

**1.1** Mover census do worker gitignored → versionado:
```bash
mv .claude/workers/colchicine-macce-2025-2026/40-census-final.md \
   content/aulas/metanalise/references/colchicine-macce-census-S148.md
```
**Commit:** `S157: preserve colchicine census (15 MAs S148)`

**1.2** Lucas decide fate de legacy files (default = arquivar):
- `evidence/forest-plot-candidates.html` → `evidence/_archive/forest-plot-candidates-S147.html`
- `evidence/s-forest-plot.html` (DRAFT S146) → `evidence/_archive/s-forest-plot-DRAFT-S146.html`

**Commit:** `S157: archive legacy forest-plot files`

**1.3** `npm run dev:metanalise` em background (porta 4102). Lucas faz visual walk do deck atual (15 slides). Lucas decide:
- **D1:** IDs dos 2 novos slides (default `08a-forest1` + `08b-forest2`, entre s-benefit-harm e s-heterogeneity)
- **D2:** Theme light ou dark (default light — crops PNG fundo branco colidem com navy)

**STOP** — Lucas reporta decisoes.

---

### Fase 2 — PDF reading (conteudo para evidence HTML)

**2.1** Criar `content/aulas/metanalise/assets/_source-pdfs/` (gitignored). Add `.gitignore`.

**2.2** Lucas move PDFs de Downloads:
```bash
mv "/c/Users/lucas/Downloads/colchicine-li-*.pdf" \
   content/aulas/metanalise/assets/_source-pdfs/li-2026-ajcd.pdf
mv "/c/Users/lucas/Downloads/colchicine-ebrahimi-*.pdf" \
   content/aulas/metanalise/assets/_source-pdfs/ebrahimi-2025-cochrane.pdf
```

**2.3** Read PDFs via Read tool nativo (com `pages` parameter para Cochrane longo). Extrair:
- **Li 2026:** PICO, methods (pairwise + cumulative dose), N RCTs, I² primario, RR/OR/HR IC95%, subgroups, figure legend
- **Ebrahimi 2025:** PICO, methods, GRADE por outcome, MI RR 0.74, Stroke RR 0.67, mortality neutral, GI adverse, trial list com RoB, Summary of Findings, figure legend

**STOP** — Reporto sintese tabelada, Lucas valida extract.

---

### Fase 3 — Evidence HTML unico denso

**3.1** Criar `content/aulas/metanalise/evidence/s-forest-plot.html` com secoes:

- `#sintese` — 3-layer pre-reading (basico + intermediario + avancado em `<details>`)
- `#anatomia-5-elementos` — square/bar/null/diamond/weight (com crop Li)
- `#rob-meta-elemento` — RoB como 6º elemento (com crop Ebrahimi)
- `#li-2026` — sintese destilada PMID 40889093
- `#ebrahimi-2025` — sintese destilada PMID 41224205 + GRADE
- `#census-15-mas` — destilacao curada do worker census (9/9 convergencia + Pinheiro outlier)
- `#pedagogia` + `#retorica` + `#numeros` + `#sugestoes`
- Depth Rubric D1-D8 em `<details>`
- `#referencias` — Li + Ebrahimi PMIDs clicaveis `.v VERIFIED`
- `#speaker-notes` — fala de 10s (ja definida)

**A11y:** `rel="noopener noreferrer"` em links externos, `scope="col"` em `<th>`.
**Benchmark visual:** `pre-reading-heterogeneidade.html` (read-only padrao-ouro S148).
**Footer:** `Coautoria: Lucas + Opus 4.6 | S157 2026-04-11`

**STOP** — Lucas revisa evidence HTML antes de avancar.

**Commit:** `S157: add s-forest-plot.html — dense evidence (Li + Ebrahimi + 15 MAs)`

---

### Fase 4 — Crops PyMuPDF

**4.1** Script Python inline via Bash:
```python
import fitz
doc = fitz.open("assets/_source-pdfs/li-2026-ajcd.pdf")
page = doc[N]  # Lucas indica pagina
pix = page.get_pixmap(dpi=300)
pix.save("assets/li-2026-forest-plot.png")
# Ou retangulo: fitz.Rect(x0,y0,x1,y1)
```

**4.2** Teste 200% no browser. Se pixelar: `page.get_svg_image()` (vector preservado se embedded); senao fallback R forestplot (reabre escopo com Lucas).

**4.3** Repetir Ebrahimi — **critico:** coluna RoB dentro do crop.

**4.4** Lucas screenshot Cochrane Library (Win+Shift+S) → `assets/cochrane-ebrahimi-screenshot.png` (backup demo live).

**STOP** — Lucas aprova 3 assets visualmente.

**Commit:** `S157: add forest plot crops + Cochrane backup`

---

### Fase 5 — Slide 1 (`s-forest1` Li 2026) — ciclo QA completo

> **KBP-05:** 1 slide por ciclo. NUNCA batch.

**5.1** Criar `slides/08a-forest1.html`:
```html
<section id="s-forest1">
  <div class="slide-inner">
    <p class="section-tag">Anatomia do Forest Plot</p>
    <h2>[PLACEHOLDER — Lucas escreve]</h2>
    <figure class="slide-figure">
      <img src="../assets/li-2026-forest-plot.png"
           alt="Forest plot Li 2026 — 14 RCTs colchicina MACCE">
      <!-- Overlays data-animate para zoom sequencial dos 5 elementos -->
    </figure>
    <cite class="source-tag">Li 2026 (Am J Cardiovasc Drugs)</cite>
  </div>
</section>
```
- Imagem estatica (sem data-animate). Overlays com data-animate.
- h2 = trabalho do Lucas (placeholder).

**STOP** — Lucas escreve h2.

**5.2** Wiring:
- `_manifest.js` — entry na posicao D1, campo `evidence: 's-forest-plot.html'`
- `metanalise.css` — `section#s-forest1 .anatomy-zoom { ... }` (scopado)
- `slide-registry.js` — condicional D3 (custom anim ou declarativo)

**5.3** Build + lint:
```bash
cd content/aulas && npm run lint:slides metanalise && npm run build:metanalise
```
**Commit:** `S157: add s-forest1 — DRAFT (h2 placeholder)`

**STOP** — Lucas checa vite.

**5.4** QA Preflight (Opus visual 4 dims, $0). Tabela PASS/FAIL. **STOP.**

**5.5** Lucas OK → `gemini-qa3.mjs --inspect`. **STOP.**

**5.6** Lucas OK → `gemini-qa3.mjs --editorial`. Save `qa-screenshots/s-forest1/editorial-suggestions.md`. **STOP.**

**5.7** Iteracoes: edit → lint → build → STOP → Lucas OK → re-QA se score <7. Max 2-3.

**Commit final:** `S157: s-forest1 DONE — Li 2026 (QA approved)`

---

### Fase 6 — Slide 2 (`s-forest2` Ebrahimi 2025) — ciclo QA completo

Estrutura identica Fase 5, adaptacoes:

**6.1** `slides/08b-forest2.html`:
- Figure com crop Ebrahimi (forest plot + coluna RoB)
- Overlay destacando RoB como meta-elemento
- Link live: `<a href="https://www.cochranelibrary.com/cdsr/doi/10.1002/14651858.CD014808.pub2/full" target="_blank" rel="noopener noreferrer">Cochrane Library</a>` (backup = screenshot)
- Speaker notes com fala de 10s (ja em evidence HTML)

**6.2-6.7** Mesmo ciclo Fase 5 (wiring, build, QA Preflight/Inspect/Editorial, iteracoes).

**Commit final:** `S157: s-forest2 DONE — Ebrahimi RoB meta-element (QA approved)`

---

### Fase 7 — Wrap

**7.1** `content/aulas/metanalise/HANDOFF.md`: 15/15 → 17/17 slides, add entries s-forest1/s-forest2, update F2. **Tambem:** remover linha fantasma `s-forest-plot` da tabela (Erro B herdado do desespero — count table=16 vs summary=15).

**7.2** `content/aulas/metanalise/CHANGELOG.md`:
```markdown
## S157 — 2026-04-11 — calmaria

- Context melt fix: KBP-17 + anti-drift §Delegation gate (commit 20dcc3e)
- Add s-forest1 (Li 2026 AJCD, PMID 40889093) — anatomia 5 elementos
- Add s-forest2 (Ebrahimi 2025 Cochrane, PMID 41224205) — RoB meta-elemento + demo live + fala 10s
- Add s-forest-plot.html evidence unico (Li + Ebrahimi + 15 MAs census destilado)
- Preserve colchicine-macce-census-S148.md em references/
- Archive legacy forest-plot-candidates + s-forest-plot DRAFT S146
- Reconcile HANDOFF aula: remove s-forest-plot phantom (15→17)
```

**7.3** `HANDOFF.md` root: session S157 → S158. KBP-17 permanece auto-loaded (durable).

**7.4** Workers preservados (KBP-10 + trail epistemologico):
- `.claude/workers/colchicine-macce-2025-2026/` intacto (40-census ja movido)
- `.claude/workers/s-forest-planning/` intacto
- Listar em BACKLOG S162+ review (minimo 5 sessoes)
- **NAO deletar** sem Lucas OK.

**Commit final:** `S157: wrap — 2 forest slides DONE`

---

## 3. Out of scope (explicit NOT)

- Pre-readings legacy (`pre-reading-forest-plot-vies.html`, `pre-reading-heterogeneidade.html`) — Lucas explicit: read-only
- 9 `<th colspan="2">` a11y gap em `forest-plot-candidates.html` — HANDOFF root P1 defer
- 14 links `rel="noopener"` + 3 `<th scope="col">` em `pre-reading-heterogeneidade.html` — benchmark read-only
- Worker cleanup (KBP-10 + anti-fragilidade — preservar trail)
- Vaduganathan slide A — superseded por S152
- Construir forest plot SVG from scratch (hard constraint metanalise CLAUDE.md #5)
- Comparacao estatistica entre Li e Ebrahimi (nao e o ponto pedagogico)
- Slide RoB standalone (RoB integrada no crop Ebrahimi)

---

## 4. Critical files

### Criados
- `content/aulas/metanalise/slides/08a-forest1.html`
- `content/aulas/metanalise/slides/08b-forest2.html`
- `content/aulas/metanalise/evidence/s-forest-plot.html` *(UM denso, serve ambos slides)*
- `content/aulas/metanalise/assets/li-2026-forest-plot.png`
- `content/aulas/metanalise/assets/ebrahimi-2025-cochrane-forest-plot.png`
- `content/aulas/metanalise/assets/cochrane-ebrahimi-screenshot.png`
- `content/aulas/metanalise/references/colchicine-macce-census-S148.md` *(mv do worker)*
- `content/aulas/metanalise/assets/_source-pdfs/` *(gitignored)*

### Editados
- `content/aulas/metanalise/HANDOFF.md` — reconcile phantom + 15/15→17/17
- `content/aulas/metanalise/CHANGELOG.md` — S157 entry
- `content/aulas/metanalise/slides/_manifest.js` — +2 entries
- `content/aulas/metanalise/metanalise.css` — +selectors scopados
- `content/aulas/metanalise/slide-registry.js` — condicional D3
- `.gitignore` — add `_source-pdfs/`

### Arquivados
- `evidence/forest-plot-candidates.html` → `evidence/_archive/forest-plot-candidates-S147.html`
- `evidence/s-forest-plot.html` (legacy S146 DRAFT) → `evidence/_archive/s-forest-plot-DRAFT-S146.html`

### Scripts (read-only, reutilizar)
- `content/aulas/scripts/build-html.ps1` — build PowerShell
- `content/aulas/scripts/lint-slides.js` — lint HTML/CSS
- `content/aulas/scripts/gemini-qa3.mjs` — QA unico (Preflight + Inspect + Editorial)
- `content/aulas/scripts/qa-capture.mjs` — screenshots pre-QA
- PyMuPDF (`fitz`) — cropping tool (Python)

### Referencia (ja lido, nao reabrir)
- `.claude/workers/s-forest-planning/2026-04-11-0001_scope-and-reflection.md`
- `.claude/workers/colchicine-macce-2025-2026/40-census-final.md`
- `content/aulas/metanalise/evidence/pre-reading-heterogeneidade.html` (benchmark **READ-ONLY**)

---

## 5. Verification (end-to-end slides)

1. **Build PASS:** `cd content/aulas && npm run build:metanalise` zero warnings
2. **Lint PASS:** `cd content/aulas && npm run lint:slides metanalise` zero errors
3. **Vite visual (localhost:4102):** s-forest1/s-forest2 com:
   - Crops nitidos em 100% e 200% browser
   - 5 elementos anatomicos reveal sequencial
   - h2 = assercao (nao rotulo generico)
   - Source tag "Autor Ano"
   - Slide 2 overlay destaca coluna RoB
   - Slide 2 speaker notes tem fala de 10s
4. **QA Gemini:** ambos score ≥7 (ou Lucas aceita ressalva registrada)
5. **Manifest count:** `_manifest.js` tem 17 entries
6. **PMIDs clicaveis:** 40889093 + 41224205 em `#referencias` abrem PubMed
7. **Census preservado:** `references/colchicine-macce-census-S148.md` existe
8. **Workers intactos:** `.claude/workers/colchicine-macce-2025-2026/` + `s-forest-planning/`
9. **HANDOFFs coerentes:** root com KBP-17, aula 17/17 sem fantasma, sem Vaduganathan

---

## 6. Commits pendentes (~9)

1. `S157: preserve colchicine census (15 MAs S148)`
2. `S157: archive legacy forest-plot files`
3. `S157: add s-forest-plot.html — dense evidence (Li + Ebrahimi + 15 MAs)`
4. `S157: add forest plot crops + Cochrane backup`
5. `S157: add s-forest1 — DRAFT (h2 placeholder)`
6. `S157: s-forest1 DONE — Li 2026 anatomy (QA approved)`
7. `S157: add s-forest2 — DRAFT`
8. `S157: s-forest2 DONE — Ebrahimi RoB meta-element (QA approved)`
9. `S157: wrap — HANDOFF + CHANGELOG + workers preserved`

**Ja commitados nesta sessao (desespero → calmaria):**
- `e9da24d` — doc commit inicial
- `20dcc3e` — KBP-17 + anti-drift §Delegation gate (rule-level fix)
- `b25e039` — HANDOFF root cleanup

---

## 7. Coautoria

**Lucas** (medicina + pedagogia + decisao + verificacao empirica PDFs + h2 writing) + **Opus 4.6** (orquestrador: rule-level fix KBP-17 + evidence HTML destilado + wiring + QA Preflight) + **Gemini Flash/Pro** (QA inspect + editorial). Census S148: Lucas + Opus + gemini-3.1-pro-preview + sonar-deep-research + SCite MCP.

Sessao 157 | 2026-04-11 | OLMO
