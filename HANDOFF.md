# HANDOFF - Proxima Sessao (S264)

> S263 partial close: Phase 0+1 committed (`c353f53` rules KBP-47+48 + 2 agents wrap-canonical + plan). Phase 2-8 bench BLOCKED on **KBP-38 daemon Ctrl+Q + reopen** (window-restart insuficiente).

## 🔥 P0 — Bench script×agent post-restart (splendid-munching-swing.md Phase 1.3-8)

Estimate ~60-90min S264 dedicada. **Pre-bench checklist (5min):**

1. `claude agents | grep -E "gemini-deep-research|perplexity-sonar-research"` — registry refresh confirmation (KBP-38)
2. `echo "GEMINI:${GEMINI_API_KEY:0:4} | PERPLEXITY:${PERPLEXITY_API_KEY:0:4} | CODEX:$(codex --version)"`
3. `nlm whoami` — TTL ~20min, relogin se expirou

Sequência (orchestrator-driven, Lucas só age em OAuth/UI): smoke test (~5min) → Phase 2 Path A (manual dispatch das 7 pernas: Bash `.mjs` P1+P5, Bash `nlm` P6, Agent tool P2+P7) → Phase 3 Path B (Agent tool dispatch P1'+P5'+P2+P7 paralelos) → Phase 4 `comparison.tsv` + spot-checks → Phase 5 decision matrix MERGE/KEEP/MERGE-BACK.

**Lucas-only actions (S264 directive S263 turn final):** Ctrl+Q + reopen (UI), `nlm login` se TTL expirou (OAuth). Resto orchestrator-driven incluindo `/research` substituído por manual dispatch (skill é `disable-model-invocation`).

## 🔥 P0 — Metanálise QA editorial pipeline (carryover S260+)

QA editorial S265 (quality): **s-quality DONE** — Phase A architectural fix `.term-content-block` wrapper + quick wins contraste (chips 30%, label emphasis, borders 80%). Pendente s-forest1 + s-forest2 (Phases B-G plan `.claude/plans/curious-enchanting-tarjan.md`). s-contrato R11=5.9 segue REOPEN (CSS failsafe + subgrid) — DEFERRED. KBP-05 anti-batch. Bench Phase 6-8 integra com este P0.

## 🟡 P1 — carryover

- **Specialty cleanup remaining** (S261 turn 7): `immutable-gliding-galaxy.md` 8 lines (L25/134/137/316/393/506/520/591) — remove cardio/gastro/hepato/reumato. VALUES.md done.
- **Tone propagation per-agent** (S261 turn 8): 14 `.claude/agents/*.md` ainda (gemini-deep-research + perplexity-sonar-research já tone-aware nos specs S263). anti-drift.md §Tone global done.
- **Tier 2 smoke tests live invocation** — hooks bypass para subprocess
- **Agent .md spec drift archaeologist** — enum `{success,partial,reverted,unknown}` vs example `"tracking"` (5 min fix)
- **`rm <file>` bypass investigation** — `Bash(*)` allow precedes hook ASK (~1-2h)
- **Lib refactor consolidado** — PROJECT_ROOT define + REPO_SLUG sha256sum (3 hooks each)
- **R3 Clínica Médica prep** — 217 dias

## Hidratação S264 (3 passos)

1. `git log --oneline -5` — confirm S263 chain `c353f53`
2. Read `.claude/plans/splendid-munching-swing.md` — 9 phases, Phase 0+1 done
3. Pre-bench checklist (acima) ANTES de qualquer dispatch

## Cross-window protocol (S259+ reinforced)

- `git fetch && git status` antes de Edit em state files (KBP-25 + KBP-40)
- `git branch --show-current` antes de commit
- Conflict-prone files (HANDOFF/CHANGELOG/BACKLOG): Edit minimal sections, não rewrite
- Daemon Ctrl+Q + reopen pra Agent registry refresh (KBP-38 reinforced S263)
- "Liberdade depois escrutínio" (Lucas S259) — divergent search > converging too fast

## Cautions ativas

- **KBP-47** Pernas isolation = research subset trap (S263 formalized)
- **KBP-48** Wrap não-agente = legacy pattern (S263 formalized)
- **KBP-38** Agent registry refresh = daemon-level only (reinforced S263)
- **KBP-42/43/44/45/46** previous (hook silent, literal colors, PMID-em-slide, wholesale migrate, subgrid contextual)
- **Tone default = terse** (anti-drift.md §Tone — global)
- **Codex agent `--model` flag REMOVED** — config.toml default applies
- **Pernas ativas pos-S263:** Codex xhigh (P7) + gemini-deep-research + perplexity-sonar-research (S263 new) + evidence-researcher (P2) + .mjs legacy P1+P5 (Path A baseline para bench)

## Plans active

- `[S264 P0]` `.claude/plans/splendid-munching-swing.md` — bench Phase 1.3-8 post-restart
- `[S262 methodology source]` `.claude/plans/S262-research-mjs-additive-migration.md` — splendid concretizou
- `[BACKGROUND]` `.claude/plans/immutable-gliding-galaxy.md` — Conductor 2026

Coautoria: Lucas + Opus 4.7 + Codex GPT-5.5 xhigh + Gemini 3.1 Pro + Perplexity sonar-deep-research + evidence-researcher | S263 wrap-canonical + 2 new pernas | 2026-04-27
