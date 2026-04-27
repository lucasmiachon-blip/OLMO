# CHANGELOG — Meta-analise

> Historico de batches. Append-only (novos no topo). Estado → HANDOFF.md
> Detalhes CSS/HTML: `git show <commit>`. Decisões: NOTES.md.
> Migrado de wt-metanalise para monorepo 2026-03-31.

---

## 2026-04-27 — S264 (Phase 1 done · refactor architectural deferred pós-clear)

> Frame: "vamos so trabalhar nos slides forest" → "atualize os documentos de forma profissional".

- **Phase 1 dead-code cleanup s-absoluto** (commit `ac65ba6`): slide deletado S186 (`20489a2`) deixou 11 refs stale. Categorias A (state files: HANDOFF root + per-aula L15/36/79) + B (evidence broken pointers: meta-narrativa, s-contrato L87/103, s-ancora, s-objetivos, s-forest-plot-final L305, evidence-harvest-S112 L51/89, research-gaps-report 3 sections) + KBP-44 fix `08a-forest1.html:34` (PMID source-tag removed — s-forest2 já compliant). lint:slides + build:metanalise PASS.
- **Phases A-G refactor architectural deferred pós-clear** — 6 issues numerados Lucas turn 7 (`.claude/plans/curious-enchanting-tarjan.md`):
  - **A.** s-quality `.term-dissociation` overflow fix (encapsular `.term-grid` + `.term-dissociation` em wrapper grid `1fr auto`)
  - **B.** s-forest2 calibration via `content/aulas/scratch/calibrate-boxes.mjs` (Playwright headless extrai percentagens bounding box reais)
  - **C.** forest1+2 architectural: tokens (`--data-1..7` Tol Bright) substituem oklch hardcoded · `.forest-annotated` premium card glassmorphism (`var(--v2-surface-panel)` + `box-shadow 0 12px 32px var(--shadow-subtle)`) · aspect-ratio rígido `4501/1451` · rodapé seguro grid `1fr auto` (`.forest-bottom-row` wrapping ma-stat + cochrane-logo)
  - **D.** Motion staggering 3 slides — `stagger: 0.1` + `ease: power2.out` + `y: 6` cascata em `slide-registry.js`
  - **E.** Build + lint + visual verification (vite port 4102 Lucas owns)
  - **F.** QA cycle 3 slides (preflight → inspect → editorial — KBP-05 anti-batch)
  - **G.** Commit + close
- **Out of scope:** s-contrato R11=5.9 REOPEN (CSS failsafe + subgrid) · `qa-screenshots/s-absoluto/` dir delete (Lucas direta — `rm -rf` hook denied) · Phase 2 reconcile geral metanalise/HANDOFF.md (s-checkpoint-2/s-aplicabilidade/s-ancora não-no-manifest) — DEFERRED.

### Aprendizados (max 5 li)

- **HANDOFF stale vs manifest source of truth:** HANDOFF root referenciou `s-absoluto` deletado há 41 commits. Detection via `_manifest.js` (S207, 17 slides) vs HANDOFF (16/16) divergence. KBP-40 generaliza para narrative state files.
- **KBP-44 propagation paradox:** regra S260 ("PMID exclusivo evidence HTML") não auto-propaga — `s-forest1` ainda tinha PMID inline source-tag em S264. Lint candidate: `grep -rn "PMID:" content/aulas/metanalise/slides/`.
- **Failsafe scoping pattern:** forest1/2 usam scoped failsafes per-slide (`.no-js section#s-forestN`) — anti-pattern oposto ao bug s-contrato R11 (regra final unscoped vazando opacity:0 globalmente).
- **`calibrate-boxes.mjs` (port S262 OLMO_GENESIS) canon anti-chute:** Playwright headless extrai bounding box % reais. Default `--slide s-forest2`. Anti-padrão: agentes Claude "chutarem" coordenadas CSS.

## 2026-04-23 — S240 metanalise-SOTA-loop (shared-v2 bridge + s-etd modernização)

### Infra (C1 `2a17744`)
- `shared-bridge.css` novo — 8 tokens v2 opt-in scoped :where(section#s-etd, s-aplicabilidade, s-heterogeneity) via @layer metanalise-modern. Namespace --v2-* evita colisão v1.
- Tokens: 3 text (emphasis/body/muted — oklch-neutral-8/7/6 S239 C4.6 recalibrados), 2 surface/border (panel/hair), 3 semantic on-dark (safe/warn/danger).
- `@import './shared-bridge.css'` em metanalise.css entre header comment e primeira regra (CSS Cascade §6.1 — prevenção bug projetor S238).

### Modernização s-etd (C2 — commit pendente)
- metanalise.css:2015-2060 substituído por @layer metanalise-modern: subgrid + :has(.etd-badge--imp) + logical props.
- Fix H1 border-left asymmetric hdr/rows (uniforme via border-inline-start 6px).
- Fix H2 drift coluna 1fr (subgrid herda template-columns do parent .etd-table).
- Hero row IAM via :has(.etd-badge--imp) — sem hardcode [data-endpoint="iam"].
- QA screenshot: `qa-screenshots/s-etd/s-etd_2026-04-23_1416_S2.png` confirma alinhamento.

### Próximo (S240 continuação)
- C3: split s-etd — novo slide `s-aplicabilidade` (file `15-aplicabilidade.html`) cobrindo CYP2C19 + NICE gap + GRADE implícito. h2 TODO Lucas.
- C4: evidence/s-aplicabilidade.html com refs Altman 1999 + Ludwig 2020 + CYP2C19 editorial ACC.
- C5: s-heterogeneity CSS moderno (só layout, conteúdo intacto).

### Aprendizados (max 5 li)
- CSS subgrid + gap no parent é a solução canônica para header/rows table-like — elimina duplicação de `grid-template-columns` (fonte do H2 drift) + resolve border-left asymmetry via border uniforme. `:has()` desacopla marker visual (hero) de atributo de dado (endpoint) — refactor-safe. @layer metanalise-modern é organizacional; tokens seguem cascade normal — namespace --v2-* é a proteção real. qa-capture.mjs + `__deckGoTo(index)` é o caminho pro para screenshot; evaluate_script manual setando `slide-active` foi workaround descartado. Build ANTES de QA é enforcement CLAUDE.md — pulei a etapa e Lucas corrigiu; lint + build passaram após rerun.

---

## 2026-03-22 — Hardening evidence-db governance + MCP pruning

### Infra
- guard-evidence-db.sh: WARN → BLOCK (`exit 2`). Todas escritas em evidence-db.md bloqueadas sem `/sync-evidence` + aprovação
- Rule `no-clinical-data-in-memory.md`: dados clínicos proibidos em agent memory
- Agent memory limpo: 5 arquivos deletados (~14.7K dados clínicos), MEMORY.md reescrito como índice vazio
- 6 quotes retóricas (Ioannidis, Murad, Guyatt, Uttley, Paul, Schunemann) resgatadas para NOTES.md

### MCP
- NotebookLM skill: PAUSED (MCP não carregado, 0 execuções)
- `.mcp-profiles/research.json`: 13→6 servers (removidos: filesystem, playwright, eslint, lighthouse, a11y, sharp, notebooklm)

### Verificação
- Zero mudanças em slides ou evidence-db. Sessão de governança pura.

---

## 2026-03-21b — Notion sync + 5 PMID corrections (evidence-db v5.7)

### Notion sync
- **Slides DB:** 4 pages atualizadas (Speaker Notes EN): s-checkpoint-1, s-ancora, s-aplicacao, s-aplicabilidade
- **References DB:** 9 papers criados com schema completo (AMA citation, PMID, DOI, Tier, Study Type, Aula relation)

### PMID corrections (PubMed MCP verification)
- 5/9 PMIDs gerados por LLM estavam **errados** — apontavam para papers completamente diferentes:
  - ACCORD 5yr: 21067804 (CTT LDL cholesterol) → **21366473** (Gerstein NEJM)
  - VADT 15yr: 31314966 (HIV testing Africa) → **31167051** (Reaven NEJM)
  - Riddle 2010: 20103978 (squalene fractionation) → **20427682** (Riddle Diabetes Care)
  - Bonds 2010: 20044403 (Varenicline/suicide) → **20061358** (Bonds BMJ)
  - Giacoppo BMJ: 41649579 (Elbahloul Eur J Clin Pharmacol, 162.829 pts) → **40467090** (Giacoppo BMJ, 16.117 pts)
- Corrigidos em: evidence-db.md, research-accord-valgimigli.md, 13-ancora.html, CHANGELOG.md

### Problemas encontrados
- PubMed MCP session expirada mid-use (retry resolveu)
- Notion "Property Name not found" — schema usa "Citation" (não "Name"). Descoberto via notion-fetch
- Giacoppo patient count errado (162.829 era do Elbahloul, paper diferente com PMID errado)

### Verificação
- Build: 18 slides OK. evidence-db v5.6→v5.7.

---

## 2026-03-21 — MCP research enrichment (ACCORD + Valgimigli)

### Research (Scite + Perplexity + Consensus)
- MCPs configurados e testados: Scite (OAuth premium), Perplexity (API key), Consensus (OAuth)
- Scite tallies: ACCORD 7.335 citing / 2.399 smart (64 supporting, 15 contrasting). Ray 1.318 / 889 (23/5). Valgimigli não indexado.
- Perplexity: ACCORD mechanisms, A1C paradox, VADT 15yr comparison
- Consensus: Valgimigli 5 citações, Giacoppo BMJ 2025 confirmação

### Artefatos
- **`references/research-accord-valgimigli.md`** (NOVO): briefing narrativo completo (3 partes) + tabela PDFs para NotebookLM
- **`references/evidence-db.md`** v5.5→v5.6: Scite tallies, NNH 95, paradoxo A1C (Riddle 2010), follow-ups (5yr/9yr/VADT-15yr), 7 RCTs nomeados, CYP2C19, authors' reply (PMID 41763741), Giacoppo BMJ (PMID 40467090)
- **`slides/03-checkpoint-1.html`**: notes enriquecidas — contexto ACCORD para arguição (4 hipóteses, paradoxo A1C, follow-ups, NNH 95)
- **`slides/13-ancora.html`**: notes — 7 RCTs nomeados, modelo IPD, Scite/Consensus status, Giacoppo
- **`slides/14-aplicacao.html`**: notes — NICE gap, custo, lacuna GRADE
- **`slides/15-aplicabilidade.html`**: notes — CYP2C19 achado pré-especificado, generalização geográfica

### Verificação
- Build: 18 slides OK. Lint: clean.
- Zero mudanças em HTML projetado (apenas `<aside class="notes">`)

---

## 2026-03-20c — qa-video.js 3 bug fixes (deck.js compat)

### Fixes (scripts/qa/qa-video.js)
- **FRAMEWORK invertido:** cirrose removido da condição Reveal.js — só grade/osteoporose são Reveal legacy
- **goToSlide broken:** `window.deck.goTo()` não existe (ESM puro). Substituído por DOM manipulation (slide-active swap + dispatch slide:changed/slide:entered)
- **getRevealCount classe errada:** `section.active` → `section.slide-active` (classe real do deck.js)

### Verificação
- `grep "window.deck"` → 0 matches
- `grep "slide-active"` → 4 matches (correto)
- `--aula=metanalise` → FRAMEWORK=deck, `--aula=grade` → FRAMEWORK=reveal

---

## 2026-03-20b — s-checkpoint-1 ACCORD rewrite + research deep dive

### Slide rewrite
- `03-checkpoint-1.html`: reescrito inteiro — ACCORD trap com dados reais (Ray 2009 PMID 19465231, ACCORD 2008 PMID 18539917)
- Visual "liquidificador": diamante simplificado dissolve → 4 trial markers (UKPDS, ADVANCE, VADT, ACCORD em danger)
- 3-beat state machine: cenário (auto) → pergunta (click) → twist ACCORD (click)
- `metanalise.css`: +110 linhas (`.ck1-*` classes, forest visual, trial positions, failsafes)
- `slide-registry.js`: handler reescrito (diamond fade, trial stagger, ACCORD emphasis)
- `_manifest.js`: headline atualizada

### Docs
- `narrative.md` v2.5: I1 reescrito com ACCORD, visual liquidificador, changelog
- `evidence-db.md` v5.5: seção "Checkpoint 1 — ACCORD trap" com tabelas Ray/ACCORD
- `blueprint.md` v2.0: slide 03 atualizado (evidência, status, nota dados reais)

### Verificação
- Build: 18 slides OK. Lint: clean. Integrity: 18/18 match. Narrative-sync: 0 errors.
- Slide-punch: 6/6 PASS, veredicto ENCAIXADO.

### Research — arguição prep
- Deep research: MAs controle glicêmico intensivo 2009-2024. 10 papers verificados.
- Achado: **ZERO** fizeram GRADE formal (Ray, CONTROL, Boussageon, Hemmingsen Cochrane, Kunutsor 2024)
- Boussageon 2011 (PMID 21791495): NNT 117-150 (IAM) vs NNH 15-52 (hipoglicemia). Crítica mais forte.
- Kunutsor 2024 (PMID 38409644): update 51.469 pts — IAM reduzido, MACE NS, sem GRADE.
- Scite tallies Ray 2009: 889 citações (23 supporting, 5 contrasting, 806 mentioning)
- Tese/antítese/síntese preparada para arguição + 6 perguntas de banca com respostas

### Infra
- `.mcp.json`: Scite MCP adicionado (streamableHttp → api.scite.ai/mcp). Perplexity: config OK, API key pendente.

---

## 2026-03-20a — Gemini CLI headless migration (5 items)

Commits: `b496462`, `38599cf`

- `scripts/gemini.mjs`: rewrite — model `gemini-3.1-pro-preview`, multimodal (--png/--mp4), auto-save `.audit/`, template loading from `docs/prompts/gemini-slide-qa.md`
- `scripts/qa/qa-video.js`: deck.js support (`--aula=metanalise`), framework auto-detect, 15s max recording, BASE_URL parametrizado
- `.audit/`: diretorio criado (.gitkeep tracked, *.json gitignored)
- `WT-OPERATING.md` §4 QA.3: CLI invocation, WebM/MP4 codec limitation documented
- `CLAUDE.md` (aula): secao "Auditoria Visual — Gemini CLI" adicionada
- MCP Gemini: **zero** referencias em .mcp.json ou .mcp-profiles/. Acesso exclusivo via CLI.

---

## 2026-03-19j — Doc hardening session: PMIDs, lessons reorg, ERROR clusters, QA template

- **Batch 1:** Siedler PMID 40969451 verified + framing corrected. Higgins DOI verified. Gemini model discrepancy documented. evidence-db v5.3, blueprint v1.9.
- **Batch 2:** lessons.md reorganized by scope (9 sections). HANDOFF cleaned (stale items removed). ERROR-LOG: 3 error clusters extracted. AUDIT-VISUAL: scorecard template + 15-slide QA queue.

---

## 2026-03-19i — s-hook QA UPLIFT: asymmetric layout, countUp, editorial typography

Commit: `c400f5a` · QA.0-QA.2 PASS (14 dims >=9, contraste AAA 8.61-17.58:1)

Gemini-driven: 3 cards iguais → grid assimétrico "fenômeno vs realidade" (1fr/auto/1fr). Números isolados de affixes (96/72px mono). GSAP custom timeline (countUp + stagger + divider scaleY). Tags AMSTAR-2/GRADE como pills. Cor danger REJEITADA (violaria semântica). Layout "Trust Blackout" simplificado para timeline sequencial.

---

## 2026-03-19h — s-hook REWRITE: sober 3-card metrics

Commit: `edb2e2f`

Lucas rejeitou tom alarmista (VITALITY "1.330 retratados", UTI, verdict vermelho). Novo: 3 metric cards sober (~80/dia, 81% AMSTAR-2, 33.8% GRADE). State machine inteira removida (-117 linhas registry, -132 linhas CSS). `data-animate="stagger"` declarativo. Scorecard anterior invalidado.

---

## 2026-03-19g — Gemini prompt v4.0 → v6.0

Prompt reescrito absorvendo cirrose v6: 5 personas (was 3), scorecard numérico 10 dimensões, 10 lenses granulares, 8 steps, temperature 1.0 + topP 0.95. Output schema rígido com 6 seções obrigatórias.

---

## 2026-03-19f — s-hook Gate 3 scorecard + QA.4 fixes

14-dim scorecard: avg 8.6. Verdict contrast 3.67→7.78:1 (explicit oklch override, bypasses stage-c remap). SplitText word-break fix (`type: 'words,chars'`). Root cause: stage-c remaps `--text-on-dark` to dark text.

---

## 2026-03-19e — s-hook content rewrite: VITALITY backbone

Beat 0: "1.330 trials retratados → 3.902 MAs" (VITALITY BMJ 2025). Beat 1: "20% mudam resultado, 157 guidelines". Beat 2: NICE-SUGAR chain (Wiener → NICE-SUGAR → Griesdale). evidence-db v5.1: +8 refs verificadas. reading-list v0.4: +3 pre-reading.

---

## 2026-03-19d — Hardening documental + GSAP toolkit

Flip + ScrambleTextPlugin importados em index.template.html. Gemini prompt v3.0→v4.0 (CoT 5-step, code-grounded API table, few-shot, self-critique). `references/archetypes.md` criado (6 layout patterns extraídos de 18 slides).

---

## 2026-03-19c — Visual uplift pre-work (infra + prompt v3.0)

SplitText importado. Dark-bg CSS consolidado: 2→6 slides (#162032 + 8 on-dark overrides). Gemini prompt v3.0 (role priming, CoT 4 dimensões, exploration mandate GSAP).

---

## 2026-03-19b — s-hook Gemini materials captured

Screenshots 3 beats + vídeo .webm (413KB) para QA.3 Gemini.

---

## 2026-03-19a — Reveal.js purge + Vite cache fix

Root cause: Vite cache poisoning (Reveal.js pre-bundled de grade/osteoporose → `section { display: none }`). Fix: Reveal removido de dependencies, FROZEN_AULAS excluídas de discoverEntries().

---

## 2026-03-18e — s-hook v4 (grid + blackout + brutalismo)

Grid 2-col assimétrico (Z-pattern). Beat 2 blackout (opacity 0.12). Verdict brutalismo (--danger bg, Instrument Serif italic). Gemini: beauty 6.5, legibility 9.0 (ITERATE).

---

## 2026-03-18d — s-hook refactor (hero 41%)

3-column grid → hero number (41% Windish). Trials concretos (TRH, rosiglitazona, glicemia intensiva, 396 reversões). evidence-db v5.0: +6 refs. QA.0-QA.2 PASS (14 dims >=8, hero 14.15:1 AAA).

---

## 2026-03-18c — s-title QA.3-QA.4 (Gemini approved)

Gemini 2 rounds → beauty 9/10, legibility 10/10, approved. Custom choreography: h1→subtitle→pillars(masking)→dots→identity. Inverted weight hierarchy (h1 400/64px, subtitle 600/20px uppercase).

---

## 2026-03-18 — QA + specificity fixes + merge main

Specificity fixes (#deck selectors). QA s-title QA.0-2 PASS (AAA). Merge main: 4 commits A/B (medical-researcher, final-pass v3, slide-punch, new-skill v2).

---

## Entries 2026-03-17 (colapsados)

| Data | Resumo |
|------|--------|
| 03-17h | Verificação documental: XREF +8 files metanalise, README +WT-OPERATING, CLAUDE.md root status |
| 03-17g | Doc sync: 6 inconsistências factuais corrigidas, 302 linhas cortadas (blueprint/evidence-db/narrative/HANDOFF) |
| 03-17f | WT-OPERATING.md criado (maquina de estados + QA 5-stage). QA-WORKFLOW.md → DEPRECATED |
| 03-17e | MCPs racionalizados: .mcp.json 5→7 servers, 14 removidos (built-ins), ECOSYSTEM.md reescrito |
| 03-17d | HTML cleanup: data-background-color removido 17/18, slide-navy removido 16/18. ERRO-009 |
| 03-17c | QA-WORKFLOW.md reescrito como doc executável (4-gate, template scorecard) |
| 03-17b | QA s-contrato visual fix: flex:1 removido, cards 550→248px, contraste 8.8:1, scorecard re-scored |
| 03-17 | QA s-contrato: h2 assertivo, scope footer removido, slide-navy/data-background-color limpos, scorecard 14-dim PASS |

---

## Sessões worktree (2026-03-13 a 2026-03-16)

| Sessão | Resumo |
|--------|--------|
| 03-14 | Análise 3 dossiês Gemini, 10 PMIDs verificados, evidence-db v3 |
| 03-15 | Notion sync (15 slides + 7 refs), narrative v2, slides 12/16/17 recalibrados |
| 03-15b | QA pass conteúdo+visual (14 dims), slide-registry.js criado |
| 03-15c | Busca âncora: 8 candidatos verificados, Valgimigli selecionado |
| 03-15e | Slides 13-15 criados (F3 completa), 18 slides ativos |
| 03-15f | QA infra parametrizada multi-aula: 22 arquivos, 6 agents, 11 skills |
| 03-15g | lint PASS, CSS orphan audit (-8 classes), _manifest.js criado |
| 03-15i | Root cause stage-c, screenshots Playwright batch 1, QA redo PASS |
| 03-15j | Scroll fix, notes hidden, auditoria dados hook — ERRO-001→004 |
| 03-16 | ERRO-005 h2 alignment fix, ERRO-006 checkpoint centering fix |
| 03-16b | Zoom fullscreen, MCPs uv removidos, guards testados |
| 03-16c | A/B sync WT↔main (9 arquivos), hooks instalados, done-gate PASS |
| 03-16d | Pesquisa ERRO-003: Bojcic PMID 37931822, Qureshi PMID 41428154 |
| 03-16h | Hook layout centering, revertido override stage-c errôneo |
| 03-16i | Notion sync completo: 18/18 slides + 25 refs |
| 03-16j | Hook 80→146/dia, CP1 PMID corrigido, evidence-db v4.2, QA 17/18 PASS |
| 03-16k | Merge main (4 commits A/B), .mcp.json validado, build OK |
