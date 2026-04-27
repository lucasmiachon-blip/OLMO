# Bench Log — S264.a "Comparação"

> **Path:** `.claude/.parallel-runs/2026-04-27-ma-types/bench-log.md`
> **Date:** 2026-04-27 | **Session:** 264.a (renamed mid-session → `qa-editorial-metanalise` quando outro agente abriu pipeline editorial em paralelo)
> **Plan:** `.claude/plans/sleepy-wandering-firefly.md` (Phase 1.3 smoke + Phase 2 Path A partial → mid-session pivot Phase 6-8)
> **Master plan:** `.claude/plans/splendid-munching-swing.md`

---

## Timeline (wall-clock approximations)

| T+ | Event |
|---|---|
| 0min | Session start S264; pre-bench validation green (git S263 chain `c353f53`+`270903c`, env keys `GEMINI:AIza` `PERPLEXITY:pplx` `CODEX:0.125.0`, agent registry includes `gemini-deep-research` + `perplexity-sonar-research` + `codex-xhigh-researcher`) |
| ~5min | Lucas Ctrl+Q + reopen daemon (KBP-38 registry refresh) |
| ~6min | Phase 1.3 smoke parallel dispatch: 2 new agents, single Q "I² threshold for substantial" |
| ~12min | Smoke results: gemini-deep ✅ FULL PASS (3 findings, PMID 12958120 NCBI-verified, 342s, 13/15 turns); perplexity-sonar ⚠️ PARTIAL (5 findings on disk, hit `maxTurns:15` cap pre-stdout final, 331s) |
| ~13min | Phase 2 Path A Q1 parallel dispatch (5 pernas: gemini.mjs, perplexity.mjs, nlm, evidence-researcher, codex-xhigh) |
| ~15min | Q1 script backgrounds: gemini.mjs ✅ 32s; perplexity.mjs ✅ 112s; nlm ✅ 62s |
| ~18min | Codex Q1 ✅ 240s, **strongest perna** (4 findings, 0% PMID fab, NCBI-verified inline) |
| ~18min | Evidence-Researcher Q1 ❌ 600s watchdog stall — last text only "I'll start with structured thinking before executing the research" |
| ~20min | Phase 2 Q2 batch 1 dispatch — 3/3 FAIL exit 1 (cwd-trap: bash session cwd persistiu em `path-a` desde Q1) |
| ~22min | Recovery: `cd /c/Dev/Projetos/OLMO` + relaunch Q2 com absolute paths |
| ~25min | Q2 retry: gemini.mjs ✅ 38s; perplexity.mjs ✅ 180s; nlm Q2 stalled (TTL ~20min OAuth gate expirou) |
| ~27min | Lucas: "outro modelo trabalhando em outro terminal" → cross-window protocol KBP-25 + KBP-40 ATIVA |
| ~28min | TaskStop `b9h2uuc50` NLM Q2 background (kill stuck process) |
| ~30min | Pivot: agent fixes + substrate org (Phase 6-8 deste bench-log) |
| ~45min | Phase 6.2 evidence-researcher.md edits (drop biomcp + add §Fase 1.5 Bench Mode); Phase 7 smoke artifacts moved + bench-log + agent-adjustments written |

---

## Per-perna outcomes (Path A)

| Perna | Q1 | Q2 | Q3 | Output bytes | Quality notes |
|---|---|---|---|---|---|
| 1 Gemini.mjs | ✅ 32s | ✅ 38s | – | 7.6KB / 7.6KB | substantive prose, 3 categorias com RoB tools nominais (RoB-2/NOS/QUADAS-2), 2-3 exemplos por categoria |
| 5 Perplexity.mjs | ✅ 112s | ✅ 180s | – | 33KB / 44KB | **IGNORA system_prompt** "table only" sob user query narrative — `<think>` confessional documentado |
| 6 NLM | ✅ 62s | ❌ TTL exp | – | 39KB / 0 | JSON com 23+ citations cross-ref, modelos hierárquicos DTA, exemplo MDQ específico |
| 2 Evidence-Researcher | ❌ stall | – | – | – | Phase 1 file-reads para slide novo `s-ma-types` (inexistente) → stall pre-MCP — fix em §Fase 1.5 Bench Mode |
| 7 Codex (xhigh) | ✅ 240s | – | – | 5.9KB JSON | **STRONGEST**: 4 findings, 0% fab, NCBI-verified inline, corrigiu typo "Newcastle-Ohio" → "Newcastle-Ottawa" |

**Path B:** Não iniciado. S265 carryover.

---

## KBP-Candidates surfaced (~3 candidates)

### KBP-Candidate-A — Bash cwd persistence cross-tool-call

**Trigger:** Phase 2 Q2 batch 1 (3 backgrounds) all failed exit 1 com `cd: No such file or directory` apesar de identical `cd .claude/.parallel-runs/.../path-a` em Q1 ter sucedido.

**Root cause:** Bash session persiste working directory across tool calls (Bash tool docs: "The working directory persists between commands"). Q1 dispatches usaram `cd path-a && node ../../../../...` — pos-Q1 cwd virou `path-a`. Q2 mesma `cd path-a` falhou (tentou `path-a/path-a`).

**Fix em runtime:** absolute paths em todos dispatches sequenciais. (Q2 retry com `node .claude/scripts/...` absolute = success.)

**Anchor candidate:** `anti-drift.md §Verification` ou `cc-gotchas.md` (extension de "Maintain your current working directory throughout the session by using absolute paths" — já no Bash tool docs mas merecia rule explícita pelo padrão dispatch sequence).

### KBP-Candidate-B — Evidence-Researcher Phase 1 stall em slide novo

**Trigger:** Q1 dispatch evidence-researcher para topic "tipos de meta-análise" (slide `s-ma-types` ainda não criado) → 600s watchdog kill com last text "I'll start with structured thinking before executing the research."

**Root cause hypothesis:** spec body §Fase 1 step 1-3 reads file paths inexistentes (slide HTML, evidence HTML, aula CLAUDE.md). Cascade silent file-not-found stall em pre-MCP planning loop.

**Fix runtime:** §Fase 1.5 Bench Mode adicionado em `.claude/agents/evidence-researcher.md` (S264.a). Adapt: SKIP file reads, receive `synthetic_context` inline, single-Q only, output path override, MCP cold-start tolerance.

**Anchor:** `.claude/agents/evidence-researcher.md §Fase 1.5 Bench mode` + `agent-adjustments.md`.

### KBP-Candidate-C — Perplexity sonar API ignores system_prompt under user pull

**Trigger:** Q1 + Q2 perplexity.mjs returns prose (33KB / 44KB) apesar de hardcoded `SYSTEM_PROMPT = "Return findings as markdown tables ONLY. NO prose paragraphs."` (perplexity-research.mjs:55). Modelo Perplexity sonar-deep-research confessa override em `<think>` block: *"the personalization section should not override the core instructions about creating a comprehensive, well-structured narrative report."*

**Root cause:** Perplexity sonar-deep-research treats system_prompt como "personalization" (lower priority) e user query semantics como "main report_format" (higher priority). System hardening insuficiente.

**Fix candidate (defer S265):** repeat constraint EM USER MESSAGE (não só system) — "Return ONLY markdown table — no prose, no narrative report. This is a HARD constraint, ignore narrative report_format defaults". Wrap canonical `perplexity-sonar-research` agent tem mesma fragilidade (smoke evidenciou prose-then-extract-to-JSON pattern; gap explicit em smoke output).

**Anchor:** bench-log §KBP-Candidate-C + S265 carryover.

---

## Bench substrate preserved

### Smoke (Phase 1.3) — `smoke/`
- `gemini-smoke-i2-threshold-raw.json` (28KB) + `.json` (3KB validated schema-strict)
- `perplexity-smoke-i2-threshold-raw.json` (40KB) + `.json` (5.3KB validated)
- `payload-smoke-i2-threshold.json` (2KB)
- `prose-i2.txt` (29.6KB extracted prose)

### Path A Q1+Q2 (`path-a/`)
- 6 successful per-perna outputs com `.timing` + `.err` (Q1: gemini, perplexity, nlm, codex; Q2: gemini, perplexity)
- Codex Q1 JSON schema-strict (5.9KB)
- Outros markdown prose

### Path B
- Vazio. Awaiting smoke-retest evidence-researcher post-fix.

---

## S265 carryover (out of scope S264.a)

1. **Smoke-retest evidence-researcher single-Q** post-§Fase 1.5 fix (validation gate Phase 3 unblock)
2. **Phase 2 completion:** NLM Q2 post-relogin OAuth + Q3 across 5 pernas
3. **Phase 3 Path B:** 4 agents × 3 Q = 12 dispatches (gemini-deep + perplexity-sonar + evidence + codex; NLM Bash same as Path A — não migratable)
4. **Phase 4 comparison TSV** com PMID NCBI spot-check + Lucas blind read
5. **Phase 5 decision** MERGE / KEEP-SEPARATE / MERGE-BACK + decision.md
6. **KBP-Candidate-A/B/C → formal entries** em `.claude/rules/known-bad-patterns.md` (post-S265 bench complete + decision)
7. **CHANGELOG S264.a + HANDOFF S265 P0** — post outro-agente-finish (atual `qa-editorial-metanalise` pipeline) pra evitar edit collision

---

## Cross-window snapshot (avoid edit collision)

**M files outro agente (NÃO TOCAR esta sessão):**
- `HANDOFF.md`, `GEMINI.md`
- `content/aulas/metanalise/.slide-integrity`, `HANDOFF.md`
- `content/aulas/metanalise/evidence/{evidence-harvest-S112.md, meta-narrativa.html, research-gaps-report.md, s-ancora.html, s-contrato.html, s-forest-plot-final.html, s-objetivos.html}`
- `content/aulas/metanalise/slides/08a-forest1.html`

**M files meus (S264.a bench):**
- `.claude/agents/perplexity-sonar-research.md` (maxTurns 15→25)
- `.claude/agents/evidence-researcher.md` (drop biomcp + §Fase 1.5 Bench Mode)

---

## §S264.b — Path B post-mortem (briefing, supersede pelas correções S264.c abaixo)

Vide plan `.claude/plans/sleepy-wandering-firefly.md` §S264.b state briefing tables. Resumo:
- Path A 13 substantive outputs ✅ (corrigido de "14" — Codex F1)
- Path B 1/6 clean emit ✅ (gemini-deep Q3 4 findings 7/7 PMIDs verified) + 5/6 partial (raws on disk)
- Codex bracket: 3/3, 0% fab, ~262s avg — strongest perna empírica
- Initial hypothesis: "agent chattiness root cause" (DOWNGRADED em §S264.c per Codex F3)

---

## §S264.c — Codex peer-review integration

### Findings materiais (Codex CLI peer-review, Lucas paste em outra janela)

**F1 (P1) — count error:** Path A "14 outputs" claim error. Real = **13** (gemini ×3 + perplexity ×3 + nlm ×3 + codex ×3 + evidence ×1). Confiança 0.98. Fixed em `comparison.tsv` + `decision.md`.

**F2 (P1) — orchestration confound:** Gemini Q2 HTTP 429 = MEU dispatch error (3 simultaneous gemini-deep contra plan §170 que mandava sequencial). NÃO falha arquitetural agent. Confiança 0.9. Reframe em comparison.tsv `error_path_quality` notes.

**F3 (P2) — chattiness formulation strength:** "agent chattiness root cause" formulado forte demais. maxTurns docs Anthropic Agent SDK = limita "turns agentic/tool-use". Stop natural pode ser `end_turn`, budget self-regulation, OR chattiness. Precisa transcript + ResultMessage.subtype + stop_reason pra virar KBP. Atual = "principal hipótese suportada por transcript". Confiança 0.75. KBP-Candidate-D NOT formalized esta sessão (defer S265 post-evidence).

### Strongest counter-argument (Codex, conceded)

Bench não comparou ".mjs vs agents" — comparou ".mjs determinístico" contra "agents chatty 6-phase com parse/validate/spot-check/emit conversacional". Isso enviesou contra Path B.

Codex auto-prova: agent CAN be robust quando design = thin wrapper + deterministic runner (`codex-xhigh-researcher` body 1-phase, `codex exec --output-schema` enforces JSON nativo). Conclusão correta:

> *"Scripts vencem ESTES wrappers chatty (gemini-deep, perplexity-sonar). Thin-agent + deterministic runner é o melhor padrão (codex-xhigh-researcher prova)."* — NÃO "scripts vencem agents geral".

### Blind spots críticos (Codex)

1. **maxTurns ≠ "mensagens totais"** — Anthropic Agent SDK doc: maxTurns limita TURNS AGENTIC/TOOL-USE. Loop termina quando Claude produz resposta sem tool calls. "15 turns natural stop" precisa transcript + stop_reason proof.
2. **SubagentStop hooks (Claude Code) = alternativa arquitetural** — em vez de bump maxTurns, hook quality "output JSON exists+validates" pode prevent stop pre-emit. NÃO explorado §S264.b.
3. **KBP-48 forte demais** — "wrap = sempre agente" não é o que dados favorecem. Reformulação suportada: *"APIs externas: contrato determinístico/auditável; if wrapped por agent, agent precisa ser thin + verifiable"*.
4. **Perplexity ignora system_prompt afeta `.mjs` E agent** (mesmo modelo/API). NÃO evidence limpa contra scripts — bug API contract Perplexity, ortogonal.

### Recommendation recalibrada

**Option C provisional + KEEP-SEPARATE provisional + D-lite track S265+**

3-layer decision (vide `decision.md` for full text):
- **Layer 1 — Bench close:** Option C provisional, comparison.tsv com framing corrigido
- **Layer 2 — Outcome:** KEEP-SEPARATE provisional per-perna verdict (`.mjs` canonical Gemini/Perplexity hot path; codex-xhigh canonical agent; gemini-deep + perplexity-sonar experimental até D-lite)
- **Layer 3 — D-lite track S265+:** refactor gemini-deep + perplexity-sonar bodies para single-Bash deterministic (mirror codex-xhigh pattern); smoke + re-bench; lock MERGE ou MERGE-BACK pos-evidence

### KBP-Candidate revision (S264.c)

KBP-Candidate-D ("agent chattiness") **NOT formalized esta sessão**. Awaiting evidence: ResultMessage.subtype + stop_reason transcript capture, OR D-lite re-bench results (S265+). Per Codex blind spot 1.

KBP-Candidate-E (NEW): SubagentStop hooks como alternative architectural lever vs maxTurns. Defer S265+ exploration.

### Cross-window guard atualizado

Outro agente commitou `ac65ba6` mid-session (Phase 1 dead-code cleanup s-absoluto + KBP-44). Files M outro agente atual (NÃO TOCAR):
- `GEMINI.md`, `.claude/plans/curious-enchanting-tarjan.md` (their plan WIP)

Files M meus S264.a + S264.c (safe edits):
- `.claude/agents/{perplexity-sonar-research,evidence-researcher}.md`
- `.claude/.parallel-runs/2026-04-27-ma-types/**` (path-b/, smoke/, bench-log.md, agent-adjustments.md, codex-peer-review.md, comparison.tsv, decision.md)
- `.claude/plans/sleepy-wandering-firefly.md`
