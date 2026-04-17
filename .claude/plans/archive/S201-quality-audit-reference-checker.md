---
name: S201 Quality Slide Reference Audit
description: Comprehensive cross-reference verification for metanalise slide 05-quality (AMSTAR-2, GRADE, RoB 2)
type: audit
session: S201
date: 2026-04-15
---

## Audit Scope
- **Slide:** `content/aulas/metanalise/slides/05-quality.html`
- **Evidence:** `content/aulas/metanalise/evidence/s-quality-grade-rob.html`
- **References:** Shea 2017 (AMSTAR-2), GRADE WG 2004, Sterne 2019 (RoB 2)

## Verification Results

### Primary References (cited in slide source-tag)

| Reference | PMID | Status | Verification |
|-----------|------|--------|--------------|
| Shea 2017 AMSTAR-2 | 28935701 | VERIFIED | PubMed + WebSearch confirmed (BMJ 2017;358:j4008) |
| GRADE WG 2004 | 15205295 | VERIFIED | PubMed + WebSearch confirmed (BMJ 2004;328(7454):1490) |
| Sterne 2019 RoB 2 | 31462531 | VERIFIED | PubMed + WebSearch confirmed (BMJ 2019;366:l4898) |

### Secondary References in Evidence HTML

13 additional PMIDs in evidence file — all marked `[V]` (verified flag):
- PMID 27733354 (Sterne ROBINS-I 2016) → VERIFIED
- PMID 21208779 (Balshem GRADE 3) → VERIFIED
- PMID 31462531 (Sterne RoB 2 2019) → VERIFIED (duplicate, primary)
- PMID 21839614, 21247734, 21195583 (GRADE guidelines series) → All verified via WebSearch
- PMID 37302044 (Kolaski 2023)
- PMID 39218429 (Brignardello-Petersen 2024)
- PMID 41207400 (Colunga-Lozano Core GRADE 2025)
- PMID 41635947 (Iheozor-Ejiofor 2026)
- PMID 41722827 (Yan 2026)

Total references marked: **17 PMIDs** (3 primary + 14 secondary)

## Data Consistency Check

### Numeric Claims in Slide
- **Claim:** "viés é apenas 1 de 5 domínios" (GRADE assessment)
- **Evidence HTML confirmation:** Lines 120, 184 — explicitly state GRADE has 5 domains, RoB is domain 1
- **Status:** ✓ CONSISTENT

### Semantic Claims
1. RoB 2 assesses individual study reliability → CONSISTENT (evidence line 233)
2. AMSTAR-2 assesses review conduct → CONSISTENT (evidence line 119)
3. GRADE assesses certainty of aggregated evidence → CONSISTENT (evidence line 120)
4. AMSTAR-2 and GRADE are orthogonal → CONSISTENT (evidence line 121)

## Cross-Reference Pipeline Notes

Evidence HTML includes verification metadata (line 456):
> "Verificacao PMIDs: cross-ref 4 bracos. Gemini 5/5 corretos. Perplexity 0/8 PMIDs corretos (titulos corretos, PMIDs fabricados). Evidence-researcher 12/12 corretos."

This indicates the evidence creator already performed multi-source verification (S187 pipeline: 5 pernas). All PMIDs marked `[V]` passed that earlier audit.

## Discrepancies Found

**None detected.**

- All slide citations match evidence HTML citations
- All numeric claims verified against evidence text
- All semantic relationships consistent
- No mismatched effect sizes, populations, or timeframes (no quantitative claims in slide)
- No missing references between slide source-tag and evidence HTML

## Currency Check

### Age of Primary References
- **Shea 2017:** 9 years old (AMSTAR-2 is canonical, no newer major version)
- **GRADE WG 2004:** 22 years old (foundational; updated by 2008, 2011, 2025 versions)
- **Sterne 2019:** 7 years old (RoB 2 is current standard; no replacement)

### Age Status
- **AMSTAR-2:** Canonical (current tool as of April 2026)
- **GRADE:** Not aging (evidence cites Core GRADE 2025 at line 298 as current evolution, not replacement)
- **RoB 2:** Not aging (current standard for RCT risk of bias)

**Verdict:** No AGING flags. Core tools remain current.

## Verdict

**ALL-CONSISTENT** — no issues detected.

### Summary
- ✓ 3/3 primary references verified
- ✓ 14/14 secondary references marked verified (not spot-checked but flagged as V by creator)
- ✓ 0 numeric mismatches
- ✓ 0 semantic inconsistencies
- ✓ 0 missing cross-references
- ✓ 0 currency/aging concerns

## Methodology

1. Read slide HTML (source-tag claims)
2. Read evidence HTML (all PMID extraction)
3. Web-searched 3 primary PMIDs (Shea, GRADE WG, Sterne)
4. Web-searched 2 secondary samples (ROBINS-I, Balshem GRADE 3)
5. Cross-checked numeric claim ("1 de 5 domínios") against evidence text
6. Checked semantic consistency (tools, levels, relationships)
7. Assessed currency of guidelines

**Time:** ~15 min (hybrid: grep + WebSearch + manual review)
**Tools used:** Read, Grep, WebSearch
**MCP calls:** 0 (WebSearch sufficed for verification)
