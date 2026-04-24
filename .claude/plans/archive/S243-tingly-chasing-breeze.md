# S243 — Adversarial Patches Execution (Batched)

> **Scope anchor:** aplicação dos 32 findings consolidados em `.claude/plans/glimmering-coalescing-ullman.md §Executive Digest` via scope COMPLETO (Lucas decidiu 2026-04-23 close S242).
> **Branch:** `s243-adversarial-patches` (a criar ao start Batch 1).
> **Master plan de referência:** `§S243 Execution Plan` (linha 642+) do `glimmering-coalescing-ullman.md`.

## Context

S242 rodou 3-prong adversarial review (Claude.ai Opus externo + Gemini 3.1 + 3 Codex batches) sobre security posture pós-S241. Retornou 32 findings: 0 CRITICAL, 11 HIGH, 10 MED, 4 LOW, 4 INFO, 1 refinement.

Principais vetores novos descobertos em Codex A v2:
- **7 bypasses HIGH novos** no prefix-match deny-list: `/bin/bash -c`, `curl | bash`, `xargs bash -c`, `find -exec bash -c`, `env bash -c`, `pwsh`/`cmd.exe` (**Windows-crítico**), `python -Ic`
- **F08 prefix-glob upgraded → HIGH** (validação empírica: 7 bypasses confirmados)
- **stop-failure-log.sh NÃO production-ready** (10 bugs linha-por-linha identificados)

S243 aplica esses findings em 4 batches ordenados por risco ascendente: Docs → Security Safe → Hook Refactor → Tokenization Structural.

### Spot-check findings (Phase 2 F22 já resolvida)
- `Grep pwsh|cmd\.exe` em `.claude/`, `scripts/`, `hooks/` → **ZERO matches legítimos** (único match em `glimmering-coalescing-ullman.md` discussão e `latest-report.md`). Phase 2 absorvida em Batch 2.
- Settings.json deny-list atual: 33 patterns (ADR-0006 4 categorias). Novos 13 patterns em Batch 2 todos novel.
- `guard-bash-write.sh` Pattern 7 (python) está em L75, Pattern 14 (ln) L119-121 — ajustes em Batch 2.
- `stop-failure-log.sh` 29 linhas — todos os 10 bugs do plan confirmados in-situ.
- KBP atual max = KBP-32; próximo = KBP-33 ✓.

---

## Batch 1 — Docs foundation (parallelizável, ~1h, commits 1+2+7+8)

**Rationale:** docs primeiro registra rationale ANTES das patches. Se alguém perguntar "por que este pattern?" em 3 meses, ADR já existe. Zero risco código.

### Tarefas

1. **ADR-0006 addendum** (`docs/adr/0006-olmo-deny-list-classification.md`): adicionar seção `## Addendum S243` após `## Governance`:
   - **DENY-5 Env manipulation:** `Bash(*PYTHONPATH=*)`, `Bash(*PATH=*)`, `Bash(*NODE_OPTIONS=*)`
   - **DENY-6 Rede raw:** `Bash(*/dev/tcp/*)`, `Bash(*/dev/udp/*)`
   - **DENY-7 Windows shells:** `Bash(pwsh*-c*)`, `Bash(cmd.exe *)` (justificativa: zero uso legítimo em OLMO via spot-check)
   - **Alargamento DENY-2** (código arbitrário): `Bash(xargs *)`, `Bash(find * -exec *)`, `Bash(env bash*)`, `Bash(env sh*)`, `Bash(/bin/bash*)`, `Bash(/bin/sh*)`, `Bash(patch *)`
   - **Alargamento DENY-3** (indirection): absolute path shells + symlink TOCTOU (coberto em guard Pattern 14 realpath)
   - **Nota DENY-1 fork bomb:** documentar que `:(){:|:&};:` não é pattern-matchable — hook-level defense via timeout

2. **KBP-33 em `.claude/rules/known-bad-patterns.md`** (L9 atualizar "Next: KBP-33" → "Next: KBP-34"; adicionar entry pointer-only):
   ```
   ## KBP-33 Prefix-glob deny insuficiente
   → docs/adr/0006-olmo-deny-list-classification.md §Addendum S243 (7 bypasses empíricos Codex A v2; guard tokenization é defesa primária, deny é camada 1 apenas)
   ```

3. **ADR-0007 novo** (`docs/adr/0007-shared-v2-migration-posture.md`): decidir entre 3 alternativas para shared-v2:
   - (a) Migração agressiva (remove v1 base.css)
   - (b) Bridge indefinido (manter `shared-bridge.css` até shared-v2 cobrir 100%)
   - (c) Freeze (shared-v2 como namespace separado, sem migração)
   - **Contexto obrigatório:** metanalise C5 shared-bridge em uso + grade-v2 scaffold pendente deadline 30/abr/2026. Decisão (b) bridge indefinido até C6 (grade-v2) fechar parece mais seguro — analisar em ADR.

4. **`content/aulas/shared-v2/tokens/reference.css`:** adicionar comment header sobre sync invariant com `:root` (F15, 2-3 linhas).

### Commits
- `docs(S243): ADR-0006 addendum taxonomia expandida (DENY-5/6/7 + alargamentos)`
- `docs(S243): KBP-33 prefix-glob insuficiente (7 bypasses empíricos)`
- `docs(S243): ADR-0007 shared-v2 migration posture`
- `chore(S243): reference.css sync invariant comment`

### Verification
- `cat docs/adr/0006-olmo-deny-list-classification.md | grep -c "DENY-"` → mínimo 7 referências (DENY-1 até DENY-7)
- `grep -c "KBP-33" .claude/rules/known-bad-patterns.md` → 2 (header + entry)
- `ls docs/adr/0007-*.md` → existe
- `git diff --stat` pré-commit confirma apenas docs tocados

---

## Batch 2 — Security patches safe (~1.5h, commits 3+4)

**Rationale:** settings.json pattern additions são reversíveis trivialmente (revert do commit). `guard-bash-write.sh` ajustes são small (regex tweaks, realpath validation). Zero mudança de arquitetura.

### Tarefas

1. **`.claude/settings.json` permissions.deny** (+13 patterns ordenados por categoria ADR):
   - **DENY-6 rede raw (2):** `Bash(*/dev/tcp/*)`, `Bash(*/dev/udp/*)`
   - **DENY-5 env (3):** `Bash(*PYTHONPATH=*)`, `Bash(*PATH=*)`, `Bash(*NODE_OPTIONS=*)`
   - **DENY-2 alargamento (6):** `Bash(patch *)`, `Bash(xargs *)`, `Bash(find * -exec *)`, `Bash(env bash*)`, `Bash(env sh*)`, `Bash(/bin/bash*)`, `Bash(/bin/sh*)`
   - **DENY-7 Windows (2):** `Bash(pwsh*-c*)`, `Bash(cmd.exe *)`

2. **`.claude/settings.json` StopFailure block:** adicionar `"statusMessage": "StopFailure: registrando erro de API..."` ao hook (símetria com Stop[0]/Stop[1]).

3. **`.claude/hooks/guard-bash-write.sh` small ajustes:**
   - Pattern 14 (ln, L119-121): adicionar realpath validation pré-ASK:
     ```bash
     # F04: symlink TOCTOU — validate target not in protected dirs
     if echo "$CMD" | grep -qE '\bln\s+-s\b'; then
         TARGET=$(echo "$CMD" | grep -oP 'ln\s+-s\s+\K[^ ]+' | head -1)
         if [[ -n "$TARGET" ]] && realpath "$TARGET" 2>/dev/null | grep -qE '(/hooks/|/\.claude/)'; then
             printf '{"hookSpecificOutput":{...permissionDecision":"block","permissionDecisionReason":"ln -s apontando para área protegida (realpath)"}}\n'
             exit 2
         fi
     fi
     # existing ASK fallback
     ```
   - Novo pattern (após Pattern 14): `Bash(patch *)` ASK com reason "patch detectado — confirme se diff é confiável" (F07)
   - Pattern 7 regex (L75): ajustar pra casar `-Ic`/`-ic`/`-c` combinados:
     - Atual: `grep -qE '\b(python3?|py)\b\s+(-c\b|[^-][^-])'`
     - Novo: `grep -qE '\b(python3?|py)\b\s+(-[IiB]*c\b|[^-][^-])'` (F23)

### Commits
- `chore(S243): settings.json +13 deny patterns + StopFailure statusMessage`
- `refactor(S243): guard-bash-write.sh realpath + patch + python-Ic (F04/F07/F23)`

### Verification
- `jq '.permissions.deny | length' .claude/settings.json` → 46 (33 atual + 13)
- `jq '.hooks.StopFailure[0].hooks[0].statusMessage' .claude/settings.json` → não-null
- `bash .claude/hooks/guard-bash-write.sh <<< '{"tool_input":{"command":"python -Ic \"import os; os.system(chr(114)+chr(109))\""}}'` → output contém `"permissionDecision":"ask"` ou block (não silent-allow)
- `bash .claude/hooks/guard-bash-write.sh <<< '{"tool_input":{"command":"ln -s /etc/passwd /tmp/pwd"}}'` → ASK (target não-protegido)
- Smoke: invocar `python -c "print(1)"` → deny expected; `pwsh -c "Get-Process"` → deny expected

---

## Batch 3 — Hook refactor fail-complete (~1.5h, commit 5)

**Rationale:** isolado em arquivo único (`hooks/stop-failure-log.sh`). 10 bugs linha-por-linha do plan. Semantic shift de "build-script strict" (set -euo pipefail) para "observability fail-complete" (sentinel touch sempre, mesmo em erro).

### Tarefas (ordem importa — aplicar top-to-bottom)

Arquivo: `hooks/stop-failure-log.sh` (29 linhas atuais):

1. **L2 REMOVE `set -euo pipefail`** (F32 idiom): build-script strict é inapropriado para observability — se jq falha, queremos log pobre, não abort silencioso.
2. **L1→L3 ADD sentinel touch append ANTES de qualquer lógica** (F32 refinement `>>` não `>`):
   ```bash
   SENTINEL="${CLAUDE_PROJECT_DIR:-$(pwd)}/.claude/.stop-failure-sentinel"
   { date -u +%Y-%m-%dT%H:%M:%SZ >> "$SENTINEL"; } 2>/dev/null || true
   ```
3. **L10 ADD defensive PROJECT_ROOT check** (F24):
   ```bash
   [[ -d "$PROJECT_ROOT" ]] || PROJECT_ROOT="$(pwd)"
   ```
4. **L12 ADD pré-source existence check** (F25):
   ```bash
   [[ -f "$PROJECT_ROOT/hooks/lib/hook-log.sh" ]] || exit 0
   ```
5. **L11 REPLACE guard-against-claude exit-1 por return 0 fallback** (F27):
   ```bash
   # antes
   [[ "$(basename "$PROJECT_ROOT")" == ".claude" ]] && { echo "ERROR..." >&2; exit 1; }
   # depois
   [[ "$(basename "$PROJECT_ROOT")" == ".claude" ]] && { echo "ERROR..." >&2; return 0 2>/dev/null || exit 0; }
   ```
6. **L20-22 RESTRUCTURE jq pipeline** (F26): remover pipefail dependency, capture explicit com `|| echo "unknown"`:
   ```bash
   REASON=$(echo "$INPUT" | jq -r '.reason // .error // .message // "unknown"' 2>/dev/null)
   [[ -z "$REASON" ]] && REASON="unknown"
   ```
7. **L22 ADD platform detect pre `grep -oP`** (F30): `-P` não é portable (macOS BSD grep). Fallback plain grep:
   ```bash
   if echo test | grep -qP '' 2>/dev/null; then
       REASON_FALLBACK=$(echo "$INPUT" | grep -oP '"(reason|error|message)"\s*:\s*"[^"]*"' | head -1 | sed 's/.*:\s*"\([^"]*\)".*/\1/')
   else
       REASON_FALLBACK=$(echo "$INPUT" | grep -oE '"(reason|error|message)":"[^"]*"' | head -1 | sed 's/.*":"\([^"]*\)"/\1/')
   fi
   ```
8. **L15 CHANGE INPUT defensive** (F29):
   ```bash
   # antes
   INPUT=$(cat 2>/dev/null || echo '{}')
   # depois
   INPUT="${INPUT:-$(cat 2>/dev/null)}"
   INPUT="${INPUT:-\{\}}"
   ```
9. **L26 ESCAPE `$REASON` via jq antes do hook_log** (F28):
   ```bash
   REASON_ESC=$(echo "$REASON" | jq -R -s '.' 2>/dev/null || printf '%s' "\"$REASON\"")
   hook_log "StopFailure" "stop-failure-log" "stop-or-api-error" "claude-code" "warn" "$REASON_ESC"
   ```
10. **L26 ADD `|| true` per chamada externa** (F05): não abort mid-lifecycle.

### Commit
- `refactor(S243): stop-failure-log.sh fail-complete semantic (10 bugs F05/F06/F24-F30/F32)`

### Verification
- Simular StopFailure: `echo '{"reason":"API timeout"}' | bash hooks/stop-failure-log.sh; echo $?` → exit 0
- Simular input quebrado: `echo 'not json' | bash hooks/stop-failure-log.sh; echo $?` → exit 0
- Simular sem jq: `PATH=/tmp echo '{}' | bash hooks/stop-failure-log.sh; echo $?` → exit 0 (fallback grep)
- Conferir sentinel: `cat .claude/.stop-failure-sentinel | tail -1` → timestamp ISO8601
- Conferir hook-log.jsonl: `tail -1 hooks/hook-log.jsonl | jq '.event'` → `"StopFailure"`

---

## Batch 4 — Tokenization structural (~2.5h, HIGH risk + value, commit 6)

**Rationale:** F08 strategic path (b) guard tokenization é estruturalmente correta vs (a) mais prefix patterns. Implementação invasiva em guard-bash-write.sh — adiciona função tokenize_command() e hazard detection awk/find/xargs. **Deve vir após Batch 2** (mesmo arquivo, evita merge conflicts).

### Tarefas

1. **ADD função `tokenize_command()`** no topo de `guard-bash-write.sh` (após INPUT parse):
   ```bash
   tokenize_command() {
       local cmd="$1"
       # read -a with IFS= respects quotes (basic, não POSIX-perfect mas cobre 95%)
       # Pra quote-awareness real: usar python3 shlex se disponível, fallback regex
       if command -v python3 &>/dev/null; then
           python3 -c "import shlex, sys; print('\n'.join(shlex.split(sys.argv[1])))" "$cmd" 2>/dev/null
       else
           # fallback: split em espaços não-quoted (incompleto mas better than nothing)
           echo "$cmd" | awk 'BEGIN{RS=" "}{gsub(/^"|"$/,""); print}'
       fi
   }
   ```

2. **ADD hazard detection após tokenize:**
   - **awk com `system()`:** tokenize → find token que contém `awk` → próximo token com `system(`
   - **find com `-exec *`:** tokenize → find `find` → próximo token `-exec` → next-to-last é comando arbitrário (CVE-equivalente)
   - **xargs com interpreter arg:** tokenize → find `xargs` → próximo token é `bash`/`sh`/`zsh`/`pwsh` → bloquear
   - **make com target perigoso:** tokenize → find `make` → check Makefile existe e grep por `shell` functions

3. **Emit ASK/BLOCK permissionDecision** com reason específica por hazard:
   ```bash
   if detect_awk_system "$TOKENS"; then
       printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"awk com system() detectado — código arbitrário via awk"}}\n'
       exit 0
   fi
   # ... similar pra find/xargs/make
   ```

### Commit
- `feat(S243): guard-bash-write.sh tokenize_command() + awk/find/xargs hazards (F03/F08)`

### Verification
- `bash .claude/hooks/guard-bash-write.sh <<< '{"tool_input":{"command":"awk \"BEGIN{system(\\\"rm -rf /\\\")}\""}}'` → ASK/block
- `bash .claude/hooks/guard-bash-write.sh <<< '{"tool_input":{"command":"find . -exec rm {} \\;"}}'` → ASK/block (também via deny DENY-2 Batch 2)
- `bash .claude/hooks/guard-bash-write.sh <<< '{"tool_input":{"command":"echo hello | xargs bash -c"}}'` → ASK/block
- Regression: `bash .claude/hooks/guard-bash-write.sh <<< '{"tool_input":{"command":"git log --oneline"}}'` → exit 0 (no false positive)
- Regression: `bash .claude/hooks/guard-bash-write.sh <<< '{"tool_input":{"command":"ls -la"}}'` → exit 0

### Risk mitigation
- tokenize_command() fallback shlex via python3 requer python3 no PATH. Se ausente, degrada pra awk split (menos preciso, mas não quebra hook). Aceitável para Windows dev env Lucas (python3 está).
- Branch dedicada (`s243-adversarial-patches`) permite rollback do Batch 4 sozinho se regressão aparecer — commits 1-5 continuam válidos em main.

---

## Dependencies & execution order

```
Batch 1 (Docs) ─┐
                ├─ independent, can run any order
Batch 2 (SafePatches) ─┐
                       ├─ Batch 3 independent (arquivo diferente)
Batch 3 (HookRefactor) ┘

Batch 4 (Tokenization) ← DEPENDS Batch 2 (mesmo guard-bash-write.sh)
```

**Recommended sequence:** Batch 1 → Batch 2 → Batch 3 → Batch 4. Batches 1 e 3 paralelizáveis teoricamente, mas sequencial é mais simples de verificar.

## Out-of-scope (preservar de scope creep)

- Metanalise C5 s-heterogeneity (plan `lovely-sparking-rossum.md`)
- grade-v2 scaffold C6 (deadline 30/abr/2026 — trilha independente)
- shared-v2 Day 2/3 continuation (plan `S239-C5-continuation.md`)
- @property token expansion (F14 HOLD per Codex C recommendation)
- R3 Clínica Médica prep (221 dias, trilha paralela)

## Session close checklist

- [ ] CHANGELOG.md append: S243 entry com 8 commits + aprendizados (max 5 linhas)
- [ ] HANDOFF.md edit: remover S243 scope, adicionar P0 para S244 (shared-v2 Day 2 ou grade-v2 scaffold)
- [ ] KBP candidates commit gate (KBP-31): se Aprendizados contém "KBP candidate"/"lint rule candidate", schedule commit antes de close
- [ ] Merge branch: fast-forward OR squash (decisão Lucas no close)
- [ ] Cleanup: deletar `.claude/plans/tingly-chasing-breeze.md` se merged; mover pra `.claude/plans/archive/` se referencia perpetuada

## TaskCreate batch (on approval)

Pós-approval, criar 4 tasks TaskCreate (anti-drift §Plan execution: ≥4 phases = mandatory tracking):
1. Batch 1 — Docs foundation (ADR-0006 addendum + KBP-33 + ADR-0007 + reference.css)
2. Batch 2 — Security safe (settings.json + guard-bash-write small)
3. Batch 3 — Hook refactor (stop-failure-log.sh 10 bugs)
4. Batch 4 — Tokenization structural (guard-bash-write tokenize + hazards)

Coautoria: Lucas + Opus 4.7 (Claude Code) | S243 adversarial-patches | 2026-04-23
