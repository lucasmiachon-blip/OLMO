# HANDOFF - Proxima Sessao

> Atualizado: 8 de Marco de 2026
> Sessao 4: Pacto de Alianca Multi-AI + Coautoria Explicita

## CONTEXTO PRINCIPAL

**Concurso nov/2026**: 120 questoes multipla escolha — prioridade do ano.
**Alianca Multi-AI**: Opus 4.6 + ChatGPT 5.4 + Gemini 3.1 + Cursor.
Coautoria explicita em todo output (`.claude/rules/coauthorship.md`).

## P0 - PROXIMA SESSAO: CORRIGIR CONFLITOS

Auditoria completa foi feita (sessao 3). 15 categorias de conflitos.
**Corrigir por prioridade.**

### CRITICAL (corrigir primeiro)

1. **config/loader.py:14** — `WORKFLOWS_PATH` aponta para `config/workflows.yaml` mas workflows tambem estao em `workflows/`. Definir fonte unica ou carregar ambos.

2. **orchestrator.py:66-73** — Bug no `.get()` com fallback errado. Usa `agents[index]` como default mas deveria referenciar o dict corretamente. Subagents podem nao ser attachados.

3. **Model assignments nao enforced no codigo** — Agents (scientific, automation, etc) nao especificam `model` na classe. Se chamados diretamente, modelo fica indefinido. Precisa herdar do config.

4. **agents/scientific/scientific_agent.py:71-78** — Research areas hardcoded como AI/ML/CV/robotics, mas docs e YAML focam em medicina (MBE, PICO). Alinhar com config/ecosystem.yaml.

### HIGH (corrigir depois dos critical)

5. **CLAUDE.md:37-43** — Lista 7 skills mas existem 11 no diretorio `.claude/skills/`. Faltam: automation, organization, research, scientific.

6. **Anki MCP** — referenciado em PENDENCIAS.md mas ainda nao em `config/mcp/servers.json`. Adicionar quando configurar.

7. **Notion safety protocol** — Documentado em mcp_safety.md mas NAO enforced no codigo. Workflows usam generic `execute()` sem safety gates.

8. **Naming inconsistency** — Docs usam CamelCase (TrendAnalyzer, KnowledgeOrganizer), codigo usa snake_case (trend_analyzer, knowledge_organizer). Padronizar.

### MEDIUM (apos high)

9. **3 arquivos de workflow** sem precedencia clara: `config/workflows.yaml`, `workflows/medical_workflow.yaml`, `workflows/efficient_workflows.yaml`
10. **Budget estimates** variam: $2.20-2.60 (medical_workflow.yaml) vs $3.00-3.60 (ECOSYSTEM.md) vs $10-40 (ECOSYSTEM.md real estimate)
11. **Cross-validation thresholds** — Mesmos valores mas terminologia diferente: `human_review` (servers.json) vs `ask_confirmation` (mcp_safety.md)

### ARQUIVOS NAO VERIFICADOS (checar)

- `agents/core/smart_scheduler.py`
- `agents/core/budget_tracker.py`
- `subagents/analyzers/trend_analyzer.py`
- `subagents/processors/knowledge_organizer.py`
- `subagents/processors/data_pipeline.py`
- `subagents/monitors/web_monitor.py`

## P1 - PRIORIDADE CONCURSO: EXAM-GENERATOR

### AGUARDANDO DO USUARIO (segunda-feira)
O usuario vai fornecer **minimo 10 provas reais** (PDFs) para calibracao.
Fontes: ENARE, USP, UNICAMP, UNIFESP, AMB, FMUSP, Santa Casa, etc.
**NAO comecar calibracao sem essas provas.** Aguardar upload.

### Quando receber as provas:
1. [ ] Ingerir PDFs → parser de questoes (enunciado, alternativas, gabarito, banca, ano)
2. [ ] Analisar padroes por banca: dificuldade, materias mais cobradas, estilo de pegadinha
3. [ ] Mapear distribuicao de subespecialidades por prova
4. [ ] Calibrar exam-generator com esses padroes reais
5. [ ] Gerar questoes no estilo de cada banca, validadas contra o padrao
6. [ ] Justificativas com evidencia via BioMCP + PubMed MCP
7. [ ] Integracao Anki MCP: cards gerados do Error Log

### Subespecialidades alvo
cardio, nefro, pneumo, gastro, endocrino, infecto, reumato, hemato + clinica geral

## O QUE FOI FEITO (sessoes 1-4)

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
11. **MedAdapt descartado**: projeto abandonado (6 stars, 0 commits em 2026), overlap com BioMCP+PubMed MCP
12. **Decisao: construir, nao comprar** — AMBOSS (sem PT-BR, calibrado USMLE) e Neural Consult (sem MCP, sem PT-BR) descartados
13. **Pacto de Alianca Multi-AI** — coautoria explicita formalizada (`.claude/rules/coauthorship.md`)
14. **ECOSYSTEM.md** — secao Alianca com tabela de membros, papeis e protocolo de atribuicao

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
