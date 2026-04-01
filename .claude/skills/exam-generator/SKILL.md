---
name: exam-generator
description: >
  Generate calibrated practice exams with anti-cue protocol (NBME-aligned),
  Anki cards, and study materials for Brazilian medical boards. Use this skill
  when the user wants to create practice questions, generate simulados, analyze
  past exams, create flashcards from errors, or calibrate question difficulty
  by specific boards (ENARE, USP, UNICAMP, SUS-SP, etc). Also trigger for
  'gerar questoes', 'simulado', 'item-writing', 'anti-cue', or 'flashcards'.
---

# Skill: Gerador de Questoes para Concurso (Exam Generator)

Gera simulados, Anki cards e material de estudo a partir de provas de bancas
de referencia fornecidas pelo usuario. Sempre com referencias tier 1 atuais.

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
9. **Cognitive level bias** — LLMs enviesam para recall, nao aplicacao/analise [7]
10. **Sinal latente de corretude** — LLMs embutem "correctness signal" nas representacoes internas [8]

### Referencias
[1] Adv Physiol Educ. 2025. DOI: 10.1152/advan.00106.2024
[2] Sci Rep (Nature). 2025. DOI: 10.1038/s41598-025-26036-7
[3] BMC Med Educ. 2024. PMC10981304
[4] BMC Med Educ. 2025. PMC11854382
[5] BMC Med Educ. 2025. PMC11806894
[6] JMIR Med Educ. 2025. PMC12143854
[7] PMC11178968
[8] arXiv:2509.10625. 2025
[9] arXiv:2602.06221. 2025
[10] Pak J Med Sci. 2025. PMID: 40103875
[11] NBME AI in Assessment. Mar 2024.
[12] arXiv:2507.19885. 2025

## Solucao: Protocolo Anti-Cue (NBME-Aligned)

### Gold Standard: NBME Item-Writing Guide
Referencia: https://www.nbme.org/educators/item-writing-guide

### Prompt Universal para Refinamento (Cho et al., 2025)
Validado para refinar questoes USMLE-style com NBME guidelines,
patient-centered language, bias checks, APPLICATION (Bloom 3+).
Ref: Cho et al. Med Sci Educ. 2025. DOI: 10.1007/s40670-025-02334-7

## Protocolo de Geracao de Questoes

### Fase 1: Ingestao de Provas de Referencia (RAG)
```
Input: PDF/texto da prova da banca
→ Parse: extrair questoes, alternativas, gabarito
→ Analise: classificar por especialidade, topico, Bloom level, dificuldade
→ Indexar: armazenar no SQLite para RAG
→ Profile: criar "perfil da banca" (estilo, distribuicao, armadilhas tipicas)
```

### Fase 2: Geracao (Anti-Cue Protocol)
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
□ "Cover-the-options" test: lead-in respondivel SEM ver alternativas
```

### Fase 3: Validacao Cruzada
```
1. Opus gera questao + aplica checklist
2. Apresenta questao SEM gabarito a ChatGPT 5.4
3. Se acertou "facil demais" (confidence >0.95): REFAZER
4. Se errou com justificativa razoavel: APROVADA
5. Se indeciso entre 2-3 opcoes: APROVADA (ajustar se ambiguidade real)
```

### Fase 4: Output

#### Formato Simulado
```markdown
## Simulado [Banca] - [Especialidade] - [Data]

### Questao 1
[Vinheta clinica completa]
Qual [lead-in]?
a) ... b) ... c) ... d) ... e) ...

### Gabarito Comentado (apos resolucao)
**Q1: Resposta: [letra]**
Justificativa: [mecanismo/raciocinio]
Por que as outras estao erradas: [cada distrator]
Referencia: [Guideline/Paper, Ano. DOI/PMID]
```

#### Formato Anki Card
```
Front: [Pergunta atomica derivada do erro]
Back: [Resposta concisa]
Extra: [Mecanismo/explicacao curta]
Reference: [Fonte tier 1 com PMID/DOI]
Tags: [especialidade, topico, banca, dificuldade]
```

## Desempenho de LLMs em Provas Brasileiras

| Exame | Modelo | Acuracia | Referencia |
|-------|--------|----------|-----------|
| ENARE 2020-2024 | GPT-4 | 88.9% | Rev DELOS, 2025 |
| Nefrologia BR | GPT-4 | 79.8% | Braz J Nephrol, 2025 |
| Radiologia CBR | ChatGPT 3.5 | 53.3% | Radiol Bras, 2024 |
| Revalida 2023 | GPT-3.5/Bard | >60% | Rev Atencao Saude, 2024 |
| Portugal | GPT-4o | 83% | Acta Med Port, 2025 |

## Regras Fundamentais

1. **So bancas indicadas pelo usuario** — nunca inventar fonte
2. **Checklist anti-cue OBRIGATORIO** — toda questao passa pelo checklist
3. **Cross-validation** — questao suspeita de ter cue = refazer
4. **Referencias tier 1** — toda resposta referenciada com DOI/PMID
5. **Portugues brasileiro** — linguagem das provas nacionais
6. **Bloom >= 3** — aplicacao, analise, sintese. Nunca recall puro
7. **Position randomizada** — distribuir correta uniformemente entre a-e
8. **Cover-the-options** — lead-in respondivel sem ver alternativas
