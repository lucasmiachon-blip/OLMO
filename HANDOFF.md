# HANDOFF - Proxima Sessao

> Sessao 40 | proximo login

## ESTADO ATUAL

Monorepo funcional. CI verde (47 testes). 11 rules. QA tooling multi-aula.

**Python** — ruff clean, mypy OK.

**Scripts** — 3 QA scripts compartilhados em scripts/ (qa-batch-screenshot, gemini-qa3, content-research). Todos com detectAula() + --aula CLI. Scripts antigos ainda em cirrose/scripts/ (backup).

**Aulas** — Cirrose: 11 slides ativos (Act 1) + 35 archive. Metanalise: 18 slides, **deadline 15/abr (14 dias)**, 14 QA pendentes, tooling pronto. Grade: 58 slides, ilegivel.

**Governanca** — 11 rules, 7 hooks, 8 agents, 20 skills, 3 commands.

## PROXIMO

1. **Codex Review: scripts + docs + CSS + HTML** — reframing objetivo e adversarial (S38 excedeu tokens, resposta incompleta). Escopo bem definido, framing curto. Anti-sycophancy: so aceitar o que for adequado.
2. **Metanalise QA** — 14 slides pendentes. Tooling pronto: `npm run qa:screenshots:metanalise` → gate0 → gate4.
3. **Cirrose Act 2 reconstituicao** — 33 slides em _archive, precisam rework. Lucas guia.
4. **Notion: mover Calendario DB** — esta em area Archived, inacessivel.

## DECISOES ATIVAS

- Calendario DB = compromissos. Tasks DB = acoes GTD (Do Next/Someday).
- Codex: OAuth ChatGPT ($0, GPT-5.4). API key fallback gpt-5.2-pro.
- CSS cirrose: self-contained. Metanalise: imports base.css.
- Maio/2026: foco total concurso. Abril = housekeeping aulas.
- Scripts antigos em cirrose/scripts/: manter como backup ate confirmar shared em producao.
- qa-engineer: economic mode default, deep mode on demand (--deep).

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Cirrose _archive: nao deletar sem branch de backup. Lucas decide o que sai.
- Codex Review: framing curto (< 2000 tokens prompt). Adversarial, nao servil. Chunk por area.

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] BudgetTracker (SQLite, configurado mas inativo)
- [ ] Font-size audit cirrose: 12+ valores abaixo 28px threshold
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] daily-briefing: adicionar Notion Calendario + Tasks "Due Today"
- [ ] Remover scripts antigos de cirrose/scripts/ apos validar shared

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-01
