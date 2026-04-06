# HANDOFF - Proxima Sessao

> Sessao 83 | 2026-04-05
> Cross-ref: `content/aulas/metanalise/HANDOFF.md` | `.archive/ADVERSARIAL-AUDIT-S81.md`

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Lint clean (v6). Build OK (19 slides metanalise).
**Agentes: 8.** MCPs: 12 connected + 3 planned = 15 total.
Adversarial audit S81: 21 achados, **20 fixados**, 1 pendente (BLOAT-1).
S82 INFRA: 10 items resolvidos (3 P0 SEC, 3 P1 BUG, 1 DOC, 2 RED, 1 maxTurns).

## AGENTES (pos-S82)

| Agente | Papel | Status |
|--------|-------|--------|
| **evidence-researcher** | Pesquisa: MCPs + Perplexity + Gemini. Triangulacao interna. | OK (output path fixed S82) |
| **qa-engineer** | Pipeline Preflight/Inspect/Editorial, 1 slide 1 gate | OK (contract fixed S82) |
| **mbe-evaluator** | Avalia qualidade evidencia (8 dim). FROZEN ate aula completa. | OK (contract → living HTML S82) |
| **reference-checker** | Cross-ref PMIDs slides/living HTML | OK (contract → living HTML S82) |
| **quality-gate** | Pre-commit lint/type/test | **P1 FROZEN: falta JS/CSS scripts** |
| **researcher** | Exploracao codebase read-only | OK |
| **repo-janitor** | Orfaos, links quebrados, limpeza | OK (model: haiku, maxTurns: 12) |
| **notion-ops** | Notion DB read/write | OK (mcpServers: claude_ai_Notion) |

## P1 — FROZEN

- quality-gate: hardening + JS/CSS lint scripts

## P2 — BACKLOG

- SEC-004: MCP servers unpinned — pinnar versoes em servers.json (MODERATE)
- SEC-005: CHATGPT_MCP_URL sem validacao — server is `planned`, non-issue ate connect (LOW)

## /insights S82 — Propostas APLICADAS

Todas 6 propostas aplicadas em `9f159b3`. Report: `.claude/skills/insights/references/latest-report.md`

## Pesquisas em andamento (S82)

- Agent self-improvement tools → `docs/research/agent-self-improvement-2026.md`
- Anti-drift/cross-ref tools → `docs/research/anti-drift-tools-2026.md`

## WORKFLOW DE AGENTES

**Max 2 agentes simultaneos. Lucas dita slide/tema.**

| Papel | Script | Regra |
|-------|--------|-------|
| Research | evidence-researcher (MCPs + Perplexity + Gemini) | 1 slide, Lucas escolhe |
| QA | qa-engineer (Preflight → Inspect → Editorial) | 1 slide 1 gate, Lucas escolhe |
| Build | npm run build:metanalise | Apos edits |

## DECISOES ATIVAS

- **Living HTML per slide = source of truth.** Evidence-first. evidence-db.md deprecated.
- **Gemini: so API/CLI, NAO MCP** (descartado S71).
- deck.js le DOM, nao manifest em runtime. index.html gerado pelo build.
- Agentes: max 2, Lucas dita, scripts existentes, 1 slide por vez.
- **1 gate = 1 invocacao** (hard stop via maxTurns).
- **Gate names descritivos** (Preflight/Inspect/Editorial).
- Memory governance: cap 20 files (14 atual), review done S81.
- Codex CLI: `codex exec --sandbox read-only -o file "prompt"`.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — rodar build-html.ps1 apos editar _manifest.js.
- **Editar slide = AMBOS arquivos** — slides/{file}.html + index.html.
- **CSS per-slide: `section#s-{id}`** — specificity 0,1,1,1.
- PMIDs de LLM: ~56% erro. SEMPRE verificar.
- CLI tools: `--help` ANTES do primeiro uso na sessao.

## SECURITY

### Pendentes (MODERATE, herdado)
- [ ] SEC-004: MCP servers unpinned
- [ ] SEC-005: CHATGPT_MCP_URL sem validacao

## PENDENTE (herdado)

- [x] BUG-3: export-pdf.js DeckTape reveal → generic (S82)
- [x] BUG-4: qa-video.js marked @deprecated — use qa-batch-screenshot.mjs (S82)
- [x] BUG-6: grade docs/prompts/ created + guard in gemini-qa3.mjs (S82)
- [ ] Obsidian CLI (backlog)
- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite
- [ ] Anki MCP setup

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-05
