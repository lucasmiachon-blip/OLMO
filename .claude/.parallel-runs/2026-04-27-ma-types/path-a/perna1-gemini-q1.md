As meta-análises diferem profundamente dependendo do design dos estudos primários incluídos. Isso ocorre porque o delineamento do estudo dita a natureza dos dados extraídos, as fontes de viés esperadas e, consequentemente, os métodos estatísticos e ferramentas de avaliação de qualidade necessários.

Abaixo, detalhamos as diferenças cruciais entre as meta-análises de **Ensaios Clínicos Randomizados (RCTs)**, **Estudos Observacionais/Coortes** e **Acurácia Diagnóstica (DTA)**.

---

### 1. Meta-análise de Ensaios Clínicos Randomizados (RCT Clássica)
Essas meta-análises avaliam a **eficácia e segurança de intervenções**. Por basearem-se em estudos randomizados, assumem alta validade interna e menor confusão basal.

*   **Premissas Estatísticas e Heterogeneidade:**
    *   **Efeito Fixo vs. Aleatório (Random-effects):** Podem utilizar o modelo de efeitos fixos (assume que todos os estudos compartilham um único efeito verdadeiro) se os RCTs forem muito homogêneos. No entanto, o **modelo de efeitos aleatórios (random-effects)** é geralmente preferido, pois assume que os efeitos verdadeiros variam numa distribuição normal (devido a diferenças de dose, tempo, características da população).
    *   **Heterogeneidade:** Avaliada classicamente pelo Teste Q de Cochran e pela estatística **$I^2$** (percentual de variação devido à heterogeneidade em vez do acaso).
    *   **Síntese:** Utiliza dados brutos (eventos/total ou médias/desvios-padrão) para calcular Risco Relativo (RR), Odds Ratio (OR) ou Diferença de Médias (MD).
*   **Ferramenta de Risco de Viés (RoB):**
    *   **Cochrane RoB-2 (Risk of Bias 2):** Avalia 5 domínios rigorosos: viés no processo de randomização, desvios das intervenções pretendidas, dados faltantes, mensuração do desfecho e seleção do resultado relatado. O estudo é classificado como "Baixo Risco", "Algumas Preocupações" ou "Alto Risco".
*   **Exemplos Seminais:**
    1.  *Antenatal corticosteroids for accelerating fetal lung maturation* (Crowley et al., 1990): Comprovou a redução da mortalidade neonatal. O gráfico de *forest plot* desta meta-análise **inspirou o logotipo da The Cochrane Collaboration**.
    2.  *Antithrombotic Trialists' Collaboration (2002):* Consolidou o uso da aspirina e outros antiplaquetários na prevenção secundária de eventos cardiovasculares, agrupando dados de mais de 100.000 pacientes de diversos RCTs.

---

### 2. Meta-análise de Estudos de Coorte / Observacionais
Estas meta-análises investigam **etiologia, fatores de risco, prognóstico e danos (harms)**, onde a randomização é impossível, antiética ou impraticável.

*   **Premissas Estatísticas e Heterogeneidade:**
    *   **Modelos de Efeitos Aleatórios (Random-effects):** É praticamente **obrigatório**. A heterogeneidade metodológica, clínica e demográfica entre estudos observacionais é inerentemente alta.
    *   **Uso de Medidas Ajustadas:** Ao contrário dos RCTs, onde se extraem os eventos brutos, em meta-análises observacionais **não se deve agrupar dados brutos**. O pesquisador deve extrair os *Hazard Ratios* (HR), OR ou RR **ajustados multivariadamente** pelos autores primários para controlar variáveis de confusão (confounders).
    *   **Exploração de Heterogeneidade:** O $I^2$ costuma ser alto. Exige-se forte dependência de *meta-regressão* e análises de subgrupos para entender por que os estudos variam tanto (ex: diferenças no tempo de seguimento).
*   **Ferramenta de Risco de Viés (RoB):**
    *   **Newcastle-Ottawa Scale (NOS):** A ferramenta mais tradicional. Avalia 3 domínios: **Seleção** (representatividade da coorte), **Comparabilidade** (controle de variáveis de confusão) e **Desfecho** (follow-up e mensuração). Estudos recebem "estrelas" (até 9).
    *   *(Nota: Atualmente, a Cochrane recomenda a ferramenta **ROBINS-I**, que é mais complexa e avalia o estudo observacional como se tentasse emular um ensaio clínico hipotético).*
*   **Exemplos Seminais:**
    1.  *Global BMI Mortality Collaboration (2016):* Meta-análise monumental de dados de participantes individuais (IPD) de 239 coortes prospectivas, estabelecendo a associação curva em J (ou U) entre Índice de Massa Corporal (IMC) e mortalidade por todas as causas.
    2.  *Hackshaw et al. (1997) - Fumo passivo e câncer de pulmão:* Uma meta-análise clássica de estudos observacionais que ajudou a solidificar políticas públicas contra o tabagismo em locais fechados.

---

### 3. Meta-análise de Acurácia Diagnóstica (DTA - Diagnostic Test Accuracy)
Essas meta-análises avaliam o desempenho de um **Teste Índice** comparado a um **Padrão de Referência (Gold Standard)**. O foco não é efeito de intervenção, mas identificação correta de doenças.

*   **Premissas Estatísticas e Heterogeneidade:**
    *   **Abordagem Bivariada (Bivariate / Hierarchical Models):** Esta é a maior diferença estatística. Sensibilidade e Especificidade são propriedades interligadas; quando um limiar de teste muda (threshold effect), a sensibilidade sobe e a especificidade desce. **Não se pode meta-analisar sensibilidade e especificidade de forma isolada/univariada.**
    *   Utiliza-se o **Modelo de Efeitos Aleatórios Bivariado** ou o modelo **HSROC** (Hierarchical Summary Receiver Operating Characteristic) para gerar uma curva ROC resumida e calcular pontos de acurácia global.
    *   **Heterogeneidade:** O $I^2$ **não** deve ser usado. A heterogeneidade é assumida como o padrão na DTA devido ao "efeito de limiar" e variabilidade clínica do teste.
*   **Ferramenta de Risco de Viés (RoB):**
    *   **QUADAS-2 (Quality Assessment of Diagnostic Accuracy Studies):** É o padrão absoluto. Avalia os estudos em 4 domínios: **Seleção de Pacientes, Teste Índice, Padrão de Referência e Fluxo/Tempo** (se todos os pacientes receberam os testes no mesmo intervalo).
    *   *Peculiaridade do QUADAS-2:* Ele divide a avaliação em **"Risco de Viés"** e **"Preocupações com a Aplicabilidade"** (ex: o estudo avaliou pacientes graves num hospital, mas queremos saber se o teste funciona na atenção primária).
*   **Exemplos Seminais:**
    1.  *D-dímero para trombose venosa profunda e embolia pulmonar (Stein et al., 2004 / Di Nisio et al., 2007):* Estabeleceu que o D-dímero tem altíssima sensibilidade e valor preditivo negativo (VPN), servindo para exclusão da doença, mas especificidade moderada.
    2.  *Testes Rápidos de Antígeno para COVID-19 (Dinnes et al. - Cochrane, 2021):* Meta-análise crítica durante a pandemia que utilizou modelos HSROC para definir a acurácia dos testes de antígeno variando de acordo com a presença de sintomas e dias do início da doença.

### Resumo Comparativo

| Característica | RCT Clássica | Coorte / Observacional | Acurácia Diagnóstica (DTA) |
| :--- | :--- | :--- | :--- |
| **Objetivo** | Eficácia e Segurança | Causas, Fatores de risco, Prognóstico | Desempenho de exames (Sens/Espec) |
| **Métrica Agrupada** | OR, RR, HR, MD (dados brutos preferíveis) | HR, OR, RR **(ajustados)** | Sensibilidade, Especificidade, Likelihood Ratio |
| **Modelo Estatístico** | Efeitos Fixos ou Aleatórios (Univariado) | Efeitos Aleatórios (Univariado) | **Bivariado** (HSROC) |
| **Avaliação da Heterogeneidade** | $I^2$, Cochran Q | Meta-regressão fortemente necessária | Efeito de limiar (Threshold effect); $I^2$ não é útil |
| **Ferramenta de Viés** | **RoB-2** (Cochrane) | **Newcastle-Ottawa** / ROBINS-I | **QUADAS-2** (Avalia viés + aplicabilidade) |
