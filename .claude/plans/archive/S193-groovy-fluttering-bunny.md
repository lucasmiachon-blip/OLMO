# Plan S193: Insights + Rules Quebradas

## Context

**O que motivou:** /insights rodou pela primeira vez desde S154 (39 sessoes de gap). Identificou 3 propostas (P001-P003). Em paralelo, Lucas questionou a temperatura do Gemini QA (0.2) — "ficou muito menos criativo". Pesquisa com fontes oficiais Google confirma: Gemini 3.x é otimizado para temp=1.0 e Google AVISA contra baixar.

**Problema real:** S178 hardening baixou temp para 0.2 quando os modelos eram Gemini 2.x. Quando migramos para Gemini 3.x, a temperatura não foi ajustada. O resultado: degradação da qualidade editorial que Lucas observou.

## Parte A: Fix Gemini Parameters (research-backed)

### Evidencia (5 fontes oficiais)

1. [Gemini 3 Developer Guide](https://ai.google.dev/gemini-api/docs/gemini-3): "For all Gemini 3 models, we strongly recommend keeping the temperature parameter at its default value of `1.0`."
2. [Gemini 3 Prompting Guide](https://docs.cloud.google.com/vertex-ai/generative-ai/docs/start/gemini-3-prompting-guide): "Changing the temperature (setting it to less than `1.0`) may lead to unexpected behavior, looping, or degraded performance"
3. [Experiment with parameters](https://docs.cloud.google.com/vertex-ai/generative-ai/docs/learn/prompts/adjust-parameter-values): Default 1.0, range 0.0-2.0
4. [AI Studio tooltip](https://discuss.ai.google.dev/t/gemini-3-1-pro-preview-temperature-setting-tooltip/139198): "For Gemini 3, best results at default 1.0. Lower values may impact reasoning"
5. [Content generation parameters](https://docs.cloud.google.com/vertex-ai/generative-ai/docs/multimodal/content-generation-parameters): topP, frequency_penalty, presence_penalty, seed

### Mudanças propostas em `content/aulas/scripts/gemini-qa3.mjs`

| Local | Atual (S178) | Proposto | Razão |
|-------|-------------|----------|-------|
| L106 TEMP_DEFAULTS | inspect:0.1, visual:0.2, uxcode:0.2, motion:0.2, validate:0.1 | **inspect:1.0, visual:1.0, uxcode:1.0, motion:1.0, validate:1.0** | Google: Gemini 3 otimizado para 1.0 |
| L840-841 Gate 0 hardcoded | temperature: 0.1, topP: 0.9 | **temperature: 1.0, topP: 0.95** | Alinhar com default Gemini 3 |
| L52 --help text | "Gate 4 default: 1.0" | "default: 1.0 (Gemini 3 recommended)" | Alinhar doc com realidade |
| L102-105 comments | "S178 hardening — lower temp = less hallucination" | "S193 — restore Gemini 3 defaults (Google recommends 1.0; see Gemini 3 Developer Guide)" | Historicar a mudança |

### Parametros adicionais a considerar (NÃO mudar sem evidencia)

- `thinkingConfig`: JÁ implementado (L1082, L1177) — thinkingBudget: 2048. OK.
- `thinking_level`: Nova param Gemini 3 (high/low/minimal). Script usa `thinkingBudget` numérico que é o equivalente. NÃO mudar.
- `frequency_penalty` / `presence_penalty`: Poderiam ajudar editorial a evitar feedback repetitivo, mas sem evidência de problema atual. NÃO adicionar.
- `seed`: Poderia ajudar reproducibilidade em inspect, mas Google diz que temp=0 já é "mostly deterministic" — com temp=1.0 e reasoning, seed pode não ter efeito útil. NÃO adicionar.

### Arquivo
- `content/aulas/scripts/gemini-qa3.mjs` — ~5 edits pontuais

## Parte B: /insights Proposals (P001-P003)

### P001 — KBP-14 fortalecimento (pre-execution gate)

**Arquivo:** `.claude/rules/anti-drift.md` §Momentum brake
**Adicionar:**
```
- **Pre-execution reflection gate (KBP-14 enforcement):** Before launching ANY multi-step execution, state in 1 sentence: WHAT and WHY this approach. Cannot articulate in 1 sentence = haven't reflected enough.
```

### P002 — qa-pipeline.md §3 temperatura stale

**Arquivo:** `.claude/rules/qa-pipeline.md` §3
**Substituir** "Temperatura editorial: 1.0 (testado S71...)" por:
```
- **Temperatura QA:** 1.0 (default Gemini 3 — Google recomenda manter; S178 baixou para 0.2 em Gemini 2.x, revertido S193). Override per-call: `--temp <float>`.
```

### P003 — slide-patterns.md §5 conflito

**Arquivo:** `.claude/rules/slide-patterns.md` §5
**Substituir** o bloco HTML do Section Opener: remover `data-background-color` (morto em deck.js) + remover inline style (proibido por slide-rules.md §1). Usar `class="theme-dark"` + CSS externo.

## Parte C: Review de mudanças adversárias do Lucas

Quando Lucas indicar que terminou as mudanças na outra janela:
1. `git diff` para ver o que mudou
2. Avaliar cada mudança vs o report do /insights
3. Identificar o que do report já foi endereçado e o que ainda faz sentido

## Verificação

- [ ] `npm run build:metanalise` PASS após Parte A
- [ ] Rodar `node scripts/gemini-qa3.mjs --help` — confirmar que temp default aparece correto
- [ ] Ler `qa-pipeline.md` e `slide-patterns.md` após edits — confirmar sem conflitos com slide-rules.md
- [ ] /insights report salvo em `.claude/skills/insights/references/latest-report.md`
- [ ] failure-registry.json atualizado com entrada S193

## Ordem de execução

1. Parte B (rules fixes — documentação, sem risco)
2. Parte A (script change — testável com build)
3. Parte C (review adversarial — quando Lucas estiver pronto)
