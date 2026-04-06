# Adversarial Audit S81 — CONFRONTACAO

> 4 auditorias: 2 Explore (Opus) + 2 Codex (GPT-5.4)
> Data: 2026-04-05 | Sessao: S81

## Status dos fixes

- [x] DOC-8: `project_tooling_pipeline.md` "11→7" → "11→8"
- [x] DOC-5: `AGENTS.md:96` versao GEMINI.md "v3.2" → "v3.6"
- [x] DOC-6: `ARCHITECTURE.md:223` link OBSIDIAN_CLI_PLAN.md → path atualizado (.archive/)
- [x] FIX-0: `repo-janitor.md` model: fast → model: haiku (janitor pre-audit)
- [ ] SEC-003: API key Gemini no URL query string
- [ ] SEC-002: Shell injection NLM execSync
- [ ] SEC-NEW: Shell injection done-gate.js
- [ ] BUG-1: Preflight contract quebrado (qa-browser-report.json vs metrics.json)
- [ ] BUG-2: .env.example GOOGLE_AI_KEY vs GEMINI_API_KEY
- [ ] BUG-3: export-pdf.js DeckTape reveal adapter (lectures sao deck.js)
- [ ] BUG-4: qa-video.js .webm→.mp4 sem transcoding + ref script inexistente
- [ ] BUG-5: Evidence agent output path stale
- [ ] BUG-6: Grade docs/prompts/ missing (crash conhecido)
- [ ] DOC-1: Arquitetura Python 4-agentes em CLAUDE.md/README (scaffold nunca implementado)
- [ ] DOC-2: MCP counts contraditorios em 6 files
- [ ] DOC-3: README lista Gemini como MCP (descartado S71)
- [ ] DOC-4: Evidence source-of-truth inconsistente (5 docs divergem)
- [ ] DOC-7: Gate naming scripts vs agents (Gate -1/0/4 vs Preflight/Inspect/Editorial)
- [ ] RED-1: MCP safety triplicado (rule + docs/ + SYNC-NOTION-REPO)
- [ ] RED-2: PMID ~56% repetido em 4 lugares
- [ ] RED-3: feedback_qa_use_cli_not_mcp.md 75 linhas (sobrepoe qa-pipeline.md)
- [ ] BLOAT-1: AGENTS.md secao Behavioral Heuristics duplica memory
- [ ] BLOAT-2: GETTING_STARTED.md + WORKFLOW_MBE.md + PIPELINE_MBE overlap
- [ ] DEAD-1: getArg()/hasFlag() duplicados em content-research.mjs + gemini-qa3.mjs
- [ ] DEAD-2: lint-narrative-sync.js lastMainSlide nao usado
- [ ] DEAD-3: lint-case-sync.js magic -10 offset

---

## SEGURANCA (P0)

### SEC-003: Gemini API key no URL query string
- **Fonte:** Codex (0.99) + HANDOFF conhecido
- **Arquivos:** `content-research.mjs:790`, `gemini-qa3.mjs:742,860,1072,1320`
- **Codigo:**
  ```js
  const url = `${BASE}/v1beta/models/${MODEL}:generateContent?key=${API_KEY}`;
  ```
- **Risco:** Key vaza em logs, proxies, browser history
- **Fix:** Mover para header `x-goog-api-key`
- **Minha avaliacao:** REAL. Verificar linhas exatas antes de aplicar.

### SEC-002: Shell injection NLM execSync
- **Fonte:** Codex (0.98) + HANDOFF conhecido
- **Arquivo:** `content-research.mjs:933-940`
- **Codigo:**
  ```js
  let cmd = `nlm notebook query ${notebookId} "${escaped}" --json`;
  const output = execSync(cmd, { ... });
  ```
- **Risco:** Query text com metacaracteres shell ($, `, ;, |) executa comandos
- **Fix:** Substituir por `execFileSync('nlm', ['notebook','query', notebookId, query, '--json'])`
- **Minha avaliacao:** REAL. Escaping de `"` nao e suficiente.

### SEC-NEW: Shell injection done-gate.js
- **Fonte:** Codex (0.97) — achado NOVO
- **Arquivo:** `done-gate.js:28,67,70,81`
- **Codigo:**
  ```js
  const explicit = args.find(a => a !== '--strict');
  // aula interpolada em:
  { name: 'build', cmd: `npm run build:${aula}` }
  execSync(cmd, { cwd: root, stdio: 'pipe', encoding: 'utf-8' });
  ```
- **Risco:** Arg posicional sem allowlist → command injection
- **Fix:** Allowlist `['cirrose','grade','metanalise']` + `execFileSync`
- **Minha avaliacao:** VERIFICAR. Risco real mas impacto local (script manual, nao web-facing).

---

## BUGS (P1)

### BUG-1: Preflight contract quebrado
- **Fonte:** Codex (0.99) — achado NOVO e importante
- **Arquivos:** `qa-engineer.md:43,81` + `qa-batch-screenshot.mjs:400,476` + `gemini-qa3.mjs:148,152`
- **Problema:** Agent e gemini-qa3 esperam `qa-browser-report.json` com objeto `checks`. Mas qa-batch-screenshot produz `metrics.json` + `batch-manifest.json`.
- **Impacto:** Fluxo documentado nao funciona como escrito. Pipeline QA tem gap.
- **Fix:** Padronizar artefato — ou producer emite qa-browser-report.json ou consumers leem metrics.json.
- **Minha avaliacao:** VERIFICAR codigo real. Se pipeline funciona na pratica, o "contract" pode ser soft (agent le o que existir). Se nao, e bug real.

### BUG-2: .env.example GOOGLE_AI_KEY vs GEMINI_API_KEY
- **Fonte:** Codex (0.99) — achado NOVO
- **Arquivos:** `.env.example:30` vs `content-research.mjs:13` + `gemini-qa3.mjs:13`
- **Problema:** .env.example documenta `GOOGLE_AI_KEY`, scripts esperam `GEMINI_API_KEY`. Fresh setup falha.
- **Fix:** Renomear em .env.example para `GEMINI_API_KEY`
- **Minha avaliacao:** ALTA CONFIANCA. Fix trivial.

### BUG-3: export-pdf.js DeckTape reveal adapter
- **Fonte:** Codex (0.96)
- **Arquivo:** `export-pdf.js:7,79`
- **Problema:** Usa DeckTape com adapter `reveal` mas lectures atuais sao deck.js
- **Fix:** Ou trocar adapter ou marcar script como legacy/reveal-only
- **Minha avaliacao:** VERIFICAR. Script pode ser legacy intencional (grade era Reveal).

### BUG-4: qa-video.js stale
- **Fonte:** Codex (0.99)
- **Arquivo:** `scripts/qa/qa-video.js:10,167,199,203,243`
- **Problema:** Renomeia .webm → .mp4 sem transcoding + referencia `scripts/gemini.mjs` (nao existe)
- **Fix:** Manter .webm ou transcodar com ffmpeg + atualizar ref para gemini-qa3.mjs
- **Minha avaliacao:** REAL. Script provavelmente orphan/nunca funcionou corretamente.

### BUG-5: Evidence agent output path stale
- **Fonte:** Codex (0.98)
- **Arquivos:** `evidence-researcher.md:126,222` vs `content-research.mjs:1179`
- **Problema:** Agent diz output vai para `evidence/research-{slideId}.md`. Script escreve `qa-screenshots/{slideId}/content-research.md`.
- **Fix:** Alinhar agent doc com realidade do script
- **Minha avaliacao:** VERIFICAR linhas exatas. Agent doc e instrucional, nao executavel — pode ser intencional (desejado vs implementado).

### BUG-6: Grade docs/prompts/ missing
- **Fonte:** Ambas auditorias (0.99) + HANDOFF conhecido
- **Arquivo:** `gemini-qa3.mjs:350-354` — `throw new Error('prompt not found')`
- **Impacto:** QA no grade aula crasha
- **Fix:** Criar prompts ou desabilitar grade no QA
- **Minha avaliacao:** DEFER — grade nao e foco atual. Documentar, nao fixar agora.

---

## DOC DRIFT (P1)

### DOC-1: Arquitetura Python 4-agentes em CLAUDE.md/README
- **Fonte:** Codex (0.99)
- **Arquivos:** `CLAUDE.md:14-24`, `README.md:14-21`, `docs/TREE.md:177`
- **Problema:** Tree mostra Cientifico/Automacao/Organizacao/AtualizacaoAI — scaffold Python nunca implementado. `agents/` so tem `__init__.py`. Agentes reais sao 8 `.claude/agents/*.md`.
- **Minha avaliacao:** REAL mas PRECISA DECISAO do Lucas. A tree serve como:
  - (a) visao arquitetural futura do Python ecosystem, ou
  - (b) descricao errada do estado atual?
  Se (a), marcar como "planned". Se (b), substituir pela topologia real.
- **Risco de agir sem perguntar:** ALTO. CLAUDE.md e carregado toda sessao — mudar a arquitetura afeta todo agente.

### DOC-2: MCP counts contraditorios
- **Fonte:** Codex (0.99)
- **Arquivos (6):** `PENDENCIAS.md:6`, `GETTING_STARTED.md:35,119`, `ARCHITECTURE.md:100`, `keys_setup.md:3`, `README.md:36`
- **Contagens encontradas:** "13 connected", "12 connected + 1 removed", "16 configured", "13 MCP servers"
- **Contagem real (verificada):** 12 connected (PENDENCIAS lista 13, menos Gemini descartado S71) + 3 planned = 15 total
- **Minha avaliacao:** REAL. Source of truth deve ser PENDENCIAS.md. Todos outros devem apontar para la ou nao ter numero hardcoded.
- **Risco:** Medio — consome tempo (6 files), cada um precisa contexto.

### DOC-3: README lista Gemini como MCP
- **Fonte:** Codex (0.98)
- **Arquivo:** `README.md:36` — "13 MCP servers (Notion, PubMed, Gmail, Gemini, Perplexity...)"
- **Verificacao:** Deferred tools do sistema NAO tem mcp__*gemini*. Memory diz "descartado S71". GEMINI.md diz usar API/CLI.
- **PENDENCIAS.md stale:** ainda marca Gemini como "[x] connected" — tambem precisa fix.
- **Minha avaliacao:** REAL. Fix = tirar Gemini da lista, atualizar count. Faz parte do DOC-2 sweep.

### DOC-4: Evidence source-of-truth inconsistente
- **Fonte:** Codex (0.97)
- **Arquivos (5):** `AGENTS.md:67`, `CLAUDE.md:61`, `SYNC-NOTION-REPO.md:14`, `project_living_html.md:38`, `design-reference.md:65`
- **Problema:** Alguns docs centram `evidence-db.md`, outros dizem living HTML e canonical.
- **Decisao existente:** CLAUDE.md diz "Living HTML per slide = source of truth"
- **Minha avaliacao:** A decisao ja existe. O problema e que docs antigos nao foram atualizados. Fix = alinhar todos com a decisao existente.
- **Confianca:** ALTA para alinhar docs. NAO precisa decisao nova — decisao ja foi tomada.

### DOC-7: Gate naming divergente
- **Fonte:** Explore (0.99) + Codex
- **Problema:** Scripts usam "Gate -1/0/4", agents usam "Preflight/Inspect/Editorial"
- **Arquivos:** `gemini-qa3.mjs:3-6,44-45` (comments internos)
- **Minha avaliacao:** Fix e cosmético (comments, nao logica). Baixo risco mas melhora clareza. DEFER — nao quebra nada.

---

## REDUNDANCIA (P2)

### RED-1: MCP safety triplicado
- **Fonte:** Explore + Codex
- **Arquivos:** `rules/mcp_safety.md` (1.7KB, com paths: frontmatter) + `docs/mcp_safety_reference.md` (1.5KB) + `SYNC-NOTION-REPO.md:64-70`
- **Minha avaliacao:** Rule e canonical (tem paths:, carrega condicionalmente). docs/ e redundante. SYNC pode linkar.
- **Fix:** Merge essencial de docs/mcp_safety_reference.md → rules/mcp_safety.md como appendix. SYNC-NOTION-REPO:64 → "See .claude/rules/mcp_safety.md".

### RED-2: PMID ~56% em 4 lugares
- **Fonte:** Codex + Explore
- **Arquivos:** `AGENTS.md:67`, `design-reference.md:64`, `feedback_research.md:24`, `MEMORY.md:24`
- **Minha avaliacao:** design-reference.md (rule, paths: scoped) deve ser o owner. Outros devem linkar ou ser 1-liner.

### RED-3: feedback_qa_use_cli_not_mcp.md 75 linhas
- **Fonte:** Codex + Explore
- **Problema:** Memory file longa, sobrepoe qa-pipeline.md (rule). Viola conciseness principle.
- **Minha avaliacao:** Trim para ~25-30 linhas. Mover canon para rule, manter so feedback/correcoes em memory.

---

## BLOAT (P2-P3)

### BLOAT-1: AGENTS.md Behavioral Heuristics
- **Fonte:** Codex + Explore
- **Secao:** AGENTS.md:53-68 (~30 linhas) duplica feedback_anti-sycophancy.md
- **Fix:** Linkar ao inves de repetir.

### BLOAT-2: GETTING_STARTED + WORKFLOW_MBE + PIPELINE_MBE overlap
- **Fonte:** Codex
- **Minha avaliacao:** DEFER. Sao docs de referencia, nao auto-loaded. Baixo impacto em tokens.

---

## DEAD CODE (P3)

### DEAD-1: getArg()/hasFlag() duplicados
- **Fonte:** Explore
- **Arquivos:** `content-research.mjs:43` + `gemini-qa3.mjs:103`
- **Fix:** Extrair para shared/lib/cli.mjs
- **Minha avaliacao:** DEFER. DRY violation mas funciona. Nao vale o risco agora.

### DEAD-2: lint-narrative-sync.js lastMainSlide
- **Fonte:** Codex (0.87)
- **Minha avaliacao:** BAIXA CONFIANCA. Verificar antes de agir.

### DEAD-3: lint-case-sync.js magic -10 offset
- **Fonte:** Codex (0.87)
- **Minha avaliacao:** BAIXA CONFIANCA. Pode ser intencional. DEFER.

---

## REJEITADOS (falso positivo ou intencional)

### REJ-1: anti-drift.md Budget/Quality overlap com CLAUDE.md
- **Fonte:** Codex
- **Motivo da rejeicao:** INTENCIONAL. anti-drift e guardrail comportamental AI (sempre loaded). CLAUDE.md e project instruction. Sobreposicao e padrao de primacy/recency anchoring — existe por design. Merge destruiria o proposito.

---

## PRIORIDADE DE EXECUCAO SUGERIDA

### Batch 1 — Alta confianca, baixo risco (doc fixes)
1. ~~DOC-8: tooling count 7→8~~ DONE
2. ~~DOC-5: AGENTS.md version ref~~ DONE
3. ~~DOC-6: ARCHITECTURE.md broken link~~ DONE
4. BUG-2: .env.example GOOGLE_AI_KEY → GEMINI_API_KEY
5. DOC-3/DOC-2: MCP count sweep (6 files) — inclui Gemini removal
6. DOC-4: Evidence source-of-truth alignment (5 files)

### Batch 2 — Precisa verificacao de codigo
7. SEC-003: API key em URL (verificar linhas)
8. SEC-002: NLM shell injection (verificar linhas)
9. SEC-NEW: done-gate.js injection (verificar linhas)
10. BUG-1: Preflight contract (verificar se pipeline funciona na pratica)
11. BUG-5: Evidence output path (verificar agent vs script)

### Batch 3 — Precisa decisao do Lucas
12. DOC-1: Arquitetura Python em CLAUDE.md (scaffold vs realidade)
13. RED-1: MCP safety consolidacao
14. RED-3: Trim feedback_qa_use_cli_not_mcp.md

### Batch 4 — Defer
15. DOC-7: Gate naming (cosmético)
16. BUG-3: export-pdf.js (possivelmente legacy intencional)
17. BUG-4: qa-video.js (orphan)
18. BUG-6: Grade prompts (grade nao e foco)
19. DEAD-1/2/3: Code cleanup
20. BLOAT-1/2: Doc trimming
21. RED-2: PMID consolidacao

---

Coautoria: Lucas + Opus 4.6 + GPT-5.4 (Codex) | 2026-04-05
