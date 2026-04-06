# Auditoria de Agentes e Scripts — S78

> Data: 2026-04-05 | Sessao: BUILD_SLIDES
> Fonte: Explore agent audit + Codex adversarial + erros observados S78

---

## Erros encontrados na S78

| Erro | O que aconteceu | Root cause |
|------|----------------|------------|
| QA batched all slides | qa-engineer analisou todos os slides em vez de 1 | Sem ENFORCEMENT de "1 slide" no agent .md |
| QA criou script proprio | Agente criou qa-measure.mjs em vez de usar qa-batch-screenshot.mjs | Sem referencia aos scripts existentes no agent .md |
| Research decidiu sozinho | medical-researcher pesquisou 19 slides sem Lucas pedir | Description dizia "proactively use" |
| Worktree desnecessario | Reorder rodou em worktree isolado | Decisao do orchestrador, nao do agent |

## Scripts removidos (orfaos/legacy)

| Script | Motivo | Substituido por |
|--------|--------|----------------|
| `qa-screenshots/s-objetivos/qa-debug.mjs` | Ad-hoc criado pelo agent, hardcoded | qa-batch-screenshot.mjs |
| `qa-screenshots/s-objetivos/qa-runner.mjs` | Ad-hoc criado pelo agent, hardcoded | qa-batch-screenshot.mjs + gemini-qa3.mjs |
| `scripts/browser-qa-act1.mjs` | Legacy (S39). Usa ArrowRight. | qa-batch-screenshot.mjs (usa __deckGoTo) |
| `scripts/qa-accessibility.js` | Legacy (S38). Checks basicos a11y. | gemini-qa3.mjs Gate 0 (cobre a11y + 8 categorias) |

## Scripts ativos (canonicos)

| Script | Funcao | Usado por |
|--------|--------|-----------|
| `lint-slides.js` | Lint de slides (v6) | qa-engineer, quality-gate |
| `qa-batch-screenshot.mjs` | Screenshots S0+S2 + metrics.json | qa-engineer |
| `gemini-qa3.mjs` | Gate 0 (inspect) + Gate 4 (editorial) | qa-engineer |
| `content-research.mjs` | Pesquisa Gemini + Google grounding | evidence-researcher |
| `lint-narrative-sync.js` | Valida manifest vs narrative.md | quality-gate |
| `lint-case-sync.js` | Valida manifest vs CASE.md (cirrose) | quality-gate |
| `lint-gsap-css-race.mjs` | Detecta race conditions GSAP/CSS | quality-gate |
| `validate-css.sh` | Cascade conflicts CSS | quality-gate |
| `done-gate.js` | Definition of Done (3 gates) | pre-commit |
| `export-pdf.js` | Export PDF via DeckTape | manual (ops) |
| `install-fonts.js` | Download WOFF2 fonts | manual (setup) |
| `install-hooks.sh` | Install git hooks | manual (setup) |

## Agentes ativos (11 → analise)

### Core QA Pipeline (2)
| Agente | Funcao | Status |
|--------|--------|--------|
| **qa-engineer** | 35 checks, 1 slide, scripts existentes | MELHORADO S78 |
| **quality-gate** | Pre-commit lint/type/test | OK |

### Core Research Pipeline — 6 pernas (5)
| Agente | Funcao | Status |
|--------|--------|--------|
| **evidence-researcher** (ex medical-researcher) | Multi-MCP, 1 slide, Lucas decide | MELHORADO S78 |
| **opus-researcher** | Pesquisa independente multi-MCP | OK |
| **mbe-evaluator** | Avalia qualidade de evidencia (8 dim) | OK |
| **reference-checker** | Cross-ref PMIDs slides/evidence-db | OK |
| **mcp-query-runner** | Executa queries SCite/Consensus | CANDIDATO A CONSOLIDAR |

### Discovery (1)
| Agente | Funcao | Status |
|--------|--------|--------|
| **perplexity-auditor** | Perplexity Sonar deep-research | OK |

### Utility (3)
| Agente | Funcao | Status |
|--------|--------|--------|
| **researcher** | Exploracao codebase read-only | OK |
| **repo-janitor** | Orfaos, links quebrados, limpeza | OK |
| **notion-ops** | Notion DB read/write | OK |

## Redundancias identificadas

| Par | Sobreposicao | Acao |
|-----|-------------|------|
| opus-researcher + evidence-researcher | Ambos multi-MCP, mesmas tools | Escopar: evidence-researcher = 1 slide (Lucas pede), opus-researcher = perna independente do /research |
| mcp-query-runner | Escopo muito estreito (so executa queries) | Candidato a merge no orchestrador futuro |
| quality-gate + qa-engineer | quality-gate faz lint/build, qa-engineer tambem | Aceitar: quality-gate = pre-commit, qa-engineer = QA visual. Escopos diferentes |

## Proposta para proxima sessao

### 1. Agente adversarial (Codex bridge)
Agente que formata prompts adversariais e envia ao Codex CLI, recebe output e apresenta ao Lucas com reflexao critica.

### 2. Orchestrador de casa
Agente que para, audita estado (git status, agentes rodando, scripts orfaos, HANDOFF desatualizado) e organiza antes de continuar.

---
Coautoria: Lucas + Opus 4.6 | 2026-04-05
