# HANDOFF - Proxima Sessao

> Sessao 78 | BUILD_SLIDES | 2026-04-05
> Cross-ref: `content/aulas/metanalise/HANDOFF.md` (estado dos slides, ordem do deck, pipeline QA por slide)

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Lint clean (v6). Build OK (19 slides metanalise).
QA pipeline: qa-engineer (35 checks) → gemini-qa3.mjs Gate -1/0/4.
Research pipeline: 6 pernas (Perplexity auditor S72). content-research.mjs aula-aware (fix S74).
Security: guard-secrets fail-closed, pre-commit hook, 4 EASY fixes aplicados.

## MUDANCAS S78

- s-contrato movido de F1 → F2 (antes de s-pico). Build+Lint PASS.
- s-objetivos QA: 35 checks PASS (2 WARN nao-blocker: vertical_rhythm, proximity_ratio)
- Codex adversarial review dos objetivos recebido (2 arquivos .claude/)
- Research gaps report gerado (evidence/research-gaps-report.md) — 3 correcoes PMID

## P0 — QA SLIDE-A-SLIDE (1 por vez, Lucas decide qual)

### s-objetivos
- 35 checks: 33 PASS, 2 WARN. Screenshot OK.
- Pendente: Gate 0 (gemini-qa3.mjs --inspect) + Gate 4 (--editorial)
- customAnim: null (stagger pendente apos QA)

### s-checkpoint-1
- Screenshots coletados (S0+S2, metrics.json)
- 35 checks: NAO concluido (agente parado)
- Fixes identificados: axis labels 10px→14px, trial names 16px→18px, tabular-nums

### Fila (14 slides LINT-PASS)
Lucas decide proximo slide. NUNCA avancar sem permissao.

## WORKFLOW DE AGENTES (S78 — regra nova)

**Max 2 agentes simultaneos (excepcionalmente 3). Lucas dita slide/tema.**

| Papel | Script | Regra |
|-------|--------|-------|
| QA | qa-batch-screenshot.mjs + qa-engineer + gemini-qa3.mjs | 1 slide, Lucas escolhe |
| Research | content-research.mjs | 1 tema, Lucas escolhe |
| Build | npm run build:metanalise | Apos edits |

- NUNCA batch QA. NUNCA avancar sem permissao.
- NUNCA criar scripts proprios. Usar os existentes.
- Sem worktrees, sem branches. Tudo no main.

## P0 — PROXIMOS SLIDES (14 sem living HTML)

### Workflow por slide
1. Evidence HTML (research pipeline) → living HTML
2. Lucas decide h2 + layout
3. Build slide (HTML + CSS + anim)
4. Propagar _manifest.js + lint + build
5. QA (screenshots + Opus visual + Gemini gates)

### Ordem atual do deck
```
F1: s-title → s-objetivos → s-hook
I1: s-checkpoint-1
F2: s-rs-vs-ma → s-contrato → s-pico → s-abstract → s-forest-plot → s-benefit-harm → s-grade → s-heterogeneity → s-fixed-random
I2: s-checkpoint-2
F3: s-ancora → s-aplicacao → s-aplicabilidade → s-absoluto → s-takehome
```

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- deck.js le DOM, nao manifest em runtime. index.html gerado pelo build.
- Source-tag: formato Autor Ano. Recurso entre parenteses se relevante.
- Gemini: API key via scripts. MCP descartado S71. Temp 1.0 para editorial.
- content-research.mjs: aula-aware via AULA_PROFILES (fix S74).
- Memory governance: cap 20 files (14 atual), next review S79.
- Agentes: max 2, Lucas dita, scripts existentes, 1 slide por vez (S78).

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — rodar build-html.ps1 apos editar _manifest.js.
- **Editar slide = AMBOS arquivos** — slides/{file}.html + index.html.
- **CSS per-slide: `section#s-{id}`** — specificity 0,1,1,1.
- PubMed MCP: dropa sessao frequentemente.
- PMIDs de LLM: ~56% erro. SEMPRE verificar.

## SECURITY (S72)

### Pendentes (MODERATE)
- [ ] SEC-002: NLM shell injection
- [ ] SEC-003: Gemini API key no URL → header
- [ ] SEC-004: MCP servers unpinned
- [ ] SEC-005: CHATGPT_MCP_URL sem validacao

## P1 — NOVOS AGENTES (proposta S78, proxima sessao)

- [ ] **codex-adversarial**: formata prompts adversariais → envia ao Codex CLI → recebe output → apresenta com reflexao critica. Segundo par de olhos automatizado.
- [ ] **session-orchestrator**: para, audita estado (git status, agentes rodando, HANDOFF, scripts orfaos), organiza antes de continuar. Garante higiene.
- [ ] Consolidar mcp-query-runner no orchestrador de pesquisa

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
