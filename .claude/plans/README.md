# Plans — Índice e Convenção

> Single source of truth para estado de plans. Atualizado para reidratação S275 (S274 close — tipos-ma evidence HTML 3/7 emit + Phase 7 next session slide build). Nao ler plans longos no start; `HANDOFF.md` escolhe a lane e este README aponta o arquivo certo.

## Active plans (3)

- **[P1 BACKGROUND]** `immutable-gliding-galaxy.md` (Conductor 2026 single source of truth) — reference doc cross-session (12-arms taxonomy + KPIs + §16 backlog ref)
- **[Lane A metanalise · S275 PRIORITY]** `scalable-questing-crane.md` — S274 evidence HTML criado + Phase 7 handoff (slide build s-tipos-ma + 5 decisões Lucas). Phase 6 (this session) closed. Abrir §Phase 7 + §Out of scope na reidratação.
- **[Lane B D-lite]** `sleepy-wandering-firefly.md` — bench D-lite refactor track. S274 D-lite live failed (400+Cloudflare); decisão re-bench post-fixes Lane C.

## Roadmap constante

| Horizonte | Item | Source of truth |
|---|---|---|
| Now | Metanalise S275: slide build s-tipos-ma + ajuste infra (Gemini timeout, Perplexity Cloudflare, D-lite 400, PubMed MCP) | `scalable-questing-crane.md §Phase 7` |
| Now | D-lite research wrappers: refactor + re-bench (post-Lane C infra fixes) | `sleepy-wandering-firefly.md` |
| Next | Infra audit residuals: done-gate strict/pre-push, integrity hooks, Windows npm gate | `docs/audit/codex-adversarial-audit-S267.md` |
| Later | Conductor 2026 / 12-bracos architecture | `immutable-gliding-galaxy.md` |

## Rehydrate protocol

1. Ler `HANDOFF.md` + `.claude/context-essentials.md`.
2. Escolher lane com Lucas.
3. Abrir apenas ranges do plan escolhido via `rg -n`.
4. Manter `CHANGELOG.md` como historico, nao como contexto inicial.

## Recently archived (S265)

- `archive/S259-jazzy-sniffing-rabbit.md` — heterogeneity-evolve (S259 worker; superseded S260 commit `cc04bbd`)
- `archive/S259-warm-snacking-hinton.md` — s-quality v2 (S259 orquestrador; superseded S262 commit `6fed511` + S265 Phase A `184fed9`)

## Archived S268 (noise reduction)

- `archive/concurrent-nibbling-teacup.md` — KBP-45 anchor retained; pointer updated in `known-bad-patterns.md`.
- `archive/wobbly-foraging-pelican.md` — S262 Slides_build committed (`6fed511`); historical.
- `archive/S262-research-mjs-additive-migration.md` — methodology source superseded by S264/S268 D-lite track; historical.
- `archive/splendid-munching-swing.md` — bench Phase 0-8 closed; decision persisted in `.claude/.parallel-runs/2026-04-27-ma-types/decision.md`.

## Archived S269 (Lane D close)

- `archive/S269-document-conversion-uv-hardening.md` — skill document-conversion criado + Fletcher PDF + uv venv hardening + KBP-49/50/51; commit `67c2688` push'd. Renamed from `toasty-greeting-crown.md` pre-archive.

## Archived S270-S271 (audit governance close)

- `archive/S270-audit-adversarial-15-findings.md` — auditoria adversarial OLMO 15 findings (1 CRÍTICO C1 Mermaid + 7 ALTO + 4 MÉDIO + 3 BAIXO); ~2050 palavras, 8 secoes formato fixo; commit `bceb3f4` push'd. Renamed from `snazzy-purring-dream.md` pre-archive S271.
- `archive/S271-audit-fix-criticos.md` — execução mecânica do audit followup: 10 findings closed (C1+A1+A2+A3+A4+A5+A6+A7+M4+B2) + INV-4 count-integrity hook + KBP-52 codified; 5 findings deferred (M1+M2+M3+B1+B3). 5 commits: `e185b45`+`4b6828f`+`66b7bd8`+`ed599ae`+commit-atual. Renamed from `elegant-crafting-marshmallow.md` pre-archive.

## Archived S272 (audit adversarial + 6 fix mecânicos)

- `archive/S272-audit-adversarial-fix.md` — auditoria adversarial S272 (14 findings: 0 CRITICO + 4 ALTO + 6 MEDIO + 4 BAIXO; ~2380 palavras inline relatório) + 6 waves fix Tier-S em auto-mode. Findings closed: A1 (INV-4 v2 prompt/cmd breakdown + 5 docs sync 35 reg), A2 (VALUES.md count), A3 (AGENTS.md fork re-sync), A4 (CHANGELOG cap=10 truncate), M1 (model precedence clarify), M6 (Stop[1] telemetry proxy). 8 commits `ae5bae7`→`cf1830f`. Renamed from `purring-purring-bubble.md` pre-archive S272 close. Defer S273+: M2/M3/M4/M5/B1/B2/B3/B4 (8 findings com decisão Lucas off-thread).

## Archived S265+S273 (Lane A metanalise close)

- `archive/S265-curious-enchanting-tarjan.md` — Phase A `s-quality` done S265 commit `184fed9`; Phases B+C+D `s-forest1/s-forest2` architectural refactor SUPERSEDED em S273 quando Lucas decidiu remover overlays (banner SUPERSEDED no plan). Renamed from `curious-enchanting-tarjan.md` pre-archive S274 close.
- `archive/S273-swift-plotting-tome.md` — overlays s-forest1/s-forest2 removidos (decisão pedagógica Lucas) + bonus autor s-title `Paulo da Ponte` → `Lucas Takeshi`. 14 Edits / 7 files. lint+build PASS. Defer S275+: QA preflight pós-remoção forest1/2. Renamed from `swift-plotting-tome.md` pre-archive S274 close.

**Regra:** max 2 active sessões correntes + 1 BACKGROUND (immutable-gliding-galaxy = exception explicit-flagged). Cross-window concurrency permite até 3 active simultâneo se janelas paralelas cooperam (S264-265 pattern). Plans auto-gen do EnterPlanMode são session-bound (transient) — archived ou renamed pre-close (S256 close pattern).

## Archive (`.claude/plans/archive/` = 116 files)

Historical audit trail. Never delete; historical value > storage cost. Reference por grep quando necessário.

## Naming convention

### Current session (active)
- **Plan mode auto-generated:** Claude Code's EnterPlanMode cria nome random tipo `generic-snuggling-cloud.md`. Aceitável durante execution.
- **Pre-archival rename:** antes de archive, renomear para `S{N}-{version/slug}.md` pattern para consistência histórica.

### Archive pattern
- `S{N}-{descriptive-slug}.md` (ex: `S230-bubbly-forging-cat.md`, `S232-v6-adversarial-consolidation.md`)
- Numbered sessions; slug descreve essência do plan
- Prefixo `ACTIVE-` deprecated (cosmetic; dropped S232 v6 post-close)

### Conteúdo esperado
- **Header:** Status, Scope, Sessões, Tese (1 frase)
- **Context:** problema + outcome esperado
- **Findings/Audit** (quando adversarial)
- **Batches/Phases:** ordem + objetivo + critério de pronto + risco se pular
- **Verification:** grep invariants + runtime smoke tests
- **Residuals:** UNVERIFIED / DEFERRED / HISTORICAL classificação explícita

## Classificação de plans (taxonomy)

| Classification | Significado | Exemplo |
|----------------|-------------|---------|
| **ACTIVE** | Em execução na sessão corrente | (none pós-S232 close) |
| **DEFERRED** | Plan válido mas pospuesto; dormant ≥ N sessões → archive | `S227-memory-to-living-html.md` (archived após 5 sessões dormant) |
| **SUPERSEDED** | Substituído por versão nova | `S232-readiness-multimodel-agents-memory.md` (v1, superseded por v6) |
| **HISTORICAL** | Referência de audit trail; execução concluída ou abandonada | S220-S230 archives |
| **ASPIRATIONAL** | Conceito documentado sem consumer runtime | ⚠️ anti-pattern; archive ou clarify |

**Triage rule:** plan dormant ≥ 3 sessões sem update → reclassificar (ACTIVE → DEFERRED → ARCHIVED). Decaimento de certeza > apego histórico.

**Exceção explícita (human override):** Lucas pode manter item como "ACTIVE commitment" mesmo com plan file archived, via BACKLOG pointer. Ex: #36 Living-HTML — archived S232 post-close mas scheduled S236 por decisão humana. Taxonomia taxativa não substitui intent declarado.

## Histórico recente

| Plan | Session | Status |
|------|---------|--------|
| (no plan file) | S233 | HISTORICAL — substrate-truth-cleanup executed in-conversation; details in `CHANGELOG §Sessao 233` |
| `archive/S232-v6-adversarial-consolidation.md` | S232 | HISTORICAL — executed, 8 commits |
| `archive/S232-readiness-multimodel-agents-memory.md` | S232 iter 1 | SUPERSEDED by v6 |
| `archive/S230-*.md` (4 files) | S230 | HISTORICAL — executed |
| `archive/S227-memory-to-living-html.md` | S227-S232 dormant | **ACTIVE COMMITMENT** (per Lucas S232 close) — plan file archived mas scheduled S236 partial execution (BACKLOG #36 canonical ref) |
| `archive/S229-slim-round-3-daily-exodus.md` | S229 | HISTORICAL — executed (ADR-0002 round 3) |
| `archive/S240-DEFERRED-lovely-sparking-rossum.md` | S240 | DEFERRED — 16 sessões dormant; archived S256 Phase 0 hygiene; resume signal via BACKLOG #64 |
| `archive/S255-S256-debug-team-hooks.md` | S255-S256 | HISTORICAL — debug-team-hooks Phase 3 cross-session (S255 Block A 5/8 + Phase 2 council audit; S256 Block A finish + B + C). Phase 4 smoke tests defer S257. Renamed from `dreamy-yawning-kite.md` pre-archive. |
| `archive/S256-hooks-execute-and-close.md` | S256 | HISTORICAL — current session execution plan (Phase 0+1+2+3 closed, Phase 5 close partial). Renamed from `snazzy-brewing-pearl.md` pre-archive. |
| `archive/S258-hookscont.md` | S258 | HISTORICAL — Phase A 8 commits (KBP-32 VERIFY add to symptom-collector + 7 smoke tests Tier 1 ATIVO contract+fixture) + Phase B close (HANDOFF/CHANGELOG sync + plan archived). G2 finding: `claude agents call` pseudocode stale; real `claude -p --agent`; subprocess hooks bypass infra defer S259 Tier 2. Renamed from `async-moseying-pebble.md` pre-archive. |
| `archive/S258-hookscont-phase-D.md` | S258 | HISTORICAL — Phase C hooks runtime audit (0/32 teatro evidence) + Phase D 3 commits hooks improvements: D.1 hooks-health.sh +5 mock tests 14/14 PASS, D.2 drain_stdin lib DEFERRED S259+ (KBP-41 Cut calibration documented), D.3 audit doc 152li + KBP-42 codified. Renamed from `async-moseying-pebble.md` pre-archive. |
| `archive/S270-audit-adversarial-15-findings.md` | S270 | HISTORICAL — auditoria adversarial 15 findings (1 CRITICO + 7 ALTO + 4 MEDIO + 3 BAIXO); commit `bceb3f4`. Renamed from `snazzy-purring-dream.md` pre-archive S271. |
| `archive/S271-audit-fix-criticos.md` | S271 | HISTORICAL — audit followup execution (10/15 closed mechanically + INV-4 hook + KBP-52 + tier S/M/T system + Stop[1] prompt hook + HANDOFF truncate 113→52 + CATALOG.md created). 5 commits. Renamed from `elegant-crafting-marshmallow.md` pre-archive. |
| `archive/S272-audit-adversarial-fix.md` | S272 | HISTORICAL — audit adversarial AUDIT_HARD: 14 findings inline relatório + 6 waves Tier-S auto-mode (A1+A2+A3+A4+M1+M6 closed). INV-4 v2 catches hook breakdown FS↔docs; M6 telemetry proxy ativa. 8 commits `ae5bae7`→`cf1830f`. Renamed from `purring-purring-bubble.md` pre-archive. |

## Quando criar novo plan file

1. Session start com task complexa: usar Claude Code plan mode → auto-generates filename
2. Roadmap cross-sessão: nomear `S{current}-{descriptive}.md` proativamente; archive quando session fecha
3. NÃO criar plan file para tarefas <3 steps (use TaskCreate + execute direto)

## Referências

- `HANDOFF.md` — ordered priority list + S234 focus
- `CHANGELOG.md §Sessao 232` — execution history
- `.claude/BACKLOG.md` — persistent backlog (independent de plans active)
- `CLAUDE.md §Self-Improvement` — session docs discipline
