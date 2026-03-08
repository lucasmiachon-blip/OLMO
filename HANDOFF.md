# HANDOFF - Proxima Sessao

> Atualizado: 8 de Marco de 2026
> Sessao 5: Bug fixes + Consolidacao + Safety Gates + MCP Integration

## CONTEXTO PRINCIPAL

**Concurso nov/2026**: 120 questoes multipla escolha — prioridade do ano.
**Alianca Multi-AI**: Opus 4.6 + ChatGPT 5.4 + Gemini 3.1 + Cursor.
Coautoria explicita em todo output (`.claude/rules/coauthorship.md`).

## STATUS: O QUE ESTA PRONTO PRA USAR

### Codigo pronto (so precisa de API keys + MCPs)
- Orchestrator com safety gates integrados (`agents/core/mcp_safety.py`)
- NotionCleaner com MCP real + fallback teste + filtro de protecao
- SQLite bootstrap automatico (`agents/core/database.py`)
- Workflows consolidados em arquivo unico (`config/workflows.yaml`)
- Budget tracker + smart scheduler prontos
- 11 skills documentadas

### O que voce precisa fazer no PC (setup unico ~30min)
1. `cp .env.example .env` e preencher API keys
2. `claude mcp add notion` (+ healthcare, pubmed, biomcp)
3. Criar 2 tokens Notion em notion.so/my-integrations (read-only + read-write)
4. `pip install -r requirements.txt` (se existir)

## P0 - PROXIMA SESSAO: VARREDURA NOTION

### Comecar assim que tiver token Notion:
1. Rodar snapshot read-only: `notion_cleaner.execute({"action": "snapshot", "protected": ["aulas"]})`
2. Revisar `data/notion_snapshot.md`
3. Rodar analise: `notion_cleaner.execute({"action": "analyze"})`
4. Revisar `data/snapshots/cleanup_plan.json`
5. Aprovar e executar acoes uma a uma

**PROTECAO**: tudo com "aulas" no titulo/database/tags sera **ignorado**.

## P1 - PRIORIDADE CONCURSO: EXAM-GENERATOR

### AGUARDANDO DO USUARIO
Fornecer **minimo 10 provas reais** (PDFs) para calibracao.
Fontes: ENARE, USP, UNICAMP, UNIFESP, AMB, FMUSP, Santa Casa, etc.
**NAO comecar calibracao sem essas provas.**

### Quando receber as provas:
1. [ ] Ingerir PDFs → parser de questoes
2. [ ] Analisar padroes por banca
3. [ ] Calibrar exam-generator
4. [ ] Gerar questoes + justificativas com evidencia
5. [ ] Integracao Anki MCP

### Subespecialidades alvo
cardio, nefro, pneumo, gastro, endocrino, infecto, reumato, hemato + clinica geral

## CONFLITOS RESOLVIDOS (sessao 5)

- [x] **Workflows**: 3 arquivos → 1 arquivo consolidado (`config/workflows.yaml`)
- [x] **Loader**: atualizado para carregar apenas fonte unica
- [x] **CLAUDE.md**: atualizado com todas 11 skills
- [x] **.env.example**: tokens Notion + todas as keys documentadas
- [x] **Safety gates**: `agents/core/mcp_safety.py` — modelo harsh implementado
- [x] **SQLite bootstrap**: `agents/core/database.py` — tabelas auto-criadas
- [x] **NotionCleaner**: stubs → MCP real + dry-run + protecao de paginas
- [x] **Orchestrator**: integrado com safety validation
- [x] **Bug fix**: path hardcoded em rate_limits.yaml
- [x] **Bug fix**: asyncio import tardio em organization_agent.py
- [x] **Bug fix**: asyncio nao usado em automation_agent.py

## CONFLITOS PENDENTES (nao criticos)

- [ ] **Model assignments** nao enforced no codigo (agents nao pegam model do YAML)
- [ ] **scientific_agent.py**: research areas hardcoded AI/ML, deveria ser medicina
- [ ] **Naming**: docs CamelCase vs codigo snake_case (menor)
- [ ] **Budget estimates**: variancia entre arquivos ($2.50 vs $3.50 vs $10-40)
- [ ] **Anki MCP**: referenciado mas nao em servers.json

## ARQUIVOS NAO VERIFICADOS (checar quando possivel)

- `agents/core/smart_scheduler.py`
- `agents/core/budget_tracker.py`
- `subagents/analyzers/trend_analyzer.py`
- `subagents/processors/data_pipeline.py`
- `subagents/monitors/web_monitor.py`

## O QUE FOI FEITO (sessoes 1-5)

1. MCP Config: 13 MCPs com model routing
2. Protocolo Seguro Notion: mcp_safety.md + mcp_safety.py (enforced)
3. NotionCleaner: snapshot → inventario → plano → execucao (MCP real)
4. Safety gates: validate_operation() no orchestrator
5. SQLite: database.py com bootstrap automatico (4 tabelas)
6. Workflows consolidados: 16 workflows em 1 arquivo
7. Ultimate Brain: registrado como base Notion
8. Teaching skill: andragogia, AI fluency, dev AI
9. Concurso: estrategia completa
10. Auditoria completa: bugs corrigidos, conflitos resolvidos
11. ChatGPT 5.4 MCP: cross-validation
12. Pacto de Alianca Multi-AI: coautoria explicita
13. 6 bug fixes (code quality)

## PENDENTE (nao urgente)

- [ ] Configurar MCPs medicos (healthcare, pubmed, biomcp)
- [ ] Configurar Gmail MCP
- [ ] Testar workflows end-to-end
- [ ] Curriculo "AI para Alunos de Medicina" (8 aulas)
- [ ] Database Notion "Teaching Log"
- [ ] Snapshot READ-ONLY do Notion
- [ ] Setup Concurso (database, Anki, simulado baseline)
- [ ] Obsidian + Zotero setup

---
Coautoria: Lucas + opus
Orquestrador: opus (consolidacao + bug fixes)
Data: 2026-03-08
