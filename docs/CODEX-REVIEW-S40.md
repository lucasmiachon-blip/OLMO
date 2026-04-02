# Codex Review S40 — Full Adversarial Review

> Data: 2026-04-01 | Modelo: GPT-5.4 (Codex CLI, OAuth $0)
> Revisor: Opus 4.6 (filtragem + verificacao)
> Escopo: 13 scripts, 3 CSS, 29 slides HTML, 7 agents, 11 rules, docs/prompts
> Chunks: 15 (C1-C15)

---

## Resumo

| Severidade | Count | Apos filtragem |
|------------|-------|----------------|
| CRITICAL | 12 | 7 (5 inline-opacity rebaixados a LOW) |
| HIGH | 69 | 68 (1 falso positivo: taskkill //) |
| MEDIUM | 36 | 36 |
| LOW | 18 | 24 (+5 rebaixados, +1 filtrado) |
| **Total** | **135** | **135** |

### Falsos positivos removidos
1. `process-hygiene.md` — `taskkill //PID` com `//` e correto em Git Bash (MSYS2 path expansion). Codex testou em CMD/PowerShell.

### Rebaixados
5x `style="opacity:0"` em cirrose HTML (02-a1-continuum, 03-a1-baveno): CRITICAL → LOW. Inline opacity:0 para GSAP init state e pragmatico e co-localizado. Regra "NUNCA inline" excessivamente rigida.

---

## Padroes Sistemicos (cross-cutting)

### S1. Font-size < 18px (13 instancias)
Presente em base.css, metanalise.css e cirrose.css. Tokens `--text-small` (14-16px) e `--text-caption` (11-14px) usados em conteudo projetado. Afeta legibilidade na TV 55" a 6m.
**Fix:** Audit completo de font-size. Minimo 18px no canvas 1280.

### S2. h2 generico em vez de asserção (11+ slides)
8/11 cirrose + 3 metanalise tem h2 como label ("Por que rastrear?", "Child-Pugh-Turcotte") em vez de claim clinica. Viola assertion-evidence paradigm.
**Fix:** Reescrever h2 como asserçoes. Decisao do Lucas slide por slide.

### S3. Print/PDF incompleto (3 instancias)
Elementos com opacity:0 (GSAP init, data-reveal, stagger children) nao tem override em @media print. PDF exportado tera conteudo invisivel.
**Fix:** Extender print reset para cobrir `[data-animate="stagger"] > *`, `[data-reveal]`, e elementos custom GSAP-hidden.

### S4. GSAP jurisdiction — CSS per-slide (7 instancias)
CSS per-slide seta opacity/transform customizados que GSAP tambem controla. Conflito de ownership. O failsafe global (`[data-animate] { opacity: 0 }`) e correto; o per-slide nao.
**Fix:** Mover init states customizados para GSAP from/fromTo.

### S5. Stale monorepo paths em rules (4 rules)
design-reference.md, slide-rules.md, qa-engineer.md, quality-gate.md referenciam paths pre-monorepo.
**Fix:** Batch update de paths.

### S6. Governance contradictions (4 instancias CRITICAL)
qa-engineer threshold impossivel, mcp_safety auto-execute vs human gate, slide-rules data-background-color, qa-engineer tools nao-permitidos.
**Fix:** Resolver contradicoes individualmente.

---

## Scripts (C1-C6) — 47 findings

### CRITICAL (3)

| # | File:Line | Issue | Fix |
|---|-----------|-------|-----|
| 1 | qa-batch-screenshot.mjs:91 | Windows file URL: `file://C:/` em vez de `file:///C:/`. Quebra import do manifest no Windows. | Usar `pathToFileURL()` |
| 2 | content-research.mjs:690 | Resposta Gemini vazia/bloqueada salva como sucesso com `'(empty response)'` | Validar candidates e finish reason antes de salvar |
| 3 | export-pdf.js:57 | Vite preview sem `--strictPort`. Se porta 4173 ocupada, PDF gerado do servidor errado ou antigo. | Adicionar `--strictPort` |

### HIGH (17)

| # | File:Line | Issue |
|---|-----------|-------|
| 4 | gemini-qa3.mjs:543,661,702,868,1045 | API key em query string da URL (exposta em logs, proxies) |
| 5 | gemini-qa3.mjs:1066-1070 | Gate 4 bypass via --force-gate4 apos Gate 0 FAIL |
| 6 | gemini-qa3.mjs:1075-1078 | Gate 4 roda sem gate0.json (so warn, nao bloqueia) |
| 7 | qa-batch-screenshot.mjs:327-331 | process.exit(1) pula finally — Playwright nao fecha |
| 8 | qa-batch-screenshot.mjs:73-77 | --act invalido produz manifest vazio com allPass:true |
| 9 | browser-qa-act1.mjs:42,46 | process.cwd() para paths — quebra se invocado de outro dir |
| 10 | browser-qa-act1.mjs:133 | Browser leak: sem try/finally no Playwright |
| 11 | lint-gsap-css-race.mjs:187 | parseJsFile error path omite directStyles → crash no caller |
| 12 | lint-slides.js:105 | `file.includes('content/aulas/')` com forward slash — GSAP rule desabilitada no Windows |
| 13 | lint-case-sync.js:109 | Brace parser nao e string/comment-aware |
| 14 | lint-case-sync.js:182 | Bidirectional check incompleto (so CASE→manifest, nao manifest→CASE) |
| 15 | export-pdf.js:57 | Windows: server.kill() so mata wrapper, nao process tree |
| 16 | install-fonts.js:121 | Sai 0 mesmo com download failures |
| 17 | install-fonts.js:27 | Arquivo zero-byte aceito como valido (skip re-download) |
| 18 | qa-video.js:55 | grade mapeado para Reveal.js mas usa deck.js — timeout garantido |
| 19 | qa-video.js:54 | Porta fixa 4100 para todas as aulas — metanalise usa 4102 |
| 20 | content-research.mjs:44-46 | getArg() aceita flags como valores (--slide --prompt-only) |

### MEDIUM (21)

| # | File:Line | Issue |
|---|-----------|-------|
| 21 | gemini-qa3.mjs:47-55 | modelCost() fallback silencioso para modelo desconhecido |
| 22 | gemini-qa3.mjs:686 | upload response sem guard (result.file) |
| 23 | gemini-qa3.mjs:702 | waitForProcessing usa fetch raw, nao fetchWithRetry |
| 24 | gemini-qa3.mjs:879 | Promise.all sem per-response try/catch |
| 25 | browser-qa-act1.mjs:46 | Manifest loading via regex scrape (fragil) |
| 26 | browser-qa-act1.mjs:47 | Missing manifest = null, desabilita check silenciosamente |
| 27 | lint-gsap-css-race.mjs:278 | CSS file missing = false PASS |
| 28 | lint-gsap-css-race.mjs:341 | Multi-line CSS selector parsing incorreto |
| 29 | lint-gsap-css-race.mjs:399 | Conflict detection ignora scope/slide |
| 30 | lint-gsap-css-race.mjs:203 | filter ausente no direct-style regex |
| 31 | lint-narrative-sync.js:129 | Sync unidirecional (manifest→narrative, nao inverse) |
| 32 | lint-slides.js:59 | Multi-line aside detection fails |
| 33 | lint-slides.js:233 | Shared CSS walked twice |
| 34 | done-gate.js:190 | Notes detector rigid (`<aside class="notes">` exato) |
| 35 | install-fonts.js:111 | Sem content-type validation no download |
| 36 | qa-accessibility.js:54 | Section count vs notes count — falso positivo em vertical stacks |
| 37 | qa-video.js:223 | process.exit(1) pula cleanup (video-tmp, browser) |
| 38 | install-hooks.sh:33,45 | Hooks no-op (pre-push.sh, post-merge.sh nao existem) |
| 39 | validate-css.sh:48 | cirrose.css escaneado 2x quando aula=cirrose |
| 40 | content-research.mjs:678 | Metadata reporta thinkingLevel errado apos fallback |
| 41 | lint-narrative-sync.js:186 | Zero-based index em mensagens de erro |

### LOW (6)

| # | File:Line | Issue |
|---|-----------|-------|
| 42 | gemini-qa3.mjs:1045 | Upload cleanup delete silencioso |
| 43 | gemini-qa3.mjs:1065 | gate0.json parse sem try/catch |
| 44 | lint-gsap-css-race.mjs:39 | JS scan scope hardcoded (4 files) |
| 45 | lint-gsap-css-race.mjs:46 | CSS scan scope hardcoded (1 file) |
| 46 | content-research.mjs:765 | thinkingLevel metadata wrong after fallback |
| 47 | lint-narrative-sync.js:186 | Off-by-one in error messages |

---

## CSS (C7-C10) — 35 findings

### HIGH (21)

| # | File:Line | Issue |
|---|-----------|-------|
| 48 | base.css:70 | --danger hue=25 chroma=0.18 — viola constraint (hue≤10, chroma≥0.20) |
| 49 | base.css:133 | @supports not fallback incompleto (--bg-black, shadows, overlay-border) |
| 50 | base.css:254 | .stage-c nao remapeia tokens usados por utility classes |
| 51 | base.css:115 | --text-caption 11px, abaixo do minimo 18px |
| 52 | base.css:319 | .source-tag clamp(10px, 0.55vw, 11px) abaixo do minimo |
| 53 | base.css:604 | Print reset nao cobre stagger children |
| 54 | metanalise.css:166 | GSAP jurisdiction: CSS seta opacity/transform em hook elements |
| 55 | metanalise.css:625 | GSAP jurisdiction: s-contrato cards |
| 56 | metanalise.css:645 | GSAP jurisdiction: checkpoint hidden elements |
| 57 | metanalise.css:669 | Dark-slide token restoration incompleta (--ui-accent-on-dark) |
| 58 | metanalise.css:780 | .ck1-axis 10px — ilegivel em projecao |
| 59 | metanalise.css:806 | .ck1-name 12px — ilegivel em projecao |
| 60 | cirrose.css:1614 | s-hook dark-bg sem token restoration (8 tokens) |
| 61 | cirrose.css:2806 | Sem .no-js fallback para [data-reveal] |
| 62 | cirrose.css:1704 | Print override incompleto (GSAP-hidden elements) |
| 63 | cirrose.css:114-115 | --text-small 14px, --text-caption 11px em conteudo projetado |
| 64 | cirrose.css:1029-1248 | Sub-18px explicitos: title-affiliation 12-16px, metric-label 14px, rec-source 12px |
| 65 | cirrose.css:55-76 | *-light tokens 15% color-mix achromatic (design-reference §4 unsafe) |
| 66 | cirrose.css:449-461 | @media print parcial (MELD cards, Rule-of-5 nao cobertos) |
| 67 | base.css:347 | GSAP jurisdiction: global fadeUp/stagger CSS seta transform (nota: failsafe pattern — verificar se intencional) |
| 68 | cirrose.css:69-72 | --danger token diverge entre cirrose e base.css (shadow silencioso) |

### MEDIUM (9)

| # | File:Line | Issue |
|---|-----------|-------|
| 69 | base.css:305 | #deck p max-width:56ch — specificity trap para child sheets |
| 70 | metanalise.css:23 | --text-small: 16px abaixo de 18px |
| 71 | metanalise.css:24 | --text-caption: 14px abaixo de 18px |
| 72 | metanalise.css:224 | .hook-tag 12px |
| 73 | metanalise.css:612 | .contrato-skill 12px |
| 74 | cirrose.css:1642 | Double panel-offset compensation no hook |
| 75 | cirrose.css:3097 | Hover overrides active state em .pcalc-tab |
| 76 | cirrose.css:3124 | Hover overrides active state em .pcalc-sex-btn |
| 77 | cirrose.css:828-838 | Raw oklch() sem HEX fallback |

### LOW (5)

| # | File:Line | Issue |
|---|-----------|-------|
| 78 | metanalise.css:33 | Dead override ::before/::after em .slide-inner |
| 79 | cirrose.css:2545 | .no-js fallback redundante para .guideline-rec (nao hidden) |
| 80 | cirrose.css:2425 | .no-js fallback redundante para .fib4-flags (nao hidden) |
| 81 | cirrose.css:510-518 | Specificity escalation em .source-tag |
| 82 | cirrose.css:145 | --danger token divergencia local vs shared |

---

## HTML (C11-C13) — 37 findings

### CRITICAL → LOW (rebaixados, 5)

| # | File:slide | Issue |
|---|------------|-------|
| 83 | 02-a1-continuum:21,34,53 | inline style="opacity:0" (3x) — rebaixado: pragmatico para GSAP init |
| 84 | 03-a1-baveno:26,44 | inline style="opacity:0" (2x) — rebaixado |

### HIGH (22)

| # | File:slide | Issue |
|---|------------|-------|
| 85 | s-hook (metanalise) | h2 "Por que isso importa" — label generico |
| 86 | s-contrato | h2 "3 perguntas..." — label generico |
| 87 | s-checkpoint-2 | Sem h2 nenhum |
| 88 | s-heterogeneity (F2) | Referencia artigos especificos (viola regra F2=generico) |
| 89 | s-absoluto (F3) | Nao referencia Valgimigli 2025 como exigido |
| 90 | s-takehome (F3) | Nao referencia Valgimigli 2025 como exigido |
| 91 | 00-title (cirrose) | id="s-title" nao segue s-{act}-{name} |
| 92 | 00-title | Notes sem [DATA] marker |
| 93 | 01-hook (cirrose) | id="s-hook" nao segue s-{act}-{name} |
| 94 | 01-hook | Notes sem [DATA] marker |
| 95 | 01-hook | Dados medicos sem fonte (IMC 31, labs, etc) |
| 96 | 02-a1-continuum | h2 "Por que rastrear?" — pergunta, nao asserçao |
| 97 | 02b-a1-cpt | h2 "Child-Pugh-Turcotte" — label generico |
| 98 | 02b-a1-cpt | kappa≤0.41 com [TBD — PMID nao localizado] |
| 99 | 02c-a1-classify | h2 "Estadiamento x Prognostico" — label |
| 100 | 03b-a1-fib4 | h2 "Modelos Preditivos: FIB-4" — label |
| 101 | 03b-a1-fib4 | 30-60% zona cinza [TBD — verificar fonte primaria] |
| 102 | 03c-a1-elasto | h2 "Fibroscan, MRE e outros metodos..." — label |
| 103 | 03c-a1-elasto | (~3x menor) sem fonte |
| 104 | 03d-a1-rule5 | h2 "Rule of Five" — label |
| 105 | 04-a1-meld | h2 "MELD: historia, importancia e evolucoes" — label |
| 106 | 07-cp1 | MELD 14 no slide vs MELD 10 em notes — contradictorio |

### MEDIUM (4)

| # | File:slide | Issue |
|---|------------|-------|
| 107 | s-aplicacao | Notes com claims clinicas sem fonte |
| 108 | s-aplicabilidade | Notes com claims sem fonte (CYP2C19, ACC editorial) |
| 109 | 01-hook (cirrose) | h3 sem h2 (heading hierarchy skip) |
| 110 | 03c-a1-elasto | PMID 39649032 nao verificado |

### LOW (6)

| # | File:slide | Issue |
|---|------------|-------|
| 111 | s-takehome | h2 "Tres perguntas..." — recap label |
| 112-116 | s-forest-plot | 5x anatomy symbols sem aria-hidden="true" |
| 117 | 07-cp1 | id="s-cp1" nao segue s-{act}-{name} |

---

## Agents + Rules (C14) — 16 findings

### CRITICAL (4)

| # | File | Issue |
|---|------|-------|
| 118 | qa-engineer.md vs qa-pipeline.md | Threshold ALL 14≥9/10 vs "6-8 se bem feita, 9=excepcional" |
| 119 | qa-engineer.md vs settings.local.json | Tools requeridas nao estao no allowlist |
| 120 | mcp_safety.md | "aprovacao humana" vs "confidence≥0.95 auto-execute" |
| 121 | slide-rules.md | data-background-color permitido como exceçao + "atributo morto" |

### HIGH (8)

| # | File | Issue |
|---|------|-------|
| 122 | medical-researcher.md vs anti-drift.md | "Proactively use" vs "exactly what requested" |
| 123 | medical-researcher.md vs efficiency.md | "search ALL MCPs" vs budget discipline |
| 124 | medical-researcher.md | VERIFIED overloaded (source verification + claim corroboration) |
| 125 | qa-engineer.md | Stale paths (AUDIT-VISUAL.md, slide-pedagogy.md) |
| 126 | quality-gate.md vs quality.md | Type hints scope mismatch |
| 127 | design-reference.md | Stale pre-monorepo paths |
| 128 | session-hygiene.md | Trigger conditions contraditorias |
| 129 | slide-rules.md | Stale paths |

### MEDIUM (2)

| # | File | Issue |
|---|------|-------|
| 130 | efficiency.md | Manda BudgetTracker que nao existe |
| 131 | notion-cross-validation.md | ChatGPT como hard dependency sem fallback |

### LOW (1)

| # | File | Issue |
|---|------|-------|
| 132 | coauthorship.md | Git trailer format invalido |

---

## Docs/Prompts (C15) — 12 findings

> Relançado S41 via `codex exec --sandbox read-only` (stdin pipe). Bug do skill wrapper contornado.

### CRITICAL (1)

| # | File | Issue | Fix |
|---|------|-------|-----|
| 133 | evidence-db.md (metanalise) | Murad et al JAMA 2014: PMID 25005654 resolve para outro artigo (doc auto-reconhece). Fonte canônica inválida. | Verificar PMID correto ou marcar [TBD]. Não usar em slide até validação. |

### HIGH (7)

| # | File | Issue |
|---|------|-------|
| 134 | blueprint.md + narrative.md (metanalise) | GRADE numeração: slide 14 diz "valida pergunta 2", mas GRADE é pergunta 3 no takehome |
| 135 | blueprint.md (metanalise) | Slide numbers desalinhados com filenames (Slide 05→04-pico.html, etc.) |
| 136 | archetypes.md + regras metanalise | Forest plot: regra exige "crop de artigo real, NUNCA SVG", mas archetype descreve grid Unicode e slide 07 está ✅ FEITO |
| 137 | gate2-opus-visual.md | Mistura "avaliar SOMENTE visual, ZERO código" com "UI/UX + análise de código" no mesmo doc |
| 138 | gate2-opus-visual.md | Contaminação de audiência: alterna Cirrose (hepatologistas) e Metanalise (residentes CM) |
| 139 | narrative.md + evidence-db.md (cirrose) | Recompensação alcoólica: narrative A3-04 "[TBD SOURCE]" mas evidence-db já tem Semmler 2023 PMID 37469291 |
| 140 | evidence-db.md (cirrose) | CCM Ann Saudi Med 2025 prevalência 48%: [TBD — buscar PMID]. Dado quantitativo sem rastreabilidade |
| 141 | evidence-db.md (cirrose) | s-a2-09 sarcopenia: [TBD SOURCE]. Slide ancorado em evidência não citável |

### MEDIUM (2)

| # | File | Issue |
|---|------|-------|
| 142 | gate2-opus-visual.md | Refs a tools/APIs inexistentes: sharp create_session_by_path, a11y test_html_string |
| 143 | blueprint.md (metanalise) | Terminology drift: mesmo slide = s-hook / 01-hook.html / Slide 01 sem mapeamento canônico |

### LOW (1)

| # | File | Issue |
|---|------|-------|
| 144 | narrative.md + blueprint.md | Blueprint derivado de narrative v2.4, mas narrative está em v2.5 |

---

## Plano de Implementacao

### P0 — Fix Now (silent failures, data corruption)
1. **#1** qa-batch-screenshot.mjs: pathToFileURL() para Windows
2. **#2** content-research.mjs: validar Gemini response antes de salvar
3. **#3** export-pdf.js: --strictPort
4. **#12** lint-slides.js: normalizar path separators para Windows
5. **#106** s-cp1: reconciliar MELD 14 vs MELD 10

### P1 — Governance (contradictions that cause drift)
6. **#118** qa-engineer threshold: ship threshold realista (ex: 7/10)
7. **#119** qa-engineer tools: alinhar com allowlist
8. **#120** mcp_safety: remover auto-execute para writes
9. **#121** slide-rules: resolver data-background-color
10. **S5** Batch update stale monorepo paths em 4 rules

### P2 — Quality (font-size audit, print, GSAP jurisdiction)
11. **S1** Font-size audit completo: minimo 18px no canvas
12. **S3** Print/PDF reset completo
13. **S4** GSAP jurisdiction: mover per-slide init states para JS
14. **#61** cirrose [data-reveal] .no-js fallback
15. Dark-slide token restoration (#57, #60)

### P3 — Polish (LOW findings, edge cases)
16. Script hardening: getArg validation, try/finally Playwright, install-fonts exit code
17. Lint improvements: multi-line aside, bidirectional checks, scope-aware detection
18. HTML: aria-hidden em symbols, heading hierarchy, notes [DATA] markers
19. h2 assertion-evidence rewrite (11+ slides) — Lucas guia, slide por slide

---

Coautoria: Lucas + Opus 4.6 + GPT-5.4 (Codex) | 2026-04-01
