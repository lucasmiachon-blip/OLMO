# HANDOFF - Proxima Sessao

> **S250 "todos-em-batches" — 5 commits main, e2e validation + 3-model audit + KBP-38:**
> - **Batch A (commits `e3404dd` + `e1ceb32`):** B1.2 `.github/workflows/ci.yml` L32 mypy paths align repo real (purged `agents/subagents/` → `scripts/ config/`) + drop L34-35 pytest step. B3 `content/aulas/package.json` L29-30 echo-redirect dead `research:*` scripts (pattern S144 lint:narrative-sync).
> - **Batch B (commit `7d68d64`):** /debug-team e2e dry-run em `ci-hatch-build-broken` — verdict **pass first try** (single_agent path, complexity_score=85, validator_loop_iter=0). Bug real descoberto durante Batch A.1 diagnostic: `pyproject.toml` faltava `[tool.hatch.build.targets.wheel]`. Fix 3-line + uv.lock self-heal stale `ai-agent-ecosystem==0.2.0` → `olmo==0.3.0` (1241 linhas dropped). BACKLOG #60 fully resolved.
> - **Batch C (commit `ae82f67`):** 3-model audit research Phase 1 — Opus 4.7 + Gemini 3.1 Deep Think + ChatGPT 5.5 xhigh, schema-strict JSON outputs (codex `--output-schema` proper flag, no workaround). Decision matrix em `.claude/plans/audit-merge-S251.md`. ADOPT-NEXT (S251 ~6h): H4 systematic-debugging→debug-team merge, X1 janitor→repo-janitor merge, X3 chaos-inject-post hook ordering. KBP-32 spot-check pego 4+ FPs across voices.
> - **Batch D (no commit):** #191 upstream codex stop-hook comment posted at `https://github.com/openai/codex-plugin-cc/issues/191#issuecomment-4320811444`.
> - **Batch E (this commit):** session close + KBP-38 (window-restart ≠ daemon-restart pra Agent tool registry) commit em `cc-gotchas.md §Agent tool registry refresh`.
>
> **🟢 Lições absorvidas mid-session (Lucas-instructed):**
> - **"Sempre profissional, sem atalhos"** (KBP-37 reinforced) — proper grep granular antes de claims, ler docs antes de Edit, EC loop rigoroso.
> - **"Memória e rules de forma granular"** (KBP-23 align) — targeted reads (limit + offset), Grep before full-file Reads.
> - **"Arrume sem workaround"** (KBP-07 reinforced) — codex `--output-schema` flag > prompt-level "DO NOT use tools" instruction.
> - **3-model methodology validated empiricamente:** convergence > average. ChatGPT xhigh ROI quando false-negative cost > waiting cost. KBP-32 spot-check é o cross-validation core.
>
> **🔴 Pendente S250 → S251 (priority order):**
> 1. **S251.A — H4 systematic-debugging skill → debug-team merge** (1 commit, ~1h). Fold systematic-debugging como lightweight/solo fallback section dentro de debug-team SKILL, remove standalone trigger. Per ChatGPT specific proposal.
> 2. **S251.B — X1 janitor skill → repo-janitor agent merge** (1 commit, ~30min). Keep repo-janitor como executor canonical, janitor skill vira thin wrapper OU delete. ChatGPT 1/3 + Opus spot-check confirmou (.claude/skills/janitor/SKILL.md L4 vs .claude/agents/repo-janitor.md L3).
> 3. **S251.C — X3 chaos-inject-post + model-fallback-advisory hooks ordering fix** (1 commit, ~1h). chaos-inject-post.sh L7 assume sequential ordering MAS Anthropic docs dizem hooks paralelos por matcher. Merge into single ordered handler OR refactor chaos para next-cycle semantics.
> 4. **S251.D — G1 disallowedTools → tools allowlist** para 6 read-only agents (debug-symptom-collector, repo-janitor, researcher, sentinel, systematic-debugger, quality-gate). Per Anthropic docs: omitted tools INHERIT parent tool pool incluindo MCP — denylist mais leak que esperado. ~2h.
> 5. **S251.E — G3 debug-team metrics instrumentation** (1 commit, ~1h). Phase tokens/wall-clock fields em plan template existem mas não populados in-flow. Instrumentar em SKILL.md state writes.
>
> **Backlog defer S252+:**
> - **G2 debug-team durable state** — checkpointer pattern (LangGraph durable-execution research). Multi-session.
> - **G5 Agent Teams pilot** — native Anthropic experimental pattern para competing-hypotheses phase. Quick research first para assess GA timeline.
> - **X2 systematic-debugger AGENT** measurement post H4 merge.
>
> **HIDRATACAO S251 (3 passos):**
> 1. `git log --oneline -10` — confirma cadeia S250 (`e3404dd → e1ceb32 → 7d68d64 → ae82f67 → <session-close>`) sobre `a86368e` S248-close.
> 2. Read `.claude/plans/audit-merge-S251.md` integral — decision matrix + ADOPT-NEXT priority + raw model outputs em `.claude-tmp/audit-{opus,gemini,chatgpt}-output.json`.
> 3. `claude agents` CLI — deve listar 21 active. Se ausente algum debug-*, full quit Ctrl+Q + reopen (KBP-38 cc-gotchas.md §Agent tool registry refresh).
>
> **Cautions S251:**
> - **Codex CLI xhigh reasoning** está default em `~/.codex/config.toml` `model_reasoning_effort = "xhigh"`. Calls demoram ~20min. Override CLI: `-c model_reasoning_effort="medium"` para tasks scope-bem-definido.
> - **Permission gate fires em external GitHub posts** — explicit literal text confirmation no chat, não AskUserQuestion answer (gate doesn't accept tool-mediated). Workaround proper: user types `! gh issue comment ...` direto.
> - **uv.lock pode self-heal** quando pyproject.toml package definition muda. Sempre commit uv.lock junto (atomic).
>
> **Backlog diferido (S243-S250, ativo):**
> - shared-v2 Day 2/3 (`.claude/plans/S239-C5-continuation.md` PAUSADO), grade-v2 scaffold C6 (**deadline 30/abr T-5d** — KBP candidate quando passa)
> - metanalise C5 s-heterogeneity (`.claude/plans/lovely-sparking-rossum.md`)
> - Tier 3-5 documental (Q1 AGENTS.md / Q2 GEMINI.md / Q3 research-S82 / Q4 CHANGELOG threshold)
> - Migrar §Script primacy → §Agent/Subagent/Skill primacy em `anti-drift.md`
> - QA editorial metanalise (3/19 done)
> - R3 Clínica Médica prep — 218 dias, trilha paralela

Coautoria: Lucas + Opus 4.7 (Claude Code) + Gemini 3.1 Deep Think + ChatGPT 5.5 (xhigh) | S250 todos-em-batches | 2026-04-25
