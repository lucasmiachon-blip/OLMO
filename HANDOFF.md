# HANDOFF - Proxima Sessao

> Sessao 39 | proximo login

## ESTADO ATUAL

Monorepo funcional. CI verde (47 testes). 11 rules. Codex Review P0-P3 COMPLETO.

**Python** — ruff clean, mypy OK.

**Scripts** — 10 scripts corrigidos (root paths, parser, WARN counter, parametrizacao, fail-hard, pipefail). Todos verificados com execucao real.

**Aulas** — Cirrose: 11 slides ativos (Act 1) + 35 archive. Metanalise: 18 slides, deadline 15/abr. Grade: 58 slides, ilegivel.

**Governanca** — 11 rules, 7 hooks, 8 agents, 20 skills, 3 commands.

## PROXIMO

1. **Metanalise: adaptar tooling cirrose** — mjs, md, prompts de cirrose serao adaptados para metanalise (Lucas pediu S38).
4. **Cirrose Act 2 reconstituicao** — 33 slides em _archive, precisam rework. Lucas guia.
4. **Metanalise QA** — 14 slides pendentes (deadline 15/abr, 14 dias)
5. **Notion: mover Calendario DB** — esta em area Archived, inacessivel

## DECISOES ATIVAS

- Calendario DB = compromissos. Tasks DB = acoes GTD (Do Next/Someday).
- Codex: OAuth ChatGPT ($0, GPT-5.4). API key fallback gpt-5.2-pro.
- CSS cirrose: self-contained (absorveu base.css). Outras aulas ainda usam base.css.
- Maio/2026: foco total concurso. Abril = housekeeping aulas.
- Source-tag: 16px (legibilidade confirmada 55" TV @ 6m).
- Verificacao PMID: vocabulario canonico em design-reference.md §3 (VERIFIED/WEB-VERIFIED/CANDIDATE/SECONDARY/UNRESOLVED).
- qa-engineer: economic mode default, deep mode on demand (--deep).

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Cirrose _archive: nao deletar sem branch de backup. Lucas decide o que sai.
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
