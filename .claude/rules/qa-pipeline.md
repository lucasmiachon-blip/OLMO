---
description: "Regras de QA: estados, propagacao, cor semantica, anti-sycophancy. So carrega em contextos de aula/QA."
paths:
  - "content/aulas/**"
  - "content/aulas/**/qa*"
  - "content/aulas/**/gate*"
---

# QA Pipeline — Regras para Avaliacao com LLM

> Fonte: Cirrose E053, E067, E068, E069
> Implementacao tecnica (gates, dims, validation): `content/aulas/scripts/gemini-qa3.mjs`

## 0. Pre-Read Gate (OBRIGATORIO antes de qualquer avaliacao)

ANTES de avaliar qualquer slide, o agente DEVE:
1. Ler qa-pipeline.md Steps 3-5 (este arquivo)
2. Ler design-reference.md secoes 1-2 (cor semantica, tipografia)
3. Ler slide-rules.md secao 2 (checklist pre-edicao)
Se o agente nao leu estes 3 arquivos na sessao atual, PARAR e ler antes de avaliar.

> Fonte: /insights S108 P001. KBP-04 recorreu em S103 por skip desta leitura.

## 1. Path de execucao (linear, sem bifurcacao)

NUNCA batch QA — 1 slide por ciclo. NUNCA atalhar pipeline (E053).

```
STEP 1  npm run build:{aula}
   ↓
STEP 2  node scripts/qa-capture.mjs --aula {aula} --slide {id}
   ↓
STEP 3  Ler criterios: design-reference.md §1-§2, slide-rules.md
   ↓
STEP 4  Ler screenshot + codigo do slide
   ↓
STEP 5  Avaliar 4 dims (Cor, Tipografia, Hierarquia, Design) → tabela PASS/FAIL → STOP
   ↓
STEP 6  Lucas entra no loop: revisar → pedir mudancas → avaliar de novo
   ↓
STEP 7  Lucas diz "prossiga"
   ↓
STEP 8  node scripts/gemini-qa3.mjs --aula {aula} --slide {id} --inspect → report → STOP
   ↓
STEP 9  Lucas OK
   ↓
STEP 10 node scripts/gemini-qa3.mjs --aula {aula} --slide {id} --editorial → report → STOP
   ↓
STEP 11 Salvar sugestoes em qa-screenshots/{id}/editorial-suggestions.md
```

Criterios Preflight: `.claude/agents/qa-engineer.md` §Preflight (tabela 4 dims + fontes).
Prompts Gemini: `gemini-qa3.mjs` (unico script QA). Check nao listado = nao existe.
Layout e composicao: livre por slide. Sem archetypes como criterio — criacao tem mais arte.
Estados de slide: BACKLOG → DRAFT → CONTENT → SYNCED → LINT-PASS → QA → DONE.

## 2. Cor Semantica → design-reference.md §1

Regras de cor semantica no QA: ver `design-reference.md` §1 (Semantica de Cor). Canonico la, nao aqui.

## 3. Anti-Sycophancy com Substancia (E069)

- **Rubrica com ceiling:** Apresentacao medica com GSAP = 6-8 se bem feita. 9 = excepcional com narrativa cinematografica.
- **Penalizacao concreta:** Stagger uniforme = max 7. CountUp sem pausa = max 6.
- **Motion:** 12 principios Disney (anticipation, follow-through, secondary action, staging focal).
- Inventario de timestamps prova que modelo VIU, nao que AVALIOU qualidade.
- **Temperatura QA:** 1.0 (default Gemini 3 — Google recomenda manter; S178 baixou para 0.2 em Gemini 2.x, revertido S198). Override per-call: `--temp <float>`.

## 4. Checklists de Transicao

### BACKLOG → DRAFT
- [ ] Arquivo HTML criado em `slides/NN-slug.html`
- [ ] `<section id="s-{act}-{slug}">` com ID correto
- [ ] `<div class="slide-inner">` wrapper
- [ ] `<h2>` com assercao (mesmo que provisoria)
- [ ] Entrada em `_manifest.js` na posicao correta

### DRAFT → CONTENT
- [ ] h2 = assercao clinica verificavel (nao rotulo generico)
- [ ] Zero `<ul>`/`<ol>` no corpo do slide
- [ ] Todos dados numericos verificados (PMID ou [TBD])

### CONTENT → SYNCED (9 superficies)
- [ ] `_manifest.js` headline = `<h2>` do HTML
- [ ] `_manifest.js` clickReveals = numero real de `[data-reveal]`
- [ ] `_manifest.js` customAnim = null ou ID correto
- [ ] `slide-registry.js` tem wiring se customAnim != null
- [ ] `{aula}.css` tem seletores `#slide-id` se necessario
- [ ] Evidence HTML (`evidence/s-{id}.html`) tem referencias
- [ ] HANDOFF registra estado SYNCED

### SYNCED → LINT-PASS
- [ ] `npm run build` PASS
- [ ] `npm run lint:slides` PASS

### QA → DONE
- [ ] Todos sub-stages QA PASS (ou max iteracoes + ressalva)
- [ ] HANDOFF.md estado = DONE
- [ ] CHANGELOG.md entry

## 5. Tabela de Propagacao

| Mudei... | Atualizar tambem... |
|----------|---------------------|
| h2 no HTML | `_manifest.js` headline |
| `<section id>` | TODAS 8 superficies (§4 CONTENT→SYNCED) |
| CSS do slide | Verificar se afeta score QA |
| Dados numericos | evidence HTML, notes `[DATA]` tag |
| Posicao no deck | `_manifest.js` ordem |
| Click-reveals | `_manifest.js` clickReveals, `slide-registry.js` |
| customAnim | `_manifest.js` customAnim, `slide-registry.js` |
| Qualquer coisa | HANDOFF.md estado do slide |
