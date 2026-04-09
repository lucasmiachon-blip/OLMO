---
title: Agents
description: Subagentes especializados do OLMO — tipos, model routing, maxTurns, contratos
domain: sistema-olmo
confidence: high
tags: [agent, orchestration, model-routing, subagent]
created: 2026-04-08
sources:
  - .claude/agents/*.md
  - docs/ARCHITECTURE.md
  - HANDOFF.md
---

# Agents

Subagentes sao especialistas lancados pelo orquestrador (Opus 4.6) para tarefas delimitadas. Cada agente tem modelo, maxTurns, e escopo rigido.

## Inventario (9 agentes)

| Agent | Model | maxTurns | Memory | Funcao |
|-------|-------|----------|--------|--------|
| evidence-researcher | Sonnet | 20 | project | Pesquisa multi-MCP, living HTML |
| qa-engineer | Sonnet | 12 | project | 1 slide, 1 gate, 1 invocacao |
| mbe-evaluator | Sonnet | 15 | — | GRADE/CONSORT/STROBE (FROZEN) |
| reference-checker | Haiku | 15 | project | PMID cross-ref, stale data |
| quality-gate | Haiku | 10 | — | Lint, type-check, tests |
| researcher | Haiku | 15 | — | Exploracao de codebase |
| repo-janitor | Haiku | 12 | — | Orphan files, dead links |
| notion-ops | Haiku | 10 | — | Notion CRUD com MCP safety |
| sentinel | Sonnet | 25 | — | Read-only self-improvement, anti-patterns |

## Model Routing

```
trivial → Ollama ($0) | simple → Haiku | medium → Sonnet | complex → Opus
```

## Contratos

- **Script primacy:** agentes referenciam scripts canonicos, nunca reimplementam (KBP-03)
- **Pre-launch checklist:** verificar tipo, output capturavel, aprovacao do Lucas (KBP-06)
- **1 tarefa = 1 invocacao.** Batch proibido (KBP-05)
- **maxTurns obrigatorio.** Estimar turns reais + 20% margem

## Relacionados

- [[hook]] — hooks guardam comportamento de agentes
- [[rule]] — rules definem contratos comportamentais
- [[mcp]] — agentes usam MCPs para pesquisa e produtividade
