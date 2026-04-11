# Plan: Evidence HTML + Speaker Notes para s-contrato

## Context

s-contrato é o slide "3 perguntas que você faz a toda meta-análise" — um framework/contract slide de 45s que organiza a estrutura da aula. Está marcado DONE no HANDOFF, mas é anterior ao sistema de living HTML. Não tem evidence HTML.

O conteúdo de cada pergunta será aprofundado em slides dedicados (s-pico, s-forest-plot, s-benefit-harm, s-heterogeneity, etc.), então o evidence aqui é **enxuto**: rationale do framework + speaker notes + mapeamento para slides subsequentes.

## Steps

### Step 1: Criar `evidence/s-contrato.html`

Estrutura benchmark (mesmas sections do s-importancia/pre-reading-heterogeneidade, mas curtas):

1. **Header** — titulo, meta (slide, fase F2, timing 45s), objectives box (2-3 items)
2. **Conceitos-chave** — O "contrato didático" como advance organizer. 3 perguntas = 3 eixos de leitura crítica. Breve (1-2 parágrafos)
3. **Por que importa** — Rationale pedagógico: reduzir carga cognitiva, dar framework antes do conteúdo. Conexão com JAMA Users' Guides / Cochrane Handbook
4. **Mapeamento** — Tabela: Pergunta → Conceitos → Slides onde é coberta
5. **Glossário** — Mínimo (3-4 termos: PICO, forest plot, GRADE, NNT — breve, detalhes nos evidence dos slides próprios)
6. **Deep dive** — `<details>` com Speaker Notes completas (timestamps, falas, ênfases, transição)
7. **Footer** — Coautoria

**Fontes:** Framework baseado na estrutura de leitura crítica de MA:
- Guyatt et al. JAMA Users' Guides (referência canônica)
- Cochrane Handbook (Higgins & Thomas)
- Estrutura da aula (narrative.md)

Sem dados numéricos para verificar — slide é conceitual/pedagógico.

### Step 2: Atualizar `_manifest.js`

Adicionar `evidence: 's-contrato.html'` na entry do s-contrato (linha 24).

### Step 3: Atualizar `metanalise/HANDOFF.md`

- s-contrato: DONE → LINT-PASS (precisa passar por QA com o novo pipeline)
- Atualizar contagens (DONE 2, LINT-PASS 13)

### Step 4: Build + Lint

```
npm run build:metanalise
npm run lint:slides
```

### Step 5: QA Pipeline (standard)

1. Preflight (4 dims: cor, tipografia, hierarquia, design) — $0
2. [Lucas OK]
3. `node scripts/gemini-qa3.mjs --aula metanalise --slide s-contrato --inspect`
4. [Lucas OK]
5. `node scripts/gemini-qa3.mjs --aula metanalise --slide s-contrato --editorial`

## Files to modify

- **CREATE:** `content/aulas/metanalise/evidence/s-contrato.html`
- **EDIT:** `content/aulas/metanalise/slides/_manifest.js` (add evidence field)
- **EDIT:** `content/aulas/metanalise/HANDOFF.md` (status update)

## Verification

- `npm run build:metanalise` PASS
- `npm run lint:slides` PASS
- Evidence HTML abre no browser e segue benchmark visual
- Speaker notes cobrem 45s com timestamps
