# S248 — infra3 + agents (refinado por SOTA evidence)

> **Plan file** | Sessão S248 | 2026-04-25 | Coautoria: Lucas + Opus 4.7
> **Refinamento 2026-04-25 17h:** Frente 2 redesenhada conforme estado-da-arte de criação de agents (SOTA-A/B/C/D em `docs/research/sota-S248-*.md`, 60 fontes verificadas).
> **Constraint:** custo NÃO é problema (Lucas solo dev). **Eficacia é o critério único.**

---

## Context

S247 deixou duas frentes pendentes que formaram o nome desta sessão:

- **infra3** — 3 schema bugs em hooks (BACKLOG #57-59 P1) — DONE em commit `2a350d6` (B2 do benchmark gate).
- **agents** — Debug Team Phases 2-7 (BACKLOG #60). Phase 1 (`debug-symptom-collector.md`) shipou em S247.

Durante a sessão (Lucas 16h30): pesquisa SOTA evidence-based foi lançada (3 agents paralelos) para fundamentar a arquitetura do debug team. 4 reports gerados (945 li, 60 fontes).

Achados críticos que mudam Frente 2:
1. **Single-agent supera MAS quando baseline >45%** (β̂=-0.408, p<0.001, S8 SOTA-C) — implica triage condicional, não MAS sempre.
2. **Aider Architect/Editor pattern** atinge 85% pass rate (vs 75% solo) com **separação de reasoning + format** (S27 SOTA-C).
3. **Tool design = capability floor** (S5/S7/S9/S10 SOTA-C) — agente sem tool correta = 0% no task class inteira, não degradação.
4. **Step counter / loop guard mecânico** preveniria 3-4x token overhead em failures (S6 SOTA-C SWE-Effi).
5. **Anthropic taxonomy 7 níveis** (S26) — bug debug fica naturalmente em níveis 4-6 (Parallelization + Orchestrator-Workers + Evaluator-Optimizer loop), não nível 7 (Autonomous).

Plus contaminação detectada: SOTA-A claim "7/10 agents sem `model:` explícito" foi FALSO (10/10 declaram, verificado por Grep local). FIX-3 retratada. Outros 2 fixes (FIX-1 `color: magenta`, FIX-2 `mcpServers` dict format) confirmados válidos.

---

## Estado atual (commits + outstanding)

| Commit | Conteúdo | Status |
|--------|----------|--------|
| `2a350d6` | hook fixes #57-59 (B2) + benchmark gate B0-B6 + plan inicial | DONE |
| `b273181` | ENFORCEMENT #6 evidence-based + KBP-36 | DONE |
| `e38c161` | KBP-32-36 trim prose-in-pointer (KBP-16 enforcement) | DONE |

**Outstanding na working tree:** apenas 4 untracked SOTA files (`docs/research/sota-S248-{A,B,C,D}-*.md`).

**Lost work (revertido externamente):** edit em `.github/workflows/ci.yml` (B1.2) — abandonado neste plan, retomar em sessão futura se necessário.

---

## Ordem revisada

Foco da sessão restante: **Frente 2 (debug team SOTA-aligned)**. B1.2/B3 deferidos (gate honrado mas tempo limitado nesta sessão).

```
Phase A — Foundation (1 commit)
  └─ FIX-1, FIX-2 em reference-checker.md (high-confidence, low-risk)

Phase B — Build agents (4-5 commits incrementais)
  ├─ debug-strategist.md (Opus, anchor — sem deps externas)
  ├─ debug-archaeologist.md (Gemini wrapper)
  ├─ debug-adversarial.md (Codex wrapper)
  ├─ debug-architect.md (Opus, Aider Architect role — text plan)
  ├─ debug-patch-editor.md (Codex Aider role — applies)
  └─ debug-validator.md (Sonnet + Bash)

Phase C — Infrastructure (1 commit)
  └─ step-counter loop-guard hook (mechanical SOTA gate)

Phase D — Orchestrator (1 commit)
  └─ .claude/skills/debug-team/SKILL.md

Phase E — Session close (1 commit)
  └─ HANDOFF + CHANGELOG + BACKLOG #60 partial-RESOLVED
```

Total ~7 commits. Cada commit ship-able independente — se sessão pausar, restart pega do último.

---

## Frente 2 — Debug Team SOTA-aligned (efficacy-first)

### Topologia revisada (S248 SOTA-D synthesis)

```
                    Phase 1: TRIAGE
                  debug-symptom-collector
                       (Sonnet, JSON schema-first)
                       + complexity_score field [0-100]
                              ↓
                       ┌──────┴──────┐
                       ↓             ↓
              score > 75          score ≤ 75
              (BASELINE >45%)     (BASELINE <45%)
              SINGLE-AGENT path   MAS path
                  ↓                   ↓
                  ↓        ┌──────────┼──────────┐
                  ↓        ↓          ↓          ↓
                  ↓     archaeologist adversarial strategist
                  ↓     (Gemini 1M)  (Codex max) (Opus max)
                  ↓        └──────────┼──────────┘
                  ↓                   ↓
                  └─────→ Phase 3: ARCHITECT ←─────┘
                         debug-architect
                         (Opus 4.7 max — TEXT plan, não JSON)
                              ↓
                         [LUCAS CONFIRM GATE]
                              ↓
                       Phase 4: APPLY
                       debug-patch-editor
                       (Codex Aider-style)
                              ↓
                       Phase 5: VALIDATE
                       debug-validator
                       (Sonnet + Bash mecânico)
                              ↓
                       ┌──────┴──────┐
                    pass            fail
                       ↓             ↓
                     DONE      Loop ← Architect
                                (max 3 iter — step counter hook)
```

### Decisões fundadas em evidência

#### D7 — Aider Architect/Editor pattern (NOVO)

**Evidence:** S27 SOTA-C — Aider blog 2024-09. 85% pass rate (Architect+Editor) vs 75% solo Claude 3.5 Sonnet. Quote: "LLMs write worse code if you ask them to return code wrapped in JSON via tool function call."

**Aplicação OLMO:**
- `debug-architect`: Opus 4.7 max, READ-ONLY, output em **markdown text estruturado** (Root cause + Patch architecture file-by-file em prosa + Risks + Rollback). Não emite JSON com tool calls.
- `debug-patch-editor`: Codex Aider wrapper. Recebe markdown do architect, traduz para Edit/Write actual. Surgical, sem drift.

**Por que beats synthesizer-com-JSON-output (plano original):** evidência empírica direta de que reasoning-without-format-constraint > reasoning-as-JSON. Mesma lógica do Aider.

#### D8 — Conditional MAS routing (NOVO)

**Evidence:** S8 SOTA-C — 180 configs, 5 architectures, 3 LLM families. β̂=-0.408 (p<0.001) para single→MAS quando baseline >45%. PSA<0.45 → MAS adiciona valor; PSA>0.45 → MAS degrada.

**Aplicação OLMO:**
- `debug-symptom-collector` adiciona campo `complexity_score` [0-100] no JSON output. Heurística: error_signature.confidence + reproduction.deterministic + scope_narrowness + recent_changes_known.
- Threshold: score > 75 → single-agent path (strategist apenas); score ≤ 75 → MAS path (3 paralelos).
- Threshold conservador (75 vs 50) porque medical-grade decisions: false-low-MAS é mais aceitável que false-high-single.

**Validação threshold:** medir em 3 bugs reais nas próximas sessões. Ajustar baseado em outcome.

#### D9 — Step counter loop-guard hook (NOVO)

**Evidence:** S6 SOTA-C SWE-Effi — failures consomem 3-4x mais tokens/tempo que sucessos. "API call adds thousands of tokens even when agent fails to make progress." S8: solução é "progress detection + stop rules enforced outside the model."

**Aplicação OLMO:**
- Novo hook: PostToolUse track de:
  - Mesmo Bash command repetido em <N turns
  - Mesmo file edit >M vezes em single phase
  - Architect→Editor→Validator loop iteration count >3
- State: `.claude-tmp/debug-team-state.json` per session
- Trigger: hook returns block + "loop guard triggered: pause and ask Lucas"

#### D10 — Lucas confirm gate Phase 3→4 (REFORÇADO)

Architect produz markdown plan (Phase 3 termina). Antes de Editor aplicar, Lucas valida architecture (custo de patch errado >> 30s validação). Pattern Anthropic taxonomy nível 6 (Evaluator-Optimizer) com humano no loop.

#### D11 — External wrapper model = sonnet (não haiku)

**Evidence:** SOTA-A nota — "Haiku para tasks que requerem mais orientação." Wrapper Gemini/Codex precisa raciocinar prompt construction + parsing + schema validation. Custo wrapper irrelevante (Lucas solo dev), eficacia importa → sonnet.

#### D12 — Allow-list em novos agents (parcial)

**Evidence:** SOTA-B C2 — 7/7 frameworks externos usam allow-list. SOTA-A: ambos suportados. Trade-off: allow-list força declaração explícita (auditabilidade +).

**Aplicação:** novos agents (Frente 2) usarão allow-list `tools:` quando agent tem ≤5 tools necessárias. Allow-list para read-only agents (architect, strategist, archaeologist, adversarial, validator). Editor mantém explícito.

### Tool permissions (D4 revisado)

| Agent | model | brain | tools (allow-list) | Read-only? | Output |
|-------|-------|-------|-------------------|------------|--------|
| debug-symptom-collector | sonnet | Sonnet nativo | Read, Grep, Glob | sim | JSON |
| debug-strategist | opus | Opus 4.7 max nativo | Read, Grep, Glob | sim | JSON |
| debug-archaeologist | sonnet | Gemini 3.1 Pro max via Bash | Bash, Read, Grep, Glob | sim | JSON |
| debug-adversarial | sonnet | Codex max via Bash | Bash, Read, Grep, Glob | sim | JSON |
| debug-architect | opus | Opus 4.7 max nativo | Read, Grep, Glob | sim | **MARKDOWN TEXT** (não JSON) |
| debug-patch-editor | sonnet | Codex Aider via Bash + Edit/Write | Bash, Read, Edit, Write | NÃO | edit-log JSON |
| debug-validator | sonnet | Sonnet nativo + Bash | Bash, Read, Grep | sim | JSON verdict |

### Phase A — FIXES atomicos (commit 1)

#### FIX-1 — `reference-checker.md` color: magenta → purple

Linha 21. Confirmado via Read local. Anthropic spec lista válidos: red, blue, green, yellow, purple, orange, pink, cyan. Purple é o mais próximo visualmente.

#### FIX-2 — `reference-checker.md` mcpServers format

Linhas 10-16 atual: dict (`mcpServers:` → `pubmed:` → fields). Anthropic spec: lista com dashes. Refazer como array notation.

Exemplo correto provável:
```yaml
mcpServers:
  - name: pubmed
    type: stdio
    command: npx
    args: ["-y", "@cyanheads/pubmed-mcp-server"]
    env:
      NCBI_API_KEY: "${NCBI_API_KEY}"
```

(Confirmar formato exato na Anthropic doc se disponível antes de Edit.)

### Phase B — Build agents (sequência recomendada)

Cada agent = 1 commit atomic. Sequência por dependência + risk minimizing:

#### B.1 — `debug-strategist.md` (anchor — zero deps externas)

Opus 4.7 max nativo, READ-ONLY. Recebe collector JSON apenas. Output: strategist-report JSON com first-principles decomposition + ranked hypotheses.

Por que primeiro: zero dependências externas (sem Gemini/Codex CLI), template puro replicável de debug-symptom-collector. Validação fácil.

#### B.2 — `debug-archaeologist.md` (Gemini wrapper)

Sonnet + Bash. Externo: Gemini 3.1 Pro max via gemini CLI.

Wrapper schema:
1. Agent recebe collector JSON
2. Constrói prompt Gemini (max plan, full context: git log -S, blame, CHANGELOG, related issues)
3. `gemini -m gemini-3-1-pro -p "$prompt"` via Bash
4. Parsea output Gemini → schema JSON
5. Retorna archaeology-report JSON

Diferenciador: 1M ctx Gemini lê 50k+ tokens git log de uma vez sem stream.

#### B.3 — `debug-adversarial.md` (Codex wrapper)

Sonnet + Bash. Externo: Codex max via `codex exec`. Mesmo wrapper pattern de archaeologist.

Diferenciador: Codex max treinado em adversarial code review.

#### B.4 — `debug-architect.md` (Aider Architect role — KEY NOVO)

Opus 4.7 max nativo, READ-ONLY. Recebe collector JSON + 1 OR 4 inputs (depending on D8 routing).

**Output: markdown text** (não JSON com tool calls — D7 critical).

Estrutura output:
```markdown
# Patch Architecture Plan

## Root Cause Analysis
[prosa cross-validating sources se MAS path; direct se single path]

## Proposed Changes
### File: path/to/file.ext (linha X-Y)
[prosa descrevendo o que muda e por quê]

### File: ...
[...]

## Risks
- ...

## Rollback Plan
[git revert plan]

## KBP References
- KBP-XX (relevância)

## Validation Pre-Patch
- [ ] check 1
- [ ] check 2
```

Phases internas:
1. Cross-validation if MAS (which root causes appear ≥2 sources)
2. Prioritization
3. Decision (text)
4. Architecture by file (prose, NOT JSON)
5. Risks + rollback
6. Validation checklist

Constraint forte: NUNCA escreve patch, NUNCA emite tool call. Apenas markdown text plan.

#### B.5 — `debug-patch-editor.md` (Aider Editor role)

Sonnet wrapper + Codex Aider via Bash + Edit/Write. ÚNICO agent que escreve.

Recebe architect markdown plan. Translates each "### File:" section para edit operations:
- Codex `codex exec --edit <file> --plan <section>` (ou stdin patch)
- Verifies diff matches architect's prose intent
- Outputs edit-log JSON: files modified, line counts, diff hash

Constraint: edita APENAS files listados em architect plan. Drift = KBP-01 violation.

#### B.6 — `debug-validator.md` (mechanical gates)

Sonnet nativo + Bash. Recebe edit-log + collector.reproduction.

Phases:
1. Run reproduction steps from collector
2. Run lint (project-specific: pre-commit hooks, ruff, etc.)
3. Spot-check regression in related files
4. Verdict

Verdict semantics:
- `pass`: repro fixed + no regressions + lint clean
- `partial`: repro fixed but lint/regression warnings
- `fail`: repro still occurs OR hard regression

Loop semantics: validator emits structured failure signal. Orchestrator (D10) pode loop back to architect com validation report → architect re-thinks → editor re-applies. Max 3 iterations (D9 step counter).

### Phase C — Step counter hook (D9)

Path: `hooks/loop-guard.sh` (new file).

Event: PostToolUse.

Logic:
1. Track session-state in `.claude-tmp/debug-team-state.json`
2. Increment counter for: same Bash repeated, same file edited, same architect→editor→validator phase
3. If threshold exceeded → emit hookSpecificOutput with `permissionDecision: "block"` + reason
4. Lucas can override or pause

Settings.json registration: PostToolUse matcher specific to debug team flow.

### Phase D — Orchestrator skill (`/debug-team`)

`.claude/skills/debug-team/SKILL.md`. Opus 4.7 supervisor pattern (Anthropic).

Workflow:
1. Trigger: `/debug-team` ou contexto bug-shaped
2. Spawn `debug-symptom-collector` → STOP, await JSON
3. Persist collector em `.claude/plans/<bug-slug>.md`
4. **Read `complexity_score`** → branch:
   - score > 75: spawn `debug-strategist` only
   - score ≤ 75: spawn 3 paralelos (archaeologist + adversarial + strategist) em single message multi-Agent
5. Persist outputs in plan file
6. Spawn `debug-architect` with collector + downstream JSONs → markdown plan
7. Persist architect plan + **PAUSE para Lucas confirm** (D10)
8. Lucas approves → spawn `debug-patch-editor` with architect plan
9. Spawn `debug-validator` with edit-log
10. Verdict pass → DONE. Verdict fail → loop back step 6 (max 3 iter, step counter D9).
11. Final report consolidação.

Constraints:
- KBP-17: spawna APENAS os 6 agents listados.
- KBP-29: persiste output em plan file ANTES de próxima phase.
- D9 loop guard ativo a partir de Phase 5 (validate).

### Phase E — Session close

Frente 3 tail tasks:
1. HANDOFF.md S248→S249 (≤50 li, futuro only).
2. CHANGELOG.md S248 entry (≤5 li per anti-drift).
3. BACKLOG.md #60 partial-RESOLVED (mark phases done, retain for /debug-team validation pós-restart).
4. #191 upstream comment — Lucas owns (não autônomo).

---

## Critical files

**Frente 2 — Phase A (FIXES):**
- `C:\Dev\Projetos\OLMO\.claude\agents\reference-checker.md` (L21 color, L10-16 mcpServers)

**Frente 2 — Phase B (NEW agents):**
- `C:\Dev\Projetos\OLMO\.claude\agents\debug-strategist.md`
- `C:\Dev\Projetos\OLMO\.claude\agents\debug-archaeologist.md`
- `C:\Dev\Projetos\OLMO\.claude\agents\debug-adversarial.md`
- `C:\Dev\Projetos\OLMO\.claude\agents\debug-architect.md` ⚡ NOVO (Aider role)
- `C:\Dev\Projetos\OLMO\.claude\agents\debug-patch-editor.md`
- `C:\Dev\Projetos\OLMO\.claude\agents\debug-validator.md`

**Frente 2 — Phase C (infrastructure):**
- `C:\Dev\Projetos\OLMO\hooks\loop-guard.sh` ⚡ NOVO
- `C:\Dev\Projetos\OLMO\.claude\settings.json` (registrar hook)

**Frente 2 — Phase D (orchestrator):**
- `C:\Dev\Projetos\OLMO\.claude\skills\debug-team\SKILL.md` ⚡ NOVO subdir

**Reference template:**
- `C:\Dev\Projetos\OLMO\.claude\agents\debug-symptom-collector.md` — Phase 1 ship S247, mas precisa update para adicionar `complexity_score` (D8)

**State files (Frente E):**
- `C:\Dev\Projetos\OLMO\HANDOFF.md`
- `C:\Dev\Projetos\OLMO\CHANGELOG.md`
- `C:\Dev\Projetos\OLMO\.claude\BACKLOG.md`

**SOTA reference (read-only basis):**
- `C:\Dev\Projetos\OLMO\docs\research\sota-S248-A-anthropic.md` (288 li, 8 URLs)
- `C:\Dev\Projetos\OLMO\docs\research\sota-S248-B-industry.md` (300 li, 22 URLs)
- `C:\Dev\Projetos\OLMO\docs\research\sota-S248-C-empirical.md` (357 li, 30 fontes)
- `C:\Dev\Projetos\OLMO\docs\research\sota-S248-D-synthesis.md` (synthesis matrix)

---

## Verification

**Phase A (FIXES):**
1. Read pós-Edit confirma `color: purple` na linha 21.
2. Read pós-Edit confirma `mcpServers` em formato lista (com dashes).
3. Pre-commit hooks passam.

**Phase B (per agent commit):**
1. Frontmatter válido (name + description + model + tools allow-list).
2. ENFORCEMENT header presente.
3. Output schema declarado (markdown ou JSON conforme D7).
4. Example âncora bug #191 ou outro caso real.

**Phase C (loop-guard hook):**
1. Hook script executa exit 0 em caso normal.
2. State file `.claude-tmp/debug-team-state.json` criado/atualizado.
3. Trigger sintético (3 Bash repetidos) bloqueia com permissionDecision block.

**Phase D (orchestrator) — requer restart CC:**
1. `/agents` lista 7 agents debug (collector + 6 novos).
2. `/help` mostra `/debug-team` skill.
3. Dry-run em bug histórico (#191): collector → routing decision → 1 ou 3 paralelos → architect markdown → Lucas confirm → editor → validator → verdict.

**Phase E (state files):**
1. HANDOFF S248→S249 < 50 li.
2. CHANGELOG S248 ≤ 5 li.
3. BACKLOG #60 marcado partial-RESOLVED.

---

## Risks / open items

- **R1:** SOTA-A teve 1/3 claims fabricated (FIX-3 retract). Outros 2 SOTA reports (B, C) podem ter taxa similar — verificações localmente quando claim impacta Edit.
- **R2:** External CLIs (gemini, codex) precisam estar PATH-ed. Adicionar preflight check em SKILL.md.
- **R3:** Codex CLI Aider-style semantics — confirmar `codex exec --edit` syntax antes de B.5. Possível fallback: stdin patch.
- **R4:** Architect markdown → Editor parse — precisa parser confiável. Codex provavelmente tem mecanismo nativo (Aider pattern). Confirmar antes de B.5.
- **R5:** complexity_score heurística (D8) é guess inicial. Medir em 3 bugs reais antes de calibrar threshold definitivo.
- **R6:** Loop guard hook pode false-positive em legitimate retry (ex: lint fix→re-run lint). Threshold conservador inicialmente.
- **R7:** ci.yml edit lost — B1.2 work não recoverable nesta session. Documentar em HANDOFF S248→S249.

---

## Decisões assumidas (consolidadas)

- **D1** #57 → `additionalContext` (informacional, não-gating). [DONE 2a350d6]
- **D2** #59 L31 reason → texto literal sem path. [DONE 2a350d6]
- **D3** External-API agents → wrapper sonnet + Bash CLI. [REVISADO D11]
- **D4** Tool permissions → allow-list em novos agents. [REVISADO D12]
- **D5** Skill em subdir `.claude/skills/debug-team/SKILL.md`. [KEEP]
- **D6** Deploy KBP-19 (Write→temp→cp) em hooks protected. [DONE 2a350d6]
- **D7** ⚡ NOVO — Aider Architect/Editor pattern (text plan, não JSON). Evidence: S27 SOTA-C 85% pass.
- **D8** ⚡ NOVO — Conditional MAS routing via complexity_score threshold 75. Evidence: S8 SOTA-C β̂=-0.408.
- **D9** ⚡ NOVO — Step counter loop-guard hook (mechanical gate). Evidence: S6 SOTA-C SWE-Effi.
- **D10** ⚡ NOVO — Lucas confirm gate Phase 3→4 (Anthropic taxonomy nível 6 Evaluator-Optimizer com humano).
- **D11** ⚡ NOVO — External wrapper model = sonnet (não haiku). Evidence: SOTA-A guidance.
- **D12** ⚡ NOVO — Allow-list (`tools:`) em novos agents quando ≤5 tools. Evidence: SOTA-B C2 (7/7 frameworks).

---

## Não-escopo (explícito)

- Postar comentário upstream #191 (Lucas owns).
- B1.2 ci.yml fix (revertido externamente — defer S249).
- B3 content/aulas/package.json fixes (defer S249).
- Tier 3-5 documental antigo (Q1/Q2/Q3/Q4 carryover) — sessão futura.
- Carryover S246 schema-level adoptions.
- Letta-style stateful memory (D5 não-aplicável OLMO atual).
- Inspect AI eval harness (sessão dedicada).

---

*Plano S248 refinado por SOTA evidence (60 fontes verificadas). Coautoria: Lucas + Opus 4.7 (Claude Code) + 3 SOTA agents background. 2026-04-25.*
