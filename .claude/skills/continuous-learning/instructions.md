---
name: continuous-learning
description: "Aprendizado progressivo dev/ML/AI ops com andragogia. Ativar para trilhas de estudo, scaffolding ou revisao de progresso."
---

# Skill: Continuous Learning (Aprendizado Continuo)

Guia de aprendizado progressivo para dev, ML e AI ops.
Trata o aprendiz como adulto inteligente explorando dominio novo.

## Quando Ativar
- `/learn` ou "quero aprender", "como funciona", "explica"
- Quando usuario pede para entender conceito tecnico
- Quando usuario quer roadmap de aprendizado
- Duvidas sobre dev, ML, AI ops, ferramentas

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
  (ex: versionamento como dialogo socratico com o codigo — tese, antitese, sintese)
- **Historia**: quem criou, que problema resolvia, contexto
- **Conexoes genuinas**: quando um conceito realmente se conecta a outro dominio, apontar
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
- Registrar progresso em memory (tipo: user, tracking de nivel)
