# CLAUDE.md - Ecossistema de Agentes AI

## Identidade do Projeto
Este projeto e um ecossistema completo de agentes AI para automacao, pesquisa cientifica, organizacao pessoal e auto-atualizacao continua. Inspirado nas melhores praticas de Anthropic, OpenAI, LangChain, CrewAI e AutoGPT.

## Arquitetura do Ecossistema

### Hierarquia de Agentes
```
Orchestrator (Agente Principal)
├── AgenteCientifico      - Pesquisa, analise e sintese de conhecimento
├── AgenteAutomacao       - Automacao de tarefas e workflows
├── AgenteOrganizacao     - Gestao pessoal, tarefas, calendario, notas
├── AgenteAtualizacaoAI   - Monitoramento e integracao de novos modelos/tools
└── Subagentes
    ├── MonitorWeb         - Monitora fontes de dados e novidades
    ├── ProcessadorDados   - ETL e transformacao de dados
    ├── AnalisadorCodigo   - Review e qualidade de codigo
    └── GeradorRelatorios  - Cria relatorios e documentacao
```

### Principios de Design
1. **Modularidade** - Cada agente e independente e substituivel
2. **Composabilidade** - Agentes podem ser combinados em workflows
3. **Observabilidade** - Logs e metricas em todos os niveis
4. **Resiliencia** - Fallbacks e retry em todas as operacoes
5. **Auto-evolucao** - O sistema aprende e se adapta

## Convencoes de Codigo
- Python 3.11+ como linguagem principal
- Type hints obrigatorios
- Docstrings em todas as funcoes publicas
- Testes para cada agente e skill
- Configuracao via YAML/TOML

## Estrutura de Arquivos
```
/agents/          - Definicoes dos agentes principais
/skills/          - Habilidades reutilizaveis entre agentes
/subagents/       - Subagentes especializados
/config/          - Configuracoes do ecossistema
/workflows/       - Definicoes de workflows automatizados
/templates/       - Templates para prompts e outputs
/docs/            - Documentacao do projeto
```

## Como Contribuir
1. Cada agente deve ter seu proprio README.md
2. Skills devem ser atomicas e testadas
3. Workflows devem ser declarativos (YAML)
4. Toda mudanca passa por review automatizado

## Comandos Uteis
- `python -m orchestrator run` - Executa o orquestrador principal
- `python -m orchestrator status` - Status de todos os agentes
- `python -m pytest tests/` - Roda todos os testes
