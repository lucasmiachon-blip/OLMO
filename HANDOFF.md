# HANDOFF - Proxima Sessao

> Sessao 35 | proximo login

## ESTADO ATUAL

Monorepo funcional. CI verde (47 testes). Codex review 12/12 completo.

**Python** — ruff clean, mypy OK. Defensive patterns aplicados.

**Aulas** — 4 aulas (deck.js unificado). Metanalise deadline 15/abr. Cirrose: 44 slides, precisa rework pesado.

**Notion** — Calendario DB (views Diario/Semanal/Mensal). Tasks triadas GTD. Calendario dentro de Archived — mover.

## PROXIMO

1. **🔴 CIRROSE REWORK (sessao pesada)** — assimilar conteudo novo, apagar slides obsoletos, reestruturar. Lucas vai guiar o que fica/sai/muda. Ler `content/aulas/cirrose/` inteiro antes de comecar. Backup branch recomendado.
2. **Metanalise QA** — 14 slides html-ready (deadline 15/abr, 14 dias)
3. **Notion: mover Calendario DB** — esta em area Archived, inacessivel
4. **Notion: dashboard unificado** — Calendario + Tasks Do Next

## DECISOES ATIVAS

- Calendario DB = compromissos. Tasks DB = acoes GTD (Do Next/Someday).
- Codex: OAuth ChatGPT ($0, GPT-5.4). API key fallback gpt-5.2-pro.
- CSS: tokens (base.css) + composicao livre por slide.
- Maio/2026: foco total concurso. Abril = housekeeping aulas.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **Cirrose rework**: criar branch antes de deletar slides. Lucas decide o que sai.
- Calendario DB: `collection://308dfe68-59a8-81c2-8d7f-000bf3da6ec4`
- Tasks DB: `collection://2f6dfe68-59a8-81df-943b-000b7f7098cf`
- Psicologo: quartas 11h. Notion: 335dfe6859a881f783b5cc1f04b80567

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] BudgetTracker (SQLite, configurado mas inativo)
- [ ] Font-size audit cirrose: 12+ valores abaixo 28px threshold
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] daily-briefing: adicionar Notion Calendario + Tasks "Due Today"

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-01
