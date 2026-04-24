# HANDOFF - Proxima Sessao

> **S244 DONE em main:** 5 commits detox instruction files (CLAUDE.md raiz + `.claude/rules/*`). SOTA Boris/Anthropic/HumanLayer aplicado (prune test, pointer pattern, path-scoped rules). 18+ linhas de session-history S-refs zerado; 0 regras operacionais perdidas.
> - Commits: `cff80e1` CLAUDE.md §Architecture · `4112316` CC gotchas → `cc-gotchas.md` path-scoped · `4e0c011` anti-drift 9 violações removidas · `a9b8a4a` KBP pointer trims · [este] state files.
> - Plan: `.claude/plans/gleaming-painting-volcano.md`
>
> **🔴 TOP PRIORITY S245 — Migrar §Script primacy → §Agent/Subagent/Skill primacy em `.claude/rules/anti-drift.md`.**
> Lucas (S244): *"agents e subagents vão incorporar parte dos scripts; agents, subagents e skills serão primacy"* + *"vão ser legacy ainda não são, mas vamos arrumar para ser"*.
>
> **Strategic direction:** scripts em `content/aulas/scripts/` deixam de ser canonicals exclusivos — agents (`.claude/agents/*.md`) e skills (`.claude/skills/*/SKILL.md`) incorporam parte dos scripts e viram source-of-truth. Regra anti-drift deve refletir essa inversão.
>
> **Sub-tasks S245:**
> - Auditar scripts em `content/aulas/scripts/` — quais já têm cobertura em agent/skill? Quais migrar? Quais ficam standalone?
> - Reescrever §Script primacy → §Agent/Subagent/Skill primacy (linguagem refletindo nova arquitetura)
> - Possível ajuste `CLAUDE.md §Architecture` para mencionar agents/skills como primacy operacional
> - Pass similar: outras seções anti-drift — aplicar Boris prune test ("Would removing cause mistakes?"). §Plan execution, §Adversarial review, §Budget auditar.
> - Deliverable: commit `docs(rules): anti-drift primacy-migration`.
>
> **Depois da priority acima: continuar "Batch 5 infra documental"** — Tier 1+Tier 2 feitos. **Tiers 3-5 + Pós-tiers pendentes** — cada um exige decisões Lucas marcadas ⚠️ abaixo.

## HYDRATION (3 passos)

1. `git log --oneline -15` — confirma cadeia S243 infra + T1/T2 em main.
2. `ls docs/ docs/archive/ .claude/plans/ .claude/plans/archive/` — estado pós-reorg.
3. Escolher próxima etapa no P0 (Tier 3 natural next; pós-tiers requer setup maior).

---

## P0 — Etapas granulares (Lucas escolhe sequência)

### Tier 3 — Top-level docs polish (~2h)

**Decisões bloqueantes (Q1 + Q2):**

- **Q1 ⚠️ `AGENTS.md`** (3.8KB, Apr 19) — legacy pós-S232 Python-free ou ainda útil?
  - (a) Keep + refresh como "agent ecosystem overview" (referenciar `.claude/agents/*.md` 9 subagents)
  - (b) Archive (obsoleto; `.claude/agents/` já é source of truth)
  - (c) Consolidar conteúdo em `docs/ARCHITECTURE.md`

- **Q2 ⚠️ `GEMINI.md`** (2.6KB, Apr 4 — top-level mais antigo) — ainda relevante?
  - (a) Keep + refresh (MCP Gemini + research/SKILL.md Perna 1 + gemini-qa3.mjs)
  - (b) Archive
  - (c) Merge em `docs/ARCHITECTURE.md §Multimodel`

**Tasks paralelizáveis (não bloqueadas por Q1/Q2):**

- T3.1 `CLAUDE.md` raiz refresh — 5KB, último touch Apr 22 (S241 CC schema gotchas). Verify: S243 changes (hooks 181→215, deny-list 46→60) documentados? Seção Architecture atual?
- T3.2 `README.md` refresh — 2.2KB, Apr 20. Entry point. Verify: intro accurate vs reality atual; getting-started path claro; shared-v2 + grade-v2 context.
- T3.3 `docs/TREE.md` gaps — `docs/adr/` subtree MISSING (6 ADRs não listados). Possível: `.claude/agents/`, `.claude/skills/`, `content/aulas/` subtrees outdated. Audit completo.
- T3.4 `docs/ARCHITECTURE.md` currency — §MCP Connections vs `config/mcp/servers.json`; §Notion Crosstalk Pattern ainda aplicável; S243 security changes (ADR-0006 addendum + KBP-33) mencionados?

### Tier 4 — docs/aulas + docs/research review (~1.5h)

**Decisão bloqueante:**

- **Q3 ⚠️ `docs/research/implementation-plan-S82.md`** — S82 muito antigo. Archive candidate (mesma pattern Tier 1)?

**Tasks granulares (docs/aulas):**

- T4.1 `design-principles.md` — 27 principles. Currency: stale refs vs shared-v2 + grade-v2 existing.
- T4.2 `slide-pedagogy.md` — assertion-evidence. Verify vs `.claude/rules/slide-rules.md` (dupes? conflicts?).
- T4.3 `slide-advanced-reference.md` — técnicas avançadas. Cross-refs intact?
- T4.4 `css-error-codes.md` — E07/E20-E52. Adicionar **E22 S238** (`@import` before `@font-face`)? Alinhar numbering com `.claude/rules/slide-rules.md §Errors`.

**Tasks granulares (docs/ top-level):**

- T4.5 `GETTING_STARTED.md` — currency vs post-S232 Python-free reality.
- T4.6 `keys_setup.md` — API keys. Ainda cobre Claude Max + Gemini API + Ollama?
- T4.7 `SYNC-NOTION-REPO.md` — Notion sync legacy (ADR-0002 cross-talk). Current status vs ADR?
- T4.8 `coauthorship_reference.md` — format `Coautoria: Lucas + [modelos]`. Accurate?
- T4.9 `mcp_safety_reference.md` — reconcile com `config/mcp/servers.json` + `.claude/settings.json` deny/allow lists.

**Tasks granulares (research):**

- T4.10 `chaos-engineering-L6.md` — L6 context. Ainda relevante operacionalmente?
- T4.11 `content/aulas/metanalise/CLAUDE.md` — per-aula rules. Propagations corretas pós-S243 deadline relaxation + shared-v2 posture (ADR-0007)?

### Tier 5 — CHANGELOG rotation ⚠️ (~1h)

**Decisão bloqueante (Q4):** threshold de corte.

- **Estado atual:** `CHANGELOG.md` 354KB / ~9000 linhas / S1 até S243.
- **Existente:** `docs/CHANGELOG-archive.md` (verificar tamanho + último session).

**Opções threshold (escolher uma):**

- (a) **Sessão <S200** — preserva S200-S243 inline (~44 sessões). Simples, alinhado ao "recentes".
- (b) **Sessão <S150** — preserva S150-S243 inline (~94 sessões). Mais conservador.
- (c) **Rolling últimas 30 sessões** — dynamic cut. Requires rotation process setup.
- (d) **Rolling últimas 50 sessões**.
- (e) **Calendário: todas <2026** para archive. Only current-year inline.

**Critério decisório:** balance (1) quick findability inline vs (2) context window peso hydration.

**Non-trivial:** CHANGELOG atual é APPEND-ONLY per anti-drift §State files. Rotação é operação raramente feita; preservar regra escrevendo "rotação S243-T5 em `archive/` path" + manter main CHANGELOG pós-cutoff.

### Pós-Tiers — Meta-trabalho (~3-4h, outra sessão)

1. **`/insights` run** — review trends/proposals acumulados. Statusline mostra "4d atrás" / pendente bi-diário. **Nota:** statusline atual mostra "220 dias R3" — trigger automático para rodar insights.

2. **`context7 evolve`** ⚠️ — Lucas mencionou. **Clarificar:** é o MCP `context7` (atualmente em deny-list, linha 66 settings.json) ou outra ferramenta? Se MCP, reativação temporária precisa justificativa.

3. **SOTA research launch — agents + subagents + skills:**
   - **Target:** patterns state-of-the-art (early 2026) que OLMO ainda não adotou.
   - **Format:** 3 agents paralelos (match S241 SOTA pattern):
     - **Agent 1:** Claude Code native agents — best practices, subagent composition, Task tool patterns
     - **Agent 2:** Anthropic agentic SDK evolution 2025-2026 + Managed Agents
     - **Agent 3:** Skill-based architecture (Claude Code skills native vs custom skill systems)
   - **Deliverable:** novo plan file + matriz `ADOPT/EVAL/IGNORE/ALREADY` por área OLMO.
   - **Escopo suggested:** 7×3 matriz (7 áreas × 3 reports) — similar S241.

### Ordem recomendada

1. **Tier 3 primeiro** — depende apenas de Q1+Q2 (AGENTS.md/GEMINI.md decisions + paralelizáveis)
2. **Tier 4 após** — Q3 decisão + execução
3. **Tier 5 após** — Q4 decisão crítica (threshold) + rotação
4. **Pós-tiers** — meta trabalho, outra sessão (context fresh preferível)

### Próximas sessões (pós Batch 5 infra docs)

1. **grade-v2 scaffold C6** — deadline 31/mai/2026 (T-38d, relaxed). ADR-0007 posture ativa. Iniciar quando Lucas autorizar (infra primeiro).
2. **shared-v2 Day 2/3 continuation** (`.claude/plans/S239-C5-continuation.md` PAUSADO) — C5 Grupo B/C + ensaio HDMI.
3. **metanalise C5 s-heterogeneity** (`.claude/plans/lovely-sparking-rossum.md`) — 10 slides sem QA; 5 R11<7; 2 editorial curso.
4. **R3 Clínica Médica prep** — 220 dias, trilha paralela.

---

## Estado factual

- **Git HEAD (main):** `7ddfb60` (Tier 2 commit). Origin sync.
- **Branches locais:** só `main` + `codex/roadmap` + `legacy/grade-v1` (feature branch `s243-adversarial-patches` deletada pós-merge).
- **Aulas:** cirrose 11 prod / metanalise 17 (s-etd modernizado) / grade-v2 scaffold pendente / grade-v1 archived.
- **shared-v2:** Day 1 + C4.6 + C5 Grupo B/C parciais; PAUSADO. **ADR-0007 formaliza migration posture (bridge-incremental)**.
- **metanalise QA:** 10 sem QA; 5 R11<7; 2 editorial em curso.
- **R3 Clínica Médica:** 220 dias · **Deadline grade-v2:** 31/mai/2026 (T-38d, relaxed).
- **Deny-list:** 46→60 patterns (S243 +14 aplicando ADR-0006 addendum).
- **Hooks:** `guard-bash-write.sh` 181→215 li (P20-23 awk/find/xargs/make hazards); `stop-failure-log.sh` 29→56 li (fail-complete semantic).
- **Docs reorg S243:** `docs/archive/` (3 audits) + `.claude/plans/archive/` (7 plans total) limpos. `docs/TREE.md` atualizado.

---

## Âncoras essenciais

- **Plans ativos (3):** `README.md` (meta) · `S239-C5-continuation.md` (C5 PAUSADO) · `lovely-sparking-rossum.md` (metanalise QA).
- **Plans archive recente (S243 T1):** `archive/S242-glimmering-coalescing-ullman.md` (32 findings) · `archive/S243-tingly-chasing-breeze.md` · `archive/S241-infra-plataforma-sota-research.md` · `archive/S238-snoopy-bubbling-moore.md` · `archive/S236-parallel-popping-book.md`.
- **docs/archive (S243 T2):** `S079-agent-audit.md` · `S150-evidence-html-audit.md` · `S151-pmid-verification.md`.
- **Audit outputs (`.claude-tmp/`, untracked):** `adversarial-{claude-ai,gemini}-output.md` · `codex-audit-batch-c.md` · `audit-batch-{a,b}-v2.md` · `s-etd-c2-preview.png`.
- **ADRs:** `0005-shared-v2-greenfield.md` · `0006-olmo-deny-list-classification.md` (**addendum S243 DONE**) · `0007-shared-v2-migration-posture.md` (**S243 DONE**).
- **Primacy:** `CLAUDE.md §ENFORCEMENT` · `.claude/rules/anti-drift.md` · `known-bad-patterns.md` (**KBP-33 DONE**; next: KBP-34).

Coautoria: Lucas + Opus 4.7 (Claude Code) | S243 infra + docs cleanup T1-T2 | 2026-04-23
