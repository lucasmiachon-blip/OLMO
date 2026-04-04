# HANDOFF - Proxima Sessao

> Sessao 58 | 2026-04-03

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). 11 rules (5 path-scoped).
Enforcement layer completa: guard-pause.sh, guard-bash-write.sh, guard-product-files.sh (all aulas), session-compact.sh.
Codex audit S57 resolvido: 10 fixes aplicados, 1 dead code removido, 6 rejeitados (justificados). Ver `docs/CODEX-FIXES-S58.md`.

## PROXIMO (P0 — aulas)

1. **Metanalise QA** — 18 slides, QA visual incompleto. Deadline 2026-04-15 (~12 dias)
2. **Construir slide s-pico** — evidence HTML pronto. Decidir h2, source-tag, speaker notes
3. **Rodar /research em s-aplicacao** — segundo HTML, validar com dados clinicos

## PROXIMO (P1 — infra)

4. **Cleanup old skills** ��� remover evidence/, mbe-evidence/, agent literature.md
5. **h2 assertion rewrite** — 11+ slides. Lucas guia.

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- guard-pause.sh: "ask" em todo Edit/Write (exceto memory files).
- guard-bash-write.sh: "ask" em shell redirects (>, >>, sed -i, tee, writeFile).
- guard-product-files.sh: "ask" em todas as aulas (generalizado).
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
