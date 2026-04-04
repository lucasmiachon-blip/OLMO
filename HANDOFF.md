# HANDOFF - Proxima Sessao

> Sessao 57 | 2026-04-03

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). 11 rules (5 path-scoped).
Enforcement layer implementada: guard-pause.sh (ask on Edit/Write), session-compact.sh (pos-compaction), CLAUDE.md primacy/recency anchors.
Codex audit completo: 2 CRITICAL, 4 HIGH, 4 MEDIUM — ver `docs/CODEX-AUDIT-S57.md`.

## PROXIMO (P0 — enforcement fixes)

1. **guard-bash-write.sh** — bloquear shell redirects (`>`, `>>`, `sed -i`, `writeFileSync`)
2. **Resolver contradicoes de policy** — 6+ arquivos contradizem root CLAUDE.md (mentor_autonomy, metanalise/CLAUDE.md, slide-rules, design-reference, qa-pipeline)
3. **Expandir guard-product-files.sh** — cobrir metanalise e grade (so protege cirrose hoje)

## PROXIMO (P1 — aulas)

4. **Metanalise QA** — 18 slides, QA visual incompleto. Deadline 2026-04-15 (~12 dias)
5. **Construir slide s-pico** — evidence HTML pronto. Decidir h2, source-tag, speaker notes
6. **Rodar /research em s-aplicacao** — segundo HTML, validar com dados clinicos
7. **Cleanup old skills** — remover evidence/, mbe-evidence/, agent literature.md

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- guard-pause.sh: "ask" em todo Edit/Write (exceto memory files).
- QA visual = Opus (multimodal). NAO Gemini. NAO delegar.
- Build ANTES de QA: `npm run build:{aula}` obrigatorio.
- QA screenshots: usar CLI (`qa-batch-screenshot.mjs`), NUNCA MCP Playwright manual.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Shell bypass: `Bash("echo > file")` bypassa guard-pause — fix pendente (P0).
- Context rot: commit + update docs antes de degradar.
- Security gates fail-closed. NaN/negative input -> BLOCK.

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] h2 assertion rewrite — 11+ slides. Lucas guia.
- [ ] ARCHITECTURE.md sync — alinhar com implementacao real

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-03
