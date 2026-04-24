# Plan — Auto-diagnóstico adversarial shared-v2 (HEAD main)

## Context

`content/aulas/shared-v2/` é biblioteca CSS greenfield entregue em S237 C4 (`a95a18d`) + hotfix S238 B (`4b9b80c`) + revert S238 (`4bd271e`). 10 arquivos / 945 linhas totais (tokens 3 camadas + fluid type + layout primitives + mocks). C5 (motion + JS + presenter-safe) começará sobre esta base com deadline preceptoria **30/abr/2026 (T-8d)**. Aula metanalise anterior sofreu slide invisível em projetor por bug de scaling — shared-v2 é reescrita defensiva; validar base antes de acrescentar camada de motion+JS é cheaper-to-fix-now than cheaper-to-fix-later.

Diagnóstico é **independente por design** (KBP-28 §Adversarial review — frame-bound): Codex CLI + Opus.ai já produziram reviews externos não lidos aqui. Triangulação pós-execução comparará resultados.

## Isolamento (hard-block)

**Permitidas:** `content/aulas/shared-v2/**`, `docs/adr/0005-shared-v2-greenfield.md`, `.claude/rules/*.md`, `CLAUDE.md` raiz, `git log/show` do path restrito.

**Proibidas:** `HANDOFF-S237*`, `HANDOFF-S238*`, qualquer `codex-*`, `adversarial-review*`, `.claude-tmp/*`, `CHANGELOG.md §Sessao 238`, `HANDOFF.md §S238 residual`. Se aparecer em grep collateral, ignorar como input.

## Estratégia de execução

**Read-only estrito:** Read, Grep, Bash (git/find/wc/node) — sem Edit/Write em arquivos de produto, sem `npm run dev`, sem commit. Plan file é o único writeable, e só durante plan mode.

**Batches de 3 items com pause explícita** (conforme brief "Agrupe no máximo 3 itens antes de pausar"):

| Batch | Items | Tema | Ferramentas principais |
|-------|-------|------|------------------------|
| 1 | 1, 2, 3 | CSS fundamentos visuais | Read (index.css), node+culori, node+apca-w3 |
| 2 | 4, 5, 6 | Disciplina de tokens | Read+node (clamp math), Grep (skip-chain, literais) |
| 3 | 7, 8, 9 | Convenções CSS | Grep (seletores, branching, prefers-reduced-motion) |
| 4 | 10, 11, 12 | Integridade semântica | git show, Grep `.cols`, Read (mocks) |
| 5 | 13 | Git hygiene | git status, find -size 0, grep TODO/FIXME |

Pause points entre batches. Silêncio = prosseguir (conforme brief).

## Dependências e gates de autorização

- **`culori`**: confirmado em `OLMO/node_modules/culori` (exploração plan mode).
- **`apca-w3@0.1.9`**: confirmado em `OLMO/node_modules/apca-w3` via `npm ls`.
- **Runtime risk:** `node -e` foi **deny** em plan mode (alinhado com CLAUDE.md §CC schema gotchas + S238 residual "Fechamento deny-list `node -p` deferido"). Fora do plan mode, provavelmente passa — mas se bloquear, fallback:
  - Tentar `node -e` direto (1 tentativa)
  - Se deny: reportar PARCIAL para Items 2 e 3 com evidência de bloqueio + sugerir Lucas rodar `! node -e '...'` manualmente OU aprovar pattern Bash específico
  - NÃO inventar valores OKLCH/APCA (brief explícito)

## Item-by-item execution spec

### Item 1 — At-rules order em `css/index.css`
- Read integral de `content/aulas/shared-v2/css/index.css` (116 li).
- Extrair ordem concreta: `@charset?` → `@layer statement?` → `@import × N` → `@font-face × N` → outras regras.
- CSS Cascade §6.1: `@import` deve preceder qualquer regra que não seja `@charset` ou `@layer` statement.
- Output: ordem real + PASS se `@layer` stmt → `@import` → `@font-face`; FAIL se `@font-face` anterior a `@import`.

### Item 2 — OKLCH gamut sRGB em `tokens/reference.css`
- Grep `--oklch-*` em reference.css, extrair tokens com valores `oklch(L% C H)`.
- Script node inline: `node -e "const c = require('culori'); [...lista de tokens].forEach(t => { const v = c.parse(t.value); console.log(t.name, c.displayable(v), c.rgb(v)); })"`.
- Se node -e bloqueado: reportar PARCIAL, listar todos os tokens com valores parse-ready para Lucas rodar.
- Output: tabela por token (name, oklch, displayable boolean, R/G/B calculated).

### Item 3 — APCA contrast em pares text/bg reais
- Grep em `tokens/components.css` por pares `color` + `background`/`background-color` na mesma regra. Expandir scope para `tokens/system.css` se classes como `.evidence`/`.chip-*` resolvem via system.
- Cadeia de resolução: components.css → system.css → reference.css até literal OKLCH.
- Script node apca-w3: `const Lc = APCAcontrast(sRGBtoY(text_rgb), sRGBtoY(bg_rgb))`.
- Target: Lc ≥ 75 body, Lc ≥ 60 elementos grandes (projetor 10m/60 pessoas).
- Output: tabela par × Lc calculado; FAIL se algum par < 60.

### Item 4 — Fluid type fórmula em `type/scale.css`
- Read integral de `content/aulas/shared-v2/type/scale.css` (70 li).
- Extrair cada `clamp(size_min, floor_px + N cqi, size_max)`.
- Validar numericamente: em container=600px → output = size_min; container=1920px → output = size_max.
- Fórmula referência: `N = (max - min) / ((1920 - 600) / 100)`; `floor = min - N × 6`.
- Desvio aceitável <0.1px.
- Output: tabela por clamp (min, N, floor, max, check 600/1920).

### Item 5 — Skip-chain violations
- Grep `var(--oklch-*)` em `tokens/system.css` (legítimo, system consome reference).
- Grep `var(--oklch-*)` em `tokens/components.css` (violação, components deveria só ler system).
- Grep `var(--(space|size|radius|...)--[0-9])` patterns de primitives em components (se aplicável).
- Output: linha-a-linha cada hit em components.css.

### Item 6 — Literais hardcoded
- Grep regex `[0-9]+\.?[0-9]*(rem|em|px|ch|cqi|cqw|cqh|%)` em todos os .css de shared-v2.
- Filtrar fora: comentários `/* */`, `clamp()` boundaries absolutos, `@font-face src/unicode-range`.
- Output: tabela suspeitos (file:line, valor, contexto minimal 1-liner).

### Item 7 — Seletores genéricos
- Grep regex `^\s*(section|div|p|h[1-6]|span|ul|ol|li|a|img)\s*\{` em todos os .css.
- Exceção: reset layer explícito (procurar nesting dentro de `@layer reset`).
- Output: hits fora do reset.

### Item 8 — Branching em primitives
- Grep `@container` e `@media` em `layout/primitives.css`.
- Grep `@container` e `@media` em `layout/slide.css`. `container-type` global aceitável em slide.css.
- Output: hits com tipo + regra.

### Item 9 — `prefers-reduced-motion` compliance
- Grep `@media (prefers-reduced-motion: reduce)` em todos os .css.
- Grep `transition:` e `animation:` em todos os .css.
- Cross-ref: cada transition/animation tem override reduce-motion neutralizando duração?
- Output: tabela transitions/animations sem reduce-override.

### Item 10 — ADR-0005 vs HEAD
- Read `docs/adr/0005-shared-v2-greenfield.md` seção C4 scope.
- `git show a95a18d --stat -- content/aulas/shared-v2/` para arquivos do commit C4.
- Overlay: ADR menciona X files + Y features; commit entrega esses? Divergência?
- Output: diff ADR-declared vs HEAD-real.

### Item 11 — `.cols` colisão
- `grep -rn "\.cols" content/aulas/` para escopo de colisão por aula.
- `grep -rn "\.cols" node_modules/bootstrap 2>/dev/null` se Bootstrap instalado.
- Verificar classe em outras aulas (cirrose/metanalise) via Grep.
- Output: contexto de colisão + recomendação renaming se aplicável.

### Item 12 — Mocks `_mocks/*.html`
- Read hero.html (19 li) + evidence.html (26 li).
- Checklist por arquivo: `<!doctype html>` case insensitive, `<meta charset>`, `<meta viewport>`, `lang="pt-BR"`, `<link rel="stylesheet" href="../css/index.css">` (path resolvable), pattern `<section data-slide=...>` ou equivalente.
- Output: tabela arquivo × 6 checks.

### Item 13 — Git hygiene + arquivos vazios + débito
- `git status --short` escopado a `content/aulas/shared-v2/`.
- `find content/aulas/shared-v2 -type f -size 0`.
- `grep -rlE "^(TODO|FIXME|XXX|HACK)" content/aulas/shared-v2/`.
- Output: 3 blocos (clean working tree? | empty files? | debt markers?).

## Output format (per item)

```
## Item N — <nome curto>
Status: PASS | FAIL | PARCIAL | N/A (com justificativa)
Evidência: <path:linha | comando | saída concreta>
Se FAIL: bug descrito + sugestão (não aplicar) + confidence 0.0-1.0
```

## Síntese final (≤6 linhas)

- Totais: PASS / FAIL / PARCIAL / N/A
- FAILs críticos (bloqueiam C5)
- FAILs médios (hotfix antes de C8+ slides)
- FAILs menores
- Recomendação binária: `C5 pode começar` OU `Hotfix C4.x obrigatório antes de C5`

## Regras de processo (hard-block re-stated)

- NÃO Edit. NÃO Write (exceto plan file). NÃO commit. NÃO `npm run dev`/HTTP server.
- NÃO invente items fora dos 13.
- NÃO leia fontes proibidas. Se ver colateral em grep, descartar como input.
- N/A exige justificativa explícita.
- Cada FAIL precisa evidência concreta (path+linha+valor/saída).
- Item que exija smoke test HTTP runtime → reportar "precisa smoke test HTTP" e parar o item.
- Pause entre batches; silêncio Lucas = prosseguir.

## Verificação end-to-end

Execução produz 13 blocks de output estruturado + síntese final ≤6 linhas. Critério de sucesso do **plano** (não do produto): todos os 13 items recebem Status + Evidência com regra adversarial respeitada. Produto (shared-v2) passa ou falha conforme o diagnóstico — independente do plano.

## Critical files (read-only)

- `content/aulas/shared-v2/css/index.css` (Item 1, 6, 9)
- `content/aulas/shared-v2/tokens/reference.css` (Item 2, 5, 6)
- `content/aulas/shared-v2/tokens/system.css` (Item 3, 5, 6, 9)
- `content/aulas/shared-v2/tokens/components.css` (Item 3, 5, 6, 7, 9)
- `content/aulas/shared-v2/type/scale.css` (Item 4, 6)
- `content/aulas/shared-v2/layout/primitives.css` (Item 7, 8, 9)
- `content/aulas/shared-v2/layout/slide.css` (Item 7, 8, 9)
- `content/aulas/shared-v2/_mocks/hero.html` (Item 12)
- `content/aulas/shared-v2/_mocks/evidence.html` (Item 12)
- `docs/adr/0005-shared-v2-greenfield.md` (Item 10)

## Não-goals

- Não escrevo fixes (read-only).
- Não comparo com revisões externas (Codex/Opus.ai) — triangulação é responsabilidade do Lucas pós-execução.
- Não audito `shared/` legacy (escopo estrito `shared-v2/`).
- Não proponho C5 plan — isso é tarefa separada (plan file distinto).
