# HANDOFF - Proxima Sessao

> Atualizado: 8 de Marco de 2026
> Sessao: MCP + Safety + Perfil Professor + Concurso + Auditoria MDs

## CONTEXTO PRINCIPAL

**Concurso nov/2026**: 120 questoes multipla escolha — prioridade do ano.
Todas as ferramentas e teorias consagradas de estudo devem servir a isso.

## P0 - Proxima Sessao

### 1. Verificar versao Ultimate Brain
- [ ] Checar versao atual instalada no Notion
- [ ] Comparar com ultima versao de Thomas Frank: thomasjfrank.com/brain/
- [ ] Se atrasada: avaliar update (backup primeiro!)

### 2. Verificar avancos Notion
- [ ] Releases recentes (notion.com/releases)
- [ ] Notion 3.0 AI agents — mudancas desde Set 2025?

### 3. Snapshot do Notion
- [ ] Configurar Notion MCP: `claude mcp add --transport http notion https://mcp.notion.com/mcp`
- [ ] Executar snapshot READ-ONLY de todas as paginas
- [ ] Gerar `data/notion_snapshot.md` com inventario completo
- [ ] Mapear Ultimate Brain → nossos databases medicos

### 4. Setup Concurso
- [ ] Definir especialidades/topicos do concurso
- [ ] Criar database Notion "Concurso Error Log"
- [ ] Configurar Anki + deck por especialidade
- [ ] Primeiro simulado baseline (120 questoes cronometrado)

## O QUE FOI FEITO (sessoes 1-2)

1. **MCP Config**: 13 MCPs com model routing, Notion = Opus $0 via Pro/Max
2. **Protocolo Seguro Notion**: `.claude/rules/mcp_safety.md`, bugs reais, modelo harsh
3. **NotionCleaner**: `notion_cleaner.py` reescrito, snapshot → inventario → plano → execucao
4. **Ultimate Brain**: registrado como base Notion (Thomas Frank)
5. **Perfil**: medico + professor + pesquisador + dev AI
6. **Teaching skill**: slideologia, cognicao, retorica, andragogia, AI fluency, dev AI 2x/semana
7. **Concurso nov/2026**: estrategia completa (active recall, spaced rep, interleaving, practice testing)
8. **Auditoria MDs**: KPIs, safety, self-improvement, cross-references, budget fix
9. **ChatGPT 5.4 MCP**: cross-validation para writes criticos

## PENDENTE (nao urgente)

- [ ] Configurar MCPs medicos (healthcare, pubmed, biomcp)
- [ ] Configurar Gmail MCP
- [ ] Testar workflows
- [ ] Curriculo completo "AI para Alunos de Medicina" (8 aulas)
- [ ] Criar database Notion "Teaching Log"
