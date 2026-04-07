# PENDENCIAS — Setup & Infraestrutura

> Checklist de instalacao e configuracao. Atualizado: 5 de Abril de 2026.
> Backlog de projeto → ver HANDOFF.md.

## MCPs (11 conectados)

### Conectados (11)
- [x] **Notion** — OAuth, connected
- [x] **PubMed** — claude.ai nativo, connected
- [x] **SCite** — assinatura ativa, connected
- [x] **Consensus** — assinatura ativa, connected
- [x] **Scholar Gateway** — connected
- ~~**Perplexity**~~ — migrado para API direta S87 (nao MCP)
- [x] **NotebookLM** — npx notebooklm-mcp@latest, connected
- [x] **Zotero** — uvx zotero-mcp, local mode (Zotero app precisa estar aberto)
- [x] **Excalidraw** — connected
- [x] **Gmail** — claude.ai nativo, connected (sessao 15)
- [x] **Google Calendar** — claude.ai nativo, connected (sessao 15)
- [x] **Canva** — connected (sessao 15)
- ~~**Gemini**~~ — descartado S71. Usar API/CLI, nao MCP.

### Planejados
- [ ] **Google Drive** — `@piotr-agier/google-drive-mcp` (requer Google Cloud Console OAuth)
- [ ] **Anki MCP** — `@ankimcp/anki-mcp-server` (requer Anki Desktop + AnkiConnect)

## FERRAMENTAS JA TEM

- [x] Perplexity Max
- [x] Excalidraw
- [x] Canva Pro
- [x] Google One Ultra 30TB (Drive + Gemini)
- [x] Claude Max (Opus 4.6)
- [x] Scite.ai (assinatura)
- [x] Consensus (assinatura)
- [x] Zotero (desktop)
- [x] Obsidian (vault local)

## WORKFLOW DE PESQUISA

```
Artigos → Zotero (biblioteca) + NotebookLM (estudo profundo)
Busca   → PubMed + Scholar + Perplexity (discovery)
Validar → SCite + Consensus (smart citations, consenso)
Sintese → Claude Opus (excerpts, nunca full-text no contexto)
Output  → Notion / Obsidian / Anki
```

Regra: **nunca** ler PDF inteiro no contexto do Claude. Usar MCPs.

## CONCURSO R3 — Setup Pendente

- [ ] **Instalar AnkiConnect** — Anki Desktop > Tools > Add-ons > 2055492159
- [ ] **Configurar Anki MCP** — `npx -y @ankimcp/anki-mcp-server --stdio` (v0.15.0, 18 tools)
- [ ] **Colocar provas reais em `assets/provas/`** — PDFs de bancas R3
- [ ] **Colocar SAPs em `assets/sap/`** — MKSAP e outros SAPs de especialidade

## AULAS — Migracoes Pendentes

- **Osteoporose** — 70 slides, Reveal.js (frozen), em `legacy/aulas-magnas`. Decidir formato.

## INFRA PENDENTE

- [ ] BudgetTracker ativar (SQLite)
- [ ] claude-task-master (MCP GTD)
- [ ] n8n self-hosted (automacao 24/7)
- [ ] Cowork Skills: Extrair UpToDate, DynaMed, BMJ Best Practice
- [ ] Database Notion "Teaching Log"

## CUSTO MENSAL

| Item | Custo/mes |
|------|----------|
| Claude Max (Opus 4.6) | incluso no plano |
| Perplexity Max | incluso no plano |
| Google One Ultra (Gemini) | incluso no plano |
| Scite + Consensus | ~$20-30 |
| Tudo mais | $0 |
| **TOTAL** | **~$20-30** (dentro do budget $100) |
