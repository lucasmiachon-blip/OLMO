# HANDOFF - Proxima Sessao

> Sessao 33 | 2026-03-31

## ESTADO ATUAL

Monorepo funcional. CI verde (47 testes). Codex CLI OAuth ativo (GPT-5.4, $0).

**Python** — ruff clean, mypy OK. 5 security fixes aplicados (path traversal, XSS, MCP drift, async import).

**Aulas** — 4 aulas (deck.js unificado). Metanalise deadline 15/abr (15 dias).

**Codex** — OAuth ChatGPT. Config: `~/.codex/config.toml` (forced_login_method=chatgpt). gpt-5.3-codex NAO disponivel via API (rollout fechado).

## PROXIMO

1. **Ensinar Lucas os findings do Codex review** — explicar cada WARN/INFO, conceitos de seguranca (path traversal, XSS, name drift). Ref: `docs/CODEX-REVIEW-S33.md`
2. **Self-improvement** — consolidar learnings em memoria (Codex workflow, model availability)
3. **INFO fixes (I6-I12)** — 7 issues de robustez pendentes do Codex review
4. **Metanalise QA** — 14 slides restantes (deadline 15/abr)
5. **Notion cleanup** — mover Calendario, criar views Today/Tomorrow

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
Coautoria: Lucas + Opus 4.6 + GPT-5.4 (reviewer) | 2026-03-31
