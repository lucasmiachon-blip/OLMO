# Plan: s-pico QA Final — Leitura e Estado Atual

## Context

s-pico completou QA Round 11 na S145 (2026-04-10). O HANDOFF marca como DONE com score ajustado 7.3/10 (2 FPs, real ~8.0/10). Este plano consolida TODOS os documentos lidos para dar ao Lucas uma visao clara do estado atual e das opcoes de refinamento pendentes.

## Estado Atual — Resumo Executivo

| Aspecto | Score | Status |
|---------|-------|--------|
| Visual | 6.8/10 | 5 fixes aplicados S145 |
| UX+Code | 7.6/10 (ajustado Call D) | OK |
| Motion | 7.6/10 (ajustado Call D — 3 ceiling violations corrigidas) | OK |
| **Overall** | **7.3/10** | **DONE (com ressalvas)** |

### O que foi feito (S145 — 5 CSS fixes)
1. Punchline specificity: `.pico-punchline` → `#deck p.pico-punchline` (beat base.css max-width:56ch)
2. Letter width: `min-width:2ch` → `width:1.5em; text-align:center` (alinha P/I/C/O)
3. Border-top: 2px → 1px (punchline parece conclusao, nao corte)
4. Symbol visibility: `.pico-neq { font-weight:700; font-size:1.15em }`
5. Symbol color: `--downgrade` → `--danger` (DL=15%, hue contrast para 10m)

### FPs confirmados (Call D)
- **css_cascade 6/10** — failsafe rules corretamente scoped; Gemini confunde condicional com global
- **failsafes 5/10** — @media print irrelevante para slides de apresentacao

### Deferred (Lucas decidiu)
- Stagger timing (pares P-I/C-O) — Lucas: "nao tem sentido"

## Refinamentos Pendentes (Call D Priority Actions)

4 priority actions do Call D, **2 MUST + 2 SHOULD**:

### MUST (ainda nao implementados)
1. **Alinhamento irregular das letras hero** — Largura variavel de P/I/C/O no Instrument Serif empurra `.pico-content` para posicoes diferentes no eixo X. Fix proposto: `width:3.5rem; display:inline-block` no `.pico-letter`. **Parcialmente resolvido:** S145 ja aplicou `width:1.5em` — precisa verificar se o alinhamento esta OK visualmente.
2. **Rodape S2 parece corte, nao conclusao** — Linha divisoria ultrapassa a grid. Fix proposto: reduzir max-width da border-top + opacity 20%. **Parcialmente resolvido:** S145 reduziu border-top de 2px→1px — falta avaliar se max-width precisa ajuste.

### SHOULD (nao implementados)
3. **Symbol visibility** — **RESOLVIDO S145** (font-weight:700, font-size:1.15em, cor danger).
4. **Stagger timing** — **DEFERRED por Lucas** ("nao tem sentido").

## Arquivos Chave

| Arquivo | Localizacao |
|---------|-------------|
| Slide HTML | `content/aulas/metanalise/slides/04-pico.html` |
| CSS (pico-grid) | `metanalise.css` L391-469 |
| Animation | `slide-registry.js` L234-273 |
| Manifest | `slides/_manifest.js` L25 |
| Evidence HTML | `evidence/s-pico.html` (21KB) |
| Evidence JSON | `evidence/s-pico.json` (15KB) |
| QA Round Log | `qa-rounds/s-pico.md` |
| Gemini R11 Report | `qa-screenshots/s-pico/gemini-qa3-r11.md` (18KB) |
| Editorial Suggestions | `qa-screenshots/s-pico/editorial-suggestions.md` |
| Gate4 Validation | `qa-screenshots/s-pico/gate4-validate-r11.json` |
| Gate0 Preflight | `qa-screenshots/s-pico/gate0.json` (all PASS) |
| Metrics | `qa-screenshots/s-pico/metrics.json` (fillRatio 82%, 5/5 PASS) |
| Screenshot S0 | `qa-screenshots/s-pico/s-pico_2026-04-10_1515_S0.png` |
| Screenshot S2 | `qa-screenshots/s-pico/s-pico_2026-04-10_1515_S2.png` |

## Decisao Pendente para Lucas

O slide esta DONE com 7.3/10 ajustado (real ~8.0 descontando FPs). Opcoes:

**A) Manter DONE** — Score aceitavel, 5 fixes aplicados, FPs confirmados. Seguir para s-absoluto.

**B) R12 refinamento** — Atacar os 2 MUST restantes (alinhamento letras + max-width border-top). Custo: ~15min CSS + rebuild + screenshot. Potencial ganho: proporcao 6→7, gestalt 6→7.

**C) R12 refinamento visual-only** — Sem rerun Gemini. Aplicar CSS fixes, screenshot, verificar visualmente. Mais rapido, sem custo API.

## Verificacao

Se opcao B ou C:
1. Editar `metanalise.css` (seletores `.pico-letter`, `#deck p.pico-punchline`)
2. `npm run build:metanalise` (na raiz content/aulas/)
3. Screenshot via `node scripts/qa-capture.mjs --aula metanalise --slide s-pico`
4. Comparar S0/S2 com screenshots anteriores
