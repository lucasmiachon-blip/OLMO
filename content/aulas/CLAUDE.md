# content/aulas/ — Regras Compartilhadas

> Aplica-se a TODAS as aulas (cirrose, metanalise, grade, futuras).
> Cada aula pode ter seu proprio CLAUDE.md com regras especificas.

## ENFORCEMENT (aulas)

1. **Build ANTES de QA.** `npm run build:{aula}` → depois QA. Sempre.
2. **QA via `gemini-qa3.mjs`** (unico script QA). Gates: Preflight (dims objetivas $0) → Inspect (Gemini Flash) → Editorial (Gemini Pro).
3. **1 slide, 1 gate, 1 invocacao.** Batch = violacao. Segundo slide = parar.
4. **Living HTML per slide = source of truth.** evidence-db.md deprecated.
5. **NUNCA `taskkill //IM node.exe`** — Lucas roda dev server. Matar por PID especifico.

## Build & Dev

- Package root: `content/aulas/package.json`
- Dev server: `npm run dev:{aula}` — portas: cirrose=4100, grade=4101, metanalise=4102
- Headless (Playwright/QA): rodar com timeout, matar ao terminar. NUNCA background sem PID
- Build: `npm run build:{aula}` — gera `{aula}/index.html` a partir de `_manifest.js`
- Build script: `{aula}/scripts/build-html.ps1` (PowerShell)
- **Lint ANTES de build** — guard-lint-before-build.sh bloqueia se lint falhar
- **index.html e gerado** — NUNCA editar diretamente. Editar `slides/*.html` + rodar build

## Design System (shared/)

- `shared/css/base.css` — tokens (cores, tipografia, espacamento)
- `shared/js/deck.js` — engine de slides (scaling, navegacao, click-reveals)
- `shared/assets/fonts/` — WOFF2 self-hosted (NUNCA Google Fonts CDN)
- Tokens: OKLCH com fallback HEX. Se divergirem, HEX vence
- Viewport: 1280x720 (deck.js escala via `scaleDeck()`)

## Scripts (content/aulas/scripts/)

| Script | Funcao |
|--------|--------|
| `lint-slides.js` | Lint HTML/CSS (errors bloqueiam build) |
| `lint-case-sync.js` | Verifica sincronia case panels |
| `lint-narrative-sync.js` | Verifica sincronia narrativa |
| `qa-capture.mjs` | Captura screenshots + video (utilitario, nao QA) |
| `gemini-qa3.mjs` | QA unico script — Preflight + Inspect + Editorial |
| ~~`content-research.mjs`~~ | ~~Pesquisa de conteudo~~ — **REMOVIDO S106.** Substituido por `/research` skill (6 pernas) |
| `done-gate.js` | Verifica estado DONE |
| `export-pdf.js` | Exporta PDF |

**Script primacy:** estes scripts sao canonicos. Agentes referenciam, nunca reimplementam.

## Convencoes por Aula

Cada aula segue a mesma estrutura:
```
{aula}/
  slides/*.html          ← fonte dos slides (1 arquivo por slide)
  slides/_manifest.js    ← metadata, ordem, headlines
  slide-registry.js      ← animacoes custom por slide
  {aula}.css             ← CSS scopado (section#s-{id})
  evidence/              ← HTML de evidencia por slide
  references/            ← reading-list.md, coautoria.md
  scripts/build-html.ps1 ← gera index.html
  CLAUDE.md              ← regras especificas (opcional)
  CHANGELOG.md           ← historico da aula
```

## Regras Universais

1. **Assertion-evidence:** h2 = assercao clinica, NUNCA rotulo generico
2. Sem `<ul>`/`<ol>` no corpo do slide
3. **CSS per-slide:** `section#s-{id}` no `{aula}.css` (specificity 0,1,1,1)
4. **Animacoes:** via `data-animate` declarativo, NUNCA gsap inline
5. **Dados numericos:** fonte Tier 1 obrigatoria. Sem fonte → `[TBD]`
6. **PMIDs:** NUNCA confiar em PMID de LLM sem verificar (~56% erro)
7. **QA:** 1 slide por ciclo. NUNCA batch
8. **Speaker notes:** `[DATA] Fonte: ... | Verificado: YYYY-MM-DD`

## Cross-Ref (Propagation Map)

| Se mudou... | Deve atualizar... |
|-------------|-------------------|
| `slides/{file}.html` | `_manifest.js` + `index.html` (run build) |
| `evidence/s-{id}.html` | slide correspondente (citation block) |
| `_manifest.js` | `index.html` (run build) |
| `h2` no slide HTML | `_manifest.js` headline |
| dados numericos | evidence HTML + speaker notes `[DATA]` tag |
| click-reveals | `_manifest.js` clickReveals + `slide-registry.js` |
