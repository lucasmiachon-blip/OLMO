# HANDOFF - Proxima Sessao

> Sessao 23 | 2026-03-29

## ESTADO ATUAL

Monorepo com aulas integradas. Cirrose (44 slides deck.js+GSAP) em `content/aulas/cirrose/`. Scaffolds para grade, metanalise, osteoporose. STRATEGY.md com pesquisa completa. Python CI intacto (47 testes, ruff, mypy). Slide rules com paths: frontmatter.

## PROXIMO

1. **npm install + testar dev server** — `cd content/aulas && npm install && npm run dev`
2. **Testar build cirrose** — `npm run build:cirrose` (requer PowerShell)
3. **Trazer metanalise** — 18 slides de wt-metanalise (branch feat/metanalise-mvp)
4. **Avaliar formato grade/osteoporose** — Reveal.js frozen, decidir migrar para deck.js ou PPTX

## PENDENTE

### Aulas
- [ ] npm install nao foi executado ainda (so copia de arquivos)
- [ ] Validar que vite.config.js funciona com paths adaptados
- [ ] Build scripts referem `aulas/cirrose/` — podem precisar ajuste para `cirrose/`
- [ ] Linters (lint-slides, lint-case-sync) — paths podem precisar ajuste
- [ ] STRATEGY.md roadmap fase 1: CSS @layer

### Infra (herdado sessao 22)
- [ ] Haiku 3 se aposenta abr/2026 — verificar configs
- [ ] Google Drive MCP: OAuth credentials
- [ ] BudgetTracker (SQLite, configurado mas inativo)

### Funcionalidades (herdado)
- [ ] Exam-generator (aguarda 10+ provas reais em PDF)
- [ ] Integrar claude-task-master (MCP GTD, 25k stars)
- [ ] NotebookLM: notebooks por tema de pesquisa

### Automacao (longo prazo)
- [ ] n8n self-hosted
- [ ] `/schedule` cloud tasks

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-03-29
