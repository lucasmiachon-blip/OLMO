# HANDOFF - Proxima Sessao

> Sessao 83 | 2026-04-05
> Cross-ref: `BACKLOG.md` | `content/aulas/metanalise/HANDOFF.md`

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Lint clean (v6). Build OK (19 slides metanalise).
**Agentes: 8** (todos OK). MCPs: 12 connected + 3 planned = 15 total.
S82 INFRA: 13 items resolvidos, 6 /insights rules aplicadas, 3 BUGs herdados fixados.

## AGENTES

| Agente | Status |
|--------|--------|
| evidence-researcher | OK |
| qa-engineer | OK |
| mbe-evaluator | OK (FROZEN ate aula completa) |
| reference-checker | OK |
| quality-gate | **FROZEN: falta JS/CSS lint scripts** (ver BACKLOG) |
| researcher | OK |
| repo-janitor | OK |
| notion-ops | OK |

## PESQUISAS PENDENTES (S82)

- Agent self-improvement tools → `docs/research/agent-self-improvement-2026.md`
- Anti-drift/cross-ref tools → `docs/research/anti-drift-tools-2026.md`
- MD compilado com plano de implementacao → a criar quando pesquisas retornarem

## WORKFLOW DE AGENTES

**Max 2 agentes simultaneos. Lucas dita slide/tema.**

| Papel | Script | Regra |
|-------|--------|-------|
| Research | evidence-researcher (MCPs + Perplexity + Gemini) | 1 slide, Lucas escolhe |
| QA | qa-engineer (Preflight → Inspect → Editorial) | 1 slide 1 gate, Lucas escolhe |
| Build | npm run build:metanalise | Apos edits |

## DECISOES ATIVAS

- **Living HTML per slide = source of truth.** evidence-db.md deprecated.
- **Gemini: so API/CLI, NAO MCP** (descartado S71).
- deck.js le DOM, nao manifest em runtime. index.html gerado pelo build.
- Agentes: max 2, Lucas dita, scripts existentes, 1 slide por vez.
- **1 gate = 1 invocacao** (hard stop via maxTurns).
- Memory governance: cap 20 files (14 atual).
- Backlog persistente em `BACKLOG.md` (separado do HANDOFF).

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — rodar build-html.ps1 apos editar _manifest.js.
- **Editar slide = AMBOS arquivos** — slides/{file}.html + index.html.
- **CSS per-slide: `section#s-{id}`** — specificity 0,1,1,1.
- PMIDs de LLM: ~56% erro. SEMPRE verificar.

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-05
