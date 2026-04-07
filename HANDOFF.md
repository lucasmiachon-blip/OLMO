# HANDOFF - Proxima Sessao

> Sessao 93 | 2026-04-06
> Cross-ref: `BACKLOG.md` | `docs/research/implementation-plan-S82.md`

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Lint clean. Build OK (18 slides metanalise).
**Agentes: 8** (todos com model routing). **Hooks: 22** (20 CC + 2 chaos). **Rules: 10**. MCPs: 11 connected.
**OTel + Langfuse V3: TRACES FUNCIONANDO.** 7 containers healthy, pipeline validado visualmente em :3100.
**Antifragile: L1 DONE, L2 MELHORADO, L3 DONE, L4 DONE, L5 DONE, L6 BASIC (4 vetores), L7 DONE.**
**/insights S91:** Phase 5 NeoSigma validado. Trend improving (corr 0.4, kbp 0.61). 2 proposals applied.

## PROXIMOS PASSOS

| # | Item | Impacto | Complexidade |
|---|------|---------|--------------|
| 1 | QA ou slide session — testar enforcement pos-S82 | Validar KBP guards em contexto real | Normal |
| 2 | L6 Phase B — vetores 5-6 (slide desync, stale memory) | Completar cobertura chaos | Normal |
| 3 | ClickHouse `events_core` migration — dashboard scores/models | Langfuse Fast Preview | Baixa prioridade |
| 4 | L6 chaos gameday — session com CHAOS_MODE=1 ativo | Validar defesas em producao | Normal |

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
- **Memory TTL:** review_by + last_challenged + confidence em 18 files. Staggered S89. Governance review S93: 3 files refreshed, no merges.
- **OTel + Langfuse V3:** Traces validados visualmente S92. Pipeline: CC→gRPC:4317→OTel Collector→Langfuse.
- **L1 retry-utils.sh:** exp backoff + jitter em 3 hooks + export-pdf.js.
- **L2 model-fallback:** state tracking + circuit breaker (2 falhas/5min = degraded).
- **L6 chaos engineering:** BASIC — chaos-inject lib + PostToolUse + Stop report. 4 vetores (429, timeout, model_unavail, rapid_calls). Opt-in `CHAOS_MODE=1`. Design doc: `docs/research/chaos-engineering-L6.md`.
- **MCP pinning:** SEC-004 done. Review quarterly S95.
- Agentes: max 2, Lucas dita, scripts existentes, 1 slide por vez.
- Memory governance: cap 20 files (18 atual). Next review: S95.
- **/insights cadence:** last run S91. Next: S94 ou on-demand.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — rodar build apos editar _manifest.js.
- **CSS per-slide: `section#s-{id}`** — specificity 0,1,1,1.
- PMIDs de LLM: ~56% erro. SEMPRE verificar.
- **Docker stack:** `docker compose up -d` sobe tudo. Se Langfuse falhar healthcheck, verificar que `HOSTNAME: "0.0.0.0"` esta no compose (IPv6 gotcha). Postgres major version incompativel = apagar volume (`down -v`).
- **Langfuse keys:** `.env` no repo root e fonte de verdade (nao Windows env vars). Nao committar `.env`. Se keys mudarem no Langfuse UI, atualizar `.env` + `LANGFUSE_AUTH_HEADER` (base64 de pk:sk).
- **Docker Compose env precedence:** Windows env vars sobrescrevem `.env` file. OTel collector usa `env_file:` para evitar isso. NUNCA usar `environment: ${VAR}` para secrets que tambem existem no Windows env.
- **ClickHouse `events_core`:** Tabela faltando — dashboard Fast Preview mostra erro. Traces funcionam. Desligar toggle "Fast Preview" ou resetar volume do ClickHouse para fix.
- **Model failures:** log em `/tmp/cc-model-failures.log` (auto-pruned 1h).
- **/insights noise:** grep por "error"/"fail" em JSONL gera ~90% falso positivo. Filtrar por role:user para correcoes reais.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | S93 2026-04-06
