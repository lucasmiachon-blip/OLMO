---
name: knowledge-ingest
disable-model-invocation: true
description: "Transforma fontes (PDF, YouTube, URL, PMID) em nota Obsidian + comandos NotebookLM."
version: 1.0.0
---

# Knowledge Ingest — De qualquer fonte para conhecimento organizado

Você recebeu uma fonte para processar. Seu trabalho é transformá-la em dois outputs: uma nota Obsidian de alta qualidade e um bloco de comandos NotebookLM prontos para usar.

## Por que isso importa

O Lucas é médico, professor e pesquisador. Ele precisa absorver papers, aulas e livros de forma eficiente, com referências verificáveis (PMIDs, DOIs). Cada nota que você gera pode ser usada para: preparar aulas, estudar para o concurso R3, ou construir uma base de conhecimento médica interconectada. A qualidade da nota impacta diretamente a qualidade do ensino e do estudo.

## Step 1 — Identificar a fonte

Detecte o tipo de fonte que o usuário forneceu:

| Tipo | Como identificar | Ação |
|------|------------------|------|
| **PMID** | Número puro (ex: `35934266`) ou `PMID:35934266` | Buscar metadata via PubMed MCP |
| **DOI** | Padrão `10.xxxx/...` | Buscar via SCite (search_literature) com DOI |
| **URL PubMed** | `pubmed.ncbi.nlm.nih.gov/...` | Extrair PMID da URL, buscar metadata |
| **URL YouTube** | `youtube.com/watch?v=...` ou `youtu.be/...` | Extrair título e conteúdo via WebFetch |
| **URL artigo** | Qualquer URL web | Extrair conteúdo via WebFetch |
| **PDF** | Arquivo `.pdf` no projeto | Ler com Read tool (respeitar regra: nunca PDF inteiro no contexto) |
| **TXT/MD** | Arquivo texto | Ler diretamente |
| **Tópico livre** | Texto descritivo (ex: "heterogeneidade em metanálise") | Buscar no PubMed + SCite |

Para papers médicos, sempre tente obter o PMID — é o identificador canônico. Se a fonte original não tem PMID, marque como `[SEM-PMID]`.

## Step 2 — Extrair informação

### Para papers (PMID/DOI):
1. Buscar metadata completa: título, autores, journal, ano, abstract
2. Se disponível no SCite: buscar Smart Citations (supporting/contrasting) — isso mostra se a comunidade concorda ou discorda
3. Classificar tipo de estudo: meta-analysis, systematic review, RCT, cohort, case-control, case report, guideline, narrative review
4. Extrair dados-chave do abstract: população, intervenção, comparador, outcomes, resultados principais (PICO)

### Para YouTube:
1. Obter título e descrição via WebFetch
2. Resumir os pontos principais
3. Identificar se há papers/referências mencionados na descrição
4. Nota: sem transcrição automática aqui — o NotebookLM fará o deep dive

### Para PDFs e textos:
1. Ler conteúdo (máx primeiras 20 páginas para PDFs)
2. Extrair estrutura: títulos, seções, conclusões
3. Identificar referências citadas (buscar PMIDs se possível)

### Para tópico livre:
1. Buscar no PubMed: query tier 1 (meta-analyses, systematic reviews) dos últimos 5 anos
2. Buscar no SCite: papers mais citados e com mais supporting citations
3. Selecionar os 5-8 papers mais relevantes
4. Processar cada um como paper individual

## Step 3 — Gerar nota Obsidian

Salvar em `resources/<slug>.md` no projeto OLMO. O slug é o título em kebab-case sem acentos.

### Template da nota:

```markdown
---
title: [Título em português]
type: note
tags:
  - [tag-1]
  - [tag-2]
  - [especialidade]
created: [YYYY-MM-DD]
updated: [YYYY-MM-DD]
last_review: [YYYY-MM-DD]
evidence_level: [I, II, III, IV, V ou N/A]
source_type: [paper, youtube, book, guideline, lecture, topic-review]
---

# [Título]

## Resumo
[2-3 parágrafos com os pontos essenciais. Para papers: contexto, método, resultado principal, conclusão. Para vídeos/livros: tese central, argumentos-chave, takeaways.]

## Pontos-Chave
- [Cada ponto deve ser uma afirmação verificável, não genérica]
- [Incluir números quando disponíveis: NNT, HR, IC 95%, p-value]
- [Marcar afirmações incertas com (?) ]

## Evidência
[Para papers: tipo de estudo, n, follow-up, outcomes primários, resultados com IC]
[Para outros: nível de evidência estimado e justificativa]

## Aplicação Clínica
[Como isso muda a prática? O que muda para o paciente?]
[Se não aplicável (ex: vídeo de metodologia), pular esta seção]

## Referências
- **[Título do paper]** [tipo_estudo] ([Autores]) PMID:[número] https://pubmed.ncbi.nlm.nih.gov/[número]/
  > [Trecho relevante do abstract]
[Repetir para cada referência]

## Links
- [[Nota-relacionada-1]]
- [[Nota-relacionada-2]]
[Verificar quais notas já existem em resources/ antes de criar wikilinks]
```

### Regras da nota:
- **evidence_level**: I = SR/MA, II = RCT, III = cohort, IV = case series, V = expert opinion, N/A = não-clínico
- **Tags**: sempre incluir a especialidade médica + o tipo de conteúdo
- **Wikilinks**: só linkar notas que existem em `resources/`. Listar `ls resources/` antes de criar links
- **PMIDs**: todo PMID citado deve ter sido verificado via PubMed MCP. Se não verificado, marcar como `[CANDIDATE]`
- **Idioma**: título e conteúdo em português. Termos técnicos podem ficar em inglês entre parênteses

## Step 4 — Gerar comandos NotebookLM

Depois de criar a nota Obsidian, gerar um bloco de comandos CLI prontos para o usuário executar no Claude Code. O NotebookLM é onde o estudo profundo acontece — quizzes, flashcards, podcasts.

### Template de comandos:

```bash
# ============================================
# NotebookLM — [Título do tópico]
# Gerado por knowledge-ingest | [data]
# ============================================

# 1. Criar notebook (ou usar existente)
nlm notebook create "[Título]"
nlm alias set [alias-curto] <notebook-id>

# 2. Adicionar fontes
[Para cada fonte identificada:]
nlm source add [alias] --url "https://pubmed.ncbi.nlm.nih.gov/[PMID]/" --wait
# OU para YouTube:
nlm source add [alias] --url "https://youtube.com/watch?v=[ID]" --wait
# OU para texto/PDF local:
nlm source add [alias] --file "[caminho]" --wait

# 3. Gerar material de estudo
nlm quiz create [alias] --count 10 --difficulty 3 --focus "[tópicos-chave extraídos]" --confirm
nlm flashcards create [alias] --difficulty medium --focus "[números-chave, definições]" --confirm
nlm audio create [alias] --format deep_dive --confirm

# 4. Verificar e baixar
nlm studio status [alias]
nlm download quiz [alias] --format html --output [alias]-quiz.html
nlm download audio [alias] --output [alias]-podcast.mp3
```

### Regras dos comandos:
- **--focus** deve conter terminologia clínica específica do tópico, não genérico
- **alias** deve ser curto e memorável (ex: `grade-ma`, `valgimigli-dapt`)
- Se o tópico é para concurso R3, adicionar tags: `nlm tag add [alias] --tags "concurso,r3,2026,[especialidade]"`
- Se há múltiplas fontes, agrupar num único notebook temático
- Lembrar: `--confirm` é obrigatório em todo comando de geração

## Step 5 — Apresentar resultado

Mostrar ao usuário:
1. **Nota criada**: caminho do arquivo e preview das primeiras linhas
2. **Bloco de comandos**: pronto para copiar
3. **Sugestões**: notas relacionadas que poderiam ser criadas, links que poderiam ser adicionados
4. **Se houver PMIDs não verificados**: listar claramente como `[CANDIDATE]`

## Quando NÃO usar esta skill

- Para editar slides da aula (usar slide-authoring)
- Para rodar o QA pipeline (usar qa-pipeline)
- Para busca profunda multi-perna (usar /research)

Esta skill é o **primeiro passo** — ingerir conhecimento. O que vem depois (slides, QA, publicação) são skills diferentes.
