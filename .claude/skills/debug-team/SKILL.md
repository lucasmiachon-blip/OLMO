---
name: debug-team
disable-model-invocation: true
description: "Multi-agent bug diagnosis pipeline. Triage → routed diagnosis (single OR MAS) → architect markdown plan → Lucas confirm → editor → validator + loop max 3. 7 agents + loop-guard mechanical gate. Use quando bug requer >2 hipoteses ou tocou >3 arquivos."
version: 1.0.0
context: fork
agent: general-purpose
allowed-tools: Read, Grep, Glob, Agent, Write, Edit, Bash
argument-hint: "<bug-description-or-slug>"
---

# Debug Team — Multi-Agent Bug Diagnosis Orchestrator

> **Pattern:** Anthropic taxonomy nível 6 (Evaluator-Optimizer + humano-in-loop).
> **Topology source:** `.claude/plans/archive/S248-scalable-splashing-bentley.md` §75-114.
> **Evidence base:** `docs/research/sota-S248-D-synthesis.md` (60 fontes verificadas).

## ENFORCEMENT (primacy anchor)

1. **User-only invocation.** Skill só dispara quando Lucas digita `/debug-team <bug>`. Modelo pode sugerir mas NUNCA auto-invocar (`disable-model-invocation: true`).
2. **Sequential gates obrigatorios.** Cada Phase 1→2→3→4→5 termina com persistência em plan file ANTES de spawn da próxima (KBP-29). Context é volátil, plan persiste.
3. **Lucas confirm gate D10 e bloqueante.** Após architect markdown, STOP explícito. Sem input Lucas = wait. Timeout-based auto-approve = catastrophic (D10).
4. **Max 3 iterations.** Validator fail → architect re-think loop ends at iter 3. Loop-guard advisory adverte ao crossing. Lucas decide humano após 3.
5. **Spawna APENAS os 6 agents listados.** Sem general-purpose ad-hoc (KBP-17).
6. **Anti-fabrication.** Cada agent output reportado literalmente. Não parafrasear, não condensar sem flag.

Pesquisa para: `$ARGUMENTS`

---

## Step 0 — Pre-Flight (validação canonical antes de flag activation)

ANTES de tocar qualquer state, validar:

```bash
for agent in debug-symptom-collector debug-strategist debug-archaeologist debug-adversarial debug-architect debug-patch-editor debug-validator; do
  test -f ".claude/agents/${agent}.md" || { echo "MISSING: ${agent}"; exit 1; }
done
echo "All 7 debug agents present."
```

Se algum missing → STOP, reportar ao Lucas: "Debug team incompleto — falta `<agent>`. /debug-team aborted."

Verificar `.claude-tmp/.debug-team-active` AUSENTE antes de criar (paranoia: stale flag de session abortada anteriormente):

```bash
test -f .claude-tmp/.debug-team-active && echo "WARN: stale flag detected"
```

Se stale flag detectado → reportar Lucas + perguntar se ok limpar (`mv .claude-tmp/.debug-team-active .claude-tmp/.debug-team-active.stale.<timestamp>`). Não auto-clean (pode ser /debug-team em outra janela).

---

## Step 1 — Activation

```bash
mkdir -p .claude-tmp/ && touch .claude-tmp/.debug-team-active
mkdir -p .claude/plans/
echo '{"bash_repeated":{},"file_edited":{},"validator_loop_iter":0,"started_at":"'"$(date -u +%FT%TZ)"'"}' > .claude-tmp/debug-team-state.json
```

**Bug-slug:** derive de `$ARGUMENTS` (kebab-case, ≤40 chars). Plan file path: `.claude/plans/debug-<bug-slug>.md`.

Initialize plan file:

```markdown
# Debug Team — <bug-description>

> Started: <ISO-8601>
> Trigger: /debug-team <args>
> State: .claude-tmp/debug-team-state.json

## Phase 1 — Symptom Collection
<pending>

## Phase 2 — Diagnosis
<pending>

## Phase 3 — Architect Plan
<pending>

## Phase 4 — Patch Application
<pending>

## Phase 5 — Validation
<pending>

## Final Verdict
<pending>

## Metrics
- Routing decision: <pending>
- Validator iter count: <pending>
- Phases tokens / wall-clock: <pending>
```

Emit ao Lucas: `[Step 1] Activated /debug-team flow for '<bug-slug>'. Plan file: .claude/plans/debug-<slug>.md. Spawning collector.`

---

## Step 2 — Phase 1: Symptom Collector (always)

```
Agent.spawn(
  subagent_type: "debug-symptom-collector",
  description: "Phase 1 collector",
  prompt: "<bug-description from $ARGUMENTS>. Output schema canonical per debug-symptom-collector.md §Output Schema. Read all referenced logs/files. Compute complexity_score honestly with confidence flags."
)
```

Aguardar JSON output. Read `complexity_score.value` + `complexity_score.routing_decision`.

**Persist em plan file §Phase 1:** Edit replace `<pending>` por:

```markdown
## Phase 1 — Symptom Collection

<full collector JSON output>

**Routing decision:** <single_agent | mas> (score: <N>)
```

Emit: `[Step 2] Collector done. complexity_score: <N>. Routing: <decision>. Spawning Phase 2.`

---

## Step 3 — Routing Decision (D8)

| `complexity_score.value` | Path | Agents to spawn |
|--------------------------|------|-----------------|
| > 75 | single_agent | `debug-strategist` SOLO |
| ≤ 75 | mas | `debug-archaeologist` + `debug-adversarial` + `debug-strategist` (3 paralelos) |

Justificativa SOTA: S8 SOTA-C β̂=-0.408 (p<0.001). Single-agent supera MAS quando baseline >45%; high complexity_score correlaciona PSA elevada.

---

## Step 4 — Phase 2: Diagnosis (1 OR 3 paralelos)

### Single-agent path (complexity_score > 75)

```
Agent.spawn(
  subagent_type: "debug-strategist",
  description: "Phase 2 single-agent diagnosis",
  prompt: "<collector JSON>. Apply first-principles decomposition. Rank hypotheses by likelihood + falsifiability. Output JSON per debug-strategist.md schema."
)
```

### MAS path (complexity_score ≤ 75)

**3 paralelos em SINGLE message multi-Agent** (Anthropic taxonomy nível 5 Parallelization):

```
[Single message containing 3 Agent tool uses:]
1. Agent.spawn(debug-archaeologist, "Search git log -S, blame, related issues...")
2. Agent.spawn(debug-adversarial, "Try to refute primary hypothesis. Construct strongest counter-argument...")
3. Agent.spawn(debug-strategist, "First-principles + ranked hypotheses...")
```

**Persist em plan file §Phase 2:**

```markdown
## Phase 2 — Diagnosis (<single_agent|mas>)

### Strategist
<JSON>

### Archaeologist (MAS only)
<JSON>

### Adversarial (MAS only)
<JSON>
```

Emit: `[Step 4] Phase 2 done. Spawning architect.`

---

## Step 5 — Phase 3: Architect (markdown plan)

```
Agent.spawn(
  subagent_type: "debug-architect",
  description: "Phase 3 architect markdown plan",
  prompt: "Inputs: <collector JSON> + <Phase 2 outputs>. Synthesize root cause cross-validation (MAS path) or direct (single). Produce markdown text per debug-architect.md §Output Format. NUNCA emit JSON tool calls. Apenas markdown text estruturado."
)
```

Aguardar markdown output. **NÃO emit JSON, é markdown text.**

**Persist em plan file §Phase 3:**

```markdown
## Phase 3 — Architect Plan

<full architect markdown output, copy-paste literal>
```

Emit: `[Step 5] Architect plan ready. PAUSING for Lucas confirm gate (D10).`

---

## Step 6 — D10 Lucas Confirm Gate (BLOQUEANTE)

Emit ao Lucas:

```
=== Architect Plan Preview ===
<full markdown plan>
=== End Plan ===

Lucas, aprovar para Phase 4 (Editor aplica)?
[1] yes — proceder com editor
[2] revise — me dizer o que mudar
[3] abort — cancelar /debug-team

Aguardando input.
```

**STOP.** Aguardar próxima mensagem Lucas. Sem input = wait. Não timeout-based auto-approve.

| Lucas response | Action |
|----------------|--------|
| `1` / `yes` / `aprovado` / similar | Proceed Step 7 |
| `2` / `revise` + delta | Re-spawn architect com delta como input adicional. Retorna Step 5. |
| `3` / `abort` | Cleanup (Step 10 abort path). DONE. |
| Outro | Pedir clarificação 1 vez. Se segundo input ambíguo, default `abort` + report. |

---

## Step 7 — Phase 4: Patch Editor (Aider Editor role)

```
Agent.spawn(
  subagent_type: "debug-patch-editor",
  description: "Phase 4 apply architect plan",
  prompt: "Architect plan: <full markdown from Phase 3>. Collector context: <collector JSON>. Apply each '### File:' section via Edit/Write + Codex Aider. Edit APENAS files listed em architect plan (KBP-01 scope violation otherwise). Output edit-log JSON."
)
```

Aguardar edit-log JSON output.

**Persist em plan file §Phase 4:**

```markdown
## Phase 4 — Patch Application

<edit-log JSON output>

### Files modified
- path/file.ext (lines X-Y)
- ...

### git diff snapshot
[run git diff --stat]
```

Emit: `[Step 7] Editor applied. Spawning validator.`

---

## Step 8 — Phase 5: Validator (mechanical verification)

```
Agent.spawn(
  subagent_type: "debug-validator",
  description: "Phase 5 mechanical validation",
  prompt: "Edit log: <edit-log JSON>. Reproduction steps from collector: <collector.reproduction>. Run repro + lint + spot-check regression em related files. Output verdict JSON per debug-validator.md schema. Verdict pass | partial | fail."
)
```

Aguardar verdict JSON.

**Persist em plan file §Phase 5:**

```markdown
## Phase 5 — Validation

<verdict JSON output>

**Verdict:** <pass | partial | fail>
```

---

## Step 9 — Verdict Branch

### Verdict `pass`

Emit final report (Step 10 success path). DONE.

### Verdict `partial`

Emit warnings + ask Lucas:

```
=== Verdict: PARTIAL ===
<verdict JSON>

Repro fixed mas com warnings (lint/regression). Lucas, aceita partial e ship?
[1] yes — accept partial
[2] no — loop back para architect
[3] abort
```

Aguardar Lucas. Branch como Step 6 logic.

### Verdict `fail`

```bash
NEW=$(jq '.validator_loop_iter += 1' .claude-tmp/debug-team-state.json)
echo "$NEW" > .claude-tmp/debug-team-state.json.tmp && mv .claude-tmp/debug-team-state.json.tmp .claude-tmp/debug-team-state.json
ITER=$(jq -r '.validator_loop_iter' .claude-tmp/debug-team-state.json)
```

| iter | Action |
|------|--------|
| 1, 2 | Loop back step 5 (architect re-think) com validator failure report como input adicional. **Não re-rodar collector ou Phase 2** — só architect novamente. |
| 3 | Loop-guard advisory dispara (==3). Pause. Emit ao Lucas: "3 iter atingido. Continuar (vai espalhar tokens) ou aceitar `unable_to_fix` + handoff humano?" |
| > 3 | NÃO chegar aqui. Step 11 unable_to_fix path (Lucas chose continue → 1 mais OK). |

State write é responsabilidade do orchestrator (single-writer). Validator agent NÃO escreve state — apenas emit verdict. Loop-guard hook lê.

---

## Step 10 — Final Report + Cleanup

### Success path (verdict pass)

```markdown
## Final Verdict — PASS

**Root cause:** <from architect>
**Files modified:** <list>
**Tests run:** <validator output>
**KBPs identified:** <if any new patterns observed>
**Iter count:** <N>

**Recommendation:** <commit / not-commit / Lucas-review>
```

```bash
# Cleanup
mv .claude-tmp/.debug-team-active .claude-tmp/.debug-team-active.completed.<bug-slug>.<timestamp>
# Keep state file as audit trail (not deleted)
```

Emit: `[Step 10] /debug-team DONE. Verdict: PASS. Plan file: .claude/plans/debug-<slug>.md.`

### Unable_to_fix path (3+ iter, Lucas decided abort)

```markdown
## Final Verdict — UNABLE_TO_FIX

**Iter count:** <N>
**Last validator failure:** <verdict JSON>
**Architect last attempt:** <last markdown plan>
**Recommendation:** Handoff humano. Plan file contém histórico completo.
```

Same cleanup as success path.

### Abort path (Lucas D10/partial abort)

```markdown
## Final Verdict — ABORTED

**Aborted at:** <step N>
**Reason:** <Lucas reason if provided>
```

Same cleanup.

---

## State File Contract

**File:** `.claude-tmp/debug-team-state.json`

**Schema:**
```json
{
  "bash_repeated": {"<sha16>": int, ...},
  "file_edited": {"<sha16>": int, ...},
  "validator_loop_iter": int,
  "started_at": "ISO-8601"
}
```

**Writers:**
- **Orchestrator (this skill):** initialize at Step 1, increment `validator_loop_iter` at Step 9 fail branch, never resets `bash_repeated`/`file_edited` (cumulative within flow).
- **Loop-guard hook (`hooks/loop-guard.sh`):** writes `bash_repeated[k]++` and `file_edited[k]++` per PostToolUse. Atomic via jq + temp-rename.

**Readers:**
- Loop-guard hook reads thresholds at every PostToolUse.
- Orchestrator reads `validator_loop_iter` at Step 9.

**Race tolerance:** advisory-mode = undercount acceptable. Single-writer-per-field semantically (orchestrator owns iter, hook owns counters).

**Reset:** flag move at Step 10 cleanup (state file kept as audit). Next /debug-team Step 1 re-initializes.

---

## Plan File Persistence Schema

**File:** `.claude/plans/debug-<bug-slug>.md`

**Initial template:** Step 1 Write.
**Updates:** Edit per phase, replacing `<pending>` por outputs literais.
**Final state:** all 5 phases populated + Final Verdict + Metrics.

KBP-29 enforcement: cada Edit acontece ANTES da próxima Agent.spawn. Context volátil → plan file durável.

---

## Failure Modes

| Situação | Ação |
|----------|------|
| Step 0 missing agent | STOP, reportar Lucas, abort |
| Step 0 stale flag | Pedir Lucas para confirmar limpar |
| Collector retorna empty/malformed JSON | KBP-07 — diagnose root cause; reportar Lucas + ask se rerun ou abort |
| Phase 2 paralelos: 1 falha | Continue com os 2 que retornaram + flag em plan file |
| Phase 2 paralelos: 2+ falham | STOP, reportar Lucas, ask retry single OR abort |
| Architect markdown malformado / vazio | Capture literal output em plan file. Não retry mesmo prompt (KBP-07). Ask Lucas se ajusta prompt manual ou abort. |
| Editor diff em files NÃO listados em architect plan | KBP-01 violation. STOP, reportar, Lucas decide revert/keep. |
| Validator verdict missing fields | Treat as `fail` conservador. Loop back Step 9. |
| Lucas ausente em D10 (multitasking) | Wait. Sem timeout. Pode demorar horas — ok. |
| Mid-flow Ctrl+C / session crash | Flag fica stale. Próxima `/debug-team` Step 0 detecta e pergunta. |

---

## Constraints (KBP enforcement)

- **KBP-17 (delegation gate):** spawna APENAS 7 agents listados. Sem general-purpose ad-hoc.
- **KBP-22 (silent execution):** entre cada step, emit 1 sentence ao usuário. Nunca silent chains.
- **KBP-29 (persist before report):** cada agent output → plan file ANTES de próxima phase.
- **KBP-15 (write race):** state file single-writer per field (orchestrator owns iter, hook owns counters). Atomic via jq + temp-rename.
- **D9 loop guard:** flag ativa durante todo flow. Limpa em Step 10 (todos terminal paths).
- **D10 confirm gate:** STOP explícito Step 6 + Step 9 partial. Sem timeout auto-approve.
- **Anti-fabrication:** se collector confidence overall = "low" + gaps > 5, pausar Step 2 e perguntar Lucas se prosseguir.

---

## Example flow (B1.2 ci.yml stale mypy)

```
Lucas: /debug-team B1.2 ci.yml mypy paths stale post-S232 purge — agents/ subagents/ devem ser scripts/. Drop pytest L34-35 sem tests/ em git.

[Step 0] Pre-flight: 7 agents present. No stale flag.
[Step 1] Activated. Plan: .claude/plans/debug-b1-2-ci-yml-stale.md
[Step 2] Collector spawned. Output: complexity_score=85, routing=single_agent.
[Step 3] Routing: single_agent path.
[Step 4] Strategist spawned (solo). Output: JSON with ranked hypotheses.
[Step 5] Architect spawned. Output: markdown plan.
[Step 6] === Architect Plan Preview === ... === End Plan ===
         Lucas, aprovar?

Lucas: yes

[Step 7] Editor spawned. Edit-log: ci.yml L32 + drop L34-35.
[Step 8] Validator spawned. Verdict: pass (lint clean, no regression).
[Step 9] Verdict pass.
[Step 10] === Final Verdict — PASS ===
         Root cause: S232 purge não atualizou CI mypy paths.
         Files: .github/workflows/ci.yml
         Recommendation: commit.
         /debug-team DONE.
```

---

## ENFORCEMENT (recency anchor — reler antes de Step 6)

1. User-only invocation (não autônomo)
2. Persist plan file ANTES de próxima phase (KBP-29)
3. D10 confirm gate é BLOQUEANTE — sem timeout auto-approve
4. Max 3 iter validator loop. Iter 3 → Lucas decide
5. State writes: orchestrator owns iter, hook owns counters
6. Cleanup flag em TODOS terminal paths (success/unable/abort)

---

## VERIFY

`scripts/smoke/debug-team.sh` — smoke test reprodutível (P1+ creation pendente). Validates: 7 agents present (Step 0 preflight loop), state file JSON schema, plan file phases 1-5 initialization, validator loop iter ≤3 boundary, cleanup flag em terminal paths.

---

*Skill S249. Coautoria: Lucas + Opus 4.7 (Claude Code). Reference: SOTA-D synthesis 60 fontes.*
