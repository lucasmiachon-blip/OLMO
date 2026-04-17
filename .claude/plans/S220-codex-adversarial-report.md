# S220 — Codex Adversarial Review (4 batches)

> Raw reports preserved from agents dispatched 2026-04-16 during S220 plan phase.
> Context: validate S219 infra + surface gaps before self-improvement loop resumes.

---

## Batch 1: HOOKS (10 issues, 5 HIGH / 4 MED / 1 LOW)

| # | Sev | Evidence | Problem | Fix |
|---|-----|----------|---------|-----|
| 1 | HIGH | `.claude/settings.local.json:172`; `.claude/hooks/guard-bash-write.sh:35` | Outer matcher only triggers on `> >> rm mv cp chmod kill`; `mkdir`, `tee`, `sed -i`, `python`, `curl -o` bypass | Run guard on all Bash OR expand matcher to every destructive class |
| 2 | HIGH | `.claude/settings.local.json:178`; `guard-lint-before-build.sh:24` | Lint enforcement only hooks `npm run build*`; `vite build`, `npx vite build`, `build-html.ps1` unguarded | Expand `if` matcher to full command set |
| 3 | HIGH | `.claude/hooks/momentum-brake-enforce.sh:46` | Blanket-exempts all Bash, armed brakes never stop shell side effects | Remove blanket, exempt only read-only |
| 4 | HIGH | `hooks/session-start.sh:20`; `.claude/hooks/post-global-handler.sh:18` | `/tmp/cc-session-id.txt` global → concurrent repos/sessions corrupt shared state | Namespace by repo hash + PID or UUID |
| 5 | HIGH | `hooks/stop-metrics.sh:149`; `settings.local.json:355` | Async grep-then-append on metrics.tsv; overlapping Stops duplicate/lose rows | Sync OR flock during write |
| 6 | HIGH | `settings.local.json:372`; `.claude/hooks/README.md:5` | Config registers `PostToolUseFailure` but README says event does not exist → silently disables later hooks | Remove or confirm platform support |
| 7 | MED | `hooks/post-tool-use-failure.sh:11` | Raw `INPUT=$(cat)` under `set -e` can abort before logging | `cat ... \|\| echo '{}'` + defensive parse |
| 8 | MED | `hooks/pre-compact-checkpoint.sh:59` | Checkpoint write errors suppressed → silent loss of recovery state | Detect write failure, emit explicit warning |
| 9 | MED | `settings.local.json:328` | Stop[0] KBP-22 check fires only at 3+ action calls; 1-2 unexplained side-effect calls pass silently | Block any unexplained side-effect regardless of count |
| 10 | MED | `.claude/hooks/nudge-checkpoint.sh:4,10`; `settings.local.json:99` | `/tmp` counters claimed to reset on SessionStart are never cleared → stale nudges across sessions | Add explicit counter reset files in SessionStart hook |

**Scoped to S220 Part D:** Issue #5 (metrics race). All others → S221 backlog.

---

## Batch 2: MEMORY (10 merge/move/delete candidates)

**Governance:** cap 20/20 (at limit). Review cadence: every 3 sessions.

| # | Action | Files | Rationale |
|---|--------|-------|-----------|
| 1 | MOVE-TO-RULES | `feedback_context_rot.md` | 41 linhas; L35-36 ja apontam para `anti-drift.md §Delegation gate` — memoria duplica prosa de regra |
| 2 | MERGE | `feedback_structured_output.md` → `feedback_research.md` | 33 linhas; sub-regra de formatacao de /research, ja coberta |
| 3 | CLARIFY-TRIGGER | `feedback_qa_use_cli_not_mcp.md` ↔ `project_metanalise.md` | Ambos disparam em QA/slides e cada um ja aponta para o outro como canonico |
| 4 | MERGE | `project_values.md` + `user_mentorship.md` + `project_self_improvement.md` | "funciona sem metrica = achismo" + balizador S213 elite duplicados nos 3 |
| 5 | MOVE-TO-RULES | `feedback_tool_permissions.md` | 50 linhas; politica operacional executavel (multi-window, guards, auth) — nao e memoria duravel |
| 6 | DELETE | `SCHEMA.md` | Stale: diz 10 rules + reference_*; realidade 5 rules + 0 references |
| 7 | MERGE | `project_audit_aula.md` → `project_metanalise.md` | Apendice sazonal cabe como subsecao "pacote final" |
| 8 | MOVE-TO-RULES | `feedback_no_fallback_without_approval.md` | 28 linhas; gate comportamental duro (report→options→STOP) pertence a rules |
| 9 | CLARIFY-TRIGGER | `feedback_motion_design.md` ↔ `project_living_html.md` | Ambos carregam em slide/CSS; prioridade indefinida |
| 10 | CLARIFY-TRIGGER | `patterns_antifragile.md` ↔ `project_values.md` | Mesmo framing antifragilidade/metrica-primeiro |

**Scoped to S220 Part F4:** SCHEMA.md DELETE/update. Merges + moves → S221 (alteram load-when triggers, exigem rethink).

---

## Batch 3: PLANS (5 plans evaluated)

| Plan | Status | Gap | Next Action |
|------|--------|-----|-------------|
| `functional-rolling-waffle.md` | FALSE-DONE | HANDOFF diz "steps 1-5 done" mas verification boxes abertas L137-143, decisao venv em aberto L46, sem artifact path | Manter ACTIVE ate completion linkada a artifact |
| `mutable-mapping-seal.md` | FALSE-DONE | L22 marca Fase 1 DONE mas L122 exige `Call B >=90%`, few-shot validado, delta tracking — nenhum run log. Phase 2 deliverables missing: `.claude/rules/design-excellence.md`, `.claude/skills/polish/SKILL.md` | Tratar Fase 1 nao-verificada ate artifact anexado |
| `generic-wondering-manatee.md` | STALE | Fase 2 agendada L190 para "proximas 3 sessoes" mas HANDOFF:58 marca self-improvement PAUSADO atras de gate. Artifacts L257, L265 nao existem | Suspender/reclassificar ate gate satisfeito |
| `snoopy-jingling-aurora.md` | ACTIVE-OK | Escopo concreto, verification L204, L214-218 diferem /polish + design-excellence ate pipeline validado, alinha com HANDOFF:24 | Manter como prerequisito ativo |
| `S204-warm-bouncing-dahl.md` (archived) | FALSE-DONE | L53-55 afirma Design Excellence Phase 2 OK pois "Phase 1.5 DONE", mas mutable-mapping-seal:122 ainda exige proof | Manter archived, tratar claim DONE como invalida |

**Scoped to S220 Part C:** Hygiene — mover `compressed-conjuring-pudding.md` (S219 KBP-22 done) para archive + status notes nos FALSE-DONE/STALE.

---

## Batch 4: RULES (10 issues)

| # | Type | Evidence | Fix |
|---|------|----------|-----|
| 1 | DEAD-REF | `CLAUDE.md:63` — `crossref-precommit.sh` | Replace com enforcer atual ou remover claim false |
| 2 | DEAD-REF | `CLAUDE.md:73` — `stop-detect-issues.sh` nao encontrado | Apontar para `hooks/stop-quality.sh` ou restaurar script |
| 3 | GAP | `.claude/rules/anti-drift.md:46`; `settings.local.json:328` | EC loop validation: mover para PreToolUse/Edit/Write hook real, nao heuristica prompt |
| 4 | GAP | `content/aulas/CLAUDE.md:77-83` | Adicionar guard sync slide/manifest/evidence/headline/clickReveals antes de build/stop |
| 5 | GAP | `CLAUDE.md:5`; `.claude/hooks/README.md:72` | Remover Bash das excecoes momentum-brake OU adicionar OK-gate explicito side-effects |
| 6 | CONTRADICTION | `anti-drift.md:22-23`; `content/aulas/CLAUDE.md:8` | Declarar build→QA permitido somente dentro de plano multi-step aprovado |
| 7 | MISSING-KBP | `hooks/session-start.sh:25`; `known-bad-patterns.md:75-76` | **Adicionar KBP-23** "agir antes de perguntar/nomear sessao" — captura evento S220 live |
| 8 | VERBOSITY | `known-bad-patterns.md:76` | Reduzir KBP-22 a pointer puro sem prose inline (viola KBP-16) |
| 9 | DEAD-REF | `known-bad-patterns.md:28` KBP-06 | Redirecionar para arquivo/secao existente ou restaurar `feedback_agent_delegation.md` |
| 10 | DEAD-REF | `known-bad-patterns.md:55` KBP-15 | Redirecionar ou restaurar `feedback_tool_permissions.md` |

**Scoped to S220 Part F1-F3:** KBP-23 add, KBP-22 verbosity fix, CLAUDE.md DEAD-REFs verify. Others → S221.

---

## S221+ Backlog (from this report)

**Hooks (9):** issues #1-4, #6, #7-10
**Memory (9):** merges 2,4,7; moves 1,5,8; clarifies 3,9,10
**Plans (0):** S220 addresses all
**Rules (7):** issues #3-6, #9, #10 (KBP-23, KBP-22, DEAD-REFs CLAUDE.md done em S220 F)

**Estimativa total S221+:** ~4-5h de trabalho focado. Prioridade: `#5 momentum-brake Bash exemption` + `#3 EC loop real hook` (GAPs arquiteturais), depois MEMORY merges (teste load-when).

---

Coautoria: Lucas + Opus 4.7 + Codex GPT-5 | S220 2026-04-16
