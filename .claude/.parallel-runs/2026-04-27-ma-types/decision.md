# Decision — S264 Bench Outcome

> **Path:** `.claude/.parallel-runs/2026-04-27-ma-types/decision.md`
> **Date:** 2026-04-27 | **Session:** 264.c
> **Outcome:** **KEEP-SEPARATE provisional + D-lite refactor track S265+**
> **Decision authority:** Lucas Miachon (KBP-39 override rule applies if Lucas overrides tech-driven recommendation)
> **Process trail:** plan §S264.b initial recommendation → Codex peer-review → plan §S264.c recalibrated → this decision

---

## Outcome (per-perna verdict)

### Canonical (S264 lock — ✅)

| Perna | Canonical implementation | Justificativa empírica |
|---|---|---|
| **1 Gemini broad** | `.claude/scripts/gemini-research.mjs` (Path A `.mjs` script) | 3/3 ✅ Q1+Q2+Q3 completed reliably (32-38s, ~7.6KB prose markdown each); direct invocation = no orchestration tax. |
| **5 Perplexity Tier 1** | `.claude/scripts/perplexity-research.mjs` (Path A `.mjs` script) | 3/3 ✅ Q1+Q2+Q3 completed reliably (~120-180s, ~33-44KB prose). **Caveat:** API ignora system_prompt "table only" sob narrative user query (`<think>` confessou) — afeta tanto script quanto wrap agent (mesmo modelo/API), bug ortogonal. |
| **6 NLM** | `nlm notebook query` Bash CLI direto | 3/3 ✅ Q1+Q2+Q3 (post-relogin OAuth ~20min TTL gate). Não migrável (OAuth interactive). |
| **7 Codex cross-family** | `.claude/agents/codex-xhigh-researcher.md` (Agent thin-wrapper) | **Strongest perna** — 3/3 ✅, **0% PMID fab** across 14 sampled (NCBI-verified inline), 100% schema-strict, ~262s avg. Body design = 1 phase (`codex exec --output-schema` enforces JSON nativo). **Pattern canonical robusto** (S259 POC validated). |
| **2 Evidence-Researcher** | `.claude/agents/evidence-researcher.md` (Agent MCP-grounded, post §Fase 1.5 fix S264.a) | Q1 ✅ pos-fix (1067s, 9 sources MCP-verified, 0 CANDIDATE, 4 MCPs sem biomcp). ROBINS-I bonus finding (PMID 27733354). §Fase 1.5 Bench Mode unblocks slide novo dispatches. |

### Experimental (NOT canonical — D-lite track required S265+)

| Perna | Experimental wrap | Status | Gate to canonical |
|---|---|---|---|
| 1' Gemini wrap | `.claude/agents/gemini-deep-research.md` | 1/3 emit ✅ (Q3 only); Q1 hit `maxTurns:15` cap; Q2 HTTP 429 (orchestration confound, sequencial dispatches resolveriam) | D-lite refactor (single-Bash deterministic API→raw→JSON→print) + smoke + re-bench. Se 6/6 emit → MERGE; senão MERGE-BACK. |
| 5' Perplexity wrap | `.claude/agents/perplexity-sonar-research.md` (maxTurns:25 post S264.a) | 0/3 emit clean Path B (raw API responses 25-61KB on disk; agents stop natural pré-Phase 6 emit). **Q1 win:** 4/4 PMIDs Tier 1 verified (BMJ ×2, Ann Intern Med ×2) — único Tier 1 filtering empirical | Idem D-lite track. |

### Provisional caveat (per Codex peer-review)

KEEP-SEPARATE é **provisional**, não permanent. Trigger pra revisão:
- **D-lite refactor S265+ → re-bench Phase 1.3 + Phase 3** decide entre MERGE (Path B canonical) vs MERGE-BACK (sunset Path B specs experimental).
- Sample size atual = 6 dispatches Path B = small. D-lite re-bench com bigger sample + transcript/stop_reason capture vai material change framing.

---

## Justificativas (verificáveis)

1. **Codex bracket prova thin-agent works**: 0% PMID fab across 14 sampled = thin wrapper + deterministic runner pattern is robust. Não precisa MERGE-BACK wholesale.

2. **`.mjs` scripts prova script reliability**: 9/9 dispatches completados (gemini ×3, perplexity ×3, nlm ×3) sem fail. Não precisa MERGE wholesale (.mjs working canonical).

3. **`gemini-deep-research` + `perplexity-sonar-research` emit unreliability empírica**: 1/6 clean emit + 5/6 stop pre-Phase-6 (4 stop natural ~15 turns + 1 HTTP error orchestration confound + 1 hit cap). Pattern ≠ random noise — likely body chattiness (6-phase reasoning chain) OR Anthropic subagent runtime stop behavior. Not yet proven sem transcript + stop_reason capture.

4. **D-lite refactor cost reasonable per Codex**: agent body já tem comandos curl + parse — refactor é collapse (single-Bash + extract + print), não rewrite from scratch. Cost real = validação (smoke + re-bench), não código novo. Estimate 30-60min not 2-3h.

5. **KBP-48 nuance** (Codex blind spot 3 acknowledged): "wrap = sempre agente" forte demais. Reformulação deferred S265: *"APIs externas devem ter contrato determinístico/auditável; se wrapped por agent, agent precisa ser thin + verifiable"*. Codex-xhigh-researcher passes; gemini-deep + perplexity-sonar (current state) don't. D-lite refactor goal = pass.

---

## Decision matrix application

| Original outcome | Trigger met? | Verdict |
|---|---|---|
| **MERGE** (sunset .mjs) | NÃO — Path B 1/6 emit, .mjs 9/9 emit. Agent path not yet reliable enough to replace scripts. | Reject |
| **KEEP-SEPARATE** | SIM — different strengths per perna (thin-agent Codex strongest, scripts reliable hot-path, chatty wraps experimental) | **ACCEPT (provisional)** |
| **MERGE-BACK** | NÃO — Path B Q1 perplexity-sonar Tier 1 filtering = real value-add over `.mjs` que ignora system_prompt. Don't archive yet. | Reject |

**Lucas-override rule (KBP-39):** Lucas pode override se julgamento qualitativo blind read sugerir A ou MERGE-BACK. Atualmente decisão tech-driven concorda com Codex peer-review.

---

## S265 carryover (post-S264 close)

- **D-lite refactor track** (gemini-deep + perplexity-sonar bodies) → smoke + re-bench → MERGE/MERGE-BACK lock
- **KBP-Candidate-D formalization** ONLY post D-lite re-bench OR transcript/stop_reason capture (concedido a Codex blind spot 1)
- **KBP-48 reformulation** em `.claude/skills/research/SKILL.md` + `known-bad-patterns.md` para "thin + verifiable" framing
- **SubagentStop hooks experiment** (Codex blind spot 2) — alternative architectural lever vs maxTurns
- **Phases 6-8 master plan** (Living HTML `s-ma-types.html` + slide build + QA) — unblocked após D-lite decision lock

---

## Bench substrate preserved (ground truth pra futuras decisões)

- `path-a/` — 13 substantive outputs (corrected per Codex F1)
- `path-b/` — 1 validated JSON + 14 raws/payloads/preflight (orchestrator-parse opt-in se Lucas quiser, não esta sessão)
- `smoke/` — 6 files Phase 1.3 Q "I² threshold for substantial"
- `bench-log.md` — chronicle S264.a + S264.b state briefing
- `agent-adjustments.md` — diffs + rationale S264.a fixes
- `codex-peer-review.md` — peer-review verbatim + Claude response
- `decision.md` — esta file

---

## Lucas signoff

[ ] **APROVADO** — KEEP-SEPARATE provisional + D-lite track S265+
[ ] **OVERRIDE** — Lucas escolhe outro outcome (MERGE / MERGE-BACK / outro). Razão: ___

Lucas: _________________________ Data: 2026-04-27
