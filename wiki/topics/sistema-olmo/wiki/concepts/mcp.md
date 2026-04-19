---
title: MCP Servers
description: Model Context Protocol — 12 servidores, categorias, safety protocol, autenticacao
domain: sistema-olmo
confidence: high
tags: [mcp, pubmed, notion, gemini, safety, infrastructure]
created: 2026-04-08
sources:
  - docs/ARCHITECTURE.md
  - docs/mcp_safety_reference.md
  - docs/keys_setup.md
  - config/ecosystem.yaml
---

# MCP Servers

MCPs sao servidores que conectam Claude Code a sistemas externos via protocolo padronizado. O OLMO usa 10 MCPs + Gemini API + Perplexity API (estes dois nao sao MCPs). Gmail+Google Calendar purged em S229.

## Inventario (12)

| Categoria | MCPs | Usado por |
|-----------|------|-----------|
| Medico | PubMed, SCite, Consensus, Scholar Gateway | evidence-researcher, /research |
| Estudo | NotebookLM (BioMCP) | /nlm-skill, /knowledge-ingest |
| Produtividade | Notion | notion-ops, crosstalk pattern (S229) |
| Visual | Excalidraw, Canva | diagramas, design |
| Dev | Playwright, Context7 | qa-engineer, docs lookup |

## Safety Protocol

- **Read-only por padrao.** Write requer aprovacao explicita do Lucas.
- **Notion:** protocolo em `.claude/rules/mcp_safety.md` — confirmar DB ID, nunca bulk delete.
- **PubMed:** PMIDs de LLM ~56% erro. SEMPRE cross-ref 3-field (autor+titulo+journal).
- **Gemini:** API via GEMINI_API_KEY (nao CLI OAuth). Modelo: gemini-3.1-pro-preview.
- **NLM:** OAuth interativo sempre primeiro (`! nlm login`). Sessao ~20min.

## Autenticacao

| MCP | Auth | Custo |
|-----|------|-------|
| PubMed/SCite/Consensus | API key gratuita | $0 |
| Notion | OAuth (claude.ai) | $0 |
| Gemini API | GEMINI_API_KEY | pay-per-use |
| Playwright | Local | $0 |
| Context7 | Nenhuma | $0 |

## Relacionados

- [[agent]] — agentes usam MCPs como tools
- [[safety]] — MCP safety e parte do stack defensivo
- [[hook]] — guard hooks protegem operacoes MCP
