# HANDOFF - Proxima Sessao

> Sessao 87 | 2026-04-06
> Cross-ref: `BACKLOG.md` | `docs/research/implementation-plan-S82.md`

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Lint clean. Build OK (18 slides metanalise).
**Agentes: 8** (todos com model routing). **Hooks: 19** (+model-fallback-advisory S86). **Rules: 10**. MCPs: 11 connected.
S87: OTel+Langfuse Docker stack, SEC-004 version pinning, memory stale update.

## PROXIMOS PASSOS

| # | Item | Impacto | Complexidade |
|---|------|---------|--------------|
| 2A+ | OTel ativacao — `docker compose up`, criar projeto Langfuse, testar telemetria | Validar stack end-to-end | Hands-on, requer `.env` |
| 3A+ | NeoSigma constrained optimization — test cycle | Validar /insights Phase 5 | Rodar /insights e verificar |
| L1 | Retry com jitter em scripts | Resiliencia transiente | Auditar scripts com retry |
| L2+ | Model fallback auto-downgrade (nao so advisory) | Resiliencia automatica | Medium |
| L6 | Chaos engineering deliberado | Testar robustez | Design-only primeiro |

Plano completo: `docs/research/implementation-plan-S82.md`

## AGENTES

| Agente | Model | maxTurns | Memory | Status |
|--------|-------|----------|--------|--------|
| evidence-researcher | sonnet | — | project | OK |
| qa-engineer | sonnet | 12 | project | OK |
| mbe-evaluator | sonnet | 15 | — | OK (FROZEN ate aula completa) |
| reference-checker | haiku | 15 | project | OK |
| quality-gate | haiku | 10 | — | OK |
| researcher | haiku | 15 | — | OK |
| repo-janitor | haiku | 12 | — | OK |
| notion-ops | haiku | 10 | — | OK |

## DECISOES ATIVAS

- **Values: Antifragile + Curiosidade** — decision gates, nao decoracao.
- **Living HTML per slide = source of truth.** evidence-db.md deprecated.
- **CLAUDE.md cascata:** root (85 linhas) → content/aulas/ → metanalise/.
- **Cross-ref: dual gate** — stop hook (advisory) + pre-commit (blocking).
- **Self-healing loop:** stop-detect → pending-fixes → session-start surfacea.
- **Known-bad-patterns (Via Negativa):** 5 KBPs, alimentado por /insights.
- **Failure registry:** `.claude/insights/failure-registry.json` — constrained optimization.
- **Memory TTL:** review_by + last_challenged + confidence em todos 17 files. /dream checa.
- **OTel + Langfuse:** Docker stack pronto, ativar com `docker compose up -d` + `.env`.
- **MCP pinning:** SEC-004 done. Review quarterly S95.
- Agentes: max 2, Lucas dita, scripts existentes, 1 slide por vez.
- Memory governance: cap 20 files (17 atual). Next review: S89.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — rodar build apos editar _manifest.js.
- **CSS per-slide: `section#s-{id}`** — specificity 0,1,1,1.
- PMIDs de LLM: ~56% erro. SEMPRE verificar.
- **Langfuse:** apos `docker compose up`, criar projeto no UI (:3100), gerar API keys, setar `LANGFUSE_AUTH_HEADER` em `.env`.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S87 2026-04-06
