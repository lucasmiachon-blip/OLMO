# HANDOFF - Proxima Sessao

> Sessao 55 | proximo login

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). 11 rules.
nlm-skill v1.0 (S53). insights-skill v1.0 (S54): 22/22 assertions, +8.3pp vs baseline.
5 hooks ativos e verificados. Git audit limpo.

## PROXIMO

1. **Rodar /research em s-aplicacao** — segundo HTML, validar com dados clinicos reais
2. **Metanalise QA** — 13 slides pendentes. Deadline 2026-04-15 (~12 dias)
3. **Implementar propostas do /insights** — 8 proposals diff-ready (fail-closed, staged-blob, anti-sycophancy, encoding, etc.)
4. **Cleanup old skills** — remover evidence/, mbe-evidence/, agent literature.md
5. **ARCHITECTURE.md sync** — alinhar com implementacao real (parcialmente feito S51)

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- /research e /teaching NAO fundem (lifecycle diferente). mbe-evaluator e a ponte.
- /insights semanal complementa /dream diario. Dream = memoria, insights = performance.
- insights read-only: propoe, nunca aplica. Lucas decide.
- Projetor ~10m: HTML primary + Canva Pro fallback (design only).
- nlm-skill: workflow-first, reference.md para detalhes.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Context rot: commit + update docs antes de degradar.
- Security gates fail-closed. NaN/negative input → BLOCK.
- guard-product-files.sh wired — protege cirrose product files.

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] daily-briefing: adicionar Notion Calendario + Tasks "Due Today"
- [ ] h2 assertion rewrite — 11+ slides. Lucas guia.
- [ ] design-reference.md — expandir E21, add RETRACTED status, chroma floor
- [ ] reduced-motion visual test — Chrome --force-prefers-reduced-motion

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-03
