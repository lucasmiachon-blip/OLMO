# Codex Audit S57 — Behavioral Enforcement Review

> Two-frame audit: objective + adversarial. GPT-5.4 (Codex), 2026-04-03.
> Context: Agent violated 5+ of its own 35 memories in S57. Root cause: memory is advisory, not enforced.
> Pre-audit: guard-pause.sh, session-compact.sh, CLAUDE.md primacy/recency anchors implemented.

---

## Frame 1: Audit Objetivo (15 findings)

### P0 (Critico)

| Arquivo | Problema | Fix |
|---------|----------|-----|
| guard-pause.sh | So cobre Edit\|Write. `Bash("echo > file")` bypassa TODOS os guards | Adicionar `guard-bash-write.sh` para shell redirects |
| feedback_mentor_autonomy.md | Diz "executar sem pedir confirmacao redundante" — contradiz CLAUDE.md "espere OK" | Reescrever: autonomia so dentro de plano aprovado |
| user_mentorship.md | Diz "decidir, executar, explicar depois" — bypassa politica de aprovacao | Reescrever: "decide within scope; if scope changes, stop and ask" |
| metanalise/CLAUDE.md | Diz "visual = Gemini CLI" e "Gemini approved = Gate 4" — contradiz root "QA = Opus, NAO Gemini" | Reescrever para alinhar com root |
| slide-rules.md | Exige aside.notes em toda section — root diz aside.notes deprecated | Resolver contradicao |
| design-reference.md | Diz "evidence-db e canonico" — root diz evidence-db deprecated | Atualizar para living HTML |
| qa-pipeline.md | "NUNCA batch Gemini" assume Gemini no QA — contradiz root | Harmonizar |
| guard-product-files.sh | So protege cirrose. Metanalise e grade desprotegidos | Expandir escopo |
| check-evidence-db.sh | Fail-open quando transcript indisponivel + enforca evidence-db (deprecated) | Fail-closed + target correto |
| stop-hygiene.sh | So avisa, nunca bloqueia stop | Fazer blocking |

### P1-P2

| Arquivo | Problema |
|---------|----------|
| session-compact.sh | Nao re-injeta memorias de erros recorrentes (CLI, rebuild) |
| anti-drift.md | Falta: "se pediu plan mode, entre" e "aprovacao antes de write/build/QA" |
| build-monitor.sh | PostToolUseFailure nunca dispara (config so registra PostToolUse) |

---

## Frame 2: Ataque Adversarial (10 vulnerabilidades)

| # | Vetor | Severidade | Status |
|---|-------|------------|--------|
| 1 | **Shell Redirection Escape** — `Bash("echo > file")` bypassa todos guards | CRITICAL | Confirmado |
| 2 | **Prompt-Time Memory Omission** — sem UserPromptSubmit, nada forca consultar memorias | CRITICAL | Confirmado |
| 3 | **Policy Shopping** — agente cita arquivo que apoia o drift (mentor_autonomy vs CLAUDE.md) | HIGH | Confirmado |
| 4 | **Compact Drift Reset** — pos-compaction perde memorias corretivas | HIGH | Confirmado |
| 5 | **Metanalise Free Zone** — guard-product-files nao protege metanalise | HIGH | Confirmado |
| 6 | **Transcript Null Pass** — check-evidence-db fail-open + target deprecated | HIGH | Confirmado |
| 7 | **Dirty Stop** — stop-hygiene nunca bloqueia | MEDIUM | Confirmado |
| 8 | **Parallel Hook Race** — hooks rodam em paralelo, possivel race | MEDIUM | Confirmado |
| 9 | **Silent Broken Build** — build-monitor nao captura falhas | MEDIUM | Confirmado |
| 10 | **Stale Memory Arbitration** — sem lifecycle metadata nas memorias | MEDIUM | Confirmado |

---

## Fixes propostos pelo Codex (codigo pronto)

1. `guard-bash-write.sh` — deny em shell commands com `>`, `>>`, `sed -i`, `writeFileSync`
2. `UserPromptSubmit` hook — injeta digest de memorias criticas antes de agir
3. Stop hygiene blocking — bloqueia stop se HANDOFF/CHANGELOG nao atualizados
4. `PreCompact` hook — salva contexto antes de compaction

---

## Roadmap de Resolucao

### P0 — Implementar imediatamente
1. [ ] `guard-bash-write.sh` — block shell write patterns (V1)
2. [ ] Resolver 6+ contradicoes de policy (V3): mentor_autonomy, user_mentorship, metanalise/CLAUDE.md, slide-rules, design-reference, qa-pipeline
3. [ ] Expandir `guard-product-files.sh` para todas aulas (V5)

### P1 — Proxima sessao
4. [ ] Reescrever `check-evidence-db.sh` para living HTML + fail-closed (V6)
5. [ ] Tornar `stop-hygiene.sh` blocking (V7)
6. [ ] Reescrever `feedback_mentor_autonomy.md` e `user_mentorship.md` (V3/V8)
7. [ ] Adicionar `trap` fail-closed ao guard-pause.sh (V9)
8. [ ] Adicionar memorias de erros recorrentes ao session-compact.sh

### P2 — Quando conveniente
9. [ ] Atualizar anti-drift.md com plan mode e aprovacao pre-write
10. [ ] Investigar build-monitor PostToolUseFailure
11. [ ] Prune de memorias stale + `expires:` frontmatter (V10)

### Bloqueado / Pesquisa necessaria
12. [ ] `UserPromptSubmit` hook para injecao de memoria (V2) — verificar se existe na API Claude Code
13. [ ] `PreCompact` hook — verificar se existe

---

Coautoria: Lucas + GPT-5.4 (Codex audit) + Opus 4.6 (implementacao + sintese) | 2026-04-03
