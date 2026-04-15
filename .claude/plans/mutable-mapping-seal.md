# Plan: Design Excellence Loop — S199

## Context

O OLMO tem um QA pipeline (Gemini 3 Flash/Pro, 15 dimensões, 3+1 calls) que funciona a ~30% do potencial. Causas-raiz diagnosticadas: prompts sem few-shot, Call B falha 30-40%, zero delta tracking, Call A chuta seletores CSS, Call D mistura dois jobs. Construir um loop iterativo sobre essa base = iterar sobre avaliação ruim.

**Problema real:** Não é falta de loop — é que o evaluator não produz feedback acionável.

**Solução em 3 fases:**
1. Consertar o evaluator (Gemini QA prompts + infra de medição)
2. Construir o loop de excelência sobre a base consertada
3. Multi-model downstream (Codex fixer, GPT tiebreaker) — futuro, quando fases 1-2 estiverem Proven

**Evidência que suporta esta sequência:**
- arXiv:2506.13639: prompt design = ~27% da qualidade vs model choice = ~4%
- arXiv:2505.20854 (SE-Jury): ensemble só supera single DEPOIS de rubric calibrado
- DesignQA (MIT): todos os frontier models falham em design compliance sem rubric específico
- Diagnóstico interno: Call B parse failure 30-40%, Call A inventa seletores, zero few-shot

---

## Fase 1: Consertar o Evaluator (Gemini QA)

### 1.1 Injetar dados computados no Call A

**Problema:** Call A (visual) recebe SOMENTE screenshots. Chuta medidas do PNG. Propõe seletores que não existem (`.bar-chart-value` quando o real é `.rob2-bar-val`).

**Fix:** Antes de chamar Gemini, usar Playwright para extrair computed CSS dos elementos-chave e injetar como dados estruturados no prompt.

```
ANTES: Call A recebe [PNG S0] + [PNG S2] + [prompt]
DEPOIS: Call A recebe [PNG S0] + [PNG S2] + [computed_data.json] + [prompt]

computed_data.json:
{
  "h2": { "font-size": "42px", "line-height": "1.1", "color": "oklch(25% 0 0)" },
  "cards": { "gap": "10px", "grid-template": "1fr 1fr", "count": 3 },
  "source-tag": { "font-size": "14px", "bottom": "8px" },
  "hero-number": { "font-size": "72px", "font-variant-numeric": "tabular-nums" },
  "viewport-usage": { "content-width": "1180px", "content-height": "640px", "whitespace": "22%" }
}
```

**Fonte:** DesignQA (MIT) — modelos precisam de dados estruturados para compliance checking.
**Script a modificar:** `qa-capture.mjs` — adicionar extração de computed styles no `measureElements()` (já existe bounding box, falta computed CSS).
**Prompt a modificar:** `gate4-call-a-visual.md` — adicionar seção `## DADOS COMPUTADOS` com instrução para usar esses valores, não chutar.

### 1.2 Corrigir Call B reliability

**Problema:** Call B (ux+code) falha ~30-40% das vezes. `maxOutputTokens: 16384` + schema complexo (5 dims + proposals array + dead_css + specificity_conflicts) = output truncado ou parse failure. Quando falha, 5 dimensões mais acionáveis se perdem.

**Fix (3 opções, testar em ordem):**
1. **Aumentar maxOutputTokens para 24576** — mais headroom para o schema complexo
2. **Retry-once on parse failure** — se `{}`, tentar novamente com prompt simplificado
3. **Split proposals em call separado** — reduzir complexidade do schema de Call B

**Script a modificar:** `gemini-qa3.mjs` — lógica de retry + maxOutputTokens config.
**Métrica de sucesso:** Call B parse success rate ≥90% em 10 runs consecutivos.

### 1.3 Adicionar few-shot golden evaluations

**Problema:** Prompts dizem "nível Apple Keynote" mas nunca mostram um exemplo concreto de avaliação BEM FEITA neste design system. Zero few-shot em Call A e Call C. Call B tem 2 exemplos triviais.

**Fix:** Criar 1-2 golden evaluations usando slides benchmark (`s-etd`, `s-quality`). Formato: screenshot → avaliação completa com scores + evidência + fixes. Injetar nos prompts como `## EXEMPLO DE AVALIACAO EXCELENTE`.

**Evidência:** arXiv:2506.13639 — reference answers = ~15% impacto na qualidade.
**Arquivos a modificar:**
- `gate4-call-a-visual.md` — 1 few-shot (s-quality: score alto com evidência concreta)
- `gate4-call-b-uxcode.md` — 1 few-shot (s-etd: CSS scoped tokens + OKLCH)
- `gate4-call-c-motion.md` — 1 few-shot (s-title: masking reveal timing)

**Como gerar:** Rodar QA nos slides benchmark, curar manualmente o output ideal, usar como golden. Lucas valida.

### 1.4 Implementar delta tracking entre rounds

**Problema:** O sistema apaga scores anteriores ("fresh eyes"). Sem diff = sem saber se melhorou.

**Fix:** Quando `round > 1`, ler scorecard do round anterior e injetar no prompt:

```
## ROUND ANTERIOR (R{N-1})
Scores: { composicao: 3, cor: 7, tipografia: 6, ... }
MUST fixes propostos: [
  { target: ".cards", change: "gap: 10px → 24px", status: "IMPLEMENTADO" },
  { target: "h2", change: "font-size: 28px → 36px", status: "PENDENTE" }
]
TAREFA: Avaliar com olhos frescos, MAS reportar delta (melhorou/piorou/estável) para cada dim.
```

**Script a modificar:** `gemini-qa3.mjs` — `readRoundContext()` deve ler scorecard anterior, não só KnownFPs.
**Schema a adicionar:** `delta: { dim: "improved"|"regressed"|"stable" }` em cada call.
**Métrica de sucesso:** Report de round N mostra deltas vs round N-1.

### 1.5 Separar Call D em dois jobs

**Problema:** Call D faz anti-sycophancy (deflacionar scores) E gera ações prioritárias. Em R15: ajustou todos motion dims uniformemente 8.2→7 = "subtraia 1 de tudo".

**Fix:** Call D = SOMENTE ceiling violations + FP detection. Priority actions = gerado pelo SCRIPT a partir de Call A+B+C validados (lógica determinística, não LLM).

```
ANTES: Call D (LLM) → ceiling_violations + priority_actions + final_verdict
DEPOIS: Call D (LLM) → ceiling_violations + false_positives
         Script (determinístico) → priority_actions (dims < 7, sorted by score ASC)
```

**Script a modificar:** `gemini-qa3.mjs` — refatorar `runSplitGate4()` para gerar priority_actions via código.
**Prompt a modificar:** `gate4-call-d-validate.md` — remover `priority_actions` do schema.

### 1.6 Validação de seletores CSS propostos (post-processing)

**Problema:** Call A propõe fixes com seletores que não existem no CSS.

**Fix:** Post-processing no script: quando Call A retorna um fix com `target: ".bar-chart-value"`, verificar se esse seletor existe no CSS da aula. Se não existe, flagear como `"selector_valid": false` e tentar match fuzzy contra seletores reais.

**Script a modificar:** `gemini-qa3.mjs` — adicionar `validateSelectors()` pós-Call A.
**Input:** CSS do slide (já disponível), lista de selectors propostos por Gemini.

---

## Fase 2: Design Excellence Loop

**Pré-requisito:** Fase 1 completa e testada (Call B ≥90% success, few-shot validados, delta tracking funcionando).

### 2.1 Rule — `.claude/rules/design-excellence.md`

Rubric de 8 dimensões macro que MAPEIA para as 15 dimensões Gemini:

| Dim Excellence | Dims Gemini que cobrem | Scoring |
|---|---|---|
| Assertion | (manual — h2 quality) | 1-3 |
| Data-Ink | distribuicao, proporcao | média Gemini/10 × 3 |
| Cognitive Load | gestalt, carga_cognitiva | média Gemini/10 × 3 |
| Color | cor | Gemini/10 × 3 |
| Typography | tipografia | Gemini/10 × 3 |
| Motion | timing, easing, narrativa_motion, crossfade, proposito | média Gemini/10 × 3 |
| Contrast | (computed — WCAG ratio via Playwright) | programático |
| CSS Architecture | css_cascade, failsafes | média Gemini/10 × 3 |

**Hard fails** e **benchmarks** como no plano anterior (s-etd, s-quality, s-title, s-hook).

**Threshold:** ≥20/24 = ELITE. ≥16/24 = PASS. <16 = FIX REQUIRED.

**Por que 8 dims macro e não 15 dims diretas?** As 15 dims Gemini são granulares demais para decisão humana. 8 dims = legível para Lucas. Mapping automático = sem perda de informação.

### 2.2 Skill — `/polish`

```
/polish {slide-id}           → single slide, loop interativo
/polish {slide-id} --quick   → 1 iteração, report only
```

**Fluxo por iteração:**

```
STEP 1: CAPTURE
  Bash: node scripts/qa-capture.mjs --aula {aula} --slide {id} --video
  → PNGs (S0, S2) + video (.webm) + computed_data.json (Fase 1.1)

STEP 2: EVALUATE (Gemini — evaluator separado)
  Bash: node scripts/gemini-qa3.mjs --aula {aula} --slide {id} --editorial
  → 15 dims scored + delta tracking + validated fixes

  Mapping automático: 15 dims Gemini → 8 dims Excellence
  Report para Lucas: tabela 8 dims × 1-3 + MUST fixes

STEP 3: DECIDE (Lucas)
  PASS (≥16): → STEP 5
  ELITE (≥20): → STEP 5 (com reconhecimento)
  FIX REQUIRED (<16 ou algum dim =1): → STEP 4

STEP 4: FIX (Claude — fixer)
  Ler fixes validados do Gemini (seletores verificados, Fase 1.6)
  Propor implementação → esperar OK do Lucas
  Aplicar via Edit (CSS/HTML)
  Chrome DevTools MCP: evaluate_script para verificar computed values
  → voltar a STEP 1 (max 5 iterações)

STEP 5: DONE
  Score final registrado
  Comparar com benchmarks
  STOP + report
```

**Por que Gemini avalia e Claude fixa?**
- Separação evaluator/fixer = code review ≠ code authorship (arXiv:2306.05685)
- Claude conhece o codebase (Edit, Read). Gemini não.
- Gemini tem anti-sycophancy calibrado nos prompts. Claude auto-avaliando-se = bias.

**Chrome DevTools MCP: role supplementar**
- Live computed style verification durante STEP 4 (post-fix)
- Quick screenshot pré-recaptura formal
- `evaluate_script()` para GSAP timeline state
- NÃO substitui Playwright para captura formal (viewport determinístico)

### 2.3 Ralph Loop — wrapper autônomo

```
/ralph-loop "/polish s-absoluto" --max-iterations 5 --completion-promise "ELITE"
```

Opcional. Para quando Lucas quer polishing autônomo. O loop do `/polish` já é auto-contido — Ralph apenas o repete entre sessões.

---

## Fase 3: Multi-Model Downstream (Futuro)

**Pré-requisito:** Fases 1-2 estabilizadas (Gemini QA ≥80% yield, loop testado em 5+ slides).

### 3.1 Codex como Code Fixer

Quando Gemini identifica problema CSS e Claude não sabe resolver:
```
Gemini: "gap entre cards = 10px, deveria ser 24px para legibilidade a 10m"
→ Codex CLI: --image screenshot.png "fix CSS gap in .cards to 24px, preserve grid layout"
→ Codex gera CSS fix
→ Claude valida e aplica
```

**Role: fixer especializado, não evaluator.**

### 3.2 GPT-5.4 como Tiebreaker

Quando Gemini e Claude discordam sobre se um fix é necessário:
```
Gemini diz: "composicao = 4, MUST fix"
Claude acha que está OK
→ GPT-5.4: avaliação independente com mesmo rubric
→ Consenso 2/3 decide
```

**Role: árbitro, não evaluator primário.** Padrão SE-Jury (arXiv:2505.20854): dynamic team selection > brute-force multi-model.

### 3.3 Gate: quando escalar para multi-model?

Não escalar preemptivamente. Trigger concreto:
- Gemini QA yield estável em ≥80% por 5+ sessões AND
- Alguma dimensão específica consistentemente subavaliada (evidência de 3+ rounds)
- Custo marginal justificado pelo ganho mensurável

---

## Implementação: Arquivos e Ordem

### Fase 1 (consertar evaluator)

| # | Arquivo | Ação | Tipo |
|---|---|---|---|
| 1.1a | `scripts/qa-capture.mjs` | Adicionar extração de computed CSS em `measureElements()` | EDITAR script |
| 1.1b | `metanalise/docs/prompts/gate4-call-a-visual.md` | Adicionar seção DADOS COMPUTADOS | EDITAR prompt |
| 1.2 | `scripts/gemini-qa3.mjs` | maxOutputTokens Call B + retry logic | EDITAR script |
| 1.3a | `metanalise/docs/prompts/gate4-call-a-visual.md` | Adicionar 1 few-shot golden | EDITAR prompt |
| 1.3b | `metanalise/docs/prompts/gate4-call-b-uxcode.md` | Adicionar 1 few-shot golden | EDITAR prompt |
| 1.3c | `metanalise/docs/prompts/gate4-call-c-motion.md` | Adicionar 1 few-shot golden | EDITAR prompt |
| 1.4 | `scripts/gemini-qa3.mjs` | Delta tracking em `readRoundContext()` | EDITAR script |
| 1.5a | `scripts/gemini-qa3.mjs` | Separar priority_actions de Call D | EDITAR script |
| 1.5b | `metanalise/docs/prompts/gate4-call-d-validate.md` | Remover priority_actions do schema | EDITAR prompt |
| 1.6 | `scripts/gemini-qa3.mjs` | `validateSelectors()` post-Call A | EDITAR script |

### Fase 2 (loop de excelência)

| # | Arquivo | Ação | Tipo |
|---|---|---|---|
| 2.1 | `.claude/rules/design-excellence.md` | Rubric 8 dims + mapping Gemini + benchmarks | CRIAR rule |
| 2.2 | `.claude/skills/polish/SKILL.md` | Protocolo do loop + Chrome DevTools | CRIAR skill |
| 2.3 | `.claude/settings.local.json` | Rule loading glob para content/aulas/** | EDITAR config |

### Fase 3 (multi-model — futuro)

Nenhum arquivo agora. Decidir quando Fase 2 estiver Proven.

---

## Verificação End-to-End

### Fase 1
1. Call B success rate: ≥90% em 10 runs (`grep -c "parse_failed" qa-screenshots/*/raw.txt`)
2. Call A propõe seletores válidos: ≥80% match contra CSS real
3. Few-shot impact: comparar scores R_antes vs R_depois para mesmo slide
4. Delta tracking: report de R(N) mostra diff vs R(N-1)
5. Priority actions: geradas por script, não por Call D

### Fase 2
1. `/polish s-absoluto` completa 1 iteração: capture → evaluate → score → report
2. Score mapping: 15 dims Gemini → 8 dims excellence → total /24
3. Fix loop: score melhora após fix (delta positivo)
4. Max iterations: loop para após 5 iterações
5. Chrome DevTools: computed values verificáveis pós-fix

### Teste final
`/polish s-absoluto` com Vite rodando → Gemini avalia (feedback acionável, seletores válidos) → Claude fixa → recaptura → Gemini re-avalia (delta positivo) → score ≥16 → PASS

---

## Fontes Consolidadas

| Decisão | Evidência | Tipo |
|---|---|---|
| Prompt > Model | arXiv:2506.13639 (~27% vs ~4%) | Paper empírico |
| Few-shot impact | arXiv:2506.13639 (reference answers ~15%) | Paper empírico |
| Ensemble pattern | arXiv:2505.20854 SE-Jury (ASE 2025) | Paper conferência |
| Anti-sycophancy | arXiv:2306.05685 Zheng (MT-Bench) | Paper fundacional |
| Design compliance | DesignQA MIT (decode.mit.edu) | Benchmark |
| Model soup anti-pattern | arXiv:2402.07927 (prompt swing 15-30%) | Survey |
| Consensus > adversarial | arXiv:2411.15594 (debate amplifica bias) | Survey |
| Codex = fixer not evaluator | OpenAI Codex CLI docs (image input, code output) | Documentação |
| GPT-5.4 marginal | BenchLM.ai (ScreenSpot +1.0, 2.4x custo) | Benchmark |
| Call B failure | Diagnóstico interno R15 s-rob2 (dims_parsed 10/15) | Empírico projeto |
| Computed CSS injection | DesignQA MIT (modelos precisam dados estruturados) | Benchmark |
| Separar evaluator/fixer | arXiv:2306.05685 (code review ≠ authorship) | Paper + eng. practice |
| Deterministic capture | Playwright vs CDT MCP (viewport, video) | Eng. practice |
