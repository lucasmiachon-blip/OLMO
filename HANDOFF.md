# HANDOFF - Proxima Sessao

> Sessao 96 | 2026-04-07
> Cross-ref: `BACKLOG.md` | `.claude/plans/hidden-shimmying-creek.md`

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Build OK (18 slides metanalise).
**Agentes: 8** (todos com maxTurns). **Hooks: 25 registrations** (27 scripts; 2 pre-commit). **Rules: 10**. MCPs: 11.
**OTel + Langfuse V3: TRACES FUNCIONANDO.** Docker stack hardened (127.0.0.1, fail-fast secrets, debug removed from traces/metrics).
**Antifragile: L1-L5 DONE, L6 BASIC (4 vetores), L7 DONE.**
**APL: LIVE.** 3 hooks.
**Codex adversarial: 16 of 23 findings resolved** (5 P0, 8 P1, 3 skipped with justification). Batches 1+4 still pending re-run.

## PROXIMOS PASSOS

| # | Item | Impacto | Complexidade |
|---|------|---------|--------------|
| 1 | Re-rodar Codex Batches 1+4 (hooks shell + JS scripts) | Cobertura adversarial | Normal |
| 2 | QA slide session — testar pipeline S95 (Preflight→Inspect→Editorial) | Validar pipeline | Normal |
| 3 | Testar Docker stack apos hardening (`docker compose up -d`) | Validar Redis auth, OTel pin | Facil |
| 4 | notion-ops: adicionar write tools + gates (finding #5) | Baixa prioridade | Facil |

## AGENTES

| Agente | Model | maxTurns | Memory | Status |
|--------|-------|----------|--------|--------|
| evidence-researcher | sonnet | 20 | project | OK (S96 fix) |
| qa-engineer | sonnet | 12 | project | OK |
| mbe-evaluator | sonnet | 15 | — | OK (FROZEN ate aula completa) |
| reference-checker | haiku | 15 | project | OK (S96: Notion removido do contrato) |
| quality-gate | haiku | 10 | — | OK |
| researcher | haiku | 15 | — | OK |
| repo-janitor | haiku | 12 | — | OK |
| notion-ops | haiku | 10 | — | **P1: adicionar write tools + gates (Lucas decidiu: write-capable)** |

## DECISOES ATIVAS

- **QA pipeline S95:** Script unico `gemini-qa3.mjs`. qa-capture.mjs = utilitario (Playwright library direta, nao MCP).
- **Values: Antifragile + Curiosidade** — decision gates, nao decoracao.
- **APL:** 3 hooks passivos. Cache em `.claude/apl/`.
- **Living HTML per slide = source of truth.** evidence-db.md deletado (cirrose legacy removido S96).
- **CLAUDE.md cascata:** root → content/aulas/ → metanalise/.
- **Cross-ref: dual gate** — stop hook (advisory) + pre-commit (blocking).
- **Self-healing loop:** stop-detect → `.claude/pending-fixes.md` → session-start surfacea.
- **Known-bad-patterns:** 5 KBPs. KBP-05 = agent convention (sem hook, maxTurns backstop).
- **OTel + Langfuse V3:** Traces OK. Debug exporter removido de traces/metrics (S96). Logs = langfuse + debug.
- **L6 chaos:** BASIC — 4 vetores. Opt-in `CHAOS_MODE=1`.
- **Codex findings skipped (com justificativa):**
  - #16 MCP pins: npx -y ignora pins, sem beneficio real
  - #22 MinIO endpoint: split intencional (server vs browser), nao e bug
  - #5 notion-ops: Lucas decidiu write-capable → fix S97 (add tools + dedup + confidence gate + LGPD)
- Memory governance: cap 20 files (18 atual). Next review: S97.
- **/insights cadence:** last run S91. Next: S97.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — rodar build apos editar _manifest.js.
- **CSS per-slide: `section#s-{id}`** — specificity 0,1,1,1.
- PMIDs de LLM: ~56% erro. SEMPRE verificar.
- **Docker stack:** Secrets em `.env` (nao mais no docker-compose). Ports em 127.0.0.1. OTel pinado 0.149.0.
- **Langfuse keys:** `.env` no repo root e fonte de verdade.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S96 2026-04-07
