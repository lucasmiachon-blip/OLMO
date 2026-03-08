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
- Hugging Face: huggingface.co
- Papers With Code: paperswithcode.com

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
