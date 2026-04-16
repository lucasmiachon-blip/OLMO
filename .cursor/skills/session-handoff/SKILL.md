---
name: session-handoff
description: Atualiza HANDOFF e documentação ao encerrar ou repassar contexto de sessão. Use quando o usuário encerrar trabalho, pedir resumo da sessão ou preparar handoff.
---

# Handoff de Sessão

## Checklist ao encerrar

1. **HANDOFF.md**
   - Resumo do que foi feito (bullets).
   - Próximos passos ou bloqueios.
   - Branch/estado relevante se houver.
   - Linha de coautoria: `Coautoria: Lucas + [modelos usados]`.

2. **`.claude/BACKLOG.md`**
   - Atualizar se backlog, setup checklist, ou tarefas pendentes mudou.

3. **docs/**
   - Atualizar `ARCHITECTURE.md` ou `BEST_PRACTICES.md` só se houver decisão técnica ou convenção nova.

## Formato sugerido para HANDOFF

```markdown
## Última sessão (YYYY-MM-DD)

### Feito
- Item 1
- Item 2

### Próximos passos
- ...

### Bloqueios / notas
- ...

---
Coautoria: Lucas + opus
```

## Referência

- Regra docs: `@.cursor/rules/docs-handoff.mdc`
