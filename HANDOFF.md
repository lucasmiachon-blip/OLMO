# HANDOFF - Proxima Sessao

> Sessao 50 | proximo login

## ESTADO ATUAL

Monorepo funcional. CI verde (47 testes). 11 rules.
Pipeline /research v2 validado. Living HTML per slide.
Slide s-rs-vs-ma DONE: 3 colunas (Revisoes, RS, MA), hierarquia visual, SVG forest plot, PMIDs verificados.

## PROXIMO

1. **Preencher [EXEMPLO TBD]** — revisao narrativa recente NEJM para speaker notes s-rs-vs-ma
2. **Rodar /research em s-aplicacao** — segundo HTML, validar com dados clinicos reais
3. **Cleanup old skills** — remover evidence/, mbe-evidence/, agent literature.md
4. **Metanalise QA** — 13 slides pendentes. Deadline 2026-04-15 (~13 dias)
5. **aside.notes deprecation** — atualizar slide-rules.md + linters
6. **Merge new-slide → slide-authoring** — overlap critico

## DECISOES ATIVAS

- Living HTML per slide substitui: evidence-db.md, aside.notes, Notion slide DB, blueprint.md
- Fontes por slide: de 5 para 2 (evidence HTML + narrative.md)
- Evidence-first workflow: HTML gerado ANTES do slide de apresentacao
- /research e /teaching NAO fundem (lifecycle diferente). mbe-evaluator e a ponte.
- Projetor ~10m: HTML primary + Canva Pro fallback

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Context rot: commit + update docs antes de degradar.

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] daily-briefing: adicionar Notion Calendario + Tasks "Due Today"
- [ ] Codex deferred: linter parsers — #13, #28-29. Low ROI.
- [ ] h2 assertion rewrite — 11+ slides. Lucas guia.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-02
