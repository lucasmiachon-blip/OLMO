# Diagnóstico: Gemini QA a ~30% do Potencial — S199

> Diagnóstico completo do sistema Gemini QA (gemini-qa3.mjs, 1634 linhas).
> Baseado em leitura de: script completo, 4 prompts Gate 4, prompt Gate 0, outputs reais R11-R15 de s-rob2.
> Este arquivo preserva os achados detalhados que informam o plano `mutable-mapping-seal.md`.

## Arquitetura Atual do Gemini QA

```
Gate -1 (Preflight, $0, local)
  → lint, screenshots exist, word count, font-size check

Gate 0 (Inspect, Gemini Flash)
  → binary defect check (overlap, clipping, contrast)

Gate 4 (Editorial, Gemini Pro) — 3+1 calls paralelos:
  Call A (visual):  5 dims — distribuicao, proporcao, cor, tipografia, composicao
  Call B (ux+code): 5 dims — gestalt, carga_cognitiva, information_design, css_cascade, failsafes
  Call C (motion):  5 dims — timing, easing, narrativa_motion, crossfade, proposito
  Call D (validate): ceiling violations + priority_actions + false_positives

Total: 15 dimensões, scoring 0-10, MUST_FIX < 7
Modelos: Flash para Gate 0, Pro para Gate 4
Temperatura: 1.0 (Gemini 3 default, S198)
```

## 5 Causas-Raiz

### CR-1: Call A não vê código — chuta seletores CSS

- **Evidência:** Prompt `gate4-call-a-visual.md` linha 6: "REGRA ABSOLUTA: Avalie SOMENTE o design visual. ZERO código, CSS, JavaScript, HTML"
- **Consequência:** Quando propõe fixes, inventa seletores. R15 s-rob2: propôs `.bar-chart-value`, `.bar-chart-bar` — seletores INEXISTENTES. Reais: `.rob2-bar-val`, `.rob2-bar`
- **Impacto:** Fixes de Call A são inaplicáveis sem tradução manual
- **Fix proposto:** Injetar computed CSS data (via Playwright measureElements) como dados estruturados no prompt. Call A continua avaliando visual, mas com medidas REAIS, não chutadas

### CR-2: Call B falha ~30-40% das vezes (parse failure)

- **Evidência:** R15 s-rob2: `media_uxcode: null`, `dims_invalid: 5`, `dims_parsed: 10/15` (completeness 67%)
- **Causa:** Schema mais complexo (5 dims + proposals array + dead_css + specificity_conflicts) + payload mais pesado (HTML+CSS+JS completo) + maxOutputTokens: 16384 + thinkingBudget: 2048
- **Impacto:** Call B é o ÚNICO call que recebe código — quando falha, as 5 dimensões mais acionáveis se perdem. O scorecard fica com 10/15 dims (visual + motion OK, ux+code = null)
- **Fix proposto:** (1) maxOutputTokens → 24576, (2) retry-once on parse failure, (3) se persistir: split proposals em call separado

### CR-3: Zero few-shot / golden baselines

- **Evidência:** Call A prompt: 0 few-shot examples. Call C prompt: 0 few-shot. Call B: 2 exemplos triviais (pass/fail de css_cascade apenas)
- **Contexto:** Prompts dizem "nível Apple Keynote, TED, NEJM Grand Rounds" mas nunca mostram UM exemplo concreto de avaliação BEM FEITA neste design system
- **Impacto:** Gemini não sabe o que "bom" parece no OLMO. Avaliações ficam genéricas
- **Fix proposto:** Gerar golden evaluations rodando QA nos slides benchmark (s-etd, s-quality, s-title), curar output ideal, usar como few-shot
- **Evidência externa:** arXiv:2506.13639 — reference answers = ~15% impacto na qualidade de avaliação

### CR-4: Zero delta tracking entre rounds

- **Evidência:** `readRoundContext()` em gemini-qa3.mjs deliberadamente apaga scores anteriores ("fresh eyes") e só injeta Known False Positives
- **Consequência:** R11 s-rob2: `composicao: 3`. R15: `composicao: 5`. Ninguém sabe se melhorou de verdade ou é ruído estatístico do sampling
- **Gaps:** Sem diff entre rounds. Sem tracking de "fix implementado?". Sem métrica de melhora. Sem convergence detection
- **Fix proposto:** Quando round > 1, injetar scorecard anterior + status de fixes propostos. Adicionar campo `delta` no schema

### CR-5: Call D faz dois jobs incompatíveis

- **Evidência:** R15 s-rob2: Call D ajustou TODAS as motion dims de 8.2 para 7 uniformemente — "subtraia 1 de tudo" em vez de ajuste calibrado por dimensão
- **Causa:** Call D é simultaneamente (a) anti-sycophancy auditor (deflacionar scores) e (b) gerador de ações prioritárias. Conflito cognitivo: gastar tokens em ceiling violations E sintetizar action plan
- **Fix proposto:** Call D = SOMENTE ceiling violations + FP detection. Priority actions = gerado pelo SCRIPT deterministicamente (dims < 7, sorted by score ASC)

## Gaps Estruturais Adicionais

| Gap | Detalhes | Impacto |
|---|---|---|
| Sem computed CSS para Call A | measureElements() em qa-capture.mjs já extrai bounding boxes mas NÃO computed styles (font-size, gap, color) | Call A chuta medidas do PNG |
| Sem before/after entre rounds | appendRoundSummary() appends mas nunca lê previous para comparação | Loop sem feedback |
| Sem verificação de fix implementado | proposals acumulam em editorial-suggestions.md mas ninguém verifica se foram aplicados | Accountability zero |
| Sem calibração per-slide type | Forest plot e title usam idênticos 15 dims | Avaliação inadequada para tipos diferentes |
| Sem validação de seletores propostos | Call A propõe `.bar-chart-value`, CSS real tem `.rob2-bar-val` | Fixes inaplicáveis |
| ROI baixo | R15: $0.09 para ~1 insight genuinamente acionável | Custo/valor subótimo |

## Dados Reais de Output (s-rob2, R15)

```
dims_parsed: 10/15 (Call B failed)
dims_expected: 15
dims_invalid: 5
completeness: 0.67 (< 0.80 threshold)

Call A (visual): OK — 5 dims parsed
  composicao: 5, distribuicao: 4, proporcao: 5, cor: 7, tipografia: 6

Call B (ux+code): FAILED — {}
  media_uxcode: null, all 5 dims: null

Call C (motion): OK — 5 dims parsed
  timing: 8, easing: 8, narrativa_motion: 8, crossfade: 8, proposito: 9

Call D (validate): adjusted ALL motion dims uniformly to 7
  timing: 8→7, easing: 8→7, narrativa: 8→7, crossfade: 8→7, proposito: 9→7
```

## Métricas de Sucesso (Fase 1)

1. Call B parse success rate ≥ 90% (10 runs consecutivos)
2. Call A selector validity ≥ 80% (match contra CSS real)
3. Few-shot impact: score delta mensurável (before/after para mesmo slide)
4. Delta tracking: report R(N) mostra diff vs R(N-1) em todas dims
5. Priority actions: geradas por script, não por Call D LLM

## Evidência Externa

| Claim | Fonte | Finding |
|---|---|---|
| Prompt design > model choice | arXiv:2506.13639 | ~27% vs ~4% impacto na qualidade |
| Reference answers importam | arXiv:2506.13639 | ~15% impacto |
| Ensemble after rubric | arXiv:2505.20854 (SE-Jury) | Ensemble de baratos > single caro, MAS rubric é pré-requisito |
| Models fail at design compliance | DesignQA MIT (decode.mit.edu) | Todos frontier models "struggle" sem rubric específico |
| Prompt instability > model diversity | arXiv:2402.07927 | Minor prompt changes = 15-30% performance swings |
| Anti-sycophancy works with ceiling | arXiv:2306.05685 (Zheng) | GPT-4 judge >80% agreement with humans when calibrated |

---

Coautoria: Lucas + Opus 4.6 | S199 2026-04-15
