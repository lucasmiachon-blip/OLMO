# HANDOFF - Proxima Sessao (S266)

> S264.c bench CLOSED commit `1ff1f63` + Codex peer-review `b6e8f7c` GEMINI.md v3.7. S265 s-quality DONE outro agente `474f879`. Estado clean — Lucas fechando concurrent windows.

## 🔥 P0 — D-lite refactor track (bench Phase 9 — gated em decision.md signoff)

> **Retomada planejada ~2 dias** (Lucas turn final S264.c: "isso aqui fica para daqui 2 dias"). Cooling-off period sobre decisão KEEP-SEPARATE provisional + cost-benefit reflection D-lite refactor.

S264.c outcome (KBP-39): **KEEP-SEPARATE provisional**. `.mjs` canonical Gemini/Perplexity hot path (9/9 ✅), `codex-xhigh-researcher` canonical thin-agent (0% fab consistent across 14 PMIDs), `evidence-researcher` canonical post §Fase 1.5, `gemini-deep-research` + `perplexity-sonar-research` **EXPERIMENTAL** até D-lite refactor + re-bench. Lucas signoff slot pending em `.claude/.parallel-runs/2026-04-27-ma-types/decision.md`.

D-lite spec (~30-60min per Codex peer-review — corpo dos agents já tem comandos, custo real é validação não rewrite): refactor gemini-deep + perplexity-sonar bodies para single-Bash deterministic (mirror codex-xhigh-researcher: API call → save raw → extract JSON → print final). Smoke + re-bench Phase 1.3 + Phase 3 single-Q. Lock MERGE (sunset .mjs) ou MERGE-BACK pos-evidence.

KBP-Candidate-D ("agent chattiness") + KBP-Candidate-E (SubagentStop hooks alternative architectural lever) formalize APENAS pos transcript+stop_reason proof OR D-lite re-bench (per Codex F3 + blind spot 1). KBP-48 reformulation defer S266+ ("APIs externas: contrato determinístico/auditável; if wrapped, agent thin + verifiable").

Substrate em `.claude/.parallel-runs/2026-04-27-ma-types/`: path-a/ 13 outputs + path-b/ 1 validated JSON + 14 raws + smoke/ + bench-log.md + agent-adjustments.md + codex-peer-review.md + comparison.tsv + decision.md.

### 🔄 Retake Protocol (S266+ daqui 2 dias — fresh session)

**5-step hidratação (~5min, ANTES de qualquer dispatch):**

1. `git log --oneline -6` — confirm chain `19467d5 → 3eefa4e → b6e8f7c → 1ff1f63` (S264.c bench) + `474f879/184fed9` (S265 outro agente s-quality) + `ac65ba6` (S264 outro agente cleanup)
2. Read `.claude/plans/sleepy-wandering-firefly.md` §S264.b (state briefing tables) + §S264.c (Codex recalibration + D-lite Phase 9 spec)
3. Read `.claude/.parallel-runs/2026-04-27-ma-types/decision.md` — confirma Lucas signoff slot (KEEP-SEPARATE provisional) ou OVERRIDE recordado
4. `claude agents | grep -E "gemini-deep-research|perplexity-sonar-research"` — registry confirm (KBP-38)
5. `echo "GEMINI:${GEMINI_API_KEY:0:4} | PERPLEXITY:${PERPLEXITY_API_KEY:0:4} | CODEX:$(codex --version)"` — env keys + Codex CLI

**Decision branch:**
- **Se Lucas SIGNOFF KEEP-SEPARATE:** prossiga D-lite refactor (specs abaixo). Outcome esperado MERGE (Path B canonical) ou MERGE-BACK (sunset wraps).
- **Se Lucas OVERRIDE:** re-plan per Lucas frame. Possíveis: opt-in Option A (re-dispatch maxTurns:50+), Option B (orchestrator-parse raws), opção custom.

**D-lite refactor concrete targets** (per Codex peer-review: "corpo já tem comandos, custo real é validação"):

| File | Mudança | LoC estimate |
|---|---|---|
| `.claude/agents/gemini-deep-research.md` | Body Phase 1-6 → collapse para 1 Bash invocation: curl Gemini API + jq extract findings + Write JSON path. Mantém preflight (Phase 1) + NCBI spot-check (Phase 2 optional). | ~40-60 li removidas |
| `.claude/agents/perplexity-sonar-research.md` | Idem com Perplexity API + Tier 1 filter (Q1 já provou 4/4 PMIDs BMJ+Ann Intern Med). Avoid prose-then-extract pattern. | ~40-60 li removidas |
| Pattern reference | `.claude/agents/codex-xhigh-researcher.md` body — thin wrapper canonical (S259 POC, 0% fab consistent) | model |

**Validation gate (Phase 9 close):**
1. Smoke ×1 each pos-edit (single Q "I² threshold for substantial") → verify clean emit + JSON schema valid + exit clean
2. Re-bench Phase 3 single-Q (Q1 design primário ambos agents) → if 2/2 emit ✅ → **MERGE** (sunset .mjs); if ≤1/2 → **MERGE-BACK** (archive wraps)
3. Decision lock em `decision.md` + KBP-Candidate-D/E formalize (pos-evidence) ou drop (se D-lite resolveu)
4. Update SKILL.md KBP-48 reformulation ("APIs externas: contrato determinístico/auditável; if wrapped, agent thin + verifiable")
5. Phases 6-8 master plan (`splendid-munching-swing.md`) unblock → Living HTML `s-ma-types.html` + slide 06-ma-types.html + QA (S267+)

**Cross-window state outro agente (defer collisions):**
- S265 s-quality DONE (`474f879`)
- S266 P0 metanalise: Phases B-G `.claude/plans/curious-enchanting-tarjan.md` (s-forest1 + s-forest2 architectural refactor)
- Escopos ortogonais: meu `.claude/agents/+parallel-runs/` ≠ outro agente `content/aulas/metanalise/`. Não conflita.

## 🔥 P0 — Metanálise QA editorial pipeline (carryover S260+)

QA editorial S265 (quality): **s-quality DONE** — Phase A architectural fix `.term-content-block` wrapper + quick wins contraste (chips 30%, label emphasis, borders 80%). Pendente s-forest1 + s-forest2 (Phases B-G plan `.claude/plans/curious-enchanting-tarjan.md`). s-contrato R11=5.9 segue REOPEN (CSS failsafe + subgrid) — DEFERRED. KBP-05 anti-batch. Bench Phase 6-8 integra com este P0.

**Direção S266 (Lucas pre-/clear):** continuar QA dos slides metanalise (re-QA s-quality pós-Phase A + LINT-PASS pendentes — Lucas escolhe slide), depois possível criar slide novo (s-ma-types per bench Phases 6-8). **Um passo de cada vez** — não batch. Phases B-E architectural (calibration + tokens + glass + motion) deslocáveis pós-QA conforme Lucas decisão por slide.

## 🟡 P1 — carryover

- **Specialty cleanup remaining** (S261 turn 7): `immutable-gliding-galaxy.md` 8 lines (L25/134/137/316/393/506/520/591) — remove cardio/gastro/hepato/reumato. VALUES.md done.
- **Tone propagation per-agent** (S261 turn 8): 14 `.claude/agents/*.md` ainda (gemini-deep-research + perplexity-sonar-research já tone-aware nos specs S263). anti-drift.md §Tone global done.
- **Tier 2 smoke tests live invocation** — hooks bypass para subprocess
- **Agent .md spec drift archaeologist** — enum `{success,partial,reverted,unknown}` vs example `"tracking"` (5 min fix)
- **RESOLVED S266:** `rm <file>` bypass — `Bash(*)` removed from global allow; `rm/rmdir` now BLOCK in `guard-bash-write.sh`; Chrome DevTools site-specific allows removed from global policy.
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
- **Pernas pos-S264.c (KEEP-SEPARATE provisional):** Codex xhigh (P7) ✅ + evidence-researcher (P2) ✅ post §Fase 1.5 + .mjs canonical hot-path (P1+P5 9/9 emit) ✅ + gemini-deep + perplexity-sonar EXPERIMENTAL até D-lite refactor + re-bench
- **KBP-Candidate-D (chattiness) + E (SubagentStop hooks):** PENDENTE evidence, formalize só post-D-lite re-bench OR transcript proof

## Plans active

- `[S266 P0]` `.claude/plans/sleepy-wandering-firefly.md` — S264.c bench close + D-lite track S266+ carryover (Phase 9 D-lite refactor + re-bench)
- `[S266 P0 metanalise]` `.claude/plans/curious-enchanting-tarjan.md` — Phases B-G s-forest1+s-forest2 (s-quality DONE S265)
- `[CLOSED]` `.claude/plans/splendid-munching-swing.md` — bench Phase 0-8 done (Phase 9 D-lite movido pra sleepy-wandering-firefly.md)
- `[S262 methodology source]` `.claude/plans/S262-research-mjs-additive-migration.md` — splendid concretizou
- `[BACKGROUND]` `.claude/plans/immutable-gliding-galaxy.md` — Conductor 2026

Coautoria: Lucas + Opus 4.7 + Codex GPT-5.5 xhigh + Gemini 3.1 Pro + Perplexity sonar-deep-research + evidence-researcher | S263 wrap-canonical + 2 new pernas | 2026-04-27
