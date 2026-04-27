{
  "value": {
    "answer": "As metan\u00e1lises diferem fundamentalmente dependendo do design dos estudos prim\u00e1rios que sintetizam, pois cada tipo de estudo exige abordagens estat\u00edsticas, avalia\u00e7\u00f5es de qualidade e interpreta\u00e7\u00f5es cl\u00ednicas distintas. \n\nAbaixo est\u00e3o as diferen\u00e7as metodol\u00f3gicas entre metan\u00e1lises de RCTs, Estudos Observacionais e Acur\u00e1cia Diagn\u00f3stica:\n\n### 1. Metan\u00e1lises de Ensaios Cl\u00ednicos Randomizados (RCTs Cl\u00e1ssicas)\n*   **Premissas Estat\u00edsticas:** A premissa central \u00e9 que cada RCT de alta qualidade fornece uma estimativa n\u00e3o enviesada do efeito do tratamento subjacente [1]. A varia\u00e7\u00e3o entre os estudos \u00e9 primeiramente atribu\u00edda ao erro amostral aleat\u00f3rio, mas modelos de **Efeitos Aleat\u00f3rios (Random-Effects)** s\u00e3o habitualmente usados para contabilizar a heterogeneidade cl\u00ednica e metodol\u00f3gica (a vari\u00e2ncia entre os estudos, ou $\\tau^2$) [2], [3]. Os dados s\u00e3o agrupados usando medidas de efeito relativas (Risco Relativo - RR, Odds Ratio - OR) ou absolutas (Diferen\u00e7a de Risco, Diferen\u00e7a de M\u00e9dias) [4], [5].\n*   **Ferramenta de Risco de Vi\u00e9s (RoB):** Utiliza-se a ferramenta **RoB 2 (Cochrane)**. Ela avalia os ensaios atrav\u00e9s de cinco dom\u00ednios baseados em \"perguntas sinalizadoras\": vi\u00e9s no processo de randomiza\u00e7\u00e3o, desvios das interven\u00e7\u00f5es pretendidas, dados de desfecho faltantes, medi\u00e7\u00e3o do desfecho e sele\u00e7\u00e3o do resultado relatado [6], [7], [8].\n*   **Exemplo Seminal:** A metan\u00e1lise sobre a administra\u00e7\u00e3o de magn\u00e9sio intravenoso no infarto agudo do mioc\u00e1rdio. Uma metan\u00e1lise inicial de estudos pequenos sugeria um forte benef\u00edcio de sobrevida, mas foi posteriormente contrariada por um mega-ensaio cl\u00ednico (o estudo ISIS-4), tornando-se um caso cl\u00e1ssico para ensinar como o vi\u00e9s de publica\u00e7\u00e3o e efeitos de pequenos estudos podem distorcer uma metan\u00e1lise de RCTs [9], [10].\n\n### 2. Metan\u00e1lises de Estudos Observacionais / Coortes\n*   **Premissas Estat\u00edsticas:** Ao contr\u00e1rio dos RCTs, estudos observacionais s\u00e3o suscet\u00edveis a fatores de confus\u00e3o (confounding) e vi\u00e9s de sele\u00e7\u00e3o [1]. A premissa de que a combina\u00e7\u00e3o matem\u00e1tica dos dados revelar\u00e1 a \"verdade\" \u00e9 perigosa aqui; combinar estudos observacionais pode gerar estimativas falsamente precisas, por\u00e9m enviesadas [1]. Estatisticamente, a metan\u00e1lise deve focar fortemente na **explora\u00e7\u00e3o da heterogeneidade** (via metarregress\u00e3o) e na separa\u00e7\u00e3o de an\u00e1lises de associa\u00e7\u00f5es ajustadas versus n\u00e3o ajustadas [11]. \n*   **Ferramenta de Risco de Vi\u00e9s (RoB):** A **Newcastle-Ottawa Scale (NOS)** \u00e9 a ferramenta tradicional, avaliando tr\u00eas dom\u00ednios: sele\u00e7\u00e3o das coortes, comparabilidade dos grupos (ajuste para fatores de confus\u00e3o) e avalia\u00e7\u00e3o do desfecho/exposi\u00e7\u00e3o [12], [13]. Modernamente, a Cochrane recomenda a evolu\u00e7\u00e3o desta ferramenta, a **ROBINS-I**, que compara o estudo observacional a um \"ensaio cl\u00ednico alvo\" (target trial) hipot\u00e9tico para avaliar o vi\u00e9s [14].\n*   **Exemplo Seminal:** A rela\u00e7\u00e3o entre betacaroteno e o risco de doen\u00e7as cardiovasculares. Metan\u00e1lises de coortes observacionais sugeriam que o alto consumo de betacaroteno reduzia o risco cardiovascular, enquanto metan\u00e1lises de RCTs subsequentes revelaram um efeito prejudicial (aumento do risco). Este caso \u00e9 usado exaustivamente na literatura para ilustrar como o vi\u00e9s de indica\u00e7\u00e3o e fatores de confus\u00e3o do estilo de vida distorcem os resultados de coortes [15].\n\n### 3. Metan\u00e1lises de Acur\u00e1cia Diagn\u00f3stica (DTA)\n*   **Premissas Estat\u00edsticas:** Esta \u00e9 a categoria metodologicamente mais complexa. Em vez de uma \u00fanica medida de efeito, os estudos prim\u00e1rios relatam pares de estat\u00edsticas (Sensibilidade e Especificidade) que s\u00e3o intrinsecamente correlacionadas e dependem do limiar (threshold) diagn\u00f3stico utilizado [16], [17]. Os modelos univariados tradicionais falham aqui porque ignoram essa correla\u00e7\u00e3o [18]. Portanto, as metan\u00e1lises de DTA exigem o uso de **Modelos Hier\u00e1rquicos (como o Modelo Bivariado ou o modelo HSROC)**, que produzem n\u00e3o apenas um ponto sum\u00e1rio (losango), mas uma curva (Summary Receiver Operating Characteristic - SROC) com regi\u00f5es de confian\u00e7a e predi\u00e7\u00e3o [18], [19], [20].\n*   **Ferramenta de Risco de Vi\u00e9s (RoB):** Utiliza-se a **QUADAS-2**. Ela avalia o risco de vi\u00e9s e os problemas de aplicabilidade cl\u00ednica em quatro dom\u00ednios: sele\u00e7\u00e3o de pacientes, teste \u00edndex (o novo teste sendo avaliado), padr\u00e3o-ouro (reference standard) e fluxo e tempo (flow and timing - se todos os pacientes receberam os mesmos testes em um intervalo de tempo adequado) [21], [22].\n*   **Exemplo Seminal:** A avalia\u00e7\u00e3o do *Mood Disorder Questionnaire (MDQ)* para o rastreio de transtorno bipolar [23], [24]. A metan\u00e1lise deste question\u00e1rio ilustra de forma clara o \"efeito de limiar\" em gr\u00e1ficos SROC, demonstrando a varia\u00e7\u00e3o brutal de sensibilidade e especificidade dependendo da nota de corte utilizada e do idioma/contexto cultural em que a ferramenta foi aplicada [25], [26], [27]. Outro exemplo robusto envolve testes r\u00e1pidos de tuberculose (Xpert MTB/RIF), utilizando metarregress\u00e3o bivariada para comparar a acur\u00e1cia em crian\u00e7as versus adultos [28], [29].",
    "conversation_id": "6d9f928d-1bcf-449e-b980-4da6cccbc5e1",
    "sources_used": [
      "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "162af2a5-4ff7-4c1b-9c8b-cff16a4ecb33",
      "02035019-dc70-421a-a592-42db43b1e743"
    ],
    "citations": {
      "1": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "2": "162af2a5-4ff7-4c1b-9c8b-cff16a4ecb33",
      "3": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "4": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "5": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "6": "162af2a5-4ff7-4c1b-9c8b-cff16a4ecb33",
      "7": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "8": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "9": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "10": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "11": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "12": "02035019-dc70-421a-a592-42db43b1e743",
      "13": "02035019-dc70-421a-a592-42db43b1e743",
      "14": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "15": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "16": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "17": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "18": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "19": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "20": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "21": "02035019-dc70-421a-a592-42db43b1e743",
      "22": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "23": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "24": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "25": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "26": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "27": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "28": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
      "29": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc"
    },
    "references": [
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 1,
        "cited_text": "202020172014201120082005 Year 200219991996199319901987 0 5,000 10,000 15,000 N o of  p ub lic at io ns 20,000 25,000 FIGURE\u00a01.1\u2003 Number of publications concerning meta- analysis, 1987\u20132020. Results from MEDLINE search using text word and medical subject heading (MESH) \u201cmeta- analysis\u201d and text word \u201csystematic review.\u201d Systematic Reviews in Health Research 3 1.2\u2003 THE\u2003SCOPE\u2003OF\u00a0META-\u2003ANALYSIS An important distinction can be made between meta- analysis of RCTs and meta- analysis of observational studies of interventions (Chapter\u00a015) or etiology (Chapter\u00a019). Consider a set of high- quality trials that examined the same intervention in comparable patient populations: each trial should provide an unbiased estimate of the same under-lying treatment effect. The variability observed between the trials can be attributed to random variation, and meta- analysis should provide an equally unbiased estimate of the treatment effect with increased precision. A fundamentally different situation typically arises in observational epidemiological studies, for example case\u2013control studies, cross- sectional studies, or cohort studies. Due to confounding and selection bias, these studies may produce estimates of causal associations that deviate from the underlying causal associations beyond what can be attributed to chance. Combining a set of observational studies will thus often provide spuriously precise, biased estimates of causal associations. The thorough consideration of heterogeneity between obser-vational study results, particularly of possible confounding and bias, will generally provide more insights than the mechanical calculation of an overall measure of effect."
      },
      {
        "source_id": "162af2a5-4ff7-4c1b-9c8b-cff16a4ecb33",
        "citation_number": 2,
        "cited_text": "In contrast, the random-effects model assumes that the treatment effects vary across studies due to differences in patient demographics, dosages, or follow-up durations. This model accounts for both within-study sampling error and between-study variation, often referred to as heterogeneity.[11, 13] For most medical meta-analyses, the random-effects model is preferred because it more accurately reflects the inherent variability found in real-world clinical practice.[11, 14] <cited_table>",
        "cited_table": {
          "num_columns": 3,
          "rows": [
            [
              "Feature",
              "Fixed-Effects Model",
              "Random-Effects Model"
            ],
            [
              "Assumption",
              "One true effect size shared by all studies.",
              "Distribution of effect sizes; effects vary by study."
            ],
            [
              "Variance Calculation",
              "Based only on within-study error.",
              "Based on within-study error + between-study variance ("
            ],
            [
              "Study Weighting",
              "Larger studies receive significantly more weight.",
              "Weights are more balanced across large and small studies."
            ],
            [
              "Confidence Interval",
              "Generally narrower (more \"certain\" but potentially biased).",
              "Generally wider (accounts for additional uncertainty)."
            ],
            [
              "Statistical Software",
              "Standard in RevMan and R packages.",
              "New methods (REML, HKSJ) endorsed by Cochrane."
            ]
          ]
        }
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 3,
        "cited_text": "Second, simply calculating an arithmetic mean would be inappropriate. The results from small studies are more subject to the play of chance and should be given less weight. Methods used for meta- analysis employ a weighted average of the results, in which the larger trials generally have more influence than the smaller ones. A variety of statistical techniques are available for this purpose (see Chapter\u00a09), which can be broadly classified into two approaches\u00a0[36]. The difference is in whether the variability of the results between the studies is considered. The fixed-\u00adeffect approach considers only random variation within studies, and individual studies are weighted solely by their precision\u00a0[37]. The main alternative, the random-\u00adeffects approach\u00a0[38, 39], assumes a model in which different effects underlie the different studies, and these differences are taken into consideration as an additional source of variation. Effects are assumed to be randomly distributed, and the central point of this distribu-tion is the focus of the combined effect estimate. Random- effects approaches generally give relatively more weight to smaller studies and lead to wider confidence intervals than fixed- effects approaches. The use of random- effects models has been advocated if there is heterogeneity between study results. This is problematic, however. Rather than simply ignoring it after applying some statistical model, the approach to hetero-geneity should be to scrutinize and attempt to explain it (see Chapter\u00a010)."
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 4,
        "cited_text": "Risk difference (RD) (also called absolute risk reduction, ARR). Number needed to treat (NNT). See Box\u00a08.1 for an explanation of the difference between risk and odds. As events may be desirable rather than undesirable, we would prefer a more neutral term than \u201crisk\u201d (such as probability), but for the sake of convention we use the term \u201crisk\u201d throughout. Measures of relative effect express the risk of the outcome in one group relative to that in the other. The RR is the ratio of two risks (one for each group), whereas the OR is the ratio of two odds. Note that these relative measures (RR, OR) are some-times expressed as the percentage reduction in risk or odds. For example, the relative risk reduction is defined as RRR\u00a0=\u00a0100(1\u00a0\u2013\u00a0RR)%. While this representation can help interpretation, it does not affect the choice between different measures: meta- analysis will always be based on the original ratio measures. Summary RRs and ORs estimated from meta- analyses can be converted into relative risk and relative odds reductions in exactly the same way as for individual trials."
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 5,
        "cited_text": "outcome measurements in all trials are made on the same scale. This is usually referred to as the mean\u2003difference (MD). For a particular study the MD is given by MDi i im m1 2 , with standard error SE MDi i i i i s n s n 1 2 1 2 2 2 . TABLE\u00a08.3\u2003 Summary information when outcome is continuous. Study i Mean response Standard deviation Group size Intervention m1i s1i n1i Control m2i s2i n2i 138 Systematic\u2003Reviews\u2003in\u2003Health\u2003Research The MD cannot be used when the trials measure the outcome in a variety of ways, for example if the trials measure depression using different psychometric scales. In this circumstance it is necessary to standardize the results of the trials to a uniform scale before they can be combined."
      },
      {
        "source_id": "162af2a5-4ff7-4c1b-9c8b-cff16a4ecb33",
        "citation_number": 6,
        "cited_text": "Risk of Bias : Assessed using tools like Cochrane\u2019s RoB 2, which looks at randomization sequence generation, allocation concealment, and blinding of participants and outcome assessors.[29, 33] Inconsistency : Large I^2 values or non-overlapping confidence intervals across studies.[32, 33] Indirectness : When the studies in the meta-analysis do not directly address the clinical question (e.g., using surrogate markers instead of patient-important outcomes like mortality).[32, 33] Imprecision : Small sample sizes or wide confidence intervals that make it difficult to distinguish between a significant effect and no effect.[32, 33] Publication Bias : Evidence of missing studies, often assessed visually via funnel plots or statistically via Egger\u2019s test.[32, 33, 34]"
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 7,
        "cited_text": "4.4.2.2\u2003 RoB\u20032 In response to concerns identified in previous evaluations, a revised tool for assessing RoB in randomized trials (RoB 2) was developed. An initial draft of RoB 2\u00a0was released in 2016\u00a0[68] and a finalized version in 2019\u00a0[14]. The RoB 2 tool includes five domains that are broadly consistent with the existing tool, but have different terminology to explain more clearly what each domain addresses (Figure\u00a0 4.5). These domains are intended to be comprehensive, covering all issues that might lead to a RoB, and for this reason review authors cannot add other domains to the tool. The tool provides signaling questions, which are reasonably factual in nature and whose answers flag the poten-tial for bias. Assessments are directed at a specific trial result, reflecting the fact that a particular methodological feature such as lack of participant blinding may bias results for certain outcomes like patient- reported quality of life but not others, for example all- cause mortality. The tool includes a rule that the overall RoB for the result is driven by the worst judgment across all domains in the tool. Thus, if any domain is assessed"
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 8,
        "cited_text": "Cochrane Risk of Bias tool (original version) RoB 2 Random sequence generation (selection bias) Bias arising from the randomization processAllocation concealment (selection bias) Blinding of participants and personnel (performance bias) Bias due to deviations from intended interventions Incomplete outcome data (attrition bias) Bias due to missing outcome data Blinding of outcome assessment (detection bias) Bias in measurement of the outcome Selective reporting (reporting bias) Bias in selection of the reported result"
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 9,
        "cited_text": "It can easily be seen (for example using list or browse) that these variables con-tain the same values as the variables _ES and _seES left behind by metan. 25.2.3\u00ad Example\u00ad2\u00a0\u2013\u00adIntravenous\u00adMagnesium\u00adin\u00a0Acute\u00adMyocardial\u00ad Infarction Table\u00a025.3 gives data from 16 randomized controlled trials of intravenous magnesium in the prevention of death following myocardial infarction. These trials are a well- known example where the results of a meta- analysis\u00a0[7] were contradicted by a single large trial (ISIS- 4)\u00a0[8\u201310]."
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 10,
        "cited_text": "Golf 1991 5 23 13 33 Thogersen 1991 4 130 8 122 LIMIT-\u00ad2 1992 90 1159 118 1157 Schechter\u00ad2 1995 4 107 17 108 ISIS-\u00ad4 1995 2216 29\u2009011 2103 29\u2009039 492 Systematic Reviews in Health Research Let us run a meta- analysis of the 2 \u00d7 2 count data in Table\u00a0 25.3. This time we request odds ratios as the effect measure, but otherwise the commands are very sim-ilar to those in our previous example. The forest plot appears in Figure\u00a025.2. generate alive1 = pop1- deaths1 generate alive0 = pop0- deaths0 metan deaths1 alive1 deaths0 alive0, or lcols(trialnam) nohet forestplot(xlabel(.1 1 10))"
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 11,
        "cited_text": "The quality of conduct and reporting of prognosis studies is gradually improving since the introduction of the REMARK and TRIPOD guidelines, and meta- analyses are thus becoming more often a sensible and achievable option\u00a0[7, 41, 42, 44]. Meta- analyses will be most interpretable, and thus useful, when separate analyses are undertaken for groups of \u201csimilar\u201d prognostic effect measures. In particular, we sug-gest separate meta- analyses for: Hazard ratios, odds ratios, and risk ratios. Unadjusted and adjusted associations. Prognostic factor effects at distinct cut points (or groups of similar cut points). Prognostic factor effects corresponding to a linear trend (association). Prognostic factor effects corresponding to nonlinear trends. Each method of measurement (for factors and outcomes)."
      },
      {
        "source_id": "02035019-dc70-421a-a592-42db43b1e743",
        "citation_number": 12,
        "cited_text": "When using this checklist, carefully consider each question and assess the study based on the information provided in the research article. The checklist helps eval-uate analytical cross-sectional studies\u2019 quality and methodological rigor, facilitating a systematic and evidence-based appraisal process. NewcastleeOttawa Scale (NOS) The NewcastleeOttawa Scale (NOS) is a tool for quality assessment of nonrandom-ized studies, such as case-control and cohort studies. It consists of three domains: selection, comparability, and outcome assessment. Each domain is scored as low, moderate, or high risk of bias, based on the information provided in the study. The overall risk of bias is then assessed as low, moderate, or high."
      },
      {
        "source_id": "02035019-dc70-421a-a592-42db43b1e743",
        "citation_number": 13,
        "cited_text": "82 CHAPTER 8 Assessment of risk of bias in included studies 2. Comparability: (maximum two stars) The subjects in different outcome groups are comparable, based on the study design or analysis. 2.1. Confounding factors are controlled. (a) The study controls for the most important factor (select one). * (b) The study controls for any additional factor. * Consider whether the study design or analysis accounts for potential con-founding factors. Controlling for the most important factor helps mini-mize confounding bias. Additional control of other factors increases confidence in the study\u2019s findings. Confounding factors are variables that are associated with both the exposure and outcome and may influence the relationship between them."
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 14,
        "cited_text": "The ROBINS- I (Risk Of Bias In Non- randomized Studies of Interventions) tool was designed specifically to assess risk of bias in NRSIs\u00a0[53]. It examines specific com-ponents of the study design, conduct, analysis, and aspects of reporting (referred to as \u201cbias domains\u201d) and their potential to introduce bias in the estimate of the treatment effect. ROBINS- I approaches assessment of risk of bias in the results of an individual NRSI by comparing it with a \u201ctarget\u201d trial\u00a0\u2013 a hypothetical, pragmatic, and unbiased"
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 15,
        "cited_text": "There are many instances where data from RCTs and NRSIs have produced conflicting results, and where combining these data would have been inappropriate. A striking example of this was a meta- analysis of beta- carotene and the risk of cardiovascular disease described by Egger et\u00a0al. in 1998 (Figure\u00a015.3)\u00a0[47]. Data from NRSIs sug-gested a reduced risk of cardiovascular disease associated with beta- carotene. How-ever, data from RCTs found a harmful effect of beta- carotene. Had only evidence from the NRSIs been available, the lack of heterogeneity in their results might have suggested that increasing beta- carotene would be beneficial. In this example, there are clear differences in the research questions asked by the cohort studies compared with the RCTs. The cohort studies compared groups with high and low beta- carotene dietary intake or serum beta- carotene concentration, whereas the trials examined beta- carotene supplementation. It is difficult to establish from the results in the forest plot whether it was high risk of bias in the cohort studies (or indeed the RCTs) or the differences in the research questions that led to the opposing conclusions from the different designs."
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 16,
        "cited_text": "Systematic Reviews of Diagnostic Accuracy 297 16.1\u2003 RATIONALE\u2003FOR\u00a0UNDERTAKING\u2003SYSTEMATIC\u2003REVIEWS\u2003 OF\u00a0STUDIES\u2003OF\u00a0TEST\u2003ACCURACY Systematic reviews of tests are undertaken for the same reasons as systematic reviews of therapeutic interventions: to produce estimates of performance based on all avail-able evidence, to evaluate the methodological quality of published studies, and to account for variation in findings between studies\u00a0[3, 4]. It is the norm to observe vari-ability in test accuracy between studies that is much more than would be expected due to chance alone. Measures of test accuracy are not fixed properties of a test and are not usually transferable across different populations and settings\u00a0[5]. Other factors may affect test performance, including the threshold for defining a positive versus a nega-tive test result, characteristics of the test and its conduct (including skill and experience of assessors or practitioners), and definition of the target condition. Reviews of diag-nostic test accuracy (DTA) studies, in common with systematic reviews of randomized controlled trials (RCTs), involve key stages of question definition, literature searching, evaluation of studies for eligibility and quality, data extraction, and data synthesis (see Chapter\u00a02). However, the details within many of the stages differ. In particular, the design of test accuracy evaluations differs from the design of studies that evaluate the effectiveness of treatments, which means that different criteria are needed when assessing study quality in terms of the potential for bias and applicability. Additionally, each study reports a pair of related summary statistics (for example, sensitivity and specificity) rather than a single statistic, requiring alternative statistical methods for combining study results."
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 17,
        "cited_text": "16.7\u2003 GENERAL\u2003PRINCIPLES\u2003OF\u00a0DIAGNOSTIC\u2003ACCURACY\u2003 META-\u2003ANALYSIS Diagnostic threshold is often a source of variation in meta- analyses of diagnostic accu-racy because studies included in a systematic review may have used different thresh-olds to define positive and negative test results. Besides numeric thresholds, there may be naturally occurring variations in diagnostic thresholds between observers or bet-ween laboratories. Therefore, a general principle for synthesizing sensitivity and speci-ficity across studies is to allow for potential correlation between these paired measures."
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 18,
        "cited_text": "Sensitivity (95% CI) 0 0.2 0.4 0.6 0.8 1 Specificity (95% CI) 0 0.2 0.4 0.6 0.8 1 FIGURE\u00a016.3 Forest plot of the mood disorder questionnaire for detection of bipolar disorder in mental health center settings. FN,\u00a0false negative; FP, false positive; TN,\u00a0true negative; TP,\u00a0true positive. The studies are sorted by threshold, sensitivity, and specificity in descending order. Source: Adapted from Takwoingi et\u00a0al.\u00a0[24]. Systematic Reviews of Diagnostic Accuracy 305 Traditional univariate fixed- effect or random- effects meta- analytic methods (see Chapter\u00a0 9) summarize sensitivity and specificity separately, thus ignoring potential correlation between the two measures. Such analyses can give misleading results\u00a0[28]. The summary receiver operating characteristic (SROC) curve approach developed by Moses et\u00a0al.\u00a0[29] is a fixed- effect method that accounts for potential heterogeneity in threshold by combining sensitivity and specificity to produce an SROC curve. How-ever, this SROC approach has methodological limitations that lead to inaccurate stan-dard errors, making formal statistical inference invalid\u00a0[30\u201332]."
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 19,
        "cited_text": "To overcome the limitations of simple univariate methods and the Moses SROC approach, hierarchical models (also known as mixed or multilevel models) are rec-ommended\u00a0 [25, 33]. These hierarchical methods are more complex than methods routinely used for synthesizing the effects of interventions. The standard hierar-chical models for meta- analysis of a pair of sensitivity and specificity from each included study are the bivariate model\u00a0 [34, 35] and the hierarchical summary receiver operating characteristic (HSROC) model\u00a0[36]. The bivariate model focuses on estimation of a summary point (summary sensitivity and specificity), while the HSROC model focuses on estimation of a summary curve. Both models account for correlation between sensitivity and specificity across studies, as well as vari-ability within and between studies. Between- study variation is modeled through the inclusion of random effects."
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 20,
        "cited_text": "16.8\u2003 METHODS\u2003FOR\u00a0META-\u2003ANALYSIS\u2003OF\u00a0A\u2003SINGLE\u2003TEST 16.8.1\u00ad Estimation\u00adof\u00a0a\u00adSummary\u00adSensitivity\u00adand\u00a0Specificity\u00ad at\u00ada\u00a0Common\u00adThreshold The bivariate model enables joint inferences about sensitivity and specificity such that confidence and prediction regions can be plotted around the summary point. Confidence regions show the uncertainty around the point estimate (analogous to a confidence interval), while prediction regions illustrate the extent of between- study heterogeneity. This means that a 95% confidence region shows the region within which we are 95% certain the average sensitivity and specificity values will lie, while a 95% prediction region shows the region within which we are 95% certain the sen-sitivity and specificity of a new study will lie. Chu et\u00a0al. have shown that a binomial likelihood should be used for modeling within- study variability\u00a0[35, 60]. This bivar-iate generalized linear mixed model (GLMM) can be fitted in SAS, Stata, R, rjags, and WinBUGS."
      },
      {
        "source_id": "02035019-dc70-421a-a592-42db43b1e743",
        "citation_number": 21,
        "cited_text": "QUADAS-2 The QUADAS-2 (Quality Assessment of Diagnostic Accuracy Studies) tool is a tool for quality assessment of diagnostic tests accuracy studies. It consists of four do-mains related to patient selection, index test, reference standard, and flow and timing. Each domain is scored as low, high, or unclear risk of bias, based on the in-formation provided in the study. In addition, a separate domain is used to assess the applicability of the study to the review question. The QUADAS-2 tool is widely used in systematic reviews and has good inter-rater reliability. However, applying it may be time-consuming and require a detailed understanding of the diagnostic test and the disease being evaluated."
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 22,
        "cited_text": "The most commonly used tool is the Quality Assessment of Diagnostic Accuracy Studies (QUADAS), the more recent version being QUADAS- 2\u00a0 [18, 19]. This is the only tool recommended by Cochrane\u00a0[20]. The QUADAS- 2 tool explicitly addresses two aspects of study validity\u00a0\u2013 risk of bias (internal validity) and applicability (external validity)\u00a0\u2013 and consists of four domains: patient selection, index test, reference stan-dard, and flow and timing. Each domain is assessed in terms of the risk of bias (low, high, or unclear risk), and the first three domains are also assessed in terms of con-cerns about applicability (low, high, or unclear concern)\u00a0 [19]. If a review evaluates more than one index test, the index test domain should be assessed separately for each index test, as there may be differences between tests. Signaling questions that"
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 23,
        "cited_text": "As with any statistical analysis, the first step is to understand the data. Estimates of sensitivity and specificity may be plotted on forest plots and in the ROC space for preliminary investigations of the data prior to meta- analysis. Figure\u00a016.3 shows estimates of sensitivity and specificity at a particular threshold from each of the 30 studies included in a systematic review of the accuracy of the mood disorder question-naire (MDQ) for detection of any type of bipolar disorder in mental health center set-tings\u00a0[26]. The total score for the MDQ ranges from 0 to 15 points and the developers of the questionnaire recommend a threshold of 7 for defining test positivity\u00a0[27]."
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 24,
        "cited_text": "58 12 25 10 19 14 20 20 0 16 63 94 22 FN 6 7 3 28 14 29 3 2 15 24 23 11 13 16 19 16 34 20 42 6 14 11 6 5 42 157 18 11 216 1 TN 32 56 8 223 38 80 63 40 96 24 80 92 210 85 364 24 38 77 40 83 65 89 85 43 48 13 43 211 1084 25 Threshold 8 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 6 6 6 5 5 5 4 4 3 2 Sensitivity (95% CI) 0.91 [0.82, 0.97] 0.88 [0.77, 0.95] 0.85 [0.62, 0.97] 0.80 [0.72, 0.86] 0.74 [0.60, 0.85] 0.73 [0.64, 0.81] 0.73 [0.39, 0.94] 0.71 [0.29, 0.96] 0.71 [0.56, 0.83] 0.70 [0.59, 0.80] 0.68 [0.57, 0.79] 0.67 [0.48, 0.82] 0.64 [0.46, 0.79] 0.64 [0.48, 0.78] 0.63 [0.49, 0.76] 0.57 [0.39, 0.73] 0.45 [0.32, 0.58] 0.43 [0.26, 0.61] 0.29 [0.18, 0.42] 0.00 [0.00, 0.46] 0.85 [0.77, 0.92] 0.76 [0.61, 0.87] 0.75 [0.53, 0.90] 0.67 [0.38, 0.88] 0.63 [0.53, 0.72] 0.54 [0.49, 0.59] 0.71 [0.59, 0.82] 0.65 [0.45, 0.81] 0.30 [0.25, 0.36] 0.83 [0.36, 1.00]"
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 25,
        "cited_text": "Using HSROC meta- regression, Carvalho et\u00a0al. investigated the effect of language (Asian versus non- Asian) on the accuracy of the MDQ by comparing SROC curves for the two subgroups of the covariate in one HSROC model\u00a0[26]. By including covariate terms for only the accuracy and threshold parameters, the final model assumed the same shape for the two SROC curves. The RDOR (95% CI) of 0.55 (0.25 to 1.19) indicated that the DOR of Asian versions of the MDQ was 0.55 times that of the non- Asian ver-sions, though there was little statistical evidence of a difference in accuracy (P\u00a0=\u00a00.13)."
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 26,
        "cited_text": "The indirect comparison of BSDS, HCL- 32, and MDQ included 44 studies. The effect of test type on the accuracy, threshold, and shape parameters of the model was assessed\u00a0[26]. Using a likelihood ratio test to compare models with and without covari-ate terms for the shape parameter, there was statistical evidence that the shapes of the SROC curves differed (P\u00a0=\u00a00.002). Figure\u00a016.8 (panel a) shows that the SROC curves for the three tests cross, implying that one test is not consistently more accurate than the other two. Therefore, the RDOR cannot be used to quantify relative accuracy. This is also evident in Table\u00a016.4, which shows the sensitivities estimated from the curves at the median, lower, and upper quartiles of the observed specificities in the included studies. The direct comparison of the MDQ and HCL- 32\u00a0included only eight studies (panel b). Three studies directly compared the BSDS and MDQ, but no study directly compared the HCL- 32 and BSDS in a mental health setting."
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 27,
        "cited_text": "1 0.9 0.8 (a) Indirect comparison Direct comparison(b) 0.7 0.6 0.5 S en si tiv ity 0.4 0.3 0.2 0.1 0 1 0.9 0.8 0.7 0.6 0.5 S en si tiv ity 0.4 0.3 0.2 0.1 0 1 0.9 0.8 0.7 0.6 0.5 Specificity Legend LegendBipolar spectrum diagnostic scale Hypomania checklist (HCL-32) Mood disorder questionnaire Mood disorder questionnaireHypomania checklist (HCL-32) 0.4 0.3 0.2 0.1 0 1 0.9 0.8 0.7 0.6 0.5 Specificity 0.4 0.3 0.2 0.1 0 FIGURE\u00a016.8 Comparison of summary curves. Panel a shows the indirect comparison of the three tests, while panel b shows the direct comparison of two of the tests. For each test on an SROC plot, each symbol represents the pair of sensitivity and specificity from a study. The size of each symbol was scaled according to the precision of sensitivity and specificity in the study. Each summary curve was drawn restricted to the range of specificities from the included studies for the test. In panel b, the pair of points from each comparative study is connected by a dotted line. BSDS,\u00a0bipolar spectrum diagnostic scale; HCL- 32,\u00a0hypomania checklist; MDQ,\u00a0mood disorder questionnaire. Source: Adapted from Carvalho et\u00a0al.\u00a0[26] and Takwoingi\u00a0[71]."
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 28,
        "cited_text": "Systematic Reviews of Diagnostic Accuracy 309 plots to observe patterns in the data. Ideally, covariates should be pre- specified in the review protocol with a clear justification for their selection (see Chapter\u00a010). Hierar-chical models are regression models and so can be extended readily to meta- regression models by adding covariate terms to investigate association between test accuracy and a potential source of heterogeneity\u00a0[34, 36]. 16.9.1\u00ad Comparison\u00adof\u00a0Summary\u00adPoints The bivariate meta- regression model enables assessment of the effect of covari-ates on sensitivity, specificity, or both. Kay et\u00a0 al. used bivariate meta- regression to investigate the effect of age group on the sensitivity and specificity of Xpert MTB/ RIF (Figure\u00a0 16.6)\u00a0 [22]. There was statistical evidence of a difference in sensitivity but not in specificity (Table\u00a0 16.2). Comparing children aged 5\u201314 years with those"
      },
      {
        "source_id": "96ca5d5f-f3f5-4d69-b3f9-63938684ffcc",
        "citation_number": 29,
        "cited_text": "Study Bunyasi 2015 Rachow 2012 Chisti 2014 Nicol 2011 Zar 2012 Sekadde 2013 LaCourse 2014 TP 7 2 2 2 45 10 2 FP 0 1 14 0 2 4 1 FN 24 6 3 3 32 5 0 TN 908 37 192 12 328 123 297 Sensitivity (95% CI) 0.23 [0.10, 0.41] 0.25 [0.03, 0.65] 0.40 [0.05, 0.85] 0.40 [0.05, 0.85] 0.58 [0.47, 0.70] 0.67 [0.38, 0.88] 1.00 [0.16, 1.00] Specificity (95% CI) 1.00 [1.00, 1.00] 0.97 [0.86, 1.00] 0.93 [0.89, 0.96] 1.00 [0.74, 1.00] 0.99 [0.98, 1.00] 0.97 [0.92, 0.99] 1.00 [0.98, 1.00] Sensitivity (95% CI) 0 0.2 0.4 0.6 0.8 1"
      }
    ]
  }
}
