# Anti-Drift

> Declare intent. Follow the plan. Implement only what was asked.

## Transparency
- State WHAT and WHY before acting. Make technical choices visible: "I chose X because Y."
- When uncertain, say so and ask. Fabrication is never valid.

## Tone (default — Lucas S261)
Be terse unless Lucas explicit indicates verbose. Concise, signal-rich, no padding. Lists > prose. Cite file:line/SHA/PMID inline. Skip preambles ("I'll...", "Let me..."). Skip postscripts ("Hope this helps."). Sub-agents `.claude/agents/*.md` propagam este default.

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
Scope extension (além do plan approved) exige format mecanicamente verificável: `[budget] calls atuais: N | última approval: K | delta: N-K | prosseguir?`. N obtido via APL statusline (`calls:NNN`) ou `cat ~/.claude/stats-cache.json | jq .calls`. K = call count na última approval registrada. Detectado em `settings.json` Stop[1] prompt hook se ausente em scope extension. Reframe call-based S271 — substituiu Xmin time-based porque mental math sobre tempo decai (audit S270 §A4 confirmou 0 hits all-time).

## Delegation gate (KBP-17)
Before ANY Agent spawn, 3 questions:
1. Read/Grep/Glob resolves directly? → SKIP agent
2. Lucas gave specific files/PMIDs/paths? → SKIP agent, read what he cited
3. Agent brings concrete gain (parallelism + massive context + exclusive tool)? No named reason → SKIP
4. Agent produces research → result written to plan file BEFORE reporting to user. Context is volatile, plan file persists.

### Spot-check AUSENTE claims (KBP-32)
Agents SOTA research (Anthropic/Competitors/Frontend externos) often mark features "AUSENTE" sem confirmar no repo real — taxa de erro observada ~33%. Antes de Edit baseado em claim AUSENTE: **Phase 1 Grep/Read spot-check obrigatório** (3-5 greps paralelos, ~5 min). Não é over-engineering — é prevenção de commit errado. Regra: todo claim "X is AUSENTE" em agent report exige 1 Grep/Read de confirmação antes de virar Edit.

## First-turn discipline (KBP-23)
First response after /clear already loads ~25KB auto-content (CLAUDE.md + rules + skills list + HANDOFF + MCP instructions). Additional tool use compounds. Discipline:
1. **Read with `limit`:** files >100 lines → `limit: 50` first. Expand only after targeted Grep locates the relevant range. **APL=HIGH strict:** memory/hooks/rules/skills `.md` files require Grep targeted a seção específica; full Read proibido a menos que targeted falhe.
2. **Skill invocation gate:** heavy skills (>100 li — systematic-debugging, /dream, brainstorming, frontend-design) only when task explicitly requires the framework. Read-only audits use direct logic.
3. **ToolSearch targeted:** fetch schemas only for tools about to be called in THIS turn. No prefetch.
4. **Agent dispatch for broad scans:** 3+ Reads + 2+ Greps in unknown area → delegate to Explore/general-purpose. Agent returns ~2KB report vs 30-50KB raw content.

## Edit discipline (KBP-25)
Edit tool match é literal — whitespace, indentação, Unicode chars (tree `│   ├──` vs ASCII `|   +-`) quebram old_string. Antes de Edit:
0. Dominio novo ou pouco tocado: ler governing docs (CLAUDE.md da subarea, ADR relevante, SKILL.md referenciado) antes do primeiro Edit. Governing context precede precisao de whitespace. Ver CLAUDE.md §ENFORCEMENT #5.
1. Read full file OU range cobrindo old_string ± 20 li. Grep context não suficiente (não mostra tabs vs spaces, box-drawing chars)
2. Copy old_string direto do Read output — não reconstruir mental
3. Same-file Edits múltiplos: old_strings em linhas distintas non-overlapping (race-safe)

## Verification
1. Identify verification command (test, build, lint, manual check)
2. Execute fully. Read complete output.
3. Confirm output matches your claim. Only then assert.

File not found → Glob. Error → read actual message. Claim about code → read the file.
Claim about state → read source-of-truth file. Claim about history → `git log -S` / `git blame`. Claim about branch → `git branch --show-current` (SessionStart `gitStatus` snapshot decai durante sessão).

## Adversarial review (KBP-28)
Adversarial validation é frame-bound — cobre apenas hipóteses formuladas. Antes de fechar audit de security: rodar checklist por tipo de comando — `bash -c`, `sh -c`, `zsh -c`, `$()`, backticks, `eval`, `exec`, `source`, `. /`.

## State files (HANDOFF, CHANGELOG, BACKLOG)
- NEVER rewrite with Write. Use Edit to add/modify specific sections.
- Write overwrites silently — forgotten sections vanish without warning.
- Before touching a state file: Read it, list sections present, verify all sections survive after edit.
- Adding S(N) content: append new section, do NOT remove S(N-1) history unless anti-drift §Session docs explicitly says to.
- CHANGELOG.md cap: ate 10 sessoes ativas (~700 linhas). Sessoes mais antigas movem para `docs/CHANGELOG-archive.md` com footer `Sessoes anteriores (Xb-Y): docs/CHANGELOG-archive.md`. CHANGELOG bloated rouba contexto/atencao na reidratacao (Lucas S269 Lane D).

## Concurrent agent commit safety (KBP-51)
Quando outro agente edita os mesmos shared docs (HANDOFF/CHANGELOG/rules) na mesma janela:
1. `git fetch origin` + `git status --short` antes de cada Edit em state file compartilhado.
2. Stage per-file (NUNCA `-A` ou `git add .`) — outro agente pode ter untracked files que nao devem entrar no seu commit.
3. Edit cirurgico em state files: Read range, Edit com `old_string` unico, NUNCA Write rewrite (perde mudancas do outro agente silenciosamente).
4. Aguardar liberacao explicita do usuario quando ele avisar que outro agente esta editando concorrente — nao tentar Edit em race.
5. `git pull --rebase` antes de push: se outro agente ja push'd, rebase preserva ordem linear.

## EC tiers (when full loop is mandatory)

Tier system formaliza judgment de risco — não é todo Edit que precisa Pre-mortem/Steelman/[budget]. Calibrate por consequência:

- **Tier S (sempre full loop incluindo Pre-mortem + Steelman + budget):** Edits em `.claude/rules/*`, `settings.json`, `.claude/hooks/*`, `hooks/*`, `CLAUDE.md`, `AGENTS.md`. Self-modifications do sistema = alta consequência. Mudança em rule de governance + hook que enforça rules tem blast radius cross-session.
- **Tier M (sempre full loop):** refactor ≥3 files, migration arquitetural, novo file ≥100 li, scope extension além do plan approved, novos agents/skills, deletes de hook/script versionado.
- **Tier T (loop mínimo: Verificação + Evidência + Mudança + Autorização):** typo fix, single-line fix óbvio em arquivo já owned, doc prose Edit não-canônica. Pre-mortem/Steelman/[budget] opcionais — engenheiro experiente skipping com motivo é OK; aplicar mesmo assim não é teatro se motivo claro existe.

Tier-S Edit sem `[EC] Fase 4 - Pre-mortem:` visível em user-facing text é detectado em `settings.json` Stop[1] prompt hook. Scope extension sem `[budget] calls atuais: N` visível também detectado. LOOP GUARD inerda pattern de Stop[0] (não duplica feedback mesma reason).

## EC loop (pre-action gate)

Context is ephemeral. Before EACH Edit/Write, Bash command with write/commit/push side effect, or writer-agent action, answer visibly and wait:

```
[EC] Fase 1 - Verificacao: <what I checked before acting>
[EC] Fase 1 - Evidencia: <file:line, command/output, SHA, PMID/DOI/URL, or other verifiable artifact>
[EC] Fase 1 - Gap A3: <current state -> expected state -> measurable gap -> source of truth>
[EC] Fase 2 - Steelman obrigatorio: <best opposing argument or strongest reason not to do this>
[EC] Fase 3 - Mudanca proposta: <exact files, minimal change, explicit out-of-scope>
[EC] Fase 3 - Por que e mais profissional: <why this reduces risk vs alternatives; what a rigorous engineer would do now vs defer with reason>
[EC] Fase 4 - Pre-mortem (Gary Klein): <plausible concrete failure mode + mitigation/check>
[EC] Fase 4 - Rollback/stop-loss: <objective trigger to abort, revert, or ask for help>
[EC] Fase 5 - Verificacao pos-mudanca: <commands/checks and objective PASS/FAIL criterion>
[EC] Fase 6 - Learning capture: <adopt, adjust, revert, or codify as rule/hook/test>
[AUTORIZACAO] <wait for Lucas explicit OK before executing>
```

Sem `[AUTORIZACAO]` explicita no thread atual = STOP. "Parece logico", "plano anterior", memoria de outra sessao, ou inferencia de intent nao contam como permissao.

`Por que e mais profissional: sim` PROIBIDO — must contain: (1) por que esta abordagem e melhor que alternativas descartadas, (2) o que um engenheiro rigoroso faria diferente agora ou deferiria com gate explicito. Reflexao de seguranca nao basta — reflexao de excelencia. Enforced por Stop[0] silent execution check.
`Steelman obrigatorio` bloqueia critica preguicosa: engajar o melhor argumento contrario antes de decidir. `Pre-mortem (Gary Klein)` imagina falha concreta antes da execucao para revelar riscos que analise direta esconde.
`Gap A3` aplica Lean/A3: problema = diferenca mensuravel entre estado atual e esperado. `Rollback/stop-loss` limita blast radius antes de agir. `Learning capture` fecha PDSA: aprender com resultado e decidir se vira regra/hook/teste ou se reverte/ajusta.
CSS/GSAP changes: verification includes screenshot via `qa-capture.mjs`.
Touching a CSS section: audit ENTIRE section (raw px, off-palette, redundant tokens — KBP-21).

### Elite faria diferente — must be actionable (KBP-37)
"Elite faria diferente: X" tem 3 destinos válidos:
1. **Doing now** — X passa cheap + high-value + evidence-supported. Aplicar nesta phase, não defer.
2. **Deferred (gate-justified)** — defer só com gate explícito citado: D13 calibrate-before-harden, KBP-21 calibrate-before-block, KBP-32 spot-check pendente, ou similar. Sem gate = não defer.
3. **Cut** — sem cost/value claro = aspiracional. Não listar — vira ruído.

Listar X sem (1), (2) ou (3) = pseudo-confessional (sinaliza awareness sem ação) = KBP-22 silent-execution-chain disfarçado. Antidoto: **ações > sinalizações de awareness**. EC loop é audit trail de decisões executáveis, não confessário de aspirações.

### Cut calibration (KBP-41)
"Cut" reservar EXCLUSIVAMENTE para items sem cost/value claro = aspiracional. Antes de marcar Cut, decision tree:
(a) Lucas pediu este escopo já (explicit ou implícito por sequência)? → **Doing now**.
(b) Cost <5min + value docs/persistent + zero risk? → **Doing now**.
(c) Cost ≥5min OU escopo expandido OU bench/research needed OU touches files fora do plan atual? → **Deferred (gate-justified com razão explícita)**.
(d) Aspiracional sem cost/value claro? → **Cut**.
**Indicador de bias:** marca Cut 2+ vezes na mesma sessão = recalibrar threshold. "Não pressuponha que nada é profissional" (Lucas S254-tail). Cut é último recurso, não primeiro. Categoria-error (Cut quando devia ser Deferred) = perda de signal — Lucas later confirma os items como entrada futura, mostrando que Cut decisão foi viés conservador, não calibração honesta.

## Session docs
- **HANDOFF.md:** pendencias only, max ~50 lines. No history — only future.
- **CHANGELOG.md:** append-only, 1 line per change. Aprendizados + residual verification combinado: max 5 linhas per session.
- Update both every session with commits/state changes.
- P0 items in HANDOFF: surface to Lucas at session start before feature work.
- **KBP candidate commit gate (KBP-31):** se Aprendizados do CHANGELOG contém "KBP candidate" ou "lint rule candidate", schedule commit em `known-bad-patterns.md` OU `slide-rules.md` antes de session close. Candidate sem commit = lost.

## Plan execution
Plan approved com ≥4 phases: TaskCreate batch mandatory no approval (1 task per phase). TaskUpdate in_progress ao start de cada phase, completed ao commit.

## Script primacy
Scripts in `content/aulas/scripts/` are canonical. Agents reference, never reimplement.

## Budget
Local first (regex, cache, file search) before API. Cheapest model that solves the task.
