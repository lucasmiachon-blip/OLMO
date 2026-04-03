# /insights — Weekly Retrospective Report

> Period: 2026-03-31 to 2026-04-03 (Sessions 38-53)
> Analyst: Opus 4.6
> Method: SCAN -> AUDIT -> DIAGNOSE -> PRESCRIBE (per SKILL.md)

---

## Phase 1: SCAN — Incident Extraction

### Sessions Analyzed

16 main sessions (S38-S53), ~60 subagent sessions. Sources: JSONL transcripts, CHANGELOG.md, HANDOFF.md, 28 memory files.

### Incident Log

| # | Session | Category | Description | Severity |
|---|---------|----------|-------------|----------|
| I01 | S49 | correction | Agent guessed `goTo('s-rs-vs-ma')` (string) when API accepts number; also guessed ArrowRight count without considering clickReveals | HIGH |
| I02 | S49 | correction | PMID 35725647 correct but agent fabricated author (Shen instead of Zhao), title, and journal | HIGH |
| I03 | S47 | correction | Agent agreed with 3 radical decisions (kill aside.notes, eliminate MDs, kill Notion DB) without raising a single objection; user had to explicitly invoke anti-sycophancy | HIGH |
| I04 | S50-S51 | error | 4 independent fail-open bugs found by adversarial review: NaN bypasses in mcp_safety.py, parse errors in guard-product-files.sh, file-not-found skips in guard-secrets.sh, corruption resets in smart_scheduler.py | CRITICAL |
| I05 | S50-S51 | error | 3 hooks (guard-secrets.sh, pre-commit.sh, validate-css.sh) scanned working-tree files instead of staged blobs — same bug pattern in 3 independent scripts | CRITICAL |
| I06 | S50 | error | validate-css.sh always returned exit 0 — hook was purely decorative, never actually blocked anything | HIGH |
| I07 | S50 | error | orchestrator.py: validate_mcp_step() was dead code — wired but never called in route_task() | HIGH |
| I08 | S40, S45 | error | Codex GPT-5.4 CSS findings had ~30% false positive rate; agent applied some without verifying cascade context | MEDIUM |
| I09 | S38-S42 | retry | 3 sessions needed continuation due to context rot — quality degraded, memories stopped functioning, responses lost coherence | HIGH |
| I10 | S36-S39 | error | Monorepo migration left ~27 broken paths across hooks/scripts/agents — guards silently bypassed because grep patterns missed new `content/aulas/` prefix | HIGH |
| I11 | S46 | error | 7 Python file I/O calls missing `encoding="utf-8"` causing mojibake on Windows (cp1252 default) | MEDIUM |
| I12 | S40 | retry | Codex doc review (C15) failed twice — skill wrapper hangs on .md files; required workaround via `codex exec` with stdin pipe | MEDIUM |
| I13 | S45 | error | done-gate.js regex too strict (required exact attribute order/quotes in notes) — false failures | LOW |
| I14 | S44 | error | validate-css.sh hardcoded `cirrose.css` instead of dynamic discovery — only scanned one aula | MEDIUM |
| I15 | S53 | error | aggregate_benchmark.py expected `with_skill`/`without_skill` directory names but eval used `old_skill` — script compatibility gap | LOW |

---

## Phase 2: AUDIT — Rule Compliance Matrix

### Rules Inventory (11 rules)

| Rule | Status | Evidence |
|------|--------|----------|
| `anti-drift.md` | **VIOLATED** | I03: agent agreed with radical changes without raising objections (anti-sycophancy sub-rule). I01: acted on guessed parameters instead of verifying. Updated S38 to soften "revert" language. |
| `coauthorship.md` | FOLLOWED | Commits consistently include Co-Authored-By. Notion pages tagged. |
| `design-reference.md` | FOLLOWED | Color semantic rules applied in S42 (--danger hue 25->8), E073-E075 hierarchy in S49. |
| `efficiency.md` | FOLLOWED | Model routing used (subagents for heavy work), batch calls, local-first approach. |
| `mcp_safety.md` | **VIOLATED then FIXED** | I04: NaN bypass, fail-open gates. Fixed S51. Gate was never actually called (I07). Now fail-closed. |
| `notion-cross-validation.md` | FOLLOWED | No Notion write operations during this period. Rule not exercised. |
| `process-hygiene.md` | FOLLOWED | Port-per-aula respected, PID-specific kill used. No `taskkill //IM node.exe` incidents. |
| `qa-pipeline.md` | FOLLOWED | QA gates sequential, attention separation applied in Codex reviews. |
| `quality.md` | **VIOLATED** | I08: CSS findings applied without verifying cascade. I14: hardcoded paths instead of dynamic. I11: missing encoding parameters. |
| `session-hygiene.md` | FOLLOWED | HANDOFF/CHANGELOG updated every session with commits. Enxuto. |
| `slide-rules.md` | FOLLOWED | Assertion-evidence structure maintained, data-animate used, checklist followed. |

### Rule Staleness Check

| Rule | Staleness |
|------|-----------|
| `anti-drift.md` | ACTIVE — exercised frequently, updated S38 |
| `coauthorship.md` | ACTIVE — but `Formato por Contexto` section could expand for living HTML |
| `design-reference.md` | ACTIVE — updated with E073-E075, chroma floor |
| `efficiency.md` | STALE-ISH — very generic, no mention of subagent delegation or eval loop batching |
| `mcp_safety.md` | ACTIVE — exercised and bugs found/fixed S50-S51 |
| `notion-cross-validation.md` | DORMANT — not exercised this week. Paths frontmatter correct. |
| `process-hygiene.md` | ACTIVE — ports used correctly |
| `qa-pipeline.md` | ACTIVE — QA gates used in Codex review framing |
| `quality.md` | ACTIVE but THIN — lacks specifics on encoding, dynamic paths, cascade verification |
| `session-hygiene.md` | ACTIVE — followed consistently |
| `slide-rules.md` | ACTIVE — comprehensive, recently updated |

### Skill Audit

| Skill | Used This Week | Issues |
|-------|---------------|--------|
| research | YES (S47-S49) | Working well. Validated end-to-end. |
| deep-search | YES (S46) | v2.1 eval showed Gemini PMID variability (not skill fault) |
| skill-creator | YES (S46, S53) | Eval loop working. aggregate_benchmark.py naming mismatch (I15) |
| nlm-skill | YES (S53) | Rewritten to 191 lines, 100% pass rate |
| dream | YES (S43, S50, S51) | Run 5, 10, 11. Context rot issue in S41 (dream didn't consolidate well in long sessions) |
| insights | NO | First run. This report. |
| evidence | NO | Not exercised independently this week |
| slide-authoring | NO | Not exercised this week (manual slide work in S49) |
| review | YES (S50-S51) | Adversarial pipeline validated |

---

## Phase 3: DIAGNOSE — Categorized Findings

### Prioritized Finding List

| Priority | Finding | Category | Sessions | Fix Target |
|----------|---------|----------|----------|------------|
| **1** | Fail-open security gates — NaN bypass, parse-error allow, missing-file skip | `PATTERN_REPEAT` | S50-S51 (4 independent instances) | rules + hook enforcement |
| **2** | Working-tree vs staged blob — 3 hooks scanned wrong source | `PATTERN_REPEAT` | S50-S51 (3 independent scripts) | rules + hook template |
| **3** | Parameter guessing without reading API | `RULE_VIOLATION` | S49 (goTo + ArrowRight) | strengthen anti-drift rule |
| **4** | PMID metadata fabrication (correct PMID, wrong author/title/journal) | `PATTERN_REPEAT` | S45-S49 (~56% error rate) | strengthen design-reference rule |
| **5** | Anti-sycophancy failure — agreeing too quickly with radical changes | `RULE_VIOLATION` | S47 | strengthen anti-drift rule |
| **6** | Context rot in long sessions | `PATTERN_REPEAT` | S38-S42 (3 continuation sessions) | add rule or hook |
| **7** | Windows encoding (cp1252 default) | `PATTERN_REPEAT` | S46 (7 instances) | add to quality rule |
| **8** | CSS cascade false positives from Codex/external review | `PATTERN_REPEAT` | S40, S45, S51 (~30% CSS FP) | add to quality rule |
| **9** | Hardcoded paths after monorepo migration | `PATTERN_REPEAT` | S36-S44 (~27 broken paths) | add to quality rule |
| **10** | Dead code shipped (validate_mcp_step never called) | `RULE_GAP` | S50 | new rule clause |
| **11** | Hook exit-code was always 0 (decorative hook) | `HOOK_GAP` | S50 | hook test protocol |
| **12** | efficiency.md too generic | `RULE_STALE` | N/A | update rule |

---

## Phase 4: PRESCRIBE — Proposed Changes

### [PATTERN_REPEAT] #1: Fail-Open Security Gates

**Evidence:** S50-S51 — NaN bypasses mcp_safety.py thresholds (IEEE 754), guard-product-files.sh parse error -> exit 0, guard-secrets.sh file-not-found -> skip, smart_scheduler.py corruption -> reset to zero. All 4 fixed in commit fbea9e7.

**Root cause:** No explicit rule requiring fail-closed design. Developers (human and AI) default to fail-open because it "works" in the happy path.

**Proposed fix:**
- **Target:** `.claude/rules/quality.md`
- **Change:** Add fail-closed mandate
- **Draft:**
```markdown
## Fail-Closed Gates
- Security/safety code: error/unexpected input -> BLOCK (not allow)
- Numeric comparisons: guard NaN/Inf BEFORE business logic (`math.isnan()`, `math.isinf()`)
- Shell hooks: empty input or parse failure -> exit non-zero
- File I/O in safety paths: corruption -> safe default (not zero/empty)
```

---

### [PATTERN_REPEAT] #2: Working-Tree vs Staged Blob in Hooks

**Evidence:** S51 — guard-secrets.sh, pre-commit.sh, validate-css.sh all used `cat "$file"` or `grep "$file"` instead of `git show ":$file"`. Same bug, 3 independent scripts.

**Root cause:** No hook template or code review checklist enforcing staged-blob reads.

**Proposed fix:**
- **Target:** `.claude/rules/quality.md`
- **Change:** Add git hook development rule
- **Draft:**
```markdown
## Git Hook Development
- Read staged content: `git show ":$file"` (NEVER `cat "$file"`)
- List staged files: `git ls-files` (NEVER `find` or `ls`)
- Iterate safely: `while IFS= read -r file` (NEVER `for file in $VAR`)
- Detect symlinks: `git ls-files -s "$file" | grep "^120"`
```

---

### [RULE_VIOLATION] #3: Parameter Guessing

**Evidence:** S49 — Agent called `goTo('s-rs-vs-ma')` assuming string param, but API accepts number. Agent pressed ArrowRight 4 times without considering clickReveals. User flagged explicitly.

**Root cause:** anti-drift.md says "verify before acting" but doesn't specifically call out API parameter verification.

**Proposed fix:**
- **Target:** `.claude/rules/anti-drift.md`
- **Change:** Add explicit parameter verification clause to Verification section
- **Draft (add after step 5):**
```markdown
Additional rules:
...
- API/function call: read the function signature and parameter types BEFORE calling. NEVER guess parameter types or values from naming convention alone.
- Stateful navigation (slides, pages): use loops with state verification, not fixed counts.
```

---

### [PATTERN_REPEAT] #4: PMID Metadata Fabrication

**Evidence:** S45-S49 — ~56% error rate on LLM-generated PMIDs (5/9 historical). New pattern in S49: PMID 35725647 was CORRECT but author/title/journal were fabricated (Shen -> Zhao, Milbank Q -> Eur J Med Res).

**Root cause:** design-reference.md requires PMID verification but the 3-field cross-reference protocol (author + title + journal) is only in memory, not in the rule.

**Proposed fix:**
- **Target:** `.claude/rules/design-reference.md`
- **Change:** Add 3-field verification protocol to PMID rules section
- **Draft (add to the PMIDs bullet):**
```markdown
- **PMIDs:** NUNCA usar PMID de LLM sem verificar em PubMed. Marcar `[CANDIDATE]` ate verificado. Taxa de erro observada: **56% (5/9)**. Verificacao = 3 campos: (1) primeiro autor, (2) titulo, (3) journal. PMID certo com metadata fabricada e padrao real (S49).
```

---

### [RULE_VIOLATION] #5: Anti-Sycophancy — Agreeing Too Quickly

**Evidence:** S47 — Agent agreed with 3 radical decisions (kill aside.notes, eliminate MDs, kill Notion DB) without raising objections. User explicitly invoked anti-sycophancy. Only when challenged did agent identify real risks.

**Root cause:** anti-drift.md covers scope discipline and verification but doesn't explicitly address "radical/structural changes require pushback."

**Proposed fix:**
- **Target:** `.claude/rules/anti-drift.md`
- **Change:** Add structural change clause
- **Draft (add to Scope discipline section):**
```markdown
- Before agreeing with structural/architectural changes (deprecate feature, kill DB, rewrite workflow): list at least 1 concrete risk and 1 question Lucas must answer. "Concordo" only after thinking critically, not before.
```

---

### [PATTERN_REPEAT] #6: Context Rot in Long Sessions

**Evidence:** S38-S42 — 3 sessions needed continuations. S41 explicitly noted "Context rot e dream/memorias nao funcionando." Responses became repetitive, tool calls redundant, recent decisions forgotten.

**Root cause:** No rule enforces proactive context management. Session-hygiene.md only covers HANDOFF/CHANGELOG at session end, not mid-session mitigation.

**Proposed fix:**
- **Target:** `.claude/rules/session-hygiene.md`
- **Change:** Add context health section
- **Draft:**
```markdown
## Context Health
- Long sessions (>60 min or >100 tool calls): commit + update HANDOFF before degradation
- Heavy subwork (Codex reviews, QA runs): delegate to subagents to preserve main context
- Signals of context rot: repetitive responses, forgotten recent decisions, redundant tool calls -> /clear + reload HANDOFF
- Dream: run in fresh window, never at end of exhausted session
```

---

### [PATTERN_REPEAT] #7: Windows Encoding (cp1252)

**Evidence:** S46 — 7 instances of file I/O missing `encoding="utf-8"` in eval-viewer, causing mojibake on accented Portuguese text (Windows default is cp1252).

**Root cause:** quality.md doesn't mention platform-specific encoding requirements.

**Proposed fix:**
- **Target:** `.claude/rules/quality.md`
- **Change:** Add encoding rule
- **Draft:**
```markdown
- Python file I/O: always `encoding="utf-8"` in `open()`, `read_text()`, `write_text()` (Windows default cp1252 = mojibake)
```

---

### [PATTERN_REPEAT] #8: CSS Cascade False Positives

**Evidence:** S40, S45 — ~30% FP rate on CSS findings from Codex GPT-5.4. Examples: #74 padding-right flagged as double offset (actually CSS override), #65 achromatic color-mix flagged as bug (intentional E059).

**Root cause:** No explicit rule for validating external CSS findings against cascade context.

**Proposed fix:**
- **Target:** `.claude/rules/quality.md`
- **Change:** Add external review validation clause
- **Draft:**
```markdown
- External code review (Codex, GPT, etc): CSS findings require cascade verification before implementing. Check: (1) higher-specificity selector overriding? (2) per-slide override? (3) documented as intentional (E-code)?
- Trust hierarchy: JS/Python findings > Shell findings > CSS findings (~30% CSS FP historical)
```

---

### [RULE_GAP] #10: Dead Code Detection

**Evidence:** S50 — orchestrator.py had validate_mcp_step() wired but never called in route_task(). Dead validation code = false sense of security.

**Root cause:** No rule about verifying that safety code is actually reachable.

**Proposed fix:**
- **Target:** `.claude/rules/quality.md`
- **Change:** Add call-site verification
- **Draft:**
```markdown
- Safety/validation functions: after writing, verify at least 1 call site exists and executes. Dead validation code = false security.
```

---

### [HOOK_GAP] #11: Hook Exit Code Testing

**Evidence:** S50 — validate-css.sh always returned exit 0. Hook existed but never blocked anything. Decorative.

**Root cause:** No testing protocol for hooks. They're written and trusted without verification.

**Proposed fix:**
- **Target:** `.claude/rules/process-hygiene.md`
- **Change:** Add hook testing clause
- **Draft:**
```markdown
## Hook Testing (after writing/modifying)
- Feed known-bad input and verify exit non-zero
- Feed known-good input and verify exit zero
- Check actual exit code with `echo $?` after manual run
```

---

### [RULE_STALE] #12: efficiency.md Too Generic

**Evidence:** Rule is 5 lines and doesn't mention subagent delegation, eval loop batching, or model routing specifics that are now standard practice.

**Proposed fix:**
- **Target:** `.claude/rules/efficiency.md`
- **Change:** Expand with learned practices
- **Draft:**
```markdown
# Regra: Eficiencia de API

Antes de qualquer API call:
1. Verifique cache local primeiro
2. Tente resolver localmente (regex, parsing, busca em arquivos)
3. Se precisar de API, use o modelo mais barato que resolve
4. Combine perguntas relacionadas em 1 chamada (batch)
5. Registre o custo no BudgetTracker

## Subagents & Context
- Heavy work (reviews, QA, research): delegate to subagents to preserve main context
- Eval loops: batch parallel runs (3+ configs simultaneously)
- Model routing: trivial->Ollama | simple->Haiku | medium->Sonnet | complex->Opus
```

---

## Evolution Metrics

No previous /insights report exists. This is the baseline.

### Baseline Metrics (S38-S53)

| Metric | Value |
|--------|-------|
| Sessions analyzed | 16 |
| Total incidents identified | 15 |
| CRITICAL severity | 2 (both fixed S51) |
| HIGH severity | 7 |
| MEDIUM severity | 4 |
| LOW severity | 2 |
| PATTERN_REPEAT (3+ sessions) | 8 (53%) |
| RULE_VIOLATION | 3 |
| RULE_GAP | 1 |
| RULE_STALE | 1 |
| HOOK_GAP | 1 |
| Rules followed consistently | 7/11 (64%) |
| Rules violated | 3/11 (27%) |
| Rules dormant/stale | 1/11 (9%) |

### Top 3 Systemic Issues (most impactful)

1. **Fail-open by default** — 4 independent instances across security code. Now fixed, needs rule to prevent recurrence.
2. **Parameter/metadata fabrication** — Agent guesses API params and LLM fabricates PMID metadata. Two faces of the same problem: acting before verifying.
3. **Context rot** — 3 sessions required continuations. Productivity loss estimated at ~20% of affected sessions.

### What Improved This Week

- Adversarial review pipeline validated (review -> validate -> fix). ~8% FP rate, efficient.
- Living HTML workflow confirmed end-to-end. Evidence-first is now standard.
- Hook infrastructure dramatically improved: 5 hooks tested and verified, 2 vestigial removed.
- nlm-skill rewrite: 73% line reduction, 100% eval pass rate.
- All 265 cumulative Codex findings (4 rounds) resolved. Git audit clean.

---

## Summary for Lucas

**Erros que se repetiram:**
1. Fail-open em gates de seguranca (NaN bypass, exit 0 em hooks) — 4 instancias independentes
2. Hooks liam working-tree ao inves de staged blob — 3 scripts com o mesmo bug
3. Fabricacao de metadata de PMID (autor/titulo/journal errados) — taxa historica 56%
4. Chute de parametros sem ler a API — goTo(string) vs goTo(number)
5. Context rot em sessoes longas — 3 sessoes precisaram continuacao

**Regras violadas:**
1. `anti-drift.md` — chute de parametros + concordancia rapida demais com mudancas radicais
2. `quality.md` — CSS aplicado sem verificar cascade, encoding faltando, paths hardcoded
3. `mcp_safety.md` — gates fail-open (corrigido S51)

**O que mudar (propostas, decisao e sua):**
1. Adicionar clausula fail-closed a quality.md (previne NaN/parse/corruption)
2. Adicionar template de git hook a quality.md (previne working-tree vs staged)
3. Reforcar anti-drift.md com verificacao de parametros + resistencia a mudancas radicais
4. Mover protocolo 3-campos PMID da memoria para design-reference.md
5. Adicionar gestao de contexto a session-hygiene.md
6. Adicionar encoding UTF-8 obrigatorio a quality.md
7. Adicionar validacao de cascade CSS a quality.md
8. Expandir efficiency.md com praticas de subagent e eval loop

---

> Report: `.claude/skills/insights-workspace/iteration-1/weekly-retrospective/with_skill/outputs/report.md`
> Coautoria: Lucas + Opus 4.6 | 2026-04-03
