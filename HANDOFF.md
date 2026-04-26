# HANDOFF - Proxima Sessao

> **S254 "Infra-rapido" — quick wins backlog (close):**
>
> 1 commit main: `<close>` sobre `e5cbe85` S253-tail.
>
> **🟢 Entregas S254:**
> - **KBP-40 codified** — branch awareness rule. Inline em `anti-drift.md §Verification`: "Claim about branch → `git branch --show-current` (SessionStart `gitStatus` snapshot decai durante sessão)". Entry pointer em `known-bad-patterns.md` KBP-40. Header bumped `Next:KBP-40`→`Next:KBP-41` (WebFetch defer'd reservado).
> - **HANDOFF + CHANGELOG** rewritten S253→S254 close.
> - **Plan archived** `cozy-coalescing-bengio.md` → `archive/S254-*`.
>
> **🎯 PROXIMA SESSÃO S255 — herdada de S254 (não executada):**
> 1. **Build/arrange 2-3 slides** (likely metanálise; `lovely-sparking-rossum.md` reference reduzido).
> 2. **Migrate 3 existing JS scripts → agents/subagents/skills com benchmark** + `chatgpt-research.mjs` NEW (4th model team):
>    - `gemini-research.mjs` · `gemini-review.mjs` · `perplexity-research.mjs` · **`chatgpt-research.mjs` NEW (Codex CLI gpt-5.5)**
>    - Sequence: (a) audit model names/params → (b) benchmark 4 scripts × N runs latency+token+quality → (c) launch research real (Lucas query)
>    - Quality bar: 9-9.5
>    - Decision pendente: agent vs subagent vs skill per script
>
> **DEFER S256+ (não bloquear S255):**
> - P0(d) audit batch G+H (28 pendentes); H4/X3 destrutivos (propose-before-pour); KPI snapshot wiring; P2 sota-intake skill; per-arm matrix §17.1-§17.12.
>
> **HIDRATACAO S255 (3 passos — single source of truth):**
> 1. `git log --oneline -10` — confirm S253→S254 chain (4 commits `dc78ff5`→`8fdc4a5`→`e5cbe85`→S254 close)
> 2. Read `.claude/plans/immutable-gliding-galaxy.md` (Conductor 2026 unified — META + §6 council + §16 backlog + §17 per-arm + §18 audit)
> 3. Read `.claude/scripts/{gemini,perplexity}-research.mjs` + `.claude/scripts/gemini-review.mjs` (existing JS to migrate; works well, só improve)
>
> **Cautions S255:**
> - **Mellow-scribbling-mitten Track A P5 in-flight** em outra window/branch (anti-drift.md + CLAUDE.md modified). NÃO TOCAR — Lucas owns aquela track + cherry-pick later. Plan persiste em `.claude/plans/` apenas no branch feat (not main).
> - **`.claude/scripts/*-research.mjs` funcionam bem** — Lucas explicit "só podem ser melhorados". Não rewrite from scratch; wrap + improve.
> - **Branch awareness (KBP-40 codified S254):** SessionStart `gitStatus` snapshot decai durante sessão. Always `git branch --show-current` antes de commit. Rule agora persistida em `anti-drift.md §Verification`.
>
> **Plans active (2, post-S254 close):**
> - `immutable-gliding-galaxy.md` — Conductor 2026 single source of truth (META + audit + execution + per-arm matrix)
> - `lovely-sparking-rossum.md` — metanálise QA (deadline removida; reference para 2-3 slides)
>
> **Backlog deferido (post-S254):**
> - /insights P253-001 backlog triage (P0 `BACKLOG.md` 41 items STAGNANT 19 sessions) — defer until P0(d) audit complete
> - **KBP-41 codify** (WebFetch URL lifecycle 7 fires) — defer until P2 sota-intake skill exists (number bumped from KBP-40 reservation; branch-awareness took KBP-40)
> - QA editorial metanalise (3/19 done) — connects S255 slide work
> - R3 Clínica Médica prep — 218 dias (long-running)

Coautoria: Lucas + Opus 4.7 (Claude Code) | S254 Infra-rapido quick wins backlog | 2026-04-26
