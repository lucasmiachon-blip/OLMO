# Plan: Hooks Optimization — S193 ADVERSARIAL

## Context

Audit adversarial (Codex + web research) revelou que o sistema de hooks OLMO esta significativamente atras do estado da arte. 38 hook registrations com ~40 shell scripts, spawning 6-8 processos Node.js por tool call (~600-1200ms overhead). Claude Code v2.1.108 suporta features que eliminam a maioria desses spawns: campo `if` (pre-filtering nativo), `jq` disponivel (10x mais rapido que node), 26 eventos (usamos 8), 4 handler types (usamos 1).

**Problema central:** cada `node -e` para parsear JSON custa ~70-150ms de startup. Com 6-8 spawns por tool call, adicionamos 600-1200ms de overhead PURO a cada acao do agent.

**Objetivo:** reduzir overhead por tool call em ~60-80%, corrigir bugs conhecidos, eliminar dead code, e adotar patterns do estado da arte.

## Fase 1 — Quick Wins (esta sessao)

### 1.1 Dead code removal
- **Deletar** `.claude/hooks/guard-pause.sh` — existe mas NAO registrado em settings.local.json. Dead code confirmado.
- **Verificar** `.claude/hooks/lib/retry-utils.sh` — so usado por build-monitor.sh e guard-lint-before-build.sh. Manter se referenciado.

### 1.2 Campo `if` para evitar spawns desnecessarios
O campo `if` usa permission-rule syntax e faz o hook NEM SPAWNAR se o tool call nao matchear. Zero overhead.

| Hook | Matcher atual | Adicionar `if` | Efeito |
|------|--------------|----------------|--------|
| `success-capture.sh` | PostToolUse Bash | `"if": "Bash(*git commit*)"` | So spawna em git commit (~5% dos Bash calls) |
| `build-monitor.sh` | PostToolUse Bash | `"if": "Bash(*npm run build*)"` | So spawna em builds (~2% dos Bash calls) |
| `guard-lint-before-build.sh` | PreToolUse Bash | `"if": "Bash(*npm run build*)"` | So spawna em builds |
| `guard-secrets.sh` | PreToolUse Bash | `"if": "Bash(*git *)"` | So spawna em git commands (~20% dos Bash calls) |

**Impacto estimado:** elimina ~4 hooks do hot path de Bash commands comuns (ls, cat, grep, etc.).

### 1.3 Node.js → jq migration (hooks de alta frequencia)
Substituir `node -e "...JSON.parse..."` por `jq -r` em hooks que disparam frequentemente.

**Prioridade por frequencia de disparo:**

| Hook | Dispara em | Node spawns | Migrar para |
|------|-----------|-------------|-------------|
| `momentum-brake-enforce.sh` | TODA PreToolUse (`.*`) | 1 | `jq -r '.tool_name // ""'` |
| `guard-bash-write.sh` | Toda PreToolUse Bash | 1 | `jq -r '.tool_input.command // ""'` |
| `guard-read-secrets.sh` | Toda PreToolUse Read | 1 | `jq -r '.tool_input.file_path // ""'` |
| `guard-generated.sh` | Toda PreToolUse Write\|Edit | 1 | `jq -r '.tool_input.file_path // ""'` |
| `guard-product-files.sh` | Toda PreToolUse Write\|Edit | 1 | `jq -r` com path normalization |
| `coupling-proactive.sh` | Toda PostToolUse Edit | 1 | `jq -r '.tool_input.file_path // ""'` |

**Pattern de migracao (cada hook):**
```bash
# ANTES (70-150ms):
FILE_PATH=$(echo "$INPUT" | node -e "
  try {
    const d=JSON.parse(require('fs').readFileSync(0,'utf8'));
    console.log((d.tool_input||{}).file_path||'');
  } catch(e) { console.log(''); }
" 2>/dev/null)

# DEPOIS (5-10ms):
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""' 2>/dev/null)
```

**Caso especial — path normalization Windows:**
guard-product-files.sh e guard-worker-write.sh normalizam `\\` → `/`. Com jq:
```bash
FILE_PATH=$(echo "$INPUT" | jq -r '(.tool_input.file_path // "") | gsub("\\\\"; "/")' 2>/dev/null)
```

### 1.4 Bug fixes

**1.4a stop-detect-issues.sh dedup (HANDOFF P1)**
Problema: logica `DOMINATED=true` com flip inverso. Linhas 78-88.
Fix: substituir por hash MD5 do bloco de issues contra hashes existentes no arquivo.
```bash
ISSUES_HASH=$(echo -e "$ISSUES" | md5sum | cut -d' ' -f1)
if ! grep -q "$ISSUES_HASH" "$PENDING" 2>/dev/null; then
  echo "" >> "$PENDING"
  echo "<!-- hash:$ISSUES_HASH -->" >> "$PENDING"
  echo "## $NOW — Issues detected at session end" >> "$PENDING"
  echo -e "$ISSUES" >> "$PENDING"
fi
```

**1.4b session-start.sh orphan rename (HANDOFF P1)**
Problema: `mv` na linha 42 cria arquivos orfaos com timestamp.
Fix: manter path canonico. Ao inves de rename, truncar o conteudo apos surfacear.
```bash
# Substituir mv por truncate apos exibir
if [ -f "$PENDING" ] && [ -s "$PENDING" ]; then
  echo "=== PENDING FIXES ==="
  cat "$PENDING"
  # Truncate (keep file, clear content) — nao rename
  > "$PENDING"
fi
```

**1.4c guard-bash-write.sh Pattern 7 — python bypass (backlog #20)**
Adicionar patterns para `python script.py`, `python ./file.py`, `python3`, `py`:
```bash
# Pattern 7: Python execution (both -c inline AND script file)
if echo "$CMD" | grep -qE 'python3?\s+(-c\b|[^-])'; then
  # Allow pure python --version, python --help
  if ! echo "$CMD" | grep -qE 'python3?\s+--(version|help)'; then
    printf '...'
    exit 0
  fi
fi
```

**1.4d stop-should-dream.sh portabilidade (backlog #22)**
Problema: `date -d` e GNU-only. No MSYS2/Windows pode falhar silently → assume overdue → multi-fire.
Fix: usar aritmetica bash pura para parsear ISO 8601:
```bash
# Parse ISO timestamp with pure bash (cross-platform)
TS=$(cat "$LAST_DREAM_FILE")
# Extract epoch: try GNU date, fallback to node, fallback to overdue
LAST=$(date -d "$DATE_STR" +%s 2>/dev/null || \
       node -e "console.log(Math.floor(new Date('$TS').getTime()/1000))" 2>/dev/null || \
       echo "")
```

## Fase 2 — Consolidacao (sessao seguinte)

### 2.1 PreToolUse Write|Edit: 3 → 1 script
Merge: `guard-worker-write.sh` + `guard-generated.sh` + `guard-product-files.sh` → `guard-write-unified.sh`
- 1 parse de JSON com jq (em vez de 3 Node.js spawns)
- Dispatch interno por path pattern
- Economia: 2 process spawns por Write/Edit call

### 2.2 PostToolUse Bash: 3 → 1 script
Merge: `build-monitor.sh` + `success-capture.sh` + `hook-calibration.sh` → `post-bash-handler.sh`
- 1 parse de JSON com jq (em vez de 3 Node.js spawns)
- Dispatch interno por command type
- Nota: com campo `if`, build-monitor e success-capture ja nao spawnam no hot path. Consolidacao reduz file count.

### 2.3 PreToolUse Bash: 2 → 1 script
Merge: `guard-secrets.sh` + `guard-bash-write.sh` → `guard-bash-unified.sh`
- Ambos parseiam command do JSON. 1 parse em vez de 2.
- guard-secrets so roda em git commit/add (ja filtrado por `if` field na Fase 1)
- guard-bash-write roda em todos Bash — mantém separado ate que `if` field suporte OR patterns

### 2.4 PostToolUse `.*`: 2 → 1 script
Merge: `cost-circuit-breaker.sh` + `momentum-brake-arm.sh` → `post-global-handler.sh`
- Ambos sao bash puro (sem node). Merge trivial.
- Economia: 1 process spawn por TODA tool call.

### 2.5 Stop: 7 → 2-3 scripts
Merge por funcao:
- `stop-hygiene.sh` + `stop-detect-issues.sh` + `stop-crossref-check.sh` → `stop-quality.sh`
- `stop-scorecard.sh` + `stop-chaos-report.sh` → `stop-metrics.sh`
- `stop-should-dream.sh` + `stop-notify.sh` permanece separado (escopo diferente)

## Fase 3 — Arquitetura (futuro)

### 3.1 Hook profiles (env var)
```bash
# No hook script:
PROFILE="${OLMO_HOOK_PROFILE:-standard}"
case "$PROFILE" in
  minimal) # so guards de seguranca ;;
  standard) # guards + momentum + cost ;;
  strict) # tudo incluindo nudges, chaos, coupling ;;
esac
```

### 3.2 Novos eventos (substituem hacks)
| Evento novo | Substitui | Beneficio |
|-------------|-----------|-----------|
| `StopFailure` | model-fallback-advisory.sh (PostToolUse hack) | Evento dedicado para erros API |
| `SubagentStart/Stop` | nudge-checkpoint.sh (breadcrumb hack) | Contagem nativa de subagents |
| `PermissionRequest` | momentum-brake-enforce (PreToolUse `.*` hack) | Decisao no ponto certo do lifecycle |
| `FileChanged` | coupling-proactive.sh (timestamp comparison hack) | Watch nativo de arquivos |

### 3.3 Handler types
| Tipo | Uso potencial |
|------|--------------|
| `type: "prompt"` (Haiku) | Decisoes de julgamento que hoje sao heuristicas bash |
| `type: "agent"` | Verificacao complexa pre-commit |
| `type: "http"` | Telemetria/audit para servico externo |

## Impacto estimado

### Performance (Fase 1 apenas)
| Tool call | Antes | Depois Fase 1 | Reducao |
|-----------|-------|---------------|---------|
| Bash (ls, cat) | 9 hooks, ~6 node, ~800ms | 5 hooks, 1 node, ~200ms | **~75%** |
| Bash (git commit) | 9 hooks, ~6 node, ~800ms | 9 hooks, 2 node+jq, ~350ms | **~55%** |
| Edit | 8 hooks, ~7 node, ~900ms | 8 hooks, 1 jq, ~200ms | **~78%** |
| Read | 4 hooks, ~1 node, ~300ms | 4 hooks, 0 node, ~100ms | **~67%** |

### Performance (Fase 1 + 2)
| Tool call | Antes | Depois Fase 1+2 | Reducao |
|-----------|-------|-----------------|---------|
| Bash (ls, cat) | 9 hooks, ~800ms | 3 hooks, ~80ms | **~90%** |
| Edit | 8 hooks, ~900ms | 4 hooks, ~100ms | **~89%** |

### File count
| Metrica | Antes | Fase 1 | Fase 1+2 |
|---------|-------|--------|----------|
| Hook scripts | 40 | 39 (-1 dead) | ~22 |
| Registrations | 38 | 38 | ~24 |
| Node.js spawns/edit | 7-8 | 1-2 | 0-1 |

## Arquivos criticos

### Fase 1 — editar:
- `.claude/settings.local.json` — adicionar campos `if`
- `.claude/hooks/momentum-brake-enforce.sh` — node → jq
- `.claude/hooks/guard-bash-write.sh` — node → jq + Pattern 7 fix
- `.claude/hooks/guard-read-secrets.sh` — node → jq
- `.claude/hooks/guard-generated.sh` — node → jq
- `.claude/hooks/guard-product-files.sh` — node → jq
- `.claude/hooks/coupling-proactive.sh` — node → jq
- `hooks/stop-detect-issues.sh` — dedup fix
- `hooks/session-start.sh` — orphan rename fix
- `hooks/stop-should-dream.sh` — portability fix

### Fase 1 — deletar:
- `.claude/hooks/guard-pause.sh` — dead code

## Verificacao

### Pre-implementacao
- [ ] `jq --version` confirma >= 1.6
- [ ] `claude --version` confirma >= 2.1.85

### Pos-implementacao (cada hook editado)
```bash
# Teste unitario: pipe JSON de exemplo para o hook
echo '{"tool_name":"Bash","tool_input":{"command":"ls"}}' | bash .claude/hooks/momentum-brake-enforce.sh
echo $?  # deve ser 0

echo '{"tool_name":"Edit","tool_input":{"file_path":"content/aulas/metanalise/index.html"}}' | bash .claude/hooks/guard-generated.sh
echo $?  # deve ser 2 (bloqueado)
```

### Benchmark de performance
```bash
# Antes vs depois: medir overhead de 1 hook
time (echo '{"tool_name":"Bash","tool_input":{"command":"ls"}}' | bash .claude/hooks/momentum-brake-enforce.sh)
```

### Integracao
- Build PASS apos todas as mudancas
- Testar: Edit de slide HTML (guard-product-files deve pedir ask)
- Testar: Bash `git commit` (guard-secrets deve bloquear se .env staged)
- Testar: Bash `ls` (deve ser rapido, sem hooks desnecessarios)

## Riscos e mitigacoes

| Risco | Mitigacao |
|-------|-----------|
| jq behavior differs from node parser | Testar cada hook com JSON de exemplo antes e depois |
| `if` field pattern nao matcha como esperado | Testar com `/hooks` browser apos configurar |
| guard-product-files path normalization quebra com jq | `gsub("\\\\"; "/")` no jq equivale a `.replace(/\\\\/g, '/')` |
| Regressao em guard-worker-write (4 node spawns complexos) | Manter node para timestamp validation (Fase 2 consolida) |
| Consolidacao Fase 2 introduce bugs em merges | Cada merge como commit separado, testado individualmente |

## Decisao pendente Lucas

1. **Fase 1 scope**: implementar tudo listado ou priorizar subconjunto?
2. **guard-pause.sh**: deletar ou arquivar?
3. **guard-worker-write.sh** (4 node spawns): migrar para jq agora (risco alto, logica complexa) ou deixar para Fase 2 consolidacao?
4. **model-fallback-advisory.sh**: manter como PostToolUse ou migrar para StopFailure event (Fase 3)?
