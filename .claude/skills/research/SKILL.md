---
name: research
description: |
  Pipeline de pesquisa medica multi-perna com sintese cruzada. 6 pernas independentes em paralelo (Gemini API, evidence-researcher MCPs, MBE evaluator, reference checker, Perplexity Sonar, NotebookLM) + orquestrador que compara, cruza e sintetiza em living HTML per slide. Use sempre que o usuario pedir "pesquisa profunda", "research completa", "buscar evidencia", "deep research", "avaliar profundidade do slide", "pesquisar a fundo", "quality assessment", "verificar dados do slide", "preciso de evidencia para", "rodar SCite/Consensus", "checar referencias". Proativamente usar quando slides precisam de evidencia ou qualidade de dados clinicos e questionada.
version: 2.0.0
context: fork
agent: general-purpose
allowed-tools: Read, Grep, Glob, Agent, WebSearch, WebFetch, Write, Bash
argument-hint: "[topic OR slide-id] [--queries 'SCite: X, Consensus: Y'] [--after slide-id]"
---

# Research — Pipeline Multi-Perna

Pesquisa para: `$ARGUMENTS`

6 pernas independentes em paralelo, cada uma com fontes e vieses diferentes. Convergencia entre pernas = alta confianca. Divergencia = flag para decisao humana.

## Step 1 — Parse

1. **PMID/DOI isolado** (ex: `30910320`, `10.1016/...`): fast path — verificar via PubMed MCP, retornar citacao formatada. Pular pipeline.
2. **Slide-id existente** (ex: `s-rs-vs-ma`): ler slide HTML + evidence HTML + CLAUDE.md da aula. Pipeline completo.
3. **Slide-id novo** (ex: `s-importancia --after s-hook`): slide nao existe ainda. Construir contexto sintetico:
   - Topic: do argumento ou `--queries`
   - Posicao: do `--after` (ler manifest, encontrar adjacent slides para cross-ref)
   - Prev/Next claims: extrair h2 dos slides adjacentes (fallback para headline do manifest)
   - Narrative: buscar narrative.md por keywords do topic
   - Evidence: vazia (slide novo)
4. **Topic livre** (ex: `terlipressin HRS-AKI`): pipeline sem Pernas 3-4 (precisam de conteudo existente).
5. Extrair `--queries` se presente (queries literais para MCPs).

## Step 2 — Dispatch (paralelo)

Lancar pernas aplicaveis via Agent tool, TODAS em 1 mensagem:

| # | Agent | Modelo | Quando | Input |
|---|-------|--------|--------|-------|
| 1 | Gemini API Deep Think (GEMINI_API_KEY, NAO CLI) — prompt aberto | gemini-3.1-pro | Sempre | topic |
| 2 | `evidence-researcher` (subagent_type) | Sonnet | Sempre | topic + slide context + queries MCP |
| 3 | `mbe-evaluator` (subagent_type) | Sonnet | Slide existe | slide HTML + evidence HTML |
| 4 | `reference-checker` (subagent_type) | Haiku | Slide existe | slide-id + aula path |
| 5 | Perplexity Sonar (orchestrador via Bash) | — | Sempre | topic (prompt aberto) |
| 6 | NLM queries (orchestrador via Bash, **OAuth PRIMEIRO: `nlm login`**) | — | Notebook mapeado | topic + adjacent context |

Minimo: Pernas 1+2+5. Maximo: todas 6.

**Perna 1 — Gemini API (Deep Think):** Pesquisa ampla com Google Search grounding. Modelo: `gemini-3.1-pro` (melhor disponivel, deep thinking). Usar GEMINI_API_KEY (NAO CLI, NAO MCP — CLI frozen S114). Prompt ABERTO. Todos PMIDs = [CANDIDATE].

Execucao (orchestrador via Bash):
```bash
node -e "
const res = await fetch('https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-pro:generateContent?key=' + process.env.GEMINI_API_KEY, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    contents: [{ parts: [{ text: '<OPEN_PROMPT>' }] }],
    tools: [{ google_search: {} }],
    generationConfig: {
      temperature: 1,
      maxOutputTokens: 8192,
      thinkingConfig: { thinkingBudget: 'HIGH' }
    }
  })
});
const data = await res.json();
const parts = data.candidates?.[0]?.content?.parts || [];
parts.forEach(p => p.text && console.log(p.text));
" 2>&1
```

**Perna 2 — Evidence Researcher:** MCPs academicos (PubMed, CrossRef, Semantic Scholar, Scite, BioMCP). Verificacao de PMIDs via PubMed MCP. Foco: dados estruturados, trials, guidelines.

**Perna 5 — Perplexity Sonar:** Pesquisa de fontes Tier 1 de 2020 ate data atual via web search grounded. Perna INDEPENDENTE (fonte diferente das MCPs). Modelo: `sonar-deep-research`. Prompt ABERTO — nunca fechado. Todas citacoes = [CANDIDATE] ate Perna 4 verificar. Max 1 call (~$0.80).

Execucao (orchestrador via Bash):
```bash
node -e "
const res = await fetch('https://api.perplexity.ai/chat/completions', {
  method: 'POST',
  headers: { 'Authorization': 'Bearer ' + process.env.PERPLEXITY_API_KEY, 'Content-Type': 'application/json' },
  body: JSON.stringify({
    model: 'sonar-deep-research',
    messages: [
      { role: 'system', content: 'Only cite Tier 1 sources (BMJ, Lancet, NEJM, JAMA, Cochrane, GRADE). Every claim needs PMID or DOI.' },
      { role: 'user', content: '<OPEN_PROMPT>' }
    ],
    temperature: 0.8, max_tokens: 4000, return_citations: true, search_context_size: 'high'
  })
});
console.log(JSON.stringify(await res.json(), null, 2));
"
```
Regras: prompts ABERTOS ("What has changed in...", "What would surprise a medical educator about..."). NUNCA fechados.

**Perna 6 — NotebookLM:** 3-4 queries progressivas ao notebook da aula via `nlm notebook query`. Q1 Foundation, Q2 Convergence, Q3 Deep content, Q4 Discovery (slides novos).

> **IMPORTANTE:** NLM requer OAuth interativo. ANTES de usar Perna 6, pedir ao usuario: `! nlm login`. Sessao dura ~20min. Se expirar mid-research: pedir re-auth. NAO tentar queries sem auth — falha silenciosa.

NLM Notebook IDs:
```
metanalise: a274cffb-8f41-4015-8b9b-abf81c6b260a
cirrose:    2660b1fe-3e01-4e5e-91ef-be060f2e1733
mbe:        635af766-82ee-454e-b550-f0c4c8120bbd
```

NLM query execution (orchestrador):
```bash
nlm notebook query <notebook-id> "<query>" --json
nlm notebook query <notebook-id> "<query>" --json --conversation-id <cid>  # follow-up
```
Auth: `nlm login` (sessao ~20min). Se expirar: `PYTHONIOENCODING=utf-8 nlm login`.

## Step 3 — Sintese (apos retorno)

Escreva para um professor que vai preparar aula, nao para um arquivo. Prose primeiro, dados depois.

### 3a. Sintese Narrativa (OBRIGATORIO, sempre primeiro)

5-10 linhas em prosa corrida respondendo:
- O que a evidencia diz sobre o topico? (1-2 frases)
- Onde as pernas concordam e por que isso importa? (1-2 frases)
- Onde discordam e o que o professor deve decidir? (1-2 frases)
- O que mudar no slide / aula? Recomendacao direta. (1-3 frases)

Nao listar, nao tabular. Escrever como um colega explicaria tomando cafe.

### 3b. Evidencia de suporte

1. **Tabela comparativa** — perna x top 5 achados (ler `references/methodology.md` para GRADE). Incluir "implicacao" por linha — o que esse achado significa pro slide.
2. **Convergencias** — interpretar, nao contar. "3/3 pernas = ALTA" nao basta. Dizer O QUE converge e POR QUE o professor pode confiar.
3. **Divergencias** — ambas posicoes + qual e mais defensavel e por que.
4. **Numeros-chave** — tabela com HR/RR/NNT + CI + PMID, pronta para copiar para slide ou speaker notes.

## Step 4 — Output

**Inline:**
1. Sintese narrativa (prosa — deve ser lida em 60s)
2. Tabela comparativa + convergencias/divergencias (para referencia)
3. Recomendacoes (o que mudar, o que manter, o que aprofundar)

**Living HTML (se slide-id):** gerar/atualizar `content/aulas/{aula}/evidence/{slide-id}.html` — documento UNICO de preparacao do professor. Substitui evidence-db.md + aside.notes + blueprint.md para esse slide.

Secoes do HTML (usar `generate-evidence-html.py` em `.claude/skills/research/scripts/`):

1. **Header** — assertion (h2 do slide), posicao (slide N de total, fase F1/F2/F3), timestamp, validade sugerida (+6 meses)
2. **Sintese Narrativa** — prosa do Step 3a (60s de leitura)
3. **Speaker Notes** — o que dizer, quando pausar, como contextualizar. Timing cues incluidos. Este HTML SUBSTITUI aside.notes — e o unico documento que o professor le antes de projetar.
4. **Posicionamento Pedagogico** — mbe-evaluator §5 (tensao anterior, resolucao, o que o slide nao mostra)
5. **Analise Retorica** — mbe-evaluator §6 (assertion-evidence, carga cognitiva, dispositivos faltantes)
6. **GRADE Assessment** — tabela 5-dominios por claim (SE claim clinico existe, senao omitir)
7. **Numeros-Chave** — tabela HR/NNT/ARR + CI + PMID + risco basal (SE dados quantitativos)
8. **Sugestoes** — considerar + nao fazer, com reasoning
9. **Depth Rubric** — colapsavel `<details>` (SE aplicavel)
10. **Convergencia** — colapsavel `<details>` (SE multi-perna)
11. **Footer** — coautoria + pipeline version

**Como gerar:** Montar um JSON com os campos acima (ver schema em `scripts/generate-evidence-html.py`) e chamar:
```bash
python .claude/skills/research/scripts/generate-evidence-html.py \
  --slide-id {id} --aula {aula} --assertion "{h2}" \
  --slide-number {N} --total-slides {total} --phase {fase} \
  --data {path-to-json}
```
O script e o template canonico — NAO gerar HTML inline manualmente. Uma fonte de verdade.

HTML puro, CSS inline minimo, charset UTF-8, sem framework. Versionado no git — `git diff` mostra o que mudou. NAO gerar HTML vazio para slides sem dados (cobertura incremental OK).

## Regras

- NUNCA inventar dados — sem fonte → `[TBD]`
- PMIDs de LLM = `[CANDIDATE]` ate verificacao via PubMed MCP
- HR != RR != OR — especificar sempre
- Pais-alvo: Brasil. NNT requer IC 95% + timeframe
- Fast path (PMID isolado): nao lancar pipeline, verificar e retornar direto
- NNT e a metrica de decisao (hero do slide). Calcular sempre que ARR disponivel. HR e academico — menor destaque.
- Risco basal: incluir na tabela de numeros-chave quando disponivel (ex: "mortalidade 1 ano cirrose descompensada: ~20%")
