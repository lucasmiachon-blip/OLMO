# Auditoria de Agentes e Scripts — S79

> Data: 2026-04-05 | Sessao: AGENTES
> Fonte: S78 audit + S79 consolidacao (eliminacao redundancias, hardening, fix tools)

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

## Agentes ativos (9)

### Core QA Pipeline (2)
| Agente | Funcao | Status |
|--------|--------|--------|
| **qa-engineer** | 35 checks, 1 slide, scripts existentes | HARDENED S78 |
| **quality-gate** | Pre-commit lint/type/test | PENDENTE hardening S79 |

### Core Research Pipeline — 5 pernas (3 agentes)
| Agente | Funcao | Status |
|--------|--------|--------|
| **evidence-researcher** (medical-researcher) | Multi-MCP + triangulacao 5 pernas + MBE/andragogia, 1 slide | CONSOLIDADO S79 (absorveu opus-researcher) |
| **mbe-evaluator** | Avalia qualidade de evidencia (8 dim) | PENDENTE hardening S79 |
| **reference-checker** | Cross-ref PMIDs slides/evidence-db | FIX S79: mcp:pubmed adicionado nos tools |

### Discovery (1)
| Agente | Funcao | Status |
|--------|--------|--------|
| **perplexity-auditor** | Perplexity Sonar deep-research | PENDENTE hardening S79 |

### Utility (3)
| Agente | Funcao | Status |
|--------|--------|--------|
| **researcher** | Exploracao codebase read-only | OK |
| **repo-janitor** | Orfaos, links quebrados, limpeza | OK |
| **notion-ops** | Notion DB read/write | OK |

## Mudancas S79

| Acao | Agente | Motivo |
|------|--------|--------|
| ELIMINADO | mcp-query-runner | Nao-funcional (tools so Read, nao acessava MCPs). SCite/Consensus via claude.ai nativos. |
| ELIMINADO | opus-researcher | Redundante com evidence-researcher (5 MCPs identicos). Conteudo unico mergeado. |
| CONSOLIDADO | evidence-researcher | Absorveu: triangulacao pipeline, expertise MBE+andragogia, divergencias, SCite critique. |
| FIX | reference-checker | Adicionado mcp:pubmed nos tools (antes nao verificava PMIDs via MCP). |

## Pendente S79

| Agente | Pendencia |
|--------|-----------|
| quality-gate | Hardening S78 + reescrever com scripts JS/CSS |
| mbe-evaluator | Hardening S78 (ENFORCEMENT + stop gate) |
| perplexity-auditor | Hardening S78 (ENFORCEMENT + stop gate) |

---
Coautoria: Lucas + Opus 4.6 | 2026-04-05
