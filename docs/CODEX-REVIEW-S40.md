# Codex Review S40 — Open Items Only

> Original: 135 findings (GPT-5.4, 2026-04-01). P0+P1+P2 done (S41-S43). S44 verified+cleaned.
> Full history in CHANGELOG S40-S44.

---

## Scripts

| # | File | Priority | Issue |
|---|------|----------|-------|
| 13 | lint-case-sync.js | HIGH | Brace parser not string/comment-aware |
| 18 | qa-video.js:55 | HIGH | grade mapped to Reveal.js but uses deck.js |
| 19 | qa-video.js:54 | HIGH | Fixed port 4100 for all aulas (metanalise=4102) |
| 28 | lint-gsap-css-race.mjs | MEDIUM | Multi-line CSS selector parsing incorrect |
| 29 | lint-gsap-css-race.mjs | MEDIUM | Conflict detection ignores scope/slide |
| 34 | done-gate.js | MEDIUM | Notes detector rigid (`<aside class="notes">` exact) |
| 44-45 | lint-gsap-css-race.mjs | LOW | JS + CSS scan scope hardcoded |

## CSS

| # | File | Priority | Issue |
|---|------|----------|-------|
| 49 | base.css:133 | HIGH | @supports not fallback incomplete |
| 50 | base.css:254 | HIGH | .stage-c doesn't remap utility class tokens |
| 65 | cirrose.css:55-76 | HIGH | *-light tokens 15% color-mix achromatic (E059) |
| 66 | cirrose.css:449-461 | HIGH | @media print partial (MELD cards, Rule-of-5) |
| 74 | cirrose.css:1642 | MEDIUM | Double panel-offset compensation in hook |
| 75-76 | cirrose.css:3097,3124 | MEDIUM | Hover overrides active state (pcalc buttons) |
| 77 | cirrose.css:828-838 | MEDIUM | Raw oklch() without HEX fallback |

## HTML (excluding h2 rewrite — Lucas guides)

| # | Slide | Priority | Issue |
|---|-------|----------|-------|
| 98 | 02b-a1-cpt | HIGH | kappa<=0.41 with [TBD — PMID nao localizado] |
| 101 | 03b-a1-fib4 | HIGH | 30-60% grey zone [TBD — verify primary source] |
| 103 | 03c-a1-elasto | HIGH | (~3x menor) no source |
| 107 | s-aplicacao | MEDIUM | Notes with clinical claims without source |
| 108 | s-aplicabilidade | MEDIUM | Notes with claims without source (CYP2C19, ACC) |
| 109 | 01-hook (cirrose) | MEDIUM | h3 without h2 (heading hierarchy skip) |
| 110 | 03c-a1-elasto | MEDIUM | PMID 39649032 not verified |

h2 rewrite (11+ slides): Lucas guides, slide by slide. Not tracked here.

## Docs (C15)

| # | File | Priority | Issue |
|---|------|----------|-------|
| 134 | blueprint + narrative (meta) | HIGH | GRADE numbering misaligned (slide 14 = pergunta 2 vs 3) |
| 135 | blueprint (meta) | HIGH | Slide numbers misaligned with filenames |
| 136 | archetypes + rules (meta) | HIGH | Forest plot: rule says "crop real article" but slide 07 uses SVG grid |
| 137-138 | gate2-opus-visual | HIGH | Mixed scope (visual-only vs code) + audience contamination |
| 139 | narrative + evidence-db (cirrose) | HIGH | Recompensacao alcoolica: [TBD SOURCE] but evidence-db has PMID |
| 140-141 | evidence-db (cirrose) | HIGH | Two entries with [TBD — buscar PMID] |
| 142 | gate2-opus-visual | MEDIUM | Refs to nonexistent tools/APIs |
| 143 | blueprint (meta) | MEDIUM | Terminology drift (s-hook vs 01-hook.html vs Slide 01) |
| 144 | narrative + blueprint | LOW | Blueprint derived from narrative v2.4 but narrative is v2.5 |

---

Coautoria: Lucas + Opus 4.6 + GPT-5.4 (Codex) | 2026-04-01
