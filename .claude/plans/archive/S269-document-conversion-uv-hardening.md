# Plan — CHANGELOG archive + plans sweep + commit cleanup (S269 Lane D follow-up)

> **Pivot do plan anterior:** EPUB→PDF + skill `document-conversion` foram executados e committados em parte (skill files + plans pendente, HANDOFF/CHANGELOG staged mas não committado). Esta é nova tarefa — **fix CHANGELOG bloat + archive ruído documental** antes de fechar commit/push.

## Context

Lucas observou: `git diff --cached --stat CHANGELOG.md = 12078 +-` — anormal. Pediu plan + verificar se foi erro meu, do outro agente, ou bug.

### Investigação read-only completa

| Métrica | Valor |
|---|---|
| `wc -l CHANGELOG.md` (working) | **6108** |
| `git show HEAD:CHANGELOG.md \| wc -l` | 6070 |
| `git show HEAD~3:CHANGELOG.md \| wc -l` | 6038 |
| `git show HEAD~10:CHANGELOG.md \| wc -l` | 6008 |
| `git show HEAD~30:CHANGELOG.md \| wc -l` | 5827 |
| Sessões documentadas (`grep "^## Sessao"`) | **248** |
| Span de sessões | S25 (2026-03-29) → S269 (2026-04-28) |

### Diagnóstico

1. **NEM eu nem outro agente fez nada errado.**
   - Eu: Edit cirúrgico ~22 linhas (Lane D entry).
   - Outro agente: Edit cirúrgico ~16 linhas (S269 capture-first + ChatGPT-5.5 perna #7).
   - Diff de conteúdo real total: ~38 linhas.

2. **CHANGELOG já estava bloated organicamente.**
   - Crescimento gradual ~10-30 linhas/sessão por 30+ commits.
   - 248 sessões em um único arquivo — viola anti-drift.md §Session docs ("CHANGELOG.md: append-only, 1 line per change... max 5 linhas per session").

3. **Diff 12k é cosmético, não real.**
   - Myers algorithm misclassifica shift puro (append-top com 38 lines) como insert+delete em files grandes.
   - Verificação: HEAD linha 100 = working linha 138 = "### Aprendizados" idênticos. Pure shift.
   - `--histogram` algorithm produz mesma anomaly.

4. **Precedente de archive já existe.**
   - Última linha do CHANGELOG: `Sessoes anteriores (7b–24): docs/CHANGELOG-archive.md`.
   - Sessões 7b-24 já foram arquivadas anos atrás. Faltou continuar pattern para S25-S260.

5. **Lucas's intuição correta:** "se changelog tem 12k linhas ele esta errado ou somente o inicio dele deve ser carregado no comeco senao todo contexto e atencao serao perdidas." → exatamente o caso.

---

## Decisão

**Archive S25–S260** (236 sessões, ~5500 linhas) para `docs/CHANGELOG-archive.md`. CHANGELOG.md mantém só S261–S269 (~9 sessões, ~600 linhas).

Cutoff S260 escolhido porque:
- S261 já tem referência ativa em CLAUDE.md / rules (Lucas S261 tone default).
- S261+ tem KBPs e learnings ainda referenciados em current code.
- 9 sessões recentes ≈ 1 mês de history relevante para reidratação.

**Plus:** sweep `.claude/plans/` para plans done não-arquivados ocupando contexto.

---

## Steps

### Phase 1 — Read state atual

1. Read `docs/CHANGELOG-archive.md` (existing format).
2. Read `.claude/plans/README.md` (Now/Next/Later).
3. `ls .claude/plans/` para mapear plans on filesystem vs README.
4. Identify cutoff exato — linha onde S260 termina e S261 começa em CHANGELOG.md.

### Phase 2 — CHANGELOG archive split

1. Extrair S25–S260 do CHANGELOG.md (range conhecido pós-Phase 1) → append a `docs/CHANGELOG-archive.md` mantendo cronologia descending.
2. Atualizar header de `docs/CHANGELOG-archive.md` para refletir new range "S7b–S260".
3. CHANGELOG.md fica:
   - Header `# CHANGELOG`
   - S269 (current, não-committed entries do outro agente + minha Lane D)
   - S268 → S261 (recent, referência ativa)
   - Footer: `Sessoes anteriores (7b–260): docs/CHANGELOG-archive.md`

### Phase 3 — Plans sweep

1. `ls .claude/plans/*.md` — listar todos.
2. Cross-ref com `.claude/plans/README.md` (Now/Next/Later).
3. Plans cujo subject está em archive ou já encerrado → mover para `.claude/plans/archive/`.
4. Update `.claude/plans/README.md` pointers.
5. Não tocar em plans active de outro agente (research D-lite, etc.).

### Phase 4 — Commit + push (concurrent-safe)

1. `git fetch origin` antes de stage final.
2. `git status --short` review — confirmar que outro agente não commitou shared files entre tempo.
3. Stage explícito (NUNCA `-A`):
   - `CHANGELOG.md` (after archive split)
   - `docs/CHANGELOG-archive.md` (after append)
   - `HANDOFF.md` (Lane D bullet)
   - `.claude/plans/toasty-greeting-crown.md` (este plan)
   - `.claude/skills/document-conversion/SKILL.md`
   - `.claude/skills/document-conversion/examples/fletcher-epidemiologia-2026-04-27.md`
   - Plans moves (se Phase 3 produziu)
4. `git diff --cached --stat` — confirmar diff CHANGELOG ≤ 100 linhas (real).
5. `git commit -m "feat(skills): document-conversion + CHANGELOG S25-S260 archive (S269 Lane D)"`.
6. `git fetch origin` + check ahead/behind.
7. `git pull --rebase origin main` se behind.
8. `git push origin main`.

---

## Critical files

- `CHANGELOG.md` — split S25-S260 out
- `docs/CHANGELOG-archive.md` — append S25-S260
- `.claude/plans/README.md` — pointers atualizados após sweep
- `.claude/plans/` (multiple) — possible moves to archive/

## Risks & mitigations

| Risco | Mitigação |
|---|---|
| Outro agente edita CHANGELOG concorrente durante archive | git fetch antes de stage; se conflict, esperar Lucas liberar |
| Cutoff S260 muito agressivo (perde context recente) | Lucas decide cutoff via AskUserQuestion |
| Archive corrompe ordering de sessions | Read tail-to-head ambas, verify cronologia descending preserved |
| Plans sweep move plan ainda relevante | Cross-ref com Lucas / README Now ANTES de mover; só archive plans Done |

## Out of scope

- Re-converter PDF Fletcher (já feito S268 → 372pp/22.6MB, intacto em ~/Downloads).
- Tocar em arquivos do outro agente (`research/SKILL.md`, `research-dlite-runner.mjs`, etc.).
- Editar AGENTS.md, CLAUDE.md, ou rules/.
- HANDOFF.md sweep mais agressivo (pode ser próxima task).

## Verification (end-to-end)

1. `wc -l CHANGELOG.md` ≤ 700.
2. `grep -c "^## Sessao" CHANGELOG.md` ≤ 12.
3. `grep "Sessoes anteriores" CHANGELOG.md` retorna footer atualizado.
4. `git diff --cached --stat CHANGELOG.md` ≤ 100 linhas (sem cosmetic inflation).
5. `wc -l docs/CHANGELOG-archive.md` cresceu por ~5500 linhas.
6. `git log --oneline -1` mostra meu commit.
7. `git push` succeeded sem force.

---

## Cutoff aprovado

**S260** — manter S261-S269 (9 sessões, ~600 linhas) no CHANGELOG.md ativo. S25-S260 (~5500 linhas) → `docs/CHANGELOG-archive.md`. Lucas confirmou "pode fazer sua proposta" 2026-04-28.
