# HANDOFF - Proxima Sessao

> Sessao 44 | proximo login

## ESTADO ATUAL

Monorepo funcional. CI verde (47 testes). 11 rules. Codex Review S40: 147 findings.
P0+P1+P2 DONE. P3 partial (script throw fix). 12 findings dismissidos com reflexao critica.

**CSS** — Dark-slide tokens completos (metanalise). Cirrose .no-js [data-reveal] + title-affiliation 18px.
**JS** — qa-batch-screenshot: process.exit→throw (browser leak fix).
**Cleanup** — 5 stale cirrose/scripts/ removidos.

## PROXIMO

1. **Producao metanalise** — projetor gigante ~10m. HTML primary + Canva Pro fallback.
2. **Metanalise QA** — 14 slides pendentes. Deadline 2026-04-15.
3. **C15 findings** — 12 (1 CRITICAL PMID [VERIFY], 7 HIGH). Maioria docs.
4. **P3 polish restante** — getArg validation, install-fonts exit code, lint improvements
5. **h2 assertion rewrite** — 11+ slides. Lucas guia.

## DECISOES ATIVAS

- Projetor ~10m: HTML primary + Canva Pro fallback (design only, no interactivity)
- GSAP jurisdiction: CSS keeps opacity:0 only, JS owns fromTo(). Checkpoint = state machine (CSS OK)
- Codex framing: "adversarial e objetivo". Wrong framing = token overflow
- Calendario DB = compromissos. Tasks DB = acoes GTD (Do Next/Someday)
- Maio/2026: foco total concurso. Abril = housekeeping aulas
- h2 assertion rewrite = trabalho do Lucas. AI so flaggeia
- qa-engineer: economic >=7/10 default, deep >=9/10 on --deep

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Codex doc review: usar `codex exec --sandbox read-only` com stdin pipe.
- Context rot: commit + update docs antes de degradar. Janelas frescas.

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] daily-briefing: adicionar Notion Calendario + Tasks "Due Today"

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-01
