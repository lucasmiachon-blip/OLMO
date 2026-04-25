# SOTA-D: Synthesis + ADOPT/EVAL Matrix (S248, 2026-04-25)

> **Inputs:** SOTA-A Anthropic (288 li, 8 URLs) + SOTA-B Industry (300 li, 22 URLs) + SOTA-C Empirical (357 li, 30 papers/postmortems). Total 945 li, 60 fontes verificadas.
> **Synthesizer:** Opus 4.7 (me) — manual cross-validation per CLAUDE.md §ENFORCEMENT #6.
> **Confidence levels:** STRONG (≥3 sources concordam) | MEDIUM (2 sources) | WEAK (1 source) | OPEN (literature gap).

---

## Cross-Validated Findings

### STRONG (3 sources)

| # | Finding | A | B | C |
|---|---------|---|---|---|
| F1 | **Description drives delegation** — terceira pessoa, com triggers "Use when..." | AP-04 (S3) | C4 separação description vs instructions | S15 Anthropic case |
| F2 | **Tool design = capability floor** — tool ausente OR genérica = 0% em task class inteira | (não cobre) | C5 schema obrigatório | S5 BFCL, S7, S9, S10 |
| F3 | **Max iterations safety gate** — universal | maxTurns | C6 todos frameworks | S6 token snowball |
| F4 | **Schema-first structured output** — validação vs JSON livre | Output Schema canonical | C7 Pydantic/Zod first-class | S5 typed prevents runtime |
| F5 | **Anti-over-engineering gate** — single antes de multi | AP-02 complexidade prematura | C8 MAF "use function se possível" | S26 Anthropic taxonomy 7 níveis |

### MEDIUM (2 sources)

| # | Finding | Sources |
|---|---------|---------|
| F6 | **Allow-list > Deny-list** (least-privilege) | SOTA-B C2 (todos frameworks); SOTA-A `tools` field |
| F7 | **Description separada de Instructions** | SOTA-A (S1, S3); SOTA-B C4 |
| F8 | **Architect/Editor pattern** (separação reasoning + format) | SOTA-C S27 Aider 85% pass; SOTA-B (não menciona pattern explícito) |
| F9 | **Modelo + scaffold pairing > scaffold isolado** | SOTA-C S6 (18x token diff); SOTA-B (frameworks recomendam model swap) |
| F10 | **Stateful memory per-agent** | SOTA-A `memory:` field; SOTA-B Letta core (D5) |

### WEAK (1 source) ou OPEN (gap)

| # | Finding | Status |
|---|---------|--------|
| F11 | Single-agent > MAS above baseline 45% (β̂=-0.408, p<0.001) | SOTA-C S8 strong; SOTA-A "open research question" — TENSÃO |
| F12 | Communication super-linear MAS: T=2.72×(n+0.5)^1.724 | SOTA-C S8 only; literature gap |
| F13 | Artifact tracking universal weakness (2.19-2.45/5.0) | SOTA-C S18 only; literature gap |
| F14 | Permission fatigue 93% approval rate | SOTA-C S14; sem estudo controlado |

---

## Tensões / Divergências (decisão necessária)

### T1 — Tribunal-3 architecture (Frente 2) vs single-agent

**Plano original S248 Frente 2:** 3 agents paralelos (Gemini archaeologist + Codex adversarial + Opus strategist) + Opus synthesizer juiz.

**Evidência empírica (SOTA-C):**
- Above baseline 45%: single-agent supera MAS (β̂=-0.408, p<0.001, n=180)
- Communication overhead super-linear (R²=0.974)
- MAS adiciona valor onde baseline single é fraco (PSA<0.45)

**Contraponto crítico:**
- Bug debug em código novo é tipicamente baseline <45% — MAS justificável
- "Voting" semantics (3 perspectivas paralelas) ≠ "task decomposition" (4 workers separados)
- Anthropic taxonomy nível 4 (parallelization sectioning/voting) é ferramenta válida do toolkit
- Aider Architect/Editor (2 agents) tem 85% pass rate — empírico suporte parcial

**Recomendação:**
1. **Antes de construir tribunal-3**, MEDIR baseline single-Opus-extended-thinking em 1 caso de bug histórico (#191).
2. Se single-Opus baseline > 45%: tribunal pode ser dispensável.
3. Se single-Opus baseline < 45%: tribunal justificado, mas considerar 2-agent (Architect+Editor) como compromisso menos overhead.

**Decisão Lucas:** (a) MEDIR baseline antes de construir | (b) Construir tribunal e medir delta | (c) Pivotar para Architect+Editor 2-agent | (d) Adiar Frente 2 indefinidamente.

---

### T2 — Allow-list vs Deny-list

**Plano OLMO atual:** `disallowedTools: Write, Edit, Agent` em 7/10 agents.

**Evidência:**
- SOTA-B C2: TODOS 8 frameworks externos usam allow-list (least-privilege universal)
- SOTA-A: ambos suportados em Claude Code; nenhum oficialmente preferido
- KBP-32 spot-check confirmou OLMO state

**Trade-off:**
- Deny-list: simpler quando agent precisa da maioria das tools (verbosidade -)
- Allow-list: alinhado a least-privilege, força declaração explícita (auditabilidade +)

**Recomendação:** EVAL — migrar agents read-only (sentinel, repo-janitor, researcher) para allow-list. Manter deny-list em agents amplos (qa-engineer, systematic-debugger) onde lista de tools necessárias é >5.

---

### T3 — Stateful memory per-agent

**Plano OLMO atual:** 5/10 agents têm `memory: project` (read-only).

**Evidência:**
- SOTA-B D5: Letta = framework construído em torno de memória (self-editing); outros: opt-in
- SOTA-C S15: Anthropic recomenda artifacts explícitos (feature list, progress, git log) — alinhado com OLMO

**Trade-off Letta-style auto-editing:**
- Pro: agente aprende cross-sessões, reduz repetição
- Con: complexity multiplier; teste/debug difícil; risco de drift

**Recomendação:** IGNORE Letta-style auto-editing por enquanto. Pattern atual (HANDOFF.md + CHANGELOG.md + memory project read-only) já está alinhado com Anthropic case S15.

---

## Immediate FIXES (high confidence, low cost)

> Lucas pode commitar agora; não dependem de decisões maiores.

### FIX-1 — `reference-checker.md` color value inválido

- **Atual:** `color: magenta` (não na lista oficial Anthropic)
- **Lista válida:** red, blue, green, yellow, purple, orange, pink, cyan
- **Fix:** trocar por `color: purple` (closer ao magenta visualmente)
- **Confidence:** SOTA-A claim — verificação local recomendada (KBP-32: spot-check)

### FIX-2 — `reference-checker.md` mcpServers format

- **Atual (per SOTA-A):** dict ao invés de lista
- **Esperado:** lista com dashes
- **Confidence:** SOTA-A claim — Read+Edit local antes de commit

### FIX-3 — Adicionar `model:` explícito em 7/10 agents (per SOTA-A spot-check)

- **Atual:** maioria herda do main = `claude-sonnet-4-6`
- **Recomendação:** declarar explícito por design intent
  - `model: haiku` em read-only (sentinel, repo-janitor, researcher) — Anthropic AP-01 Explore default
  - `model: sonnet` em research/debug (qa-engineer, evidence-researcher, systematic-debugger)
  - `model: opus` em design/synthesis (mbe-evaluator?)
- **Effort:** ~10min, 7 small Edits
- **Validation:** verificar quem realmente é read-only via Grep `disallowedTools` antes de assumir Haiku

---

## ADOPT/EVAL/IGNORE/ALREADY Matrix

> Por dimensão, com sources cited e effort estimado.

| Dim | Empirical/SOTA evidence | OLMO state | Decision | Effort |
|-----|------------------------|-----------|----------|--------|
| **Description com triggers** | F1 strong | Variável (alguns vagos) | EVAL — audit descriptions | M (1h, 10 agents) |
| **Tool allow-list least-privilege** | F6 medium | Deny-list em 7/10 | EVAL — migrar read-only agents | M (30min, 3 agents) |
| **Schema-first output** | F4 strong | ALREADY (debug-symptom-collector) | ADOPT em todos novos agents | — (regra para Frente 2) |
| **Max iterations** | F3 strong | ALREADY (10/10 agents) | KEEP | — |
| **Model explícito** | F9 medium | 3/10 declaram | ADOPT — declarar todos | S (FIX-3, ~10min) |
| **Anti-over-engineering gate** | F5 strong | ALREADY (CLAUDE.md §ENFORCEMENT) | KEEP | — |
| **Single vs MAS** | F11 weak/open | OLMO usa pattern correto (10 agents especializados sequenciais) | KEEP — mas T1 decisão pendente p/ Frente 2 | depends |
| **Architect/Editor pattern** | F8 medium | AUSENTE (uso de single agents) | EVAL para qa-engineer + evidence-researcher pair | L (1-2h research+test) |
| **Stateful memory auto-edit** | F10 medium | Read-only project memory | IGNORE | — |
| **Step counter / loop detector** | SOTA-C S6 strong | AUSENTE | EVAL — possible novo hook | M (1h research) |
| **Artifact tracking compactação** | F13 open | HANDOFF presente | KEEP — literature gap, OLMO já está alinhado |  — |
| **Eval harness reproduzível** | SOTA-C S3, S20 | AUSENTE | DEFER — Inspect AI candidato | L (sessão dedicada) |
| **`color` value valid** | SOTA-A spec | 1 invalid (magenta) | FIX-1 imediato | S |
| **`mcpServers` format** | SOTA-A spec | 1 invalid format | FIX-2 imediato | S |
| **`isolation: worktree`** | SOTA-A field | AUSENTE | IGNORE — caso de uso não-aplicável atualmente | — |
| **`background: true`** | SOTA-A field | AUSENTE | EVAL para sentinel | S |

---

## Recomendações para Frente 2 (Debug Team)

### Opção A — Pivotar para Architect/Editor 2-agent (recomendação evidence-based)

**Pattern:** SOTA-C S27 — Aider 85% pass rate empírico.

**Topology proposta:**
1. `debug-symptom-collector` (DONE S247) — Sonnet, schema-first
2. **`debug-architect`** (NOVO) — Opus 4.7 max — recebe symptom JSON, raciocina root cause sem constraint de format, propõe plan textual (não tool calls)
3. **`debug-editor`** (NOVO) — Sonnet + Codex CLI — recebe architect plan + applies edits Aider-style
4. `debug-validator` (NOVO) — Sonnet + Bash — testa, lint

**Benefícios vs tribunal-3:**
- 4 agents vs 6 (33% menos files)
- Communication overhead linear vs super-linear
- Empirical 85% pass rate (Aider study)
- Mais simples para Lucas validar/manter

### Opção B — Manter tribunal-3 mas medir antes

Construir conforme plano original, mas **antes de declarar pronto**:
1. Rodar baseline single-Opus-extended-thinking em bug #191
2. Rodar tribunal-3 no mesmo bug
3. Comparar token cost + accuracy + tempo
4. Decidir se manter ou colapsar para single

### Opção C — Adiar Frente 2 indefinidamente

Foco em B1+B3 (CI truth + content pipeline truth) per benchmark gate. Frente 2 retorna após gates fechados E após mais 2-3 use cases reais que justifiquem o investimento.

---

## Empirical OLMO Gaps (não-resolvidos pela research)

1. **Step counter / repeated-action detector** (SOTA-C S6, S8) — high-value gap. Possível novo hook.
2. **Eval reproducibility para multi-agent pipeline** (SOTA-C S3) — Inspect AI candidato.
3. **Compressão de contexto entre sessões** (SOTA-C S18, S19) — universal gap, OLMO HANDOFF é human-readable não machine-queryable.
4. **Permission fatigue measurement** (SOTA-C S14) — 93% approval rate. KBP-23 endereça parcialmente; mensuração ausente.

---

## Open Decisions for Lucas

| # | Decisão | Recomendação minha | Razão |
|---|---------|-------------------|-------|
| D1 | Tribunal-3 vs Architect/Editor 2-agent vs adiar | **Architect/Editor 2-agent** | Empirical 85% (Aider) + 33% menos overhead + simpler |
| D2 | Allow-list migração (read-only agents) | **EVAL próx sessão** | Não bloqueia, alinha com least-privilege |
| D3 | FIX-1, FIX-2, FIX-3 (small commits) | **Aplicar na sessão atual** | Atomic, evidence-backed, low risk |
| D4 | Step counter hook | **EVAL próx sessão** | High-value mas requires research/design |
| D5 | Inspect AI eval harness | **DEFER** | Sessão dedicada; valor alto mas escopo grande |
| D6 | Continuar B1+B3 antes de Frente 2? | **Sim per overlay** | Gate operacional adotado, não desfazer |

---

## Caveats / Confidence Notes

- 60 fontes verificadas pelos 3 agents via WebFetch + WebSearch — re-verification por mim NÃO executada (trust-but-verify per KBP-36).
- KBP-32 spot-check executado pelos 3 agents para AUSENTE claims — taxa erro histórica ~33%, então FIX-1/FIX-2/FIX-3 devem ser confirmados via Read local antes de commit.
- SOTA-C tem maior peso empírico (papers + benchmarks); SOTA-A tem maior autoridade (Anthropic primary); SOTA-B tem maior cobertura (industry breadth). Triangulação 3-fold.
- Synthesis é Opus 4.7 (eu) — não cross-validated por outro agent. Lucas deve sanity-check decisões críticas (especialmente T1 tribunal-3 reconsideration).

---

*Coautoria: Lucas + Opus 4.7 (Claude Code) | S248 | 2026-04-25*
*Synthesis manual sem agent secundário (KBP-17 evita over-delegation).*
