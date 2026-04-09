# Sistema OLMO

> Conhecimento sobre o proprio sistema: AI, orquestracao, harness, memory, rules.
> Fonte: docs existentes + best practices + ecosystem studies.

## Raw Sources (raw/)

| Arquivo | Tema | Data |
|---------|------|------|
| best-practices-cowork-skills-2026-04-08.md | Best practices Anthropic + repos | 2026-04-08 |
| ecosystem-study-S115.md | Estudo do ecossistema OLMO | S115 |
| workflow-mbe-opus-classificacao.md | Workflow MBE classificacao | 2026-03-29 |

## Repo Sources (nao copiadas — referenciadas in-place)

| Path no repo | Tema | Feed para |
|-------------|------|-----------|
| docs/ARCHITECTURE.md | Arquitetura do sistema | agent, mcp, orquestracao |
| config/ecosystem.yaml | Inventario agentes/MCPs/skills | agent, mcp, skill |
| docs/mcp_safety_reference.md | Protocolo MCP safety | mcp, safety |
| docs/PIPELINE_MBE_NOTION_OBSIDIAN.md | Pipeline MBE completo | pipeline-dag |
| docs/WORKFLOW_MBE.md | Workflow MBE | pipeline-dag |
| docs/keys_setup.md | Setup de chaves/infra | mcp |
| docs/research/implementation-plan-S82.md | Plano /insights | orquestracao |
| docs/research/chaos-engineering-L6.md | Chaos engineering L6 | safety |
| .claude/rules/*.md | Regras comportamentais | rule, safety |
| .claude/agents/*.md | Definicoes de agentes | agent |

## Concepts (wiki/concepts/)

| Concept | Descricao | Fontes principais |
|---------|-----------|-------------------|
| [[agent]] | 9 subagentes, model routing, contratos | agents/*.md, ARCHITECTURE.md |
| [[mcp]] | 12 MCPs, safety protocol, auth | ARCHITECTURE.md, mcp_safety_reference.md |
| [[hook]] | 34 registrations, guards, antifragile | hooks/*.sh, ARCHITECTURE.md |
| [[skill]] | 25+ skills, triggers, progressive disclosure | skills/*.md, ecosystem.yaml |
| [[memory]] | Memory wiki, 20-file cap, /dream, dual wiki | SCHEMA.md, MEMORY.md |
| [[rule]] | 11 rules, 7 KBPs, enforcement piramide | rules/*.md, known-bad-patterns.md |

## Topics (wiki/topics/) — Pendente

Fase 6: compilar temas transversais.

| Topic planejado | Fontes |
|-----------------|--------|
| orquestracao.md | multi-window.md, anti-drift.md, known-bad-patterns.md |
| safety.md | patterns_defensive.md, guard-*.sh, chaos-engineering-L6.md |
| pipeline-dag.md | SCHEMA.md DAG, PIPELINE_MBE.md, /research, knowledge-ingest |
