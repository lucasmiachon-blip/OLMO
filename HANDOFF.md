# HANDOFF - Proxima Sessao

> Sessao 80 | 2026-04-05
> Cross-ref: `content/aulas/metanalise/HANDOFF.md` (estado dos slides, ordem do deck, pipeline QA por slide)

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Lint clean (v6). Build OK (19 slides metanalise).
**Agentes: 8** (era 11). Consolidacao S79: 3 eliminados, 3 melhorados.

## AGENTES (pos-S79)

| Agente | Papel | Status |
|--------|-------|--------|
| **evidence-researcher** | Pesquisa: MCPs + Perplexity + Gemini. Triangulacao interna. MBE/andragogia. | HARDENED |
| **qa-engineer** | 35 checks, 1 slide, scripts existentes | HARDENED |
| **mbe-evaluator** | Avalia qualidade evidencia (8 dim). FROZEN ate aula completa. | HARDENED |
| **reference-checker** | Cross-ref PMIDs slides/evidence-db | FIX S79 (mcp:pubmed) |
| **quality-gate** | Pre-commit lint/type/test | **PENDENTE: hardening + scripts JS/CSS** |
| **researcher** | Exploracao codebase read-only | OK |
| **repo-janitor** | Orfaos, links quebrados, limpeza | OK |
| **notion-ops** | Notion DB read/write | OK |

## P0 — PENDENTE PROXIMA SESSAO

### quality-gate (Fix 6/7 da S79)
- Adicionar ENFORCEMENT duplo
- Reescrever checklist: manter ruff/pytest + adicionar lint-slides.js, lint-narrative-sync.js, lint-gsap-css-race.mjs, validate-css.sh, done-gate.js
- Rodar de `content/aulas/`

### QA slide-a-slide (Lucas decide qual)
- s-objetivos: Gate 0/4 pendentes
- s-checkpoint-1: fixes pendentes (axis 10→14px, trial names 16→18px, tabular-nums)
- Fila: 13 slides LINT-PASS

## WORKFLOW DE AGENTES

**Max 2 agentes simultaneos. Lucas dita slide/tema.**

| Papel | Script | Regra |
|-------|--------|-------|
| Research | evidence-researcher (MCPs + Perplexity + Gemini) | 1 slide, Lucas escolhe |
| QA | qa-batch-screenshot.mjs + qa-engineer + gemini-qa3.mjs | 1 slide, Lucas escolhe |
| Build | npm run build:metanalise | Apos edits |

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- deck.js le DOM, nao manifest em runtime. index.html gerado pelo build.
- Agentes: max 2, Lucas dita, scripts existentes, 1 slide por vez.
- mbe-evaluator: frozen ate aula completa.
- Memory governance: cap 20 files (14 atual), next review S81.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — rodar build-html.ps1 apos editar _manifest.js.
- **Editar slide = AMBOS arquivos** — slides/{file}.html + index.html.
- **CSS per-slide: `section#s-{id}`** — specificity 0,1,1,1.
- PMIDs de LLM: ~56% erro. SEMPRE verificar.

## SECURITY (S72)

### Pendentes (MODERATE)
- [ ] SEC-002: NLM shell injection
- [ ] SEC-003: Gemini API key no URL → header
- [ ] SEC-004: MCP servers unpinned
- [ ] SEC-005: CHATGPT_MCP_URL sem validacao

## PENDENTE (herdado)

- [ ] gemini-qa3.mjs: grade aula crash (missing docs/prompts/)
- [ ] Obsidian CLI (backlog)
- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite
- [ ] Anki MCP setup

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-05
