# HANDOFF - Proxima Sessao

> Sessao 65 | 2026-04-04

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). 9 rules (5 path-scoped).
Gemini MCP removido — deep-search agora via CLI ($0 OAuth Ultra).
GEMINI.md v3.4 (skepticism mandate + backtracking + retraction check). AGENTS.md command-first.
content-research.mjs: `--cli` flag funcional (OAuth, $0).

## P0 — BENCHMARK CLI vs API

1. Usar `/skill-creator` para benchmark: content-research `--cli` vs API key
2. Metricas: qualidade research, acuracia JSON, latencia
3. Se CLI >= 90% qualidade API → tornar `--cli` default
4. gemini-qa3.mjs: avaliar viabilidade de `--cli` para Gate 0 (structured output via prompt)

## P1 — AUDIT (herdado S63)

1. Revisar S63 audit report — 8 FIX pendentes (4 alto, 4 medio)
2. Aplicar fixes aprovados
3. Rodar Codex Round 2 — prompts em `.claude/tmp/codex-round2a.md`

## P2 — AULAS (herdado)

4. Metanalise QA — 18 slides, 4 DONE, 14 pendentes. Deadline 2026-04-15 (~11 dias)
5. Construir slide s-pico — evidence HTML pronto
6. Rodar /research em s-aplicacao

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- Gemini CLI (OAuth Ultra) = canal primario de pesquisa ($0, 2000 req/dia).
- Scripts: API key como default, --cli como opt-in. Benchmark decide migracao.
- OAuth piggybacking inviavel (scope insuficiente) — verificado S65.
- Memory governance: cap 20 files, review a cada 3 sessoes.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- Context rot: commit + update docs antes de degradar.
- settings.local.json e hooks/ BLOQUEADOS contra Edit/Write (pedir autorizacao).

## PENDENTE (herdado)

- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)
- [ ] ARCHITECTURE.md sync

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-04
