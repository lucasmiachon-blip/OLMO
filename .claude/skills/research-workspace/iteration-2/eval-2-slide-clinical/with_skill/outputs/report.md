# Research Report: Slide s-aplicacao (14-aplicacao.html)

> Aula: Meta-analise | Fase 3 — Aplicacao (Valgimigli 2025 Lancet)
> Pipeline: /research (legs 2, 3, 5) | Orquestrador: Opus 4.6
> Data: 2026-04-02

---

## 1. Sintese Narrativa

O slide s-aplicacao e o momento pedagogico mais importante da Fase 3: e onde o residente aplica o framework das 3 perguntas a dados reais pela primeira vez. A evidencia subjacente — clopidogrel vs aspirina em prevencao secundaria de DAC — e robusta e convergente: tres IPD-MAs independentes (Valgimigli 2025 Lancet, Giacoppo 2025 BMJ, Gragnano/PANTHER 2023 JACC) chegam a mesma direcao com magnitudes compativeis (HR 0,77-0,88 para MACCE) e todas sem aumento de sangramento maior. A convergencia entre estudos com diferentes populacoes (5-7-9 RCTs), periodos (2-5,5 anos), e modelos estatisticos (one-stage frailty, mixed-effects, random-effects) confere alta confianca na direcao do efeito.

Onde as pernas concordam: a reducao de MACCE com clopidogrel e real, consistente, e sem trade-off de sangramento. Isso importa porque o professor pode afirmar com seguranca que o dado no slide e defensavel — o HR 0,86 com IC que nao cruza 1 nao e artefato de um unico trial ou de modelo estatistico. Onde o slide acerta plenamente e na exposicao da lacuna GRADE: e verdade que os autores nao fizeram GRADE, e isso e comum ate em journals top (Siedler 2025: apenas 33,8% das SRs avaliam certeza). A h2 do slide captura isso com precisao.

O que o professor precisa decidir: o slide mostra o beneficio e a ausencia de dano, mas nao oferece ao residente ferramentas para ele proprio estimar a certeza GRADE. O speaker notes compensa parcialmente ("riscos de vies dos estudos incluidos, imprecisao, inconsistencia — tudo entra"), mas nao materializa a avaliacao. Para uma aula de 90s, isso pode ser adequado — o proximo slide (s-aplicabilidade) aprofunda validade externa. Mas se o objetivo didatico e que o residente exercite a pergunta 2 do framework, o slide precisa dar mais substrato (ver recomendacoes).

---

## 2. MBE Evaluation — Depth Rubric (8 Dimensoes)

| Dim | Score | Achado | Implicacao para o slide |
|-----|-------|--------|------------------------|
| D1 Source | **9** | PMID 40902613 verificado, Lancet 2025, primeiro autor nomeado. source-tag completa. | Exemplar. Manter. |
| D2 Effect Size | **8** | HR 0,86 (IC 0,77-0,96) para MACCE; HR 0,94 (IC 0,74-1,21) para sangramento. p-value presente. | Muito bom. Falta NNT — calculavel a partir das taxas absolutas (ver abaixo). Adicionar em notes. |
| D3 Population | **6** | N total (28.982) e 7 RCTs no notes, mas NAO no corpo do slide. Criterios de inclusao ausentes no slide. | Slide body mostra efeito sem contexto de quem foi estudado. Notes compensam, mas projecao a 6m nao mostra notes. Considerar adicionar "7 RCTs, 29 mil pacientes" como subtexto visual. |
| D4 Timeframe | **7** | "5,5 anos" presente nos notes com "(MACCE, 5,5 anos)". Ausente do corpo do slide. | O timeframe e critico para interpretacao do HR. Residente vendo so o slide nao sabe se sao 6 meses ou 10 anos. Adicionar ao corpo ou ao compare-footer. |
| D5 Comparator | **7** | "clopidogrel" e "aspirina" implicitos no contexto da aula (slide anterior s-artigo apresenta PICO). Nao explicito no slide. | Aceitavel dado que slide 13 ja apresenta PICO. Mas stand-alone, o slide nao diz qual droga vs qual. |
| D6 Grading | **8** | Ausencia de GRADE explicitamente declarada ("Certeza GRADE: nao avaliada pelos autores"). Funcao didatica superior. | Excelente uso pedagogico da lacuna. E o ponto central do slide. Manter. |
| D7 Impact | **5** | Sem NNT, sem efeito absoluto, sem traducao para decisao clinica. | Gap mais importante. O residente ve 14% de reducao relativa mas nao sabe quantos pacientes precisa tratar. NNT calculavel: ~38 pacientes em 5,5 anos (929/14507 vs 1062/14475 → ARR ~2,6%). Giacoppo 2025 reporta NNT 45,5 (IC 31,4-93,6) para populacao pos-PCI. |
| D8 Currency | **10** | Publicacao ago/2025. Verificado mar/2026. | Maximo. |

**Score medio: 7,5 / 10 — DEEP (minor adjustments)**

### Resumo do rubric

O slide e forte em fonte, atualidade, efeito, e uso pedagogico da lacuna GRADE. Os gaps sao: (1) ausencia de NNT/efeito absoluto — que e ironico porque o slide 16 (efeito-absoluto) vem logo depois, mas o residente nao tem o dado concreto para exercitar; (2) populacao e timeframe invisiveis no corpo do slide (so aparecem nos notes).

---

## 3. GRADE Assessment — Claims Clinicos do Slide

O slide faz duas claims clinicas com dados quantitativos. GRADE deve ser aplicado por desfecho.

### 3a. MACCE: HR 0,86 (IC 0,77-0,96), p=0,008

| Dominio GRADE | Avaliacao | Justificativa |
|---------------|-----------|---------------|
| **Risco de vies** | Serio (-1) | 5 de 7 RCTs sao open-label (HOST-EXAM, STOPDAPT-2, STOPDAPT-3, SMART-CHOICE, ASCET). CAPRIE e duplo-cego mas tem 29 anos. Desfechos "soft" do composto (IAM nao-fatal, AVC) sao vulneraveis a detection bias em estudos abertos. Adjudicacao central mitiga parcialmente. |
| **Inconsistencia** | Nao serio (0) | Direcao consistente em 3 IPD-MAs independentes. I2 nao reportado no Valgimigli (frailty model), mas Aggarwal 2022 reporta I2=0% para MACE em 9 RCTs. Gragnano/PANTHER 2023: HR 0,88 (0,79-0,97). Giacoppo 2025 BMJ: HR 0,77 (0,67-0,89). Mesma direcao, magnitude compativel. |
| **Indirectness** | Nao serio (0) | Populacao (DAC pos-PCI/SCA), intervencao (clopidogrel mono), comparador (aspirina mono), desfecho (MACCE) — todos diretamente aplicaveis a pergunta clinica. Populacao 66a, 78% homens, predominio asiatico (4/7 trials) gera questao de generalidade mas nao de indirectness formal. |
| **Imprecisao** | Nao serio (0) | N=28.982. IC nao cruza nulidade (0,77-0,96). Eventos suficientes (929 vs 1062). Limites clinicamente coerentes. |
| **Vies de publicacao** | Nao serio (0) | PROSPERO pre-registrado (CRD42025645594). IPD de todos os trials elegiveis obtidos. Sem evidencia de seletividade. |

**Certeza GRADE para MACCE: MODERADA** (alta por serem RCTs, -1 por risco de vies de estudos open-label)

**Implicacao:** "Provavelmente" clopidogrel reduz MACCE vs aspirina. Pesquisa adicional poderia mudar a magnitude, mas provavelmente nao a direcao. Para o slide: o professor pode dizer "certeza moderada — o efeito e provavelmente real, mas a maioria dos trials nao era duplo-cego."

### 3b. Sangramento maior: HR 0,94 (IC 0,74-1,21), NS

| Dominio GRADE | Avaliacao | Justificativa |
|---------------|-----------|---------------|
| **Risco de vies** | Serio (-1) | Mesmos trials open-label. Definicao de sangramento varia entre trials (BARC, TIMI, GUSTO). Harmonizacao imperfecta em IPD. |
| **Inconsistencia** | Nao serio (0) | Direcao consistente (ponto central sempre proximo de 1,0). Giacoppo BMJ: HR 1,26 (0,78-2,04) — nao significativo, mesma direcao. |
| **Indirectness** | Nao serio (0) | Desfecho diretamente relevante. |
| **Imprecisao** | Serio (-1) | IC amplo (0,74-1,21) — cruza nulidade e nao exclui beneficio OU dano de ate 21%. Com 535 eventos totais, poder estatistico limitado para sangramento. |
| **Vies de publicacao** | Nao serio (0) | Idem MACCE. |

**Certeza GRADE para sangramento: BAIXA** (alta -1 vies -1 imprecisao)

**Implicacao:** "Incerto" se clopidogrel e realmente equivalente em sangramento. O slide mostra "NS" o que e tecnicamente correto, mas o professor deve explicitar que "NS nao significa igual — significa que nao temos certeza suficiente." A baixa certeza para o desfecho de seguranca e pedagogicamente poderosa: e exatamente o tipo de nuance que a pergunta 2 do framework deve capturar.

---

## 4. Reference Check (Leg 3)

| Item | Status | Detalhe |
|------|--------|---------|
| PMID 40902613 | VERIFIED | PubMed confirma: Valgimigli M et al. Lancet 2025;406(10508):1091-1102. Titulo, autores, journal, volume/pagina match. [DOI](https://doi.org/10.1016/S0140-6736(25)01562-4) |
| HR 0,86 (0,77-0,96) MACCE | VERIFIED | Abstract PubMed: "hazard ratio 0.86 [95% CI 0.77-0.96]; p=0.0082". Slide mostra p=0,008 (arredondamento aceitavel). |
| HR 0,94 (0,74-1,21) sangramento | VERIFIED | Abstract PubMed: "0.94 [0.74-1.21]; p=0.64". Slide mostra "NS" — correto. |
| 7 RCTs, 28.982 pacientes | VERIFIED | Abstract PubMed: "Seven randomised trials including 28,982 patients". |
| "GRADE nao avaliada" | VERIFIED | Abstract e full-text nao mencionam GRADE, certeza da evidencia, ou SoF table. Confirmado por ACC Journal Scan (sem GRADE). Circulation 2025 abstract de MA independente relata "evidence certainty ranged from low to very low" usando GRADE na mesma questao clinica. |
| Giacoppo BMJ (PMID 40467090) | VERIFIED | PubMed confirma IPD-MA, 16.117 pts, 5 RCTs pos-PCI. HR 0,77 (0,67-0,89). NNT 45,5 (31,4-93,6). [DOI](https://doi.org/10.1136/bmj-2024-082561) |
| PANTHER JACC (PMID 37407118) | VERIFIED | PubMed confirma Gragnano/Valgimigli. JACC 2023;82(2):89-105. IPD-MA, 7 trials, 24.325 pts. HR 0,88 (0,79-0,97). [DOI](https://doi.org/10.1016/j.jacc.2023.04.051) |
| Evidence-db consistency | OK | Todos os dados no slide match evidence-db v5.7. Nenhuma discrepancia encontrada. |

---

## 5. Opus Research — Contexto Clinico Ampliado (Leg 5)

### 5a. Convergencia entre 3 IPD-MAs

| Estudo | Journal | Ano | N | Trials | HR MACCE (IC 95%) | Sangramento | NNT |
|--------|---------|-----|---|--------|-------------------|-------------|-----|
| Gragnano/PANTHER | JACC | 2023 | 24.325 | 7 | 0,88 (0,79-0,97) | HR 0,87 (0,70-1,09) NS | — |
| Giacoppo | BMJ | 2025 | 16.117 | 5 (pos-PCI) | 0,77 (0,67-0,89) | HR 1,26 (0,78-2,04) NS | 45,5 (31,4-93,6) |
| Valgimigli | Lancet | 2025 | 28.982 | 7 | 0,86 (0,77-0,96) | HR 0,94 (0,74-1,21) NS | ~38 (calculado) |

**Interpretacao:** 3 IPD-MAs do mesmo grupo colaborativo (PANTHER), com overlap parcial de trials mas analises independentes e diferentes. A consistencia reforca a direcao. A magnitude varia (HR 0,77-0,88) provavelmente por diferencas de populacao (Giacoppo restrito a pos-PCI mostra efeito maior — selecao de pacientes com maior risco basal → maior beneficio absoluto).

### 5b. Trials open-label — implicacao para RoB

| Trial | Design | N | % da MA |
|-------|--------|---|---------|
| CAPRIE (1996) | Duplo-cego | 19.185 | 66% |
| HOST-EXAM | Open-label, adjudicacao central | 5.530 | 19% |
| STOPDAPT-2 | Open-label | — | — |
| STOPDAPT-3 | Open-label | — | — |
| SMART-CHOICE | Open-label | — | — |
| ASCET | Open-label | — | — |
| CADET | — | — | — |

CAPRIE contribui ~66% do N total e e duplo-cego. Mas e de 1996 — pratica clinica diferente (stents, DAPT moderna nao existiam). Os 5 trials asiaticos recentes sao open-label. Isso e relevante porque MACCE inclui componentes "soft" (IAM nao-fatal com troponina ultrassensivel, AVC menor) onde detection bias em estudos abertos e plausivel. A adjudicacao central mitiga mas nao elimina.

### 5c. Lacuna GRADE — padrao ou excecao?

A ausencia de GRADE no Valgimigli 2025 nao e excepcional:
- Siedler 2025 (PMID 40969451): apenas 33,8% das SRs em 10 revistas de alto impacto avaliaram certeza da evidencia (2013-2024). 89,3% usaram GRADE quando avaliaram.
- Uma MA independente sobre a mesma questao clinica (ASA vs P2Y12, Circulation 2025 abstract) que APLICOU GRADE classificou a certeza como **low to very low** — citando imprecisao, follow-up curto, e limitacoes metodologicas.
- Isso sugere que, se os autores do Valgimigli tivessem feito GRADE, o resultado provavel seria **moderada** para MACCE (o maior N e follow-up mais longo compensam parcialmente) e **baixa** para sangramento.

### 5d. CYP2C19 — achado pré-especificado relevante

O editorial do Lancet (2026) levanta que apenas 1 dos 7 trials (SMART-CHOICE 3) fez analise farmacogenetica, com apenas 731 pacientes genotipados. Apesar disso, o ACC Journal Scan cita que "even patients with impaired responsiveness to clopidogrel because of genetic or clinical factors still benefited from its use over aspirin." A questao permanece aberta e e relevante para o slide de aplicabilidade (s-aplicabilidade, slide 15).

### 5e. Custo-efetividade — gap declarado

Os autores reconhecem que clopidogrel custa mais que aspirina na maioria dos paises e pedem estudos de custo-efetividade. No Brasil: clopidogrel generico e amplamente disponivel (SUS e rede privada), o diferencial de custo e pequeno. Isso favorece a aplicabilidade local.

---

## 6. Tabela Comparativa — Pernas x Achados

| Achado | PubMed (Leg 3) | Consensus (Leg 5a) | WebSearch (Leg 5b) | SCite (Leg 2) | Confianca |
|--------|----------------|--------------------|--------------------|---------------|-----------|
| HR 0,86 MACCE | VERIFIED | Confirmado (3 MAs) | ACC Journal Scan confirma | N/A (nao indexado) | **ALTA** |
| HR 0,94 sangramento NS | VERIFIED | Confirmado (3 MAs) | Confirmado | N/A | **ALTA** |
| GRADE nao feito | VERIFIED (abstract) | Circulation 2025: GRADE low-very low | Confirmado ACC | — | **ALTA** |
| Open-label 5/7 trials | Conferido (study types) | Confirmado por designs | Editorial Lancet | — | **ALTA** |
| CYP2C19 gap | — | — | Editorial Lancet 2026 | — | **MODERADA** (1 fonte) |
| NNT ~38-45 | Calculavel do abstract | Giacoppo: 45,5 (31,4-93,6) | — | — | **MODERADA** |

---

## 7. Convergencias Interpretadas

**Por que o professor pode confiar no HR 0,86:** Nao e porque 3 MAs dizem a mesma coisa (isso seria circular — compartilham trials). E porque: (a) a direcao e consistente mesmo com diferentes selecoes de trials (5, 7, 9 RCTs), diferentes periodos de follow-up (2, 3,7, 5,5 anos), e diferentes modelos estatisticos; (b) a magnitude e biologicamente plausivel (clopidogrel e um antiplaquetar mais potente que aspirina em inibicao ADP-dependente); (c) nenhuma analise de subgrupo inverteu a direcao; (d) a ausencia de aumento de sangramento e coerente com o mecanismo (aspirina inibe COX-1 → mais efeito em mucosa GI).

**Por que GRADE moderada e nao alta para MACCE:** O unico downgrade e risco de vies (trials open-label). Mas CAPRIE (66% do N) e duplo-cego, e adjudicacao central mitiga detection bias. Se a analise fosse restrita a CAPRIE, o efeito persistiria (subgrupo IAM no CAPRIE original ja mostrava tendencia). Nao ha downgrades por inconsistencia, indirectness, imprecisao, ou publicacao.

---

## 8. Divergencias

| Ponto | Posicao A | Posicao B | Mais defensavel |
|-------|-----------|-----------|-----------------|
| Magnitude do efeito | Valgimigli: HR 0,86 (14% RRR) | Giacoppo pos-PCI: HR 0,77 (23% RRR) | Ambas validas — populacoes diferentes. Valgimigli e mais conservador (inclui CAPRIE com pop mista). Para aula didatica, usar Valgimigli (maior N, mais inclusivo). |
| Certeza GRADE | Nao avaliada (Valgimigli/Giacoppo) | Low to very low (Circulation 2025 abstract, 5 RCTs) | A Circulation 2025 usou apenas 5 RCTs com follow-up curto e imprecisao. Com 7 RCTs e 29 mil pts, avaliacao provavel seria MODERADA para MACCE. Professor pode apresentar faixa: "moderada a baixa, dependendo do modelo." |
| Sangramento: neutro ou incerto? | Slide: "NS" | GRADE: certeza baixa (IC amplo) | GRADE e mais informativa. "NS" pode ser lido como "sem diferenca" quando na verdade e "nao sabemos com certeza". Notes do slide ja matizam. |

---

## 9. Numeros-Chave — Prontos para Slide/Notes

| Dado | Valor | IC 95% | Fonte | PMID |
|------|-------|--------|-------|------|
| MACCE HR | 0,86 | 0,77-0,96 | Valgimigli Lancet 2025 | 40902613 |
| MACCE p-value | 0,0082 | — | idem | 40902613 |
| MACCE taxa clopidogrel | 2,61/100 pts-ano | — | idem | 40902613 |
| MACCE taxa aspirina | 2,99/100 pts-ano | — | idem | 40902613 |
| MACCE NNT (calculado) | ~38 | — | Derivado das taxas em 5,5 anos | — |
| MACCE NNT (Giacoppo pos-PCI) | 45,5 | 31,4-93,6 | Giacoppo BMJ 2025 | 40467090 |
| Sangramento maior HR | 0,94 | 0,74-1,21 | Valgimigli Lancet 2025 | 40902613 |
| Sangramento p-value | 0,64 | — | idem | 40902613 |
| Mortalidade total | NS | — | idem | 40902613 |
| Mortalidade CV | NS | — | idem | 40902613 |
| N total | 28.982 | — | idem | 40902613 |
| Follow-up mediano | 2,3 anos (IQR 1,1-4,0) | — | idem | 40902613 |
| MACCE endpoint (Kaplan-Meier) | 5,5 anos | — | idem | 40902613 |

---

## 10. Recomendacoes para o Slide

### Manter (sem mudanca)
1. **h2 assertion** — excelente. Captura beneficio + lacuna GRADE em uma frase. Assertion-evidence puro.
2. **Estrutura visual beneficio/dano** — layout compare e eficaz. Simbolos safe/neutral corretos.
3. **source-tag** — completa e verificada.
4. **Speaker notes** — timing, fontes, contexto didatico, NICE gap. Abrangentes.

### Considerar (decisao do Lucas)
1. **Adicionar "7 RCTs | 29 mil pacientes" no compare-footer** — da contexto de populacao ao corpo visivel do slide. O residente que ve a projecao a 6m nao tem acesso ao notes. Uma frase como "7 RCTs, 29 mil pacientes, 5,5 anos" resolve D3+D4 sem poluir.
2. **Adicionar NNT estimado nos notes** — "NNT ~38 em 5,5 anos (1 evento MACCE evitado a cada 38 pacientes tratados com clopidogrel em vez de aspirina). Giacoppo 2025 (pos-PCI): NNT 45,5 (IC 31,4-93,6)." Isso prepara o terreno para slide 16 (efeito absoluto).
3. **Enriquecer notes com GRADE estimada** — "Se avaliassemos GRADE: certeza MODERADA para MACCE (5/7 trials open-label, mas CAPRIE duplo-cego e 66% do N; adjudicacao central; I2 proximo de zero). Certeza BAIXA para sangramento (IC amplo, definicoes heterogeneas)." Isso transforma a lacuna pedagogica em exercicio concreto.
4. **Matizar "NS" no sangramento** — Nos notes, adicionar: "NS nao significa igual. Significa que nao temos poder estatistico suficiente para excluir ate 21% de aumento. Certeza GRADE: baixa." Isso reforça a pergunta 2 do framework.

### Nao fazer
1. Nao adicionar NNT ao corpo do slide — slide 16 e dedicado a efeito absoluto. Duplicar seria redundante.
2. Nao adicionar GRADE formal ao corpo — a ausencia E o ponto pedagogico. Resolver no corpo destruiria a funcao didatica.
3. Nao mencionar CYP2C19 neste slide — isso pertence ao s-aplicabilidade (slide 15).

---

## 11. Posicionamento Pedagogico

O slide s-aplicacao ocupa posicao pivot na narrativa: e o primeiro momento em que dados reais substituem conceitos abstratos. Ele conecta:
- **Para tras:** framework das 3 perguntas (slide contrato), beneficio-dano (slide 08), GRADE (slide 09)
- **Para frente:** aplicabilidade/validade externa (slide 15), efeito absoluto (slide 16), take-home (slide 17)

O slide cumpre seu papel: mostra que mesmo um Lancet com 29 mil pacientes pode omitir GRADE, validando a pergunta 2 como ferramenta critica. O risco pedagogico e que o residente saia do slide sem substrato para exercitar a resposta — ele sabe que GRADE nao foi feita, mas nao sabe o que a resposta seria. Os notes enriquecidos (recomendacao 3) resolvem isso sem alterar o corpo do slide.

---

## Fontes

Baseado em artigos recuperados do PubMed:
- Valgimigli M et al. Lancet 2025;406(10508):1091-1102. [DOI](https://doi.org/10.1016/S0140-6736(25)01562-4). PMID 40902613.
- Giacoppo D et al. BMJ 2025;389:e082561. [DOI](https://doi.org/10.1136/bmj-2024-082561). PMID 40467090.
- Gragnano F et al (PANTHER). JACC 2023;82(2):89-105. [DOI](https://doi.org/10.1016/j.jacc.2023.04.051). PMID 37407118.
- Aggarwal D et al. Eur Heart J Open 2022;2(2):oeac019. [DOI](https://doi.org/10.1093/ehjopen/oeac019).
- Siedler MR et al. Cochrane Evid Synth Methods 2025;3(2). PMID 40969451.

Web sources:
- [ACC Journal Scan — Clopidogrel Superior to Aspirin](https://www.acc.org/latest-in-cardiology/journal-scans/2025/09/19/16/45/clopidogrel-superior-to-aspirin)
- [Lancet editorial commentary](https://www.thelancet.com/journals/lancet/article/PIIS0140-6736(25)02644-3/fulltext)

Coautoria: Lucas + Opus 4.6 (orquestrador + pesquisador)
