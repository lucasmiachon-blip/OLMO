# HANDOFF - Proxima Sessao

> Sessao 60 | 2026-04-03

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). 11 rules (5 path-scoped).
7 hooks (6 pre-existing + 1 novo: guard-lint-before-build). Lint enforced antes de builds.
Cleanup S60: evidence/, mbe-evidence/, literature.md removidos. 4 workspaces arquivados.
Dream skill: ONBOARDING removido, funcionando (run 12, 2026-04-03).
Codex dual-frame S60: objetivo + adversarial — findings pendentes review.

## PROXIMO (P0 — aulas)

1. **Metanalise QA** — 18 slides, QA visual incompleto. Deadline 2026-04-15 (~12 dias)
2. **Construir slide s-pico** — evidence HTML pronto. Decidir h2, source-tag, speaker notes
3. **Rodar /research em s-aplicacao** — segundo HTML, validar com dados clinicos

## PROXIMO (P1 — infra)

4. **Aplicar fixes do Codex S60** — revisar findings objetivo + adversarial
5. **h2 assertion rewrite** — 11+ slides. Lucas guia.
6. **Merge new-slide into slide-authoring** — ultimo cleanup de skills

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- guard-lint-before-build.sh: BLOQUEIA builds se lint-slides.js falhar.
- guard-pause.sh: "ask" em todo Edit/Write (exceto memory files).
- guard-bash-write.sh: "ask" em shell redirects + curl -o + wget -O + python -c.
- guard-product-files.sh: "ask" em todas as aulas (generalizado, sem FROZEN).
- QA visual = Opus (multimodal) + Gemini script (gemini-qa3.mjs). Ambos coexistem.
- Build ANTES de QA: `npm run build:{aula}` obrigatorio.
- QA screenshots: usar CLI (`qa-batch-screenshot.mjs`), NUNCA MCP Playwright manual.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Context rot: commit + update docs antes de degradar.
- Security gates fail-closed. NaN/negative input -> BLOCK.

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] ARCHITECTURE.md sync — alinhar com implementacao real

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-03
