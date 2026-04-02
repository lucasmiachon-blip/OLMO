# HANDOFF - Proxima Sessao

> Sessao 41 | proximo login

## ESTADO ATUAL

Monorepo funcional. CI verde (47 testes). 11 rules. Codex Review S40 completo: 135 findings documentados.

**Python** — ruff clean, mypy OK.

**Scripts** — 13 scripts em scripts/. 47 findings (3 CRITICAL, 17 HIGH). Top: Windows file URL, --strictPort, GSAP rule desabilitada no Windows.

**CSS** — 35 findings (21 HIGH). Font-size < 18px sistematico (13 instancias). Print/PDF incompleto. GSAP jurisdiction.

**HTML** — 37 findings (22 HIGH). 11+ h2 genericos (Lucas reescreve). MELD 14 vs 10 contradictorio.

**Governanca** — 16 findings (4 CRITICAL). qa-engineer threshold impossivel. mcp_safety auto-execute contradiz human gate.

## PROXIMO

1. **P0 fixes** — 5 silent failures: pathToFileURL(), --strictPort, MELD reconcile, Windows path separator, Gemini response validation
2. **P1 governance** — resolver contradicoes: qa-engineer threshold, mcp_safety, slide-rules, stale paths
3. **P2 audits** — font-size 18px, print/PDF reset, GSAP jurisdiction, dark-slide tokens
4. **C15 relaunch** — docs/prompts review. Bug: codex:codex-rescue trava com .md files (2x). Investigar.
5. **Metanalise QA** — 14 slides pendentes. Deadline 2026-04-15. Tooling pronto.

## DECISOES ATIVAS

- Calendario DB = compromissos. Tasks DB = acoes GTD (Do Next/Someday).
- Codex: OAuth ChatGPT ($0, GPT-5.4). API key fallback gpt-5.2-pro.
- CSS cirrose: self-contained. Metanalise: imports base.css.
- Maio/2026: foco total concurso. Abril = housekeeping aulas.
- Inline opacity:0 para GSAP init = OK. "NUNCA inline" e forte demais.
- h2 assertion rewrite = trabalho do Lucas. AI so flaggeia, nao reescreve.
- qa-engineer: economic mode default, deep mode on demand (--deep).

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Cirrose _archive: nao deletar sem branch de backup. Lucas decide o que sai.
- P0 fixes: testar no Windows (muitos findings sao Windows-specific).
- Codex doc review: bug ativo, nao confiar em codex:codex-rescue para .md files.

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
Coautoria: Lucas + Opus 4.6 + GPT-5.4 (Codex) | 2026-04-01
