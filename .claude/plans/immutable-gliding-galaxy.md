# Conductor 2026 — Arquitetura OLMO em 12 braços + AUTOMATION_LEAN_LAYER

> **Status:** PROPOSTA Phase 4 (S251) — pendente aprovação Lucas via ExitPlanMode
> **Inspiração visual:** chase.h.ai "the conductor" (tier-3, screenshot WhatsApp 2026-04-25)
> **Scope:** consumer-only AI agent system (medical education + concurso R3 + research EBM)
> **Não-destrutivo:** este plano DEFINE taxonomia + KPIs + gates. Não reorganiza pastas, não move arquivos, não deleta nada. P0 é audit + baseline; mudanças estruturais ficam em P2+ com aprovação separada.

---

## 1. Context (problem statement)

OLMO acumulou 16 agents + 19 skills + 32 hooks + 6 ADRs sem mapa unificado por dimensão cognitiva. Lucas declarou (S251 abertura):

- **Redundância:** janitor skill ↔ repo-janitor agent; systematic-debugging ↔ debug-team (audit S250 X1/H4)
- **Teatro sem E2E:** componentes sem trigger objetivo + artefato + consumer (lições S232 v6 — workflows.yaml 0 invocations purgado)
- **Métricas vanish:** `.claude/apl/*.tsv` é gitignored (`.gitkeep` único committed); zero KPI baseline persistente; HANDOFF/CHANGELOG são prose
- **Sycophancy + LLM biases:** sem práticas defensivas formalizadas (debug-adversarial só em debug, não cross-cutting)
- **Build-and-break:** features criadas quebram depois; sem smoke test reprodutível + sem regression guard
- **Zero-WHY docs:** componentes documentam WHAT, não WHY (problem solved + evidence)
- **Notion dependência externa:** ideias úteis lá; abandonar sem harvest = perda informacional silenciosa
- **Gemini/Codex subutilizados:** ADR-0003 triggers minimalistas funcionam mas não exploitam SOTA (Codex Architect role 85% pass-rate Aider 2024; Gemini 1M context one-shot)
- **Sem daily SOTA intake:** zero feed externo, zero schedule cron, zero skill daily-digest (Explore agent confirmou)
- **Cross-model docs parciais:** AGENTS.md + GEMINI.md existem; CODEX.md gap; CLAUDE.md 80/84 li Claude-specific

**Outcome desejado:** mapa coerente por dimensão cognitiva + KPIs persistentes committed + gates anti-bias/anti-teatro + loops daily de melhora baseados em evidência. Tornar OLMO o melhor projeto AI/LLMOps medicina solo, embebido em valores (clínica EBM, reumato/hepato, educação teoria+prática, dev AI/ML/LLMOps continuous, gestão aplicada, humanidades).

---

## 2. Princípios canonical (6 gates universais — toda decisão passa por TODOS)

| # | Princípio | Aplicação |
|---|-----------|-----------|
| **P1** | **Humildade epistêmica** | "Não sei" é output legítimo. Confidence: high/medium/low explicit per claim. Sem confidence = rejeitar |
| **P2** | **Evidence-tier T1/T2/T3** | T1: papers peer-reviewed, Anthropic/Google/OpenAI docs oficiais, ADRs OLMO. T2: OSS repos maintained (>1k stars + commits ≤90d), benchmarks reproduzíveis. T3: demos creators (Instagram/X) = inspiração-pra-investigar, NUNCA evidência adoção |
| **P3** | **Anti-sycophancy** | Adversarial role mandatory ≥medium-stakes (ref: Sharma et al. 2023 arXiv:2310.13548). Independent voices sem cross-contamination. Pre-registered hypothesis. Disagreement persistence (não recua sem nova evidência). Source citation enforced (KBP-36) |
| **P4** | **Profissionalismo KBP-37** | Ler docs antes de Edit. Grep granular antes de claims. EC loop antes de cada Edit/Write. Verification command output lido completo. "Sempre profissional, sem atalhos" |
| **P5** | **Anti-teatro** | Cada componente: (a) trigger objetivo declarado, (b) artefato concreto produzido, (c) consumer real downstream. Sem 3-of-3 = NÃO entra ou é purgado. Lições S232 v6 |
| **P6** | **E2E reproducibility + WHY-first docs** | Cada agent/skill/hook header obrigatório: `WHAT` (1-line) · `WHY` (problem + evidence T1/T2) · `HOW` (1-line architecture) · `VERIFY` (path smoke test reprodutível). Sem 4-of-4 = backlog purge candidate |

---

## 3. Anti-padrões a destruir (6 — espelham os princípios)

1. **Redundância:** dois componentes mesma função (X1: janitor↔repo-janitor; H4: systematic-debugging↔debug-team)
2. **Teatro sem E2E:** trigger ausente OU artefato vazio OU consumer inexistente
3. **Métricas vanish:** logs gitignored ou prose-only (sem números estruturados committed)
4. **Sycophancy/biases LLM:** confirmação acrítica, recency bias, authority bias, overconfidence
5. **Build-and-break:** componente sem smoke test reprodutível + sem regression guard CI
6. **Zero-WHY:** documentação WHAT-only (código bem-nomeado já mostra WHAT — comentário/header só vale se documenta WHY)

---

## 4. Os 12 braços (MECE) — definição + OLMO atual + gaps + KPI

> **Convenção:** `evidence:` cita Glob/Grep path ou ADR — confidence high baseado em Explore agent S251 (a4633f3a5a2769838).

### 4.1. MEMORY (estado mutável persistente cross-session)
- **Define:** stateful continuity — Lucas/agent state que sobrevive sessões
- **OLMO atual:** files (`HANDOFF.md`, `CHANGELOG.md`, `BACKLOG.md`, `.claude/memory/*`, `.claude/agent-memory/{agent}/`); hooks (`session-compact.sh`, `pre-compact-checkpoint.sh`, `post-compact-reread.sh`); plugins (`dream`, `wiki-lint`, `wiki-query`)
- **Gaps:** apenas 1 agent material em `.claude/agent-memory/` (evidence-researcher); demais subpastas vazias ou inexistentes — `evidence: Explore S251 §6`
- **KPI alvo:** `agent-memory-coverage = (agents com material/16) × 100`. Baseline 1/16 = 6.25%. Threshold ≥40% (≥7/16) em P3
- **Source/evidence:** ADR-0006 (deny-list); CLAUDE.md §Memory Governance (T1)

### 4.2. KNOWLEDGE (base curada read-mostly + epistemic store)
- **Define:** conhecimento estruturado externalizável — distinto de MEMORY (mutável) por ser curated/canonical
- **OLMO atual:** files (`docs/`, `content/aulas/`, `content/concurso/`, ADRs); skills (`evidence-audit`, `teaching`, `continuous-learning`, `nlm-skill`, `knowledge-ingest`)
- **Gaps:** sem doc canônico "Notion vs OLMO" mapping (Explore §4); knowledge-ingest produz nota Obsidian mas integração com `.claude/memory/wiki/` não documentada
- **KPI alvo:** `knowledge-base-coverage` = aulas com living HTML evidence + tier-1 sources / total. Baseline ~3/19 (QA editorial). Threshold ≥80%
- **Source/evidence:** S250 audit identificou redundância potencial knowledge-ingest ↔ research; ADR-0002 external-inbox

### 4.3. RESEARCH (ato de buscar — query-driven external)
- **Define:** investigação ativa de literatura/codebase/evidências externas
- **OLMO atual:** agents (`evidence-researcher`, `mbe-evaluator`, `reference-checker`, `researcher`); skill `research` (v2.0 pipeline 6 pernas: Gemini, Perplexity, evidence-researcher subagent, NLM, SCite, Consensus); MCPs (pubmed, crossref, semantic-scholar, scite, biomcp, web-search/fetch)
- **Gaps:** research/SKILL.md não tem KPI de "queries with tier-1 source ratio"; sem benchmark de coverage cross-MCP
- **KPI alvo:** `research-tier1-ratio` = (claims com PMID/DOI/arXiv / total claims) ≥90% per artifact
- **Source/evidence:** Explore §1 confirmou skill purpose; ADR-0003 multimodel

### 4.4. DEBUG (diagnose ativo — reativo a problemas)
- **Define:** root-cause structured de bugs/erros/regressions
- **OLMO atual:** agents (7 debug-* + systematic-debugger); skills (`debug-team`, `systematic-debugging`); hooks (`post-tool-use-failure.sh`, `stop-failure-log.sh`)
- **Gaps:** REDUNDÂNCIA H4 — `systematic-debugging` skill standalone vs `debug-team` (S250 audit 3/3 ADOPT-NEXT); P1 deste plan resolve
- **KPI alvo:** `debug-team-validator-pass-first-try-ratio` ≥70% (S250 e2e: 1/1 = 100% baseline mas 1 sample). 5+ runs needed pra significância
- **Source/evidence:** `.claude/skills/debug-team/SKILL.md` (T1); audit-merge-S251.md (T1 OLMO)

### 4.5. BACKEND (lógica computacional — scripts + automação backend)
- **Define:** código que computa (Python minimal + bash hooks lógicos)
- **OLMO atual:** files (`scripts/fetch_medical.py`, `content/aulas/scripts/*.mjs`); tooling (`make lint/format/type-check`, ruff, mypy); skill `automation` (parte cron/pipeline)
- **Gaps:** `scripts/smoke/` ausente — nenhum smoke test reprodutível por componente (P6 violação cross-cutting); CI invariants minimal
- **KPI alvo:** `smoke-test-coverage` = (componentes com smoke / total ≥18 componentes-chave) ≥80%
- **Source/evidence:** ARCHITECTURE.md §Runtime post-S232 (T1 OLMO)

### 4.6. FRONTEND (apresentação visual + UX — slides aulas + statusline)
- **Define:** output visual user-facing
- **OLMO atual:** files (`content/aulas/*` HTML/CSS/JS); plugins (`frontend-design`, `chrome-devtools-mcp`); skill `teaching` (parte slideologia); tools (lint-slides, lint-case-sync, validate-css)
- **Gaps:** zero output-styles configurados em `.claude/output-styles/` (Explore §6 confirmou pasta inexistente) — current session usa "explanatory" mode mas via system message inline
- **KPI alvo:** `slides-qa-pass-ratio` ≥95% per aula (3 gates: preflight, inspect, editorial)
- **Source/evidence:** `content/aulas/CLAUDE.md` (T1 OLMO); QA editorial S250 = 3/19 = 15.8% baseline

### 4.7. CONTENT (produção de conteúdo educacional — output-bound)
- **Define:** artefatos finais consumidos por aluno/médico/Lucas
- **OLMO atual:** skills (`teaching`, `exam-generator`, `qa-engineer`, `nlm-skill`); agents (`qa-engineer`); files (`content/aulas/`, `content/concurso/`)
- **Gaps:** sem editorial calendar persistente; sem KPI "aulas com slide count estável" (S232 v6 KBP-30 indicou drift)
- **KPI alvo:** `aulas-com-evidencia-tier1-completa` (PMIDs cross-checked) ≥80% (atual 3/19)
- **Source/evidence:** content/aulas/CLAUDE.md; KBP-30 (T1 OLMO)

### 4.8. PRODUCTIVITY (workflow daily — planning, scheduling, brainstorm)
- **Define:** assistência ao fluxo de trabalho ativo
- **OLMO atual:** skills (`backlog`, `insights`, `brainstorming`, `automation`, `schedule`); hooks (`ambient-pulse.sh` APL, `nudge-checkpoint.sh`, `nudge-commit.sh`, `momentum-brake-*.sh`); plugins (`schedule`, `loop`, `ralph-loop`)
- **Gaps:** APL escreve em `.claude/apl/*.tsv` que é gitignored — métricas vanish (Explore §2 confirmou); insights skill /insights pendente 6d
- **KPI alvo:** `apl-metrics-committed` (path canonical em `.claude/metrics/apl-snapshot-{date}.tsv` daily) — boolean: existe arquivo dia atual?
- **Source/evidence:** Explore §2 (T1 OLMO)

### 4.9. SELF_EVOLVING / ANTIFRAGILE (feedback loops + resiliência — proactive)
- **Define:** pattern→prevent loops; melhora contínua sistêmica; resiliência a falhas (Taleb L1-L7)
- **OLMO atual:** skills (`improve`, `insights`, `dream`, `wiki-lint`); agents (`sentinel`, `repo-janitor`); hooks (`stop-quality.sh`, `model-fallback-advisory.sh`, `chaos-inject-post.sh`); files (`known-bad-patterns.md` KBP catalog, `anti-drift.md`, `pending-fixes.md`); ADR-0007 antifragile posture
- **Gaps:** L3 Cost Circuit Breaker = NOT IMPLEMENTED; L6 Chaos = BASIC (Explore §5); X3 hook ordering race (S250 audit ADOPT-NEXT)
- **KPI alvo:** `kbp-resolved-per-session` ≥1 average (KBP catalog tem 38 itens — `KBP-NN` count); `pending-fixes-zero-stale` (idade max ≤7d)
- **Source/evidence:** ARCHITECTURE.md §Antifragile Stack (T1 OLMO)

### 4.10. TOOLING / ECOSYSTEM (integrations external — MCPs, CLIs, plugins)
- **Define:** adaptors externos + plugin ecosystem
- **OLMO atual:** files (`config/mcp/servers.json`, `.claude/settings.json`); plugins (`codex`, `chrome-devtools-mcp`, `code-review`, `security-review`, `ralph-loop`, `frontend-design`); skill `skill-creator`
- **Gaps:** zero skill marketplaces externos instalados (antigravity-awesome-skills 24k stars T2 não avaliado; vercel-labs/skills T2 não avaliado); sem tracking de plugin update cadence
- **KPI alvo:** `mcp-health-uptime` ≥99% (semantic-scholar, pubmed verified weekly via smoke test); `plugin-update-lag` ≤30d
- **Source/evidence:** Explore §6 (T1 OLMO)

### 4.11. ORQUESTRACAO_MULTI_MODEL (routing decisions cross-model + council)
- **Define:** quando + qual modelo + como invocar (Claude/Codex/Gemini/Ollama/etc)
- **OLMO atual:** ADR-0003 canonical; skills (`research` 6 pernas, `debug-team` Architect role); plans (`audit-merge-S251.md` 3-model methodology); plugins (`codex`, `gemini-research.mjs`)
- **Gaps:** Codex quebrado em S249 (gpt-5.5 upgrade pending); ADR-0003 triggers minimalistas — sem rotina diária; council pattern dispersos (debug-team + audit-S251 + research-6-pernas) sem framework unificado
- **KPI alvo:** `cross-model-invocations-per-week` ≥3 (Gemini ou Codex ou Ollama) — baseline S248-S250 ~2/sem
- **Source/evidence:** ADR-0003 (T1); Explore §9 (T1 OLMO)

### 4.12. CUSTOM (domínio-específico Lucas — concurso, reumato, hepato/gastro, humanidades)
- **Define:** Lucas-specific moat — não-comoditizável
- **OLMO atual:** skills (`concurso`, `exam-generator`, `evidence`); files (`content/concurso/`, `content/aulas/{cardio,hepato,gastro,etc}`); plugin `evidence`
- **Gaps:** humanidades (filosofia/etimologia/línguas/história) zero representação em skill/agent — só CLAUDE.md user pref menciona "etimologia, filosofia"; reumatologia sem skill dedicada apesar de ser foco profissional
- **KPI alvo:** `r3-questoes-acertadas-simulado` ≥75% (concurso dez/2026 baseline atual); `humanidades-citacoes-per-aula` ≥1 (etimologia/história/filosofia conexão genuína)
- **Source/evidence:** CLAUDE.md User Pref (T1); HANDOFF.md R3 prep (T1 OLMO)

---

## 5. AUTOMATION_LEAN_LAYER (transversal — corta TODOS os 12 braços)

- **Define:** schedule/cron/triggers/routines que ativam componentes dos braços. Lean = mínimo essencial, sem overhead.
- **OLMO atual:** 32 hooks (`.claude/hooks/` 17 + `hooks/` 15); plugins (`schedule` cron remote agents, `loop` interval, `ralph-loop` continuous, `ambient-pulse` APL); files (`.claude/settings.json` hooks array — 32 registrations / 12 events)
- **Gaps:** zero schedules ativos em `~/.claude/schedules/` (Explore §7); ambient-pulse lê só local (sem feeds externos); sem cron daily SOTA digest
- **KPI alvo:** `automation-layer-uptime` ≥98% (hooks fire success rate via stop-metrics — quando esse for committed); `daily-routines-executed` ≥1/day
- **Princípio operacional:** "ativa se e só se trigger objetivo + artefato + consumer". Sem 3 = não roda.

---

## 6. Council pattern formalizado (multi-framework + multi-model)

**OLMO já tem 3 implementações parciais** (Explore §3):
1. `debug-team/SKILL.md` — 7 agents sequential gates, complexity_score routing, Lucas D10 confirm gate (Anthropic taxonomy nível 6)
2. `audit-merge-S251.md` — 3-model: Opus internal + Gemini Deep Think + ChatGPT 5.5 xhigh; convergence rules 3/3=ADOPT-NOW, 2/3=DEFER, 1/3+spot-check=ADOPT-NEXT
3. `research/SKILL.md` v2.0 — 6 pernas (Gemini, Perplexity, evidence-researcher, NLM, SCite, Consensus)

**Proposta unificação:** `.claude/skills/council/SKILL.md` (NEW — P3). Convoca quórum por classe de decisão:
- **DEBUG** (complexity ≤75) → debug-team MAS path (strategist + archaeologist + adversarial)
- **AUDIT/META** (architecture, adoption decisions) → 3-model methodology (Opus + Gemini + Codex/ChatGPT)
- **RESEARCH** (literature claim) → research 6-pernas
- **HIGH-STAKES** (irreversível) → 5-voice Karpathy-style (mavgpt claude-council T3 inspiração) — Opus + Gemini + Codex + Ollama (devil's advocate role) + sentinel (KBP-aware)

**Anti-sycophancy structural:** voices independentes (sem cross-contamination até synthesis); pre-registered hypothesis em arquivo committed antes de queries; adversarial role mandatory.

**KPI council:** `council-decision-traceability` = decisões grandes com ≥3 voices outputs persisted em `.claude/plans/decisions/{date}-{topic}.md` ≥90%.

**Evidence-tier:** Karpathy LLM Council (T3 — blog post; precisa pesquisa T1/T2 antes de adoção formal); Aider 2024 Architect+Editor 85% pass-rate (T1 paper + study). Adoção condicional pendente verificação T1/T2.

### §6.1 — Convergence rules (KBP-39 anchor)

3-model methodology validated em S250 (Opus + Gemini Deep Think + ChatGPT 5.5 xhigh). Cada voice rodou audit prompt + JSON schema strict independent. Outputs em `.claude-tmp/audit-{voice}-output.json` (deletados S253 cleanup; synthesis aqui é canonical).

**Convergence rules** (anchor para KBP-39 — "audit-merge convergence rules followed loosely"):
- **3/3 high** → ADOPT-NOW (cheap + verified)
- **2/3** → DEFER pending Phase 2 spot-check
- **1/3 high + spot-check confirmed** → ADOPT-NEXT (evidence-anchored opinion overrides solo-voice)
- **1/3 high + sem spot-check** → flag FP candidate
- **Divergence** → Opus orchestrator arbitrates citing local evidence (KBP-32 spot-check)

**KBP-39 lesson (S250 X1 pattern):** S250 X1 (janitor↔repo-janitor) was labeled ADOPT-NEXT based on "ChatGPT 1/3 + Opus spot-check" — should have been DEFER per strict 3/3 rule. Lucas explicit decision "merge sem sentido ter os dois" overrode technical reclassification. Outcome OK (single canonical executor é cleaner) mas methodology adherence loose. Document for future audit-merge runs: strict rules > Lucas-override OK desde que flagged como exception, não silent.

### §6.2 — Concrete decision matrix S250 (Lucas-flagged 7 hypotheses)

| # | Components | Opus | Gemini | ChatGPT | Convergence | Final action |
|---|------------|------|--------|---------|-------------|--------------|
| H1 | evidence-researcher vs researcher | KEEP_SEP high | KEEP_SEP high | KEEP_SEP high | **3/3** | KEEP_SEP + rename `researcher` → `codebase-explorer` (P2) |
| H2 | sentinel vs repo-janitor | KEEP_SEP high | MERGE med | KEEP_SEP high | 2/3 (Gemini FP) | **KEEP_SEP** |
| H3 | quality-gate vs qa-engineer | KEEP_SEP high | KEEP_SEP high | KEEP_SEP high | **3/3** | KEEP_SEP + optional rename (P2) |
| H4 | systematic-debugging skill vs debug-team skill | DEFER high | CUT high | MERGE high | **3/3 want change** | **MERGE** systematic-debugging into debug-team (lightweight fallback) — pendente S253+ destrutivo |
| H5 | automation vs improve vs continuous-learning | KEEP_SEP high | MERGE high | KEEP_SEP high | 2/3 | **KEEP_SEP** (Gemini sem grep verification) |
| H6 | insights skill vs sentinel agent | KEEP_SEP med | KEEP_SEP med | KEEP_SEP high | **3/3** | KEEP_SEP (producer/consumer) |
| H7 | docs-audit skill vs repo-janitor agent | DEFER med | KEEP_SEP med | KEEP_SEP high | 2/3 | KEEP_SEP + optional delegation |

### §6.3 — Beyond Lucas-flagged (ChatGPT-discovered)

| # | Components | Convergence | Final action | Status |
|---|------------|-------------|--------------|--------|
| **X1** | janitor skill vs repo-janitor agent | 1/3 + spot-check confirmed | ADOPT-NEXT → executed S251 | ✓ commit `3082c39` |
| X2 | systematic-debugger AGENT vs debug-team agents | 2/3 want change | DEFER S253+ measurement post-H4 | pending |
| **X3** | chaos-inject-post + model-fallback-advisory ordering | 1/3 + spot-check confirmed L7 comment | ADOPT-NEXT → pending refactor S253+ | **PENDING** |
| X4 | debug-architect vs debug-patch-editor | 3/3 | KEEP_SEP (Aider Architect/Editor SOTA S27) | ✓ confirmed |

### §6.4 — Refuted hypotheses (Gemini false positives — methodology evidence)

| Claim | Spot-check result | Verdict |
|-------|-------------------|---------|
| MERGE 4× stop-* hooks | ChatGPT cite README.md:145-178 — already consolidated | REFUTED |
| MERGE hooks/ vs .claude/hooks/ paths | All 32 paths intentional + active | REFUTED |
| MERGE hooks "likely orphans" | 32 paths registered, 69 cmd-instances | REFUTED — zero orphans |

### §6.5 — SOTA gaps consolidated (P1+ priority)

| # | Component | Gap | Priority | Source |
|---|-----------|-----|----------|--------|
| G1 | Read-only audit agents (6) | Use `disallowedTools` denylist not explicit `tools` allowlist (omitted tools INHERIT parent pool) | P1 high | code.claude.com/docs/en/subagents |
| G2 | debug-team durable state | Ad-hoc `.claude-tmp/` JSON; no checkpointer/thread-id pattern | P1 high | docs.langchain.com/oss/javascript/langgraph/durable-execution |
| G3 | debug-team metrics (tokens + wall-clock per phase) | Field exists in template but populated post-hoc; instrument SKILL.md state writes | P1 high | anthropic.com/engineering/multi-agent-research-system |
| G4 | chaos-inject-post hook ordering | Sequential assumption invalid (Anthropic docs: hooks parallel) | P1 high | code.claude.com/docs/en/hooks (= same as X3) |
| G5 | Agent Teams native pattern | Pilot for /debug-team competing-hypotheses phase | P2 high | code.claude.com/docs/en/agent-teams |
| G6 | systematic-debugging skill modern fields | Lacks `disable-model-invocation`, `context: fork`, `agent` | P2 high | code.claude.com/docs/en/skills |
| G7 | Hooks unit/golden test harness | 32 hooks + zero tests = regression risk | P2 low | (not independently verified) |
| G8 | Hooks self-disable gates (S249 loop-guard pattern) | Zero overhead in non-relevant sessions | P2 low | (measurement needed) |
| G9 | Maturity layers (SDL/SAMM/OpenSSF/CMMI) | "Eram para estar funcionando" (Lucas S254-tail) — spec documented mas non-operational; sem instrumentation, scoring, ou gate. SOTA radar, não active work. | P2 radar | `docs/research/external-benchmark-execution-plan-S248.md §B5 Security and maturity lite` |

### §6.6 — Methodology lessons (S250 retrospective)

1. **3-model methodology validated empiricamente.** Each voice caught FPs others missed. Gemini's 4 MERGE = 3 refuted by spot-check. Opus's "research lacks orchestrator" = self-refuted by Read SKILL.md L65-67. ChatGPT xhigh + grep tool = surfaced 2 high-confidence merges + 7 SOTA gaps com sources. **No single voice solo would have produced this matrix.**
2. **xhigh reasoning ROI calibrate-by-task.** ChatGPT 5.5 xhigh ~22min vs Opus internal ~3min vs Gemini 60s — earned its time via 2 high-confidence concrete merges + 7 SOTA gaps with sources. Override CLI `-c model_reasoning_effort=medium` para tasks bem-definidos.
3. **Lucas-flagged hypotheses são correctly-scoped boundaries.** Mostly 3/3 KEEP_SEPARATE. Real merges came from ChatGPT broader sweep (janitor X1, chaos-hook X3). Lesson: **2/3 voices saw inventory + inferred semantic similarity; ChatGPT did file-grep evidence work that surfaced concrete invariant violations.**
4. **KBP-32 spot-check methodology paid off cross-validation.** Caught 4+ FPs across 3 voices. Enshrined em `/research`-style skill canonical orchestration (3-model + spot-check loop).
5. **Post-S248 debug-team ≈ modern orchestrator-worker SOTA.** Next steps = measurement + durable state (G2 + G3), NOT adding more agents.

### §6.7 — Phase 2+ execution map (folded from audit-merge-S251 §8)

```
S251.A — H4 systematic-debugging skill → debug-team merge (~1h)  [PENDING]
S251.B — X1 janitor skill → repo-janitor merge (~30min)          [✓ DONE]
S251.C — X3 chaos-inject-post ordering fix (~1h)                  [PENDING]
S251.D — G1 disallowedTools → tools allowlist 6 agents (~2h)     [PENDING]
S251.E — G3 debug-team metrics instrumentation (~1h)              [PENDING — depends D]

S252+ research-heavy:
- G2 durable state checkpointer research + ADR
- G5 Agent Teams pilot evaluation
- X2 systematic-debugger AGENT measurement
```

---

## 7. Daily SOTA intake loop (gap crítico — não existe hoje)

**Estado:** `~/.claude/schedules/` vazio; ambient-pulse só local; zero skill `daily-digest` (Explore §7 confirmou).

**Proposta:** `.claude/skills/sota-intake/SKILL.md` (NEW — P2). Cron via plugin `schedule` 1×/day (06:00 BRT idle). Fontes T1/T2 only:
- **T1 official changelogs:** Anthropic blog/release notes, Google Gemini release, OpenAI Codex changelog, MCP spec updates
- **T2 maintained repos (>1k stars + commits ≤7d):** anthropics/claude-code, google/generative-ai-docs, openai/codex-plugin-cc, antropics/skills (oficial)
- **T2 papers:** arXiv cs.AI/cs.CL filtered by week + arXiv-sanity OR Anthropic-cited

**Output:** `.claude/digests/sota-{YYYY-MM-DD}.md` committed. Each item: `tier · source-URL · 1-line summary · OLMO relevance (high/med/low/none)`.

**KPI:** `digest-published-daily` boolean (≥6/7 days/week); `digest-items-tier1-2-only` 100%; `digest-actionable-items-per-week` ≥2 (com OLMO relevance high/med).

**Anti-sycophancy:** digest output passes by sentinel agent que flag claims sem source-URL (KBP-36 enforce).

---

## 8. Cross-model docs split

**Estado (Explore §8):** `AGENTS.md` (existe, declara "Claude Code não lê") + `GEMINI.md` v3.6 (existe) + `CLAUDE.md` (84 li, 80 Claude-specific) + **CODEX.md** (NÃO existe).

**Proposta:**
- **Manter `CLAUDE.md`** Claude-specific (hooks, skills, slash commands, tool routing) — lock-in admitido
- **Manter `AGENTS.md`** cross-tool agnostic (Codex + Gemini CLI + futuros)
- **Manter `GEMINI.md`** Gemini-specific gates
- **Criar `CODEX.md`** (P2) — mirror de GEMINI.md adaptado pra Codex CLI + ChatGPT 5.5 xhigh + GPT-5.4 plugin label nuance
- **Promover conteúdo de valores/domínio/workflow** de CLAUDE.md → `PROJECT.md` (NEW, cross-model) — médico/EBM/concurso/humanidades. Reduz CLAUDE.md a ~50 li puramente Claude-tool

**KPI cross-model docs:** `cross-tool-coverage` = tools com gov-doc / tools usados ≥4/4 (Claude + Codex + Gemini + Ollama futuro)
**Evidence-tier:** AGENTS.md spec proposta Cursor/Block 2025 (T2 — emergent standard, precisa T1 anchor — verificar Cursor docs Q2 2026)

---

## 9. KPI/OKR persistence (anti-vanish)

**Path canonical:** `.claude/metrics/` (NEW — committed, NOT gitignored)
- `.claude/metrics/baseline.md` — KPI definitions + thresholds + cadence (versioned)
- `.claude/metrics/snapshots/{YYYY-MM-DD}.tsv` — daily snapshot per-arm KPIs
- `.claude/metrics/okr-{quarter}.md` — quarterly OKRs Lucas-defined

**Collection script:** `scripts/kpi-snapshot.mjs` (NEW — P1) que escreve snapshot diário em git-trackable file. Hook: `hooks/stop-kpi-snapshot.sh` (or schedule cron 23:00).

**Anti-vanish gate:** `.claude/apl/` permanece gitignored (volátil session-local OK), MAS `.claude/metrics/snapshots/` é committed daily. Cron rotaciona — após 90d move pra `.claude/metrics/archive/{YYYY-MM}.tsv` agregado.

**Evidence:** OLMO falta isso (Explore §2 100% confirmado). DORA metrics methodology (T1: dora.dev + Google SRE book) sugere quatro key metrics; OLMO solo precisa adaptar — não DORA full, mas similar discipline.

**KPI meta-canonical:** `kpi-snapshot-uptime` ≥95% (≥27/30 days/month); `kpi-baseline-defined-per-arm` 12/12 (1 KPI alvo per braço deste plan).

---

## 10. Notion harvest-before-abandon (moved P0 → P2 per Lucas S253)

**Estado:** Notion blocked em `.claude/settings.json` deny-list MCP-level (Explore §4) — facilmente reversível. ADR-0006 trata Bash deny-list, NÃO Notion. Sem doc canônico "Notion vs OLMO".

**Repositioning S253:** originalmente em P0(c) blocking. Lucas S253: "Notion fica para P2" — não bloqueia foundation work (KPI infra ✓ + audit em progresso são suficientes pra P0→P1). Notion harvest é "knowledge ingestion infrastructure" alinhado com P2 (sota-intake skill + cross-model docs).

**Phase P2 (post-baseline) — HARVEST + categorize:**
1. Lucas exporta Notion workspace (Markdown export native do Notion)
2. Coloca em `.claude-tmp/notion-export/` (gitignored, temp)
3. Sentinel agent + Lucas leem categorize: `migrate-to-OLMO | keep-in-Notion | discard`

**Critério migrate-to-OLMO:**
- Templates reusáveis → `.claude/templates/` (NEW)
- Knowledge canonical (e.g., reumato protocols, hepato algorithms) → `content/knowledge/{domain}/`
- Daily logs históricos → `.claude/memory/historical/` (read-only)

**Critério keep-in-Notion:**
- UI/UX-bound (kanban, drag-drop) — OLMO não substitui sem custo desproporcional
- Multi-collaborador (se houver) — OLMO é solo

**Phase decision:** depois do harvest + triage, decisão offboarding completo vs hybrid (OLMO + Notion subset). Sem harvest = decisão prematura.

**KPI:** `notion-items-harvested` (boolean: harvest done); `notion-items-migrated` percentual; `notion-active-pages` post-offboarding ≤20% baseline

**Evidence-tier:** Chesterton's Fence principle (T1 — G.K. Chesterton "The Thing" 1929 + Eric Raymond CatB application).

---

## 11. Diagrama ASCII (Conductor 2026 OLMO)

```
                        ┌──────────────────────────────┐
                        │       Lucas (user)           │
                        └────────────┬─────────────────┘
                                     ↓
                ┌────────────────────────────────────────┐
                │   CLAUDE CODE — orchestrator default   │
                │   (intra-routing: Ollama < Haiku <     │
                │    Sonnet < Opus by complexity)        │
                └─┬──────────┬──────────┬──────────┬─────┘
                  ↓          ↓          ↓          ↓
       ┌──────────────┬──────────────┬──────────────┬────────────────┐
       │              │              │              │                │
   COGNITIVE        OUTPUT        SUPPORT       META-LOOPS      CROSS-MODEL
       │              │              │              │                │
  ┌────┴────┐    ┌────┴────┐   ┌────┴────┐    ┌────┴────┐      ┌────┴────┐
  │ MEMORY  │    │FRONTEND │   │PRODUCTIV│    │ SELF_EV │      │ ORQUEST │
  │KNOWLEDG │    │ CONTENT │   │ DEBUG   │    │ ANTIFRA │      │ MULTI_M │
  │RESEARCH │    │ CUSTOM  │   │BACKEND  │    │TOOLING/ │      │COUNCIL  │
  │         │    │         │   │         │    │ECOSYSTM │      │ (P3)    │
  └────┬────┘    └────┬────┘   └────┬────┘    └────┬────┘      └────┬────┘
       │              │              │              │                │
       └──────────────┴──────────────┴──────────────┴────────────────┘
                                     ↓
                ┌────────────────────────────────────────┐
                │      AUTOMATION_LEAN_LAYER             │
                │  hooks (32) · schedule cron · loop ·   │
                │  ambient-pulse APL · daily-SOTA (P2)   │
                └────────────────────────────────────────┘
                                     ↓
                ┌────────────────────────────────────────┐
                │    KPI/OKR persistence (anti-vanish)   │
                │    .claude/metrics/{baseline,snapshot} │
                │    daily snapshot via cron (P1)        │
                └────────────────────────────────────────┘

  Cada braço passa pelos 6 PRINCÍPIOS canonical:
  P1 humildade · P2 evidence-tier · P3 anti-sycophancy ·
  P4 profissionalismo · P5 anti-teatro · P6 E2E+WHY
```

---

## 11b. Mermaid DAG — Architecture (rendered)

```mermaid
flowchart TB
    Lucas([Lucas — user/decider])
    CC[Claude Code<br/>orchestrator default]
    Lucas --> CC

    subgraph Cognitive ["Cognitive (input-bound)"]
        MEM[MEMORY<br/>HANDOFF · agent-memory · dream]
        KNOW[KNOWLEDGE<br/>docs · ADRs · content/aulas]
        RES[RESEARCH<br/>evidence-researcher · 6-pernas]
    end

    subgraph Output ["Output (artifact-bound)"]
        FE[FRONTEND<br/>slides · chrome-devtools]
        CONT[CONTENT<br/>teaching · exam-generator · QA]
        CUST[CUSTOM<br/>concurso R3 · reumato · humanidades]
    end

    subgraph Support ["Support (process-bound)"]
        DBG[DEBUG<br/>debug-team 7 agents]
        BE[BACKEND<br/>scripts · ruff · mypy]
        PROD[PRODUCTIVITY<br/>backlog · insights · APL]
    end

    subgraph MetaLoops ["Meta-loops (system-bound)"]
        SE[SELF_EVOLVING<br/>ANTIFRAGILE<br/>sentinel · KBPs · improve]
        TOOL[TOOLING<br/>ECOSYSTEM<br/>MCPs · plugins · settings]
    end

    subgraph CrossModel ["Cross-model"]
        ORQ[ORQUESTRACAO_<br/>MULTI_MODEL<br/>ADR-0003]
        COUNCIL[COUNCIL P3<br/>3-model methodology<br/>Karpathy 5-voice high-stakes]
    end

    CC --> Cognitive
    CC --> Output
    CC --> Support
    CC --> MetaLoops
    CC --> CrossModel

    AUTO[AUTOMATION_LEAN_LAYER<br/>32 hooks · schedule cron · APL · daily-SOTA P2]
    Cognitive --> AUTO
    Output --> AUTO
    Support --> AUTO
    MetaLoops --> AUTO
    CrossModel --> AUTO

    KPI[(KPI/OKR persistence<br/>.claude/metrics/baseline+snapshot<br/>anti-vanish daily commit)]
    AUTO --> KPI

    KPI -.feedback.-> SE
    KPI -.calibrate.-> Lucas

    style Lucas fill:#f9c74f,color:#000
    style CC fill:#90e0ef,color:#000
    style AUTO fill:#a8dadc,color:#000
    style KPI fill:#e63946,color:#fff
    style COUNCIL fill:#b5179e,color:#fff
    style SE fill:#06d6a0,color:#000
```

---

## 11c. Mermaid DAG — Phasing P0→P4 (KPI gates)

```mermaid
flowchart LR
    P0["P0 Audit + Baseline + Harvest<br/>~6-8h<br/><b>S251 status: 3/4 done</b><br/>(a) baseline ✓ · (b) snapshot ✓<br/>(c) Notion ⏸ · (d) audit 30%"]
    P1["P1 Resolve redundâncias<br/>+ wire daily snapshot cron<br/>~6h"]
    P2["P2 Daily SOTA + cross-model docs<br/>+ smoke tests<br/>~8-10h"]
    P3["P3 Council unification<br/>+ agent-memory expansion<br/>~10h"]
    P4["P4 Notion offboarding<br/>+ humanidades skill<br/>~6h"]

    P0 -->|"KPI gate:<br/>baseline + 12 KPIs valued<br/>harvest log committed<br/>audit 67/67 ✗ (defer aggregate)"| P1
    P1 -->|"kpi-snapshot-uptime ≥3d<br/>S250 ADOPT-NEXT done<br/>(X1+H4+X3 resolved)"| P2
    P2 -->|"digest-published-daily ≥5/7<br/>smoke-test-coverage ≥40%<br/>CODEX.md created"| P3
    P3 -->|"agent-memory-coverage ≥40%<br/>council-decision-trace ≥1 demo"| P4
    P4 --> Done(["Conductor 2026<br/>operational"])

    style P0 fill:#f4a261,color:#000
    style P1 fill:#e9c46a,color:#000
    style P2 fill:#2a9d8f,color:#fff
    style P3 fill:#264653,color:#fff
    style P4 fill:#e76f51,color:#fff
    style Done fill:#06d6a0,color:#000
```

---

## 11d. Mermaid DAG — Council pattern (multi-model decision routing)

```mermaid
flowchart TB
    Decision{Decision class?}

    Decision -->|complexity ≤75<br/>bug| DEBUG[debug-team MAS<br/>strategist + archaeologist + adversarial<br/>parallel voices]
    Decision -->|architecture<br/>adoption| AUDIT[3-model methodology<br/>Opus + Gemini + Codex<br/>convergence rules 3/3 · 2/3 · 1/3]
    Decision -->|literature claim| RESEARCH[research 6-pernas<br/>Gemini + Perplexity + evidence-researcher<br/>+ NLM + SCite + Consensus]
    Decision -->|high-stakes<br/>irreversible| HIGH[Karpathy 5-voice<br/>Opus + Gemini + Codex + Ollama-devil + sentinel<br/>independent · pre-registered · adversarial]

    DEBUG --> Synth[Synthesis<br/>debug-architect markdown plan]
    AUDIT --> Synth2[Synthesis<br/>decision matrix file]
    RESEARCH --> Synth3[Synthesis<br/>living HTML evidence]
    HIGH --> Synth4[Synthesis<br/>quorum + Lucas confirm gate D10]

    Synth --> Action[Action<br/>editor + validator]
    Synth2 --> Action2[Action<br/>plan approval + phasing]
    Synth3 --> Action3[Action<br/>slide write + reference-checker]
    Synth4 --> Action4[Action<br/>Lucas final decision]

    style Decision fill:#f9c74f,color:#000
    style HIGH fill:#b5179e,color:#fff
    style Action fill:#06d6a0,color:#000
    style Action2 fill:#06d6a0,color:#000
    style Action3 fill:#06d6a0,color:#000
    style Action4 fill:#06d6a0,color:#000
```

---

## 12. Phasing P0 → P4 (executable, KPI-gated)

| Phase | Goal | Deliverables | KPI gate to advance | Estimated |
|-------|------|--------------|---------------------|-----------|
| **P0 — Audit + Baseline** | Saber onde estamos antes de mudar nada | (1) `.claude/metrics/baseline.md` com 12 KPIs definidos + thresholds. (2) `scripts/kpi-snapshot.mjs` com primeira run committed em `.claude/metrics/snapshots/{date}.tsv`. (3) Audit P5/P6 violations: tabela componente × {trigger? artefato? consumer? smoke? WHY?} per todos 16 agents + 18 skills + 32 hooks | Baseline file committed + 12 KPIs com valor inicial + violations tabulated | ~5-7h |
| **P1 — Resolve top-3 redundâncias S250 + métricas non-vanish** | Eliminate teatro identificado | (1) Resolve X1 (janitor↔repo-janitor merge). (2) Resolve H4 (systematic-debugging↔debug-team merge). (3) Resolve X3 (chaos-inject ordering). (4) Wire KPI snapshot daily cron via plugin schedule. (5) `.claude/digests/` placeholder estrutura | KPI: `kpi-snapshot-uptime` ≥3 days consecutive · S250 ADOPT-NEXT items resolvidos | ~6h (3×~2h) |
| **P2 — Daily SOTA loop + cross-model docs + smoke tests + Notion harvest** | Build intake + reproducibility + knowledge ingestion | (1) `.claude/skills/sota-intake/SKILL.md` + cron config. (2) `CODEX.md` created. (3) `PROJECT.md` extracted from CLAUDE.md (cross-model values/domain). (4) `scripts/smoke/` per-component (≥top 8 agents/skills críticos). (5) **Notion harvest + categorize** (moved from P0 per Lucas S253 — see §10) | KPI: `digest-published-daily` ≥5/7 days first week · `smoke-test-coverage` ≥40% (8/20 components) · `notion-items-harvested` boolean=true | ~9-11h |
| **P3 — Council unification + agent-memory expansion** | Formalize multi-model decision pattern + expand memory | (1) `.claude/skills/council/SKILL.md` (unifica debug-team + audit + research). (2) `.claude/agent-memory/` populated for ≥7/16 agents (top critical) | KPI: `agent-memory-coverage` ≥40% · `council-decision-traceability` ≥1 demo case | ~10h |
| **P4 — Notion offboarding decision + humanidades skill** | Finalize external dependencies + fill CUSTOM gap | (1) Decisão notion offboard vs hybrid (post-P2 harvest data). (2) `.claude/skills/humanidades/SKILL.md` (etimologia + filosofia + história — Lucas value embed). (3) Reumato skill dedicated | KPI: `humanidades-citacoes-per-aula` ≥1 over 3 aulas next · `notion-active-pages` post-offboard | ~6h |

**Total estimate:** P0-P4 = ~36-40h work. Spread over ~6-8 sessions (S252-S258).

**Phasing principle:** P0 baseline antes de qualquer build novo. KPI gate to advance = não promover phase sem evidência.

### Current state S253 (verified Explore agent 2026-04-25)

**Score: 4/18 PASS · 2 PARTIAL · 12 FAIL** (per phase deliverable):

- **P0 (3/3 PASS — COMPLETE post-S253 Notion repositioning):** baseline.md ✓ (12 KPIs + Lucas calibrated S252) · scripts/kpi-snapshot.mjs ✓ + snapshots/2026-04-26.tsv ✓ · audit P5/P6 PARTIAL 38/66 (58%; agents milestone 16/16 ✓; pendentes 8 skills + 20 hooks).
- **P1 (1/5 PASS · 1 PARTIAL · 3 FAIL):** X1 janitor↔repo-janitor ✓ (commit 3082c39) · H4 systematic-debugging↔debug-team FAIL (skill ainda existe) · X3 chaos-inject FAIL (sem ordering refactor) · KPI cron PARTIAL (script exists; hook/cron não wired) · `.claude/digests/` FAIL (não criado).
- **P2 (0/5 PASS):** sota-intake/SKILL.md ausente · CODEX.md ausente · PROJECT.md ausente · scripts/smoke/ ausente · Notion harvest pending.
- **P3 (0/2 PASS):** council/SKILL.md ausente · agent-memory 1/16 = 6.25% (threshold 40%).
- **P4 (0/2 PASS):** humanidades/SKILL.md ausente · reumato/SKILL.md ausente.

**Bottleneck atual:** P0(d) audit 58% pendente + P1 destrutivos H4/X3 (precisam propose-before-pour). Detalhe P0(d) em §18 NEW.

---

## 13. Alternativas consideradas (rejected — for transparency P3 anti-sycophancy)

| Alternativa | Por que rejeitada |
|-------------|-------------------|
| **Reorganizar `.claude/agents/` + `.claude/skills/` em subpastas por domínio** | Destrutivo (renames quebram imports + plans + history); sem ganho funcional vs taxonomia documentada. Plan defends taxonomy SEM mover arquivos |
| **Adotar `antigravity-awesome-skills` (1262 skills) wholesale** | T2 rep mas T3 quality unverified per-skill; "more skills" ≠ better; risco de bloat + redundância c/ existing 19 skills. Avaliar caso-a-caso post-P2 |
| **Implementar Karpathy 5-voice council como default** | T3 evidence (Karpathy blog); current 3-model methodology (audit-S251) já provou eficácia em S250; expand para 5 só se 3 demonstrar limitação |
| **Auto-purge componentes sem WHY-header** | Destrutivo + premature; P0 audit primeiro lista violations, depois Lucas decide caso-a-caso |
| **Migrar tudo de Notion immediato** | Viola Chesterton's Fence; P0 harvest first |
| **Daily SOTA intake via Twitter/X scraping** | T3 source quality + ToS risk; T1/T2 official changelogs sufficient + safer |

---

## 14. Open questions (Lucas decisions needed before P0 advance)

1. **Notion harvest path:** Lucas exporta workspace inteiro ou só sub-páginas selecionadas? (Affects P0 scope)
2. **KPI 12 thresholds:** valores propostos neste plan são suggestions; Lucas confirma/edits cada threshold? (Affects baseline)
3. **CODEX.md content scope:** mirror full GEMINI.md ou enxuto (Codex tem menos surface)? (Affects P2 scope)
4. **Notion offboarding cadence:** post-harvest, gradual (3 meses) ou hard-cutoff? (Affects P4)
5. **Council 5-voice trigger:** quais decisões qualificam "high-stakes irreversível"? (Affects P3 design)

---

## 15. Verification plan (smoke tests reprodutíveis — P6 enforcement)

Cada deliverable de phase tem smoke test committed. Examples:

- **P0 baseline:** `scripts/smoke/kpi-baseline.sh` — verifica `.claude/metrics/baseline.md` existe, parses 12 KPIs, todos têm threshold + cadence
- **P1 redundancy resolve:** `scripts/smoke/no-redundancy.sh` — Grep confirma janitor skill removed OR thin-wrapper; debug-team contains systematic-debugging section
- **P2 daily SOTA:** `scripts/smoke/digest-fresh.sh` — verifica `.claude/digests/sota-{today}.md` existe + tem ≥3 items + todos com source-URL
- **P3 council demo:** `scripts/smoke/council-trace.sh` — verifica `.claude/plans/decisions/` tem ≥1 file com ≥3 voice outputs persisted
- **P4 humanidades:** Grep `etimologia\|filosofia\|história` em últimas 3 aulas modified — count ≥1 per aula

**Master smoke runner:** `scripts/smoke/all.sh` — chains todos. Exit 0 = phase complete. Hook `pre-commit` opcional pra block commits sem smoke pass (P1+).

---

## Files modified by this plan (when approved)

**P0:**
- `.claude/metrics/baseline.md` (NEW)
- `.claude/metrics/snapshots/{date}.tsv` (NEW first)
- `scripts/kpi-snapshot.mjs` (NEW)
- `.claude-tmp/notion-export/` (gitignored, temp working dir)
- `.claude/plans/audit-p5-p6-violations.md` (NEW — output of audit)

**P1:**
- `.claude/skills/janitor/SKILL.md` (delete or thin-wrapper)
- `.claude/skills/systematic-debugging/SKILL.md` (merge into debug-team)
- `.claude/hooks/chaos-inject-post.sh` (refactor ordering)
- `.claude/settings.json` (cron snapshot wiring)

**P2:**
- `.claude/skills/sota-intake/SKILL.md` (NEW)
- `CODEX.md` (NEW)
- `PROJECT.md` (NEW)
- `CLAUDE.md` (slim down)
- `scripts/smoke/*.sh` (≥8 NEW)

**P3:**
- `.claude/skills/council/SKILL.md` (NEW)
- `.claude/agent-memory/{agent}/MEMORY.md` (≥6 NEW)

**P4:**
- `.claude/skills/humanidades/SKILL.md` (NEW)
- `.claude/skills/reumato/SKILL.md` (NEW)
- (notion offboarding files TBD post-harvest)

**Total NEW files estimate:** ~25-30. **Total MODIFIED:** ~10-15.

---

## 16. Active execution backlog (S253-S254 — folded from `fancy-imagining-crab.md`)

> **Status pós-S253 organize-a-casa:** consolidated; per-phase tasks aligned to §12 Conductor phasing.

### S253 (current session)

| Phase | Task | Type | Time | Status |
|-------|------|------|------|--------|
| **organize-a-casa** | Group A archive ruído | mechanical | 30min | ✓ done (commit `dc78ff5`) |
| **organize-a-casa** | Group B fold sub-plans into Conductor | doc | 60min | in-progress (this commit) |
| **organize-a-casa** | Group C Lucas decisions (mellow/lovely floating) | decision | 5min Lucas | pending |
| **organize-a-casa** | Group D HANDOFF + CHANGELOG single source truth | doc | 15min | pending |

### S254 (next session — slides + script-to-agent migration, per Lucas S253)

**Lucas tomorrow priorities (confirmed S253):**

| Phase | Task | Type | Time | Notes |
|-------|------|------|------|-------|
| **content** | Build/arrange 2-3 slides (likely metanálise area) | content | ~1-2h | Lovely-sparking-rossum reduced scope reference; Lucas picks slides at session start |
| **P3 / arms RESEARCH+ORQUEST** | Migrate 3 working JS research scripts → agents/subagents/skills com benchmark | refactor | ~2-3h | Aproveitar `gemini-research.mjs`, `gemini-review.mjs`, `perplexity-research.mjs` (já funcionam bem; só improve+wrap como agents/skills). Same logic + benchmark. Cross-model (Gemini+Perplexity). |
| **P1.4 (defer S255)** | KPI snapshot wiring (script + hook + first snapshot) | build | 2h | Pushed para S255+ — não cabe em S254 com slides + migration |
| **DAG (defer S255)** | Update §11c Phasing DAG state | doc | 15min | Defer junto com KPI infra |

**Total S254 estimate:** ~3-5h (slides + script migration). KPI infra defer to S255 (was originally S254, deslocado per Lucas tomorrow priority).

**Migration sub-plan (~3-4h refactor, 3 existing scripts + 1 NEW ChatGPT 5.5 wrapper, 4 total):**

> **Lucas S253:** "vamos adicionar o chat gpt 5.5 nesse time" — adds ChatGPT 5.5 (via Codex CLI) como 4th model alongside Gemini + Perplexity research + Gemini review. **Quality target:** "estava nota 8-9, vamos deixar 9-9.5" — improvement bar set 9-9.5 vs current 8-9 baseline.

| Script | Current location | Migrate to | Type | Benchmark vs |
|--------|------------------|------------|------|--------------|
| `gemini-research.mjs` | `.claude/scripts/` | agent OR skill (Lucas decide) | wrapper | direct API call (current) |
| `gemini-review.mjs` | `.claude/scripts/` | agent OR skill | wrapper | current direct invoke |
| `perplexity-research.mjs` | `.claude/scripts/` | agent OR skill | wrapper | current direct invoke |
| **`chatgpt-research.mjs` (NEW)** | `.claude/scripts/` (will create) | agent OR skill | NEW wrapper using Codex CLI gpt-5.5 | adds 4th voice to research team (audit-merge-S251 §6.1 3-model methodology already includes ChatGPT 5.5; add to research/SKILL.md 6 pernas → 7 pernas) |

**Method per script (~45min each):**
1. Read script + understand JS logic (works well — só improve)
2. Decide agent vs subagent vs skill (per Conductor §4 RESEARCH arm)
3. Wrap as `.claude/agents/*.md` OR `.claude/skills/*/SKILL.md` preserving JS as backend
4. Benchmark: same query × N runs (current vs new) → measure latency + token cost + output quality
5. Document migration delta em arm RESEARCH section §17.3 (per-arm matrix amanhã)

**S254 execution sequence (Lucas confirmed S253):**

1. **Pre-migration audit:** model names + parameters review nos 3 scripts existentes — última semana teve muitas updates (Gemini canonical = `gemini-3.1-pro-preview` per project_tooling_pipeline; ChatGPT = gpt-5.5 via Codex CLI; Perplexity model TBD). Sync to current canonical antes de benchmarkear.
2. **Benchmark:** rodar mesma query × N runs nos 4 scripts (3 existentes + chatgpt-research NEW) → latency + token + quality metrics. Quality target: 9-9.5 (vs 8-9 baseline).
3. **Launch research:** usar team atualizado para query real (Lucas pick — likely metanálise-related slide research).

**Decision pendente Lucas (open at S254 start):** agent vs subagent vs skill per script — depends on invocation pattern (one-shot vs orchestrated vs user-triggered).

### S255+ (defer destrutivos + heavy doc work)

| Phase | Task | Time | Block |
|-------|------|------|-------|
| **P0(d)** | Audit batch G+H — 28 pendentes (8 skills + 20 hooks) | ~3 sessions | none |
| **P1.1** | H4 systematic-debugging→debug-team merge (destrutivo) | ~1.5h | propose-before-pour separado + KBP-39 anchor |
| **P1.2** | X3 chaos-inject ordering refactor (destrutivo) | ~1h | propose-before-pour |
| **P1.3** | KPI snapshot daily cron wired (post-S254) | ~30min | build done |
| **P2** | sota-intake skill + CODEX.md + PROJECT.md + scripts/smoke/ + Notion harvest | ~9-11h | spread S255-S257 |

### Out of scope this organize-a-casa session

- /insights P253-001 backlog triage P0 (defer until P0(d) audit complete)
- KBP-40 codify (defer until P2 sota-intake skill exists — sem section pra apontar pointer-only KBP-16)
- Mellow-scribbling-mitten P5 (Lucas in-flight outra session/window)

---

## 17. Per-arm component audit matrix (TEMPLATE — work amanhã)

> **Lucas frame S253:** "amanhã é arrumar skills/agents/subagents/hooks por cada um dos grupos do Mermaid (12 braços) — eu não sei onde foi parar o que eu havia falado".

Audit P5/P6 horizontal (§18) é cross-component em ordem cronológica de batch. §17 vira o mesmo dado VERTICAL por arm — exposes per-arm gaps. Trabalho amanhã = preencher §17.1 a §17.12 (reusing §18 dados + assigning components per arm).

**Skeleton (template para 11 arms a preencher amanhã):**

```markdown
### §17.{N} {ARM_NAME} (Conductor §4.{N})

| Component | Type | P5 | P6 | Status | Action |
|-----------|------|-----|-----|--------|--------|
```

### §17.4 DEBUG (worked example today — strongest arm post-S252)

| Component | Type | P5 | P6 | Status | Action |
|-----------|------|-----|-----|--------|--------|
| debug-symptom-collector | agent | PASS | PART 2/4 | NEED VERIFY+WHY | mechanical batch G |
| debug-strategist | agent | PASS | PART 3.5/4 | VERIFY ✓; body WHY weak | strict body P253-004 |
| debug-archaeologist | agent | PASS | **PASS 4/4** ✓ | DONE S252 | none |
| debug-adversarial | agent | PASS | **PASS 4/4** ✓ | DONE S252 | none |
| debug-architect | agent | PASS | **PASS 4/4** ✓ | DONE S252 | none |
| debug-patch-editor | agent | PASS | **PASS 4/4** ✓ | DONE S252 | none |
| debug-validator | agent | PASS | PART 3.5/4 | VERIFY ✓; body WHY weak | strict body P253-004 |
| systematic-debugger | agent | PASS | PART 3/4 | needs VERIFY | mechanical |
| systematic-debugging | skill | (pending audit) | (pending) | likely fold post-H4 merge | H4 destrutivo S255+ |
| debug-team | skill | PASS | **PASS 4/4** ✓ | DONE S252 | none |
| post-tool-use-failure | hook | PASS | PART 3/4 | needs VERIFY | mechanical |
| stop-failure-log | hook | (pending audit) | — | — | batch H |

**DEBUG arm status (12 components):** 6 DONE · 4 mechanical pending · 1 destrutivo (H4) · 1 audit pending. **Strongest arm post-S252 audit batch F.**

### §17.{1-3, 5-12} — TODO amanhã

Para cada um dos arms restantes (MEMORY, KNOWLEDGE, RESEARCH, BACKEND, FRONTEND, CONTENT, PRODUCTIVITY, SELF_EVOLVING, TOOLING, ORQUESTRACAO, CUSTOM): assign components do §18 por arm + score per arm (DONE/pending/destrutivo).

---

## 18. Audit P5/P6 detailed progress (current state — folded from `audit-p5-p6-violations.md`)

> **Status:** v1.5 — S252 P0 in-progress (38/66 = 58% audited; 28 pending; batch F added 8 — 3 agents + 3 .claude/hooks + 2 hooks/)
> **Methodology:** read frontmatter + first 50 li per component, score 7 criteria (P5: 3 + P6: 4)
> **Cadence:** ~6-10 components per session; full P0 audit completes em ~3 more sessions

### §18.1 — Methodology (7 criteria)

| Code | Criterion | What to check |
|------|-----------|---------------|
| **5a** | Trigger objetivo | Declared invocation condition (frontmatter + body) |
| **5b** | Artefato concreto | Output file/format/structure documented |
| **5c** | Consumer real | Who consumes downstream |
| **6a** | WHAT (1-line) | Frontmatter `description:` (Anthropic spec) |
| **6b** | WHY (problem + evidence T1/T2) | Section explica problema solved + cita source |
| **6c** | HOW (1-line architecture) | Pipeline/phases/algorithm visível |
| **6d** | VERIFY (smoke test path) | `scripts/smoke/{name}.sh` ou equivalent reprodutível |

**Score per component:** P5 (3-of-3 PASS / 2-of-3 PARTIAL / ≤1 FAIL); P6 (4-of-4 PASS / 2-3 PARTIAL / ≤1 FAIL).

### §18.2 — AUDITED 38/66 (batches A-F, S251-S252)

| # | Component | Type | P5 | P6 | Action |
|---|-----------|------|----|----|--------|
| 1 | sentinel | agent | PASS | PART 2/4 | add WHY + VERIFY |
| 2 | repo-janitor | agent | PART (consumer ambíguo) | PART 2/4 | clarify consumer + WHY + VERIFY |
| 3 | qa-engineer | agent | PASS | PART 2/4 | add WHY + VERIFY |
| 4 | research | skill | PASS | PART 2/4 | add WHY + VERIFY |
| 5 | improve | skill | PASS | PART 2/4 | add WHY + VERIFY |
| 6 | insights | skill | PASS | PART 2/4 | add WHY + VERIFY |
| 7 | debug-architect | agent | PASS | **PASS 4/4** ✓ | DONE S252 |
| 8 | debug-validator | agent | PASS | PART 3.5/4 | strengthen WHY-body |
| 9 | debug-strategist | agent | PASS | PART 3.5/4 | strengthen WHY-body |
| 10 | evidence-researcher | agent | PASS | FAIL 1/4 | full refactor |
| 11 | guard-write-unified.sh | hook | PASS | PART 3/4 | add VERIFY |
| 12 | ambient-pulse.sh | hook | PASS | PART 2/4 | add WHY + VERIFY |
| 13 | debug-team | skill | PASS | **PASS 4/4** ✓ | DONE S252 |
| 14 | knowledge-ingest | skill | PASS | PART 3/4 | add VERIFY |
| 15 | debug-symptom-collector | agent | PASS | PART 2/4 | add WHY + VERIFY |
| 16 | debug-archaeologist | agent | PASS | **PASS 4/4** ✓ | DONE S252 |
| 17 | lint-on-edit.sh | hook | PASS | PART 3/4 | add VERIFY |
| 18 | guard-bash-write.sh | hook | PASS | PART 3/4 | add VERIFY |
| 19 | evidence-audit | skill | PASS | PART 2/4 | add WHY + VERIFY |
| 20 | automation | skill | PART | FAIL 1-2/4 | full refactor |
| 21 | debug-adversarial | agent | PASS | **PASS 4/4** ✓ | DONE S252 |
| 22 | researcher | agent | PASS | PART 2/4 | add WHY + VERIFY |
| 23 | teaching | skill | PART (trigger ambíguo) | PART 3/4 | clarify trigger + VERIFY |
| 24 | stop-quality.sh | hook | PASS | PART 3/4 | add VERIFY |
| 25 | mbe-evaluator | agent | PASS | **PASS 4/4** ✓ | DONE S252 |
| 26 | debug-patch-editor | agent | PASS | **PASS 4/4** ✓ | DONE S252 |
| 27 | docs-audit | skill | PASS | PART 2/4 | add WHY + VERIFY |
| 28 | exam-generator | skill | PASS | PART 3/4 | add VERIFY (best 6b ref density) |
| 29 | post-bash-handler.sh | hook | PASS | PART 3/4 | add VERIFY |
| 30 | post-tool-use-failure.sh | hook | PASS | PART 3/4 | add VERIFY |
| 31 | quality-gate | agent | PASS | PART 2/4 | add WHY + VERIFY |
| 32 | systematic-debugger | agent | PASS | PART 3/4 | add VERIFY |
| 33 | reference-checker | agent | PASS | PART 2/4 | add WHY + VERIFY |
| 34 | guard-secrets.sh | hook | PASS | PART 3/4 | add VERIFY |
| 35 | guard-mcp-queries.sh | hook | PASS | PART 2/4 | add WHY + VERIFY |
| 36 | nudge-checkpoint.sh | hook | PASS | PART 2/4 | add WHY + VERIFY |
| 37 | session-compact.sh | hook | PASS | PART 2/4 | add WHY + VERIFY |
| 38 | session-start.sh | hook | PASS | PART 3/4 | add VERIFY (best 6b ref density) |

### §18.3 — PENDING 28/66 (batches G+H, S253-S256 mechanical)

**Skills (8 pending of 18):** brainstorming · concurso · systematic-debugging (likely fold post-H4) · skill-creator · nlm-skill · continuous-learning · review · (1 reserve)

**Hooks `.claude/hooks/` (10 pending of 17):** allow-plan-exit · chaos-inject-post (refactor post-X3) · coupling-proactive · guard-read-secrets · guard-research-queries · model-fallback-advisory · momentum-brake-clear · guard-lint-before-build · post-global-handler · momentum-brake-enforce

**Hooks `hooks/` (10 pending of 15):** notify · stop-notify · nudge-commit · session-end · pre-compact-checkpoint · stop-metrics · stop-failure-log · apl-cache-refresh · post-compact-reread · loop-guard

### §18.4 — Aggregate

| Metric | Current S253 | After full P0 |
|--------|--------------|----------------|
| Components audited | 38/66 (57.6%) | 66/66 (100%) |
| P5 PASS rate | 35/38 (92%) | TBD |
| P5 PARTIAL | 3/38 (8%) | TBD |
| **P6 PASS rate** | **6/38 (16%)** ★ first PASSes S252 | TBD |
| P6 PARTIAL 3.5/4 (VERIFY+ WHY weak) | 2/38 (5%) | TBD |
| P6 PARTIAL 3/4 (close — só VERIFY) | 12/38 (32%) | TBD |
| P6 PARTIAL 2/4 (WHY+VERIFY ausentes) | 16/38 (42%) | TBD |
| P6 FAIL ≤1.5/4 | 2/38 (5%) | TBD |

**Milestone S252 Phase 3:** First 6 P6 PASSes do projeto (0%→16%). Hypothesis P1+ mechanical (add VERIFY ~5min × 8 = 40min) confirmed — 6/8 = 75% conversion.

**Pattern n=38 stable:** P5 92% PASS · P6 5-tier stratification (4/4=16%, 3.5/4=5%, 3/4=32%, 2/4=42%, FAIL=5%).

**Agents milestone (S252 batch F):** 16/16 = 100% complete. Pendentes restantes: 8 skills + 20 hooks (28 components total).

### §18.5 — Time-to-completion P1+ remaining n=38

- 12 mecânicos (VERIFY only): ~1h (batch G + H)
- 2 strict 3.5/4 (body WHY strengthen): ~30min (debug-validator + debug-strategist)
- 16 doc-only (WHY+VERIFY): ~3-4h
- 2 structural FAIL: ~1h
- 3 trigger-clarify: ~15min
- **Total restante: ~5.5h** spread S253-S256 (3 sessions dedicated mechanical)

---

## Closing note

Este plano é **defensável evidence-based** (cada decisão cita source); **MECE** (12 braços sem overlap material); **executable** (phasing com KPI gates); **non-destructive em P0-P1** (audit + baseline antes de qualquer reorg estrutural); e **embedded com 6 princípios canonical** que viram lens pra TODA decisão futura. Confidence overall: **medium-high** (high em mapping OLMO atual via Explore agent T1; medium em benchmark thresholds — Lucas precisa calibrar).
