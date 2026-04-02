---
name: research
description: |
  Pipeline de pesquisa medica multi-perna com sintese cruzada. 5 buscas independentes em paralelo (Gemini deep-search, MBE evaluator, reference checker, MCP query runner, Opus researcher) + orquestrador que compara, cruza e sintetiza em Notion. Use sempre que o usuario pedir "pesquisa profunda", "research completa", "buscar evidencia", "deep research", "avaliar profundidade do slide", "pesquisar a fundo", "quality assessment", "verificar dados do slide", "preciso de evidencia para", "rodar SCite/Consensus", "checar referencias". Proativamente usar quando slides precisam de evidencia ou qualidade de dados clinicos e questionada.
version: 1.0.0
context: fork
agent: general-purpose
allowed-tools: Read, Grep, Glob, Agent, WebSearch, WebFetch, Write
argument-hint: "[topic OR slide-id] [--queries 'SCite: X, Consensus: Y']"
---

# Research — Pipeline Multi-Perna

Pesquisa para: `$ARGUMENTS`

5 pernas independentes em paralelo, cada uma com fontes e vieses diferentes. Convergencia entre pernas = alta confianca. Divergencia = flag para decisao humana.

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

Minimo: Pernas 1+5. Maximo: todas 5.

## Step 3 — Sintese (apos retorno)

1. **Tabela comparativa** — perna x top 5 achados (ler `references/methodology.md` para GRADE)
2. **Convergencias** — dado em >=2 pernas com PMIDs verificados → ALTA CONFIANCA
3. **Divergencias** — pernas discordam → ambas versoes + flag para decisao humana
4. **Merge** — o que usar, descartar, ou requer decisao humana
5. **Pros/contras** — por finding principal

## Step 4 — Output

**Inline:** tabela comparativa + convergencias/divergencias + merge + recomendacoes

**Notion (se slide-id):** criar/atualizar pagina por slide com:
- Conteudo sumarizado (para Lucas ler pos-projecao)
- Speaker notes sugeridas
- Evidence-db block atualizado
Seguir `.claude/rules/mcp_safety.md`.

## Regras

- NUNCA inventar dados — sem fonte → `[TBD]`
- PMIDs de LLM = `[CANDIDATE]` ate verificacao via PubMed MCP
- HR != RR != OR — especificar sempre
- Pais-alvo: Brasil. NNT requer IC 95% + timeframe
- Fast path (PMID isolado): nao lancar pipeline, verificar e retornar direto
