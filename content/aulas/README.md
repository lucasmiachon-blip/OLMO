# Aulas — Slides Interativos para Ensino Medico

## Quick Start

```bash
cd content/aulas
npm install
npm run dev:cirrose  # porta 4100
npm run dev:grade    # porta 4101
```

## Status por Aula

| Aula | Slides | Engine | Estado | Dev |
|------|--------|--------|--------|-----|
| `cirrose/` | 44 | deck.js + GSAP | Producao (lint clean) | `npm run dev:cirrose` |
| `grade/` | 58 | deck.js | Scaffold (9/10 falham C8 legibilidade) | `npm run dev:grade` |
| `metanalise/` | 18 | deck.js | Congelado (branch `feat/metanalise-mvp`) | — |
| `osteoporose/` | 70 | Reveal.js | Congelado (repo `aulas-magnas`) | — |

## Estrutura

```
cirrose/                 # Producao: 44 slides assertion-evidence
  slides/                #   HTMLs individuais + _manifest.js
  references/            #   CASE, narrative, evidence-db, archetypes, etc.
  scripts/               #   Build, QA, research (cirrose-especificos)
grade/                   # Scaffold: 58 slides, precisa redesign
  slides/                #   HTMLs + _manifest.js
  scripts/               #   Build, QA (grade-especificos)
  qa-screenshots/        #   Batch QA com metricas
metanalise/              # README.md (ponteiro para branch)
osteoporose/             # README.md (ponteiro para repo externo)
shared/                  # Design system compartilhado
  css/base.css           #   OKLCH tokens, grid, tipografia
  js/deck.js             #   Engine de slides (~170 linhas)
  js/engine.js           #   Animacoes GSAP + lifecycle
  js/case-panel.js       #   Estado do caso clinico
  js/click-reveal.js     #   Interacao click-reveal
  assets/fonts/          #   DM Sans, Instrument Serif, JetBrains Mono (woff2)
scripts/                 # Tooling compartilhado (linters, QA, export)
STRATEGY.md              # Roadmap tecnico + pesquisa de ferramentas
```

## Portas Vite (strictPort)

| Script | Porta | Notas |
|--------|-------|-------|
| `npm run dev` | 4100 | Generico, abre sem rota |
| `npm run dev:cirrose` | 4100 | Abre `/cirrose/index.html` |
| `npm run dev:grade` | 4101 | Abre `/grade/index.html` |
| `npm run preview` | 4173 | Preview do build |

`strictPort: true` — porta ocupada = erro imediato, nunca migra silencioso.

## Scripts

### Compartilhados (`scripts/`)

| Script | Comando npm | Proposito |
|--------|-------------|-----------|
| `done-gate.js` | `npm run done:cirrose` | Definition of Done: 3 gates (build+lint, screenshots, propagation). `--strict` para push. |
| `lint-slides.js` | `npm run lint:slides` | Lint estrutural em todos os slides (h2, notes, E07, etc.) |
| `lint-case-sync.js` | `npm run lint:case-sync` | Valida `_manifest.js` panelStates contra `CASE.md` |
| `lint-narrative-sync.js` | `npm run lint:narrative-sync` | Valida tensionLevel/narrativeRole contra `narrative.md` |
| `lint-gsap-css-race.mjs` | *(direto)* | Detecta race conditions GSAP vs CSS (ERRO-054) |
| `export-pdf.js` | *(direto)* | Export PDF via DeckTape. Usa preview na porta 4173. |
| `qa-accessibility.js` | *(direto)* | Audit WCAG (contraste, alt text, ARIA, font-size) |
| `install-fonts.js` | *(direto)* | Instala fonts woff2 para offline-first |

### Cirrose-especificos (`cirrose/scripts/`)

| Script | Comando npm | Proposito |
|--------|-------------|-----------|
| `build-html.ps1` | `npm run build:cirrose` | Template → HTML (PowerShell) |
| ~~`content-research.mjs`~~ | — | **REMOVIDO S106.** Substituido por `/research` skill |
| `capture-s-*.mjs` | *(direto)* | Screenshot de slide especifico |

### Grade-especificos (`grade/scripts/`)

| Script | Comando npm | Proposito |
|--------|-------------|-----------|
| `build-html.ps1` | `npm run build:grade` | Template → HTML (PowerShell) |

## Reference Docs (cirrose)

Os 7 documentos em `cirrose/references/` formam um grafo interconectado:

```
CASE.md ←──────── Source of truth (dados do paciente)
  ↕                 ↑ valida
narrative.md ←── Arco narrativo (3 atos, pacing, Chekhov's guns)
  ↕                 ↑ PMIDs
evidence-db.md ←─ Dados clinicos com PMID verificado
  ↕
must-read-trials.md ← Lista de leitura + status PDF (sync Notion)
  ↕
archetypes.md ←── Skeletons HTML para coding agents
  ↕
decision-protocol.md ← Protocolo para decisoes nao-triviais
  ↕
coautoria.md ←─── Disclosure AI (ICMJE 2024)
```

Cada arquivo tem secao "See also" linkando para os siblings relevantes.

## Integracao Notion

| DB Notion | Arquivo repo | Direcao | O que sincroniza |
|-----------|-------------|---------|------------------|
| References DB (`collection://2b24bb6c...`) | `must-read-trials.md`, `evidence-db.md` | Bidirecional | PMIDs, tier, PDF status |
| Biblia Narrativa (page) | `narrative.md` | Notion → Repo (draft) | Arco narrativo (repo e canonico) |
| Teaching Log (planejado) | — | — | Feedback de aulas |

Protocolo completo: `docs/SYNC-NOTION-REPO.md`
Seguranca Notion: `.claude/rules/mcp_safety.md`

## Stack

- **Engine:** deck.js (custom, ~170 linhas)
- **Animacao:** GSAP 3.14 (declarativo via `data-animate`)
- **Build:** Vite 6
- **Formato:** Assertion-Evidence (h2 = claim clinica, visual = evidencia)
- **Offline-first:** zero CDN, fonts self-hosted

## Decisao de formato por contexto

| Contexto | Ferramenta |
|----------|-----------|
| Aulas regulares | HTML/JS (deck.js + GSAP) |
| Conferencias (EASL, AASLD) | PPTX (obrigatorio) |
| Assets visuais | Canva Pro (MCP) |

Ver `STRATEGY.md` para roadmap completo.

## Build + QA Protocol

### Pipeline de build (sequencia obrigatoria)

1. Editar `content/aulas/{aula}/slides/*.html` (arquivos individuais)
2. Atualizar `slides/_manifest.js` (headline, timing, metadata)
3. Rodar `npm run build:{aula}` (ex: `npm run build:metanalise`)
4. Verificar no browser com Ctrl+Shift+R (hard reload)

`index.html` e arquivo gerado — hook `guard-generated.sh` bloqueia edits diretos. Editar o index = perder mudancas no proximo rebuild.

### Rebuild antes de QA

SEMPRE `npm run build:{aula}` ANTES de QA. O Vite serve `index.html` (build output), nao os slides individuais. Se o build nao rodou apos a ultima edicao, QA mostra conteudo stale. Script QA unico: `gemini-qa3.mjs` (Preflight + Inspect + Editorial).

### Screenshots QA

- Nome com timestamp: `s-rs-vs-ma_2026-04-02T23-15.png`
- Deletar todos os PNGs do slide apos QA concluido e Lucas aprovar
- NUNCA commitar screenshots de QA — artefatos temporarios
