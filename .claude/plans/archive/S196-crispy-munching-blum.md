# Plan: Hooks Fase 2 — Consolidação

## Context

Fase 1 (S193) migrou 6 hooks node→jq e adicionou 4 campos `if`. Resultado: 37 registros, ~1-2 node spawns/Edit (antes: 6-8).

**Problema residual:** guard-worker-write.sh ainda tem 3-4 node spawns (único não migrado). PostToolUse Bash dispara 3 scripts com node. Stop dispara 7 hooks com 3 git diff redundantes. PostToolUse `.*` dispara 2 scripts separados em todo tool call.

**Objetivo:** consolidar hooks que parseiam o mesmo JSON, eliminar últimos node spawns do hot path. 37→29 registros, 0 node spawns em operações comuns.

## Divergência do plano Fase 2 original

O plano S193 (polished-wibbling-cloud.md §Fase 2) propunha merge de guard-secrets + guard-bash-write (2.3). **Revisão:** manter separados.

**Por quê:** concerns diferentes (secret scanning staged files vs write-pattern detection), complexidade combinada 250+ linhas, guard-secrets já tem `if: Bash(*git *)` (baixa frequência). Merge não é elite — só reduz file count sem ganho real. Ação: migrar guard-secrets node→jq standalone.

## Implementação (5 steps, ordem por risco/impacto)

### Step 1: PostToolUse `.*` merge (2→1) — TRIVIAL

Merge: `cost-circuit-breaker.sh` + `momentum-brake-arm.sh` → `.claude/hooks/post-global-handler.sh`

- Ambos pure bash, `cat >/dev/null` stdin
- Combinar: count+warn+arm em 1 script
- 0 dependências, 0 JSON parsing

**Ficheiros:** criar `.claude/hooks/post-global-handler.sh`, remover 2 antigos, 2→1 em settings

### Step 2: PreToolUse Write|Edit merge (3→1) + node→jq — ALTO IMPACTO

Merge: `guard-worker-write.sh` + `guard-generated.sh` + `guard-product-files.sh` → `.claude/hooks/guard-write-unified.sh`

**Lógica dispatch (ordem = prioridade):**
1. Parse path + tool_name com 1 jq call (substitui 4 node spawns de guard-worker-write)
2. Worker timestamp enforcement (bash regex + date arithmetic, substitui node timestamp validation)
3. Generated file block (`content/aulas/*/index.html`)
4. Infra file block/ask (hooks/*.sh → block, settings.json → ask)
5. Product file ask (slides, CSS, JS, manifests, scripts)

**Detalhes timestamp (complexidade migrada):**
- Write: extrair first line do content via jq → `jq -r '.tool_input.content // ""' | head -1`
- Edit: ler first line do file existente via `head -1`
- Validar formato: bash `[[ =~ ]]` com pattern `[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}`
- Validar ranges: bash arithmetic `(( MO < 1 || MO > 12 ... ))`
- Validar staleness: `date -d "$TS" +%s` vs `date +%s`, diff > 300s = stale

**Ficheiros:** criar `.claude/hooks/guard-write-unified.sh`, remover 3 antigos, 3→1 em settings

### Step 3: guard-secrets node→jq — QUICK WIN

Migrar line 13-16 de guard-secrets.sh:
```bash
# ANTES:
CMD=$(echo "$INPUT" | node -e "...JSON.parse..." 2>/dev/null)
# DEPOIS:
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // ""' 2>/dev/null)
```

Manter `if: Bash(*git *)` field. Não merge com guard-bash-write.

**Ficheiro:** editar `.claude/hooks/guard-secrets.sh` in-place (Write→temp→cp)

### Step 4: PostToolUse Bash merge (3→1) + node→jq — MÉDIO IMPACTO

Merge: `build-monitor.sh` + `success-capture.sh` + `hook-calibration.sh` → `.claude/hooks/post-bash-handler.sh`

**Lógica dispatch:**
1. Parse command + interrupted via 1 jq call (substitui 3 node spawns)
2. If `npm run build` + stderr: log build failure (build-monitor)
3. If `git commit` + not interrupted: log commit (success-capture, jq para JSON output)
4. Always: check breadcrumbs em `/tmp/olmo-hook-fired-*` (hook-calibration, jq para JSON output)

**Sem `if` field no registro combinado** — hook-calibration precisa de todo Bash. Dispatch interno substitui.

**Nota:** build-monitor usa retry-utils.sh. Com jq (mais confiável que node), retry desnecessário. retry-utils.sh mantido para lint-on-edit.sh e guard-lint-before-build.sh.

**Ficheiros:** criar `.claude/hooks/post-bash-handler.sh`, remover `build-monitor.sh` + `hook-calibration.sh` de `.claude/hooks/`, remover `success-capture.sh` de `hooks/`, 3→1 em settings (remover 2 `if` fields que não se aplicam ao combinado)

### Step 5: Stop merge (7→4) — LIMPEZA

**Grupo A — stop-quality.sh** (crossref + detect-issues + hygiene):
- 1 git diff call (era 3 independentes)
- Cross-ref warnings (imediato)
- Issue detection (persist pending-fixes.md com hash dedup)
- Hygiene check (HANDOFF/CHANGELOG)
- Print HANDOFF para context recovery

Replace: `stop-crossref-check.sh` + `stop-detect-issues.sh` + `stop-hygiene.sh` → `hooks/stop-quality.sh`

**Grupo B — stop-metrics.sh** (scorecard + chaos):
- Session metrics (duration, commits, cost, hygiene)
- Chaos report (condicional, só se CHAOS_MODE ativo)

Replace: `stop-scorecard.sh` + `stop-chaos-report.sh` → `hooks/stop-metrics.sh`

**Mantidos separados:**
- `stop-notify.sh` — tech diferente (powershell)
- `stop-should-dream.sh` — escopo diferente (dream scheduling)

**Ficheiros:** criar 2 em `hooks/`, remover 5, 7→4 em settings

## Inventário resultado

| Métrica | Antes (Fase 1) | Depois (Fase 2) | Delta |
|---------|----------------|------------------|-------|
| Registros settings | 37 | 29 | -8 |
| Scripts .claude/hooks/ | 20 | 15 | -5 |
| Scripts hooks/ | 17 | 14 | -3 |
| Total scripts | 37 | 29 | -8 |
| Node spawns/Edit | 3-4 | 0 | -4 |
| Node spawns/Bash(ls) | 1 | 0 | -1 |
| Node spawns/git commit | 4-5 | 0 | -5 |
| Process spawns/Stop | 7 | 4 | -3 |

**Node spawns restantes pós-Fase 2 (5, todos baixa frequência):**
- guard-lint-before-build.sh (if: npm run build)
- guard-research-queries.sh (matcher: Skill)
- model-fallback-advisory.sh (matcher: Agent|Bash)
- lint-on-edit.sh (matcher: Write|Edit)
- apl-cache-refresh.sh (SessionStart, 1x/sessão)

## Deploy pattern (cada step)

```
Write→temp → bash test JSON pipe → cp temp→final → rm temp → update settings → git commit
```

Testar cada hook com JSON de exemplo:
```bash
# PreToolUse test:
echo '{"tool_name":"Edit","tool_input":{"file_path":"test.txt"}}' | bash .claude/hooks/guard-write-unified.sh
echo $? # esperado: 0

# Produto test:
echo '{"tool_name":"Edit","tool_input":{"file_path":"content/aulas/metanalise/slides/s-forest.html"}}' | bash .claude/hooks/guard-write-unified.sh
echo $? # esperado: 0 com ask JSON

# Block test:
echo '{"tool_name":"Write","tool_input":{"file_path":"content/aulas/metanalise/index.html"}}' | bash .claude/hooks/guard-write-unified.sh
echo $? # esperado: 2
```

## Commits (1 por step)

1. `S194: hooks Fase 2 step 1 — merge PostToolUse .* (cost+momentum → post-global-handler)`
2. `S194: hooks Fase 2 step 2 — merge PreToolUse Write|Edit (3 guards → guard-write-unified, 0 node)`
3. `S194: hooks Fase 2 step 3 — guard-secrets node→jq migration`
4. `S194: hooks Fase 2 step 4 — merge PostToolUse Bash (3→post-bash-handler, 0 node)`
5. `S194: hooks Fase 2 step 5 — merge Stop (7→4, deduplicate git diff)`

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Timestamp validation em bash falha com em dash Unicode | Testar regex com string contendo — (UTF-8) em Git Bash |
| jq path normalization diverge de node | `gsub("\\\\"; "/")` testado em Fase 1, mesmo pattern |
| Stop merge perde issue caso edge case | Testar com git diff artificial (stage files, run hook) |
| retry-utils.sh órfão após build-monitor removido | Manter — usado por lint-on-edit + guard-lint-before-build |
| Settings edit introduz JSON syntax error | Validar com `jq . settings.local.json` pós-edit |
