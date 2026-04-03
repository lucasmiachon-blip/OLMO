# HANDOFF - Proxima Sessao

> Sessao 51 | proximo login

## ESTADO ATUAL

Monorepo funcional. CI verde (47 testes). 11 rules.
Adversarial review S50 DONE: 118 findings (9 CRIT, 61 HIGH) em `docs/ADVERSARIAL-REVIEW-S50.md`.
4 padroes sistemicos: security theater, working-tree vs staged, fail-open, docs drift.

## PROXIMO (prioritizado por adversarial review)

1. **Corrigir CRITICAL** — mcp_safety.py (NaN guard), orchestrator.py (wire validate_mcp_step), guard-secrets.sh (staged blob), validate-css.sh (exit code), medical-researcher (NNT + retraction)
2. **Corrigir HIGH pre-deadline** — deck.js (race condition), engine.js (reduced-motion), base.css (OKLCH fallback), pre-commit.sh (staged blob)
3. **Rodar /research em s-aplicacao** — segundo HTML, validar com dados clinicos reais
4. **Metanalise QA** — 13 slides pendentes. Deadline 2026-04-15 (~11 dias)
5. **Cleanup old skills** — remover evidence/, mbe-evidence/, agent literature.md
6. **Docs sync** — CLAUDE.md, ARCHITECTURE.md, slide-rules.md, design-reference.md

## DECISOES ATIVAS

- Living HTML per slide substitui: evidence-db.md, aside.notes, Notion slide DB, blueprint.md
- Fontes por slide: de 5 para 2 (evidence HTML + narrative.md)
- Evidence-first workflow: HTML gerado ANTES do slide de apresentacao
- /research e /teaching NAO fundem (lifecycle diferente). mbe-evaluator e a ponte.
- Projetor ~10m: HTML primary + Canva Pro fallback

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Context rot: commit + update docs antes de degradar.
- **Security theater**: 4 gates existem mas nao protegem — ver adversarial review.

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
Coautoria: Lucas + Opus 4.6 + GPT-5.4 | 2026-04-02
