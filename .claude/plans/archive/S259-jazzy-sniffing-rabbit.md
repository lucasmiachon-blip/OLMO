# Plano — heterogeneity-evolve (jazzy-sniffing-rabbit)

> **Sessão worker S259** (date 2026-04-26). Outra instância: orchestrator auditando hooks (KBP-42 emergente).
> **Plan mode até ExitPlanMode.** Foco: **clareza para residentes iniciantes**, não sofisticação CSS.

## Context

- Lucas apresentou heterogeneidade + RE/FE com narrativa **4/10** na primeira apresentação real
- Causa: evidence não ajudou durante aula + slides confusos para residentes
- s-etd (`14-etd.html`) está **muito bom** (único slide com modelo híbrido até agora) — não tocar
- Outros slides precisam **complementá-lo** = elevar `s-heterogeneity` + `s-fixed-random` ao padrão híbrido s-etd
- PI (Intervalo de Predição) é conceito sofisticado para iniciantes → **fica no evidence, NÃO em slide**
- Pesquisa adaptada para fortalecer evidence: multi-model (Claude + Gemini + ChatGPT 5.5 Xhigh novo)
- Scripts → agents/skills é meta-projeto futuro (DEFERRED nesta sessão)

## Achados Phase 1 (3 Explore agents)

### Slide canônico: `14-etd.html`
- `class="theme-dark"` em `<section>` (único no deck)
- `var(--v2-safe-on-dark)` etc via `shared-bridge.css`
- `color-mix(in oklch, …)` + `subgrid` + logical properties + `<cite>` em source-tag

### Architectural pattern: brownfield evolution
- `shared-bridge.css` define `:where(section#X) { --token: var(--v2-…) }` — especificidade zero
- Slide opta-in adicionando `class="theme-dark"` ou referenciando `var(--v2-*)`
- Strangler fig em CSS — slide-a-slide, sem big-bang

### Slides de heterogeneidade — set identificado
| Pos | File | ID | Ação |
|---|---|---|---|
| 9 | `08a-forest1.html` | `s-forest1` | Não tocar (forest plot real, het zones funcionam) |
| 10 | `08b-forest2.html` | `s-forest2` | Não tocar |
| 13 | `09a-heterogeneity.html` | `s-heterogeneity` | **REFACTOR híbrido + clareza iniciantes** |
| — | `09b-i2.html` | `s-i2` | **DEFERRED** (órfão; Higgins "desinformativos" sofisticado p/ iniciantes) |
| 14 | `10-fixed-random.html` | `s-fixed-random` | **REFACTOR híbrido + clareza iniciantes** |

### Evidence file
- `evidence/s-heterogeneity.html`: 28 PMID/DOI links, 12 V verified, 5 gaps documentados, ISBN, PI já tem seção com GLP-1 + clozapina
- CSS hardcoded HEX (sem tokens, sem dark mode) — modernização **opcional** secundária

## Open questions (Lucas decide ANTES de Phase B)

1. **`theme-dark` em s-heterogeneity / s-fixed-random?** s-etd é dark-bg. Replicar dark ou manter light? (Decisão visual + APCA contrast Lc ≥ 75)
2. **Storyboard narrativo para iniciantes** (Phase B output) — Lucas aprova antes do refactor visual
3. **Phase D evidence** — fazer nesta sessão ou separar? Pesquisa multi-model (ChatGPT 5.5 Xhigh) entra agora ou só preencher gaps documentados com workflow atual?

## Phases

### Phase A — Read s-etd canônico (read-only, post-ExitPlanMode)
1. `slides/14-etd.html` — estrutura completa
2. Seção `section#s-etd` em `content/aulas/metanalise/css/metanalise.css`
3. `shared-bridge.css` (path a confirmar via Glob) — tokens `--v2-*` disponíveis
4. `slide-registry.js` entry para `s-etd` — wire pattern
5. `slide-rules.md` + `design-reference.md` (targeted Grep às seções relevantes)

### Phase B — Storyboard para iniciantes (Lucas approve before C)
Princípio guia: **menos é mais para working memory de residente iniciante**. Cada slide tem 1 idea-unit e termina com 1 takeaway.

Sequência proposta:
- `s-forest1` / `s-forest2` (existentes, sem mudança) — anatomia + I² visual ao vivo
- `s-heterogeneity` (refactor) — paradoxo I² em 1 frase + caveat: "I² alto não indica magnitude clínica"; sem PI, sem audit Tatas/Higgins
- `s-fixed-random` (refactor) — escolha estatística simples: "FE = mesmo efeito real assumido; RE = efeitos variam; quando duvidar, RE com cautela"

Output Phase B: 2 wireframes (ASCII + bullets) por slide. Lucas valida.

### Phase C — Per-slide refactor (1 slide = 1 commit, anti-batch)

Por slide, sequência:
1. Read seção atual em `metanalise.css` ± 20 li
2. Read HTML do slide
3. Edit HTML: estrutura, classes (`theme-dark` se decisão), source-tag → `<cite>`, beats redesenhados
4. Edit CSS: tokens `var(--v2-*)`, logical properties, `color-mix`, subgrid se útil
5. `npm run lint:slides` (zero errors)
6. `bash scripts/validate-css.sh`
7. `node scripts/qa-capture.mjs --aula metanalise --slide X` (screenshot diff)
8. `node scripts/apca-audit.mjs` (Lc ≥ 75 body se theme-dark)
9. Vite browser review (Lucas)
10. Lucas approval → `git add <files>` + commit

### Phase D — Evidence expansion `evidence/s-heterogeneity.html`
1. PI section deep dive (já existe; expandir GLP-1 + clozapina + adicionar exemplo terceiro?)
2. Preencher 5 gaps documentados (Higgins 2025, Siemens 2025 como CANDIDATE; "96% I²-only" fonte; exemplos livro-texto)
3. Pesquisa multi-model (decisão Lucas Open #3): se SIM, adicionar braço ChatGPT 5.5 Xhigh + Gemini + Claude triangulação para refs novas
4. Modernizar visual (tokens + dark mode) — **opcional**, defer se time pressed
5. Lucas review → commit

### Phase E — Final pass
- `metanalise/HANDOFF.md` (stale desde S162) → manifest S207 + estados pós-refactor
- `CHANGELOG.md` S259 entry: 1 line per commit + ≤5 li learnings
- KBP candidates do session (se houver)

## Critical files

**Modify:**
- `content/aulas/metanalise/slides/09a-heterogeneity.html`
- `content/aulas/metanalise/slides/10-fixed-random.html`
- `content/aulas/metanalise/css/metanalise.css` (seções s-heterogeneity + s-fixed-random)
- `content/aulas/metanalise/evidence/s-heterogeneity.html`
- `content/aulas/metanalise/HANDOFF.md`
- `CHANGELOG.md`

**Read-only references:**
- `content/aulas/metanalise/slides/14-etd.html` (canônico)
- `content/aulas/metanalise/css/metanalise.css` (section#s-etd)
- `shared-bridge.css` (path a confirmar)
- `content/aulas/metanalise/slides/slide-registry.js` (entry s-etd)
- `content/aulas/scripts/{lint-slides.js, validate-css.sh, apca-audit.mjs, qa-capture.mjs}`
- `.claude/rules/slide-rules.md` + `design-reference.md` + `qa-pipeline.md`

## Reused patterns from s-etd
- `class="theme-dark"` em `<section>`
- `var(--v2-safe-on-dark/warn-on-dark/danger-on-dark)`
- `color-mix(in oklch, ...)`
- `subgrid` em layouts complexos
- Logical properties (`inline-size`, `block-size`, `margin-block-*`)
- `<cite>` em source-tag

## Verification end-to-end

1. `npm run lint:slides` (zero errors em arquivos modificados)
2. `bash content/aulas/scripts/validate-css.sh`
3. `node content/aulas/scripts/apca-audit.mjs --aula metanalise` (Lc ≥ 75 body em theme-dark)
4. `node scripts/qa-capture.mjs --aula metanalise --slide X` (screenshot diff vs baseline)
5. **Vite visual:** `npm run dev:metanalise` (Lucas browser review per slide)
6. `npm run lint:case-sync`
7. **Per-slide commit gate:** Lucas approval (1 slide = 1 commit, anti-batch)

## Cautions ativas

- **Plan mode discipline** até ExitPlanMode
- **KBP-22** silent execution: EC loop visível antes de cada Edit pós-exit
- **KBP-25** Edit precision: Read full ± 20 li antes de cada Edit
- **KBP-30** manifest add → HANDOFF slide count update (não adicionando slides nesta sessão; confirmar HANDOFF state)
- **KBP-32** spot-check: confirmar `shared-bridge.css` path exato antes de Edit
- **KBP-40** branch awareness: `git branch --show-current` antes do primeiro commit
- **KBP-42** hook silent without consumer = teatro candidate — orchestrator session cuida; **não cruzar escopo**
- **`mellow-scribbling-mitten Track A P5`** em outra branch (`feat/shell-sota-migration`) — não afeta metanálise
- **Anti-SOTA guard ≤30%** session em meta-work
- **APL=HIGH** first-turn discipline; Read com `limit`; Grep targeted

## Deferred (sessão futura)

- `s-i2` órfão integration — Tatas 2025 + Higgins 2025 "desinformativos" sofisticado para iniciantes (pode entrar em curso avançado / refresher residentes 2º ano)
- Scripts → agents/skills migration — meta-projeto, escopo grande
- ChatGPT 5.5 Xhigh como braço permanente do pipeline pesquisa — depende decisão Open #3
- Evidence visual modernization completa (tokens + dark) — secundário
- Forest1 / Forest2 melhorias — não estão confusos segundo Lucas

## Status (re-entrada plan mode #2 — S259)

### Phase C0 ROB2 restoration — ~95% DONE (Lucas: "ficou bom")

**Edits aplicados + aprovados:**
- ✅ HTML: `class="theme-dark"` + 4× `<div class="rob2-bar-track">` wrappers
- ✅ CSS bar block: track + bar-fill height/transition + `.rob2-bar` grid (3ch 1fr auto, gap md)
- ✅ CSS section root: `background-color: #162032` + 4 token text-* overrides
- ✅ CSS `--kappa-*`: muted editorial palette (chroma 0.08-0.10 — Lucas request "muito vibrantes")
- ✅ CSS `:has()` edge bleed fix universal (replaces MutationObserver workaround — modern, sem remendo)
- ✅ CSS `.rob2-figure`: white card (bg + radius + padding + shadow oklch) — replace `mix-blend-mode: multiply`
- ✅ CSS `.rob2-figure img`: `mix-blend-mode: multiply` removido
- ✅ CSS `.rob2-kappa`: `align-self: start` + `justify-content: flex-start` (Lucas: "subir conteudo")
- ✅ CSS `.kappa-stats`: `display: grid` + `grid-template-columns: 4ch auto`
- ✅ CSS `.kappa-val`: `min-width: 4ch` + `tabular-nums lining-nums` + `text-align: right` (LAST PROP CAUSA O BUG)

**Verificação atual:**
- Build PASS · Lint Clean · Validate-css PASS · qa-capture 0F/0W
- Visual: white card OK, κ subiu OK, palette muted OK, MAS números colados ao label

### Issue residual confirmado pelo Lucas

> "ficou bom so precisa arrumar o conteudo e alinhamento"

**(1) Alinhamento:** números "0,45moderada" sem espaço. Causa: `.kappa-val { text-align: right }` empurra valor ao end do col 4ch → cola contra label.

**(2) Conteúdo:** ambíguo — pode ser:
- (a) typography weight em D1-D5 list (GENESIS pode ter weight maior)
- (b) ROBUST-RCT chip styling
- (c) layout column proportion 7fr 5fr vs 1fr 1fr (ainda 7fr 5fr no OLMO; 1fr 1fr causou overflow em test anterior)
- (d) outra coisa específica que Lucas tem em mente

## Plano refined (post-ExitPlanMode)

### Phase C0.1 — Alignment fix (1 Edit)
**Single fix, baixíssimo risco:**

```css
section#s-rob2 .kappa-val {
  font-size: 1.4rem;
  font-weight: 700;
  color: var(--text-primary);
  min-width: 4ch;
  /* text-align: right removido */
  font-variant-numeric: tabular-nums lining-nums;
}
```

`tabular-nums` + `min-width: 4ch` já garante alinhamento perfeito entre rows. `text-align: right` era redundante e causava colisão visual.

### Phase C0.2 — Conteúdo audit (read-only first)
1. **Re-capture 4110** via Chrome DevTools MCP (qa-capture limpou o PNG anterior)
2. **Side-by-side compare** novo OLMO 2045_S2 vs novo 4110 capture
3. **Apresentar diferenças visuais residuais** ao Lucas com screenshots
4. **Lucas confirma** o que "conteúdo" significa (a/b/c/d acima ou outro)
5. **Propor fix específico** com EC loop + esperar OK

### Phase C0.3 — Commit checkpoint
**Antes de Phase C0.2 (ou depois — Lucas decide ordem):**
- `git add content/aulas/metanalise/slides/08c-rob2.html content/aulas/metanalise/metanalise.css content/aulas/metanalise/index.html`
- `git commit -m "fix(metanalise): restore ROB2 from OLMO_GENESIS reference"`
- Mensagem inclui: theme-dark + bar-track wrappers + white card + :has() edge bleed + κ subiu + bars muted + tabular-nums alignment
- 79min sem commit (NUDGE) — work product está em estado coerente para snapshot

## Sequência executiva proposta (re-plano #3 S259)

### Estado pós-edits anteriores
- ✅ Subgrid funcionou — alignment dos 4 bars compartilha colunas
- ✅ Source-tag removido
- ✅ White card RoB
- ✅ κ subiu para topo do grid cell
- ⚠️ Palette ainda chutada — D4/D3 azul-pálido em navy (mix com `--text-on-dark` lavou)

### Próxima ação — Tokens profissionais Paul Tol (não literais inventados)

Lucas: "ajustar tokens e palheta", "sem ficar chutando cores", "palheta profissional".

`shared/css/base.css:79-91` declara Paul Tol palettes como tokens PROFISSIONAIS:
```css
--data-1: #4477AA  --data-2: #EE6677  --data-3: #228833
--data-4: #CCBB44  --data-5: #66CCEE  --data-6: #AA3377
--data-7: #BBBBBB
```

Tol é referência publicada (TU Delft 2018), color-blind safe, adopted em Nature/BMJ/NEJM. Cirrose.css já usa precedente.

**Mapping κ → Tol Bright:**
- D1 (best κ=0,45): `var(--data-1)` blue saturado #4477AA
- D4 (κ=0,28 mid): `var(--data-5)` light cyan #66CCEE
- D3 (κ=0,22 weak): `var(--data-7)` gray #BBBBBB (fading)
- D2 (worst κ=0,04): `var(--data-2)` warm red #EE6677 (outlier)

### Single Edit (palette swap)

```css
section#s-rob2 {
  /* … */
  /* Kappa concordance — Paul Tol Bright palette (scientific viz standard). */
  --kappa-d1: var(--data-1);
  --kappa-d4: var(--data-5);
  --kappa-d3: var(--data-7);
  --kappa-d2: var(--data-2);
}
```

### Sequência pós-ExitPlanMode

1. **Edit `--kappa-*`** com Tol tokens (1 Edit)
2. **Build + lint** validation
3. **qa-capture** (Lucas autoriza após edit OR Lucas captura manual)
4. **Lucas valida** visualmente o screenshot
5. Se OK → atualizar **HANDOFF + CHANGELOG** (S259 entry para ROB2 restoration)
6. **git status** + branch awareness (KBP-40, 2-window aware)
7. **git add** files específicos (08c-rob2.html, metanalise.css, .slide-integrity, index.html, HANDOFF, CHANGELOG)
8. **git commit** — message inclui ROB2 restoration scope
9. **git push** (Lucas autorizou no plan original)

### Não tocar (outras janelas em curso)
- `.claude/plans/entre-em-plan-vamos-sunny-gosling.md` — outra sessão
- `.claude/plans/warm-snacking-hinton.md` — outra sessão
- Qualquer file não-rob2 (tokens-base.css, shared/, etc)

### Cuidados continuados

- **Loop propose-wait-execute** — Lucas explicitou múltiplas vezes
- **Não chutar cores** — usar tokens published OU análise APCA documentada
- **Capture/screenshot** somente quando Lucas autoriza ou pede
- **2-window awareness** — outras sessões podem tocar files diferentes; verificar git status antes de commit

## Observações críticas

- **Loop propose-wait-execute estrito** — Lucas explicitou "sempre fale o que vai fazer espere aprovação"
- **Auto mode pode estar ativo** mas plan mode + diretiva Lucas supersede
- **Custo HIGH** (1080+ tool calls) — economizar reads/edits, batch onde possível
- **Não tocar slide-registry.js** — `:has()` CSS já cobre edge bleed sem JS workaround
- **s-heterogeneity + s-fixed-random** continuam DEFERRED até ROB2 fechar

## Deferred (fora escopo C0)

- s-heterogeneity refactor (Phase C1 — pending)
- s-fixed-random refactor (Phase C2 — pending)
- Evidence expansion (Phase D — pending)
- HANDOFF + CHANGELOG update (Phase E — pending)
- s-i2 órfão integration (sessão futura)
- Migrate s-etd MutationObserver → `:has()` (não nesta sessão; s-etd está bom como está)

---

## Re-entry plan mode #4 — S260 (date 2026-04-26 evening)

### G1 Lucas decision

**Failure mode dominante:** "Conteúdo cognitivamente pesado" — slides + evidence não se explicaram por si em aula real. Lucas: "eu não consegui explicar e os slides não se explicaram por si".

**Escopo redefinido:**
- **NÃO** replicar `theme-dark` cegamente — Lucas: "profissionais não fazem isso". Theme-dark reservado para slides de impacto/checkpoint (s-ancora, s-absoluto, s-checkpoint-2). Slides didáticos = light bg.
- **Foco**: reescrita textual storyboard B (HANDOFF root: "storyboard B aprovado").
- **Par slide+evidence**: ambos precisam virar autoexplicativos.

### Phase C1 — s-heterogeneity textual rewrite

**Princípio:** o slide ensina **a lição**, não a definição. I² é só o gancho visual.

| Elemento | ATUAL | PROPOSTO | Razão |
|---|---|---|---|
| h2 | "Dois forest plots com I² de 67% podem esconder realidades clínicas opostas" | "Mesmo I² de 67% — mas decisões clínicas opostas" | encurta; ênfase em "decisão" (target = residente decisor) |
| verdict safe | "Todos beneficiam" | "Estudos concordam clinicamente — todos apontam benefício" | explicita concordância clínica vs estatística |
| verdict danger | "Alguns podem ser prejudicados" | "Estudos divergem clinicamente — alguns ajudam, outros prejudicam" | explicita divergência clínica vs estatística |
| def | "I² = proporção da variação entre estudos que não é acaso" | "**I² mede dispersão estatística**, não magnitude clínica" | elimina "proporção da variação" (jargão); contraste estatística↔clínica é A lição |
| caveat | "Depende do tamanho e precisão dos estudos, não da relevância clínica" | "Dois estudos pequenos discordando dão I² baixo; dois mil grandes concordando dão I² alto" | concretiza com exemplo numérico — fixa intuição |
| source-tag | "Borenstein 2024 · Cochrane Handbook v6.5" | `<cite>` "Borenstein 2024 (PMID 37940120) · Cochrane Handbook v6.5 · Higgins 2025" | semantic HTML5; adiciona Higgins 2025 (creator's reflections, evidence linha 59) |

**Notas:**
- PI (intervalo de predição) **fica no evidence** (storyboard B aprovado).
- Sem matemática (Q, τ², fórmulas) no slide.
- Mantém SVG forest plots — visual já funciona; só texto recalibra.

### Phase C2 — s-fixed-random textual rewrite

**Princípio:** o slide ensina **decisão a priori sobre o mundo**, não mecânica de pesos.

| Elemento | ATUAL | PROPOSTO | Razão |
|---|---|---|---|
| h2 | "Mesmos dados, conclusões diferentes" | "Mesmos dados, conclusões diferentes — a escolha do modelo importa" | explicita stakes; sinaliza por que olhar slide |
| verdict FE | "Peso concentrado nos grandes" | "Assume um único efeito real em todos os estudos" | premissa do mundo (not mecânica) — alinha com evidence linha 107 "Premissa" |
| verdict RE | "Peso redistribuído aos menores — IC mais amplo" | "Aceita que o efeito varia entre populações" | premissa do mundo |
| def | "Efeitos aleatórios, padrão Cochrane atual — 42% utilizam de forma não adequada" | "**A escolha vem antes dos dados** — depende se faz sentido clínico todos os estudos terem o mesmo efeito real" | remove "42%" (Lucas G0); ensina A LIÇÃO PROFUNDA do evidence linha 115 (decisão a priori) |
| caveat | "Modelo fixo só funciona em cenários excepcionais" | "Quando duvidar, use efeitos aleatórios — padrão Cochrane v6.5" | regra prática direta para residente |
| source-tag | "Tatas 2025 · Mheissen 2024 · Cochrane v6.5" | `<cite>` "Borenstein 2021 · Cochrane Handbook v6.5 · Mheissen 2024 (PMID 38502662)" | troca Tatas (audit "42%" removido) por Borenstein (livro fundamental) + PMID semântico |

### Phase D — evidence/s-heterogeneity.html (post-C1+C2)

**Lucas decide escopo após slides commitarem.** Hipóteses (não executar até confirmar):
1. **Box "Como ler um forest plot em 3 passos"** no topo (atalho cognitivo p/ residente)
2. **Mensagem central como sidebar fixa** (linha 63 do evidence — repetida em cada seção)
3. **Mini-decisão clínica** ao final: "Você lê I²=78%. Que pergunta faz a seguir?"
4. Mover DL/REML/HKSJ + ICEMAN + GRADE Core para `<details>` (já são deep-dive — reduz peso visual)
5. Adicionar **2 prediction intervals com "tradução plain-text"** (sem fórmula): "Em 60% dos cenários comparáveis, esse benefício se mantém"

### Sequência executiva (post-ExitPlanMode)

1. **C1** Edit `09a-heterogeneity.html` (3 elementos textuais + source-tag → `<cite>`) — 1 Edit, 1 commit
2. **Build + lint:slides + validate-css**
3. **Vite browser** — Lucas valida que slide "se explica sozinho"
4. **Commit C1** isolado
5. **C2** Edit `10-fixed-random.html` (idem) — 1 Edit, 1 commit
6. **Build + lint** (manifest já está OK — confirmar)
7. **Vite browser** — Lucas valida
8. **Commit C2** isolado
9. **Pause + Lucas decide escopo D** (qual hipótese 1-5 acima)
10. **D Edit** evidence (escopo definido) — 1 commit
11. **E** HANDOFF + CHANGELOG S259 entry com 3 commits + KBP candidates

### Gates per-commit (idem C0 ROB2)

- KBP-22: EC loop visível antes de Edit
- KBP-25: Read full ± 20 li antes de Edit
- KBP-40: branch awareness antes de commit
- 1 slide = 1 commit (anti-batch)

### Não-objetivos S260 (esta sessão)

- ❌ Adicionar PI no slide (storyboard B: PI fica no evidence)
- ❌ theme-dark em s-heterogeneity ou s-fixed-random
- ❌ Tol tokens substituindo `--safe`/`--danger` (semantic é correto aqui — clinical safe/danger, não data-viz neutro)
- ❌ Mexer em `_manifest.js` (headlines podem mudar; verificar pós-C1/C2)
- ❌ Cleanup CSS visual (lucas: visual aceitável)
- ❌ Phase C0 audit (ROB2 fechado, commit `56301bc`)

