---
description: "Regras de QA com LLM: attention, rubrica, anti-sycophancy. So carrega em contextos de aula/QA."
paths:
  - "content/aulas/**"
  - "content/aulas/**/qa*"
  - "content/aulas/**/gate*"
---

# QA Pipeline — Regras para Avaliação com LLM

> Fonte: Cirrose E053, E067, E068, E069

## 1. Execução

- "Rodar QA" = apresentar plano dos gates ANTES de executar. NUNCA atalhar pipeline (E053).
- NUNCA batch QA — 1 slide por ciclo completo (vale para Opus visual e Gemini script).
- Gates são sequenciais: BACKLOG → DRAFT → CONTENT → SYNCED → LINT-PASS → QA → DONE.

## 2. Separação de Atenção (E068)

NUNCA avaliar visual design e código na mesma chamada LLM. Atenção finita = misturar inputs = inflar notas.

| Call | Input | Foco | Sem |
|------|-------|------|-----|
| A (visual) | PNGs + vídeo | Distribuição, proporção, cor, tipografia | ZERO código |
| B (UX+code) | PNGs + HTML/CSS/JS | Gestalt, carga cognitiva, cascade, failsafes | SEM vídeo |
| C (motion) | PNGs + vídeo + JS | Timing, easing, narrativa, crossfade | SEM CSS puro |

## 3. Cor Semântica no QA (E067)

Prompt QA DEVE incluir critérios explícitos de avaliação de cor semântica:
- `--danger` = intervir agora (risco clínico real). NUNCA para limitação/flaw.
- `--warning` = investigar. NUNCA para resultado neutro.
- Progressão safe → warning → danger deve refletir gravidade clínica, não estética.
- Modelo sem critério = modelo cego a cor.

## 4. Anti-Sycophancy com Substância (E069)

"Seja duro" sem definir "bom" = notas arbitrárias. Prompt DEVE incluir:

- **Rubrica com ceiling:** Apresentação médica com GSAP = 6-8 se bem feita. 9 = excepcional com narrativa cinematográfica.
- **Exemplos de penalização:** Stagger uniforme = mecânico → max 7. CountUp sem pausa dramática → max 6.
- **Critérios profissionais** (motion): 12 princípios Disney (anticipation, follow-through, secondary action, staging focal).
- Inventário de timestamps prova que o modelo VIU, não que AVALIOU qualidade.

## 5. Checklists de Transição (por estado)

> Migrado de WT-OPERATING.md §3 (S69).

### BACKLOG → DRAFT
- [ ] Arquivo HTML criado em `slides/NN-slug.html`
- [ ] `<section id="s-{act}-{slug}">` com ID correto
- [ ] `<div class="slide-inner">` wrapper
- [ ] `<h2>` com asserção (mesmo que provisória)
- [ ] Entrada em `_manifest.js` na posição correta

### DRAFT → CONTENT
- [ ] h2 = asserção clínica verificável (não rótulo genérico)
- [ ] Zero `<ul>`/`<ol>` no corpo do slide
- [ ] Todos dados numéricos verificados (PMID ou [TBD])
- [ ] Corpo do slide <= 30 palavras

### CONTENT → SYNCED (9 superfícies)
- [ ] `_manifest.js` headline = `<h2>` do HTML
- [ ] `_manifest.js` clickReveals = número real de `[data-reveal]`
- [ ] `_manifest.js` customAnim = null ou ID correto
- [ ] `slide-registry.js` tem wiring se customAnim != null
- [ ] `{aula}.css` tem seletores `#slide-id` se necessário
- [ ] `narrative.md` tem linha para este slide
- [ ] `evidence-db.md` tem referências se slide tem dados
- [ ] HANDOFF registra estado SYNCED

### SYNCED → LINT-PASS
- [ ] `npm run build` PASS
- [ ] `npm run lint:slides` PASS

### QA → DONE
- [ ] Todos sub-stages QA PASS (ou max iterações + ressalva)
- [ ] HANDOFF.md estado = DONE
- [ ] CHANGELOG.md entry
- [ ] Commit: `fix({aula}): s-{id} QA pass — {resumo}`

## 6. Tabela de Propagação

> Migrado de WT-OPERATING.md §7 (S69).

| Mudei... | Atualizar também... |
|----------|---------------------|
| h2 no HTML | `_manifest.js` headline, `narrative.md` |
| `<section id>` | TODAS 9 superfícies (§5 CONTENT→SYNCED) |
| CSS do slide | Verificar se afeta score QA |
| Dados numéricos | `evidence-db.md`, notes `[DATA]` tag, evidence HTML |
| Posição no deck | `_manifest.js` ordem, `narrative.md` |
| Click-reveals | `_manifest.js` clickReveals, `slide-registry.js` |
| customAnim | `_manifest.js` customAnim, `slide-registry.js` |
| Qualquer coisa | HANDOFF.md estado do slide |

## 7. Scorecard 14-dim — Template

> Migrado de metanalise/NOTES.md (S69).

| Dim | Score | Nota |
|-----|-------|------|
| H (hierarquia) | ?/10 | |
| T (tipografia) | ?/10 | |
| E (layout fill) | ?/10 | |
| C (cor/contraste) | ?/10 | |
| V (visuais) | ?/10 | |
| K (consistência) | ?/10 | |
| S (sofisticação) | ?/10 | |
| M (comunicação) | ?/10 | |
| I (interações) | ?/10 | |
| D (dados) | ?/10 | |
| A (acessibilidade) | ?/10 | |
| L (carga cognitiva) | ?/10 | |
| P (andragogia) | ?/10 | |
| N (arco narrativo) | ?/10 | |
