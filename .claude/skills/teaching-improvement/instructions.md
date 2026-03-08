# Skill: Ensino e Autoaprimoramento

Voce auxilia no aprendizado continuo e melhoria dos projetos do ecossistema.
Todo output deve ter referenciamento impecavel.

## Quando Ativar
- Estudo de papers/guidelines para autoaprendizado
- Melhoria de skills, workflows ou agentes existentes
- Criacao de material de estudo
- Atualizacao de conhecimento medico ou dev

## Principios

### 1. Referenciamento Impecavel
Todo conteudo gerado deve conter:
- PMID para papers medicos
- DOI quando disponivel
- URL verificavel para fontes web
- Data de acesso para conteudo online
- Nivel de evidencia (quando medico)

Formato de referencia:
```
[1] Autor AB, et al. Titulo. Revista. Ano;Vol(Num):Pag. PMID: XXXXX. DOI: XX.XXXX
[2] Organizacao. Titulo do documento. URL. Acessado em: DD/MM/AAAA.
```

### 2. Autoaprimoramento do Projeto
O ecossistema deve melhorar continuamente:
- Cada projeto tem seu proprio CLAUDE.md especifico
- Skills devem evoluir com novas ferramentas/checklists
- Workflows devem ser refinados com base em uso real
- Agentes devem aprender padroes do usuario

### 3. Aprendizado Ativo
- Resumos com recall testing (perguntas ao final)
- Flashcards para conceitos-chave
- Conexoes com conhecimento previo (Zettelkasten)
- Espacamento (spaced repetition) para revisao

## Workflow de Estudo

### Paper/Guideline → Conhecimento
1. Upload/input do material
2. Extracao de conceitos-chave
3. Classificacao por relevancia e evidencia
4. Criacao de nota Obsidian (Zettelkasten)
5. Conexao com notas existentes (links bidirecionais)
6. Adicionar referencia no Zotero
7. Gerar perguntas de revisao
8. Publicar resumo no Notion (se compartilhavel)

### Melhoria de Projeto
1. Revisar uso recente do projeto
2. Identificar gaps ou ineficiencias
3. Propor melhorias concretas
4. Implementar com testes
5. Documentar no CLAUDE.md do projeto
6. Commitar com mensagem descritiva

## Estrategias de Educacao (Professor)

### Slideologia (Apresentacoes de Alto Impacto)
- **Principio**: slides sao apoio visual, nao teleprompter
- **Regra 10-20-30** (Guy Kawasaki): 10 slides, 20 min, 30pt font
- **Picture Superiority Effect**: imagens > texto para retencao
- **Assertion-Evidence** (Michael Alley): titulo = afirmacao, corpo = evidencia visual
- **Fontes**: Garr Reynolds (Presentation Zen), Nancy Duarte (Resonate), Edward Tufte

### Psicologia Cognitiva (Como o Aluno Aprende)
- **Carga cognitiva** (Sweller): intrinseca vs extrinseca vs germane
- **Dual Coding** (Paivio): visual + verbal juntos melhoram retencao
- **Testing Effect** (Roediger): testar > reler para fixacao
- **Spaced Repetition** (Ebbinghaus): revisao espacada combate esquecimento
- **Interleaving**: misturar topicos > estudar blocos
- **Elaborative Interrogation**: "por que isso funciona?" melhora compreensao
- **Desirable Difficulties** (Bjork): dificuldade produtiva fortalece memoria
- **Fontes**: Make It Stick (Brown/Roediger), Why Don't Students Like School (Willingham)

### Retorica e Oratoria
- **Estrutura classica**: Ethos (credibilidade) → Pathos (emocao) → Logos (logica)
- **Storytelling**: caso clinico como hook, dados como corpo, takeaway como fechamento
- **Tecnica Feynman**: explicar de forma simples = dominar o conteudo
- **Pausas estrategicas**: silencio > preencher com "eh", "tipo"
- **Fontes**: Talk Like TED (Gallo), The Art of Public Speaking (Dale Carnegie)

### Educacao de Adultos (Andragogia - Knowles)
Alunos de medicina sao adultos. Aprendem diferente de criancas.
- **Autonomia**: adultos querem controlar seu aprendizado
- **Experiencia**: usar casos clinicos reais como base (nao teoria abstrata)
- **Aplicabilidade imediata**: "vou usar isso amanha no plantao?"
- **Motivacao interna**: resolucao de problemas > nota na prova
- **Respeito**: tratar como colegas em formacao, nao como subordinados
- **Principios de Knowles**: self-directed, experience-based, relevancy-oriented
- **Fontes**: Malcolm Knowles (The Adult Learner), David Kolb (Experiential Learning)

### Pesquisa e Publicacao
Pesquisador ativo — bioestatistica e EBM como ferramentas centrais.
- **Bioestatistica**: dominar para publicar E para ensinar (ver skill mbe-evidence)
- **Publicacao**: todo projeto de pesquisa visa publicacao com rigor
- **Referenciamento**: PMID e DOI obrigatorios, sempre verificar fontes
- **Ferramentas**: Zotero, PubMed MCP, Scite, Elicit, Consensus
- **Checklists**: CONSORT, STROBE, PRISMA conforme tipo de estudo
- **Mentoria**: orientar alunos em TCC/IC com as mesmas ferramentas

### Error Log e Diario de Ensino
- **Formato**: data + aula + o que funcionou + o que nao funcionou + acao
- **Reflexao**: semanal, revisar padroes de erros e acertos
- **Template Notion**: criar database "Teaching Log" com properties:
  - Aula, Data, Topico, Feedback (positivo/negativo), Acao Corretiva, Tags
- **Growth mindset**: erros sao dados, nao falhas

### AI Fluency (para si e para transmitir aos alunos)
Objetivo: dominar AI fluentemente para poder transmitir essa fluencia aos alunos.
Principio: voce nao pode ensinar o que nao domina — primeiro domine, depois simplifique.

#### O Que Ensinar (curriculo progressivo)
1. **Fundamentos** (aula 1-2)
   - O que e LLM, o que pode e nao pode fazer
   - Alucinacoes: por que AI inventa e como detectar
   - Prompt engineering basico: contexto + instrucao + formato
   - Etica: plagiarism, LGPD, bias, limites do uso clinico

2. **Uso Responsavel na Medicina** (aula 3-4)
   - AI como "residente inteligente" — sempre verificar com fontes primarias
   - PubMed + AI: busca assistida, nao substituicao
   - Quando AI ajuda: triagem de literatura, resumos, traducao, formatacao
   - Quando AI atrapalha: diagnostico, prescricao, decisao clinica sem supervisao
   - Referenciamento: NUNCA confiar em referencias geradas por AI sem verificar PMID/DOI

3. **Ferramentas Praticas** (aula 5-6)
   - Claude/ChatGPT para estudo: flashcards, explicacoes, quiz
   - Perplexity para pesquisa com fontes citadas
   - NotebookLM para estudar papers (podcast, Q&A)
   - Notion AI para organizacao de estudo
   - Zotero + AI para referencias

4. **Avancado** (aula 7-8)
   - Prompt engineering medico: PICO como prompt, sistema GRADE como checklist
   - AI para apresentacoes: estruturar conteudo, gerar imagens, revisar slides
   - Workflow pessoal: captura → processamento → publicacao
   - MCP e agentes: o futuro da automacao medica

#### Principios Pedagogicos para Ensinar AI
- **Learn by doing**: cada aula tem exercicio pratico com AI
- **Fail forward**: mostrar exemplos de AI errando (alucinacoes reais)
- **Critical thinking first**: AI amplifica pensamento critico, nao substitui
- **Etica sempre**: todo uso tem consequencia para o paciente

### Concurso Nov/2026 — 120 Questoes Multipla Escolha (PRIORIDADE DO ANO)

Todo o ecossistema deve servir a esse objetivo. Ferramentas + ciencia do aprendizado.

#### Ciencia do Estudo para Provas (Evidence-Based Learning)

1. **Active Recall** (Roediger & Karpicke, 2006 - PMID: 17183309)
   - Testar-se > reler. Cada teste fortalece a memoria
   - Aplicar: resolver questoes ANTES de revisar teoria
   - Ferramenta: Anki, Claude quiz generator, bancos de questoes

2. **Spaced Repetition** (Ebbinghaus + Leitner System)
   - Revisao espacada combate curva do esquecimento
   - Intervalos: 1d → 3d → 7d → 14d → 30d → 90d
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

#### Planejamento Macro → Micro

```
MACRO (8 meses: mar-nov 2026)
├── Mar-Mai: Fundacao — cobrir todo conteudo 1x (leitura + resumo)
├── Jun-Ago: Consolidacao — questoes + revisao espacada + simulados
├── Set-Out: Intensivo — simulados semanais + revisao de erros
└── Nov: Polimento — revisao final + descanso estrategico

MESO (semanal)
├── Seg-Sex: 4-6h estudo/dia (blocos Pomodoro)
├── Sab: Simulado (120 questoes, cronometrado)
└── Dom: Revisao de erros do simulado + Anki + descanso

MICRO (diario)
├── Manha: Anki review (30min) + topico novo (2h)
├── Tarde: Questoes do topico (1.5h) + interleaving (1h)
└── Noite: Revisao rapida erros do dia (30min)
```

#### Anki Gerido por AI (Opus + ChatGPT 5.4)

O usuario nao cria cards manualmente. AI gera, prioriza e adapta.

**Fluxo:**
```
1. Usuario resolve questoes → registra erros no Notion (Error Log)
2. Opus le Error Log + desempenho → gera cards focados nos gaps
3. ChatGPT 5.4 valida cards (cross-validation: clareza, corretude, relevancia)
4. Cards aprovados → push para Anki via MCP (ankimcp/anki-mcp-server)
5. Anki agenda revisao (FSRS/spaced repetition automatico)
6. Opus analisa Anki retention rate → ajusta dificuldade e foco
```

**Tipos de cards gerados por AI:**
- **Error-based**: gerado direto do erro (ex: confundiu X com Y → card comparativo)
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

#### Ferramentas AI para o Concurso

| Ferramenta | Uso | Quando |
|-----------|-----|--------|
| **Anki + MCP** | Spaced repetition, cards gerados por Opus + 5.4 | Diario (review) |
| **Claude Opus** | Gera cards, analisa erros, adapta plano de estudo | Apos cada sessao |
| **ChatGPT 5.4** | Cross-valida cards, segunda opiniao em duvidas | Junto com Opus |
| **NotebookLM** | Estudar guidelines/papers (podcast, Q&A) | 2-3x/semana |
| **Perplexity** | Tirar duvidas rapidas com fontes | Ad hoc |
| **Banco de questoes** | Practice testing real | 3-5x/semana |
| **Notion** | Error log, tracking progresso, plano de estudo | Continuo |

#### Error Log de Questoes (Template Notion)
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

#### Metricas de Progresso
- % acerto por especialidade (meta: >70% geral, >80% nas fortes)
- Questoes resolvidas/semana (meta: 200+)
- Anki retention rate (meta: >85%)
- Anki cards gerados por AI / aceitos (quality rate)
- Simulados completos/mes (meta: 4)
- Trending: % acerto por semana (deve subir)

### Dev AI - Aprendizado Continuo (2x/semana)
Sessoes curtas (30-60min) focadas em alto ROI:

#### Fontes Obrigatorias (curar 2x/semana)
| Fonte | Frequencia | O Que Buscar | ROI |
|-------|-----------|-------------|-----|
| Anthropic Blog | Semanal | Novos modelos, features Claude | Muito Alto |
| OpenAI Blog | Semanal | Novos modelos, features ChatGPT | Alto |
| Hacker News (AI) | 2x/semana | Trending tools, libraries, debates | Alto |
| GitHub Trending | Semanal | Repos com alto star velocity | Alto |
| Simon Willison Blog | Semanal | LLM pragmatico, tools, MCP | Muito Alto |
| Latent Space Podcast | Quinzenal | Entrevistas com builders AI | Alto |
| AI News (tldr.tech) | 2x/semana | Curadoria rapida de noticias | Medio |

#### Foco Alto ROI (o que aprender agora)
1. **MCP servers**: criar, configurar, usar — padrao universal 2026
2. **Claude Code / Agent SDK**: automacao de workflows reais
3. **Prompt engineering avancado**: system prompts, tool use, function calling
4. **Agentic patterns**: orchestrator, evaluator, tool-use loops
5. **Local models (Ollama)**: quando usar vs API, fine-tuning basico

#### Formato da Sessao Dev AI
```
1. Curar fontes (15min) → ler headlines, salvar top 3
2. Deep dive em 1 topico (30min) → hands-on, testar
3. Nota no Obsidian (10min) → o que aprendi, como usar
4. Opcional: aplicar no ecossistema → PR, skill, workflow
```

## Fontes de Atualizacao Continua

### Estatistica e Metodologia
- Frank Harrell: fharrell.com (Bayesiano, trials)
- Andrew Gelman: statmodeling.stat.columbia.edu (Bayesiano, causal)
- StatQuest YouTube (bioestatistica visual)
- EQUATOR Network (reporting guidelines)

### MBE
- CEBM Oxford: cebm.net
- Cochrane Library: cochranelibrary.com
- Dr. Luis Correia: medicinabaseadaemevidencias.blogspot.com
- The Bottom Line: thebottomline.org.uk

### AI/Dev
- Anthropic Blog: anthropic.com/blog
- OpenAI Blog: openai.com/blog
- Simon Willison: simonwillison.net
- Hugging Face: huggingface.co
- Papers With Code: paperswithcode.com
- Latent Space: latent.space
- TLDR AI Newsletter: tldr.tech/ai

### Ensino e Apresentacoes
- Garr Reynolds: presentationzen.com
- Nancy Duarte: duarte.com/blog
- Michael Alley: assertion-evidence.com
- Make It Stick (livro): Brown, Roediger, McDaniel
- Retrieval Practice: retrievalpractice.org

## Estrutura de Projetos com CLAUDE.md

Cada projeto deve ter seu proprio MD:
```
repositorio/
├── CLAUDE.md              # Root: enxuto, visao geral
├── projeto-a/
│   └── CLAUDE.md          # Especifico: contexto, regras, skills
├── projeto-b/
│   └── CLAUDE.md          # Especifico: contexto, regras, skills
└── .claude/
    ├── skills/            # Skills compartilhadas
    └── rules/             # Regras compartilhadas
```

### CLAUDE.md Root (enxuto)
- Identidade do ecossistema (2-3 linhas)
- Arquitetura (diagrama simples)
- Convencoes de codigo
- Key files
- Como estender

### CLAUDE.md por Projeto
- Contexto especifico do projeto
- Dependencias e setup
- Testes e validacao
- Decisoes de arquitetura ja tomadas
- TODOs e proximos passos

## Eficiencia e Seguranca
- Registrar custo no BudgetTracker para todas as chamadas (Opus, ChatGPT, MCPs)
- Para operacoes Notion: seguir protocolo `.claude/rules/mcp_safety.md`
- Codigo de automacao deve seguir Python 3.11+, type hints, async/await

## Output de Estudo para Notion

```markdown
## [Topico] - Resumo de Estudo

### Conceitos-Chave
1. ...
2. ...

### Conexoes com Conhecimento Previo
- Relaciona-se com: [[nota-existente]]
- Contradiz/complementa: [[outra-nota]]

### Perguntas de Revisao
1. [Pergunta]? → [Resposta resumida]
2. [Pergunta]? → [Resposta resumida]

### Referencias
[1] Autor. Titulo. Revista. Ano. PMID: XXX
[2] ...
```
