# Research Methodology Reference

Reference material for the orchestrator's synthesis step. Loaded on demand.

## GRADE — Certainty of Evidence

| Quality | Starting Point | Common Modifiers |
|---------|---------------|-----------------|
| **High** | RCTs without serious limitations | Downgrade: bias, inconsistency, indirectness, imprecision, pub bias |
| **Moderate** | RCTs with limitations OR well-conducted observational | |
| **Low** | Observational studies | Upgrade: large effect (RR>2 or <0.5), dose-response |
| **Very Low** | Very indirect or imprecise evidence | Upgrade: confounders favoring null |

**Recommendation strength:** Strong (benefits clearly outweigh risks) vs Conditional (close balance or uncertain).
GRADE quality != recommendation strength. Low-quality evidence can still support strong recommendations when alternatives are worse.

## Oxford CEBM — Evidence Levels

| Level | Study Type | Recommendation Grade |
|-------|-----------|---------------------|
| 1a | Systematic review of RCTs | A |
| 1b | Individual RCT with narrow CI | A |
| 2a | Systematic review of cohorts | B |
| 2b | Individual cohort / low-quality RCT | B |
| 3a | Systematic review of case-control | B |
| 3b | Individual case-control | C |
| 4 | Case series | C |
| 5 | Expert opinion | D |

## Depth Rubric — 8 Dimensions

Used by MBE evaluator (Perna 2) and by orchestrator for slide assessment.

| Dim | What it measures | Superficial (1-3) | Profundo (7-10) |
|-----|-----------------|-------------------|-----------------|
| D1 Source | Origin of claim | "studies show" | PMID + year + society |
| D2 Effect Size | Statistical precision | absent/p-only | HR/RR + CI + NNT |
| D3 Population | Who was studied | "patients with X" | n + criteria + multicenter |
| D4 Timeframe | Duration context | absent | years + median follow-up |
| D5 Comparator | What compared | absent/"vs control" | drug + dose + regimen |
| D6 Grading | Evidence quality | absent | GRADE + strength + society |
| D7 Impact | Practice translation | "improves outcomes" | NNT (CI) + translation |
| D8 Currency | Temporal relevance | >10y/unknown | <5y or current guideline |

**Scoring:** Mean of 8 dimensions.
- 1.0-3.0 = SUPERFICIAL (needs rewrite)
- 3.1-5.0 = ADEQUATE WITH GAPS (improve dims <4)
- 5.1-8.0 = DEEP (minor adjustments)
- 8.1-10.0 = EXEMPLARY (maintain)

## Framework-to-Study Mapping

| Study Type | Reporting Guideline | Quality Tool |
|-----------|-------------------|-------------|
| RCT | CONSORT (25 items) | Cochrane RoB 2 |
| Cohort / Case-control | STROBE (22 items) | Newcastle-Ottawa / ROBINS-I |
| Systematic review | PRISMA (27 items) | AMSTAR-2 |
| Meta-analysis (obs) | MOOSE | Newcastle-Ottawa |
| Diagnostic accuracy | STARD | QUADAS-2/3 |
| Clinical guideline | — | AGREE II |
| Case report | CARE | — |

## Synthesis — Convergence/Divergence Rules

| Pattern | Confidence | Action |
|---------|-----------|--------|
| Same finding in >=3 pernas, PMIDs verified | **HIGH** | Include with confidence tag |
| Same finding in 2 pernas | **MODERATE** | Include, note limited sources |
| Finding in 1 perna only | **LOW** | Include with caveat |
| Pernas disagree on same data point | **CONFLICT** | Present both, flag for human decision |
| Finding contradicts existing slide data | **MISMATCH** | Flag, do NOT auto-correct |

### Perplexity (Perna 6) — Triangulation Rules

Perplexity citations have **lower initial confidence** than MCP-verified sources:

| Perplexity finding | + Confirmed by Perna 3 (ref-checker) | Confidence |
|---|---|---|
| Concept/framework (no PMID) | N/A — conceptual, not citable | Use as context, not as reference |
| Web URL with PMID extracted | PMID verified via PubMed | **Same as any verified PMID** |
| PMC URL only | PMCID→PMID converted + verified | **Same as any verified PMID** |
| Web URL, no PMID/DOI | Not verifiable | **WEB-ONLY** — include as background, never as Tier 1 |

**Key principle:** Perplexity DISCOVERS, reference-checker VERIFIES. A Perplexity finding that survives verification joins the convergence count like any other perna. One that doesn't = contextual background only.

## Source Hierarchy (priority order)

1. Current guidelines from medical societies
2. Cochrane reviews / meta-analyses with >=5 RCTs
3. Multicenter RCTs >=200 patients
4. Reference textbooks (latest edition)
5. Expert consensus / Delphi panels
6. Large case series (n>500) — only when nothing above
7. Individual expert opinion — NEVER primary source for numeric data
