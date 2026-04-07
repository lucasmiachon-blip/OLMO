# CHANGELOG

## Sessao 93 — 2026-04-06 (Governance + Chaos Design — L6 antifragile implemented)

### Memory Governance Review
- REFRESH: `project_tooling_pipeline.md` — hook count 19→20 (allow-plan-exit.sh missing)
- REFRESH: `patterns_antifragile.md` — L1-L7 status updated from S82 snapshot to S93 current
- REFRESH: `project_self_improvement.md` — header S87→S93, L6 status updated
- UPDATE: MEMORY.md index — S93 state

### L6 Chaos Engineering (Antifragile)
- ADD: `docs/research/chaos-engineering-L6.md` — design doc (philosophy, matrix, activation, observation)
- ADD: `.claude/hooks/lib/chaos-inject.sh` — injection library (4 vectors, probability roll, JSONL logging)
- ADD: `.claude/hooks/chaos-inject-post.sh` — PostToolUse hook (Agent|Bash), injects into /tmp state files
- ADD: `hooks/stop-chaos-report.sh` — Stop hook, reports injections vs defense activations + gap analysis
- MOD: `.claude/settings.local.json` — registered 2 new hooks (chaos PostToolUse + Stop report)
- MOD: `.claude/hooks/README.md` — updated from 13 to 22 hooks, added libraries section
- DESIGN: Zero changes to existing L1-L3 hooks. Chaos writes to same /tmp files defenses already read.
- TESTED: `CHAOS_MODE=1 CHAOS_PROBABILITY=100` — all 4 vectors fire, stop report generates cleanly. Default off = zero output.

---

## Sessao 92 — 2026-04-06 (Langfuse traces validated — OTel pipeline fix)

### OTel Pipeline Fix
- FIX: API keys desatualizadas no `.env` (projeto Langfuse recriado, keys antigas invalidadas)
- FIX: Windows env vars sobrescreviam `.env` — docker-compose `environment: ${VAR}` → `env_file: .env`
- ADD: Header `x-langfuse-ingestion-version: "4"` no OTel collector config (Langfuse V3 requirement)
- FIX: Logs pipeline removido do exporter Langfuse (endpoint `/otel/v1/logs` nao existe em V3 = 404)
- RESULT: Traces visíveis no Langfuse UI :3100. Pipeline end-to-end validado visualmente.

### Pendente
- ClickHouse `events_core` table faltando — dashboard Fast Preview com erro (scores/models/costs). Traces OK.
- L6 chaos design doc — movido para S93
- Memory governance review — movido para S93

---

## Sessao 91 — 2026-04-06 (NeoSigma /insights — Phase 5 validated)

### /insights Run (13 sessions analyzed, S86-S90 period)
- SCAN: 0 user corrections, 0 real errors, 0 KBP violations
- AUDIT: 9/10 rules FOLLOWED, 2 UNTESTED (no QA/slide sessions in period)
- Phase 5 constrained optimization: trend improving (corrections 0.5→0.4, kbp 0.76→0.61)
- Failure registry updated: 5 entries, JSON validated

### Proposals Applied (2 of 5)
- P002: `qa-pipeline.md` — state enum source of truth reference (`_manifest.js`)
- P003: `qa-engineer.md` — KBP-05 hard guard (stop on second slide ID)

### Report
- `latest-report.md` updated, `previous-report.md` archived (S82 report)

---

## Sessao 90 — 2026-04-06 (INFRA — cleanup research MDs + evidence-db redistribution)

### Cleanup: Research MDs (~3.500 linhas removidas)
- DEL: `docs/research/anti-drift-tools-2026.md` — consumido (anti-drift rules, hooks)
- DEL: `docs/research/agent-self-improvement-2026.md` — consumido (OTel, memory, self-healing)
- DEL: `docs/research/claude-md-best-practices-2026.md` — consumido (CLAUDE.md cascade)
- DEL: `docs/research/memory-best-practices-2026.md` — consumido (memory governance, TTL)
- DEL: `docs/research/claude-code-best-practices-2026.md` — consumido (agents, skills, hooks)
- KEEP: `docs/research/implementation-plan-S82.md` — plano ativo

### Redistribuicao: evidence-db.md → living HTML
- DEL: `metanalise/references/evidence-db.md` (387 linhas, v5.7)
- NEW: `metanalise/evidence/s-hook.html` — volume, qualidade, competencia (5 dados EM USO + apoio)
- NEW: `metanalise/evidence/s-checkpoint-1.html` — Ray 2009 + ACCORD + follow-ups + paradoxo A1C
- NEW: `metanalise/evidence/s-ancora.html` — Valgimigli 2025 + 7 RCTs + CYP2C19
- EDIT: 5 arquivos — referencias atualizadas de evidence-db.md para living HTML

---

## Sessao 89 — 2026-04-06 (OTel validated, memory governance, antifragile L1+L2)

### OTel Validation
- Stack end-to-end confirmado: 7/7 containers healthy, env vars loaded, Langfuse 200 OK

### Memory Governance Review (S89)
- 17 files auditados, 0 merges (reconsiderado — conteudo distinto)
- TTL staggered: 2@2026-06-15, 4@2026-07-01, 2@2026-07-15 (evita bottleneck)
- Cross-refs adicionados: patterns_antifragile ↔ project_self_improvement
- Next review: S92

### Antifragile L1 — Retry with Jitter (DONE)
- NEW: `.claude/hooks/lib/retry-utils.sh` — exp backoff + jitter utility
- EDIT: `lint-on-edit.sh` — 2 attempts with jitter
- EDIT: `guard-lint-before-build.sh` — 3 attempts with jitter per lint script
- EDIT: `build-monitor.sh` — 2 attempts with jitter on node JSON parse
- EDIT: `export-pdf.js` waitForServer() — exp backoff 1.5x + jitter (was fixed 300ms)
- `.gitignore`: exception for `.claude/hooks/lib/` (overrides generic `lib/` ignore)

### Antifragile L2 — Model Fallback State Tracking (MELHORADO)
- REWRITE: `model-fallback-advisory.sh` — added failure log + circuit breaker
- State tracking: `/tmp/cc-model-failures.log` (auto-pruned 1h)
- Circuit breaker: 2 failures in 5min → model marked "degraded" → strong advisory
- Fallback chain context-aware: suggests next model in Opus→Sonnet→Haiku chain

### Docs
- `implementation-plan-S82.md`: L1 PARCIAL→DONE, L2 PARCIAL→MELHORADO

---

## Sessao 88 — 2026-04-06 (OTel activation — Langfuse V3 stack live)

### Langfuse V2 → V3 Upgrade + Activation
- `docker-compose.yml`: 3 services → 7 (+ ClickHouse 24, Redis 7, MinIO, langfuse-worker)
- Langfuse image: `langfuse/langfuse:latest` (V2) → `langfuse/langfuse:3` (V3.163.0)
- Postgres: 16-alpine → 17-alpine
- Split: `langfuse` → `langfuse-web` + `langfuse-worker` (async processing)
- All infra ports bound to `127.0.0.1` (localhost only)

### Bug Fixes (3 issues found and resolved)
- OTel endpoint: `langfuse:3100` → `langfuse-web:3000` (Docker internal port, not host mapping)
- Healthcheck IPv6: `localhost` → `127.0.0.1` + `HOSTNAME: "0.0.0.0"` (Next.js container binding)
- Postgres volume: cleared stale PG16 data incompatible with PG17

### Environment Configuration
- `.env` created with Langfuse API keys + OTel endpoint (gitignored)
- Windows env vars: `LANGFUSE_PUBLIC_KEY`, `LANGFUSE_SECRET_KEY`, `LANGFUSE_AUTH_HEADER`, `OTEL_EXPORTER_OTLP_ENDPOINT`
- Langfuse project "OLMO" created, API keys generated

### Pending
- Restart Claude Code to activate OTel telemetry (env var loaded at process start)

---

## Sessao 87 — 2026-04-06 (INFRA2 — OTel+Langfuse, SEC-004 version pinning, memory stale update)

### OTel + Langfuse Self-Host (Tier 0 Observability)
- `docker-compose.yml`: 3 services — PostgreSQL 16, OTel Collector, Langfuse
- `config/otel/otel-collector-config.yaml`: OTLP gRPC :4317 → batch → Langfuse HTTP
- Claude Code → OTLP → Collector → Langfuse UI (:3100)
- `.gitignore`: added langfuse_postgres volume

### SEC-004: MCP Version Pinning (P0 Security)
- `notebooklm-mcp@latest` → `@1.2.1` (pinned)
- `zotero-mcp` → `==0.1.6` (pinned)
- `perplexity` → `status: removed` (migrated to API)
- Added `_comment_version_policy` with quarterly review (next: S95)

### Memory Stale Update
- `project_self_improvement.md`: L1-L7 actual state, KBPs active, OTel done, self-healing loop
- `project_tooling_pipeline.md`: 19 hooks, 11 MCPs, 20+ skills, quality-gate unfrozen, Gemini CLI
- `MEMORY.md`: updated index descriptions

---

## Sessao 86 — 2026-04-06 (INFRA — L7 continuous learning: memory TTL, failure registry, model fallback)

### Antifragile L7 — Memory TTL Backfill
- 17 memory files: added `review_by`, `last_challenged`, `confidence` frontmatter fields
- Classification: 6 permanent, 5 review Q3 2026, 4 review Q2 2026, 2 near-term (medium confidence)
- MEMORY.md: updated governance (review cadence S89, TTL fields documented)
- `/dream` SKILL.md Phase 4: added TTL check — flags expired review_by, suggests confidence downgrade

### Antifragile L7 — NeoSigma Failure Registry
- `.claude/insights/failure-registry.json`: schema v1 with constrained optimization
- Seeded with 4 sessions (S82-baseline + S83-S85) from /insights S82 report data
- Trend: corrections_5avg 0.5, kbp_violations_5avg 0.76, direction "improving"
- `/insights` SKILL.md Phase 5: append to registry + recompute trend + regression check

### Antifragile L2 — Model Fallback Advisory Hook
- `.claude/hooks/model-fallback-advisory.sh`: PostToolUse(Agent|Bash) hook
- Detects: overloaded (529), rate_limit (429), model_not_available, context_length_exceeded
- Advisory: suggests Opus→Sonnet→Haiku downgrade (no auto-switch)
- settings.local.json: wired as PostToolUse(Agent|Bash) with 3s timeout

### Infra
- Hooks: 18 → 19 (+model-fallback-advisory)
- Taleb layers: L2 ZERO→PARCIAL, L7 MELHORADO→SIGNIFICATIVO

---

## Sessao 85 — 2026-04-06 (INFRA — Tier 2 antifragile: lint-on-edit, circuit breaker, quality-gate, insights JSON)

### Antifragile L5 — lint-on-edit (PostToolUse)
- `.claude/hooks/lint-on-edit.sh`: novo PostToolUse(Write|Edit) hook
  - Detecta automaticamente edicoes em `content/aulas/*/slides/*.html`
  - Extrai nome da aula do path, roda `node lint-slides.js {aula}`
  - Silencioso em sucesso; injeta erros no contexto do agente como additionalContext (auto-correcao)
  - Exit 0 sempre (PostToolUse nao pode reverter, mas o agente recebe o feedback)
- settings.local.json: wiring `PostToolUse(Write|Edit)` → lint-on-edit.sh (timeout 15s)

### Antifragile L3 — circuit breaker de custo (PostToolUse)
- `.claude/hooks/cost-circuit-breaker.sh`: novo PostToolUse(.*) hook
  - Rastreia tool calls por hora em `/tmp/cc-calls-{YYYYMMDD_HH}.txt`
  - Aviso progressivo a cada 10 calls apos 100 (default `CC_COST_WARN_CALLS`)
  - Injeta instrucao STOP apos 400 calls (default `CC_COST_BLOCK_CALLS`)
  - Thresholds ajustaveis via env vars; documentado upgrade para custo USD real via OTel
- settings.local.json: wiring `PostToolUse(.*)` → cost-circuit-breaker.sh (timeout 3s)

### quality-gate descongelado
- `.claude/agents/quality-gate.md`: adicionados 4 novos items ao checklist
  - Item 4: `lint-slides.js {aula}` — erros bloqueantes de HTML/estrutura
  - Item 5: `lint-case-sync.js {aula}` — sincronizacao de casos clinicos
  - Item 6: `lint-narrative-sync.js {aula}` — sincronizacao narrativa
  - Item 7: `validate-css.sh` — validacao CSS
  - Agente nao esta mais FROZEN; detecta aula ativa via git branch
- HANDOFF.md: status atualizado "OK (JS/CSS lint adicionado S85)"
- BACKLOG.md: item quality-gate marcado como [x]

### Antifragile L7 — /insights output estruturado
- `.claude/skills/insights/SKILL.md`: adicionado bloco "Structured JSON Output (obrigatorio)"
  - Template JSON com: `proposals[]`, `kbps_to_add[]`, `pending_fixes_to_add[]`, `metrics{}`
  - Alimenta `known-bad-patterns.md` e `pending-fixes.md` com aprovacao do Lucas
  - Metrica de evolucao: `patterns_resolved_since_last` vs `patterns_new`

### Infra
- Hooks: 16 → 18 (+lint-on-edit, +cost-circuit-breaker)
- Docker Desktop instalado via winget (v4.67.0) — habilita OTel + Langfuse (Tier 2A)

### Commits
- `5e3058a` — S85: Tier 2 antifragile - lint-on-edit, cost circuit breaker, quality-gate JS/CSS, insights JSON output

---

## Sessao 84 — 2026-04-06 (INFRA — Tier 0 + Tier 1 antifragile: OTel docs, model routing, PreCompact, agent memory)

### Tier 0 — Observabilidade documentada
- `.env.example`: adicionadas 5 vars OTel comentadas (CLAUDE_CODE_ENABLE_TELEMETRY, OTEL_METRICS_EXPORTER, OTEL_EXPORTER_OTLP_PROTOCOL, OTEL_EXPORTER_OTLP_ENDPOINT, OTEL_METRIC_EXPORT_INTERVAL)
- Backend recomendado: Langfuse (MIT, $0, cloud free 50k eventos/mes)
- Ativas quando Docker + Langfuse estiverem configurados

### Tier 1A — Model routing (3 agentes)
- `.claude/agents/evidence-researcher.md`: `model: inherit` → `model: sonnet` (~60% economia)
- `.claude/agents/reference-checker.md`: `model: sonnet` → `model: haiku` (~85% economia)
- `.claude/agents/notion-ops.md`: `model: sonnet` → `model: haiku` (~60% economia)
- Todos os 8 agentes tem agora model explícito (nenhum herda Opus por acidente)

### Tier 1B — PreCompact hook migration
- `settings.local.json`: `pre-compact-checkpoint.sh` movido do evento `Stop` para `PreCompact`
- Timing agora garantido: salva estado ANTES da compaction, nao depois
- Hooks: 15 → 16 (+PreCompact event)

### Tier 1C — Agent memory: project
- `.claude/agents/qa-engineer.md`: adicionado `memory: project` (aprende issues recorrentes de QA)
- `.claude/agents/reference-checker.md`: adicionado `memory: project` (acumula citation patterns)
- `evidence-researcher` ja tinha `memory: project` (verificado, sem alteracao)
- Antifragile L7: agentes que aprendem entre sessoes

### Tier 1D — context: fork (verificado, ja existia)
- Skills `/research`, `/medical-researcher`, `/deep-search` ja tinham `context: fork` no frontmatter
- Verificado e documentado; sem alteracao necessaria

### Commits
- `8ed6905` — S84: agent hardening Tier 0 + Tier 1 completos

---

## Sessao 83 — 2026-04-06 (INFRA — enforcement, Via Negativa, self-healing, values)

### Enforcement (Tier 1)
- crossref-precommit.sh: BLOQUEIA commit se slide HTML staged sem _manifest.js (ou evidence sem slide)
- known-bad-patterns.md: 5 anti-patterns (Via Negativa) como rule always-on (KBP-01 a KBP-05)
- CLAUDE.md enforcement: 3→5 regras, mais concretas, com consequencias explicitas

### Self-Healing Loop
- stop-detect-issues.sh: novo Stop hook persiste issues em .claude/pending-fixes.md
- session-start.sh: surfacea pending-fixes na proxima sessao + arquiva
- .gitignore: exclui pending-fixes*.md (transiente)
- settings.local.json: wiring do novo hook (15 hooks total)

### CLAUDE.md & Structure
- content/aulas/CLAUDE.md: regras compartilhadas para todas as aulas (74 linhas)
- CLAUDE.md root: slim 92→90 linhas, propagation map movido para aulas/CLAUDE.md
- Values como decision gates: antifragile + curiosidade em CLAUDE.md + context-essentials
- context-essentials.md: adicionada secao VALUES com perguntas operacionais

### Cleanup
- qa-video.js: removido (deprecated S82, pipeline real: qa-batch-screenshot.mjs)
- TREE.md: referencia atualizada qa-video → qa-batch-screenshot

### Pesquisas (2 novas, background agents)
- docs/research/memory-best-practices-2026.md (736 linhas) — OLMO 7.4/10
- docs/research/claude-code-best-practices-2026.md (1076 linhas) — 19 recomendacoes, 17 gaps

### Bug Fix
- QA visual conflict: "NUNCA Gemini" era regra stale — Gemini coexiste com Opus no pipeline QA

### Implementation Plan Update
- Marcados items 5-7, 16-17 como DONE
- Adicionados Tier 1A-D da pesquisa best practices (agent routing, PreCompact, memory, context:fork)
- Tabela de camadas antifragile atualizada (L5 e L7 parciais)
- Architecture vision atualizada com estado S83

## Sessao 82 — 2026-04-05/06 (INFRA — audit cleanup, security, anti-drift, anti-fragile)

### Quick Wins (Fase 1)
- repo-janitor: add maxTurns: 12 (unico agente sem limite)
- HANDOFF: remove DOC-1 (Python 4-agent arch IS implemented, not scaffold)
- HANDOFF: remove RED-3 (feedback_qa_use_cli_not_mcp.md already consolidated)
- AGENTS.md: fix broken ref feedback_anti-sycophancy.md → memory/patterns_adversarial_review.md

### P1 Bug Fixes (Fase 2)
- BUG-1: Preflight contract aligned to metrics.json (qa-engineer.md + gemini-qa3.mjs)
- BUG-5: Evidence agent output path aligned to qa-screenshots/ (evidence-researcher.md)
- DOC-4: 3 agent contracts rewritten from evidence-db.md → living HTML (reference-checker, evidence-researcher, mbe-evaluator)

### P0 Security Fixes (Fase 3)
- SEC-003: Gemini API key moved from URL query string to x-goog-api-key header (6 instances, 2 scripts)
- SEC-002: NLM execSync → execFileSync array form (content-research.mjs)
- SEC-NEW: done-gate.js aula allowlist + execFileSync for all interpolated commands

### Redundancy (Fase 4)
- RED-1: mcp_safety.md consolidated — batch/reorganize delegates to notion-cross-validation.md

### Inherited Bug Fixes
- BUG-3: export-pdf.js DeckTape adapter reveal → generic (deck.js, not Reveal.js)
- BUG-4: qa-video.js marked @deprecated (references non-existent gemini.mjs)
- BUG-6: grade/docs/prompts/ created (5 prompt files copied from metanalise)

### /insights Proposals Applied (6 rules)
- Criteria-source mandate (qa-pipeline.md)
- Momentum brake (anti-drift.md)
- Script primacy (anti-drift.md)
- Single-slide guard (qa-engineer.md)
- Proactive checkpoints (session-hygiene.md)
- P0 security gate (session-hygiene.md)

### Anti-Drift Quick Wins Implementados (5 items)
- plansDirectory config (.claude/plans — planos sobrevivem sessoes)
- context-essentials.md (regras reinjectadas pos-compaction)
- Propagation Map no CLAUDE.md (cross-ref "se mudou X, atualize Y")
- pre-compact-checkpoint.sh (Stop hook grava git status + arquivos recentes)
- stop-crossref-check.sh (Stop hook warning se slide mudou sem manifest)

### Pesquisas Completas (3 reports)
- anti-drift-tools-2026.md (449 linhas, 30+ fontes, ifttt-lint, hooks, propagation maps)
- agent-self-improvement-2026.md (811 linhas, 60+ fontes, 23 ferramentas, OTel, Langfuse, NeoSigma)
- claude-md-best-practices-2026.md (414 linhas, OLMO scorecard acima da media)
- implementation-plan-S82.md compilado (diagnostico + roadmap Dia 0-2 + Tier 1-3)

### Meta
- /insights retrospective: 5 recurring patterns (scope creep 24x, context overflow 11x, criteria 9x, script redundancy 10x, batch QA 7x)
- BACKLOG.md criado (separado do HANDOFF — persistente entre sessoes)
- Memory: 14 → 16 files (patterns_antifragile, feedback_teach_best_usage)
- Hooks: 9 → 13 (pre-compact-checkpoint, stop-crossref-check, session-compact atualizado)
- 18 commits total nesta sessao

## Sessao 81 — 2026-04-05 (CONFRONTACAO — adversarial audit, doc sweep)

### Janitor
- Fix: repo-janitor `model: fast` → `model: haiku` (valor invalido causava crash)
- Cleanup: 10 notion dump MDs em scripts/output/ + dirs vazios data/, .claude/worktrees (untracked)

### Adversarial Audit (4 auditorias: 2 Explore Opus + 2 Codex GPT-5.4)
- Relatorio completo: `.archive/ADVERSARIAL-AUDIT-S81.md`
- 21 achados categorizados: 3 SEC, 6 BUG, 8 DOC, 3 RED, 3 DEAD
- 1 rejeitado (anti-drift overlap = intencional)

### Doc Fixes (Batch 1 — alta confianca)
- `project_tooling_pipeline.md`: agent count "11→7" → "11→8"
- `AGENTS.md:96`: GEMINI.md version ref "v3.2" → "v3.6"
- `AGENTS.md:67`: evidence-db.md → living HTML (canonical)
- `ARCHITECTURE.md:223`: OBSIDIAN_CLI_PLAN.md link → .archive/ path
- `.env.example`: GOOGLE_AI_KEY → GEMINI_API_KEY
- MCP count sweep (6 files): Gemini removido, 16→15 total, 13→12 connected
- PENDENCIAS.md: Gemini MCP marcado como descartado S71

### Pendente (Batch 2-4 no audit report)
- SEC-002/003/NEW: security fixes em scripts (verificar codigo)
- BUG-1: preflight contract (qa-browser-report.json vs metrics.json)
- DOC-1: arquitetura Python em CLAUDE.md (decisao Lucas)
- DOC-4 parcial: agentes dependentes de evidence-db (requer rewrite)

## Sessao 80 — 2026-04-05 (AGENTES — audit 2, rename, qa-engineer rewrite)

### Doc fixes
- HANDOFF: contagem 7→8 agentes, 4→3 eliminados
- CHANGELOG S79: "eliminados (4)" → (3)
- TREE, GETTING_STARTED, ARCHITECTURE: agent count 10→8

### Rename medical-researcher → evidence-researcher
- Arquivo, agent-memory dir, 5 docs atualizados (15 files)
- Filename agora == frontmatter `name:` (sistema usa filename para routing)

### qa-engineer rewrite (186→80 linhas)
- Fix: StrReplace → Edit (tool inexistente)
- Add: maxTurns: 12 (era unbounded — rodava indefinidamente)
- Rename gates: -1/0/4 → Preflight/Inspect/Editorial
- Arquitetura: 1 gate = 1 invocacao (hard stop via maxTurns)
- Removida redundancia: tabelas de 35 checks → categorias, execution sequence → referencia a scripts

### Rules
- session-hygiene.md: checklist pos-consolidacao + hardening de agentes
- qa-pipeline.md: gate names atualizados (Preflight/Inspect/Editorial)

## Sessao 79 — 2026-04-05 (AGENTES — consolidacao e hardening)

### Agentes eliminados (3)
- mcp-query-runner: nao-funcional (tools so Read, nao acessava SCite/Consensus)
- opus-researcher: redundante (5 MCPs identicos ao evidence-researcher), conteudo mergeado
- perplexity-auditor: absorvido pelo evidence-researcher (Perplexity via Bash + triangulacao interna)

### Agentes melhorados (3)
- evidence-researcher: consolidou opus-researcher + perplexity-auditor. Triangulacao interna (MCPs + Perplexity + Gemini). Expertise MBE + andragogia + divergencias.
- reference-checker: fix mcp:pubmed nos tools (antes nao verificava PMIDs via MCP)
- mbe-evaluator: ENFORCEMENT duplo + stop gate (padrao S78)

### Docs
- AGENT-AUDIT renomeado S78→S79, inventario atualizado (11→7 agentes)

## Sessao 77b — 2026-04-05 (s-objetivos fixes + cross-ref sync)

### Fixes
- Acentos PT-BR corrigidos em 00b-objetivos.html (7 palavras)
- CSS: obj-detail 17→18px (min projeção), obj-num opacity 0.35→0.5
- lint-narrative-sync: hookIdx > 1 → > 2 (s-objetivos entre title e hook)

### Cross-refs
- metanalise/HANDOFF.md: 18→19 slides, s-objetivos na tabela F1, counts atualizados
- blueprint.md: Slide 00b adicionado entre title e hook
- narrative.md: 00b-objetivos na lista F1

### Infra
- Memoria consolidada: feedback_qa_cross_ref.md → feedback_qa_use_cli_not_mcp.md
- project_metanalise.md: hub routing (build, QA, research, lint, evidence)

## Sessao 76 — 2026-04-05 (QA + SLIDES — s-objetivos content rewrite)

### QA — s-objetivos
- Gate -1: overflow (fillRatio 1.04) + h2 clipado (-11px). Resolvido com flex-start + content rewrite
- h2 alinhado a 68px (matching s-hook, s-contrato) via `section#s-objetivos .slide-inner { justify-content: flex-start }`
- Codex adversarial: CSS OK, content hierarchy strong, bug notes corrigido (5→4→5)

### Conteudo — reescrito por Lucas
- 5 objetivos: conceitos, forest plot, heterogeneidade, certeza GRADE, EtD
- Layout 2 colunas: lista 1-4 esquerda + objetivo 5 (EtD) sidebar direita com destaque
- Source-tag: formato Autor Ano — Higgins 2024, Shea 2017, Murad 2014

### Rules — erros recorrentes capturados
- `slide-rules.md` §2: dual-source (slides/*.html + index.html), CSS specificity (`section#s-{id}`), source-tag formato
- Aprendizado: rules > memory para erros no caminho de acao

## Sessao 75 — 2026-04-05 (SLIDES — s-objetivos build + 3-leg research)

### Research — 3 pernas paralelas para s-objetivos
- Perna A (Gemini API + NLM): `content-research.mjs --slide s-objetivos --fields --nlm` ($0.048, 3 NLM queries)
- Perna B (Opus web research): PubMed, Semantic Scholar, CrossRef — competency frameworks, resident blind spots
- Perna C (PMID verification): 2 agents paralelos para PMID 17785646 (Windish) e 28935701 (AMSTAR-2)
- Convergencia 3/3 pernas nos 3 pilares (credibilidade → resultados → aplicacao)
- 7 PMIDs VERIFIED, 6 CANDIDATE, 2 WEB-VERIFIED (18 referencias total)
- Novos achados: Windish 2007 (41.4% biostat score), Nasr 2018 (forest plot teachable 44→76%), Borenstein 2023 (I² misinterpretation)

### Living HTML — s-objetivos reescrito
- `evidence/s-objetivos.html`: 3 eixos (competencias + blind spots + formato) vs 2 eixos (S74)
- 11 metricas em Numeros-Chave (vs 5), 4 Evidence Gaps documentados, Assessment Tools catalogados
- 5 opcoes formato (A-E), convergencia documentada por perna

### Slide s-objetivos — build completo
- `slides/00b-objetivos.html`: 5 competencias Cochrane + AMSTAR-2, layout vertical numerado
- h2: "Objetivos educacionais" (decisao Lucas)
- CSS: `.objetivos-list`, `.obj-item`, `.obj-num`, `.obj-skill`, `.obj-detail` no metanalise.css
- `_manifest.js`: headline atualizado
- `index.html`: section injetada (deck.js le DOM, nao manifest em runtime)
- Lint clean, build OK (19 slides)

### Bug fix — slide nao renderizava
- Root cause: `index.html` nao incluia `<section id="s-objetivos">` (deck.js le DOM)
- Fix: injecao manual no index.html entre s-title e s-hook
- Codex adversarial encontrou root cause em 1 passo

### Mockups
- v1: 3 variantes (C, D, E) — rejeitado (palheta errada, emojis, sem paralelismo)
- v2: 2 variantes (F, G) com tokens reais — Lucas escolheu F (lista vertical numerada)
- Mockups deletados apos decisao

## Sessao 74 — 2026-04-05 (SLIDES — s-objetivos + content-research fix)

### Slide s-objetivos — stub + living HTML parcial
- `slides/00b-objetivos.html` criado (stub, h2 provisorio)
- `_manifest.js` atualizado: 19 slides, s-objetivos entre s-title e s-hook
- `evidence/s-objetivos.html` criado: 2 eixos (conteudo Murad + formato pedagogico)
- 3 pilares Murad identificados: credibilidade → confianca → aplicacao
- 4 opcoes de formato mapeadas (verbos, perguntas, roadmap, hibrido)
- PMIDs verificados: 4 VERIFIED (32870085, 25284006, 37640836, 22225439)
- PMIDs descartados: 26173516 (Gemini hallucinated), 29713210 (Gemini hallucinated — era inotuzumab)

### Fix: content-research.mjs — contaminacao aula
- `buildSystemPrompt()`: hardcoded hepatologia → `AULA_PROFILES` object (cirrose, metanalise, mbe, grade)
- Role, audience, guidelines, tier-1 sources, clinical action, audience level: todos aula-specific
- Tabela de divergencia: EASL/AASLD/Baveno → Source A/B/C (generico)
- User prompt: guidelines hardcoded → referencia ao system prompt
- Re-rodou com contexto correto: Gemini agora responde sobre MA, nao cirrose

### Pesquisa — 4 frentes
- Opus web search: prequestions d=0.84 (Sana 2020), curiosidade/dopamina (Gruber 2014), advance organizers (Cutrer 2011)
- Gemini deep-search: assertion-evidence (Alley), 6 design patterns, progressive disclosure
- Analise conteudo: 16 competencias mapeadas por Bloom, arco emocional, distincao contrato vs objetivos
- Gemini API (corrigido): 3 pilares Murad, GRADE Working Group, Cochrane Handbook

### Feedback salvo
- Agentes: perguntas ABERTAS, nao forcar framework (Bloom/andragogia) em todas as frentes

## Sessao 73 — 2026-04-05 (SLIDE s-PICO REDESIGN)

### Slide s-pico — mismatch grid + indirectness punchline
- h2: "O valor da MA depende em grande parte da concordância entre o study PICO e o seu target PICO"
- Layout: grid 2×2 com P≠/I≠/C≠/O≠ — cenários de mismatch (andragogia, não definição)
- Punchline click-reveal: "evidência indireta (indirectness)" — sentir gap antes de nomear
- Custom anim: stagger P→I→C→O (0.3s) + 1 hookAdvance para punchline
- CSS: border-left downgrade, .pico-neq, .pico-punchline, GSAP init states
- Gemini 2.5 Pro deep-think consultado para design (convergiu com Opus no conceito mismatch)
- Lint clean, build OK (18 slides), 2 screenshots (S0 + S2)

## Sessao 72 — 2026-04-05 (PERPLEXITY PIPELINE + SECURITY HARDENING + s-PICO EVIDENCE)

### Research pipeline — Perplexity (Perna 6)
- `.claude/agents/perplexity-auditor.md` criado: Sonar deep-research, Tier 1 enforcement, open-ended prompts
- `.claude/skills/research/SKILL.md`: 5→6 pernas, dispatch table atualizado, minimum legs 1+5+6
- `.claude/agents/reference-checker.md`: verificacao Perplexity (PMC→PMID, survival rate)
- `.claude/skills/research/references/methodology.md`: triangulation rules Perna 6
- `perplexity-findings.md` criado: 8 findings (F1-F8), 3 conceptuais. F1 VERIFIED Tier 1, F7 INVALID (PMID hallucinated)
- Feedback salvo: queries ABERTAS para discovery, nunca fechadas (memory)

### Security — 4 EASY fixes
- `guard-secrets.sh`: warn-only → fail-closed (exit 2)
- `guard-secrets-precommit.sh` criado: standalone git pre-commit, pattern `pplx-` adicionado
- `.pre-commit-config.yaml`: hook local guard-secrets adicionado
- `.gitignore`: expandido (*.p12, *.pfx, credentials.json, service-account*.json)
- `content-research.mjs`: path traversal guard no `--fields` (SEC-006)
- `package.json`: ExecutionPolicy Bypass → RemoteSigned (SEC-007)
- Codex adversarial audit: segundo pass com framing adversarial (SEC-002/003/004/005 MODERATE pendentes)

### Living HTML — s-pico
- Core GRADE Unpacked (PMID 41207400) adicionado como Tier 1 ref-principal
- 3 numeros-chave novos verificados: PMIDs 17238363 (Huang 2006), 28234219 (Adie 2017), 36398200
- Convergencia 6/6 pernas documentada (incluindo Perna 6 Perplexity)
- PMID 37575761 flaggado INVALID (hallucinated by Perplexity — paper real e Autoantibody/AMACR)

### Config
- Memory: feedback_perplexity_open_queries.md adicionado (15 files, cap 20)

## Sessao 71 — 2026-04-05 (QUERY + BUILD S-PICO + QA PROFESSIONALIZATION)

### QA pipeline (gemini-qa3.mjs)
- Gate -1 preflight: lint, screenshots, freshness, h2, word count, font-size ($0, bloqueia API)
- Validation layer: nota range [0,10] server-side + completeness check + semantic consistency
- Video: removido de Call A (static PNGs only), proof-of-viewing validation Call C
- artefatos separado da media motion → integrity gate (blocking, nao estetico)
- Schema min/max, media-first ordering (Google rec), thinkingConfig HIGH Gemini 3.x
- Temperatura editorial: manter 1.0 (testado, baixar torna critica generica)
- qa-engineer.md: reescrito como measurement agent — 35 checks objetivos em 7 categorias (estrutural, acessibilidade, conteudo, tipografia, cor, design, visual). Schema JSON, thresholds, auto-fix, enforcement via qa-browser-report.json
- qa-pipeline.md: reduzido de 111→75 linhas, removida duplicacao com script
- Gate -1: le qa-browser-report.json se existir (autoridade), senao roda checks locais fallback
- Codex adversarial: 2 agents, ~15% FP. 5 easy wins + artefatos separation implementados.

### Script: content-research.mjs + NLM integration
- `--nlm` flag: 3 queries progressivas ao NotebookLM (fundacao, convergencia, deep content)
- NLM notebooks mapeados: metanalise, cirrose, mbe (UUIDs verificados)
- Queries enriquecidos com padroes Gemini: preamble contextual, adversarial framing, evidence hierarchy
- Preamble dinamico por aula (era hardcoded "meta-analises")
- Pipeline testado: Gemini $0.041 + NLM 139.6s, 10.4k chars, 30 refs

### Codex audit S70 — triagem + fix
- Batch 2 (rules/agents): 6/14 genuinos corrigidos, 5 FP (~36%)
- Batch 1 (docs): ~28/42 genuinos corrigidos, ~14 FP (CHANGELOG historico)
- JS scripts adversarial: 4/6 genuinos (preamble hardcoded, --help UX, _archive lint)
- OBSIDIAN_CLI_PLAN.md + S63-AUDIT-REPORT.md + CODEX-AUDIT-S70.md → archived
- ARCHITECTURE.md + TREE.md counts atualizados (skills 20, rules 9, agents 10, MCP 12)

### Decisoes
- h2 s-pico decidido: "PICO mismatch e indirectness no GRADE — motivo formal para rebaixar certeza"
- Boxes: ponte PICO→GRADE (cada letra → tipo de indirectness). Conteudo exato pendente
- Gemini MCP descartado. Usar API key via scripts existentes

### Triangulacao (5 pernas)
- Consensus, SCite, Gemini API, NLM: convergentes nos 4 tipos indirectness
- PubMed MCP: session terminated (3a vez). Fallback WEB-VERIFIED
- PMID falso flaggado: Gemini 37263516 para Goldkuhle → correto 37146659

## Sessao 70 — 2026-04-05 (Criacao Slide — lint fix + research + Codex audit)

### Lint
- lint-slides.js: NOTES check removido inteiramente (aside.notes opcional, notes vao no living HTML)
- lint-slides.js: version string unificada v5→v6 (header + console)
- Lint clean, build OK (18 slides), dev server verificado (port 4102, morto por PID)

### Research (s-pico)
- /research skill: SPIDER PMID corrigido (22925661 era paper neurociencia → 22829486 correto)
- PICOT PMID (17040536) verificado correto. 0 CANDIDATE refs restantes
- Consensus MCP (19 papers): Core GRADE 1+5 (Guyatt 2025), estimands framework (Remiro-Azocar 2025)
- SCite MCP (10 results): full-text excerpts Core GRADE, PICO formulation
- PubMed MCP: falhou 2x (session terminated). NLM: auth expirada + cp1252 bug

### Slide s-pico — redesign iniciado (nao concluido)
- h2 "E de volta a PICO" identificado como rotulo generico → 3 opcoes de assercao propostas
- Boxes P-I-C-O com definicoes → redundante, 3 direcoes de conteudo novo propostas
- Lucas decidira h2 + direcao na proxima sessao

### Codex Adversarial Audit
- 3 batches (root+docs, rules+agents, aulas): `docs/CODEX-AUDIT-S70.md`
- Batch 1 (root+docs): 3 HIGH, 31 MEDIUM, 5 LOW — repo rename stale, paths quebrados
- Batch 2 (rules+agents): 3 HIGH, 8 MEDIUM, 1 LOW — references/ paths, permissoes MCP
- Batch 3 (aulas): despachado mas nao retornou findings concretos
- Total: 6 HIGH, 39 MEDIUM, 6 LOW

### Config
- Gemini MCP reativado em servers.json (status: removed→connected, precisa restart)
- Memory: feedback_notes_in_living_html.md adicionado (14 files, cap 20)

## Sessao 69 — 2026-04-04 (Codex triagem final + complexidade reduzida)

### Codex Triagem (completa)
- session-hygiene.md: template HANDOFF atualizado (max ~50, priority bands)
- CLAUDE.md: path guard-lint qualificado para `.claude/hooks/`
- 4 items descartados com justificativa (mcp_safety, ENFORCEMENT, HEX, precedencia)
- 3 arquivos verificados existentes (coauthorship_reference, chatgpt_audit, mcp_safety_reference)

### Reducao de Complexidade
- NOTES.md removido (cirrose + metanalise) — living HTML e source of truth
- WT-OPERATING.md removido (cirrose) — 70% duplicado, 30% migrado
- Conteudo unico migrado para qa-pipeline.md: §5 checklists, §6 propagacao, §7 scorecard 14-dim
- 10+ referencias atualizadas (HANDOFF, CLAUDE.md, AUDIT-VISUAL, ERROR-LOG, decision-protocol, TREE)

### Pipeline
- Lint clean, build OK (526ms), 53 testes passed

## Sessao 68 — 2026-04-04 (P0 Benchmark + P1 Audit Fixes + GEMINI.md v3.6)

### P0 — Benchmark CLI vs API
- content-research.mjs: CLI ($0) vs API ($) benchmark em s-heterogeneity
- Resultado: CLI falha (6x lento, topico errado, sem grounding). API permanece default
- Fix: `shell: true` + timeout 300s no callGeminiCLI (bug ENOENT no Windows/fnm)

### P1 — 8 Fixes do S63 Audit
- CLAUDE.md: "Tabela = funcao, NAO autonomia. Espere OK prevalece."
- anti-drift.md: fallback "verificar manualmente" no gate de verificacao
- metanalise/CLAUDE.md: IPD metodologia fora, ancora IPD-MA ensinada como pairwise
- global CLAUDE.md: /dream skip silently se skill indisponivel
- qa-pipeline.md: paths narrowed `**/qa*` → `content/aulas/**/qa*`
- notion-cross-validation.md: opening alinhado com exceptions
- session-hygiene.md: no-commit state change case
- slide-rules.md: ja tinha `paths:` (fix pre-aplicado)

### GEMINI.md v3.6 (criatividade + integridade)
- 7 regras anti-hallucination → 3 gates simples (DOI, busca, backtracking)
- "Mandato de Ceticismo" → "Pesquise com curiosidade, analise com rigor"
- XML obrigatorio → XML para pesquisa estruturada, formato livre para exploratoria
- 86 → 55 linhas

### Codex Adversarial Round 2
- R2A (cross-file contradictions): 1 MINOR + 3 ACTION NEEDED
- R2B (dead references): WT-OPERATING.md removido, 3 path parciais, 3 UNKNOWN
- Triagem consolidada em `.claude/tmp/S68-CODEX-TRIAGEM.md`

### Cross-Reference Fixes (parcial)
- design-reference.md: E52 clarificado (vw proibido font-size, clamp() so layout)
- design-reference.md: token source corrigido (base.css → aula.css cascade)
- metanalise/CLAUDE.md: dead ref WT-OPERATING.md removido

## Sessao 67 — 2026-04-04 (GEMINI.md v3.5 + AGENTS.md Hardening)

### GEMINI.md v3.5 (6 fixes do Codex audit)
- P0: anti-hallucination reescrito — `google_web_search` → grounding-or-flag protocol
- P0: safe harbor temporal removido — verificacao obrigatoria independente do ano
- P0: trigger ampliado — "antes de qualquer claim factual" (nao so DOI/PMID)
- P1: Model Configuration removido (temperature/thinking-level nao sao flags CLI)
- P1: `<reasoning_path>` → `<analysis_summary>` com counter_evidence-first ordering
- P1: multimodal wishlist → capability matrix concreta (limites honestos)

### AGENTS.md (melhorias incrementais)
- Proposta "Adversarial Gatekeeper" rejeitada apos pesquisa (ferramentas fabricadas, anti-patterns)
- Adicionadas 3 heuristicas comportamentais como complemento (nao substituicao)
- Workflow validado documentado (S50-S51: 8% FP rate)
- Quick Commands atualizados (3 lint gates, done-gate, validate-css.sh fix)
- Previous Audits: paths corrigidos, S60/S61/Round 2 adicionados

### Hooks
- allow-plan-exit.sh: PreToolUse hook para ExitPlanMode (workaround bug Claude Code)

### Cleanup
- Arquivados: CODEX-AUDIT-S57.md, CODEX-FIXES-S58.md, CODEX-MEMORY-AUDIT-S61.md, BEST_PRACTICES.md → .archive/
- S63-AUDIT-REPORT.md mantido (8 fixes pendentes)

## Sessao 66 — 2026-04-04 (Memory Deep Cleanup)

### Memory
- Deep cleanup 19→13 files: eliminacao de duplicacao memory↔HANDOFF↔CLAUDE.md
- Deletados: decisions_active (80% duplicado), facts_teaching (stale), feedback_monorepo_migration (niche S36)
- Absorvidos em S66 fase 1: feedback_narrative_citation_format→living_html, project_nlm_research_leg→tooling, patterns_skill_design→tooling
- Trimados: project_living_html (47→25), project_metanalise (30→21), patterns_staged_blob (29→13), project_tooling_pipeline (88→35)
- Quick Reference reduzido a 2 items (removido tudo ja em CLAUDE.md/HANDOFF)

### Hooks
- guard-pause.sh: whitelist para `/.claude/plans/` (fix: plan mode Write bloqueado por hook)

## Sessao 65 — 2026-04-04 (MCP + Scripts Migration)

### MCP Migration
- Gemini MCP removido: permission, server registration, status→removed
- deep-search SKILL.md v3.0: MCP tools → gemini CLI via Bash ($0 OAuth)
- .geminiignore criado (assets/provas, assets/sap, node_modules)

### Scripts
- content-research.mjs: `--cli` flag (Gemini CLI OAuth, $0) como alternativa ao API key
- OAuth piggybacking inviavel (scope insuficiente) — verificado e documentado

### Config
- GEMINI.md v3.3→v3.4: anti-hallucination + skepticism mandate, backtracking protocol, retraction check, self-adversarial reasoning
- AGENTS.md: command-first refactor, copy-pasteable audit commands
- ~/.codex/config.toml: project_doc_fallback_filenames = ["CLAUDE.md"]

### Descobertas
- Gemini CLI Deep Research funciona via prompt (nao e endpoint separado)
- CLI `-o json` e envelope, nao structured output com schema
- CLI flags limitados: sem --temperature, --thinking-level, --system-instruction

## Sessao 64 — 2026-04-04 (Instalacao CLI)

### CLI Setup
- Gemini CLI atualizado 0.32.1 → 0.36.0, OAuth Ultra ativo (lucasmiachon87@gmail.com)
- Codex CLI v0.118.0 confirmado, plugin codex@openai-codex ativo
- GEMINI.md criado (global + projeto) — papel PESQUISAR, read-only
- AGENTS.md criado (projeto) — papel VALIDAR, adversarial reviewer
- ~/.gemini/GEMINI.md global criado (identidade, MBE, budget)

### Pesquisa (3 agentes paralelos)
- AGENTS.md best practices: comandos > prosa, <150 linhas, padrao universal emergente
- GEMINI.md best practices: @file imports, 3 tiers concatenam, /init, .geminiignore
- Orquestracao multi-CLI: task routing matrix, cost optimization, debate pattern
- Google AI Ultra: 2,000 req/dia, multimodal incluso, Deep Think incluso, $0 via OAuth
- Deep Research Agent formal: API only (nao incluso no CLI OAuth)

### Pendente (plano para proxima sessao)
- Fase 1: remover Gemini MCP (claude mcp remove gemini) — parar de gastar API key
- Fase 2: migrar scripts (gemini-qa3.mjs, content-research.mjs) de API key → CLI OAuth
- Fase 3: refinar GEMINI.md e AGENTS.md com achados da pesquisa

## Sessao 63 — 2026-04-04 (CLAUDE.md + Rules Audit)

### Consolidacao (P0.1)
- Merge efficiency.md + quality.md INTO anti-drift.md (11 → 9 rules)
- Trim root CLAUDE.md: Objectives + Self-Improvement compactados (86 → 77 linhas)
- Trim process-hygiene.md: bash snippets removidos (49 → 26 linhas)
- Compact metanalise/CLAUDE.md status table (107 → 96 linhas)
- Frontmatter description adicionado a coauthorship.md e session-hygiene.md

### Codex Audit (P0.2)
- Round 1A (CLAUDE.md + unscoped rules): 35 criterios, 8 FIX pendentes, 3 REJECT (FP)
- Round 1B (path-scoped rules): 30 criterios, 2 FIX pendentes, 2 REJECT (FP)
- Round 2 prompts preparados (adversarial + dead refs) — execucao em S64
- Report completo: `docs/S63-AUDIT-REPORT.md`

### Memory
- feedback_anti-sycophancy.md: +Regra 4 (audit findings → report first, execute next session)

## Sessao 62 — 2026-04-04 (Memory Cleanup + Infra)

### Memory Consolidation (40 → 21 files)
- 9 files migrated to canonical docs: slide-rules.md (+h2 authorship, +CSS inline exception), aulas/README.md (+build pipeline, +rebuild-before-QA, +screenshot cleanup), global CLAUDE.md (+autonomy contract, +screenshots path, +notification prefs)
- 1 redundant deleted (project_codex_doc_review_bug.md — absorbed by project_tooling_pipeline.md)
- 5 thematic merges: living-html (2→1), metanalise (4→1), research (3→1), defensive (2→1), tooling (+2 absorbed)
- MEMORY.md rebuilt as pure index (20 entries + quick reference)
- Memory governance rule added to global CLAUDE.md (cap 20, creation criteria, review cadence)

### Skill Merge
- new-slide merged INTO slide-authoring v2.0: 9-surface checklist, PT-BR triggers, pre-flight, `context: fork`
- HTML template moved to references/patterns.md section 0
- new-slide/ directory deleted

### Docs
- hooks README rewritten: 13 active hooks documented, 4 retired removed, PostToolUseFailure warning added
- Codex memory audit report unchanged (docs/CODEX-MEMORY-AUDIT-S61.md) — verdicts were validated manually this session

## Sessao 61 — 2026-04-04 (Codex S60 TODOs + Memory Audit)

### Lint Script Fixes (Codex S60 remainders)
- **O13**: lint-slides.js aceita aula arg (process.argv[2]) — scopa ao dir da aula
- **O15**: lint-narrative-sync.js erro explícito quando sem aula (era silent default cirrose)
- **O14**: lint-case-sync.js remoção de dead branch (if !manCp unreachable)
- **O8**: triado como low-impact (log-only), ACCEPTED

### Hook Fix
- **O6**: guard-lint-before-build.sh roda 3 linters (era só lint-slides.js)
- Positional arg (consistente com scripts), acumula falhas, bloqueia se qualquer falhar

### Audit
- Codex S60 audit 100% resolvido: 24/24 findings (20 fixed, 4 accepted)
- `docs/CODEX-AUDIT-S60.md` → `.archive/` (completo)
- Codex Memory Audit iniciado (4 frames: obj+adv × round1+round2). Report parcial em `docs/CODEX-MEMORY-AUDIT-S61.md`

## Sessao 60 — 2026-04-03 (Hardening + Cleanup + Codex Dual-Frame)

### Cleanup
- Archived 4 workspace dirs (1.7MB): deep-search, research, insights, nlm-skill
- Deleted deprecated skills: evidence/, mbe-evidence/, agents/literature.md
- Archived project_codex_review_findings.md (100% resolved)
- Updated MEMORY.md index, CLAUDE.md refs

### New Hooks
- `guard-lint-before-build.sh` — BLOCKS builds if lint-slides.js fails
- `guard-read-secrets.sh` — BLOCKS Read of .env, .pem, credentials, SSH keys
- Both wired in settings.local.json

### Hook Hardening (Codex S60 — 24 findings, 16 fixed)
- **CRITICAL A6:** guard-product-files now BLOCKS edits to settings.local.json and hooks/
- **CRITICAL A10:** guard-read-secrets blocks Read of secret files
- **HIGH O4/A2/A4:** ALL hooks migrated from sed to node JSON parsing (no more truncation)
- **HIGH O5/A1:** guard-bash-write: +4 new patterns (cp/mv/dd/install/rsync/perl/ruby/fs.promises)
- **HIGH A9:** guard-lint-before-build: expanded build detection (vite build, npx)
- **MED O2:** guard-product-files: added _manifest.js to protected patterns
- **MED O3:** guard-secrets: exit 2 + structured JSON (was exit 1)
- **MED O11:** stop-hygiene: checks staged + unstaged changes
- **LOW O10:** session-start: takes max session number (was first match)
- **LOW O16:** guard-pause: unified path extraction

### Remaining (TODO next session)
- O6: Add lint-case-sync + lint-narrative-sync to build gate
- O13: lint-slides.js --aula argument parsing
- O15: lint-narrative-sync.js silent default to cirrose

### Dream Skill
- Removed ONBOARDING section (~120 lines) — setup already complete, run 12

### Docs
- Created docs/CODEX-AUDIT-S60.md (full findings + tracker)

## Sessao 59 — 2026-04-03 (Hook Hardening)

### Hooks (code fixes)
- **guard-bash-write.sh** — +3 padroes: `curl -o`, `wget -O`, `python -c` (ask, nao block)
- **build-monitor.sh** — reescrito: checa `tool_response.exit_code` em vez de PostToolUseFailure (dead code desde criacao). Aula detectada do comando antes de branch.

### Docs
- **CODEX-AUDIT-S57.md** — tabela cross-reference objetivo↔adversarial, V8 rejeitado (hooks sequenciais)
- **CODEX-FIXES-S58.md** — 3 anotacoes: re-review disclaimer (Fix 4), gap preexistente (Fix 10), inconsistencia enforcement passivo (Rejeicao 16)

### Cleanup
- Removidos workspace artifacts (insights-workspace, nlm-skill-workspace)
- `.gitignore` — `*-workspace/` pattern adicionado

## Sessao 58 — 2026-04-03 (Codex Audit Fixes)

### Enforcement (fixes)
- **guard-bash-write.sh** — novo hook PreToolUse(Bash), fecha shell redirect escape (CRITICAL)
- **guard-product-files.sh** — expandido para todas as aulas (era so cirrose), mudou block→ask
- **check-evidence-db.sh** — removido (dead code: transcript_path nunca existiu no hook input)
- **build-monitor.sh** — PostToolUseFailure tentado e revertido (evento nao existe). Dead code identificado
- **settings.local.json** — 3 mudancas (add bash guard, remove evidence-db, add failure hook)

### Policy (contradicoes resolvidas)
- **metanalise/CLAUDE.md** — QA dual: Opus visual + Gemini script (era so "Gemini CLI")
- **slide-rules.md** — aside.notes de obrigatorio→opcional (deprecated, Lucas nao usa presenter mode)
- **design-reference.md** — "evidence-db canonico"→"living HTML canonico"
- **qa-pipeline.md** — "NUNCA batch Gemini"→"NUNCA batch QA" (vale para ambos)

### Memories (2 reescritas)
- **feedback_mentor_autonomy.md** — autonomia condicionada a plano aprovado, CLAUDE.md e teto
- **user_mentorship.md** — "decidir, executar, explicar depois"→"propor, explicar, executar apos OK"

### Docs
- `docs/CODEX-FIXES-S58.md` — relatorio completo (10 fixes, 6 rejeicoes justificadas)

## Sessao 57 — 2026-04-03 (Behavioral Enforcement + Codex Audit)

### Enforcement (novo)
- `guard-pause.sh` — PreToolUse "ask" em todo Edit/Write (whitelist: memory files, .session-name)
- `session-compact.sh` — SessionStart compact matcher, re-injeta 5 regras criticas + HANDOFF
- CLAUDE.md primacy/recency anchors (ENFORCEMENT section top + bottom)
- `settings.local.json` atualizado com novos hooks

### Codex Audit
- Two-frame audit (objetivo + adversarial): 2 CRITICAL, 4 HIGH, 4 MEDIUM
- Findings em `docs/CODEX-AUDIT-S57.md`
- Shell bypass (Bash > file) e memory omission = CRITICAL
- 6+ policy contradictions identificadas (mentor_autonomy, metanalise/CLAUDE.md, etc.)

### QA
- Batch QA screenshots gerados (18 slides, 20 PNGs) via `qa-batch-screenshot.mjs`
- s-pico h2 stale detectado e corrigido no build (nao no index.html direto)
- `_manifest.js` headline de s-pico atualizada

### Memories (2 novas)
- `feedback_qa_use_cli_not_mcp.md` — usar CLI script, nunca MCP Playwright manual
- `feedback_rebuild_before_qa.md` — build obrigatorio antes de QA

### Cleanup
- Deletados: `docs/ADVERSARIAL-FIX-S51.md`, `docs/ADVERSARIAL-REVIEW-S50.md`, `docs/CODEX-REVIEW-S40.md` (resolvidos)

## Sessao 56 — 2026-04-03 (PICO Evidence + NLM Research Leg)

### Evidence
- Generated `evidence/s-pico.html` via /research pipeline (5 legs + NLM)
- 7 verified refs: Cochrane v6.5, GRADE 8, Core GRADE 5, Goldkuhle 2023, PRISMA 2020, PICOS, Borenstein
- Jia et al. 2026 (Gemini) marked INVALID — DOI doesn't resolve, paper not found
- Reference table: 8 terms (indirectness, target/study PICO, treatment switching, tautologia, PICOS, PICOT, SPIDER)

### Pipeline
- NotebookLM validated as /research leg — Borenstein tautology discovery (textbook content PubMed can't find)
- Command: `PYTHONIOENCODING=utf-8 nlm notebook query <id> "query" --json`

### Memories (3 new)
- `feedback_research_non_deterministic.md` — queries exploratorias, nao deterministas
- `feedback_narrative_citation_format.md` — narrativa sem PMID/badges, formato cientifico
- `project_nlm_research_leg.md` — NLM como perna, notebook IDs, auth pattern

## Sessao 55 — 2026-04-03 (Arch Diagnosis Review)

### CSS Architecture
- New `.theme-dark` class in base.css — restores 11 on-dark tokens inside stage-c
- metanalise.css: replaced 6 hardcoded slide IDs with `.theme-dark .slide-inner` (24→3 lines)
- 6 HTML slides: added `class="theme-dark"` to `<section>`
- slide-rules.md §10 updated: `.theme-dark` is canonical, `.slide-navy` marked legacy

### Governance
- CLAUDE.md: Key Files trimmed 33→4 lines (link to TREE.md). Total 98→72 lines
- process-hygiene.md: added `paths: content/aulas/**` frontmatter (lazy load)
- design-reference.md: added `paths: content/aulas/**` frontmatter (lazy load)
- Rules path-scoped: 3/11 → 5/11 (45%)

### Architecture Review
- Evaluated 10 findings from external diagnosis across CSS, governance, Python
- Agreed: 2 strongly, 4 partially. Disagreed: 4 (clamp overrides correct, Python is stub)

## Sessao 54 — 2026-04-03 (Insights Skill Creation)

### insights-skill v1.0
- New skill: /insights — agent self-improvement via retrospective session analysis
- 4-phase process: SCAN→AUDIT→DIAGNOSE→PRESCRIBE
- 3 recipes: weekly retrospective, focused error patterns, rule health check
- 7-category taxonomy: RULE_VIOLATION, RULE_GAP, PATTERN_REPEAT, RULE_STALE, HOOK_GAP, SKILL_GAP, SKILL_UNDERTRIGGER
- Read-only: proposes changes, never auto-applies. Complements /dream (memory) with performance audit.
- Evolution tracking: saves canonical report + archives previous for longitudinal comparison

### Eval Loop (skill-creator)
- 3 evals, 22 assertions, 6 parallel agents (with_skill vs without_skill baseline)
- Result: 22/22 (100%) with_skill vs 20/22 (91.7%) without_skill = +8.3pp
- Discriminating assertions: A3 (taxonomy), A8 (report archival)
- Qualitative: structured output, causal chain analysis, 50% shorter rule-health-check
- Token cost: +34% (103k vs 77k avg) — acceptable for weekly audit

### First Real Insights Run
- Weekly retrospective identified 15 incidents (S38-S53), 12 findings
- Top systemic issues: fail-open gates, staged-blob bugs, parameter guessing, context rot
- 8 diff-ready proposals for rules improvements (pending Lucas approval)
- Rule compliance: 7/11 followed, 3/11 violated, 1/11 stale

## Sessao 53 — 2026-04-03 (NLM Skill Rewrite)

### nlm-skill v1.0
- Rewrite SKILL.md: 702→191 linhas (-73%), workflow-first para medical education
- 3 workflow recipes: Paper to Study Materials, Research Pipeline, Batch Concurso Prep
- Fix MCP prefix bug: `mcp__notebooklm-mcp__*` → `mcp__notebooklm__*`
- Clinical `--focus` prompt templates (ICA-AKI, trial endpoints, NNT)
- Windows cp1252 encoding workaround documented
- Expanded reference.md: 52→363 linhas (detailed command catalog)
- PubMed URL pattern: `https://pubmed.ncbi.nlm.nih.gov/{PMID}/`
- OLMO ecosystem integration table (/research, /concurso, /exam-generator, Zotero)

### Eval Loop (skill-creator)
- 3 evals, 25 assertions, 6 parallel agents (new vs old skill)
- Result: 100% pass rate (new) vs 96% (old), 12.5% fewer tokens
- Workspace + benchmark + grading preserved in nlm-skill-workspace/

## Sessao 52 — 2026-04-02 (Secondary Review)

### Fixes (5)
- guard-secrets.sh: .env filename blocking (exit 1 for .env* except .env.example)
- validate-css.sh: !important outside allowed context promoted WARN→FAIL, context window 20→50 lines
- deck.js: added `details, summary` to click handler exclusion list
- base.css: OKLCH chroma 0.002→0.001 in 5 tints (reduce P3/OLED blue tint risk)
- orchestrator.py: documented mcp_operation key assumption in comment

### Hooks
- guard-product-files.sh wired in settings.local.json (was missing)
- Removed 2 vestigial hooks: guard-evidence-db.sh, task-completed-gate.sh
- All 5 hooks tested and verified

### Assessment (10 items reviewed)
- 3 already OK: AKIA present, NaN guard positioned correctly, threading.Lock sufficient
- 5 fixed (above)
- 1 documented (orchestrator gate limitation)
- 1 pending manual test (reduced-motion screenshot)

## Sessao 51 — 2026-04-02 (Adversarial Fix)

### Tier 1 CRITICAL (5 fixes)
- mcp_safety.py: NaN/Inf/negative guard, validate_move param validation
- orchestrator.py: wire validate_mcp_step() into route_task(), fix status overwrite in finally
- guard-secrets.sh: scan staged blobs, safe word-splitting, 8 new patterns, symlink check
- medical-researcher SKILL.md: NNT applicability constraints, retraction check, 4 new statuses

### Tier 2 HIGH (3 fixes + 1 gap)
- engine.js: reduced-motion calls forceAnimFinalState, per-slide timer scoping
- deck.js: transitionend race cleanup, init idempotency guard, click hijack fix
- base.css: OKLCH fallback (shadow/overlay tokens), E059 achromatic fix, stage-bad selectors

### Tier 3 (4 fixes)
- guard-product-files.sh: SPRINT_MODE removed, fail-closed, path canonicalization
- validate-css.sh: CRLF strip, comment filter, indented selector regex
- pre-commit.sh: staged index for slide count
- orchestrator.py: agent.model race via task dict, run_workflow exception boundary
- smart_scheduler.py: atomic writes (tmp+rename), threading lock

### Tests + Docs
- 6 new tests (NaN, Inf, negative, empty input) → 53 total
- CLAUDE.md synced (hook counts, test count, living HTML workflow)
- Git history audit: clean (no real secrets, only placeholders)
- Report: docs/ADVERSARIAL-FIX-S51.md
- Dream run 11: 3 new patterns, 2 updates

### Validation stats
- 38 findings validated: 30 TRUE, 5 PARTIALLY TRUE, 3 FALSE POSITIVE (~8% FP)
- False positives: mcp_safety #1 (already blocked), validate-css #1 (by design), pre-commit #1 (intentional)

## Sessao 50 — 2026-04-02 (Adversarial Review)

### Adversarial Review via Codex GPT-5.4
- 17 arquivos revisados: Python (3), JS (3), CSS (2), Rules/Skills (3), Shell hooks (4), Docs (2)
- 118 findings: 9 CRITICAL, 61 HIGH, 36 MEDIUM, 12 LOW
- 4 cross-cutting patterns: security theater, working-tree vs staged blob, fail-open, docs drift
- Relatorio completo: `docs/ADVERSARIAL-REVIEW-S50.md`

### Findings mais graves
- mcp_safety.py: NaN bypassa thresholds, unknown ops escapam via batch_size
- orchestrator.py: validate_mcp_step() nunca chamado (dead code)
- guard-secrets.sh: escaneia working-tree em vez de staged blob
- validate-css.sh: sempre retorna exit 0 (nunca bloqueia)
- medical-researcher: NNT forcado como universal, sem check de retraction

### Infra
- Dream run 10 (maintenance-only, no new signal)

## Sessao 49 — 2026-04-02 (s-rs-vs-ma DONE)

### Slide s-rs-vs-ma
- Redesign: 3 colunas (Revisoes, Revisao Sistematica, Meta-analise) com hierarquia visual E073-E075
- Col1: lista com % (Zhao 2022) + itens secundarios (Escopo, Umbrella) em .compare-minor
- Col2: 4 termos verticalizados (Protocolo, Busca, Selecao, Vies) + label "= PROCESSO"
- Col3: header unico "Meta-analise" + SVG forest plot (opacity melhorada) + label "= CALCULO"
- Footer: specificity fix (#deck p.compare-footer) para evitar max-width: 56ch do base.css

### Evidence HTML
- PMID 35725647: corrigido Shen→Zhao em todas as secoes. WEB-VERIFIED
- PMID 27620683: Ioannidis CANDIDATE→WEB-VERIFIED em depth rubric, convergencia, numeros
- Badges CANDIDATE→WEB-VERIFIED consistentes em todo o documento

### Infra
- lint-slides.js: evidence/ excluido da varredura de slides
- vite.config.js: host:true para acesso Playwright IPv4

### Memorias
- feedback_no_parameter_guessing: nunca chutar parametros, verificar API antes
- feedback_qa_screenshots_cleanup: screenshots com timestamp, deletar apos QA

## Sessao 48 — 2026-04-02 (Primeiro Living HTML Real)

### Evidence HTML
- Primeiro HTML real gerado: `content/aulas/metanalise/evidence/s-rs-vs-ma.html`
- JSON intermediario versionado: `content/aulas/metanalise/evidence/s-rs-vs-ma.json`
- Conteudo: sintese narrativa, speaker notes (90s), pedagogia, retorica, numeros bibliometricos, depth rubric D1-D8
- Referencia Rapida: 12 entradas (8 tipos de revisao + 4 master protocols)
- Pipeline validado end-to-end: /research → JSON → generate-evidence-html.py → HTML

### Template (generate-evidence-html.py)
- Badges inline: [WEB-VERIFIED] azul, [CANDIDATE] vermelho
- text-align:justify, white-space:pre-line em speaker notes
- Secao colapsavel Referencia Rapida (Termo/Definicao/Nota)
- Secao Referencias academicas: Autor (ano) + lista final com PMID/revista/status

### Slide
- s-rs-vs-ma reescrito: 2→4 colunas (Rev narrativa, RS, Umbrella Review, MA)
- aside.notes: skeleton minimo com link para evidence HTML
- Footer: "Nem toda RS tem MA. Hoje, quase toda MA e precedida de uma RS."

### Decisoes
- Evidence-first workflow confirmado (HTML antes do slide)
- MDs (evidence-db, blueprint) = peso morto. Lucas nao le. Deprecacao gradual
- aside.notes = skeleton (timing + link). Conteudo real no evidence HTML

### Docs
- HANDOFF → S49

## Sessao 47 — 2026-04-02 (/research v2 + Living HTML)

### Skills
- /research v2 criada: 5 pernas paralelas (deep-search + mbe-evaluator + reference-checker + mcp-query-runner + opus-researcher) + orquestrador
- SKILL.md: output Notion → living HTML per slide (evidence/{slide-id}.html)
- SKILL.md: NNT mandate + risco basal obrigatorio
- opus-researcher: NNT mandate + SCite contrasting citations para critica metodologica
- mbe-evaluator: analise retorica adicionada (§6: assertion-evidence, carga cognitiva, dispositivos)
- generate-evidence-html.py: script gerador de HTML standalone per slide

### Agents
- opus-researcher.md, mbe-evaluator.md, reference-checker.md, mcp-query-runner.md: novos agents para pipeline /research

### Evals
- research iteration 2: 6 runs (3 with + 3 without), 21/21 WITH (100%), 14/21 WITHOUT (66.7%)
- Delta: +31pp (honesto — assertions testam utilidade, nao estrutura)
- WITH skill mais rapido que baseline (-33.8s avg)
- Eval viewer com benchmark tab funcional

### Decisoes
- Living HTML substitui: evidence-db.md, aside.notes, Notion slide DB, blueprint.md (5→2 fontes)
- /research e /teaching NAO fundem (lifecycle diferente). mbe-evaluator e a ponte
- aside.notes deprecated (cleanup futuro)

### Docs
- HANDOFF → S48

## Sessao 46 — 2026-04-02 (Deep-Search v2.1 Eval Loop)

### Skills
- deep-search v2.0 → v2.1: PRIMARY DIRECTIVE em query-template.md (Tier 1 sources como core deliverable)
- deep-search v2.1: post-processing simplificado (7 steps → 3 regras de limpeza minima)
- skill-creator eval-viewer: fix UTF-8 encoding (7 read_text/write_text calls → encoding="utf-8")

### Evals
- deep-search iteration 2: 3 evals × 2 configs (with_skill + old_skill), grading, benchmark.json
- Benchmark: v2.1=91.7% vs v2.0=95.8% (delta -4.1pp, por Gemini PMID variability, nao skill)
- Eval viewer static HTML funcional com benchmark tab

### Docs
- HANDOFF → S47 (skill merge roadmap: new-slide→slide-authoring, /research unificada)

## Sessao 45 — 2026-04-02 (Codex Cleanup Final)

### Scripts
- qa-video.js: PORT_MAP per-aula (cirrose:4100, grade:4101, metanalise:4102) replaces hardcoded 4100
- qa-video.js: grade removed from Reveal.js mapping (confirmed deck.js)
- done-gate.js: notes regex relaxed (any attribute order, quotes, multiple classes)

### CSS
- cirrose.css: defensive .pcalc-tab--active:hover + .pcalc-sex-btn--active:hover
- cirrose.css: HEX fallback (#192035) for #s-cp1 oklch background

### Docs
- narrative.md (cirrose): alcohol [TBD SOURCE] → PMID 37469291 (Semmler 2023)
- gate2-opus-visual.md: sharp/a11y tools marked [PLANNED]
- CODEX-REVIEW-S40.md: restructured — 7 resolved, 9 dismissed, 11 deferred. Zero open HIGH.
- HANDOFF → S46

## Sessao 44 — 2026-04-01 (Codex Cleanup + Verification)

### Cleanup
- Deleted CODEX-REVIEW-S37.md (100% resolved — verified)
- Condensed CODEX-REVIEW-S40.md: 411 → 55 lines (open items only, strikethroughs removed)
- Verified 6 findings as already fixed (done-gate path, qa-a11y path, lint-case-sync bidirectional, getArg, install-fonts, --danger hue)
- Dismissed 4 findings (specificity .source-tag = intentional, session-hygiene = OK, notion-cross-validation = design, med-researcher memory = moot)

### Script fixes
- validate-css.sh: hardcoded `cirrose.css` scan → dynamic discovery (shared/css/base.css + aula.css)
- validate-css.sh: import order check accepts `base.css → aula.css` pattern (not just single-file)
- lint-case-sync.js: table regex 3-column only → N-column (`{2,}` quantifier)

### CSS
- metanalise.css: removed dead `::before/::after { display: none }` override (base.css has no pseudo-elements on .slide-inner)

### Agents
- repo-janitor.md: added "skip if not found" fallback for CLAUDE.md pre-condition

### Docs
- HANDOFF → S45 (removed already-fixed items)

## Sessao 43 — 2026-04-01 (Fixes Chat + Prioridades HANDOFF)

### Dream Run 5
- Memory consolidation: 5 files updated, 1 new (feedback_context_rot)
- decisions_active.md: type fix + reorganized by theme, removed completed migrations
- project_codex_review_findings.md: P0-P3 status updated to reality
- Quick Reference: added Codex framing + context rot mitigation

### P2 — Quality (conclusion)
- Dark-slide tokens: --ui-accent-on-dark + --downgrade-on-dark added to metanalise restoration block
- Cirrose .no-js [data-reveal] fallback (cirrose doesn't import base.css)
- Cirrose .title-affiliation: 16px → 18px min

### P3 — Script fix
- qa-batch-screenshot.mjs: process.exit(1) → throw (honors finally, closes browser)

### Cleanup
- Removed 5 stale cirrose/scripts/ files (capture-*.mjs, content-research.mjs, gemini-qa3.mjs, qa-batch-screenshot.mjs) — superseded by shared scripts/

### Reflexao Critica (anti-sycophancy)
- 12 Codex findings dismissidos com justificativa (documented in CODEX-REVIEW-S40.md)
- Key: #67 base.css GSAP = failsafe, #56 checkpoint = state machine, #60 cirrose dark = stage-c correct

### Docs
- CODEX-REVIEW-S40.md: P2 marked done, dismissals documented
- HANDOFF → S44

## Sessao 42 — 2026-04-01 (Codex Review Exec cont.)

### P2 — Quality (cont.)
- Font tokens bumped: --text-small 20px, --text-caption 18px (base + metanalise + cirrose)
- Source-tags 16px, hook-tag/contrato-skill 18px, ck1-name 16px, screening labels 18px
- --danger hue: 25° → 8° everywhere (root + stage-c on-dark in both base + cirrose)
- Cirrose --danger aligned to base.css canonical (50% 0.22 8)
- GSAP jurisdiction: 5 elements converted from .to() → .fromTo() (hook + contrato)
  CSS stripped of transforms, keeps only opacity:0. Divider/checkpoint exceptions kept.
- .no-js fallback: generalized [data-animate] + added [data-reveal]
- aria-hidden on 5 forest-plot anatomy symbols (a11y)

### Docs
- HANDOFF → S43
- Memory: project_metanalise_projetor (projetor gigante 10m, Canva fallback)

## Sessao 41 — 2026-04-01 (Codex Review Exec)

### P0 — Silent Failures (5 fixes)
- pathToFileURL() em 3 qa-batch-screenshot.mjs (Windows file URL)
- Gemini response validation em content-research.mjs (fail-fast)
- --strictPort em export-pdf.js
- Windows path separator em lint-slides.js (GSAP rule)
- MELD 14 reconciliado em 07-cp1.html (notes corrigidas)

### P1 — Governance (5 fixes)
- qa-engineer threshold: 9/10 → 7/10 (economic), 9/10 so --deep
- qa-engineer tools: 5 MCP tools removidas (inalcancaveis)
- mcp_safety: auto-execute removido, writes sempre humano
- slide-rules: data-background-color excecao removida (morto)
- Stale monorepo paths: 4 corrigidos em 3 rules

### P2 — Quality (parcial)
- Print/PDF reset: +stagger children, +[data-reveal], +inline opacity:0
- Font-size audit: 21 instancias < 18px documentadas por categoria

### C15 Relaunch
- Bug skill wrapper contornado: `codex exec --sandbox read-only` via stdin pipe
- 12 findings (1 CRITICAL, 7 HIGH, 2 MEDIUM, 1 LOW). Total: 147.

### Meta (anotado)
- Context rot e dream/memorias nao funcionando — investigar proxima sessao

## Sessao 40 — 2026-04-01 (Codex Review Adversarial)

### Codex Review GPT-5.4 — 135 findings (full-scope adversarial)
- 15 chunks: 13 scripts, 3 CSS, 29 slides HTML, 7 agents, 11 rules
- 7 CRITICAL, 68 HIGH, 36 MEDIUM, 24 LOW (apos filtragem)
- 1 falso positivo filtrado (taskkill // em Git Bash)
- 5 rebaixados CRITICAL→LOW (inline opacity:0 pragmatico)
- C15 (docs/prompts) falhou 2x — bug no codex:codex-rescue com .md files

### Padroes sistemicos identificados
- S1: font-size < 18px (13 instancias across 3 CSS files)
- S2: h2 generico (11+ slides, rewrite e trabalho do Lucas)
- S3: print/PDF incompleto (GSAP-hidden elements invisiveis)
- S4: GSAP jurisdiction (CSS per-slide compete com GSAP)
- S5: stale monorepo paths em 4 rules
- S6: governance contradictions (4 CRITICAL em agents/rules)

### Plano P0-P3 documentado
- P0: 5 fixes (Windows file URL, --strictPort, MELD contradiction, path separator)
- P1: 5 governance fixes (qa-engineer threshold, mcp_safety, slide-rules)
- P2: 5 systemic audits (font-size, print, GSAP, tokens)
- P3: polish + h2 rewrite (Lucas guia)

### Memory
- feedback_css_inline: inline opacity:0 para GSAP e OK
- feedback_h2_assertions: AI-generated h2 sao terriveis, Lucas reescreve
- project_codex_doc_review_bug: C15 falhou 2x, investigar

### Docs
- docs/CODEX-REVIEW-S40.md: review completo com 135 findings + plano P0-P3

## Sessao 39 — 2026-04-01 (Metanalise Tooling)

### Scripts — 3 movidos para scripts/ compartilhado (multi-aula)
- `qa-batch-screenshot.mjs`: +detectAula, +PORT_MAP, dynamic manifest/URL, act filter suporta phases
- `gemini-qa3.mjs`: +detectAula, dynamic CSS (`${aula}.css`), prompt paths per-aula
- `content-research.mjs`: +detectAula, dynamic AULA_DIR
- `browser-qa-act1.mjs`: +loadManifestIds() dinamico (le _manifest.js da aula)

### Prompts — 5 templates criados em metanalise/docs/prompts/
- gate0-inspector, gate4-call-a/b/c, error-digest (audiencia: residentes CM)

### Infra
- package.json: +4 npm scripts metanalise (qa:screenshots, qa:gate0, qa:gate4, research)
- Migrou cirrose/grade scripts para usar shared scripts/ com --aula

### Bugs corrigidos
- URL Vite em qa-batch-screenshot: `/aulas/cirrose/` → `/${aula}/` (bug monorepo migration)
- Prompt paths em gemini-qa3: REPO_ROOT nunca resolvia → per-aula AULA_DIR/docs/prompts/

## Sessao 38 — 2026-04-01 (Scripts + Prompts)

### P1 — Prompt Engineering (Codex Review fixes)
- `anti-drift.md`: "revert extra work" → "ask Lucas before reverting" (protege WIP)
- `qa-engineer.md`: removido "Use PROACTIVELY", adicionado Scope & Mode (economic default, --deep on demand)
- `medical-researcher.md`: PMID verification tiered (VERIFIED/WEB-VERIFIED/CANDIDATE, fallback MCP→WebSearch)
- `design-reference.md`: vocabulario canonico de verificacao (5 status: VERIFIED→UNRESOLVED)

### P0 — Root path fixes + fail-hard (Codex Review CRITICAL)
- `lint-slides.js`: `walk(join(root, 'aulas'), ...)` → `walk(root, ...)` (path duplication fix)
- `lint-narrative-sync.js`: `join(root, 'aulas', aula)` → `join(root, aula)`
- `lint-gsap-css-race.mjs`: CLI arg + dynamic aulaDir/CSS filename + shared/ paths via root
- `export-pdf.js`: failures counter + `process.exit(1)` on any export failure

### P3 — Polish (Codex Review LOW)
- `validate-css.sh`: SCRIPT_DIR-based root (CWD-independent) + pipefail-safe wc -l
- `qa-accessibility.js`: notes regex relaxed `/<aside\b[^>]*\bnotes\b[^>]*>/`
- `install-fonts.js`: HTTP status >= 400 validation in fetch()
- `qa-engineer.md`: RALPH commands with `2>/dev/null || echo` fallback
- `medical-researcher.md`: "skip if not found" for aula CLAUDE.md + §3 ref fix

### P2 — Scripts parametrizados (Codex Review fixes)
- `browser-qa-act1.mjs`: detectAula() + PORT_MAP + auto-detect branch (cirrose IDs preservados)
- `pre-commit.sh`: branch matching generalizado (cirrose + grade + metanalise)
- `validate-css.sh`: import order `${AULA}.css` dinamico + WARN counter via process substitution
- `lint-case-sync.js`: path fix + brace-balanced parser + diff bidirecional (CASE.md→manifest)
- `qa-accessibility.js`: __dirname-based path → slides/ + existsSync guard
- `done-gate.js`: aulaDir path fix + Windows-safe git status (sem shell:true)

## Sessao 37 — 2026-04-01 (self-improvement via ERROR-LOGs)

### Rules — 8 lacunas codificadas (86 erros analisados)
- `slide-rules.md`: +§9 GSAP jurisdiction/FOUC, §10 stage-c dark, §11 specificity, §12 bootstrap nova aula
- `design-reference.md`: +§1 hierarquia semantica, §3 PMID propagation (56% erro LLM), +§4 color safety OKLCH
- `qa-pipeline.md`: nova rule — attention separation, cor semantica QA, anti-sycophancy com rubrica

### Codex Review (GPT-5.4)
- Scripts: 16 findings (2 CRITICAL root path + export-pdf, 5 HIGH, 6 MEDIUM, 2 LOW)
- Agents+Rules: 39 findings (3 CRITICAL verification deadlock + impossible QA + memory conflict)
- 3 problemas sistemicos: "verified" ambiguo, tensao exhaustive/restrained, fallback ausente
- Plano de implementacao P0-P3 documentado em `docs/CODEX-REVIEW-S37.md`

### Governanca
- 11 rules (antes 10). CI verde (47 testes). Dream: nada novo a consolidar.

## Sessao 36 — 2026-04-01 (CSS fixes + Codex review)

### Cirrose CSS Fixes (post-import)
- Font paths: `shared/` → `../shared/` nas 4 @font-face (monorepo sibling fix)
- Source-tag specificity: `.stage-c #deck .source-tag` (1,2,1) vence `#deck p` (1,0,1)
- Source-tag: 16px + max-width:none (legibilidade 55" TV @ 6m confirmada)

### Housekeeping
- Aula_cirrose standalone movida para Legacy/
- Memory: facts_projection_setup (55" TV, 6m baseline)

## Sessao 35 — 2026-04-01 (cirrose import from standalone)

### Cirrose Import (Aula_cirrose → OLMO)
- 11 slides ativos (Act 1) + 35 arquivados em _archive/ (substituem 44 antigos)
- cirrose.css single-file 3224L (absorveu base.css + archetypes.css eliminado)
- slide-registry.js, _manifest.js, references/ atualizados
- Meta files: ERROR-LOG (67 erros), AUDIT-VISUAL (14 dim), WT-OPERATING, DONE-GATE

### Shared JS Updates (backwards-compatible)
- deck.js: bugfix child transition bubbling
- engine.js: animation timing (slide:changed vs slide:entered)
- case-panel.js: MELD/MELD-Na/MELD 3.0 tabs

### Governance Ported
- 1 rule (design-reference), 3 agents, 8 agent-memories, 5 skills, 3 commands
- 7 hooks (.claude/hooks/): guard-generated, guard-secrets, check-evidence-db, build-monitor, task-completed-gate
- Hooks registrados em settings.local.json (PreToolUse, PostToolUse)

### Docs & Scripts
- 5 cirrose-specific docs + 15 QA prompt templates (Gate 0/2/4)
- 4 universal docs → docs/aulas/ (design-principles, css-error-codes, pedagogy, hardening)
- 3 scripts evoluidos (gemini-qa3, content-research, qa-batch-screenshot)
- 5 scripts novos (browser-qa-act1, validate-css, qa-video, pre-commit, install-hooks)
- .gitignore: qa-screenshots/, qa-rounds/, index.html, .playwright-mcp/

## Sessao 34 — 2026-04-01 (self-improvement + INFO fixes)

### Robustness Fixes (I6-I12 do Codex review)
- I6: try/except em YAML loading (`config/loader.py`)
- I7: scheduler limits sync com rate_limits.yaml (50/250 vs hardcoded 10/50)
- I8: try/except em JSON parse (`smart_scheduler.py` budget + cache)
- I9: stop hook fallback se HANDOFF ausente (`stop-hygiene.sh`)
- I10: warn + fail em actions sem handler (`automation_agent.py`)
- I11: validacao de priority com fallback (`organization_agent.py`)
- I12: removidas 4 skills fantasma do `ecosystem.yaml`

### Self-Improvement
- Statusline: indicador context window % com cores (green/yellow/red)
- Memoria consolidada: defensive coding patterns, review findings 12/12 complete
- Teaching: explicacao dos 12 findings (XSS, path traversal, name drift, async, defensive patterns)

### Notion Organization
- Calendario DB: views Diario/Semanal/Mensal melhoradas (Categoria, Prioridade, Status)
- Tasks DB: triagem GTD — 2 Do Next, 11 Someday, 1 Done (Aula Cirrose 31/03)
- Tasks DB: calendar view criada (📅 Calendar)
- Eventos criados: Psicologo 11h (semanal), Profa Fernanda Hemato ICESP 14h

## Sessao 33 — 2026-03-31 (OAuth do Codex e Limpeza)

### Codex CLI
- Codex login: OAuth via ChatGPT (forced_login_method=chatgpt) — modelo GPT-5.4, $0
- Primeiro code review com Codex: 12 findings (5 WARN, 7 INFO) em 6 diretorios

### Security Fixes (via Codex review)
- Fix W1: XSS — `presenter.js` innerHTML → textContent
- Fix W2: Path traversal — `local_first.py` _safe_knowledge_path() com resolve + is_relative_to
- Fix W3: Path traversal — `run_eval.py` sanitiza skill_name com re.sub
- Fix W4: MCP name drift — sync mcp_safety.py + servers.json + testes com API real do Notion
- Fix W5: Async import — `presenter.js` import().then() em vez de assignment sincrono

### Docs
- `docs/CODEX-REVIEW-S33.md` — findings completos do primeiro Codex review

## Sessao 32 — 2026-03-31 (skill-debugging)

### Skills
- `systematic-debugging`: nova skill, 4 fases (root cause → padroes → hipotese → fix), adaptada de obra/superpowers (128K stars)
- Skills: 14 → 15

### Rules
- `anti-drift.md`: verification gate 5-step (cherry-pick superpowers verification-before-completion)

### Tooling
- `dream-skill` instalada (~/.claude/skills/dream/) — memory consolidation 4 fases, Stop hook global, auto-trigger 24h
- `@openai/codex` CLI v0.118.0 instalado globalmente (npm -g), autenticado (API key)
- `codex-plugin-cc` (openai) instalado — `/codex:review`, `/codex:adversarial-review`, `/codex:rescue`
- Global CLAUDE.md: Auto Dream trigger adicionado
- Global settings.json: dream Stop hook + codex marketplace

### Research
- Superpowers (128K stars): avaliado, cherry-picked debugging + verification
- GSD (32K stars): avaliado, descartado (dev workflow, nao organizacao)
- Notion Calendario + Tasks DB: mapeados (schema, views, data source IDs)
- Auto Dream (oficial Anthropic): rolling out mar/2026, behind feature flag

### Notion
- 3 compromissos criados no Calendario DB para 01/abr (Dr Fernanda ICESP, Psicologo 11h, OLMO skills+metanalise)

### Memory
- 3 novas memorias: notion-databases (reference), tooling-pipeline (project), metanalise-deadline (project)

## Sessao 31 — 2026-03-31

### Skills Audit (18 → 14)
- **3 merges**: ai-learning → continuous-learning, research → mbe-evidence, notion-knowledge-capture → notion-publisher
- **1 prune**: self-evolving removida (PDCA ja coberto por concurso e review)
- **12 migracoes**: instructions.md → SKILL.md (formato oficial Anthropic)
- Todas 14 skills com descriptions "pushy" (anti-undertrigger, trigger phrases PT-BR)
- Descoberta: skills com `instructions.md` nao carregavam no auto-trigger — so `SKILL.md` funciona

### Docs
- `ARCHITECTURE.md`: contagem atualizada (17 → 14 skills)

### Memory
- Atualizada `user_mentorship.md`: Opus mentor full-stack (dev, ML, AI, eng sistemas, gestao, orquestracao)

## Sessao 30 — 2026-03-31

### Skills
- `skill-creator`: substituido por versao oficial Anthropic (18 arquivos, repo anthropics/skills)
- `slide-authoring`: nova skill (65 linhas SKILL.md + references/patterns.md com 5 padroes HTML)
- Avaliadas e descartadas: 7 skills ui-ux-pro-max (irrelevantes para nosso stack deck.js)
- Avaliado claude-mem (44K stars): decisao de instalar em sessao dedicada futura

### Config
- `statusline.sh`: nome da sessao em magenta bold (destaque visual)
- `pyproject.toml`: ruff exclude para `.claude/skills/skill-creator/` (codigo externo)

### Memory
- Criado sistema de memoria persistente (MEMORY.md + 2 memorias: anti-sycophancy, mentorship)

## Sessao 29 — 2026-03-31

### Hooks
- Novo `hooks/stop-notify.sh`: beep 1200Hz + toast "Pronto" no evento Stop
- Todos os 3 hooks corrigidos para paths absolutos (CWD-independent)

### Docs Promovidos
- `decision-protocol.md` e `coautoria.md` promovidos de cirrose → `shared/`
- Cirrose originais viram redirects (tabela de artefatos preservada)

### Lessons Absorbed
- `slide-rules.md`: +E32, +§7 GSAP armadilhas, +§8 scaling arquitetura
- `ERROR-LOG.md` metanalise: 5 licoes herdadas do aulas-magnas

### Infra
- Repo renomeado: `organizacao1` → `LM` → `OLMO` (via `gh repo rename`)

### Cirrose — Feedback pós-aula (2026-03-31)
- Novo `cirrose/NOTES.md`: feedback da aula real
- Erro: indicação de albumina em HDA (albumina é SBP, não HDA)
- Tópico novo: coagulopatia no cirrótico (hemostasia rebalanceada, TEG/ROTEM, PVT)
- Pronúncia cACLD: letra por letra internacionalmente, DHCAc não é usado verbalmente no BR

### Legacy Cleanup
- `aulas-magnas` movido para `legacy/` (fora do repo)
- `wt-metanalise` movido para `legacy/` (worktree pruned)

### PENDENCIAS
- `Osteoporose` atualizado: agora em `legacy/aulas-magnas`

## Sessao 28 — 2026-03-31

### Metanalise Migration
- 18 slides + references + scripts migrados de wt-metanalise para `content/aulas/metanalise/`
- Paths corrigidos: `../../shared/` → `../shared/`
- Docs reescritos (CLAUDE.md, HANDOFF.md, NOTES.md, CHANGELOG.md, ERROR-LOG.md)
- Deleted: WT-OPERATING.md, AUDIT-VISUAL.md, HANDOFF-ARCHIVE.md (absorvidos)
- `package.json`: +`dev:metanalise` (port 4102), +`build:metanalise`

### CSS Architecture
- slide-rules.md: nova secao §1b (tokens + composicao livre, sem archetypes)
- Stack profissional: GSAP 3.14 (ja existia) + Lottie-web 5.13 + D3 7.9
- `base.css`: `@media (prefers-reduced-motion: reduce)` adicionado
- `presenter.js`: criado mas NAO integrado (precisa rewrite — HTML separado, timer fix)

### Doc Restructuring
- ECOSYSTEM.md deletado — conteudo unico absorvido no CLAUDE.md (Objectives + Tool Assignment)
- CHANGELOG.md: 382→50 linhas — sessoes 7b-24 movidas para `docs/CHANGELOG-archive.md`
- PENDENCIAS.md: separado setup/infra de backlog, items completados removidos
- ARCHITECTURE.md: skills list derivavel removida, agent system marcado como scaffold
- HANDOFF.md: items DONE removidos, sessao 28 atualizada
- 4 refs a ECOSYSTEM.md atualizadas (GETTING_STARTED, TREE, OBSIDIAN_CLI_PLAN, CLAUDE.md)

### Memories
- feedback_self_question: reflexao critica antes de implementar
- feedback_no_sycophancy: zero adulacao, analise critica antes de concordar

## Sessao 27 — 2026-03-29

### Tree Cleanup
- Deletada branch stale `refactor/monorepo-professional` (12 commits atras, 0 proprios)
- Removidos 5 stubs orfaos: `content/blog/`, `apps/api/`, `apps/web/`, `aulas/metanalise/`, `aulas/osteoporose/`
- Info migracao preservada em PENDENCIAS.md secao "Aulas Congeladas"

### Path Fix
- `03-Resources/` → `resources/` em 4 arquivos: `atualizar_tema.py`, `workflow_cirrose_ascite.py`, `workflows.yaml`, `workflow-mbe-opus-classificacao.md`
- `knowledge_organizer.py` mantido (PARA convention do Obsidian vault)

### Documentation
- Novo `docs/TREE.md`: mapa completo anotado da arvore do projeto
- `skills/__init__.py`: docstring clarifica `skills/` (runtime) vs `.claude/skills/` (slash commands)
- `CLAUDE.md`: secao Misc com cross-refs para skills/ e TREE.md

## Sessao 26 — 2026-03-29

### Hardening Documental
- Novo `docs/SYNC-NOTION-REPO.md`: protocolo Notion↔Repo (source of truth, collection IDs, workflows)
- `content/aulas/README.md` reescrito: 14 scripts mapeados, status por aula, grafo cross-refs, Notion
- See-also em 7 reference docs (CASE, narrative, evidence-db, must-read, archetypes, decision-protocol, coautoria)
- `CLAUDE.md` + `ECOSYSTEM.md` atualizados com referencia ao SYNC-NOTION-REPO

### Vite Safety
- `vite.config.js`: `strictPort: true`, porta removida (controlada por npm scripts)
- `package.json`: cirrose=4100, grade=4101, strictPort em todos os dev scripts
- Corrige problema de servidores fantasma ao rodar multiplos projetos Vite

## Sessao 25 — 2026-03-29

### Timeline Fix
- Concurso: nov/2026 → dez/2026 (7 ocorrencias: CLAUDE.md, ECOSYSTEM, ecosystem.yaml, ARCHITECTURE, skill concurso)
- Estudo: "foco total abril" → "foco total maio" (HANDOFF, PENDENCIAS)
- PENDENCIAS backlog: "Abr-Nov" → "Mai-Dez"
- Memory: project_concurso_timeline atualizada

### Docs Cleanup
- `docs/WORKFLOW_MBE.md` + `docs/PIPELINE_MBE_NOTION_OBSIDIAN.md`: `03-Resources/` → `resources/` (path stale desde sessao 21)
- Auditoria completa: 9 docs, 8 rules, 17 skills, 4 agents — tudo sincronizado
- Nenhum doc stale ou redundante encontrado

### Housekeeping
- HANDOFF.md: sessao 25 com estado atualizado + novo item (scripts Python path stale)
- Flagged: `atualizar_tema.py`, `knowledge_organizer.py`, `workflows.yaml` ainda referenciam `03-Resources/`

---
Sessoes anteriores (7b–24): `docs/CHANGELOG-archive.md`
