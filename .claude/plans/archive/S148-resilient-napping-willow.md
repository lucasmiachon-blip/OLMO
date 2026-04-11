# Plan: Refatorar Evidence HTMLs — DOIs Clicaveis (Benchmark: pre-reading-heterogeneidade)

## Context

5 evidence HTMLs precisam de DOIs clicaveis seguindo o padrao do benchmark `pre-reading-heterogeneidade.html`. Lucas le as MAs candidatas em paralelo enquanto eu refatoro.

## Benchmark (pre-reading-heterogeneidade.html)

Padrao de referencia com DOI:
```html
<a class="ref-pmid" href="https://pubmed.ncbi.nlm.nih.gov/XXXXX" target="_blank">PMID XXXXX</a> | <a class="ref-pmid" href="https://doi.org/10.xxx/xxx" target="_blank">DOI</a> | Acesso livre
```
- DOI usa a mesma class `.ref-pmid` (azul, clicavel)
- PMID e DOI lado a lado com `|` separador
- Acesso indicado quando relevante

## DOIs encontrados por arquivo

| Arquivo | DOIs como texto puro | Onde |
|---------|---------------------|------|
| s-checkpoint-1.html | `10.1016/S0140-6736(09)60697-8` (Ray 2009) | L29, tabela identificacao |
| s-checkpoint-1.html | `10.1056/NEJMoa0802743` (ACCORD) | L51, tabela identificacao |
| s-ancora.html | `10.1016/S0140-6736(25)01562-4` (Valgimigli) | L24, tabela identificacao |
| s-objetivos.html | `DOI:10.2307/1162483` (Luiten) | L203, ref-list |
| s-hook.html | nenhum | — |
| s-rs-vs-ma.html | nenhum | — |

## Plano de edits

### 1. s-checkpoint-1.html (2 DOIs)
- L29: `<td>10.1016/S0140-6736(09)60697-8</td>` → `<td><a class="ref-pmid" href="https://doi.org/10.1016/S0140-6736(09)60697-8" target="_blank">10.1016/S0140-6736(09)60697-8</a></td>`
- L51: `<td>10.1056/NEJMoa0802743</td>` → `<td><a class="ref-pmid" href="https://doi.org/10.1056/NEJMoa0802743" target="_blank">10.1056/NEJMoa0802743</a></td>`
- Nota: DOIs no bloco Scite (`<code>`) ficam como estao — sao referencia tecnica, nao links para leitor.

### 2. s-ancora.html (1 DOI)
- L24: `<td>10.1016/S0140-6736(25)01562-4</td>` → `<td><a class="ref-pmid" href="https://doi.org/10.1016/S0140-6736(25)01562-4" target="_blank">10.1016/S0140-6736(25)01562-4</a></td>`

### 3. s-objetivos.html (1 DOI)
- L203: `DOI:10.2307/1162483` → `<a class="ref-pmid" href="https://doi.org/10.2307/1162483" target="_blank">DOI</a>`

### 4. s-hook.html — nenhum DOI. Skip.
### 5. s-rs-vs-ma.html — nenhum DOI. Skip.

## Escopo explicito

- SO DOIs: transformar texto puro em `<a>` clicavel
- NAO toca: conteudo, h2, secoes, estrutura, PMIDs (ja sao links), badges V/C
- NAO converte formato de refs (`ol.ref-list` → `table`)
- NAO adiciona secoes ausentes

## Verificacao

1. Abrir cada HTML editado no browser
2. Clicar nos DOIs e confirmar que abrem doi.org
3. Grep final por DOIs nao linkados

## Arquivos

- `content/aulas/metanalise/evidence/s-checkpoint-1.html` (2 edits)
- `content/aulas/metanalise/evidence/s-ancora.html` (1 edit)
- `content/aulas/metanalise/evidence/s-objetivos.html` (1 edit)
