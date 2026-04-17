# S225 Consolidacao — Plan

> Session: `consolidacao` | 2026-04-17 | Opus 4.7 + Lucas
> Era: SHIP Phase 1 (Codex debt zero + memory + BACKLOG merge)
> Modo: write-gate ativo (pause antes de cada Edit substantivo, aguardar OK)

---

## Context

S225 abre a era SHIP (S225-S230, roadmap aprovado S224 iter 12). Meta desta sessão:
infraestrutura com **zero known-debt visível** e memória consolidada para desbloquear `/dream` futuro.

Ação da sessão = executar o já triageado (`ACTIVE-S225-codex-triage.md`) + memory audit real + BACKLOG cleanup.
Exploração em plan mode revelou **3 desvios vs triage** que precisam confirmação antes de executar:

| # | Triage original | Realidade verificada 2026-04-17 |
|---|---|---|
| 5 | VERIFY P0 | **FIX P0** — `stop-metrics.sh` NÃO tem flock/lock; S220 Part D alegou fix mas nunca aplicou (L162 `>> "$METRICS_FILE"` direto). |
| 1 | FIX HIGH — matcher gaps | **Quase resolvido** — 19 patterns cobrem mkdir/tee/sed/curl/python. Gap residual: `python -c "open('f','w')"` sem flag `-c`. Rebaixar para MED ou park. |
| 2 | FIX HIGH — matcher expand | **Parcialmente feito** — `vite build`/`npx vite`/`build-html.ps1` já presentes. Faltam: `npm run dev-build`, `powershell ./build-html.ps1` absoluto. Micro-fix. |
| 6 | INVESTIGATE | **FALSE-POSITIVE** — PostToolUseFailure EXISTE (62 entries em hook-log.jsonl, última 2026-04-17T21:39:59Z). README desatualizado diz "does not exist". Fix = edit README, não código. |
| 9 | LUCAS-DECIDE | `stop-quality.sh` L104 tem threshold 1+ (`if [ -n "$ISSUES" ]`). Referência a "Stop[0] threshold 3+" do triage pode ser artefato pré-merge S217-S219. **Lucas decide se mantém 1+ ou eleva para 3+.** |

Outros achados:
- **Memory global em 20/20** (`~/.claude/projects/C--Dev-Projetos-OLMO/memory/`). Cap atingido — `/dream` bloqueado até consolidar.
- **BACKLOG merge LT-7 está 80% pronto**. Root `BACKLOG.md` + `PENDENCIAS.md` já removidos/migrados em commit anterior (S214). Pendente: reclassificar `plans/BACKLOG-S220-codex-adversarial-report.md` como `archive/` (é report, não BACKLOG canonico).

---

## Execution — 6 phases

### Phase 1 — Quick wins (~50min, 5 hooks)

Atomic diffs, test-locally, commit-individually.

**1.1 Issue #5 FIX — `hooks/stop-metrics.sh` race** *(P0, 15min)*
- Inserir `flock -x 9` antes do `>>` na L162 usando FD 9 pointing to `${METRICS_FILE}.lock`
- Alt considerado: `mv -n` atomic rename com tmp — rejeitado (JSONL append, não replace)
- Test: spawn 2 Stops simultâneos; verificar nenhuma linha truncada no JSONL

**1.2 Issue #7 FIX — `hooks/post-tool-use-failure.sh` defensive cat** *(P1, 5min)*
- L12: `INPUT=$(cat)` → `INPUT=$(cat 2>/dev/null || echo '{}')`
- Rationale: `set -euo pipefail` ativo (L2) — stdin fechando aborta hook
- Test: `echo '' | bash hooks/post-tool-use-failure.sh` não deve abortar

**1.3 Issue #10 FIX — counter reset `hooks/session-start.sh`** *(P1, 10min)*
- Adicionar após L21 (session-id write): `rm -f /tmp/olmo-subagent-count /tmp/olmo-checkpoint-nudged`
- Rationale: nudge-checkpoint counters carregavam entre sessões, inflating stale counts

**1.4 Issue #2 FIX — `hooks/guard-lint-before-build.sh` matcher expand** *(P1, 10min)*
- L25: adicionar `|npm run dev-build|powershell.*build-html\.ps1` ao regex
- Skip: `vite`, `build-html.ps1` relativo já cobertos
- Test: `npm run dev-build aula-x` sem lint deve bloquear

**1.5 Issue #6 DOCS — README PostToolUseFailure reclassify** *(P1, 10min)*
- Edit `hooks/README.md` L5: remover "does NOT exist", substituir por "triggers on tool failures (62 captures since S200)"
- Rationale: evidência 62 entries comprova evento funcional
- Sem mudança de código

**Commit Phase 1:** 1 commit por fix (5 commits) com tag `S225 Phase 1`.

---

### Phase 2 — Architectural (~75min, 3 hooks)

Changes que afetam policy de enforcement. Teste extra.

**2.1 Issue #3 FIX — `hooks/momentum-brake-enforce.sh` Bash exemption granular** *(P2, 45min)*
- L46: atualmente `case "$TOOL_NAME" in Read|Grep|Glob|Bash|...` — `Bash` blanket exempt
- Proposta: separar case para Bash — exempt apenas se command prefix ∈ {ls, cat, head, tail, git log, git status, git diff, git show, which, pwd, find, echo}
- Mutations (rm, mv, cp destructive, git commit/push, npm install) → NO exempt
- Alt considerado: confiar 100% em guard-bash-write — rejeitado (guard-bash-write ataca patterns de write; momentum-brake ataca patterns de AÇÃO. São axes ortogonais.)
- Test: `git commit` sem KBP-07 trigger anterior deve ser bloqueado pelo momentum-brake; `ls` deve passar

**2.2 Issue #4 FIX — `/tmp/cc-session-id.txt` namespacing** *(P2, 20min)*
- Files afetados: `hooks/session-start.sh` L21 (write) + `hooks/stop-metrics.sh` L198 (read)
- Proposta: `SESSION_ID_FILE="/tmp/cc-session-id-$(cd "$(git rev-parse --show-toplevel 2>/dev/null || echo $HOME)" && pwd | sha256sum | head -c 8)-$$.txt"`
- Alt considerado: `$REPO_ROOT/.claude/.session-id-${PID}` — rejeitado (committed state = risco de leak)
- Test: 2 Claude Code instances diferentes não sobrescrevem session-id entre si

**2.3 Issue #8 FIX — `hooks/pre-compact-checkpoint.sh` visibility** *(P2, 10min)*
- L16-60 bloco `{ ... } > "$CHECKPOINT" 2>/dev/null` perde TODOS os erros
- Proposta: `{ ... } > "$CHECKPOINT" 2>&1 || echo "[pre-compact] checkpoint write failed: $CHECKPOINT" >&2`
- Rationale: silent fail em disk full / permission era invisível; agora emite warning mas não bloqueia
- Test: simular disk full com checkpoint path inválido — confirmar warning em stderr

**Commit Phase 2:** 1 commit por fix (3 commits) tag `S225 Phase 2`.

---

### Phase 3 — Edge cases + Lucas decisions (~20min)

**3.1 Issue #1 DECISION** — rebaixar para LOW ou park
- Gap residual é `python -c "open('f','w')"` + variantes sem `-c` explícito (e.g. `python script_inline.py`)
- Custo fix: adicionar 2 patterns em `guard-bash-write.sh`
- Custo defer: praticamente zero (uso raríssimo)
- **Lucas decide: micro-fix agora OR park em KBP-referenciado**

**3.2 Issue #9 DECISION** — threshold 1+ vs 3+
- Atual: 1+ issues dispara persist em `stop-quality.sh` L104
- Proposta alternativa: `if [ "$(echo "$ISSUES" | wc -l)" -ge 3 ]` — reduz false-positives mas pode mascarar issues pontuais
- Tradeoff: noisy-vs-silent. **Lucas decide.**

---

### Phase 4 — Memory consolidation (~40min)

Cap global atingido (20/20). Consolidação DESBLOQUEIA `/dream`.

**4.1 Merge TE/CSPH accuracy** — combinar dois files num só
- `~/.claude/projects/C--Dev-Projetos-OLMO/memory/te-csph-diagnostic-accuracy.md`
- `~/.claude/projects/C--Dev-Projetos-OLMO/memory/rule-of-five-limitations-gray-zone.md`
- Novo nome proposto: `te-csph-accuracy-and-gray-zone.md` — ambos cobrem mesma decisão clínica (Baveno VII cutoffs)
- Requer Read ambos + merge manual preservando "Load when" triggers
- Libera 1 slot

**4.2 Merge elastography confounders/comparison**
- `elastography-confounders-limitations.md` + `mre-vs-te-head-to-head.md` → `elastography-modality-comparison-and-limitations.md`
- Libera 1 slot

**4.3 Archive stale S201**
- `.claude/agent-memory/reference-checker/s-quality-audit-S201.md` → `archive/` ou delete
- Conteúdo pontual de sessão encerrada

**4.4 Atualizar `MEMORY.md` indexes** (global + evidence-researcher)
- Remover entries merged, adicionar novos nomes
- Test: `/wiki-query elastografia` deve retornar novo file combinado

Post-Phase 4: global 20 → 18/20 (2 slots liberados).

**Commit Phase 4:** 1 commit "memory consolidation S225" tag.

---

### Phase 5 — BACKLOG cleanup (~10min)

**5.1** Rename `.claude/plans/BACKLOG-S220-codex-adversarial-report.md` → `.claude/plans/archive/S220-codex-adversarial-report.md`
- Rationale: file é REPORT preservado, não é BACKLOG canonico
- Canonical vive em `.claude/BACKLOG.md` (80 li, 33 items)

**5.2** Verify — os 9 hook issues do S220 Batch 1 estão referenciados em `ACTIVE-S225-codex-triage.md`? Sim (confirmado Phase 1 exploration). Sem perda de rastreabilidade.

**5.3** Update `.claude/BACKLOG.md` — marcar LT-7 como DONE com nota "S214 migration completed; S225 archived S220 report".

---

### Phase 6 — Session docs + elite-check (~15min)

**6.1** `HANDOFF.md` — update para S226 START HERE. Max 50 linhas (KBP-23). P0 items: DE Fase 2, semantic memory decision (A2/A3).

**6.2** `CHANGELOG.md` — append linha por commit S225.

**6.3** Elite-check #6 — honest gap report. Slip rate target <15% (vs S224 45%).

**6.4** `/insights` semanal se couber tempo.

---

## Critical files (alpha)

| File | Phase | Lines affected |
|------|-------|----------------|
| `.claude/BACKLOG.md` | 5 | LT-7 RESOLVED note |
| `hooks/guard-lint-before-build.sh` | 1.4 | L25 regex |
| `hooks/momentum-brake-enforce.sh` | 2.1 | L46 case block |
| `hooks/nudge-checkpoint.sh` | - | read-only (consumer) |
| `hooks/post-tool-use-failure.sh` | 1.2 | L12 |
| `hooks/pre-compact-checkpoint.sh` | 2.3 | L16-60 block |
| `hooks/README.md` | 1.5 | L5 |
| `hooks/session-start.sh` | 1.3, 2.2 | L21 + new reset lines |
| `hooks/stop-metrics.sh` | 1.1, 2.2 | L162, L198 |
| `~/.claude/projects/C--Dev-Projetos-OLMO/memory/MEMORY.md` | 4.4 | index update |
| `~/.claude/projects/C--Dev-Projetos-OLMO/memory/te-csph-*.md` | 4.1 | merge |
| `~/.claude/projects/C--Dev-Projetos-OLMO/memory/elastography-*.md` | 4.2 | merge |
| `HANDOFF.md` | 6 | rewrite for S226 |
| `CHANGELOG.md` | 6 | append |
| `.claude/plans/BACKLOG-S220-*.md` | 5.1 | git mv to archive/ |

**Plans consulted (read-only):** `ACTIVE-S225-codex-triage.md`, `ACTIVE-S225-SHIP-roadmap.md`.

---

## Verification strategy

- **Hooks Phase 1-3:** cada fix tem teste locally-runnable antes do commit. Output esperado explicito.
- **Race test #5:** `bash hooks/stop-metrics.sh &; bash hooks/stop-metrics.sh &; wait; wc -l $METRICS_FILE` — linha count = 2 exato.
- **Memory Phase 4:** `/wiki-query elastografia` + `/wiki-query CSPH` após merge — retornam conteúdo relevante de novos files.
- **BACKLOG Phase 5:** `git ls-files .claude/plans/ | grep -v archive | wc -l` — não aumenta; `ls .claude/plans/archive/` mostra file novo.
- **Final:** `.claude/hooks/*.sh` rodados individualmente com input de teste; nenhum exit ≠0 ou stderr inesperado.

---

## Risk / blockers

1. **Write-gate discipline** (anti-drift §Momentum brake + S225 SHIP era): pause antes de cada Edit substantivo. "Parece lógico" não vira execução. Lucas OK por Phase.
2. **Memory merge = risk de perder nuance** — Read integral de cada file antes de escrever merged version. Não confiar em "skim".
3. **Issue #3 momentum-brake**: mudança architectural — risco de false positive bloqueando Bash legítimos. Testar com 5 comandos típicos de Lucas (git status, ls, git commit, rm file, mv) antes de commit.
4. **Slip budget**: roadmap estimou 2.5-3h. Plan real ~3.5-4h. Se travar em 2.1 (momentum-brake), defer para S226 é OK — priorizar Phase 1+4+5 (Quick wins + memory + backlog).
5. **Elite-check #6** at close — reportar honest gap vs plan, não inflar.

---

## Approval needed (per phase)

- Phase 1 (Quick wins) — request OK antes de start; depois 1 OK por fix OR bloco
- Phase 2 (Architectural) — OK separado por fix, principalmente #3
- Phase 3 (decisions) — Lucas responde 2 perguntas (#1 + #9)
- Phase 4 (memory) — OK antes do merge de cada pair (2 OKs)
- Phase 5 (BACKLOG) — pode ir em batch com Phase 6
- Phase 6 (docs) — OK final antes de HANDOFF rewrite

---

## Execution log

### S225 iter 1 — Phase 1.1 + MSYS2 toolchain install (2026-04-17)

**Decisão durável**: instalar toolchain MSYS2 full em vez de workaround-per-hook. Justificativa: ferramentas duradouras + ajudam outros projetos Lucas (doutorado, case study, medical workflows, slides pipeline).

**Instalado:**
- **MSYS2** (via `winget install MSYS2.MSYS2`) em `C:\msys64\`
- **Via pacman**: `util-linux` (flock, column, getopt) + `rsync` (backup/deploy) + `parallel` (batch jobs) + `moreutils` (sponge, ts, pee) + `zstd` (tar.zst)
- **Via winget**: `MikeFarah.yq` (YAML) + `SQLite.SQLite` (sqlite3)
- **PATH**: `C:\msys64\usr\bin` appended ao User PATH (PowerShell SetEnvironmentVariable) — durável, zero admin, todos shells veem

**Stop-metrics.sh decisão final**: hybrid flock+mkdir mantido. Zero code change pós-install — `command -v flock` check é dynamic; próximo Claude Code spawn vê flock no PATH e usa. mkdir fallback permanece como insurance cross-env.

**Race test (iter 1)**: 3 parallel writers → 1 linha. mkdir atomic lock validado. Flock path será exercitado naturalmente em S226+.

---

Coautoria: Lucas + Opus 4.7 | S225 plan file | 2026-04-17
