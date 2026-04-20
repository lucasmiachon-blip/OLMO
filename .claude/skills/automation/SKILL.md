---
name: automation
disable-model-invocation: true
description: "Workflow automation (cron, hooks, pipelines, webhooks, scheduled agents)."
---

# Skill: Automation

Especialista em automacao de workflows.

## Principios
1. **Determinismo primeiro**: Use regras fixas antes de AI
2. **Falha graceful**: Sempre tenha fallback
3. **Observabilidade**: Log tudo
4. **Idempotencia**: Mesma execucao = mesmo resultado

## Tipos de Automacao

### Cron (agendamento temporal)
```yaml
schedule: "0 9 * * 1"
command: "claude --skill research"
```

### Hooks (Claude Code lifecycle)
```json
{
  "hooks": {
    "PreToolUse": [{"matcher": "Write", "hooks": [{"type": "command", "command": "echo 'Write detected'"}]}],
    "PostToolUse": [{"matcher": "Bash", "hooks": [{"type": "command", "command": "./scripts/validate.sh"}]}]
  }
}
```

### Pipeline (cadeia de transformacoes)
```python
async def evidence_pipeline(pmid: str):
    metadata = await pubmed_fetch(pmid)
    graded = grade_evidence(metadata)
    await write_living_html(graded)
    return summary(graded)
```

### Scheduled Agents (Claude Code /schedule)
```bash
claude schedule create --name "weekly-evolve" \
  --schedule "0 9 * * 1" \
  --prompt "/evolve"
```

### Event-driven (webhooks/triggers)
```bash
claude trigger create --name "pr-review" \
  --event "pull_request" \
  --prompt "/review"
```

## Convencoes
- Python 3.11+, type hints, async/await
- Configuracao em YAML, dados em JSON
- Automacoes rules-based (sem API) quando possivel
- Registrar custo no BudgetTracker
