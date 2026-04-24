# S236 — Execute /insights proposals + reconcile S230 registry

## Context

O /insights S236 (combinado com /dream, relatório em `.claude/skills/insights/references/latest-report.md`) produziu 5 proposals (P007-P011) + 1 KBP candidato. Em paralelo, leitura direta dos hooks revelou que 5 de 6 proposals do report S230 (P002-P006) já foram implementados organicamente nos commits Phase G — mas `failure-registry.json` ainda registra `proposals_pending: 6`, bloqueando trend computation do registry e contaminando signal de governança.

**Objetivo:** restaurar o loop `/insights → accept → implement → trend`, atualmente quebrado porque o registry não acompanha commits orgânicos. Secundariamente, executar as proposals S236 de alta prioridade (P007 metrics fallback, P008 auto-rotation) e codificar KBP-29 como pointer.

**Decisão principal neste plano:** P001 (momentum-brake) — flip evidence-based de DELETE candidate → KEEP. Rationale em Fase 2.

**Sessões paralelas não tocadas:** grade-v2 (P0 HANDOFF), metanalise QA (P0.5), R3 infra (P1). Escopo self-improvement only.

---

## Fases ordenadas

### Fase 1 — Registry reconciliation (~10min)

**Por quê:** S230 proposals acceptance foi perdida silenciosamente. Registry entry S230 diz `proposals_pending: 6` mas hook code reading confirma que P002-P006 foram implementados via commits Phase G (S230 close 2026-04-19). Trend computation precisa ground truth.

**Target:** `.claude/insights/failure-registry.json` — S230 entry

**Change:** editar S230 entry adicionando field `proposals_implemented_commits` mapeando proposal→commit hash. Atualizar `proposals_accepted` 0→5, `proposals_pending` 6→1, `new_kbps_added` 0→0 (manter).

Commit hashes verificados via `git log` (2026-04-21):
- P002 (KBP-23 enforcement) → `33b59e7` S230 G.7 — `post-tool-use-failure.sh:30-33` banner_warn em Read exceeds max tokens
- P003 (KPI + Cost BLOCK delete) → `0780061` S230 G.3 — `post-global-handler.sh` 148→35 li
- P004 (metrics regex) → `64a9338` S230 G.2 — `stop-metrics.sh:96` regex fix
- P005 (anti-meta-loop banner) → `c405a1a` S230 G.8 — `session-start.sh:76-92`
- P006 (/insights reminder) → `c405a1a` S230 G.5 — `session-start.sh:94-103`
- P001 (momentum-brake) → `31815ff` S230 G.4 — `momentum-brake-enforce.sh:54-56` LOGGING added, DELETE deferred

**Verificação:** `python3 -m json.tool .claude/insights/failure-registry.json > /dev/null` passa sem erro; `jq '.sessions[0].proposals_pending'` retorna 1.

---

### Fase 2 — P001 decision: KEEP momentum-brake (evidence-flipped)

**Por quê:** S230 concluiu "brake = teatro, delete" com base em presumida ausência de firings. Mas o critério era ausência de popups ASK — que são auto-bypassed pelo bug KBP-26 (permissions.ask broken em CC 2.1.113). S230 G.4 adicionou `hook_log` ao brake-enforce para medir mechanism-level firings.

**Evidência 5 dias (2026-04-16 → 2026-04-21, 722 hook-log entries):**
- `brake-fired:Edit`: 160 events
- `brake-fired:Skill`: 54 events
- `brake-fired:Write`: 26 events
- `brake-fired:Agent`: 6 events
- **Total: 246 brake-fired events**

**Interpretação:** mecanismo funciona. A "ausência de popups" é artefato do bug KBP-26 (ASK degrada para allow), não do brake ser inefetivo. DELETE seria regressão quando Anthropic fix o bug `permissions.ask` em CC update futuro.

**Chesterton's Fence aplicável:** não deletar o que empiricamente dispara 246x em 5 dias.

**Target + Change:**
1. `.claude/insights/failure-registry.json` S230 entry — adicionar `P001_resolution: "rejected_evidence_flipped_2026-04-21"` + note explicando flip
2. `.claude/hooks/momentum-brake-enforce.sh:21-22` — remover 2 linhas de comentário "NOTE: COST_LOCK check (linha 32-36) is dead code pós-G.3" + "Preservado por ora; remover em S231+ se confirmado unused". Rationale: defense-in-depth legítimo (cost brake pode ser ressuscitado), comment induz delete errado.

**Verificação:** `git diff .claude/hooks/momentum-brake-enforce.sh` mostra só -2 linhas de comment; brake mechanism intacto.

---

### Fase 3 — P007: metrics.tsv session detection fallback (HIGH, ~15min)

**Root cause identificado (lido diretamente de `hooks/stop-metrics.sh:94-101`):**
```bash
SESSION_NUM=""
LATEST_COMMIT_MSG=$(git log --oneline -1 --format='%s' ...)
if [[ "$LATEST_COMMIT_MSG" =~ ^S([0-9]+)([[:space:]]|:) ]]; then       # fallback 1
  SESSION_NUM="S${BASH_REMATCH[1]}"
fi
if [ -z "$SESSION_NUM" ] && [[ "$SESSION_NAME" =~ S([0-9]+) ]]; then   # fallback 2
  SESSION_NUM="S${BASH_REMATCH[1]}"
fi
```

S231-S235 falham em AMBOS fallbacks:
- Commits S231-S235b: `docs:`, `security:`, `fix:` (Conventional Commits) — não `S231:`
- Session names S231-S235: provavelmente semânticos (`dream+insights`, `security-hygiene`) — sem prefixo S###

**Fix:** Adicionar 3ª fallback lendo maior `## Sessao \d+` do CHANGELOG.md. Consistente com `session-start.sh:25` que já usa esse pattern para `LAST_SESSION`.

**Target:** `hooks/stop-metrics.sh` — inserir bloco após linha 101 (antes de `# --- Rework Rate ---`)

**Change (exato):**
```bash
# S236 P007: 3rd fallback — infer from CHANGELOG.md max Sessao entry
# (Commits Conventional Commits style não tem "S###:" prefix; session names semanticos)
if [ -z "$SESSION_NUM" ] && [ -f "$PROJECT_ROOT/CHANGELOG.md" ]; then
  CL_LATEST=$(grep -o '^## Sessao [0-9]*' "$PROJECT_ROOT/CHANGELOG.md" 2>/dev/null | grep -o '[0-9]*' | sort -n | tail -1)
  [ -n "$CL_LATEST" ] && SESSION_NUM="S${CL_LATEST}"
fi
```

**Verificação:**
- `bash -n hooks/stop-metrics.sh` — syntax OK
- Manual dry-run: `bash hooks/stop-metrics.sh < /dev/null` em sessão atual deve resultar em nova linha metrics.tsv com `S236` (ou session atual)
- Se linha já existe (guard `grep -q` em `_persist_metrics()`), não duplica — seguro re-rodar

**Não inclui:** backfill manual S231-S235 — proposto separadamente se Lucas quiser (uma linha por sessão via `printf` direta em metrics.tsv).

---

### Fase 4 — P008: Hook-log auto-rotation no session-start (MEDIUM, ~15min)

**Por quê:** `.claude/hook-log.jsonl` atingiu 722 li antes da rotação manual feita hoje em /dream Phase 2. Entre dream runs, arquivo cresce ilimitado. /dream spec especifica threshold 500 — alinhar session-start a mesmo threshold evita gap.

**Target:** `hooks/session-start.sh` — inserir bloco após linha 35 (após `rm -f /tmp/cc-session-id.txt`, antes de `cat <<EOF`)

**Change (exato):**
```bash
# S236 P008: auto-rotate hook-log.jsonl (aligned com /dream Phase 2 threshold 500)
HOOKLOG="$PROJECT_ROOT/.claude/hook-log.jsonl"
if [ -f "$HOOKLOG" ]; then
  LOG_LINES=$(wc -l < "$HOOKLOG" 2>/dev/null | tr -d ' ' || echo 0)
  if [ "$LOG_LINES" -gt 500 ]; then
    mkdir -p "$PROJECT_ROOT/.claude/hook-log-archive"
    EXCESS=$((LOG_LINES - 500))
    head -n "$EXCESS" "$HOOKLOG" > "$PROJECT_ROOT/.claude/hook-log-archive/hook-log-$(date -I).jsonl"
    tail -n 500 "$HOOKLOG" > "$HOOKLOG.tmp" && cat "$HOOKLOG.tmp" > "$HOOKLOG" && rm -f "$HOOKLOG.tmp"
    echo "[HOOK-ROTATE] Archived ${EXCESS} oldest lines to hook-log-archive/" >&2
  fi
fi
```

**Padrão consistente:** mesma lógica que o /dream skill Phase 2 Step 2, mesmo threshold (500).

**Verificação simulada:**
```bash
# Simular arquivo >500 linhas (via script temp)
printf '{"ts":"2026-01-01T00:00:%02dZ","event":"test"}\n' $(seq 0 10) > /tmp/test-hooklog.jsonl
# Expand para 600 linhas copiando o template
for i in $(seq 1 59); do cat /tmp/test-hooklog.jsonl >> /tmp/test-hooklog-big.jsonl; done
# Swap active path para test + rodar hook
# Verificar arquivo resulta em 500 linhas + archive criado
```

**Race condition nota:** `tail > .tmp + cat` tem janela se outra sessão escreve concurrently. /dream spec aceita isso (rotação rara). Mkdir lock atomic pode ser adicionado futuro (S225 Issue #5 pattern), fora deste plano.

---

### Fase 5 — P009: KBP-29 Agent Spawn Without HANDOFF (MEDIUM, ~5min)

**Por quê:** hook `cross-ref:agent-without-handoff` disparou 7x como warn em 5 dias (hook-log window). Rule existente em `anti-drift.md §Delegation gate §4` já cobre: "Agent produces research → result written to plan file BEFORE reporting to user. Context is volatile, plan file persists." KBP-29 codifica o anti-pattern detectado pelo hook — governance `one in, one out` ainda não atingida (28/21 cap absoluto documented em `project_self_improvement.md`), mas pointer-only format permite add sem prose bloat.

**Target:** `.claude/rules/known-bad-patterns.md`

**Change (2 edits):**
1. Linha 9: `Next: KBP-29.` → `Next: KBP-30.`
2. Append ao final (linha 95+):
```markdown

## KBP-29 Agent Spawn Without HANDOFF/Plan Persistence
→ anti-drift.md §Delegation gate
```

**Verificação:**
- `grep -c "^## KBP-" .claude/rules/known-bad-patterns.md` retorna 29
- `grep "^## KBP-29" .claude/rules/known-bad-patterns.md` encontra entry
- MEMORY.md quick-ref (`KBPs 28 → 29`) — defer update ao próximo dream

---

## Deferred com razão explícita

### P010 — nudge-commit calibration (LOW)
**Current state (lido de `hooks/nudge-commit.sh`):** threshold 35min + cooldown 15min + requires `TOTAL > 0` modified/untracked.
**Razão deferral:** action rate 13% (11 commits / 145 fires) pode ser apropriado se os 87% são fluxo consciente (Lucas em leitura/pesquisa). Precisa correlação `hook-fired timestamp vs user-action` em 3-5 sessões antes de ajustar threshold. Sem esse signal = guessing.
**Re-evaluation gate:** coletar em próximas sessões. Decidir S239+ se action rate ainda <20%.

### P011 — .dream-pending relocation (LOW)
**Current state:** flag em `$HOME/.claude/.dream-pending`. Touch feito em `.claude/settings.json` Stop hook command line. `should-dream.sh` não toca no flag (só lê `.last-dream`). Remoção do flag é responsabilidade de `/dream` skill (blocked por deny policy em `rm` sob `~/.claude`).
**Razão deferral:** implica mod a `$HOME/.claude/skills/dream/SKILL.md` + `.claude/settings.json` Stop hook command — cruza boundary user/project. Benefício é cosmetic (flag persiste após dream run). `.last-dream` timestamp já serve de source-of-truth efetivo. Custo > valor.

---

## Orçamento e riscos

**Total estimado:** ~45-50min efetivo
- Fase 1: 10min (JSON edit + json.tool validate)
- Fase 2: 5min (JSON S230 note + 2-line comment removal)
- Fase 3: 15min (9 linhas bash insert + dry-run)
- Fase 4: 15min (12 linhas bash insert + simulação)
- Fase 5: 5min (2 edits pointer-only)

**Matriz de risco:**
| Fase | Risco | Likelihood | Impacto | Mitigação |
|------|-------|-----------|---------|-----------|
| 1 | JSON malformado quebra failure-registry load | low | medium | `python3 -m json.tool` antes; `git diff` review; registry não é consumido por hooks críticos |
| 2 | 2-line comment remove altera comportamento | very low | low | Somente comentário, zero behavioral change |
| 3 | 3ª fallback pega sessão errada (branch cruzada) | low | low | `sort -n | tail -1` = max, consistente com session-start.sh:25; falha gracefully se CHANGELOG vazio |
| 4 | Race em rotação se 2 sessões concorrentes | very low | low | Single-session default; mkdir-lock pattern reservado para futuro se evidência emergir |
| 5 | known-bad-patterns.md corrompido | very low | low | Edit Tool verification + Grep pós-edit |

**Rollback:** todas mudanças em 3 arquivos tracked + 1 gitignored (registry). `git checkout -- <file>` reverte atomic para 3 arquivos. Registry rollback via `cat .backup > registry` se tomar backup antes.

**Dependências externas:** zero — tudo é local ao repo. Nenhum API call, nenhum MCP, nenhum side-effect shared.

---

## Verificação end-to-end

Pós-aplicação das 5 fases, executar em ordem:

```bash
# 1. Syntax check shell scripts
bash -n hooks/stop-metrics.sh
bash -n hooks/session-start.sh
bash -n .claude/hooks/momentum-brake-enforce.sh

# 2. Registry JSON válido
python3 -m json.tool .claude/insights/failure-registry.json > /dev/null && echo "registry OK"

# 3. KBP-29 indexed corretamente
grep -c "^## KBP-" .claude/rules/known-bad-patterns.md  # esperado: 29
grep "^## KBP-29" .claude/rules/known-bad-patterns.md   # esperado: Agent Spawn Without HANDOFF

# 4. Dry-run session-start (sem side-effects destrutivos, só output)
bash hooks/session-start.sh > /tmp/s236-session-start.out 2>&1
head -40 /tmp/s236-session-start.out  # esperado: HANDOFF + (se hook-log >500) banner rotate

# 5. Simulação stop-metrics com commit atual (docs: KBP-28 ...)
# Esperado: SESSION_NUM=S236 via 3ª fallback CHANGELOG; linha append em metrics.tsv
bash hooks/stop-metrics.sh < /dev/null
tail -1 .claude/apl/metrics.tsv  # esperado: S236 ...
```

---

## Commit strategy

**Single consolidated commit:**
```
insights: S236 execute P007/P008/P009 + S230 registry reconciliation

- P007: hooks/stop-metrics.sh 3rd CHANGELOG fallback (Conventional Commits compat)
- P008: hooks/session-start.sh auto-rotate hook-log.jsonl (threshold 500)
- P009: .claude/rules/known-bad-patterns.md KBP-29 Agent Spawn w/o HANDOFF
- S230 registry: reconcile P002-P006 implemented (5 commits G.2/3/5/7/8) + P001 keep (evidence-flipped 246 brake-fires/5d)
- Minor: .claude/hooks/momentum-brake-enforce.sh remove 2-line comment fossil

Refs: /insights S236 report .claude/skills/insights/references/latest-report.md
```

**Arquivos alterados (5):**
1. `.claude/insights/failure-registry.json` — reconcile S230 + add S236 proposals_applied
2. `.claude/hooks/momentum-brake-enforce.sh` — -2 li comment
3. `hooks/stop-metrics.sh` — +5 li CHANGELOG fallback
4. `hooks/session-start.sh` — +11 li auto-rotation
5. `.claude/rules/known-bad-patterns.md` — +3 li KBP-29 + header bump

**Não incluir no commit:**
- memory/ files (fora do repo git, scope user .claude dir)
- hook-log.jsonl rotation do /dream (gitignored, local apenas)
- latest-report.md / previous-report.md (tracked mas já commitados separadamente se Lucas decidir)

---

## Referências existentes reutilizadas (Script primacy, anti-drift)

- `hooks/lib/banner.sh` — `banner_warn` / `banner_info` (já usado em session-start.sh e post-tool-use-failure.sh)
- `hooks/lib/hook-log.sh` — `hook_log` function (já usado em momentum-brake-enforce.sh:56)
- `session-start.sh:25` — `grep -o 'Sessao [0-9]*' ... | sort -n | tail -1` pattern reutilizado em P007 (consistency)
- /dream skill Phase 2 Step 2 — threshold 500 + head/tail rotation pattern reutilizado em P008
- `anti-drift.md §Delegation gate §4` — pointer target de KBP-29 (regra já canonical)

Zero código novo não-justificável. Três fallbacks adicionais (P007, P008, KBP-29 pointer) + 2 reconciliations (registry + comment).

---

Coautoria: Lucas + Opus 4.7 | S236 plan execution /insights proposals | 2026-04-21
