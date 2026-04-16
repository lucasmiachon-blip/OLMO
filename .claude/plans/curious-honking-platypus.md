# S214: Self-Improvement Loop Step 2 ✅

> /dream consome hook-log.jsonl → reflexao sobre dados reais de hooks
> **Status:** Tarefas 1-2 executadas. Tarefa 3 pendente (manual, Lucas).

## Context

Step 1 (S213) criou infraestrutura de logging: `hook-log.jsonl` + `hook_log()` utility + 3 hooks produtores.
Step 2 fecha o gap: /dream le esses dados e identifica padroes recorrentes como candidatos a KBP.
Convergencia validada: data-first → reflect → propose → act (Reflexion, Auto MoC, SICA, Addy Osmani).

## Plano (3 tarefas)

### Tarefa 1: /dream Phase 2 — Sub-step 5: Hook Log Analysis

**Arquivo:** `C:/Users/lucas/.claude/skills/dream/SKILL.md`
**Local:** Inserir apos linha 160 ("Report all repetitions..."), antes de `---` que abre Phase 3.

**Adicionar:**

```markdown
### Sub-step 5: Hook Log Analysis

**Goal:** Surface recurring hook-detected problems as KBP candidates.

1. **Locate hook log:**
   - Path: `$CLAUDE_PROJECT_DIR/.claude/hook-log.jsonl` (fallback: detect project root from memory paths in Phase 1)
   - If file absent or empty → skip sub-step, note "(Hook log absent — sub-step 5 skipped)"

2. **Log rotation (if >500 lines):**
   - Archive oldest lines to `.claude/hook-log-archive/hook-log-YYYY-MM-DD.jsonl`
   - Keep newest 500 in active file
   - Note: "Hook log rotated: archived {N} lines"

3. **Aggregate:**
   - Group by compound key `category:pattern`
   - Track per group: count, first_ts, last_ts, max severity (error > warn > info)
   - Ignore entries where `event` = `"test"` (smoke tests)

4. **Cross-reference against KBPs:**
   - Read `.claude/rules/known-bad-patterns.md`
   - For each aggregated pattern, check if any KBP name contains it (case-insensitive)
   - Status: `KNOWN (KBP-NN)` | `CANDIDATE` (count >= 3) | `(sub-threshold)` (count < 3)
   - If KNOWN but still firing → note "rule exists but pattern recurring (recurrence signal)"

5. **Report:**

| pattern | category | count | first seen | last seen | severity | status |
|---------|----------|-------|------------|-----------|----------|--------|
| slide-without-manifest | cross-ref | 4 | 2026-04-10 | 2026-04-16 | warn | CANDIDATE |

If no patterns >= 3: "(No patterns with 3+ occurrences yet — {N} total entries)"

KBP candidates require `/insights` to escalate. Do NOT write to known-bad-patterns.md from /dream.
```

**Racional:** Fase 2 extrai sinal. Sub-steps 1-4 extraem de transcripts (linguagem humana). Sub-step 5 extrai de hook-log (dados estruturados de maquina). Aditivo — nao mexe na logica existente.

### Tarefa 2: Agent Hook no Stop (artifact verification)

**Arquivo:** `C:/Dev/Projetos/OLMO/.claude/settings.local.json`
**Local:** Stop hooks array, inserir APOS o prompt hook (posicao [1], empurrando os demais).

**Adicionar:**

```json
{
  "hooks": [
    {
      "type": "agent",
      "prompt": "Check session artifact hygiene. Run these commands:\n1. git -C \"$CLAUDE_PROJECT_DIR\" diff --name-only HEAD -- HANDOFF.md CHANGELOG.md\n2. git -C \"$CLAUDE_PROJECT_DIR\" log --oneline -1 -- HANDOFF.md CHANGELOG.md\nIf NEITHER command shows modifications to HANDOFF.md or CHANGELOG.md, respond: {\"ok\": false, \"reason\": \"Session ended without updating HANDOFF.md or CHANGELOG.md\"}.\nOtherwise respond: {\"ok\": true}.",
      "timeout": 60
    }
  ]
}
```

**Racional:**
- Prompt hook (existente) = anti-racionalizacao semantica (rapido, cego, Haiku)
- Agent hook (novo) = verificacao grounded de artefatos (le git diff real)
- Complementares: prompt pega "eu decidi nao fazer", agent pega "nao atualizou HANDOFF"
- Custo: $0 no Max, +30-60s no close
- Se disruptivo: pode virar `async: true` (perde blocking, ganha velocidade)

### Tarefa 3: Verificacao Auto Dream

**Acao manual (Lucas):** Rodar `/memory` no Claude Code e reportar se Auto Dream nativo aparece.

**Se disponivel:**
- `autoMemoryEnabled` pode mudar para `true`
- `.dream-pending` flag system fica redundante
- Simplificar `session-end.sh` e `session-start.sh`

**Se indisponivel:** Nenhuma mudanca. Sistema custom continua.

## Arquivos criticos

| Arquivo | Acao |
|---------|------|
| `~/.claude/skills/dream/SKILL.md` | EDIT — adicionar Sub-step 5 na Phase 2 |
| `.claude/settings.local.json` | EDIT — adicionar agent hook no Stop |
| `.claude/hook-log.jsonl` | READ-ONLY — validar schema |
| `.claude/rules/known-bad-patterns.md` | READ-ONLY — cross-ref target |
| `hooks/lib/hook-log.sh` | READ-ONLY — referencia de schema |
| `HANDOFF.md` | UPDATE — estado da sessao |
| `CHANGELOG.md` | APPEND — registro de mudancas |

## Verificacao

1. **Tarefa 1:** Rodar `/dream` e confirmar que Phase 2 output inclui secao "Hook Log Analysis". Com 3 entries no log, esperar "(No patterns with 3+ occurrences yet)".
2. **Tarefa 1 stress:** Manualmente adicionar 3+ entries identicas ao hook-log.jsonl, re-rodar /dream, confirmar tabela com CANDIDATE.
3. **Tarefa 2:** Encerrar sessao SEM editar HANDOFF/CHANGELOG → agent hook deve bloquear. Encerrar COM edits → deve passar.
4. **Tarefa 3:** Lucas roda `/memory` e reporta.

## Sequencia

1. ~~Tarefa 1 primeiro (core do Step 2)~~ ✅
2. ~~Tarefa 2 segundo (independente, incremental)~~ ✅
3. Tarefa 3 manual (Lucas decide timing) — PENDENTE
4. ~~Atualizar HANDOFF.md + CHANGELOG.md~~ ✅
5. Commit

## Filosofia

> "Prefiro over-engineering que ajustamos aos poucos do que erros invisiveis." — Lucas, S214

Infraestrutura que nao dispara ainda = pronta para quando precisar.
Erro que ninguem mede = divida tecnica invisivel que so cresce.

- **Agent hook latency:** +30-60s no close. Mitigacao: `async: true` se necessario. Mas blocking e o default — melhor freiar do que ignorar.
- **Log rotation:** Inerte ate 500 linhas. Custo zero. Previne o problema antes de existir.
