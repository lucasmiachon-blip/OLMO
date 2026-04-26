# HANDOFF - Proxima Sessao

> **S254 "Infra-rapido" closed** — 3 commits main: `b559fbb` → `3f488e0` → `063ce11`. Detalhes/aprendizados: `CHANGELOG.md §S254`. Local 2 commits ahead origin.

## 🔥 P0 — S255 core (próxima sessão)

1. **Build/arrange 2-3 slides** (likely metanálise; reference `lovely-sparking-rossum.md`).
2. **Migrate 3 JS scripts → agents/skills + benchmark + `chatgpt-research.mjs` NEW** (4th model team):
   - `gemini-research.mjs` · `gemini-review.mjs` · `perplexity-research.mjs` · **`chatgpt-research.mjs` NEW** (Codex CLI gpt-5.5)
   - Sequence: (a) audit model names/params → (b) benchmark 4 × N runs latency+token+quality → (c) launch research real
   - Quality bar 9-9.5 · decision pendente: agent vs subagent vs skill per script

## 🟡 P1 — Não bloquear core, surface natural durante P0

3. **Testar skills + agents funcionando** (Lucas S254-tail) — smoke-test 1 invocation real per item → ✓/✗ aggregate. Skills: `/insights`, `/dream` (post-disable lifecycle test surface BACKLOG #63 root cause), `/research`, `/debug-team`. Agents: 16 catalogued em `/dream` tooling-pipeline.

## 🟢 P2 — Defer S256+ (radar)

- **BACKLOG #63** SessionStart flags `/insights`+`/dream` systematic-debugging (passos a-e) — surface natural via P1 #3 test
- **Conductor §6.5 G9** Maturity layers (SDL/SAMM/OpenSSF/CMMI) SOTA radar — spec em `docs/research/external-benchmark-execution-plan-S248.md §B5`, non-operational
- **KBP-41 codify** (WebFetch URL lifecycle 7 fires) — defer until P2 sota-intake skill exists
- **/insights P253-001** backlog triage (P0 `BACKLOG.md` 41 items STAGNANT 19 sessions) — defer until P0(d) audit complete
- **P0(d) audit batch G+H** (28 pendentes) + H4/X3 destrutivos + KPI snapshot wiring + per-arm matrix §17.1-§17.12
- **Retroactive `git add --renormalize .`** (post `.gitattributes` S254-tail) — defer sessão dedicada
- **Conductor §16 sync com S254 state** — execution backlog atualizar com S254 closed + S255 P0/P1/P2 stamped (Lucas S254-tail explicit "vai entrar depois")
- **QA editorial metanalise** (3/19 done) — connects S255 P0#1 slide work
- **R3 Clínica Médica prep** — 218 dias (long-running)

## Hidratação S255 (3 passos)

1. `git log --oneline -10` — confirm S253→S254 chain (6 commits)
2. Read `.claude/plans/immutable-gliding-galaxy.md` (Conductor 2026 unified — META + §6 council + §16 backlog + §17 per-arm + §18 audit)
3. Read `.claude/scripts/{gemini,perplexity}-research.mjs` + `gemini-review.mjs` (works well, só improve)

## Cautions ativas

- **Mellow-scribbling-mitten Track A P5 in-flight** outra window/branch — NÃO TOCAR (Lucas owns; cherry-pick later)
- **`.claude/scripts/*-research.mjs` funcionam bem** — não rewrite, só improve (Lucas explicit)
- **KBP-40 branch awareness:** `git branch --show-current` antes de commit (SessionStart `gitStatus` snapshot decai)
- **Flag disable é KBP-07 escape válido** — re-enable sem systematic-debugging primeiro = regressão garantida; passos a-e em BACKLOG #63

## Plans active (2, stamped por prioridade)

- **[P0]** `immutable-gliding-galaxy.md` — Conductor 2026 single source of truth
- **[P1]** `lovely-sparking-rossum.md` — metanálise QA reference (deadline removida; para 2-3 slides P0#1)

Coautoria: Lucas + Opus 4.7 (Claude Code) | S254 Infra-rapido | 2026-04-26
