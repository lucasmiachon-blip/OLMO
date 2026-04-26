# HANDOFF - Proxima Sessao

> **S256 "hooks" — Phase 0+1+2+3 closed (11 commits), Phase 4 (smoke tests Block D) defer S257.** Phase 0 plans hygiene · Phase 1 Block A finish (A.6/A.7/A.8) · Phase 2 Block B exec (D1-D4 Lucas decisions) · Phase 3 Block C BACKLOG #63 RESOLVED (path mismatch + re-enable). Detalhes/aprendizados: `CHANGELOG.md §S256`. Plan canonical (archived): `.claude/plans/archive/S256-hooks-execute-and-close.md`.

## 🔥 P0 — S257 Phase 4 smoke tests debug-team (~1.5-2.5h, 7 commits)

**Block D — convert T4 teatro → ATIVO.** scripts/smoke/debug-{symptom-collector,strategist,archaeologist,adversarial,architect,patch-editor,validator}.sh. Cada agent .md tem secao VERIFY com spec do que validar. Atualmente TODOS 7 ausentes — VERIFY claim performativo.

Common pattern:
```bash
INPUT_FIXTURE="scripts/smoke/fixtures/<agent>-input.json"
OUTPUT="$(claude agents call <agent> < $INPUT_FIXTURE)"
echo "$OUTPUT" | jq -e '<required field>' || { echo "FAIL"; exit 1; }
echo "PASS"
```

Spec D.1-D.7 detalhado em `.claude/plans/archive/S256-hooks-execute-and-close.md §6` ou `archive/S255-S256-debug-team-hooks.md §6`.

## 🟡 P1 — S257 metanálise QA editorial resume (BACKLOG #64)

**Lucas commitment.** Plan persisted em `.claude/plans/archive/S240-DEFERRED-lovely-sparking-rossum.md` (16 sessões dormant pré-S256, archived Phase 0 hygiene). 14 slides pendentes QA editorial (3/19 done). 5 slides com R11 abaixo threshold 7. Inconsistência s-contrato (R11=5.7 marcado DONE) requer reabertura ou aceite.

## 🟢 P2 — Defer (radar S258+)

- **Lib refactor consolidado** (drain_stdin 7+ hooks + REPO_SLUG calc 3 hooks + safe_source pattern): session dedicada lib audit
- **H4/X2/X3 redundâncias debug-team** (Conductor §6.2-6.3 destrutivos): MERGE systematic-debugging into debug-team (3/3 audit), X2/X3 measurement post-H4
- **Conductor §6.5 G9 Maturity layers** (SDL/SAMM/OpenSSF/CMMI) SOTA radar
- **KBP-42 codify** (WebFetch URL lifecycle 7 fires) — defer P2 sota-intake skill
- **/insights P253-001 backlog triage** (41 items STAGNANT 19+ sessões) — defer
- **Conductor §16 sync com S254/S255/S256 state** + per-arm matrix §17.1-§17.12
- **R3 Clínica Médica prep** — 216 dias
- **KBP candidate codify (S256 emergent):** "Producer-consumer path contracts" — file written por component X read por component Y must validate path equality OR co-evolve. Detectable via grep variable names cross-files.
- **KBP candidate codify (S256 emergent):** "State files staleness recursive" — README/HANDOFF/BACKLOG counts/paths require lint sync vs Glob real. Análogo KBP-40 mas para state files.
- **`.claude/.last-insights` repo-local cleanup**: tracked file frozen S225-era; redundant pós dual-write fix S256 — Lucas pode rm + commit ou aguardar próxima /insights run sync.
- **"Files written but never read" KBP candidate** (S255 emergent): producer-without-consumer = teatro detectable apenas forensic.

## Hidratação S257 (3 passos)

1. `git log --oneline -15` — confirm S253→S254→S255→S256 chain (~28 commits)
2. **Read `.claude/plans/archive/S255-S256-debug-team-hooks.md` §6** (ou `archive/S256-hooks-execute-and-close.md §6`) — Block D smoke tests specs D.1-D.7 + agent .md VERIFY references
3. `git status` para push state real (KBP-40 corollary: claims sobre git state em files versionados são auto-stale)

## Cautions ativas

- **Mellow-scribbling-mitten Track A P5 in-flight** outra window/branch — NÃO TOCAR (Lucas owns; cherry-pick later)
- **KBP-40 branch awareness:** `git branch --show-current` antes de commit (SessionStart gitStatus snapshot decai)
- **APL CALLS counter ATIVO desde S255 A2 fix** — counter visível em "[APL] Ultimo commit: Xmin atras - N tool calls"
- **integrity-report.md surface ATIVO desde S255 A.5** — INV violations visible em SessionStart automaticamente
- **dream + /insights surface ATIVO desde S256 Block C fix** — re-enabled após audit + path mismatch fix (MAX of repo/global)
- **Stop array shifted S256 B.2:** Stop[5]→Stop[4] integrity (Stop[1] inline agent removed). 5 entries total (was 6).
- **Recommendation framing Lucas-style:** "propoe pq sim ou nao" — apresentar recommendation + justificativa SIM/NÃO; Lucas confirma. Padrão emergent S256.

## Plans active (1 background)

- **[P1 BACKGROUND]** `immutable-gliding-galaxy.md` — Conductor 2026 single source of truth (12-arms taxonomy + KPIs + §16 backlog reference)

S256 transient plans archived: `archive/S255-S256-debug-team-hooks.md` (canonical Phase 3 cross-session) + `archive/S256-hooks-execute-and-close.md` (this session execution plan).

Coautoria: Lucas + Opus 4.7 (Claude Code) | S256 hooks Phase 0+1+2+3 closed | 2026-04-26
