---
name: TE/FibroScan CSPH Accuracy, Rule-of-5 Limitations, Gray Zone
description: Transient elastography diagnostic performance for CSPH + Baveno VII Rule-of-5 validation, limitations (7 categories), gray zone (40-60%), F2/F3 VCTE cutoffs by etiology, F3 vs F4 clinical gap, MASLD gap, confounders reference (merged from te-csph-diagnostic-accuracy + rule-of-five-limitations-gray-zone, S225 2026-04-17)
type: reference
---

# TE/FibroScan — CSPH Accuracy, Rule-of-5 Limitations, Gray Zone

Researched: 2026-03-29 (accuracy) + 2026-03-30 (limitations + gray zone). Merged S225.
MCPs used: BioMCP (article_searcher + article_getter + think), WebSearch, WebFetch, PubMed MCP (down — 400 errors on date-range queries)

## Verified PMIDs (24 total, all confirmed via BioMCP article_getter)

| PMID | First Author | Journal | Year | Type | Key Finding |
|------|-------------|---------|------|------|-------------|
| 35120736 | de Franchis | J Hepatol | 2022 | Consensus | Baveno VII: Rule-of-5 cutoffs for cACLD/CSPH |
| 34166721 | EASL | J Hepatol | 2021 | CPG | EASL NITs guideline: cutoffs by etiology, confounders, reliability |
| 38489521 | Duarte-Rojo | Hepatology | 2024 | Systematic review | AASLD: 240 studies, 61,193 pts, TE/SWE/MRE accuracy |
| 33982942 | Pons | Am J Gastroenterol | 2021 | Derivation cohort | Rule-of-5 derivation. n=836. LSM>=25 PPV>90% except obese NASH (62.8%). ANTICIPATE-NASH model. |
| 27639071 | Abraldes | Hepatology | 2016 | Derivation cohort | ANTICIPATE original. n=518. LSM+PLT nomogram. LSPS highest discrimination. |
| 39689352 | Vutien | Hepatology | 2025 | Validation cohort | n=17,076 Veterans. Rule-of-5 validated. "Critical CSPH" 50-75 kPa: ~2x risk vs 25-49.9 |
| 41138818 | Banares | J Hepatol | 2025 | IPD meta-analysis | 5 studies, n=1433. LSM>=25 pooled PPV 92%. NPV rule-out 99%. ANTICIPATE >=75% → PPV 95% incl. MASLD+obesity |
| 35876975 | Kumar | J Med Ultrason | 2022 | Meta-analysis | 26 studies, n=4337. Weighted mean cutoff 22.8 kPa. Sens 79%, Spec 88%, AUROC 0.91 |
| 37288716 | Song | Liver Int | 2023 | Validation cohort | n=1966 cACLD. 3-yr decompensation: 22% CSPH vs 1.4% excluded. sHR 8.00 |
| 38479612 | Jachs | J Hepatol | 2024 | Validation (HDV) | n=51 HDV. Baveno VII: 100% sens rule-out, 84.2% spec rule-in. ANTICIPATE AUROC 0.885 |
| 36214066 | Rabiee | Hepatol Commun | 2022 | External validation | ANTICIPATE validated in NASH. n=222. Both models AUC>0.8. Developed FIB4+ (AUC 0.80) |
| 38740698 | He | Hepatol Int | 2024 | Validation (2D-SWE) | n=118. LSM>=25 OR SSM>=50: PPV 100%, spec 100% |
| 40844510 | Prakash | Am J Gastroenterol | 2025 | Prospective | n=116. SSM 100Hz AUROC 0.849 for HREV. SSM 35 kPa cutoff: sens 95.6% |
| 40719905 | Li | Clin Exp Med | 2025 | Retrospective | n=1409 cACLD. Dynamic LSM (delta/baseline) AUC 0.777-0.782 for decompensation |
| 36503206 | Rodrigues | Clin Mol Hepatol | 2023 | Editorial | "Shades of Grey" — gray zone 40-60%, SSM reduces to 7-15% |
| 37646318 | Lin | APT | 2023 | Prospective cohort | n=2763 cACLD. Gray zone 44.9%. 5yr decompensation: 4.2% |
| 18395077 | Friedrich-Rust | Gastroenterology | 2008 | Meta-analysis | 50 studies. AUROC: 0.84 (F2), 0.89 (F3), 0.94 (F4). Accuracy varies by etiology for F2 |
| 19745758 | Stebbing | J Clin Gastroenterol | 2010 | Meta-analysis | 22 studies, 4430 pts. F2 cutoff 7.71 kPa (sens 71.9%, spec 82.4%). F4 cutoff 15.08 kPa |
| 39983746 | Liguori/Tsochatzis | Lancet GH | 2025 | Meta-analysis | WHO 2024: 211 studies, 61,665 pts HBV. FibroScan >=7.0 kPa for F2, >=12.5 kPa for F4 |
| 41546486 | Barrett | Liver Int | 2026 | Systematic review | F3 progression: HR 8.15 for MALO. F3 vs F4 poorly distinguished by NITs |
| 39165159 | Chon | Clin Mol Hepatol | 2024 | Meta-analysis | NAFLD: VCTE 7.1-7.9 kPa optimal for AF. AUC 0.87 (F3), 0.94 (F4) |
| 26669632 | Li | APT | 2016 | Meta-analysis | CHB: 27 studies, 4386 pts. AUROC 0.88 (F2), 0.91 (F3), 0.93 (F4) |
| 38605932 | Lai/Wong | Gastroenterol Rep | 2024 | Review | Confounders + disease-specific cutoffs |
| 40034396 | Mandorfer | JHEP Rep | 2024 | Review | NITs for PH: liver stiffness and beyond |

## INVALID PMID DETECTED
- **34052326**: Previously listed as EASL CPG on NITs 2021 — actually returns a prostate cancer paper (Freeland, Cancer Lett 2021). CORRECT PMID = 34166721.

---

## 1. Baveno VII Rule-of-5 Key Cutoffs

| LSM (kPa) | + Platelet | Classification | PPV/NPV |
|------------|-----------|----------------|---------|
| <10 | any | Excludes cACLD | — |
| 10-14.9 | any | Probable cACLD | — |
| <15 | >=150x10^9/L | Excludes CSPH | NPV 99% (pooled) |
| 15-19.9 | <110x10^9/L | Probable CSPH (>=60% risk) | — |
| 20-24.9 | <150x10^9/L | Probable CSPH (>=60% risk) | — |
| >=25 | any | Certain CSPH | PPV 92% (pooled) |
| 50-75 | any | "Critical CSPH" (proposed) | ~2x decompensation risk vs 25-49.9 |

---

## 2. Pooled Diagnostic Accuracy (Kumar 2022 meta-analysis)

- 26 studies, 4337 patients
- Weighted mean optimal cutoff: 22.8 kPa
- Sensitivity: 79% (95% CI 74-84%)
- Specificity: 88% (95% CI 84-91%)
- AUROC (HSROC): 0.91 (95% CI 0.88-0.93)
- Correlation with HVPG: r=0.70 (range 0.36-0.86)
- Heterogeneity: I2 83% (sensitivity), 74% (specificity)

---

## 3. MASLD Gap

- LSM >=25 kPa PPV in obese MASLD: only 62.8% (Pons 2021)
- ANTICIPATE-NASH (LSM+PLT+BMI) at >=75% risk threshold: PPV 83-95% (Banares 2025)
- Rule-out (LSM <15 + PLT >=150) works across all etiologies: NPV 99%

---

## 4. Limitations of the Rule of Five (7 major categories)

### L1. Gray Zone — 40-60% of cACLD patients are "indeterminate"
- LSM 15-24.9 kPa = "probable CSPH" but PPV/NPV suboptimal
- In Lin 2023 (n=2763): 44.9% in gray zone, 19.4% high-risk
- 5yr decompensation: low-risk 0.6%, gray zone 4.2%, high-risk 11.4%
- Wong study: Baveno VII criteria "suboptimal to predict decompensation" in probable CSPH
- SSM (spleen stiffness) reduces gray zone from 40-60% to 7-15% (Rodrigues 2023)

### L2. Obesity/MASLD — PPV drops dramatically
- LSM >=25 kPa PPV for CSPH: 90%+ in viral, but only 62.8% in obese NASH (Pons 2021)
- Portal hypertension prevalence in cACLD: >90% viral, only 60.9% NASH (53.3% obese NASH)
- ANTICIPATE-NASH model (LSM+PLT+BMI) improves to PPV 83-95% at >=75% risk threshold

### L3. Derivation bias — primarily viral hepatitis cohorts
- Original Rule-of-5 derived in cohort with HCV 43%, NASH 30%, ALD 24%, HBV 3%
- Non-viral etiologies (ALD, MASLD) less validated
- ALD patients: alcohol use can falsely elevate LSM by ~2.6 kPa
- MASLD patients: steatosis and inflammation confound independently

### L4. F2/F3 discrimination — NOT the purpose of Rule of 5
- Rule of 5 classifies cACLD and CSPH risk, NOT fibrosis stage
- F3 vs F4 discrimination by NITs is poor: Barrett 2026 review states NITs "differentiate between F3 and F4 fibrosis poorly"
- 16% of F3 patients already have varices; decompensation occurs in F3 MASLD
- Clinical implication: the F3-F4 boundary may be less important than the composite F3-4 for outcomes

### L5. Confounders affect ALL strata (amplified in gray zone)
- See [[elastography-modality-comparison-and-limitations]] for quantitative confounder impact (ALT, postprandial, BMI, cholestasis, congestion, alcohol, ascites, severe steatosis)

### L6. Reliability issues inflate/deflate strata assignment
- IQR/median >30% = poorly reliable (Boursier criteria)
- Failure rate: 3.37% overall, 8.86% with XL probe (NHANES 2017-2020)
- BMI >30: 5.86% failure rate
- Ascites: TE not feasible

### L7. No dynamic assessment — snapshot vs trajectory
- Rule of 5 is a single-timepoint classification
- Delta LSM (change over time) may predict decompensation better (Li 2025, PMID 40719905)
- A 10-20% drop in LSM post-treatment = clinically meaningful but no Baveno VII guidance

---

## 5. F2/F3 VCTE Cutoffs by Etiology

### Meta-analytic pooled cutoffs (all etiologies)
| Stage | Cutoff (kPa) | Sensitivity | Specificity | AUROC | Source |
|-------|-------------|-------------|-------------|-------|--------|
| >=F2 | 7.71 | 71.9% | 82.4% | 0.84 | Stebbing 2010 (PMID 19745758) |
| >=F3 | ~9.5-10.0 | — | — | 0.89 | Friedrich-Rust 2008 (PMID 18395077) |
| F4 | 15.08 | 84.5% | 94.7% | 0.94 | Stebbing 2010 (PMID 19745758) |

### Etiology-specific cutoffs (EASL 2021 + meta-analyses)

| Etiology | >=F2 (kPa) | >=F3 (kPa) | F4 (kPa) | Source |
|----------|-----------|-----------|---------|--------|
| HCV | 7.0 | 9.5-10.0 | 12.5-13.0 | EASL 2021 |
| HBV | 7.0 | 8.1-8.8 | 11.0-12.5 | EASL 2021 / WHO 2024 (PMID 39983746) |
| NAFLD/MASLD | 7.0-8.2 | 7.1-7.9 (AF) / 8.0-10.0 | 12.0-13.0 | EASL 2021 / Chon 2024 (PMID 39165159) |
| ALD | ~8.0 | ~12.0 | ~12.5-15.0 | EASL 2021 (higher due to inflammation) |
| PBC | 7.5-17.9 (AF range) | — | — | An 2024 (PMID 39165158) |
| AIH | 8.18-12.1 (AF range) | — | — | An 2024 (PMID 39165158) |

### Key finding: F2 vs F3 overlap
- AUROC for F2 = 0.84 vs F3 = 0.89 vs F4 = 0.94 (Friedrich-Rust 2008)
- Accuracy INCREASES with fibrosis stage — F2 has the WORST discrimination
- VCTE has BROAD cutoff ranges for F2-F3: 4.8-16.4 kPa for >=F2, reflecting etiology dependence

---

## 6. Gray Zone (10-25 kPa) Sub-stratification

### Baveno VII classification within gray zone
| LSM (kPa) | + Platelet | Category | 5yr decompensation |
|-----------|-----------|----------|-------------------|
| 10-14.9 | any | Probable cACLD | Part of "low-risk" 0.6% |
| 15-19.9 | >=110 | cACLD, no CSPH (low gray) | Part of gray zone 4.2% |
| 15-19.9 | <110 | Probable CSPH (high gray) | Part of gray zone 4.2% |
| 20-24.9 | >=150 | cACLD, no CSPH (low gray) | Part of gray zone 4.2% |
| 20-24.9 | <150 | Probable CSPH (high gray) | Part of gray zone 4.2% |

### Risk factors for decompensation WITHIN gray zone (Lin 2023):
- ALD etiology (higher risk)
- ALBI score (albumin-bilirubin)
- Alkaline phosphatase level

### Spleen stiffness adds discrimination:
- SSM >40 kPa + gray zone = reclassify to high-risk
- SSM <40 kPa + gray zone = reclassify to low-risk
- Reduces gray zone from 40-60% to 7-15%

---

## 7. F3 vs F4: Clinical Relevance (Barrett 2026)

- F3 MASLD: HR 8.15 (95% CI 3.42-19.43) for MALO vs controls
- F4 MASLD: HR 38.16 (95% CI 11.58-125.76) for MALO vs controls
- F3 progression to cirrhosis: 16-30% on paired biopsies
- F3 patients with varices: 16% (vs 63.8% in F4)
- Time to 10% decompensation: F3 = 11.8 years, F4 = 5.6 years
- Optimal LSM to predict progression in F3: >=16.6 kPa (31.1% progressed vs 9.1% below)
- KEY: "Non-invasive tests of fibrosis differentiate between F3 and F4 fibrosis poorly"
