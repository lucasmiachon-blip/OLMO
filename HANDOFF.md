# HANDOFF - Proxima Sessao

> Atualizado: 8 de Marco de 2026
> Sessao atual: Definicao MCP + Protocolo Seguro Notion

## P0 - Fazer AMANHA

### 1. Verificar versao Ultimate Brain
- [ ] Checar versao atual instalada no Notion do usuario
- [ ] Comparar com ultima versao de Thomas Frank: https://thomasjfrank.com/brain/
- [ ] Comparar com templates oficiais do Notion: https://www.notion.com/templates
- [ ] Se atrasada: avaliar se vale atualizar (backup primeiro!)
- [ ] Verificar Flylighter (browser extension) — esta instalada?

### 2. Verificar avancos do Notion (plataforma)
- [ ] Checar releases recentes do Notion (notion.com/releases)
- [ ] Notion 3.0 AI agents — o que mudou desde Set 2025?
- [ ] Novos templates oficiais relevantes pra medico/pesquisador
- [ ] Novo pricing? Features do free tier mudaram?

### 3. Snapshot do Notion (P0 do PENDENCIAS.md)
- [ ] Configurar Notion MCP: `claude mcp add --transport http notion https://mcp.notion.com/mcp`
- [ ] Executar snapshot READ-ONLY de todas as paginas
- [ ] Gerar `data/notion_snapshot.md` com inventario completo
- [ ] Identificar databases, paginas orfas, duplicatas
- [ ] Mapear estrutura Ultimate Brain atual → nossos databases medicos

## O QUE FOI FEITO HOJE

### MCP Config Completa
- `config/mcp/servers.json` — 13 MCPs com model routing definido
- Notion = Opus direto ($0 via Pro/Max)
- ChatGPT 5.4 MCP adicionado como cross-validator

### Protocolo Seguro Notion (baseado em evidencia)
- `.claude/rules/mcp_safety.md` — protocolo completo
- Bugs reais documentados (#64, #74, #79, #80, #82, #131, #181)
- READ-ONLY padrao, 2 tokens, 1 write por vez
- Cross-validation Claude + 5.4 para writes ($0)
- Workaround para move: criar+copiar+verificar+arquivar

### NotionCleaner Reescrito
- `subagents/processors/notion_cleaner.py` — modelo harsh
- Fluxo: snapshot → inventario MD → analyze → plan → aprovacao humana → execute
- Checkpoints por acao (resumable)
- Nunca deleta, apenas arquiva

### Ultimate Brain Registrado
- PENDENCIAS.md atualizado com setup UB + medico
- tools_ecosystem.yaml com notion_base: ultimate_brain

## PENDENTE (nao urgente)

- [ ] Revisar todos os MDs (enxutos? auto-referenciados? best practices?)
- [ ] Configurar MCPs medicos (healthcare, pubmed, biomcp)
- [ ] Configurar Gmail MCP
- [ ] Testar workflows
