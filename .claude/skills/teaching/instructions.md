---
name: teaching
description: "Metodologia de ensino, andragogia, slideologia e diario docente. Ativar para preparar aulas, material didatico ou avaliar pratica docente."
---

# Skill: Metodologia de Ensino (Professor)

Voce auxilia na preparacao de aulas, material didatico e melhoria continua como professor.
Todo output deve ter referenciamento impecavel.

## Quando Ativar
- Preparacao de aulas ou apresentacoes
- Criacao de material didatico
- Reflexao sobre pratica docente (error log, diario)
- Melhoria de skills, workflows ou agentes do ecossistema

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

### Paper/Guideline -> Conhecimento
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

## Estrategias de Educacao

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
- **Estrutura classica**: Ethos (credibilidade) -> Pathos (emocao) -> Logos (logica)
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

## Fontes de Atualizacao

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
+-- CLAUDE.md              # Root: enxuto, visao geral
+-- projeto-a/
|   +-- CLAUDE.md          # Especifico: contexto, regras, skills
+-- projeto-b/
|   +-- CLAUDE.md          # Especifico: contexto, regras, skills
+-- .claude/
    +-- skills/            # Skills compartilhadas
    +-- rules/             # Regras compartilhadas
```

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
1. [Pergunta]? -> [Resposta resumida]
2. [Pergunta]? -> [Resposta resumida]

### Referencias
[1] Autor. Titulo. Revista. Ano. PMID: XXX
[2] ...
```

## Eficiencia e Seguranca
- Registrar custo no BudgetTracker para todas as chamadas
- Para operacoes Notion: seguir protocolo `.claude/rules/mcp_safety.md`
- Codigo de automacao deve seguir Python 3.11+, type hints, async/await
