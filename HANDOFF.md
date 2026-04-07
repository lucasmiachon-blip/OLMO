# HANDOFF - Proxima Sessao

> Sessao 95 | 2026-04-07
> Cross-ref: `BACKLOG.md` | `.claude/plans/s95-codex-adversarial-findings.md`

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Build OK (18 slides metanalise).
**Agentes: 8** (evidence-researcher sem maxTurns — fix pendente). **Hooks: 25**. **Rules: 10**. MCPs: 11.
**OTel + Langfuse V3: TRACES FUNCIONANDO.** 7 containers healthy.
**Antifragile: L1-L5 DONE, L6 BASIC (4 vetores), L7 DONE.**
**APL: LIVE.** 3 hooks.
**QA pipeline simplificado S95:** Preflight (dims objetivas $0) → Inspect (Gemini Flash) → Editorial (Gemini Pro). Script unico: `gemini-qa3.mjs`. `qa-batch-screenshot.mjs` renomeado → `qa-capture.mjs` (utilitario de captura).

## PROXIMOS PASSOS

| # | Item | Impacto | Complexidade |
|---|------|---------|--------------|
| 1 | Verificar qa-capture.mjs: Playwright CLI vs MCP | Garantir nao usa MCP Playwright | Facil |
| 2 | Fixes P0 Codex (docker ports, secrets, debug exporter, deadline cache) | Security | Normal |
| 3 | Fixes P1 Codex (maxTurns, notion-ops gates, hook counts, paths) | Enforcement | Normal |
| 4 | Re-rodar Codex Batches 1+4 (hooks shell + JS scripts) | Cobertura adversarial | Normal |
| 5 | QA slide session — testar enforcement novo Preflight | Validar pipeline S95 | Normal |

Findings completos: `.claude/plans/s95-codex-adversarial-findings.md` (23 findings: 5 P0, 17 P1, 1 P2)

## AGENTES

| Agente | Model | maxTurns | Memory | Status |
|--------|-------|----------|--------|--------|
| evidence-researcher | sonnet | — | project | **P1: falta maxTurns** |
| qa-engineer | sonnet | 12 | project | OK (Preflight simplificado S95) |
| mbe-evaluator | sonnet | 15 | — | OK (FROZEN ate aula completa) |
| reference-checker | haiku | 15 | project | **P1: promete Notion sem acesso** |
| quality-gate | haiku | 10 | — | OK |
| researcher | haiku | 15 | — | OK |
| repo-janitor | haiku | 12 | — | OK |
| notion-ops | haiku | 10 | — | **P1: falta safety gates mcp_safety** |

## DECISOES ATIVAS

- **QA pipeline S95:** Script unico `gemini-qa3.mjs`. Preflight = dims objetivas (cor, tipografia, hierarquia) PASS/FAIL. Sem scorecard 14-dim, sem DOM batch, sem C1-C7 separados. `qa-capture.mjs` = utilitario de screenshot/video.
- **Values: Antifragile + Curiosidade** — decision gates, nao decoracao.
- **APL:** 3 hooks passivos. Cache em `.claude/apl/`.
- **Living HTML per slide = source of truth.** evidence-db.md deprecated (cirrose legacy ainda existe).
- **CLAUDE.md cascata:** root → content/aulas/ → metanalise/.
- **Cross-ref: dual gate** — stop hook (advisory) + pre-commit (blocking).
- **Self-healing loop:** stop-detect → pending-fixes → session-start surfacea.
- **Known-bad-patterns:** 5 KBPs. KBP-05 eh agent convention (sem hook — finding #10).
- **OTel + Langfuse V3:** Traces funcionando. Debug exporter ativo (P0 finding #14).
- **L6 chaos:** BASIC — 4 vetores. Opt-in `CHAOS_MODE=1`.
- **MCP pinning:** 4 MCPs sem pin (P1 finding #16). Review S96.
- Memory governance: cap 20 files (18 atual). Next review: S96.
- **/insights cadence:** last run S91. Next: S96.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — rodar build apos editar _manifest.js.
- **CSS per-slide: `section#s-{id}`** — specificity 0,1,1,1.
- PMIDs de LLM: ~56% erro. SEMPRE verificar.
- **Docker stack:** ports expostos em 0.0.0.0 (P0 — fix pendente). Debug exporter ativo (P0).
- **Langfuse keys:** `.env` no repo root e fonte de verdade.
- **pending-fixes.md:** path canonico = `.claude/pending-fixes.md` (drift documentado, fix pendente).

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S95 2026-04-07
