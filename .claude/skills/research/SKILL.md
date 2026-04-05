---
name: research
description: |
  Pipeline de pesquisa medica multi-perna com sintese cruzada. 6 buscas independentes em paralelo (Gemini deep-search, MBE evaluator, reference checker, MCP query runner, Opus researcher, Perplexity auditor) + orquestrador que compara, cruza e sintetiza em living HTML per slide. Use sempre que o usuario pedir "pesquisa profunda", "research completa", "buscar evidencia", "deep research", "avaliar profundidade do slide", "pesquisar a fundo", "quality assessment", "verificar dados do slide", "preciso de evidencia para", "rodar SCite/Consensus", "checar referencias". Proativamente usar quando slides precisam de evidencia ou qualidade de dados clinicos e questionada.
version: 1.0.0
context: fork
agent: general-purpose
allowed-tools: Read, Grep, Glob, Agent, WebSearch, WebFetch, Write
argument-hint: "[topic OR slide-id] [--queries 'SCite: X, Consensus: Y']"
---

# Research — Pipeline Multi-Perna

Pesquisa para: `$ARGUMENTS`

6 pernas independentes em paralelo, cada uma com fontes e vieses diferentes. Convergencia entre pernas = alta confianca. Divergencia = flag para decisao humana.

## Step 1 — Parse

1. **PMID/DOI isolado** (ex: `30910320`, `10.1016/...`): fast path — verificar via PubMed MCP, retornar citacao formatada. Pular pipeline.
2. **Slide-id** (ex: `s-rs-vs-ma`): ler slide HTML + evidence-db + CLAUDE.md da aula. Pipeline completo.
3. **Topic livre** (ex: `terlipressin HRS-AKI`): pipeline sem Pernas 2-3 (precisam de conteudo existente).
4. Extrair `--queries` se presente (queries literais para Perna 4).

## Step 2 — Dispatch (paralelo)

Lancar pernas aplicaveis via Agent tool, TODAS em 1 mensagem:

| # | Agent | Modelo | Quando | Input |
|---|-------|--------|--------|-------|
| 1 | Ler `.claude/skills/deep-search/SKILL.md` e seguir | Gemini 3.1 | Sempre | topic |
| 2 | `mbe-evaluator` (subagent_type) | Sonnet | Slide existe | slide HTML + evidence-db |
| 3 | `reference-checker` (subagent_type) | Sonnet | Slide existe | slide-id + aula path |
| 4 | `mcp-query-runner` (subagent_type) | Haiku | --queries presente | queries literais |
| 5 | `opus-researcher` (subagent_type) | Opus | Sempre | topic |
| 6 | `perplexity-auditor` (subagent_type) | Haiku | Sempre | topic + slide context |

Minimo: Pernas 1+5+6. Maximo: todas 6.

**Perna 6 — Perplexity:** Discovery de frameworks e conceitos via web search grounded. Prompt ABERTO (nunca fechado). Todas as citacoes = [CANDIDATE] ate Perna 3 (reference-checker) verificar. Custo: ~$0.80-1.00/call.

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
