# HANDOFF - Proxima Sessao

> Sessao 37 | proximo login

## ESTADO ATUAL

Monorepo funcional. CI verde (47 testes). Cirrose importada e testada no Vite.

**Python** — ruff clean, mypy OK. Defensive patterns aplicados.

**Aulas** — Cirrose: 11 slides ativos (Act 1) + 35 archive. CSS single-file (~3224L), font paths + source-tag fixados. Metanalise: 18 slides, deadline 15/abr. Grade: 58 slides, ilegivel.

**Governanca** — 7 hooks ativos (.claude/hooks/), 8 agents, 20 skills, 3 commands.

**Aula_cirrose standalone** — movida para `C:\Dev\Projetos\Legacy\Aula_cirrose`. Git intacto.

## PROXIMO

1. **Cirrose Act 2 reconstituicao** — 33 slides em _archive, precisam rework para novo formato. Lucas guia.
2. **Metanalise QA** — 14 slides pendentes (deadline 15/abr, 13 dias)
3. **Self-improvement** — Analisar ERROR-LOG + lessons do Aula_cirrose para extrair novas rules/skills
4. **Notion: mover Calendario DB** — esta em area Archived, inacessivel

## DECISOES ATIVAS

- Calendario DB = compromissos. Tasks DB = acoes GTD (Do Next/Someday).
- Codex: OAuth ChatGPT ($0, GPT-5.4). API key fallback gpt-5.2-pro.
- CSS cirrose: self-contained (absorveu base.css). Outras aulas ainda usam base.css.
- Maio/2026: foco total concurso. Abril = housekeeping aulas.
- Source-tag: 16px (legibilidade confirmada 55" TV @ 6m).

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Cirrose _archive: nao deletar sem branch de backup. Lucas decide o que sai.
- Calendario DB: `collection://308dfe68-59a8-81c2-8d7f-000bf3da6ec4`
- Tasks DB: `collection://2f6dfe68-59a8-81df-943b-000b7f7098cf`
- Psicologo: quartas 11h. Notion: 335dfe6859a881f783b5cc1f04b80567
- Pasta vazia `C:\Dev\Projetos\Aula_cirrose` pode ser deletada (locked no move)

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
