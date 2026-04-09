---
title: Memory Wiki
description: Sistema de memoria persistente — 20 files capped, wiki-index v1, /dream, governance
domain: sistema-olmo
confidence: high
tags: [memory, wiki, dream, governance, obsidian]
created: 2026-04-08
sources:
  - memory/SCHEMA.md
  - memory/MEMORY.md
  - ~/.claude/CLAUDE.md (auto memory section)
---

# Memory Wiki

O Memory Wiki e o sistema de auto-conhecimento do agente. Persiste entre sessoes como arquivos markdown em `~/.claude/projects/*/memory/`.

## Arquitetura (4 camadas)

1. **RAW** — Fontes imutaveis (transcripts, papers, evidence HTML)
2. **STUDY** — Material de estudo via NLM (podcasts, flashcards)
3. **WIKI** — Paginas compiladas (20 files, capped)
4. **VISUALIZATION** — Obsidian (graph view, backlinks, tags)

## Governance

- **Cap: 20 topic files.** MEMORY.md (indice) e separado.
- **Review cadence:** a cada 3 sessoes, verificar merge candidates
- **Consolidation trigger:** no cap, rodar /dream audit antes de criar file 21
- **Supersession > deletion:** claims antigas marcadas [SUPERSEDED], nunca removidas silenciosamente
- **Audit trail:** changelog.md (append-only)

## Operacoes

| Op | Skill | Trigger |
|----|-------|---------|
| Ingest | /dream | Auto 24h via stop hook |
| Query | wiki-query | Quando agente precisa de conhecimento |
| Lint | wiki-lint | Periodico ou sob demanda |
| Update | via /dream | Apos lint identificar issues |
| Init | manual | Bootstrap de novo dominio |

## Retrieval (wiki-index v1)

MEMORY.md contem "Load when" triggers para cada arquivo. Agente le indice → match triggers com tarefa → carrega APENAS paginas relevantes. Funciona na escala atual (20 files). Futuro: embeddings RAG quando >50 pages.

## Dual Wiki

| Aspecto | Memory Wiki | Content Wiki (wiki/) |
|---------|-------------|---------------------|
| Local | ~/.claude/projects/*/memory/ | OLMO/wiki/ |
| Conteudo | Auto-conhecimento do agente | Conhecimento medico + sistema |
| Cap | 20 files | Sem cap |
| Tracking | Gitignored (local) | Git tracked |
| Quem escreve | /dream, orquestrador | Orquestrador, compilacao |

## Relacionados

- [[skill]] — /dream, /wiki-query, /wiki-lint operam no wiki
- [[rule]] — rules informam memoria (known-bad-patterns → feedback)
- [[agent]] — agentes com `memory: project` persistem entre invocacoes
