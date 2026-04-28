# BACKLOG — Persistent Self-Improvement Channel

> Canonical SSoT per S225 LT-7 merge. Schema: tier (P0/P1/P2/Frozen/Resolved) + cat (infra/tooling/process/research/content) + effort (S/M/L).
> Governance: items surgem via backlog gate (S155). Attack top-down within tier. Movement: P0 → in-progress via HANDOFF. Done → Resolved. Dormant >10 sessões = audit candidate.
> Counts: P0=3 | P1=7 | Deferred=9 | P2=22 | Frozen=3 | Resolved=20 | Setup=separate. Next #=65.

## TOC

- [P0](#p0) · [P1 — 2-3 sessões](#p1) · [Deferred — no consumer / low urgency](#deferred) · [P2 — sem urgência](#p2) · [Frozen](#frozen) · [Resolved — historical](#resolved) · [Setup & Infra](#setup)

---

## P0 — blocking próxima sessão <a id="p0"></a>

**Foco (ordem explícita):**

1. **P0a — shared-v2 Day 2 (C5) — #53** — `motion/tokens.css` + `motion/transitions.css` + `js/motion.js` + `js/deck.js` + `js/presenter-safe.js` + `js/reveal.js` + `css/presenter-safe.css` + `_mocks/dialog.html`. **Ensaio HDMI residencial obrigatório** antes de commit.
2. **P0b — grade-v2 scaffold (C6) — #52** — `content/aulas/grade-v2/` com slides/ + evidence/ + exports/ + qa-rounds/ + variants/ + CLAUDE.md + _manifest.js 18 slots.
3. **P0c — qa-pipeline v2 Gate 0+1 (C7) — #54** — `content/aulas/scripts/qa-pipeline/` com gate0-local + gate1-flash + shared utilities + prompts.
4. **P0.5 — QA editorial metanalise** — 16 slides pendentes (3/19 done), paralelo quando bandwidth permitir + qa-pipeline v2 operacional.
5. **P1 sub** — R3 infra + Anki cards (deferred pós-30/abr; tracked em §P1 #34 + §Setup & Infra).

**Deadline grade-v2:** 30/abr/2026 quinta-feira. Hoje T-9d.

**Bloqueadores cruzados:**
- P0a (C5) bloqueia validação completa de shared-v2 (scaleDeck bug elimination via presenter-safe.js + ensaio HDMI).
- P0b (C6) consome shared-v2 (precisa Day 2 done).
- P0c (C7) pode rodar paralelo a P0b após Gate 0+1 validados.

**Estado pós-C4 (2026-04-21):** #53 parcialmente Done — Day 1 tokens + type + layout + entry + mocks committed em `a95a18d`. Day 2 pendente C5.

---

## P1 — importante 2-3 sessões <a id="p1"></a>

> 9 items em §Deferred (no consumer / low urgency). Aqui ficam apenas content-adjacent + trivial + historical.

| # | Cat | Effort | Item | Next action |
|---|-----|--------|------|-------------|
| 36 | content | L | Memory → Living-HTML migration (aulas cirrose/metanalise) | Plan canonical em `.claude/plans/archive/S227-memory-to-living-html.md`. Content-adjacent (prep para uso em slides). Destravar só se slides solicitarem explicitamente. |
| ~~37~~ | RESOLVED S245 (fix em `a0b243a+1`) | - | ~~apl-cache-refresh.sh wrong BACKLOG path~~ | L23 `$PROJECT_ROOT/BACKLOG.md` → `$PROJECT_ROOT/.claude/BACKLOG.md`. Hook agora cacheia top-3 items corretamente. |
| 34 | infra | M | [S227 partial] cp Pattern 8 — CC 2.1.113 ask bypass | Investigation done; applied 34 deny patterns (KBP-26). Manual monitoring ongoing. **S245 monitoring note:** `.stop-failure-sentinel` cluster 02:04-02:05 hoje = 1 API timeout + 2 unknowns + 2 synthetic escape-tests (nao ask-bypass pattern). Ausencia de sinal contra estabilidade; nao fecha sem evidencia positiva. **STATUS: essentially historical; close quando Lucas confirmar estabilidade post-/clear**. |
| 47 | process | S | [DEFERRED] Research skill E2E verification (ex-S234 P0) | Scripts `.claude/scripts/{gemini,perplexity}-research.mjs` nunca testados contra API real. Reativar só se research para slide concreto quebrar. |
| 48 | tooling | M | [DEFERRED] PMID batch verification automation (ex-S235) | Script `.claude/scripts/pmid-batch-verify.mjs` para batch PMID via PubMed MCP esummary. Reativar só se volume research justificar. |
| ~~49~~ | RESOLVED S232 post-close (via #51 DELETE path) | - | ~~Managed Agents evaluation~~ | Historical marker. |
| ~~57~~ | RESOLVED S248 (commit `2a350d6`) | - | ~~`hooks/post-tool-use-failure.sh:38-40` schema bug~~ | `additionalContext` top-level emitido (era `hookSpecificOutput.systemMessage` ignorado por PostToolUseFailure). |
| ~~58~~ | RESOLVED S248 (commit `2a350d6`) | - | ~~`hooks/post-compact-reread.sh:17` schema bug~~ | `systemMessage` top-level emitido (era `hookSpecificOutput.message` ignorado por PostCompact). |
| ~~59~~ | RESOLVED S248 (commit `2a350d6`) | - | ~~`.claude/hooks/guard-write-unified.sh:31,42,122` schema bug~~ | 3 linhas convertidas para `{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"block","permissionDecisionReason":"..."}}`. KBP-19 deploy. |
| 61 | process | S | [S248] External benchmark execution gate | Plano canonico em `docs/research/external-benchmark-execution-plan-S248.md`. Antes de expandir #60, fechar B1-B3: CI truth, hook schema containment e content pipeline truth. Benchmarks: Anthropic Claude Code, Google/DORA, GitHub, Microsoft SDL, OWASP SAMM, OpenSSF, Google SRE, CMMI. |
| ~~60~~ | RESOLVED S250 (commits `0ae043e` + `11e44f0` + `7d68d64`) | - | ~~[S248 partial] Time de debugger Phase B + SOTA pivot~~ | Phase B agents shipped S248 (6 novos + collector update). **Phase C `hooks/loop-guard.sh` D9 advisory-mode** (commit `0ae043e` S249) + **Phase D `.claude/skills/debug-team/SKILL.md` 11-step orchestrator** (commit `11e44f0` S249). **Phase 4 e2e validated S250** (commit `7d68d64` /debug-team em ci-hatch-build-broken — verdict pass first try, single_agent path complexity_score=85, validator_loop_iter=0). Plan: `.claude/plans/archive/S249-partitioned-jumping-summit.md` + `.claude/plans/debug-ci-hatch-build-broken.md`. |
| 62 | process | L | [S249 Lucas-request, S250 Phase 1 done] Audit + merge agents/skills/hooks pós-SOTA | **Phase 1 (3-model research) DONE em `.claude/plans/audit-merge-S251.md`** — Opus 4.7 + Gemini 3.1 Deep Think + ChatGPT 5.5 xhigh, schema-strict JSON outputs. **ADOPT-NEXT (S251 ~6h):** 3 high-confidence (H4 systematic-debugging→debug-team merge, X1 janitor→repo-janitor merge, X3 chaos-inject-post hook ordering fix). **DEFER P1 SOTA gaps:** disallowedTools→allowlist 6 agents, debug-team durable state, metrics instrumentation, Agent Teams pilot. **Refuted hypotheses (Gemini FPs):** stop-* hooks merge (already consolidated), hooks/ paths migration (both intentional), orphan hooks (32/32 registered). |
| ~~63~~ | RESOLVED S256 (commit `8cd0131`) | - | ~~SessionStart flags `/insights` + `/dream` bugged~~ | Root cause: `.claude/.last-insights` (tracked, frozen S225-era) vs `~/.claude/projects/.../.last-insights` (canonical /insights write). Path mismatch → GAP_DAYS sempre ≥7 → recurring FP. Fix: session-start.sh read MAX(repo, global) + /insights SKILL.md L234 dual-write pattern (per /dream). /dream lifecycle audit confirmou skill SKILL.md L499-504 já correto (dual-write .last-dream + rm .dream-pending). Both `if false` blocks re-enabled. Empirical pre-commit: GAP_DAYS=0 (was 7). 3 sessões dormant S254→S256 closed. |
| 64 | content | M | [S256] Metanálise QA editorial resume — Lucas commitment | Plan persisted em `.claude/plans/archive/S240-DEFERRED-lovely-sparking-rossum.md` (16 sessões dormant pós S240, archived S256 Phase 0 hygiene). 14 slides pendentes QA editorial (3/19 done). 5 slides com R11 abaixo threshold 7. Resume signal: post-hooks-complete (S256 Block C+D done) ou Lucas explicit reabertura. Inconsistência s-contrato (R11=5.7 marcado DONE) requer reabertura ou aceite. |

---

## Deferred — no consumer / low urgency <a id="deferred"></a>

> Items com razão substantiva de defer (sem consumer ativo, meta-tooling sem pain, research arquitetural). Não é "frozen permanent" — é "fora de consideração até demanda emergir". Histórico no git log.

| # | Ex-tier | Item | Razão do defer |
|---|---------|------|----------------|
| ~~13~~ | RESOLVED S245 (via dormancy) | ~~g3-result memory findings audit~~ | ARCHIVED S245 — 78 sessoes dormente, auto-viola governance L4; zero content impact. Precedent: #49 pattern (RESOLVED via reframe). Historia no git log. |
| 18 | P1 | KBP-18 dispatch sem prompting skill | Meta process; sem content consumer |
| 29 | P1 | Agent/subagent optimization audit (10 agents) | Puro meta-tooling (HyperAgents/DGM/Voyager research); zero content unblock |
| 33 | P1 | Research persistence inter-sessão | Meta process template; content pode ir ad-hoc |
| 46 | P1 | Knowledge integration architecture (OLMO ↔ COWORK) | Research arquitetural; sem pain imediato |
| 50 | P1 | QA gate parallelism (ADR + pilot) | Luxo infra; QA sequential ainda funciona |
| 23 | P1 | Edit/Write permission glob Windows broken | Workaround S189 existente; meta-tooling |
| 1 | P1 | Pernas pendentes research (Perna 2 + 6) | Research infra; content pode usar pernas atuais |
| 4 | P1 | Pipeline DAG end-to-end (inbox → NLM → wiki) | Arquitetural; sem consumer ativo |
| 5 | P1 | medicina-clinica 4 stubs | Aguarda external harvest COWORK (ADR-0002); sem ação OLMO possível |

**Contagem:** 9 items (10 total, 1 archived S245). Próximo #=62.

---

## P2 — nice-to-have (sem urgência) <a id="p2"></a>

### Research/theory (foundational patterns to adopt)

| # | Cat | Effort | Item | Detalhe |
|---|-----|--------|------|---------|
| 24 | research | L | Voyager-style skill auto-extraction | Wang 2023 arXiv:2305.16291. Prereq: infra de verificação (test cases per skill). S190 |
| 25 | research | M | Kaizen test generation skills/agents | Gerar test cases, executar, analisar falhas, propor fix. Long-term memory testes falhados. Kaizen-agent github. S190 |
| 26 | research | M | Strategy archive (DGM-inspired) | Sakana AI Darwin Godel Machine arXiv:2505.22954. Variantes avaliadas empírico. S190 |
| 27 | research | M | Metaprompt optimization | OpenAI Self-Evolving Agents Cookbook 2025. Meta-prompt fix SKILL.md quando underperform. S190 |
| 28 | research | S | Reflexion pattern em workflows | Shinn 2023 arXiv:2303.11366. Self-critique antes retry. Previne KBP-18. Implementar em anti-drift.md. S190 |
| 19 | process | S | Symmetric vs adversarial triangulation doctrine | §6.4 synthesis. Future multi-leg = 1 symmetric + 1 adversarial pair, não N symmetric. Add em `patterns_adversarial_review.md` pós /dream. S158 |
| 41 | research | L | Research orchestrator (future, fresh design) | OLMO teve stub Python (`agents/scientific/`, `subagents/analyzers/`) deletado S228 após auditoria adversarial (aspiracional sem consumer). Live tool hoje: `.claude/agents/evidence-researcher` — MCPs agent-scoped declarados no próprio arquivo (SSoT). Skill `.claude/skills/mbe-evidence` citada em plans S229/S232 NÃO existe no filesystem atual — phantom, não ressuscitar. Quando demanda emergir: **design fresh**, não ressuscitar stub. Taleb/anti-drift: feature sem demanda = dívida. Ref plan `.claude/plans/archive/S228-groovy-launching-steele.md`. S228 |

### Content/aulas (slides + medical content)

| # | Cat | Effort | Item | Detalhe |
|---|-----|--------|------|---------|
| 14 | content | S | metanalise s-objetivos customAnim | stagger não wired — após QA visual |
| 21 | content | S | Backward nav restore beat state (não beat 0) | UX: backward retorna ao último beat visitado. Persistir `revealed` fora factory closure (Map no dispatcher ou data-attr DOM). Baixa prioridade — beat 0 funciona, professor re-clica. S167 |
| 30 | content | L | Prompt hardening propagation cirrose+grade | 7 hardening measures do metanálise (Call A/B/C): S2 mechanical-only, WHAT/WHY/PROPOSAL/GUARANTEE, 24px threshold, KNOWN DESIGN DECISIONS, IGNORE_LIST, few-shot, anti-quota. Bug: grade refs "metanalise.css" (l.72+l.96). 6 files (3 calls × 2 aulas). Plano git log S178 |

### Infra/tooling (system/permission/hooks)

| # | Cat | Effort | Item | Detalhe |
|---|-----|--------|------|---------|
| 2 | infra | S | Adversarial deferred M-01/M-10 | Policy decisions (Bash granularity, Canva MCP wildcard) |
| 7 | tooling | M | P006 plan pre-flight tool availability | Re-design: Step 1.5 em research/SKILL.md ou static allowlist |
| 11 | tooling | M | S155 Group G hooks lazy load | Complexity-as-ceremony per backlog gate |
| ~~16~~ | RESOLVED | - | ~~Zombie refs audit post-archival~~ | ✅ S243-T2 (2026-04-23): `AGENT-AUDIT-S79.md` moved to `docs/archive/S079-agent-audit.md`. `research-gaps-report.md` + `evidence-harvest-S112.md` verificados em `content/aulas/metanalise/evidence/` (localização legítima per-aula, não zombies). |
| ~~42~~ | RESOLVED | - | ~~ModelRouter unused~~ | ✅ S230 Batch 3c (commit pendente): `model_router.py` + `test_model_router.py` deletados; orchestrator simplificado; routing intent (trivial→Ollama, simple→Haiku, medium→Sonnet, complex→Opus) preservada como diretiva humana em `CLAUDE.md`. Decisão B (delete) escolhida — teatro arquitetural removido. |
| ~~43~~ [RESOLVED S271 via #51 Python stack delete] | - | ~~MCP safety gate dormant~~ | `agents/core/orchestrator.py:45-48` deletado S232 (#51 commit `46489c0`). Enforcement real persiste em `.claude/hooks/guard-mcp-queries.sh` (active). Decisão (b) executada por dependência. Spot-check S271: `agents/core/orchestrator.py` = FILE_NOT_FOUND, Grep `orchestrator` em `**/*.py` = 0 hits. |
| 56 | infra | S | Stop hook "No stderr output" silent failure (Windows path escape) | S237 C1 commit `e361520` disparou 9 stop hooks; 1 failed non-blocking sem stderr output. Suspect: Windows path escape em bash-within-bash MSYS (`C:\Dev\Projetos\OLMO` → `C:DevProjetosOLMO`). Evidência: `.claude/hook-log.jsonl` entry 2026-04-21T19:10:56Z com `cd: C:DevProjetosOLMO: No such file or directory`. Non-blocking mas silent = esconde regressão. Fix candidate: (a) identificar qual dos 6 Stop hooks falhou via `set -x` debug em wrapper, (b) add stderr redirect com context, (c) novo KBP "Windows path escape in hook wrappers" se root cause confirmado. Ref audit: `.claude/plans/archive/S237-EC-audit.md §Stop hook silent failure`. S237 |

### Process/governance

| # | Cat | Effort | Item | Detalhe |
|---|-----|--------|------|---------|
| 6 | process | M | Skill de slides consolidada | Usar skill-creator para criar skill nova |
| 8 | process | S | Postmortem dead JSON+py pipeline | Lucas: "para registrar". S156+ |
| 9 | process | M | S155 Group E slide-patterns vs slide-rules drift | 5 findings em `.claude/tmp/c1-result.md` (C1 #6-#10). Defer slide-focused session (CSS/runtime + Lucas working area) |
| 17 | process | L | Context reduction — qualitative findings S157 | Adversarial review S158 descartou números (bytes/4 não tokenizado), P11/P12, §6 meta-proposals, KBP-17 conflict. **Trigo preservado:** (a) P5 ground truth = 8 files auto-loaded; (b) Codex R6/R7 demoted; (c) procedural gates (R1/R2/R3/R5 caveats); (d) KBP-18 renumerado (item 18). **Pre-exec obrigatório:** tokenizer real + red team verdadeiro. Synthesis: `.claude/workers/reducao-context/synthesis-2026-04-11-1631.md` |
| 31 | process | M | Sentinel audit quality — melhoria contínua | S196: sentinel errou 1 claim + orchestration truncou (50 tool calls sem report). Melhorias: (1) verificação cruzada antes de claim, (2) report estruturado, (3) scope 1 dir/concern, (4) maturity tier. Aplicar proven-wins.md ao audit |
| ~~44~~ [RESOLVED S271 via #51 Python stack delete] | - | ~~CLI Python viability decision~~ | `orchestrator.py` + `__main__.py` + entire Python CLI deletados S232 (#51 commit `46489c0`). `run` subcommand não existe. Decisão (a) executada por dependência. Spot-check S271: Grep `orchestrator` em `**/*.py` = 0 hits. |
| 45 | process | M | "7-layer antifragile stack" claim unaudited | S228 audit Bloco-3 Suspender-narrativa: README claima L1-L7 antifragile stack mas padrão do projeto é "aspiracional > runtime". Executar audit próprio de cada layer (L1 retry, L2 model fallback, L3 cost breaker, L4 graceful degradation, L5 self-healing, L6 chaos, L7 continuous learning) antes de continuar usando claim em docs externos |
| 55 | process | S | EC audit consolidation — S237 ~25 blocks review | Review `.claude/plans/archive/S237-EC-audit.md` para padrões: Elite section ritualismo (phrases recorrentes "engineer elite would automate/extract/BDD"), Write vs Edit EC template differentiation, compressed format rule adoption mid-session. Output candidato: rule em anti-drift §EC loop se pattern emergir OU KBP novo se anti-pattern. Trigger: quando novo ciclo de EC-heavy commits for observado (C5 Day 2 shared-v2 com JS layer = likely candidate; ~30+ ECs esperados). S237 |

---

## Frozen — deferred indefinitely <a id="frozen"></a>

> Items sem prazo, não atacar sem re-triagem explícita. Candidatos a deletion se 5+ sessões sem revival.

| # | Item | Origin |
|---|------|--------|
| 38 | [FROZEN] Obsidian plugins setup | Templater, Dataview, Spaced Rep, obsidian-git. Migrado HANDOFF §Carryover → S227 docs-diet |
| 39 | [FROZEN] Wallace CSS 29 raw px audit | Legacy CSS audit indefinido. Migrado HANDOFF §Carryover → S227 docs-diet |
| 40 | [FROZEN] Slides s-absoluto legacy | Legacy slides frozen aula priority. Migrado HANDOFF §Carryover → S227 docs-diet |

---

## Resolved (historical) <a id="resolved"></a>

> Preservados para rastreabilidade. Overflow rule: >20 items = mover os mais antigos para `CHANGELOG.md §Resolved archive`.

| # | Item | Resolution |
|---|------|------------|
| 3 [RESOLVED S196] | Hook/config system review | Fase 1 (S193): node→jq, `if` fields, dead code. Fase 2 (S194-S196): 34→29 hooks, 0 node spawns. Audit sentinel S196 |
| 10 [RESOLVED S156] | settings.local.json wildcard collapse | 68→26 entries. MCP wildcards (pubmed/biomcp/crossref). Commit 2 |
| 12 [RESOLVED S158] | settings.local.json reflection S157 | Removeu `"Edit"` e `"Write"` do allow. Default=ask. Manual Lucas (guard A6 bloqueou agent) |
| 15 [RESOLVED S196] | Hooks reduction audit | Fase 1 (S193) 38→37, Fase 2 (S194-S196) 34→29, 5 steps. S196: 2 CRITICAL (glob counter, mypy FP) + 2 WARN (hygiene dedup, Armed noise) fixed |
| 20 [RESOLVED S193] | guard-bash-write.sh python bypass | Pattern 7 expandido: python -c, python script.py, python3, py. Whitelist: --version/--help/-m pip. 5 testes passam |
| 22 [RESOLVED S193] | /dream multi-fire | `stop-should-dream.sh`: shebang posição 0 + jq fromdateiso8601 fallback |
| 32 [RESOLVED S198] | Node→jq migration restante — 4 scripts | guard-lint-before-build + guard-research-queries + lint-on-edit + model-fallback-advisory. 0 `node -e` em .claude/hooks/ |
| 35 [RESOLVED S225] | BACKLOG merge 3→1 (S214 LT-7) | BACKLOG-S220-codex-adversarial-report.md → plans/archive/S220. Canonical único: este arquivo |
| 42 [RESOLVED S230] | ModelRouter unused — teatro arquitetural | `model_router.py` + `test_model_router.py` deletados (Batch 3c). Routing intent (trivial→Ollama, simple→Haiku, medium→Sonnet, complex→Opus) preservada como diretiva humana em `CLAUDE.md` §Efficiency |
| 49 [RESOLVED S232 post-close] | Managed Agents evaluation (via #51 DELETE path) | Subsumed em #51; quando #51 DELETE executou, MA eval tornou-se moot (não há orchestrator.py para migrar). Reabrir apenas se novo use case materializar (hosted tracing for new needs). |
| 51 [RESOLVED S232 post-close] | Python orchestrator stack DELETE TOTAL | Lucas: "vestigial/falido/nunca usado". Empirical grep audit confirmou: 0 hook invocations, 0 external consumers. Deletado: `orchestrator.py` + `__main__.py` + `agents/` (automation + core) + `subagents/` + `tests/` (Python) + `config/loader.py` + `config/ecosystem.yaml` + `config/rate_limits.yaml`. Updated: pyproject.toml (deps 11→1), Makefile (targets purged), ARCHITECTURE.md + TREE.md + CLAUDE.md + README.md (Python refs removed). Commit `46489c0`. Remaining Python: `scripts/fetch_medical.py` (standalone, httpx-only). |

---

## Setup & Infra (workstream separado) <a id="setup"></a>

> Migrado de PENDENCIAS.md (S214). Workstream separado do backlog tiered — infra/custo/aulas planning.

### MCPs

**Shared inventory** (`config/mcp/servers.json`, `status:connected`):
- [x] PubMed, SCite, Consensus, Scholar Gateway, NotebookLM, Zotero, Excalidraw, Canva, Notion

**Policy-blocked no runtime atual** (`.claude/settings.json` deny): Notion, Canva, Excalidraw, Scholar Gateway, Zotero, Gmail, Google Calendar. Inventoried ≠ callable — ativar manualmente (mover deny→allow) se necessário.

**Agent-scoped** (`.claude/agents/*.md` `mcpServers:`, fora do shared inventory):
- `evidence-researcher`: pubmed, crossref, semantic-scholar, scite, biomcp
- `reference-checker`: pubmed

**Removed/migrated:**
- ~~Perplexity~~ → API direta (S87); ~~Gemini~~ → CLI OAuth (S71)
- Gmail, Google Calendar → migrados para OLMO_COWORK (S228-S229)
- Scholar Gateway: `status:connected` mas **frozen** per evidence-researcher S128

**Planned (not installed):**
- [ ] Google Drive — `@piotr-agier/google-drive-mcp` (requer Google Cloud Console OAuth)
- [ ] Anki MCP — `@ankimcp/anki-mcp-server` (requer Anki Desktop + AnkiConnect)

### Concurso R3 — Setup Pendente

- [ ] Instalar AnkiConnect — Anki Desktop > Tools > Add-ons > 2055492159
- [ ] Configurar Anki MCP — `npx -y @ankimcp/anki-mcp-server --stdio`
- [ ] Provas reais em `assets/provas/` — PDFs de bancas R3
- [ ] SAPs em `assets/sap/` — MKSAP e SAPs de especialidade

### Infra Pendente

- [ ] BudgetTracker (SQLite)
- [ ] claude-task-master (MCP GTD)
- [ ] n8n self-hosted (automacao 24/7)
- [ ] Database Notion "Teaching Log"
- [ ] Pipeline email → Notion → Obsidian
- [ ] Obsidian CLI + vault sync com Notion DBs

### Custo Mensal

| Item | Custo/mes |
|------|-----------|
| Claude Max + Perplexity Max + Google One Ultra | incluso nos planos |
| Scite + Consensus | ~$20-30 |
| **TOTAL** | **~$20-30** (budget $100) |

### Aulas — Migracoes Pendentes

- Osteoporose — 70 slides, Reveal.js (frozen), em `legacy/aulas-magnas`. Decidir formato.

### S241 DEFERRED — Infra (matriz consolidada em `.claude/plans/infra-plataforma-sota-research.md`)

**Top priority (low cost, high value):**
- [ ] `@starting-style` em shared-v2 components — substitui `gsap.from({opacity:0})` em ~30% dos casos simples
- [ ] Logical properties (`margin-inline`, `padding-block`) em novos componentes shared-v2 (Widely 2022+, safe)
- [ ] `context: fork` em skill `/dream` ou `/research` — piloto isolação de contexto (1 skill por vez)
- [ ] Hook `SubagentStart`/`SubagentStop` — instrumentation de dispatch (~30 li script)
- [ ] Hook `PermissionRequest` — audita allow-list growth (mitigação KBP-26)

**Medium priority (high value, requer investigação):**
- [ ] `@scope` migration — substituir padrão `section#s-{id}` (testar slides-lab; FF 146 muito recente)
- [ ] `@container` size queries em panels/cards — safe Chrome/FF/Safari (Widely ago/2025)
- [ ] View Transitions same-doc — substituir duck-mock de `motion.js` por API nativa
- [ ] `permissions.sandbox:` block — verificar Windows 11 disponibilidade; resolveria KBP-28 sistemicamente
- [ ] A2A Protocol MCP wrapper — federação cross-vendor (Salesforce, ServiceNow, Google ADK)
- [ ] Observability MCP server (Langfuse self-hosted) — tracing estruturado
- [ ] Redis state MCP — padroniza session state (equivalente OpenAI Redis sessions)

**Lower priority:**
- [ ] Array by copy methods (`toSorted`, `toReversed`) em JS scripts — safe jan/2026
- [ ] Expansão `@property` para tokens OKLCH remanescentes (além dos 6 solid★ PoC em S241)
