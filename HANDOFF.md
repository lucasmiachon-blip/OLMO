# HANDOFF - Proxima Sessao

> **S249 "infra3 + agents + e2e" — 3 commits main, orchestrator + KBP-37 shipped:**
> - **Phase 1 (commit `0ae043e`):** `hooks/loop-guard.sh` D9 advisory-mode + `.claude/settings.json` PostToolUse registration. Self-disable via `.claude-tmp/.debug-team-active` flag (zero overhead em sessões fora de /debug-team). Thresholds 4 Bash / 5 file edit / 3 validator-iter (fire em == crossing, sem spam após). Synthetic test 13 casos pass.
> - **Phase 2 (commit `11e44f0`):** `.claude/skills/debug-team/SKILL.md` 485 li. 11-step orchestrator (collector → routing D8 → architect → D10 Lucas confirm → editor → validator + loop max 3). user-only invocation (`disable-model-invocation: true`). State contract single-writer-per-field (orchestrator owns iter, hook owns counters).
> - **KBP-37 (commit `8a906ae`):** "Elite faria diferente" must be actionable — 3 destinos válidos (doing-now / deferred-with-gate / cut). EC loop hardening contra pseudo-confessional. Origem: S249 conversation antidote.
> - **Phase 3 partial:** `claude agents` CLI canonical confirms 21 active inc 7 debug + skill via /skills. /agents UI screenshot mostrou só 9 — alfabeticamente scrolled past `d` (debug-* before evidence-researcher).
> - **Phase 4 e2e BLOCKED:** Agent tool in-session registry SEM debug-* mesmo após Lucas window-restart. Smoke test via `general-purpose` proxy stopped mid-flow — Lucas observou "agente nao ficou com cor" = visual confirm não-real e2e. Output partial em `.claude-tmp/...`.
> - **Background investigation memory: project gap:** 4 agents missing (mbe-evaluator, quality-gate, repo-janitor, researcher) é INTENTIONAL per S84+S121 deliberate commits — defer-by-evidence (não batch fix sem failure case real).
>
> **🔴 Pendente S249 → S250 (priority order):**
> 1. **Full CC quit + reopen** (Ctrl+Q / system tray exit, NÃO só fechar window). Daemon-level restart obrigatório pra Agent tool in-session registry pegar 7 debug-*. Sem isso `/debug-team` não consegue spawn real agents.
> 2. **Real e2e dry-run /debug-team** após registry fresh. Target candidato: `hooks-que-nao-disparam` (partial work em `.claude/plans/debug-hooks-nao-disparam.md`, collector proxy stopped mid-investigation) OU `B1.2 ci.yml` (carryover S248). Comparar metrics/outputs vs proxy run.
> 3. **Audit + merge agents + skills + subagents + hooks** (Lucas explicit request S249): "muitos podem ser merged, muitos longe do SOTA até hoje". Multi-session refactor. Identifica redundancy + SOTA gaps. Provavelmente precisa pesquisa SOTA dedicada antes.
> 4. **B1.2 ci.yml mypy paths stale** (carryover S248): `.github/workflows/ci.yml` L32 deve ser `mypy scripts/ config/` (era `agents/ subagents/ config/` purged S232) + drop pytest L34-35 (no tests/ tracked).
> 5. **B3 content/aulas/package.json dead scripts:** `research:cirrose|metanalise` apontam stub. Echo-redirect → /research skill (S144 lint:narrative-sync pattern).
> 6. **#191 upstream comment** — Lucas valida + posta `.claude-tmp/upstream-comment-191.md` via `gh issue comment 191 -R openai/codex-plugin-cc -F ...`.
>
> **HIDRATACAO S250 (4 passos pos-quit-CC):**
> 1. `git log --oneline -10` — confirma cadeia 3 commits S249 sobre `a86368e` S248-close.
> 2. **`claude agents` CLI** (Bash) — deve listar 21 active inc 7 debug. Se menos = quit incompleto, retry.
> 3. **Test Agent tool registry:** spawn dummy `debug-symptom-collector` via Agent tool. Erro "agent type not found" = registry stale, mais full quit. Sucesso = registry refreshed, prossegue Phase 4.
> 4. Read `.claude/plans/archive/S249-partitioned-jumping-summit.md` (S249 plan archived) + `.claude/plans/debug-hooks-nao-disparam.md` (template + partial).
>
> **Cautions S250:**
> - **Window restart ≠ daemon restart pra Agent tool registry** (KBP-38 candidate). `claude agents` CLI = canonical truth. /agents UI = display (scrollable, verifica Up arrow). Agent tool in-session = separate registry (refresh só em daemon-level Ctrl+Q + reopen). Verificar via `claude agents` CLI antes de qualquer "silently dropped" hypothesis.
> - **SOTA hypothesis em-dash em description é FALSE POSITIVE** — claude-code-guide propôs (H1 high), dados refutaram (debug-validator 0 em-dashes não show pré-restart; reference-checker 1 em-dash show). Agents registram com em-dashes. Lição: hypothesis SOTA-source ≠ dato local.
> - **Codex CLI 0.118.0 model issue:** gpt-5.5 default returns "needs newer version"; gpt-5 returns "not supported on ChatGPT account". Pode precisar `codex update` antes de adversarial diagnose. Workaround: Gemini API node script funciona (60s deep think OPEN/CLOSED schema reproduzível).
> - **`claude agents` CLI canonical primeiro, agent tool depois.** 5s diagnostic > 10min spawn agentes pra inferência. KBP candidate em S249 aprendizados.
>
> **Backlog diferido (S243-S249, ativo):**
> - shared-v2 Day 2/3 (`.claude/plans/S239-C5-continuation.md` PAUSADO), grade-v2 scaffold C6 (deadline 30/abr T-5d), metanalise C5 s-heterogeneity (`.claude/plans/lovely-sparking-rossum.md`)
> - Tier 3-5 documental (Q1 AGENTS.md / Q2 GEMINI.md / Q3 research-S82 / Q4 CHANGELOG threshold)
> - Migrar §Script primacy → §Agent/Subagent/Skill primacy em `anti-drift.md`
> - QA editorial metanalise (3/19 done)
> - R3 Clínica Médica prep — 219 dias, trilha paralela

Coautoria: Lucas + Opus 4.7 (Claude Code) | S249 infra3+agents+e2e | 2026-04-25
