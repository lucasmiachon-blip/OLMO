# HANDOFF - Proxima Sessao

> Sessao 82 | 2026-04-05
> Cross-ref: `content/aulas/metanalise/HANDOFF.md` (estado dos slides, ordem do deck, pipeline QA por slide)

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Lint clean (v6). Build OK (19 slides metanalise).
**Agentes: 8** (era 11). Consolidacao S79: 3 eliminados, 3 melhorados. Audit S80: rename + qa-engineer rewrite.

## AGENTES (pos-S80)

| Agente | Papel | Status |
|--------|-------|--------|
| **evidence-researcher** | Pesquisa: MCPs + Perplexity + Gemini. Triangulacao interna. | HARDENED (renamed S80) |
| **qa-engineer** | Pipeline Preflight/Inspect/Editorial, 1 slide 1 gate | REWRITTEN S80 |
| **mbe-evaluator** | Avalia qualidade evidencia (8 dim). FROZEN ate aula completa. | HARDENED |
| **reference-checker** | Cross-ref PMIDs slides/evidence-db | FIX S79 (mcp:pubmed) |
| **quality-gate** | Pre-commit lint/type/test | **P1 FROZEN: falta JS/CSS scripts** |
| **researcher** | Exploracao codebase read-only | OK |
| **repo-janitor** | Orfaos, links quebrados, limpeza | FIX S81 (model: fast→haiku). Falta maxTurns |
| **notion-ops** | Notion DB read/write | OK (verificar se mcp tools funcionam) |

## P0 — TESTAR AGENTES

- Testar qa-engineer reescrito (1 slide, 1 gate Preflight)
- Testar evidence-researcher renomeado (1 slide, pesquisa simples)

## P1 — FROZEN

- quality-gate: hardening + JS/CSS lint scripts
- notion-ops: verificar se mcpServers basta ou precisa mcp:notion-* tools explicitos
- repo-janitor: adicionar maxTurns
- qa-pipeline.md: gate names atualizados, mas scripts (gemini-qa3.mjs) ainda usam Gate 0/Gate 4 nos comments internos

## WORKFLOW DE AGENTES

**Max 2 agentes simultaneos. Lucas dita slide/tema.**

| Papel | Script | Regra |
|-------|--------|-------|
| Research | evidence-researcher (MCPs + Perplexity + Gemini) | 1 slide, Lucas escolhe |
| QA | qa-engineer (Preflight → Inspect → Editorial) | 1 slide 1 gate, Lucas escolhe |
| Build | npm run build:metanalise | Apos edits |

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- deck.js le DOM, nao manifest em runtime. index.html gerado pelo build.
- Agentes: max 2, Lucas dita, scripts existentes, 1 slide por vez.
- mbe-evaluator: frozen ate aula completa.
- Memory governance: cap 20 files (14 atual), next review S81.
- **1 gate = 1 invocacao** (hard stop via maxTurns, nao instrucao soft).
- **Gate names descritivos** (Preflight/Inspect/Editorial), nao numeros.

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
