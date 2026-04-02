# Research Report — Slide `s-rs-vs-ma`

> Aula: metanalise | Slide: `04-rs-vs-ma.html`
> Data: 2026-04-02
> Pipeline: /research (4 pernas executadas, Perna 4 omitida por ausencia de --queries)
> Coautoria: Lucas + Opus 4.6 (orquestrador) + Gemini 3.1 (deep-research, em andamento) + Consensus + PubMed + WebSearch

---

## 1. Conteudo Atual do Slide

```
h2: "RS e o metodo de busca e selecao; MA e o calculo estatistico — e sao separaveis"
Corpo: Compare-layout com RS (protocolo, busca, selecao, extracao, avaliacao de vies)
       vs MA (combina resultados em estimativa ponderada)
Footer: "Nem toda RS tem MA. Toda MA vem de uma RS."
Fonte: Cochrane Handbook v6.5, cap. 1
Timing: 60s
```

---

## 2. Resultados por Perna

### Perna 1 — Gemini Deep Research (em andamento)

**Status:** Processing (research ID: `v1_ChdBTF...`). Resultado pendente.
Sera adicionado como apendice quando disponivel.

### Perna 2 — MBE Evaluation (8 dimensoes)

Avaliacao de profundidade do slide usando rubrica D1-D8 (methodology.md):

| Dim | Score | Justificativa |
|-----|-------|---------------|
| D1 Source | 7 | Cochrane Handbook v6.5 cap. 1 — fonte Tier 1, especifica. Falta DOI/ISBN explicito |
| D2 Effect Size | N/A | Slide definitional — nao ha efeito estatistico a reportar |
| D3 Population | N/A | Slide conceitual generico — nao ha populacao de estudo |
| D4 Timeframe | N/A | Conceito atemporal — nao aplicavel |
| D5 Comparator | 8 | Comparacao RS vs MA e o proprio proposito do slide. Bem estruturada |
| D6 Grading | N/A | Nao ha claim de eficacia a ser graduado |
| D7 Impact | 6 | Traduz para pratica (saber ler RS/MA), mas nao quantifica impacto clinico |
| D8 Currency | 8 | Cochrane Handbook v6.5 e versao corrente (2024). Definicoes canonicas |

**Dimensoes aplicaveis:** 4/8
**Media (dims aplicaveis):** 7.25 / 10 — **DEEP** (minor adjustments)

**Nota sobre GRADE:** Nao aplicavel — slide definitional, nao reporta evidencia de intervencao.

**Assessment geral:** O slide e conceitualmente solido. As definicoes estao alinhadas com a fonte canonica. Para um slide de 60s com objetivo de corrigir equivoco RS=MA, a profundidade e adequada.

### Perna 3 — Reference Check

#### 3.1 Referencia citada no slide

| Referencia | Status | Detalhes |
|-----------|--------|----------|
| Cochrane Handbook v6.5, cap. 1 | **WEB-VERIFIED** | Confirmado via WebSearch: Cap. 1 "Starting a review" contem secao 1.2.2 "What is a systematic review?" com definicoes canonicas. Versao current = v6.5 (2024). URL: https://www.cochrane.org/authors/handbooks-and-manuals/handbook/current/chapter-01 |

#### 3.2 Cross-reference com evidence-db.md

| Campo | evidence-db | Slide | Status |
|-------|------------|-------|--------|
| Cochrane Handbook Cap. 1 | Listado em "Metodo — Cochrane Handbook", funcao "RS vs MA", quem le "Professor" | Citado como "Cochrane Handbook v6.5, cap. 1" | **CONSISTENTE** |
| Funcao na aula | "RS vs MA" | Exatamente o conteudo do slide | **CONSISTENTE** |

#### 3.3 Verificacao de claims factuais

| Claim no slide | Verificacao | Fonte | Status |
|---------------|-------------|-------|--------|
| "RS e o metodo de busca e selecao" | Cochrane Handbook 1.2.2: "systematic review attempts to collate all empirical evidence that fits pre-specified eligibility criteria [...] using explicit, systematic methods" | Cochrane v6.5, cap. 1 | **VERIFICADO** |
| "MA e o calculo estatistico" | Cochrane: "Meta-analysis is the use of statistical methods to summarize the results of independent studies" | Cochrane v6.5, cap. 10 | **VERIFICADO** |
| "Nem toda RS tem MA" | Cochrane: "Many systematic reviews contain meta-analyses" (many, nao todas). Consenso amplo na literatura | Cochrane + multiplas fontes | **VERIFICADO** |
| "Toda MA vem de uma RS" | Parcialmente correto. Toda MA **deveria** vir de uma RS, mas na pratica existem MAs sem RS formal. Cochrane e PRISMA assumem RS como pre-requisito | Consenso + Cochrane | **PARCIAL** — ver divergencia abaixo |

### Perna 5 — Opus Research (WebSearch + PubMed + Consensus)

#### 5.1 Definicoes canonicas encontradas

**Cochrane Handbook v6.5 (fonte do slide):**
- **RS:** "A systematic review attempts to collate all empirical evidence that fits pre-specified eligibility criteria in order to answer a specific research question, using explicit, systematic methods that are selected with a view to minimizing bias."
- **MA:** "Meta-analysis is the use of statistical methods to summarize the results of independent studies."

**PRISMA 2020 (Page et al. BMJ 2021, PMID 33782057):**
- Distingue RS (processo completo) de MA (componente estatistico opcional).
- DOI: https://doi.org/10.1136/bmj.n71

**Consensus — Chaves et al. (Clin Microbiol Infect, 2014):**
- "Meta-analysis is merely the statistical method used to compile effect estimates from individual studies. Labelling studies as 'meta-analysis' is a misnomer, as would be labelling an observational study 'multivariate'."
- 64 citacoes. Altamente relevante ao proposito do slide.

**Consensus — Pae (J Educ Eval Health Prof, 2023, 49 citacoes):**
- "A systematic review refers to a review [...] that uses explicit and systematic methods. In contrast, a meta-analysis is a quantitative statistical analysis that combines individual results on the same research question."

#### 5.2 Quando RS NAO tem MA (evidencias)

Fontes convergentes identificam 4 razoes principais:

| Razao | Fonte |
|-------|-------|
| Heterogeneidade clinica excessiva | Cochrane Handbook cap. 10; ScienceDirect (2023) |
| Poucos estudos disponiveis | Cochrane Handbook 13.6.2.4 |
| Desfechos incompativeis para pooling | Mantsiou et al. (IJLEW 2023) |
| Dados qualitativos (narrative synthesis) | Haidich (Hippokratia 2010) |

Cochrane Handbook 13.6.2.4 ("When pooling is judged not to be appropriate"):
- Exibir forest plot SEM pooled estimate
- Explorar heterogeneidade como informacao (nao como problema)

#### 5.3 Posicao na hierarquia de evidencia

| Fonte | Posicao RS/MA | Nuance |
|-------|--------------|--------|
| Oxford CEBM | Nivel 1a (RS de RCTs) | RS per se, MA e ferramenta |
| GRADE | Nao posiciona RS na hierarquia — avalia certeza POR desfecho | RS e veiculo, nao nivel |
| Consensus papers | "Top of evidence hierarchy" (multiplos) | Mas: "a MA is only as good as the studies it includes" |

#### 5.4 Papers mais relevantes encontrados

| Paper | Citacoes | Relevancia para slide | PMID/DOI |
|-------|----------|----------------------|----------|
| Chaves (Clin Microbiol Infect 2014) "Systematic review or meta-analysis? Their place in the evidence hierarchy" | 64 | **ALTA** — diretamente distingue RS de MA, critica uso intercambiavel dos termos | [Consensus link] |
| Pae (J Educ Eval Health Prof 2023) "How to review and assess a systematic review and meta-analysis article" | 49 | MEDIA — definicoes claras, mais voltado a como avaliar | PMID: nao verificado |
| Gopalakrishnan & Ganeshkumar (J Hum Reprod Sci 2013) "Systematic reviews and meta-analyses" | 633 | MEDIA — review educacional completo | [Consensus link] |
| Page et al. (BMJ 2021) "PRISMA 2020" | 41909 | ALTA — guideline de relato, distingue RS de MA | PMID: 33782057, DOI: 10.1136/bmj.n71 |
| Springer chapter (2019) "What Is the Difference Between a Systematic Review and a Meta-analysis?" | 30 | ALTA — titulo exatamente o tema do slide | DOI: 10.1007/978-3-662-58254-1_37 |

---

## 3. Tabela Comparativa entre Pernas

| Achado | Perna 2 (MBE) | Perna 3 (RefCheck) | Perna 5 (Opus) | Confianca |
|--------|--------------|-------------------|---------------|-----------|
| Definicao RS = processo | Alinhada | Verificada vs Cochrane | Confirmada por 5+ fontes | **ALTA** |
| Definicao MA = estatistica | Alinhada | Verificada vs Cochrane | Confirmada por 5+ fontes | **ALTA** |
| "Nem toda RS tem MA" | Correta | Consistente com evidence-db | Confirmada com razoes especificas | **ALTA** |
| "Toda MA vem de uma RS" | Nao avaliada | PARCIAL | Normativamente correto, na pratica nem sempre | **MODERADA** — ver divergencia |
| Cochrane v6.5 cap. 1 como fonte | Tier 1, DOI ausente | Confirmado, URL verificado | Confirmada como fonte canonica | **ALTA** |
| Profundidade adequada | 7.25/10 DEEP | — | — | **ALTA** |
| Slide cobre equivocos comuns | — | — | Chaves 2014 confirma que confusao e prevalente | **ALTA** |

---

## 4. Convergencias

1. **Definicoes corretas:** As definicoes do slide estao alinhadas com TODAS as fontes consultadas (Cochrane, PRISMA, Consensus papers, WebSearch). Nenhuma divergencia conceitual.

2. **Separabilidade RS/MA:** O claim central do slide — que RS e MA sao separaveis — e unanime em todas as fontes. Chaves (2014) vai alem: chama de "misnomer" rotular um estudo como "meta-analysis" quando deveria ser "systematic review with meta-analysis".

3. **"Nem toda RS tem MA":** Confirmado por todas as fontes. Razoes: heterogeneidade, poucos estudos, desfechos incompativeis, sintese narrativa.

4. **Cochrane Handbook como fonte:** Adequada e canonica. Tier 1.

---

## 5. Divergencias

### 5.1 "Toda MA vem de uma RS" — PARCIALMENTE CORRETO

**O que o slide diz:** "Toda MA vem de uma RS."

**O que as fontes dizem:**
- **Normativamente:** Sim. PRISMA, Cochrane e GRADE assumem RS como prerequisito para MA. Uma MA sem RS seria metodologicamente fragil.
- **Na pratica:** Existem MAs publicadas sem RS formal (busca nao sistematica, sem protocolo). Ioannidis (2016, PMID 27620683, ja na evidence-db) critica justamente a proliferacao de MAs de baixa qualidade que nao seguem processo sistematico.
- **Nuance para o slide:** Para o nivel basico-intermediario dos residentes, a afirmacao e pedagogicamente correta e alinhada com o padrao ideal. Nao requer correcao, mas o professor (speaker notes) pode mencionar a ressalva.

**Acao sugerida:** Manter o footer como esta. Adicionar nota nos speaker notes:
```
[NOTA] "Toda MA vem de uma RS" = ideal metodologico. Na pratica, existem MAs
sem RS formal — que sao justamente as de pior qualidade (Ioannidis 2016).
```

### 5.2 Hierarquia de evidencia — ausente no slide

**O que o slide omite:** A posicao de RS/MA na hierarquia de evidencia.

**O que as fontes dizem:** Multiplos papers (Consensus: 6/10 mencionam "top of evidence hierarchy"). GRADE nao posiciona RS como nivel, mas Oxford CEBM sim (1a).

**Assessment:** O slide tem 60s. Incluir hierarquia sobrecarregaria. A aula inteira cobre isso em slides posteriores. **Nao e gap — e scoping adequado.**

---

## 6. Sugestoes de Melhoria

### Prioridade ALTA

| # | Sugestao | Justificativa | Acao |
|---|---------|---------------|------|
| 1 | Adicionar nota sobre "toda MA vem de RS" nos speaker notes | Divergencia 5.1 — nuance pedagogicamente util | Append 2 linhas em `<aside class="notes">` |

### Prioridade MEDIA

| # | Sugestao | Justificativa | Acao |
|---|---------|---------------|------|
| 2 | Considerar adicionar referencia complementar: Chaves (Clin Microbiol Infect 2014) | Paper curto, diretamente sobre o tema, linguagem didatica | Adicionar em evidence-db, nao no slide |
| 3 | Explicitar versao do Handbook (v6.5, 2024) no source-tag | Atualmente diz "v6.5" sem ano. Adicionar "(2024)" para currency | Editar source-tag |

### Prioridade BAIXA

| # | Sugestao | Justificativa | Acao |
|---|---------|---------------|------|
| 4 | Nos speaker notes, mencionar razoes para RS sem MA | Enriquece fala do professor em [0:40-0:60] | Opcional — depende do tempo |
| 5 | Adicionar DOI/ISBN do Cochrane Handbook na evidence-db | Reference tracking | Adicionar na evidence-db |

### NAO recomendado

| # | O que NAO fazer | Razao |
|---|----------------|-------|
| A | Adicionar hierarquia de evidencia ao slide | Fora do timing (60s), coberto em slides posteriores |
| B | Mudar o h2 | Assertion-evidence correta, concisa, testada |
| C | Adicionar exemplos concretos de RS sem MA | Sobrecarrega slide definitional de 60s |

---

## 7. Status das Fontes

| Fonte | Tipo | Status de Verificacao | Onde |
|-------|------|-----------------------|------|
| Cochrane Handbook v6.5, cap. 1 | Handbook | **WEB-VERIFIED** | Slide + evidence-db |
| PRISMA 2020 (Page et al. BMJ 2021) | Guideline relato | **VERIFIED** (PMID 33782057) | evidence-db |
| Chaves (Clin Microbiol Infect 2014) | Paper educacional | **CANDIDATE** | Consensus (nao verificado PubMed) |
| Pae (J Educ Eval Health Prof 2023) | Review educacional | **CANDIDATE** | Consensus |
| Ioannidis 2016 (Milbank Q) | Critica qualidade SRs | **VERIFIED** (PMID 27620683) | evidence-db |
| Springer chapter 2019 | Book chapter | **CANDIDATE** | Consensus |

---

## 8. Conclusao

O slide `s-rs-vs-ma` e **conceitualmente solido**, com definicoes alinhadas a fonte canonica (Cochrane Handbook v6.5) e confirmadas por multiplas fontes independentes. A unica divergencia identificada ("Toda MA vem de uma RS") e uma simplificacao pedagogicamente justificavel, com sugestao de nota complementar nos speaker notes.

**Score MBE:** 7.25/10 (DEEP) — adequado para slide definitional de 60s.

**Acao minima recomendada:** Adicionar 2 linhas nos speaker notes sobre a nuance de "toda MA vem de RS".

---

## Apendice A — Gemini Deep Research

**Status:** Em andamento (research ID: `v1_ChdBTF9PYWJYYkNMVHF6N0lQdk96bTBBbxIXQUxfT2FiWGJDTFRxejdJUHZPem0wQW8`).
**Verificar com:** `gemini-check-research` usando o ID acima.
Quando disponivel, comparar achados contra este report e anexar como Apendice A completo.

## Apendice B — Consensus Search Summary

10 papers encontrados. Top 5 por relevancia:

1. Gopalakrishnan & Ganeshkumar (Semin Fetal Neonatal Med 2013) — 633 cit. Review educacional abrangente.
2. Chaves (Clin Microbiol Infect 2014) — 64 cit. "Labelling studies as 'meta-analysis' is a misnomer."
3. Pae (J Educ Eval Health Prof 2023) — 49 cit. Como avaliar RS/MA.
4. Springer chapter (2019) — 30 cit. "What Is the Difference Between a SR and a MA?"
5. A comprehensive guide (Medicine, 2025) — 0 cit. Guia recente, definicoes atualizadas.

---

*Report gerado por /research pipeline. Orquestrador: Opus 4.6. Fontes: Consensus, PubMed, WebSearch, Cochrane Handbook. Gemini deep-research pendente.*
