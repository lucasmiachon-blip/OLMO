# Plan: s-pico — Evidence Benchmark + RS no Titulo + QA

## Context

HANDOFF S144 define 3 tarefas para s-pico:
1. Atualizar `evidence/s-pico.html` para o benchmark (estrutura de s-contrato.html)
2. Adicionar RS ao titulo/h2 do slide
3. QA pipeline (4 calls: A+B+C+D)

Pending-fix: `_manifest.js` modificado mas `index.html` nao rebuildado (5 ocorrencias). Resolver antes.

---

## Step 0: Pending Fix — Rebuild index.html

```bash
cd content/aulas && npm run build:metanalise
```
Depois: `rm .claude/pending-fixes.md`

---

## Step 1: Evidence HTML — Refatorar para Benchmark

**Arquivo:** `content/aulas/metanalise/evidence/s-pico.html`
**Benchmark:** `evidence/s-contrato.html` (DONE, R11)

### Mudancas concretas:

| # | O que | De (s-pico atual) | Para (benchmark) |
|---|-------|--------------------|-------------------|
| 1 | **CSS** | Minificado (1 linha) | Multi-line legivel (como s-contrato) |
| 2 | **Header** | h1 + meta simples | h1 + meta + `.objectives` box |
| 3 | **Section "sintese"** | Bloco narrativo unico longo | Dividir em `#concepts` (conceitos-chave) + `#narrative` (por que importa) |
| 4 | **Speaker notes** | Secao exposta `<section>` | Mover para `<details>` dentro de `#deep-dive` |
| 5 | **Pedagogia + Retorica** | 2 secoes expostas | Consolidar numa secao + mover detalhes para `<details>` |
| 6 | **Numeros-chave** | Tabela exposta | Manter exposta (dados sao core — diferente do benchmark puro) |
| 7 | **Sugestoes** | Secao exposta | Remover (artefato de pesquisa, nao leitor-facing) |
| 8 | **Depth rubric + Convergencia** | `<details>` (ja colapsado) | Manter em `<details>` (OK) |
| 9 | **Referencias** | `<ol class="ref-list">` com badges | Simplificar: manter PMID links inline, remover badges excessivos |
| 10 | **Footer** | Longa com pipeline info | Simplificar (como s-contrato: autor + curadoria) |
| 11 | **Componentes** | Sem key-takeaway/caveat | Adicionar `.key-takeaway` e `.caveat` onde apropriado |

### O que PRESERVAR intacto:
- Todo conteudo cientifico (fontes, PMIDs, dados verificados)
- Numeros-chave tabela (conteudo, nao formato)
- Depth rubric D1-D8 (conteudo)
- Convergencia entre fontes (conteudo)
- Referencias (conteudo — so reorganizar formato)

### Estrutura final proposta:
```
<header> h1 + meta + objectives
<section#concepts> Conceitos-chave + key-takeaway + tabela PICO-GRADE
<section#narrative> Por que este slide importa
<section#key-numbers> Numeros-chave (tabela 3 metricas)
<section#glossary> Referencia rapida (tabela termos)
<section#deep-dive>
  <details> Speaker Notes (timestamps)
  <details> Posicionamento Pedagogico
  <details> Analise Retorica
  <details> Depth Rubric D1-D8
  <details> Convergencia Entre Fontes
<section#referencias> Lista simplificada
<footer> Autor + curadoria
```

---

## Step 2: RS no Titulo/h2

**Regra:** h2 = trabalho do Lucas. Oferecer opcoes, nao decidir.

**h2 DECIDIDO por Lucas:**
> O valor da RS e da MA depende em grande parte da concordancia entre o study PICO e o seu target PICO

Ambos (slide h2 + evidence h1) ficam identicos.

Propagar para: `_manifest.js` headline + `references/narrative.md` + rebuild.

---

## Step 3: QA Pipeline (apos Steps 0-2 estarem OK)

Sequencia linear (1 slide, 1 gate):
1. `npm run build:metanalise`
2. `node scripts/qa-capture.mjs --aula metanalise --slide s-pico`
3. Gate 0: `node scripts/gemini-qa3.mjs --aula metanalise --slide s-pico --inspect`
4. [STOP — Lucas review]
5. Gate 4: `node scripts/gemini-qa3.mjs --aula metanalise --slide s-pico --editorial --round 1`
6. [STOP — Lucas review]

---

## Arquivos a Modificar

| Arquivo | Acao |
|---------|------|
| `content/aulas/metanalise/evidence/s-pico.html` | Refatorar (Step 1) |
| `content/aulas/metanalise/slides/04-pico.html` | h2 se Lucas aprovar (Step 2) |
| `content/aulas/metanalise/slides/_manifest.js` | headline sync se h2 mudar |
| `content/aulas/metanalise/references/narrative.md` | headline sync se h2 mudar |
| `content/aulas/metanalise/index.html` | Rebuild (Step 0 + apos mudancas) |

---

## Verificacao

- [ ] `npm run lint:slides` PASS apos mudancas
- [ ] `npm run build:metanalise` PASS
- [ ] Evidence HTML abre corretamente no browser
- [ ] Estrutura match benchmark (secoes, CSS legivel, details colapsados)
- [ ] Conteudo cientifico preservado (diff conteudo = zero perda)
- [ ] Se h2 mudou: propagado em 3 superficies (_manifest, narrative, slide)
