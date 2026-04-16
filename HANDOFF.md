# HANDOFF - Proxima Sessao

> Sessao 215 | Organizacao Batches 2-5 + auditoria estado da arte.

## ESTADO ATUAL

Monorepo funcional. Build PASS (**17 slides** metanalise).
**Rules: 5 files, 199 li.** **Hooks: 30 scripts (10/21 eventos, 7 async, 4 `if` guards) + 1 agent hook.** **Permissions: 52 (43 allow, 9 deny).**
**Memory: 20/20 (at cap, clean).** Agentes: 9 (-1 notion-ops). MCPs: 3+9. KBPs: 21. Skills: 22+3. Backlog: 33 (7 resolved).
**Strict mode: 30/30 `set -euo pipefail`.** Paths portaveis via `$CLAUDE_PROJECT_DIR`. 0 vulns. 0 hardcoded paths.
**Plans: 3 ativos, 39 archived.** Python: 53 tests PASS, ruff clean.

## PLANO MASTER: ARCHIVED (`hashed-zooming-bonbon.md`)

Fases 0-3 completas (S210-S213). Fase 4 cancelada. Fase 5 steps 1-2 done, step 3+ pausado.
Plano movido para archive S215 — sem pendencias ativas.

## STOP HOOKS (5 entries, dual-check S214)

Stop[0] prompt (semantico, cego) → Stop[1] agent (git diff grounded) → Stop[2] quality.sh → Stop[3] metrics (async) → Stop[4] notify (async)

## PLANOS ATIVOS (3)

- `mutable-mapping-seal.md` — Design Excellence Loop. Fase 2: /polish skill + rule.
- `generic-wondering-manatee.md` — CMMI roadmap. Fase 2: verification loops + PNG export.
- `snoopy-jingling-aurora.md` — I/O Pipeline Hardening. 5 gargalos Gemini QA.

## S215 — O QUE FOI FEITO

### Batches 2-5 (cleanup plan completo)
- Batch 2: rm .playwright-mcp/ (30), .obsidian/ (4), error.log + gitignore
- Batch 3: git rm hooks/stop-should-dream.sh, .archive/ (6 audits S57-S81), AGENTS.md atualizado
- Batch 4: rm .claude/workers/* (14), git rm gemini-adversarial-* (3), rm skills/.archive/
- Batch 5: rm daily-digest/ (2), docs/.archive/ (3)

### Auditoria estado da arte
- notion-ops.md removido (MCP denied = agente inoperante)
- KBP-19 pointer corrigido (guard-product-files.sh → guard-write-unified.sh + guard-bash-write.sh)
- 3 permissions stale removidas (cp de .claude/tmp/ que nao existe)
- 3 plans arquivados (hashed-zooming-bonbon, curious-honking-platypus, S213-state-of-art)

## PENDENTES

- s-quality: evidence HTML integration + narrativa
- s-tipos-ma: slide PENDENTE (Lucas decide quantos, posicao, h2)
- drive-package: PDF stale, PNG export pendente
- Wallace CSS-wide: 29 font-sizes raw, #162032 sem token, 20 !important
- TREE.md desatualizado (S93 → S215)
- Testar agent hook Stop: encerrar sessao sem HANDOFF/CHANGELOG → deve bloquear
- Auto Dream nativo: NAO disponivel (verificado S214)

### Decisoes pendentes (Lucas)
- Python infra (orchestrator.py, agents/, subagents/, skills/): manter, arquivar, ou limpar? Testes passam mas nao e usado no dia-a-dia.
- docs/ stale: PIPELINE_MBE_NOTION_OBSIDIAN.md, WORKFLOW_MBE.md (mar/29), codex-adversarial-s104.md (S104)

### Decisoes tomadas S215
- **Cursor abandonado:** .cursor/ removido (8 tracked), gitignored. Historico no git.
- **Obsidian = segundo cerebro:** vai entrar forte. .obsidian/ removido do .gitignore.
  - MCP: obsidian-mcp-tools (jacksteamdev) — ponte vault→Claude via semantic search
  - Spaced rep: obsidian-spaced-repetition (st3v3nmw) — flashcards para R3
  - Template: bramses-highly-opinionated-vault-2023 — Zettelkasten + PARA
  - Otimizacao: vault precisa ser configurado para performance (lazy loading, plugins minimos)
- **Notion = segundo plano.** notion-ops agent ja removido S215.
- **Gemini skills + Antigravity:** Lucas quer usar mais. Setup pendente.

## DECISOES ATIVAS

- Gemini QA temp: 1.0, topP 0.95. OKLCH obrigatorio.
- Living HTML = source of truth. Agent effort: max.
- CMMI maturity model. Hooks = freio (L2). Self-improvement loop = L3.
- Settings: effort=max, adaptive_thinking=off, subagent=sonnet, 1M=off.
- Memoria: stay native. Nenhuma ferramenta externa adotada. Auto Dream nativo quando disponivel.
- Hook errors: NAO sao cosmeticos — tratar como bugs reais (observacao Lucas S213).
- Self-improvement: PAUSADO. Sem evidencia de valor real. Retomar quando dados justificarem.
- Over-engineering > erros invisiveis. Infraestrutura inerte = pronta. Erro sem metrica = divida invisivel. (Lucas S214)

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro.
- npm scripts: rodar de `content/aulas/`. h2 = trabalho do Lucas.
- NUNCA colocar `ANTHROPIC_API_KEY` no env (bypassa Max, cobra API direto).
- Pesquisa de agente: SEMPRE persistir em plan file ANTES de reportar.
- Hook scripts: deploy via Write→tmp→cp (guard-write-unified bloqueia write direto em hooks/).
- "Funciona" sem metrica = achismo. Medir antes de afirmar.
- Agent hook Stop: +30-60s no close. Se disruptivo → `async: true` perde blocking.

---
Coautoria: Lucas + Opus 4.6 | S215 2026-04-16
