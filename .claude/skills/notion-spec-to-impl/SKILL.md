---
name: notion-spec-to-impl
disable-model-invocation: true
description: "Converts specs into trackable Notion Tasks DB entries decomposed into atomic tasks with dependencies."
---

# Skill: Notion Spec-to-Implementation

Converte especificacoes e planos em tasks rastreáveis no Notion Tasks DB.

## MCP: Seguir `.claude/rules/mcp_safety.md` INTEGRALMENTE

## Tasks DB Target

Database: `${NOTION_TASKS_DB}`
Data Source: `${NOTION_TASKS_DS}`

## Workflow

1. **Parse** — extrair requisitos e criterios de aceitacao da spec
2. **Decompor** — quebrar em tasks atomicas (max 2h cada)
3. **Dependencias** — identificar ordem e bloqueios
4. **Estimar** — tempo por task (conservador)
5. **Criar** — tasks no Notion Tasks DB, 1 por vez
6. **Verificar** — re-ler cada task criada

## Formato de Task

```
Titulo: [acao verbo] + [objeto] (ex: "Configurar Obsidian MCP server")
Status: Not started
Prioridade: Urgente+Importante / Importante / Urgente / Baixa
Estimativa: [Xh]
Dependencia: [task anterior, se houver]
Contexto: [link para spec/pagina Masterpiece]
```

## Hierarquia

```
Projeto (pagina Masterpiece, Pilar: PROJETOS)
├── Epic 1 (toggle na pagina)
│   ├── Task 1.1 (Notion Tasks DB)
│   ├── Task 1.2
│   └── Task 1.3
└── Epic 2
    └── Tasks...
```

## Regras
- Task > 2h = decompor mais
- Batch > 5 tasks = confirmacao humana
- Cada task criada = verificar antes da proxima
- Specs de sistema de estudo (R3) = prioridade maxima
