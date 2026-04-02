# HANDOFF - Proxima Sessao

> Sessao 48 | proximo login

## ESTADO ATUAL

Monorepo funcional. CI verde (47 testes). 11 rules.
/research v2 validada (21/21, +31pp vs baseline, iteration 2 completa).
Living HTML per slide: SKILL.md atualizado, script gerador criado, template definido.

## PROXIMO

1. **Rodar /research em s-aplicacao** — primeiro HTML real, validar template + script
2. **Cleanup old skills** — remover evidence/, mbe-evidence/, agent literature.md
3. **Metanalise QA** — 14 slides pendentes. Deadline 2026-04-15 (~13 dias)
4. **aside.notes deprecation** — atualizar slide-rules.md + linters (apos HTML validado)
5. **Merge new-slide → slide-authoring** — overlap critico
6. **Producao metanalise** — projetor ~10m. HTML primary + Canva Pro fallback

## DECISOES ATIVAS

- Living HTML per slide substitui: evidence-db.md, aside.notes, Notion slide DB, blueprint.md
- Fontes por slide: de 5 para 2 (evidence HTML + narrative.md)
- /research e /teaching NAO fundem (lifecycle diferente). mbe-evaluator e a ponte.
- Notion slide DB metanalise: NAO popular (HTML e source of truth)
- NNT e hero metric. Risco basal obrigatorio quando disponivel.
- SCite contrasting citations para critica metodologica.
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
