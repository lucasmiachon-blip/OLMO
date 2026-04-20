# BACKLOG — Persistent Self-Improvement Channel

> Canonical SSoT per S225 LT-7 merge. Schema: tier (P0/P1/P2/Frozen/Resolved) + cat (infra/tooling/process/research/content) + effort (S/M/L).
> Governance: items surgem via backlog gate (S155). Attack top-down within tier. Movement: P0 → in-progress via HANDOFF. Done → Resolved. Dormant >10 sessões = audit candidate.
> Counts: P0=0 | P1=16 | P2=22 | Frozen=3 | Resolved=9 | Setup=separate. Next #=51. (S232 close: +4 evolution items B/A/C/D; #36 Living-HTML continues per Lucas)

## TOC

- [P0 — blocking próxima sessão](#p0) · [P1 — 2-3 sessões](#p1) · [P2 — sem urgência](#p2) · [Frozen](#frozen) · [Resolved — historical](#resolved) · [Setup & Infra](#setup)

---

## P0 — blocking próxima sessão <a id="p0"></a>

*(empty — no active blockers)*

---

## P1 — importante 2-3 sessões <a id="p1"></a>

| # | Cat | Effort | Item | Next action |
|---|-----|--------|------|-------------|
| 46 | research | L | Knowledge integration architecture (OLMO ↔ COWORK) | S229: OLMO removeu producer-side knowledge mgmt (Notion+Obsidian+Zotero sync). Pendente ADR descrevendo como consumer (OLMO) le knowledge produzido por COWORK sem reintroduzir sync code. Candidatos: filesystem cross-mount, MCP read-only, periodic snapshot import. Ref plan `.claude/plans/archive/S229-slim-round-3-daily-exodus.md` |
| 34 | infra | M | [S227 partial] cp Pattern 8 — CC 2.1.113 ask bypass | Investigation Opus+Codex done: `permissions.ask` fundamentally bypassed (cp/rm/Write all empirical). Applied: 34 destructive deny patterns. Manual via `/clear` + observe popup behavior in new session. Residual gap: redirects + script-file writes ungateable (KBP-26). Next: verify deny stability post-/clear, then close |
| 36 | content | L | Memory → Living-HTML migration (S227) — **ACTIVE per Lucas S232 close; SCHEDULED S236 partial** | Plan canonical em `.claude/plans/archive/S227-memory-to-living-html.md` (archived S232 post-close mas intent vivo). S236: partial 2-3 high-value cirrose files (csph-nsbb, meld-na, te-accuracy) com PMIDs verified via #48. S239+: remaining 4 files. |
| 37 | infra | S | apl-cache-refresh.sh wrong BACKLOG path | L23 fix: `$PROJECT_ROOT/.claude/BACKLOG.md`. Write→tmp→cp (guard bloqueia Edit hooks/*.sh). Consequência: cache `backlog-top.txt` stale entre sessões. Descoberto S226 pós-close |
| 13 | process | M | g3-result memory findings audit | Revisar 15 findings `.claude/tmp/g3-result.md` antes do próximo /dream. Memory no cap 20/20. S156 |
| 29 | tooling | L | Agent/subagent optimization audit (10 agents) | Phase 1: tool restrictions; Phase 2: model routing (Sonnet/Haiku para repo-janitor/quality-gate); Phase 3: maxTurns calibration; Phase 4: HyperAgents/DGM patterns; Phase 5: parallelism (QA preflight/inspect/editorial); Phase 6: agent-as-skill migration. Refs: HyperAgents Golchian 2026, DGM Sakana 2025, Anthropic orchestrator-workers Dec 2024. S190 |
| 18 | process | S | KBP-18 dispatch sem prompting skill | Add Format C+ pointer → `feedback_agent_delegation §Pre-dispatch ritual`. 5 root causes: no pre-dispatch ritual, name-matching bias, momentum after correction, complexity-as-ceremony, cognitive vs hook layer. Hook enforcement proposal separado (L4 move, warn-level primeiro). S157 |
| 23 | tooling | M | Edit/Write permission glob Windows broken | Edit(.claude/skills/**) não faz match com paths absolutos Windows. Workaround S189: Edit/Write sem args. Investigar `:*` syntax vs path absoluto. Root cause: prefix match vs glob. Relacionado #12 |
| 33 | process | S | Research persistence inter-sessão | Output template obrigatório + plan archive como persistence layer + HANDOFF pointer discipline para pesquisas. Pattern: resultados em `.claude/plans/archive/` com tabela de edits + fontes + verificacao. S197 |
| 1 | research | M | Pernas pendentes research | Perna 2 (evidence-researcher), Perna 6 (NLM: requer login) |
| 4 | infra | L | Pipeline DAG end-to-end | external inbox → NLM → wiki (ADR-0002) |
| 5 | content | M | medicina-clinica 4 stubs | Aguardar external harvest via `$OLMO_INBOX` (ADR-0002). 4 concepts stub/low |
| 47 | process | S | **[S234 P0] Research skill E2E verification** | S232 criou `.claude/scripts/{gemini,perplexity}-research.mjs` unblock KBP-26 mas nunca testados contra API real. Rodar 1 topic real, verificar cada script (path + API + output format); documentar baseline tempo/custo/qualidade em `.claude/scripts/README.md`. Deliverable: empirical proof vs theoretical claim. ~1-2h. |
| 48 | tooling | M | **[S235] PMID batch verification automation** | Script `.claude/scripts/pmid-batch-verify.mjs` — input lista CANDIDATE PMIDs, output VERIFIED/INVALID inline via PubMed MCP esummary batch. Update evidence-researcher SKILL.md post-output step. Consumer: ~100 slides/ano × 5-10min manual = 8-16h/ano saved + zero PMID errado publicado. Não-YAGNI: Lucas faz manualmente toda research session. |
| 49 | infra | L | **[S237] Claude Managed Agents evaluation (spec-only)** | Anthropic lançou April 8 — hosted agent infra (sandboxing, scoped perms, long sessions, tracing). Potencial replace orchestrator.py + resolve KBP-26 permissions pain. Deliverable: ADR-0004 spec-audit dos pains resolvidos + custos migração + veredicto (migrate S239+ / NOT migrate / partial adopt). **Spec-only, não migrate ainda.** ~2-3h read Anthropic docs + map to OLMO pain points. |
| 50 | tooling | M | **[S238] QA gate parallelism (ADR + pilot)** | Atual: Preflight → Lucas OK → Inspect → Lucas OK → Editorial sequential ~30-40min/slide. Proposta: 3 gates PARALELO para MESMO slide (KBP-05 preserved: 1 slide); Lucas decide 1× em vez de 3×. Requer ADR-0005 (KBP-05 semantics + human-in-loop) antes de implement. Pilot em 1 slide opt-in flag `--parallel` em qa-engineer. Ganho: ~50% QA time cut = ~47h/ano salvos. |

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
| 41 | research | L | Research orchestrator (future, fresh design) | OLMO teve stub Python (`agents/scientific/`, `subagents/analyzers/`) deletado S228 após auditoria adversarial (aspiracional sem consumer). Live tool hoje: `.claude/agents/evidence-researcher` (6 braços MCP: PubMed/Scite/Consensus/Semantic Scholar/CrossRef/BioMCP) + `.claude/skills/mbe-evidence`. Quando demanda emergir: **design fresh**, não ressuscitar stub. Taleb/anti-drift: feature sem demanda = dívida. Ref plan `.claude/plans/archive/S228-groovy-launching-steele.md`. S228 |

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
| 16 | tooling | S | Zombie refs audit post-archival | 3 históricos restantes: `docs/aulas/AGENT-AUDIT-S79.md` + `research-gaps-report.md` + `evidence-harvest-S112.md` (renomeado S226 ADR-0002). Baixo risco. S154/S157 |
| ~~42~~ | RESOLVED | - | ~~ModelRouter unused~~ | ✅ S230 Batch 3c (commit pendente): `model_router.py` + `test_model_router.py` deletados; orchestrator simplificado; routing intent (trivial→Ollama, simple→Haiku, medium→Sonnet, complex→Opus) preservada como diretiva humana em `CLAUDE.md`. Decisão B (delete) escolhida — teatro arquitetural removido. |
| 43 | infra | S | MCP safety gate dormant (`mcp_operation` key unset by callers) | S228 audit finding: `agents/core/orchestrator.py:45-48` gate só dispara com `task["mcp_operation"]`. `grep` confirma que nenhum workflow/test/caller seta essa key — workflows usam `type: "mcp"`. Decisão: (a) fire em `type:"mcp"` OR `mcp_operation` OR (b) delete gate Python (enforcement real está em `.claude/hooks/guard-mcp-queries.sh`). Ver §Mudanca-4 |

### Process/governance

| # | Cat | Effort | Item | Detalhe |
|---|-----|--------|------|---------|
| 6 | process | M | Skill de slides consolidada | Usar skill-creator para criar skill nova |
| 8 | process | S | Postmortem dead JSON+py pipeline | Lucas: "para registrar". S156+ |
| 9 | process | M | S155 Group E slide-patterns vs slide-rules drift | 5 findings em `.claude/tmp/c1-result.md` (C1 #6-#10). Defer slide-focused session (CSS/runtime + Lucas working area) |
| 17 | process | L | Context reduction — qualitative findings S157 | Adversarial review S158 descartou números (bytes/4 não tokenizado), P11/P12, §6 meta-proposals, KBP-17 conflict. **Trigo preservado:** (a) P5 ground truth = 8 files auto-loaded; (b) Codex R6/R7 demoted; (c) procedural gates (R1/R2/R3/R5 caveats); (d) KBP-18 renumerado (item 18). **Pre-exec obrigatório:** tokenizer real + red team verdadeiro. Synthesis: `.claude/workers/reducao-context/synthesis-2026-04-11-1631.md` |
| 31 | process | M | Sentinel audit quality — melhoria contínua | S196: sentinel errou 1 claim + orchestration truncou (50 tool calls sem report). Melhorias: (1) verificação cruzada antes de claim, (2) report estruturado, (3) scope 1 dir/concern, (4) maturity tier. Aplicar proven-wins.md ao audit |
| 44 | process | S | CLI Python viability decision (`python -m orchestrator run`) | S228 audit finding: após slim migration, `run` subcommand = apenas display_status (demo workflow removido). Decisão: (a) delete `run` subcommand OR (b) documentar intenção como "start + wait" OR (c) implementar dispatchers `mcp/api_call/local/skill` em route_task. Depende de se CLI é target vivo ou legacy. Ver §Mudanca-3 |
| 45 | process | M | "7-layer antifragile stack" claim unaudited | S228 audit Bloco-3 Suspender-narrativa: README claima L1-L7 antifragile stack mas padrão do projeto é "aspiracional > runtime". Executar audit próprio de cada layer (L1 retry, L2 model fallback, L3 cost breaker, L4 graceful degradation, L5 self-healing, L6 chaos, L7 continuous learning) antes de continuar usando claim em docs externos |

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

---

## Setup & Infra (workstream separado) <a id="setup"></a>

> Migrado de PENDENCIAS.md (S214). Workstream separado do backlog tiered — infra/custo/aulas planning.

### MCPs (11 conectados)

- [x] Notion, PubMed, SCite, Consensus, Scholar Gateway, NotebookLM, Zotero, Excalidraw, Gmail, Google Calendar, Canva
- ~~Perplexity~~ — migrado para API direta S87. ~~Gemini~~ — descartado S71.
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
