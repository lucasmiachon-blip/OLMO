# HANDOFF - Proxima Sessao

> Sessao 201 | Design_excelence_loop — Plan APPROVED, implementation pending

## ESTADO ATUAL

Monorepo funcional. Build PASS (**17 slides** metanalise).
**Agentes: 10.** **Hooks: 29 registros, 29 scripts (0 node -e JSON parse).** **Rules: 13.** **MCPs: 3 ativos + 9 frozen.** **KBPs: 19.** **Skills: 22 project + 3 user.** **Memory: 20/20.** **Backlog: 33 items (7 resolved).**

## P0 — s-tipos-ma (evidence DONE S187, slide PENDENTE)

- Evidence `evidence/s-tipos-ma.html`: 16 refs VERIFIED + 1 book, ~480 linhas.
- **Pendente:** Lucas decide quantos slides, posicao no manifest, h2.

## P0 — drive-package v2.1 (S199-S200)

- **Local:** `content/aulas/drive-package/` (gitignored, 71 MB)
- **3 servidores:** Caddy :18080 → Python :18081 → Miniserve :18082 → PDF
- **S200 hardening (3 rondas):** health check gates, PID tracking, UX consistency
- **Padrao uniforme:** orphan cleanup → port check → start → health check → PID save → browser gated → pause → cleanup
- **Pendente:** metanalise.pdf stale (16 slides, S166). Regenerar com Playwright/Decktape.
- **Pendente:** Gemini adversarial review (em andamento S200)
- **Para deploy:** regenerar PDF, zipar, subir Drive

## P0 — Design Excellence Loop (S201 — plan approved)

- **Plano:** `.claude/plans/mutable-mapping-seal.md` (3 fases, evidência completa)
- **Diagnóstico:** `.claude/plans/S199-gemini-qa-diagnostic.md` (5 causas-raiz do Gemini QA 30%)
- **Research:** `.claude/plans/S199-research-findings.md` (SOTA CSS, slideology, multi-model, benchmarks)
- **Fase 1 (próxima):** Consertar Gemini QA evaluator (6 fixes: computed CSS, Call B reliability, few-shot, delta tracking, Call D split, selector validation)
- **Fase 2:** Design Excellence Loop (rule design-excellence.md + skill /polish + Chrome DevTools MCP + Ralph)
- **Fase 3 (futuro):** Multi-model (Codex fixer, GPT tiebreaker) — só quando Fases 1-2 Proven
- **Evidência-chave:** Prompt design = ~27% qualidade vs model choice = ~4% (arXiv:2506.13639)

## P1 — Loop melhoria continua (rondas restantes)

### Ronda 2: Sentinel agent improvement (backlog #31)
Adicionar: grep/verify antes de claims, report template obrigatorio, scope limit.

### Ronda 3: Agent optimization audit (backlog #29 — read-only)
Tools/model/maxTurns review dos 10 agentes. Report-only.

## P1 — Security: node -e fs.writeFileSync bypasses guard-bash-write

- `node -e "require('fs').writeFileSync(...)"` contorna o hook sem ask
- **Fix:** expandir Pattern 7 para cobrir `fs.writeFileSync`, `fs.copyFileSync`, `fs.rmSync`
- Relacionado: backlog #20 (python script file bypass)

## P1 — Prompt hardening propagacao (backlog #30)

## P1 — Gemini parametros adicionais (pesquisa pendente)

- thinking_level (high/low/minimal), frequency_penalty, presence_penalty, seed
- Sem evidencia suficiente — lancar busca dedicada antes de implementar
- Fontes base: `.claude/plans/archive/S193-groovy-fluttering-bunny.md`

## DECISOES ATIVAS

- **Gemini QA temp: APLICADO S198.** Todos gates 1.0 (Google Gemini 3 default). topP 0.95.
- Format C+ pointer-only. OKLCH obrigatorio.
- Living HTML = source of truth. Benchmark CSS = `pre-reading-heterogeneidade.html` (READ-ONLY).
- Agent effort: max (degrada para high em Sonnet/Haiku).
- Hook scripts: Edit BLOCK + deploy via Write→cp (guard-bash-write asks). Settings: Edit ASK.
- **Elite-conduct loop:** `.claude/rules/elite-conduct.md` (promoted S195).
- **Proven-wins rule:** `.claude/rules/proven-wins.md` — maturity tiers (unaudited→proven).

## CUIDADOS

- NUNCA `taskkill //IM node.exe`. CSS: `section#s-{id}`. PMIDs: ~56% erro (LLM).
- npm scripts: rodar de `content/aulas/`, NAO da raiz.
- **h2 = trabalho do Lucas.** NUNCA remover/reescrever sem instrucao EXPLICITA.
- **Sentinel claims: verificar antes de agir.** S196: 1 FP (apl-cache-refresh), 1 truncado.
- **node -e fs bypass:** workaround funcional mas brecha de seguranca. Fix P1.
- **Params sem evidencia: pesquisar antes, nunca inventar.**

## BACKLOG

→ `.claude/BACKLOG.md` (33 items, 7 resolved — #32 resolved S198)

## CLEANUP PENDENTE

- `.claude/workers/`: S178 + S181. Lucas decide.
- `02-contrato.html` menciona slides demolidos.
- `.claude/plans/mutable-mapping-seal-agent-*.md` — untracked, Lucas decide.

---
Coautoria: Lucas + Opus 4.6 | S201 2026-04-15
