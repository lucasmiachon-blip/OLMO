# Clopidogrel vs Aspirina -- Prevenção Secundária de AVC Isquêmico

> Pesquisa profunda via Gemini Deep Research (Gemini 3.1 deep-research-pro-preview)
> Data: 2026-04-02 | Duração: 5m 38s
> Research ID: `v1_ChctNURPYWF1bUxMaml6N0lQMWUyMGdRNBIXLTVET2FhdW1MTGppejdJUDFlMjBnUTQ`
> Status: CANDIDATE -- dados de LLM com Google Search grounding, verificação PMID pendente

---

## Pontos-Chave

1. **CAPRIE (1996):** Clopidogrel mostrou superioridade global sobre aspirina (RRR 8.7%, p=0.043), mas o **subgrupo AVC NÃO atingiu significância** (RRR 7.3%, p=0.26).
2. **Meta-análises recentes (PANTHER IPD 2025):** P2Y12 monotherapy superior a aspirina para MACCE em pacientes com DAC (HR 0.86, p=0.008), com redução de AVC isquêmico (HR 0.79) e hemorrágico (HR 0.32).
3. **Divergência de guidelines:** AHA/ASA mantém paridade (aspirina Class I, clopidogrel Class IIa/IIb). ESC/ESOC trending para preferir clopidogrel baseado em dados pan-vasculares.
4. **DAPT 21 dias:** CHANCE/POINT consolidaram DAPT curta (21d) seguida de monoterapia como padrão para AVC minor/TIA.
5. **CYP2C19:** ~25% caucasianos e até 60% asiáticos são portadores de alelos loss-of-function, tornando clopidogrel ineficaz nesses pacientes.
6. **OCEANIC-STROKE (2026):** Asundexian (inibidor FXIa) reduziu AVC recorrente em 26% (HR 0.74, p<0.0001) **sem aumento de sangramento** -- potencial paradigm shift.

---

## 1. CAPRIE Trial (1996)

### Design
- RCT internacional, duplo-cego
- N = 19,185 (AVC isquêmico n=6,431 | IAM n=6,302 | DAP n=6,452)
- Clopidogrel 75mg vs Aspirina **325mg**/dia
- Follow-up mediano: 1.91 anos
- Endpoint primário: composto de AVC isquêmico, IAM ou morte vascular

### Resultados Globais
- Taxa de eventos: clopidogrel 5.32%/ano vs aspirina 5.83%/ano
- **RRR 8.7%** (IC 95%: 0.3-16.5%, p=0.043)

### Subgrupo AVC (n=6,431)

| Métrica | Valor |
|---------|-------|
| Taxa clopidogrel | 7.15%/ano |
| Taxa aspirina | 7.71%/ano |
| RRR | 7.3% (IC 95%: -5.7% a 18.7%) |
| p-value | **0.26 (não significativo)** |
| RR bruto | 0.93 (IC 95%: 0.82-1.05) |
| ARR (eventos compostos) | 1.0% |
| **NNT (evento composto)** | **98** |
| **NNT (AVC recorrente)** | **121** |

### Limitações Críticas

1. **Underpowered para subgrupos:** CAPRIE foi dimensionado para o desfecho composto global, não para subgrupos individuais.
2. **Dose alta de aspirina (325mg):** Evidência subsequente (ATC) mostrou que 75-150mg é igualmente eficaz com menos sangramento GI. A comparação pode ter inflado o benefício relativo do clopidogrel.
3. **Generalização limitada:** Apenas ~32% dos pacientes de AVC do mundo real se qualificariam pelos critérios de exclusão (excluídos: acamados, demência, HAS descontrolada, expectativa <3 anos, TIA).

---

## 2. Meta-Análises Pós-CAPRIE

### 2.1 Tasoudis et al. (2022) -- 5 RCTs, 26,855 pacientes

| Desfecho | OR (IC 95%) | p |
|----------|-------------|---|
| AVC isquêmico | 0.87 (0.71-1.06) | 0.16 (NS) |
| Mortalidade total | 1.01 | NS |
| Sangramento maior | 0.77 | NS |
| IAM não-fatal | 0.83 (sig) | <0.05 |
| MACE global | 0.84 | 0.05 (borderline) |

**Conclusão:** Sem diferença significativa para AVC isquêmico isoladamente.

### 2.2 PANTHER IPD Meta-Análise (2025) -- 7 trials, 24,325 pacientes (DAC)

| Desfecho | HR (IC 95%) | p |
|----------|-------------|---|
| MACCE (morte CV, IAM, AVC) | 0.86 (0.79-0.97) | 0.008 |
| AVC isquêmico | 0.79 | sig |
| AVC hemorrágico | 0.32 (0.14-0.75) | 0.009 |
| Sangramento maior | NS (1.2% vs 1.4%) | NS |
| Sangramento GI | 0.75 | 0.027 |

**Limitação:** População predominantemente DAC, não AVC primário. NNT extrapolado ~48.

### Tabela Resumo NNT

| Contexto | Comparação | RR/HR (IC 95%) | ARR | NNT |
|----------|-----------|----------------|-----|-----|
| CAPRIE subgrupo AVC | Clopi vs ASA 325mg | RR 0.93 (0.82-1.05) | 1.0% | 98 (composto) |
| CAPRIE subgrupo AVC | Clopi vs ASA 325mg | -- | 0.8% | 121 (AVC recorrente) |
| PANTHER (DAC) | P2Y12 vs ASA | HR 0.86 (0.79-0.97) | ~0.8%/ano | ~48 (extrapolado) |
| Tasoudis (CVD) | Clopi vs ASA | OR 0.87 (0.71-1.06) | -- | NS para AVC |

---

## 3. Trials de DAPT Curta

| Trial | Ano | N | Regime | AVC/Desfecho (DAPT vs mono) | Sangramento |
|-------|-----|---|--------|------------------------------|-------------|
| **CHANCE** | 2013 | 5,170 | Clopi 300mg load + 75mg + ASA 21d, depois clopi mono até 90d | 8.2% vs 11.7% (HR 0.68) | Sem aumento |
| **POINT** | 2018 | 4,881 | Clopi 600mg load + 75mg + ASA 90d | 5.0% vs 6.5% (HR 0.72) | Maior (0.9% vs 0.4%, HR 2.32) |
| **THALES** | 2020 | -- | Ticagrelor + ASA 30d | 5.5% vs 6.6% (HR 0.83) | Maior (0.4% vs 0.1%, HR 3.66) |

**Consenso atual:** DAPT 21 dias (ASA + clopidogrel) seguido de monoterapia. O benefício isquêmico concentra-se nos primeiros 21 dias; sangramento acumula com o tempo.

**Impacto na monoterapia:** Como CHANCE usou clopidogrel mono após 21d de DAPT, muitos clínicos defaultam para clopidogrel como agente crônico.

---

## 4. Divergência de Guidelines: AHA/ASA vs ESC/ESOC

| Aspecto | AHA/ASA 2021 | ESC/ESOC 2022+ |
|---------|-------------|----------------|
| **Regime preferido** | SAPT (monoterapia) | SAPT (monoterapia) |
| **Aspirina** | Class I, Level A | Fortemente recomendada |
| **Clopidogrel** | Class IIa/IIb, Level B ("opção razoável") | Fortemente recomendado (preferência crescente sobre ASA nas atualizações ESC) |
| **DAPT curta (AVC minor)** | Recomendada 21-90d | Recomendada ~21d |
| **DAPT longa (>90d)** | Class III (Harm) | Fraca recomendação contra |
| **Base para divergência** | Aderência estrita ao subgrupo CAPRIE (resultado nulo para AVC) | Integração de meta-análises pan-vasculares (PANTHER, HOST-EXAM, SMART-CHOICE 3) |

### Razões para a divergência

1. **Interpretação dos dados:** AHA/ASA exige significância estatística no subgrupo AVC; ESC integra dados pan-vasculares (aterosclerose como doença sistêmica).
2. **Genericização:** Clopidogrel genérico (~$50/ano) neutralizou o argumento econômico contra seu uso como primeira linha.
3. **CYP2C19:** A variabilidade genética (25% caucasianos, até 60% asiáticos) é um fator de cautela para recomendação universal.
4. **Evidência recente (2024-2025):** SMART-CHOICE 3 confirmou superioridade de clopidogrel vs aspirina a 3 anos pós-PCI (MACCE 4.4% vs 6.6%), reforçando a posição europeia.

---

## 5. Farmacogenômica: CYP2C19

- Clopidogrel é pró-droga, requer ativação hepática por CYP2C19 em 2 etapas
- **Alelos loss-of-function (LoF):**
  - ~25% caucasianos portadores
  - ~60% asiáticos portadores
- Portadores de LoF: metabolização reduzida, inibição plaquetária insuficiente ("resistência ao clopidogrel")
- No subestudo genético do CHANCE: pacientes com LoF **não tiveram benefício** com clopidogrel vs aspirina
- Genotipagem CYP2C19 upfront: ICER $1,930/QALY (custo-efetivo)
- **Implicação prática:** A recomendação universal de clopidogrel é biologicamente problemática sem farmacogenômica

---

## 6. Custo-Efetividade

| Era | Custo clopidogrel | ICER |
|-----|-------------------|------|
| Pré-genérico (CHARISMA era) | Alto (Plavix branded) | $36,343/QALY |
| Pós-genérico (atual) | ~$50/ano | Altamente custo-efetivo |
| Regime CHANCE (China) | Incremental $192 | $5,200/QALY |

---

## 7. Horizonte 2023-2026: Trials em Andamento

### SMART-CHOICE 3 (2024-2025)
- 5,542 pacientes pós-PCI alto risco
- Clopidogrel vs aspirina mono após DAPT
- **MACCE a 3 anos: 4.4% vs 6.6% (favorável clopidogrel)**

### STROKE75+ (em andamento)
- Fase III, pacientes AVC >=75 anos
- SAPT vs SAPT + edoxaban ultra-baixa dose (15mg)
- Baseado em ELDERCARE-AF (HR 0.34 vs placebo para AVC em idosos)

### OCEANIC-STROKE (2026) -- PARADIGM SHIFT POTENCIAL
- 12,327 pacientes com AVC isquêmico agudo não-cardioembólico ou TIA
- **Asundexian (inibidor FXIa) 50mg + antiagregante vs placebo + antiagregante**
- AVC isquêmico recorrente: **redução de 26%** (csHR 0.74, IC 95%: 0.65-0.84, p<0.0001)
- ARR 1.9% a 1 ano | **NNT 53**
- **Sem aumento de sangramento maior, AVC hemorrágico ou HIC sintomática**
- Mecanismo: FXIa amplifica trombose patológica mas tem papel mínimo em hemostasia fisiológica

---

## 8. Conclusão e Síntese Clínica

**Para AVC isquêmico especificamente:**

1. A evidência de **superioridade** do clopidogrel sobre aspirina em monoterapia é **modesta e estatisticamente inconclusiva** quando limitada ao subgrupo AVC (CAPRIE p=0.26, Tasoudis p=0.16).

2. A evidência **pan-vascular** (PANTHER, SMART-CHOICE 3) favorece consistentemente P2Y12 sobre aspirina para proteção aterosclerótica sistêmica, o que sustenta a posição europeia.

3. O **padrão de cuidado atual** para AVC minor/TIA agudo é DAPT 21 dias seguida de monoterapia, com default frequente para clopidogrel.

4. A escolha deve considerar:
   - **Genótipo CYP2C19** (se disponível)
   - Perfil de sangramento GI (favorece clopidogrel)
   - Doença aterosclerótica concomitante (favorece clopidogrel)
   - Custo local e disponibilidade

5. **O futuro próximo** pode tornar o debate clopidogrel vs aspirina secundário: inibidores de FXIa (asundexian) demonstraram redução adicional de 26% em AVC recorrente sem custo hemorrágico, adicionados sobre antiplaquetários convencionais.

---

## Fontes (Google Search Grounding)

Fontes indexadas pelo Gemini Deep Research. **Status: CANDIDATE -- verificação PMID independente pendente.**

1. bayer.com -- OCEANIC-STROKE trial results
2. uspharmacist.com -- Clopidogrel pharmacology, CAPRIE review
3. rebelem.com -- CYP2C19 pharmacogenomics
4. heart.org -- AHA antiplatelet guidelines
5. strokebestpractices.ca -- CAPRIE detailed analysis
6. oup.com -- Oxford academic stroke prevention
7. nih.gov (PubMed) -- CAPRIE original, meta-analyses, CYP2C19 studies
8. acc.org -- PANTHER IPD meta-analysis, AHA/ASA guidelines
9. ccjm.org -- Clopidogrel clinical review
10. eso-stroke.org -- ESO guidelines on antiplatelets
11. pcronline.com -- ESC 2024 CCS guidelines
12. escardio.org -- ESC antiplatelet recommendations
13. ahajournals.org -- CHANCE cost-effectiveness, CAPRIE subgroup analysis
14. neurology.org -- DAPT pooled analysis
15. nowyouknowneuro.com -- CHANCE/POINT summary
16. tctmd.com -- OCEANIC-STROKE, CYP2C19 review
17. bmj.com -- Stroke secondary prevention overview
18. clinicaltrials.gov -- STROKE75+ trial registration
19. pace-cme.org -- PANTHER results
20. 2minutemedicine.com -- PANTHER summary

---

*Coautoria: Lucas + Opus 4.6 (orquestração) + Gemini 3.1 deep-research-pro-preview (pesquisa)*
*Gerado em 2026-04-02. Todos os dados são CANDIDATE até verificação PMID independente.*
