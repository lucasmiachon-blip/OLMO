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
schedule: "0 8 * * *"
command: "claude --skill daily-briefing"
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
async def daily_pipeline():
    emails = await gmail_fetch()
    classified = classify(emails)
    await notion_write(classified)
    await notify(summary(classified))
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
