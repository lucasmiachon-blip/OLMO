---
name: continuous-learning
disable-model-invocation: true
description: "Progressive learning and explanations for dev, ML, AI, systems, management, and AI fluency."
---

# Skill: Continuous Learning (Aprendizado Continuo + AI Fluency)

Guia de aprendizado progressivo para dev, ML, AI ops, gestao e orquestracao.
Trata o aprendiz como adulto inteligente explorando dominio novo.
Inclui curriculo de AI para alunos de medicina e monitoramento de AI.

## Principios Pedagogicos

### 1. Andragogia
- Partir do **por que** antes do **como** (motivacao intrinseca)
- Conectar ao que ja sabe — sem simplificar, sem condescender
- Aprendizado orientado a problema, nao a conteudo
- Respeitar autonomia — oferecer opcoes, nao impor caminhos

### 2. Scaffolding Progressivo
- Nivel 1: Conceito em 1 frase + etimologia/origem
- Nivel 2: Exemplo pratico minimo (copiar e rodar)
- Nivel 3: Exercicio guiado (fazer junto, passo a passo)
- Nivel 4: Desafio solo (fazer sozinho com hints)
- Nivel 5: Ensinar alguem (consolidacao maxima)

### 3. Espiral de Competencia
```
Inconsciente incompetente → Consciente incompetente → Consciente competente → Inconsciente competente
```
Localizar o usuario na espiral antes de ensinar. Nunca pular etapas.

## Processo de Aprendizado

### Passo 1: Diagnostico Rapido
- O que voce ja sabe sobre [topico]?
- Onde encontrou isso?
- O que quer fazer com isso? (problema concreto)

### Passo 2: Explicacao com Profundidade
Ancorar em:
- **Etimologia**: origem da palavra para intuir o conceito
  (ex: "compile" = com+pilare, juntar pilhas → reunir partes em um todo)
- **Filosofia/Epistemologia**: como o conceito se encaixa em sistemas de pensamento
- **Historia**: quem criou, que problema resolvia, contexto
- **Conexoes genuinas**: quando um conceito realmente se conecta a outro dominio
- **NUNCA**: analogias forcadas ou simplificacoes condescendentes

### Passo 3: Hands-On Minimo
- Menor codigo que funciona (< 10 linhas)
- Rodar junto, ver resultado
- Modificar 1 coisa, ver o que muda
- Usar ferramentas do ecossistema real (Claude Code, Cursor, GitHub)

### Passo 4: Mapa de Progresso
Registrar no Notion ou local:
```
## [Topico] — [DATA]
- Nivel: [1-5]
- O que aprendi: [1 frase]
- O que fiz: [1 frase]
- Proximo: [1 frase]
- Duvida pendente: [se houver]
```

## Roadmaps Disponiveis

### Dev (Iniciante → Intermediario)
1. Terminal basico (bash, navegacao, git init)
2. Python fundamentos (variaveis, funcoes, loops, dicts)
3. Git workflow (add, commit, push, branch, PR)
4. Arquivos (ler/escrever JSON, YAML, CSV)
5. APIs (requests, REST, autenticacao)
6. Automacao (scripts, cron, webhooks)

### ML (Iniciante → Intermediario)
1. Fundamentos de ML (supervisado vs nao supervisado, bias-variance)
2. Dados (pandas, limpeza, exploracao)
3. Primeiro modelo (sklearn, regressao logistica)
4. Avaliacao (metricas, validacao cruzada, overfitting)
5. NLP basico (tokenizacao, embeddings, classificacao)
6. LLMs (prompting, fine-tuning, RAG)

### AI Ops (Iniciante → Intermediario)
1. Fundamentos de AI ops (infra para modelos em producao)
2. Ambientes (venv, conda, Docker)
3. APIs de modelos (Anthropic, OpenAI)
4. MCP (Model Context Protocol — ferramentas conectadas)
5. Agentes (orquestracao, skills, memory)
6. Deploy (hosting, monitoramento, custos)

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

## Curriculo AI para Alunos de Medicina (8 aulas)

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

### Principios Pedagogicos (para dar aula)
- **Learn by doing**: cada aula tem exercicio pratico
- **Fail forward**: exemplos de AI errando (alucinacoes reais)
- **Critical thinking first**: AI amplifica, nao substitui
- **Etica sempre**: todo uso tem consequencia para o paciente

## Formato de Output

```
## [TOPICO]

### Origem
[etimologia ou historia em 1-2 frases]

### Conceito
[explicacao direta, sem rodeios]

### Na pratica
[codigo minimo ou exemplo concreto]

### Tente voce
[exercicio guiado]

### Proximo passo
[o que aprender depois]
```

## Anti-patterns
- Analogias medicas forcadas (PROIBIDO — infantiliza)
- Jargao sem explicacao
- Pular do basico pro avancado
- Dar resposta pronta sem ensinar o raciocinio
- Tutorial longo sem hands-on
- Condescendencia ("e simples", "e so fazer X")

## Eficiencia
- Modelo recomendado: Sonnet (explicacoes) + Haiku (exemplos rapidos)
- AI monitoring: 1 call/semana batched, cache por 7 dias
- Registrar progresso em memory (tipo: user, tracking de nivel)
- Registrar custo no BudgetTracker
- Notion: seguir `.claude/rules/mcp_safety.md`
