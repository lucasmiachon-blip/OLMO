# Query Template — Gemini Deep Research v2

> v2: prompt aberto. Gemini pesquisa livre, Claude organiza depois.
> Preencher campos `{...}` antes de chamar gemini-deep-research.

---

## Query (enviar como parametro `query`)

```
Topic: {TOPICO}
Context: {CONTEXTO — 1 frase: quem vai usar, em que nivel}

I need an objective, thorough investigation of this topic. Not a summary of what is commonly believed — a critical examination of what the strongest evidence actually says.

Questions to investigate:

1. What do the major authorities say about this? (society guidelines, Cochrane, landmark trials, reference textbooks). For each authority: what is their position, what evidence do they base it on, and when was it last updated?

2. Where do different authorities AGREE? What is the consensus, and how strong is it?

3. Where do they DISAGREE? What explains the disagreement — different evidence base, different populations, different interpretation of the same data, or different values/priorities?

4. What are the concrete numbers? Effect sizes with confidence intervals, NNT when calculable, incidence rates, diagnostic accuracy metrics. Numbers without confidence intervals are incomplete — flag them.

5. What are the strongest criticisms or limitations of the current evidence? Surrogate endpoints, small sample sizes, industry funding, population mismatch, lack of replication.

6. What questions remain genuinely unanswered?

7. Are there Brazilian guidelines or data sources relevant to this topic? (CONITEC, PCDT, SBH, SBC, SBHPA, ANVISA)

Requirements:
- Every claim must have a verifiable source (PMID, DOI, or full citation with journal/year)
- Every finding must include concrete numbers when they exist
- Report what you find, not what you think I want to hear
- If evidence is weak, conflicting, or absent — say so explicitly
- Do not force findings into predetermined categories
- Organize your report in whatever structure best represents what you found
```

---

## Format (enviar como parametro `format`)

```
Structured research report in Portuguese (PT-BR), medical terms in English when standard. Include PMID or DOI for every citation. Provide concrete numbers (effect sizes, confidence intervals, NNT, p-values) whenever available. Organize freely — use whatever structure best fits the findings.
```

---

## Pos-processamento (Claude faz apos receber o raw output)

O Gemini vai devolver um report em formato livre. Claude le e extrai:

### O que extrair

1. **Fontes encontradas**: listar cada uma com tipo (guideline, MA, RCT, livro, coorte), citacao, e dado principal
2. **Convergencias**: onde 2+ autoridades concordam — com fontes
3. **Divergencias**: onde discordam — posicao de cada, ano, base, qual mais recente/forte
4. **Numeros concretos**: effect sizes, IC 95%, NNT, p-values, n — tabela quando possivel
5. **Criticas e limitacoes**: o que o Gemini flagou sobre qualidade da evidencia
6. **Gaps**: perguntas sem resposta
7. **Dados para slide**: max 3 estatisticas prontas para speaker notes, com fonte e sugestao de uso

### Regras do pos-processamento

- Se o Gemini nao encontrou algo, nao inventar. Ausencia = dado.
- Nao adicionar GRADE se o Gemini nao avaliou qualidade — reportar como encontrado.
- Nao reclassificar fontes. Se o Gemini chamou de "estudo observacional", nao promover a "RCT".
- PMIDs: marcar TODOS como `[CANDIDATE]` — verificacao e outro passo.
- Se o Gemini contradiz algo que o Claude sabe, reportar ambas as versoes. Nao editar silenciosamente.

### Template do report final

```
## Deep Search Report: [Topico]
Data: [YYYY-MM-DD] | Fonte: Gemini 3.1 + Google Search
Status PMIDs: CANDIDATE

### Fontes Tier 1 encontradas
(listar cada fonte com tipo, citacao, dado principal)

### Convergencias
(onde autoridades concordam — com fontes)
(se nenhuma: "Nenhuma convergencia clara identificada")

### Divergencias
(onde discordam — posicao de cada, base)
(se nenhuma: "Nenhuma divergencia identificada nesta pesquisa")

### Numeros concretos
(tabela quando possivel)

### Limitacoes da evidencia
(o que o Gemini flagou)

### Gaps
(perguntas sem resposta)

### Dados para slide (max 3)
- Dado — Fonte — Como usar na apresentacao

### Fontes completas
(todas as referencias citadas pelo Gemini)
```

Se uma secao ficou vazia, mante-la com "Nao identificado nesta pesquisa" — a ausencia informa.

---

## Notas

- **Tempo**: ~2-5 min (assincrono)
- **Custo**: ~$0.02-0.05 por query
- **Follow-up**: `gemini-research-followup` para aprofundar gaps
- **Cross-validation**: rodar /research (Claude MCPs) em paralelo e comparar
