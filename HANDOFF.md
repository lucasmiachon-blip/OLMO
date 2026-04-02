# HANDOFF - Proxima Sessao

> Sessao 43 | proximo login

## ESTADO ATUAL

Monorepo funcional. CI verde (47 testes). 11 rules. Codex Review S40: 147 findings.
P0+P1 done. P2 mostly done (font-size, print, GSAP jurisdiction, --danger hue). S42 = 3 commits.

**CSS** — Font tokens bumped (20px small, 18px caption). --danger hue 8 everywhere (root + stage-c). Source-tags 16px. Cirrose aligned to base.
**JS** — GSAP fromTo() for hook + contrato (5 elements). Checkpoint left as-is (semantic class).
**HTML** — aria-hidden on forest-plot symbols.

## PROXIMO

1. **Producao metanalise** — projetor gigante ~10m. HTML primary + Canva Pro fallback. Starts S43.
2. **Dark-slide token restoration** (#57 metanalise, #60 cirrose) — 8 tokens on-dark per slide
3. **P3 polish** — script hardening (try/finally Playwright, getArg), lint improvements
4. **C15 findings** — 12 novos (1 CRITICAL PMID invalido, 7 HIGH). Maioria em docs.
5. **Metanalise QA** — 14 slides pendentes. Deadline 2026-04-15.
6. **Meta** — context rot + dream/memorias. Investigar.

## DECISOES ATIVAS

- Projetor ~10m: HTML primary + Canva Pro fallback (sem interatividade Canva)
- GSAP jurisdiction: CSS keeps opacity:0 only, JS owns fromTo(). Divider/checkpoint exceptions OK.
- Calendario DB = compromissos. Tasks DB = acoes GTD (Do Next/Someday).
- Maio/2026: foco total concurso. Abril = housekeeping aulas.
- h2 assertion rewrite = trabalho do Lucas. AI so flaggeia.
- qa-engineer: economic >=7/10 default, deep >=9/10 on --deep.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Codex doc review: usar `codex exec --sandbox read-only` com stdin pipe.
- Context rot: commit + update docs antes de degradar. Janelas frescas.

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] daily-briefing: adicionar Notion Calendario + Tasks "Due Today"
- [ ] Remover scripts antigos de cirrose/scripts/ apos validar shared

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-01
