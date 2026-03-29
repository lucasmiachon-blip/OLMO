---
name: ai-learning
description: "AI fluency (ensino + dev AI continuo) + monitoring (modelos, tools, benchmarks). Ativar para dominar/ensinar AI ou monitorar novidades."
---

# Skill: AI Learning (Ensino + Monitoring + Dev AI)

Dominar AI fluentemente para transmitir aos alunos e manter o ecossistema atualizado.

## Quando Ativar
- Preparacao de aulas sobre AI para alunos de medicina
- Sessoes de aprendizado Dev AI (2x/semana)
- Digest de noticias, novos modelos, benchmarks
- Comparacao de modelos ou tools

## Curriculo Progressivo (8 aulas para alunos de medicina)

### 1. Fundamentos (aula 1-2)
- O que e LLM, o que pode e nao pode fazer
- Alucinacoes: por que AI inventa e como detectar
- Prompt engineering basico: contexto + instrucao + formato
- Etica: plagiarism, LGPD, bias, limites do uso clinico

### 2. Uso Responsavel na Medicina (aula 3-4)
- AI como "residente inteligente" — sempre verificar com fontes primarias
- PubMed + AI: busca assistida, nao substituicao
- Quando AI ajuda: triagem, resumos, traducao, formatacao
- Quando AI atrapalha: diagnostico, prescricao, decisao clinica sem supervisao

### 3. Ferramentas Praticas (aula 5-6)
- Claude/ChatGPT para estudo: flashcards, explicacoes, quiz
- Perplexity para pesquisa com fontes citadas
- NotebookLM para estudar papers (podcast, Q&A)
- Notion AI para organizacao, Zotero + AI para referencias

### 4. Avancado (aula 7-8)
- Prompt engineering medico: PICO como prompt, GRADE como checklist
- Workflow pessoal: captura → processamento → publicacao
- MCP e agentes: o futuro da automacao medica

## Principios Pedagogicos
- **Learn by doing**: cada aula tem exercicio pratico
- **Fail forward**: exemplos de AI errando (alucinacoes reais)
- **Critical thinking first**: AI amplifica, nao substitui
- **Etica sempre**: todo uso tem consequencia para o paciente

## Dev AI — Aprendizado Continuo (2x/semana)

Sessoes curtas (30-60min) focadas em alto ROI.

### Fontes Obrigatorias
| Fonte | Frequencia | ROI |
|-------|-----------|-----|
| Anthropic Blog | Semanal | Muito Alto |
| OpenAI Blog | Semanal | Alto |
| Simon Willison Blog | Semanal | Muito Alto |
| GitHub Trending | Semanal | Alto |
| Hacker News (AI) | 2x/semana | Alto |
| Latent Space Podcast | Quinzenal | Alto |

### Foco Alto ROI
1. MCP servers: criar, configurar, usar
2. Claude Code / Agent SDK: automacao real
3. Prompt engineering avancado: system prompts, tool use
4. Agentic patterns: orchestrator, evaluator, tool-use loops
5. Local models (Ollama): quando usar vs API

### Formato da Sessao
```
1. Curar fontes (15min) → top 3 headlines
2. Deep dive 1 topico (30min) → hands-on
3. Nota Obsidian (10min) → o que aprendi
4. Opcional: aplicar no ecossistema → PR, skill, workflow
```

## AI Monitoring — Modelos e Benchmarks

### Fontes Prioritarias
Anthropic, OpenAI, Google, Meta, Mistral, HuggingFace, Papers With Code, GitHub Trending.

### Formato do Digest
```
## AI Digest - [DATA]
### Lancamentos | Tendencias | Precos/Mudancas | Paper da Semana
```

### Eficiencia
- 1 call/semana batched
- Cache por 7 dias
- Registrar custo no BudgetTracker
- Referenciar fontes com URL + data de acesso
- Notion: seguir `.claude/rules/mcp_safety.md`
