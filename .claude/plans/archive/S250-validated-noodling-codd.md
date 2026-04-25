# S250 — todos-em-batches

> **Plan file** | Sessão S250 | 2026-04-25 | Coautoria: Lucas + Opus 4.7
> **Continuação de S249** (`.claude/plans/archive/S249-partitioned-jumping-summit.md`).
> Foco escolhido: "todos em batches" — 6 pendências HANDOFF S249→S250 sequenciadas.

---

## Context

S249 fechou orchestrator + loop-guard + KBP-37 (3 commits ship-able), mas Phase 4 e2e ficou bloqueada por Agent tool registry stale (resolved post-quit-CC: `claude agents` CLI agora lista 21 active inc 7 debug-*). HANDOFF S249→S250 enumera 6 pendências em priority order. Lucas explicitou estratégia "todos em batches" — sequenciar tudo numa sessão só, aceitando que Batch C (audit) é multi-session por natureza e ship apenas Phase 1 (research + decision matrix).

**Por que multi-batch importa:** B1.2 (CI truth) + B3 (package.json deadlinks) são pré-requisitos do benchmark plan B0-B3 (BACKLOG #61). Sem eles, expansão de #62 viola "freeze de expansão até drifts B1-B3 resolvidos" (decision #1 do benchmark plan). E2e dry-run (Batch B) fecha BACKLOG #60 fully validated. Audit (Batch C) destrava #62.

---

## Estado atual (input para S250)

| Item | Estado | Notas |
|------|--------|-------|
| `claude agents` CLI | 21 active inc 7 debug-* | Daemon-restart resolved registry |
| `f4a81ca..a86368e` | 4 commits S249 chain | Sobre `a86368e` S248-close |
| `hooks/loop-guard.sh` | Operacional advisory-mode | Self-disable via `.debug-team-active` flag |
| `.claude/skills/debug-team/SKILL.md` | 11-step orchestrator | Steps 0-11 validados read-through |
| `.claude/plans/debug-hooks-nao-disparam.md` | Phases pending | Collector partial, abandoned mid-flow S249 |
| `.claude-tmp/upstream-comment-191.md` | Pronto, 43 li | Lucas valida + posta via `gh issue comment` |
| `.github/workflows/ci.yml` L32 | Stale: `mypy agents/ subagents/ config/` | Purged S232 — fix `mypy scripts/ config/` |
| `content/aulas/package.json` L29-30 | `research:cirrose|metanalise` → `content-research.mjs` removido S106 | Echo-redirect pattern já existe L17 (lint:narrative-sync) |
| Inventory audit baseline | 16 agents + 19 skills + 32 hooks | Para Batch C 3-model research |
| Codex CLI | 0.118.0, gpt-5.5 broken | Requer `codex update` antes Batch C |

---

## Batch sequence (5 batches, ~5-6 commits ship-able)

```
Batch A — Quick wins (B1.2 + B3)              ~20min  | 2 commits
Batch B — e2e /debug-team dry-run              ~60min  | 1 commit (plan file + verdict)
Batch C — 3-model audit research (Phase 1)     ~45min  | 1 commit (plan canonical)
Batch D — #191 upstream comment validate+post  ~10min  | 0 commit (Lucas-owned post)
Batch E — Session close                        ~25min  | 1 commit (HANDOFF/CHANGELOG/KBPs)
```

Total ~2.5h. Cada commit independente, ship-able, rollback simples.

---

## Batch A — B1.2 + B3 quick fixes

### A.1 — `.github/workflows/ci.yml` L32-35 (B1.2)

**Path:** `C:\Dev\Projetos\OLMO\.github\workflows\ci.yml`

**Edit L32** (single line):
```yaml
# antes:
        run: uv run mypy agents/ subagents/ config/
# depois:
        run: uv run mypy scripts/ config/
```

**Edit L33-35** (drop pytest step — `tests/` purged S232, sem test files tracked):
```yaml
# antes (3 linhas):
      - name: Tests
        run: uv run pytest -q
# depois: bloco removido completamente
```

**Justificativa:** benchmark plan §B1 explicita "CI ainda roda mypy agents/subagents/config/ apesar do repo declarar runtime Python purgado" — fix alinha CI ao repo real (DORA CI truth practice). Pytest sem tests/ tracked = false-green check.

**Verification:**
```bash
gh workflow run ci.yml --ref main 2>&1 | tail -10
# OR localmente:
uv run mypy scripts/ config/  # deve passar
```

**Commit:** `fix(S250): B1.2 ci.yml mypy paths align repo real (purged agents/subagents/) + drop pytest`

### A.2 — `content/aulas/package.json` L29-30 (B3)

**Path:** `C:\Dev\Projetos\OLMO\content\aulas\package.json`

**Pattern:** seguir L17 precedente (lint:narrative-sync archived S144):
```json
"lint:narrative-sync": "echo 'ARCHIVED S144 — see scripts/_archived/lint-narrative-sync.js'"
```

**Edit L29-30** (2 linhas):
```json
// antes:
"research:cirrose": "node scripts/content-research.mjs --aula cirrose",
"research:metanalise": "node scripts/content-research.mjs --aula metanalise"
// depois:
"research:cirrose": "echo 'REMOVED S106 — use /research skill (6 pernas)'",
"research:metanalise": "echo 'REMOVED S106 — use /research skill (6 pernas)'"
```

**Justificativa:** `content-research.mjs` foi removido S106 (CLAUDE.md aulas L46). Echo-redirect preserva muscle-memory (`npm run research:cirrose` ainda exit 0), sinaliza death-state, aponta substituto (`/research` skill). KBP-15 negativa: deletar key silenciosamente quebra `package.json` consumers.

**Verification:**
```bash
cd content/aulas && npm run research:cirrose 2>&1
# Expected: prints "REMOVED S106 — use /research skill (6 pernas)" + exit 0
```

**Commit:** `fix(S250): B3 package.json dead research scripts → echo-redirect /research skill (S144 pattern)`

---

## Batch B — e2e /debug-team dry-run

### B.0 — Pre-flight

**Targets candidatos** (Lucas escolhe):
1. **`hooks-que-nao-disparam`** — collector partial existe em `.claude/plans/debug-hooks-nao-disparam.md` (Phases pending). Reabrir com clean state. Pro: bug real, multi-file. Con: investigation aberta sem reproducível claro.
2. **`ci-mypy-paths-stale`** — Batch A.1 sem fix manual; usar como input. Pro: bug minúsculo + verificável + diagnóstico já feito (treino do orchestrator). Con: trivial demais; complexity_score esperado ≤30 → MAS path overkill.

**Recomendação:** target 1 (`hooks-que-nao-disparam`) — bug real testa orchestrator em ambiguidade verdadeira. Treino com bug trivial (target 2) = cargo cult. Lucas confirma.

### B.1 — Activate /debug-team

```bash
# Lucas digita no chat:
/debug-team hooks-que-nao-disparam
```

Step 0 pre-flight valida 7 agents present. Step 1 ativa flag + state file. Steps 2-9 sequenciais conforme SKILL.md (collector → routing → diagnosis → architect → Lucas confirm gate D10 → editor → validator + loop max 3).

### B.2 — Phase tracking

Plan file `.claude/plans/debug-hooks-nao-disparam.md` é o source-of-truth — cada Phase escreve seu output ANTES de spawn da próxima (KBP-29 persistence). Eu (orchestrador) faço persist edits, agentes só retornam JSON/markdown.

### B.3 — Verification

**Mid-flow:** loop-guard hook deve emitir advisory se Bash repeated ≥4 OU file edited ≥5. Validar via `cat .claude-tmp/debug-team-state.json` em phase transitions.

**End-state success:**
- Verdict `pass` ou `partial+Lucas-accept`
- Plan file todas as 5 Phases preenchidas
- Metrics §validator_loop_iter ≤ 3
- `.claude-tmp/.debug-team-active` flag removido (Step 10 cleanup)

**End-state failure:**
- Verdict `fail` + 3 iterations exhausted → escalation Lucas (per Step 9 verdict branch fail)
- Documentar gaps observados em CHANGELOG (treino fornece feedback ao orchestrator design)

### B.4 — Commit

`docs(S250): B Phase 4 e2e /debug-team dry-run em hooks-que-nao-disparam — verdict <pass|partial|fail>`

Commit single mesmo se verdict ≠ pass — closure documenta resultado real (BACKLOG #60 fully validated).

---

## Batch C — 3-model audit research (Phase 1 only)

### C.0 — Scope clarification

**S250 ship apenas Phase 1**: research outputs + decision matrix canonical. Phases 2+ (execução merges/cuts) = S251+.

**Decisão #1 benchmark plan:** "freeze de expansão até B1-B3 closed". Batch A fecha B1.2 + parte de B3. Batch C não viola freeze pois é **research + planning**, não criação de novos componentes.

### C.1 — Codex CLI update (pre-req)

```bash
codex update 2>&1 | tail -10
# verify version bump:
codex --version
# test gpt-5.5:
echo "ping" | codex exec --model gpt-5.5 -- 2>&1 | head -5
```

Se `codex update` falhar OU gpt-5.5 ainda broken → fallback Perplexity (`perplexity-research.mjs`). Document fallback decision em plan.

### C.2 — Audit prompt skeleton (unified — same input para 3 models)

**Goal:** identificar redundancy + SOTA gaps em OLMO control plane (16 agents + 19 skills + 32 hooks).

**Input bundle (anexar via prompt):**
- `claude agents` output (16 project agents + 4 plugin/built-in)
- `ls .claude/skills/` + grep `name:` em cada SKILL.md (19 skills)
- `ls .claude/hooks/ hooks/` (32 hooks)
- Last 3 sessions HANDOFF excerpts (S247, S248, S249) — context atual
- BACKLOG #62 statement: "muitos podem ser merged, muitos longe do SOTA"

**Output schema (mesmo para 3 models):**
```json
{
  "model": "<opus-4.7|gemini-3.1-deep-think|chatgpt-5.5>",
  "analysis_date": "2026-04-25",
  "merge_candidates": [
    {
      "components": ["agent-A", "agent-B"],
      "rationale": "<why merge>",
      "evidence_local": "<grep/file ref OR null>",
      "confidence": "high|medium|low",
      "action": "ADOPT|MERGE|CUT|DEFER"
    }
  ],
  "sota_gaps": [
    {
      "component": "<agent/skill/hook>",
      "gap": "<what SOTA pattern missing>",
      "source": "<paper/anthropic-doc/null>",
      "priority": "P0|P1|P2"
    }
  ],
  "no_action_items": [
    "<components correctly scoped, no change needed>"
  ]
}
```

**Output schema enforced** = Opus orchestrator pode programmatically diff (KBP-12 research-without-output-schema antidote).

### C.3 — 3-model parallel calls

```bash
# Opus 4.7 — me/orquestrador (eu mesmo, prompt internal)
# (Não é Bash call — é parte do meu raciocínio com prompt skeleton aplicado)

# Gemini 3.1 Deep Think — via API node script
node .claude/scripts/gemini-research.mjs --prompt-file .claude-tmp/audit-prompt-S250.md --model deep-think --output .claude-tmp/audit-gemini-output.json

# ChatGPT 5.5 — via Codex CLI exec
codex exec --model gpt-5.5 --input-file .claude-tmp/audit-prompt-S250.md --output .claude-tmp/audit-chatgpt-output.json
```

3 outputs JSON com mesmo schema. Tempo esperado: Opus ~5min reasoning, Gemini 60s deep think, ChatGPT ~30s. Plus tempo de Bash spawn — total ~8-10min.

**Fallback se ChatGPT 5.5 broken:**
```bash
node .claude/scripts/perplexity-research.mjs --prompt-file <...> --output .claude-tmp/audit-perplexity-output.json
```

Perplexity 3rd voice = ainda 3-model, mas perspectiva web-search-augmented (diferente role).

### C.4 — Opus orchestration (synthesis)

Eu (Opus 4.7) leio 3 outputs JSON e produzo `.claude/plans/audit-merge-S251.md`:

1. **Cross-validate merge_candidates:**
   - Convergência 3/3 = high confidence ADOPT
   - Convergência 2/3 = medium, requer KBP-32 spot-check antes de adopt
   - Convergência 1/3 = filter como FP candidate (não descarta, mas flag explícito)
   - Divergence: rationale conflict — Opus arbitra citando evidence local

2. **Spot-check obrigatório (KBP-32):** cada claim "agent-X é AUSENTE / redundant" exige 1 Grep/Read de confirmação. Sem spot-check = não escala para ADOPT.

3. **Output canonical:** `.claude/plans/audit-merge-S251.md` com:
   - Section 1: Merge matrix (rows=candidates, cols=opus/gemini/chatgpt+convergence+spot-check)
   - Section 2: SOTA gaps prioritized P0/P1/P2
   - Section 3: ADOPT-NOW (convergence 3/3 + cheap+verified) — execute next session
   - Section 4: DEFER (medium confidence ou requires deeper research)
   - Section 5: CUT (1/3 confidence ou refuted by spot-check)

### C.5 — BACKLOG #62 update + commit

Edit `.claude/BACKLOG.md` #62 — bump status + reference plan canonical:
```
| 62 | process | L | [S249 Lucas-request, S250 Phase 1 done] Audit + merge ... | Plan: `.claude/plans/audit-merge-S251.md`. Phase 1 (3-model research + decision matrix) DONE. Phases 2+ (execution) target S251+. ADOPT-NOW count: <N>. DEFER: <M>. |
```

**Commit:** `feat(S250): C Batch — 3-model audit research (opus+gemini+chatgpt) → decision matrix S251 exec`

---

## Batch D — #191 upstream comment

### D.1 — Read + Lucas validate

Lucas re-lê `.claude-tmp/upstream-comment-191.md` (43 li, GitHub-issue ready). Ajusta se necessário.

### D.2 — Post via gh

```bash
gh issue comment 191 -R openai/codex-plugin-cc -F .claude-tmp/upstream-comment-191.md
```

**Lucas-owned:** post visível externamente (KBP-10 destrutivo-shared-state) — Lucas confirma antes de eu rodar `gh`.

### D.3 — No commit (external action)

Comment posted, sem commit local. Documentar em CHANGELOG S250 como "external action: #191 comment posted".

---

## Batch E — Session close

### E.1 — KBP-38 candidate commit (S249→S250 learning)

**Adicionar `.claude/rules/known-bad-patterns.md`:**
```
## KBP-38 Window-restart ≠ daemon-restart pra Agent tool registry
→ cc-gotchas.md §Agent tool registry refresh
```

**Adicionar `.claude/rules/cc-gotchas.md`:**
```
## Agent tool registry refresh
- `claude agents` CLI = canonical truth (5s).
- `/agents` UI = display scrollable (verifica Up arrow se >9 listados).
- Agent tool in-session = separate registry, refresh apenas em **daemon-level Ctrl+Q + reopen** (window close-and-reopen NÃO basta).
- Diagnóstico: `claude agents` antes de qualquer hypothesis "silently dropped" (KBP-32 spot-check).
- Origem: S249 Phase 4 e2e blocked (window-restart insuficiente).
```

### E.2 — KBP-31 sweep

Grep CHANGELOG.md S249-S250 entries por "KBP candidate" / "lint rule candidate" → schedule commit antes session close. Já identificado: KBP-38 (commit em E.1).

### E.3 — HANDOFF + CHANGELOG + BACKLOG

**HANDOFF.md:** Edit (não Write) — substituir S249 hand-off por S250 hand-off (pendências only, ~50 linhas, no history). Items:
- Batch A done? B1.2 + B3 closed status
- Batch B verdict pass/partial/fail
- Batch C plan canonical reference
- Batch D #191 posted
- Batch E close metrics
- Pendências S250→S251: principalmente Batch C Phase 2+ (execution merges) + grade-v2 deadline 30/abr

**CHANGELOG.md:** Append S250 section — 1 line per change + 5-line aprendizados/residual block (per anti-drift §Session docs).

**BACKLOG.md:** Updates #60 (B Phase 4 done), #61 (B1 partial), #62 (audit Phase 1 done).

**Commit final:** `docs(S250): Batch E close — HANDOFF/CHANGELOG/BACKLOG + KBP-38 commit + plan archive`

### E.4 — Plan archive

Move `.claude/plans/validated-noodling-codd.md` → `.claude/plans/archive/S250-validated-noodling-codd.md` (mantém slug curto + S-prefix per S225 convention).

---

## Risks + Rollback

| Batch | Risk | Mitigation | Rollback |
|-------|------|-----------|----------|
| A.1 | mypy fails em `scripts/` (não rodava antes) | Rodar `uv run mypy scripts/ config/` localmente ANTES de commit; se broken, ship revert hint em CHANGELOG | `git revert <sha>` — 1 line revert |
| A.2 | Echo command quebra em alguma plataforma | Pattern já provado L17 (lint:narrative-sync) — same syntax | `git revert <sha>` |
| B | /debug-team trava ou agente falha | Loop-guard advisory + max 3 iterations + abort path Step 10 | Cleanup `.debug-team-active` flag + state file |
| C.1 | `codex update` falha | Fallback Perplexity (`perplexity-research.mjs`) — 2-of-3 ainda | Document fallback em plan |
| C.4 | Spot-check refuta majority claim | Opus arbitra: evidence local > model consensus (KBP-32) | Audit matrix flagga divergence explícito |
| D | gh post wrong-tone ou mistake | Lucas valida ANTES de post | `gh issue comment <id> --delete` se for o caso |

---

## Verification per batch (consolidated)

| Batch | Command | Expected |
|-------|---------|----------|
| A.1 | `uv run mypy scripts/ config/` | Exit 0 |
| A.2 | `cd content/aulas && npm run research:cirrose` | Echo + exit 0 |
| B | Plan file 5 phases preenchidas + verdict reported | Closure documented |
| C.3 | 3 JSON outputs válidos same schema | jq parse all 3 sem erro |
| C.4 | Plan canonical S251 audit-merge written | File >100 li com 5 sections |
| D | `gh issue view 191 -R openai/codex-plugin-cc` | Comment visível |
| E | `git log --oneline -10` | 5-6 commits S250 chain |

---

## Critical files modified (full list)

**Edits:**
- `.github/workflows/ci.yml` (Batch A.1)
- `content/aulas/package.json` (Batch A.2)
- `.claude/plans/debug-hooks-nao-disparam.md` (Batch B persistência multi-phase)
- `.claude/rules/known-bad-patterns.md` (Batch E.1 KBP-38)
- `.claude/rules/cc-gotchas.md` (Batch E.1 Agent tool registry refresh)
- `.claude/BACKLOG.md` (Batch C.5 #62 + Batch E.3 #60/#61)
- `HANDOFF.md` (Batch E.3, Edit-not-Write per anti-drift)
- `CHANGELOG.md` (Batch E.3 append)

**Writes (new):**
- `.claude-tmp/audit-prompt-S250.md` (Batch C.2 — temp, not committed)
- `.claude-tmp/audit-{gemini,chatgpt|perplexity}-output.json` (Batch C.3 — temp)
- `.claude/plans/audit-merge-S251.md` (Batch C.4 — canonical, committed)
- `.claude/plans/archive/S250-validated-noodling-codd.md` (Batch E.4 — move from active)

**External actions (no commit):**
- `gh issue comment 191 -R openai/codex-plugin-cc -F ...` (Batch D — Lucas confirms)

---

## Dependencies + ordering rationale

```
A.1 ─┐
A.2 ─┴── B ── C ── D ── E
```

- **A before B/C:** B1.2 + B3 são "freeze blockers" do benchmark plan; release them first.
- **B before C:** e2e validation feeds confidence em todo orchestrator pattern (positive evidence para C audit decisions).
- **C before D:** D é Lucas-owned post; non-blocking pra plano.
- **E last:** session close consolidation depends on all above outputs.

**Parallelizable:** A.1 + A.2 são independentes (poderiam ir paralelos), mas commits sequenciais clarify diff. Within Batch C, c.3 calls are parallel (single-message multi-Bash).

---

## Next session pointers (S251)

- **Batch C Phase 2+:** execução merges/cuts conforme `.claude/plans/audit-merge-S251.md` ADOPT-NOW section.
- **grade-v2 scaffold C6:** deadline 30/abr T-5d (após S250).
- **shared-v2 Day 2/3:** PAUSADO em `.claude/plans/S239-C5-continuation.md`.
- **QA editorial metanalise:** 16 slides pendentes (3/19 done).

---

Coautoria: Lucas + Opus 4.7 (Claude Code) | S250 todos-em-batches | 2026-04-25
