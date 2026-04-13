# Plan: S181 VIES_PUB1 — Viés de Publicacao (2 slides + living HTML)

## Context

A aula de metanalise (F2 — Metodologia) cobre forest plot, RoB, heterogeneidade e fixed/random, mas NAO tem slides sobre vies de publicacao — apesar de ser objetivo listado em 00b-objetivos.html. Pre-reading ja existe (pre-reading-forest-plot-vies.html, 3 artigos). Evidence HTML por slide = living HTML = source of truth.

## Escopo (Lucas definiu)

- **Slide 1 (s-pubbias1):** Conteudo conceitual — o que e vies de publicacao
- **Slide 2 (s-pubbias2):** Funnel plot — ferramenta visual de deteccao
- **Living HTML:** `evidence/s-pubbias.html` — evidence per slide(s)
- **Posicao no deck:** F2, apos s-rob2 (vies de estudo → vies de publicacao = sequencia natural), antes de s-heterogeneity

## Estado da pesquisa

### Ja disponivel no repo
- pre-reading-forest-plot-vies.html: Page 2021, Afonso 2024, Sterne 2011
- s-importancia.html: deep-dive vies de publicacao + Egger 1997 (PMID 9310563 VERIFIED)
- s-importancia-research.md: Egger 1997 detalhado

### Pesquisa em andamento (1 agente, todos os bracos)
- [ ] evidence-researcher: PubMed + SCite + Semantic Scholar + CrossRef + BioMCP
  - Artigos seminais (Rosenthal 1979, Begg 1994, Egger 1997, Duval 2000, Sterne 2011, Page 2021)
  - Most cited / state of the art 2020-2026
  - Funnel plot methodology + alternativas (contour-enhanced, selection models, p-curve)
  - Verificacao PMID protocolo de precisao

## Sequencia de trabalho

### Fase A: Pesquisa
- Invocar `/evidence` skill com topico "vies de publicacao em meta-analises"
- Skill despacha 6 pernas automaticamente (Gemini, evidence-researcher, mbe-evaluator, reference-checker, Perplexity, NLM)
- Tier 1, ate 2026
- Protocolo de precisao: PMID cross-ref 3 campos
- NOTA: agent evidence-researcher lancado manualmente (erro) — re-invocar via skill

### Fase B: Living HTML
- Criar `evidence/s-pubbias.html` — source of truth para ambos os slides
- Segue padrao existente (s-importancia.html como referencia)
- Conteudo derivado da pesquisa, sintetizado e curado

### Fase C: Slides (so apos living HTML aprovado)
- `slides/11a-pubbias1.html` — conceitual (o que e vies de publicacao)
- `slides/11b-pubbias2.html` — funnel plot (ferramenta visual)
- CSS scopado em `metanalise.css`
- Entradas em `_manifest.js`
- Build + lint PASS

## Restricoes

- h2 = Lucas decide
- aside.notes PROIBIDO (S161)
- OKLCH obrigatorio (S171)
- Dados numericos: fonte Tier 1 + PMID VERIFIED
- Layout: Lucas decide composicao visual
- aside.notes = PROIBIDO em slides novos
