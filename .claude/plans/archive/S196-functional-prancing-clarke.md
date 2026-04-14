# Plan: S195 Hooks Fase 2 — Steps 4-5

## Context

Continuacao do plano-mae `crispy-munching-blum.md`. Steps 1-3 concluidos em S194.
Estado atual: 34 registros settings, 34 scripts. Steps 4-5 reduzem para 29/29.

## Step 4: PostToolUse Bash 3→1 (post-bash-handler.sh)

### Fontes (3 scripts, 4 node spawns)

| Script | Local | Node spawns | if field | Funcao |
|--------|-------|-------------|----------|--------|
| `build-monitor.sh` | `.claude/hooks/` | 1 (parse, retry) | `Bash(*npm run build*)` | Log build failures → NOTES.md |
| `success-capture.sh` | `hooks/` | 2 (parse + JSON) | `Bash(*git commit*)` | Log commits → success-log.jsonl |
| `hook-calibration.sh` | `hooks/` | 1 (JSON output) | (nenhum) | Log breadcrumbs → hook-stats.jsonl |

### Destino: `.claude/hooks/post-bash-handler.sh`

Logica:
1. Parse stdin com 1 `jq` call: command, interrupted, cwd, stderr
2. **Build gate:** se command contem `npm run build` E stderr nao-vazio E nao interrupted → log failure (NOTES.md)
3. **Commit gate:** se command contem `git commit` E nao interrupted → git log + jq JSON → success-log.jsonl
4. **Always:** check breadcrumbs `/tmp/olmo-hook-fired-*` → jq JSON → hook-stats.jsonl

Sem `if` field no registro (hook-calibration precisa de todo Bash).
retry-utils.sh NAO usado (jq mais confiavel que node, retry desnecessario).

### Settings changes

Remover 3 PostToolUse Bash entries (linhas ~281-359):
- build-monitor.sh (com `if`)
- success-capture.sh (com `if`)
- hook-calibration.sh (sem `if`)

Adicionar 1:
```json
{
  "matcher": "Bash",
  "hooks": [{
    "type": "command",
    "command": "bash /c/Dev/Projetos/OLMO/.claude/hooks/post-bash-handler.sh",
    "timeout": 5000
  }]
}
```

### Ficheiros a remover
- `.claude/hooks/build-monitor.sh`
- `hooks/success-capture.sh`
- `hooks/hook-calibration.sh`

### Commit
`S195: hooks Fase 2 step 4 — merge PostToolUse Bash (3→post-bash-handler, 0 node)`

---

## Step 5: Stop 7→4

### Grupo A → `hooks/stop-quality.sh` (crossref + detect-issues + hygiene)

Fontes:
- `hooks/stop-crossref-check.sh` (61 linhas) — 2 git diff calls, warnings stdout
- `hooks/stop-detect-issues.sh` (87 linhas) — 2 git diff calls, persist pending-fixes.md
- `hooks/stop-hygiene.sh` (40 linhas) — 2 git diff calls, hygiene + HANDOFF print

Overlap critico: checks 1-3 de crossref e detect-issues sao IDENTICOS. Ambos checam:
1. Slide HTML → _manifest.js
2. Evidence HTML → slide HTML
3. _manifest.js → index.html rebuild
4. crossref: agent def → HANDOFF
5. detect-issues: HANDOFF/CHANGELOG hygiene
6. hygiene: HANDOFF/CHANGELOG hygiene (formato diferente)

Logica merged:
1. `cat >/dev/null` stdin (drain)
2. 1x `git diff --name-only HEAD` + 1x `git diff --cached --name-only` → ALL_CHANGED (shared)
3. Cross-ref checks (slide→manifest, evidence→slide, manifest→index, agent→HANDOFF) → print warnings + accumulate ISSUES
4. Hygiene check (HANDOFF + CHANGELOG, same logic as detect-issues check 4) → print warning + accumulate ISSUES
5. Persist ISSUES to pending-fixes.md (hash dedup, same as detect-issues)
6. Print HANDOFF para context recovery (same as hygiene)

Git diff calls: 2 (era 6 nos 3 scripts separados).

### Grupo B → `hooks/stop-metrics.sh` (scorecard + chaos)

Fontes:
- `hooks/stop-scorecard.sh` (78 linhas) — session metrics 2-line summary
- `hooks/stop-chaos-report.sh` (82 linhas) — conditional chaos report (so se CHAOS_MODE)

Logica merged:
1. `cat >/dev/null` stdin (drain)
2. Scorecard: session name, duration, commits, tool calls, cost, hygiene → 2-line output
3. Chaos gate: `[ ! -f /tmp/cc-chaos-log.jsonl ] && skip`; else full chaos report box

Scorecard precisa de 2 git diff calls proprios (hygiene check). Total: 2 calls.

### Mantidos separados (sem mudanca)
- `hooks/stop-notify.sh` — PowerShell, tech diferente
- `hooks/stop-should-dream.sh` — dream scheduling, escopo diferente

### Settings changes

Remover 5 Stop entries:
- stop-crossref-check.sh
- stop-detect-issues.sh
- stop-chaos-report.sh
- stop-hygiene.sh
- stop-scorecard.sh

Adicionar 2:
```json
{ "hooks": [{ "type": "command", "command": "bash /c/Dev/Projetos/OLMO/hooks/stop-quality.sh", "timeout": 5000 }] },
{ "hooks": [{ "type": "command", "command": "bash /c/Dev/Projetos/OLMO/hooks/stop-metrics.sh", "timeout": 5000 }] }
```

Ordem no settings: stop-quality → stop-metrics → stop-notify → stop-should-dream

### Ficheiros a remover
- `hooks/stop-crossref-check.sh`
- `hooks/stop-detect-issues.sh`
- `hooks/stop-chaos-report.sh`
- `hooks/stop-hygiene.sh`
- `hooks/stop-scorecard.sh`

### Commit
`S195: hooks Fase 2 step 5 — merge Stop (7→4, deduplicate git diff)`

---

## Inventario final projetado

| Metrica | Antes (S194 fim) | Depois (S195) | Delta |
|---------|-------------------|---------------|-------|
| Registros settings | 34 | 29 | -5 |
| PostToolUse Bash scripts | 3 | 1 | -2 |
| Stop scripts | 7 | 4 | -3 |
| Node spawns/Bash(qualquer) | 4 | 0 | -4 |
| Git diff calls/Stop | ~10 | ~4 | -6 |

## Deploy pattern (cada step)

```
Write→/tmp/  →  echo JSON | bash /tmp/script.sh  →  cp→final  →  Edit settings  →  jq validate  →  rm antigos  →  git commit
```

## Verificacao

Step 4 tests:
```bash
# Parse test (qualquer comando):
echo '{"tool_input":{"command":"ls -la"},"tool_response":{"interrupted":false}}' | bash /tmp/post-bash-handler.sh
# Build failure test:
echo '{"tool_input":{"command":"npm run build"},"tool_response":{"interrupted":false,"stderr":"Error: failed"},"cwd":"."}' | bash /tmp/post-bash-handler.sh
# Commit test:
echo '{"tool_input":{"command":"git commit -m test"},"tool_response":{"interrupted":false}}' | bash /tmp/post-bash-handler.sh
```

Step 5 tests:
```bash
# Quality with no changes:
echo '' | bash /tmp/stop-quality.sh
# Metrics basic:
echo '' | bash /tmp/stop-metrics.sh
```

Post-deploy: `jq . .claude/settings.local.json` (validate JSON)
