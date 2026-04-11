# Plan: Build s-importancia (Dual Creation Pattern)

## Context

s-importancia is a new F1 slide after s-hook in the metanalise deck.
- s-hook = CRISIS (81% critically low, 33.8% assess GRADE)
- s-importancia = POSITIVE FLIP: why MA matters despite those problems
- Transition: ceticismo -> apreciacao informada (not blind faith)
- Evidence HTML ready (327 lines, 5 vantagens, Tier 1 data)
- H2 (Lucas): **"Porque isso importa - Metodologia"**

## Phase A: Dual Proposals (parallel)

### A1 — Proposta Gemini (via API curl)
Send to Gemini 3.1 Pro:
- Full evidence HTML content (as text in prompt)
- Context: assertion-evidence slide, 1280x720 canvas, ~60s, projetor grande ~10m
- s-hook HTML as narrative predecessor
- H2 headline
- Ask: content selection, visual layout proposal, emphasis, what to cut for 60s

### A2 — Proposta Claude
Independent analysis of evidence:
- Content selection (which V1-V5, what data points)
- Visual layout (grid, cards, hero numbers, etc.)
- Narrative arc in 60s
- What makes it land at 10m on projector

## Phase B: Lucas Decides
Present proposals side by side. Lucas picks, merges, or iterates.

## Phase C: Implementation (after approval)

### Files to create/modify:
1. **CREATE** `slides/02-importancia.html`
2. **EDIT** `slides/_manifest.js` — add entry after s-hook
3. **EDIT** `metanalise.css` — CSS scoped to `section#s-importancia`
4. **EDIT** `slide-registry.js` — if custom animation needed
5. **RUN** `npm run build:metanalise` from `content/aulas/`

### Manifest entry:
```js
{ id: 's-importancia', file: '02-importancia.html', phase: 'F1',
  headline: 'Porque isso importa - Metodologia', timing: 60,
  clickReveals: TBD, customAnim: TBD,
  narrativeRole: 'setup', tensionLevel: 1, narrativeCritical: false,
  evidence: 's-importancia.html' },
```

### Verification:
1. `npm run lint:slides` PASS
2. `npm run build:metanalise` PASS
3. Dev server visual check

## Display Constraints
- Projetor grande, ate ~10m distancia
- Font minima 18px no canvas 1280 (mas considerar legibilidade a 10m)
- scaleDeck() em 1080p
- Legibilidade = constraint #1
