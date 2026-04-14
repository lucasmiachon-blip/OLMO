---
name: evidence-audit
disable-model-invocation: true
description: "V2 verification of 1 evidence HTML: extracts PMIDs, checks numerical claims against NCBI abstracts, flags data fabrication and missing references."
version: 1.0.0
context: fork
agent: general-purpose
allowed-tools: Read, Grep, Glob, Bash
argument-hint: "[evidence-file-path]"
---

# Evidence Audit — V2 Verification Pipeline

## ENFORCEMENT

1. **1 evidence HTML per invocation.** NUNCA batch.
2. **Read the file FIRST.** Extrair PMIDs e claims antes de qualquer API call.
3. **NCBI E-utilities only.** Sem MCP, sem WebSearch, sem Gemini. curl + esummary.fcgi + efetch.fcgi.
4. **Report, don't fix.** Retornar achados. Correcoes = decisao do Lucas/orchestrador.
5. **Numeros contra abstract.** Todo percentual, NNT, OR, RR, effect size citado no HTML deve ser comparado com o abstract real.

Auditar: `$ARGUMENTS`

## Step 1 — Parse + Extract

1. Read the evidence HTML file completely
2. Extract ALL PMIDs (pattern: PMID \d+ or pubmed.ncbi.nlm.nih.gov/\d+)
3. Extract ALL DOI-only refs (pattern: DOI:? 10.\S+)
4. Extract ALL numerical claims with their attributed source
5. Extract ALL inline citations (Author Year pattern) from prose text
6. Extract ALL entries from the formal references section
7. Compare: inline citations vs formal references → list MISSING refs

## Step 2 — V1 Identity Check (batch)

Batch all PMIDs in a single NCBI esummary call:

    curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=pubmed&id=PMID1,PMID2,...&retmode=json"

For each PMID verify: author, journal, year (±1), title topic. Report V1 PASS/FAIL.

## Step 3 — V2 Claim Check (per paper with numerical claims)

    curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=PMID&rettype=abstract&retmode=text"

Compare each numerical claim against abstract: exact=V2 PASS, close but different=V2 SUSPECT, not in abstract=V2 INCONCLUSIVE.

## Step 4 — Missing References Check

Compare inline citations vs formal refs. MISSING REF = cited in text but not in refs section. Attempt PMID discovery via esearch.

## Step 5 — Report

Return structured markdown: Summary, V1 Results table, V2 Results table, Missing References table, Recommendations.

## Constraints

- No edits. Report only. Fixes = orchestrator decision.
- NCBI rate limit: 0.5s delay between efetch calls if >5 papers.
- Abstract-only limitation: V2 checks abstract only. Flag claims needing V3 (full-text).
- No training-data synthesis. Only abstract text counts.
