# HANDOFF - Proxima Sessao

> **S255 "debug-team-hooks" — 3 phases parcialmente closed.** Phase 1 (4 fixes mecânicos) ✓ · Phase 2 (5 voices council audit + synthesis §6.1 strict) ✓ · Phase 3 Block A 5/8 ✓ · Block A 3 remaining + Block B/C/D pendentes S256. Detalhes/aprendizados: `CHANGELOG.md §S255`. Plan canonical: `.claude/plans/dreamy-yawning-kite.md` (8 sections, S255 close + S256 dedicated).

## 🔥 P0 — S256 finish hooks (sequência locked: hooks complete → E2E → advance)

**Block A remaining (~50min, 3 commits) — finish mechanical:**
1. **A.6 post-global-handler fallback fix + TTL** — fallback `unknown_${REPO_SLUG}_$(date)` recognizable + session-start TTL one-liner
2. **A.7 pre-compact-checkpoint timing fix** — capturar OLD_MTIME antes truncate, find -newermt @$OLD_MTIME
3. **A.8 hook-log.sh JSON escape via jq** — replace printf interpolation por `jq -cn --arg`

**Block B (~30min decisões + ~30-90min exec, 4 commits) — Lucas decides D1-D4 batch antes execute:**
- **D1 chaos:** (a) CHAOS_MODE=1 always-on | (b) document opt-in | (c) remove hooks + Conductor §4.9 revert
- **D2 Stop[1]:** (a) remove inline agent | (b) restrict prompt | (c) keep status quo
- **D3 secret bypass Grep/Glob:** (a) PreToolUse matchers | (b) permissions.deny | (c) both (recomendo)
- **D4 guard-bash-write filter:** (a) broaden settings if | (b) remove filter | (c) keep + remove dead detectors

**Block C BACKLOG #63 systematic-debug (~1.5-2h, 3-5 commits) — dream-pending end-to-end:**
- Audit /insights + /dream skills lifecycle (.last-insights write-on-close, .dream-pending delete)
- Fix lifecycle bug (likely write-on-OPEN inverted)
- Re-enable session-start.sh `if false` blocks (linhas 88-95 dream + 117-127 insights)

## 🟡 P1 — S256 E2E tests (Block D smoke tests debug-team T4 fix)

**Block D 7 smoke tests (~1.5-2.5h, 7 commits):** scripts/smoke/debug-{symptom-collector,strategist,archaeologist,adversarial,architect,patch-editor,validator}.sh — cada agent .md tem secao VERIFY com spec do que validar. Atualmente TODOS 7 ausentes — VERIFY claim performativo (T4 teatro). Convert teatro → ATIVO.

## 🟢 P2 — Defer post-hooks-complete (advance)

- **Slides metanálise + scripts migration** (P0 original S254/S255 deferred): 2-3 slides via `lovely-sparking-rossum.md` + 4 JS scripts → agents/skills + chatgpt-research.mjs NEW
- **Lib refactor consolidado** (drain_stdin 7+ hooks + REPO_SLUG calc 3 hooks + safe_source pattern): session dedicada lib audit
- **H4/X2/X3 redundâncias debug-team** (Conductor §6.2-6.3 destrutivos): MERGE systematic-debugging into debug-team (3/3 audit), X2/X3 measurement post-H4
- **"Files written but never read" KBP candidate** (S255 emergent): producer-without-consumer = teatro detectable apenas forensic. Codify se padrão repete
- **Conductor §6.5 G9 Maturity layers** (SDL/SAMM/OpenSSF/CMMI) SOTA radar
- **KBP-42 codify** (WebFetch URL lifecycle 7 fires) — defer P2 sota-intake skill
- **/insights P253-001** backlog triage (41 items STAGNANT 19 sessões) — defer post-Block C
- **Conductor §16 sync com S254/S255 state** + per-arm matrix §17.1-§17.12
- **R3 Clínica Médica prep** — 217 dias

## Hidratação S256 (3 passos)

1. `git log --oneline -15` — confirm S253→S254→S255 chain (~17 commits)
2. **Read `.claude/plans/dreamy-yawning-kite.md` integral** (canonical Phase 3 plan — 8 sections, Block A/B/C/D specs + critical files map + verification approach + KBP candidates)
3. `git status` para push state real (KBP-40 corollary: claims sobre git state em files versionados são auto-stale)

## Cautions ativas

- **Mellow-scribbling-mitten Track A P5 in-flight** outra window/branch — NÃO TOCAR (Lucas owns; cherry-pick later)
- **KBP-40 branch awareness:** `git branch --show-current` antes de commit (SessionStart gitStatus snapshot decai)
- **APL CALLS counter ATIVO desde S255 A2 fix** — desde S225 reportava 0 (teatro). Counter atual visível em "[APL] Ultimo commit: Xmin atras - N tool calls" (N>0)
- **integrity-report.md surface ativo desde S255 A.5** — INV violations agora visible em SessionStart automaticamente
- **Lib pattern A6+A.2+A.3:** 3 libs com idempotent guard (`[[ -n LOADED ]] && return 0`) — banner.sh + handoff-utils.sh + toast.sh. Próximas libs (drain_stdin, REPO_SLUG, safe_source) seguir mesmo pattern
- **Block A 5/8 done:** A.6+A.7+A.8 NÃO foram pulados — só não couberam S255 budget. Plan dreamy-yawning-kite.md §3 specs intactos para S256 retomar
- **Block B 4 decisions D1-D4 require Lucas pick BEFORE Edit** — não decidir autonomamente

## Plans active (3, stamped por prioridade hooks-first)

- **[P0 ACTIVE]** `dreamy-yawning-kite.md` — Phase 3 hooks plan (S255 close + S256 dedicated, sections 1-12)
- **[P1 BACKGROUND]** `immutable-gliding-galaxy.md` — Conductor 2026 single source of truth (DEBUG arm §4.4 + §6 council + §16 backlog reference)
- **[P2 PAUSED]** `lovely-sparking-rossum.md` — metanálise QA reference (resume post-hooks-complete via P2 advance)

Coautoria: Lucas + Opus 4.7 (Claude Code) | S255 debug-team-hooks Phase 1+2+3-partial | 2026-04-26
