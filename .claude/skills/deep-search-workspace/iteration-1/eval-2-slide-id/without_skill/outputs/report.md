# Deep Search Report: s-rs-vs-ma (Slide 04-rs-vs-ma.html)

> Baseline test (no skill). Gemini deep-research MCP.
> Date: 2026-04-02 | Duration: 5m 29s
> Research ID: `v1_ChdBSkhPYWVDVk1lN3J6N0lQMHE2b21RaxIXQUpIT2FlQ1ZNZTdyejdJUDBxNm9tUWs`

---

## Slide Context

- **Slide ID:** `s-rs-vs-ma`
- **Position:** Phase 2 (Methodology), first concept slide
- **h2 assertion:** "RS e o metodo de busca e selecao; MA e o calculo estatistico — e sao separaveis"
- **Current state:** Skeleton HTML with compare layout (RS vs MA), brief descriptions, footer sentence, speaker notes with timing
- **Source cited:** Cochrane Handbook v6.5, cap. 1
- **Timing:** 60s

---

## Research Results (Gemini Deep Research)

### 1. Definitions — Authoritative Sources

**Cochrane Handbook v6.5, Chapter 1:**
- **Systematic Review:** "Systematic reviews seek to collate evidence that fits pre-specified eligibility criteria in order to answer a specific research question. They aim to minimize bias by using explicit, systematic methods documented in advance with a protocol."
- **Meta-Analysis:** "The use of statistical techniques in a systematic review to integrate the results of included studies." (Cochrane Glossary). Chapter 10 describes it as typically a two-stage process: (1) calculate summary statistic per study, (2) calculate weighted average across studies.

**PRISMA 2020 (Box 1 Glossary):**
- **Systematic Review:** "A review that uses explicit, systematic methods to collate and synthesize findings of studies that address a clearly formulated question."
- **Meta-Analysis of Effect Estimates:** "A statistical technique used to synthesize results when study effect estimates and their variances are available, yielding a quantitative summary of results."

**JAMA Users' Guides (Murad et al. 2014, DOI: 10.1001/jama.2014.5559):**
- "A systematic review is a research summary that addresses a focused clinical question in a structured, reproducible manner. It is often, but not always, accompanied by a meta-analysis, which is a statistical pooling or aggregation of results from different studies providing a single estimate of effect."

### 2. Relationship — "Not Every SR Includes a MA"

**Epistemological reasoning:**
- The primary threat is **selection bias** — cherry-picking studies. SR combats this with exhaustive search. MA is mathematically agnostic to data origin — software will produce a diamond regardless of whether inputs represent totality of evidence or a biased subset.
- Cochrane Handbook Ch. 10 warning (*Do not start here!*): "The production of a diamond at the bottom of a plot is an exciting moment... but results of meta-analyses can be very misleading if suitable attention has not been given to formulating the review question; specifying eligibility criteria; identifying and selecting studies..."

**Epidemiological data — how often do SRs include MA:**

| Source | Sample | % with MA |
|--------|--------|-----------|
| Page et al. 2016 (PLOS Med, DOI: 10.1371/journal.pmed.1002028) | 300 SRs from MEDLINE Feb 2014 | **63%** |
| Annals of Surgery bibliometric 2022 | 186 SRs (2011-2020) | **70.4%** |
| Page et al. 2022 (BMJ) | 300 SRs from 2020 | Majority, trend sustained |

**Conclusion:** ~30-37% of published SRs validly decline to pool data.

### 3. When MA is Not Possible or Appropriate

Cochrane Handbook Ch. 12 (McKenzie & Brennan) — recognized reasons:

1. **Too much clinical/methodological diversity** — populations, interventions, comparators differ drastically
2. **Excessive statistical heterogeneity** — high I-squared, Q test, tau-squared
3. **Incompletely reported outcomes** — no CIs, SDs, or only P-values/direction
4. **Different effect measures** — HRs mixed with ORs mixed with mean differences, non-transformable
5. **Universal high risk of bias** — pooling compounds bias into precise but inaccurate estimate
6. **Too few studies** — 0-2 studies, false sense of precision

**Alternatives:** Narrative synthesis (SWiM guidelines), structured tables, harvest plots, albatross plots.

### 4. Common Conflation Error

- **Cochrane Glossary** explicitly flags: meta-analysis is "Sometimes misused as a synonym for systematic reviews."
- **Historical campaign:** Chalmers & Altman (1995, book *Systematic Reviews*) deliberately separated the terms. Zoccali (2016, Nephrol Dial Transplant) documented this.
- **Ioannidis 2016** (DOI: 10.1111/1468-0009.12210): "The Mass Production of Redundant, Misleading, and Conflicted Systematic Reviews and Meta-analyses" — estimates only 3% of published MAs are truly informative. "Meta-analysis" used as prestige/marketing label.
- **Clinical takeaway:** Seeing "meta-analysis" in a title does NOT guarantee a systematic review was conducted. Without SR rigor, MA is a precise synthesis of biased data.

### 5. Historical Context

| Event | Year | Key Figure |
|-------|------|------------|
| First informal pooling of studies | 1904 | Karl Pearson (typhoid vaccine, 11 studies) |
| Combining P-values across experiments | 1930s | Ronald Fisher (ANOVA, agricultural) |
| Term "meta-analysis" coined | **1976** | **Gene V. Glass** (presidential address, AERA) |
| | | Definition: "statistical analysis of a large collection of analysis results from individual studies for the purpose of integrating the findings" |
| | | Application: 375 psychotherapy studies, challenged Eysenck |
| Archie Cochrane's plea | **1979** | "It is surely a great criticism of our profession that we have not organised a critical summary... of all relevant randomised controlled trials" |
| Effective Care in Pregnancy and Childbirth DB | 1989 | Iain Chalmers |
| **Cochrane Collaboration founded** | **1993** | Oxford, UK Cochrane Centre |
| Formal separation of terms | 1995 | Chalmers & Altman (*Systematic Reviews* book) |

### 6. "SR = Process, MA = Statistical Step" — Nuances

The framing is broadly accurate but has 3 important nuances:

1. **MA can exist outside SR:** Two investigators pooling their own trials, or an author arbitrarily selecting 5 studies — both are mechanically MAs but lack SR rigor. The latter is considered highly flawed (catastrophic selection bias).

2. **SR involves synthesis beyond math:** PRISMA 2020 recognizes qualitative synthesis, thematic synthesis, narrative synthesis as legitimate SR outputs. RoB assessment, GRADE evaluation, structured summaries are complex synthesis even without pooling.

3. **Not all quantitative synthesis = MA:** Cochrane Handbook identifies methods like combining P-values, vote counting by direction of effect, calculating range of observed effects — these are quantitative but NOT meta-analysis of effect estimates.

**For residents:**
- When reading a **SR**: ask "Did they identify ALL evidence and assess risk of bias?" (credibility of process)
- When reading a **MA**: ask "Were studies similar enough to justify combining into one number?" (confidence in pooled estimate)
- A brilliant MA cannot salvage a flawed SR. An excellent SR may rightfully conclude MA is impossible.

---

## Key References for Slide

| Reference | Type | Function | Citation |
|-----------|------|----------|----------|
| Cochrane Handbook v6.5, Ch. 1 | Handbook | SR vs MA definitions | Already cited on slide |
| Cochrane Handbook v6.5, Ch. 10 | Handbook | MA methodology, "Do not start here!" warning | Speaker notes |
| Cochrane Handbook v6.5, Ch. 12 | Handbook | When NOT to pool | Speaker notes |
| PRISMA 2020 (Page et al. BMJ 2021) | Statement | Definitions, glossary | Already in evidence-db |
| Murad et al. 2014, JAMA | Users' Guide | SR vs MA for clinicians | DOI: 10.1001/jama.2014.5559 |
| Page et al. 2016, PLOS Med | Bibliometric | 63% of SRs include MA | DOI: 10.1371/journal.pmed.1002028 |
| Glass 1976 | Seminal | Coined "meta-analysis" | AERA presidential address |
| Ioannidis 2016 | Critique | Mass production, only 3% truly informative | DOI: 10.1111/1468-0009.12210 |

---

## Slide Content Assessment

### What the slide already has (correct):
- h2 is a proper assertion (not a label)
- RS/MA separation is accurate
- "Nem toda RS tem MA. Toda MA vem de uma RS." is the correct axiom
- Source (Cochrane Handbook v6.5, cap. 1) is appropriate
- Speaker notes have good timing and clear narrative arc

### What could strengthen the slide content:
1. **RS column description** could be more specific: the current "Protocolo, busca, selecao, extracao, avaliacao de vies" is actually excellent — it names the 5 steps of the SR process
2. **MA column description** could add "estimativa ponderada" (weighted estimate) — currently says "estimativa ponderada" which is correct
3. **Speaker notes** could incorporate the "63% of SRs include MA" data point (Page et al. 2016) to ground the "nem toda RS tem MA" claim with a number
4. **Speaker notes** could reference the Cochrane Ch. 10 "Do not start here!" warning as a memorable anchor
5. The **footer** "Nem toda RS tem MA. Toda MA vem de uma RS." is the single most important takeaway — correctly placed as a compare-footer

### Verification status of existing content:
- Cochrane Handbook v6.5, cap. 1 definitions: **CONFIRMED** by Gemini deep research against source
- "Nem toda RS tem MA. Toda MA vem de uma RS.": **CONFIRMED** — standard axiom per Cochrane, PRISMA, JAMA Users' Guides
- Note: "Toda MA vem de uma RS" is slightly normative (prescriptive, not descriptive) — MAs CAN exist without SRs, but SHOULDN'T in EBM. The slide's speaker notes already handle this nuance at [0:40-0:60].

---

## Raw Output Location

Full Gemini JSON: `C:\Users\lucas\AppData\Roaming\gemini-mcp\output\895e0fe124d103c5\deep-research-2026-04-02T15-59-08-005Z.json`

---

Coautoria: Lucas + Opus 4.6 (orchestrator) + Gemini 3.1 (deep-research)
