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

## 1. Execucao

- "Rodar QA" = apresentar plano dos gates ANTES de executar. NUNCA atalhar pipeline (E053).
- NUNCA batch QA — 1 slide por ciclo completo (vale para Opus visual e Gemini script).
- Gates sequenciais: -1 (preflight $0) → 0 (Flash inspect) → [checkpoint Lucas] → 4 (Pro editorial 3 calls).
- Estados de slide: BACKLOG → DRAFT → CONTENT → SYNCED → LINT-PASS → QA → DONE.

## 2. Cor Semantica no QA (E067)

Prompt QA DEVE incluir criterios explicitos:
- `--danger` = intervir agora (risco clinico real). NUNCA para limitacao/flaw.
- `--warning` = investigar. NUNCA para resultado neutro.
- Progressao safe → warning → danger = gravidade clinica, nao estetica.

## 3. Anti-Sycophancy com Substancia (E069)

- **Rubrica com ceiling:** Apresentacao medica com GSAP = 6-8 se bem feita. 9 = excepcional com narrativa cinematografica.
- **Penalizacao concreta:** Stagger uniforme = max 7. CountUp sem pausa = max 6.
- **Motion:** 12 principios Disney (anticipation, follow-through, secondary action, staging focal).
- Inventario de timestamps prova que modelo VIU, nao que AVALIOU qualidade.
- Temperatura editorial: 1.0 (testado S71 — baixar torna critica generica).

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
- [ ] Corpo do slide <= 30 palavras

### CONTENT → SYNCED (9 superficies)
- [ ] `_manifest.js` headline = `<h2>` do HTML
- [ ] `_manifest.js` clickReveals = numero real de `[data-reveal]`
- [ ] `_manifest.js` customAnim = null ou ID correto
- [ ] `slide-registry.js` tem wiring se customAnim != null
- [ ] `{aula}.css` tem seletores `#slide-id` se necessario
- [ ] `references/narrative.md` tem linha para este slide
- [ ] Evidence HTML (`evidence/s-{id}.html`) ou `references/evidence-db.md` tem referencias
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
| h2 no HTML | `_manifest.js` headline, `references/narrative.md` |
| `<section id>` | TODAS 9 superficies (§4 CONTENT→SYNCED) |
| CSS do slide | Verificar se afeta score QA |
| Dados numericos | evidence HTML, `references/evidence-db.md`, notes `[DATA]` tag |
| Posicao no deck | `_manifest.js` ordem, `references/narrative.md` |
| Click-reveals | `_manifest.js` clickReveals, `slide-registry.js` |
| customAnim | `_manifest.js` customAnim, `slide-registry.js` |
| Qualquer coisa | HANDOFF.md estado do slide |
