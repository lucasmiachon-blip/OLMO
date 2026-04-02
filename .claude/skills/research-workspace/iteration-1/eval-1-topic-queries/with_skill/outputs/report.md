# Research Report: Beta-bloqueadores na Prevencao Primaria de Sangramento Varicoso

**Data:** 2026-04-02 | **Pernas executadas:** 1 (Gemini Deep Search), 4 (SCite + Consensus), 5 (PubMed + Opus Researcher)
**Status:** COMPLETO — sintese cruzada abaixo. Pendente: salvar em `.claude/skills/research-workspace/` (plan mode impediu escrita).

---

## 1. Tabela Comparativa por Perna

| Finding | Leg 1 (Gemini) | Leg 4 (SCite/Consensus) | Leg 5 (PubMed/Opus) | Convergencia |
|---------|---------------|------------------------|---------------------|-------------|
| PREDESCI: NSBB reduz descompensacao HR 0.51 (0.26-0.97) | SIM, dados completos | SCite: citado em 10 papers | PubMed PMID:30910320 VERIFIED | **ALTA (3/3)** |
| Carvedilol > propranolol na reducao HVPG | SIM, Baveno VII | Consensus: 3 papers confirmam | PMID:35661713 SHR 0.506 (0.289-0.887) | **ALTA (3/3)** |
| Baveno VII: NSBB para CSPH independente de varizes | SIM, detalhe extenso | Consensus: corroborado | PMID:35120736 VERIFIED | **ALTA (3/3)** |
| EVL nao reduz mortalidade vs NSBB (Cochrane RR 1.09) | SIM, Cochrane citado | SCite: snippets confirmam | PubMed: tema recorrente | **ALTA (3/3)** |
| Combinacao NSBB+EVL: RR 0.39 (0.19-0.76) para bleeding | Gemini nao detalhou | Consensus: Pannala 2025 | PMID:40396591 VERIFIED | **MODERADA (2/3)** |
| CAVARLY: Carvedilol+VBL HR 0.31 (CTP B/C) | Nao mencionado | Consensus: 21 citacoes (2024) | Nao buscado diretamente | **BAIXA (1/3)** |
| NSBBs reduzem PBE e translocacao bacteriana | SIM | SCite: citacoes suportam | PMID:17975481 revisao | **ALTA (3/3)** |
| Janela terapeutica: cautela em ascite refrataria | SIM, detalhado | Consensus: controversias | PubMed: tema confirmado | **ALTA (3/3)** |
| Brasil: propranolol SUS, carvedilol crescendo | SIM (SBH, CONITEC) | Nao abordado | Nao abordado | **BAIXA (1/3)** |

---

## 2. Achados Verificados por Fonte (PMIDs VERIFIED via PubMed MCP)

### Landmark Trial: PREDESCI
- **PMID:** 30910320 [VERIFIED]
- **DOI:** [10.1016/S0140-6736(18)31875-0](https://doi.org/10.1016/S0140-6736(18)31875-0)
- **Citacao:** Villanueva C et al. Lancet 2019; 393(10181):1597-1608.
- **Desenho:** RCT duplo-cego, multicentrico (8 hospitais Espanha), n=201, cirrose compensada + CSPH (HVPG >=10)
- **Endpoint primario:** Descompensacao ou morte: 16% BBNS vs 27% placebo; HR 0.51 (IC95% 0.26-0.97; p=0.041)
- **Ascite:** 9% vs 20%; HR 0.44 (0.20-0.97; p=0.030) — principal driver
- **Sangramento varicoso:** 3% vs 4% (NS)
- **Mortalidade:** 11% vs 8% (NS)
- **Limitacoes:** Populacao 56% HCV, 16% alcool, 6% NASH. HVPG invasivo. Adesao >=70%.

### Baveno VII Consensus
- **PMID:** 35120736 [VERIFIED]
- **DOI:** [10.1016/j.jhep.2021.12.022](https://doi.org/10.1016/j.jhep.2021.12.022)
- **Citacao:** de Franchis R et al. J Hepatol 2022; 76(4):959-974.
- **Posicao:** NSBB (preferencialmente carvedilol <=12.5mg/dia) para todos com CSPH, independente do tamanho das varizes. EVL reservada para intolerancia.
- **Estratificacao nao-invasiva:** LSM >25 kPa = CSPH rule-in; LSM <20 + plaquetas >150k = dispensa EDA

### Carvedilol IPD Meta-analysis
- **PMID:** 35661713 [VERIFIED]
- **DOI:** [10.1016/j.jhep.2022.05.021](https://doi.org/10.1016/j.jhep.2022.05.021)
- **Citacao:** Villanueva C et al. J Hepatol 2022; 77(4):1014-1025.
- **Dados:** 4 RCTs, n=352 compensados. Carvedilol vs controle.
  - Descompensacao: SHR 0.506 (0.289-0.887; p=0.017; I2=0%)
  - Morte: SHR 0.417 (0.194-0.896; p=0.025; I2=0%)
  - Ascite: SHR 0.491 (0.247-0.974; p=0.042)

### NSBB+EBL Combined vs Monotherapy (2025)
- **PMID:** 40396591 [VERIFIED]
- **DOI:** [10.1111/liv.70145](https://doi.org/10.1111/liv.70145)
- **Citacao:** Pannala S et al. Liver Int 2025; 45(6):e70145.
- **Dados:** 6 RCTs, n=1011. Combinado vs NSBB: RR 0.39 (0.19-0.76; p=0.009). Combinado vs EBL: RR 0.46 (0.29-0.74; p=0.002). Taxa sangramento: combinado 9.4%, NSBB 28.2%, EBL 13.9%.

### Carvedilol vs EVL (Shah 2014)
- **PMID:** 24291366 [VERIFIED]
- **DOI:** [10.1016/j.jhep.2013.11.019](https://doi.org/10.1016/j.jhep.2013.11.019)
- **Citacao:** Shah HA et al. J Hepatol 2014; 60(4):757-64.
- **Dados:** n=168, carvedilol 12.5mg vs EVL. Sangramento: 6.9% vs 8.5% (NS). Mortalidade: 19.5% vs 12.8% (NS). Underpowered.

### D'Amico 2006 — Natural History Cirrhosis
- **PMID:** 16298014 [VERIFIED]
- **DOI:** [10.1016/j.jhep.2005.10.013](https://doi.org/10.1016/j.jhep.2005.10.013)
- **Citacao:** D'Amico G et al. J Hepatol 2006; 44(1):217-31. Systematic review de 118 estudos.

### ALERTA: PMIDs do CLAUDE.md que NAO sao beta-bloqueadores
- **PMID 33657294 = CONFIRM trial** (Terlipressin + albumin para HRS-1, NEJM 2021). NAO e trial de beta-bloqueador.
- **PMID 29861076 = ANSWER trial** (Albumin longo prazo em cirrose descompensada, Lancet 2018). NAO e trial de beta-bloqueador.
- Estes PMIDs estao listados como "Fontes Tier 1 Hepatologia" no CLAUDE.md e sao corretos para seus respectivos topicos, mas nao se aplicam a esta pesquisa sobre beta-bloqueadores.

---

## 3. Convergencias (>=2 pernas)

### CONVERGENCIA FORTE (3/3 pernas)

1. **NSBB como primeira linha na cirrose compensada com CSPH** — Baveno VII, AASLD 2024, ACG 2024, meta-analises convergem unanimemente. GRADE: MODERADA para prevencao de descompensacao; ALTA para prevencao de sangramento.

2. **Carvedilol como NSBB preferencial** — Reducao HVPG superior ao propranolol (resposta em ate 72% dos pacientes vs ~50% com propranolol). Dose alvo: 12.5 mg/dia. Mecanismo: bloqueio alfa-1 adicional reduz resistencia intra-hepatica.

3. **EVL nao reduz mortalidade na profilaxia primaria** — Cochrane 2012: RR mortalidade 1.09 (0.92-1.30) EVL vs NSBB. EVL reduz sangramento (RR 0.67) mas nao trata fisiopatologia subjacente (translocacao bacteriana, vasodilatacao esplancnica).

4. **NSBB reduz translocacao bacteriana e PBE** — Efeitos nao-hemodinamicos: anti-inflamatorio, reducao permeabilidade intestinal. Confirmado por multiplas revisoes.

5. **Cautela na cirrose descompensada avancada** — "Janela terapeutica": sem beneficio em HVPG <10 (pouco hiperdinamismo), beneficio maximo em CSPH compensada, risco de colapso hemodinamico em ascite refrataria com PAS <90 mmHg.

### CONVERGENCIA MODERADA (2/3 pernas)

6. **Combinacao NSBB+EVL superior a monoterapia para prevenao de sangramento** — RR 0.39 (0.19-0.76) vs NSBB isolado; RR 0.46 (0.29-0.74) vs EVL isolada. Porem, sem beneficio de sobrevida adicional na cirrose compensada (Baveno VII).

7. **Diagnostico nao-invasivo de CSPH substitui EDA de rastreamento** — LSM >25 kPa = rule-in CSPH. LSM <20 + PLT >150k = dispensa EDA. Zona cinzenta 20-25 kPa = controversia ativa.

---

## 4. Divergencias e Questoes em Aberto

| Questao | Posicao A | Posicao B | Status |
|---------|----------|----------|--------|
| Quando parar NSBB na cirrose avancada? | EASL: parar se PAS <90 ou ascite refrataria | Dados recentes: carvedilol seguro com titulacao cuidadosa | **CONFLITO — decisao humana** |
| NSBB em NASH/MASLD? | PREDESCI: 56% HCV, subgrupo NASH sem efeito | Extrapolacao assume intercambiabilidade etiologica | **NAO RESOLVIDO** |
| Zona cinzenta elastografia (LSM 15-24) | Baveno VII: rule-in so >25 kPa | AASLD: >=20 + PLT <=150k justifica terapia | **DIVERGENCIA ATIVA** |
| NSBB para prevenir FORMACAO de varizes? | Nenhuma guideline recomenda (HVPG 6-9 = ineficaz) | Um estudo sugeriu beneficio; nao replicado | **EVIDENCIA INSUFICIENTE** |
| Pediatria | Zero RCTs (Cochrane 2020/2021) | Extrapolacao de adultos | **SEM EVIDENCIA Tier 1** |

---

## 5. Numeros-Chave para Slide/Ensino

| Dado | Valor | IC 95% | Fonte | PMID |
|------|-------|--------|-------|------|
| PREDESCI: HR descompensacao/morte NSBB vs placebo | 0.51 | 0.26-0.97 | Lancet 2019 | 30910320 |
| PREDESCI: HR ascite | 0.44 | 0.20-0.97 | Lancet 2019 | 30910320 |
| Carvedilol IPD: SHR descompensacao | 0.506 | 0.289-0.887 | J Hepatol 2022 | 35661713 |
| Carvedilol IPD: SHR morte | 0.417 | 0.194-0.896 | J Hepatol 2022 | 35661713 |
| Cochrane EVL vs NSBB: RR mortalidade | 1.09 | 0.92-1.30 | Cochrane 2012 | 22895942 [CANDIDATE] |
| Cochrane EVL vs NSBB: RR sangramento | 0.67 | 0.46-0.98 | Cochrane 2012 | 22895942 [CANDIDATE] |
| NSBB+EVL vs NSBB: RR sangramento | 0.39 | 0.19-0.76 | Liver Int 2025 | 40396591 |
| NMA carvedilol vs placebo: RR sangramento | 0.33 | 0.11-0.88 | JCTH 2023 | [CANDIDATE] |
| NMA carvedilol vs placebo: RR mortalidade | 0.32 | 0.17-0.57 | JCTH 2023 | [CANDIDATE] |
| NMA NSBB: OR mortalidade vs placebo | 0.70 | 0.49-1.00 | Hepatology 2019 | [CANDIDATE] |
| CAVARLY: carvedilol+VBL vs VBL HR sangramento | 0.37 | 0.192-0.716 | Gut 2024 | [CANDIDATE] |
| Resposta HVPG aguda >=10% prediz nao-sangramento | 4% vs 46% em 24m | p<0.001 | Gastroenterology 2009 | [CANDIDATE] |

---

## 6. Fonte das Pernas (Raw Data)

### Leg 1 — Gemini Deep Search
- **Status:** COMPLETO (4m29s)
- **Output:** `C:\Users\lucas\AppData\Roaming\gemini-mcp\output\895e0fe124d103c5\deep-research-2026-04-02T19-05-02-300Z.json`
- **PMIDs:** TODOS marcados CANDIDATE (taxa erro Gemini ~15-20%)
- **Cobertura:** 46 fontes, incluindo Baveno VII, PREDESCI, Cochrane, AASLD, ACG, SBH, CONITEC
- **Ponto forte:** Contexto brasileiro (SBH, PCDT, CONITEC) — unica perna que cobriu isso

### Leg 4 — SCite + Consensus
- **SCite:** 10 papers com Smart Citations. Top hits: Villanueva 2021 (Clinics Liver Dis), D'Amico coorte nacional, Carvedilol controversies
- **Consensus (query 1):** 502 error — proxy down. Retry falhou.
- **Consensus (query 2):** 10 papers retornados. Top: NMA NSBB vs EBL (Hepatology 2019, 90 citacoes), Carvedilol NMA (JCTH 2023), CAVARLY trial (Gut 2024, 21 citacoes)
- **Ponto forte:** Smart Citations do SCite trouxeram snippets de como os papers citam o PREDESCI

### Leg 5 — PubMed + Opus Researcher
- **PubMed search 1:** 15 PMIDs (beta-blockers primary prevention guidelines)
- **PubMed search 2:** 8 PMIDs (PREDESCI-related)
- **PubMed search 3:** 10 PMIDs (carvedilol RCTs)
- **Baveno VII:** PMID 35120736 VERIFIED
- **PMIDs verificados via get_article_metadata:** 30910320, 35661713, 40396591, 24291366, 16298014, 35120736
- **Ponto forte:** Verificacao direta de PMIDs. Descobriu que PMID 33657294 (CONFIRM) e 29861076 (ANSWER) NAO sao sobre beta-bloqueadores

---

## 7. Recomendacoes para Proximos Passos

1. **Verificar PMIDs CANDIDATE** — Os PMIDs do Cochrane 2012 (22895942), NMA JCTH 2023, CAVARLY trial, e resposta hemodinamica (Gastroenterology 2009) precisam de verificacao via PubMed MCP antes de usar em slides.

2. **Slide-ready data** — Os numeros do PREDESCI e carvedilol IPD meta-analysis estao prontos para uso direto (VERIFIED). Formato NNT nao calculavel diretamente dos HRs — precisaria de taxa basal e tempo de follow-up para conversao.

3. **Contexto brasileiro** — A perna Gemini e a unica que trouxe dados SBH/CONITEC. Esses dados precisam de verificacao independente antes de uso em slide projetado.

4. **GRADE Assessment:**
   - PREDESCI isolado: MODERADA (1 RCT, sem replicacao, populacao limitada)
   - Carvedilol meta-analysis: MODERADA (IPD de 4 RCTs, n=352, I2=0%)
   - NSBB vs placebo para sangramento: ALTA (multiplos RCTs + meta-analises)
   - NSBB vs EVL mortalidade: ALTA (Cochrane + multiplas meta-analises)
   - NSBB em CSPH sem varizes: MODERADA (PREDESCI + Baveno VII consensus)

---

Coautoria: Lucas + Claude Opus 4.6 (orquestrador) + Gemini 3.1 (deep search) + PubMed MCP + SCite MCP + Consensus MCP
Orquestrador: Claude Opus 4.6
Validador: PubMed MCP (verificacao PMIDs)
