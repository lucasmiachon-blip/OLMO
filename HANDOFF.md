# HANDOFF - Proxima Sessao

> Sessao 60 | 2026-04-03

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). 11 rules (5 path-scoped).
8 hooks (.claude/hooks/): guard-pause, guard-generated, guard-product-files, guard-secrets,
guard-bash-write, guard-lint-before-build (NEW), guard-read-secrets (NEW), build-monitor.
5 hooks (hooks/): session-start, session-compact, stop-hygiene, notify, stop-notify.
Codex S60 dual-frame: 24 findings (16 fixed, 4 accepted, 4 TODO). Report: docs/CODEX-AUDIT-S60.md.
Cleanup: -15K lines (workspaces archived, deprecated skills deleted).
ALL hooks now use node JSON parsing (sed removed — fixes truncation bypass).

## PROXIMO (P0 — aulas)

1. **Metanalise QA** — 18 slides, QA visual incompleto. Deadline 2026-04-15 (~12 dias)
2. **Construir slide s-pico** — evidence HTML pronto. Decidir h2, source-tag, speaker notes
3. **Rodar /research em s-aplicacao** — segundo HTML, validar com dados clinicos

## PROXIMO (P1 — infra, Codex S60 TODOs)

4. **O13: lint-slides.js --aula** — script ignora argumento, linta todas as aulas
5. **O6: lint gate completar** — adicionar lint-case-sync + lint-narrative-sync ao build gate
6. **O15: lint-narrative-sync.js** — para de defaultar silenciosamente para cirrose
7. **h2 assertion rewrite** — 11+ slides. Lucas guia.
8. **Merge new-slide into slide-authoring** — ultimo cleanup de skills

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- guard-lint-before-build.sh: BLOQUEIA builds se lint-slides.js falhar.
- guard-read-secrets.sh: BLOQUEIA Read de .env, .pem, credentials.
- guard-product-files.sh: BLOQUEIA edits a settings.local.json e hooks/ (self-protection).
- guard-bash-write.sh: 11 patterns (>, sed -i, tee, writeFile, curl, wget, python, cp, mv, dd, perl, ruby, fs.promises).
- guard-pause.sh: "ask" em todo Edit/Write (exceto memory files).
- QA visual = Opus (multimodal) + Gemini script (gemini-qa3.mjs). Ambos coexistem.
- Build ANTES de QA: `npm run build:{aula}` obrigatorio.
- QA screenshots: usar CLI (`qa-batch-screenshot.mjs`), NUNCA MCP Playwright manual.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Context rot: commit + update docs antes de degradar.
- Security gates fail-closed. NaN/negative input -> BLOCK.
- settings.local.json e hooks/ sao BLOQUEADOS contra edits pelo agente (Codex S60 A6).

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] ARCHITECTURE.md sync — alinhar com implementacao real

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 + Codex GPT-5.4 | 2026-04-03
