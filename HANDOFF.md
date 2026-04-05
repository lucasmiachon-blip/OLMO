# HANDOFF - Proxima Sessao

> Sessao 74 | proximo

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Lint clean (v6). Build OK (18 slides metanalise).
QA pipeline: qa-engineer (35 checks) → gemini-qa3.mjs Gate -1/0/4.
Research pipeline: 6 pernas (Perplexity auditor adicionado S72, verificado).
Security: guard-secrets fail-closed, pre-commit hook adicionado, 4 EASY fixes aplicados.
s-pico: redesign concluido (S73) — mismatch grid + indirectness punchline.

## P0 — PROXIMOS SLIDES (15 sem living HTML)

### Workflow por slide
1. Evidence HTML (research pipeline 6 pernas) → living HTML
2. Lucas decide h2 + layout
3. Build slide (HTML + CSS + anim)
4. Propagar _manifest.js + lint + build
5. QA (screenshots + Opus visual + Gemini gates)

### Próxima sessão (S74)
- [ ] Slide novo: objetivos educacionais da aula
- [ ] Slide novo: por que meta-análise (motivação/relevância)
- Ambos precisam: living HTML → h2 + layout → build → lint → QA

## P1 — QA PIPELINE

### Proximo passo
- [ ] Prompts QA → shared/aula-agnostico (hoje duplicados cirrose + metanalise)
- [ ] Structured frame_inventory (substituir string array por {ts, state, delta})
- [ ] Evidence-bearing schema (bbox/state/timestamp) — 3 prompts rewrite

## P2 — AULAS (metanalise)

| Estado | Count | Slides |
|--------|-------|--------|
| DONE | 1 | s-rs-vs-ma |
| LINT-PASS | 15 | s-pico + todos F2 restantes + I2 + F3 |
| QA pending | 1 | s-checkpoint-1 |
| Title/hook/contrato | 3 | production-ready (sem living HTML) |

- 15 slides sem living HTML. Deadline 2026-04-15 (~9 dias)

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- Gemini: API key via scripts. MCP descartado S71. Temp 1.0 para editorial.
- Perplexity: Sonar deep-research como Perna 6. ~$0.80-1.00/call. Prompts ABERTOS.
- NLM: `--nlm` flag no content-research.mjs. 3 queries progressivas. Auth expira ~20min.
- Memory governance: cap 20 files (15 atual), next review S76.

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- NLM CLI no Windows: sempre `PYTHONIOENCODING=utf-8`. Auth expira ~20min.
- PubMed MCP: dropa sessao frequentemente.
- Perplexity PMIDs: ~25% erro. SEMPRE verificar via PubMed MCP antes de usar.

## SECURITY (S72)

### Fixes aplicados
- guard-secrets.sh: fail-closed (exit 2)
- guard-secrets-precommit.sh: versao standalone para git pre-commit
- .pre-commit-config.yaml: hook local adicionado
- .gitignore: expandido (*.p12, *.pfx, credentials.json, etc.)
- content-research.mjs: path traversal guard no --fields (SEC-006)
- package.json: ExecutionPolicy Bypass → RemoteSigned (SEC-007)

### Pendentes (MODERATE)
- [ ] SEC-002: NLM shell injection (execSync com slide content interpolado)
- [ ] SEC-003: Gemini API key no URL → mover para header x-goog-api-key
- [ ] SEC-004: MCP servers unpinned (npx -y sem versao)
- [ ] SEC-005: CHATGPT_MCP_URL sem validacao de hostname

## P3 — SELF-IMPROVEMENT

- [ ] Buscar/criar skill de self-healing
- [ ] Quality gates progressivos

## PENDENTE (herdado)

- [ ] gemini-qa3.mjs: grade aula crash (missing docs/prompts/) — baixa prioridade
- [ ] Obsidian CLI (backlog, plano em docs/.archive/)
- [ ] Google Drive MCP: OAuth credentials
- [ ] Presenter.js rewrite (HTML separado, timer fix)
- [ ] Anki MCP setup (AnkiConnect add-on 2055492159)

## CONFLITOS

(nenhum ativo)

---
Coautoria: Lucas + Opus 4.6 | 2026-04-05
