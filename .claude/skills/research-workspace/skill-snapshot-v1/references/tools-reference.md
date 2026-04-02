# Research Tools Reference

Static tables loaded on demand by the orchestrator or MBE evaluator.

## Reporting Guidelines (EQUATOR Network)

| Guideline | Use | Items | URL |
|-----------|-----|-------|-----|
| CONSORT | RCTs | 25 | consort-statement.org |
| STROBE | Observational (cohort, case-control, cross-sectional) | 22 | strobe-statement.org |
| PRISMA | Systematic reviews and meta-analyses (2020 update) | 27 | prisma-statement.org |
| MOOSE | Meta-analysis of observational studies | — | equator-network.org |
| SPIRIT | Clinical trial protocol | — | spirit-statement.org |
| STARD | Diagnostic accuracy | — | equator-network.org |
| ARRIVE | Animal research | — | arriveguidelines.org |
| CARE | Case reports | — | care-statement.org |
| CHEERS | Health economic evaluations (2022 update) | — | equator-network.org |
| TRIPOD | Prediction/diagnostic models | — | tripod-statement.org |

Portal: equator-network.org (500+ guidelines). Selector: goodreports.org

## Quality Assessment / Risk of Bias Tools

| Tool | Use | Time | Reference |
|------|-----|------|-----------|
| Cochrane RoB 2 | Risk of bias in RCTs (5 domains) | 1-2h | methods.cochrane.org |
| ROBINS-I | Non-randomized (interventions) | 3-7h | methods.cochrane.org |
| ROBINS-E | Non-randomized (exposures) | 3-7h | riskofbias.info |
| QUADAS-2 | Diagnostic accuracy (4 domains) | 1-2h | quadas.org |
| QUADAS-3 | Updated QUADAS-2 | 1-2h | quadas.org |
| Newcastle-Ottawa | Non-randomized (faster than ROBINS) | 30min | ohri.ca |
| Jadad Scale | RCT quality (score 0-5, 3 items) | 15min | Oxford |
| PEDro Scale | Physiotherapy/rehab RCTs | 15min | pedro.org.au |
| AMSTAR-2 | Systematic review quality (16 items) | 30min | amstar.ca |
| AGREE II | Clinical guideline quality (23 items) | 1h | agreetrust.org |

## Tier-1 Sources — Hepatology (project default)

| Source | Type | ID |
|--------|------|----|
| BAVENO VII | Portal HT Consensus | DOI:10.1016/j.jhep.2021.12.012 |
| EASL Cirrhosis 2024 | CPG | DOI: TBD |
| AASLD Varices 2024 | Practice Guidance | DOI: TBD |
| PREDESCI | RCT | PMID:30910320 |
| CONFIRM | RCT | PMID:33657294 |
| ANSWER | RCT | PMID:29861076 |
| D'Amico 2006 | Systematic review | PMID:16298014 |

## PMID Verification Status Vocabulary

| Status | Meaning | Use |
|--------|---------|-----|
| VERIFIED | PubMed MCP confirmed (author + title + n match) | Gold standard |
| WEB-VERIFIED | PubMed web confirmed (MCP unavailable) | Acceptable |
| CANDIDATE | Not verified — LLM-generated | NEVER in final output |
| SECONDARY | Confirmed by 2+ independent sources | Additional confidence |
| UNRESOLVED | Sources disagree — flagged for human | Requires Lucas decision |
| INVALID | PMID 404 or wrong article | Remove from report |

## Brazilian Medical Societies

| Society | Abbreviation | Field |
|---------|-------------|-------|
| Sociedade Brasileira de Hepatologia | SBH | Hepatology |
| Sociedade Brasileira de Cardiologia | SBC | Cardiology |
| Sociedade Brasileira de Endocrinologia | SBEM | Endocrinology |
| Sociedade Brasileira de Gastroenterologia | SBAD/FBG | Gastroenterology |
| CONITEC | — | HTA / PCDT protocols |
| Ministerio da Saude | MS | National guidelines |
