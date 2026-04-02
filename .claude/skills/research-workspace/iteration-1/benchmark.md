# Skill Benchmark: research

**Model**: claude-opus-4-6
**Date**: 2026-04-02
**Evals**: topic-queries, slide-id, fast-path-pmid (1 run each per configuration)

## Summary

| Metric | with_skill | without_skill | Delta |
|--------|------------|---------------|-------|
| Pass Rate | 100% +/- 0% | 61.1% +/- 16.8% | **+38.9pp** |
| Time | 261.4s +/- 149.4s | 196.7s +/- 99.7s | +64.7s |
| Tokens | 74,653 +/- 35,032 | 60,370 +/- 21,369 | +14,283 |

## Per-Eval Breakdown

| Eval | with_skill | without_skill | Delta |
|------|------------|---------------|-------|
| topic-queries | 7/7 (100%) | 4/7 (57.1%) | +42.9pp |
| slide-id | 7/7 (100%) | 3/7 (42.9%) | +57.1pp |
| fast-path-pmid | 6/6 (100%) | 5/6 (83.3%) | +16.7pp |

## Assertion Analysis

### Discriminating (only pass with skill)
- `comparative-table` — multi-leg comparison table
- `convergence-divergence` — cross-leg analysis
- `depth-rubric` — 8-dimension D1-D8 scoring
- `grade-assessment` — GRADE framework application
- `multi-leg-findings` — 3+ independent search legs
- `comparative-synthesis` — cross-leg synthesis

### Non-discriminating (pass both)
- `verified-pmids`, `pmid-present`, `author-present`, `study-design`, `sample-size`, `effect-size`
- `slide-read`, `mcp-query-results`
- Both configs handle basic data retrieval well

### Partially discriminating
- `fast-path-routing` — with_skill produces concise 51-line report; without produces 147-line report
- `no-unsourced-claims` — with_skill is more rigorous about sourcing every claim

## Analyst Observations

1. **Multi-leg architecture is the skill's main differentiator.** The 6 discriminating assertions all relate to parallel search legs + synthesis. Without the skill, the agent does competent single-threaded research but misses cross-validation.

2. **Cost-benefit is favorable.** +33% time and +24% tokens buy +39pp pass rate. The extra compute goes to parallel legs that produce qualitatively different output (convergence tables, depth rubrics, GRADE assessments).

3. **Fast-path routing works.** The skill correctly identifies PMID-only queries and produces concise output without launching the full pipeline.

4. **Eval-2 (slide-id) shows maximum delta (+57pp).** This is where the skill shines — reading HTML, applying depth rubric, cross-referencing evidence-db, and synthesizing across legs. Without the skill, the agent improvises its own rubric (6 dims on 5-point scale).

5. **Baseline is not weak.** The without_skill runs still verify PMIDs, extract effect sizes, and use MCPs. The skill adds *structure* (parallel legs, convergence analysis, standardized rubrics) more than raw capability.

6. **PubMed MCP instability is a risk.** Eval-1 without_skill had 5 failed PubMed attempts. The skill's multi-leg design provides natural resilience — if one leg fails, others compensate.
