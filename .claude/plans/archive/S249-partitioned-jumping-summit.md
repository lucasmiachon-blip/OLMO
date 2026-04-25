# S249 — infra3 + agents + e2e

> **Plan file** | Sessão S249 | 2026-04-25 | Coautoria: Lucas + Opus 4.7
> **Continuação de S248** (`.claude/plans/archive/S248-scalable-splashing-bentley.md` §Phase C/D).

---

## Context

S248 shipou 7 debug agents (collector + 6 novos: strategist, archaeologist, adversarial, architect, patch-editor, validator) + 4 SOTA reports (60 fontes verificadas) + 12 decisões D1-D12. Faltou **fechar o loop**: o orchestrator que conecta os agents e o mechanical gate que previne loop runaway.

S249 = **infra3** (loop-guard hook D9) + **agents** (debug-team SKILL.md orchestrator D5/D7/D10) + **e2e** (primeiro dry-run do workflow completo em bug real). Sessão deve fechar BACKLOG #60 (debug team Phases 2-7) integralmente.

**Por que e2e importa nesta sessão:** taxa empírica (Aider 85% pass, MetaGPT, SWE-Effi) é medida em bugs reais — workflows que passam em sintéticos quebram em real-world ambiguity. Sem dry-run, /debug-team é teoria. Primeiro bug real revela gaps no orchestrator que sinteticos não capturam (parsing, schema mismatches, prompt brittleness).

---

## Estado atual (input para S249)

| Commit / Estado | Conteúdo | Status |
|-----------------|----------|--------|
| `a86368e` (S248 close) | HANDOFF/CHANGELOG/BACKLOG + plan archive | DONE |
| 7 debug agents shipped | collector + strategist + archaeologist + adversarial + architect + patch-editor + validator | DONE |
| 4 SOTA reports | `docs/research/sota-S248-{A,B,C,D}-*.md` | DONE (reference live) |
| `debug-symptom-collector.md` complexity_score | D8 routing field embutido (linha 56-65 + Fase 2 §4) | DONE |
| `hooks/loop-guard.sh` | D9 mechanical gate | **PENDENTE** |
| `.claude/skills/debug-team/SKILL.md` | D5/D7/D10 orchestrator | **PENDENTE** |
| `/agents` lista 7 debug | Visible apos restart CC | A VERIFICAR |
| BACKLOG #60 partial-RESOLVED | Marcado partial em S248 | A FECHAR (RESOLVED full) |

**Carryover defer-friendly (S249 escopo se houver tempo):**
- B1.2 `.github/workflows/ci.yml` mypy paths stale (poderá servir como e2e target)
- B3 `content/aulas/package.json` dead `research:cirrose|metanalise` scripts
- #191 upstream comment (Lucas owns — não autônomo)

---

## Plan map (5 phases, ~5 commits)

```
Phase 1 — loop-guard.sh hook (D9, advisory-mode)
  └─ hooks/loop-guard.sh + .claude/settings.json registration

Phase 2 — debug-team SKILL.md (orchestrator D5/D7/D10)
  └─ .claude/skills/debug-team/SKILL.md (subdir nova)

Phase 3 — Restart CC + sanity verification
  └─ Lucas restarta + valida /agents (7) + /help (/debug-team)

Phase 4 — e2e dry-run em bug real (B1.2 ci.yml proposed)
  └─ Run /debug-team em B1.2 stale mypy paths → fix shipped

Phase 5 — Session close
  └─ HANDOFF + CHANGELOG + BACKLOG #60 fully RESOLVED
```

Total ~5 commits. Cada commit ship-able independente.

---

## Phase 1 — `hooks/loop-guard.sh` (D9 mechanical gate, advisory-mode)

**Path:** `C:\Dev\Projetos\OLMO\hooks\loop-guard.sh` (NOVO)
**Event:** PostToolUse (Bash + Edit + Write matchers).
**Severidade:** **advisory-mode** (`additionalContext` top-level, NÃO `permissionDecision: block`). Justificativa: per HANDOFF S249 §1 + KBP-21 (calibrate threshold antes de block), observation-mode primeiro gera training data sem cost de FP. Hardening para block após 3 sessões observadas sem FP.

### Logic skeleton

1. **Self-disable gate:** se `.claude-tmp/.debug-team-active` NÃO existe → exit 0 imediato (zero overhead em sessões normais). Flag setada/limpa pelo SKILL.md (Phase 2).
2. **State file:** `.claude-tmp/debug-team-state.json` (initialized vazio na primeira chamada da sessão).
3. **Increment counters:**
   - `bash_repeated[<sha256(cmd)>] += 1` quando tool_name == "Bash"
   - `file_edited[<path>] += 1` quando tool_name in {"Edit","Write"}
4. **Threshold check (advisory):**
   - `bash_repeated[X] >= 4` → emit `additionalContext` advisory: "Loop guard: Bash command '...' repeated 4x. Diagnose root cause antes de retry (KBP-07)."
   - `file_edited[X] >= 5` → emit advisory: "Loop guard: file '...' edited 5x in single phase. Considere se fix está convergindo ou loop runaway (KBP-22)."
5. **Architect↔Editor↔Validator iteration counter:** state field `validator_loop_iter`. Orchestrator (Phase 2) é responsável por incrementar via state write. Hook só lê e adverte ≥3.
6. **Exit 0 sempre** (advisory ≠ block).

### Idiom reference

`hooks/post-tool-use-failure.sh` L1-43 (recém-shipped #57-59 fix). Padrão:
- `set -euo pipefail` + `PROJECT_ROOT` resolution
- `INPUT=$(cat 2>/dev/null || echo '{}')` defensive read
- `jq -r '.tool_name'` extraction
- `cat <<EOF { "additionalContext": "..." } EOF` output schema

### Settings.json registration

Inserir nova entrada em `.claude/settings.json` §hooks.PostToolUse:

```json
{
  "matcher": "Bash|Edit|Write",
  "hooks": [
    {
      "type": "command",
      "command": "bash $CLAUDE_PROJECT_DIR/hooks/loop-guard.sh",
      "timeout": 3000
    }
  ]
}
```

3000ms timeout (ms — `cc-gotchas.md §timeout em hook type "command": milissegundos`).

### Verification (Phase 1)

1. **Synthetic trigger:** crie `.claude-tmp/.debug-team-active`, rode 4× mesmo Bash → confirmar advisory aparece. Limpe flag → confirmar exit 0 sem advisory.
2. **State persistence:** `.claude-tmp/debug-team-state.json` criado/atualizado entre invocações.
3. **Self-disable:** sem flag, `time` mede <50ms overhead (essencialmente exit 0 imediato).
4. Hook não trava em stdin pipe broken (defensive `cat || echo '{}'`).

---

## Phase 2 — `.claude/skills/debug-team/SKILL.md` (orchestrator)

**Path:** `C:\Dev\Projetos\OLMO\.claude\skills\debug-team\SKILL.md` (NOVO subdir).
**Pattern:** Anthropic Opus 4.7 supervisor (taxonomy nível 6 Evaluator-Optimizer + humano). Reference frontmatter: `.claude/skills/research/SKILL.md` L1-10 — adaptar para orchestrator (NÃO `disable-model-invocation: true` — ver Insight acima).

### Frontmatter proposto

```yaml
---
name: debug-team
description: "Multi-agent bug diagnosis pipeline. Triage → routed diagnosis (single OR MAS) → architect plan → Lucas confirm → editor → validator. 6 agents + loop-guard. Use quando bug requer >2 hipoteses ou tocou >3 arquivos."
version: 1.0.0
context: fork
agent: general-purpose
allowed-tools: Read, Grep, Glob, Agent, Write, Bash, Edit
argument-hint: "[bug-description OR slug]"
---
```

### Workflow (11 steps, do plan archive S248 §319-332)

1. **Trigger:** `/debug-team <bug-description>` ou contexto bug-shaped detectado.
2. **Pre-flight:** `mkdir -p .claude-tmp/ && touch .claude-tmp/.debug-team-active` (ativa loop-guard) + `mkdir -p .claude/plans/`.
3. **Spawn `debug-symptom-collector`** (Phase 1 do agent flow). STOP, await JSON output. Read complexity_score.
4. **Persist collector** em `.claude/plans/<bug-slug>.md` §Phase 1 (KBP-29 — antes de próxima phase).
5. **Routing decision (D8):**
   - `complexity_score.value > 75` → spawn **`debug-strategist` SOLO** (single-agent path, baseline forecast >45%).
   - `complexity_score.value ≤ 75` → spawn **3 paralelos** (`debug-archaeologist` + `debug-adversarial` + `debug-strategist`) em single message multi-Agent (anti-drift §Plan execution).
6. **Persist outputs** em `.claude/plans/<bug-slug>.md` §Phase 2 (sub-section per agent).
7. **Spawn `debug-architect`** com (collector + 1 OR 3 downstream JSONs). Output: markdown text plan (D7 — NÃO JSON). Persist em §Phase 3.
8. **PAUSE — Lucas confirm gate (D10):**
   ```
   === Architect Plan ===
   <markdown plan>
   ===
   Lucas, aprovar para Phase 4 (Editor)? [yes / revise / abort]
   ```
   Aguardar input explícito Lucas. Sem input = STOP (KBP-01).
9. **Lucas approves → spawn `debug-patch-editor`** com architect plan + collector. Editor único agent que escreve. Recebe markdown, aplica via Edit/Write + Codex `codex exec --edit`. Output: edit-log JSON. Persist §Phase 4.
10. **Spawn `debug-validator`** com edit-log + collector.reproduction. Output: verdict JSON (`pass` / `partial` / `fail`). Persist §Phase 5.
11. **Verdict branch:**
    - `pass` → emit final report (root cause + files changed + tests run + KBPs identificados). Limpa flag (`rm .claude-tmp/.debug-team-active`). DONE.
    - `partial` → emit warnings, ask Lucas se aceita.
    - `fail` → increment `validator_loop_iter` em state file → loop back step 7 com validator report como input adicional para architect re-think. **Max 3 iter** (loop-guard adverte ≥3, Lucas decide). Após 3, emit final report `unable_to_fix` + handoff para humano.

### Constraints (KBP enforcement)

- **KBP-17 (delegation gate):** spawna APENAS os 6 agents listados. Sem general-purpose ad-hoc.
- **KBP-29 (persist before report):** cada agent output → plan file ANTES de próxima phase. Context é volátil, plan persiste.
- **KBP-22 (silent execution):** entre cada step, emit 1 sentence ao usuário (`"[Phase X] Spawned <agent>. Awaiting JSON."`).
- **D9 loop guard:** ativo via flag durante todo o flow. Limpa em terminal states (DONE / unable_to_fix / Lucas abort).
- **Anti-fabrication:** se collector confidence overall = "low" + gaps > 5, pausar e perguntar Lucas se quer prosseguir.

### Verification (Phase 2)

1. SKILL.md frontmatter valida contra Anthropic skill schema (`name`, `description`, `version`, `agent`, `allowed-tools`).
2. Workflow 11 steps cobre rota single-agent E rota MAS.
3. Lucas confirm gate (step 8) é explícito + bloqueante.
4. Loop-back (step 11.fail) tem terminator (max 3 iter).

---

## Phase 3 — Restart CC + sanity verification

Skills registradas em `.claude/skills/*/SKILL.md` carregam no boot. **Lucas restart CC** (intencional momento de "deploy + integration test").

Após restart, Lucas verifica:
1. `/agents` lista 7 debug agents (collector + 6 novos). Se < 7 → frontmatter inválido em algum agent → debug.
2. `/help` (ou skill list) mostra `/debug-team`. Se ausente → SKILL.md frontmatter / path inválido → debug.
3. `.claude-tmp/.debug-team-active` NÃO existe (clean state).
4. settings.json valida (sem JSON syntax error após adição da hook entry).

Phase 3 só prossegue se 1+2 verdadeiros. Caso contrário, debug + commit fix antes de Phase 4.

---

## Phase 4 — e2e dry-run em bug real (proposta: B1.2 ci.yml stale mypy)

**Target proposto:** B1.2 — `.github/workflows/ci.yml` L32 `mypy agents/ subagents/ config/` (stale, agents/+subagents/ purged S232) → deve ser `mypy scripts/ config/`. Plus drop pytest L34-35 (sem tests/ em git).

**Por que B1.2 como e2e first:**
- Bug real (mypy quebraria CI se rodasse — não roda porque CI desabilitado, mas latente)
- Escopo trivial (~3 line edit em 1 arquivo)
- complexity_score esperado >75 (error_clarity high — lemma: paths não existem; scope_clarity high — 1 file 2 lines; cause_familiarity high — S232 purge documentado)
- → exercita **single-agent path** (strategist solo). MAS path testar em bug futuro mais complexo.
- Workflow validado por Lucas em cada gate (step 8 D10 + Phase 5 verdict review). Final patch correctness double-checked manualmente — Lucas reads diff antes de commit.

### e2e protocol

```
1. Lucas tipa: /debug-team "B1.2 ci.yml mypy paths stale post-S232 purge — agents/ subagents/ devem ser scripts/. Drop pytest L34-35 sem tests/ em git."
2. SKILL orchestrator executa workflow steps 1-11.
3. Lucas observa cada gate; intervém em D10 (step 8) confirming or revising architect plan.
4. Validator pass → editor commit shipped.
5. Verdict pass → BACKLOG B1.2 RESOLVED.
6. Capture metrics em `.claude/plans/<bug-slug>.md` §metrics:
   - tokens consumed per phase
   - wall-clock per phase
   - routing decision (esperado: single_agent)
   - validator iter count (esperado: 1)
7. Limpa flag .debug-team-active.
```

### Fallback se workflow falhar mid-flow

- **Collector trava:** input ambíguo. Lucas refina prompt + re-invoca.
- **Architect markdown malformado:** D7 risk. Capture output literal em plan file. Manual fix to Architect agent prompt em commit follow-up. Não retry mesmo prompt (KBP-07).
- **Editor diff incorreto:** D11 risk (Codex Aider syntax). Lucas reverte commit (`git reset --hard HEAD~1`), debug agent prompt, re-tenta.
- **Validator FP:** verdict fail mas Lucas vê fix correto. Capture em plan file gaps. Pass manual override + ship.
- **Loop runaway despite max 3:** loop-guard advisory dispara, Lucas aborta manualmente. Workflow registrado como `unable_to_fix` + e2e considerado partial-success (loop-guard funcionou).

### Verification (Phase 4)

1. `/debug-team` invoca sem erro de skill registration.
2. Collector emite JSON com complexity_score >75 (validate D8 routing).
3. Strategist solo path executado (não MAS) — confirmar via plan file §Phase 2 contendo 1 agent output.
4. Architect markdown válido + Lucas confirma D10.
5. Editor aplica diff em ci.yml (não em outros files — KBP-01 scope).
6. Validator verdict `pass` (mypy não roda em CI desabilitado, mas lint clean + spot-check de regression em outros workflows passa).
7. Plan file `.claude/plans/<b1-2-ci-yml-stale>.md` persiste todas as fases (KBP-29).
8. **Comparison checkpoint:** Lucas review final commit diff equivale ao manual fix esperado (ci.yml L32 + L34-35).

---

## Phase 5 — Session close

1. **HANDOFF.md S249→S250:**
   - Phase C/D RESOLVED (paths shipped).
   - e2e outcome (success/partial/fail).
   - B1.2 RESOLVED se Phase 4 ship.
   - Carryover S249→S250: B3 dead scripts, #191 upstream comment, observações do dry-run para S250 hardening (ex: threshold tuning loop-guard).
   - <50 li (anti-drift §Session docs).
2. **CHANGELOG.md S249 entry:** ≤5 li.
3. **BACKLOG.md #60 RESOLVED full** (Phases 2-7 todas done).
4. **Plan archive:** mover `.claude/plans/partitioned-jumping-summit.md` → `.claude/plans/archive/S249-partitioned-jumping-summit.md` em commit final.

---

## Critical files

**Phase 1 (loop-guard):**
- `C:\Dev\Projetos\OLMO\hooks\loop-guard.sh` (NOVO, ~80 li)
- `C:\Dev\Projetos\OLMO\.claude\settings.json` (Edit em §hooks.PostToolUse)

**Phase 2 (orchestrator):**
- `C:\Dev\Projetos\OLMO\.claude\skills\debug-team\SKILL.md` (NOVO, ~200 li)

**Phase 3 (verification):** N/A — Lucas hands-on

**Phase 4 (e2e):**
- `C:\Dev\Projetos\OLMO\.github\workflows\ci.yml` (Edit via debug-patch-editor)
- `C:\Dev\Projetos\OLMO\.claude\plans\<bug-slug>.md` (Write progressivo orchestrator)

**Phase 5 (close):**
- `C:\Dev\Projetos\OLMO\HANDOFF.md`
- `C:\Dev\Projetos\OLMO\CHANGELOG.md`
- `C:\Dev\Projetos\OLMO\.claude\BACKLOG.md`
- `C:\Dev\Projetos\OLMO\.claude\plans\archive\S249-*.md` (rename)

**Reference (read-only basis, NÃO modificar):**
- `.claude/plans/archive/S248-scalable-splashing-bentley.md` (plan source — Phase C §301-313, Phase D §315-345)
- `docs/research/sota-S248-D-synthesis.md` (D7-D12 evidence)
- `.claude/agents/debug-symptom-collector.md` L56-65 (complexity_score schema canonical)
- `hooks/post-tool-use-failure.sh` (idiom reference Phase 1)
- `.claude/skills/research/SKILL.md` L1-10 (frontmatter reference Phase 2)

---

## Verification (consolidada)

| Phase | Verification command | Pass criteria |
|-------|----------------------|---------------|
| 1 | Synthetic trigger 4× Bash → emit advisory | additionalContext aparece + state file existe + exit 0 |
| 1 | Sem flag .debug-team-active → time bash hooks/loop-guard.sh | <50ms overhead |
| 2 | `python -c 'import yaml; yaml.safe_load(open(".claude/skills/debug-team/SKILL.md").read().split("---")[1])'` | Frontmatter parses sem erro |
| 3 | `/agents` (após restart) | Lista 7 debug agents |
| 3 | `/help` (após restart) | `/debug-team` aparece |
| 4 | `/debug-team "B1.2..."` execution | Workflow completa 11 steps; verdict pass; commit ci.yml shipped |
| 4 | `git diff HEAD~1 -- .github/workflows/ci.yml` | Match esperado: L32 paths + L34-35 drop pytest |
| 5 | `wc -l HANDOFF.md` | <50 li |
| 5 | BACKLOG #60 grep | "RESOLVED" tag presente, sem "partial" |

---

## Risks / open items

- **R1 — Threshold loop-guard FP:** advisory-mode mitiga. Mas Lucas pode ficar dessensibilizado a advisories ruidosas. Mitigation: log estruturado em `.claude-tmp/debug-team-state.json` + revisão pos-3-sessões antes de hardening para block.
- **R2 — Codex Aider syntax `codex exec --edit`:** plan archive R3 levantou — confirm em build time. Fallback documentado (stdin patch).
- **R3 — SKILL.md skill registration latency:** restart CC pode demorar ~5-10s + skill list refresh. Não bloqueante mas interrupte fluxo. Mitigation: Lucas restart entre Phase 2 commit e Phase 4 invocation (não mid-Phase 4).
- **R4 — e2e B1.2 escolhido pode ter complexity_score <75 (MAS path):** se collector emit <75, workflow exercita MAS path em vez de single. Não é bug — é informação útil sobre threshold calibration. Continue execução, anota em plan file metrics.
- **R5 — Architect markdown parsing pelo Editor:** D7 unproven em OLMO. Codex Aider deve ter parsing nativo (S27 SOTA-C evidence). Se falhar: Editor reporta + Lucas inspeciona markdown literal + decide se é prompt issue ou parser issue.
- **R6 — Validator verdict FP em CI desabilitado:** ci.yml fix não tem teste runtime (CI off). Validator vai usar lint estático + spot-check regression. Pode emitir partial. Lucas override = OK.
- **R7 — Lucas time gate D10:** se Lucas ausente / multitasking, workflow espera. SKILL.md deve `STOP` explícito sem timeout (D10 anti-pattern: timeout-based auto-approve = catastrophic).

---

## Decisões assumidas (S249)

- **D13 (NOVO)** — Loop-guard advisory-mode primeiro (vs block do plan archive). Justificativa: KBP-21 calibrate-before-harden + HANDOFF S249 §1. Hardening para block após observação ≥3 sessões sem FP.
- **D14 (NOVO)** — e2e target = B1.2 ci.yml. Justificativa: bug real, escopo trivial, expected single-agent path = primeiro stress-test pre-MAS.
- **D15 (NOVO)** — SKILL.md SEM `disable-model-invocation: true` (research SKILL usa). Justificativa: orchestrator é interactive (humano-in-the-loop), Opus supervisor precisa ser invocavel pelo modelo durante triage.
- **D16 (NOVO)** — Validator iter cap = 3 (loop-guard advertência ≥3, Lucas decide manual). Justificativa: SOTA-C S6 SWE-Effi failures consomem 3-4x tokens; cap conservador antes de calibrar.
- **D17 (NOVO)** — `.claude-tmp/.debug-team-active` flag pattern (vs always-on hook). Justificativa: zero overhead em sessões normais (>99% das sessões), KBP-23 first-turn discipline.

---

## Não-escopo (explícito)

- **B3 content/aulas/package.json** dead scripts (defer S250 ou seguinte — pode virar segundo e2e target).
- **#191 upstream comment** — Lucas owns, não autônomo.
- **Tier 3-5 documental** carryover (Q1/Q2/Q3/Q4 — sessão futura).
- **Threshold calibration loop-guard** (S250+ pós-observação).
- **Hardening SKILL.md** com prompt versioning, A/B test architect formats, etc. — sessão pós-3-bugs medidos.
- **R3 Clínica Médica prep** — trilha paralela.
- **shared-v2 Day 2/3, grade-v2 scaffold C6, metanalise C5 s-heterogeneity** — todos PAUSED em planos próprios.

---

*Plano S249. Coautoria: Lucas + Opus 4.7 (Claude Code). 2026-04-25.*
