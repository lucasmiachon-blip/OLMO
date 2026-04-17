# HANDOFF - Proxima Sessao

> Sessao 222 | CONTEXT_ROT 3 — infra fix closed, semantic pendente

## S223 START HERE (P0 truth-decay semantic)

**Infra layer fechado em S222** (cwd class fix + settings tracked + orfaos limpos). **Semantic layer intacto.** Comece por INV-3:

1. **INV-3 pointer resolution** — expandir `tools/integrity.sh` para parsear `→ pointer` em `rules/` + KBPs, verificar target exists. Ataca CLAUDE.md:63+73 DEAD-REFs + KBP-06/15 apontando memory mortos. HIGH impact (CLAUDE.md lido todo turno pelos agentes).
2. **INV-4 count integrity** — grep SCHEMA.md "N rules" vs MEMORY.md "N rules" vs `ls .claude/rules/*.md | wc -l`. Trivial, 1 funcao bash.
3. **INV-1 md destino** — frontmatter obrigatorio + whitelist grandfather. Maior trabalho (migrar md existentes).

Depois: hooks resto do diagnose S221 (momentum-brake, PostToolUseFailure, /tmp/cc-session-id).

## ESTADO ATUAL (pos-S222)

**Hooks:** 31 registered, 31 valid. Integrity.sh async wired no Stop (INV-2+5 PASS, 0 violations).
**Settings:** `.claude/settings.json` TRACKED (baseline 413 li). `settings.local.json` = `{}` (reservado overrides).
**PROJECT_ROOT hardened** em 11 hooks (`${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel)}` + sanity check basename).
**Memory:** 20/20 (at cap, 9 merges pendentes). Rules: 5. Plans: 6 ativos, 42 archived.
**Build:** 17 slides PASS. Python 53 tests PASS, ruff clean.
**Docling:** `tools/docling/` com 4 scripts. Venv NAO inicializado.

## STOP HOOKS (6 entries)

Stop[0] prompt → [1] agent (git diff) → [2] quality → [3] metrics async → [4] notify async → **[5] integrity.sh async (S222)**

## PLANOS ATIVOS (6)

- `buzzing-wondering-hickey.md` (S222) — 3/3 DONE (cwd + settings + cleanup)
- `partitioned-orbiting-hellman.md` (S221) — INV-2+5 done. INV-1/3/4 para S223
- `humble-toasting-ritchie.md` — C1-C3 done, C4/C5 deferred
- `proud-drifting-sunbeam.md` — B1+B1.5 done
- `functional-rolling-waffle.md` — Docling venv pending
- `mutable-mapping-seal.md` / `generic-wondering-manatee.md` / `snoopy-jingling-aurora.md` — backlog

## PENDENTES

### Semantic truth-decay (P0 S223)
- INV-3 → INV-4 → INV-1 (ordem acima)
- Memory: 9 merges pendentes (review via /dream)

### Hooks resto (S221 diagnose)
- momentum-brake exempta Bash (policia nao policia)
- PostToolUseFailure registrado em evento inexistente
- `/tmp/cc-session-id.txt` compartilhado entre sessoes

### Carryover
- Docling: `cd tools/docling && uv sync` + testar `pdf_to_obsidian.py`
- Slides: s-quality, s-tipos-ma, drive-package PDF/PNG
- Wallace CSS: 29 raw px, #162032 sem token, 20 !important
- Obsidian plugins (Templater, Dataview, Periodic Notes, Spaced Rep, obsidian-git)
- Testar agent hook Stop bloqueio sem HANDOFF
- Codex backlog: 40 findings em `.claude/plans/S220-codex-adversarial-report.md`

## DECISOES ATIVAS

- **S220 context melt:** C1-C3 DONE. C4 DEFERRED — /dream nao invocado toda sessao (Lucas).
- **First-turn discipline (KBP-23):** Read limit, skill invocation gate, ToolSearch targeted, agent dispatch for broad scans. (S220)
- **HANDOFF.md target 50 li:** session-start head -50 + pointer "50/N li" expoe drift. (S220)
- Gemini QA temp: 1.0, topP 0.95. OKLCH obrigatorio.
- Living HTML = source of truth. Agent effort: max.
- CMMI maturity model. Hooks = freio (L2). Self-improvement loop = L3. **KPI = passo para L4.** (S217)
- Settings: effort=max, adaptive_thinking=off, subagent=sonnet, 1M=off.
- Memoria: stay native. Auto Dream agora manual (fix S216).
- Hook errors: NAO sao cosmeticos — tratar como bugs reais.
- Self-improvement: PAUSADO. **Resume gate (S218):** retomar quando ALL true: (1) >= 5 real rows em metrics.tsv (atual: 2/5), (2) rework_files nao subindo nas ultimas 3 sessoes reais, (3) zero STUCK alerts (stuck-counts >= 3), (4) /dream rodou com Phase 2.6 (metrics trend) pelo menos 1x.
- Over-engineering > erros invisiveis. Erro sem metrica = divida invisivel.
- Docling = ferramenta primaria PDF. Marker = alternativa leve. (S216)
- Hook deploy via python shutil.copy (guard blocks Edit+cp). (S216)
- **Stop hook reconhece "proponha→OK→execute" como fluxo correto, nao como skip.** (S217)
- **Leading indicators > vanity metrics.** Rework, backlog velocity, stuck items > commits, tool calls. (S217)
- **Stop[0] loop guard:** feedback duplicado = ok:true. Previne loop infinito. (S218)
- **Opus 4.7:** testar como modelo principal na proxima sessao (`claude update`). (S219)
- **Docling venv:** `tools/docling/.venv` separado. Python >=3.13 incompativel com root >=3.11. (S219)
- **Python infra:** manter orchestrator.py + agents/ + subagents/ + config/. Limpar `skills/efficiency/` (orphaned). (S219)
- **KPI interpretado:** session-start mostra moving avg + verdicts + efficiency ratio. Mid-session mostra ctx%. (S219)
- **ctx_pct_max:** metrica de pico de contexto por sessao. statusline.sh persiste, stop-metrics.sh coleta. (S219)
- **KBP-22 Silent Execution:** Stop[0] agora checa silent execution (3+ action tools sem comunicar). EC Elite exige reflexao de excelencia. (S219)

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
- **metrics.tsv colunas (12): session, date, rework_files, backlog_open, backlog_resolved, handoff_pendentes, changelog_lines, commits, tool_calls, duration_min, data_quality, ctx_pct_max.** (S219)

- **Stop[0] prompt hook: loop guard obrigatorio.** Sem dedup = loop infinito (30+ iteracoes S218). (S218)

---
Coautoria: Lucas + Opus 4.7 | S220 2026-04-16
