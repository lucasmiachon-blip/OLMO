# Clinical Evaluation Report: Slide 14 (s-aplicacao)

> Evaluator: Claude Opus 4.6 (without /medical-researcher skill)
> Date: 2026-04-02
> Slide: `content/aulas/metanalise/slides/14-aplicacao.html`
> Evidence DB: `content/aulas/metanalise/references/evidence-db.md` (v5.7)
> Verification: PubMed MCP + WebSearch + Consensus

---

## 1. Reference Verification

### PMID 40902613 — Valgimigli et al. 2025

| Field | Slide | PubMed | Match? |
|-------|-------|--------|--------|
| First author | Valgimigli | Valgimigli M | YES |
| Title | (not in slide body) | "Clopidogrel versus aspirin for secondary prevention of coronary artery disease: a systematic review and individual patient data meta-analysis" | N/A |
| Journal | Lancet 2025 | Lancet (London, England), 2025 | YES |
| Volume/Pages | (not in slide) | 406(10508):1091-1102 | N/A |
| DOI | (not in slide) | 10.1016/S0140-6736(25)01562-4 | N/A |
| PMID | 40902613 | 40902613 | YES |

**Verdict: PMID VERIFIED.** Author, title, journal, volume, pages all confirmed via PubMed MCP. DOI confirmed: [10.1016/S0140-6736(25)01562-4](https://doi.org/10.1016/S0140-6736(25)01562-4).

---

## 2. Clinical Data Accuracy

### 2a. MACCE (Primary Efficacy Endpoint)

| Field | Slide | PubMed Abstract | Evidence-DB | Concordance |
|-------|-------|-----------------|-------------|-------------|
| HR | 0.86 | 0.86 | 0.86 | MATCH |
| 95% CI | 0.77-0.96 | 0.77-0.96 | 0.77-0.96 | MATCH |
| p-value | 0.008 | 0.0082 | 0.0082 | MINOR: slide rounds to 0.008, abstract says 0.0082 |
| Time frame | (not explicit in body) | 5.5 years | 5.5 years | See note below |
| Events clopidogrel | (not in slide body) | 929 (2.61/100 pt-yr) | 929 (2.61/100 pt-yr) | N/A |
| Events aspirin | (not in slide body) | 1062 (2.99/100 pt-yr) | 1062 (2.99/100 pt-yr) | N/A |

**p-value rounding:** Slide says p = 0.008; abstract says p = 0.0082. Acceptable rounding for a slide, but speaker notes correctly state p=0.0082. No clinical distortion.

**"14% reduction" claim (h2):** HR 0.86 = 1 - 0.86 = 14% relative risk reduction. Mathematically correct. This is a relative reduction, not absolute. The slide uses "MACCE caiu 14%" which is technically correct but could mislead if audience conflates relative and absolute reduction. The speaker notes do clarify this is a "reducao relativa" (line 30).

### 2b. Major Bleeding (Primary Safety Endpoint)

| Field | Slide | PubMed Abstract | Evidence-DB | Concordance |
|-------|-------|-----------------|-------------|-------------|
| HR | 0.94 | 0.94 | 0.94 | MATCH |
| 95% CI | 0.74-1.21 | 0.74-1.21 | 0.74-1.21 | MATCH |
| p-value | NS | p=0.64 | NS | MATCH (NS = correct interpretation) |
| Bleeding definition | (not in slide body) | "major bleeding" | BARC 3-5 | See note |

**Bleeding definition:** Speaker notes (line 51) correctly specify "BARC 3-5" for bleeding. The slide body says "Sangramento maior" which is an acceptable simplification. Evidence-DB confirms BARC 3-5.

### 2c. HR vs RR Distinction

The slide correctly uses **HR** (hazard ratio), consistent with the IPD meta-analysis methodology (semi-parametric shared log-normal frailty models). This is NOT a pairwise MA using RR. The evidence-DB correctly notes "HR (nao RR)" and the design rule E25 (HR = trial/IPD, RR = pairwise MA) is respected.

### 2d. Mortality

Speaker notes state "Mortalidade total e CV: sem diferenca entre grupos" (line 52). PubMed abstract confirms: "Mortality and major bleeding...did not differ." Evidence-DB confirms. MATCH.

---

## 3. GRADE Assessment

### What the slide says

- h2: "certeza GRADE nao foi avaliada"
- Footer: "Certeza GRADE: nao avaliada pelos autores"
- Speaker notes: "Os autores nao fizeram avaliacao GRADE" (line 40)

### Verification

**Confirmed.** The Valgimigli 2025 Lancet paper does NOT include a formal GRADE assessment. The field "GRADE" in the evidence-DB is marked "Nao explicito." Multiple web searches confirmed no GRADE table or SoF table is present in the publication.

### External GRADE Assessments Found

A Circulation 2025 abstract (Abstract 4339586: "Aspirin versus P2Y12 Inhibitors as Monotherapy for Secondary Prevention in Coronary Artery Disease") by a separate team DID perform a GRADE assessment on the ASA vs P2Y12 comparison. Their conclusion:

> "Evidence certainty ranged from **low to very low** due to imprecision, short follow-up durations, and methodological limitations."

This is highly relevant pedagogically: it confirms the slide's implicit message that the absence of GRADE is a meaningful gap, and that if GRADE were applied, the certainty would likely NOT be high.

### Contextual GRADE Gap Data

The evidence-DB (hook section) documents that only **33.8%** of SRs in top-10 journals assessed certainty of evidence (Siedler 2025, PMID 40969451). This contextualizes the Valgimigli omission as typical, not exceptional -- exactly the pedagogical point made in the speaker notes (line 42-43).

---

## 4. Evidence-DB vs Slide Cross-Reference

| Evidence-DB Field | Present in Slide? | Notes |
|--------------------|-------------------|-------|
| Autores | YES (source-tag) | Valgimigli et al. |
| Journal + Year | YES (source-tag) | Lancet 2025 |
| PMID | YES (source-tag) | 40902613 |
| Design (IPD-MA) | NO | Not mentioned in body; notes mention "7 RCTs" and "29 mil pacientes" |
| N = 28,982 | Partial | Notes say "29 mil" (rounded) |
| Follow-up median | NO | Not in slide or notes body |
| MACCE HR + CI + p | YES | Fully accurate |
| Bleeding HR + CI | YES | Fully accurate |
| GRADE status | YES | Correctly flagged as absent |
| PROSPERO | NO | Not relevant for this slide's scope |
| CYP2C19 finding | NO | Reserved for s-aplicabilidade (slide 15) |
| Giacoppo confirmatory MA | NO | Not in scope for this slide |
| NICE gap | YES (notes only) | Correctly placed as "[NICE gap -- para arguicao]" |

**Verdict:** All data presented in the slide body matches the evidence-DB and PubMed source exactly. No fabricated or unsourced data.

---

## 5. Pedagogical Depth Assessment

### Target Audience

Medical residents (clinica medica), basic-intermediate level. This is slide 14 of 18, the first "application" slide (Phase F3) after methodology was taught in F2.

### Strengths

1. **Assertion-evidence format.** The h2 is a genuine clinical assertion ("MACCE caiu 14%...mas certeza GRADE nao foi avaliada"), not a topic label. This follows best practice (Alley method).

2. **Benefit-harm framing.** The two-column compare layout directly teaches the benefit vs. harm framework -- a core EBM skill. This is structurally sound.

3. **The GRADE gap is the pedagogical punchline.** The slide deliberately withholds GRADE certainty (because the authors did) and uses this as a teaching moment: "Se nem os autores avaliaram, VOCES precisam se perguntar." This is excellent andragogy -- it creates cognitive tension and transfers responsibility to the learner.

4. **Speaker notes are rich.** Timing markers, [DATA] tags, verification date, NICE gap for argumentation -- all present and properly structured. The notes contain the full event counts (929 vs 1062) and rates (2.61 vs 2.99/100 pt-yr) that the slide intentionally omits for visual clarity.

5. **Correct statistical framing.** HR used (not RR), CI interpretation correct ("cruza 1"), NS interpretation correct. The notes explicitly translate "14% de reducao relativa."

### Weaknesses and Improvement Opportunities

#### W1. No absolute risk reduction or NNT (MODERATE)

The slide presents HR 0.86 (relative reduction) but no absolute numbers. For residents learning clinical decision-making, **ARR and NNT are more actionable than HR**. The evidence-DB has event rates (2.61 vs 2.99/100 pt-yr), from which:

- ARR = 0.38/100 patient-years
- Over 5.5 years: ~2.1% absolute reduction
- NNT (5.5 yr) ~ 48

This is not necessarily a flaw in the SLIDE (word count constraint, and NNT is explicitly not the focus of this slide), but the SPEAKER NOTES could include it for verbal delivery. The design-reference.md states "NNT > ARR > HR" as hierarchy, though the slide's purpose is to teach GRADE gap, not quantify benefit.

**Recommendation:** Add NNT to speaker notes as an optional verbal point. Do NOT add to slide body (would exceed 30-word constraint and shift focus from the GRADE teaching point).

#### W2. Time frame not explicit in slide body (MINOR)

The MACCE outcome is at 5.5 years, but this is only in the speaker notes, not the slide body. For a projected slide at 6m distance, a time qualifier matters for clinical interpretation of HR.

**Recommendation:** Consider adding "(5,5 anos)" after "MACCE" in the compare-desc. Minimal word cost.

#### W3. Follow-up median vs. outcome time frame ambiguity (MINOR)

The study has median follow-up of 2.3 years but reports MACCE at 5.5 years (Kaplan-Meier extrapolation with frailty models). This distinction is not addressed in the slide or notes. For a teaching audience, the gap between median follow-up (2.3 yr) and outcome reporting horizon (5.5 yr) deserves a brief note -- it teaches about censoring and extrapolation.

**Recommendation:** Add 1 sentence to speaker notes: "Follow-up mediano 2,3 anos, mas modelo estatistico extrapola ate 5,5 anos. Ponto de atencao: poucos pacientes com acompanhamento real tao longo."

#### W4. Bleeding definition not in slide body (MINOR)

"Sangramento maior" is vague. BARC 3-5 is the correct classification and appears only in notes. For residents who will encounter BARC in cardiology, naming the scale has pedagogical value.

**Recommendation:** Optional -- could add "(BARC 3-5)" in parentheses after "Sangramento maior" in the slide body.

#### W5. The h2 could be more assertive about the GRADE gap (STYLISTIC)

Current h2: "MACCE caiu 14% com clopidogrel, sem aumento de sangramento -- mas certeza GRADE nao foi avaliada"

This h2 does two things: states the result AND flags the GRADE gap. The assertion-evidence method works best with ONE claim per h2. The "mas" creates a compound assertion. However, this is a deliberate pedagogical choice (benefit-then-doubt), and splitting into two slides would lose the dramatic pivot.

**Recommendation:** No change needed. The compound structure serves the narrative arc.

#### W6. NICE TA210 context in notes only (INFORMATIONAL)

The notes include a NICE TA210 gap analysis for argumentation. This is well-placed -- it belongs in notes for verbal delivery, not on the slide. No change needed.

---

## 6. Evidence Quality Summary

| Dimension | Rating | Justification |
|-----------|--------|---------------|
| **PMID verification** | VERIFIED | PubMed MCP confirmed author, title, journal, volume, pages |
| **Data accuracy (MACCE)** | EXACT MATCH | HR, CI, p-value all match abstract |
| **Data accuracy (Bleeding)** | EXACT MATCH | HR, CI match abstract |
| **HR vs RR distinction** | CORRECT | IPD-MA uses HR, not RR. Rule E25 respected |
| **GRADE claim** | CORRECT | Authors did not perform GRADE. External assessment suggests low-very low certainty |
| **Source tag** | COMPLETE | Author, journal, year, PMID all present |
| **Evidence-DB sync** | FULL | All slide data traceable to evidence-DB entries |
| **Speaker notes quality** | HIGH | Timing, [DATA] tags, verification date, event counts, argumentation material |

---

## 7. If GRADE Were Applied (Evaluator's Assessment)

Since the Valgimigli authors omitted GRADE and this is the slide's teaching point, here is an informal assessment based on available data:

| Domain | Assessment | Rationale |
|--------|-----------|-----------|
| Risk of bias | Some concerns | 7 RCTs, open-label designs (HOST-EXAM, SMART-CHOICE). RoB not reported in abstract |
| Inconsistency | Low concern | IPD analysis with frailty models accounts for between-trial heterogeneity |
| Indirectness | Some concerns | Population: 78% male, mean age 66, mostly post-PCI. 4/7 trials from East Asia (Korea, Japan). Generalizability to non-PCI, non-Asian populations uncertain |
| Imprecision | Low for MACCE | CI 0.77-0.96 excludes 1.0, p=0.0082. ~2000 events. Adequate |
| Imprecision | High for bleeding | CI 0.74-1.21 crosses 1.0. Cannot exclude 21% increase |
| Publication bias | Some concerns | Funnel plot not reported in abstract. Relatively few trials (7) |

**Informal GRADE estimate:** MODERATE certainty for MACCE (downgraded for some RoB and indirectness). LOW certainty for bleeding safety (imprecision -- CI crosses null). This is consistent with the Circulation 2025 abstract that found "low to very low" certainty for the broader ASA vs P2Y12 comparison.

---

## 8. Overall Verdict

**The slide is clinically accurate, pedagogically sound, and evidence-aligned.** All numerical claims match the primary source exactly. The PMID is verified. The GRADE gap is correctly identified and used as a teaching tool. The HR/RR distinction is correct.

### Priority Improvements

| Priority | Item | Effort |
|----------|------|--------|
| P2 | Add NNT calculation to speaker notes | 1 line |
| P3 | Add "(5,5 anos)" time qualifier to MACCE in slide body | 2 words |
| P3 | Add follow-up vs. extrapolation note to speaker notes | 1 sentence |
| P4 | Optional: add "(BARC 3-5)" to bleeding label | 4 characters |

No P1 (critical) issues found.

---

## Sources

- PubMed: [PMID 40902613](https://doi.org/10.1016/S0140-6736(25)01562-4) -- Valgimigli M et al. Lancet 2025;406(10508):1091-1102
- [PubMed entry](https://pubmed.ncbi.nlm.nih.gov/40902613/)
- [ACC Journal Scan](https://www.acc.org/latest-in-cardiology/journal-scans/2025/09/19/16/45/clopidogrel-superior-to-aspirin)
- [The Lancet abstract](https://www.thelancet.com/journals/lancet/article/PIIS0140-6736(25)01562-4/abstract)
- Consensus: [Valgimigli 2025](https://consensus.app/papers/details/3afc782244ce556e929da16c034a3246/?utm_source=claude_desktop) (5 citations)
- Circulation 2025 Abstract 4339586: ASP vs P2Y12 with GRADE assessment (low to very low certainty)
- Evidence-DB v5.7: `content/aulas/metanalise/references/evidence-db.md`

---

Coautoria: Lucas + Claude Opus 4.6
Verificacao: PubMed MCP + WebSearch + Consensus
