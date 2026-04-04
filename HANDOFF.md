# HANDOFF - Proxima Sessao

> Sessao 63 | 2026-04-04

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). 9 rules (5 path-scoped).
8 hooks (.claude/hooks/) + 5 hooks (hooks/). Memory: 20 files (cap 20).
Codex audit Round 1 completo. Report: `docs/S63-AUDIT-REPORT.md`.

## PROXIMO (P0 — S64)

1. **Revisar S63 audit report** — 8 FIX pendentes (4 alto, 4 medio). Lucas aprova.
2. **Aplicar fixes aprovados** — precedence clarifier, verification fallback, IPD scope, /dream check, frontmatter normalize, qa-pipeline paths, notion-cv opening, session-hygiene no-commit
3. **Rodar Codex Round 2** — prompts prontos em `.claude/tmp/codex-round2a.md` e `round2b.md`. Comandos no report.
4. **Triagem Round 2** — fix/accept/reject + fixes finais
5. **Build slides metanalise** + preparar pre-reading

## PROXIMO (P1 — aulas)

6. **Metanalise QA** — 18 slides, 3 DONE, 15 pendentes. Deadline 2026-04-15 (~11 dias)
7. **Construir slide s-pico** — evidence HTML pronto
8. **Rodar /research em s-aplicacao**

## PROXIMO (P2 — infra herdado)

9. **h2 assertion rewrite** — 11+ slides. Lucas guia.

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- Audit findings: report first, execute next session. NUNCA aplicar imediatamente.
- QA visual = Opus (multimodal) + Gemini script. Build ANTES de QA.
- Memory governance: cap 20 files, review a cada 3 sessoes.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Context rot: commit + update docs antes de degradar.
- settings.local.json e hooks/ BLOQUEADOS contra Edit/Write.

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] ARCHITECTURE.md sync — alinhar com implementacao real

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-04
