# Aulas — Slides Interativos para Ensino Medico

## Quick Start

```bash
cd content/aulas
npm install
npm run dev          # Abre Vite dev server
npm run dev:cirrose  # Abre direto na aula de cirrose
```

## Estrutura

```
cirrose/           # Live: 44 slides, deck.js + GSAP, assertion-evidence
grade/             # Scaffold (58 slides Reveal.js no repo aulas-magnas)
metanalise/        # Scaffold (18 slides deck.js no branch feat/metanalise-mvp)
osteoporose/       # Scaffold (70 slides Reveal.js no repo aulas-magnas)
scripts/           # Tooling compartilhado (linters, QA)
STRATEGY.md        # Roadmap + pesquisa de ferramentas
```

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
