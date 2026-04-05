# HANDOFF - Proxima Sessao

> Sessao 77 | proximo

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Lint clean (v6). Build OK (19 slides metanalise).
QA pipeline: qa-engineer (35 checks) → gemini-qa3.mjs Gate -1/0/4.
Research pipeline: 6 pernas (Perplexity auditor S72). content-research.mjs aula-aware (fix S74).
Security: guard-secrets fail-closed, pre-commit hook, 4 EASY fixes aplicados.

## P0 — SLIDE s-objetivos (QA EM ANDAMENTO)

### Estado atual
- 6 objetivos, grid 3×2. Reescrito Lucas (S76) + expandido S77
- h2: "Objetivos educacionais" alinhado flex-start
- Source-tag: Higgins 2024 (Cochrane Handbook) · Shea 2017 (AMSTAR-2) · Murad 2014
- Acentos corrigidos (S77). CSS: obj-detail 18px, obj-num opacity 0.5
- Gate -1 PASS. C1 word count = excecao esperada para slide de objetivos
- lint-narrative-sync fix: s-hook posicao 2 aceita (hookIdx > 2)
- customAnim: null (stagger nao wired)

### Proximo passo
- [ ] Gate 0 (gemini-qa3.mjs --inspect)
- [ ] Gate 4 (gemini-qa3.mjs --editorial, 3 calls)
- [ ] Verificar PMIDs CANDIDATE via PubMed MCP (evidence HTML)
- [ ] Animacoes stagger (wiring slide-registry.js) — apos QA visual
- [ ] narrative.md: 6 objetivos nao mapeiam 1:1 com slide (Lucas decidir)

## P0 — PROXIMOS SLIDES (14 sem living HTML)

### Workflow por slide
1. Evidence HTML (research pipeline 6 pernas) → living HTML
2. Lucas decide h2 + layout
3. Build slide (HTML + CSS + anim)
4. Propagar _manifest.js + index.html + lint + build
5. QA (screenshots + Opus visual + Gemini gates)

### Pendente apos s-objetivos
- [ ] Slide novo: por que meta-analise (motivacao/relevancia) — previsto S74, nao iniciado
- 14 slides sem living HTML. Deadline 2026-04-15

## P1 — QA PIPELINE

- [ ] Prompts QA → shared/aula-agnostico (hoje duplicados cirrose + metanalise)
- [ ] Structured frame_inventory (substituir string array por {ts, state, delta})
- [ ] Evidence-bearing schema (bbox/state/timestamp) — 3 prompts rewrite

## P2 — AULAS (metanalise)

| Estado | Count | Slides |
|--------|-------|--------|
| DONE | 3 | s-title, s-hook, s-contrato |
| QA em andamento | 1 | s-objetivos |
| LINT-PASS | 14 | s-pico + todos F2 + I2 + F3 |
| QA pending | 1 | s-checkpoint-1 |

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- deck.js le DOM, nao manifest em runtime. Slides novos precisam injecao no index.html.
- Source-tag: formato Autor Ano. Recurso entre parenteses se relevante. Lucas avisa excecoes.
- Gemini: API key via scripts. MCP descartado S71. Temp 1.0 para editorial.
- content-research.mjs: aula-aware via AULA_PROFILES (fix S74). Sem contaminacao.
- Perplexity: Sonar deep-research como Perna 6. ~$0.80-1.00/call. Prompts ABERTOS.
- NLM: `--nlm` flag no content-research.mjs. 3 queries progressivas. Auth expira ~20min.
- Memory governance: cap 20 files (14 atual), next review S78.
- Agentes de pesquisa: perguntas ABERTAS, nao pre-mastigar respostas (feedback S74).

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — slide novo precisa injecao manual (ou rodar build-html.ps1).
- **Editar slide = AMBOS arquivos** — slides/{file}.html + index.html (rule em slide-rules.md §2).
- **CSS per-slide: `section#s-{id}`** — nao `#s-{id}` (specificity 0,1,1,1 para empatar com base).
- NLM CLI no Windows: sempre `PYTHONIOENCODING=utf-8`. Auth expira ~20min.
- PubMed MCP: dropa sessao frequentemente.
- Perplexity PMIDs: ~25% erro. SEMPRE verificar via PubMed MCP antes de usar.
- Gemini API PMIDs: verificacao obrigatoria. PMID 29713210 hallucinated (S74).

## SECURITY (S72)

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
