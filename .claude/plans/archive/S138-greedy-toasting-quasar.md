# Plano S138: QA s-importancia — H2 + Preflight

## Context

S137 removeu o h2 do s-importancia por erro de interpretacao. Lucas quer restaura-lo com texto especifico. Slide tem muito conteudo (5 vantagens + mecanismo) — preflight deve focar em legibilidade e hierarquia visual. Pending-fix: manifest desatualizado (9 alertas).

## Passo 1: Cleanup PNGs antigos

- Deletar: `qa-screenshots/s-importancia/s-importancia_2026-04-10_0046_S0.png`
- Tambem deletar: `animation-1280x720.webm`, `metrics.json` (desatualizados)
- Manter: `*.md` files (research docs de S132-era)

## Passo 2: Restaurar H2 no slide

Arquivo: `content/aulas/metanalise/slides/02-importancia.html`

Adicionar na linha 3 (apos `<div class="slide-inner">`, antes de `<div class="imp-layout">`):

```html
    <h2 class="slide-headline">Porque é importante: metodologia</h2>
```

Padrao identico aos 11 slides que usam `slide-headline` (ex: contrato, pico, forest-plot, etc).

## Passo 3: Atualizar _manifest.js

Mudar headline de `'Porque isso importa — Metodologia'` para `'Porque é importante: metodologia'`.

## Passo 4: Build

```bash
cd content/aulas && npm run build:metanalise
```

## Passo 5: Gerar novos screenshots

```bash
cd content/aulas && node scripts/qa-capture.mjs --aula metanalise --slide s-importancia
```

## Passo 6: Comparar com slides adjacentes

Capturar screenshots de s-hook (slide anterior) e s-contrato (proximo slide) para comparar altura do h2 visualmente. Lucas avalia.

## Passo 7: Preflight focado

Focos especificos do Lucas para este slide denso:
1. **Contraste** — texto sobre fundo, numeros, labels
2. **Alinhamentos** — grid esquerda/direita, numeros vs texto
3. **Hierarquia por tamanho** — h2 > mecanismo > nomes > detalhes
4. **Cores** — semantica correta, sem conflito
5. **Bold** — peso visual diferencia niveis
6. **Animacoes** — stagger dos rows, countUp se houver

## Passo 8: Limpar pending-fixes.md

Apos manifest atualizado, remover os 9 alertas repetidos.

## Verificacao

- Build PASS
- Screenshot novo gerado com h2 visivel
- h2 na mesma posicao vertical que s-contrato e s-hook
- Manifest headline = h2 do HTML

## Decisao pendente

- Texto exato do h2: Lucas escreveu "Porque e importante: metodologia". Confirmar acento e capitalizacao.
- Brainstorming skill: Lucas pediu ativacao — usar apos h2 restaurado para discutir melhorias esteticas antes do preflight?
