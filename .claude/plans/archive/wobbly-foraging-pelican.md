# Plan — Slides_build · s-quality content + QA visual (S262)

> Session name: `Slides_build` (Lucas turn 2)
> Plan mode até ExitPlanMode aprovado.

## Context

Lucas direcionou a sessão em três turnos:
- Turn 1: "Vamos fazer slides depois migramos tentamos migra o mjs" → slides primeiro, S262 mjs migration deferred.
- Turn 3 (interrupt): "eles estao visual e contraste que pode ser melhorara, eu quero que tenha mais animacoes, e um pouco mais de sconteudo e ele tem que ter mais coerencia com o resto, incorporar css e js moderno aos poucos" + "abra o vite antes de entrar em plan".
- Turn 5 (interrupt): "calma um slide por vez. comecar com conteudo e QA visual de slide quality".

Escopo final desta sessão: **só s-quality (slide 5)** — conteúdo audit + QA pipeline (preflight → inspect → editorial). Demais slides + visual evolution (heterogeneity/fixed-random) + mjs migration ficam para sessões seguintes.

### Pre-condition state (verificado read-only nesta phase)
- S260 heterogeneity-evolve uncommitted: 5 files modificados (`slides/09a-heterogeneity.html`, `slides/10-fixed-random.html`, `slides/_manifest.js`, `evidence/s-heterogeneity.html`, `metanalise/HANDOFF.md`) + `.slide-integrity` recomputado.
- Index.html já sincronizado (grep empírico: 1 ocorrência da headline nova "Mesmo I² = 67%", 0 ocorrências da OLD "Dois forest plots com I² de 67%"). Pending-fix flag stale — confirmar com build idempotente.
- s-quality state: LINT-PASS desde S259 commit `80645da` (v2 rebuild — 3 cards isomórficos + dissociation panel 52% Alvarenga-Brant 2024). Ready para preflight.
- Vite NÃO está rodando (Lucas pediu abrir antes do work substantivo).

### KBP-44 candidate flag (para Phase 1)
Linha 59 do slide tem PMID inline:
```html
<p class="term-stat-source">Alvarenga-Brant 2024 · PMID 39003480 · BMC Oral Health</p>
```
KBP-44 (formalizado S261): "Source-tags em slides com PMID — PMID exclusivo do evidence HTML". `term-stat-source` é classe diferente de `source-tag`, mas o spirit aplica. Lucas decide na Phase 1 se remove ou mantém.

---

## Phases

### Phase 0 — Setup (commit S260 batch + abrir vite)

Sequência (EC loop visível para cada Bash):

0.1. `git fetch && git status` (KBP-40 staleness check; KBP-25 cross-window protocol)
0.2. `git branch --show-current` (confirmar `main`)
0.3. `npm run build:metanalise` (idempotente — confirma index.html sincronizado; se diff aparecer, re-stage)
0.4. `git add` específico (NUNCA `-A`):
   - `content/aulas/metanalise/slides/09a-heterogeneity.html`
   - `content/aulas/metanalise/slides/10-fixed-random.html`
   - `content/aulas/metanalise/slides/_manifest.js`
   - `content/aulas/metanalise/evidence/s-heterogeneity.html`
   - `content/aulas/metanalise/HANDOFF.md`
   - `content/aulas/metanalise/.slide-integrity`
0.5. `git commit` batch S260 — mensagem proposta:
   ```
   feat(metanalise/S260): heterogeneity-evolve C1+C2+D — slides reformulados pedagogicamente

   - s-heterogeneity (09a): h2 "Mesmo I² = 67%, dois cenários clínicos opostos";
     verdicts explicitam concordância vs divergência clínica; analogia "auscultar sopro";
     remove jargão "proporção da variação" + "não é acaso".
   - s-fixed-random (10): h2 "Mesmos dados, dois modelos, duas conclusões";
     premissa do mundo (não mecânica de pesos); regra prática residente.
   - _manifest.js: 2 headlines atualizadas (sync com slides).
   - evidence/s-heterogeneity.html: nova seção #estrategias-didaticas (4 abordagens NLM
     ancoradas Borenstein 2021 Cap. 20) + 3 refs validadas + 2 gaps RESOLVIDO.
   - .slide-integrity hashes recomputados.
   - HANDOFF metanalise: S260 entry documentado.

   Detalhes: CHANGELOG §S260. KBP-44 candidate (PMID-em-slide).
   ```
0.6. `git status` post-commit (confirmar working tree clean exceto untracked plans)
0.7. **Abrir vite background:** `npm run dev:metanalise` em background (porta 4102)
0.8. Lucas confirma vite OK + slide 5 (s-quality) carrega no browser → unlock Phase 1

### Phase 1 — Audit completo s-quality (read-only)

Sem Edit nesta phase. Output = inventário estruturado de adições/melhorias por categoria.

1.1. Read `content/aulas/metanalise/slides/05-quality.html` (65 li — já lido na exploração)
1.2. Read `content/aulas/metanalise/evidence/s-quality-grade-rob.html` (507 li — limit 100 primeiro, expand targeted via Grep)
1.3. Read `content/aulas/metanalise/slide-registry.js` (entry `s-quality` — animações 4 beats CLT-driven S259)
1.4. Read `content/aulas/metanalise/metanalise.css` lines 334-475 (`section#s-quality`)
1.5. Read `content/aulas/metanalise/shared-bridge.css` (s-quality opt-in 4º slide-laboratório — confirmar tokens v2 wired)
1.6. Read `content/aulas/metanalise/slides/14-etd.html` (canônico shared-v2) — referência de coerência
1.7. Lucas browser visual review (vite porta 4102) — captura impressões reais
1.8. **Output a Lucas — inventário 5 categorias** (Lucas turn 3):
   - **Conteúdo (adições):** o que pode ser adicionado dentro da CLT (residentes iniciantes) — exemplos concretos do evidence ainda não no slide, frasing mais clara, dissociation expansion
   - **Visual + contraste:** APCA Lc atual vs target (≥75 dark / ≥60 light), palette gaps, hierarchy, tipografia
   - **Animações:** reveals adicionais, microinteractions, choreography (vs s-etd canônico)
   - **Coerência com canônico:** s-etd patterns ausentes (theme-dark? subgrid? `<cite>`? color-mix?)
   - **CSS/JS moderno gradual:** subgrid, `:has()`, `color-mix(in oklch)`, logical properties, anchor positioning, `@scope`/`@container` (se aplicável)
   - **KBP-44 PMID flag:** line 59 `<p class="term-stat-source">…PMID 39003480…</p>` — remove ou keep?
1.9. Lucas decide:
   - Quais adições de conteúdo aprovar (Phase 2 mandatória)
   - Quais melhorias visuais/animação aprovar (Phase 3 opcional)
   - O que deferir para sessões futuras

### Phase 2 — Adição de conteúdo (mandatória, Lucas turn 6: "primeiro tem a faze de adicicao de conteudo")

Foco: enriquecer o slide com material do evidence/research que ainda não está no slide. Princípio CLT — adicionar sem overload working memory residente iniciante.

Sub-ciclo per adição (anti-batch — 1 adição por ciclo, Lucas OK entre cada):

2.1. **Propose-before-pour:** apresentar a adição específica (texto exato + posição no slide + EC loop)
2.2. **EC loop visível:**
   ```
   [EC] Verificacao: <what I read/checked no evidence + slide>
   [EC] Mudanca: <1 sentence>
   [EC] Elite: <(1) por que esta adição é melhor que alternativas (incluir vs deferir vs reformular),
                (2) o que profissional faria diferente — actionable per KBP-37>
   ```
2.3. Lucas approve → Edit (HTML primário; CSS só se layout exige)
2.4. `npm run lint:slides` (zero errors)
2.5. `bash content/aulas/scripts/validate-css.sh` PASS
2.6. `npm run build:metanalise` PASS
2.7. Vite browser visual — Lucas valida que adição não quebra hierarchy nem CLT
2.8. Loop: próxima adição OU avançar para Phase 3

### Phase 3 — Evolução visual + animações + CSS/JS moderno (opcional, sub-ciclo idêntico Phase 2)

Foco: as 4 dimensões restantes Lucas turn 3 (visual/contraste, animações, coerência canônico, CSS/JS moderno). **Strangler fig** — incorporar gradual, não big-bang.

Per melhoria:
3.1. Propose-before-pour + EC loop (idem Phase 2)
3.2. Edit HTML/CSS/slide-registry.js conforme escopo
3.3. Lint + validate-css + build PASS
3.4. APCA audit se touching contraste: `node content/aulas/scripts/apca-audit.mjs --aula metanalise`
3.5. Vite browser visual — Lucas valida
3.6. Loop OU avançar para Phase 4

### Phase 4 — QA pipeline gemini-qa3 (1 slide, 3 gates separados)

Per `.claude/rules/qa-pipeline.md`: NEVER batch QA. Lucas OK entre cada gate.

4.1. **Preflight ($0, dims objetivas):**
   ```
   node content/aulas/scripts/gemini-qa3.mjs --aula metanalise --slide s-quality --preflight
   ```
   - Verifica: h2 asserção + 0 vw/vh font-size + tokens em todos values + fonts Tier 1
   - Apresentar output a Lucas
   - **[Lucas OK]** explícito antes de 4.2

4.2. **Inspect (Gemini Flash, defect inspector):**
   ```
   node content/aulas/scripts/gemini-qa3.mjs --aula metanalise --slide s-quality --inspect
   ```
   - Score esperado ≥ 7 (medical GSAP rubric ceiling 6-8 per E069)
   - Apresentar output a Lucas
   - **Se score < 7: checkpoint Lucas obrigatório** (qa-pipeline.md threshold)
   - **[Lucas OK]** explícito antes de 4.3

4.3. **Editorial (Gemini Pro, creative review):**
   ```
   node content/aulas/scripts/gemini-qa3.mjs --aula metanalise --slide s-quality --editorial --round N
   ```
   - Round N a confirmar (ler `qa-screenshots/s-quality/` ou `metrics.json` para histórico)
   - Apresentar output a Lucas
   - **[Lucas approved]** → estado DONE

### Phase 5 — Close + commit final

5.1. Edit `content/aulas/metanalise/HANDOFF.md`: linha s-quality `LINT-PASS → DONE` (Edit minimal section, NÃO rewrite — anti-drift §State files)
5.2. Edit `CHANGELOG.md` raiz: append S262 entry — 1 line per commit + ≤5 li aprendizados (anti-drift §Session docs)
5.3. Edit `HANDOFF.md` raiz: atualizar P0 carryover (s-quality DONE; outros slides pendentes; mjs migration próximo)
5.4. `git add` files atualizados + `git commit`:
   ```
   chore(metanalise/S262): s-quality content + QA editorial DONE
   ```

---

## Out-of-scope (deferred — sessões futuras)

- s-heterogeneity / s-fixed-random visual evolution (5 dims Lucas turn 3: contraste, animações, conteúdo, coerência, CSS/JS moderno)
- s-absoluto + outros 12 LINT-PASS slides
- S262 P0 main: mjs → agents migration (`.claude/plans/S262-research-mjs-additive-migration.md`)
- P1 cleanup carryover: specialty cleanup (8 lines em `immutable-gliding-galaxy.md`) + tone propagation per-agent (16 `.claude/agents/*.md`)
- R3 Clínica Médica prep (217 dias)

---

## Critical files (modify)

- `content/aulas/metanalise/slides/05-quality.html` (apenas se Phase 2 ativa)
- `content/aulas/metanalise/metanalise.css` (lines 334-475 — `section#s-quality` SÓ — apenas se Phase 2)
- `content/aulas/metanalise/HANDOFF.md` (Phase 4)
- `CHANGELOG.md` (Phase 4)
- `HANDOFF.md` raiz (Phase 4)

## Read-only references

- `content/aulas/metanalise/evidence/s-quality-grade-rob.html` (Phase 1.2)
- `content/aulas/metanalise/slide-registry.js` (Phase 1.3)
- `content/aulas/metanalise/shared-bridge.css` (Phase 1.5)
- `content/aulas/metanalise/qa-screenshots/s-quality/content-research.md` (deep research 19 PMIDs verified — context)
- `content/aulas/metanalise/qa-screenshots/s-quality/metrics.json` (round N history)
- `content/aulas/scripts/gemini-qa3.mjs` (script QA — script primacy)
- `.claude/rules/qa-pipeline.md` (state machine + 4 gates)
- `.claude/rules/slide-rules.md` (h2, CSS, errors)
- `.claude/rules/design-reference.md` (color, typography, medical data)
- `content/aulas/metanalise/CLAUDE.md` (escopo, ancora, hard constraints)

---

## Verification end-to-end

| Gate | Comando | Pass criterion |
|---|---|---|
| Build | `npm run build:metanalise` | exit 0, index.html sincronizado |
| Lint | `npm run lint:slides` | zero errors |
| CSS validate | `bash content/aulas/scripts/validate-css.sh` | PASS |
| Preflight | `gemini-qa3 --preflight` | dims objetivas pass ($0) |
| Inspect | `gemini-qa3 --inspect` | score ≥ 7 (Lucas review) |
| Editorial | `gemini-qa3 --editorial --round N` | Lucas approved |
| Visual | Vite porta 4102 | Lucas browser review per Edit |

---

## Anti-drift guards (ativos)

- **KBP-05** anti-batch QA — 1 slide por ciclo, 1 gate por invocação
- **KBP-22** silent execution — EC loop visível antes de cada Edit
- **KBP-25** Edit precision — Read full ± 20 li antes de cada Edit (whitespace literal)
- **KBP-32** spot-check token names em `shared-bridge.css` antes de usar `var(--v2-*)`
- **KBP-37** "Elite faria diferente" actionable (cost/value claro ou gate-justified defer)
- **KBP-40** branch awareness — `git branch --show-current` antes de cada commit
- **KBP-44** PMID-em-slide candidate (line 59 `term-stat-source`) — Phase 1 flag
- **Lucas OK entre gates** — KBP-05 + qa-pipeline.md
- **Propose-before-pour** — Phase 2 não inicia sem approval do gap específico
- **State files Edit minimal section** (HANDOFF/CHANGELOG não rewrite com Write)
- **Plan mode** discipline até ExitPlanMode

---

## Session-name action (Phase 0.0, antes do resto)

Lucas escolheu `Slides_build`. Phase 0.0:
```
echo -n "Slides_build" > .claude/.session-name
```

(Cobre obrigação SessionStart + status line update.)

---

Coautoria: Lucas + Opus 4.7 (Claude Code) | S262 s-quality content + QA visual | 2026-04-27
