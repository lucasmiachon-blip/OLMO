# Plan: QA Gemini R13 s-importancia + Speaker Notes

## Context

R12 scored 6.5/10 (Visual 5.8, UX+Code 6.2, Motion 7.4). Improvement from R11 (5.2).
Key issues: CSS cascade FPs (4/10), failsafes FPs (3/10), distribution (5/10), composition (5/10).
Some findings are known FPs: `[data-qa]` selectors flagged as bugs, opacity:1 in QA context.
HANDOFF S139 P0 items: structured output (WHAT/WHY/PROPOSAL/GUARANTEE), consider additional call, speaker notes.

## Part 1: Prompt Template Changes (WHAT/WHY/PROPOSAL/GUARANTEE)

### Why
R12 output has subjective notes ("domina excessivamente", "padrão") and proposals without verification criteria.
Decision S139: Gemini must report WHAT/WHY/PROPOSAL/GUARANTEE, no subjective notes.

### Changes to all 3 prompt files

**gate4-call-a-visual.md** (content/aulas/metanalise/docs/prompts/)
- Replace dimension output instructions with WHAT/WHY/PROPOSAL/GUARANTEE structure
- Map to existing schema fields: `evidencia`=WHAT, `problemas`=WHY, `fixes`=PROPOSAL+GUARANTEE
- Add known FP note: "Navy card 300px is intentional hero. ΣN = design anchor. Do NOT flag card size."
- Add: "Sem notas subjetivas. Cada problema = fato observavel + medida concreta."

**gate4-call-b-uxcode.md**
- Same WHAT/WHY/PROPOSAL/GUARANTEE mapping
- Add known FP: "`[data-qa]` selectors exist intentionally for QA capture. Do NOT flag as dead CSS or failsafe issue."
- Add known FP: "opacity:1 under `.no-js`, `.stage-bad`, `[data-qa]`, `@media print` is intentional failsafe design."
- Proposals: add `guarantee` instruction — "Cada proposal DEVE incluir no campo fix: GUARANTEE: como verificar que funcionou."

**gate4-call-c-motion.md**
- Same structure
- Add: "Card entry scale 0.92→1 is intentional metaphor (growth = combining samples). Do NOT flag as decorative."

### Concrete prompt diff (example for call-a)

In the DIMENSOES section, after each dimension description, add:
```
Formato OBRIGATORIO por dimensao:
- evidencia (WHAT): descricao factual do que voce VE. Sem adjetivos subjetivos.
- problemas (WHY): causa raiz do problema, nao sintoma. "Font 18px ilegivel a 6m" nao "texto pequeno".
- fixes (PROPOSAL + GUARANTEE): acao concreta + "GUARANTEE: [como verificar]"
- nota: 1-10
```

### Schema change in gemini-qa3.mjs (line ~374)

Add optional `guarantee` field to DIM_PROP:
```javascript
const DIM_PROP = {
  type: "OBJECT",
  properties: {
    evidencia: { type: "STRING" },
    problemas: { type: "ARRAY", items: { type: "STRING" } },
    fixes: { type: "ARRAY", items: { type: "STRING" } },
    guarantee: { type: "ARRAY", items: { type: "STRING" } },  // NEW
    nota: { type: "NUMBER", minimum: 0, maximum: 10 },
  },
  required: ["evidencia", "problemas", "fixes", "nota"],  // guarantee optional
};
```

Add `guarantee` to proposal items too (line ~405):
```javascript
properties: {
  severity: { type: "STRING" }, titulo: { type: "STRING" },
  fix: { type: "STRING" }, guarantee: { type: "STRING" },  // NEW
  arquivo: { type: "STRING" }, tipo: { type: "STRING" },
},
required: ["severity", "titulo", "fix", "arquivo", "tipo"],  // guarantee optional
```

Backward compatible — existing scorecards parse normally.

## Part 2: Additional Call Assessment

**Recommendation: NO additional call for R13.**

Why:
1. The 3 calls already have focused domains (visual-only, code+ux, motion-only)
2. R12 quality was adequate — the problem is format, not attention
3. Known FPs (css_cascade 4/10, failsafes 3/10) inflate the "problem count" artificially
4. Adding a 4th synthesis call costs ~$0.02-0.03 extra per round
5. Better prompts + FP injection in round context should fix the output quality

If R13 still shows attention issues (dimensions with empty evidence, scores that contradict findings), THEN add synthesis call in R14.

The real attention problem in R12 was call B having too much input (HTML+CSS+JS+PNGs+round context+error digest = ~8K tokens). Fix: inject known FPs in round context so the model doesn't re-discover them, freeing attention for real issues.

## Part 3: Round Context Update

Update `content/aulas/metanalise/qa-rounds/s-importancia.md` — append R12 status + known FPs:

```markdown
## Round 12 Gate 4 (2026-04-10)
...existing content...
Status: ADDRESSED — CSS work done S139 (click-reveal, dead CSS, font 18px)

### Known FPs (inject into R13)
- css_cascade: `[data-qa]` selectors are intentional for QA capture, NOT dead CSS
- failsafes: opacity:1 under `.no-js`, `.stage-bad`, `[data-qa]` is intentional design
- proporcao: Navy card 300px is hero (Lucas decision S139). ΣN = design anchor
- easing: power2.out for card entry is intentional (pragmatic, not "padrão")
- proposito: scale 0.92→1 is metaphor (growth = combining samples), not decorative
```

## Part 4: Speaker Notes for Evidence HTML

**File:** content/aulas/metanalise/evidence/s-importancia.html (lines 170-175)
Replace placeholder in `<details><summary>Speaker Notes (timestamps)</summary>`.

Content (6 beats across 60s):

```
[0:00-0:05] Card ΣN entra (auto-play 0.7s).
Falar: "Somatório de N — é disso que se trata a meta-análise."
PAUSA 3s. Deixar o símbolo impactar.

[CLICK 1 — ~0:08] Poder Estatístico
Falar: "65 trials de beta-bloqueador pós-IAM — todos negativos isolados. A MA juntou: redução de 25% na mortalidade."
Ênfase: "negativo por falta de amostra, não por falta de efeito"
[DATA] Yusuf 1985 — Prog Cardiovasc Dis | Verificado: 2026-04-10

[CLICK 2 — ~0:18] Precisão
Falar: "Estreptocinase — em 1973 com 8 trials, OR 0,74. Em 1988 com 33 trials? Mesmo OR, IC dramaticamente mais estreito."
Ênfase: "25 trials depois não mudaram a direção — só confirmaram"
[DATA] Lau 1992 — NEJM | Verificado: 2026-04-10

[CLICK 3 — ~0:28] Resolução de Controvérsias
Falar: "Dois trials discordam. É heterogeneidade real ou acaso? A MA responde — se era acaso, o pooling dissolve."
Ênfase: subgrupos localizam a fonte quando heterogeneidade é real

[CLICK 4 — ~0:38] Detecção de Efeitos Pequenos
Falar: "RR 0,88 — efeito de 12%. Precisa de mais de 50.000 pacientes para poder de 80%. Nenhum trial faz isso sozinho."
Ênfase: "ausência de evidência não é evidência de ausência"

[CLICK 5 — ~0:48] Generalização
Falar: "Um trial = um centro, uma faixa etária. A MA reúne contextos distintos. Quando o efeito se mantém — confiança robusta."

[0:55-1:00] Transição
"Cinco vantagens. Mas vantagens não significam infalibilidade. Vamos ver agora como ler uma MA com rigor."
Transição → s-checkpoint-1 (ACCORD trap)
```

## Part 5: Execution Sequence

1. Edit 3 prompt files (WHAT/WHY/PROPOSAL/GUARANTEE)
2. Edit gemini-qa3.mjs schema (add `guarantee` field)
3. Update round context with FPs
4. Write speaker notes in evidence HTML
5. Build: `npm run build:metanalise` (from content/aulas/)
6. Capture: `node scripts/qa-capture.mjs --aula metanalise --slide s-importancia`
7. Run R13: `node scripts/gemini-qa3.mjs --aula metanalise --slide s-importancia --editorial --round 13`
8. Review output: verify WHAT/WHY/PROPOSAL/GUARANTEE structure
9. Session docs (HANDOFF + CHANGELOG)

## Files Modified

| File | Change |
|------|--------|
| `metanalise/docs/prompts/gate4-call-a-visual.md` | WHAT/WHY/PROPOSAL/GUARANTEE format + known FPs |
| `metanalise/docs/prompts/gate4-call-b-uxcode.md` | Same + proposal guarantee field |
| `metanalise/docs/prompts/gate4-call-c-motion.md` | Same + motion FP notes |
| `scripts/gemini-qa3.mjs` | Add `guarantee` to DIM_PROP + proposal schema (~4 lines) |
| `metanalise/qa-rounds/s-importancia.md` | Append known FPs section |
| `metanalise/evidence/s-importancia.html` | Replace speaker notes placeholder |

## Verification

- Build passes: `npm run build:metanalise`
- R13 output has `guarantee` fields (non-empty in at least some dimensions)
- Known FPs not repeated (css_cascade and failsafes scores should improve)
- Speaker notes visible in evidence HTML
