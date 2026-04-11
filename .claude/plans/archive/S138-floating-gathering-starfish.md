# Plan: Melhorar s-importancia

## Context

Slide #02 (F1: Create Importance). Navy card left + 5 vantagens right.
S137 fez QA preflight (conteudo+CSS), S138 fez visual cleanup + motion (SplitText).
Status: LINT-PASS. Pendente: QA gates + melhorias visuais.

## Diagnostico — Issues Encontrados

### A. Font-size violation (P0)
`.imp-detail` usa **16px** — abaixo do minimo **18px** para canvas 1280 (regra em metanalise/CLAUDE.md).
A 10m de projecao, 16px e ilegivel. **Corrigir para 18px.**

### B. Dead CSS (P1 — cleanup)
S138 removeu `.imp-mech-label`, `.imp-mech-desc`, `.imp-mech-arrow` do HTML.
CSS ainda tem regras para esses seletores (linhas 766-794). **Remover CSS morto.**

### C. SplitText cleanup (P1)
`splitInstances[]` e populado mas nunca revertido. SplitText injeta `<div>` wrappers
que ficam no DOM indefinidamente. Deveria ter cleanup (e.g., on slide exit ou no ctx).

### D. Border-left ausente
HANDOFF S137 menciona "border-left 4px solid --ui-accent" nas rows, mas CSS atual
nao tem `border-left` nos `.imp-row`. Verificar se foi removido intencionalmente.

### E. Spacing revisao
Gaps atuais: `.imp-advantages` gap 10px, `.imp-row` padding 10px 16px.
Verificar se spacing e suficiente para legibilidade a 10m.

## Decisao Lucas

- Animacao SplitText "sem sentido, nao ficou bom" — motion sem proposito percebido
- Direcao: corrigir issues tecnicos AGORA, depois consultar Gemini para ideias criativas
- Plano pos-fixes: Gemini inspect/editorial para perspectiva diferente

## Plano de Execucao

### Step 1: Font-size fix (P0)
`.imp-detail` 16px → 18px em metanalise.css (linha 834)

### Step 2: Dead CSS cleanup
Remover regras de `.imp-mech-label` (766-774), `.imp-mech-desc` (782-789),
`.imp-mech-arrow` (790-794) — classes ausentes do HTML desde S138

### Step 3: SplitText cleanup
Adicionar revert dos splitInstances (cleanup de DOM wrappers).
Nota: animacao pode ser removida/simplificada apos feedback Gemini.

### Step 4: Verificar border-left
Confirmar se ausencia e intencional ou se precisa restaurar.

### Step 5: Build + lint
`npm run build:metanalise` + `npm run lint:slides` para confirmar.

### Pos-execucao
1. Push (9 commits pendentes + novos)
2. Salvar memoria: filosofia motion design
3. Reforcar anti-sycophancy na memoria existente
4. Gemini QA gates para ideias criativas

## Verificacao
- `npm run lint:slides` PASS
- `npm run build:metanalise` PASS
- Screenshot para Lucas avaliar visualmente
