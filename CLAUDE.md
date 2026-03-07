# CLAUDE.md - AI Agent Ecosystem

> "The winners won't have the smartest agents; they'll have the architecture
> that makes agents trustworthy, deployable, and governable." - CrewAI

## Project Identity

Ecossistema modular de agentes AI para automacao, pesquisa cientifica,
organizacao pessoal e monitoramento AI. Projetado para **maximo valor com
minimo de API calls** (poucos requests por dia/semana).

## Architecture

```
Orchestrator ─── rota tarefas, executa workflows
├── Cientifico ─── arXiv, papers, hipoteses, tendencias
│   └── TrendAnalyzer (subagent)
├── Automacao ─── regras, pipelines, eventos, cron
│   └── DataPipeline (subagent)
├── Organizacao ─── GTD, Eisenhower, projetos, habitos
└── AtualizacaoAI ─── modelos, tools, news, benchmarks
    └── WebMonitor (subagent)

SmartScheduler ─── budget, cache, batch, priorizacao
BudgetTracker ─── custo por agente, alertas, otimizacao
```

## Efficiency-First Design

O sistema usa 3 camadas para minimizar API calls:

1. **Local-First** → processa regex, parsing, files localmente ($0)
2. **Cache** → mesma pergunta nunca bate na API 2x (TTL por tipo)
3. **Batching** → combina queries relacionadas em 1 chamada (80% economia)

Model routing por complexidade:
- `trivial` → Ollama local ($0)
- `simple` → Haiku ($0.001)
- `medium` → Sonnet ($0.01)
- `complex` → Opus ($0.05-0.10)

## Commands

```bash
python orchestrator.py status      # Status do ecossistema
python orchestrator.py run         # Inicia ecossistema
python orchestrator.py workflow X  # Executa workflow X
```

## Code Conventions

- Python 3.11+, type hints obrigatorios
- Async/await para operacoes de I/O
- Pydantic para validacao de dados
- YAML para configuracao, JSON para dados
- Testes: `pytest tests/`
- Lint: `ruff check .`

## Key Files

- `orchestrator.py` → entry point principal
- `config/ecosystem.yaml` → configuracao dos agentes
- `config/workflows.yaml` → definicao de workflows
- `config/rate_limits.yaml` → budget e limites de API
- `agents/core/smart_scheduler.py` → agendador inteligente
- `agents/core/budget_tracker.py` → rastreamento de custos

## Extending

Para adicionar um novo agente:
1. Crie em `agents/<nome>/` herdando `BaseAgent`
2. Implemente `execute()` e `plan()`
3. Registre no `orchestrator.py` via `orch.register_agent()`
4. Adicione config em `config/ecosystem.yaml`

Para adicionar uma nova skill:
1. Crie em `skills/<categoria>/`
2. Registre no agente via `agent.register_skill()`
