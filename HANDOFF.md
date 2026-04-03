# HANDOFF - Proxima Sessao

> Sessao 54 | proximo login

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). 11 rules.
nlm-skill v1.0 reescrita: 702→191 linhas, workflows medicos, MCP prefix fix, eval loop completo.
5 hooks ativos e verificados. Git audit limpo.

## PROXIMO

1. **Rodar /research em s-aplicacao** — segundo HTML, validar com dados clinicos reais
2. **Metanalise QA** — 13 slides pendentes. Deadline 2026-04-15 (~12 dias)
3. **Cleanup old skills** — remover evidence/, mbe-evidence/, agent literature.md
4. **ARCHITECTURE.md sync** — alinhar com implementacao real (parcialmente feito S51)
5. **design-reference.md** — expandir E21, add RETRACTED status, chroma floor
6. **reduced-motion visual test** — Chrome --force-prefers-reduced-motion + screenshot

## DECISOES ATIVAS

- Living HTML per slide substitui: evidence-db.md, aside.notes, Notion slide DB, blueprint.md
- Fontes por slide: de 5 para 2 (evidence HTML + narrative.md)
- Evidence-first workflow: HTML gerado ANTES do slide de apresentacao
- /research e /teaching NAO fundem (lifecycle diferente). mbe-evaluator e a ponte.
- Projetor ~10m: HTML primary + Canva Pro fallback
- validate-css.sh: !important fora de contexto permitido agora = FAIL (nao WARN)
- base.css: OKLCH chroma 0.001 (minimo para resolver E059 sem tint visivel)
- nlm-skill: workflow-first (paper study, research pipeline, batch concurso), reference.md para detalhes

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Context rot: commit + update docs antes de degradar.
- Security gates agora fail-closed. NaN/negative input → BLOCK.
- guard-product-files.sh agora wired — protege cirrose product files.

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
Coautoria: Lucas + Opus 4.6 | 2026-04-03
