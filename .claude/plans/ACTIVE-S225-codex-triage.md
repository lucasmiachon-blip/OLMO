# ACTIVE-S225 — Codex Hooks Triage

> **Status: ACTIVE-S225** (ready for execution in S225)
> Origem: `BACKLOG-S220-codex-adversarial-report.md` Batch 1 (9 issues deferidas desde S220)
> Criado: S224 iter 10.5 (2026-04-17) | Target execution: S225

## Context

S220 Codex adversarial review flagged 10 hook issues. S220 scoped APENAS Issue #5 (metrics race). S221-S224 nao endereçaram os 9 restantes — technical debt visivel. S225 close-out com triage estruturada.

## Triage (9 issues remanescentes)

| # | Sev | Verdict | Priority | Effort | Rationale |
|---|-----|---------|----------|--------|-----------|
| 1 | HIGH | **FIX** | P1 | 30min | guard-bash-write.sh matcher gaps (mkdir/tee/sed/python/curl-o bypass). Exploitable. |
| 2 | HIGH | **FIX** | P1 | 15min | guard-lint-before-build.sh so hooka `npm run build*`; expand para vite/powershell. |
| 3 | HIGH | **FIX** | P2 | 45-60min | momentum-brake blanket Bash exemption. Remove blanket, exempt only read-only. Architectural — testar enforcement semantic. |
| 4 | HIGH | **FIX** | P2 | 20min | `/tmp/cc-session-id.txt` shared state: namespace por repo-hash + PID. |
| 5 | HIGH | **VERIFY** | P0 | 10min | Metrics race — S220 Part D claimed fix. Ler stop-metrics.sh atual + testar 2 overlapping Stops. |
| 6 | HIGH | **INVESTIGATE (likely obsolete)** | P1 | 10min | PostToolUseFailure event: hook-log.jsonl mostra 15+ entries — README pode estar outdated, nao codigo. Reclassificar como false-positive se confirmado. |
| 7 | MED | **FIX** | P1 | 5min | `INPUT=$(cat \|\| echo '{}')` defensive fallback em post-tool-use-failure.sh. Trivial. |
| 8 | MED | **FIX** | P2 | 15min | pre-compact-checkpoint.sh silent write errors — emit explicit warning. |
| 9 | MED | **LUCAS-DECIDE** | P3 | 5min | Stop[0] KBP-22 threshold 3+ vs 1+ (tradeoff: false positives vs silent misses). |
| 10 | MED | **FIX** | P1 | 10min | nudge-checkpoint.sh `/tmp` counters nunca clear — add explicit reset em session-start.sh. |

**Sumario:** 7 FIX imediatos + 1 FIX (Lucas decide) + 2 INVESTIGATE/VERIFY. Zero WONTFIX.

## Execution order S225

### Phase 1 — Verify first (P0, 10min)
- **Issue #5 metrics race:** ler `hooks/stop-metrics.sh` atual, verificar se flock ou sync foi adicionado; teste overlapping-Stops com 2 turns rapidos. Se ainda race, elevar a FIX P1.

### Phase 2 — Quick wins (P1, 40-65min)
- Issue #7 (5min): cat defensive fallback
- Issue #10 (10min): counters clear no session-start
- Issue #2 (15min): lint matcher expand
- Issue #6 (10min investigate): PostToolUseFailure evidence check — likely obsolete
- Issue #1 (30min): guard-bash-write matcher expand

### Phase 3 — Architectural (P2, 80-95min)
- Issue #3 (45-60min): momentum-brake Bash exemption fix — **testar careful, enforcement semantic**
- Issue #4 (20min): session-id namespacing por repo+PID
- Issue #8 (15min): checkpoint write error visibility

### Phase 4 — Lucas decision (P3, 5min)
- Issue #9: threshold 3+ vs 1+ tradeoff discussion

**Total estimado:** 2.5-3h focused S225 work (excl. Issue #9 wait).

## Verification framework

Cada fix requer:
- **Test pre-fix:** comando que demonstra o gap (guard atual NAO bloqueia)
- **Diff:** linhas exatas alteradas
- **Test pos-fix:** mesmo comando agora bloqueia/captura
- **Commit msg:** referencia "Codex Batch 1 Issue #X" + link ao BACKLOG

## Success definition

S225 plan succeeds when:
- 7 FIX issues committed (+1 se Lucas decide #9)
- 2 VERIFY/INVESTIGATE issues resolvidos com evidencia
- HANDOFF S226 START HERE reflete estado final (zero Codex hooks pendente OR explicit defer reason)

## References

- **BACKLOG source:** `BACKLOG-S220-codex-adversarial-report.md` Batch 1 L8-23
- **Related S224:** commit 3bb9591 (DEAD-REFs CLAUDE.md fix — Codex Batch 4 Issue #1+#2 addressed)

---
Coautoria: Lucas + Opus 4.7 | S224 triage document para S225 execution | 2026-04-17
