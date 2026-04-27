# Plano S259 orq — reformular `s-quality` (warm-snacking-hinton)

> **Sessão orquestrador S259** (date 2026-04-26). Worker (outra janela): `jazzy-sniffing-rabbit.md` — heterogeneity-evolve. Plan mode até ExitPlanMode.

## Context

**Trigger:** Lucas mesmo apresentou `s-quality` em aula real e plateia não assimilou. Score subjetivo 4/10. Próprio Lucas reporta "não consegui entender" (auto-feedback raro = sinal forte).

**Conceitos canônicos a passar** (screenshot `Screenshot 2026-04-26 194628.png` — tabela Pollock-style 3 termos):

| Termo | Definição (best-practice) | Alt. usado (errado) | Tool |
|---|---|---|---|
| **Quality** | Extensão em que a RS foi conduzida segundo best practice | Às vezes intercambiado com RoB ou Certainty | AMSTAR / ROBIS |
| **RoB** | Potencial de erros sistemáticos em desenho/condução/reporting de **estudos individuais** distorcendo o efeito | Às vezes específico para Cochrane RoB tool em RCTs | Cochrane RoB / RoB 2 / ROBINS-I |
| **Certainty** | Confiança que efeitos reportados refletem efeito verdadeiro **através do corpo de evidência** | Usado menos que os outros | GRADE |

**Ortogonalidade:** os 3 medem **objetos diferentes** (revisão / estudo / corpo). Confundir = decisão clínica errada.

**Estado atual** (`slides/05-quality.html`, 47 li):
- 3 níveis numerados verticalmente (Estudo / Revisão / Evidência)
- 3 cards row layout
- Punchline scenario: "Processo ✓ Alta + Estudos ✓ Baixo risco → Certeza ✕ Muito baixa"
- Source: Shea 2017 · GRADE WG 2004 · Sterne 2019

**Evidence completo** (`evidence/s-quality-grade-rob.html`, 507 li, 19 PMIDs verified):
- Framework 3 níveis + tabelas de cada ferramenta + concepções errôneas + cenários + dados empíricos (Alvarenga-Brant 52% AMSTAR-High → GRADE Very-Low)
- Já contém TUDO necessário — slide é destilação visual

## Diagnóstico (por que não comunicou)

| # | Hipótese | Evidência | Fix proposto |
|---|---|---|---|
| 1 | Numeração 1/2/3 sugere hierarquia/sequência | quality-num--study/process/evidence em row vertical | Layout 3 colunas paralelas (ortogonal visual) |
| 2 | Headlines são perguntas longas | "Quanta certeza no resultado combinado?" não casa com "GRADE" instantaneamente | TERM em destaque + 1-line def |
| 3 | Falta frase-âncora "sinônimos enganadores" | h2 atual diz "qualidade não garante certeza" mas não nomeia os 3 termos | h2 reframe: "Quality, RoB e Certainty medem coisas diferentes" |
| 4 | Punchline opaco | "Processo ✓ + Estudos ✓ → Certeza ✕" — residente não sabe o que é "Processo" naquele contexto | Punchline com NOMES + número empírico (Alvarenga-Brant 52%) |
| 5 | Coluna "alt. erradas" do screenshot ausente | slide não mostra a armadilha pedagógica (sinonímia equivocada) | Discutir verbalmente OU adicionar uma linha "❌ usado como sinônimo de…" se couber |

**Diagnóstico-mãe:** slide atual ensina os 3 níveis como **escada** (sobe: estudo → revisão → evidência). Screenshot ensina como **dimensões independentes**. Plateia não absorve "ortogonal" sem paralelismo visual.

## Approach proposto

### Reframe central
**h2 nova:** "Quality, RoB e Certainty medem coisas diferentes — confundir leva a decisão clínica errada"
(assertion-evidence preserved; explicita os 3 termos do screenshot)

### Layout: 3 colunas verticais paralelas

Cada coluna = 1 card vertical com:
- **Header:** TERM em font-display grande (Quality / RoB / Certainty) + cor distintiva (mantém palette OKLCH atual q-study/q-process/q-evidence)
- **Definição (1 linha):** "como a RS foi feita" / "viés nos estudos individuais" / "confiança no corpo de evidência"
- **Objeto:** ícone ou label do que mede (revisão / estudo / corpo de evidência)
- **Tool pill:** AMSTAR-2 / RoB 2 / GRADE

### Punchline empírico (reveal final)
Substituir scenario abstrato por dado concreto:
> **AMSTAR-2 "High" + RoB "Low" → GRADE "Very Low" em 52% dos outcomes**
> Alvarenga-Brant 2024 (PMID 39003480) — 71 SRs odontologia pediátrica

Esse número fica na cabeça. Scenario abstrato não.

### shared-v2 brownfield (Loop β oportunista)

| Patch | Risco | Justificativa |
|---|---|---|
| `<cite>` em source-tag (substitui `<p class="source-tag">`) | BAIXO | semantic HTML5 |
| `subgrid` para alinhar headers/defs/tools cross-cards | MÉDIO | precedente s-etd; 3 colunas sem subgrid podem dessincronizar baselines |
| `color-mix(in oklch, ...)` para tints suaves dos 3 fundos | BAIXO | mantém q-bg-study/process/evidence atuais; só usar color-mix se contrast adjust necessário |
| Logical properties (`margin-block`, `padding-inline`) em novas declarações | BAIXO | convenção moderna |
| **Não opta** `class="theme-dark"` | — | slide didático light bg adequado; theme-dark é para slides de impacto/checkpoint |
| **Não usa** `@starting-style`, `@scope`, `@container` | — | DEFER per BACKLOG (FF 146 muito recente, sem shared-v2 component pattern) |

### Wireframe ASCII (proposta para Lucas validar)

```
┌────────────────────────────────────────────────────────────────┐
│ H2: Quality, RoB e Certainty medem coisas diferentes —         │
│     confundir leva a decisão clínica errada                    │
├────────────┬───────────────────┬───────────────────────────────┤
│  QUALITY   │       RoB         │        CERTAINTY              │
│  (violet)  │  (violet médio)   │     (violet escuro)           │
│            │                   │                                │
│  Como a RS │  Viés em estudos  │  Confiança no corpo           │
│  foi feita │  individuais      │  de evidência                  │
│            │                   │                                │
│  ⚙ revisão │  🔬 estudo        │  📊 corpo agregado            │
│            │                   │                                │
│  AMSTAR-2  │     RoB 2         │       GRADE                    │
└────────────┴───────────────────┴───────────────────────────────┘
                                                                  
   ┌─────────────────────────────────────────────────────────┐
   │ AMSTAR-2 "High" + RoB "Low" → GRADE "Very Low" em      │
   │ 52% dos outcomes (Alvarenga-Brant 2024 · 71 SRs)       │
   └─────────────────────────────────────────────────────────┘

<cite>Pollock 2023 · Shea 2017 · GRADE WG 2004 · Sterne 2019</cite>
```

(Ícones: emojis são placeholder — final usa SVG inline ou char Unicode neutro.)

## Sub-ciclo execução (após Lucas approve wireframe)

1. **Edit `slides/05-quality.html`:**
   - Reescrever estrutura para 3-col grid
   - h2 nova
   - data-reveal=1/2/3/4 (3 cards + punchline)
   - `<cite>` em source-tag

2. **Edit `metanalise.css` `section#s-quality`** (linhas 334-475):
   - Trocar `.quality-levels { flex-direction: column }` → `display: grid; grid-template-columns: repeat(3, 1fr); subgrid` ou `display: grid; grid-template-columns: 1fr 1fr 1fr` com subgrid em row
   - `.quality-level` redesenhado para card vertical
   - `.quality-example` mantém estrutura mas refraseia conteúdo via HTML
   - Logical props em novas margens

3. **Lint + validate-css:**
   - `npm run lint:slides`
   - `bash content/aulas/scripts/validate-css.sh`

4. **Build:**
   - `npm run build:metanalise`

5. **Screenshot:**
   - `node content/aulas/scripts/qa-capture.mjs --aula metanalise --slide s-quality`
   - Diff vs baseline `qa-screenshots/s-quality/s-quality_2026-04-15_1635_S0.png`

6. **APCA:**
   - `node content/aulas/scripts/apca-audit.mjs --aula metanalise`
   - Se theme-dark NÃO for adotado: skip ou usar Lc≥60 light bg threshold

7. **Vite browser review:**
   - `npm run dev:metanalise` (porta 4102)
   - Lucas valida assimilação visual (teste subjetivo: "se eu disser AMSTAR-2 alta, isso garante GRADE alto?" — Lucas espelha resposta esperada)

8. **Commit isolado:**
   - `[orq S259] feat(metanalise): s-quality reformula 3 conceitos canônicos (3-col + Alvarenga-Brant punchline)`
   - Files: `slides/05-quality.html`, `metanalise.css` (seção `section#s-quality` SÓ), `metanalise/HANDOFF.md` linha s-quality, `CHANGELOG.md` append

9. **Loop A QA continuação (opcional, mesmo dia):**
   - Preflight $0
   - gemini-qa3 --inspect (Flash) — score ≥7
   - Lucas OK → --editorial (Pro)
   - Lucas approved → DONE

## Critical files

**Edit (escopo orq):**
- `content/aulas/metanalise/slides/05-quality.html`
- `content/aulas/metanalise/metanalise.css` (linhas 334-475 SÓ — seção `section#s-quality`)
- `content/aulas/metanalise/HANDOFF.md` (linha s-quality apenas)
- `CHANGELOG.md` raiz (append S259 entry com `[orq]` prefix)

**Read-only references:**
- `content/aulas/metanalise/slides/14-etd.html` (padrão shared-v2 híbrido)
- `content/aulas/metanalise/shared-bridge.css` (tokens `--v2-*`)
- `content/aulas/metanalise/evidence/s-quality-grade-rob.html` (framework completo + Alvarenga-Brant)
- `content/aulas/metanalise/qa-screenshots/s-quality/content-research.md` (deep research 19 PMIDs verified)
- `content/aulas/scripts/{lint-slides.js, validate-css.sh, qa-capture.mjs, apca-audit.mjs, gemini-qa3.mjs}`
- `.claude/rules/{slide-rules.md, design-reference.md, qa-pipeline.md}`

**NUNCA editar:**
- `content/aulas/metanalise/slides/09a-heterogeneity.html` (worker)
- `content/aulas/metanalise/slides/10-fixed-random.html` (worker)
- `content/aulas/metanalise/metanalise.css` seções `section#s-heterogeneity` + `section#s-fixed-random` (worker)
- `content/aulas/metanalise/evidence/s-heterogeneity.html` (worker)
- `content/aulas/shared/` (v1 estável)
- `content/aulas/shared-v2/` (infra futura)
- `.claude/plans/jazzy-sniffing-rabbit.md` (worker plan)

## Coordination com worker (dual-front)

**Pre-Edit:**
1. `git fetch && git status && git diff HEAD origin/main`
2. Read full file antes de Edit (KBP-25)
3. `git branch --show-current` antes commit (KBP-40)

**Conflict-prone files:**
- `metanalise/HANDOFF.md` — Edit linha s-quality SÓ (não tabela inteira)
- `CHANGELOG.md` raiz — Append section S259 com `[orq]` prefix
- `metanalise.css` — só linhas 334-475 (seção `section#s-quality`); NUNCA seções heterogeneity/fixed-random

**Cherry-pick later:** commits isolados + reversíveis. Conflito git → MERGE (não rebase force).

## Verification end-to-end

1. Preflight $0: h2 asserção + 0 vw/vh font-size + tokens em todos values + fonts Tier1
2. `npm run lint:slides` PASS (zero errors)
3. `bash content/aulas/scripts/validate-css.sh` PASS
4. `npm run build:metanalise` PASS
5. Screenshot diff vs baseline (mudança visível esperada — não regressão)
6. APCA Lc adequado para light bg (≥60 body) ou theme-dark (≥75 body)
7. Vite browser — Lucas valida assimilação ("teste pergunta": se AMSTAR-2 alta → GRADE alta? plateia hipotética responde NÃO porque 3-col paralelo + punchline 52% deixou claro)
8. (Pós approve) gemini-qa3 inspect ≥7
9. Editorial Pro → Lucas approved → DONE
10. HANDOFF linha s-quality: LINT-PASS → QA → DONE

## Anti-drift guards

- KBP-22: EC loop visível antes de Edit (Verificacao + Mudanca + Elite)
- KBP-25: Read full ± 20 li antes Edit
- KBP-32: spot-check token name no shared-bridge.css antes de usar `var(--v2-*)`
- KBP-37: "Elite faria diferente" actionable
- KBP-40: branch `main` antes commit
- 1 slide = 1 commit anti-batch
- Propose-before-pour: wireframe ACII acima JÁ é a proposta — Lucas approve antes do Edit

## Status (live)

- [ ] ExitPlanMode + Lucas approve wireframe (3-col + h2 nova + Alvarenga-Brant punchline)
- [ ] Edit slide HTML
- [ ] Edit CSS section
- [ ] Lint + validate-css + build + screenshot
- [ ] Vite browser review Lucas
- [ ] Commit isolado `[orq S259]`
- [ ] (Opcional mesmo dia) gemini-qa3 inspect → editorial → DONE
- [ ] HANDOFF linha + CHANGELOG entry

---

Coautoria: Lucas + Opus 4.7 (Claude Code) | S259 orq s-quality reformula | 2026-04-26
