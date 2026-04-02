# HANDOFF - Proxima Sessao

> Sessao 42 | proximo login

## ESTADO ATUAL

Monorepo funcional. CI verde (47 testes). 11 rules. Codex Review S40 completo: 147 findings (135 + 12 C15).
P0+P1 fixes aplicados (S41). Print/PDF reset feito. Font-size audit documentado.

**Python** — ruff clean, mypy OK.
**Scripts** — P0 fixes: pathToFileURL, Gemini validation, strictPort, Windows paths.
**CSS** — Print reset extended. 21 font-size < 18px documentados (Lucas decide).
**HTML** — MELD 14 reconciliado.
**Governanca** — P1 fixes: threshold 7/10, tools removed, auto-execute removed, stale paths.

## PROXIMO

1. **Font-size decisions** — 21 instancias documentadas em CODEX-REVIEW-S40.md. Lucas decide por categoria (tokens, eixos, source-tags, case-panel, titulo).
2. **P2 restante** — GSAP jurisdiction (7 instancias), [data-reveal] .no-js fallback, dark-slide tokens
3. **P3 polish** — script hardening, lint improvements, h2 assertion rewrite (Lucas guia)
4. **C15 findings** — 12 novos (1 CRITICAL PMID invalido, 7 HIGH contradictions/stale)
5. **Metanalise QA** — 14 slides pendentes. Deadline 2026-04-15.
6. **Meta** — context rot + dream/memorias nao funcionando. Investigar.

## DECISOES ATIVAS

- Calendario DB = compromissos. Tasks DB = acoes GTD (Do Next/Someday).
- Codex: OAuth ChatGPT ($0, GPT-5.4). API key fallback gpt-5.2-pro.
- CSS cirrose: self-contained. Metanalise: imports base.css.
- Maio/2026: foco total concurso. Abril = housekeeping aulas.
- Inline opacity:0 para GSAP init = OK. "NUNCA inline" e forte demais.
- h2 assertion rewrite = trabalho do Lucas. AI so flaggeia, nao reescreve.
- qa-engineer: economic mode default (>=7/10), deep mode on demand (>=9/10, --deep).

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Cirrose _archive: nao deletar sem branch de backup. Lucas decide o que sai.
- Codex doc review: bug do skill wrapper contornado (usar `codex exec --sandbox read-only` com stdin pipe).

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] BudgetTracker (SQLite, configurado mas inativo)
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] daily-briefing: adicionar Notion Calendario + Tasks "Due Today"
- [ ] Remover scripts antigos de cirrose/scripts/ apos validar shared

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 + GPT-5.4 (Codex) | 2026-04-01
