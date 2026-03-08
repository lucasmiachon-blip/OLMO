# HANDOFF - Proxima Sessao

> Atualizado: 8 de Marco de 2026
> Sessao: Diagnostico completo de conflitos MD/YAML/Python

## CONTEXTO PRINCIPAL

**Concurso nov/2026**: 120 questoes multipla escolha — prioridade do ano.
Todas as ferramentas e teorias consagradas de estudo devem servir a isso.

## P0 - PROXIMA SESSAO: CORRIGIR CONFLITOS

Auditoria completa foi feita. 15 categorias de conflitos identificados.
**Amanha: corrigir por prioridade.**

### CRITICAL (corrigir primeiro)

1. **config/loader.py:14** — `WORKFLOWS_PATH` aponta para `config/workflows.yaml` mas workflows tambem estao em `workflows/`. Definir fonte unica ou carregar ambos.

2. **orchestrator.py:66-73** — Bug no `.get()` com fallback errado. Usa `agents[index]` como default mas deveria referenciar o dict corretamente. Subagents podem nao ser attachados.

3. **Model assignments nao enforced no codigo** — Agents (scientific, automation, etc) nao especificam `model` na classe. Se chamados diretamente, modelo fica indefinido. Precisa herdar do config.

4. **agents/scientific/scientific_agent.py:71-78** — Research areas hardcoded como AI/ML/CV/robotics, mas docs e YAML focam em medicina (MBE, PICO). Alinhar com config/ecosystem.yaml.

### HIGH (corrigir depois dos critical)

5. **CLAUDE.md:37-43** — Lista 7 skills mas existem 11 no diretorio `.claude/skills/`. Faltam: automation, organization, research, scientific.

6. **PENDENCIAS.md** — Referencia Anki MCP (linha 87) e MedAdapt MCP (linha 92) que NAO existem em `config/mcp/servers.json`.

7. **Notion safety protocol** — Documentado em mcp_safety.md mas NAO enforced no codigo. Workflows usam generic `execute()` sem safety gates.

8. **Naming inconsistency** — Docs usam CamelCase (TrendAnalyzer, KnowledgeOrganizer), codigo usa snake_case (trend_analyzer, knowledge_organizer). Padronizar.

### MEDIUM (apos high)

9. **3 arquivos de workflow** sem precedencia clara: `config/workflows.yaml`, `workflows/medical_workflow.yaml`, `workflows/efficient_workflows.yaml`
10. **Budget estimates** variam: $2.20-2.60 (medical_workflow.yaml) vs $3.00-3.60 (ECOSYSTEM.md) vs $10-40 (ECOSYSTEM.md real estimate)
11. **Cross-validation thresholds** — Mesmos valores mas terminologia diferente: `human_review` (servers.json) vs `ask_confirmation` (mcp_safety.md)

### ARQUIVOS NAO VERIFICADOS (checar amanha)

- `agents/core/smart_scheduler.py`
- `agents/core/budget_tracker.py`
- `subagents/analyzers/trend_analyzer.py`
- `subagents/processors/knowledge_organizer.py`
- `subagents/processors/data_pipeline.py`
- `subagents/monitors/web_monitor.py`

## O QUE FOI FEITO (sessoes 1-3)

1. **MCP Config**: 13 MCPs com model routing, Notion = Opus $0 via Pro/Max
2. **Protocolo Seguro Notion**: `.claude/rules/mcp_safety.md`, bugs reais, modelo harsh
3. **NotionCleaner**: `notion_cleaner.py` reescrito, snapshot → inventario → plano → execucao
4. **Ultimate Brain**: registrado como base Notion (Thomas Frank)
5. **Perfil**: medico + professor + pesquisador + dev AI
6. **Teaching skill**: slideologia, cognicao, retorica, andragogia, AI fluency, dev AI 2x/semana
7. **Concurso nov/2026**: estrategia completa (active recall, spaced rep, interleaving, practice testing)
8. **Auditoria MDs**: KPIs, safety, self-improvement, cross-references, budget fix
9. **ChatGPT 5.4 MCP**: cross-validation para writes criticos
10. **Diagnostico completo**: 15 categorias de conflitos entre MD/YAML/Python auditados

## PENDENTE (nao urgente)

- [ ] Configurar MCPs medicos (healthcare, pubmed, biomcp)
- [ ] Configurar Gmail MCP
- [ ] Testar workflows
- [ ] Curriculo completo "AI para Alunos de Medicina" (8 aulas)
- [ ] Criar database Notion "Teaching Log"
- [ ] Verificar versao Ultimate Brain (thomasjfrank.com/brain/)
- [ ] Notion 3.0 AI agents — mudancas desde Set 2025?
- [ ] Snapshot READ-ONLY do Notion
- [ ] Setup Concurso (database, Anki, simulado baseline)
