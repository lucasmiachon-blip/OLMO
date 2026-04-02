---
name: deep-search
description: |
  Pesquisa profunda via Gemini 3.1 deep-research com Google Search grounding em tempo real. Busca fontes Tier 1 (guidelines, meta-analises, RCTs landmark), dados concretos com numeros, divergencias e convergencias entre sociedades medicas. Use para "deep search", "pesquisa gemini", "buscar tier 1", "gemini profundo", "pesquisa profunda", "divergencia guidelines", "fontes fortes", "gemini search", "preciso de dados concretos sobre". Complementa /research (Claude MCPs) — ideal para cross-validation dual-model. Tambem funciona standalone quando o objetivo e descoberta ampla com grounding web.
version: 2.1.0
context: fork
agent: general-purpose
allowed-tools: Read, Grep, Glob
argument-hint: "[topico clinico OU slide-id OU ideia/h2] [--followup pergunta]"
---

# Deep Search — Gemini 3.1 Deep Research

Pesquisa para: `$ARGUMENTS`

Gemini deep-research usa Google Search grounding — acessa dados em tempo real. PMIDs do Gemini tem ~15-20% de erro, por isso todo PMID sai como CANDIDATE.

Esta skill separa duas responsabilidades: o Gemini PESQUISA (prompt aberto, sem estrutura forcada) e o Claude ORGANIZA (pos-processamento em formato padrao). Isso evita leading the witness — o Gemini pensa livremente, depois nos extraimos o que importa.

## Step 1 — Entender o input

**A) Slide-id** (ex: `s-rs-vs-ma`): grep nos HTMLs, ler o que existir. Ler CLAUDE.md da aula.
**B) Ideia/h2 solto**: slide nao existe ainda. Objetivo = descoberta fundacional.
**C) Topico livre**: pesquisa pura.

## Step 2 — Compor a query (ABERTA)

Ler `references/query-template.md` e preencher os campos. O template e intencionalmente aberto — faz perguntas ao Gemini em vez de ditar respostas. Isso porque:
- Prompt prescritivo forca o modelo a preencher caixas, mesmo sem dados
- Prompt aberto permite que o modelo surpreenda com achados inesperados
- Pesquisa objetiva comeca com perguntas, nao com conclusoes

O `format` parameter e minimo: pede citacoes e numeros, nao seccoes pre-definidas.

## Step 3 — Executar

1. `mcp__gemini__gemini-deep-research` com query aberta + format minimo
2. Guardar `researchId`
3. `mcp__gemini__gemini-check-research` ate completar (~2-5 min)
4. Se nao completo: informar usuario

## Step 4 — Limpeza minima

O Gemini retorna um report em formato livre. Esta skill faz apenas limpeza leve:

1. Marcar todo PMID/DOI como `[CANDIDATE]`
2. Remover afirmacoes sem fonte ("estudos mostram..." sem citacao = cortar)
3. Preservar a estrutura que o Gemini escolheu — nao reorganizar

O output desta skill e **materia-prima** para o orquestrador (/research), que faz:
- Cruzamento com achados dos MCPs do Claude (PubMed, SCite, Consensus)
- Verificacao de PMIDs via PubMed MCP
- Analise de convergencias/divergencias entre as duas pernas
- Classificacao GRADE e tags de tipo

Deep-search nao faz essas analises — quem cruza e o orquestrador.

## Step 5 — Entregar

```
## Deep Search Report: [Topico]
Data: [YYYY-MM-DD] | Fonte: Gemini 3.1 + Google Search
Status PMIDs: CANDIDATE (verificar via PubMed antes de usar)

[output do Gemini limpo — estrutura original preservada]

### Fontes citadas
[lista de todas as referencias com PMID/DOI marcados CANDIDATE]
```

## Step 5b — Follow-up (opcional)

Se gaps criticos: `gemini-research-followup` com pergunta especifica.

## Arquitetura

Esta skill e UMA PERNA de pesquisa. O fluxo completo:

```
/research (orquestrador)
├── /deep-search (Gemini) ── pesquisa livre, grounding web ── ESTA SKILL
├── Claude MCPs ── PubMed, SCite, Consensus, Scholar Gateway
└── Cruzamento ── convergencias/divergencias entre pernas, GRADE, verificacao PMID
```

Deep-search nao compete com os MCPs do Claude — eles veem fontes diferentes.
Gemini tem Google Search (web ampla, dados recentes). Claude MCPs tem PubMed (estruturado, PMIDs verificaveis).
O cruzamento entre os dois e onde a confianca real emerge.

## Principios

- **Prompt aberto.** Perguntas, nao instrucoes. Deixar o Gemini pensar.
- **Limpeza minima.** Nao reorganizar, nao reclassificar, nao inventar.
- **PMIDs CANDIDATE.** Sem excecao. Verificacao e trabalho do orquestrador.
- **Materia-prima, nao produto final.** O orquestrador cruza e decide.
