# Plans — Índice e Convenção

> Single source of truth para o estado dos plans OLMO. Atualizado: 2026-04-26 (S256 hooks).

## Active plans (1)

- **[P1 BACKGROUND]** `immutable-gliding-galaxy.md` (Conductor 2026 single source of truth) — reference doc cross-session (12-arms taxonomy + KPIs + §16 backlog ref)

**Regra:** no máximo 2 plans active simultaneamente (1 sessão corrente + 1 roadmap cross-sessão explicitamente flagged). Mais que isso = archival overdue. Plans auto-gen do EnterPlanMode são session-bound (transient) — archived ou renamed pre-close (S256 close pattern).

## Archive (`.claude/plans/archive/` = 103 files)

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

## Quando criar novo plan file

1. Session start com task complexa: usar Claude Code plan mode → auto-generates filename
2. Roadmap cross-sessão: nomear `S{current}-{descriptive}.md` proativamente; archive quando session fecha
3. NÃO criar plan file para tarefas <3 steps (use TaskCreate + execute direto)

## Referências

- `HANDOFF.md` — ordered priority list + S234 focus
- `CHANGELOG.md §Sessao 232` — execution history
- `.claude/BACKLOG.md` — persistent backlog (independent de plans active)
- `CLAUDE.md §Self-Improvement` — session docs discipline
