# S163 Plan — HTML + SFOREST

## Context

Forest plot slides (`08a-forest1.html`, `08b-forest2.html`) existem mas sao shells minimos:
imagem cropada + source-tag. Evidence file extenso (s-forest-plot-final.html) ja cobre Li 2026,
Ebrahimi Cochrane 2025, sintese critica, census 15 MAs, e matriz overlap Li vs Ebrahimi.

Slides anteriores no deck (PICO, RS-vs-MA) sao referencia de estilo: HTML semantico rico,
data-animate, grids customizados. Os forest slides precisam atingir esse nivel.

## Pendencias HANDOFF (P0)

| # | Item | Tipo | Status |
|---|------|------|--------|
| 1 | Icone clicavel no slide 2 (Cochrane link) | HTML edit | Pronto para implementar |
| 2 | Pesquisar sobreposicao detalhada (15 MAs x 14 RCTs) | Research | Pendente — informa conteudo slide 2 |
| 3 | Resultados dos trials para conteudo visual | Research | Pendente — informa animacoes/efeitos |
| 4 | QA pipeline (Preflight → Inspect → Editorial) | QA | Pos-HTML |

## Decisoes do Lucas

1. **Slide 1 (Li 2026):** Adicionar elementos visuais — labels dos 5 elementos anatomicos + dados
2. **Slide 2 (Ebrahimi Cochrane):** Botao Cochrane visivel no slide + labels tambem
3. **Overlap research ANTES do HTML** — informa conteudo do slide 2

## Sequencia de execucao

### Fase 1: Pesquisa overlap (15 MAs x 14 RCTs)
- Fonte: evidence file ja tem Li vs Ebrahimi (10/14 compartilhados)
- Pesquisar: quais RCTs cada uma das 15 MAs incluiu
- Abordagem: PubMed/SCite para acessar included studies de cada MA
- Output: tabela de overlap → append ao evidence file
- **Gate:** Apresentar tabela a Lucas antes de prosseguir

### Fase 2: HTML slide 1 (Li 2026 — anatomia)
- Adicionar labels HTML dos 5 elementos (quadrado, barra, nulo, diamante, peso)
- Posicionamento: ao redor/sobre a imagem (CSS overlay ou legenda lateral)
- Dados de apoio: OR 0.72, 14 RCTs, 31.397 pacientes
- **Animacao:** click-reveal (data-reveal) para os 5 labels — professor revela cada
  elemento conforme ensina. Imagem entra com fadeUp, labels entram por click
  (1 por click, max 5 reveals). Proposito: pacing pedagogico — aluno ve o elemento
  antes de receber o nome. Mais engajante que stagger auto (que revela tudo de uma vez).
- CSS scopado: section#s-forest1 em metanalise.css
- **Gate:** Build + inspecao visual

### Fase 3: HTML slide 2 (Ebrahimi Cochrane — RoB + link)
- Botao Cochrane clicavel (URL ja definida no HANDOFF)
- Labels dos elementos + coluna RoB como diferencial visual
- Dados: RR 0.74 IAM, RR 0.67 AVC, GRADE alta
- **Animacao:** fadeUp para imagem, depois stagger nos labels/dados.
  Botao Cochrane com drawPath no icone (SVG stroke que "desenha" o logo/link).
  O RoB label entra por ultimo com highlight (Von Restorff) — e o punchline visual,
  o "meta-elemento #6" que diferencia Cochrane. Proposito: sequencia narrativa
  (reconhecer 5 elementos ja conhecidos → perceber o 6o novo → acao: abrir Cochrane).
- CSS scopado: section#s-forest2 em metanalise.css
- **Gate:** Build + inspecao visual

### Fase 4: Build + QA
- `npm run build:metanalise` (de content/aulas/)
- Lint slides
- QA se houver tempo (1 slide por ciclo)

## Arquivos criticos

- `content/aulas/metanalise/slides/08a-forest1.html` — slide 1
- `content/aulas/metanalise/slides/08b-forest2.html` — slide 2
- `content/aulas/metanalise/metanalise.css` — CSS (linhas 1068-1118)
- `content/aulas/metanalise/evidence/s-forest-plot-final.html` — evidence (source of truth)
- `content/aulas/metanalise/slides/_manifest.js` — metadata

## Verificacao

- `npm run build:metanalise` (de content/aulas/)
- Dev server porta 4102 para inspecao visual
- Lint: `npm run lint:slides`
