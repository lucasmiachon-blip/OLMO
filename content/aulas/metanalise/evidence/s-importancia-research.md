# Deep Research Report: s-importancia — Vantagens Metodológicas da Meta-análise

**Date:** 2026-04-07 | **Aula:** metanalise | **Slide:** s-importancia | **Fase:** F1
**MCPs usados:** BioMCP (article_searcher, article_getter) | WebSearch
**Verificação PMID:** Todos marcados CANDIDATE até verificação via PubMed MCP. Verificados inline.

---

## TL;DR

Meta-análise bem conduzida aumenta poder, estreita ICs e resolve controvérsias que trials isolados não conseguem. O caso streptokinase (Lau 1992) é O exemplo pedagógico clássico: evidência suficiente existia desde 1973 mas trials continuaram por 20 anos por falta de síntese cumulativa. Antithrombotic Trialists' Collaboration (287 estudos, 135.000 pacientes) demonstra poder para detectar efeitos que nenhum trial isolado detectaria.

---

## Vantagem 1 — Aumento de Poder Estatístico

### Mecanismo
Pooling de N aumenta poder para detectar diferenças reais. Muitos trials individuais são negativos por underpowering, não por ausência de efeito.

### Exemplo canônico: beta-blockers pós-IAM (Yusuf 1985)
- **Paper:** Yusuf S, Peto R, Lewis J, Collins R, Sleight P. Beta blockade during and after myocardial infarction: an overview of the randomized trials. *Prog Cardiovasc Dis.* 1985;27(5):335-71.
- **PMID:** 2858114 — **VERIFIED** (PubMed MCP: autor Yusuf S et al., Prog Cardiovasc Dis, 1985-03-01)
- **Dado:** Overview de ~65 trials de beta-bloqueadores pós-IAM. Individualmente, a maioria era negativa ou inconclusiva. Pooled: redução de mortalidade ~25% (estatisticamente significativa).
- **Citação do abstract:** "Although most trials are too small to be individually reliable, this defect of size may be rectified by an overview of many trials, as long as appropriate statistical methods are used."
- **Uso pedagógico:** Exemplo direto de "trial negativo + trial negativo + ... = MA positiva". Yusuf estabeleceu beta-bloqueador como padrão quando nenhum trial individual tinha poder suficiente.

### Exemplo complementar: Antithrombotic Trialists' Collaboration (ATC 2002)
- **Paper:** Antithrombotic Trialists' Collaboration. Collaborative meta-analysis of randomised trials of antiplatelet therapy for prevention of death, myocardial infarction, and stroke in high risk patients. *BMJ.* 2002;324(7329):71-86.
- **PMID:** 11786451 — **VERIFIED** (PubMed MCP: Antithrombotic Trialists' Collaboration, BMJ, 2002-01-12)
- **Dado:** 287 estudos, ~135.000 pacientes em comparações antiagregante vs controle + 77.000 em comparações entre regimes.
- **Resultado principal:** Antiagregantes reduziram evento vascular sério em ~25%; redução absoluta de 36 eventos/1.000 pacientes tratados por 2 anos em pós-IAM.
- **Relevância para poder:** Nenhum trial isolado teria N suficiente para detectar efeitos em subgrupos (angina estável, doença arterial periférica, fibrilação atrial) — cada subgrupo confirmado separadamente com p significativo apenas pelo pooling.

---

## Vantagem 2 — Precisão Aumentada (ICs mais estreitos)

### Mecanismo
IC 95% se estreita com aumento de N. Uma MA de 10 trials de 500 pts = N efetivo ~5.000 → IC mais estreito que qualquer trial isolado.

### Exemplo quantificado: Lau 1992 — streptokinase (cumulative MA)
- **Paper:** Lau J, Antman EM, Jimenez-Silva J, Kupelnick B, Mosteller F, Chalmers TC. Cumulative meta-analysis of therapeutic trials for myocardial infarction. *N Engl J Med.* 1992;327(4):248-54.
- **PMID:** 1614465 — **VERIFIED** (PubMed MCP: Lau J, Antman EM et al., N Engl J Med, 1992-07-23)
- **Dado concreto:**
  - 1973 (8 trials, n=2.432): OR 0,74 (IC 95%: 0,59–0,92) — já significativo, mas IC amplo
  - 1988 (33 trials, n=37.000+): OR similar, mas IC muito mais estreito
  - Os 25 trials subsequentes "had little or no effect on the odds ratio establishing efficacy, but simply narrowed the 95 percent confidence interval"
- **Lição:** A MA não mudou a estimativa pontual — estreitou o IC, aumentando a certeza sem requerer novos dados.

### Referência metodológica (textbook)
- **Borenstein M, Hedges LV, Higgins JPT, Rothstein HR.** *Introduction to Meta-Analysis.* Wiley, 2021 (2nd ed.). ISBN: 978-1-119-55835-4.
  - Capítulo 1 quantifica formalmente: IC da MA ∝ 1/√N_total. Sem PMID (livro). WEB-VERIFIED via editora Wiley.
- **Cochrane Handbook v6.5 (2024):** "estimation is usually improved when it is based on more information... meta-analysis may have more power to detect real differences than single studies, yielding more precise estimates." (Chapter 10). Disponível em: training.cochrane.org/handbook/current/chapter-10. Sem PMID individual (handbook online). WEB-VERIFIED.

---

## Vantagem 3 — Resolução de Controvérsias (trials que discordam)

### O caso clássico: streptokinase e o desperdício de 20 anos

- **Paper:** Lau 1992 (mesmo paper acima, PMID 1614465 — VERIFIED)
- **Narrativa pedagógica:**
  - Streptokinase foi testada em 33 trials entre 1959 e 1988.
  - Se uma MA cumulativa tivesse sido feita, a evidência de eficácia estava completa em **1973** (OR 0,74; IC: 0,59–0,92) com apenas 8 trials (n=2.432).
  - Os 25 trials subsequentes (1973–1988) — incluindo GISSI (11.712 pts, 1986) e ISIS-2 (17.187 pts, 1988) — não mudaram a conclusão. Apenas estreitaram o IC.
  - **Implicação ética:** ~34.542 pacientes adicionais foram randomizados para placebo após a evidência estar estabelecida.
  - Sem a MA cumulativa, os trials individuais pareciam discordantes (alguns positivos, alguns neutros) — a MA resolveu a aparente controvérsia.

- **Confirmação pelo ISIS-2 (RCT):**
  - ISIS-2 Collaborative Group. Randomised trial of intravenous streptokinase, oral aspirin, both, or neither among 17,187 cases of suspected acute myocardial infarction: ISIS-2. *Lancet.* 1988;2(8607):349-60.
  - **PMID:** 2899772 — **VERIFIED** (PubMed MCP: ISIS-2 Collaborative Group, Lancet, 1988-08-13, n=17.187)
  - ISIS-2 confirmou o benefício que a MA já havia estabelecido: streptokinase 25% redução de mortalidade vascular (OR, odds reduction: 25% SD 4; 2p<0,00001), aspirina 23%.
  - **Uso pedagógico:** ISIS-2 é o trial que "confirmou" algo que a MA já sabia. Ilustra a vantagem 3 (resolve controvérsia) + vantagem 1 (poder).

- **Paper de revisão metodológica (Clarke 2014):**
  - Clarke M, Brice A, Chalmers I. Accumulating Research: A Systematic Account of How Cumulative Meta-Analyses Would Have Provided Knowledge, Improved Health, Reduced Harm and Saved Resources. *PLoS One.* 2014;9(7):e102670.
  - **PMID:** 25068257 — **VERIFIED** (PubMed MCP: Clarke M, Brice A, Chalmers I, PLoS One, 2014-07-28)
  - **Dado:** 50 reports com >1.500 MAs cumulativas (1992–2012) mostram padrão consistente: em muitos casos, o resultado estava estabelecido muito antes do último trial ser conduzido.

---

## Vantagem 4 — Detecção de Efeitos Pequenos mas Clinicamente Relevantes

### Mecanismo
Efeitos de magnitude pequena (RR 0,85–0,95) requerem N na casa das dezenas de milhar para atingir poder adequado. Nenhum trial individual tem esse N para esses efeitos.

### Exemplo: ATC 2002 — aspirina em prevenção secundária
- **Paper:** ATC 2002 (PMID 11786451 — VERIFIED, citado acima)
- **Dado:** Redução de ~25% em eventos vasculares sérios. Em prevenção secundária: ARR de 36/1.000 em 2 anos. Em populações individuais (angina estável, DAP, FA): cada subgrupo com p significativo individualmente — só possível pelo pooling.
- **Magnitude do efeito:** RR ~0,75 em evento composto. Nenhum trial com <5.000 pacientes teria poder >80% para detectar esse efeito.

### Exemplo: ATC 2009 — aspirina em prevenção primária (IPD-MA)
- **Paper:** Antithrombotic Trialists' (ATT) Collaboration, Baigent C et al. Aspirin in the primary and secondary prevention of vascular disease: collaborative meta-analysis of individual participant data from randomised trials. *Lancet.* 2009;373(9678):1849-60.
- **PMID:** 19482214 — **VERIFIED** (PubMed MCP: ATT Collaboration, Baigent C et al., Lancet, 2009-05-30)
- **Dado:** 6 trials prevenção primária (95.000 indivíduos, 660.000 person-years) + 16 secundária (17.000, 43.000 person-years). Efeito em primária: RR 0,88 (IC 95%: 0,82–0,94), p=0,0001. Redução absoluta pequena: 0,07%/ano — só detectável por IPD-MA de 95.000 pacientes.
- **Uso pedagógico:** Mostra que mesmo efeito pequeno (e clinicamente importante para decidir política de saúde pública) só é detectável com MA.

---

## Vantagem 5 — Generalização / Validade Externa

### Mecanismo
Pooling de populações diversas (diferentes idades, etnias, comorbidades, centros) aumenta a validade externa da estimativa pontual e permite análises de subgrupo pré-especificadas com poder adequado.

### Exemplo: ATC 2002 (PMID 11786451 — VERIFIED)
- 287 estudos em múltiplos países, cenários, populações.
- Subgrupos analisados: pós-IAM, pós-AVC/TIA, angina estável, AVC agudo, outros alto risco.
- Resultado consistente across subgrupos — aumenta confiança na generalização.

### Exemplo: ATC 2009 IPD (PMID 19482214 — VERIFIED)
- IPD permite análise de interação sexo × tratamento, idade × tratamento, sem confundimento por diferenças de protocolo entre trials.
- "The proportional reductions in the aggregate of all serious vascular events seemed similar for men and women" — só possível com IPD-MA poolada.

### Cochrane Handbook sobre generalização (WEB-VERIFIED)
- Chapter 1: "A selection of studies with differing characteristics can allow investigation of the consistency of effect across a wider range of populations and interventions" (training.cochrane.org/handbook/current/chapter-01).

---

## Referências Metodológicas Canônicas

### Glass 1976 — cunhou o termo "meta-analysis"
- Glass GV. Primary, Secondary, and Meta-Analysis of Research. *Educational Researcher.* 1976;5(10):3-8.
- DOI: 10.3102/0013189X005010003
- **Sem PMID** (não indexado no PubMed — publicação de 1976 em periódico educacional). WEB-VERIFIED via JSTOR/SAGE.
- Discurso presidencial na American Educational Research Association, 1976. Cunhou "meta-análise" como "statistical analysis of a large collection of analysis results from individual studies."

### Egger 1997 — bias em MA (funnel plot)
- Egger M, Davey Smith G, Schneider M, Minder C. Bias in meta-analysis detected by a simple, graphical test. *BMJ.* 1997;315(7109):629-34.
- **PMID:** 9310563 — **VERIFIED** (PubMed MCP: Egger M, Davey Smith G et al., BMJ, 1997-09-13)
- Contexto: Relevante para seção de limitações (viés de publicação via funnel plot). Encontrou assimetria em 38% dos journals e 13% das Cochrane reviews de 1996. Assinala a outra face da moeda: MA pode ser viesada quando trials negativos não são publicados.

### Cochrane Handbook (referência normativa atual)
- Higgins JPT, Thomas J, Chandler J et al. (eds). *Cochrane Handbook for Systematic Reviews of Interventions.* Version 6.5. Cochrane, 2024. Disponível em: training.cochrane.org/handbook/current.
- **Sem PMID** (handbook online, atualizado continuamente). WEB-VERIFIED.
- Paper editorial de apresentação: Cumpston M et al. Updated guidance for trusted systematic reviews. *Cochrane Database Syst Rev.* 2019. PMID: 31643080. **VERIFIED** (PubMed MCP: Cumpston M, Li T, Page MJ et al., Cochrane Database Syst Rev, 2019-10-03)

### Borenstein 2021 (textbook)
- Borenstein M, Hedges LV, Higgins JPT, Rothstein HR. *Introduction to Meta-Analysis.* Wiley; 2021 (2nd ed.). ISBN: 978-1-119-55835-4. **Sem PMID.** WEB-VERIFIED (Wiley).

---

## Tabela-Resumo de PMIDs Verificados

| PMID | Autor/Ano | Journal | Status | Uso |
|------|-----------|---------|--------|-----|
| 1614465 | Lau 1992 | N Engl J Med | VERIFIED | Cumulative MA, streptokinase, resolução de controvérsia + precisão |
| 11786451 | ATC 2002 | BMJ | VERIFIED | Poder estatístico, efeitos pequenos, generalização |
| 19482214 | ATT 2009 | Lancet | VERIFIED | Efeitos pequenos (IPD-MA primária/secundária) |
| 2899772 | ISIS-2 1988 | Lancet | VERIFIED | Trial que confirmou o que MA já sabia (contraste) |
| 2858114 | Yusuf 1985 | Prog Cardiovasc Dis | VERIFIED | Poder: trials individuais negativos → MA positiva (beta-blockers) |
| 9310563 | Egger 1997 | BMJ | VERIFIED | Limitação: viés de publicação (funnel plot) |
| 25068257 | Clarke 2014 | PLoS One | VERIFIED | Sistematização de 1.500+ MAs cumulativas (desperdício de pesquisa) |
| 31643080 | Cumpston 2019 | Cochrane DB Syst Rev | VERIFIED | Editorial Cochrane Handbook v6 |

**Sem PMID (livros/handbooks):** Glass 1976 (DOI: 10.3102/0013189X005010003), Borenstein 2021 (ISBN 978-1-119-55835-4), Cochrane Handbook v6.5 (training.cochrane.org).

**CANDIDATE (não verificados):** nenhum — todos os PMIDs foram verificados ou fontes sem PMID foram identificadas como livros/handbooks.

---

## Flags de Verificação

- PMID 1314677 foi testado como candidato para Lau 1992 — ERRADO (era paper sobre implante dentário de hidroxiapatita, Biomaterials 1992). Confirmação que taxa de erro de PMIDs de LLM é real.
- PMID 1614465 (Lau 1992) confirmado via WebSearch (NEJM) + PubMed MCP.
- Borenstein, Cochrane Handbook, Glass 1976: fontes sem PMID por natureza (livros/handbook web/periódico pré-PubMed) — não é limitação, é característica da fonte.

---

## Notas Pedagógicas para o Professor

1. **Streptokinase como âncora narrativa:** O caso Lau 1992 é perfeito para sala: "Em 1973 a evidência estava lá. Por 20 anos mais, ensaiamos pacientes para placebo. Por que? Porque ninguém fez a síntese." Gera discussão sobre ética de pesquisa + importância de SR como pré-requisito de novo trial.

2. **Beta-blockers (Yusuf 1985):** Alternativa mais intuitiva. Mostrar que 65 trials individuais "negativos" + MA = "positiva". Pergunta para residentes: "Se você tivesse visto o trial do seu hospital (negativo), teria prescrito o beta-bloqueador?"

3. **ATC 2002 como exemplo de magnitude:** 287 estudos, 135.000 pacientes. Nenhum médico lê 287 papers. A MA leu por você — e quantificou: 36 vidas salvas por cada 1.000 tratados por 2 anos.

4. **Egger 1997 como contrapeso (F2/F3):** Não usar em F1 (mata o momentum). Reservar para slide de limitações: a MA só é boa se os trials foram todos encontrados. Funnel plot assimétrico em 38% das MAs de grandes journals em 1996 — viés de publicação é real.

5. **Distinção trial vs MA:** ISIS-2 é O trial que "confirmou" o que Lau já sabia. Usar para reforçar: grande trial não substitui MA prévia; MA não substitui trial bem conduzido. São complementares.

---

## Depth Score

| Dimensão | Score | Justificativa |
|----------|-------|--------------|
| D1 Source | 9 | 7 PMIDs verificados (Tier 1), 3 fontes sem PMID por natureza (livros canônicos) |
| D2 Effect Size | 8 | Dados quantitativos: OR 0,74, IC explícito, RR 0,88, ARR 36/1.000 |
| D3 Population | 9 | Múltiplas populações (IAM, prevenção primária/secundária, subgrupos) |
| D4 Timeframe | 8 | Dados com follow-up explícito (2 anos, 1 mês, etc.) |
| D5 Comparator | 7 | Placebo/controle claramente identificado em todos os exemplos |
| D6 Grading | 6 | GRADE não aplicado formalmente (fora do escopo F1) |
| D7 Clinical Impact | 9 | Implicações éticas e clínicas explicitadas (20 anos de trials redundantes) |
| D8 Currency | 7 | Papers clássicos (1985-2002) — necessários e canônicos para F1 |

**Score médio: 7,9/10 — DEEP**

---

## Coautoria

Coautoria: Lucas + Claude Sonnet 4.6
Pesquisa: 2026-04-07
