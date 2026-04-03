# HANDOFF - Proxima Sessao

> Sessao 56 | proximo login

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). 11 rules (5 path-scoped).
`.theme-dark` class em base.css — dark slides sem IDs hardcoded.
CLAUDE.md 72 linhas (era 98). process-hygiene e design-reference path-scoped.

## PROXIMO

1. **Construir slides metanalise** — Lucas vai indicar foco
2. **Rodar /research em s-aplicacao** — segundo HTML, validar com dados clinicos reais
3. **Metanalise QA** — 13 slides pendentes. Deadline 2026-04-15 (~12 dias)
4. **Cleanup old skills** — remover evidence/, mbe-evidence/, agent literature.md
5. **ARCHITECTURE.md sync** — alinhar com implementacao real + CLAUDE.md line count

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- `.theme-dark` class para dark slides (substitui IDs hardcoded). slide-rules.md §10 atualizado.
- /research e /teaching NAO fundem. /insights semanal + /dream diario.
- Projetor ~10m: HTML primary + Canva Pro fallback (design only).

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Context rot: commit + update docs antes de degradar.
- Security gates fail-closed. NaN/negative input → BLOCK.

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] daily-briefing: adicionar Notion Calendario + Tasks "Due Today"
- [ ] h2 assertion rewrite — 11+ slides. Lucas guia.
- [ ] reduced-motion visual test — Chrome --force-prefers-reduced-motion
- [ ] Cirrose: migrar dark slides para .theme-dark (mesmo pattern)

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-03
