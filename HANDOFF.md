# HANDOFF - Proxima Sessao

> Sessao 91 | 2026-04-06
> Cross-ref: `BACKLOG.md` | `docs/research/implementation-plan-S82.md`

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Lint clean. Build OK (18 slides metanalise).
**Agentes: 8** (todos com model routing). **Hooks: 19**. **Rules: 10**. MCPs: 11 connected.
**OTel + Langfuse V3: VALIDADO.** 7 containers healthy, env vars loaded, Langfuse 200 OK em :3100.
**Antifragile: L1 DONE, L2 MELHORADO, L3 DONE, L5 DONE, L7 DONE.** L4 implementado, L6 zero.
**/insights S91:** Phase 5 NeoSigma validado. Trend improving (corr 0.4, kbp 0.61). 2 proposals applied.

## PROXIMOS PASSOS

| # | Item | Impacto | Complexidade |
|---|------|---------|--------------|
| 1 | Verificar traces em Langfuse UI (abrir :3100 no browser) | Confirmar telemetria visual | Manual |
| 2 | QA ou slide session — testar enforcement pos-S82 | Validar KBP guards em contexto real | Normal |
| L6 | Chaos engineering deliberado | Testar robustez | Design-only primeiro |

Plano completo: `docs/research/implementation-plan-S82.md`

## AGENTES

| Agente | Model | maxTurns | Memory | Status |
|--------|-------|----------|--------|--------|
| evidence-researcher | sonnet | — | project | OK |
| qa-engineer | sonnet | 12 | project | OK (KBP-05 hard guard added S91) |
| mbe-evaluator | sonnet | 15 | — | OK (FROZEN ate aula completa) |
| reference-checker | haiku | 15 | project | OK |
| quality-gate | haiku | 10 | — | OK |
| researcher | haiku | 15 | — | OK |
| repo-janitor | haiku | 12 | — | OK |
| notion-ops | haiku | 10 | — | OK |

## DECISOES ATIVAS

- **Values: Antifragile + Curiosidade** — decision gates, nao decoracao.
- **Living HTML per slide = source of truth.** evidence-db.md deletado S90, dados em living HTML.
- **CLAUDE.md cascata:** root (85 linhas) → content/aulas/ → metanalise/.
- **Cross-ref: dual gate** — stop hook (advisory) + pre-commit (blocking).
- **Self-healing loop:** stop-detect → pending-fixes → session-start surfacea.
- **Known-bad-patterns (Via Negativa):** 5 KBPs, alimentado por /insights.
- **Failure registry:** `.claude/insights/failure-registry.json` — 5 entries, trend improving.
- **Memory TTL:** review_by + last_challenged + confidence em 17 files. Staggered S89.
- **OTel + Langfuse V3:** Stack validado S89, 7 containers.
- **L1 retry-utils.sh:** exp backoff + jitter em 3 hooks + export-pdf.js.
- **L2 model-fallback:** state tracking + circuit breaker (2 falhas/5min = degraded).
- **MCP pinning:** SEC-004 done. Review quarterly S95.
- Agentes: max 2, Lucas dita, scripts existentes, 1 slide por vez.
- Memory governance: cap 20 files (17 atual). Next review: S92.
- **/insights cadence:** last run S91. Next: S94 ou on-demand.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — rodar build apos editar _manifest.js.
- **CSS per-slide: `section#s-{id}`** — specificity 0,1,1,1.
- PMIDs de LLM: ~56% erro. SEMPRE verificar.
- **Docker stack:** `docker compose up -d` sobe tudo. Se Langfuse falhar healthcheck, verificar que `HOSTNAME: "0.0.0.0"` esta no compose (IPv6 gotcha). Postgres major version incompativel = apagar volume (`down -v`).
- **Langfuse keys:** Windows env vars + `.env` no repo root. Nao committar `.env`.
- **Model failures:** log em `/tmp/cc-model-failures.log` (auto-pruned 1h).
- **/insights noise:** grep por "error"/"fail" em JSONL gera ~90% falso positivo. Filtrar por role:user para correcoes reais.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S91 2026-04-06
