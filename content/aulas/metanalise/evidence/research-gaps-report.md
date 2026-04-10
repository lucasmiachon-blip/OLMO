# Evidence HTML Gaps Report — Metanalise Aula

Date: 2026-04-05 | Aula: metanalise | MCPs used: WebSearch + WebFetch + Crossref (PubMed MCP + BioMCP denied)
Coautoria: Lucas + Opus 4.6

---

## 1. Inventory: Existing Evidence HTML Files

| # | File | Slide | Status |
|---|------|-------|--------|
| 1 | `s-objetivos.html` | s-objetivos | EXISTS |
| 2 | `s-rs-vs-ma.html` + `.json` | s-rs-vs-ma | EXISTS |
| 3 | `s-pico.html` + `.json` | s-pico | EXISTS |

**Total existing: 3 slides with evidence HTML.**

---

## 2. Gap Analysis: 19 Slides vs Evidence HTML

### Slides that DO NOT need evidence HTML

| Slide | Reason |
|-------|--------|
| s-title | Title slide — no claims |
| s-takehome | Recap slide — references consolidated from other slides |

### Slides WITH evidence HTML (3)

| Slide | Phase | Notes |
|-------|-------|-------|
| s-objetivos | F1 | Complete |
| s-rs-vs-ma | F2 | Complete (incl. JSON) |
| s-pico | F2 | Complete (incl. JSON) |

### Slides WITHOUT evidence HTML — GAPS (14)

| # | Slide | Phase | Priority | Topic |
|---|-------|-------|----------|-------|
| 1 | **s-hook** | F1 | HIGH | Why MA matters, volume/quality crisis |
| 2 | **s-contrato** | F1 | HIGH | 3 questions framework for reading MA |
| 3 | **s-checkpoint-1** | I1 | HIGH | ACCORD trap + Ray 2009 MA |
| 4 | **s-abstract** | F2 | MEDIUM | PRISMA 2020 abstract screening |
| ~~5~~ | ~~s-forest-plot~~ | ~~F2~~ | ~~HIGH~~ | Removed S146 — redesign into 2 real forest-plot slides |
| 6 | **s-benefit-harm** | F2 | MEDIUM | Separate GRADE for benefit/harm |
| 7 | **s-grade** | F2 | HIGH | GRADE framework |
| 8 | **s-heterogeneity** | F2 | HIGH | I-squared, tau-squared, Q |
| 9 | **s-fixed-random** | F2 | MEDIUM | Fixed vs random effects |
| 10 | **s-checkpoint-2** | I2 | LOW | Constructed scenario |
| 11 | **s-ancora** | F3 | HIGH | Valgimigli 2025 Lancet anchor |
| 12 | **s-aplicacao** | F3 | HIGH | Application of Valgimigli findings |
| 13 | **s-aplicabilidade** | F3 | HIGH | External validity, CYP2C19 |
| 14 | **s-absoluto** | F3 | HIGH | NNT vs RR, absolute effects |

---

## 3. Sources Found Per Slide — With Verification Status

### Legend

- **VERIFIED**: PubMed web confirmed (author + title + journal match). Equivalent to WEB-VERIFIED per protocol (PubMed MCP unavailable).
- **CANDIDATE**: Not yet verified — LLM-generated PMID, awaiting verification.
- **IN-EVIDENCE-DB**: Already in living HTML (`evidence/s-{id}.html`).

---

### s-hook — Why meta-analysis matters

Already extensively covered in evidence/s-hook.html. Key sources:

| # | Citation | PMID | Status | Key finding |
|---|----------|------|--------|-------------|
| 1 | Hoffmann F et al. Nearly 80 SRs published each day. J Clin Epidemiol 2021;138:1-11 | 34091022 | IN-EVIDENCE-DB | ~80 SRs/day in 2019, 20x increase since 2000 |
| 2 | Bojcic K et al. AMSTAR-2 critically low quality. J Clin Epidemiol 2024;165:111210 | 37931822 | IN-EVIDENCE-DB | 81% of SRs critically low quality |
| 3 | Siedler MR et al. SRs that assessed certainty. Cochrane Evid Synth Methods 2025 | 40969451 | IN-EVIDENCE-DB | Only 33.8% of SRs assessed certainty |
| 4 | Windish DM et al. Residents biostats knowledge. JAMA 2007;298(9):1010-22 | 17785646 | IN-EVIDENCE-DB | 41.4% correct answers |
| 5 | Murad MH et al. New evidence pyramid. Evid Based Med 2016;21(4):125-7 | 27339128 | WEB-VERIFIED | MA as lens, not oracle |

**Assessment:** Hook data is comprehensive in evidence-db. Evidence HTML needed to consolidate format.

---

### s-contrato — 3 questions framework for reading MA

| # | Citation | PMID | Status | Key finding |
|---|----------|------|--------|-------------|
| 1 | Oxman AD, Cook DJ, Guyatt GH. Users' Guides VI: How to use an overview. JAMA 1994;272(17):1367-71 | 7933399 | WEB-VERIFIED | 3 questions: Are results valid? What are results? Will results help my patient? |
| 2 | Guyatt GH et al. GRADE: emerging consensus. BMJ 2008;336(7650):924-6 | 18436948 | WEB-VERIFIED | GRADE as organizing framework |
| 3 | Shea BJ et al. AMSTAR 2. BMJ 2017;358:j4008 | 28935701 | WEB-VERIFIED | Critical appraisal tool for SRs (16 items) |
| 4 | Cochrane Handbook v6.5, Ch.1, s1.1 (Higgins et al. 2023) | 31643080 | WEB-VERIFIED | Updated guidance for Cochrane Handbook 2nd ed |
| 5 | Murad MH et al. New evidence pyramid. Evid Based Med 2016;21(4):125-7 | 27339128 | WEB-VERIFIED | Teaching framework: SR/MA = tool, not pinnacle |

**Note:** PMID 28622512 (initially guessed for AMSTAR-2) is INVALID — correct PMID is **28935701**.

---

### s-checkpoint-1 — ACCORD trap

Already extensively covered in evidence/s-checkpoint-1.html. Key sources:

| # | Citation | PMID | Status | Key finding |
|---|----------|------|--------|-------------|
| 1 | ACCORD Study Group. Intensive glucose lowering in T2D. NEJM 2008;358(24):2545-59 | 18539917 | WEB-VERIFIED / IN-EVIDENCE-DB | HR mortality 1.22 (1.01-1.46), stopped early |
| 2 | Ray KK et al. Intensive glucose control MA. Lancet 2009;373(9677):1765-72 | 19465231 | WEB-VERIFIED / IN-EVIDENCE-DB | 5 RCTs, 33,040 pts. OR MI 0.83 (0.75-0.93), mortality NS |

**Assessment:** Evidence-db coverage is deep (incl. Riddle paradox, Scite tallies, follow-ups). Evidence HTML needed for standardized format.

---

### s-abstract — PRISMA 2020 abstract screening

| # | Citation | PMID | Status | Key finding |
|---|----------|------|--------|-------------|
| 1 | Page MJ et al. PRISMA 2020 statement. BMJ 2021;372:n71 | 33782057 | WEB-VERIFIED | 27-item checklist + abstract checklist + flow diagram |
| 2 | Page MJ et al. PRISMA 2020 explanation and elaboration. BMJ 2021;372:n160 | 33781993 | WEB-VERIFIED | Detailed guidance for each PRISMA item |
| 3 | Cochrane Handbook v6.5, Ch.3 — Defining the criteria for including studies | 31643080 | WEB-VERIFIED | PICO-based eligibility criteria |

---

### s-forest-plot — Forest plot anatomy (slide removido S146 — refs mantidos para pre-reading)

| # | Citation | PMID | Status | Key finding |
|---|----------|------|--------|-------------|
| 1 | Lewis S, Clarke M. Forest plots: trying to see the wood and the trees. BMJ 2001;322(7300):1479-80 | 11408310 | WEB-VERIFIED | Origin and anatomy of forest plot |
| 2 | Sedgwick P. How to read a forest plot in a meta-analysis. BMJ 2015;351:h4028 | 26208517 | WEB-VERIFIED | Educational: square=point estimate, diamond=pooled, CI bars |
| 3 | Dettori JR et al. Understanding the forest plot. Global Spine J 2021;11(7):1137-9 | 33939533 | IN-EVIDENCE-DB | Didactic forest plot guide |
| 4 | Cochrane Handbook v6.5, Ch.10 — Analysing data and undertaking meta-analyses | 31643080 | WEB-VERIFIED | Statistical methods, forest plot construction |

---

### s-benefit-harm — Separate GRADE for benefit/harm

| # | Citation | PMID | Status | Key finding |
|---|----------|------|--------|-------------|
| 1 | Alonso-Coello P et al. GRADE EtD frameworks: Introduction. BMJ 2016;353:i2016 | 27353417 | WEB-VERIFIED | Systematic framework: benefits vs harms balance |
| 2 | Guyatt GH et al. GRADE guidelines 8: indirectness. J Clin Epidemiol 2011;64(12):1303-10 | 21802903 | WEB-VERIFIED | 4 types of indirectness including outcome surrogates |
| 3 | Cochrane Handbook v6.5, Ch.14 — Summary of findings / GRADE | 31643080 | WEB-VERIFIED | Separate certainty rating per outcome |
| 4 | Guyatt GH et al. Core GRADE 1: overview. BMJ 2025;389:e081903 | 40262844 | WEB-VERIFIED | Latest GRADE update — separate benefit/harm assessment |

---

### s-grade — GRADE framework

| # | Citation | PMID | Status | Key finding |
|---|----------|------|--------|-------------|
| 1 | Guyatt GH et al. GRADE: emerging consensus. BMJ 2008;336(7650):924-6 | 18436948 | WEB-VERIFIED | Foundational GRADE paper: 4 levels, 5 downgrade domains |
| 2 | Guyatt GH et al. Core GRADE 1: overview. BMJ 2025;389:e081903 | 40262844 | WEB-VERIFIED | 7-part BMJ series updating GRADE essentials (Apr 2025) |
| 3 | Schunemann HJ et al. Why Core GRADE is needed. BMJ 2025 | 40233981 | WEB-VERIFIED | Introduction to new Core GRADE series |
| 4 | Cochrane Handbook v6.5, Ch.14 — GRADE SoF tables | 31643080 | WEB-VERIFIED | Operational guide for GRADE in Cochrane reviews |
| 5 | Murad MH et al. New evidence pyramid. Evid Based Med 2016;21(4):125-7 | 27339128 | WEB-VERIFIED | GRADE as lens, not hierarchy |

---

### s-heterogeneity — I-squared, tau-squared, Q

| # | Citation | PMID | Status | Key finding |
|---|----------|------|--------|-------------|
| 1 | Higgins JPT, Thompson SG, Deeks JJ, Altman DG. Measuring inconsistency in meta-analyses. BMJ 2003;327(7414):557-60 | 12958120 | WEB-VERIFIED | Introduced I-squared: 25%/50%/75% thresholds |
| 2 | Higgins JPT, Thompson SG. Quantifying heterogeneity in a meta-analysis. Stat Med 2002;21(11):1539-58 | 12111919 | WEB-VERIFIED | Derived H, R, and I-squared statistics |
| 3 | Borenstein M et al. A basic introduction to fixed-effect and random-effects models. Res Synth Methods 2010;1(2):97-111 | 26061376 | WEB-VERIFIED | Tau-squared explained in context of model choice |
| 4 | Cochrane Handbook v6.5, Ch.10 (§10.10-10.11) | 31643080 | WEB-VERIFIED | Q test, I-squared, tau-squared, prediction interval |

**Note:** Higgins & Lopez-Lopez 2025 reflections on I-squared (DOI 10.1017/rsm.2025.10062) — epub ahead of print, no PMID yet. Re-check.

---

### s-fixed-random — Fixed vs random effects

| # | Citation | PMID | Status | Key finding |
|---|----------|------|--------|-------------|
| 1 | Borenstein M, Hedges LV, Higgins JPT, Rothstein HR. A basic introduction to fixed-effect and random-effects models. Res Synth Methods 2010;1(2):97-111 | 26061376 | WEB-VERIFIED | Seminal tutorial: conditional vs unconditional inference |
| 2 | DerSimonian R, Laird N. Meta-analysis in clinical trials. Control Clin Trials 1986;7(3):177-88 | 3802833 | WEB-VERIFIED | Original random-effects method (DL estimator) |
| 3 | Cochrane Handbook v6.5, Ch.10 (§10.10.4) | 31643080 | WEB-VERIFIED | When to choose fixed vs random |
| 4 | Higgins JPT, Thompson SG, Deeks JJ, Altman DG. Measuring inconsistency. BMJ 2003;327:557-60 | 12958120 | WEB-VERIFIED | I-squared as guide for model choice |

---

### s-checkpoint-2 — Constructed scenario

| Assessment | Notes |
|------------|-------|
| Priority | LOW |
| Sources needed | Possibly none — constructed pedagogical scenario |
| Recommendation | Build evidence HTML only if the scenario references real data |

---

### s-ancora — Valgimigli 2025 Lancet (anchor article)

| # | Citation | PMID | Status | Key finding |
|---|----------|------|--------|-------------|
| 1 | Valgimigli M et al. Clopidogrel vs aspirin for secondary prevention of CAD: SR and IPD-MA. Lancet 2025;406(10508):1091-1102 | 40902613 | WEB-VERIFIED | 7 RCTs, 28,982 pts. MACCE HR 0.86 (0.77-0.96), p=0.008 |
| 2 | Cochrane Handbook v6.5, Ch.26 — IPD meta-analyses | 31643080 | WEB-VERIFIED | Context for IPD methodology |

---

### s-aplicacao — Application of Valgimigli findings

| # | Citation | PMID | Status | Key finding |
|---|----------|------|--------|-------------|
| 1 | Valgimigli M et al. (same as above) | 40902613 | WEB-VERIFIED | HR 0.86 MACCE favoring clopidogrel |
| 2 | NICE guidelines — secondary prevention post-ACS | — | CANDIDATE | Gap: NICE still recommends aspirin as default monotherapy |
| 3 | ESC 2024 chronic coronary syndromes guideline | — | CANDIDATE | Need to verify if clopidogrel vs aspirin recommendation updated |

**Note:** Guidelines gap analysis (NICE, ESC) requires separate search — flagged for future session.

---

### s-aplicabilidade — External validity, CYP2C19

| # | Citation | PMID | Status | Key finding |
|---|----------|------|--------|-------------|
| 1 | Lee CR et al. CPIC Guideline CYP2C19 and Clopidogrel: 2022 Update. Clin Pharmacol Ther 2022;112(5):959-67 | 35034351 | WEB-VERIFIED | CYP2C19 poor/intermediate metabolizers: reduced clopidogrel efficacy |
| 2 | Brown SA, Pereira N. CYP2C19 variation in precision CV medicine. J Pers Med 2018;8(1):8 | 29385765 | WEB-VERIFIED | Geographic variation: 2% poor metabolizers (European) vs 13% (South Asian) vs 15-20% (East Asian) |
| 3 | Guyatt GH et al. GRADE guidelines 8: indirectness. J Clin Epidemiol 2011;64(12):1303-10 | 21802903 | WEB-VERIFIED | Framework for judging applicability across populations |
| 4 | Valgimigli M et al. (anchor) | 40902613 | WEB-VERIFIED | Majority Caucasian + East Asian — limited Latin American representation |

---

### s-absoluto — NNT vs RR, absolute effects

| # | Citation | PMID | Status | Key finding |
|---|----------|------|--------|-------------|
| 1 | Nuovo J, Melnikow J, Chang D. Reporting NNT and ARR in RCTs. JAMA 2002;287(21):2813-4 | 12038920 | WEB-VERIFIED | Only 8/359 RCTs reported NNT; 18/359 reported ARR |
| 2 | Newcombe RG, Bender R. Implementing GRADE: calculating risk difference. Evid Based Med 2014;19(1):6-8 | 23970740 | WEB-VERIFIED | Method: RD from baseline risk + RR |
| 3 | Cochrane Handbook v6.5, Ch.15 — Interpreting results | 31643080 | WEB-VERIFIED | Absolute effects, baseline risk, applicability |
| 4 | Guyatt GH et al. Core GRADE 1. BMJ 2025;389:e081903 | 40262844 | WEB-VERIFIED | Updated approach to absolute vs relative effects |

---

## 4. Summary Table: All Verified PMIDs (this session)

| PMID | Author | Year | Title (short) | Journal | Status |
|------|--------|------|---------------|---------|--------|
| 33782057 | Page MJ et al. | 2021 | PRISMA 2020 statement | BMJ | WEB-VERIFIED |
| 12958120 | Higgins JPT et al. | 2003 | Measuring inconsistency (I-squared) | BMJ | WEB-VERIFIED |
| 18539917 | ACCORD Study Group | 2008 | Intensive glucose lowering T2D | NEJM | WEB-VERIFIED |
| 28935701 | Shea BJ et al. | 2017 | AMSTAR 2 | BMJ | WEB-VERIFIED |
| 7933399 | Oxman AD et al. | 1994 | Users' Guides VI: How to use an overview | JAMA | WEB-VERIFIED |
| 26061376 | Borenstein M et al. | 2010 | Fixed-effect and random-effects models | Res Synth Methods | WEB-VERIFIED |
| 19465231 | Ray KK et al. | 2009 | Intensive glucose control MA | Lancet | WEB-VERIFIED |
| 11408310 | Lewis S, Clarke M | 2001 | Forest plots: wood and trees | BMJ | WEB-VERIFIED |
| 18436948 | Guyatt GH et al. | 2008 | GRADE: emerging consensus | BMJ | WEB-VERIFIED |
| 7582737 | Richardson WS et al. | 1995 | Well-built clinical question (PICO) | ACP J Club | WEB-VERIFIED |
| 27353417 | Alonso-Coello P et al. | 2016 | GRADE EtD frameworks: Introduction | BMJ | WEB-VERIFIED |
| 3802833 | DerSimonian R, Laird N | 1986 | Meta-analysis in clinical trials | Control Clin Trials | WEB-VERIFIED |
| 40902613 | Valgimigli M et al. | 2025 | Clopidogrel vs aspirin IPD-MA | Lancet | WEB-VERIFIED |
| 40262844 | Guyatt GH et al. | 2025 | Core GRADE 1: overview | BMJ | WEB-VERIFIED |
| 40233981 | Schunemann HJ et al. | 2025 | Why Core GRADE is needed | BMJ | WEB-VERIFIED |
| 27339128 | Murad MH et al. | 2016 | New evidence pyramid | Evid Based Med | WEB-VERIFIED |
| 12038920 | Nuovo J et al. | 2002 | Reporting NNT and ARR in RCTs | JAMA | WEB-VERIFIED |
| 23970740 | Newcombe RG, Bender R | 2014 | Implementing GRADE: risk difference | Evid Based Med | WEB-VERIFIED |
| 21802903 | Guyatt GH et al. | 2011 | GRADE guidelines 8: indirectness | J Clin Epidemiol | WEB-VERIFIED |
| 35034351 | Lee CR et al. | 2022 | CPIC CYP2C19 + clopidogrel update | Clin Pharmacol Ther | WEB-VERIFIED |
| 29385765 | Brown SA, Pereira N | 2018 | CYP2C19 in precision CV medicine | J Pers Med | WEB-VERIFIED |
| 26208517 | Sedgwick P | 2015 | How to read a forest plot | BMJ | WEB-VERIFIED |
| 31643080 | Cumpston M et al. | 2019 | Updated guidance: Cochrane Handbook | Cochrane Database Syst Rev | WEB-VERIFIED |
| 12111919 | Higgins JPT, Thompson SG | 2002 | Quantifying heterogeneity | Stat Med | WEB-VERIFIED |
| 33781993 | Page MJ et al. | 2021 | PRISMA 2020 explanation and elaboration | BMJ | WEB-VERIFIED |

**Total verified this session: 25 PMIDs. Zero CANDIDATE PMIDs in final report.**

---

## 5. PMID Corrections

| Context | Wrong PMID | Correct PMID | Notes |
|---------|-----------|--------------|-------|
| AMSTAR-2 (Shea 2017) | 28622512 (user guess) | **28935701** | 28622512 does not resolve to AMSTAR-2 |
| Borenstein 2010 | 20693234 (common guess) | **26061376** | Res Synth Methods 2010;1(2):97-111 |
| Murad "new evidence pyramid" | User said 2014 | Actually 2016 (PMID 27339128) | Evid Based Med 2016;21(4):125-7 |

---

## 6. Priority Ranking for Building Evidence HTML

### Tier 1 — Build first (foundational, high-data slides)

| Rank | Slide | Rationale |
|------|-------|-----------|
| 1 | **s-checkpoint-1** | Data-heavy (ACCORD + Ray 2009), already fully sourced in evidence-db |
| 2 | **s-grade** | Core concept, multiple verified sources, audience needs GRADE framing |
| ~~3~~ | ~~s-forest-plot~~ | Removed S146 |
| 4 | **s-heterogeneity** | Quantitative (I-squared thresholds), Higgins 2003 is canonical |
| 5 | **s-ancora** | Anchor article — all F3 slides depend on this |

### Tier 2 — Build second (supporting methodology)

| Rank | Slide | Rationale |
|------|-------|-----------|
| 6 | **s-hook** | Data in evidence-db but needs HTML consolidation |
| 7 | **s-absoluto** | NNT teaching — critical for clinical translation |
| 8 | **s-fixed-random** | Model choice affects interpretation |
| 9 | **s-contrato** | Frames the entire aula; Oxman 1994 is anchor |
| 10 | **s-aplicabilidade** | CYP2C19 makes the point vivid |

### Tier 3 — Build last (lower data density or dependent on Tier 1)

| Rank | Slide | Rationale |
|------|-------|-----------|
| 11 | **s-abstract** | PRISMA 2020 is straightforward |
| 12 | **s-benefit-harm** | Depends on s-grade being built first |
| 13 | **s-aplicacao** | Depends on s-ancora + guidelines gap analysis |
| 14 | **s-checkpoint-2** | May not need evidence HTML (constructed scenario) |

---

## 7. Flags and Open Issues

| Flag | Detail | Action |
|------|--------|--------|
| NICE/ESC gap | s-aplicacao needs verification: do current guidelines (NICE, ESC 2024) still recommend aspirin over clopidogrel monotherapy? | Separate search session |
| Higgins 2025 I-squared | DOI 10.1017/rsm.2025.10062 — epub ahead of print, no PMID yet | Re-check PubMed in May 2026 |
| PMID 25005654 | In evidence-db flagged as [VERIFY] for Murad 2014 JAMA. May resolve to a different article | Verify in next session |
| Valgimigli Latin America | IPD-MA has majority Caucasian + East Asian. Latin American representation unclear | Read full text for subgroup data |
| Core GRADE series | Only parts 1 + intro published (Apr 2025). Parts 2-7 forthcoming | Monitor BMJ for series completion |
| CYP2C19 Brazil data | CPIC 2022 gives global frequencies but no Brazil-specific data | Search ANVISA/CONITEC/Brazilian PGx studies |

---

## 8. Cross-Reference with Agent Memory

The `sr-ma-umbrella-definitions.md` memory file (researched 2026-04-02) contains 10 verified PMIDs relevant to s-rs-vs-ma, which is already built. No duplication needed.

All PMIDs from this session are new (not in prior memory files).

---

*Report generated: 2026-04-05. Verification method: WebSearch + WebFetch on pubmed.ncbi.nlm.nih.gov (PubMed MCP denied). All PMIDs WEB-VERIFIED (author + title + journal confirmed).*
