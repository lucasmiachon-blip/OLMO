# HANDOFF - Proxima Sessao

> S259 closed: metanalise-s-quality v2 (3 cards + dissociation, R4 "ortogonal não EBM term") + heterogeneity-evolve C0 ROB2 + Codex xhigh POC (research perna #6). Detalhes: `CHANGELOG.md §S259`.

## 🔥 P0 — S260 metanálise QA editorial (Loop A pipeline)

State per `content/aulas/metanalise/HANDOFF.md`:
- s-quality (S259 rebuild) → ready preflight
- Próximo APL: **s-absoluto** (3/19 editorial)
- 12 LINT-PASS pendentes
- s-contrato R11=5.7 inconsistência (REOPEN ou ACCEPT — Lucas decide)

Pipeline: `node scripts/gemini-qa3.mjs --aula metanalise --slide {id} --preflight` → [Lucas OK] → `--inspect` → [Lucas OK] → `--editorial`. 1 slide = 1 commit. KBP-05 anti-batch.

## 🔥 P0 — S260 metanálise visual + carga cognitiva (heterogeneity-evolve)

Pattern canônico: ROB2 + s-etd + s-quality. Pendente:
- C1 s-heterogeneity refactor (Tol palette + storyboard B)
- C2 s-fixed-random refactor (remove "42% utilizam não adequada")
- D evidence/s-heterogeneity expansion (PI deep dive + 5 gaps + multi-model triangulation)
- Plan: `.claude/plans/jazzy-sniffing-rabbit.md` §Phase C1+

## 🟡 P1 — Defer (radar S260+)

- **Tier 2 smoke tests live invocation** — hooks bypass para subprocess `claude -p --agent X`
- **Agent .md spec drift archaeologist** — enum `{success,partial,reverted,unknown}` vs example `"tracking"` (5 min fix)
- **`rm <file>` bypass investigation** — `Bash(*)` allow precedes hook ASK; root cause settings filter (~1-2h)
- **Agents runtime invoke + non-redundancy live** — 9 non-debug agents sem proof (~1.5-2h)
- **`.mjs → agents/skill` migration** — POC validated S259; full migration consultar Conductor 2026 `.claude/plans/immutable-gliding-galaxy.md` §11b/c/d
- **Lib refactor consolidado** — PROJECT_ROOT define + REPO_SLUG sha256sum (3 hooks each)
- **R3 Clínica Médica prep** — 217 dias

## Hidratação S260 (3 passos)

1. `git log --oneline -10` — confirm S259 chain (~7 commits cross-window)
2. Read `.claude/plans/jazzy-sniffing-rabbit.md` §Phase C1+ + per-aula HANDOFF S259 lines
3. `git status` — KBP-40 staleness check

## Cross-window protocol (S259 reinforced)

- `git fetch && git status` antes de Edit em state files (KBP-25 + KBP-40)
- `git branch --show-current` antes de commit
- Conflict-prone files (HANDOFF/CHANGELOG/BACKLOG): Edit minimal sections, não rewrite
- "Liberdade depois escrutínio" (Lucas S259) — divergent search > converging too fast

## Cautions ativas

- **APL CALLS counter** + **Stop[5]→Stop[4] shift** (S256 B.2)
- **Smoke tests Tier 1 ATIVO** — debug-team 7/7 + hooks 14/14 (S258)
- **KBP-42** "Hook silent without consumer = teatro candidate" (S258)
- **KBP-43** "Cores literais inventados quando design tokens published" (S259)
- **`codex-xhigh-researcher` agent disponível** — Codex GPT-5.5 xhigh via Bash CLI (S259 POC)

## Plans active

- `[S260 worker]` `.claude/plans/jazzy-sniffing-rabbit.md` — heterogeneity-evolve C1/C2/D
- `[BACKGROUND]` `.claude/plans/immutable-gliding-galaxy.md` — Conductor 2026 (single source of truth)

S259 plans archived: `archive/S259-metanalise-s-quality.md`.

Coautoria: Lucas + Opus 4.7 + Codex GPT-5.5 (xhigh) + OLMO_GENESIS | S259 closed | 2026-04-26
