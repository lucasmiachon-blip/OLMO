# HANDOFF - Proxima Sessao

> Sessao 34 | 2026-04-01

## ESTADO ATUAL

Monorepo funcional. CI verde (47 testes). Codex review 12/12 findings resolvidos.

**Python** — ruff clean, mypy OK. Defensive patterns aplicados.

**Aulas** — 4 aulas (deck.js unificado). Metanalise deadline 15/abr (14 dias).

**Notion** — Calendario DB com views Diario/Semanal/Mensal. Tasks triadas (GTD: Do Next/Someday). Calendario DB dentro de area Archived — considerar mover.

## PROXIMO

1. **Metanalise QA** — 14 slides html-ready pendentes QA (deadline 15/abr)
2. **Notion: mover Calendario DB** — esta dentro de "Archived", usuario nao acha facilmente
3. **Notion: dashboard unificado** — pagina com Calendario + Tasks Do Next lado a lado

## DECISOES ATIVAS

- Calendario DB = compromissos com hora. Tasks DB = acoes (GTD: Do Next/Someday).
- Codex: OAuth ChatGPT ($0, GPT-5.4). API key mantida como fallback.
- CSS: tokens (base.css) + composicao livre por slide.
- Skills: formato SKILL.md (oficial), descriptions "pushy".
- Maio/2026: foco total concurso. Abril = housekeeping aulas.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Calendario DB: `collection://308dfe68-59a8-81c2-8d7f-000bf3da6ec4`
- Tasks DB: `collection://2f6dfe68-59a8-81df-943b-000b7f7098cf`
- Psicologo: quartas 11h (recorrente). Notion event ID: 335dfe6859a881f783b5cc1f04b80567

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
