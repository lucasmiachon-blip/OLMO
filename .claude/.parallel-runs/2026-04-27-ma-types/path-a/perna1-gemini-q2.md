A escolha entre uma **Metanálise de Dados Individuais de Pacientes (IPD-MA)** e uma **Metanálise Tradicional de Dados Agregados (AD-MA)** é uma das decisões metodológicas mais cruciais na síntese de evidências. 

Enquanto a AD-MA extrai estatísticas resumidas (médias, *Odds Ratios*, *Hazard Ratios*) já publicadas nos artigos, a IPD-MA (considerada o "padrão-ouro") requer que os pesquisadores solicitem os bancos de dados brutos originais (linha por linha, paciente por paciente) aos autores primários de cada estudo para reanalisá-los de forma centralizada.

Abaixo, detalhamos quando o IPD é necessário, os custos/tempos envolvidos e exemplos clássicos onde a mudança de método alterou a conclusão médica.

---

### 1. Quando o IPD é necessário? (Forças vs. Fraquezas)

A realização de uma IPD-MA não é justificável para todas as perguntas de pesquisa. Ela é **necessária** quando as limitações da metanálise agregada (AD-MA) comprometem a validade clínica da resposta.

#### Forças do IPD (Quando utilizá-lo):
*   **Análises de Subgrupos Confiáveis (Evita o Viés Ecológico):** Na AD-MA, tentar descobrir se um remédio funciona melhor em idosos correlacionando a "idade média" do estudo com o "efeito do estudo" gera um viés de agregação (falácia ecológica). A IPD-MA permite testar interações no nível do paciente (ex: cruzar a idade exata de cada paciente com seu desfecho), identificando com precisão quem se beneficia do tratamento.
*   **Desfechos de Tempo até o Evento (Sobrevida):** Em oncologia ou cardiologia, extrair um *Hazard Ratio* (HR) publicado é limitado. Com o IPD, é possível reconstruir as curvas de Kaplan-Meier, tratar dados censurados de forma padronizada e verificar a proporcionalidade dos riscos ao longo de todo o tempo de seguimento.
*   **Padronização e Correção de Erros:** Permite padronizar pontos de corte, recalcular escalas, ajustar para variáveis de confusão de forma uniforme em todos os estudos e aplicar a análise por intenção de tratar (ITT) real, incluindo pacientes que os autores originais podem ter excluído de suas publicações.
*   **Acesso a Dados Não Publicados (Follow-up estendido):** Os autores frequentemente possuem dados de acompanhamento mais longos do que os que estavam disponíveis no momento da publicação original do artigo.

#### Fraquezas do IPD:
*   **Viés de Disponibilidade (Perda de Randomização):** Se apenas 60% dos autores originais concordarem em compartilhar seus dados, os 40% restantes ficam de fora. Isso pode quebrar a representatividade da metanálise e introduzir um forte viés de seleção.
*   **Complexidade Estatística e de Gestão:** Exige modelos hierárquicos e multiníveis (1-stage ou 2-stage models) complexos para acomodar o agrupamento (clustering) de pacientes dentro de diferentes estudos.

---

### 2. Custo e Tempo

A diferença logística entre as duas abordagens é monumental.

| Característica | Metanálise de Dados Agregados (AD-MA) | Metanálise de Dados Individuais (IPD-MA) |
| :--- | :--- | :--- |
| **Tempo estimado** | **Semanas a alguns meses.** Depende apenas da velocidade da equipe em ler e extrair dados da literatura. | **1 a 3 anos (frequentemente mais).** O tempo é gasto rastreando autores, negociando Acordos de Transferência de Dados (DTAs), limpando bancos de dados corrompidos ou em formatos obsoletos e harmonizando variáveis. |
| **Custo financeiro** | **Baixo/Mínimo.** Geralmente coberto pelo salário padrão dos pesquisadores e softwares de metanálise comuns. | **Muito Alto.** Exige financiamento/grants específicos. Requer gerentes de projeto, estatísticos avançados, aconselhamento jurídico para LGPD/GDPR e, por vezes, financiamento de workshops presenciais para o consórcio de pesquisadores originais. |

*Nota da Cochrane:* Devido ao alto custo, a *Cochrane* recomenda que **sempre se faça uma AD-MA primeiro**. A IPD-MA só deve ser iniciada se a AD-MA deixar lacunas críticas (ex: incerteza sobre subgrupos específicos) que justifiquem o investimento.

---

### 3. Exemplos Práticos onde a Conclusão Diferiu

Uma grande revisão metodológica de banco de dados (Tudur Smith et al., 2016 [1, 2]) demonstrou que, em cerca de **20% dos casos, a IPD-MA e a AD-MA chegam a conclusões estatísticas diferentes** [1]. Abaixo estão três exemplos práticos e famosos onde a adoção do IPD alterou diretrizes clínicas ou revogou conclusões prévias:

#### Exemplo 1: Imunização com Células Paternas para Aborto de Repetição (O "Falso Positivo" da AD-MA)
*   **O Cenário:** Mulheres com abortos de repetição recebiam leucócitos do parceiro para induzir tolerância imunológica. 
*   **AD-MA (Agregada):** Metanálises iniciais utilizando dados agregados da literatura apontaram um efeito protetor pequeno, mas estatisticamente significativo a favor da imunização.
*   **IPD-MA (Jeng et al., 1995 [3]):** Quando os dados individuais foram solicitados e analisados, descobriu-se que o efeito benéfico havia desaparecido completamente.
*   **Por que diferiu?** A AD-MA sofreu de um forte viés de publicação e relato seletivo (estudos negativos não publicaram dados completos que pudessem ser extraídos na metanálise agregada, mas foram incluídos na IPD). **Conclusão alterada:** A terapia foi comprovada como ineficaz e abandonada.

#### Exemplo 2: Antibióticos para Otite Média Aguda em Crianças (O Poder dos Subgrupos)
*   **O Cenário:** Uso de antibióticos para dor de ouvido infantil.
*   **AD-MA (Agregada):** Mostrava que os antibióticos tinham um benefício geral extremamente marginal, levando diretrizes a recomendar a "espera vigilante" (não dar antibióticos) para quase todas as crianças, pois a AD-MA não conseguia identificar *quem* realmente se beneficiava.
*   **IPD-MA (Rovers et al., 2006):** Ao coletar os dados de 3.276 crianças individualmente, os pesquisadores testaram variáveis interativas. Descobriram que o benefício não era marginal para todos: crianças **menores de 2 anos com otite bilateral** ou com **otorreia (secreção)** tinham um benefício gigantesco, enquanto o resto não tinha benefício nenhum.
*   **Por que diferiu?** A falácia ecológica impedia a AD-MA de cruzar idade + lateralidade da doença no nível do indivíduo. **Conclusão alterada:** Diretrizes pediátricas globais mudaram para prescrever antibióticos especificamente para esses dois subgrupos e manter a espera vigilante para os demais.

#### Exemplo 3: Sobrevida no Câncer e o Efeito no Tempo (A imprecisão dos cortes de tempo)
*   **O Cenário:** Michiels et al. (2005) [4] investigaram tratamentos oncológicos comparando as duas abordagens com dados idênticos.
*   **AD-MA (Agregada):** Para tentar medir a sobrevida com dados agregados, a equipe extraiu as *Odds Ratios* (OR) de mortalidade em pontos de tempo fixos (ex: vivos vs mortos em exatos 5 anos). O resultado (OR = 0.84, IC 95%: 0.67–1.06) **não foi estatisticamente significativo** [4, 5].
*   **IPD-MA:** Usando o acompanhamento completo contínuo dos pacientes para gerar uma análise de sobrevida real (*Hazard Ratio*), o resultado foi HR = 0.88 (IC 95%: 0.78–0.99), demonstrando um **benefício estatisticamente significativo** [4, 5].
*   **Por que diferiu?** A AD-MA joga fora todos os dados de "tempo" dos pacientes e transforma uma variável de sobrevida contínua em uma variável dicotômica e estática. A IPD-MA usa toda a história do paciente [5], aumentando radicalmente o poder estatístico [2] e provando a eficácia da droga que a AD-MA teria descartado.
