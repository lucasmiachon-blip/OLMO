# Plan S198: Ultima_infra_dia — P0 Execution

## Context

S197 finalizou /insights (P001-P003 drafts) + Gemini parameter research (5 fontes Google).
Tudo documentado, nada executado. Esta sessao aplica os 3 steps do P0 na sequencia.

## Step 1: /insights P001-P003 (rules fixes)

3 edits pontuais em rules auto-loaded. Sem risco — sao docs, nao codigo.

### P001 — anti-drift.md §Momentum brake (KBP-14 enforcement)

**File:** `.claude/rules/anti-drift.md`
**Where:** Append ao final do bloco `## Momentum brake` (antes de `## Delegation gate`)
**Add:**
```
- **Pre-execution reflection gate (KBP-14):** Before ANY multi-step execution, state in 1 sentence: WHAT you will do and WHY this approach. Cannot articulate in 1 sentence = haven't reflected enough. Fast approval ("OK") does not exempt this gate.
```

### P002 — qa-pipeline.md §3 temp stale

**File:** `.claude/rules/qa-pipeline.md`
**Where:** Line 67 — replace the temperatura line
**Old:** `- Temperatura editorial: 1.0 (testado S71 — baixar torna critica generica). Aplica-se a TODAS as calls editoriais incluindo Call D e futuras.`
**New:** `- **Temperatura QA:** 1.0 (default Gemini 3 — Google recomenda manter; S178 baixou para 0.2 em Gemini 2.x, revertido S198). Override per-call: \`--temp <float>\`.`

### P003 — slide-patterns.md §5 conflict

**File:** `.claude/rules/slide-patterns.md`
**Where:** Section `## 5. Section Opener (Dark)` — replace HTML example
**Old:**
```html
<section id="s-a1-section-treatment" data-background-color="#0d1a2d">
  <div class="slide-inner slide-navy" style="justify-content: center; align-items: center; text-align: center;">
```
**New:**
```html
<section id="s-a1-section-treatment" class="theme-dark">
  <div class="slide-inner">
```
**Why:** `data-background-color` is dead in deck.js (slide-rules.md §10). Inline style prohibited (§1). `theme-dark` restores tokens + bg via CSS cascade.

## Step 2: Gemini parameter fix

**File:** `content/aulas/scripts/gemini-qa3.mjs`
**Decision gate:** HANDOFF diz "PENDENTE REVISAO". Lucas aprova temp 1.0?

5 edits pontuais (todos no mesmo arquivo):

| # | Lines | Old | New |
|---|-------|-----|-----|
| A | L102-106 | Comments: "S178 hardening" + TEMP_DEFAULTS 0.1/0.2 | Comments: "S198 Gemini 3 defaults (Google 1.0)" + all 1.0 |
| B | L52 | `--temp <float>     Override temperature (Gate 4 default: 1.0)` | `--temp <float>     Override temperature (default: 1.0, Gemini 3 recommended)` |
| C | L841 | `temperature: 0.1, topP: 0.9,` | `temperature: 1.0, topP: 0.95,` |
| D | L1075-1076 | validate call already uses TEMP_DEFAULTS (changes via A) | No extra edit needed |
| E | L1168-1170 | editorial calls already use TEMP_DEFAULTS (changes via A) | No extra edit needed |

**Not changing:** thinkingConfig (already OK), thinking_level (no advantage), frequency/presence_penalty (no evidence), seed (low priority).

**Verification:** `node content/aulas/scripts/gemini-qa3.mjs --help` + `npm run build:metanalise` from `content/aulas/`.

## Step 3: Loop melhoria continua (3 rondas)

### Ronda 1: node→jq migration (backlog #32)

4 scripts, same pattern as guard-bash-write.sh (S193). Deploy: Write→/tmp → bash -n → test → cp.

| Script | node -e extracts | jq replacement |
|--------|-----------------|----------------|
| guard-research-queries.sh L10-15 | `.tool_input.skill` | `jq -r '.tool_input.skill // ""'` |
| lint-on-edit.sh L12-16 | `.tool_input.file_path \|\| .path` | `jq -r '.tool_input.file_path // .tool_input.path // ""'` |
| lint-on-edit.sh L30-33 | `.cwd` | `jq -r '.cwd // "."'` |
| model-fallback-advisory.sh L15-20 | `.tool_response` (stringify+truncate) | `jq -r '(.tool_response // {}) | if type=="string" then . else tostring end' \| head -c 2000` |
| guard-lint-before-build.sh L17-25 | `.tool_input.command` | `jq -r '.tool_input.command // ""'` |

Each script: write to /tmp → `bash -n` syntax check → test with mock JSON → `cp` to final location.

### Ronda 2: Sentinel improvement (backlog #31)

**File:** `.claude/agents/sentinel.md`
4 additions:
1. **Verify-before-claim gate:** Add rule: "Before listing ANY finding, grep/verify the claim. If grep shows no match, DROP the finding."
2. **Report template mandatory:** Add required sections (Summary, Findings table, KBP Candidates, Hook Health, Metrics). Missing section = incomplete report.
3. **Scope limit:** Add: "1 concern OR 1 directory per invocation. Multi-concern scans must be split into multiple invocations."
4. **Maturity note:** Add: "Current tier: Audited (proven-wins.md). Promote after 5+ sessions without FP."

### Ronda 3: Agent optimization audit (backlog #29 — READ-ONLY)

Audit all 10 agents: tools, model, maxTurns. Report-only, no changes.
Read `.claude/agents/*.md` → produce table → return to Lucas.

## Verification

- [ ] Step 1: Read each edited rule file — confirm no conflicts with slide-rules.md
- [ ] Step 2: `node content/aulas/scripts/gemini-qa3.mjs --help` — temp text correct
- [ ] Step 2: `cd content/aulas && npm run build:metanalise` — PASS
- [ ] Step 3 R1: `bash -n` on each migrated script + mock JSON test
- [ ] Step 3 R2: Read sentinel.md — verify additions coherent
- [ ] Step 3 R3: Report table returned as text

## Order

1 → 2 → 3 (R1 → R2 → R3). Commit after each step. Momentum brake between steps.
