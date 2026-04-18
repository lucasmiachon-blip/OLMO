<!-- SHIPPED S204 (commit a940234 "Pipeline I/O Hardening"). E1-E5 artifacts verified: typographyHierarchy em qa-capture.mjs L342, validateFixTokens em gemini-qa3.mjs L531, {{TYPOGRAPHY_HIERARCHY}}+{{SPACING_MAP}} placeholders L1228-1229. Archived S226 post-close. -->

# Plan: Design Excellence — Input/Output Pipeline Hardening

## Context

S203 testou editorial no s-takehome. Resultado: evaluator produz feedback com 3 classes de erro sistemático que reduzem a eficiência do loop avaliação→fix→re-avaliação.

**Evidência do teste (s-takehome R11):**
1. Call A leu `font-size: 16px` do container (`.takehome-card`) em vez dos elementos de texto reais (`.takehome-text` 26px, `.takehome-num` 64px) → tipografia score=5 (falso positivo). Call D capturou, mas o score não foi corrigido upward.
2. Call B propôs `var(--text-display, 64px)` e `var(--text-lg, 28px)` — tokens que **não existem** em base.css. Causa: prompt diz "NUNCA px literal" mas não fornece font-size tokens (porque não existem no design system — deck.js escala via transform).
3. Aplicar gap `--space-xl` (64px) causou overflow — zero validação pós-fix.

**Problema real:** O pipeline gasta cycles do modelo e do operador em FPs e fixes inválidos. Fixes de elite requerem input de elite.

---

## Diagnóstico: 5 Gargalos

### G1. Shallow computed style extraction
`qa-capture.mjs` `measureElements()` escaneia 2 níveis de profundidade (children + grandchildren de `.slide-inner`). Estrutura do s-takehome:
```
slide-inner → takehome-grid → takehome-card → takehome-num / takehome-text
                                              ↑ NÍVEL 3 — NÃO CAPTURADO
```
Resultado: computedStyles tem `div.takehome-card` (16px base) mas NÃO `span.takehome-num` (64px) nem `p.takehome-text` (26px).

→ **Fix:** scan depth 3→4, com cap de 40 elementos (atualmente 25).

### G2. CSS properties insuficientes
`STYLE_KEYS` captura: fontSize, fontWeight, fontFamily, lineHeight, color, backgroundColor, opacity.
`LAYOUT_KEYS` captura: display, gap, gridTemplateColumns, gridTemplateRows, flexDirection.

**Missing para design de elite:**
- `padding`, `paddingBlock`, `paddingInline` — proximidade Gestalt (gap vs padding)
- `margin`, `marginBlock` — espaçamento externo
- `borderLeft`, `borderRadius` — hierarquia visual por borda
- `letterSpacing`, `fontVariantNumeric` — polish tipográfico
- `boxShadow` — elevação (mas pode ser verboso; talvez bool `hasBoxShadow`)
- `maxWidth` — readability constraint

→ **Fix:** expandir STYLE_KEYS e LAYOUT_KEYS. Adicionar SPACING_KEYS separado.

### G3. Contradição no prompt de tokens
Call B prompt (gate4-call-b-uxcode.md:70): "NUNCA px literal — usar var() ou clamp()"
Mas: nenhum font-size token existe em base.css. Resultado: Gemini inventa tokens.

Realidade do design system: deck.js escala todo o viewport via `transform: scale()`. Font-size em px é válido para per-slide sizing. Tokens existem para spacing (`--space-*`) e cores (`--safe`, etc.), não para font-size.

→ **Fix:** corrigir a instrução no prompt. "px OK para font-size per-slide (deck.js escala). Tokens obrigatórios para: spacing (--space-*), cores (--safe/warning/danger/ui-accent), border-radius (--radius-*). NUNCA inventar tokens — se não está na lista acima, usar valor concreto."

### G4. Sem hierarquia tipográfica no input
O modelo recebe `computedStyles` como JSON flat — todos os elementos no mesmo nível. Não há ordenação por importância visual. O modelo tem que inferir hierarquia, e frequentemente erra (lê container em vez de texto).

→ **Fix:** gerar seção `typographyHierarchy` no metrics.json:
```json
"typographyHierarchy": [
  { "selector": "h2.slide-headline", "fontSize": 34, "fontWeight": 600, "role": "headline", "color": "oklch(...)" },
  { "selector": "p.takehome-text", "fontSize": 26, "fontWeight": 400, "role": "body", "color": "oklch(...)" },
  { "selector": "span.takehome-num", "fontSize": 64, "fontWeight": 500, "role": "decorative", "color": "oklch(...)" }
]
```
Sorted by font-size descending. O role pode ser inferido: h1/h2 = "headline", p/span com font-size > 24 = "body", font-size < 18 = "caption".

→ **Também:** seção `spacingMap` com relações gap/padding/margin por container.

### G5. Zero validação pós-fix
Nenhuma verificação automática após aplicar fixes:
- Token existe em base.css? (fix 1.6 valida seletores CSS, mas não tokens)
- Overflow? (fillRatio > 0.95 após mudar gap/padding/font-size)
- Regressão visual? (screenshot comparison)

→ **Fix:** pipeline de validação pós-fix no /polish skill:
1. Token existence check (grep base.css)
2. Recapture + fillRatio check
3. Delta visual (comparar screenshot antes/depois)

---

## Implementação: 5 Edits

### E1. qa-capture.mjs — scan depth + properties + hierarchy
**Arquivo:** `scripts/qa-capture.mjs` (linhas 138-306)

Mudanças:
1. **Scan depth:** Adicionar nível 4 (great-grandchildren). Aumentar cap 25→40.
2. **Properties:** Expandir para:
   ```js
   const STYLE_KEYS = ['fontSize', 'fontWeight', 'fontFamily', 'lineHeight', 'color', 'backgroundColor', 'opacity', 'letterSpacing', 'fontVariantNumeric'];
   const LAYOUT_KEYS = ['display', 'gap', 'gridTemplateColumns', 'gridTemplateRows', 'flexDirection', 'justifyContent', 'alignItems'];
   const SPACING_KEYS = ['padding', 'paddingBlock', 'paddingInline', 'margin', 'marginBlock', 'marginInline'];
   const BORDER_KEYS = ['borderLeft', 'borderRadius'];
   ```
3. **Typography hierarchy:** Após scan, gerar array ordenado:
   ```js
   // Collect all text elements with computed font-size
   const textElements = [];
   for (const [label, styles] of Object.entries(computedStyles)) {
     if (styles.fontSize) {
       textElements.push({
         selector: styles.selector,
         fontSize: parseFloat(styles.fontSize),
         fontWeight: parseInt(styles.fontWeight) || 400,
         color: styles.color,
         role: inferRole(el, styles) // headline/body/caption/decorative
       });
     }
   }
   textElements.sort((a, b) => b.fontSize - a.fontSize);
   result.typographyHierarchy = textElements;
   ```
4. **Spacing map:** Para cada container com display:flex/grid, reportar:
   ```js
   result.spacingMap = containers.map(c => ({
     selector: selectorOf(c),
     gap: cs.gap,
     padding: cs.padding,
     childCount: c.children.length,
     note: parseFloat(cs.gap) < parseFloat(cs.padding) ? 'WARN: gap < padding (proximity)' : 'OK'
   }));
   ```

### E2. gate4-call-a-visual.md — computed data format
**Arquivo:** `metanalise/docs/prompts/gate4-call-a-visual.md` (linhas 24-31)

Mudanças:
1. Substituir `{{COMPUTED_DATA}}` por 3 seções organizadas:
   ```
   ## DADOS COMPUTADOS (Playwright — fonte de verdade)

   ### HIERARQUIA TIPOGRÁFICA (sorted by size)
   {{TYPOGRAPHY_HIERARCHY}}
   → Use ESTES tamanhos de fonte, NÃO estime do PNG.

   ### MAPA DE ESPAÇAMENTO (containers)
   {{SPACING_MAP}}
   → gap < padding = violação de proximidade Gestalt.

   ### ESTILOS COMPUTADOS (raw)
   {{COMPUTED_STYLES}}
   ```

2. Instrução explícita: "Para avaliar tipografia, leia a HIERARQUIA TIPOGRÁFICA — ela lista os elementos de TEXTO reais, não containers. O font-size de um `<div>` container é o default herdado, não o tamanho visível do texto."

### E3. gate4-call-b-uxcode.md — token contradiction fix
**Arquivo:** `metanalise/docs/prompts/gate4-call-b-uxcode.md` (linhas 68-77)

Mudar de:
```
/* NUNCA vw/vh em font-size. NUNCA px literal — usar var() ou clamp(). */
```
Para:
```
/* NUNCA vw/vh em font-size (deck.js scale).
   Tokens obrigatórios: spacing (--space-*), cores (--safe/--warning/--danger/--ui-accent/--text-*), border-radius (--radius-*).
   font-size: px OK para per-slide sizing (deck.js escala viewport). Thresholds: body ≥18px, títulos ≥28px, hero ≥48px.
   NUNCA inventar tokens. Se não está na lista acima, usar valor concreto. */
```

### E4. gemini-qa3.mjs — structured fix fields + token validation
**Arquivo:** `scripts/gemini-qa3.mjs`

Mudanças:
1. **buildSplitCallPayload:** ler `typographyHierarchy` e `spacingMap` de metrics.json e substituir no template como seções separadas (não dump raw).
2. **Novo: validateFixTokens()** — pós-Call B, verificar se tokens referenciados existem:
   ```js
   function validateFixTokens(proposals, baseCSS) {
     for (const p of proposals) {
       const tokens = [...p.fix.matchAll(/var\(--([a-z-]+)/g)].map(m => m[1]);
       for (const t of tokens) {
         if (!baseCSS.includes(`--${t}:`)) {
           p.token_valid = false;
           p.token_note = `Token --${t} not found in base.css`;
         }
       }
       if (p.token_valid !== false) p.token_valid = true;
     }
   }
   ```
3. **DIM_PROP schema:** adicionar campo opcional `old_value` ao fix:
   ```js
   fixes: { type: "ARRAY", items: {
     type: "OBJECT",
     properties: {
       target: { type: "STRING" },
       change: { type: "STRING" },
       reason: { type: "STRING" },
       old_value: { type: "STRING" }, // computed value atual (grounding)
     },
     required: ["target", "change", "reason"],
   }}
   ```

### E5. gemini-qa3.mjs — computed data placeholders
**Arquivo:** `scripts/gemini-qa3.mjs` (buildSplitCallPayload)

Adicionar placeholders `{{TYPOGRAPHY_HIERARCHY}}` e `{{SPACING_MAP}}` no replacements map, lidos do metrics.json. Formatar como texto legível (não JSON raw):
```
h2.slide-headline — 34px, 600, DM Sans — headline
span.takehome-num — 64px, 500, Instrument Serif — decorative
p.takehome-text   — 26px, 400, DM Sans — body
```

---

## Verificação

1. **Recapturar s-takehome:** metrics.json agora inclui typographyHierarchy com 3+ elementos de texto (não só containers)
2. **Rodar editorial s-takehome R12:** Call A usa hierarquia tipográfica → sem FP no font-size
3. **Verificar que Call B não inventa tokens:** fixes usam px para font-size, tokens para spacing/cor
4. **Token validation:** proposta com `var(--text-display)` → flagged como `token_valid: false`
5. **Spacing map:** containers reportam gap vs padding com WARN quando gap < padding

---

## Escopo e Limites

- **SIM:** 2 scripts + 2 prompts (4 arquivos de code, 2 de prompt)
- **NÃO:** /polish skill (Fase 2.2 — próximo step após este hardening)
- **NÃO:** rule design-excellence.md (Fase 2.1 — depende de pipeline validado)
- **NÃO:** Chrome DevTools MCP (Fase 2.2 — supplementar)

Este plano é pré-requisito para /polish funcionar bem. Sem input de qualidade, o loop gasta iterações em FPs e fixes inválidos.
