# Plan: s-hook — Remover volume + simplificar animações

## Context

O slide s-hook tem 3 stats: ~80/dia (volume), 81% (AMSTAR-2), 33.8% (GRADE).
Problema: animações chamam mais atenção que a mensagem. O "80/dia" é irrelevante visualmente — Lucas fala nos notes.

## Mudanças

### 1. HTML (`metanalise/slides/01-hook.html`)
- Remover `.hook-volume` (bloco ~80/dia) e `.hook-divider`
- Manter os 2 `.hook-fact` (81% AMSTAR-2, 33.8% GRADE)
- Reestruturar `.hook-content` para centralizar os 2 facts
- Mover dado "~80/dia" para speaker notes (Lucas menciona verbalmente)

### 2. CSS (`metanalise/metanalise.css` linhas 155-247)
- `.hook-content`: grid 3-col → layout centrado para 2 facts
- Remover regras: `.hook-volume`, `.hook-divider`, `.hook-volume .hook-num`, `.hook-volume .hook-affix`, `.hook-volume .hook-label`
- Atualizar failsafes (.no-js, .stage-bad, @media print) removendo referências a volume/divider
- Manter tokens — NENHUMA cor literal nova

### 3. JS (`metanalise/slide-registry.js` linhas 50-89)
- Remover: volume entrance (fromTo x:-24), divider scaleY, delay logic para volume
- Simplificar: facts entram com fadeUp simples (opacity + y), sem x lateral
- CountUp: manter mas reduzir drama (sem delay escalonado complexo, duração mais curta)
- Objetivo: animação serve a mensagem, não compete com ela

### 4. Build + verificação
- `npm run build:metanalise`
- `npm run lint:slides metanalise`
- Verificar visual no browser (dev server :4102)

## Arquivos tocados
- `content/aulas/metanalise/slides/01-hook.html`
- `content/aulas/metanalise/metanalise.css`
- `content/aulas/metanalise/slide-registry.js`

## Verificação
- Lint PASS
- Build PASS
- Conferir no browser: 2 facts centralizados, animação sutil, mensagem > chrome
