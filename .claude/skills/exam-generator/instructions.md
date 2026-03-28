---
name: exam-generator
description: "Gera simulados calibrados por bancas, Anki cards e material de estudo. Ativar para criar questoes, analisar provas ou gerar flashcards."
---

# Skill: Gerador de Questoes para Concurso (Exam Generator)

Gera simulados, Anki cards e material de estudo a partir de provas de bancas
de referencia fornecidas pelo usuario. Sempre com referencias tier 1 atuais.

## Quando Ativar
- Gerar simulados baseados em provas de bancas especificas
- Criar Anki cards a partir de questoes/erros
- Referenciar estado da arte para estudo direcionado
- Analisar padroes de provas anteriores (temas, dificuldade, estilo)
- Spaced learning planning

## O Problema: LLMs Tendem a Dar Pistas na Questao

### Evidencia Cientifica (2024-2025)

**FATO 1**: 49% das questoes geradas por LLM contem item-writing flaws [1]
**FATO 2**: 22% contem erros factuais ou conceituais [1]
**FATO 3**: LLMs performam 39% pior em free-response vs MCQ, sugerindo que
usam as alternativas como pistas — e geram questoes da mesma forma [2]
**FATO 4**: Revisao sistematica (2024): TODOS os estudos encontraram questoes
defeituosas geradas por LLM, embora 5/8 considerem viavel com revisao [3]
**FATO 5**: Com quality assurance, questoes AI sao indistinguiveis de humanas [4]

### Item-Writing Flaws Comuns em Questoes Geradas por AI
1. **Alternativa correta mais longa** — LLM tende a elaborar mais a resposta certa
2. **Grammatical cues** — so uma alternativa encaixa gramaticalmente no enunciado
3. **Absolute terms** — distratores com "sempre", "nunca" (faceis de eliminar)
4. **Heterogeneidade** — distratores muito diferentes entre si em estilo/tamanho
5. **Convergencia logica** — varias pistas no enunciado apontam pra mesma resposta
6. **Distratores implausíveis** — alternativas que nenhum estudante real erraria
7. **"Testwise" cues** — padrao reconhecivel sem conhecer o conteudo
8. **Position bias** — Gemini favorece B, ChatGPT favorece A/B/C como correta [6]
9. **Cognitive level bias** — LLMs geram questoes enviesadas para recall/reconhecimento,
   nao aplicacao/analise. Operam por pattern matching, nao raciocinio genuino [7]
10. **Sinal latente de corretude** — LLMs embutem "correctness signal" nas representacoes
    internas; linear probe prediz resposta correta so pela questao, sem alternativas [8]

### Referencias
[1] LLM-Generated MCQ practice quizzes for preclinical students.
    Adv Physiol Educ. 2025. DOI: 10.1152/advan.00106.2024
[2] The pitfalls of MCQs in generative AI and medical education.
    Sci Rep (Nature). 2025. DOI: 10.1038/s41598-025-26036-7
[3] Large language models for generating medical examinations: systematic review.
    BMC Med Educ. 2024. PMC10981304
[4] Quality assurance and validity of AI-generated SBA questions.
    BMC Med Educ. 2025. PMC11854382
[5] AI vs human-generated MCQs: cohort study in high-stakes examination.
    BMC Med Educ. 2025. PMC11806894
[6] Answer position bias in AI-generated MCQs. JMIR Med Educ. 2025. PMC12143854
[7] Cognitive level bias in LLM-generated questions. PMC11178968
[8] Cencerrado et al. No Answer Needed: Predicting LLM Answer Accuracy from
    Question-Only Linear Probes. arXiv:2509.10625. 2025
[9] Balepur et al. BenchMarker: Education-Inspired Toolkit for Highlighting Flaws
    in MCQ Benchmarks. arXiv:2602.06221. 2025
[10] Sabqat et al. AI Meets Item Analysis: ChatGPT trained on NBME guide to detect
     MCQ flaws. Pak J Med Sci. 2025. PMID: 40103875. DOI: 10.12669/pjms.41.3.11224
[11] NBME. AI in Assessment: Ethics, Innovation and Research. Mar 2024.
     https://www.nbme.org/sites/default/files/2024-03/AI_in_Assessment_Executive_Summary.pdf
[12] Zero-shot performance of generative AI on FMUSP exam. arXiv:2507.19885. 2025

## Solucao: Protocolo Anti-Cue (NBME-Aligned)

### Gold Standard: NBME Item-Writing Guide
Referencia: https://www.nbme.org/educators/item-writing-guide
Livro: Case & Swanson, "Constructing Written Test Questions for the Basic
and Clinical Sciences" (NBME, atualizado periodicamente)

### Prompt Universal para Refinamento (Cho et al., 2025)
Existe um "Universal Prompt" validado para refinar questoes USMLE-style:
- Alinha com NBME guidelines
- Inclui patient-centered language
- Bias checks automaticos
- Focus em APPLICATION (Bloom nivel 3+), nao recall
Ref: Cho et al. Med Sci Educ. 2025. DOI: 10.1007/s40670-025-02334-7

## Protocolo de Geracao de Questoes

### Fase 1: Ingestao de Provas de Referencia (RAG)
O usuario fornece provas de bancas especificas (ex: ENARE, USP, UNICAMP, SUS-SP).
Estas servem como calibracao de estilo, dificuldade e formato.

```
Input: PDF/texto da prova da banca
→ Parse: extrair questoes, alternativas, gabarito
→ Analise: classificar por especialidade, topico, Bloom level, dificuldade
→ Indexar: armazenar no SQLite para RAG
→ Profile: criar "perfil da banca" (estilo, distribuicao, armadilhas tipicas)
```

### Fase 2: Geracao (Anti-Cue Protocol)
Para CADA questao gerada, aplicar checklist NBME:

```
CHECKLIST ANTI-CUE (obrigatorio antes de entregar qualquer questao)
─────────────────────────────────────────────────────────────────
□ Vinheta clinica realista (idade, sexo, queixa, exame, labs)
□ Lead-in claro: "Qual o diagnostico mais provavel?" / "Qual a conduta?"
□ 5 alternativas (padrao concurso brasileiro)
□ Alternativa correta NAO e a mais longa
□ Todas alternativas com tamanho similar (+/- 20% caracteres)
□ Todas alternativas gramaticalmente compativeis com o lead-in
□ Sem termos absolutos ("sempre", "nunca", "todos", "nenhum")
□ Todos os distratores sao plausíveis (erros reais de estudantes)
□ Sem convergencia logica (pistas no enunciado que apontem a resposta)
□ Bloom level >= 3 (aplicacao ou superior, NAO recall puro)
□ Nivel de dificuldade calibrado pela banca de referencia
□ Referencia tier 1 para a resposta correta (guideline/RS/RCT)
□ Posicao da alternativa correta RANDOMIZADA (distribuir a-e uniformemente)
□ "Cover-the-options" test: lead-in deve ser respondivel SEM ver alternativas
□ Registrar custo no BudgetTracker (Opus + ChatGPT 5.4 por questao)
```

### Fase 3: Validacao Cruzada
```
1. Opus gera questao + aplica checklist
2. Apresenta questao SEM gabarito a um segundo modelo (ChatGPT 5.4)
3. Segundo modelo tenta responder + justificar
4. Se acertou "facil demais" (confidence >0.95 + justificativa curta):
   → Questao provavelmente tem cue → REFAZER
5. Se errou com justificativa razoavel:
   → Distratores estao funcionando → APROVADA
6. Se nao conseguiu decidir entre 2-3 opcoes:
   → Dificuldade adequada → APROVADA (ajustar se ambiguidade real)
```

### Fase 4: Output

#### Formato Simulado
```markdown
## Simulado [Banca] - [Especialidade] - [Data]
Baseado no perfil: [nome da banca], [N] questoes, [tempo] minutos

### Questao 1
[Vinheta clinica completa]

Qual [lead-in]?

a) [Alternativa A]
b) [Alternativa B]
c) [Alternativa C]
d) [Alternativa D]
e) [Alternativa E]

---
### Gabarito Comentado (apos resolucao)

**Q1: Resposta: [letra]**
Justificativa: [explicacao do mecanismo/raciocinio]
Por que as outras estao erradas:
- a) [por que e plausível mas incorreta]
- b) [...]
Referencia: [Guideline/Paper, Ano. DOI/PMID]
Leitura recomendada: [estado da arte tier 1]
```

#### Formato Anki Card (gerado a partir de erros)
```
Front: [Pergunta atomica derivada do erro]
Back: [Resposta concisa]
Extra: [Mecanismo/explicacao curta]
Reference: [Fonte tier 1 com PMID/DOI]
Tags: [especialidade, topico, banca, dificuldade]
```

## Bancas de Referencia (fornecidas pelo usuario)

O usuario indicara quais bancas usar como calibracao. Exemplos:
- ENARE (Exame Nacional de Residencia)
- USP / FMUSP
- UNICAMP
- SUS-SP
- UERJ
- UNIFESP
- Santa Casa SP
- Outras indicadas pelo usuario

**IMPORTANTE**: So usar provas que o usuario fornecer explicitamente.
Nao inventar questoes de bancas nao fornecidas.

## Desempenho de LLMs em Provas Brasileiras (Evidencia 2024-2026)

Para calibrar: LLMs ja demonstram desempenho comparavel ou superior a humanos.

| Exame | Modelo | Acuracia | Referencia |
|-------|--------|----------|-----------|
| ENARE 2020-2024 | GPT-4 | 88.9% | Rev DELOS, 2025 |
| Nefrologia (residencia BR) | GPT-4 | 79.8% | Braz J Nephrol, 2025 |
| Radiologia CBR | ChatGPT 3.5 | 53.3% | Radiol Bras, 2024 |
| Revalida 2023 | GPT-3.5/Bard | >60% | Rev Atencao Saude, 2024 |
| Portugal (Prova Nacional) | GPT-4o | 124/150 (83%) | Acta Med Port, 2025 |

Implicacao: se o modelo acerta 89% do ENARE, ele CONHECE o conteudo.
O desafio e gerar questoes SEM dar pistas, nao falta de conhecimento.

## Spaced Learning Integration

### Fluxo Completo: Prova → Estudo → Retencao
```
1. Usuario resolve simulado gerado
2. Sistema registra erros no Error Log (Notion)
3. Para cada erro:
   a. Gerar Anki card focado no gap especifico
   b. Referenciar leitura tier 1 (guideline/paper mais atual)
   c. Classificar: conceito vs interpretacao vs desatencao
4. Anki agenda revisao (FSRS algorithm)
5. Apos revisao: re-testar com questao similar (interleaving)
6. Tracking: % retencao por topico ao longo do tempo
```

### Leitura do Estado da Arte (Tier 1 Only)
Para cada topico errado, referenciar na ordem de prioridade:
1. **Guideline atual** (sociedade brasileira/internacional, <3 anos)
2. **Revisao sistematica/meta-analise** (Cochrane, <5 anos)
3. **RCT landmark** (trial que mudou a pratica)
4. **UpToDate** (referencia rapida, sempre atualizado)
5. **Harrison's/Cecil** (referencia classica, ultima edicao)

### Formato de Referencia para Estudo
```
📖 Leitura Recomendada para [Topico]:
1. [Guideline] Sociedade X. "Titulo". Ano. DOI: xxx
   → Ler secao: [secao especifica relevante]
2. [Meta-analise] Autor et al. "Titulo". Revista. Ano. PMID: xxx
   → Foco: [achado principal relevante ao erro]
3. [Livro] Harrison's Cap XX, p. YYY-ZZZ (edicao mais recente)
```

## MKSAP Integration

ACP MKSAP (2025+) e all-digital, subscription-based, com ~2000 questoes.
**NAO existe API publica** para MKSAP. Integracao possivel apenas via:
- Uso manual no app/web (mksap.acponline.org)
- Anotar erros do MKSAP no Error Log → AI gera cards complementares
- Complementar MKSAP com questoes geradas calibradas por bancas brasileiras

## Eficiencia e Seguranca

### Cache (efficiency.md)
- Cachear perfis de bancas ja analisados no SQLite (evitar re-parse)
- Cachear questoes geradas anteriormente (evitar duplicatas)
- Verificar cache local antes de qualquer API call

### Notion Safety (mcp_safety.md)
- Para operacoes no Error Log (Notion): seguir protocolo completo de mcp_safety.md
- READ-ONLY padrao; WRITE so apos snapshot + aprovacao humana
- UMA operacao por vez; NUNCA batch automatico

### BudgetTracker
- Registrar custo de cada questao gerada (Opus + ChatGPT 5.4)
- Estimar: ~$0.15/questao (Opus gera + ChatGPT valida)
- Simulado 120 questoes ≈ $18 — planejar com antecedencia

## Regras Fundamentais

1. **So bancas indicadas pelo usuario** — nunca inventar fonte
2. **Checklist anti-cue OBRIGATORIO** — toda questao passa pelo checklist
3. **Cross-validation** — questao suspeita de ter cue = refazer
4. **Referencias tier 1** — toda resposta referenciada com DOI/PMID
5. **Portugues brasileiro** — linguagem das provas nacionais
6. **2026 = ano atual** — usar guidelines e evidencias mais recentes
7. **Bloom >= 3** — aplicacao, analise, sintese. Nunca recall puro
8. **Calibrar pela banca** — dificuldade e estilo devem espelhar a banca real
9. **Position randomizada** — distribuir correta uniformemente entre a-e
10. **Cover-the-options** — lead-in respondivel sem ver alternativas
