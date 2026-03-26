# PENDENCIAS - O Que Falta Para Rodar

> Checklist de setup. Atualizado: 26 de Marco de 2026

## MCPs (16 configurados)

### Conectados (13)
- [x] **Notion** — OAuth, connected
- [x] **PubMed** — claude.ai nativo, connected
- [x] **SCite** — assinatura ativa, connected
- [x] **Consensus** — assinatura ativa, connected
- [x] **Scholar Gateway** — connected
- [x] **Perplexity** — API key configurada, connected
- [x] **Gemini** — npx @rlabs-inc/gemini-mcp, connected
- [x] **NotebookLM** — npx notebooklm-mcp@latest, connected
- [x] **Zotero** — uvx zotero-mcp, local mode (Zotero app precisa estar aberto)
- [x] **Excalidraw** — connected
- [x] **Gmail** — claude.ai nativo, connected (sessao 15)
- [x] **Google Calendar** — claude.ai nativo, connected (sessao 15)
- [x] **Canva** — connected (sessao 15)

### Planejados (3)
- [ ] **Google Drive** — `@piotr-agier/google-drive-mcp` (requer Google Cloud Console OAuth)
- [ ] **ChatGPT 5.4 MCP** — cross-validator para Notion writes
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

## CONCURSO NOV/2026 (120 questoes)

- [ ] Exam-generator (aguarda 10+ provas reais em PDF)
- [ ] Anki + AnkiConnect (desktop + add-on 2055492159)
- [ ] Anki MCP (`claude mcp add anki-mcp npx -- -y @ankimcp/anki-mcp-server`)
- [ ] Primeiro simulado baseline (120 questoes cronometrado)
- [ ] Plano macro Mar-Nov no Notion

## ENSINO

- [ ] Database Notion "Teaching Log"
- [ ] Curriculo "AI para Alunos de Medicina" (8 aulas)
- [x] ~~Split teaching-improvement~~ → teaching + concurso + ai-fluency (sessao 15)

## INFRA

- [ ] BudgetTracker ativar (SQLite)
- [ ] claude-task-master (MCP GTD)
- [ ] n8n self-hosted (automacao 24/7)
- [ ] Cowork Skills: Extrair UpToDate, DynaMed, BMJ Best Practice

## CUSTO MENSAL

| Item | Custo/mes |
|------|----------|
| Claude Max (Opus 4.6) | incluso no plano |
| Perplexity Max | incluso no plano |
| Google One Ultra (Gemini) | incluso no plano |
| Scite + Consensus | ~$20-30 |
| Tudo mais | $0 |
| **TOTAL** | **~$20-30** (dentro do budget $100) |
