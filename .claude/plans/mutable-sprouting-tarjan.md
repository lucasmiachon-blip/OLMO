# Plan: mutable-sprouting-tarjan — S230 Continuation (Batches 3+4 close)

> **Session:** 230 (`bubbly-forging-cat` continua)
> **Origin:** `bubbly-forging-cat.md` Batches 3+4 (Batches 1-2 já commitados em `46ae0ce` + `104cdbd`)
> **Date:** 2026-04-19
> **Branch:** main

---

## Context

Sessão anterior parou a meio do **Batch 4** com 2 mudanças no working tree:
- `ACTIVE-S225-SHIP-roadmap.md` renomeado para `archive/` (item 1) — pendente commit
- `ACTIVE-S227-memory-to-living-html.md` header `S226` → `S227+` + status atualizado (item 2) — pendente commit

Lucas confirmou que a "incorporação skill→rule" (na verdade `metanalise/CLAUDE.md §QA Pipeline` → `qa-pipeline.md`) foi feita em **Batch 2 sem perda de dados** — verifiquei diff: state machine, 4 gates, sequência Lucas OK, threshold score<7 — tudo migrou (e expandiu, com Lucas OK em bold entre cada gate).

Decisão pendente já tomada: **Batch 3 ModelRouter = B (delete)**, com ressalva: preservar a granularidade do mapping 4-tier (trivial→Ollama, simple→Haiku, medium→Sonnet, complex→Opus) como **diretiva humana em CLAUDE.md**, mesmo após delete do código teatro.

Diretiva geral do Lucas (esta sessão): **"sempre que fizer (deletar/mover/renomear/arquivar), remova o ruído associado"**. Aplicado a este plano: cada operação estrutural lista explicitamente seus cleanup-ops.

**Outcome desta sessão:**
- Plans ACTIVE alinhados com realidade (Batch 4 fechado).
- Runtime Python sem código órfão (~520 li removidas).
- ModelRouter teatro substituído por intent-only doc em CLAUDE.md.
- BACKLOG #42 RESOLVED.
- `settings.local.json` slim (5 entries → 1).
- `ecosystem.yaml` scope-clarified.
- Zero refs órfãs em `docs/TREE.md`, `docs/GETTING_STARTED.md`.

**Out of scope (defer):** Batches 5 (multimodel gate) e 6 (Living-HTML migration BACKLOG #36).

---

## Phase A — Close Batch 4 (working tree commit) [~5 min, LOW risk]

Working tree já tem 2 mudanças prontas. Apenas commit.

**Commit message proposed:**
```
S230 Batch 4: plans audit (S225 archive + S227 header refresh)

- ACTIVE-S225-SHIP-roadmap.md → archive/ (S229 executou daily-exodus, não roadmap original)
- ACTIVE-S227 header S226 → S227+ + status: "não executado S227-S229; ainda ACTIVE per HANDOFF / BACKLOG #36"

Plan: .claude/plans/bubbly-forging-cat.md Batch 4 + mutable-sprouting-tarjan.md Phase A.

Coautoria: Lucas + Opus 4.7
```

**Verification:**
```bash
git status --short  # → empty
ls .claude/plans/ACTIVE-*.md  # → only ACTIVE-S227
ls .claude/plans/archive/S225-SHIP-roadmap.md  # → exists
```

**Cleanup de ruído:** `HANDOFF.md` referencia "S225-SHIP" no Plans block — atualizar pós-commit (Phase E).

---

## Phase B — Batch 3a: Low-risk warm-up (settings + ecosystem) [~15 min, LOW risk]

Mudanças isoladas em config files. Sem touch em código.

### B.1 — `settings.local.json` cleanup (5 entries → 1)

Atual:
```json
{
  "permissions": {
    "allow": [
      "Bash(bash tools/integrity.sh)",   // KEEP — não coberto por settings.json
      "Agent",                            // DELETE — duplica settings.json:26
      "Bash(mv .claude/plans/ACTIVE-S226-purga-cowork-plan.md ...)",  // DELETE — stale S226
      "Bash(git add *)",                  // DELETE — coberto por Bash(*)
      "Bash(git commit -m ' *)"           // DELETE — coberto por Bash(*)
    ]
  }
}
```

Resultado:
```json
{
  "permissions": {
    "allow": [
      "Bash(bash tools/integrity.sh)"
    ]
  }
}
```

**Verificação prévia:** confirmar `Bash(*)` em `settings.json` cobre git add/commit. Se cobrir, delete safe. Se não, manter as 2 git lines.

### B.2 — `config/ecosystem.yaml` scope clarification

Linha 35 atual: `# Skills (.claude/skills/ — 9 ativas)` (mentira: filesystem tem 18).

Substituir comment por header de escopo explícito:
```yaml
# Skills (Python-runtime visible — 9 declaradas)
# Nota: .claude/skills/ filesystem tem 18 skills total. As 9 declaradas aqui são
# as expostas ao runtime Python (orchestrator + agentes). CC-only skills
# (sentinel, systematic-debugger, brainstorming, evidence-audit, improve,
# insights, knowledge-ingest, nlm-skill, backlog) vivem por filesystem
# convention e não precisam declaração explícita aqui.
skills:
```

**Cleanup de ruído associado:** nenhum (apenas comment). Sem refs externas a "9 ativas".

**Verification:**
```bash
wc -l .claude/settings.local.json  # ≤ 7 lines
grep "9 ativas" config/ecosystem.yaml  # 0 matches
```

**Commit message:**
```
S230 Batch 3a: settings.local.json slim + ecosystem.yaml scope clarified

- settings.local.json 5 entries → 1 (kept tools/integrity.sh; deleted Agent dup, S226 stale mv, git add/commit redundantes com settings.json Bash(*))
- ecosystem.yaml: comment "9 ativas" → header explícito declarando que ecosystem.yaml lista skills Python-runtime visible; CC-only skills vivem por filesystem convention

Plan: mutable-sprouting-tarjan.md Phase B.

Coautoria: Lucas + Opus 4.7
```

---

## Phase C — Batch 3b: SmartScheduler + skills/efficiency cascade delete [~15 min, MEDIUM risk]

**Cascata identificada:** `agents/core/smart_scheduler.py` é o único consumer de `skills/efficiency/local_first.py`. Ambos órfãos = pasta `skills/` inteira sai.

### C.1 — Delete files

```bash
git rm agents/core/smart_scheduler.py        # 309 li
git rm -r skills/                             # __init__.py + efficiency/local_first.py + efficiency/__init__.py
```

### C.2 — Cleanup de ruído (refs órfãs)

| Arquivo | Linha | Operação |
|---|---|---|
| `docs/TREE.md` | :75 | DELETE line `smart_scheduler.py # Schedule management` |
| `docs/TREE.md` | (verificar) | DELETE entries de `skills/` root se existirem |
| `docs/GETTING_STARTED.md` | :90 | DELETE line `efficiency/ # local_first (custo zero)` (e linhas adjacentes da árvore se órfãs) |

**Refs em docs históricos:** `CHANGELOG-archive.md`, `bubbly-forging-cat.md` (este plano antecessor), archive plans — **KEEP** (são histórico).

### C.3 — Verificação imports zerados

```bash
ruff check .
mypy agents/
python -c "from orchestrator import build_ecosystem; e = build_ecosystem(); print(list(e.agents.keys()))"
# → ['automacao']
pytest tests/
# → all green
test ! -d skills/
test ! -f agents/core/smart_scheduler.py
```

**Commit message:**
```
S230 Batch 3b: delete SmartScheduler + skills/ orphan cascade

- agents/core/smart_scheduler.py (309 li, 0 imports em produção desde S?)
- skills/ root pasta inteira (LocalFirstSkill era consumed apenas por SmartScheduler)
- docs/TREE.md: refs órfãs removidas
- docs/GETTING_STARTED.md: tree-block efficiency/ removido

Total: ~520 li deletadas. Zero comportamento perdido (nada disso era invocado em runtime atual).

Plan: mutable-sprouting-tarjan.md Phase C.

Coautoria: Lucas + Opus 4.7
```

---

## Phase D — Batch 3c: ModelRouter delete (BACKLOG #42 RESOLVED) [~25 min, MEDIUM risk]

**Decisão Lucas: B (delete)** com ressalva: preservar mapping 4-tier como **diretiva humana em CLAUDE.md** (não deletar a frase `Model routing: trivial→Ollama($0) | simple→Haiku | medium→Sonnet | complex→Opus`).

### D.1 — Delete files

```bash
git rm agents/core/model_router.py          # 55 li
git rm tests/test_core/test_model_router.py # 13 testes
```

### D.2 — Edit `agents/core/orchestrator.py`

Linha 11: `from agents.core.model_router import ModelRouter` → DELETE
Linha 34: `self.model_router = ModelRouter(agents_config)` → DELETE
Linha 26: `def __init__(self, agents_config: ...)` → manter signature (test compat) mas não usar `agents_config` para router (pode passar para outra coisa futuro ou virar `_: dict | None = None`)
Linhas 76-79: simplificar:
```python
# antes:
agent = self.agents[agent_name]
resolved_model = self.model_router.resolve(agent_name, task)
task_with_model = {**task, "_resolved_model": resolved_model}
return await agent.execute(task_with_model)

# depois:
return await self.agents[agent_name].execute(task)
```

### D.3 — Edit `agents/core/__init__.py`

```python
# antes:
"""Core agents - Base classes, orquestrador e model routing."""

from agents.core.base_agent import BaseAgent
from agents.core.model_router import ModelRouter
from agents.core.orchestrator import Orchestrator

__all__ = ["BaseAgent", "ModelRouter", "Orchestrator"]

# depois:
"""Core agents - Base classes e orquestrador."""

from agents.core.base_agent import BaseAgent
from agents.core.orchestrator import Orchestrator

__all__ = ["BaseAgent", "Orchestrator"]
```

### D.4 — Cleanup de ruído (refs órfãs)

| Arquivo | Linha | Operação |
|---|---|---|
| `docs/TREE.md` | :72 | DELETE line `model_router.py # Cost-based routing (WARN: ...)` |
| `.claude/BACKLOG.md` | :68 (item #42) | EDIT: mark RESOLVED + reference S230 (`✅ S230 Batch 3c: deleted; routing intent preservada como diretiva humana em CLAUDE.md`) |
| `HANDOFF.md` | :17 | EDIT: "BACKLOG #42-45" → "BACKLOG #43-45" (#42 resolved) + ajustar prosa |

**CLAUDE.md preservation check:** linha 60 atual: `Model routing: trivial→Ollama($0) | simple→Haiku | medium→Sonnet | complex→Opus`. **MANTER intacta.** Esta é a diretiva humana — agora desacoplada honestamente do código.

**Refs em docs históricos:** `CHANGELOG-archive.md`, `S228-groovy-launching-steele.md` archive — **KEEP** (histórico).

### D.5 — Verificação

```bash
grep -rn "model_router\|ModelRouter\|_resolved_model" agents/ tests/
# → 0 matches

ruff check .
mypy agents/
python -c "from orchestrator import build_ecosystem; e = build_ecosystem(); print(list(e.agents.keys()))"
# → ['automacao']
pytest tests/
# → all green (test_model_router deleted, others pass)
```

**Commit message:**
```
S230 Batch 3c: delete ModelRouter teatro (BACKLOG #42 RESOLVED)

- agents/core/model_router.py (55 li, _resolved_model escrito mas nunca lido)
- tests/test_core/test_model_router.py (13 testes obsoletos)
- agents/core/orchestrator.py: import + instantiation + uso em route_task removidos
- agents/core/__init__.py: ModelRouter export removido
- docs/TREE.md: ref WARN removida
- BACKLOG #42 RESOLVED
- HANDOFF.md: P2 list atualizada (#43-45 remain)

Routing intent (trivial→Ollama, simple→Haiku, medium→Sonnet, complex→Opus) PRESERVADA
em CLAUDE.md como diretiva humana — agora honestamente desacoplada do enforcement
automático que nunca existiu.

Total: ~75 li código + 13 testes deletados.

Plan: mutable-sprouting-tarjan.md Phase D.

Coautoria: Lucas + Opus 4.7
```

---

## Phase E — Session close: HANDOFF + CHANGELOG sync [~10 min, LOW risk]

### E.1 — `HANDOFF.md` updates

Mudanças:
- Remover S229 hydration block (S230 já hidrata por si)
- Substituir Priority List item 0 (BACKLOG #46) — ainda P1, manter
- Marcar bubbly-forging-cat completion: Batches 1-4 done, 5-6 deferred
- Atualizar P2 list: #42 RESOLVED, restam #43-45
- Update plans block: ACTIVE-S227 only (S225 archived)

### E.2 — `CHANGELOG.md` entries (S230)

Append (≤5 linhas):
```
## S230 — bubbly-forging-cat (2026-04-19)
- Adversarial audit + simplification: doc/reality reconciliation, memory de-dup, runtime surface reduction
- Batches 1-4: ~520 li órfãs deletadas (SmartScheduler + skills/efficiency + ModelRouter); plans audit; ecosystem.yaml scope; settings.local.json slim
- BACKLOG #42 RESOLVED. KBP count: 27 (no new). Hooks: 31/31 valid (unchanged)
- Batches 5 (multimodel gate) + 6 (Living-HTML BACKLOG #36) DEFERRED para S231+
- Aprendizado: cascata de delete (A consumer único de B → ambos órfãos); código teatro pode ser deletado preservando intenção em doc
```

### E.3 — Archive `bubbly-forging-cat.md`

```bash
git mv .claude/plans/bubbly-forging-cat.md .claude/plans/archive/S230-bubbly-forging-cat.md
git mv .claude/plans/mutable-sprouting-tarjan.md .claude/plans/archive/S230-mutable-sprouting-tarjan-execution.md
```

**Commit message (final):**
```
S230 close: bubbly-forging-cat — 4 batches complete (5+6 deferred)

- HANDOFF.md: S229 hydration removed, S230 state, P2 #42 RESOLVED
- CHANGELOG.md: S230 entry
- bubbly-forging-cat.md → archive/S230-bubbly-forging-cat.md
- mutable-sprouting-tarjan.md → archive (execution log)

Net S230: doc/reality reconciliation (Batch 1) + memory de-dup (Batch 2) +
runtime surface reduction ~520 li (Batch 3) + plans audit (Batch 4).
Batches 5 (multimodel) + 6 (Living-HTML BACKLOG #36) deferred.

Coautoria: Lucas + Opus 4.7
```

---

## Critical Files

**To be modified:**
- `.claude/settings.local.json` (slim 5→1 entry)
- `config/ecosystem.yaml` (linha 35 comment)
- `agents/core/orchestrator.py` (linhas 11, 34, 76-79)
- `agents/core/__init__.py` (remove ModelRouter export)
- `docs/TREE.md` (linhas 72, 75 — model_router + smart_scheduler entries)
- `docs/GETTING_STARTED.md` (linha 90 — efficiency/ tree)
- `.claude/BACKLOG.md` (linha 68 — #42 RESOLVED)
- `HANDOFF.md` (P2 list + plans block)
- `CHANGELOG.md` (S230 entry)

**To be deleted:**
- `agents/core/smart_scheduler.py` (309 li)
- `agents/core/model_router.py` (55 li)
- `tests/test_core/test_model_router.py` (13 testes)
- `skills/` (root pasta inteira: `__init__.py` + `efficiency/__init__.py` + `efficiency/local_first.py`)

**To be archived (Phase E):**
- `.claude/plans/bubbly-forging-cat.md` → `archive/S230-bubbly-forging-cat.md`
- `.claude/plans/mutable-sprouting-tarjan.md` → `archive/S230-mutable-sprouting-tarjan-execution.md`

**Untouched (preservation):**
- `CLAUDE.md` — linha 60 mapping 4-tier MANTIDA (diretiva humana)
- `agents/core/database.py` — KEEP (consumer real: `mcp_safety.py`)
- `docs/CHANGELOG-archive.md`, archive plans — KEEP (histórico)

---

## Verification (end-to-end)

Após Phase D commit:
```bash
# Imports limpos
grep -rn "model_router\|ModelRouter\|_resolved_model\|smart_scheduler\|SmartScheduler\|local_first\|LocalFirstSkill" agents/ skills/ tests/ docs/TREE.md docs/GETTING_STARTED.md
# Expected: 0 matches (refs históricas em docs/CHANGELOG-archive.md OK)

# Filesystem
test ! -d skills/
test ! -f agents/core/smart_scheduler.py
test ! -f agents/core/model_router.py
test ! -f tests/test_core/test_model_router.py

# Runtime
ruff check .
mypy agents/
pytest tests/
python -c "from orchestrator import build_ecosystem; e = build_ecosystem(); print(list(e.agents.keys()))"
# Expected: ['automacao']

# Settings
wc -l .claude/settings.local.json  # ≤ 7

# Plans state
ls .claude/plans/ACTIVE-*.md  # → only ACTIVE-S227
ls .claude/plans/archive/S230-*.md  # → 2 files
```

---

## Commit Granularity

5 commits, ordem fixa:
1. **Phase A** — Batch 4 close (working tree)
2. **Phase B** — Batch 3a settings + ecosystem
3. **Phase C** — Batch 3b SmartScheduler + skills/ cascade
4. **Phase D** — Batch 3c ModelRouter (BACKLOG #42 RESOLVED)
5. **Phase E** — S230 close + plans archive

Cada commit independentemente revertível. Phase D > C > B em dependência conceitual; nenhum bloqueia o seguinte (delete ordering é commutativa).

---

## Risk Map

| Phase | Risk | Mitigation |
|---|---|---|
| A | LOW | Working tree já validado em S229/S230 anterior. |
| B | LOW | Apenas config — sem código tocado. Verify settings.json `Bash(*)` antes do delete. |
| C | MEDIUM | Cascata de delete. Mitigation: imports já confirmados zero (Phase 1 grep), pytest verifica. |
| D | MEDIUM | Toca orchestrator (entry point). Mitigation: ruff + mypy + pytest + sanity build_ecosystem. |
| E | LOW | State files. Edit (não Write) per anti-drift §State files. |

---

## Defensible Skips

- **Não toco `database.py`**: tem consumer real (`mcp_safety.py`). KEEP confirmado em Phase 1.
- **Não removo `Model routing:` line de CLAUDE.md**: é diretiva humana, sobrevive ao delete do código teatro.
- **Não executo Batch 5 (multimodel gate)**: deferred até S231+ — exige decisão de produto (Codex formalization, ChatGPT/Antigravity gate).
- **Não executo Batch 6 (Living-HTML BACKLOG #36)**: requires Phase F+ na próxima sessão; toca agent behavior + per-slide content.
- **Não toco skill triggers fracos** (`continuous-learning`, `teaching` com triggers genéricos): identificado em bubbly-forging-cat §Findings 7 mas requer decisão de produto. Defer.
- **Não auditô `slide-rules.md` vs `design-reference.md` overlap**: Batch 2 item 6 explicitamente parking até evidência de overlap real.

---

## Coautoria

Cada commit: `Coautoria: Lucas + Opus 4.7` no body + `Co-authored-by: Opus 4.7 <noreply@anthropic.com>`.
