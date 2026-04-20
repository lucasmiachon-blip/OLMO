---
name: research
disable-model-invocation: true
description: "Pipeline de pesquisa medica multi-perna (6 pernas) com sintese cruzada em living HTML."
version: 2.0.0
context: fork
agent: general-purpose
allowed-tools: Read, Grep, Glob, Agent, Write, Bash
argument-hint: "[topic OR slide-id] [--queries 'SCite: X, Consensus: Y'] [--after slide-id]"
---

# Research — Pipeline Multi-Perna

## ENFORCEMENT (primacy anchor)

1. **Cada perna usa SUA ferramenta.** Gemini = Bash/Node.js HTTP com GEMINI_API_KEY. Perplexity = Bash/Node.js HTTP com PERPLEXITY_API_KEY. Evidence-researcher = subagent com MCPs academicos. NLM = CLI `nlm notebook query`.
2. **NUNCA substituir uma perna por outra.** Se uma perna falha (API key ausente, timeout, erro): reportar ao usuario e pular. NAO improvisar com WebSearch, NAO lancar agente general-purpose como substituto. KBP-08.
3. **Pre-flight obrigatorio.** Validar API keys ANTES de dispatch (Step 1.5). Key ausente = perna indisponivel, nao perna substituida.

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

## Step 1.5 — Pre-Flight

Antes de dispatch, validar via Bash:

```bash
echo "GEMINI: $(echo $GEMINI_API_KEY | head -c4)... | PERPLEXITY: $(echo $PERPLEXITY_API_KEY | head -c4)..."
```

- Prefixo visivel = key configurada → perna disponivel
- Vazio = key ausente → reportar: "Perna X indisponivel: API key nao configurada"
- **NAO substituir por WebSearch.** NAO lancar agente general-purpose como substituto. Pular a perna.
- Continuar com pernas restantes.
- Se AMBAS keys ausentes: avisar usuario que pesquisa tera cobertura reduzida (so MCPs academicos).

### Worker Mode Override

Se `.claude/.worker-mode` existe (verificar via `test -f .claude/.worker-mode`):
- **Subagents (Pernas 2/3/4):** adicionar ao prompt de dispatch: "Escreva output em `.claude/workers/{task}/perna{N}-{nome}.md`"
- **Orquestrador (Pernas 1/5/6):** output vai para console — sem conflito com hook
- **Motivo:** hook `guard-worker-write.sh` bloqueia Write/Edit fora de `.claude/workers/` em worker mode. Sem override, subagents que escrevem em `qa-screenshots/` terao output silenciosamente bloqueado.

## Step 2 — Dispatch (paralelo)

Lancar pernas aplicaveis via Agent tool, TODAS em 1 mensagem:

| # | Ferramenta/Executor | Modelo | Quando | Input | Output |
|---|---------------------|--------|--------|-------|--------|
| 1 | Gemini API — Bash `node -e` (**Orquestrador**) | gemini-3.1-pro-preview | Sempre | topic | inline (console) |
| 2 | `evidence-researcher` (**Subagent**) | Sonnet | Sempre | topic + slide context + queries MCP | retorno ao orquestrador |
| 3 | `mbe-evaluator` (**Subagent**) | Sonnet | Slide existe | slide HTML + evidence HTML | retorno ao orquestrador |
| 4 | `reference-checker` (**Subagent**) | Haiku | Slide existe | slide-id + aula path | retorno ao orquestrador |
| 5 | Perplexity API — Bash `node -e` (**Orquestrador**) | sonar-deep-research | Sempre | topic (prompt aberto) | inline (console) |
| 6 | NLM CLI `nlm notebook query` (**Orquestrador**, OAuth) | — | Notebook mapeado | topic + adjacent context | inline (console) |

Todas as pernas aplicaveis rodam. Perna indisponivel (key ausente, tool quebrada) = reportar e pular.

**Principio I/O (S145):** OPEN topic + CLOSED format. Nunca ambos abertos.
- OPEN: "What are the most practice-changing..." (topico livre, nao-deterministico)
- CLOSED: "Return ONLY a markdown table..." (formato fixo, parseavel)
- NEVER: both open (gera ensaio 31KB) or both closed (mata criatividade)

### Output Schema Suffix (obrigatorio em toda perna)

Toda perna DEVE ter este sufixo (ou adaptacao) no final do prompt:

```
=== OUTPUT FORMAT (MANDATORY) ===
Return ONLY a markdown table with these columns. NO prose before or after.

| Field | Item 1 | Item 2 |
|-------|--------|--------|
| First author, year | | |
| Type (paper\|book\|guideline\|preprint\|web) | | |
| Title | | |
| Journal / Publisher / Organization | | |
| PMID (if paper or preprint) | | |
| DOI (if available) | | |
| Fallback ID (ISBN for book, URL for web/guideline w/o DOI) | | |
| Population | | |
| Intervention | | |
| Comparator | | |
| Primary outcome | | |
| Effect size (specify OR/RR/HR) | | |
| 95% CI | | |
| I² (%) | | |
| N studies | | |
| N patients | | |
| Clinical significance (1-2 sentences max) | | |
| PMID status | CANDIDATE | CANDIDATE |

RULES: No introductions. No conclusions. No methodology discussion.
Only the table. If <2 items found, fill what you have.
```

Adaptar colunas ao tipo de pesquisa: declarar `Type` primeiro, depois preencher PMID/DOI/Fallback ID conforme regra em §Regras (P005). Ex: busca de guideline → remover PICO, preencher Fallback ID com URL da org se DOI ausente.

**Perna 1 — Gemini API (Deep Think):** Pesquisa ampla com Google Search grounding. Modelo: `gemini-3.1-pro-preview` (melhor disponivel, deep thinking). Usar GEMINI_API_KEY (NAO CLI, NAO MCP — CLI frozen S114). Topico ABERTO, formato FECHADO (schema suffix obrigatorio). Todos PMIDs = [CANDIDATE].

Execucao (orchestrador via Bash):
```bash
node .claude/scripts/gemini-research.mjs "<OPEN_PROMPT_COM_SCHEMA_SUFFIX>"
```

Script canonical em `.claude/scripts/gemini-research.mjs` (S232 v6 Batch 4 — substitui inline `node -e` bloqueado por settings.json deny list desde S227 KBP-26). Contém generationConfig (temperature 1, maxOutputTokens 32768, thinkingBudget 16384), google_search tool, error handling MAX_TOKENS + grounding sources surface.

**Perna 2 — Evidence Researcher:** MCPs academicos (PubMed, CrossRef, Semantic Scholar, Scite, BioMCP). Verificacao de PMIDs via PubMed MCP. Foco: dados estruturados, trials, guidelines.

**Perna 5 — Perplexity Sonar:** Pesquisa de fontes Tier 1 de 2020 ate data atual via web search grounded. Perna INDEPENDENTE (fonte diferente das MCPs). Modelo: `sonar-deep-research`. Topico ABERTO, formato FECHADO (schema suffix obrigatorio). Todas citacoes = [CANDIDATE] ate Perna 4 verificar. Max 1 call (~$0.80).

Execucao (orchestrador via Bash):
```bash
node .claude/scripts/perplexity-research.mjs "<OPEN_PROMPT>"
```

Script canonical em `.claude/scripts/perplexity-research.mjs` (S232 v6 Batch 4). Modelo `sonar-deep-research`, temperature 0.8, max_tokens 8000, return_citations + search_context_size high. SYSTEM prompt embutido (Tier 1 sources NEJM/Lancet/JAMA/BMJ/Ann Intern Med/Cochrane; markdown table only; PMIDs CANDIDATE).

Regras: topico ABERTO ("What has changed in...", "What would surprise..."). Formato FECHADO (schema suffix no final do user prompt). Output parseavel.

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

## Step 2.5 — Validacao Pos-Retorno

Para CADA perna retornada, antes de prosseguir para Step 3:

1. **Output existe?** Perna retornou texto/dados? Se vazio → diagnosticar (timeout? hook block? maxTurns esgotados? thinking consumed tokens?)
2. **Schema check (mecanico):**
   - Output contem `|` (pipe) em >=3 linhas? (indica tabela markdown)
   - Output contem PMID ou DOI? (indica dados rastreaveis)
   - Output < 5000 chars? (indica concisao — se > 5000, provavelmente prosa)
   - finishReason != MAX_TOKENS? (indica completude)
   - Score: 4/4 = prosseguir | 2-3/4 = flag + prosseguir | 0-1/4 = re-prompt ou skip
3. **Coverage?** Output cobriu o escopo pedido? Se parcial (ex: 3/5 eixos) → flag com o que falta

**Gates:**
- Perna falhou → reportar ao usuario com diagnostico. NAO prosseguir para sintese com dados incompletos sem aprovacao.
- >= 2 pernas falharam → STOP e reportar. Cobertura insuficiente para sintese confiavel.
- Perna parcial → apresentar o que tem + o que falta. Lucas decide se relanca ou aceita.

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
3. **Divergencias** — ambas posicoes + qual e mais defensavel e por que. Resolver via §3c.
4. **Numeros-chave** — tabela com HR/RR/NNT + CI + PMID, pronta para copiar para slide ou speaker notes.

### 3c. Resolucao de Conflitos (cross-synthesis)

Quando pernas divergem, resolver pela hierarquia abaixo (primeira regra que desempata vence):

| Prioridade | Criterio | Exemplo |
|-----------|----------|---------|
| 1 | **Nivel de evidencia (MBE)** | Meta-analise > RCT > coorte > expert opinion |
| 2 | **Verificacao PMID** | Dado com PMID verificado > dado com PMID candidato > dado sem fonte |
| 3 | **Recencia** | Guideline 2024 > guideline 2018 (se mesmo nivel) |
| 4 | **Consistencia interna** | Perna que concorda consigo mesma > perna com contradicoes internas |
| 5 | **Numero de pernas concordantes** | 4/6 concordam > 2/6 (ultimo recurso, nao substitui hierarquia) |

**Regras:**
- NUNCA resolver por "maioria simples" sem verificar nivel de evidencia primeiro
- Divergencia irresolvivel (mesmo nivel, mesma recencia) → flag para Lucas com ambas posicoes
- Perna Gemini/Perplexity (web search) sempre abaixo de pernas MCP (dados estruturados) quando nivel de evidencia e igual
- Registrar a regra usada na sintese: "Resolvido por criterio X: [explicacao]"

## Step 4 — Output

**Inline:**
1. Sintese narrativa (prosa — deve ser lida em 60s)
2. Tabela comparativa + convergencias/divergencias (para referencia)
3. Recomendacoes (o que mudar, o que manter, o que aprofundar)

**Living HTML (se slide-id):** gerar/atualizar `content/aulas/{aula}/evidence/{slide-id}.html` — documento UNICO de preparacao do professor. Substitui evidence-db.md + aside.notes + blueprint.md para esse slide.

Secoes do HTML (escrever direto no arquivo, seguindo a estrutura abaixo):

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

**Como escrever:** HTML escrito diretamente em `content/aulas/{aula}/evidence/{slide-id}.html`, seguindo as 11 secoes acima como template mental. **Benchmark visual canonico:** `content/aulas/metanalise/evidence/pre-reading-heterogeneidade.html` (S148). HTML puro, CSS inline minimo, charset UTF-8, sem framework. Versionado no git — `git diff` mostra o que mudou. NAO gerar HTML vazio para slides sem dados (cobertura incremental OK).

## Regras

- NUNCA inventar dados — sem fonte → `[TBD]`
- PMIDs de LLM = `[CANDIDATE]` ate verificacao via PubMed MCP
- **Reference type discipline (P005):** toda referencia DEVE declarar `Type` ANTES de tentar lookup. Mapeamento ID:
  - `paper` → PMID (primary) + DOI (optional)
  - `preprint` → DOI (primary, e.g., bioRxiv/medRxiv) — sem PMID
  - `guideline` → DOI ou Fallback ID (org + year + URL). NAO tentar PMID
  - `book` → Fallback ID = ISBN. NAO tentar PMID
  - `web` → Fallback ID = URL. NAO tentar PMID
  - Tentar PMID em book/guideline/web = fabricacao (KBP-13). Stop e declare type primeiro.
- HR != RR != OR — especificar sempre
- Pais-alvo: Brasil. NNT requer IC 95% + timeframe
- Fast path (PMID isolado): nao lancar pipeline, verificar e retornar direto
- NNT e a metrica de decisao (hero do slide). Calcular sempre que ARR disponivel. HR e academico — menor destaque.
- Risco basal: incluir na tabela de numeros-chave quando disponivel (ex: "mortalidade 1 ano cirrose descompensada: ~20%")

## ENFORCEMENT (recency anchor)

1. **Cada perna usa SUA ferramenta.** Gemini = Bash/API. Perplexity = Bash/API. Evidence-researcher = MCPs. NLM = CLI.
2. **NUNCA substituir perna por WebSearch ou general-purpose.** Falhou = reportar e pular. KBP-08.
3. **Pre-flight obrigatorio.** Step 1.5 antes de dispatch.
