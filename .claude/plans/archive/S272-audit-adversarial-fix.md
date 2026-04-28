# Plano S272 — Audit-fix mecânico pós-relatório adversarial

> Sessão: AUDIT_HARD (S272) | Branch: main | HEAD baseline: `bdc0189`
> Audit-source: relatório adversarial inline desta sessão (14 findings: 0 CRITICO + 4 ALTO + 6 MEDIO + 4 BAIXO).

## Context

Auditoria adversarial S272 (read-only) confirmou **drift recursivo**: a mesma sessão (S271, commit `4b6828f`) que adicionou INV-4 count-integrity validator também adicionou Stop[1] tier-S Pre-mortem prompt hook. Bumpou prompts de 1→2 e command hooks de 33→32 (total 34 inalterado), mas o breakdown "33 cmd + 1 prompt" continua repetido em 5 docs porque INV-4 só valida agent/skill counts FS, não a subdivisão dos hooks.

VALUES.md também escapou do "truth-pass S270" declarado em `CHANGELOG.md:126` (continua "agents (19) + skills (18)"). CHANGELOG.md tem 13 sessões ativas vs cap "max 10" declarado em `anti-drift.md:74`. AGENTS.md §EC tiers (fork de `anti-drift.md §EC tiers`) está dessincronizado em qualifiers Tier M+T.

Outcome desejado: 4 fixes mecânicos (zero decisão Lucas) executados em 5 commits separados; 8 fixes que dependem de decisão Lucas ficam **deferred com gate explícito** (não Cut, KBP-41) e são listados no HANDOFF S273.

## Escopo

### Dentro

1. **Wave 1 — VALUES.md count fix** (A2)
2. **Wave 2 — CHANGELOG truncate** (A4)
3. **Wave 3 — INV-4 extension + 5-docs hook breakdown sync** (A1)
4. **Wave 4 — AGENTS.md §EC tiers fork re-sync** (A3)
5. **Wave 5 — ARCHITECTURE.md §Model Routing precedence clarify** (M1)
6. **Wave 6 — Stop[1] ok:false telemetry append** (M6 prerequisite to M2)

### Fora (deferred com gate)

- **M2 (Stop[1] regex tolerância):** gate = M6 telemetry produzir ≥5 sessões de hits/misses. Calibrar threshold com dados.
- **M3 (systematic-debugger ↔ systematic-debugging):** decisão Lucas keep skill / cut agent OR documentar diferenciação.
- **M4 (`.claude/.parallel-runs/` retention):** decisão Lucas gitignore vs move-to-`docs/research/benchmarks/`.
- **M5 (candidate-delete partial: nlm-skill + skill-creator):** decisão Lucas 1-a-1 (audit S270 §8 bulk-delete proibido).
- **B1 (tools/docling):** decisão Lucas keep/move/delete.
- **B2 (`.claude/scripts/gemini-review.mjs`):** decisão Lucas delete vs catalog.
- **B3 (115 plans archive retention):** decisão Lucas declare policy vs accept grow-only.
- **B4 (README "7-layer antifragile" → "5-layer + 2 gaps"):** decisão Lucas rewrite vs keep footnote disclaim.

## Plan

### Wave 1 — VALUES.md count fix (A2) — 2min, Tier-S

**File:** `VALUES.md:33`
**Edit:** `Dedicated agents (19) + skills (18) por domain` → `Dedicated agents (21) + skills (19) por domain`
**Pre-mortem:** VALUES.md pode ter contagens em outras linhas; `grep -n "agents\|skills" VALUES.md` antes do Edit pra confirmar única ocorrência.
**Rollback:** `git checkout VALUES.md`.
**Verification:** `bash tools/integrity.sh && grep "INV-4" .claude/integrity-report.md` — deve ainda PASS (VALUES não estava em `docs[]` array, mas é honest fix).
**Commit:** `docs(values): A2 truth-pass S272 — sync agents/skills counts pós-S271`

### Wave 2 — CHANGELOG truncate (A4) — 15min, Tier-S

**Files:** `CHANGELOG.md` (remove 3 oldest active sessions), `docs/CHANGELOG-archive.md` (append).
**Action:** `grep -n "^## Sessao" CHANGELOG.md` mostra 13 sessions; mover S262, S263, S264 (3 mais antigos) para top de `docs/CHANGELOG-archive.md` preservando ordem cronológica reversa (mais recente primeiro). CHANGELOG.md fica com 10 sessions visíveis (cap compliance).
**Pre-mortem:** truncate errado pode perder Aprendizados úteis; verify section bounds via `grep -n "^## Sessao" CHANGELOG.md` antes do Edit.
**Rollback:** `git checkout CHANGELOG.md docs/CHANGELOG-archive.md`.
**Verification:** `grep -c "^## Sessao" CHANGELOG.md` ≤ 10; `grep -c "^## Sessao" docs/CHANGELOG-archive.md` aumenta em 3.
**Commit:** `docs(changelog): A4 truncate S262-S264 → archive (cap 10 ativas)`

### Wave 3 — INV-4 extension + 5 docs sync (A1) — 35min, Tier-S

**Files (ordem):**
1. `tools/integrity.sh` — estender `check_inv_4` com prompt-vs-cmd breakdown.
2. Run `bash tools/integrity.sh` → confirmar reports actual breakdown.
3. Sync 5 docs com real numbers (`32 command + 2 inline prompts`):
   - `CLAUDE.md` (linha "Hooks em `.claude/hooks/` + `hooks/`...")
   - `README.md:19`
   - `docs/ARCHITECTURE.md:14,82`
   - `.claude/hooks/README.md:3`
4. Run `bash tools/integrity.sh` → INV-4 PASS confirmado.

**INV-4 extension logic (pseudocode):**
```bash
# Adicionar ao check_inv_4 após linha 125:
local fs_prompts fs_cmds
fs_prompts=$(jq '[.. | objects | select(.type=="prompt")] | length' .claude/settings.json)
fs_cmds=$(jq '[.. | objects | select(.type=="command")] | length' .claude/settings.json)

for doc in "${docs[@]}"; do
  prompts_in=$(grep -oE '[0-9]+ inline prompt' "$doc" 2>/dev/null | head -1 | grep -oE '[0-9]+')
  cmds_in=$(grep -oE '[0-9]+ command hooks?' "$doc" 2>/dev/null | head -1 | grep -oE '[0-9]+')
  # FAIL se diverge de fs_prompts/fs_cmds
done
```

**Pre-mortem:** jq pode não estar disponível em PATH (Windows Git Bash) — `command -v jq` antes de usar; se ausente, usar grep heurístico no settings.json. Padrão grep doc pode pegar sub-strings erradas; testar regex com 5 docs reais antes de commit.
**Rollback:** `git checkout tools/integrity.sh README.md CLAUDE.md docs/ARCHITECTURE.md .claude/hooks/README.md`.
**Verification:** `bash tools/integrity.sh` retorna exit 0 + integrity-report.md mostra `[PASS]` para todos 5 docs em INV-4 cmd/prompt. Self-test: 6 docs × 4 counts (agents, skills, cmds, prompts) = 24 checks (alguns SKIP esperados).
**Commit:** `feat(integrity): INV-4 v2 — prompt-vs-cmd breakdown + 5 docs sync`

### Wave 4 — AGENTS.md §EC tiers fork re-sync (A3) — 12min, Tier-S

**File:** `AGENTS.md:14-19`
**Action:** copy literal Tier M + Tier T do `anti-drift.md:89-90` master (preservar PT-BR variant onde fork intencionalmente diverge — neste caso bullets factual content alinha exato).

**Specific changes:**
- `AGENTS.md:18` Tier M: adicionar `, novos agents/skills, deletes de hook/script versionado` no final.
- `AGENTS.md:19` Tier T: substituir `Pre-mortem/Steelman/[budget] opcionais com motivo.` por `typo fix, single-line fix óbvio em arquivo já owned, doc prose Edit não-canônica. Pre-mortem/Steelman/[budget] opcionais — engenheiro experiente skipping com motivo é OK; aplicar mesmo assim não é teatro se motivo claro existe.`

**Pre-mortem:** fork pode ser intencionalmente shorter para Codex/Gemini (não Claude) — re-sync overshoot pode quebrar leitura cross-CLI. Mitigation: AGENTS.md:15 self-comment já declara "re-sync ao mudar master"; intent é sync.
**Rollback:** `git checkout AGENTS.md`.
**Verification:** `diff <(sed -n '88,90p' .claude/rules/anti-drift.md) <(sed -n '17,19p' AGENTS.md)` — bullets factuais match (whitespace pode divergir, OK).
**Commit:** `docs(agents): A3 re-sync §EC tiers fork com anti-drift master`

### Wave 5 — ARCHITECTURE.md §Model Routing precedence (M1) — 5min, Tier-S

**File:** `docs/ARCHITECTURE.md` §Model Routing (linhas 186-194 aprox).
**Action:** adicionar 1 linha clarificando precedência: `**Subagent model precedence:** agent frontmatter \`model:\` (e.g., \`debug-strategist.md:8\`) overrides \`CLAUDE_CODE_SUBAGENT_MODEL\` env var (`settings.json:12\`). Env var = default para agents sem model pinned.`
**Pre-mortem:** afirmação não verificada empiricamente — flag como "documented behavior" not tested. Se precedência for inversa, doc fica errado. Mitigation: marcar `<!-- HIPOTESE: confirmar via 1 invocation log -->` inline.
**Rollback:** `git checkout docs/ARCHITECTURE.md`.
**Verification:** `grep "Subagent model precedence" docs/ARCHITECTURE.md` ≥ 1 hit.
**Commit:** `docs(arch): M1 model precedence clarify (env vs frontmatter)`

### Wave 6 — Stop[1] ok:false telemetry (M6) — 12min, Tier-S

**File:** `.claude/settings.json` Stop[1] prompt.
**Action:** adicionar antes do `$ARGUMENTS` no prompt: `If responding ok:false, ALSO log to .claude/stop-stderr.log via the response: prepend "[Stop1-trigger ${reason_short}]" so post-hook bash can grep --count.`

Alternative más simples (preferida): adicionar Stop[6] command hook que tail `.claude/stop-stderr.log` + extract ok:false events. Mas isso requer mudança no formato output do prompt — mais frágil. **Decisão técnica:** preferir Wave 6 short version: deixar o prompt como está, e adicionar 1 linha ao `hooks/stop-quality.sh` (Stop[2]) que grep stop-stderr.log para "Tier S Edit" + "Scope extension" patterns e append em `.claude/stop1-telemetry.jsonl`.

**Specific change (revised):** edit `hooks/stop-quality.sh` (Stop[2] command) — adicionar bloco que detecta Stop[1] ok:false events em previous turn (via stderr log) e append jsonl.

**Pre-mortem:** `stop-stderr.log` capture pode ser inconsistente (timing de when CC writes to it relativo a stop-quality runs). Se hook não captura, telemetry vira null sem alarme. Mitigation: Wave 6 fica COMO PROTOTIPO; calibrate quality em Wave 6.5 (defer) se telemetry empty após 3 sessions.
**Rollback:** `git checkout hooks/stop-quality.sh`.
**Verification:** após próxima Tier-S Edit que skipping Pre-mortem, `wc -l .claude/stop1-telemetry.jsonl` aumenta.
**Commit:** `feat(telemetry): M6 Stop[1] ok:false jsonl capture (M2 prerequisite)`

## TaskCreate plan

Per `anti-drift.md §Plan execution`: 6 phases ≥ 4 → mandatory TaskCreate batch ao approval. Tasks:
1. Wave 1 — VALUES.md fix
2. Wave 2 — CHANGELOG truncate
3. Wave 3 — INV-4 extension + 5 docs sync
4. Wave 4 — AGENTS.md fork re-sync
5. Wave 5 — ARCHITECTURE.md model precedence
6. Wave 6 — Stop[1] telemetry capture

## Verification end-to-end

Após Wave 6:
- `bash tools/integrity.sh && cat .claude/integrity-report.md` — INV-2 PASS 33/33, INV-4 PASS counts + breakdowns, INV-5 PASS (sem pollution).
- `grep -c "^## Sessao" CHANGELOG.md` ≤ 10.
- `grep "21 .* 19 skills" VALUES.md README.md docs/ARCHITECTURE.md` ≥ 3 hits (post-fix).
- `grep "32 command\|2 inline prompt" CLAUDE.md README.md docs/ARCHITECTURE.md .claude/hooks/README.md` ≥ 4 hits.
- `diff` AGENTS.md §EC tiers vs anti-drift.md §EC tiers bullets — factual content matches.
- `wc -l .claude/stop1-telemetry.jsonl` — file existe, mesmo que linha 0.
- `git log --oneline -6` — 6 commits sequenciais um por wave.

## HANDOFF.md update (post-Wave 6)

Atualizar §3 Lane C com:
- Status: S272 fechou A1+A2+A3+A4+M1+M6 (6/14 findings audit S272).
- Defer S273+: M2 (gate M6 telemetry ≥5 sessions), M3 (decisão Lucas), M4 (decisão), M5 (decisão), B1 (decisão), B2 (decisão), B3 (decisão), B4 (decisão).
- Roadmap Now: adicionar `[S273+ audit S272 deferred]` linha pointing para este plano archived.

## CHANGELOG.md update (post-Wave 6)

Single entry `## Sessao 272 — 2026-04-28 (audit S272 mecânico fix + INV-4 v2)` com 6 bullet lines (1 per wave) + Aprendizados (max 5 li): drift recursivo padrão, INV-4 v2 cobre breakdown, fork re-sync precisa de hook validador (KBP candidate?), telemetry-before-regex calibration order.

## Critical files reference

| File | Wave | Purpose |
|---|---|---|
| `VALUES.md:33` | 1 | Truth-pass count |
| `CHANGELOG.md` | 2 | Cap compliance |
| `docs/CHANGELOG-archive.md` | 2 | Archive destino |
| `tools/integrity.sh:82-134` | 3 | check_inv_4 extension |
| `CLAUDE.md` | 3 | Hook breakdown sync |
| `README.md:19` | 3 | Hook breakdown sync |
| `docs/ARCHITECTURE.md:14,82` | 3 + 5 | Hook breakdown + model precedence |
| `.claude/hooks/README.md:3` | 3 | Hook breakdown sync |
| `AGENTS.md:14-19` | 4 | EC tiers fork re-sync |
| `hooks/stop-quality.sh` | 6 | Stop[1] telemetry append |

## Estimated cost

- Tool calls: ~50-70 (Read+Edit+Bash verify per wave).
- Tempo: 80-90min sequencial.
- Commits: 6 (one-concern per anti-drift §Scope).
- Risk: BAIXO. Tudo é Tier-S formal mas changes são pontuais; rollback per-wave atômico via `git checkout`.

## Out-of-scope (não cobrir nesta sessão)

- Decisões M2/M3/M4/M5/B1/B2/B3/B4 — deferred com gate explícito acima.
- Migração `.mjs` D-lite — Lane B tem own gate (re-bench Gemini 429 resolution).
- Metanálise QA editorial — Lane A tem own roadmap.
- Audit de skill bodies (17 skills sem leitura body completa nesta auditoria) — defer próxima audit S275+.
