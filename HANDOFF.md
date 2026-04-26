# HANDOFF - Proxima Sessao

> **S254 "Infra-rapido" — quick wins backlog (close):**
>
> 3 commits main: `b559fbb` (close A) → `3f488e0` (flag disable) → `<docs>` (S255 prep) sobre `e5cbe85` S253-tail.
>
> **🟢 Entregas S254:**
> - **KBP-40 codified** — branch awareness rule. Inline em `anti-drift.md §Verification`: "Claim about branch → `git branch --show-current` (SessionStart `gitStatus` snapshot decai durante sessão)". Entry pointer em `known-bad-patterns.md` KBP-40. Header bumped `Next:KBP-40`→`Next:KBP-41` (WebFetch defer'd reservado).
> - **Flag disable temp** (`3f488e0`) — `/insights` + `/dream` SessionStart banners wrapped em `if false; then ... fi` em `hooks/session-start.sh` (lines 82-91 + 111-122). Lucas reportou 4-5x recurring false positives. **Symptom suppressed ~95% · root cause intact 0%** — debug enfileirado em BACKLOG #63 systematic-debugging (passos a-e).
> - **HANDOFF + CHANGELOG** rewritten S253→S254 close + S255 prep update.
> - **Plan archived** `cozy-coalescing-bengio.md` → `archive/S254-*`.
> - **`.gitattributes` criado** (S254-tail) — `* text=auto eol=lf` previne CRLF artifacts em diffs futuros (lesson de settings.json + BACKLOG inflados S254). Retroactive renormalize não aplicado (defer sessão dedicada).
>
> **🎯 PROXIMA SESSÃO S255 — herdada de S254 (não executada):**
> 1. **Build/arrange 2-3 slides** (likely metanálise; `lovely-sparking-rossum.md` reference reduzido).
> 2. **Migrate 3 existing JS scripts → agents/subagents/skills com benchmark** + `chatgpt-research.mjs` NEW (4th model team):
>    - `gemini-research.mjs` · `gemini-review.mjs` · `perplexity-research.mjs` · **`chatgpt-research.mjs` NEW (Codex CLI gpt-5.5)**
>    - Sequence: (a) audit model names/params → (b) benchmark 4 scripts × N runs latency+token+quality → (c) launch research real (Lucas query)
>    - Quality bar: 9-9.5
>    - Decision pendente: agent vs subagent vs skill per script
> 3. **Testar skills + agents funcionando** (Lucas explicit S254-tail) — verificar funcionalidade real além do core. Skills priority: `/insights`, `/dream` (post-disable lifecycle test), `/research`, `/debug-team`. Agents priority: 16 catalogued em `/dream` tooling-pipeline (S253 dream consolidated). Method: smoke-test 1 invocation real per item → captura ✓/✗ → aggregate report. **Conexão BACKLOG #63:** test do /insights + /dream cycle natural surface root cause da flag bug (b ou c do passos a-e).
>
> **DEFER S256+ (não bloquear S255):**
> - P0(d) audit batch G+H (28 pendentes); H4/X3 destrutivos (propose-before-pour); KPI snapshot wiring; P2 sota-intake skill; per-arm matrix §17.1-§17.12.
>
> **HIDRATACAO S255 (3 passos — single source of truth):**
> 1. `git log --oneline -10` — confirm S253→S254 chain (6 commits S253-S254: `dc78ff5`→`8fdc4a5`→`e5cbe85`→`b559fbb`→`3f488e0`→S254 docs)
> 2. Read `.claude/plans/immutable-gliding-galaxy.md` (Conductor 2026 unified — META + §6 council + §16 backlog + §17 per-arm + §18 audit)
> 3. Read `.claude/scripts/{gemini,perplexity}-research.mjs` + `.claude/scripts/gemini-review.mjs` (existing JS to migrate; works well, só improve)
>
> **Cautions S255:**
> - **Mellow-scribbling-mitten Track A P5 in-flight** em outra window/branch (anti-drift.md + CLAUDE.md modified). NÃO TOCAR — Lucas owns aquela track + cherry-pick later. Plan persiste em `.claude/plans/` apenas no branch feat (not main).
> - **`.claude/scripts/*-research.mjs` funcionam bem** — Lucas explicit "só podem ser melhorados". Não rewrite from scratch; wrap + improve.
> - **Branch awareness (KBP-40 codified S254):** SessionStart `gitStatus` snapshot decai durante sessão. Always `git branch --show-current` antes de commit. Rule agora persistida em `anti-drift.md §Verification`.
> - **Flag disable é workaround KBP-07 escape válido:** `/insights` + `/dream` blocks `if false; then` suppress symptom (~95% conf) mas root cause (skills não escrevem `.last-insights` / não deletam `.dream-pending` no close) **intacto (0% conf)**. Re-enable sem systematic-debugging primeiro = regressão garantida. BACKLOG #63 lista passos a-e. Honest confidence > inflated claims.
>
> **Plans active (2, post-S254 close):**
> - `immutable-gliding-galaxy.md` — Conductor 2026 single source of truth (META + audit + execution + per-arm matrix)
> - `lovely-sparking-rossum.md` — metanálise QA (deadline removida; reference para 2-3 slides)
>
> **Backlog deferido (post-S254):**
> - /insights P253-001 backlog triage (P0 `BACKLOG.md` 41 items STAGNANT 19 sessions) — defer until P0(d) audit complete
> - **KBP-41 codify** (WebFetch URL lifecycle 7 fires) — defer until P2 sota-intake skill exists (number bumped from KBP-40 reservation; branch-awareness took KBP-40)
> - **BACKLOG #63** (S254 NEW) — SessionStart flags `/insights` + `/dream` systematic-debugging (passos a-e); test do S255 priority #3 surface root cause natural
> - **Conductor §6.5 G9** (S254 NEW) — Maturity layers (SDL/SAMM/OpenSSF/CMMI) SOTA radar; spec em `docs/research/external-benchmark-execution-plan-S248.md §B5` mas non-operational; P2 radar não active
> - QA editorial metanalise (3/19 done) — connects S255 slide work
> - R3 Clínica Médica prep — 218 dias (long-running)

Coautoria: Lucas + Opus 4.7 (Claude Code) | S254 Infra-rapido quick wins + flag disable + S255 prep | 2026-04-26
