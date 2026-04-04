# Query Template — Gemini Deep Search v3.0

> v3.0: prompt aberto com diretiva primaria Tier 1. Gemini pesquisa livre, Claude faz limpeza minima.
> Preencher campos `{...}` e enviar via `gemini -p "QUERY_COMPLETA" -o text`.

---

## Query (enviar como parametro `query`)

```
Topic: {TOPICO}
Context: {CONTEXTO — 1 frase: quem vai usar, em que nivel}

PRIMARY DIRECTIVE: Find the strongest, most authoritative sources on this topic. I need Tier 1 evidence — not blog posts, not narrative reviews, not opinion pieces. Specifically:
- Society guidelines and consensus statements (EASL, AASLD, AHA, ESC, ACG, WHO, Cochrane, and specialty-specific bodies)
- Reference textbooks and handbooks (Harrison's, Sleisenger, Braunwald, Oxford Handbook, UpToDate — with edition/year)
- Landmark trials (the RCTs that changed practice)
- High-quality meta-analyses and systematic reviews (Cochrane, PRISMA-compliant)
- Where authorities CONVERGE: what do multiple societies/sources agree on, and how strong is this consensus?
- Where authorities DIVERGE: what do they disagree on, why, and which position has stronger evidence?

These are not optional — they are the core deliverables.

Questions to investigate:

1. What do the major authorities say about this? For each: position, evidence base, year of last update.

2. Where do they AGREE? What is the consensus, and how strong is it?

3. Where do they DISAGREE? Different evidence, different populations, different interpretation, or different values?

4. What are the concrete numbers? Effect sizes with confidence intervals, NNT when calculable, incidence rates, diagnostic accuracy. Numbers without CI are incomplete — flag them.

5. What are the strongest criticisms or limitations? Surrogate endpoints, small samples, industry funding, population mismatch, lack of replication.

6. What questions remain genuinely unanswered?

7. Are there Brazilian guidelines or data? (CONITEC, PCDT, SBH, SBC, SBHPA, ANVISA, Ministerio da Saude)

Requirements:
- Every claim must have a verifiable source (PMID, DOI, or full citation with journal/year)
- Every finding must include concrete numbers when they exist
- Report what you find, not what you think I want to hear
- If evidence is weak, conflicting, or absent — say so explicitly
- Organize your report in whatever structure best represents what you found
```

---

## Format (enviar como parametro `format`)

```
Structured research report in Portuguese (PT-BR), medical terms in English when standard. Include PMID or DOI for every citation. Provide concrete numbers (effect sizes, confidence intervals, NNT, p-values) whenever available. Organize freely — use whatever structure best fits the findings.
```

---

## Pos-processamento (Claude faz apos receber o raw output)

O Gemini devolve um report em formato livre. Deep-search faz apenas limpeza minima — NAO reorganizar, NAO reclassificar. A analise pesada (cruzamento, GRADE, verificacao PMID) e trabalho do orquestrador `/research`.

### Limpeza minima (3 regras)

1. **PMIDs CANDIDATE**: Marcar todo PMID/DOI como `[CANDIDATE]`. Sem excecao. Verificacao via PubMed MCP e outro passo.
2. **Remover vaguezas**: Frases como "estudos mostram..." sem citacao = cortar. Se o Gemini nao citou fonte, nao manter a afirmacao.
3. **Preservar estrutura original**: O Gemini escolheu como organizar. Manter. Nao criar secoes artificiais.

### O que NAO fazer (responsabilidade do orquestrador)

- Nao extrair convergencias/divergencias em secoes formais — reportar como o Gemini escreveu
- Nao aplicar GRADE — quem classifica e o orquestrador com os MCPs do Claude
- Nao reclassificar fontes — se o Gemini chamou de "estudo observacional", manter
- Nao criar "Dados para slide" — o orquestrador decide o que vai pro slide
- Se o Gemini contradiz algo que o Claude sabe: reportar ambas as versoes, nao editar

### Template do output

```
## Deep Search Report: [Topico]
Data: [YYYY-MM-DD] | Fonte: Gemini 3.1 + Google Search
Status PMIDs: CANDIDATE (verificar via PubMed antes de usar)

[output do Gemini — estrutura original preservada, PMIDs marcados CANDIDATE]

### Fontes citadas
[lista de todas as referencias com PMID/DOI marcados CANDIDATE]
```

Output enxuto. Materia-prima para o orquestrador, nao produto final.

---

## Notas

- **Tempo**: ~30-90s (sincrono via CLI)
- **Custo**: $0 (OAuth Ultra, 2000 req/dia)
- **Follow-up**: nova chamada `gemini -p "FOLLOWUP"` com contexto adicional
- **Cross-validation**: rodar /research (Claude MCPs) em paralelo e comparar
