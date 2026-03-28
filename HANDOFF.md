# HANDOFF - Proxima Sessao

> Sessao 20 | 2026-03-28

## ESTADO ATUAL

19 skills (todas com YAML frontmatter). 4 custom agents em `.claude/agents/`. 6 rules. 16 MCPs (13 connected, 3 planned). Memory pruned: 5 files (3 stale removidas). Auditoria Masterpiece: 3 ciclos completos.

## PROXIMO

1. **Hooks** — configurar 3 hooks em settings.json (maior gap atual):
   - `Notification`: alerta desktop quando Claude precisa de input
   - `SessionStart` (matcher: `compact`): re-le HANDOFF.md apos compaction
   - `Stop` (prompt-based): checa se HANDOFF+CHANGELOG foram atualizados
2. **Rules path-scoping** — adicionar `paths:` frontmatter em mcp_safety.md e notion-cross-validation.md (nao carregar 210 linhas em sessoes sem Notion)
3. Distribuir conceitos do MOC de Conceitos Garimpados para paginas do Masterpiece
4. Testar custom agents em sessao real (researcher, notion-ops, literature, quality-gate)

## PENDENTE

### Infra & Config
- [ ] Hooks: Notification + post-compact + Stop session-hygiene (ver achados sessao 20)
- [ ] Rules: `paths:` frontmatter em mcp_safety.md e notion-cross-validation.md
- [ ] settings.local.json: remover 4 permissoes Notion redundantes (wildcard ja cobre)
- [ ] Verificar se `instructions.md` → `SKILL.md` e migracao real ou rumor (checar docs oficiais)
- [ ] Haiku 3 se aposenta abr/2026 — verificar se algum agent/config aponta pra versao antiga
- [ ] mcp_safety.md: podar secoes FATOS e FONTES (rationale), manter so protocolo (~136→~60 linhas)
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
