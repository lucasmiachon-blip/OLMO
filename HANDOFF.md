# HANDOFF - Proxima Sessao

> Sessao 68 | 2026-04-04

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). 9 rules (5 path-scoped).
GEMINI.md v3.6: 3 gates de integridade + criatividade livre.
P1 audit fixes aplicados (8/8). Benchmark CLI vs API concluido (API venceu).
content-research.mjs: CLI mode fix (shell: true, timeout 300s).
Memory: 13 files, next review S69.

## P0 — CODEX ADVERSARIAL (pos-clear)

1. Rodar Round 2A: `cat .claude/tmp/codex-round2a.md | codex exec --sandbox read-only -o .claude/tmp/codex-r2a-output.md -`
2. Rodar Round 2B: `cat .claude/tmp/codex-round2b.md | codex exec --sandbox read-only -o .claude/tmp/codex-r2b-output.md -`
3. Triagem findings (FIX / ACCEPT / REJECT)
4. Aplicar fixes aprovados

## P1 — AULAS (herdado)

1. Metanalise QA — 19 slides, 4 DONE, 15 pendentes. Deadline 2026-04-15 (~11 dias)
2. Construir slide s-pico — evidence HTML pronto
3. Rodar /research em s-aplicacao

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- Gemini CLI (OAuth Ultra) = pesquisas pontuais. API key = scripts (content-research, gemini-qa3).
- Memory governance: cap 20 files, review a cada 3 sessoes. Next: S69.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Context rot: commit + update docs antes de degradar.
- settings.local.json e hooks/ BLOQUEADOS contra Edit/Write (pedir autorizacao).

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] ARCHITECTURE.md sync
- [ ] GEMINI.md: revisitar se precisar mais restritivo apos testes

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-04
