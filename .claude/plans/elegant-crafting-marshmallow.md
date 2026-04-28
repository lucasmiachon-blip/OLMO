# Audit S270 Follow-up — Críticos + ALTOs baratos (S271)

> Sessão: TBD (Lucas confirma na aprovação) · 2026-04-28 · Read-only até OK

---

## Contexto

Em S270 (commit `bceb3f4`) Lucas comissionou auditoria adversarial — relatório em `.claude/plans/snazzy-purring-dream.md` listou **15 findings**: 1 CRÍTICO + 7 ALTO + 4 MÉDIO + 3 BAIXO. Lucas pediu agora "começar pelos críticos". Este plano executa o subset **mecânico** (file:line precisos, baixo risco, alto retorno) e **defere explicitamente** os findings que exigem decisão de governance.

**Por que separar mecânico vs governance:** misturar fix de Mermaid (30s) com decisão "Pre-mortem é ritual ou regra?" produz commit gordo onde a decisão honesta vira footnote. Audit utility = trail decisional auditável.

---

## Scope INCLUSO (este plano)

| ID | Severidade | Finding | Custo |
|---|---|---|---|
| **C1** | CRÍTICO | Mermaid L3 `fill:#2ecc71` mente vs `:110` "NOT IMPLEMENTED" | 30s |
| **A1** | ALTO | Component count drift — FS=21/19 vs README/ARCHITECTURE=19/18 | 5min |
| **A2** | ALTO | EC loop body duplicado em 5 arquivos sem master | 15min |
| **A5** | ALTO | KBP-06/15 broken refs — `feedback_*.md` ausentes (verificado 0 files) | 5min |
| **B2** | BAIXO | `anti-drift.md:10` "16 agents pendentes" stale | 2min |

**Total estimado:** ~30 minutos de Edits + 5min commit/verify.

---

## Scope EXCLUSO (governance — outro thread, sem decisão tomada)

| ID | Decisão pendente |
|---|---|
| A3 | Pre-mortem (Gary Klein) — 0 aplicações em 10 sessões. Apply consistentemente OU downgrade para opcional? |
| A4 | `[budget]` gate — 0 hits. Apply OU downgrade? |
| A6 | HANDOFF.md 109 li vs cap 50. Truncar (mover §0 para per-lane plans) OU subir cap declarado com justificativa? |
| A7 | Catalog inflation — 13/19 skills + 11/21 agents zero-use 27d. Tag `intentional-dormant` vs `candidate-delete` 1-a-1 |
| M1-M4, B1, B3 | Defer próximo audit pass |

**Por que defer:** estas decisões mudam *regras* (não conteúdo). KBP-37 §Cut calibration: defer válido com gate explícito = "decisão de governance pendente input do owner".

---

## Phase 0 · Session naming (pré-Edit)

**Pergunta:** qual nome da sessão S271?
**Sugestões:**
- `audit-fix-criticos` (descritivo da work)
- `s270-followup` (continuidade)
- `audit-honesty` (curto, captura espírito C1)

**Action:** `echo -n "<nome>" > .claude/.session-name` (atualiza statusline).
**Lucas decide na aprovação.**

---

## Phase 1 · C1 — Mermaid L3 honesty

**File:** `docs/ARCHITECTURE.md`

**Edit (1 linha):**
```diff
-    style L3 fill:#2ecc71,color:#fff
+    style L3 fill:#95a5a6,color:#fff
```

**Bonus opcional (mesmo Edit, +6 chars):** alterar texto do nó L3 :91 para sinalizar status:
```diff
-    L2 --> L3[L3 Cost Circuit Breaker<br>warn@100 block@400 calls/hr]
+    L2 --> L3[L3 Cost Circuit Breaker<br>warn@100 block@400 calls/hr<br>NOT IMPL]
```

**Rationale cor:** `#95a5a6` = cinza Wet Asphalt (Flat UI). Distingue de `#2ecc71` Emerald (DONE) e `#f39c12` Orange (BASIC, atual L6). Padrão de status visual já estabelecido no diagrama.

**Verificação:** abrir ARCHITECTURE.md em preview Mermaid → L3 visualmente ≠ L2/L4. Tabela `:106-114` permanece coerente (L3 já marcado NOT IMPLEMENTED na linha 110).

---

## Phase 2 · A1 — Component count sync

**Source of truth:** filesystem `ls .claude/agents/*.md | wc -l = 21`, `ls .claude/skills/*/SKILL.md | wc -l = 19`. Verified `bash` antes de plan.

**Breakdown reconcile:** "9 core + 7 debug-team + 3 research wrappers = 19" → S269 adicionou 2 D-lite research wrappers (`gemini-dlite-research`, `perplexity-dlite-research` per HANDOFF). Novo: "9 core + 7 debug-team + 5 research wrappers" = 21.

**Files + edits:**

| File | Linha | Antes | Depois |
|---|---|---|---|
| `README.md` | 17 | "19 subagents (9 core + 7 debug-team + 3 research wrappers)" | "21 subagents (9 core + 7 debug-team + 5 research wrappers)" |
| `README.md` | 18 | "18 skills" | "19 skills" |
| `README.md` | 37 | "19 CC subagents + 18 skills" | "21 CC subagents + 19 skills" |
| `docs/ARCHITECTURE.md` | 5 | "S266 \| 2026-04-27" | "S271 \| 2026-04-28" |
| `docs/ARCHITECTURE.md` | 12 | "19 subagents..." | "21 subagents..." (mesmo padrão README) |
| `docs/ARCHITECTURE.md` | 13 | "18 skills" | "19 skills" |
| `docs/ARCHITECTURE.md` | 26 | "Claude Code Subagents (19)" | "Claude Code Subagents (21)" |

**CLAUDE.md já correto** (21/19) — não tocar.

**Spot-check pós-Edit:** `grep -rn "19 subagents\|18 skills" --include="*.md"` deve retornar 0 hits em README/ARCHITECTURE (apenas histórico em CHANGELOG-archive aceitável).

---

## Phase 3 · A2 — EC loop master designation

**Master canônico:** `.claude/rules/anti-drift.md` §EC loop (linhas 84-107). Já é o mais completo (23 li com bloco ``` ``` + parágrafos explicativos abaixo).

**Conversão para pointer:**

### CLAUDE.md ENFORCEMENT #7 (atual: linha 11)
```diff
-7. **EC loop antes de side effects.** Antes de Edit/Write, Bash com escrita, commit/push, ou agent writer: seguir `.claude/rules/anti-drift.md §EC loop` (Verificacao → Evidencia → Gap A3 → Steelman obrigatorio → Mudanca proposta → Por que e mais profissional → Pre-mortem Gary Klein → Rollback/stop-loss → Verificacao pos-mudanca → Learning capture → Autorizacao). Sem OK explicito do Lucas no thread atual = STOP.
+7. **EC loop antes de side effects.** Antes de Edit/Write, Bash com escrita, commit/push, ou agent writer: seguir `.claude/rules/anti-drift.md §EC loop` (master). Sem OK explicito do Lucas no thread atual = STOP.
```
Remove a listagem de fases inline (já está em master). Mantém trigger + STOP rule.

### HANDOFF.md (atual: linha 23)
```diff
-- EC loop obrigatorio persistido em `AGENTS.md`, `CLAUDE.md`, `.claude/rules/anti-drift.md` e `.claude/context-essentials.md`: Verificacao -> Evidencia -> Gap A3 -> Steelman -> Mudanca -> Por que profissional -> Pre-mortem -> Rollback/stop-loss -> Verificacao pos -> Learning capture -> AUTORIZACAO.
+- EC loop master: `.claude/rules/anti-drift.md §EC loop`. Forks vivos: `AGENTS.md` (Codex/Gemini cross-CLI). Pointers: `CLAUDE.md` ENFORCEMENT #7, `.claude/context-essentials.md`.
```

### .claude/context-essentials.md (atual: linha 25)
```diff
-- Antes de side effect: EC loop visivel = Verificacao -> Evidencia -> Gap A3 -> Steelman obrigatorio -> Mudanca proposta -> Por que e mais profissional -> Pre-mortem (Gary Klein) -> Rollback/stop-loss -> Verificacao pos-mudanca -> Learning capture -> AUTORIZACAO Lucas. Sem OK explicito no thread atual = STOP.
+- Antes de side effect: EC loop visível — ver master `.claude/rules/anti-drift.md §EC loop`. Sem OK explícito no thread atual = STOP.
```

### AGENTS.md — manter cópia (cross-CLI), adicionar header de versionamento
**File:** `AGENTS.md` (linhas 13-29 são a cópia EC loop)

**Edit:** acima da linha 13 (no início da seção), adicionar:
```markdown
> **Fork de `.claude/rules/anti-drift.md §EC loop`** — re-sync ao mudar master. Codex/Gemini não leem CLAUDE.md.
```

**Risk gate:** drift entre master e AGENTS.md fork. Mitigation:
1. Header explícito declara fork + dependência.
2. Stop[0] silent-execution check (settings.json:406) já é prompt-based — não muda com esta refactor.
3. Próximo `/insights` deve checkar consistência fork (manual).

**Spot-check pós-Edit:** `grep -rn "Fase 4 - Pre-mortem" --include="*.md"` deve retornar **2 hits apenas**: `anti-drift.md:95` (master) + `AGENTS.md:24` (fork). Antes do Edit: 2 hits. Esperado: 2 hits (não muda contagem; muda 3 prosa-resumida em pointer).

---

## Phase 4 · A5 — KBP-06/15 broken refs

**Verificação prévia:**
- `Glob **/feedback_*.md` → **0 arquivos** (confirmado este turn)
- `ls C:/Users/lucas/.claude/memory/` → **No such file or directory** (confirmado este turn)
- Diretório `~/.claude/memory/` declarado em CLAUDE.md user-global §Memory Governance mas **inexistente**

**Edits em `.claude/rules/known-bad-patterns.md`:**

```diff
 ## KBP-06 Agent Delegation Without Verification
-→ feedback_agent_delegation.md (memory)
+→ anti-drift.md §Delegation gate #4 + KBP-32 (spot-check AUSENTE claims)
```

```diff
 ## KBP-15 Write Race via External Script
-→ feedback_tool_permissions.md §Write race (memory)
+→ anti-drift.md §Concurrent agent commit safety + KBP-51
```

**Justificativa:** anti-drift.md §Delegation gate item #4 já cobre "Agent produces research → result written to plan file BEFORE reporting to user" (verificação). KBP-32 cobre spot-check AUSENTE. KBP-51 cobre concurrent commit safety (write race moderno). Conteúdo equivalente já vivo em master.

**Spot-check pós-Edit:** `Glob **/feedback_*.md` ainda 0 (não criamos novos arquivos). `grep -rn "feedback_.*\.md (memory)" .claude/rules/` retorna 0 (refs broken eliminadas).

---

## Phase 5 · B2 — anti-drift.md tone propagation cleanup

**File:** `.claude/rules/anti-drift.md`
**Edit (linha 10):**
```diff
-Be terse unless Lucas explicit indicates verbose. Concise, signal-rich, no padding. Lists > prose. Cite file:line/SHA/PMID inline. Skip preambles ("I'll...", "Let me..."). Skip postscripts ("Hope this helps."). Sub-agents `.claude/agents/*.md` propagam este default — S262 enforce per-agent (16 agents pendentes).
+Be terse unless Lucas explicit indicates verbose. Concise, signal-rich, no padding. Lists > prose. Cite file:line/SHA/PMID inline. Skip preambles ("I'll...", "Let me..."). Skip postscripts ("Hope this helps."). Sub-agents `.claude/agents/*.md` propagam este default.
```

**Rationale:** "(16 agents pendentes)" é claim sem tracking file (audit B2). Remover é mais honesto que inventar count atualizado. Regra-base permanece.

---

## Phase 6 · HANDOFF/CHANGELOG/Commit

### HANDOFF.md
**Edit:** §0 add S271 status:
```markdown
- S271 audit followup: C1 Mermaid L3 cinza+[NOT IMPL]; A1 counts 21/19 sync; A2 EC loop master+pointers; A5 KBP-06/15 refs fixed; B2 tone propagation count claim removed. Governance defer: A3 Pre-mortem, A4 budget, A6 HANDOFF cap, A7 catalog inflation.
```

### CHANGELOG.md
Append S271 section (5 linhas Aprendizados max, 1 linha por finding fixado):
```markdown
## S271 — 2026-04-28 — audit-fix (C1+A1+A2+A5+B2)
- C1 [docs] ARCHITECTURE.md L3 fill `#2ecc71` → `#95a5a6` + `[NOT IMPL]` label (Mermaid honesty)
- A1 [docs] README.md + ARCHITECTURE.md counts sync 21 agents / 19 skills (FS truth)
- A2 [docs] EC loop master `anti-drift.md §EC loop`; CLAUDE.md/HANDOFF.md/context-essentials.md → pointer; AGENTS.md fork header
- A5 [rules] KBP-06 → `anti-drift.md §Delegation gate #4 + KBP-32`; KBP-15 → `§Concurrent agent commit safety + KBP-51` (broken refs eliminadas)
- B2 [rules] anti-drift.md `(16 agents pendentes)` removido — claim sem tracking file
- Aprendizados: (1) audit utility = trail decisional auditável — separar mecânico de governance preserva commits limpos; (2) `~/.claude/memory/` declarado em CLAUDE.md user-global mas nunca existiu — KBP design depende de pointer integrity, governance pending; (3) component counts sem hook auto-validador continuam driftando — Cenário 1 do pre-mortem S270 a 2 sessões de manifestar.
```

### Commit
```bash
git add docs/ARCHITECTURE.md README.md CLAUDE.md HANDOFF.md .claude/context-essentials.md AGENTS.md .claude/rules/anti-drift.md .claude/rules/known-bad-patterns.md CHANGELOG.md .claude/.session-name .claude/plans/elegant-crafting-marshmallow.md
git commit -m "docs(audit): S271 — fix C1+A1+A2+A5+B2 from S270 audit"
```

**KBP-51 awareness:** add per-file (não `-A`). `git fetch origin` + `status --short` antes do stage (concurrent agent guard).

---

## Verificação end-to-end

```bash
# 1. Mermaid L3 cinza
grep -n "style L3" docs/ARCHITECTURE.md
# Esperado: linha 99 com fill:#95a5a6

# 2. Counts sync
ls .claude/agents/*.md | wc -l           # = 21
ls .claude/skills/*/SKILL.md | wc -l     # = 19
grep -rn "19 subagents\|18 skills" README.md docs/ARCHITECTURE.md
# Esperado: 0 hits

# 3. EC loop pointers
grep -c "Fase 4 - Pre-mortem" CLAUDE.md HANDOFF.md .claude/context-essentials.md
# Esperado: 0:0:0 (todos 3 = pointer)
grep -c "Fase 4 - Pre-mortem" .claude/rules/anti-drift.md AGENTS.md
# Esperado: 1:1 (master + fork)

# 4. KBP refs
grep -E "feedback_.*\.md \(memory\)" .claude/rules/known-bad-patterns.md
# Esperado: 0 hits

# 5. tone propagation
grep "16 agents pendentes" .claude/rules/anti-drift.md
# Esperado: 0 hits
```

---

## Out of scope explícito (não fazer neste plano)

- ❌ Criar arquivos `feedback_*.md` em `~/.claude/memory/` (KBP-15 write race + auto-confessado em audit "NÃO criar arquivo `pre-mortem-log.md` para rastrear regras não-aplicadas")
- ❌ Hook auto-validando counts FS↔docs (ALTO/30min do audit §7 — incluído como follow-up futuro, não nesta sessão por escopo)
- ❌ Decidir A3/A4/A6/A7 (governance — thread separado)
- ❌ Tocar `.claude/skills/` ou `.claude/agents/` filesystem (counts são CONSEQUÊNCIA, não causa)

---

## Rollback / stop-loss

**Trigger objetivo de abort:**
- Se durante Phase 3 (EC loop pointers) o spot-check `grep -c "Fase 4 - Pre-mortem"` retornar contagem inesperada → STOP, reportar antes de continuar.
- Se Edit em CLAUDE.md/HANDOFF.md falhar por old_string mismatch (KBP-25) → Read full range +20 li, NÃO retry mecânico.
- Se `git status` antes do commit mostrar arquivos modificados não previstos → STOP, identificar fonte (concurrent agent? hook?) antes de stage.

**Rollback:** todos Edits são em files versionados. `git restore <files>` reverte. Plano não cria files novos exceto `.claude/.session-name` (texto trivial, gitignored ou versionado per Lucas decision).

---

## Confidence per claim

- **HIGH:** C1 (file:line + visual rule verificada), A1 (FS counts verificadas), A5 (memory dir non-existence verificada), B2 (line text verificada).
- **HIGH:** A2 master = anti-drift.md (linhas 84-107 lidas), pointer targets identificados.
- **MEDIUM:** A2 risco fork drift AGENTS.md (mitigation = header declarativo, depende de Lucas/agent ler ao mudar master).
- **HIGH:** governance defer rationale (auditado em §7 do audit + EC loop §Cut calibration KBP-41).
