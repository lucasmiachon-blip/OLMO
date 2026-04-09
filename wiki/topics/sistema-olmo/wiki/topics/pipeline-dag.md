---
title: Pipeline DAG
description: Directed acyclic graphs — research pipeline (6 legs), MBE workflow, content pipeline, QA gates, agent routing
domain: sistema-olmo
type: topic
confidence: high
tags: [pipeline, dag, research, mbe, qa, content, agent-routing]
created: 2026-04-09
sources:
  - docs/PIPELINE_MBE_NOTION_OBSIDIAN.md
  - docs/WORKFLOW_MBE.md
  - docs/ARCHITECTURE.md
  - .claude/rules/qa-pipeline.md
  - .claude/skills/research/SKILL.md
related: [[agent]], [[mcp]], [[orquestracao]], [[safety]]
---

# Pipeline DAG

O OLMO opera como um conjunto de DAGs (directed acyclic graphs) interconectados: pesquisa alimenta evidência, evidência alimenta slides, slides passam por QA gates, e todo o fluxo é orquestrado por agent routing. Cada pipeline é linear e fail-safe — nenhuma etapa pode ser pulada.

## Research Pipeline (6 pernas paralelas)

O /research skill despacha 6 pernas independentes em paralelo, cada uma com fontes e métodos diferentes:

| Perna | Agente/Ferramenta | Fontes | Output |
|-------|-------------------|--------|--------|
| 1. Gemini Deep Think | Gemini API | Google Search grounding | Findings + PMIDs [CANDIDATE] |
| 2. Evidence Researcher | Sonnet + 5 MCPs | PubMed, CrossRef, Semantic Scholar, Scite, BioMCP | PMIDs verificados + síntese |
| 3. MBE Evaluator | Sonnet | Slide HTML + Evidence HTML | GRADE/CONSORT/STROBE scoring |
| 4. Reference Checker | Haiku + PubMed MCP | Slide HTML + Evidence HTML | Consistency flags |
| 5. Perplexity Sonar | Perplexity API | Web tier 1, 2020+ | Findings web-grounded |
| 6. NotebookLM | NLM CLI | 3-4 progressive queries | Foundation → Discovery |

Síntese: convergência entre pernas = alta confiança; divergência = flag para decisão humana. Output final: Living HTML (source of truth) com 10 seções.

## MBE Workflow (4 estágios)

Pipeline de medicina baseada em evidência:

1. **BUSCA** (automatizada): `atualizar_tema.py --fetch --tier1 --recent`
2. **CLASSIFICAÇÃO** (Consensus + Scite → Opus): filtrar, classificar (Oxford/GRADE), criticar
3. **SÍNTESE** (manual ou agente): preencher definição, key points
4. **PUBLICAÇÃO**: dual output (Obsidian frontmatter + Notion Masterpiece DB)

Cenários: novo tópico (busca completa), atualizar existente (só metadata), refetch (nova busca preservando links), conteúdo manual. Cadência: digest semanal (segunda 8h), on-demand por tópico.

## Content Pipeline (Slides)

Fluxo de produção de conteúdo educacional:

```
Research → Living HTML (evidence) → Slides (HTML) → _manifest.js
  → build-html.ps1 → index.html → lint-slides.js
  → QA Pipeline → gemini-qa3.mjs (3 gates) → export-pdf.js → PDF
```

State machine por slide: BACKLOG → DRAFT → CONTENT → SYNCED → LINT-PASS → QA → DONE.

## QA Gates

Pipeline de QA com 3 gates sequenciais:

| Gate | Ferramenta | Foco |
|------|-----------|------|
| Preflight | lint-slides.js + DOM inspection | Estrutura HTML, erros bloqueantes |
| Inspect | gemini-qa3.mjs | Defeitos visuais (Gemini API) |
| Editorial | gemini-qa3.mjs | Qualidade criativa (Gemini API) |

Regras: 1 slide por vez, 1 gate por invocação, nunca batch. 4 dimensões: cor semântica, tipografia, hierarquia, design. Cor semântica segue severidade clínica (`--danger` = risco, intervir agora; `--warning` = investigar), não estética.

## Agent Routing

DAG de orquestração:

```
Lucas → Orchestrator (Opus 4.6)
  ├── Evidence Research (Sonnet) → MCPs acadêmicos
  ├── QA Pipeline (Sonnet/Haiku) → Playwright, Gemini
  ├── Organization (Sonnet) → Notion, Calendar
  └── Automation (Haiku) → Scripts, hooks, cron
```

Model routing: trivial → Ollama ($0), simple → Haiku, medium → Sonnet, complex → Opus.

## Automation

- **Weekly digest:** Monday 8h cron — atualiza tópicos MBE
- **Dream cycle:** 24h via stop-should-dream.sh → /dream subagent
- **Session hygiene:** Stop hooks → HANDOFF/CHANGELOG update check

---

Fontes: docs/PIPELINE_MBE_NOTION_OBSIDIAN.md, docs/WORKFLOW_MBE.md, docs/ARCHITECTURE.md, .claude/rules/qa-pipeline.md, .claude/skills/research/SKILL.md
Coautoria: Lucas + Opus 4.6 | S121 2026-04-09
