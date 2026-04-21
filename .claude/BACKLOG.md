# BACKLOG — Persistent Self-Improvement Channel

> Canonical SSoT per S225 LT-7 merge. Schema: tier (P0/P1/P2/Frozen/Resolved) + cat (infra/tooling/process/research/content) + effort (S/M/L).
> Governance: items surgem via backlog gate (S155). Attack top-down within tier. Movement: P0 → in-progress via HANDOFF. Done → Resolved. Dormant >10 sessões = audit candidate.
> Counts: P0=1 (MORATORIUM) | P1=5 slim | MORATORIUM-DEFERRED=10 | P2=22 | Frozen=3 | Resolved=11 | Setup=separate. Next #=52. (S234 Batch 2: content moratorium active — 10 P1 items deferred até §P0 condições de saída satisfeitas)

## TOC

- [P0 — MORATORIUM ATIVO](#p0) · [P1 — 2-3 sessões (slim)](#p1) · [MORATORIUM-DEFERRED](#moratorium-deferred) · [P2 — sem urgência](#p2) · [Frozen](#frozen) · [Resolved — historical](#resolved) · [Setup & Infra](#setup)

---

## P0 — blocking próxima sessão <a id="p0"></a>

> **CONTENT MORATORIUM ACTIVE** (S234 → até condições) — meta-work congelado.
>
> **Commits tocam APENAS:** `content/aulas/**`, `assets/provas/`, `assets/sap/`, Anki files, HANDOFF/CHANGELOG/BACKLOG de wrap.
>
> **NÃO tocar:** `.claude/agents/`, `.claude/skills/`, `.claude/hooks/`, `.claude/rules/`, `config/`, `docs/`, `pyproject.toml`, `CLAUDE.md`, `README.md`.
>
> **Drift canonical detectado durante content work:** anotar 1 linha em §MORATORIUM-DEFERRED; **NÃO corrigir**.
>
> **Condições de saída (UMA basta):** (a) QA editorial metanalise 19/19; (b) R3 infra ativo (AnkiConnect + Anki MCP + 2 provas classificadas em `assets/provas/` + ≥10 Anki cards rodando spaced rep); (c) Lucas declara fim com rationale de bloqueio real (não "seria legal").
>
> **Plano âncora:** `.claude/plans/S234-content-moratorium-active.md` — ler ao hydrate se dúvida.

**Foco (ordem explícita):**

1. **P0 — Nova aula de grade (totalmente nova, NÃO relacionada ao legacy)** — conteúdo brainstormed com **claude.ai (web, ChatGPT-style)**; implementação (slides HTML + evidence HTML + QA pipeline) via **Claude Code**. Path livre em `content/aulas/` (sugestão: `grade-v2/` ou similar). **NÃO editar `content/aulas/grade/` legacy (58 slides) — tratar como referência apenas**. Segue padrão existente (deck.js + GSAP + OKLCH tokens + manifest + scripts QA).
2. **P0.5 — QA editorial metanalise** — 16 slides pendentes (s-absoluto → próximos per APL). ~½-1 sessão por slide. Destravar em paralelo ao P0 quando bandwidth permitir.
3. **P1 sub — R3 infra setup** — AnkiConnect addon (Anki Desktop > Tools > Add-ons > 2055492159), Anki MCP (`npx -y @ankimcp/anki-mcp-server --stdio`), 2 provas reais em `assets/provas/`, 1 SAP em `assets/sap/`. Detalhes em §Setup & Infra.
4. **P1 sub — Anki cards reais** — conteúdo de erro log + temas semana. Só depois de R3 infra ativo.

---

## P1 — importante 2-3 sessões (slim durante moratorium) <a id="p1"></a>

> Slim: 10 items movidos para §MORATORIUM-DEFERRED. Aqui ficam apenas content-adjacent + trivial + historical.

| # | Cat | Effort | Item | Next action |
|---|-----|--------|------|-------------|
| 36 | content | L | Memory → Living-HTML migration (aulas cirrose/metanalise) | Plan canonical em `.claude/plans/archive/S227-memory-to-living-html.md`. Content-adjacent (prep para uso em slides). **DEFER durante moratorium** — só destravar se slides solicitarem explicitamente. |
| 37 | infra | S | apl-cache-refresh.sh wrong BACKLOG path | L23 fix: `$PROJECT_ROOT/.claude/BACKLOG.md`. Cache stale entre sessões. **DEFER — fora do escopo moratorium (`.claude/hooks/`).** |
| 34 | infra | M | [S227 partial] cp Pattern 8 — CC 2.1.113 ask bypass | Investigation done; applied 34 deny patterns (KBP-26). Manual monitoring ongoing. **STATUS: essentially historical; close quando Lucas confirmar estabilidade post-/clear**. |
| 47 | process | S | [DEFERRED] Research skill E2E verification (ex-S234 P0) | Scripts `.claude/scripts/{gemini,perplexity}-research.mjs` nunca testados contra API real (BACKLOG #47 original). **DEFER durante moratorium** — reativar só se research para slide concreto quebrar. |
| 48 | tooling | M | [DEFERRED] PMID batch verification automation (ex-S235) | Script `.claude/scripts/pmid-batch-verify.mjs` para batch PMID via PubMed MCP esummary. **DEFER durante moratorium** — reativar só se volume research justificar. |
| ~~49~~ | RESOLVED S232 post-close (via #51 DELETE path) | - | ~~Managed Agents evaluation~~ | Historical marker. |

---

## MORATORIUM-DEFERRED <a id="moratorium-deferred"></a>

> Items movidos de P1 no início do content moratorium (S234 Batch 2). Reavaliar apenas quando moratorium fechar (ver §P0 condições de saída). Não é "frozen permanent" — é "fora de consideração até produção ganhar tração". Histórico de cada item preservado no git log.

| # | Ex-tier | Item | Razão do defer |
|---|---------|------|----------------|
| 13 | P1 | g3-result memory findings audit | 78 sessões dormente; auto-viola governance L4 ("Dormant >10 sessões"); zero content impact |
| 18 | P1 | KBP-18 dispatch sem prompting skill | Meta process; sem content consumer |
| 29 | P1 | Agent/subagent optimization audit (10 agents) | Puro meta-tooling (HyperAgents/DGM/Voyager research); zero content unblock |
| 33 | P1 | Research persistence inter-sessão | Meta process template; content pode ir ad-hoc |
| 46 | P1 | Knowledge integration architecture (OLMO ↔ COWORK) | Research arquitetural; sem pain imediato |
| 50 | P1 | QA gate parallelism (ADR + pilot) | Luxo infra; QA sequential ainda funciona |
| 23 | P1 | Edit/Write permission glob Windows broken | Workaround S189 existente; meta-tooling |
| 1 | P1 | Pernas pendentes research (Perna 2 + 6) | Research infra; content pode usar pernas atuais |
| 4 | P1 | Pipeline DAG end-to-end (inbox → NLM → wiki) | Arquitetural; sem consumer ativo |
| 5 | P1 | medicina-clinica 4 stubs | Aguarda external harvest COWORK (ADR-0002); sem ação OLMO possível |

**Contagem:** 10 items. Próximo # ainda 52. Reativar apenas se §P0 condições de saída satisfeitas.

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
