# S224 Consolidacao & Ordem de Acao

> Sessao 224 | 2026-04-17 | Input: A1 plans archaeology + A2 knowledge graph SOA + janitor inline. A3 memory/dream/wiki ainda rodando.
> Scope: aggregate findings por sessao, identificar eliminaveis, propor ordem executavel com racional.

---

## Context

Apos 7 iters em S224 (INFRA100.1+100.2 commit consolidado f8564fe; housekeeping 14 renames 7bece0a+1217e84; HANDOFF compactado c95c405), Lucas pediu consolidation + ordem com racional. Motivacao: **feedback loop estrutural diagnosticado S208 mas nao fixed** (+25 sessions aberto); **memory 20/20 at cap com growth projetado 20→30+ na proxima semana**; **10 Codex hook issues open desde S220 (4 HIGH)**. Precisamos execucao ordenada, nao mais patches.

Evidencia-base: `ACTIVE-S224-research-plans-archaeology.md` (56 plans mapped), `ACTIVE-S224-research-knowledge-graph-soa.md` (ByteRover rec), inline janitor (0 orphans, 0 temp files, 7 empty dirs, 1 nested bug suspect).

---

## Inventario por Sessao

| Range | Count | Tema | Status atual |
|-------|-------|------|--------------|
| S135-S156 | 17 | Slide build, QA gate dev, PMID audit | DONE (archived) |
| S193-S201 | 9 | Hooks Fase 1+2, Design Excellence research | DONE hooks; **Design Excellence Fase 2 ABERTA 25+ sessions** |
| S202-S213 | 7 | DE Loop, QA repair, self-improvement | FALSE-DONE S202 (QA); `hashed-zooming-bonbon` Fase 2 STALE |
| S216-S219 | 4 | PDF/Obsidian pipeline, KBP-22, context rot | S216 FALSE-DONE (docling); S218 /dream Phase 2.6 gated; S219 KBP-22 DONE |
| S220 | 3 | humble-ritchie + codex-adversarial + proud-sunbeam | C1-C3 DONE; C4 DEFERRED; **40 codex findings open (9+9+7+15)** |
| S221-S223 | 3 | Integrity + validation | S221 DONE; S222 teatro; S223 diag Stop[5] |
| S224 | 3+ | INFRA100.1+100.2 + housekeeping + research | Stop[5] H4 confirmed + stderr permanent; plans 14→3+archive |

**Lost threads ativos (8):** LT-1 docling move, LT-2 9 memory consolidations (desde S220), LT-3 9 hook issues (4 HIGH, desde S220), LT-4 EC-loop-as-hook, LT-5 2 DEAD-REFs CLAUDE.md, LT-6 s-takehome direction, LT-7 BACKLOG.md merge 3→1, LT-8 /dream Phase 2.6 gated.

---

## Criterios de Eliminacao / Consolidacao

### ELIMINAR (delete file/line)
- `.claude/memory/SCHEMA.md` — declared stale Codex S220 Batch 2 #6 (zero-effort)
- 3 empty dirs safe: `scripts/output`, `content/aulas/drive-package/slides-png`, `content/aulas/scripts/qa`
- Investigar nested bug `wiki/topics/medicina-clinica/wiki/topics` — se duplicate estrutura, cleanup
- `.claude/pending-fixes.md` mantem (0 bytes esperado — self-healing surface-then-clear)

### CONSOLIDAR (merge content)
- `feedback_context_rot.md` → MOVE-TO-RULES (anti-drift.md ja cobre — dedup)
- `project_values.md + user_mentorship.md + project_self_improvement.md` → 3→1 merged memory file
- 4 Design Excellence research docs (S199-S204) → single `docs/research/design-excellence-research-S199-S204.md` read-only ref
- 3 BACKLOG files (`BACKLOG.md` root, `PENDENCIAS.md`, `.claude/BACKLOG.md`) → 1 SoT (LT-7 S214 plan)

### ANOTAR (status header, not delete)
- 3 FALSE-DONE archived plans: `S199-STALE-mutable-mapping-seal`, `S208-STALE-generic-wondering-manatee`, `S204-warm-bouncing-dahl`
- 2 DEAD-REFs em CLAUDE.md: `crossref-precommit.sh` (L63), `stop-detect-issues.sh` (L73) — remove OR point to current analog

### DECIDIR (Lucas blocks execution)
- **Design Excellence Fase 2:** matar (archive) OR executar (scope rule + skill)?
- **docling move:** executar (S216 LT-1), abandonar, ou re-scope?
- **`defaultMode: auto` em settings.json:** persistir ou reverter?
- **Stop[5] per-turn vs per-session:** INFRA carryover

### MANTER
- `ACTIVE-snoopy-jingling-aurora` (pipeline hardening, 5 gargalos)
- `ACTIVE-proud-drifting-sunbeam` (S220 batches — revisar relevancia)
- `BACKLOG-S220-codex-adversarial-report` (40 findings)
- `ACTIVE-S224-research-*` (3 research reports, preserve until consolidated into action)

---

## Ordem de Acao com Racional

### Fase 0 — Decisoes Lucas (blockers, paralelo; 3×2min = 6min)

| # | Decisao | Racional | Impact |
|---|---------|----------|--------|
| 0.1 | Design Excellence Fase 2: matar OU executar? | Zombie 25+ sessions. Matar = ACTIVE-snoopy foca pipeline-only, sem rule. Executar = escopo Fase 2.1+2.2 antes de snoopy close | Blocker Track A S225+ |
| 0.2 | docling move: executar / abandonar / re-scope? | S216 LT-1 FALSE-DONE. Tools em `C:\Dev\Projetos\docling-tools\` ate hoje, nao migrou | Medio |
| 0.3 | `defaultMode: auto` persist/revert? | Foi adicionado pelo harness Auto mode S224. Pequeno mas pendente em HANDOFF | Pequeno |

### Fase 1 — Eliminacao trivial (zero risk, <30min total)

| # | Acao | Racional | Time |
|---|------|----------|------|
| 1.1 | Delete `.claude/memory/SCHEMA.md` | LT-2 #6 stale. Libera 1 slot no cap 20/20 | 1min |
| 1.2 | Move `feedback_context_rot.md` conteudo → anti-drift.md §relevante; delete source | LT-2 #1. Dedup governance. +1 slot livre | 10min |
| 1.3 | Annotate 3 FALSE-DONE plans com `> Status: FALSE-DONE — S224 audit` | A1 R1. Previne future session build sobre foundation invalidated | 5min |
| 1.4 | Fix 2 DEAD-REFs em CLAUDE.md (L63, L73) | LT-5. CLAUDE.md auto-loaded; broken refs gaslight session-start | 5min |

**Racional Fase 1:** zero-decision wins; builds momentum; resolve 4 lost threads em 20-30min.

### Fase 2 — Infraestrutura acionavel (30-90min dependendo escolhas)

| # | Acao | Racional | Dep |
|---|------|----------|-----|
| 2.1 | **ByteRover CLI setup** (`npm i -g byterover-cli && brv init && brv mcp`) | A2 rec #1. Memory 20→30+ growth invalida "ignore until 50+" threshold. Semantic retrieval + AKL lifecycle resolvem 2 dos 6 gaps identificados. Markdown-compatible, $0, 10min setup, reversivel | Aguardar A3 confirmar synergy com /dream+wiki |
| 2.2 | Codex hooks Batch 1 triage (9 issues, 4 HIGH) — re-read BACKLOG-S220 + rank fix/defer/wontfix | LT-3 desde S220. "Nao remendo" ethic demands closure. Triage 30min; actual fixes roll S225 | Independente |
| 2.3 | Merge memory files project_values+user_mentorship+project_self_improvement | LT-2 #4. 3→1 merged. +2 slots cap | Independente |

### Fase 3 — Consolidacao documental (30-45min, nice-to-have)

| # | Acao | Racional |
|---|------|----------|
| 3.1 | Consolidate 4 DE research docs → `docs/research/design-excellence-research-S199-S204.md` | A1 R4. Foundation if Fase 2 executar; se matar, apenas archive clearly |
| 3.2 | BACKLOG.md consolidation 3→1 SoT | LT-7 S214 plan. Reduce entropy tracking |
| 3.3 | Empty dirs cleanup + investigate `wiki/topics/medicina-clinica/wiki/topics` nested bug | Janitor phase 2. Micro-opt |

### Fase 4 — Batch 2 research (OPCIONAL, 60-90min)

Launch A4 (GTD) + A5 (Hookify) + A6 (Insights) SOA agents se Lucas quiser rearquitetura ampliada informada por research. Nao urgente; S225 pode dispatcher.

### Fase 5 — Session close (15min)

Elite-check #5 + ctx_pct final reading + CHANGELOG SessionEnd entry + HANDOFF sync + commit(s) das fases 1-3.

---

## Ordem consolidada (sequencia execucao)

```
Fase 0 (Lucas decide) → Fase 1 (eliminacao) → [A3 volta?] → Fase 2 (infra) → Fase 3 (docs) → [Fase 4 opc] → Fase 5 (close)
```

**Total S224 continuation:**
- Minimo (Fases 0-2): ~90 min
- Completo (Fases 0-3+5): ~2.5 horas
- Com Batch 2 (Fase 4): +60-90 min

**Estimate ctx budget:** start=27 live. Cada fase +2-5%. End estimate 40-50%. Folga substancial.

---

## Racional Global

1. **Fase 0 primeiro** — sem 3 decisoes Lucas, Fases 1-3 skin-deep. 6 min de prompt Lucas desbloqueia tudo.
2. **Fase 1 trivial-first** — zero-risk wins building momentum. 4 lost threads fechados em 30min. Visibilidade imediata de progresso.
3. **Fase 2 com ByteRover urgente** — growth projection 20→30+ muda prioridade A2 rec de "evolutiva" para "bloqueante". Awaiting A3 sinergy ≠ bloqueador (A3 pode refine scope mas nao invalida rec).
4. **Fase 3 documental baixa-urgencia** — reduz entropy; nao bloqueia Fase 2.
5. **Fase 4 opcional** — GTD/Hookify/Insights research informa **proxima era**, nao S224 close.
6. **Fase 5 obrigatoria** — cadence regra Lucas (3-iter elite-check) + measurable closure.

---

## Critical files

| Acao | File(s) |
|------|---------|
| 1.1 delete | `.claude/memory/SCHEMA.md` |
| 1.2 move+delete | `.claude/memory/feedback_context_rot.md` → anti-drift.md §additions |
| 1.3 annotate | `.claude/plans/archive/S199-STALE-mutable-mapping-seal.md`, `S208-STALE-generic-wondering-manatee.md`, `S204-warm-bouncing-dahl.md` |
| 1.4 fix | `CLAUDE.md:63` (crossref-precommit.sh), `CLAUDE.md:73` (stop-detect-issues.sh) |
| 2.1 install | external (npm global) + `.claude/settings.json` MCP config |
| 2.2 read+triage | `.claude/plans/BACKLOG-S220-codex-adversarial-report.md` |
| 2.3 merge | `.claude/memory/project_values.md`, `user_mentorship.md`, `project_self_improvement.md` |
| 3.1 consolidate | new `docs/research/design-excellence-research-S199-S204.md` from 4 archive files |
| 3.2 merge | `BACKLOG.md`, `PENDENCIAS.md`, `.claude/BACKLOG.md` → SoT |
| 3.3 cleanup | 3 empty dirs + `wiki/topics/medicina-clinica/wiki/topics` (investigate) |

---

## Verification (per fase)

**Fase 1:**
- `ls .claude/memory/SCHEMA.md` = "No such file"
- `grep -r feedback_context_rot .claude/memory/` = 0 hits; `grep context.rot .claude/rules/anti-drift.md` > 0
- `head -1 archive/S199-STALE-*.md | grep FALSE-DONE` = match (3 files)
- `grep -E "crossref-precommit|stop-detect-issues" CLAUDE.md` = 0 hits

**Fase 2:**
- `brv --version` returns; `brv init` no error; primeira query retorna resposta coerente
- Codex triage: plan file `.claude/plans/ACTIVE-S225-codex-triage.md` com 9 issues ranked
- Memory merged: 1 file presente, 3 antigos deleted; MEMORY.md index atualizado

**Fase 3:**
- Design Excellence consolidated doc existe + 4 source plans referenced
- Root BACKLOG.md consolidated; 2 others reduced to pointer
- Empty dirs removed (git status clean); wiki nested investigated

**Fase 5:**
- `git log S224 --oneline` mostra fases commits
- ctx_pct end documentado em CHANGELOG S224 closing
- HANDOFF S225 START HERE atualizado com resultado Fase 0 decisoes

---

## Out of scope (FROZEN)

- Slides s-absoluto, s-quality, s-tipos-ma, drive-package
- Wallace CSS (29 raw px, 20 !important)
- Track B semantic truth-decay (INV-1/3/4)
- Codex issues implementation (triage only Fase 2.2; impl S225+)
- write-gate enforcement rule (KBP-24 discussion parked; revisit after rearchitecture)

---

## Success definition

Plan succeeds when:
1. 3 Fase 0 decisoes recorded (mesmo "defer" with explicit reason)
2. 4 lost threads closed em Fase 1 (SCHEMA, feedback_context_rot, FALSE-DONE, DEAD-REFs)
3. ByteRover operating OR explicit defer com reason (Fase 2.1)
4. Codex triage plan file exists (Fase 2.2)
5. Memory cap down to ≤18/20 (3 freed)
6. Commits publicados (minimum 2: Fase 1 + Fase 2/3)
7. HANDOFF S225 START HERE atualizado
8. Elite-check #5 com evidencia quantitativa
