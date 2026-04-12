# Evidence Harvest S112 — Cowork Pipeline Test
# Aula: Metanálise | Data: 2026-04-08
# Coautoria: Lucas + Opus 4.6 (Cowork)
# Fonte: PubMed MCP + SCite MCP (search_literature)

## Resumo

Pipeline testado end-to-end via Cowork. MCPs funcionais: PubMed, SCite/search_literature, Notion.
14 slides sem evidence HTML identificados. Papers-chave encontrados para os de alta prioridade.

---

## Papers Encontrados por Slide

### s-heterogeneity (ALTA PRIORIDADE)
Slide sobre I², tau², Q e heterogeneidade em meta-análise.

| # | Autores | Título | PMID | DOI | Ano | Status |
|---|---------|--------|------|-----|-----|--------|
| 1 | **Borenstein M** | Avoiding common mistakes in meta-analysis: Understanding the distinct roles of Q, I-squared, tau-squared, and the prediction interval | 37940120 | [10.1002/jrsm.1678](https://doi.org/10.1002/jrsm.1678) | 2023 | **WEB-VERIFIED** |
| 2 | **Borenstein M** | How to understand and report heterogeneity in a meta-analysis: The difference between I-squared and prediction intervals | 38938910 | [10.1016/j.imr.2023.101014](https://doi.org/10.1016/j.imr.2023.101014) | 2023 | **WEB-VERIFIED** |
| 3 | Migliavaca CB et al. | Meta-analysis of prevalence: I statistic and how to deal with heterogeneity | 35088937 | [10.1002/jrsm.1547](https://doi.org/10.1002/jrsm.1547) | 2022 | **WEB-VERIFIED** |

**Key finding (Borenstein 2023):** I² NÃO mede quanta variação existe — apenas que proporção da variação observada é real. O prediction interval é a estatística correta para quantificar dispersão dos efeitos. Classificações "low/moderate/high" baseadas em I² são uninformativas.

### s-grade (ALTA PRIORIDADE)
Slide sobre o framework GRADE para certeza de evidência.

| # | Autores | Título | PMID | DOI | Ano | Status |
|---|---------|--------|------|-----|-----|--------|
| 1 | **Schünemann HJ** et al. | GRADE guidance 35: update on rating imprecision for assessing contextualized certainty of evidence | 35934266 | [10.1016/j.jclinepi.2022.07.015](https://doi.org/10.1016/j.jclinepi.2022.07.015) | 2022 | **WEB-VERIFIED** |
| 2 | **Guyatt G** et al. | GRADE guidance 36: updates to GRADE's approach to addressing inconsistency | 36898507 | [10.1016/j.jclinepi.2023.03.003](https://doi.org/10.1016/j.jclinepi.2023.03.003) | 2023 | **WEB-VERIFIED** |
| 3 | Hultcrantz M et al. | The GRADE Working Group clarifies the construct of certainty of evidence | 28529184 | [10.1016/j.jclinepi.2017.05.006](https://doi.org/10.1016/j.jclinepi.2017.05.006) | 2017 | **WEB-VERIFIED** |

**Key finding (Hultcrantz 2017):** Certeza de evidência = certeza de que o efeito verdadeiro está de um lado de um threshold específico OU dentro de um range escolhido. Abordagem "fully contextualized" requer considerar todos os outcomes críticos simultaneamente.

### s-abstract (MÉDIA PRIORIDADE)
Slide sobre screening de abstracts com PRISMA 2020.

| # | Autores | Título | PMID | DOI | Ano | Status |
|---|---------|--------|------|-----|-----|--------|
| 1 | **Page MJ** et al. | The PRISMA 2020 statement: an updated guideline for reporting systematic reviews | 33782057 | [10.1136/bmj.n71](https://doi.org/10.1136/bmj.n71) | 2021 | **WEB-VERIFIED** |

### s-forest-plot (ALTA PRIORIDADE)
Slide sobre anatomia do forest plot.

Papers da busca PubMed (PMIDs 37573151, 35851070, 41940896) são MAs que USAM forest plots mas não ENSINAM sobre eles. Para este slide, os papers de Borenstein (37940120, 38938910) são mais úteis pois explicam como interpretar forest plots no contexto de heterogeneidade.

### s-ancora + s-aplicacao + s-aplicabilidade + s-absoluto (ALTA PRIORIDADE)
Papers F3 — aplicação do Valgimigli 2025.

| # | Autores | Título | PMID | DOI | Ano | Status |
|---|---------|--------|------|-----|-----|--------|
| 1 | **Valgimigli M** et al. | Clopidogrel versus aspirin for secondary prevention of CAD: SR and IPD-MA | 40902613 | [10.1016/S0140-6736(25)01562-4](https://doi.org/10.1016/S0140-6736(25)01562-4) | 2025 | **WEB-VERIFIED** |

**Key data:** 7 RCTs, 28.982 pacientes, mediana follow-up 2.3 anos. MACCE: HR 0.86 (95% CI 0.77-0.96, p=0.0082). Major bleeding: HR 0.94 (0.74-1.21, p=0.64). Clopidogrel > aspirina para prevenção secundária de DAC.

### s-fixed-random (MÉDIA PRIORIDADE)
Fixed vs random effects.

Papers relevantes encontrados via PubMed (PMIDs 34128998, 29046404). O paper de migraine (JAMA 2021, 34128998) usa DerSimonian-Laird random-effects com Hartung-Knapp-Sidik-Jonkman correction — bom exemplo didático. O paper de cranberry UTI (29046404) mostra decisão explícita entre fixed e random baseada em I².

### ~~s-benefit-harm~~ (REMOVIDO S162)

---

## PMIDs Consolidados (todos WEB-VERIFIED via PubMed MCP)

```
37940120  Borenstein 2023 — Q/I²/tau²/prediction interval (Res Synth Methods)
38938910  Borenstein 2023 — I² vs prediction intervals (Integr Med Res)
35088937  Migliavaca 2022 — I² in prevalence MAs (Res Synth Methods)
35934266  Schünemann 2022 — GRADE guidance 35 imprecision (J Clin Epidemiol)
36898507  Guyatt 2023 — GRADE guidance 36 inconsistency (J Clin Epidemiol)
28529184  Hultcrantz 2017 — GRADE certainty construct (J Clin Epidemiol)
33782057  Page 2021 — PRISMA 2020 statement (BMJ)
40902613  Valgimigli 2025 — Clopidogrel vs aspirin IPD-MA (Lancet)
34128998  VanderPluym 2021 — Migraine acute treatments MA (JAMA)
29046404  Fu 2017 — Cranberry UTI MA (J Nutr)
```

## Gaps Restantes (precisam busca adicional)

- **s-contrato:** Framework das 3 perguntas para ler MA — precisa de fonte original
- **s-checkpoint-1:** ACCORD trial trap + Ray 2009 MA — PMIDs conhecidos, verificar
- **s-checkpoint-2:** Cenário construído — não precisa de evidence HTML per se
- **s-absoluto:** NNT/ARR/efeitos absolutos — GRADE guidance 35 cobre parcialmente; buscar Guyatt summary of findings table

## URLs para NotebookLM (PubMed)

```
https://pubmed.ncbi.nlm.nih.gov/37940120/
https://pubmed.ncbi.nlm.nih.gov/38938910/
https://pubmed.ncbi.nlm.nih.gov/35088937/
https://pubmed.ncbi.nlm.nih.gov/35934266/
https://pubmed.ncbi.nlm.nih.gov/36898507/
https://pubmed.ncbi.nlm.nih.gov/28529184/
https://pubmed.ncbi.nlm.nih.gov/33782057/
https://pubmed.ncbi.nlm.nih.gov/40902613/
```

---
Coautoria: Lucas + Opus 4.6 (Cowork) | S112 2026-04-08
