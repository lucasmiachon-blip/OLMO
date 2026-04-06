# HANDOFF - Proxima Sessao

> Sessao 82 | 2026-04-05
> Cross-ref: `content/aulas/metanalise/HANDOFF.md` | `.archive/ADVERSARIAL-AUDIT-S81.md` (checklist completo)

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Lint clean (v6). Build OK (19 slides metanalise).
**Agentes: 8.** MCPs: 12 connected + 3 planned = 15 total.
Adversarial audit S81: 21 achados, 10 fixados, 11 pendentes.

## AGENTES (pos-S81)

| Agente | Papel | Status |
|--------|-------|--------|
| **evidence-researcher** | Pesquisa: MCPs + Perplexity + Gemini. Triangulacao interna. | Output path stale (BUG-5) |
| **qa-engineer** | Pipeline Preflight/Inspect/Editorial, 1 slide 1 gate | Preflight contract gap (BUG-1) |
| **mbe-evaluator** | Avalia qualidade evidencia (8 dim). FROZEN ate aula completa. | Depende de evidence-db (DOC-4) |
| **reference-checker** | Cross-ref PMIDs slides/living HTML | Depende de evidence-db (DOC-4, requer rewrite) |
| **quality-gate** | Pre-commit lint/type/test | **P1 FROZEN: falta JS/CSS scripts** |
| **researcher** | Exploracao codebase read-only | OK |
| **repo-janitor** | Orfaos, links quebrados, limpeza | FIX S81 (model: haiku). Falta maxTurns |
| **notion-ops** | Notion DB read/write | OK (verificar mcp tools) |

## P0 — SECURITY (audit S81)

- [x] SEC-003: Gemini API key moved to x-goog-api-key header (S82)
- [x] SEC-002: NLM execSync → execFileSync array form (S82)
- [x] SEC-NEW: done-gate.js allowlist + execFileSync (S82)

## P1 — BUGS (audit S81)

- [x] BUG-1: Preflight contract aligned → metrics.json (S82)
- [x] BUG-5: Evidence agent output path aligned → qa-screenshots/ (S82)
- [x] DOC-4: 3 agent contracts rewritten → living HTML (S82)

## P1 — DECISOES PENDENTES

(nenhuma)

## P2 — FROZEN

- quality-gate: hardening + JS/CSS lint scripts
- notion-ops: verificar se mcpServers basta
- repo-janitor: adicionar maxTurns
- RED-1: MCP safety triplicado → consolidar
- BLOAT-1: AGENTS.md heuristics section → linkar memory

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
- Reflexao estendida obrigatoria antes de decisoes/audits.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — rodar build-html.ps1 apos editar _manifest.js.
- **Editar slide = AMBOS arquivos** — slides/{file}.html + index.html.
- **CSS per-slide: `section#s-{id}`** — specificity 0,1,1,1.
- PMIDs de LLM: ~56% erro. SEMPRE verificar.
- CLI tools: `--help` ANTES do primeiro uso na sessao.

## SECURITY (S72 + S81)

### P0 (audit S81) — RESOLVED S82
- [x] SEC-002: NLM shell injection → execFileSync
- [x] SEC-003: Gemini API key no URL → header (6 instâncias)
- [x] SEC-NEW: done-gate.js allowlist + execFileSync

### Pendentes (MODERATE, herdado)
- [ ] SEC-004: MCP servers unpinned
- [ ] SEC-005: CHATGPT_MCP_URL sem validacao

## PENDENTE (herdado)

- [ ] BUG-3: export-pdf.js DeckTape reveal adapter (lectures sao deck.js)
- [ ] BUG-4: qa-video.js .webm→.mp4 sem transcoding + ref script morto
- [ ] BUG-6: gemini-qa3.mjs grade aula crash (missing docs/prompts/)
- [ ] Obsidian CLI (backlog)
- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite
- [ ] Anki MCP setup

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 + GPT-5.4 (Codex) | 2026-04-05
