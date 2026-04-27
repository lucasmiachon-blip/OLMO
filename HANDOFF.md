# HANDOFF - Proxima Sessao

> **S259 "heterogeneity-evolve" worker — Phase C0 ROB2 restoration from OLMO_GENESIS (commit `56301bc`).** Tol palette (--data-1/5/7/2) + subgrid + :has() edge bleed + white card .rob2-figure + ch-context bug fix. KBP-43 codified ("cores literais inventados quando design tokens published"). Detalhes/aprendizados: `CHANGELOG.md §S259`.
>
> **S258 "hookscont" closed:** debug-team Tier 1 7/7 (A); 32 hooks producer-consumer 0 teatro + KBP-42 codified (C+D); hooks-health 14/14 PASS (D). G2 finding subprocess hooks bypass defer S259+. Detalhes: `CHANGELOG.md §S258`.

## 🔥 P0 — S259+ metanálise visual + carga cognitiva (heterogeneity-evolve continuation)

**Lucas frame:** "melhorando estética + carga cognitiva + profissional sem chutes". Pattern canônico estabelecido em ROB2 + s-etd (S240).

State real (`content/aulas/metanalise/HANDOFF.md` + plan `.claude/plans/jazzy-sniffing-rabbit.md`):
- ✅ **C0 ROB2** (08c-rob2.html): restored — Tol palette, subgrid, :has(), white card
- ⏳ **C1 s-heterogeneity** (09a): refactor pendente — pattern ROB2 + storyboard B aprovado (insight reescrito sem matemática para iniciantes; PI fica no evidence)
- ⏳ **C2 s-fixed-random** (10): refactor pendente — mesmo pattern; remove "42% utilizam não adequada" (complex p/ iniciante)
- ⏳ **D evidence/s-heterogeneity.html**: PI deep dive + 5 gaps + pesquisa multi-model (ChatGPT 5.5 Xhigh + Gemini + Claude triangulation)
- ⏳ **E HANDOFF + CHANGELOG final close**

**Cross-window S259 active:** outra janela em `s-quality` (slide 05) reform — plans `entre-em-plan-vamos-sunny-gosling.md` + `warm-snacking-hinton.md` (mesma scope, orquestrador+worker). **Escopos não conflitam** (rob2/heterogeneity vs quality). Não tocar files dessas sessões.

**Hidratação S260+ (3 passos):**
1. `git log --oneline -5` — confirm `56301bc` ROB2 + outros S259 commits
2. Read `.claude/plans/jazzy-sniffing-rabbit.md` (storyboard C1/C2 + open questions + Tol palette mapping)
3. Read `content/aulas/metanalise/HANDOFF.md` §S259 line

## 🟢 P2 — QA editorial metanálise (opcional, se tiver tempo)

**Lucas S259 close:** "ja esta apresentavel" — QA editorial não bloqueador, foco visual+carga cognitiva venceu.

Backlog dormant 16+ sessões. Plan: `.claude/plans/archive/S240-DEFERRED-lovely-sparking-rossum.md`. State:
- 12 LINT-PASS pendentes (Loop A pipeline `gemini-qa3.mjs`: Preflight → Inspect → Editorial)
- s-contrato R11=5.7 inconsistência (REOPEN ou ACCEPT — Lucas decide)
- s-objetivos QA preflight pendente

Plus: BACKLOG #52/#53/#54 content delivery deadline (grade-v2 scaffold / shared-v2 Day 2 / qa-pipeline-v2). Stale.

## 🟡 P1 — Tier 2 smoke tests live invocation infra (S258 emergent)

Hooks bypass para subprocess `claude -p --agent X`. Investigação opções: `--bare` (API key requirement Lucas Max OAuth), `--setting-sources user` (loses agent discovery em `.claude/agents/`?), inline `--agents <json>` (verbose). Goal: SMOKE_LIVE=1 opt-in real agent invocation per smoke test (~$0.10 total). Plus: SMOKE_STUB=1 pattern já preparado para Codex/Gemini deps. Estimate 1-2h investigação + 7 sub-commits.

## 🟡 P1 — Agent .md spec drift fix archaeologist (S258 KBP-32 finding)

`debug-archaeologist.md` line 59 schema declares outcome enum `{success,partial,reverted,unknown}` mas example line 240 uses `"tracking"`. Smoke usa "partial" para conformar spec. Fix: ou expand enum (add "tracking") ou rename example "tracking"→"partial". 5min fix. Smoke recompila se enum changed.

## 🟡 P1 — `rm <single-file>` bypass investigation (S258 Phase C/D audit)

Observed: `rm /tmp/file` ran sem ASK or BLOCK durante runtime test. Root cause hypothesis: `Bash(*)` allow precedes hook ASK output OR settings filter `*rm *` glob não match leading `rm <path>`. Investigation: settings filter precedence + Bash(*) interaction + guard-bash-write Pattern 17 invocation analysis. Estimate 1-2h. Defense surface menor que `.claude/hooks/README.md` claim post-fix. Detalhe: `docs/audit/hooks-runtime-S258.md §F.1`.

## 🟡 P1 — Agents runtime invoke + non-redundancy live (Phase C.2/C.3 deferred)

Lucas explicit "agents ficam pra proxima". 9 non-debug agents sem runtime test (researcher/sentinel/repo-janitor/reference-checker/qa-engineer/quality-gate/evidence-researcher/mbe-evaluator/systematic-debugger). Loop: invoke 5 agents via Task tool com bounded tasks (~$0.30) + non-redundancy 3 paralelos same-task (researcher vs Explore, sentinel vs repo-janitor, reference-checker vs evidence-researcher). Codex 5.5 xhigh + Gemini 3.1 Pro Preview cross-validation se REVIEW cases mantêm uncertainty (~$0.50). Estimate 1.5-2h.

## 🟢 P2 — Defer (radar S260+)

- **Lib refactor consolidado** (drain_stdin 7+ hooks + REPO_SLUG calc 3 hooks + safe_source pattern): session dedicada lib audit
- **H4/X2/X3 redundâncias debug-team** (Conductor §6.2-6.3): MERGE systematic-debugging into debug-team
- **Conductor §6.5 G9 Maturity layers** (SDL/SAMM/OpenSSF/CMMI) SOTA radar
- **KBP candidate codify (S256)** WebFetch URL lifecycle 7 fires — sota-intake skill (KBP-42 já usado S258 D.3 hooks-consumer; este vira KBP-43 candidate)
- **/insights P253-001 backlog triage** (41 items STAGNANT 19+ sessões)
- **Conductor §16 sync com S254/S255/S256/S258 state** + per-arm matrix
- **R3 Clínica Médica prep** — 218 dias
- **KBP candidate codify (S258 emergent):** "Pseudocode em plans envelhece com CLI changes" — `claude agents call` em S256 §6.1 → real `claude --print --agent` S258. Detectable via `claude --help | grep <cmd>` antes de scaffold. Defer S260+ se padrão repete.
- **KBP candidates S256 emergent (reaffirm S258):** "Producer-consumer path contracts" + "State files staleness recursive"
- **`.claude/.last-insights` repo-local cleanup** — tracked file frozen S225-era; redundant pós dual-write fix S256

## Hidratação S260+ (3 passos)

1. `git log --oneline -15` — confirm S258→S259 chain (S259 ROB2 commit `56301bc` + outras S259 commits cross-window)
2. **Read `.claude/plans/jazzy-sniffing-rabbit.md`** §Phase C1+ (storyboard heterogeneity + fixed-random) + `content/aulas/metanalise/HANDOFF.md` §S259 line
3. `git status` (KBP-40: gitStatus snapshot decai; verificar plan files untracked não-meus para 2-window awareness)

## Dual-front working protocol (S259+ — Lucas reinforced S258 close)

**S258 + Mellow-scribbling-mitten Track A em paralelo. Cuidado redobrado:**

1. **Pre-Edit obrigatório:** `git fetch && git status && git diff HEAD origin/main` antes QUALQUER edit
2. **Read full file** (não Grep partial) antes Edit em state files (HANDOFF/CHANGELOG/BACKLOG/README) — KBP-25
3. **Branch check:** `git branch --show-current` antes commit — KBP-40
4. **NÃO TOCAR** `jazzy-sniffing-rabbit.md` em `.claude/plans/` (Mellow-scribbling-mitten Track A — Lucas owns outra window)
5. **Conflict-prone files:** HANDOFF/CHANGELOG/BACKLOG — Edit minimal sections (não rewrite), aceitar merge se sync issue
6. **Cherry-pick later** workflow: cada commit isolado + reversível

## S259 first-action decision (G0)

Lucas pickar entre P0 alternativas:
- **(A) Metanálise QA** (BACKLOG #64 commitment) — 12 slides LINT-PASS, Loop A pipeline gemini-qa3.mjs, 1 slide = 1 commit
- **(B) Content delivery deadline** (30/abr T-3d) — #52 grade-v2 + #53 shared-v2 Day 2 + #54 qa-pipeline-v2 — exige plan dedicado (não há atualmente)
- **(C) rm bypass investigation** (~1-2h, Phase C audit finding) — root cause settings filter precedence; defense surface menor que README claim
- **(D) Agents runtime invoke + non-redundancy live** (~1.5-2h) — 9 non-debug agents sem proof; 3 paralelos same-task

Recommend **(A) metanálise** — Lucas commitment + plan canonical existe + bounded per-slide. (B) deadline-driven mas plan ausente; (C)/(D) são P1 emergent S258, não bloqueadoras.

## Cautions ativas

- **Mellow-scribbling-mitten Track A P5 in-flight** outra window/branch — NÃO TOCAR
- **KBP-40 branch awareness:** `git branch --show-current` antes de commit
- **APL CALLS counter ATIVO desde S255 A2 fix**
- **integrity-report.md surface ATIVO desde S255 A.5**
- **dream + /insights surface ATIVO desde S256 Block C fix**
- **Stop array shifted S256 B.2:** Stop[5]→Stop[4] (5 entries)
- **Recommendation framing Lucas-style:** "propoe pq sim ou nao" — pattern emergent S256 reaffirmed S258 ("vai pelo profissional que recomendar com justificativa")
- **Smoke tests Tier 1 ATIVO S258:** debug-team `bash scripts/smoke/debug-<agent>.sh` 7/7 + hooks `bash scripts/smoke/hooks-health.sh` 14/14 — CI hook candidate post-S259 Tier 2 live invocation
- **drain_stdin DRY DEFERRED S258 D.2** (KBP-41 gate-justified): cost > value @ 1-line pattern; revisit signal pattern adds 3+ usages OR hook_log-style envelope evolui. Real DRY candidates S259+: PROJECT_ROOT define + REPO_SLUG sha256sum.
- **KBP-42 codified S258 D.3:** "Hook silent without consumer = teatro candidate" — detection method em `docs/audit/hooks-runtime-S258.md §5`

## Plans active (3 — S259 multi-window)

- **[S259 worker]** `jazzy-sniffing-rabbit.md` — heterogeneity-evolve (this session: ROB2 done; C1/C2/D pending)
- **[S259 outra janela]** `entre-em-plan-vamos-sunny-gosling.md` — s-quality reform (Cognitive Load Theory)
- **[S259 outra janela]** `warm-snacking-hinton.md` — s-quality orquestrador (paralelo à anterior)
- **[P1 BACKGROUND]** `immutable-gliding-galaxy.md` — Conductor 2026 single source of truth (12-arms taxonomy + KPIs)

S258 plans archived: `archive/S258-hookscont.md` + `archive/S258-hookscont-phase-D.md`.

Coautoria: Lucas + Opus 4.7 (Claude Code) + OLMO_GENESIS visual reference | S259 ROB2 restoration shipped | 2026-04-26
