# Guia de Inicio Rapido

## Pre-requisitos

- Python 3.11+
- pip ou uv

## Instalacao

```bash
# Clone o repositorio
git clone <repo-url>
cd organizacao

# Crie um ambiente virtual
python -m venv .venv
source .venv/bin/activate

# Instale dependencias
pip install -e ".[dev]"

# Configure variaveis de ambiente
cp .env.example .env
# Edite .env com suas API keys
```

## Uso Basico

```bash
# Ver status do ecossistema
python orchestrator.py status

# Iniciar ecossistema
python orchestrator.py run

# Executar workflow especifico
python orchestrator.py workflow morning_review
python orchestrator.py workflow weekly_review
python orchestrator.py workflow research_pipeline
```

## Uso Programatico

```python
import asyncio
from orchestrator import build_ecosystem

async def main():
    # Construir ecossistema
    orch = build_ecosystem()

    # Executar tarefa de pesquisa
    result = await orch.execute({
        "type": "research",
        "action": "search",
        "query": "transformer architecture improvements 2026",
    })
    print(result)

    # Adicionar tarefa pessoal
    result = await orch.execute({
        "type": "organize",
        "agent": "organizacao",
        "action": "add_task",
        "title": "Estudar novo paper sobre LLMs",
        "priority": "high",
        "tags": ["estudo", "ai"],
    })
    print(result)

    # Ver status
    status = orch.get_ecosystem_status()
    print(status)

asyncio.run(main())
```

## Estrutura do Projeto

```
organizacao/
├── CLAUDE.md                 # Configuracao do Claude Code
├── pyproject.toml            # Configuracao do projeto
├── orchestrator.py           # Entry point principal
├── agents/                   # Agentes principais
│   ├── core/                 # Base + Orchestrator
│   ├── scientific/           # Agente cientifico
│   ├── automation/           # Agente de automacao
│   ├── organization/         # Agente de organizacao
│   └── ai_update/            # Agente de atualizacao AI
├── skills/                   # Habilidades reutilizaveis
│   ├── research/             # Pesquisa e busca
│   ├── coding/               # Analise e geracao de codigo
│   ├── writing/              # Criacao de conteudo
│   ├── data/                 # Processamento de dados
│   └── devops/               # Git e infraestrutura
├── subagents/                # Subagentes especializados
│   ├── monitors/             # Monitoramento
│   ├── processors/           # Processamento
│   └── analyzers/            # Analise
├── config/                   # Configuracoes YAML
├── workflows/                # Definicoes de workflows
├── templates/                # Templates de prompts
└── docs/                     # Documentacao
```
