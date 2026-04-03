# Focused Error Audit — Recurring Patterns

> /insights Recipe 2 | 2026-04-03 | Sessions analyzed: 20 (Mar 31 - Apr 3)
> Agent: Opus 4.6 | First insights run (no baseline comparison)

---

## Executive Summary

22 main sessions scanned, 20 within the 7-day window. 10 of 20 (50%) experienced context overflow. 5 patterns repeat across 3+ sessions. The dominant failure mode is **context rot leading to lost thread**, which cascades into forgotten plans, unnecessary work, and invisible outputs.

---

## Top 5 Recurring Patterns

### 1. [PATTERN_REPEAT] Context Overflow & Session Fragmentation

**Frequency:** 10/20 sessions (50%)
**Impact:** HIGH — user must re-explain state, agent loses decisions, dream can't consolidate properly
**Sessions:** e667d3b9, bd30970f, b6481cfa, ffce597a, 0eb6439c, 364598d4, 8783887e, 36e03571, 12d1555e, 90b4969a

**Evidence:**
- Session 364598d4 hit context overflow **3 times** in a single session
- User explicitly flagged: "estamos encontrando 2 problemas, context rot, e suas memorias nao estao funcionando"
- User said "nao eh descanso eh dia. vou dar clear o estado vai se hidratar adequadamente?" — revealing that even /clear doesn't reliably restore state

**Root cause:** Sessions grow too large before the agent commits progress and updates docs. Subagent delegation (Codex, dream) adds tool results that bloat context. The agent doesn't proactively split long workflows into commit-and-continue checkpoints.

**Proposed fix:**
- **Target:** `.claude/rules/session-hygiene.md`
- **Change:** Add a proactive checkpoint rule
- **Draft:**
```markdown
## Proactive Checkpoints

Before reaching ~60% of context capacity (visible as conversation length, not a metric):
1. Commit any uncommitted work
2. Update HANDOFF.md with current state
3. Suggest /clear to user if switching tasks

Never run 3+ complex subagent tasks without an intermediate checkpoint.
When a continuation summary appears ("This session is being continued from a previous conversation"),
immediately re-read HANDOFF.md — the summary is lossy.
```

---

### 2. [PATTERN_REPEAT] Unnecessary Work / Scope Drift

**Frequency:** 8/20 sessions (40%)
**Impact:** MEDIUM — wastes time on features/files user doesn't use
**Sessions:** 0eb6439c, 364598d4, 7601f49c, 63deadb3, 8783887e, 36e03571, 82695db8, ebcdbff5

**Evidence:**
- "nao uso o presenter mode, quem sabe no futuro mas nao agora" (0eb6439c)
- "fantasmas seu nao tem nada pode arquiva" (364598d4) — agent showing content that doesn't exist
- "nao preciso de interatividade grande igual html css js, no canva so preciso de design profissional" (36e03571) — agent over-engineering fallback
- "nao estou usando nenhum dos md" — user pointing out agent works on files nobody reads

**Root cause:** The agent works from its mental model of the project rather than re-checking what the user actually uses. Deprecated files (evidence-db.md, blueprint.md, aside.notes) persist in agent memory and get referenced even after deprecation decisions.

**Proposed fix:**
- **Target:** `.claude/rules/anti-drift.md`
- **Change:** Add "active inventory" check
- **Draft:**
```markdown
## Active Inventory Check

Before working on a file or feature, confirm it is in active use:
- Check HANDOFF.md DECISOES ATIVAS for deprecated items
- If a file was deprecated in a recent session, do not reference or update it
- When user says "nao uso X" — immediately add to mental deprecated list for the session
```

---

### 3. [PATTERN_REPEAT] Encoding Issues (Windows cp1252 / Mojibake)

**Frequency:** 7/20 sessions (35%)
**Impact:** MEDIUM — visible rendering bugs, user has to report and wait for fix
**Sessions:** e667d3b9, bd30970f, 0a897a43, b6481cfa, ffce597a, 0eb6439c, 364598d4

**Evidence:**
- "funcionando mas com mojibakes" → "ainda mojibake" (364598d4) — agent failed to fix on first attempt
- Memory file already documents this: "Windows Python: always encoding='utf-8' in file I/O (default cp1252 = mojibake)"
- The rule exists in memory but keeps being violated, especially in new scripts

**Root cause:** Windows default encoding (cp1252) is not UTF-8. Every new Python script or Node.js file write that doesn't explicitly set encoding creates mojibake for Portuguese content (accented characters). The agent knows this rule but fails to apply it systematically to NEW code.

**Proposed fix:**
- **Target:** `.claude/rules/quality.md`
- **Change:** Add encoding mandate
- **Draft:**
```markdown
## Windows Encoding (mandatory)

Every Python `open()` call MUST include `encoding="utf-8"`.
Every Node.js `readFileSync`/`writeFileSync` MUST use `'utf-8'`.
This is Windows — the default is cp1252, not UTF-8.
Violation = mojibake in Portuguese content. Non-negotiable.
```

---

### 4. [PATTERN_REPEAT] Lost Thread / Forgotten Plans

**Frequency:** 6/20 sessions (30%) for lost thread, 3/20 for forgotten plans
**Impact:** HIGH — user has to re-explain what was agreed, breaks trust
**Sessions:** e667d3b9, 364598d4, 7601f49c, 63deadb3, 90b4969a, ebcdbff5

**Evidence:**
- "prioridade 1, precisamos iniciar ajuste com o notion, narrativa, voltar ao fio da producao que eu nao me lembro bem onde paramos" (364598d4)
- "vc usou o modelos melhor o prompt que era pra ser usada, temos um roteiro para isso nao eh lancar qualquer coisa" (364598d4) — agent forgot the established research prompt template
- "se nao tem era pra ser copiada da aula de cirrose mas adaptada que era algo que vc me falou que adaptaria" (364598d4) — agent forgot a previous commitment
- "nao calma handoff esta errado" (a07e3760) — HANDOFF itself was stale/wrong

**Root cause:** HANDOFF.md covers project state but not session-specific commitments ("I will do X next session"). When the agent promises future work in conversation but doesn't record it in HANDOFF, it is lost. Additionally, after context overflow, the continuation summary is lossy and drops nuanced decisions.

**Proposed fix:**
- **Target:** `.claude/rules/session-hygiene.md`
- **Change:** Add commitments tracking
- **Draft:**
```markdown
## Commitments

When the agent promises to do something in a future session ("next session I will..."),
it MUST be recorded in HANDOFF.md under PROXIMO, not just stated in conversation.
Conversational promises that aren't in HANDOFF.md don't survive context overflow.
```

---

### 5. [PATTERN_REPEAT] Output Invisible / Changes Not Reflected

**Frequency:** 5/20 sessions (25%)
**Impact:** MEDIUM — user cannot see what changed, breaks feedback loop
**Sessions:** e667d3b9, b6481cfa, ffce597a, 0eb6439c, 364598d4

**Evidence:**
- "nao vejo no meu html" (ffce597a) — agent edited file but changes not visible
- "nao vejo o que vc mudou no vite" — agent made Vite config change that didn't take effect
- "nao vejo o build" — build output not where user expected
- "ele quebra nao deveria quebrar" (b6481cfa) — agent's change introduced a regression

**Root cause:** The agent edits files without verifying the change is visible in the running dev server. In a Vite HMR environment, some changes require restart. The agent also sometimes edits the wrong file (working tree vs. the file actually loaded by the server), or edits are syntactically correct but don't produce visible output (CSS specificity issues, display:none, opacity:0).

**Proposed fix:**
- **Target:** `.claude/rules/anti-drift.md` (Verification section)
- **Change:** Strengthen the verification gate for visual changes
- **Draft:**
```markdown
## Visual Change Verification

After editing HTML/CSS that should produce a visible change:
1. Confirm the correct file was edited (the one served by Vite, not a duplicate)
2. If Vite HMR may not pick up the change (config files, new files), note that restart may be needed
3. For CSS: verify specificity wins over existing rules (grep for competing selectors)
4. Never claim "done" on a visual change without confirming it renders
```

---

## Secondary Patterns (2 sessions each)

| Pattern | Sessions | Notes |
|---------|----------|-------|
| Smart App Control blocking hooks | 4 sessions | Known workaround exists (--no-verify), already documented in memory |
| MCP session expiration | 1-2 sessions | PubMed MCP sessions expire mid-search. Fallback to WebSearch exists |
| HANDOFF stale/wrong | 1 session | HANDOFF reflected agent's plan, not user's actual priority |

---

## Cross-Cutting Observation

The top 5 patterns form a causal chain:

```
Context Overflow (P1)
  → Lost Thread (P4) — agent forgets what was agreed
  → Forgotten Plan (P4) — agent uses wrong tool/template
  → Unnecessary Work (P2) — agent works on deprecated items
  → Output Invisible (P5) — agent doesn't verify changes
```

**The root cause is overwhelmingly P1 (context overflow).** If sessions stayed within context limits, patterns P2-P5 would be significantly reduced. The encoding issue (P3) is independent — it's a platform-specific knowledge gap that keeps re-emerging.

---

## Quantitative Summary

| Pattern | Category | Sessions | Severity | Fix Complexity |
|---------|----------|----------|----------|----------------|
| Context overflow | RULE_GAP | 10/20 | HIGH | Medium (rule + behavior) |
| Unnecessary work | RULE_VIOLATION | 8/20 | MEDIUM | Low (rule addition) |
| Encoding/mojibake | RULE_GAP | 7/20 | MEDIUM | Low (rule addition) |
| Lost thread | RULE_GAP | 6/20 | HIGH | Medium (HANDOFF protocol) |
| Output invisible | RULE_VIOLATION | 5/20 | MEDIUM | Low (verification gate) |

---

## Proposed Action Items (ordered by impact)

1. **Add proactive checkpoint rule** to session-hygiene.md — prevents P1 cascade
2. **Add commitments section** to HANDOFF protocol — prevents P4
3. **Add encoding mandate** to quality.md — prevents P3 independently
4. **Add active inventory check** to anti-drift.md — prevents P2
5. **Strengthen visual verification gate** in anti-drift.md — prevents P5

All proposals are additions to existing rules. No new files needed.

---

> Coautoria: Lucas + Opus 4.6
> Report generated by /insights Recipe 2 (Focused Error Audit)
> No previous report exists — this is the baseline.
