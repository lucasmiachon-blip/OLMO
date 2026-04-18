# S227 — Docs Diet (noise cleanup)

> Status: PROPOSED (plan mode) | 2026-04-18 | Session: melhoria1.1.2 (scope extension)
> Budget: ~55min (APL 65min − buffer 10min)
> Origem: Lucas "arrume documental, esses ruidos que tiram atencao que devem sumir"

## Context

S227 já executou Melhoria1.1.2 CLOSEOUT (commit `179ddeb`). Lucas identificou que os documentos top-level continuam ruidosos — abrir HANDOFF/CHANGELOG/BACKLOG exige scroll por conteúdo histórico/resolved que não informa decisões futuras.

Audit (Explore agent) identificou 5 noise sources HIGH impact + 4 MEDIUM/LOW:

**HIGH impact** (reduzem friction visual >50%):
1. HANDOFF L8-25 `## VERDICT S226` (18 li) — history retrospectiva
2. HANDOFF L26-33 `## VERDICT S225` (8 li) — 2 sessões atrás, obsoleto
3. HANDOFF L61-68 `## APRENDIZADOS S226` (8 li) — duplicata do CHANGELOG L37-43
4. CHANGELOG S226 aprendizados+residual (L37-49, 13 li) — viola §Session docs max-5 explicitamente
5. BACKLOG #36 (L43) — path morto `ACTIVE-S226-memory-to-living-html.md` (renomeado para S227)
6. BACKLOG RESOLVED items (7 entries) — bloat histórico no top-level da tabela

**MEDIUM/LOW**:
- HANDOFF L3-4 banner dupla (redundância com §ESTADO)
- HANDOFF L59 contagem stale "36 items" (atual 37)
- CHANGELOG L28 trailing `\` markdown artifact
- Plan archive S227 untracked (Phase 5 lingering do commit anterior)

**Rule violations explícitas** (anti-drift §Session docs):
- HANDOFF total ~76 li >> "max ~50 lines. No history — only future."
- CHANGELOG S226 aprendizados+residual 10 li >> "max 5 linhas per session"

**Outcome desejado**: Lucas abre HANDOFF, vê 3 sections acionáveis (START HERE + ESTADO + Carryover) em ~35 li. CHANGELOG compacto por sessão. BACKLOG sem broken refs nem resolved bloat no topo.

## Scope

**Modificar**:
- `HANDOFF.md` — deletar 3 history sections + fix banner/count
- `CHANGELOG.md` — collapse S226 aprendizados+residual + minor fixes
- `.claude/BACKLOG.md` — fix #36 path + move RESOLVED → bottom collapsible
- `.claude/plans/archive/S227-melhoria-1-1-2-closeout.md` — `git add` (track orphan)

**NÃO modificar**:
- `.claude/rules/*` — auditado sessão passada, 4 regras 1.1 in place
- Plan files ACTIVE (S225-SHIP-roadmap, S227-memory-to-living-html) — próprias iterações
- CHANGELOG pre-S226 sessões — preserva histórico, escopo = S226-S227 only

## Phases

### Phase 1 — HANDOFF diet (~12min)

**Deletar**:
- L8-25 `## VERDICT S226` (18 li): retrospective → CHANGELOG já possui via S226 section
- L26-33 `## VERDICT S225 (histórico)` (8 li): 2 sessões atrás, CHANGELOG tem
- L61-68 `## APRENDIZADOS S226` (8 li): duplicata exata CHANGELOG L37-43

**Corrigir**:
- L3-4 dual banner → 1 linha consolidada: `> **S226 CLOSED** 2026-04-17 | **S227 active** (melhoria1.1.2 CLOSEOUT + docs-diet) | ADR-0001/0002 in force`
- L59 `BACKLOG: 36 items` → `BACKLOG: 37 items` (wc current)

**Preservar intact**:
- L1-7 header + HYDRATION
- L34-43 `## S227 START HERE` (post-CLOSEOUT, já limpo)
- L44-54 `## ESTADO POS-S226` (fix L59 só)
- L63-68 `## Carryover sem prazo`
- L69-71 footer

**Expected diff**: -34 li (vs current 76), final ~42 li. Compliance: ≤50 ✓.

### Phase 2 — CHANGELOG cleanup (~10min)

**Collapse S226 section** (`CHANGELOG.md` L37-49):

Old `### Aprendizados S226` (5 bullets L38-42) + `### Residual verificado` (5 bullets L44-49) = 12 li
New: single `### Aprendizados + residual (consolidado)` = **≤3 li**:

```markdown
### Aprendizados + residual (consolidado)
- Scope pivot mid-session válido com ADR novo; separation-of-roles em skill-creator upstream; pointer-only KBP + ADR externo = SSoT grepable
- Residual 93 hits "cowork" TODOS legítimos (10 IMMUTABLE archive, 75 plan file, 6 upstream α, 2 producer-refs documentados)
```

**Outros fixes**:
- L28 trailing `\` em `producer nunca escreve em OLMO\` → remove escape
- L11 (S227 entry) "retomar ou descartar" → rephrase para clarity: `"CLOSEOUT item #5: ambígua 'retomar ou descartar' → explícito mapping origem→destino"`

**Expected diff**: -8 li CHANGELOG total.

### Phase 3 — BACKLOG cleanup (~18min)

**Fix broken refs** (L43 item #36):
- Título: `Memory → Living-HTML migration (S226)` → `Memory → Living-HTML migration (S227)`
- Path interno: `ACTIVE-S226-memory-to-living-html.md` → `ACTIVE-S227-memory-to-living-html.md`

**Move RESOLVED items** (agente identificou #3, #10, #12, #15, #20, #22, #32, #35):
- Estratégia: criar seção `## Resolved (historical, preservado)` NO FINAL do arquivo
- Mover os 7-8 entries para lá (cut + paste abaixo de seção atual, antes de qualquer footer)
- Preservar numeração original (não renumera — history context mantido)
- Top table fica só com items OPEN

**Verificar**:
- Count após move: mainline items + RESOLVED = total original (sanity check)
- Update HANDOFF L59 count se necessário pós-move (escopo MEDIUM covered)

**Risk mitigation**: RESOLVED items são lossy-free (nothing deleted, só realocado visualmente).

**Expected diff**: top table -7 linhas, bottom section +9 linhas (header + 7 items + blank). Net +2 li para legibilidade >> compactness tradeoff.

### Phase 4 — Plan archive track + final commit (~5min)

**Track the orphan**:
- `git add .claude/plans/archive/S227-melhoria-1-1-2-closeout.md`
- Inclui no próximo commit (sem amend — CLAUDE.md discourage)

**Final commit** (single, non-atomic granularity per Lucas):
```
S227 docs diet: HANDOFF/CHANGELOG/BACKLOG noise cleanup + plan archive track

HANDOFF:
- Remove VERDICT S226 + S225 + APRENDIZADOS S226 (history duplicada em CHANGELOG)
- Fix banner redundancy + BACKLOG count 36→37
- Compliance anti-drift §Session docs max-50-li (76→42 li)

CHANGELOG:
- Collapse S226 Aprendizados+Residual 12li→3li (compliance max-5-li)
- Fix L28 trailing backslash + L11 phrasing

BACKLOG:
- Fix #36 dead path (S226→S227 in title + internal ref)
- Move 7 RESOLVED items → ## Resolved (historical) bottom section
- Top table apenas OPEN items (visual clarity)

Plan archive:
- Track .claude/plans/archive/S227-melhoria-1-1-2-closeout.md (era untracked pós-commit 179ddeb)

Also: this plan file archived to .claude/plans/archive/S227-docs-diet-plan.md

Coautoria: Lucas + Opus 4.7

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
```

### Phase 5 — Verification (~5min)

Execute + report:
1. `wc -l HANDOFF.md` — expect ~42
2. `grep -c "## " HANDOFF.md` — expect 4 seções (start here + estado + carryover + footer)
3. `grep "VERDICT" HANDOFF.md` — expect 0 hits
4. `grep -E "ACTIVE-S22[0-9]" .claude/BACKLOG.md` — expect only S227 refs
5. `grep -i "retomar ou descartar" HANDOFF.md CHANGELOG.md` — expect 0 hits
6. `git status` — limpo após commit
7. `git log -1 --stat` — 4 arquivos modificados

## Order Rationale

**Por que HANDOFF primeiro** (Phase 1):
- HANDOFF é o "front door" de toda sessão. Noise ali impacta todas as futuras leituras.
- Deletions são LOW risk (duplicadas em CHANGELOG, confirmed via agent audit).
- Maior ROI por minuto — -34 li de -76 li = 45% redução total visual.

**Por que CHANGELOG segundo** (Phase 2):
- Collapse antes do BACKLOG porque muda 1 arquivo só (simples).
- Rule compliance (§Session docs max-5) prioriza sobre organização (que é subjetiva).
- Outros fixes (backslash, retomar) são minor — bundled aqui para evitar novo touch.

**Por que BACKLOG terceiro** (Phase 3):
- Maior (37 items), mais classificação cognitiva.
- Dead path #36 é HIGH mas não bloqueia outras phases.
- RESOLVED move é structural — uma vez feito, a tabela fica hygienically sustentável.

**Por que Phase 4 = single final commit (não atomic per file)**:
- Lucas pediu: "sem commits atomicos, já passamos dessa fase"
- Trade-off aceito: commit grande (~8-10 files modificados), mas 1 concern = "docs diet"
- 4 arquivos cohesive de scope único justifica single commit por clareza de intent na history

**Por que Phase 5 = verification no final**:
- Grep checks são cheap, run all at once.
- Fallback: se algo falhar, mini-fix + amend (autorizado dentro do mesmo scope).

## Files to Modify

- `HANDOFF.md` — 3 section deletions + banner/count fixes
- `CHANGELOG.md` — S226 subsection collapse + 2 minor fixes
- `.claude/BACKLOG.md` — #36 path fix + RESOLVED reorganization
- `.claude/plans/archive/S227-melhoria-1-1-2-closeout.md` — git add (was orphan)
- `.claude/plans/S227-docs-diet-plan.md` — archive post-commit (self-reference)

## Files Explicitly NOT Modified

- `.claude/rules/*` — out-of-scope, regras já em compliance
- ACTIVE plan files — próprias iterações, escopo separado
- Pre-S226 CHANGELOG sessões — historical preservation
- `.claude/memory/*` — separate cleanup track (mentioned but deferred)

## Verification

(see Phase 5 — grep/wc checks)

## Budget Tracking

| Phase | Est | Notes |
|-------|-----|-------|
| 1 HANDOFF diet | 12min | 3 deletes + 2 fixes |
| 2 CHANGELOG cleanup | 10min | Collapse + 2 minor |
| 3 BACKLOG cleanup | 18min | Move logic careful |
| 4 git add + commit | 5min | Single consolidated |
| 5 Verification | 5min | Greps + counts |
| Buffer | 15min | For edge cases |
| **Total** | **~50-65min** | Fits APL 65min |

## Exit Criteria

- HANDOFF.md ≤50 linhas, 0 hits "VERDICT"/"APRENDIZADOS"
- CHANGELOG S226 aprendizados+residual ≤5 li (compliance §Session docs)
- BACKLOG #36 path aponta para arquivo existente
- BACKLOG top table apenas OPEN items
- `.claude/plans/archive/S227-melhoria-1-1-2-closeout.md` tracked
- Single commit capturando todo o scope
- `git status` limpo pós-commit

---

Coautoria: Lucas + Opus 4.7 | S227 docs-diet plan mode | 2026-04-18
