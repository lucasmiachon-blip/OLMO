---
name: automation
description: "Automacao de workflows, cron, hooks e pipelines. Ativar para criar ou gerenciar automacoes."
---

# Skill: Automation

Voce e um especialista em automacao de workflows. Use esta skill para
criar e gerenciar automacoes.

## Quando Ativar
- Criar novas automacoes
- Configurar pipelines de dados
- Agendar tarefas recorrentes
- Integrar servicos
- Configurar hooks do Claude Code

## Principios
1. **Determinismo primeiro**: Use regras fixas antes de AI
2. **Falha graceful**: Sempre tenha fallback
3. **Observabilidade**: Log tudo
4. **Idempotencia**: Mesma execucao = mesmo resultado

## Tipos de Automacao

### Cron (agendamento temporal)
```yaml
# Exemplo: daily briefing as 8h
schedule: "0 8 * * *"
command: "claude --skill daily-briefing"
```

### Hooks (Claude Code lifecycle)
```json
// .claude/settings.local.json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write",
      "hooks": [{"type": "command", "command": "echo 'Write detected'"}]
    }],
    "PostToolUse": [{
      "matcher": "Bash",
      "hooks": [{"type": "command", "command": "./scripts/validate.sh"}]
    }]
  }
}
```

### Pipeline (cadeia de transformacoes)
```python
# Exemplo: email → classificar → Notion
async def daily_pipeline():
    emails = await gmail_fetch()          # Step 1: read
    classified = classify(emails)          # Step 2: process
    await notion_write(classified)         # Step 3: write
    await notify(summary(classified))      # Step 4: notify
```

### Scheduled Agents (Claude Code /schedule)
```bash
# Criar agent recorrente via CLI
claude schedule create --name "weekly-evolve" \
  --schedule "0 9 * * 1" \
  --prompt "/evolve"
```

### Event-driven (webhooks/triggers)
```bash
# GitHub Actions → Claude Code
claude trigger create --name "pr-review" \
  --event "pull_request" \
  --prompt "/review"
```

## Convencoes de Codigo
- Python 3.11+, type hints, async/await
- Configuracao em YAML, dados em JSON
- Automacoes rules-based (sem API) quando possivel
- API apenas para decisoes que precisam de raciocinio
- Haiku para classificacao simples
- Registrar custo no BudgetTracker
