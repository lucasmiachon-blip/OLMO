# HANDOFF - Proxima Sessao

> Sessao 76 | proximo

## ESTADO ATUAL

Monorepo funcional. CI verde (53 testes). Lint clean (v6). Build OK (19 slides metanalise).
QA pipeline: qa-engineer (35 checks) → gemini-qa3.mjs Gate -1/0/4.
Research pipeline: 6 pernas (Perplexity auditor S72). content-research.mjs aula-aware (fix S74).
Security: guard-secrets fail-closed, pre-commit hook, 4 EASY fixes aplicados.

## P0 — SLIDE s-objetivos (QA PENDENTE)

### Estado atual
- Slide HTML built: `slides/00b-objetivos.html` (5 competencias Cochrane + AMSTAR-2, layout vertical numerado)
- h2: "Objetivos educacionais" (decisao Lucas S75)
- CSS pronto: `.objetivos-list` no metanalise.css
- Living HTML completo: `evidence/s-objetivos.html` (3 eixos, 7 VERIFIED, 6 CANDIDATE)
- Manifest atualizado, index.html injetado, lint clean, build OK
- Animacao: nao implementada (stagger pendente — precisa wiring em slide-registry.js)

### Proximo passo (S76)
- [ ] QA visual (screenshot + Opus multimodal)
- [ ] Decidir: quer stagger animation nos 5 itens? (wiring slide-registry.js)
- [ ] Verificar 6 PMIDs CANDIDATE via PubMed MCP
- [ ] lint-narrative-sync: s-hook posicao 2 (pre-existente desde S74, threshold do lint precisa ajuste)

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
| BUILT (QA pending) | 1 | s-objetivos |
| LINT-PASS | 14 | s-pico + todos F2 + I2 + F3 |
| QA pending | 1 | s-checkpoint-1 |

## DECISOES ATIVAS

- Living HTML per slide = source of truth. Evidence-first workflow.
- deck.js le DOM, nao manifest em runtime. Slides novos precisam injecao no index.html.
- Gemini: API key via scripts. MCP descartado S71. Temp 1.0 para editorial.
- content-research.mjs: aula-aware via AULA_PROFILES (fix S74). Sem contaminacao.
- Perplexity: Sonar deep-research como Perna 6. ~$0.80-1.00/call. Prompts ABERTOS.
- NLM: `--nlm` flag no content-research.mjs. 3 queries progressivas. Auth expira ~20min.
- Memory governance: cap 20 files (14 atual), next review S76.
- Agentes de pesquisa: perguntas ABERTAS, nao pre-mastigar respostas (feedback S74).

## CUIDADOS

- **NUNCA `taskkill //IM node.exe`** — matar por PID especifico.
- **index.html e gerado** — slide novo precisa injecao manual (ou rodar build-html.ps1).
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
