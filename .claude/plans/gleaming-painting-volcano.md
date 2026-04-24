# S244 — CLAUDE.md Detox

> Scope: reduzir ruído em arquivos auto-loaded de instrução (CLAUDE.md + .claude/rules/*). Benchmark: SOTA late-2025/2026 (Boris Cherny, Anthropic docs, HumanLayer).

## Context

**Problema:** 349 linhas auto-loaded permanente todo turno (CLAUDE.md 92 + anti-drift 98 + KBP 109 + user global 50). Anthropic docs oficiais citam **200 linhas** como ceiling por arquivo CLAUDE.md; OLMO CLAUDE.md raiz está em 92 li (OK), mas o conjunto tem **18 linhas com session-refs inline** (`violação S226`, `pós-S232`, `S241 obs`, `Addendum S243`) e 1 header com data hardcoded (`(abril/2026)`).

**Por que isso importa:**
1. **Adherence degrada com bloat** (Anthropic: "if too long, Claude ignores half — rules get lost in noise")
2. **Session-history inline = "static memory" anti-pattern** (Boris) + "information that changes frequently" (Anthropic exclude column)
3. **Prune test (Boris):** "Would removing this cause Claude to make mistakes?" — "violação S226: 3 Reads integrais" → NÃO. A REGRA opera sem a HISTÓRIA. O relato pedagógico pertence a humanos (CHANGELOG, git), não ao modelo.

**Outcome esperado:** instrução enxuta focada em regras operacionais, sem narrativa histórica. Economia estimada: 15-25 linhas, mantendo 100% da força regulatória.

---

## SOTA Benchmarks (research externa)

| Heurística | Fonte convergente | Status OLMO |
|---|---|---|
| CLAUDE.md < 200 li | Anthropic docs oficial | ✓ raiz 92 li |
| Instrução total < 2.5k tokens | Boris Cherny | ✓ ~2k tokens estimado |
| Pointer > inline prose | HumanLayer + Anthropic (`@import`) | ✓ KBP file é pointer-only (KBP-16) |
| Prune test | Boris Cherny | ✗ 18 linhas session-history falham |
| Path-scoped rules para condicional | Anthropic | ✓ parcial (slide/qa/design têm `paths:`) |
| Skills > CLAUDE.md para condicional | Anthropic | ✓ 18 skills existem |
| "Static memory" anti-pattern | Boris #2 | ✗ "violação S226" ×4 em anti-drift |
| "Info que muda frequentemente" | Anthropic exclude column | ✗ `(abril/2026)` header + "S243 Addendum" |

**URLs-chave:**
- [Anthropic Best Practices](https://code.claude.com/docs/en/best-practices)
- [Anthropic Memory docs](https://code.claude.com/docs/en/memory)
- [HumanLayer — Writing a good CLAUDE.md](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
- [howborisusesclaudecode.com](https://howborisusesclaudecode.com/)

---

## Inventário de Ruído (audit local)

### Always-on (auto-loaded permanente) — FOCO do detox

**`CLAUDE.md` raiz (92 li) — 4 hits:**
| Linha | Ruído | Ação proposta |
|---|---|---|
| L18 | `## Architecture (S232 post-close — Claude Code only, consumer)` | Header: remover "(S232 post-close —" → `## Architecture — Claude Code only, consumer` |
| L20 | `**Sem runtime Python.** S232 post-close deletou stack Python inteiro (orchestrator.py + agents/ + subagents/ + tests/) por ser vestigial/falido/nunca usado.` | Compress: `**Sem runtime Python.** Stack antigo removido; history em git log.` |
| L84 | `## CC schema gotchas (abril/2026)` | Remover `(abril/2026)` → `## CC schema gotchas` |
| L92 | `Commit 9ef3b78 (S235b) adicionou 7 patterns shell-within-shell...` | Remover commit hash + `(S235b)` → `Deny-list inclui 7 patterns shell-within-shell...` |

**`.claude/rules/anti-drift.md` (98 li) — 8 hits concentrados:**
| Linha | Ruído | Ação proposta |
|---|---|---|
| L29 | `...Habit sem gate mecânico decai — violação S226 aceitou +15min F+G sem gate explícito no momento da proposta.` | Remove sentence final "— violação S226 aceitou..." |
| L43 | `...full Read proibido a menos que targeted falhe (violação S226: 3 Reads integrais com APL já HIGH).` | Remove parênteses final |
| L54 | `Violação S226 Phase A: 3 Edits falhados por whitespace mismatch (...)` | Delete sentence inteira (line L54) — é só history, a REGRA está em L50-52 |
| L65 | `Adversarial validation é frame-bound — cobre apenas hipóteses formuladas. S227 validou deny-list dentro do frame "Bash(*) é o problema?", não simulou shell-within-shell.` | Compress: manter "Adversarial validation é frame-bound — cobre apenas hipóteses formuladas." e deletar exemplo S227 |
| L80 | `...Enforced por Stop[0] silent execution check (S219).` | Remove `(S219)` |
| L86 | `...Aprendizados + residual verification combinado: max 5 linhas per session. Violação S226: 7 bullets aprendizados + 5 residual breakdown.` | Remove final "Violação S226..." |
| L89 | `...Candidate sem commit = lost (casos S237 Windows-path-escape + S238 E22 ambos perdidos).` | Remove parênteses final |
| L92 | `...TaskUpdate in_progress ao start de cada phase, completed ao commit. Violação S226: 8 phases sem task tracking, UX Lucas prejudicada (só commits visíveis, sem progress real-time).` | Remove final "Violação S226..." |

**Economia:** ~1 linha deletada (L54) + 7 sentence-trims inline = ~10-12 linhas liberadas.

**`.claude/rules/known-bad-patterns.md` (109 li) — 5 hits (pointer-adjacent prose):**
| Linha | Ruído | Ação proposta |
|---|---|---|
| L67 | `→ guard-write-unified.sh + guard-bash-write.sh (merged S194, original guard-product-files.sh removed)` | Simplify: `→ guard-write-unified.sh + guard-bash-write.sh` (history em git) |
| L76 | `→ anti-drift.md §EC loop + Stop[0] prompt silent execution check (S219: enforcement mecanico)` | Simplify: `→ anti-drift.md §EC loop + Stop[0] silent execution check` |
| L88 | `→ `.claude/BACKLOG.md #34` + `.claude/plans/archive/S227-backlog-34-architecture.md`` | **KEEP** — pointer válido a plano archive específico |
| L106 | `→ anti-drift.md §Delegation gate ("Spot-check AUSENTE claims" — S241 obs: 33% taxa de erro em claims "AUSENTE" de agents SOTA research; Phase 1 Grep/Read spot-check antes de Edit é não-opcional)` | Compress: `→ anti-drift.md §Delegation gate ("Spot-check AUSENTE claims" — agent SOTA research claims AUSENTE têm taxa erro ~33%; Grep/Read confirm obrigatório antes de Edit)` — remove "S241 obs" |
| L109 | `→ docs/adr/0006-olmo-deny-list-classification.md §Addendum S243 (7 bypasses empíricos Codex A v2 — `/bin/bash`, `xargs bash`, `find -exec`, `env bash`, `pwsh`, `cmd.exe`, `python -Ic`; guard tokenization é defesa primária, deny é camada 1)` | **QUESTION Q3** — value of inline bypass list vs pointer |

### Path-scoped (não always-on) — fora do scope detox mas auditados

- `.claude/rules/slide-rules.md` (32 li) — 1 S-ref (L22 `bug projetor S238` em regra E22). **KEEP** — justifica a regra; pedagógico.
- `.claude/rules/qa-pipeline.md` (33 li) — 0 hits, **clean**
- `.claude/rules/design-reference.md` (19 li) — 0 hits, **clean**

### User global — fora do scope (não projeto-OLMO)

- `~/.claude/CLAUDE.md` (50 li) — 0 S-refs, 0 datas, pura preferência. **Keep as-is**.

---

## Arquivos a modificar

1. `C:\Dev\Projetos\OLMO\CLAUDE.md` (4 edits)
2. `C:\Dev\Projetos\OLMO\.claude\rules\anti-drift.md` (8 edits, 1 line-delete)
3. `C:\Dev\Projetos\OLMO\.claude\rules\known-bad-patterns.md` (2-4 edits, depende Q3)

**Método:** Edit cirúrgico (anti-drift §State files proíbe Write rewrite). Cada old_string verificado via Read integral do range ±20 li antes (KBP-25 Edit discipline).

---

## Decisões aprovadas

- **Q1:** Mover `## CC schema gotchas` para `.claude/rules/cc-gotchas.md` path-scoped (`paths: ['.claude/settings*.json', 'hooks/**', '.claude/hooks/**']`). CLAUDE.md perde section inteira (L83-92).
- **Q2:** Remove TODAS as 8 menções `violação Sxxx` em anti-drift.md. Regras ficam, history vai pra CHANGELOG/git.
- **Q3:** KBP-33 L109 — compress (remove `§Addendum S243`, mantém lista operacional dos 7 bypasses).
- **Q4:** CLAUDE.md L18 header → `## Architecture`. L20 compress → `**Sem runtime Python.** Orquestração: Claude Code nativo (subagents + skills + hooks + MCPs).`

---

## Verification

Após cada Edit:
1. `wc -l <file>` — confirmar redução
2. `grep -c "S\d\{3\}" <file>` — confirmar S-refs zerados nas seções editadas
3. Read do range ±10 li ao redor do Edit — confirmar contexto preservado, regra intacta
4. Grep de keywords-críticas preservadas (ex: "KBP-26", "permissions.ask", "deny-list", "timeout")

Pós-tudo:
5. `wc -l CLAUDE.md .claude/rules/anti-drift.md .claude/rules/known-bad-patterns.md` → total < 280 li (redução ~20%)
6. `grep -c "viola" .claude/rules/anti-drift.md` → 0 (se Q2=a)
7. Session-start hook reload: confirmar que nada critical quebrou (stop hook não reclama)

---

## Order of operations (5 commits atômicos)

**Commit 1 — `CLAUDE.md` L18+L20 Architecture cleanup**
- L18: `## Architecture (S232 post-close — Claude Code only, consumer)` → `## Architecture`
- L20: reescrever linha como `**Sem runtime Python.** Orquestração: Claude Code nativo (subagents + skills + hooks + MCPs).` (remove S232 history + details sobre orchestrator.py/agents/etc — git log preserva)

**Commit 2 — Relocate CC schema gotchas (CLAUDE.md + new rule file)**
- Create `.claude/rules/cc-gotchas.md` com frontmatter `paths: ['.claude/settings.json', '.claude/settings.local.json', 'hooks/**', '.claude/hooks/**']` + conteúdo L84-92 refatorado (sem data `(abril/2026)`, sem commit hash `9ef3b78 (S235b)`)
- `CLAUDE.md`: delete section completa L83-92 (section header + 4 bullets)

**Commit 3 — `anti-drift.md` remove 8 violação-Sxxx**
- L29 trim final: `...Habit sem gate mecânico decai.`
- L43 trim parênteses: `...full Read proibido a menos que targeted falhe.`
- L54 delete line inteira (Violação S226 Phase A)
- L65 trim frase exemplo S227
- L80 trim `(S219)`
- L86 trim final: `...max 5 linhas per session.`
- L89 trim parênteses: `...Candidate sem commit = lost.`
- L92 trim final: `...completed ao commit.`

**Commit 4 — `known-bad-patterns.md` cleanup**
- L67: `→ guard-write-unified.sh + guard-bash-write.sh` (remove "merged S194..." parenthesis)
- L76: `→ anti-drift.md §EC loop + Stop[0] silent execution check` (remove "S219: enforcement mecanico")
- L106: remove "S241 obs" do KBP-32 pointer
- L109: remove `§Addendum S243` e compress KBP-33 mantendo lista operacional dos 7 bypasses
- L88 (KBP-26): **KEEP** — pointer a plano archive específico tem valor de rastreamento

**Commit 5 — State files (HANDOFF + CHANGELOG)**
- Append S244 line em CHANGELOG.md
- Update HANDOFF.md §P0 (marcar detox done, Tiers 3-5 restantes)

Cada commit isolado (anti-drift §Scope "one concern per commit"). Ordem permite bisect: se commit N quebra algo, revert N sem afetar N-1.

---

## Fora de scope (explícito)

- Tiers 3-5 docs-polish (HANDOFF pendente) — sessão separada
- HANDOFF.md / CHANGELOG.md (são state, não config)
- Skills (`.claude/skills/*/SKILL.md`) — fora do pedido
- Agent definitions (`.claude/agents/*.md`) — fora do pedido
- `.claude/agent-memory/evidence-researcher/` — agent-scoped, não auto-load global
- Hooks (`.claude/hooks/` + `hooks/`) — fora do pedido explícito
