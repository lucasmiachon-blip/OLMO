# HANDOFF - Proxima Sessao

> Sessao 34 | 2026-04-01

## ESTADO ATUAL

Monorepo funcional. CI verde (47 testes). Codex review 12/12 findings resolvidos.

**Python** — ruff clean, mypy OK. Defensive patterns aplicados (try/except, enum validation, handler coverage).

**Aulas** — 4 aulas (deck.js unificado). Metanalise deadline 15/abr (14 dias).

**Codex** — OAuth ChatGPT (GPT-5.4, $0). Primeiro review completo e ensinado.

## PROXIMO

1. **Metanalise QA** — 14 slides restantes (deadline 15/abr)
2. **Notion cleanup** — mover Calendario, criar views Today/Tomorrow
3. **Proximo Codex review** — agendar apos proxima feature major

## DECISOES ATIVAS

- Codex: OAuth ChatGPT ($0, GPT-5.4). API key mantida como fallback (gpt-5.2-pro).
- CSS: tokens (base.css) + composicao livre por slide.
- Skills: formato SKILL.md (oficial), descriptions "pushy".
- Maio/2026: foco total concurso. Abril = housekeeping aulas.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Codex OAuth: so aceita modelo default (GPT-5.4). Modelos especificos exigem API key.
- gpt-5.3-codex: NAO disponivel via API (rollout fechado, mar/2026).
- Notion Calendario DB: `collection://308dfe68-59a8-81c2-8d7f-000bf3da6ec4`
- Notion Tasks DB: `collection://2f6dfe68-59a8-81df-943b-000b7f7098cf`

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
