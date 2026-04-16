# HANDOFF - Proxima Sessao

> Sessao 218 | KPI + Self-Improvement

## ESTADO ATUAL

Monorepo funcional. Build PASS (**17 slides** metanalise).
**Rules: 5 files, 199 li.** **Hooks: 30 scripts (10/21 eventos, 7 async, 4 `if` guards) + 1 agent hook.** **Permissions: 49 (40 allow, 9 deny).**
**Memory: 20/20 (at cap, clean).** Agentes: 9. MCPs: 3+9. KBPs: 21. Skills: 22+3. Backlog: 33 (7 resolved).
**Strict mode: 30/30 `set -euo pipefail`.** Paths portaveis via `$CLAUDE_PROJECT_DIR`. 0 vulns. 0 hardcoded paths.
**Plans: 4 ativos, 42 archived.** Python: 53 tests PASS, ruff clean.
**Docling pipeline:** `tools/docling/` com 4 scripts + pyproject. Venv NAO inicializado.
**KPI system:** metrics.tsv (27 rows, real data starts S217) + KPI loop a cada 200 calls + stuck-detection fix S218 (PENDENTES-only parsing, 3-col schema, reset). DORA-inspired. /dream Phase 2.6 conecta metrics.tsv → memoria.

## STOP HOOKS (5 entries, dual-check S214)

Stop[0] prompt (semantico — S218: loop guard adicionado contra feedback infinito) → Stop[1] agent (git diff grounded) → Stop[2] quality.sh → Stop[3] metrics (async, S217: persiste metrics.tsv + HANDOFF snapshot) → Stop[4] notify (async)

## PLANOS ATIVOS (4)

- `functional-rolling-waffle.md` — S216 Clean_up + Obsidian + PDF Pipeline. Steps 1-5 done, venv pendente.
- `mutable-mapping-seal.md` — Design Excellence Loop. Fase 2: /polish skill + rule. Depende de snoopy.
- `generic-wondering-manatee.md` — CMMI roadmap. Fase 2: verification loops + PNG export.
- `snoopy-jingling-aurora.md` — I/O Pipeline Hardening. 5 gargalos Gemini QA. Pre-req de mutable-mapping.

## PENDENTES

### Docling (carryover S216)
- `cd tools/docling && uv sync` — inicializar venv (~2GB com PyTorch)
- Testar `pdf_to_obsidian.py` com PDF real (colchicina cochrane ou tier2)
- Verificar frontmatter compativel com template literature-note do vault
- Multi-agente: implementar orquestracao (2-3 agentes independentes como Lucas sugeriu)
- Decisao Lucas: venv separado (`tools/docling/.venv`) vs unificado com raiz OLMO

### KPI system — next steps
- Considerar Opus 4.7 como modelo principal (`claude update`)
- Monitorar stuck-detection com dados reais (reset S218, validar S219+)
- Rodar /dream para testar Phase 2.6 (metrics.tsv → memoria)

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
- Self-improvement: PAUSADO. **Resume gate (S218):** retomar quando ALL true: (1) >= 5 real rows em metrics.tsv (atual: 1/5), (2) rework_files nao subindo nas ultimas 3 sessoes reais, (3) zero STUCK alerts (stuck-counts >= 3), (4) /dream rodou com Phase 2.6 (metrics trend) pelo menos 1x.
- Over-engineering > erros invisiveis. Erro sem metrica = divida invisivel.
- Docling = ferramenta primaria PDF. Marker = alternativa leve. (S216)
- Hook deploy via python shutil.copy (guard blocks Edit+cp). (S216)
- **Stop hook reconhece "proponha→OK→execute" como fluxo correto, nao como skip.** (S217)
- **Leading indicators > vanity metrics.** Rework, backlog velocity, stuck items > commits, tool calls. (S217)
- **Stop[0] loop guard:** feedback duplicado = ok:true. Previne loop infinito. (S218)

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

- **Stop[0] prompt hook: loop guard obrigatorio.** Sem dedup = loop infinito (30+ iteracoes S218). (S218)

---
Coautoria: Lucas + Opus 4.6 | S218 2026-04-16
