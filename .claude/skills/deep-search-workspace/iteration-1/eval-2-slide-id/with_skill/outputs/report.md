## Deep Search Report: RS vs MA -- Diferenca conceitual, separabilidade, proporcoes bibliometricas
Data: 2026-04-02 | Fonte: Gemini 3.1 + Google Search
Status PMIDs: CANDIDATE (verificar via PubMed antes de usar em slide)

---

## TL;DR

A RS e o metodo cientifico de busca e selecao para minimizar vieses; a MA e a tecnica estatistica opcional para agrupar dados. **37% das RSs medicas atuais nao contem MA** (Page et al. PLoS Med 2016). Na pratica clinica (GRADE), uma MA sem RS previa gera resultados matematicamente precisos porem clinicamente falsos (*garbage in, garbage out*). Confianca: ALTA.

## CONVERGENCIAS

1. **Definicao universal de separacao:** Cochrane Handbook v6.5 (2024), IOM/NAM (2011), e PRISMA 2020 convergem unanimemente: RS = metodo de identificacao e avaliacao; MA = subconjunto puramente estatistico e opcional.
   - Cochrane Handbook cap. 1.2: "Muitas revisoes sistematicas contem meta-analises" (nao-obrigatoriedade).
   - IOM 2011: RS "pode incluir sintese quantitativa (meta-analise) dependendo dos dados".
   - PRISMA 2020: checklist separa itens de RS (metodo) dos itens de MA (estatistica).

2. **Prevalencia epidemiologica:** Grandes estudos meta-epidemiologicos convergem: a maioria das RSs inclui MA, mas uma porcao significativa nao. Taxa de inclusao de MA em RS: 53,7% em 2004 (Moher et al. PLoS Med 2007) → ~63% em 2014 (Page et al. PLoS Med 2016). Ou seja, >1/3 das RSs sao sinteses qualitativas.

3. **Hierarquia metodologica:** Concordancia absoluta de que MA isolada sem RS = vies de selecao inaceitavel. Estatistica agrupada ganha "falso poder estatistico" sobre dados enviesados.

## DIVERGENCIAS

1. **Uso terminologico inadequado (autores vs diretrizes):**
   - Autores: 22,8% de revisoes em CAM que incluiam "meta-analise" no titulo NAO reportaram nenhuma estimativa pooled (Turner et al. PLoS One 2013; DOI: 10.1371/journal.pone.0053536).
   - Diretrizes (Cochrane/IOM): rejeitam esse uso como erro metodologico primario.
   - PRISMA 2020 e Cochrane sao definitivos: MA so deve ser declarada quando houve combinacao quantitativa de dados.

2. **Decisao sobre modelo estatistico (efeito fixo vs aleatorio):**
   - Pratica comum: autores usam I-squared post hoc para decidir modelo (efeito aleatorio se I2>50%).
   - Cochrane desencoraja: decisao deve ser baseada em diversidade clinica e metodologica a priori, nao reacao post hoc ao I2.

## EVIDENCIA TIER 1

### [GUIDELINE] Cochrane Handbook v6.5, 2024
- Higgins JPT et al. Cochrane Handbook for Systematic Reviews of Interventions.
- Define categoricamente: RS = "levantamento rigoroso de evidencias empiricas usando metodos sistematicos predefinidos (protocolo)". MA = "combinacao estatistica de resultados numericos". Separaveis.
- GRADE: HIGH
- Nota critica: Padrao-ouro global. Adotado pela ANVISA/CONITEC no Brasil.

### [GUIDELINE] IOM/NAM -- Standards for Systematic Reviews, 2011
- Eden J et al. Finding What Works in Health Care. National Academies Press, 2011.
- 21 padroes de qualidade. RS = "investigacao cientifica que usa metodos predefinidos [...] e que pode incluir sintese quantitativa (meta-analise) dependendo dos dados".
- GRADE: HIGH
- Nota critica: Base para CONITEC/PCDTs. Exige AMSTAR-2 para avaliacao.

### [META/SR] Page MJ et al. PLoS Med 2016;13(5):e1002028
- n=300 RSs aleatorias de 2014 (amostra global PubMed)
- MA realizada em **63% (189/300)**. Logo, **37% sem MA** (revisoes qualitativas).
- MA mediana: 9 estudos (IQR 6-17). 1% = "Empty Reviews" (0 estudos incluidos).
- DOI: 10.1371/journal.pmed.1002028
- GRADE: MODERATE
- Nota critica: Populacao universal de PubMed. Robusto para o dado "37%".

### [GUIDELINE] PRISMA 2020 -- Page MJ et al. BMJ 2021;372:n71
- Checklist 27 itens. Separa itens de RS (metodo) dos de MA (estatistica).
- Serve para RS com MA (pairwise), MA em rede, ou RS sem qualquer sintese.
- DOI: 10.1136/bmj.n71
- GRADE: HIGH

### [META/SR] Turner L et al. PLoS One 2013;8(1):e53536
- n=349 RSs em terapias alternativas vs controles
- **22,8%** que se autointitulavam "Meta-analise" no titulo NAO reportaram nenhuma estimativa pooled (vs 1% no controle de medicina convencional).
- DOI: 10.1371/journal.pone.0053536
- GRADE: LOW (area especifica de CAM, mas ilustrativo)
- Nota critica: Evidencia de que titulo nao substitui leitura critica.

### [LANDMARK] Marco historico: Karl Pearson (1904) + Gene Glass (1976) + Archie Cochrane (1979)
- Pearson (BMJ 1904): primeiro calculo de combinacao de outcomes (vacina tifoide). A matematica veio antes do metodo.
- Glass (Educational Researcher 1976): cunhou o termo "Meta-Analysis" -- "analise estatistica de uma grande colecao de resultados de estudos individuais".
- Cochrane (1971/1979): chamou atencao para a falta de resumos criticos de RCTs. Em 1993, Iain Chalmers fundou a Cochrane Collaboration.
- GRADE: N/A (historico)

## NUANCES

1. **"Garbage In, Garbage Out" (GIGO):** MA pode conferir falsa sensacao de precisao a dados falhos. IC estreito + p<0.001 + effect size pontual, mas refletindo erro sistematico, nao verdade biologica. A RS salva a MA definindo criterios rigorosos de exclusao de vies.

2. **Revisoes vazias (Empty Reviews):** Ate 1% das RSs bem desenhadas terminam sem nenhum estudo elegivel. Publicadas sem MA e sem pacientes -- servem como alerta de lacuna de evidencia (Page et al. 2016).

3. **Variacoes modernas (mencao apenas):**
   - Network MA (meta-analise em rede): comparacao indireta (A vs C via A-B + B-C).
   - Umbrella Reviews: RS de RSs -- combinam achados de RS/MAs ja publicadas.

4. **Erros estatisticos comuns em MAs:** Contagem dupla de pacientes em trials multi-braco (inflando N falsamente). Confusao entre Erro Padrao (SE) e Desvio Padrao (SD) durante extracao (Papakonstantinou et al. Methods 2025).

## GAPS

- Como lidar com o "vies de redundancia" -- dezenas de MAs conflitantes sobre o mesmo topico clinico (Ioannidis 2016). Residentes encaram 5+ MAs recentes e divergentes, sem orientacao clara sobre qual priorizar.
- Proporção exata de MAs publicadas sem RS previa rigorosa (dado nao encontrado).
- Impacto quantificado do uso terminologico errado em decisoes clinicas reais.

## DADOS PARA SLIDE

1. **37% das RSs NAO contem MA.**
   - Fonte: Page MJ et al. PLoS Med 2016. DOI: 10.1371/journal.pmed.1002028
   - Como usar: Desmistificar crenca de que "toda RS precisa de Forest Plot". RS barra MA quando heterogeneidade clinica impede combinacao. Cabe no compare-footer do slide.

2. **1904 vs 1976 -- A matematica veio antes do metodo.**
   - Fonte: Karl Pearson (BMJ 1904) e Gene Glass (Educational Researcher 1976)
   - Como usar: Marco historico nas speaker notes. Pearson calculou primeiro modelo agregado (vacina tifoide) 72 anos antes do termo "meta-analise" existir. A RS moderna nasceu depois (Cochrane, 1979).

3. **22,8% de artigos com "Meta-analise" no titulo NAO reportam dados combinados.**
   - Fonte: Turner L et al. PLoS One 2013. DOI: 10.1371/journal.pone.0053536
   - Como usar: Alerta de leitura critica nas speaker notes. "Nunca prescrever baseado apenas no titulo do PubMed."

## FONTES COMPLETAS

- Eden J, Levit L, Berg A, Morton S. Finding What Works in Health Care: Standards for Systematic Reviews. IOM/NAM, 2011.
- Glass GV. Primary, secondary, and meta-analysis of research. Educational Researcher 1976.
- Higgins JPT et al. Cochrane Handbook for Systematic Reviews of Interventions v6.5. Cochrane, 2024.
- Moher D, Tetzlaff J, Tricco AC, Sampson M, Altman DG. Epidemiology and reporting characteristics of systematic reviews. PLoS Medicine 2007. DOI: 10.1371/journal.pmed.0040078
- Page MJ et al. Epidemiology and Reporting Characteristics of Systematic Reviews of Biomedical Research: A Cross-Sectional Study. PLoS Medicine 2016. DOI: 10.1371/journal.pmed.1002028
- Page MJ et al. The PRISMA 2020 statement: an updated guideline for reporting systematic reviews. BMJ 2021. DOI: 10.1136/bmj.n71
- Papakonstantinou T et al. Common statistical errors in systematic reviews: A tutorial. Methods 2025.
- Turner L et al. An Evaluation of Epidemiological and Reporting Characteristics of CAM Systematic Reviews. PLoS One 2013. DOI: 10.1371/journal.pone.0053536
- Pearson K. Report on certain enteric fever inoculation statistics. BMJ 1904;2:1243-6.
- Cochrane AL. Effectiveness and Efficiency. 1971.

---

> **Nota:** Todos os PMIDs citados pelo Gemini sao CANDIDATE -- verificar via PubMed MCP antes de inserir em slide ou evidence-db. Taxa historica de erro de PMIDs do Gemini: ~15-20%.
> **Cross-validation recomendada:** Rodar /research (Claude MCPs) para confirmar os dados-chave (37%, 22.8%, marcos historicos).
> **Proximos passos sugeridos:** (1) Verificar PMIDs via PubMed. (2) Inserir dado "37%" no compare-footer ou speaker notes do slide s-rs-vs-ma. (3) Enriquecer compare-desc de RS com "Protocolo, busca, selecao, extracao, avaliacao de vies — 37% param aqui". (4) Adicionar fontes verificadas ao evidence-db.

---

Coautoria: Lucas + Opus 4.6 (orquestracao, formatacao) + Gemini 3.1 (deep-research com Google Search grounding)
