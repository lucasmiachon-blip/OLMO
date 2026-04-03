# CHANGELOG

## Sessao 56 — 2026-04-03 (PICO Evidence + NLM Research Leg)

### Evidence
- Generated `evidence/s-pico.html` via /research pipeline (5 legs + NLM)
- 7 verified refs: Cochrane v6.5, GRADE 8, Core GRADE 5, Goldkuhle 2023, PRISMA 2020, PICOS, Borenstein
- Jia et al. 2026 (Gemini) marked INVALID — DOI doesn't resolve, paper not found
- Reference table: 8 terms (indirectness, target/study PICO, treatment switching, tautologia, PICOS, PICOT, SPIDER)

### Pipeline
- NotebookLM validated as /research leg — Borenstein tautology discovery (textbook content PubMed can't find)
- Command: `PYTHONIOENCODING=utf-8 nlm notebook query <id> "query" --json`

### Memories (3 new)
- `feedback_research_non_deterministic.md` — queries exploratorias, nao deterministas
- `feedback_narrative_citation_format.md` — narrativa sem PMID/badges, formato cientifico
- `project_nlm_research_leg.md` — NLM como perna, notebook IDs, auth pattern

## Sessao 55 — 2026-04-03 (Arch Diagnosis Review)

### CSS Architecture
- New `.theme-dark` class in base.css — restores 11 on-dark tokens inside stage-c
- metanalise.css: replaced 6 hardcoded slide IDs with `.theme-dark .slide-inner` (24→3 lines)
- 6 HTML slides: added `class="theme-dark"` to `<section>`
- slide-rules.md §10 updated: `.theme-dark` is canonical, `.slide-navy` marked legacy

### Governance
- CLAUDE.md: Key Files trimmed 33→4 lines (link to TREE.md). Total 98→72 lines
- process-hygiene.md: added `paths: content/aulas/**` frontmatter (lazy load)
- design-reference.md: added `paths: content/aulas/**` frontmatter (lazy load)
- Rules path-scoped: 3/11 → 5/11 (45%)

### Architecture Review
- Evaluated 10 findings from external diagnosis across CSS, governance, Python
- Agreed: 2 strongly, 4 partially. Disagreed: 4 (clamp overrides correct, Python is stub)

## Sessao 54 — 2026-04-03 (Insights Skill Creation)

### insights-skill v1.0
- New skill: /insights — agent self-improvement via retrospective session analysis
- 4-phase process: SCAN→AUDIT→DIAGNOSE→PRESCRIBE
- 3 recipes: weekly retrospective, focused error patterns, rule health check
- 7-category taxonomy: RULE_VIOLATION, RULE_GAP, PATTERN_REPEAT, RULE_STALE, HOOK_GAP, SKILL_GAP, SKILL_UNDERTRIGGER
- Read-only: proposes changes, never auto-applies. Complements /dream (memory) with performance audit.
- Evolution tracking: saves canonical report + archives previous for longitudinal comparison

### Eval Loop (skill-creator)
- 3 evals, 22 assertions, 6 parallel agents (with_skill vs without_skill baseline)
- Result: 22/22 (100%) with_skill vs 20/22 (91.7%) without_skill = +8.3pp
- Discriminating assertions: A3 (taxonomy), A8 (report archival)
- Qualitative: structured output, causal chain analysis, 50% shorter rule-health-check
- Token cost: +34% (103k vs 77k avg) — acceptable for weekly audit

### First Real Insights Run
- Weekly retrospective identified 15 incidents (S38-S53), 12 findings
- Top systemic issues: fail-open gates, staged-blob bugs, parameter guessing, context rot
- 8 diff-ready proposals for rules improvements (pending Lucas approval)
- Rule compliance: 7/11 followed, 3/11 violated, 1/11 stale

## Sessao 53 — 2026-04-03 (NLM Skill Rewrite)

### nlm-skill v1.0
- Rewrite SKILL.md: 702→191 linhas (-73%), workflow-first para medical education
- 3 workflow recipes: Paper to Study Materials, Research Pipeline, Batch Concurso Prep
- Fix MCP prefix bug: `mcp__notebooklm-mcp__*` → `mcp__notebooklm__*`
- Clinical `--focus` prompt templates (ICA-AKI, trial endpoints, NNT)
- Windows cp1252 encoding workaround documented
- Expanded reference.md: 52→363 linhas (detailed command catalog)
- PubMed URL pattern: `https://pubmed.ncbi.nlm.nih.gov/{PMID}/`
- OLMO ecosystem integration table (/research, /concurso, /exam-generator, Zotero)

### Eval Loop (skill-creator)
- 3 evals, 25 assertions, 6 parallel agents (new vs old skill)
- Result: 100% pass rate (new) vs 96% (old), 12.5% fewer tokens
- Workspace + benchmark + grading preserved in nlm-skill-workspace/

## Sessao 52 — 2026-04-02 (Secondary Review)

### Fixes (5)
- guard-secrets.sh: .env filename blocking (exit 1 for .env* except .env.example)
- validate-css.sh: !important outside allowed context promoted WARN→FAIL, context window 20→50 lines
- deck.js: added `details, summary` to click handler exclusion list
- base.css: OKLCH chroma 0.002→0.001 in 5 tints (reduce P3/OLED blue tint risk)
- orchestrator.py: documented mcp_operation key assumption in comment

### Hooks
- guard-product-files.sh wired in settings.local.json (was missing)
- Removed 2 vestigial hooks: guard-evidence-db.sh, task-completed-gate.sh
- All 5 hooks tested and verified

### Assessment (10 items reviewed)
- 3 already OK: AKIA present, NaN guard positioned correctly, threading.Lock sufficient
- 5 fixed (above)
- 1 documented (orchestrator gate limitation)
- 1 pending manual test (reduced-motion screenshot)

## Sessao 51 — 2026-04-02 (Adversarial Fix)

### Tier 1 CRITICAL (5 fixes)
- mcp_safety.py: NaN/Inf/negative guard, validate_move param validation
- orchestrator.py: wire validate_mcp_step() into route_task(), fix status overwrite in finally
- guard-secrets.sh: scan staged blobs, safe word-splitting, 8 new patterns, symlink check
- medical-researcher SKILL.md: NNT applicability constraints, retraction check, 4 new statuses

### Tier 2 HIGH (3 fixes + 1 gap)
- engine.js: reduced-motion calls forceAnimFinalState, per-slide timer scoping
- deck.js: transitionend race cleanup, init idempotency guard, click hijack fix
- base.css: OKLCH fallback (shadow/overlay tokens), E059 achromatic fix, stage-bad selectors

### Tier 3 (4 fixes)
- guard-product-files.sh: SPRINT_MODE removed, fail-closed, path canonicalization
- validate-css.sh: CRLF strip, comment filter, indented selector regex
- pre-commit.sh: staged index for slide count
- orchestrator.py: agent.model race via task dict, run_workflow exception boundary
- smart_scheduler.py: atomic writes (tmp+rename), threading lock

### Tests + Docs
- 6 new tests (NaN, Inf, negative, empty input) → 53 total
- CLAUDE.md synced (hook counts, test count, living HTML workflow)
- Git history audit: clean (no real secrets, only placeholders)
- Report: docs/ADVERSARIAL-FIX-S51.md
- Dream run 11: 3 new patterns, 2 updates

### Validation stats
- 38 findings validated: 30 TRUE, 5 PARTIALLY TRUE, 3 FALSE POSITIVE (~8% FP)
- False positives: mcp_safety #1 (already blocked), validate-css #1 (by design), pre-commit #1 (intentional)

## Sessao 50 — 2026-04-02 (Adversarial Review)

### Adversarial Review via Codex GPT-5.4
- 17 arquivos revisados: Python (3), JS (3), CSS (2), Rules/Skills (3), Shell hooks (4), Docs (2)
- 118 findings: 9 CRITICAL, 61 HIGH, 36 MEDIUM, 12 LOW
- 4 cross-cutting patterns: security theater, working-tree vs staged blob, fail-open, docs drift
- Relatorio completo: `docs/ADVERSARIAL-REVIEW-S50.md`

### Findings mais graves
- mcp_safety.py: NaN bypassa thresholds, unknown ops escapam via batch_size
- orchestrator.py: validate_mcp_step() nunca chamado (dead code)
- guard-secrets.sh: escaneia working-tree em vez de staged blob
- validate-css.sh: sempre retorna exit 0 (nunca bloqueia)
- medical-researcher: NNT forcado como universal, sem check de retraction

### Infra
- Dream run 10 (maintenance-only, no new signal)

## Sessao 49 — 2026-04-02 (s-rs-vs-ma DONE)

### Slide s-rs-vs-ma
- Redesign: 3 colunas (Revisoes, Revisao Sistematica, Meta-analise) com hierarquia visual E073-E075
- Col1: lista com % (Zhao 2022) + itens secundarios (Escopo, Umbrella) em .compare-minor
- Col2: 4 termos verticalizados (Protocolo, Busca, Selecao, Vies) + label "= PROCESSO"
- Col3: header unico "Meta-analise" + SVG forest plot (opacity melhorada) + label "= CALCULO"
- Footer: specificity fix (#deck p.compare-footer) para evitar max-width: 56ch do base.css

### Evidence HTML
- PMID 35725647: corrigido Shen→Zhao em todas as secoes. WEB-VERIFIED
- PMID 27620683: Ioannidis CANDIDATE→WEB-VERIFIED em depth rubric, convergencia, numeros
- Badges CANDIDATE→WEB-VERIFIED consistentes em todo o documento

### Infra
- lint-slides.js: evidence/ excluido da varredura de slides
- vite.config.js: host:true para acesso Playwright IPv4

### Memorias
- feedback_no_parameter_guessing: nunca chutar parametros, verificar API antes
- feedback_qa_screenshots_cleanup: screenshots com timestamp, deletar apos QA

## Sessao 48 — 2026-04-02 (Primeiro Living HTML Real)

### Evidence HTML
- Primeiro HTML real gerado: `content/aulas/metanalise/evidence/s-rs-vs-ma.html`
- JSON intermediario versionado: `content/aulas/metanalise/evidence/s-rs-vs-ma.json`
- Conteudo: sintese narrativa, speaker notes (90s), pedagogia, retorica, numeros bibliometricos, depth rubric D1-D8
- Referencia Rapida: 12 entradas (8 tipos de revisao + 4 master protocols)
- Pipeline validado end-to-end: /research → JSON → generate-evidence-html.py → HTML

### Template (generate-evidence-html.py)
- Badges inline: [WEB-VERIFIED] azul, [CANDIDATE] vermelho
- text-align:justify, white-space:pre-line em speaker notes
- Secao colapsavel Referencia Rapida (Termo/Definicao/Nota)
- Secao Referencias academicas: Autor (ano) + lista final com PMID/revista/status

### Slide
- s-rs-vs-ma reescrito: 2→4 colunas (Rev narrativa, RS, Umbrella Review, MA)
- aside.notes: skeleton minimo com link para evidence HTML
- Footer: "Nem toda RS tem MA. Hoje, quase toda MA e precedida de uma RS."

### Decisoes
- Evidence-first workflow confirmado (HTML antes do slide)
- MDs (evidence-db, blueprint) = peso morto. Lucas nao le. Deprecacao gradual
- aside.notes = skeleton (timing + link). Conteudo real no evidence HTML

### Docs
- HANDOFF → S49

## Sessao 47 — 2026-04-02 (/research v2 + Living HTML)

### Skills
- /research v2 criada: 5 pernas paralelas (deep-search + mbe-evaluator + reference-checker + mcp-query-runner + opus-researcher) + orquestrador
- SKILL.md: output Notion → living HTML per slide (evidence/{slide-id}.html)
- SKILL.md: NNT mandate + risco basal obrigatorio
- opus-researcher: NNT mandate + SCite contrasting citations para critica metodologica
- mbe-evaluator: analise retorica adicionada (§6: assertion-evidence, carga cognitiva, dispositivos)
- generate-evidence-html.py: script gerador de HTML standalone per slide

### Agents
- opus-researcher.md, mbe-evaluator.md, reference-checker.md, mcp-query-runner.md: novos agents para pipeline /research

### Evals
- research iteration 2: 6 runs (3 with + 3 without), 21/21 WITH (100%), 14/21 WITHOUT (66.7%)
- Delta: +31pp (honesto — assertions testam utilidade, nao estrutura)
- WITH skill mais rapido que baseline (-33.8s avg)
- Eval viewer com benchmark tab funcional

### Decisoes
- Living HTML substitui: evidence-db.md, aside.notes, Notion slide DB, blueprint.md (5→2 fontes)
- /research e /teaching NAO fundem (lifecycle diferente). mbe-evaluator e a ponte
- aside.notes deprecated (cleanup futuro)

### Docs
- HANDOFF → S48

## Sessao 46 — 2026-04-02 (Deep-Search v2.1 Eval Loop)

### Skills
- deep-search v2.0 → v2.1: PRIMARY DIRECTIVE em query-template.md (Tier 1 sources como core deliverable)
- deep-search v2.1: post-processing simplificado (7 steps → 3 regras de limpeza minima)
- skill-creator eval-viewer: fix UTF-8 encoding (7 read_text/write_text calls → encoding="utf-8")

### Evals
- deep-search iteration 2: 3 evals × 2 configs (with_skill + old_skill), grading, benchmark.json
- Benchmark: v2.1=91.7% vs v2.0=95.8% (delta -4.1pp, por Gemini PMID variability, nao skill)
- Eval viewer static HTML funcional com benchmark tab

### Docs
- HANDOFF → S47 (skill merge roadmap: new-slide→slide-authoring, /research unificada)

## Sessao 45 — 2026-04-02 (Codex Cleanup Final)

### Scripts
- qa-video.js: PORT_MAP per-aula (cirrose:4100, grade:4101, metanalise:4102) replaces hardcoded 4100
- qa-video.js: grade removed from Reveal.js mapping (confirmed deck.js)
- done-gate.js: notes regex relaxed (any attribute order, quotes, multiple classes)

### CSS
- cirrose.css: defensive .pcalc-tab--active:hover + .pcalc-sex-btn--active:hover
- cirrose.css: HEX fallback (#192035) for #s-cp1 oklch background

### Docs
- narrative.md (cirrose): alcohol [TBD SOURCE] → PMID 37469291 (Semmler 2023)
- gate2-opus-visual.md: sharp/a11y tools marked [PLANNED]
- CODEX-REVIEW-S40.md: restructured — 7 resolved, 9 dismissed, 11 deferred. Zero open HIGH.
- HANDOFF → S46

## Sessao 44 — 2026-04-01 (Codex Cleanup + Verification)

### Cleanup
- Deleted CODEX-REVIEW-S37.md (100% resolved — verified)
- Condensed CODEX-REVIEW-S40.md: 411 → 55 lines (open items only, strikethroughs removed)
- Verified 6 findings as already fixed (done-gate path, qa-a11y path, lint-case-sync bidirectional, getArg, install-fonts, --danger hue)
- Dismissed 4 findings (specificity .source-tag = intentional, session-hygiene = OK, notion-cross-validation = design, med-researcher memory = moot)

### Script fixes
- validate-css.sh: hardcoded `cirrose.css` scan → dynamic discovery (shared/css/base.css + aula.css)
- validate-css.sh: import order check accepts `base.css → aula.css` pattern (not just single-file)
- lint-case-sync.js: table regex 3-column only → N-column (`{2,}` quantifier)

### CSS
- metanalise.css: removed dead `::before/::after { display: none }` override (base.css has no pseudo-elements on .slide-inner)

### Agents
- repo-janitor.md: added "skip if not found" fallback for CLAUDE.md pre-condition

### Docs
- HANDOFF → S45 (removed already-fixed items)

## Sessao 43 — 2026-04-01 (Fixes Chat + Prioridades HANDOFF)

### Dream Run 5
- Memory consolidation: 5 files updated, 1 new (feedback_context_rot)
- decisions_active.md: type fix + reorganized by theme, removed completed migrations
- project_codex_review_findings.md: P0-P3 status updated to reality
- Quick Reference: added Codex framing + context rot mitigation

### P2 — Quality (conclusion)
- Dark-slide tokens: --ui-accent-on-dark + --downgrade-on-dark added to metanalise restoration block
- Cirrose .no-js [data-reveal] fallback (cirrose doesn't import base.css)
- Cirrose .title-affiliation: 16px → 18px min

### P3 — Script fix
- qa-batch-screenshot.mjs: process.exit(1) → throw (honors finally, closes browser)

### Cleanup
- Removed 5 stale cirrose/scripts/ files (capture-*.mjs, content-research.mjs, gemini-qa3.mjs, qa-batch-screenshot.mjs) — superseded by shared scripts/

### Reflexao Critica (anti-sycophancy)
- 12 Codex findings dismissidos com justificativa (documented in CODEX-REVIEW-S40.md)
- Key: #67 base.css GSAP = failsafe, #56 checkpoint = state machine, #60 cirrose dark = stage-c correct

### Docs
- CODEX-REVIEW-S40.md: P2 marked done, dismissals documented
- HANDOFF → S44

## Sessao 42 — 2026-04-01 (Codex Review Exec cont.)

### P2 — Quality (cont.)
- Font tokens bumped: --text-small 20px, --text-caption 18px (base + metanalise + cirrose)
- Source-tags 16px, hook-tag/contrato-skill 18px, ck1-name 16px, screening labels 18px
- --danger hue: 25° → 8° everywhere (root + stage-c on-dark in both base + cirrose)
- Cirrose --danger aligned to base.css canonical (50% 0.22 8)
- GSAP jurisdiction: 5 elements converted from .to() → .fromTo() (hook + contrato)
  CSS stripped of transforms, keeps only opacity:0. Divider/checkpoint exceptions kept.
- .no-js fallback: generalized [data-animate] + added [data-reveal]
- aria-hidden on 5 forest-plot anatomy symbols (a11y)

### Docs
- HANDOFF → S43
- Memory: project_metanalise_projetor (projetor gigante 10m, Canva fallback)

## Sessao 41 — 2026-04-01 (Codex Review Exec)

### P0 — Silent Failures (5 fixes)
- pathToFileURL() em 3 qa-batch-screenshot.mjs (Windows file URL)
- Gemini response validation em content-research.mjs (fail-fast)
- --strictPort em export-pdf.js
- Windows path separator em lint-slides.js (GSAP rule)
- MELD 14 reconciliado em 07-cp1.html (notes corrigidas)

### P1 — Governance (5 fixes)
- qa-engineer threshold: 9/10 → 7/10 (economic), 9/10 so --deep
- qa-engineer tools: 5 MCP tools removidas (inalcancaveis)
- mcp_safety: auto-execute removido, writes sempre humano
- slide-rules: data-background-color excecao removida (morto)
- Stale monorepo paths: 4 corrigidos em 3 rules

### P2 — Quality (parcial)
- Print/PDF reset: +stagger children, +[data-reveal], +inline opacity:0
- Font-size audit: 21 instancias < 18px documentadas por categoria

### C15 Relaunch
- Bug skill wrapper contornado: `codex exec --sandbox read-only` via stdin pipe
- 12 findings (1 CRITICAL, 7 HIGH, 2 MEDIUM, 1 LOW). Total: 147.

### Meta (anotado)
- Context rot e dream/memorias nao funcionando — investigar proxima sessao

## Sessao 40 — 2026-04-01 (Codex Review Adversarial)

### Codex Review GPT-5.4 — 135 findings (full-scope adversarial)
- 15 chunks: 13 scripts, 3 CSS, 29 slides HTML, 7 agents, 11 rules
- 7 CRITICAL, 68 HIGH, 36 MEDIUM, 24 LOW (apos filtragem)
- 1 falso positivo filtrado (taskkill // em Git Bash)
- 5 rebaixados CRITICAL→LOW (inline opacity:0 pragmatico)
- C15 (docs/prompts) falhou 2x — bug no codex:codex-rescue com .md files

### Padroes sistemicos identificados
- S1: font-size < 18px (13 instancias across 3 CSS files)
- S2: h2 generico (11+ slides, rewrite e trabalho do Lucas)
- S3: print/PDF incompleto (GSAP-hidden elements invisiveis)
- S4: GSAP jurisdiction (CSS per-slide compete com GSAP)
- S5: stale monorepo paths em 4 rules
- S6: governance contradictions (4 CRITICAL em agents/rules)

### Plano P0-P3 documentado
- P0: 5 fixes (Windows file URL, --strictPort, MELD contradiction, path separator)
- P1: 5 governance fixes (qa-engineer threshold, mcp_safety, slide-rules)
- P2: 5 systemic audits (font-size, print, GSAP, tokens)
- P3: polish + h2 rewrite (Lucas guia)

### Memory
- feedback_css_inline: inline opacity:0 para GSAP e OK
- feedback_h2_assertions: AI-generated h2 sao terriveis, Lucas reescreve
- project_codex_doc_review_bug: C15 falhou 2x, investigar

### Docs
- docs/CODEX-REVIEW-S40.md: review completo com 135 findings + plano P0-P3

## Sessao 39 — 2026-04-01 (Metanalise Tooling)

### Scripts — 3 movidos para scripts/ compartilhado (multi-aula)
- `qa-batch-screenshot.mjs`: +detectAula, +PORT_MAP, dynamic manifest/URL, act filter suporta phases
- `gemini-qa3.mjs`: +detectAula, dynamic CSS (`${aula}.css`), prompt paths per-aula
- `content-research.mjs`: +detectAula, dynamic AULA_DIR
- `browser-qa-act1.mjs`: +loadManifestIds() dinamico (le _manifest.js da aula)

### Prompts — 5 templates criados em metanalise/docs/prompts/
- gate0-inspector, gate4-call-a/b/c, error-digest (audiencia: residentes CM)

### Infra
- package.json: +4 npm scripts metanalise (qa:screenshots, qa:gate0, qa:gate4, research)
- Migrou cirrose/grade scripts para usar shared scripts/ com --aula

### Bugs corrigidos
- URL Vite em qa-batch-screenshot: `/aulas/cirrose/` → `/${aula}/` (bug monorepo migration)
- Prompt paths em gemini-qa3: REPO_ROOT nunca resolvia → per-aula AULA_DIR/docs/prompts/

## Sessao 38 — 2026-04-01 (Scripts + Prompts)

### P1 — Prompt Engineering (Codex Review fixes)
- `anti-drift.md`: "revert extra work" → "ask Lucas before reverting" (protege WIP)
- `qa-engineer.md`: removido "Use PROACTIVELY", adicionado Scope & Mode (economic default, --deep on demand)
- `medical-researcher.md`: PMID verification tiered (VERIFIED/WEB-VERIFIED/CANDIDATE, fallback MCP→WebSearch)
- `design-reference.md`: vocabulario canonico de verificacao (5 status: VERIFIED→UNRESOLVED)

### P0 — Root path fixes + fail-hard (Codex Review CRITICAL)
- `lint-slides.js`: `walk(join(root, 'aulas'), ...)` → `walk(root, ...)` (path duplication fix)
- `lint-narrative-sync.js`: `join(root, 'aulas', aula)` → `join(root, aula)`
- `lint-gsap-css-race.mjs`: CLI arg + dynamic aulaDir/CSS filename + shared/ paths via root
- `export-pdf.js`: failures counter + `process.exit(1)` on any export failure

### P3 — Polish (Codex Review LOW)
- `validate-css.sh`: SCRIPT_DIR-based root (CWD-independent) + pipefail-safe wc -l
- `qa-accessibility.js`: notes regex relaxed `/<aside\b[^>]*\bnotes\b[^>]*>/`
- `install-fonts.js`: HTTP status >= 400 validation in fetch()
- `qa-engineer.md`: RALPH commands with `2>/dev/null || echo` fallback
- `medical-researcher.md`: "skip if not found" for aula CLAUDE.md + §3 ref fix

### P2 — Scripts parametrizados (Codex Review fixes)
- `browser-qa-act1.mjs`: detectAula() + PORT_MAP + auto-detect branch (cirrose IDs preservados)
- `pre-commit.sh`: branch matching generalizado (cirrose + grade + metanalise)
- `validate-css.sh`: import order `${AULA}.css` dinamico + WARN counter via process substitution
- `lint-case-sync.js`: path fix + brace-balanced parser + diff bidirecional (CASE.md→manifest)
- `qa-accessibility.js`: __dirname-based path → slides/ + existsSync guard
- `done-gate.js`: aulaDir path fix + Windows-safe git status (sem shell:true)

## Sessao 37 — 2026-04-01 (self-improvement via ERROR-LOGs)

### Rules — 8 lacunas codificadas (86 erros analisados)
- `slide-rules.md`: +§9 GSAP jurisdiction/FOUC, §10 stage-c dark, §11 specificity, §12 bootstrap nova aula
- `design-reference.md`: +§1 hierarquia semantica, §3 PMID propagation (56% erro LLM), +§4 color safety OKLCH
- `qa-pipeline.md`: nova rule — attention separation, cor semantica QA, anti-sycophancy com rubrica

### Codex Review (GPT-5.4)
- Scripts: 16 findings (2 CRITICAL root path + export-pdf, 5 HIGH, 6 MEDIUM, 2 LOW)
- Agents+Rules: 39 findings (3 CRITICAL verification deadlock + impossible QA + memory conflict)
- 3 problemas sistemicos: "verified" ambiguo, tensao exhaustive/restrained, fallback ausente
- Plano de implementacao P0-P3 documentado em `docs/CODEX-REVIEW-S37.md`

### Governanca
- 11 rules (antes 10). CI verde (47 testes). Dream: nada novo a consolidar.

## Sessao 36 — 2026-04-01 (CSS fixes + Codex review)

### Cirrose CSS Fixes (post-import)
- Font paths: `shared/` → `../shared/` nas 4 @font-face (monorepo sibling fix)
- Source-tag specificity: `.stage-c #deck .source-tag` (1,2,1) vence `#deck p` (1,0,1)
- Source-tag: 16px + max-width:none (legibilidade 55" TV @ 6m confirmada)

### Housekeeping
- Aula_cirrose standalone movida para Legacy/
- Memory: facts_projection_setup (55" TV, 6m baseline)

## Sessao 35 — 2026-04-01 (cirrose import from standalone)

### Cirrose Import (Aula_cirrose → OLMO)
- 11 slides ativos (Act 1) + 35 arquivados em _archive/ (substituem 44 antigos)
- cirrose.css single-file 3224L (absorveu base.css + archetypes.css eliminado)
- slide-registry.js, _manifest.js, references/ atualizados
- Meta files: ERROR-LOG (67 erros), AUDIT-VISUAL (14 dim), WT-OPERATING, DONE-GATE

### Shared JS Updates (backwards-compatible)
- deck.js: bugfix child transition bubbling
- engine.js: animation timing (slide:changed vs slide:entered)
- case-panel.js: MELD/MELD-Na/MELD 3.0 tabs

### Governance Ported
- 1 rule (design-reference), 3 agents, 8 agent-memories, 5 skills, 3 commands
- 7 hooks (.claude/hooks/): guard-generated, guard-secrets, check-evidence-db, build-monitor, task-completed-gate
- Hooks registrados em settings.local.json (PreToolUse, PostToolUse)

### Docs & Scripts
- 5 cirrose-specific docs + 15 QA prompt templates (Gate 0/2/4)
- 4 universal docs → docs/aulas/ (design-principles, css-error-codes, pedagogy, hardening)
- 3 scripts evoluidos (gemini-qa3, content-research, qa-batch-screenshot)
- 5 scripts novos (browser-qa-act1, validate-css, qa-video, pre-commit, install-hooks)
- .gitignore: qa-screenshots/, qa-rounds/, index.html, .playwright-mcp/

## Sessao 34 — 2026-04-01 (self-improvement + INFO fixes)

### Robustness Fixes (I6-I12 do Codex review)
- I6: try/except em YAML loading (`config/loader.py`)
- I7: scheduler limits sync com rate_limits.yaml (50/250 vs hardcoded 10/50)
- I8: try/except em JSON parse (`smart_scheduler.py` budget + cache)
- I9: stop hook fallback se HANDOFF ausente (`stop-hygiene.sh`)
- I10: warn + fail em actions sem handler (`automation_agent.py`)
- I11: validacao de priority com fallback (`organization_agent.py`)
- I12: removidas 4 skills fantasma do `ecosystem.yaml`

### Self-Improvement
- Statusline: indicador context window % com cores (green/yellow/red)
- Memoria consolidada: defensive coding patterns, review findings 12/12 complete
- Teaching: explicacao dos 12 findings (XSS, path traversal, name drift, async, defensive patterns)

### Notion Organization
- Calendario DB: views Diario/Semanal/Mensal melhoradas (Categoria, Prioridade, Status)
- Tasks DB: triagem GTD — 2 Do Next, 11 Someday, 1 Done (Aula Cirrose 31/03)
- Tasks DB: calendar view criada (📅 Calendar)
- Eventos criados: Psicologo 11h (semanal), Profa Fernanda Hemato ICESP 14h

## Sessao 33 — 2026-03-31 (OAuth do Codex e Limpeza)

### Codex CLI
- Codex login: OAuth via ChatGPT (forced_login_method=chatgpt) — modelo GPT-5.4, $0
- Primeiro code review com Codex: 12 findings (5 WARN, 7 INFO) em 6 diretorios

### Security Fixes (via Codex review)
- Fix W1: XSS — `presenter.js` innerHTML → textContent
- Fix W2: Path traversal — `local_first.py` _safe_knowledge_path() com resolve + is_relative_to
- Fix W3: Path traversal — `run_eval.py` sanitiza skill_name com re.sub
- Fix W4: MCP name drift — sync mcp_safety.py + servers.json + testes com API real do Notion
- Fix W5: Async import — `presenter.js` import().then() em vez de assignment sincrono

### Docs
- `docs/CODEX-REVIEW-S33.md` — findings completos do primeiro Codex review

## Sessao 32 — 2026-03-31 (skill-debugging)

### Skills
- `systematic-debugging`: nova skill, 4 fases (root cause → padroes → hipotese → fix), adaptada de obra/superpowers (128K stars)
- Skills: 14 → 15

### Rules
- `anti-drift.md`: verification gate 5-step (cherry-pick superpowers verification-before-completion)

### Tooling
- `dream-skill` instalada (~/.claude/skills/dream/) — memory consolidation 4 fases, Stop hook global, auto-trigger 24h
- `@openai/codex` CLI v0.118.0 instalado globalmente (npm -g), autenticado (API key)
- `codex-plugin-cc` (openai) instalado — `/codex:review`, `/codex:adversarial-review`, `/codex:rescue`
- Global CLAUDE.md: Auto Dream trigger adicionado
- Global settings.json: dream Stop hook + codex marketplace

### Research
- Superpowers (128K stars): avaliado, cherry-picked debugging + verification
- GSD (32K stars): avaliado, descartado (dev workflow, nao organizacao)
- Notion Calendario + Tasks DB: mapeados (schema, views, data source IDs)
- Auto Dream (oficial Anthropic): rolling out mar/2026, behind feature flag

### Notion
- 3 compromissos criados no Calendario DB para 01/abr (Dr Fernanda ICESP, Psicologo 11h, OLMO skills+metanalise)

### Memory
- 3 novas memorias: notion-databases (reference), tooling-pipeline (project), metanalise-deadline (project)

## Sessao 31 — 2026-03-31

### Skills Audit (18 → 14)
- **3 merges**: ai-learning → continuous-learning, research → mbe-evidence, notion-knowledge-capture → notion-publisher
- **1 prune**: self-evolving removida (PDCA ja coberto por concurso e review)
- **12 migracoes**: instructions.md → SKILL.md (formato oficial Anthropic)
- Todas 14 skills com descriptions "pushy" (anti-undertrigger, trigger phrases PT-BR)
- Descoberta: skills com `instructions.md` nao carregavam no auto-trigger — so `SKILL.md` funciona

### Docs
- `ARCHITECTURE.md`: contagem atualizada (17 → 14 skills)

### Memory
- Atualizada `user_mentorship.md`: Opus mentor full-stack (dev, ML, AI, eng sistemas, gestao, orquestracao)

## Sessao 30 — 2026-03-31

### Skills
- `skill-creator`: substituido por versao oficial Anthropic (18 arquivos, repo anthropics/skills)
- `slide-authoring`: nova skill (65 linhas SKILL.md + references/patterns.md com 5 padroes HTML)
- Avaliadas e descartadas: 7 skills ui-ux-pro-max (irrelevantes para nosso stack deck.js)
- Avaliado claude-mem (44K stars): decisao de instalar em sessao dedicada futura

### Config
- `statusline.sh`: nome da sessao em magenta bold (destaque visual)
- `pyproject.toml`: ruff exclude para `.claude/skills/skill-creator/` (codigo externo)

### Memory
- Criado sistema de memoria persistente (MEMORY.md + 2 memorias: anti-sycophancy, mentorship)

## Sessao 29 — 2026-03-31

### Hooks
- Novo `hooks/stop-notify.sh`: beep 1200Hz + toast "Pronto" no evento Stop
- Todos os 3 hooks corrigidos para paths absolutos (CWD-independent)

### Docs Promovidos
- `decision-protocol.md` e `coautoria.md` promovidos de cirrose → `shared/`
- Cirrose originais viram redirects (tabela de artefatos preservada)

### Lessons Absorbed
- `slide-rules.md`: +E32, +§7 GSAP armadilhas, +§8 scaling arquitetura
- `ERROR-LOG.md` metanalise: 5 licoes herdadas do aulas-magnas

### Infra
- Repo renomeado: `organizacao1` → `LM` → `OLMO` (via `gh repo rename`)

### Cirrose — Feedback pós-aula (2026-03-31)
- Novo `cirrose/NOTES.md`: feedback da aula real
- Erro: indicação de albumina em HDA (albumina é SBP, não HDA)
- Tópico novo: coagulopatia no cirrótico (hemostasia rebalanceada, TEG/ROTEM, PVT)
- Pronúncia cACLD: letra por letra internacionalmente, DHCAc não é usado verbalmente no BR

### Legacy Cleanup
- `aulas-magnas` movido para `legacy/` (fora do repo)
- `wt-metanalise` movido para `legacy/` (worktree pruned)

### PENDENCIAS
- `Osteoporose` atualizado: agora em `legacy/aulas-magnas`

## Sessao 28 — 2026-03-31

### Metanalise Migration
- 18 slides + references + scripts migrados de wt-metanalise para `content/aulas/metanalise/`
- Paths corrigidos: `../../shared/` → `../shared/`
- Docs reescritos (CLAUDE.md, HANDOFF.md, NOTES.md, CHANGELOG.md, ERROR-LOG.md)
- Deleted: WT-OPERATING.md, AUDIT-VISUAL.md, HANDOFF-ARCHIVE.md (absorvidos)
- `package.json`: +`dev:metanalise` (port 4102), +`build:metanalise`

### CSS Architecture
- slide-rules.md: nova secao §1b (tokens + composicao livre, sem archetypes)
- Stack profissional: GSAP 3.14 (ja existia) + Lottie-web 5.13 + D3 7.9
- `base.css`: `@media (prefers-reduced-motion: reduce)` adicionado
- `presenter.js`: criado mas NAO integrado (precisa rewrite — HTML separado, timer fix)

### Doc Restructuring
- ECOSYSTEM.md deletado — conteudo unico absorvido no CLAUDE.md (Objectives + Tool Assignment)
- CHANGELOG.md: 382→50 linhas — sessoes 7b-24 movidas para `docs/CHANGELOG-archive.md`
- PENDENCIAS.md: separado setup/infra de backlog, items completados removidos
- ARCHITECTURE.md: skills list derivavel removida, agent system marcado como scaffold
- HANDOFF.md: items DONE removidos, sessao 28 atualizada
- 4 refs a ECOSYSTEM.md atualizadas (GETTING_STARTED, TREE, OBSIDIAN_CLI_PLAN, CLAUDE.md)

### Memories
- feedback_self_question: reflexao critica antes de implementar
- feedback_no_sycophancy: zero adulacao, analise critica antes de concordar

## Sessao 27 — 2026-03-29

### Tree Cleanup
- Deletada branch stale `refactor/monorepo-professional` (12 commits atras, 0 proprios)
- Removidos 5 stubs orfaos: `content/blog/`, `apps/api/`, `apps/web/`, `aulas/metanalise/`, `aulas/osteoporose/`
- Info migracao preservada em PENDENCIAS.md secao "Aulas Congeladas"

### Path Fix
- `03-Resources/` → `resources/` em 4 arquivos: `atualizar_tema.py`, `workflow_cirrose_ascite.py`, `workflows.yaml`, `workflow-mbe-opus-classificacao.md`
- `knowledge_organizer.py` mantido (PARA convention do Obsidian vault)

### Documentation
- Novo `docs/TREE.md`: mapa completo anotado da arvore do projeto
- `skills/__init__.py`: docstring clarifica `skills/` (runtime) vs `.claude/skills/` (slash commands)
- `CLAUDE.md`: secao Misc com cross-refs para skills/ e TREE.md

## Sessao 26 — 2026-03-29

### Hardening Documental
- Novo `docs/SYNC-NOTION-REPO.md`: protocolo Notion↔Repo (source of truth, collection IDs, workflows)
- `content/aulas/README.md` reescrito: 14 scripts mapeados, status por aula, grafo cross-refs, Notion
- See-also em 7 reference docs (CASE, narrative, evidence-db, must-read, archetypes, decision-protocol, coautoria)
- `CLAUDE.md` + `ECOSYSTEM.md` atualizados com referencia ao SYNC-NOTION-REPO

### Vite Safety
- `vite.config.js`: `strictPort: true`, porta removida (controlada por npm scripts)
- `package.json`: cirrose=4100, grade=4101, strictPort em todos os dev scripts
- Corrige problema de servidores fantasma ao rodar multiplos projetos Vite

## Sessao 25 — 2026-03-29

### Timeline Fix
- Concurso: nov/2026 → dez/2026 (7 ocorrencias: CLAUDE.md, ECOSYSTEM, ecosystem.yaml, ARCHITECTURE, skill concurso)
- Estudo: "foco total abril" → "foco total maio" (HANDOFF, PENDENCIAS)
- PENDENCIAS backlog: "Abr-Nov" → "Mai-Dez"
- Memory: project_concurso_timeline atualizada

### Docs Cleanup
- `docs/WORKFLOW_MBE.md` + `docs/PIPELINE_MBE_NOTION_OBSIDIAN.md`: `03-Resources/` → `resources/` (path stale desde sessao 21)
- Auditoria completa: 9 docs, 8 rules, 17 skills, 4 agents — tudo sincronizado
- Nenhum doc stale ou redundante encontrado

### Housekeeping
- HANDOFF.md: sessao 25 com estado atualizado + novo item (scripts Python path stale)
- Flagged: `atualizar_tema.py`, `knowledge_organizer.py`, `workflows.yaml` ainda referenciam `03-Resources/`

---
Sessoes anteriores (7b–24): `docs/CHANGELOG-archive.md`
