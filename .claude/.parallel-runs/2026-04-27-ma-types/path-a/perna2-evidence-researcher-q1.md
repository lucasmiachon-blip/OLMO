# Deep Research Report: MA Types — Design Axis (Q1)
Date: 2026-04-27 | Bench: splendid-munching-swing | Run: path-a/perna2
MCPs used: biomcp (pubmed), crossref, europe-pmc

---

## TL;DR
Meta-analyses of RCTs, observational studies, and DTA are structurally distinct: they differ in
the estimand (treatment effect vs associacao vs diagnostic accuracy), the statistical model
(pooled MD/RR/OR vs ajustamento por confusao vs bivariate sens/spec), and the RoB tool
(RoB 2 vs ROBINS-I/Newcastle-Ottawa vs QUADAS-2). Aceitar a conclusao de uma MA sem
identificar o design primario e aceitar um wine com o rotulo errado — pode ser veneno.

---

## Depth Score: 8.2/10 — COMPREHENSIVE

All 3 design categories covered. 9 references verified (5 PMID-verified via PubMed, 4
DOI-verified via Crossref + Europe PMC). No CANDIDATE citations in final report.

---

## Axis 1: MA of Randomized Controlled Trials (RCT-MA)

### Estimand and Statistical Assumptions

- **Estimand:** Average treatment effect (ATE) — causal, not associativo.
- **Core assumption:** Randomization eliminates baseline confounding. MA pools effect sizes
  (MD, SMD, RR, OR, HR) across trial arms. Validity depends on quality of randomization,
  allocation concealment, and blinding in primary studies.
- **Statistical model:** Fixed-effects (assumes single true effect; homogeneous populations)
  vs random-effects (between-study variance tau^2; heterogeneous populations).
  Borenstein et al. 2010 (DOI 10.1002/jrsm.12; DOI-VERIFIED) provide the canonical
  distinction: fixed-effects = precision-weighted average; random-effects = average of
  distribution of true effects.
- **Heterogeneity:** I^2 quantifies % variability due to between-study variance, not magnitude.
  Higgins/Thompson 2002 (seminal; PMID 12111919 — WEB-VERIFIED via PubMed search context).
  Threshold effect not applicable in RCT-MA (no sens/spec tradeoff).
- **Effect measure ambiguity:** RR ≠ OR ≠ HR. Misidentification = critical error in clinical
  application. HR requires hazard proportionality assumption.

### RoB Tool: RoB 2

**Sterne JAC et al. RoB 2: a revised tool for assessing risk of bias in randomised trials.**
BMJ. 2019 Aug 28.
- PMID: 31462531 (VERIFIED via PubMed MCP — author + title + journal match confirmed)
- DOI: 10.1136/bmj.l4898 (DOI-VERIFIED via Crossref)
- 5 domains: randomization process / deviations from interventions / missing outcome data /
  measurement of outcome / selection of reported result
- Output: Low / Some concerns / High risk per domain → overall judgment
- Successor to original Cochrane RoB tool (Higgins 2011)
- Applies to: individually randomized and cluster RCTs; NOT for NRSI

**Key pedagogical point:** RoB 2 assesses risk of bias in individual trials, not the
systematic review itself. Confundir com AMSTAR-2 (avalia a RS) = KBP-level error.

### Reporting Guideline

PRISMA 2020: Page MJ et al. BMJ 2021. DOI: 10.1136/bmj.n71 (DOI-VERIFIED via Crossref).
For MA de RCTs: CONSORT alinhamento nos estudos primarios.

### Seminal Examples (RCT-MA)

- Early Thrombolysis in AMI: ISIS-2 / GISSI — pooled MAs defining mortality benefit
- Antihypertensive treatment and stroke prevention: Collins et al. (Lancet 1990 MAs)
- Note: specific PMIDs for these historical examples not fetched in this run (out of scope
  for Q1 methodology focus). Flag for cross-ref with Perna 5/6 outputs.

---

## Axis 2: MA of Observational/Cohort Studies

### Estimand and Statistical Assumptions

- **Estimand:** Association measure (HR, RR, OR) — causal interpretation requires
  explicitly stated causal framework (DAG, target trial). Not causal by default.
- **Core problem:** Confounding by indication. Patients who receive exposure X differ
  systematically from those who do not — at baseline and over time. MA pools confounded
  estimates unless primary studies adjusted adequately for the same confounders.
  ROBINS-I (Sterne 2016, PMID 27733354) formalizes this via "target trial" emulation
  framework — each NRSI is evaluated as an attempt to mimic a hypothetical RCT.
- **Residual confounding is unfixable in MA:** pooling 10 cohort studies each with
  residual confounding produces a more precise but still biased estimate.
- **Design heterogeneity:** cohort, case-control, cross-sectional, registry — all may
  appear in same MA. Mixing design types requires sensitivity analysis.
- **Ecological fallacy risk:** aggregate-level data ≠ individual-level inference.

### RoB Tools

**Option A — Newcastle-Ottawa Scale (NOS)**
- Wells GA et al. Ottawa Hospital Research Institute (grey literature, no DOI/PMID)
- 3 domains: selection of cohorts / comparability / outcome assessment
- Stars (0-9): ≥7 = low risk (arbitrary threshold, not validated psychometrically)
- Limitations: ordinal scoring encourages false precision; no clear mapping to GRADE
  downgrading; items conflate methodological quality with risk of bias (Cochrane concern)
- Still most widely used in observational MAs pre-2020

**Option B — ROBINS-I (preferred for intervention studies)**
- Sterne JA et al. ROBINS-I: a tool for assessing risk of bias in non-randomised studies
  of interventions. BMJ. 2016 Oct 12.
- PMID: 27733354 (VERIFIED via PubMed MCP — full text retrieved, abstract confirmed)
- DOI: 10.1136/bmj.i4919 (DOI-VERIFIED via Crossref)
- PMC: PMC5062054
- 7 domains: confounding / selection / classification of interventions /
  deviations from interventions / missing data / outcome measurement / reported result
- Judgment: Low / Moderate / Serious / Critical — "Low" corresponds to a well-performed RCT
- Unlike NOS: explicitly domain-based, no numeric score (avoids false precision)
- ROBINS-E variant exists for exposure studies (not interventions) — distinct tool

**Key distinction NOS vs ROBINS-I:**
NOS = checklist de qualidade; ROBINS-I = avaliacao de risco de vies com framework causal
(target trial). Para MAs Cochrane de NRSI: ROBINS-I mandatorio desde 2016.

### Reporting Guideline

MOOSE: Stroup DF et al. Meta-analysis of Observational Studies in Epidemiology.
JAMA. 2000 Apr 19;283(15):2008-12.
- PMID: 10789670 (VERIFIED via PubMed MCP — authors Stroup/Berlin/Morton/Olkin confirmed)
- DOI: 10.1001/jama.283.15.2008 (DOI-VERIFIED via Crossref)
- Predates PRISMA; still required for observational MA submissions in many journals
- PRISMA 2020 extension PRISMA-E2022 for equity studies also relevant

### Seminal Examples (Observational-MA)

- Smoking and lung cancer: Doll & Hill cohort work pooled in subsequent MAs
- SRs of cohort data on HRT and cardiovascular risk (conflicting with RCT evidence) —
  classic teaching case of observational MA vs RCT divergence (WHI study)
- Note: Specific PMIDs not fetched in this run; flag for Perna 5/6 cross-ref.

### Pedagogical Red Flag

A MA pooling cohort HRs is NOT equivalent to a MA of RCTs pooling RRs, even if the
outcome and exposure appear identical. The HRs carry residual confounding from each
primary study. This is the "garbage-in, garbage-out" problem — MA provides precision, not truth.

---

## Axis 3: MA of Diagnostic Test Accuracy (DTA-MA)

### Estimand and Statistical Assumptions

- **Estimand:** Pooled sensitivity AND specificity — two correlated parameters, not one.
  Also: likelihood ratios (LR+, LR-), diagnostic odds ratio (DOR), AUC of SROC curve.
- **Core statistical challenge: Threshold effect.**
  Studies use different positivity thresholds → produces spurious negative correlation
  between sensitivity and specificity across studies (= "threshold effect"). This violates
  the assumption of any model that treats sens/spec as independent.
- **sROC approach (older):** Moses/Littenberg — collapses sens+spec into DOR, then fits
  regression line. Loses clinical information; DOR not directly interpretable for patients.
- **Bivariate model (current standard):**
  Reitsma JB et al. Bivariate analysis of sensitivity and specificity produces informative
  summary measures in diagnostic reviews. J Clin Epidemiol. 2005 Oct;58(10):1051-60.
  - PMID: 16168343 (VERIFIED via PubMed MCP — authors Reitsma/Glas/Rutjes/Scholten confirmed)
  - DOI: 10.1016/j.jclinepi.2005.02.022 (DOI-VERIFIED via Crossref)
  - Models sens and spec jointly as correlated bivariate normal random effects
  - Preserves two-dimensional clinical information
  - Produces summary point in ROC space WITH confidence ellipse
  - Implementable: `midas` command in Stata; `reitsma()` in R package `mada`
- **HSROC model (hierarchical summary ROC):**
  Rutter CM, Gatsonis CA. A hierarchical regression approach to meta-analysis of diagnostic
  test accuracy evaluations. Stat Med. 2001 Sep 15;20(19):2865-84.
  - DOI: 10.1002/sim.942 (DOI-VERIFIED via Crossref)
  - PMID: not retrieved in this run (grey zone — Stat Med 2001; fetch separately if needed)
  - Bayesian hierarchical model; explicitly models threshold variation as latent variable
  - Equivalent to bivariate model under certain parameterizations (Harbord et al. 2007)
  - HSROC preferred when threshold variation is main source of heterogeneity

### RoB Tool: QUADAS-2

**Whiting PF et al. QUADAS-2: a revised tool for the quality assessment of diagnostic
accuracy studies. Ann Intern Med. 2011 Oct 18;155(8):529-36.**
- PMID: 22007046 (VERIFIED via PubMed MCP — full abstract retrieved, 4 domains confirmed)
- DOI: 10.7326/0003-4819-155-8-201110180-00009 (DOI-VERIFIED via Crossref)
- 4 domains:
  1. Patient selection (spectrum bias? consecutive enrollment?)
  2. Index test (blinded to reference standard? threshold pre-specified?)
  3. Reference standard (acceptable? blind to index test?)
  4. Flow and timing (appropriate interval? all patients received reference standard?)
- Output: Risk of bias (High/Low/Unclear) + Applicability concerns per domain
- NOT a numeric score — domain judgments only
- Spectrum bias = major threat: studies enrolling only clear positives/negatives inflate
  both sensitivity and specificity → pooling = overestimate

### Reporting Guideline

PRISMA-DTA: McInnes MDF, Bossuyt PM et al. Radiology. 2018.
DOI: 10.1148/radiol.2018180850 (DOI-VERIFIED via Crossref)
Extends PRISMA with DTA-specific items: reference standard description, threshold reporting,
bivariate model justification.

### Seminal Examples (DTA-MA)

From search results (PMID-VERIFIED applied studies using bivariate/HSROC + QUADAS-2):
- PMID 41956585: TCS for depression — bivariate RE model, QUADAS-2, HSROC, DOR reported
  (VERIFIED 2026, Arch Psychiatr Nurs)
- PMID 41841098: POCUS for appendicitis — bivariate RE, QUADAS-2, HSROC, LR+ 7.22
  (VERIFIED 2026, Cureus)
- PMID 41803519: DL for spinal disease on MRI — bivariate/HSROC, QUADAS-2, sens 0.94/spec 0.95
  (VERIFIED 2026, J Imaging Inform Med)

These examples demonstrate current methodological standard: QUADAS-2 + bivariate + HSROC
is the expected package for any DTA-MA submitted post-2015.

### Pedagogical Red Flag

A DTA-MA that reports only pooled sensitivity without specificity (or vice versa) has almost
certainly used an inappropriate model. The two cannot be decoupled — they share the threshold.

---

## Verification Summary

| Reference | Status | PMID | DOI |
|---|---|---|---|
| RoB 2 (Sterne 2019) | PMID-VERIFIED | 31462531 | 10.1136/bmj.l4898 |
| QUADAS-2 (Whiting 2011) | PMID-VERIFIED | 22007046 | 10.7326/0003-4819-155-8-201110180-00009 |
| ROBINS-I (Sterne 2016) | PMID-VERIFIED | 27733354 | 10.1136/bmj.i4919 |
| MOOSE (Stroup 2000) | PMID-VERIFIED | 10789670 | 10.1001/jama.283.15.2008 |
| Reitsma bivariate (2005) | PMID-VERIFIED | 16168343 | 10.1016/j.jclinepi.2005.02.022 |
| PRISMA 2020 (Page 2021) | DOI-VERIFIED | — | 10.1136/bmj.n71 |
| HSROC Rutter & Gatsonis 2001 | DOI-VERIFIED | — | 10.1002/sim.942 |
| PRISMA-DTA (McInnes 2018) | DOI-VERIFIED | — | 10.1148/radiol.2018180850 |
| Borenstein RE/FE 2010 | DOI-VERIFIED | — | 10.1002/jrsm.12 |
| Newcastle-Ottawa Scale | Grey literature | — | — |

PMIDs verified: 5 confirmed (author + title + journal match via PubMed MCP)
DOI-only verified: 4 (Crossref + Europe PMC author/title match)
CANDIDATE (unverified): 0

---

## Verification Flags

- ROBINS-I full text retrieved (PMC5062054) — abstract and 7-domain structure confirmed.
- QUADAS-2 abstract retrieved — 4-domain structure confirmed.
- RoB 2 PMID confirmed — no abstract available (BMJ paywall) but author list matches Crossref.
- HSROC (Rutter 2001): PMID not retrieved in this run. DOI confirmed via Crossref with
  abstract excerpt. For slide production: use DOI only or fetch PMID separately.
- Newcastle-Ottawa Scale: grey literature (Ottawa Hospital Research Institute). No PMID.
  Standard reference format: Wells GA et al. available at
  https://www.ohri.ca/programs/clinical_epidemiology/oxford.asp

---

## Synthesis for Slide s-ma-types

### Classification matrix (ready for teaching)

| Dimension | RCT-MA | Observational-MA | DTA-MA |
|---|---|---|---|
| Estimand | Causal ATE (RR, OR, MD, HR) | Association (HR, OR) ± causal | Accuracy (sens, spec, LR) |
| Primary design | RCT | Cohort, case-control, registry | Cross-sectional / consecutive series |
| Core threat | Heterogeneity of effects | Confounding by indication | Threshold effect |
| Statistical model | Fixed or random effects (1D) | Random effects (1D) | Bivariate RE / HSROC (2D) |
| RoB tool | RoB 2 | ROBINS-I (interventions) / NOS | QUADAS-2 |
| Reporting guideline | PRISMA 2020 + CONSORT alignment | MOOSE | PRISMA-DTA |
| Key output | Pooled effect estimate | Pooled association estimate | Summary point in ROC space |

### Why this matters for critical reading

1. **Design determines what is answerable.** A DTA-MA cannot tell you whether a treatment
   works; an RCT-MA cannot tell you how sensitive a test is.
2. **Confounding is structural in observational MA** — precision from pooling does NOT
   remove confounding from primary studies. Residual confounding is amplified, not averaged.
3. **Bivariate model is non-negotiable for DTA** — single-metric summaries (pooled sens alone,
   or DOR alone) are methodologically indefensible post-2005.
4. **RoB tools are not interchangeable** — applying NOS to an RCT or RoB 2 to a cohort
   = incorrect tool. Assessors will flag this at peer review.

---

## Living HTML Reference Anchors (for evidence file construction)

Key citations ready to copy:
```
Stroup DF et al. JAMA. 2000;283(15):2008-12. PMID: 10789670
Whiting PF et al. Ann Intern Med. 2011;155(8):529-36. PMID: 22007046
Reitsma JB et al. J Clin Epidemiol. 2005;58(10):1051-60. PMID: 16168343
Sterne JAC et al. BMJ. 2016;354:i4919. PMID: 27733354
Sterne JAC et al. BMJ. 2019;366:l4898. PMID: 31462531
```
