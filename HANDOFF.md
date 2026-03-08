# HANDOFF - Proxima Sessao

> Atualizado: 8 de Marco de 2026
> Sessao 6: Corte de docs inflados + prompt diagnostico

## CONTEXTO PRINCIPAL

**Concurso nov/2026**: 120 questoes multipla escolha — prioridade do ano.
**Alianca Multi-AI**: Opus 4.6 + ChatGPT 5.4 + Gemini 3.1 + Cursor.
Coautoria explicita em todo output (`.claude/rules/coauthorship.md`).

## P0 - PROXIMA SESSAO: DIAGNOSTICO COMPLETO

Rodar prompt de diagnostico (gerado na sessao 6) num chat Opus limpo.
Objetivo: auditoria tecnica honesta — cada .py classificado como Real/Stub/Quebrado.
**O prompt esta na conversa da sessao 6** (ou pedir pra gerar novamente).

Apos diagnostico, decidir:
1. Quais arquivos manter, quais deletar
2. O que e stub que precisa virar codigo real
3. O que funciona de verdade end-to-end

## P1 - VARREDURA NOTION (quando tiver token)

1. Rodar snapshot read-only: `notion_cleaner.execute({"action": "snapshot", "protected": ["aulas"]})`
2. Revisar `data/notion_snapshot.md`
3. Rodar analise e executar acoes uma a uma

## P2 - CONCURSO: EXAM-GENERATOR

**AGUARDANDO**: minimo 10 provas reais (PDFs) para calibracao.
Fontes: ENARE, USP, UNICAMP, UNIFESP, AMB, FMUSP, Santa Casa.

## O QUE FOI FEITO (sessao 6)

14. **Corte de ECOSYSTEM.md**: 393 → 52 linhas (removido duplicacao com CLAUDE.md)
15. **Corte de coauthorship.md**: 112 → 45 linhas (tabela + regras essenciais)
16. **Prompt de diagnostico**: gerado para sessao Opus limpa (auditoria completa)

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

## CONFLITOS PENDENTES (nao criticos)

- [ ] Model assignments nao enforced no codigo
- [ ] scientific_agent.py: research areas hardcoded AI/ML, deveria ser medicina
- [ ] Budget estimates: variancia entre arquivos
- [ ] Anki MCP: referenciado mas nao em servers.json

## ARQUIVOS NAO VERIFICADOS

- `agents/core/smart_scheduler.py`
- `agents/core/budget_tracker.py`
- `subagents/analyzers/trend_analyzer.py`
- `subagents/processors/data_pipeline.py`
- `subagents/monitors/web_monitor.py`

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
Orquestrador: opus (corte de docs + diagnostico)
Data: 2026-03-08
