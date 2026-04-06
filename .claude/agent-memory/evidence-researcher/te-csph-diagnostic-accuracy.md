---
name: TE/FibroScan CSPH Diagnostic Accuracy
description: Transient elastography diagnostic performance for CSPH in cirrhosis — Baveno VII Rule-of-5 validation, MASLD gap, ANTICIPATE models, meta-analyses (researched 2026-03-29)
type: reference
---

# Transient Elastography — CSPH Diagnostic Accuracy

Researched: 2026-03-29
MCPs used: BioMCP (article_searcher + article_getter + think), WebSearch, PubMed MCP (down — 400 errors on date-range queries)

## Verified PMIDs (12 total, all confirmed via BioMCP article_getter)

| PMID | First Author | Journal | Year | Type | Key Finding |
|------|-------------|---------|------|------|-------------|
| 35120736 | de Franchis | J Hepatol | 2022 | Consensus | Baveno VII: Rule-of-5 cutoffs for cACLD/CSPH (already in evidence-db) |
| 33982942 | Pons | Am J Gastroenterol | 2021 | Derivation cohort | Rule-of-5 derivation. n=836. LSM>=25 PPV>90% all except obese NASH (62.8%). ANTICIPATE-NASH model. |
| 27639071 | Abraldes | Hepatology | 2016 | Derivation cohort | ANTICIPATE original. n=518. LSM+PLT nomogram. LSPS highest discrimination. |
| 39689352 | Vutien | Hepatology | 2025 | Validation cohort | n=17,076 Veterans. Rule-of-5 validated. "Critical CSPH" 50-75 kPa: ~2x risk vs 25-49.9 |
| 41138818 | Banares | J Hepatol | 2025 | IPD meta-analysis | 5 studies, n=1433. LSM>=25 pooled PPV 92%. NPV rule-out 99%. ANTICIPATE >=75% → PPV 95% incl. MASLD+obesity |
| 35876975 | Kumar | J Med Ultrason | 2022 | Meta-analysis | 26 studies, n=4337. Weighted mean cutoff 22.8 kPa. Sens 79%, Spec 88%, AUROC 0.91 |
| 37288716 | Song | Liver Int | 2023 | Validation cohort | n=1966 cACLD. 3-yr decompensation: 22% CSPH vs 1.4% excluded. sHR 8.00 |
| 38479612 | Jachs | J Hepatol | 2024 | Validation (HDV) | n=51 HDV. Baveno VII: 100% sens rule-out, 84.2% spec rule-in. ANTICIPATE AUROC 0.885 |
| 36214066 | Rabiee | Hepatol Commun | 2022 | External validation | ANTICIPATE validated in NASH. n=222. Both models AUC>0.8. Developed FIB4+ (AUC 0.80) |
| 38740698 | He | Hepatol Int | 2024 | Validation (2D-SWE) | n=118. LSM>=25 OR SSM>=50: PPV 100%, spec 100% (already in evidence-db) |
| 40844510 | Prakash | Am J Gastroenterol | 2025 | Prospective | n=116. SSM 100Hz AUROC 0.849 for HREV. SSM 35 kPa cutoff: sens 95.6% |
| 40719905 | Li | Clin Exp Med | 2025 | Retrospective | n=1409 cACLD. Dynamic LSM (delta/baseline) AUC 0.777-0.782 for decompensation |

## Key Cutoffs (Baveno VII Rule-of-5)

| LSM (kPa) | + Platelet | Classification | PPV/NPV |
|------------|-----------|----------------|---------|
| <10 | any | Excludes cACLD | — |
| 10-14.9 | any | Probable cACLD | — |
| <15 | >=150x10^9/L | Excludes CSPH | NPV 99% (pooled) |
| 15-19.9 | <110x10^9/L | Probable CSPH (>=60% risk) | — |
| 20-24.9 | <150x10^9/L | Probable CSPH (>=60% risk) | — |
| >=25 | any | Certain CSPH | PPV 92% (pooled) |
| 50-75 | any | "Critical CSPH" (proposed) | ~2x decompensation risk vs 25-49.9 |

## MASLD Gap

- LSM >=25 kPa PPV in obese MASLD: only 62.8% (Pons 2021)
- ANTICIPATE-NASH (LSM+PLT+BMI) at >=75% risk threshold: PPV 83-95% (Banares 2025)
- Rule-out (LSM <15 + PLT >=150) works across all etiologies: NPV 99%

## Pooled Diagnostic Accuracy (Kumar 2022 meta-analysis)

- 26 studies, 4337 patients
- Weighted mean optimal cutoff: 22.8 kPa
- Sensitivity: 79% (95% CI 74-84%)
- Specificity: 88% (95% CI 84-91%)
- AUROC (HSROC): 0.91 (95% CI 0.88-0.93)
- Correlation with HVPG: r=0.70 (range 0.36-0.86)
- Heterogeneity: I2 83% (sensitivity), 74% (specificity)
