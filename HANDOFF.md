# HANDOFF - Proxima Sessao

> Sessao 24 | 2026-03-29

## ESTADO ATUAL

Monorepo funcional end-to-end. Aulas: npm install OK (229 pkgs), vite dev server validado (cirrose HTTP 200 em localhost:3000), build OK (44 slides), lint slides clean. Python CI intacto (47 testes). Concurso mapeado com pipeline concreto.

## PROXIMO

1. **Instalar AnkiConnect** — Anki Desktop > Tools > Add-ons > 2055492159
2. **Configurar Anki MCP** — adicionar `@ankimcp/anki-mcp-server` v0.15.0 em servers.json + testar
3. **Colocar provas reais** em `assets/provas/` — PDFs das bancas para analise
4. **CSS @layer** — STRATEGY.md fase 1: organizar cascade em base.css

## PENDENTE

### Concurso (foco total a partir de abril)
- [ ] AnkiConnect + Anki MCP (proximo passo concreto)
- [ ] Provas reais em assets/ → analise de padroes → questoes calibradas
- [ ] Primeiro simulado baseline (120 questoes)
- [ ] Plano macro Abr-Nov no Notion

### Aulas
- [x] Grade migrada (58 slides, deck.js) — `content/aulas/grade/`
- [x] shared/ promovido para `content/aulas/shared/` (ambas aulas compartilham)
- [ ] STRATEGY.md fase 1: CSS @layer
- [ ] Trazer metanalise (conteudo no repo aulas-magnas original)
- [ ] Trazer osteoporose (70 slides, Reveal.js → deck.js, mesmo pattern que grade)

### Infra
- [ ] Google Drive MCP: OAuth credentials
- [ ] BudgetTracker (SQLite, configurado mas inativo)

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-03-29
