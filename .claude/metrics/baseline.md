# OLMO KPI Baseline — Conductor 2026

> **Status:** v1.0 — S251 P0 first commit (proposed thresholds; Lucas calibration pending — open question #2 do plan)
> **Source-of-truth:** este file. Snapshot diário em `.claude/metrics/snapshots/{YYYY-MM-DD}.tsv` via `scripts/kpi-snapshot.mjs`.
> **Path policy:** `.claude/metrics/` é committed (não-gitignored). `.claude/apl/` permanece gitignored (volátil session-local).
> **Plan reference:** `.claude/plans/immutable-gliding-galaxy.md` §4 (12 braços) + §5-10 (transversais).
> **Anti-vanish:** snapshot diário committed previne loss; archive mensal `.claude/metrics/archive/{YYYY-MM}.tsv` após 90d.

---

## Princípios canonical aplicados (Conductor §2)

- **P1 humildade:** cada KPI tem confidence (high/medium/low) e source explícita
- **P2 evidence-tier:** thresholds T1 (paper/methodology) ou T2 (OLMO history) — T3 inspiração não sustenta KPI
- **P5 anti-teatro:** todo KPI tem (a) measurement script, (b) consumer (snapshot), (c) review cadence
- **P6 E2E:** smoke test por KPI em `scripts/smoke/kpi-{name}.sh` (P1+ deliverable)

---

## ACTIVE — 12 KPIs (1 per braço — P0 mandatory)

| Slug | Braço | Definition | Measurement | Threshold | Cadence | Source | Confidence |
|------|-------|------------|-------------|-----------|---------|--------|------------|
| `agent-memory-coverage` | MEMORY | (agents com material em `.claude/agent-memory/{agent}/` / 16) × 100 | `find .claude/agent-memory -mindepth 2 -name "*.md" \| awk -F/ '{print $3}' \| sort -u \| wc -l` ÷ 16 × 100 | ≥40% (P3) | weekly | Conductor §4.1 + Explore S251 §6 | high (baseline 6.25% confirmed) |
| `knowledge-base-coverage` | KNOWLEDGE | aulas com living HTML evidence + tier-1 sources / total | grep `evidence/.*living` + PMID count em `content/aulas/*/index.html` | ≥80% | monthly | Conductor §4.2 | medium (baseline ~3/19 = 15.8% from QA editorial S250) |
| `research-tier1-ratio` | RESEARCH | (claims com PMID/DOI/arXiv / total claims) per artifact | sample 5 últimos research outputs em `.claude/plans/` ou `content/`; grep `PMID\|DOI\|arXiv` | ≥90% | per-artifact | Conductor §4.3 | medium (baseline não medido — P0 first measurement) |
| `debug-team-pass-first-try` | DEBUG | runs com validator verdict=pass primeira tentativa / total runs | grep `validator_loop_iter=0` em `.claude/plans/debug-*.md` | ≥70% | per-run | Conductor §4.4 | low (baseline 1/1 S250 — n=1 insufficient) |
| `smoke-test-coverage` | BACKEND | (componentes-chave com `scripts/smoke/{name}.sh` / 18 críticos) × 100 | `ls scripts/smoke/*.sh \| wc -l` ÷ 18 × 100 | ≥80% (P3) | weekly | Conductor §4.5 | high (baseline 0% — pasta não existe) |
| `slides-qa-pass-ratio` | FRONTEND | aulas com QA editorial 3/3 gates passed / total aulas | count `qa-editorial-pass.json` em `content/aulas/*/qa-rounds/` | ≥95% per aula | per-aula | Conductor §4.6 + content/aulas/CLAUDE.md | medium (baseline 3/19 = 15.8% S250 APL) |
| `aulas-tier1-evidence-complete` | CONTENT | aulas com PMIDs cross-checked + reference-checker pass / total | ref-checker output JSON em `.claude/plans/qa-*` | ≥80% | monthly | Conductor §4.7 + KBP-30 | medium (baseline ~3/19) |
| `apl-metrics-committed-daily` | PRODUCTIVITY | boolean: `.claude/metrics/snapshots/{today}.tsv` existe? | `test -f .claude/metrics/snapshots/$(date +%F).tsv` | true (≥27/30 days/month) | daily | Conductor §4.8 + §9 | high (P0 deliverable enables this) |
| `kbp-resolved-per-session` | SELF_EVOLVING | KBPs marked RESOLVED em CHANGELOG entry da sessão | grep `RESOLVED` em CHANGELOG.md sessão atual | ≥1 average across 5 sessions | per-session | Conductor §4.9 + KBP catalog | medium (baseline KBP-NN=38; histórico não medido) |
| `mcp-health-uptime` | TOOLING | MCPs core (pubmed, semantic-scholar, crossref, scite, biomcp) responsivas em smoke check | `scripts/smoke/mcp-health.sh` (P2 deliverable) | ≥99% weekly | weekly | Conductor §4.10 | low (baseline não medido — P2 enables) |
| `cross-model-invocations-week` | ORQUESTRACAO | invocations Gemini OR Codex OR Ollama em commits/plans/ últimas 7d | grep `gemini-research\|codex exec\|ollama` em CHANGELOG.md últimas 7d | ≥3 | weekly | Conductor §4.11 + ADR-0003 | high (S248-S250 baseline ~2/sem) |
| `r3-questoes-acertadas-simulado` | CUSTOM | percentual acerto último simulado R3 Clínica Médica | manual entry em `content/concurso/error-log.md` | ≥75% | per-simulado | Conductor §4.12 + HANDOFF R3 prep | low (baseline não medido — Lucas annota) |

---

## DEFERRED (P1+) — 12 transversais (estrutura definida; collection após P0 baseline stable)

| Slug | Layer | Definition | Phase activation |
|------|-------|------------|------------------|
| `automation-layer-uptime` | AUTOMATION_LEAN | hooks fire success rate (sem stderr non-zero) | P1 (após KPI snapshot wired) |
| `daily-routines-executed` | AUTOMATION_LEAN | número de routines completed/day | P2 (após sota-intake skill) |
| `council-decision-traceability` | COUNCIL §6 | decisões com ≥3 voices outputs persisted | P3 (após council/SKILL.md) |
| `digest-published-daily` | SOTA §7 | boolean: `.claude/digests/sota-{today}.md` existe? | P2 (após sota-intake) |
| `digest-items-tier1-2-only` | SOTA §7 | percentual items com source URL T1/T2 | P2 |
| `digest-actionable-items-week` | SOTA §7 | items com OLMO relevance high/med por semana | P2 |
| `cross-tool-coverage` | CROSS-MODEL §8 | tools com gov-doc / tools usados | P2 (após CODEX.md) |
| `kpi-snapshot-uptime` | KPI-META §9 | days com snapshot committed / total days month | P1 (após cron wired) |
| `kpi-baseline-defined-per-arm` | KPI-META §9 | 12/12 active baseline (este file) | DONE P0 (= 12/12 desde commit deste file) |
| `notion-items-harvested` | NOTION §10 | boolean: `.claude-tmp/notion-export/` populated | P0 (Lucas action — pending) |
| `notion-items-migrated` | NOTION §10 | items movidos para OLMO post-triage / total harvested | P4 |
| `notion-active-pages-post-offboard` | NOTION §10 | percentual Notion pages ainda ativas vs baseline | P4 |

---

## Snapshot file format (TSV — `scripts/kpi-snapshot.mjs` consumer)

```
date	slug	value	threshold	pass	source_command	confidence
2026-04-25	agent-memory-coverage	6.25	40	false	find...wc-l	high
2026-04-25	smoke-test-coverage	0	80	false	ls...wc-l	high
...
```

**Headers fixed:** `date | slug | value | threshold | pass | source_command | confidence`. TSV (tab-separated) pra parse robusto.

**`pass` derivation:** `value >= threshold` for percent/count KPIs; boolean KPIs use `true`/`false` literal.

---

## Calibration log (Lucas thresholds confirm/edit)

| KPI | Proposed threshold | Lucas confirms? | Lucas edited to | Date |
|-----|--------------------|-----------------|-----------------|------|
| `agent-memory-coverage` | ≥40% (P3) | ✓ confirmed | — | 2026-04-25 |
| `knowledge-base-coverage` | ≥80% | ✓ confirmed | — | 2026-04-25 |
| `research-tier1-ratio` | ≥90% per artifact | ✓ confirmed | — | 2026-04-25 |
| `debug-team-pass-first-try` | ≥70% | ✓ confirmed (low conf — re-eval c/ n≥5 runs S257) | — | 2026-04-25 |
| `smoke-test-coverage` | ≥80% (P3) | ✓ confirmed | — | 2026-04-25 |
| `slides-qa-pass-ratio` | ≥95% per aula | ✓ confirmed | — | 2026-04-25 |
| `aulas-tier1-evidence-complete` | ≥80% | ✓ confirmed | — | 2026-04-25 |
| `apl-metrics-committed-daily` | true (≥27/30 days/month) | ✓ confirmed | — | 2026-04-25 |
| `kbp-resolved-per-session` | ≥1 avg/5 sessions | ✓ confirmed | — | 2026-04-25 |
| `mcp-health-uptime` | ≥99% weekly | ✓ confirmed (low conf — measurement P2 enables) | — | 2026-04-25 |
| `cross-model-invocations-week` | ≥3/week | ✓ confirmed | — | 2026-04-25 |
| `r3-questoes-acertadas-simulado` | ≥75% | ✓ confirmed (low conf — Lucas manual annota) | — | 2026-04-25 |

**Status:** 12/12 confirmed S252 (Lucas AskUserQuestion 2026-04-25). 3 KPIs flagged low-confidence persistem com threshold proposed; future re-calibration trigger = baseline data accumulate (n≥5 runs).

**Action histórica:** Lucas confirmou tabela ACTIVE como-está em S252 P0 calibration phase. Snapshots daily (`scripts/kpi-snapshot.mjs`) podem rodar against thresholds confirmed.

---

## Open questions (referenced from plan §14)

1. ~~**Threshold calibration:** Lucas confirma thresholds proposed acima ou edita?~~ **RESOLVED S252** — Lucas confirmou todos 12 defaults (AskUserQuestion 2026-04-25). §Calibration log preenchido.
2. **R3 simulado entry mechanism:** manual em `content/concurso/error-log.md` OU skill dedicada `simulado-tracker`?
3. **debug-team baseline n=1:** spawn 4+ runs sintéticos pra significância OU aguardar runs orgânicas (estimativa S252-S255)?

---

## Smoke test (P1 deliverable referenced)

Future: `scripts/smoke/kpi-baseline.sh` verifica:
- `.claude/metrics/baseline.md` exists
- Parses 12 ACTIVE KPIs
- Each has: slug, definition, measurement, threshold, cadence, source, confidence
- Each measurement command is executable (dry-run)

Exit 0 = pass.
