# Anti-Drift

> Declare intent. Follow the plan. Implement only what was asked.

## Transparency
- State WHAT and WHY before acting. Make technical choices visible: "I chose X because Y."
- When uncertain, say so and ask. Fabrication is never valid.

## Scope
- Implement exactly what requested. Adjacent code untouched. One concern per commit.
- Research pinned to specific deliverable named in request. Scope expansion requires explicit ask.
- Scope reductions: report skipped items in HANDOFF with reason. Silent skips = drift.

## Failure response (KBP-07)
1. Read COMPLETE error message
2. Diagnose ROOT CAUSE (verify before claiming)
3. Report: what failed, why, evidence
4. List options (retry / fix root cause / defer / do nothing)
5. STOP — wait for Lucas

## Momentum brake
After any discrete action: STOP and report result. Next step requires explicit instruction.
Exception: within approved multi-step plan where all steps listed upfront.

### Propose-before-pour
Operação substantiva (merge ≥3 files OU rewrite ≥100 li OU migration arquitetural OU novo file ≥100 li): propor approach high-level + 1 short example (5-10 li). Aguardar OK antes de gerar volume completo. Architectural pivots são cheap antes do pour, caros depois.

### Budget gate em scope extensions
Scope extension (além do originalmente aprovado) exige proposal format: `[budget] custo estimado: Xmin | budget restante: Ymin | prosseguir?`. Habit sem gate mecânico decai — violação S226 aceitou +15min F+G sem gate explícito no momento da proposta.

## Delegation gate (KBP-17)
Before ANY Agent spawn, 3 questions:
1. Read/Grep/Glob resolves directly? → SKIP agent
2. Lucas gave specific files/PMIDs/paths? → SKIP agent, read what he cited
3. Agent brings concrete gain (parallelism + massive context + exclusive tool)? No named reason → SKIP
4. Agent produces research → result written to plan file BEFORE reporting to user. Context is volatile, plan file persists.

### Spot-check AUSENTE claims (KBP-32)
Agents SOTA research (Anthropic/Competitors/Frontend externos) often mark features "AUSENTE" sem confirmar no repo real. S241 obs: Agent 1 reportou `paths:` frontmatter ausente em rules — eram ALREADY em 3 files (slide-rules, design-reference, qa-pipeline). Taxa 33% erro (1/3 amostras). Antes de Edit baseado em claim AUSENTE: **Phase 1 Grep/Read spot-check obrigatório** (3-5 greps paralelos, ~5 min). Não é over-engineering — é prevenção de commit errado. Regra: todo claim "X is AUSENTE" em agent report exige 1 Grep/Read de confirmação antes de virar Edit.

## First-turn discipline (KBP-23)
First response after /clear already loads ~25KB auto-content (CLAUDE.md + rules + skills list + HANDOFF + MCP instructions). Additional tool use compounds. Discipline:
1. **Read with `limit`:** files >100 lines → `limit: 50` first. Expand only after targeted Grep locates the relevant range. **APL=HIGH strict:** memory/hooks/rules/skills `.md` files require Grep targeted a seção específica; full Read proibido a menos que targeted falhe (violação S226: 3 Reads integrais com APL já HIGH).
2. **Skill invocation gate:** heavy skills (>100 li — systematic-debugging, /dream, brainstorming, frontend-design) only when task explicitly requires the framework. Read-only audits use direct logic.
3. **ToolSearch targeted:** fetch schemas only for tools about to be called in THIS turn. No prefetch.
4. **Agent dispatch for broad scans:** 3+ Reads + 2+ Greps in unknown area → delegate to Explore/general-purpose. Agent returns ~2KB report vs 30-50KB raw content.

## Edit discipline (KBP-25)
Edit tool match é literal — whitespace, indentação, Unicode chars (tree `│   ├──` vs ASCII `|   +-`) quebram old_string. Antes de Edit:
1. Read full file OU range cobrindo old_string ± 20 li. Grep context não suficiente (não mostra tabs vs spaces, box-drawing chars)
2. Copy old_string direto do Read output — não reconstruir mental
3. Same-file Edits múltiplos: old_strings em linhas distintas non-overlapping (race-safe)

Violação S226 Phase A: 3 Edits falhados por whitespace mismatch (`│   ├── medicina-clinica` mental vs `    │   ├── medicina-clinica` real com 4-space prefix).

## Verification
1. Identify verification command (test, build, lint, manual check)
2. Execute fully. Read complete output.
3. Confirm output matches your claim. Only then assert.

File not found → Glob. Error → read actual message. Claim about code → read the file.
Claim about state → read source-of-truth file. Claim about history → `git log -S` / `git blame`.

## Adversarial review (KBP-28)
Adversarial validation é frame-bound — cobre apenas hipóteses formuladas. S227 validou deny-list dentro do frame "Bash(*) é o problema?", não simulou shell-within-shell. Antes de fechar audit de security: rodar checklist por tipo de comando — `bash -c`, `sh -c`, `zsh -c`, `$()`, backticks, `eval`, `exec`, `source`, `. /`.

## State files (HANDOFF, CHANGELOG, BACKLOG)
- NEVER rewrite with Write. Use Edit to add/modify specific sections.
- Write overwrites silently — forgotten sections vanish without warning.
- Before touching a state file: Read it, list sections present, verify all sections survive after edit.
- Adding S(N) content: append new section, do NOT remove S(N-1) history unless anti-drift §Session docs explicitly says to.

## EC loop (pre-action gate)
Before EACH Edit/Write, answer visibly:
```
[EC] Verificacao: <what I checked>
[EC] Mudanca: <1 sentence>
[EC] Elite: <(1) por que esta abordagem e melhor que alternativas, (2) o que seria mais profissional>
```
"Elite: sim" PROIBIDO — must contain: (1) por que esta abordagem e melhor que alternativas descartadas, (2) o que um engenheiro de elite faria diferente. Reflexao de seguranca nao basta — reflexao de excelencia. Enforced por Stop[0] silent execution check (S219).
CSS/GSAP changes: verification includes screenshot via `qa-capture.mjs`.
Touching a CSS section: audit ENTIRE section (raw px, off-palette, redundant tokens — KBP-21).

## Session docs
- **HANDOFF.md:** pendencias only, max ~50 lines. No history — only future.
- **CHANGELOG.md:** append-only, 1 line per change. Aprendizados + residual verification combinado: max 5 linhas per session. Violação S226: 7 bullets aprendizados + 5 residual breakdown.
- Update both every session with commits/state changes.
- P0 items in HANDOFF: surface to Lucas at session start before feature work.
- **KBP candidate commit gate (KBP-31):** se Aprendizados do CHANGELOG contém "KBP candidate" ou "lint rule candidate", schedule commit em `known-bad-patterns.md` OU `slide-rules.md` antes de session close. Candidate sem commit = lost (casos S237 Windows-path-escape + S238 E22 ambos perdidos).

## Plan execution
Plan approved com ≥4 phases: TaskCreate batch mandatory no approval (1 task per phase). TaskUpdate in_progress ao start de cada phase, completed ao commit. Violação S226: 8 phases sem task tracking, UX Lucas prejudicada (só commits visíveis, sem progress real-time).

## Script primacy
Scripts in `content/aulas/scripts/` are canonical. Agents reference, never reimplement.

## Budget
Local first (regex, cache, file search) before API. Cheapest model that solves the task.
