---
name: Elastography — Modality Comparison (MRE vs TE) and Confounders/Limitations
description: TE/VCTE confounders (ALT, food, obesity, ascites, cholestasis, congestion), failure rates, XL probe, reliability, SSM + MRE vs VCTE head-to-head (AUROC, cutoff tables, kPa scale difference, portal hypertension, cost/access) — merged from elastography-confounders-limitations + mre-vs-te-head-to-head (S225 2026-04-17)
type: reference
---

# Elastography — Modality Comparison and Limitations

Researched: 2026-03-29. Merged S225.
MCPs used: BioMCP (article_searcher + article_getter + think), WebSearch

## Verified PMIDs (17 total, all confirmed via BioMCP article_getter)

| PMID | First Author | Year | Journal | Role / Key Finding |
|------|-------------|------|---------|--------------------|
| **34166721** | EASL | 2021 | J Hepatol | Tier-1 guideline: confounders, fasting, reliability |
| **38762390** | WFUMB | 2024 | Ultrasound Med Biol | Tier-1 guideline: reliability, SSM, portal HTN |
| **38489521** | AASLD (Duarte-Rojo) | 2024 | Hepatology | Tier-1: 240 studies, 61,193 pts, TE/SWE/MRE accuracy |
| **39649032** | NHANES 2017-2020 | 2024 | J Clin Transl Hepatol | Failure rate VCTE 3.37%, BMI/age/XL factors |
| **41498616** | Cochrane | 2026 | Cochrane Database Syst Rev | LSM+SSM for CSPH, 47 studies, 7817 pts, VCTE sens 72.6%@spec90% |
| **38605932** | Lai/Wong | 2024 | Gastroenterol Rep | Review: confounders + disease-specific cutoffs |
| **40900859** | — | 2025 | World J Methodol | Splenic TE for portal hypertension (review): SSM cutoffs 45-50 kPa |
| **36990516** | de Franchis | 2022 | J Hepatol | Baveno VII: Rule-of-5 — <10 excludes cACLD, >=25 rules in CSPH |
| 25305349 | Singh | 2015 | Clin Gastroenterol Hepatol | IPD meta MRE fibrosis: AUROC 0.84/0.88/0.93/0.92 for F1-F4; n=697, 12 studies |
| 29908362 | Hsu | 2019 | Clin Gastroenterol Hepatol | MRE vs TE IPD NAFLD: MRE 0.87/0.92/0.93/0.94 vs TE 0.82/0.87/0.84/0.84; n=230 |
| 29107943 | Xiao | 2017 | PLoS One | MRE vs FibroScan meta CHB: 0.981/0.972/0.972 vs 0.796/0.893/0.905 for F2/F3/F4 |
| 33991635 | Selvaraj (LITMUS) | 2021 | J Hepatol | NAFLD: VCTE 0.83/0.85/0.89 vs MRE 0.91/0.92/0.90 for sig/adv/cirrhosis |
| 39165159 | Chon | 2024 | Clin Mol Hepatol | Largest meta — optimal cutoffs NAFLD: VCTE 7.1-7.9 kPa, MRE 3.62-3.8 kPa |
| 35727321 | Kennedy | 2022 | Eur Radiol | 3D MRE spleen stiffness for CSPH: AUC 0.911, r=0.686 with HVPG |
| 40034396 | Mandorfer | 2024 | JHEP Rep | Review NITs for portal hypertension — liver stiffness and beyond |
| 39300925 | Zhang & Wong | 2024 | Clin Mol Hepatol | Editorial: LITMUS IPD cutoffs 3.14/3.53/4.45 kPa for F2/F3/F4 MRE |
| 26677985 | Imajo | 2016 | Gastroenterology | Head-to-head NAFLD n=142: MRE AUROC 0.91 vs TE 0.82 for >=F2 |

---

## 1. Confounders that INCREASE LSM Falsely

| Confounder | Magnitude | Key data | Source |
|-----------|-----------|----------|--------|
| ALT flare | 1.3-3x fold increase | Acute hep B: median 15.6 kPa (range 7.1-57) mimicking cirrhosis; resolves with ALT norm | Arena, Coco; review PMC4734958 |
| Postprandial | +17-21% healthy; +21% (range 8-63%) in fibrosis | Peak 15-45 min post-meal, returns baseline ~120 min | Multiple |
| Extrahepatic cholestasis | Mean 8.9 kPa -> 5.6 kPa after drainage | Severe cases: up to 15.2 kPa -> 7.1 kPa post-drainage | Millonig 2008 (PMID 22087164) |
| Hepatic congestion/CHF | Significant elevation correlating with RAP | TE reflects right atrial pressure, not fibrosis | Multiple |
| Acute alcohol | 2.6 kPa reduction at 4 wks abstinence (p=0.004) | Defer testing 2-4 wks post-cessation | Review PMC12781356 |
| Severe steatosis (S3) | Low correlation TE vs pSWE (r=0.48) | 38.6% >=2-stage discordance in class 3 obesity | Losurdo 2025 (PMID 40807038) |

### ALT threshold (EASL 2021)
- ALT >5x ULN: defer until normalization
- ALT >100 IU/L: interpret with caution
- Overestimation >=2 grades: 50% probability at ALT ~2x ULN

### Fasting (EASL)
- Minimum 3 hours pre-test
- Effect persists >=2.5 hours post-meal
- Peak elevation 15-45 min post-meal

---

## 2. Failure Rates and XL Probe

### Failure causes

| Cause | M probe failure | XL probe failure | Mechanism |
|-------|----------------|-----------------|-----------|
| Obesity BMI>30 | 5-22% | 1.1% | SCD >2.6cm (M) or >3.4cm (XL) |
| Ascites | High rate | High rate | Shear wave interrupted by fluid |
| Narrow intercostal | Variable | N/A | No acoustic window |

### NHANES 2017-2020 failure rates (n=7096)
- Overall US: 3.37%
- XL probe group: 8.86%
- Obese: 5.86%
- Diabetic: 5.33%
- Age >=64: 4.55%
- Factors: age OR 1.03, BMI OR 1.07, XL use OR 4.05

### XL probe specifics
- Frequency: 3.5 MHz (vs 5 MHz M)
- Depth: 35-75 mm (vs 25-65 mm M)
- Lower cutoffs needed: XL 4.8 kPa ~ M 6.0 kPa; XL 10.7 kPa ~ M 12.0 kPa
- Auto-switching on current machines based on SCD

---

## 3. Reliability Criteria (EASL/WFUMB/manufacturer consensus)

- Minimum 10 valid measurements
- Success rate >=60%
- IQR/median <30% (kPa) or <15% (m/s)
- Boursier categories: very reliable (IQR/M <=0.10), reliable (0.10-0.30 OR >0.30 if LSM <7.1), poorly reliable (>0.30 + LSM >=7.1)

---

## 4. When NOT to Trust TE

1. Acute hepatitis (any cause) — wait for ALT normalization
2. Extrahepatic cholestasis — wait until post-drainage bilirubin normalization
3. Active CHF / elevated CVP — treat heart failure first
4. Ascites — use 2D-SWE or MRE instead
5. BMI >40 + SCD >3.4cm — MRE preferred
6. <3h fasting
7. Active heavy alcohol use — defer 2-4 weeks

---

## 5. Spleen Stiffness Measurement (SSM) — Emerging Data

- Cutoffs for significant portal hypertension: 45-50 kPa (TE)
- Cochrane 2026 (PMID 41498616): SSM by VCTE sens 72.9% at spec 90%, SSM by 2D-SWE sens 80% at spec 90%
- Baveno VI + SSM100Hz: SER 31.5%, missed HRV 3%
- PVT: SSM 27.9 vs 16.9 kPa controls (p<0.001)
- 3D MRE spleen stiffness for CSPH: AUC 0.911, r=0.686 with HVPG (Kennedy 2022, PMID 35727321)

---

## 6. MRE vs TE Head-to-Head

### Critical Nuance: kPa Scales Are NOT Equivalent

MRE and VCTE both report in kPa but measure fundamentally different physical properties:
- VCTE: 50 Hz, 1D, ~1x4cm cylinder sample
- MRE: 60 Hz, 2D/3D, large liver cross-section
- MRE values are ~3x lower than VCTE for same fibrosis stage

### Cutoff Summary (NAFLD/MASLD)

| Stage | MRE (kPa) | VCTE (kPa) |
|-------|-----------|------------|
| >=F1  | 2.5-3.14  | 5.0-9.6    |
| >=F2  | 2.77-4.14 | 4.8-16.4   |
| >=F3  | 3.62-3.8  | 7.1-7.9    |
| F4    | 3.35-6.7  | 6.9-20.1   |

### AUROC comparison (by cohort/meta)

| Study | N | F2 MRE / TE | F3 MRE / TE | F4 MRE / TE |
|-------|---|-------------|-------------|-------------|
| Singh 2015 IPD | 697 | — / — | 0.88 / — | 0.93 / — |
| Hsu 2019 IPD NAFLD | 230 | 0.87 / 0.82 | 0.93 / 0.84 | 0.94 / 0.84 |
| Xiao 2017 CHB | — | 0.981 / 0.796 | 0.972 / 0.893 | 0.972 / 0.905 |
| Selvaraj 2021 LITMUS | — | 0.91 / 0.83 | 0.92 / 0.85 | 0.90 / 0.89 |
| Imajo 2016 NAFLD | 142 | 0.91 / 0.82 | — / — | — / — |

### When Each Modality Wins

**MRE superior:**
- Lower fibrosis stages (F1-F2)
- Obese patients (BMI >40 + SCD >3.4cm)
- Ascites (TE fails)
- NAFLD/MASLD significant fibrosis
- Spleen stiffness for portal hypertension (3D MRE)

**VCTE comparable or preferred:**
- Cirrhosis (F4) — both AUROC 0.94
- Cost ($200-500 vs $500-2500)
- Accessibility (portable, 127+ countries)
- Baveno VII framework (Rule-of-5)
- Serial monitoring

### Other modality considerations
- TE vs pSWE: high correlation (r=0.83-0.87), pSWE slightly closer to MRE
- TE vs 2D-SWE: comparable AUCs for fibrosis, but poor correlation in Fontan/congestion
- 2D-SWE advantage in ascites: works when TE fails
- Severe steatosis (S3): TE-pSWE correlation drops (r=0.48) — consider MRE
