# BACKLOG — Persistent Self-Improvement Channel

> Canonical SSoT per S225 LT-7 merge. Schema: tier (P0/P1/P2/Frozen/Resolved) + cat (infra/tooling/process/research/content) + effort (S/M/L).
> Governance: items surgem via backlog gate (S155). Attack top-down within tier. Movement: P0 → in-progress via HANDOFF. Done → Resolved. Dormant >10 sessões = audit candidate.
> Counts: P0=1 | P1=10 | P2=20 | Frozen=3 | Resolved=8 | Setup=separate. Next #=42.

## TOC

- [P0 — blocking próxima sessão](#p0) · [P1 — 2-3 sessões](#p1) · [P2 — sem urgência](#p2) · [Frozen](#frozen) · [Resolved — historical](#resolved) · [Setup & Infra](#setup)

---

## P0 — blocking próxima sessão <a id="p0"></a>

*(empty — no active blockers)*

---

## P1 — importante 2-3 sessões <a id="p1"></a>

| # | Cat | Effort | Item | Next action |
|---|-----|--------|------|-------------|
| 34 | infra | M | [S227 partial] cp Pattern 8 — CC 2.1.113 ask bypass | Investigation Opus+Codex done: `permissions.ask` fundamentally bypassed (cp/rm/Write all empirical). Applied: 34 destructive deny patterns. Manual via `/clear` + observe popup behavior in new session. Residual gap: redirects + script-file writes ungateable (KBP-26). Next: verify deny stability post-/clear, then close |
| 36 | content | L | Memory → Living-HTML migration (S227) | Run plan `.claude/plans/ACTIVE-S227-memory-to-living-html.md` steps 1-6. 6 medical .md → `content/aulas/cirrose/evidence/*.html` |
| 37 | infra | S | apl-cache-refresh.sh wrong BACKLOG path | L23 fix: `$PROJECT_ROOT/.claude/BACKLOG.md`. Write→tmp→cp (guard bloqueia Edit hooks/*.sh). Consequência: cache `backlog-top.txt` stale entre sessões. Descoberto S226 pós-close |
| 13 | process | M | g3-result memory findings audit | Revisar 15 findings `.claude/tmp/g3-result.md` antes do próximo /dream. Memory no cap 20/20. S156 |
| 29 | tooling | L | Agent/subagent optimization audit (10 agents) | Phase 1: tool restrictions; Phase 2: model routing (Sonnet/Haiku para repo-janitor/quality-gate); Phase 3: maxTurns calibration; Phase 4: HyperAgents/DGM patterns; Phase 5: parallelism (QA preflight/inspect/editorial); Phase 6: agent-as-skill migration. Refs: HyperAgents Golchian 2026, DGM Sakana 2025, Anthropic orchestrator-workers Dec 2024. S190 |
| 18 | process | S | KBP-18 dispatch sem prompting skill | Add Format C+ pointer → `feedback_agent_delegation §Pre-dispatch ritual`. 5 root causes: no pre-dispatch ritual, name-matching bias, momentum after correction, complexity-as-ceremony, cognitive vs hook layer. Hook enforcement proposal separado (L4 move, warn-level primeiro). S157 |
| 23 | tooling | M | Edit/Write permission glob Windows broken | Edit(.claude/skills/**) não faz match com paths absolutos Windows. Workaround S189: Edit/Write sem args. Investigar `:*` syntax vs path absoluto. Root cause: prefix match vs glob. Relacionado #12 |
| 33 | process | S | Research persistence inter-sessão | Output template obrigatório + plan archive como persistence layer + HANDOFF pointer discipline para pesquisas. Pattern: resultados em `.claude/plans/archive/` com tabela de edits + fontes + verificacao. S197 |
| 1 | research | M | Pernas pendentes research | Perna 2 (evidence-researcher), Perna 6 (NLM: requer login) |
| 4 | infra | L | Pipeline DAG end-to-end | external inbox → NLM → wiki (ADR-0002) |
| 5 | content | M | medicina-clinica 4 stubs | Aguardar external harvest via `$OLMO_INBOX` (ADR-0002). 4 concepts stub/low |

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
| 41 | research | L | Research orchestrator (future, fresh design) | OLMO teve stub Python (`agents/scientific/`, `subagents/analyzers/`) deletado S228 após auditoria adversarial (aspiracional sem consumer). Live tool hoje: `.claude/agents/evidence-researcher` (6 braços MCP: PubMed/Scite/Consensus/Semantic Scholar/CrossRef/BioMCP) + `.claude/skills/mbe-evidence`. Quando demanda emergir: **design fresh**, não ressuscitar stub. Taleb/anti-drift: feature sem demanda = dívida. Ref plan `.claude/plans/groovy-launching-steele.md`. S228 |

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

### Process/governance

| # | Cat | Effort | Item | Detalhe |
|---|-----|--------|------|---------|
| 6 | process | M | Skill de slides consolidada | Usar skill-creator para criar skill nova |
| 8 | process | S | Postmortem dead JSON+py pipeline | Lucas: "para registrar". S156+ |
| 9 | process | M | S155 Group E slide-patterns vs slide-rules drift | 5 findings em `.claude/tmp/c1-result.md` (C1 #6-#10). Defer slide-focused session (CSS/runtime + Lucas working area) |
| 17 | process | L | Context reduction — qualitative findings S157 | Adversarial review S158 descartou números (bytes/4 não tokenizado), P11/P12, §6 meta-proposals, KBP-17 conflict. **Trigo preservado:** (a) P5 ground truth = 8 files auto-loaded; (b) Codex R6/R7 demoted; (c) procedural gates (R1/R2/R3/R5 caveats); (d) KBP-18 renumerado (item 18). **Pre-exec obrigatório:** tokenizer real + red team verdadeiro. Synthesis: `.claude/workers/reducao-context/synthesis-2026-04-11-1631.md` |
| 31 | process | M | Sentinel audit quality — melhoria contínua | S196: sentinel errou 1 claim + orchestration truncou (50 tool calls sem report). Melhorias: (1) verificação cruzada antes de claim, (2) report estruturado, (3) scope 1 dir/concern, (4) maturity tier. Aplicar proven-wins.md ao audit |

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
