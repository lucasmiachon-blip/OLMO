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

## Agentes ativos (8)

### Core QA Pipeline (2)
| Agente | Funcao | Status |
|--------|--------|--------|
| **qa-engineer** | 35 checks, 1 slide, scripts existentes | HARDENED S78 |
| **quality-gate** | Pre-commit lint/type/test | PENDENTE hardening S79 |

### Core Research Pipeline (3 agentes)
| Agente | Funcao | Status |
|--------|--------|--------|
| **evidence-researcher** | Triangulacao interna (MCPs + Perplexity + Gemini) + MBE/andragogia, 1 slide | CONSOLIDADO S79 (absorveu opus-researcher + perplexity-auditor) |
| **mbe-evaluator** | Avalia qualidade de evidencia (8 dim) | HARDENED S79 |
| **reference-checker** | Cross-ref PMIDs slides/evidence-db | FIX S79: mcp:pubmed adicionado nos tools |

### Utility (3 — sem mudanca, exceto 1 eliminado)
| Agente | Funcao | Status |
|--------|--------|--------|
| **researcher** | Exploracao codebase read-only | OK |
| **repo-janitor** | Orfaos, links quebrados, limpeza | OK |
| **notion-ops** | Notion DB read/write | OK |

## Mudancas S79

| Acao | Agente | Motivo |
|------|--------|--------|
| ELIMINADO | mcp-query-runner | Nao-funcional (tools so Read, nao acessava MCPs). SCite/Consensus via claude.ai nativos. |
| ELIMINADO | opus-researcher | Redundante (5 MCPs identicos). Conteudo mergeado no evidence-researcher. |
| ELIMINADO | perplexity-auditor | Absorvido pelo evidence-researcher (Perplexity via Bash + triangulacao interna). |
| CONSOLIDADO | evidence-researcher | Absorveu: opus-researcher + perplexity-auditor. Triangulacao interna (MCPs + Perplexity + Gemini). MBE/andragogia. |
| FIX | reference-checker | Adicionado mcp:pubmed nos tools. |
| HARDENED | mbe-evaluator | ENFORCEMENT duplo + stop gate. |

## Pendente S79

| Agente | Pendencia |
|--------|-----------|
| quality-gate | Hardening + reescrever com scripts JS/CSS |

---
Coautoria: Lucas + Opus 4.6 | 2026-04-05
