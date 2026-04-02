# Evaluation Report: Slide s-rs-vs-ma (04-rs-vs-ma.html)

> Baseline run (without skill). Evaluator: Claude Opus 4.6.
> Date: 2026-04-02

---

## 1. Slide Overview

| Field | Value |
|-------|-------|
| ID | `s-rs-vs-ma` |
| File | `content/aulas/metanalise/slides/04-rs-vs-ma.html` |
| Phase | F2 (Methodology) — first slide of the methodology phase |
| Archetype | compare (concept-evidence sub-variant) |
| Narrative role | Setup — desfazer a confusao mais comum antes de ensinar conceitos |
| Timing | 60 seconds |
| QA state | LINT-PASS (scorecard 14-dim pendente) |
| Evidence source | Cochrane Handbook v6.5, cap. 1 |

### h2 Assertion

> "RS e o metodo de busca e selecao; MA e o calculo estatistico — e sao separaveis"

### Visual Structure

Two-column compare layout (`.compare-layout` with two `.compare-col` children), plus a footer statement. Stagger animation on the compare columns. Source tag at the bottom.

---

## 2. Evidence Quality Assessment

### 2.1 Reference Verification

**Source cited:** Cochrane Handbook v6.5, cap. 1

**Verification result:** VERIFIED (via web search against cochrane.org)

- The Cochrane Handbook for Systematic Reviews of Interventions is a Tier 1 methodological reference.
- Version 6.5 was released in August 2024. The current version is 6.5.1 (2025). The slide cites v6.5 -- this is acceptable since the definitions in Chapter 1 have been stable across versions. However, updating to "v6.5.1" or simply "v6, current" would be more future-proof.
- Chapter 1 ("Starting a review") indeed defines systematic reviews as the process (protocol, search, selection, bias assessment) and meta-analysis as the optional statistical combination of results. The slide's content accurately reflects these definitions.
- No PMID or DOI applies -- the Cochrane Handbook is a living online resource (not a journal article). The reference format "Cochrane Handbook v6.5, cap. 1" is appropriate.

**Rating: 5/5** -- Correct source, verified, Tier 1.

### 2.2 Factual Accuracy of Claims

| Claim in slide | Accurate? | Notes |
|----------------|-----------|-------|
| RS = protocolo, busca, selecao, extracao, avaliacao de vies | YES | Cochrane Handbook Chapter 1 defines SR as involving a priori specification, systematic search, eligibility criteria, risk of bias assessment |
| MA = combina resultados em estimativa ponderada | YES | Cochrane Handbook and Chapter 10 define MA as "statistical combination of results from two or more separate studies" |
| "Nem toda RS tem MA" | YES | Approximately 32% of health-related SRs do not perform MA (SWiM guideline, Campbell 2020, PMID 31948937). Cochrane Handbook explicitly states MA is an optional component |
| "Toda MA vem de uma RS" | PARTIALLY | This is the standard teaching framing and is correct in the normative sense (a well-conducted MA should be embedded in a SR). However, some published MAs exist without full SR methodology (e.g., older or poorly conducted studies). As a pedagogical simplification for residents, this is acceptable, but the speaker notes should acknowledge the nuance |
| RS and MA are "separaveis" | YES | Core Cochrane concept. SWiM guidelines (2020) specifically address reporting synthesis without meta-analysis |

**Rating: 4/5** -- All claims accurate. One simplification ("toda MA vem de uma RS") is pedagogically defensible but not absolute in practice.

### 2.3 Speaker Notes Quality

The speaker notes follow the required format with timing blocks:

- `[0:00-0:20]` -- Hook + disambiguation
- `[0:20-0:40]` -- RS definition expansion
- `[0:40-0:60]` -- MA definition + "nem toda RS tem MA" expansion
- `[DATA]` tag with source and verification date present

**Strengths:**
- Clear 3-beat structure within 60 seconds
- "A confusao mais comum que preciso resolver primeiro" is a good rhetorical opening
- PAUSA marker after the key distinction
- Concrete examples of when to use each term ("a meta-analise mostrou" vs "a revisao sistematica incluiu")

**Weaknesses:**
- The navigation note says "avancar para slide 04 (PICO)" -- this is a legacy numbering reference. The slide IS 04 already (04-rs-vs-ma). The next slide is 05 (04-pico.html, but functionally slide 05 in the deck). Minor inconsistency.
- No mention of SWiM or concrete examples of RS-without-MA. A brief note like "Ex: Cochrane SR com estudos heterogeneos demais para pooling" would reinforce the concept.
- No "risco cognitivo" callout in notes, though the blueprint identifies it as "tratar RS e MA como sinonimos → perda da estrutura logica"

**Rating: 3.5/5** -- Functional but thin. The notes serve the 60-second constraint but miss opportunities to deepen the teacher's framing.

---

## 3. Depth Assessment

### 3.1 Content Depth vs. Audience Level

The slide targets residents at basic-intermediate level. For this audience, the slide is:

**Appropriate in scope:** The RS vs MA distinction is foundational. Residents frequently conflate the terms. The slide addresses this cleanly.

**Appropriate in density:** Body content is ~25 words (well under the 30-word constraint). Two columns + footer is a clean cognitive load.

**Missing depth layers (potential improvements for notes):**

1. **Concrete example of RS without MA:** The Cochrane Handbook itself contains SRs that present narrative synthesis without pooling. A one-line example would make the concept tangible.

2. **Connection to the ACCORD trap (slide 03):** The previous slide just showed that "the diamond said benefit, but the biggest piece pointed the other way." This slide could bridge: "the RS is what tells you WHICH studies went in. The MA is just the diamond. Without the RS process, you cannot evaluate the diamond." The speaker notes do not make this connection explicit.

3. **Why separability matters clinically:** The slide states they are separable but does not explain WHY a resident should care. The clinical implication is: "you can trust the SR process but reject the MA result (too heterogeneous), or critique the SR process while noting the MA result." This is never stated.

4. **The "umbrella" problem:** Many residents encounter umbrella reviews, overviews of reviews, and network meta-analyses. A brief aside in the notes acknowledging these exist but are out of scope would set boundaries.

### 3.2 Pedagogical Positioning

Per `narrative.md`, this slide opens Phase 2 (Methodology) after the ACCORD trap checkpoint. Its function is "desfazer a confusao mais comum."

**Narrative flow assessment:**

- **From slide 03 (checkpoint-1):** The ACCORD trap created tension -- "the diamond can lie." This slide should capitalize on that tension by framing RS as the process that reveals WHAT went into the diamond. It does not make this connection.
- **To slide 05 (PICO):** The next slide introduces PICO as the "porta de entrada." The bridge should be: "the RS process starts with PICO." The footer ("Nem toda RS tem MA. Toda MA vem de uma RS.") is a good transition statement, but the speaker notes navigate to "slide 04 (PICO)" rather than making the conceptual bridge.

**Rating: 3/5** -- The slide works in isolation but underexploits its position in the narrative arc. The ACCORD → RS/MA → PICO chain has a gap.

---

## 4. Technical/Structural Assessment

### 4.1 HTML Compliance

| Check | Pass? | Notes |
|-------|-------|-------|
| h2 is clinical assertion | YES | Strong assertion with "separaveis" as key word |
| No ul/ol in slide | YES | Uses div-based compare layout |
| aside.notes present | YES | With timing and DATA tag |
| No inline style on section | YES | Clean |
| data-animate present | YES | `data-animate="stagger"` on compare-layout |
| source-tag present | YES | "Cochrane Handbook v6.5, cap. 1" |

### 4.2 CSS

- Styling is handled by shared `.compare-*` classes in `metanalise.css` (lines 242-285).
- No `#s-rs-vs-ma`-specific CSS exists -- the slide relies entirely on shared compare layout classes.
- Background: light (stage-c creme), consistent with archetype constraints.
- Colors use design tokens (`--bg-navy-mid`, `--ui-accent-on-dark`, `--text-secondary`, `--text-primary`).

### 4.3 Manifest Alignment

The `_manifest.js` entry matches:
- `archetype: 'compare'` -- correct
- `timing: 60` -- matches HTML `data-timing="60"`
- `clickReveals: 0` -- correct (no click-reveal)
- `narrativeRole: 'setup'` -- correct
- `tensionLevel: 1` -- appropriate for a definitional slide
- `narrativeCritical: false` -- debatable; the RS/MA distinction is foundational, but not where the "aha" moment lives

---

## 5. Gaps and Recommendations

### 5.1 Evidence Gaps

| Gap | Severity | Recommendation |
|-----|----------|----------------|
| Cochrane Handbook version could be updated to 6.5.1 | LOW | Update source-tag and notes to "v6.5.1 (2025)" or use versionless "Cochrane Handbook, current, cap. 1" |
| No DOI/URL for Cochrane Handbook | LOW | Add URL in speaker notes: `https://training.cochrane.org/handbook/current/chapter-01` |
| "Toda MA vem de uma RS" is a pedagogical simplification | LOW | Add nuance in speaker notes: "Em rigor, MAs mal feitas existem sem RS formal — mas o padrao Cochrane exige RS" |

### 5.2 Content Depth Gaps

| Gap | Severity | Recommendation |
|-----|----------|----------------|
| No concrete example of RS without MA | MEDIUM | Add in notes: "Ex: SR de estudos qualitativos, ou quando I2 e tao alto que pooling seria enganoso" |
| No bridge from ACCORD trap | MEDIUM | Add in notes [0:00-0:20]: "No slide anterior, o diamante disse beneficio mas escondia um trial que aumentou mortalidade. A RS e o que te permite ABRIR o diamante." |
| No "why separability matters" for the resident | MEDIUM | Add in notes [0:40-0:60]: "Voce pode confiar no processo de busca (RS) mas rejeitar o calculo (MA) — por exemplo, quando a heterogeneidade e alta demais" |
| Navigation note has legacy numbering | LOW | Fix "avancar para slide 04 (PICO)" to "avancar para slide 05 (PICO)" or remove numbering |

### 5.3 Missing Cross-References in evidence-db

The evidence-db lists the Cochrane Handbook chapters (cap. 1, 10, 14, 15) in a table but does not provide:
- Full bibliographic citation (Higgins JPT, Thomas J, Chandler J, et al., eds. Cochrane Handbook for Systematic Reviews of Interventions version 6.5.1. Cochrane, 2025.)
- DOI for the Handbook itself (10.1002/9781119536604)
- The SWiM guideline (Campbell et al. BMJ 2020;368:l6890, PMID 31948937) as a supporting reference for the "nem toda RS tem MA" claim

---

## 6. Overall Scores

| Dimension | Score | Notes |
|-----------|-------|-------|
| Factual accuracy | 4/5 | All claims correct; one pedagogical simplification noted |
| Source quality | 5/5 | Tier 1 (Cochrane Handbook), verified |
| Content depth | 3/5 | Accurate but shallow -- misses narrative bridges and clinical "why" |
| Speaker notes | 3.5/5 | Functional, good timing, but thin on framing and bridging |
| Narrative positioning | 3/5 | Underexploits ACCORD → RS/MA → PICO chain |
| Technical compliance | 5/5 | Clean HTML, proper archetype, tokens, animations |
| **Overall** | **3.75/5** | Solid foundation, needs depth in notes and narrative bridging |

---

## 7. Summary

The slide `s-rs-vs-ma` is technically clean, factually accurate, and correctly sourced from a Tier 1 reference (Cochrane Handbook v6.5, Chapter 1). The assertion-evidence structure is strong -- the h2 communicates the core concept, and the two-column compare layout is cognitively efficient.

The main weakness is **depth**: the slide (and especially the speaker notes) treats the RS/MA distinction as a standalone fact rather than leveraging its position in the narrative arc. Coming immediately after the ACCORD trap, this is a missed opportunity to connect "the diamond lied" to "the RS process is HOW you detect that." The "why should I care" layer for the resident is absent.

The factual claim "toda MA vem de uma RS" is a standard teaching simplification that holds normatively but not descriptively. The notes should acknowledge this.

No incorrect data. No fabricated references. No verification failures. The slide is safe to present as-is but would benefit from richer speaker notes before the 14-dim scorecard QA.
