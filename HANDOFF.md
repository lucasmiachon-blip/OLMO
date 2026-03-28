# HANDOFF - Proxima Sessao

> Sessao 21 | 2026-03-28

## ESTADO ATUAL

19 skills, 4 agents, 6 rules (2 com path-scoping), 2 hooks ativos (notification + stop-hygiene). 13 MCPs connected. Arvore limpa, sem dirs vazios. mcp_safety podada (137→92 linhas).

## PROXIMO

1. **Testar hooks em sessao real** — verificar toast notification no Windows + stop-hygiene output
2. **Testar custom agents** — researcher, literature, quality-gate ou notion-ops em tarefa real
3. **Conceitos Garimpados** → distribuir para paginas do Masterpiece (Notion write)

## PENDENTE

### Infra & Config
- [ ] Verificar se `instructions.md` → `SKILL.md` e migracao real ou rumor (checar docs oficiais)
- [ ] Haiku 3 se aposenta abr/2026 — verificar se algum agent/config aponta pra versao antiga
- [ ] Google Drive MCP: criar Google Cloud Console project + OAuth credentials

### Funcionalidades
- [ ] Primeiro ciclo de pesquisa real (pipeline busca → validacao → sintese)
- [ ] Ativar BudgetTracker (SQLite, configurado mas inativo)
- [ ] Exam-generator (aguarda 10+ provas reais em PDF)
- [ ] Integrar claude-task-master (MCP GTD, 25k stars)
- [ ] NotebookLM: criar notebooks por tema de pesquisa ativo

### Automacao (longo prazo)
- [ ] n8n self-hosted (automacao 24/7)
- [ ] `/schedule` cloud tasks: daily-briefing (diario) + /evolve (semanal seg 9h)
- [ ] Lixeira Notion: deletar manualmente 2 paginas (rascunho + pagina vazia)

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + opus | 2026-03-28
