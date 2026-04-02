ERROS COMUNS DO PROJETO — NAO COMETER:

1. NUNCA vw/vh em font-size dentro de slides deck.js. scaleDeck() usa transform:scale mas vw referencia viewport real — fonts estouram em viewports >1280px. Usar px fixo. (ERRO-008)
2. NUNCA flex:1 igualitario em containers com filhos de tamanho desigual. Spacers ::before/::after de base.css competem com children flex:1 — override com display:none. (ERRO-005)
3. Contraste stage-c: fundo creme claro (L=95%). Tokens *-light (L>85%) sao INVISIVEIS como foreground. Verificar contraste >=7:1 para texto primario. (ERRO-009)
4. NUNCA display inline no <section> de slide — quebra navegacao deck.js. Layout vai em .slide-inner. (ERRO-001)
5. GSAP inline style (max specificity) sobrescreve CSS classes — race condition se ambos animam mesma propriedade.
6. data-background-color NAO funciona em deck.js (legacy Reveal.js). Usar background-color no CSS com seletor #slide-id .slide-inner. (ERRO-009)
7. justify-content:center em flex containers com overflow = clipping simetrico. Usar margin-top:auto no primeiro child. (ERRO-006)
8. #deck p herda max-width:56ch de base.css. Para <p> full-width (source-tag, footer): max-width:none + width:100% com seletor #deck p.className. (ERRO-007)
9. NUNCA zoom CSS — double-scaling com deck.js transform:scale. (ERRO-008)
10. slide-navy DEVE ter background-color no CSS E token restoration scope (8 tokens on-dark). Sem ambos = texto invisivel. (ERRO-009)
