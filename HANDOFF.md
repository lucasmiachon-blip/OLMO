# HANDOFF - Proxima Sessao

> Sessao 217 | Continuar + KPI

## ESTADO ATUAL

Monorepo funcional. Build PASS (**17 slides** metanalise).
**Rules: 5 files, 199 li.** **Hooks: 30 scripts (10/21 eventos, 7 async, 4 `if` guards) + 1 agent hook.** **Permissions: 49 (40 allow, 9 deny).**
**Memory: 20/20 (at cap, clean).** Agentes: 9. MCPs: 3+9. KBPs: 21. Skills: 22+3. Backlog: 33 (7 resolved).
**Strict mode: 30/30 `set -euo pipefail`.** Paths portaveis via `$CLAUDE_PROJECT_DIR`. 0 vulns. 0 hardcoded paths.
**Plans: 4 ativos, 39 archived.** Python: 53 tests PASS, ruff clean.
**Docling pipeline:** `tools/docling/` com 4 scripts + pyproject. Venv NAO inicializado.
**KPI system:** metrics.tsv (26 sessoes seed) + KPI loop a cada 200 calls + stuck-item detection. DORA-inspired.

## STOP HOOKS (5 entries, dual-check S214)

Stop[0] prompt (semantico — S217: reconhece "proponha→OK→execute" como fluxo correto) → Stop[1] agent (git diff grounded) → Stop[2] quality.sh → Stop[3] metrics (async, S217: persiste metrics.tsv + HANDOFF snapshot) → Stop[4] notify (async)

## PLANOS ATIVOS (4)

- `functional-rolling-waffle.md` — S216 Clean_up + Obsidian + PDF Pipeline. Steps 1-5 done, venv pendente.
- `mutable-mapping-seal.md` — Design Excellence Loop. Fase 2: /polish skill + rule.
- `generic-wondering-manatee.md` — CMMI roadmap. Fase 2: verification loops + PNG export.
- `snoopy-jingling-aurora.md` — I/O Pipeline Hardening. 5 gargalos Gemini QA.

## S217 — O QUE FOI FEITO

### KPI System (DORA-inspired, pesquisa fundamentada)
- Pesquisa: DORA 5 metrics, SPACE framework, CMMI L4, S213 plan archive consultado
- **Leading indicators vs vanity metrics**: rework_files, backlog_velocity, handoff_pendentes sao leading; commits, tool_calls sao vanity (contexto only)
- `.claude/apl/metrics.tsv` — 10 colunas, 26 sessoes seed (S190-S216), append automatico no session-end
- `hooks/stop-metrics.sh` — persiste metricas + snapshot HANDOFF para stuck detection
- `hooks/apl-cache-refresh.sh` — trend display + stuck-item detection (>= 3 sessoes = STUCK alert)
- `.claude/hooks/post-global-handler.sh` — KPI loop a cada 200 calls: compara rework/backlog/pendentes contra baseline das ultimas 5 sessoes, alerta se >20% acima

### Stop hook prompt fix
- Stop[0] prompt atualizado: reconhece "proponha, espere OK, execute" como fluxo correto do OLMO
- Bug anterior: stop hook cobrava "nao implementou" quando usuario pedia para discutir antes, criando loop infinito

### Opus 4.7
- Disponivel para Claude Code desde 2026-04-16. Model ID: `claude-opus-4-7`. Requer v2.1.111+.

## PENDENTES

### Docling (carryover S216)
- `cd tools/docling && uv sync` — inicializar venv (~2GB com PyTorch)
- Testar `pdf_to_obsidian.py` com PDF real (colchicina cochrane ou tier2)
- Verificar frontmatter compativel com template literature-note do vault
- Multi-agente: implementar orquestracao (2-3 agentes independentes como Lucas sugeriu)
- Decisao Lucas: venv separado (`tools/docling/.venv`) vs unificado com raiz OLMO

### KPI system — next steps
- Validar stuck-item detection apos 2-3 sessoes com dados reais
- /dream consumir metrics.tsv (Step 2 do S213 plan)
- Considerar Opus 4.7 como modelo principal (`claude update`)

### Slides e QA (carryover)
- s-quality: evidence HTML integration + narrativa
- s-tipos-ma: slide PENDENTE (Lucas decide quantos, posicao, h2)
- drive-package: PDF stale, PNG export pendente
- Wallace CSS-wide: 29 font-sizes raw, #162032 sem token, 20 !important

### Infra (carryover)
- Testar agent hook Stop: encerrar sessao sem HANDOFF/CHANGELOG → deve bloquear
- Python infra (orchestrator.py, agents/, subagents/, skills/): decisao Lucas — manter, arquivar, limpar?
- Obsidian plugins pendentes: Templater, Dataview, Periodic Notes, Spaced Repetition, obsidian-git
- obsidian-mcp-tools: ponte vault→Claude (semantic search)
- Gemini skills + Antigravity: setup pendente

## DECISOES ATIVAS

- Gemini QA temp: 1.0, topP 0.95. OKLCH obrigatorio.
- Living HTML = source of truth. Agent effort: max.
- CMMI maturity model. Hooks = freio (L2). Self-improvement loop = L3. **KPI = passo para L4.** (S217)
- Settings: effort=max, adaptive_thinking=off, subagent=sonnet, 1M=off.
- Memoria: stay native. Auto Dream agora manual (fix S216).
- Hook errors: NAO sao cosmeticos — tratar como bugs reais.
- Self-improvement: PAUSADO. Retomar quando dados justificarem. **KPI system deployado S217 — Lucas decide se retoma.**
- Over-engineering > erros invisiveis. Erro sem metrica = divida invisivel.
- Docling = ferramenta primaria PDF. Marker = alternativa leve. (S216)
- Hook deploy via python shutil.copy (guard blocks Edit+cp). (S216)
- **Stop hook reconhece "proponha→OK→execute" como fluxo correto, nao como skip.** (S217)
- **Leading indicators > vanity metrics.** Rework, backlog velocity, stuck items > commits, tool calls. (S217)

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro.
- npm scripts: rodar de `content/aulas/`. h2 = trabalho do Lucas.
- NUNCA colocar `ANTHROPIC_API_KEY` no env (bypassa Max, cobra API direto).
- Pesquisa de agente: SEMPRE persistir em plan file ANTES de reportar.
- Hook scripts: deploy via Write→tmp→python shutil.copy (guard blocks Edit+cp, python ask=ok).
- "Funciona" sem metrica = achismo. Medir antes de afirmar.
- Agent hook Stop: +30-60s no close. Se disruptivo → `async: true` perde blocking.
- Docling venv pesado (~2GB). Manter separado em tools/docling/.venv.
- **KPI loop: intervalo default 200 calls (CC_KPI_INTERVAL env var).** (S217)
- **metrics.tsv colunas: session, date, rework_files, backlog_open, backlog_resolved, handoff_pendentes, changelog_lines, commits, tool_calls, duration_min.** (S217)

---
Coautoria: Lucas + Opus 4.6 | S217 2026-04-16
