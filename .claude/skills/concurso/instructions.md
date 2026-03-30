---
name: concurso
description: "Prep concurso dez/2026 (120 MCQs). Ativar para planejar estudo, gerar questoes calibradas ou revisar conteudo para prova."
---

# Skill: Concurso Dez/2026 — 120 Questoes Multipla Escolha

PRIORIDADE DO ANO. Todo o ecossistema deve servir a esse objetivo.
Ferramentas + ciencia do aprendizado.

> Para **gerar questoes/simulados**: use `/exam-generator` (metodologia de item-writing, anti-cue, calibracao por banca).

## Quando Ativar
- Planejamento de estudo para o concurso
- Resolucao/analise de questoes
- Geracao de cards Anki
- Simulados e analise de desempenho
- Error log de questoes
- Qualquer referencia ao concurso dez/2026

## Ciencia do Estudo para Provas (Evidence-Based Learning)

1. **Active Recall** (Roediger & Karpicke, 2006 - PMID: 17183309)
   - Testar-se > reler. Cada teste fortalece a memoria
   - Aplicar: resolver questoes ANTES de revisar teoria
   - Ferramenta: Anki, Claude quiz generator, bancos de questoes

2. **Spaced Repetition** (Ebbinghaus + Leitner System)
   - Revisao espacada combate curva do esquecimento
   - Intervalos: 1d -> 3d -> 7d -> 14d -> 30d -> 90d
   - Ferramenta: Anki com deck personalizado por especialidade
   - AI: Claude gera cards a partir de resumos/erros

3. **Interleaving** (Rohrer & Taylor, 2007)
   - Misturar topicos diferentes numa sessao > blocos isolados
   - Ex: 20min cardio + 20min pneumo + 20min neuro > 60min so cardio
   - Parece mais dificil = aprende mais (desirable difficulty)

4. **Elaborative Interrogation** (Pressley et al.)
   - Perguntar "POR QUE?" para cada fato
   - Conecta novo conhecimento com o que ja sabe
   - AI: Claude explica mecanismo, voce tenta antes

5. **Practice Testing** (Dunlosky et al., 2013 - meta-analise 10 tecnicas)
   - Alta utilidade: practice testing + distributed practice
   - Media: elaborative interrogation + interleaving
   - Baixa: reler, grifar, resumir passivamente
   - Ref: "Improving Students' Learning With Effective Learning Techniques"

6. **Pomodoro + Deep Work** (Cal Newport)
   - Blocos 50min estudo focado + 10min pausa
   - Sem celular/notificacoes durante bloco
   - Meta: 4-6 blocos/dia nos meses finais

## Planejamento Macro -> Micro

```
MACRO (8 meses: mar-nov 2026)
+-- Mar-Mai: Fundacao — cobrir todo conteudo 1x (leitura + resumo)
+-- Jun-Ago: Consolidacao — questoes + revisao espacada + simulados
+-- Set-Out: Intensivo — simulados semanais + revisao de erros
+-- Nov: Polimento — revisao final + descanso estrategico

MESO (semanal)
+-- Seg-Sex: 4-6h estudo/dia (blocos Pomodoro)
+-- Sab: Simulado (120 questoes, cronometrado)
+-- Dom: Revisao de erros do simulado + Anki + descanso

MICRO (diario)
+-- Manha: Anki review (30min) + topico novo (2h)
+-- Tarde: Questoes do topico (1.5h) + interleaving (1h)
+-- Noite: Revisao rapida erros do dia (30min)
```

## Anki Gerido por AI (Opus + ChatGPT 5.4)

O usuario nao cria cards manualmente. AI gera, prioriza e adapta.

**Fluxo:**
```
1. Usuario resolve questoes -> registra erros no Notion (Error Log)
2. Opus le Error Log + desempenho -> gera cards focados nos gaps
3. ChatGPT 5.4 valida cards (cross-validation: clareza, corretude, relevancia)
4. Cards aprovados -> push para Anki via MCP (ankimcp/anki-mcp-server)
5. Anki agenda revisao (FSRS/spaced repetition automatico)
6. Opus analisa Anki retention rate -> ajusta dificuldade e foco
```

**Tipos de cards gerados por AI:**
- **Error-based**: gerado direto do erro (ex: confundiu X com Y -> card comparativo)
- **Mechanism**: "Por que X causa Y?" (elaborative interrogation)
- **Clinical vignette**: mini-caso clinico com 1 pergunta-chave
- **High-yield**: fatos de alta incidencia em provas (baseado em analise de provas anteriores)
- **Interleaving**: card misturando 2 especialidades relacionadas

**Regras de geracao:**
- 1 conceito por card (atomico)
- Pergunta na frente, resposta curta atras
- Incluir referencia (fonte, pagina, PMID se aplicavel)
- Priorizar: erros recorrentes > erros unicos > conteudo novo
- Max 20 cards novos/dia (evitar overload)

**MCP Setup:**
```bash
# Requer Anki Desktop + AnkiConnect add-on (codigo 2055492159)
claude mcp add anki-mcp npx -- -y @ankimcp/anki-mcp-server
```

## Ferramentas AI para o Concurso

| Ferramenta | Uso | Quando |
|-----------|-----|--------|
| **Anki + MCP** | Spaced repetition, cards gerados por Opus + 5.4 | Diario (review) |
| **Claude Opus** | Gera cards, analisa erros, adapta plano de estudo | Apos cada sessao |
| **ChatGPT 5.4** | Cross-valida cards, segunda opiniao em duvidas | Junto com Opus |
| **NotebookLM** | Estudar guidelines/papers (podcast, Q&A) | 2-3x/semana |
| **Perplexity** | Tirar duvidas rapidas com fontes | Ad hoc |
| **Banco de questoes** | Practice testing real | 3-5x/semana |
| **Notion** | Error log, tracking progresso, plano de estudo | Continuo |

## Error Log de Questoes (Template Notion)
```
Database: "Concurso Error Log"
Properties:
  - Questao (title)
  - Especialidade (select)
  - Topico (select)
  - Erro: conceito vs interpretacao vs desatencao (select)
  - Explicacao correta (rich_text)
  - Referencia (rich_text)
  - Card Anki gerado? (checkbox)
  - Revisado em (date)
  - Acertou na revisao? (checkbox)
Tags: usado por Opus para gerar cards e identificar padroes de erro
```

## Metricas de Progresso
- % acerto por especialidade (meta: >70% geral, >80% nas fortes)
- Questoes resolvidas/semana (meta: 200+)
- Anki retention rate (meta: >85%)
- Anki cards gerados por AI / aceitos (quality rate)
- Simulados completos/mes (meta: 4)
- Trending: % acerto por semana (deve subir)
