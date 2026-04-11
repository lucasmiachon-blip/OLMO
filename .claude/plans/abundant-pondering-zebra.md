# S157 — Context melt fix + forest plot slides

> **Sessao:** 157 | **Data:** 2026-04-11
> **Estado:** plan mode, post-compaction
> **Prioridade:** fix context melt PRIMEIRO (documentar + prevenir recorrencia), slides depois

---

## 1. Contexto — por que nao estamos conseguindo conversar

Lucas observou spike de contexto **20% → ~60% ao entrar plan mode**. Isso corrompe a capacidade de dialogar: cada iteracao consome budget desproporcional e o agente perde clareza sobre o que Lucas pediu. Sem fix, repete em S158+.

Hipotese inicial do Lucas: KBP acumulado ou rules inflados em auto-load. **Diagnostico (read-only, ja executado nesta sessao) descarta essa hipotese.**

---

## 2. Root cause — diagnose

### 2.1 Baseline auto-load medido

**Sempre ativo:**

| Arquivo | Linhas |
|---------|--------|
| `~/.claude/CLAUDE.md` (global) | 49 |
| `CLAUDE.md` (projeto) | 76 |
| `.claude/rules/anti-drift.md` | 128 |
| `.claude/rules/coauthorship.md` | 31 |
| `.claude/rules/known-bad-patterns.md` | **58** (Format C+ slim) |
| `.claude/rules/multi-window.md` | 35 |
| `.claude/rules/session-hygiene.md` | 64 |
| `memory/MEMORY.md` | 56 |
| **Subtotal baseline** | **497** |

**Path-triggered (CWD em `content/aulas/**`):**

| Arquivo | Linhas |
|---------|--------|
| `content/aulas/CLAUDE.md` | 83 |
| `content/aulas/metanalise/CLAUDE.md` | 91 |
| `.claude/rules/qa-pipeline.md` | 112 |
| `.claude/rules/design-reference.md` | 119 |
| `.claude/rules/slide-rules.md` | 173 |
| `.claude/rules/slide-patterns.md` | 186 |
| **Subtotal path** | **764** |

**Total estatico: ~1260 linhas ≈ 19k tokens ≈ 10% do context 200k.**

Hooks SessionStart injetam ~140 linhas adicionais (session-start.sh + session-compact.sh + apl-cache-refresh.sh + HANDOFF cat). **Overhead total estatico ≈ 15% worst case.**

### 2.2 Conclusoes primarias

- **KBPs NAO sao o problema** — 58 linhas Format C+ slim. Pointer-only discipline funcionando.
- **anti-drift NAO e o principal vilao** — 128 linhas moderadas.
- **Memory 22 topic files ja sao on-demand** — so o index 56L e eagerly loaded.
- **Baseline max e ~15% do context.** O spike 20→60% nao pode vir de auto-load estatico.

### 2.3 Causa raiz identificada

**Plan mode Phase 1 + Phase 2 multiplicam contexto via agent spawning.**

A instrucao de plan mode (injetada pelo harness toda vez que Lucas entra plan mode) explicitamente encoraja:

- **Phase 1:** "Launch up to 3 Explore agents IN PARALLEL" com comprehensive output
- **Phase 2:** "Launch up to 3 Plan agents" com "comprehensive background context from Phase 1"

Cada Explore agent retorna ~5-15k tokens. Cada Plan agent retorna ~3-8k tokens. Maximo teorico:

- 3 Explore agents: ~45k tokens
- 3 Plan agents: ~24k tokens
- **Total: ~70k tokens ≈ 35% do context 200k**

**20% baseline + 35% (agents) + ~5% (misc reads) ≈ 60%.** Bate exatamente com o que Lucas observou.

---

## 3. Fix — behavioral, nao estrutural

Plan mode JA permite skip. Cita textualmente (na propria instrucao injetada):

- "Use 1 agent when the task is isolated to known files, the user provided specific file paths, or you're making a small targeted change"
- "try to use the minimum number of agents necessary (usually just 1)"
- "Skip agents: Only for truly trivial tasks"

**Regra operacional (S157 e futuras):**

Quando Lucas ja declarou o objetivo e as ancoras sao conhecidas (papers + PMIDs + ficheiros exatos), **pular Phase 1 Explore e Phase 2 Plan agents completamente**. Usar Read/Grep/Glob diretos para verificar ancoras especificas e escrever o plano inline. AskUserQuestion so para decisoes reais (IDs, theme, placement), nunca para exploracao.

**Este fix e comportamental — nao adiciona rule nova.** Adicionar KBP-17 sobre "plan mode agent discipline" seria ironico: a solucao nao e mais regras, e obedecer as regras que plan mode ja declara.

**Metrica de sucesso:** executar Fase 0 deste plano SEM lancar Explore/Plan agents. Contexto deve ficar proximo de 20-30%, nao 60%.

### 3.1 Por que documentar no HANDOFF (nao so no plano)

Sem documentar em lugar durable, repete na proxima sessao. O HANDOFF root e lido em toda SessionStart. **Add secao "Context Melt Protocol" apontando para este plano.**

---

## 4. Slides forest plot — contexto (objetivo secundario, executar DEPOIS do fix)

Lucas quer 2 slides na aula de metanalise ensinando anatomia de forest plot, com **UMA evidence HTML densa** contendo as 2 MAs:

- **Slide 1 — Li Y 2026** *Am J Cardiovasc Drugs*, PMID **40889093** VERIFIED, 14 RCTs, N=31,397. Ensina os 5 elementos anatomicos (square, bar, null line, diamond, weight).
- **Slide 2 — Ebrahimi F 2025** *Cochrane Database Syst Rev*, PMID **41224205** VERIFIED, DOI `10.1002/14651858.CD014808.pub2`, 12 RCTs, N~22,983. Adiciona RoB como meta-elemento + demo live Cochrane + fala de 10s fechando:

> *"Quinze metanalises em quatorze meses sobre o mesmo tema clinico. [pausa 1s] O que isso diz sobre o incentivo do campo?"*

**Base de trabalho (S148 census + S152 brainstorm, ja lidos, nao reabrir):**
- `.claude/workers/colchicine-macce-2025-2026/40-census-final.md` (15 MAs triangulated)
- `.claude/workers/s-forest-planning/2026-04-11-0001_scope-and-reflection.md` (436 L pedagogia)

**Mudancas vs plan S152:**
1. **UMA** evidence HTML (`s-forest-plot.html`), nao duas.
2. `forest-plot-candidates.html` pode ser arquivado/deletado.
3. Living HTML FIRST (ler PDFs, escrever evidence), DEPOIS slides.

---

## 5. Execution

### Fase 0 — Fix context melt (PRIMEIRO, antes dos slides)

**Por que primeiro:** se o fix nao for registrado, repete em S158+ e continuamos sem conversa fluida.

**0.1** Session name:
```bash
echo -n "htmls-forest-plot" > .claude/.session-name
```

**0.2** Plano ja salvo em `.claude/plans/abundant-pondering-zebra.md` (este arquivo).

**0.3** Atualizar `HANDOFF.md` root adicionando secao:

```markdown
## CONTEXT MELT PROTOCOL (S157 lesson)

Observado S157: spike de contexto 20% → 60% ao entrar plan mode.
Causa raiz: Plan mode Phase 1/2 encoraja lancar ate 3 Explore + 3 Plan agents
(~70k tokens combinados de retorno).

Fix behavioral: quando escopo conhecido (Lucas ja declarou objetivo + ancoras
claras: papers, PMIDs, ficheiros), pular Phase 1/2 agents completamente.
Escrever plano inline usando Read/Grep/Glob para ancoras especificas.

Detalhes completos: `.claude/plans/abundant-pondering-zebra.md` §1-§3

**Check antes de lancar Agent em plan mode:**
"Lucas ja me deu arquivos/PMIDs/papers exatos? Se sim → zero agents."
```

**0.4** Commit isolado:
```
S157: context melt fix — document plan mode agent discipline
```

**0.5** Reconciliar `content/aulas/metanalise/HANDOFF.md`:
- Remover linha fantasma `| 8 | s-forest-plot | LINT-PASS | ...` (nunca criado S146)
- Corrigir `16/16 slides` → `15/15`
- Corrigir ordem narrativa F2 (remover `-> s-forest-plot`)
- Remover `s-forest-plot` da lista dark-bg (5→4)

**Commit:** `S157: reconcile HANDOFF aula — remove s-forest-plot phantom`

**0.6** Reconciliar `HANDOFF.md` root:
- Remover P0 "Slide A: Vaduganathan 2022" (superseded por S152)
- Substituir por "S157: context melt fix + 2 slides forest plot em execucao"

**Commit:** `S157: HANDOFF root — supersede Vaduganathan carry-over`

**STOP** — Lucas confirma que contexto nao explodiu nesta sessao (metrica subjetiva do fix).

---

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

**7.1** `content/aulas/metanalise/HANDOFF.md`: 15/15 → 17/17 slides, add entries s-forest1/s-forest2, update F2.

**7.2** `content/aulas/metanalise/CHANGELOG.md`:
```markdown
## S157 — 2026-04-11 — htmls-forest-plot

- Context melt fix: document plan mode agent discipline (HANDOFF root + plano arquivado)
- Add s-forest1 (Li 2026 AJCD, PMID 40889093) — anatomia 5 elementos
- Add s-forest2 (Ebrahimi 2025 Cochrane, PMID 41224205) — RoB meta-elemento + demo live + fala 10s
- Add s-forest-plot.html evidence unico (Li + Ebrahimi + 15 MAs census destilado)
- Preserve colchicine-macce-census-S148.md em references/
- Archive legacy forest-plot-candidates + s-forest-plot DRAFT S146
- Reconcile HANDOFF aula: remove s-forest-plot phantom (15→17)
```

**7.3** `HANDOFF.md` root: session S157 → S158. Manter Context Melt Protocol (lesson durable).

**7.4** Workers preservados (KBP-10 + trail epistemologico):
- `.claude/workers/colchicine-macce-2025-2026/` intacto (40-census ja movido)
- `.claude/workers/s-forest-planning/` intacto
- Listar em BACKLOG S162+ review (minimo 5 sessoes)
- **NAO deletar** sem Lucas OK.

**Commit final:** `S157: wrap — 2 forest slides DONE + context melt documented`

---

## 6. Out of scope (explicit NOT)

- Pre-readings legacy (`pre-reading-forest-plot-vies.html`, `pre-reading-heterogeneidade.html`) — Lucas explicit: read-only
- 9 `<th colspan="2">` a11y gap em `forest-plot-candidates.html` — HANDOFF root P1 defer
- 14 links `rel="noopener"` + 3 `<th scope="col">` em `pre-reading-heterogeneidade.html` — benchmark read-only
- Worker cleanup (KBP-10 + anti-fragilidade — preservar trail)
- Vaduganathan slide A — superseded por S152
- Narrow rule paths ou slim memory — diagnosticado como NAO sendo causa do spike
- Adicionar KBP-17 sobre plan mode agents — fix e comportamental, nao mais regra
- Construir forest plot SVG from scratch (hard constraint metanalise CLAUDE.md #5)
- Comparacao estatistica entre Li e Ebrahimi (nao e o ponto pedagogico)
- Slide RoB standalone (RoB integrada no crop Ebrahimi)

---

## 7. Critical files

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
- `HANDOFF.md` root — add Context Melt Protocol + supersede Vaduganathan
- `content/aulas/metanalise/HANDOFF.md` — reconcile phantom, 15/15→17/17
- `content/aulas/metanalise/CHANGELOG.md` — S157 entry
- `content/aulas/metanalise/slides/_manifest.js` — +2 entries
- `content/aulas/metanalise/metanalise.css` — +selectors scopados
- `content/aulas/metanalise/slide-registry.js` — condicional D3
- `.claude/.session-name`
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

## 8. Verification (end-to-end)

### Context melt fix (Fase 0)

1. Executar Fase 0 sem lancar Explore/Plan agents → contexto fica proximo de 20-30%, nao 60%
2. `HANDOFF.md` root tem secao "CONTEXT MELT PROTOCOL" visivel em proxima session start
3. `.claude/plans/abundant-pondering-zebra.md` preservado (plan mode artifact)
4. Lucas reporta subjetivamente que conversa voltou a fluir

### Slides (Fases 1-7)

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
9. **HANDOFFs coerentes:** root com Context Melt Protocol, aula 17/17, sem fantasma, sem Vaduganathan

---

## 9. Commits (~12)

1. `S157: context melt fix — document plan mode agent discipline`
2. `S157: reconcile HANDOFF aula — remove s-forest-plot phantom`
3. `S157: HANDOFF root — supersede Vaduganathan carry-over`
4. `S157: preserve colchicine census (15 MAs S148)`
5. `S157: archive legacy forest-plot files`
6. `S157: add s-forest-plot.html — dense evidence (Li + Ebrahimi + 15 MAs)`
7. `S157: add forest plot crops + Cochrane backup`
8. `S157: add s-forest1 — DRAFT (h2 placeholder)`
9. `S157: s-forest1 DONE — Li 2026 anatomy (QA approved)`
10. `S157: add s-forest2 — DRAFT`
11. `S157: s-forest2 DONE — Ebrahimi RoB meta-element (QA approved)`
12. `S157: wrap — HANDOFF + CHANGELOG + workers preserved`

---

## 10. Coautoria

**Lucas** (medicina + pedagogia + decisao + verificacao empirica PDFs + h2 writing) + **Opus 4.6** (orquestrador: diagnose context melt + reconciliacao + evidence HTML destilado + wiring + QA Preflight) + **Gemini Flash/Pro** (QA inspect + editorial). Census S148: Lucas + Opus + gemini-3.1-pro-preview + sonar-deep-research + SCite MCP.

Sessao 157 | 2026-04-11 | OLMO
