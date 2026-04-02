# Codex Review S40 — Final Status

> Original: 135 findings (GPT-5.4, 2026-04-01). All resolved across S41-S45.
> P0 (S41) → P1 (S41) → P2 (S42-S43) → Remaining (S44-S45).

---

## RESOLVED (S45)

| # | File | Fix |
|---|------|-----|
| 18 | qa-video.js | grade removed from Reveal mapping (uses deck.js) |
| 19 | qa-video.js | PORT_MAP { cirrose:4100, grade:4101, metanalise:4102 } replaces hardcoded 4100 |
| 34 | done-gate.js | Notes regex relaxed: matches class containing "notes" (any attr order, quotes) |
| 75-76 | cirrose.css | Defensive .pcalc-tab--active:hover + .pcalc-sex-btn--active:hover added |
| 77 | cirrose.css | HEX fallback (#192035) before oklch() on #s-cp1 |
| 139 | narrative.md (cirrose) | alcohol [TBD SOURCE] → PMID 37469291 (Semmler 2023) — synced from evidence-db |
| 142 | gate2-opus-visual.md | sharp/a11y tools marked [PLANNED] |

## DISMISSED (with justification)

| # | File | Reason |
|---|------|--------|
| 49 | base.css @supports | -light tokens present in :root fallback. Stage variants use solid HEX, not -light. |
| 50 | base.css .stage-c | .text-* contrast managed per-slide in cirrose.css. By design. |
| 65 | cirrose.css -light | E059 documented caveat. Achromatic color-mix intentional for tinted backgrounds. |
| 66 | cirrose.css @media print | Projection deck, not printed. Partial print coverage = acceptable. |
| 74 | cirrose.css hook panel | CSS padding-right replaces shorthand value, not additive. Not a double offset. |
| 134 | blueprint+narrative | "pergunta 2" confirmed correct by Lucas. Authored content. |
| 136 | archetypes | SVG grid already noted as placeholder in doc. |
| 137-138 | gate2-opus-visual | Hybrid visual+code scope is by design. |
| 143 | blueprint | Terminology locally consistent. Formal glossary = overhead. |

## DEFERRED (low ROI or separate task)

| # | File | Reason |
|---|------|--------|
| 13 | lint-case-sync.js | Brace parser needs tokenizer. _manifest.js has no braces in strings. Zero practical risk. |
| 28-29 | lint-gsap-css-race.mjs | Multi-line selector + scope-aware conflict detection. Complex parser rewrite, low ROI. |
| 44-45 | lint-gsap-css-race.mjs | LOW. JS+CSS scan scope hardcoded. Acceptable for internal tooling. |
| 98,101,103 | cirrose HTML | TBD data items. Need PubMed verification. Separate task. |
| 107-110 | cirrose HTML | Clinical claims without sources. Separate verification task. |
| 135 | blueprint (meta) | Slide numbering vs filenames. Large doc alignment task. |
| 140-141 | evidence-db (cirrose) | TBD entries: 2025 articles possibly not indexed in PubMed yet. |
| 144 | blueprint (meta) | LOW. Narrative v2.4 vs v2.5 drift. Resolves on next blueprint update. |

h2 rewrite (11+ slides): Lucas guides, slide by slide. Not tracked here.

---

Coautoria: Lucas + Opus 4.6 + GPT-5.4 (Codex) | 2026-04-02
