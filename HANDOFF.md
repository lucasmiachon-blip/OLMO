# HANDOFF - Proxima Sessao

> **S255 "debug-team-hooks" closed** — 4 hook teatros fixed: A1 stdin drain (session-start + session-compact) + A2 post-global-handler S225 path + A3 5736 orfaos purge + A6 banner.sh idempotent guard. Commits chain: `20e1e9a` → `fd77bbc` → `9d91c8b` → `7218c01` + docs close. Detalhes/aprendizados: `CHANGELOG.md §S255`. Push state: confirme via `git status` (claim "ahead origin" sofre recursao quando incluida no proprio HANDOFF — KBP-40 corollary).

## 🔥 P0 — S256 core (Lucas pick: A ou B)

**Opção A — Continuar debug-team-hooks domain:**
1. **Debug-team smoke tests** (T4 teatro fix) — criar `scripts/smoke/debug-{symptom-collector,strategist,archaeologist,adversarial,architect,patch-editor,validator}.sh`. Cada agent .md tem secao VERIFY com spec do que validar. Atualmente TODOS 7 ausentes — VERIFY claim performativo. Estimate: 2-3h (~20min cada). Convert teatro T4 → ATIVO.
2. **A4 chaos-inject decision** (CHAOS_MODE off por design ou bug?) + X3 ordering race resolution.
3. **A5 post-compact-reread.sh schema verify** (probe via 1 trigger compact + read additionalContext trail).

**Opção B — Voltar P0 original (S254/S255 deferred):**
1. **Build/arrange 2-3 slides** (likely metanálise; reference `lovely-sparking-rossum.md`).
2. **Migrate 3 JS scripts → agents/skills + benchmark + `chatgpt-research.mjs` NEW** (gemini-research, gemini-review, perplexity-research + new). Sequence: audit → benchmark → launch real.

## 🟡 P1 — Não bloquear core, surface natural

3. **Testar skills + agents funcionando** (S254-tail) — smoke-test 1 invocation real per item → ✓/✗ aggregate. Skills: `/insights`, `/dream`, `/research`, `/debug-team`. Agents: 16 catalogued em `/dream` tooling-pipeline. **Note S255:** Bug A1 fix deve eliminar SessionStart hook errors observados — re-confirm /insights + /dream lifecycle agora que stdin drain está OK.

## 🟢 P2 — Defer S257+ (radar)

- **Lib refactor consolidado (S255 emergent):** extract `drain_stdin()` + `compute_session_id_path()` (REPO_SLUG calc) em `hooks/lib/protocol.sh` ou similar. DRY de 7+ hooks (drain) + 3 hooks (REPO_SLUG). KBP-41 (c) Deferred (gate-justified): cost ≥5min, escopo expandido, regressao risk em multiple hooks ja passing. Acumular outras DRY candidates antes de session dedicada lib refactor.
- **H4/X2 redundancias debug-team** (Conductor §6.2 audit 3-model): MERGE `systematic-debugging` skill into `debug-team`; X2 `systematic-debugger` agent vs 7 debug-* (DEFER measurement post-H4). Destrutivos requerem Lucas explicit OK.
- **"Files written but never read" invariant** (S255 KBP candidate?) — Bug A2 acumulou 5736 orfaos por ~30 sessoes silenciosas. Antidoto: stop-quality.sh ou sentinel agent checa producers sem consumers como pre-commit invariant. Codify se padrão repetir.
- **BACKLOG #63** SessionStart flags `/insights`+`/dream` systematic-debugging (passos a-e) — surface natural via P1 #3 test
- **Conductor §6.5 G9** Maturity layers (SDL/SAMM/OpenSSF/CMMI) SOTA radar — spec em `docs/research/external-benchmark-execution-plan-S248.md §B5`, non-operational
- **KBP-42 codify** (WebFetch URL lifecycle 7 fires) — defer until P2 sota-intake skill exists
- **/insights P253-001** backlog triage (P0 `BACKLOG.md` 41 items STAGNANT 19 sessions) — defer until P0(d) audit complete
- **P0(d) audit batch G+H** (28 pendentes) + H4/X3 destrutivos + KPI snapshot wiring + per-arm matrix §17.1-§17.12
- **Retroactive `git add --renormalize .`** (post `.gitattributes` S254-tail) — defer sessão dedicada
- **Conductor §16 sync com S254/S255 state** — execution backlog atualizar com S254+S255 closed + new P0/P1/P2 stamped
- **QA editorial metanalise** (3/19 done) — connects Opção B P0#1 slide work
- **R3 Clínica Médica prep** — 217 dias (long-running)

## Hidratação S256 (3 passos)

1. `git log --oneline -10` — confirm S253→S254→S255 chain (9 commits)
2. Read `.claude/plans/immutable-gliding-galaxy.md` §6.5 G1-G8 SOTA gaps + §17.4 DEBUG arm worked example (12 components, 6 DONE, 4 mechanical pending, 1 destrutivo H4, 1 audit pending)
3. Se Opção A: read 7 `.claude/agents/debug-*.md` secao VERIFY (spec dos smoke tests pendentes). Se Opção B: read `.claude/scripts/{gemini,perplexity}-research.mjs` + `gemini-review.mjs` (works well, só improve).

## Cautions ativas

- **Mellow-scribbling-mitten Track A P5 in-flight** outra window/branch — NÃO TOCAR (Lucas owns; cherry-pick later)
- **`.claude/scripts/*-research.mjs` funcionam bem** — não rewrite, só improve (Lucas explicit S254)
- **KBP-40 branch awareness:** `git branch --show-current` antes de commit (SessionStart `gitStatus` snapshot decai)
- **Flag disable é KBP-07 escape válido** — re-enable sem systematic-debugging primeiro = regressão garantida; passos a-e em BACKLOG #63. **S255 update:** Bug A1 fix (stdin drain) elimina classe de hook error — pode liberar re-enable se test confirmar /insights + /dream lifecycle agora OK.
- **KBP-41 cut calibration (S254-tail):** decision tree em `anti-drift.md §EC loop §Cut calibration` — antes de marcar Cut, perguntar a/b/c/d. Bias indicator: 2+ Cuts/sessão = recalibrar. **S255 honored:** lib refactor candidates marcados Deferred (gate-justified), não Cut.
- **APL CALLS counter agora ativo (S255 A2 fix)** — desde S225 reportava 0 sempre (teatro); proxima sessao deve ver valores reais "[APL] Ultimo commit: Xmin atras - N tool calls" (N>0).

## Plans active (2, stamped por prioridade)

- **[P0]** `immutable-gliding-galaxy.md` — Conductor 2026 single source of truth (DEBUG arm §4.4 + §17.4 + §6 council + §16 backlog cobrem dominio S255)
- **[P1]** `lovely-sparking-rossum.md` — metanálise QA reference (relevante se Opção B escolhida)

Coautoria: Lucas + Opus 4.7 (Claude Code) | S255 debug-team-hooks | 2026-04-26
