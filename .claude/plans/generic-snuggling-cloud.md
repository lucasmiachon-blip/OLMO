# S232-S233 — Adversarial Consolidation Audit (v6 final)

> Status: v6 — AUDIT-FIRST per Lucas's adversarial consolidator prompt.
> Additions rule: **no net-new artifacts unless required to repair a canonical broken path** (e.g., scripts/ files to unblock research skill Pernas 1+5).
> Sessões: S232 remaining (~2h) + S233 (~2h) | Slides retomam: S234
> Tese: complexidade líquida DIMINUI. Menos artefatos ativos no fim que no começo.

---

## Oscilação v1→v6 (postmortem)

| v | Framing | Rejected because |
|---|---------|-------------------|
| v1 | SOA cosplay aggressive | Cargo cult Reflexion/memory-audit |
| v2 | Codex pivot storage-first | OK but missing SOA |
| v3 | Gemini aggressive (MCP + Native SO) | Ambicioso demais 2d |
| v4 | Pure org cleanup | Yak-shaving |
| v5 | Org minimal + 1 SOA pilot (harness) | **Still adds** (violates "não proponha mais skills") |
| **v6** | **Audit + remove/merge/archive** | **Honors Lucas's prompt** |

Padrão: cada pivot seguinte corrigia ambição anterior sem atacar a raiz. v6 começa com evidência empírica.

---

## BATCH 0 — AUDIT (completed 2026-04-19)

3 parallel Explore agents verified 8 hypotheses. Findings tabela:

### P0 (critical)

| # | File | Line | Problem | Action |
|---|------|------|---------|--------|
| 1 | `config/workflows.yaml` | all 3 | 3 workflows (`weekly_deep_review`, `smart_query`, `code_review`) declared e registered mas `route_task` só handler `automate`/`monitor`. **All unreachable at runtime.** Comment L98-107 admits "Nao reviver stubs" | **DELETE** workflows.yaml + downstream cleanup |
| 2 | `.claude/skills/research/SKILL.md` | 117-169 | Perna 1 Gemini + Perna 5 Perplexity exigem `node -e "..."` mas `.claude/settings.json:102` tem `Bash(node -e *)` em deny. **Research skill não-executável since S227 KBP-26.** | **MERGE** — replace com script file pattern (.claude/scripts/*.mjs) |
| 3 | `config/ecosystem.yaml` | 95-96 | `provider: openai` + `model: chatgpt-5.4` — `chatgpt-5.4` **não existe como OpenAI API model ID**. Config falha programaticamente | **MERGE** — fix to real API ID ou mark aspirational |
| 4 | `config/rate_limits.yaml` | 63, 69, 114 | `alternatives: ["chatgpt-5.4"]` — fabricated ID em routing fallback | **MERGE** — fix same |
| 5 | `scripts/atualizar_tema.py` | 2, 46, 249 | Docstring: "Atualiza tema/tópico: **Obsidian + Notion**". `.write_text()` producer calls. **Viola ADR-0002 (OLMO consumer-only).** | **ARCHIVE/MOVE** to OLMO_COWORK |
| 6 | `scripts/workflow_cirrose_ascite.py` | 2-7, 162, 175 | Docstring: "Zotero → **Notion + Obsidian**". 3 writes producer-side | **ARCHIVE/MOVE** to OLMO_COWORK |

### P1 (significant)

| # | File | Line | Problem | Action |
|---|------|------|---------|--------|
| 7 | `config/ecosystem.yaml` | 43-44 | `mbe-evidence: path: ".claude/skills/mbe-evidence"` — skill directory **deleted per CHANGELOG** but entry persists | **DELETE** entry |
| 8 | `.claude/skills/automation/SKILL.md` | 22 | `command: "claude --skill mbe-evidence"` — phantom skill reference in cron | **DELETE** line ou update to real skill |
| 9 | `.claude/skills/teaching/SKILL.md` | 59 | "ver skill mbe-evidence" cross-ref to deleted skill | **DELETE/FIX** cross-ref |
| 10 | `.claude/agents/sentinel.md` | 38 | Checks `settings.local.json` for hook registration — **wrong file**. Hook registry canonical = `settings.json:108+` | **MERGE** — update to settings.json |
| 11 | `.claude/agents/systematic-debugger.md` | 92 | Same mismatch: "Erro em hook/guard: verificar `settings.local.json`" | **MERGE** — fix to settings.json |
| 12 | `CLAUDE.md` | ~38 | `ChatGPT=VALIDAR` slot. ADR-0003 §6 says DEFLATE (redundant with Codex). **CLAUDE.md não foi atualizado** | **DELETE/DEFLATE** slot |
| 13 | `docs/adr/0003-multimodel-orchestration.md` | 35 | `Codex (GPT-5.4)` routes via `ChatGPT Plus (incluso)` — conflates plugin UX + model ID. `GPT-5.4` not official | **DEMOTE-AS-ASPIRATIONAL** — add caveat |

### P2 (minor)

| # | File | Line | Problem | Action |
|---|------|------|---------|--------|
| 14 | `agents/core/base_agent.py` | 27 | `shared_memory: dict[str, Any]` — 0 usages outside declaration | **DELETE** field |
| 15 | `.claude/settings.local.json` | all | 17 li stale `chmod +x` / `rm` entries accumulated | **DELETE** stale; keep structural |
| 16 | `docs/adr/0003-multimodel-orchestration.md` | 10 | "Antigravity" é decisão histórica (mentioned em CHANGELOG S226 como candidate tool). Atual ADR phrasing pode ler como runtime claim. | **DEMOTE-AS-ASPIRATIONAL** — rephrase para "historical/deferred candidate" com pointer para CHANGELOG; NÃO apagar do passado |

### Removed from findings (false positive)
- ~~#17 `hooks/stop-quality.sh`~~ — Explore agent misclassified. stop-quality.sh DOES run real quality checks; exit=0 is intentional advisory pattern. **NO ACTION.**

---

## TOPOLOGIA CANÔNICA PROPOSTA

Single source of truth per concern (kill competing):

| Concern | Canonical | Kill (merge into canonical) |
|---------|-----------|------------------------------|
| Architecture | `docs/ARCHITECTURE.md` | TREE.md becomes pointer-only |
| Per-agent memory | `.claude/agent-memory/{agent}/` | `shared_memory` field deleted |
| Multimodel roles | `docs/adr/0003-multimodel-orchestration.md` (fixed) | `CLAUDE.md §Tool Assignment` deflated per ADR-0003 |
| Active plans | `.claude/plans/*.md` (max 2) | Archive everything else |
| Handoff | `HANDOFF.md` (future-only) | No competing status files |
| Hook registry | `.claude/settings.json:hooks[]` | `.claude/settings.local.json` = user overrides ONLY |
| Agent definitions | `.claude/agents/*.md` | No Python agent ABC registry |
| Runtime | `orchestrator.py` CLI (1 agent + 1 subagent) | `workflows.yaml` deleted (aspirational) |

---

## BATCH 1 — SUBSTRATE CLEANUP (~45min S232)

**Objetivo:** remover surfaces fantasmas + producer-side contamination.

**Arquivos tocados:**
1. Delete `config/ecosystem.yaml:43-44` (mbe-evidence entry — finding #7)
2. Edit `.claude/skills/automation/SKILL.md:22` (remove mbe-evidence cron — finding #8)
3. Edit `.claude/skills/teaching/SKILL.md:59` (delete mbe-evidence cross-ref — finding #9)
4. Delete `agents/core/base_agent.py:27` (shared_memory field — finding #14)
5. Rephrase `docs/adr/0003-multimodel-orchestration.md:10` Antigravity → "historical/deferred candidate per CHANGELOG S226" pointer (finding #16)
6. `git mv scripts/atualizar_tema.py` → archive/ or delete (finding #5)
7. `git mv scripts/workflow_cirrose_ascite.py` → archive/ or delete (finding #6)
8. Delete stale chmod/rm entries in `.claude/settings.local.json` (finding #15)

**Critério de pronto:**
- `grep -r "mbe-evidence" config/ .claude/skills/` → 0 matches
- `grep -r "shared_memory" agents/ subagents/` → 0 matches (or only historical)
- `grep -r "atualizar_tema\|workflow_cirrose" scripts/` → 0 matches (files moved/deleted)
- `grep Antigravity docs/adr/0003-*` → phrase = "historical/deferred", not runtime claim
- `git status` limpo pós-commit

**Risco se pular:** mantém phantom references que confundem future audit + Lucas na interpretação do sistema.

**Por que vem antes:** remove debris antes de tentar organizar control plane (Batch 2).

---

## BATCH 2 — CONTROL PLANE (~30min S232)

**Objetivo:** agents auditam o arquivo certo. `settings.local.json` tem propósito claro.

**Arquivos tocados:**
1. `.claude/agents/sentinel.md:38` — audit `settings.json` não `.local.json` (finding #10)
2. `.claude/agents/systematic-debugger.md:92` — same fix (finding #11)
3. `docs/ARCHITECTURE.md` — document control plane canonical (hooks em settings.json; permissions overrides em settings.local.json)

**Critério de pronto:**
- sentinel/systematic-debugger checks apontam settings.json hooks array
- ARCHITECTURE.md tem §Control Plane explaining both files

**Risco se pular:** agents falham em audit hooks corretamente; false negatives persistentes.

**Por que vem antes:** Batch 3+ precisa que control plane esteja claro para referenciar.

---

## BATCH 3 — MEMORY GOVERNANCE (~20min S232)

**Objetivo:** owner único por tipo de memória. Sem shared/global/project layer fantasma.

**Arquivos tocados:**
1. Confirmar `shared_memory` deleted (Batch 1 #14)
2. Delete empty `.claude/agent-memory/{qa-engineer,sentinel,reference-checker}` (3 empty dirs)
3. Update `docs/ARCHITECTURE.md` §Memory — declare: per-agent memory only; user-global em `~/.claude/memory/` (out of scope OLMO)

**Critério de pronto:**
- `.claude/agent-memory/` = 1 active subdir (evidence-researcher)
- ARCHITECTURE.md §Memory tem owner único declared

**Risco se pular:** memória fantasma permanece; next session pode revivir shared_memory intent.

---

## BATCH 4 — ORCHESTRATION (~60min S232)

**Objetivo:** deletar workflows aspirational + fix research skill executability + atualizar toda dependência downstream.

**Arquivos tocados:**
1. **workflows.yaml:** DELETE (finding #1) — comment já dizia "Nao reviver stubs"
2. `config/loader.py` — audit + remove workflows.yaml loading (dependency de #1)
3. `orchestrator.py:71-73` — remove `register_workflow` loop
4. Grep downstream refs em `docs/*.md`, `CLAUDE.md`, `README.md`, `AGENTS.md` para "workflows.yaml" + update/delete pointers
5. **research/SKILL.md:** MERGE node -e → `.claude/scripts/*.mjs` pattern (finding #2)
   - Create `.claude/scripts/perplexity-research.mjs` (Perna 5) — **repair script, not net-new feature**
   - Reuse `.claude/scripts/gemini-review.mjs` pattern OR create `gemini-research.mjs` se signature diverge
   - Update SKILL.md Perna 1+5 invocation para `node .claude/scripts/{name}.mjs <args>`

**Critério de pronto:**
- workflows.yaml gone
- loader.py não tenta carregar workflows
- 0 downstream refs broken (grep "workflows.yaml" retorna 0 ou apenas historical CHANGELOG)
- `/research` skill executable end-to-end (Pernas 1+5 via script files, não blocked)

**Risco se pular:** continua "false-DONE" em workflows; loader.py crashes OR silently fails; research skill permanece quebrada desde S227.

---

## BATCH 5 — MULTIMODEL (~30min S232 ou S233)

**Objetivo:** fix naming conflation. ChatGPT ≠ Codex ≠ OpenAI API ≠ GPT model ID.

**Arquivos tocados:**
1. `config/ecosystem.yaml:95-96` — fix `chatgpt-5.4` → real API model ID OR mark aspirational (finding #3)
2. `config/rate_limits.yaml:63,69,114` — same (finding #4)
3. `docs/adr/0003-multimodel-orchestration.md:35` — add caveat "`GPT-5.4` not official OpenAI API ID; marketing label from Codex plugin UX" (finding #13)
4. `CLAUDE.md §Tool Assignment` — delete `ChatGPT=VALIDAR`, replace com `Codex=VALIDAR` per ADR-0003 (finding #12)

**Critério de pronto:**
- `grep "chatgpt-5.4" config/` → 0 matches (replaced) OR explicit aspirational flag
- CLAUDE.md Tool Assignment aligns ADR-0003

**Risco se pular:** config programático falha quando invocado; documentação engana future self.

---

## RESÍDUOS (explicit non-action)

### UNVERIFIED
- Nenhum (finding #16 Antigravity reclassificada para HISTORICAL/DEFERRED; finding #17 stop-quality.sh FALSE POSITIVE removido)

### DEFERRED
- Claude Managed Agents evaluation (April 8 launch) — post-S233 roadmap
- Three-Agent Harness pilot (v5 proposal) — **dropped** per "não proponha mais skills antes de provar ownership"
- Native Structured Outputs at agent-level — defer; requires design
- Living-HTML migration (BACKLOG #36) — unchanged, continues active item
- MCP server Gemini/Perplexity — script pattern sufficient now
- SQLite/KV memory migration — over-engineering for current scale
- Antigravity como future candidate — tratada como historical/deferred em ADR-0003

### HISTORICAL ONLY (keep for audit trail)
- CHANGELOG references to ModelRouter, SmartScheduler (removed) — `KEEP-HISTORICAL`
- HANDOFF §ESTADO POS-S230 references to notion-ops/Gmail migrations — `KEEP-HISTORICAL`
- CHANGELOG mention of "Antigravity" (S226 candidate tool) — `KEEP-HISTORICAL` audit trail; ADR-0003 rephrased to "historical/deferred candidate" pointer

---

## Critical files (per Batch)

### Deleted
- `config/workflows.yaml` (Batch 4)
- `config/ecosystem.yaml:43-44` (Batch 1)
- `scripts/atualizar_tema.py` (Batch 1)
- `scripts/workflow_cirrose_ascite.py` (Batch 1)
- `agents/core/base_agent.py:27` shared_memory field (Batch 1)
- Empty `.claude/agent-memory/{qa-engineer,sentinel,reference-checker}` (Batch 3)

### Modified
- `.claude/skills/automation/SKILL.md` (Batch 1)
- `.claude/skills/teaching/SKILL.md` (Batch 1)
- `.claude/agents/sentinel.md` (Batch 2)
- `.claude/agents/systematic-debugger.md` (Batch 2)
- `docs/ARCHITECTURE.md` (Batches 2, 3)
- `.claude/skills/research/SKILL.md` (Batch 4)
- `config/loader.py` (Batch 4)
- `orchestrator.py` (Batch 4)
- `config/ecosystem.yaml` (Batches 1, 5)
- `config/rate_limits.yaml` (Batch 5)
- `docs/adr/0003-multimodel-orchestration.md` (Batches 1, 5)
- `CLAUDE.md` (Batch 5)
- `.claude/settings.local.json` (Batch 1)
- Docs downstream refs (Batch 4 grep sweep)

### Created (repair-only, not net-new features)
- `.claude/scripts/perplexity-research.mjs` (Batch 4, unblock research Perna 5)
- Possibly `.claude/scripts/gemini-research.mjs` (Batch 4, unblock research Perna 1 if signature diverge from gemini-review.mjs)

---

## Budget

| Batch | Tempo | Net complexity delta |
|-------|-------|----------------------|
| 1 Substrate | 45min | **-8 files/refs removed** |
| 2 Control plane | 30min | **-2 agent drifts fixed** |
| 3 Memory | 20min | **-3 empty dirs deleted** |
| 4 Orchestration | 60min | **-1 YAML, -lines orchestrator.py + loader.py; +2 repair scripts** |
| 5 Multimodel | 30min | **-4 conflations fixed** |
| **S232 total** | **~3h 5min** | fits |
| S233 verification | 2h | **0 new; only grep tests + HANDOFF** |

**Net artifact count:** pós-v6, OLMO terá MENOS artefatos ativos apesar de 2 repair scripts novos (que unbloqueiam research skill há semanas broken). Success criterion per Lucas's prompt mantido.

---

## Verification (end of S232)

Grep-based invariants (all must return 0):

1. `grep -r "mbe-evidence" config/ .claude/` → 0 matches
2. `grep -r "shared_memory" agents/ subagents/ scripts/` → 0 matches
3. `grep -r "atualizar_tema\|workflow_cirrose" scripts/` → 0 matches
4. `grep "chatgpt-5.4" config/ CLAUDE.md` → 0 matches OR explicit aspirational flag
5. `grep "workflows.yaml" config/ orchestrator.py docs/` → 0 matches (excl CHANGELOG historical)
6. `grep -r "node -e.*fetch" .claude/skills/research/` → 0 matches (moved to scripts/)
7. `grep -r "settings.local.json" .claude/agents/{sentinel,systematic-debugger}.md` → audit-context should be `settings.json`
8. `grep Antigravity docs/adr/0003*` → phrase contains "historical" or "deferred", não runtime claim

**Runtime invariants:**
- `/research` skill invocation succeeds end-to-end (Pernas 1+5 via scripts/)
- `python orchestrator.py status` still works (minus workflows stub)
- No hook breaks (settings.json hooks array unchanged)

---

## Commits expected (atomic per batch)

1. `S232 Batch 1: substrate cleanup — mbe-evidence phantoms, shared_memory dead field, producer-scripts archived, Antigravity rephrased`
2. `S232 Batch 2: control plane — sentinel + systematic-debugger audit settings.json (not .local.json)`
3. `S232 Batch 3: memory governance — delete empty agent-memory subdirs, ARCHITECTURE §Memory owner single`
4. `S232 Batch 4: orchestration — delete workflows.yaml + loader.py + orchestrator.py + docs sweep; research skill to scripts/ pattern`
5. `S232 Batch 5: multimodel — fix chatgpt-5.4 conflation, CLAUDE.md deflate ChatGPT slot per ADR-0003`
6. `S233 verification pass + HANDOFF S234 slides production`

---

## External review inputs

- Codex GPT-5.4 v3 review — 5 findings P1/P2 (stale SOA framing, storage-first, orchestration gates)
- Gemini 3.1 Pro v3 review — confirmed + escalated to MCP/NativeSO (+ 1 hallucination: CGAgentX caught by research agent)
- Gemini 3.1 Pro v4 roast — "rearranging deck chairs" critique
- Research agent 2026-04-19 (fresh) — Anthropic harness, Managed Agents, Context Kubernetes, Gemini hallucination catch
- Lucas adversarial consolidator prompt — **directing framework for v6** (BATCH 0-5 structure, "no additions except repair" rule)
- Lucas v6 corrections — rephrased Antigravity as historical/deferred; removed stop-quality.sh false positive; expanded Batch 4 to include loader.py + docs sweep; clarified additions rule

---

## What v6 intentionally does NOT add

- NO new agents
- NO new hooks
- NO new memory layers
- NO new skills (harness-pilot dropped from v5)
- NO new plans
- NO architecture revolutions (MCP server, SQLite, Managed Agents migration) — all deferred S234+

**Exceção:** 2 scripts em `.claude/scripts/` que REPAIRAM canonical broken path (research skill Pernas 1+5 blocked since S227 KBP-26). Per Lucas's corrected rule: "no net-new artifacts **unless required to repair a canonical broken path**". Scripts qualify.

---

Coautoria: Lucas + Opus 4.7 (synthesis) + 3 Explore agents (audit) + Codex + Gemini + Research agent | 2026-04-19
