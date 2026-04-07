# HANDOFF - Proxima Sessao

> Sessao 97 | 2026-04-07
> Cross-ref: `BACKLOG.md` | `.claude/plans/twinkling-dancing-hamming.md`

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Build OK (19 slides metanalise).
**Agentes: 8** (todos com maxTurns). **Hooks: 25 registrations** (27 scripts; 2 pre-commit). **Rules: 10**. MCPs: 11.
**OTel + Langfuse V3: TRACES FUNCIONANDO.** Docker stack hardened (127.0.0.1, fail-fast secrets, debug removed from traces/metrics).
**Antifragile: L1-L5 DONE, L6 BASIC (4 vetores), L7 DONE.**
**APL: LIVE.** 3 hooks.
**QA pipeline S97:** Path linear 11 steps. Regra 30 palavras removida. Preflight visual com 4 dims + loop Lucas antes de Gemini.
**s-objetivos:** Editorial rodou (2.8/10). Sugestoes em `qa-screenshots/s-objetivos/editorial-suggestions.md`. Fixes pendentes (CSS+HTML+Motion).

## PROXIMOS PASSOS

| # | Item | Impacto | Complexidade |
|---|------|---------|--------------|
| 1 | Implementar fixes s-objetivos (CSS visual + HTML wrapper + stagger) | QA slide | Normal |
| 2 | Testar Docker stack apos hardening (`docker compose up -d`) | Validar Redis auth, OTel pin | Facil |
| 3 | /insights (last run S91 — 6 sessoes atras) | Self-improvement | Normal |
| 4 | Memory governance review (18/20 files) | Housekeeping | Facil |
| 5 | notion-ops: adicionar write tools + gates (finding #5) | Baixa prioridade | Facil |
| 6 | Re-rodar Codex Batches 1+4 (hooks shell + JS scripts) | Cobertura adversarial | Normal |

## AGENTES

| Agente | Model | maxTurns | Memory | Status |
|--------|-------|----------|--------|--------|
| evidence-researcher | sonnet | 20 | project | OK |
| qa-engineer | sonnet | 12 | project | **S97: Preflight reescrito (4 dims, pre-gate, pos-check, loop Lucas)** |
| mbe-evaluator | sonnet | 15 | — | OK (FROZEN ate aula completa) |
| reference-checker | haiku | 15 | project | OK |
| quality-gate | haiku | 10 | — | OK |
| researcher | haiku | 15 | — | OK |
| repo-janitor | haiku | 12 | — | OK |
| notion-ops | haiku | 10 | — | **P1: adicionar write tools + gates** |

## DECISOES ATIVAS

- **QA pipeline S97:** Path linear 11 steps (`qa-pipeline.md` §1). Opus visual QA com 4 dims documentadas (Cor, Tipografia, Hierarquia, Design) + fontes cross-ref. Loop Lucas (steps 6-7) antes de Gemini. Regra 30 palavras REMOVIDA (8 pontos, 7 arquivos).
- **Values: Antifragile + Curiosidade** — decision gates, nao decoracao.
- **APL:** 3 hooks passivos. Cache em `.claude/apl/`.
- **Living HTML per slide = source of truth.**
- **CLAUDE.md cascata:** root → content/aulas/ → metanalise/.
- **Cross-ref: dual gate** — stop hook (advisory) + pre-commit (blocking).
- **Self-healing loop:** stop-detect → `.claude/pending-fixes.md` → session-start surfacea.
- **Known-bad-patterns:** 5 KBPs. KBP-05 = agent convention (sem hook, maxTurns backstop).
- **OTel + Langfuse V3:** Traces OK. Logs = langfuse + debug.
- **L6 chaos:** BASIC — 4 vetores. Opt-in `CHAOS_MODE=1`.
- **Codex findings skipped:** #16 MCP pins, #22 MinIO endpoint, #5 notion-ops (pendente).
- Memory governance: cap 20 files (18 atual). Next review: S97+.
- **/insights cadence:** last run S91. Next: S97+.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — rodar build apos editar _manifest.js.
- **CSS per-slide: `section#s-{id}`** — specificity 0,1,1,1.
- PMIDs de LLM: ~56% erro. SEMPRE verificar.
- **Docker stack:** Secrets em `.env`. Ports em 127.0.0.1. OTel pinado 0.149.0.
- **QA visual:** Seguir path linear. NUNCA fabricar criterios. Ler docs antes de avaliar (KBP-04).

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S97 2026-04-07
