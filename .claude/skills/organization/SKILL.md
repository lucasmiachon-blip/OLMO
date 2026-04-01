---
name: organization
description: >
  GTD, Eisenhower matrix, Deep Work, and session memory management (HANDOFF
  + CHANGELOG). Use this skill for daily/weekly planning, task prioritization,
  weekly reviews, context management between sessions, productivity systems,
  or any organizational request. Trigger for 'planejar', 'organizar', 'weekly
  review', 'priorizar', 'o que fazer', or questions about task management.
---

# Skill: Organization (GTD + Eisenhower + Memory)

Gestao de tarefas, planejamento, produtividade e memoria de contexto.

## Metodologias
1. **GTD**: Capture > Clarify > Organize > Reflect > Engage
2. **Eisenhower**: Urgente+Importante / Importante / Urgente / Nenhum
3. **Deep Work**: Blocos de foco sem interrupcao
4. **Time Boxing**: Limite de tempo por tarefa

## Memory Management (2 tiers)

### Tier 1: Hot Cache (HANDOFF.md ~30 linhas)
- Estado atual do sistema
- Proximos passos imediatos
- Pendencias e conflitos
- Atualizado a cada sessao (so pendencias, sem historico)

### Tier 2: Deep Storage (CHANGELOG.md + auto memory)
- Historico de sessoes (append-only)
- Decisoes e rationale
- `~/.claude/projects/.../memory/` para notas persistentes

### Regras de memoria
- HANDOFF = futuro (o que falta). CHANGELOG = passado (o que foi feito).
- Promover para HANDOFF: bloqueios ativos, decisoes pendentes
- Remover do HANDOFF: items completados (mover para CHANGELOG)
- Nunca duplicar info entre HANDOFF e CHANGELOG

## Task Management

### Notion Tasks DB: `${NOTION_TASKS_DB}`
- Fonte de verdade para tasks ativas
- Sincronizar via Notion MCP (seguir `mcp_safety.md`)

### Formato do Plano Diario
```
## Plano do Dia - [DATA]

### Foco Principal (Deep Work)
1. [TAREFA] - [TEMPO ESTIMADO]

### Tarefas Rapidas (Shallow Work)
- [ ] ...
```

### Weekly Review Checklist
1. Varrer Notion Tasks → identificar overdue
2. Revisar HANDOFF.md → ainda relevante?
3. Mover completos para CHANGELOG
4. Re-priorizar proxima semana (Eisenhower)
5. Atualizar auto memory se padroes novos

## Eficiencia
- Planejamento diario: Sonnet (1 call)
- Weekly review: Sonnet (1 call batched)
- Notion sync: seguir `.claude/rules/mcp_safety.md`
