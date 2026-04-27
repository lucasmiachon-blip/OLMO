# S259 metanalise-s-quality — rebuild com carga germânica

## Context

Slide `05-quality.html` (deck position 6, F2 Metodologia) atualmente reframa o paper-fonte (screenshot `Screenshot 2026-04-26 203329.png`) como **hierarquia ascendente** — "estudo individual → revisão → corpo de evidência" com RoB 2 → AMSTAR-2 → GRADE como ferramentas em escada. Mensagem errada: residente sai pensando que GRADE *depende* de AMSTAR-2 que *depende* de RoB.

Mensagem correta (e que o evidence HTML `s-quality-grade-rob.html` linha 138 já enuncia): **3 conceitos paralelos e independentes** que residentes usam como sinônimos. RoB avalia *cada ingrediente*; GRADE avalia *o produto final*; AMSTAR-2 avalia *o processo de fabricação*. Paralelismo, não hierarquia.

Lucas (S259) explicitou prioridades:
1. **Reduzir carga extrínseca + maximizar carga germânica** (Sweller / Mayer): transformar complexidade em schema mental durável.
2. **Beleza editorial** (palhetas shared-v2, sem refator).

Workflow dual-front: Claude constrói v1 (HTML + CSS + GSAP + evidence + paper-source via WebSearch). Lucas QA visual após preflight.

## Pedagogical frame (Cognitive Load Theory)

| Tipo de carga | O que é | Decisão de design |
|---------------|---------|-------------------|
| **Intrínseca** | Complexidade inerente — 3 ferramentas, 3 objetos, 1 dissociação empírica | Chunk em 4 beats (cada click = 1 operação cognitiva) |
| **Extrínseca** | Overhead que não ensina | Zero decorative GSAP. Sem labels redundantes. Source tag única. |
| **Germânica** | Esforço que constrói schema | Estrutura paralela (3 cols isomorfas). Coluna "Confusão" torna misconception explícita. Dissociation panel ancora a tese empiricamente. |

Mayer principles aplicáveis: **Spatial Contiguity** (3 cols paralelas = schema paralelo); **Coherence** (remover ornamento); **Signaling** (term name como anchor visual por coluna); **Pre-training** (activate prior knowledge via "Confusão comum" row).

## Layout (1280×720 canvas)

```
+----------------------------------------------------------------------+
| h2: Qualidade, Risco de Viés e Certeza são ortogonais                |
+----------------------------------------------------------------------+
|                                                                      |
|   +---------------+    +---------------+    +---------------+       |
|   | QUALIDADE     |    | RISCO DE VIÉS |    | CERTEZA       |       |
|   | hue 155° verde|    | hue 75° âmbar |    | hue 265° vio. |       |
|   +---------------+    +---------------+    +---------------+       |
|   | PERGUNTA      |    | PERGUNTA      |    | PERGUNTA      |       |
|   | Como a RS foi |    | Vieses no     |    | Confiança no  |       |
|   | conduzida?    |    | estudo indi-  |    | corpo combi-  |       |
|   |               |    | vidual?       |    | nado?         |       |
|   +---------------+    +---------------+    +---------------+       |
|   | CONFUSÃO      |    | CONFUSÃO      |    | CONFUSÃO      |       |
|   | Usado como    |    | "RoB" = só    |    | Subusada vs   |       |
|   | sinônimo de   |    | Cochrane      |    | os outros 2   |       |
|   | RoB/Certeza   |    | RoB tool      |    | termos        |       |
|   +---------------+    +---------------+    +---------------+       |
|   | FERRAMENTA    |    | FERRAMENTA    |    | FERRAMENTA    |       |
|   | AMSTAR-2      |    | RoB 2 (RCT)   |    | GRADE         |       |
|   | ROBIS         |    | ROBINS-I      |    |               |       |
|   +---------------+    +---------------+    +---------------+       |
|                                                                      |
|   +--------------------------------------------------------------+   |
|   | DISSOCIAÇÃO EMPÍRICA                                         |   |
|   |                                                              |   |
|   |   52%        das MAs com AMSTAR-2 "Alta" têm outcomes        |   |
|   |   ─────      em GRADE "Muito baixa"                          |   |
|   |   (large)                                                    |   |
|   |                                                              |   |
|   |   Alvarenga-Brant 2024 · PMID 39003480 · BMC Oral Health    |   |
|   +--------------------------------------------------------------+   |
|                                                                      |
| Source-tag: Cochrane Methods · Shea 2017 · GRADE WG · Sterne 2019    |
+----------------------------------------------------------------------+
```

**Reveal sequence (4 beats — cada click = 1 schema operation):**

| Beat | Auto/Click | What appears | Cognitive operation |
|------|------------|--------------|---------------------|
| 0 | Auto | h2 + 3 term headlines (Qualidade / Risco de Viés / Certeza) | Activate prior knowledge — residente reconhece os termos |
| 1 | Click | "PERGUNTA" row em 3 cols (paralelo, stagger 0.1s) | Schema rupture — "ah, são perguntas DIFERENTES" |
| 2 | Click | "CONFUSÃO" row em 3 cols | Misconception explícita — confronto com erro próprio |
| 3 | Click | "FERRAMENTA" row + dissociation panel | Synthesis — ferramenta segue função; 52% prova |

Stagger entre colunas: 0.1s (rápido — preserva paralelidade). Stagger entre células dentro de uma row: 0s (atômico).

## CSS — shared-v2 incorporação gradual (sem refator)

**1. Adicionar s-quality ao bridge** (`shared-bridge.css` linha 28-32):

```css
:where(
  section#s-etd,
  section#s-aplicabilidade,
  section#s-heterogeneity,
  section#s-quality                    /* +1 */
) { ... }
```

**2. Tokens v2 consumidos:**

| Token | Uso |
|-------|-----|
| `--v2-text-emphasis` | Term names (Quality / RoB / Certainty) — peso alto |
| `--v2-text-body` | Conteúdo de células (perguntas, confusões, ferramentas) |
| `--v2-text-muted` | Labels (PERGUNTA / CONFUSÃO / FERRAMENTA — uppercase, tracking-wide) |
| `--v2-surface-panel` | Background dos 3 cards |
| `--v2-border-hair` | Border interno entre rows do card |

**3. Color coding por termo (3 hues distintas via tokens locais):**

```css
section#s-quality {
  /* Anchor colors — 3 hues distintas, derivadas de shared-v2 reference.css */
  --term-quality:   oklch(45% 0.13 155);   /* success-derived "processo" */
  --term-rob:       oklch(48% 0.16 75);    /* warning-derived "atenção a vieses" */
  --term-certainty: oklch(45% 0.18 265);   /* accent-derived "certeza editorial" */

  /* Tints sutis para card border-top accent */
  --term-quality-tint:   oklch(94% 0.04 155);
  --term-rob-tint:       oklch(94% 0.05 75);
  --term-certainty-tint: oklch(94% 0.04 265);
}
```

**4. Layout primitives:**

- Outer: `.term-grid` = `display: grid; grid-template-columns: repeat(3, 1fr); gap: var(--space-md)`
- Card: `.term-card` = `display: grid; grid-template-rows: auto auto 1fr auto; padding`. `border-top: 4px solid var(--term-{X})` para anchor visual.
- Row: `.term-row` = `display: grid; grid-template-rows: auto auto`; label + content
- Dissociation: `.term-dissociation` = `display: grid; grid-template-columns: auto 1fr`; número grande + descrição

**5. Substituir bloco s-quality (linhas 334-475 metanalise.css)** — preserva scope `section#s-quality` (specificity 0,1,1,1). Não toca outros slides.

**6. Typography:**

- Term names: `font-family: var(--font-display)` (existente no project — Instrument Serif)
- Labels: `font-family: var(--font-mono)` (JetBrains Mono Variable v2) `font-size: var(--text-caption)` `letter-spacing: 0.08em` `text-transform: uppercase`
- Body: `font-family: var(--font-body)` (DM Sans Variable v2)
- 52% number: `font-family: var(--font-display)`, `font-size: 96px`, `font-variant-numeric: tabular-nums lining-nums`

## GSAP — slide-registry.js handler rewrite

Substituir `s-quality` handler atual (linhas 102-142). Novo:

```js
's-quality': (slide, gsap) => {
  const cards = slide.querySelectorAll('.term-card');
  const rows = {
    pergunta: slide.querySelectorAll('.term-row--pergunta'),
    confusao: slide.querySelectorAll('.term-row--confusao'),
    ferramenta: slide.querySelectorAll('.term-row--ferramenta'),
  };
  const dissociation = slide.querySelector('.term-dissociation');
  const MAX = 3;
  let revealed = 0;

  // Beat 0 (auto): card headers fade-up paralelo
  gsap.fromTo(cards,
    { opacity: 0, y: 12 },
    { opacity: 1, y: 0, duration: 0.6, stagger: 0.1, ease: 'power3.out' }
  );

  const advance = () => {
    if (revealed >= MAX) return false;
    revealed++;
    const targets = revealed === 1 ? rows.pergunta
                  : revealed === 2 ? rows.confusao
                  : rows.ferramenta;
    gsap.fromTo(targets,
      { opacity: 0, y: 8 },
      { opacity: 1, y: 0, duration: 0.45, stagger: 0.1, ease: 'power3.out' }
    );
    if (revealed === 3 && dissociation) {
      gsap.fromTo(dissociation,
        { opacity: 0, y: 12 },
        { opacity: 1, y: 0, duration: 0.55, delay: 0.35, ease: 'power3.out' }
      );
    }
    return true;
  };

  const retreat = () => {
    if (revealed <= 0) return false;
    const targets = revealed === 1 ? rows.pergunta
                  : revealed === 2 ? rows.confusao
                  : rows.ferramenta;
    if (revealed === 3 && dissociation) {
      gsap.to(dissociation, { opacity: 0, y: 12, duration: 0.25, ease: 'power2.in' });
    }
    gsap.to(targets, { opacity: 0, y: 8, duration: 0.3, ease: 'power2.in' });
    revealed--;
    return true;
  };

  slide.__clickRevealNext = advance;
  slide.__hookRetreat = retreat;
  slide.__hookCurrentBeat = () => revealed;
}
```

GSAP principles preserved:
- `power3.out` (anti-drift §slide-rules — proibido bounce/elastic/linear)
- Stagger 0.1s (não excessivo — KBP qa-pipeline anti-sycophancy "uniform stagger = max 7")
- Pause antes do dissociation panel (delay 0.35s) — dramatic beat para a synthesis empírica

## Evidence HTML synthesis (research-driven, source of truth)

Per CLAUDE.md + content/aulas/CLAUDE.md + linha 113 do próprio arquivo: **`evidence/s-quality-grade-rob.html` = source of truth + resultado de pesquisa** (pipeline /evidence 5 pernas S187 → **6 pernas S259** com adição Codex xhigh / GPT-5.5, validade sugerida outubro/2026). Lucas se ampara no evidence durante aula. Promover "ortogonalidade" a tese central exige **NEW RESEARCH, não rewrite do existing**. Frase narrativa criada por Claude sem fonte = KBP-13 (claim sem evidência) + downgrade do rigor que produziu o documento original.

### Pipeline pernas (6 total para S259)

| # | Perna | Família | Pontos fortes |
|---|-------|---------|----------------|
| 1 | Gemini API (Pro 2.5 / 3.1) | Google | Long-context (1M), raciocínio profundo, custo baixo |
| 2 | Perplexity Sonar | Perplexity | Web-grounded, citações em-tempo-real |
| 3 | NLM CLI (E-utilities) | NIH/NCBI | PubMed direto, autoridade primária médica |
| 4 | evidence-researcher agent | MCPs (PubMed/CrossRef/Scite/BioMCP) | PMID verification S187 12/12 corretos |
| 5 | NCBI orchestrator | NIH | Cross-DB queries (PubMed + PMC + Bookshelf) |
| 6 | **Codex xhigh / GPT-5.5 (NOVO S259)** | OpenAI | Família independente Anthropic — diversidade epistemológica |

Convergência cross-família (Anthropic-internal vs Google vs OpenAI vs MCPs) é defesa contra hallucination compartilhada entre modelos da mesma família.

### Architectural drift signal (Lucas observation, S259)

Pipeline atual `/evidence` orquestra `.mjs` scripts (`content/aulas/scripts/*.mjs`) — Lucas reportou que researcher .mjs está "quebrando muito facil". Direção SOTA: migrar research orchestration de `.mjs` para **agents/subagents/skill pattern** (`.claude/agents/*.md` + `.claude/skills/*/SKILL.md`). Vantagens estruturais:

- **Tool isolation per agent** — cada perna tem MCPs próprios via agent inline frontmatter (vs scripts compartilhando estado global)
- **Declarative orchestration** — skill markdown > imperative .mjs (frágil a Node versioning, deps, runtime errors)
- **Less surface for breakage** — cada agent stateless + bounded; subagents Task-tool isolados do main context

**S259 escopo (Lucas explicit):** "vamos testar tudo antes de mudar completamente". NÃO fully migrate `.mjs`. Mantém em produção. S259 usa Codex xhigh perna como **POC do novo pattern** (subagent-style invocation). POC sucesso → plan dedicado S260+ para full migration. POC falha → keep .mjs + investigate fragility root cause.

**Hard constraint S259:** Nenhum `.mjs` é tocado neste plano. Migration .mjs → agents/skill = futuro escopo separado, gated pelo POC outcome.

### Codex CLI bring-up (Phase B prerequisite)

Status verificado em planning: `codex-cli 0.125.0` instalado. Lucas notou "drástica atualização" recente — confirmar se 0.125.0 é a release mais recente. AGENTS.md existe no project root (uppercase, único arquivo via Glob).

**Sub-steps Phase B:**

1. **Verify latest release:** `codex --version` (= 0.125.0). WebSearch ou GitHub `openai/codex` releases. Se 0.125.0 ≠ latest: update via package manager apropriado.
2. **SOTA research (April 2026):**
   - WebSearch "Codex CLI 2026 update changelog xhigh GPT-5.5" + GitHub releases — capture: new model tiers, flags, MCP integration, agent capabilities, prompt formats.
   - WebSearch "Anthropic Claude Code subagents skills 2026 SOTA pattern" — capture: pattern best practices para POC architectural migration.
3. **Architect Codex xhigh subagent (POC):** criar `.claude/agents/codex-xhigh-researcher.md` (ou equivalente) com model invocation contract para R1-R5 questions. Inline MCP frontmatter se aplicável (PubMed/Scite via OpenAI MCP layer se Codex CLI suportar).
4. **Update AGENTS.md:** apply patch refletindo (a) new Codex CLI capabilities, (b) intent de migrar research .mjs → agents/skill pattern (S260+ trabalho), (c) S259 POC com codex-xhigh-researcher subagent. KBP-25 — read full file first, copy old_string verbatim.
5. **Confirm xhigh invocable:** smoke test `codex --model xhigh --print "test"` (ou syntax atual conforme SOTA findings) returns valid output ANTES de Phase C.

**Defer if blocked:** install/update bloqueado → flag + use 0.125.0. SOTA research + AGENTS.md update independem do install.

### Phase C research questions (executar via /evidence 6 pernas — .mjs primary + Codex xhigh POC)

| ID | Pergunta | Por que importa | Output esperado |
|----|----------|-----------------|------------------|
| **R1** | Qual o paper-fonte do screenshot (4-col table sage-green: Term/Definition/Alternative uses/Tools)? | Identificar autor/PMID — anchor primário do reframe | PMID + DOI + verbatim trecho citável |
| **R2** | Existe empirical data sobre **Qualidade ⊥ Risco de Viés** (AMSTAR-2 high vs RoB médio dos estudos incluídos)? | Sustentar 1º eixo da nova seção "três ortogonalidades" — atualmente sem dado quantitativo | Cross-tab studies ou observação narrativa cited |
| **R3** | Beyond Balshem 2011 + Mickenautsch 2024, há paper documentando **GRADE downgrades por dominios non-RoB em corpos com RoB baixo** (RoB ⊥ Certeza)? | Sustentar 3º eixo. Atualmente só Balshem genericamente citado | PMIDs adicionais + estatísticas se houver |
| **R4** | "**Ortogonalidade**" é framing estabelecido em literatura EBM 2023+ para esse trio Quality/RoB/Certainty? Ou é metáfora local (Lucas)? | Decide se evidence HTML afirma "ortogonal" como termo padrão ou flagueia como heurística pedagógica | Citation precedent OU explicit flag low-confidence |
| **R5** | Há **systematic review of misconceptions** sobre Quality/RoB/Certainty terminology entre clínicos/residentes? (Kolaski 2023 já cita misconceptions — há mais?) | Sustentar Beat 2 (Confusão row) com prevalência empírica da confusão | Citations + dados de prevalência |

### Phase D — Evidence HTML synthesis (apenas APÓS Phase C return)

Estado atual: 503 li, 19 PMIDs verificados. "Ortogonal" aparece 2× (linha 162 + 194), restrito a AMSTAR-2↔GRADE. Sintese (linha 160) lapsa para "três níveis". Plano de synthesis (cada item gated por output Phase B):

1. **Header (linhas 110-114):** atualizar com novo h2 ("Qualidade, Risco de Viés e Certeza são ortogonais") + breve framing intro. **Update Pesquisa header** linha 113: append "S259 expansion — paper-fonte (R1) + ortogonalidades (R2-R5)".

2. **Paper-fonte da disambiguação (NEW section após header):** se R1 retornou PMID confirmado, criar section dedicada com cita verbatim + DOI + relação com a tese ortogonal. Se R1 falhou: `[CANDIDATE — PMID TBD]` flag explícito + queries documentadas para Lucas verificar manualmente.

3. **"As três ortogonalidades" (NEW section após concepts-intro):**
   - Sub-bloco **Qualidade ⊥ Risco de Viés:** definição + cenário 2 (já existe linha 152) + R2 dados se houver.
   - Sub-bloco **Qualidade ⊥ Certeza:** Alvarenga 2024 52% (já citado) + qualquer dado adicional R2.
   - Sub-bloco **Risco de Viés ⊥ Certeza:** Balshem 2011 (já) + R3 papers novos.
   - Cada par: definição operacional + exemplo clínico curto + dado empírico cited (ou flag se ausente).

4. **Sintese (linhas 159-167):** "três níveis" → "três eixos ortogonais" usando R4 framing. Se R4 confirma "ortogonal" como termo padrão EBM: assertion direta. Se R4 retorna apenas Lucas/local heurística: flag "framing pedagógico" com justificativa metodológica explícita.

5. **Pull-quote 52%:** section "O dado central" (linha 366) já tem o stat. Reformatar como `<blockquote class="key-stat">` dominante ligado explicitamente a "Qualidade ⊥ Certeza".

6. **Lucas narrative anchors (NEW `<section id="lucas-narrative">` após framework):**
   - Bloco copy-paste para aula — frases derivadas de R1-R5 findings (paráfrases citadas, não criações Claude).
   - Estrutura: 4 frases (abertura / definição operacional / schema rupture / síntese), cada uma com source attribution na margem.
   - Hard rule: phrase "X" → cited from "Author Year PMID NNNNNNNN". Sem fonte ⇒ flag `[heurística pedagógica — Lucas, S259]`, low confidence.

7. **Relabel framework (linha 170):** "três níveis" → "três eixos". Conteúdo da framework-box técnico-correto, só relabel `<span class="level">`.

8. **Misconceptions section (linha 261)** — incorporar R5 findings adicionais se houver, mantendo as 6 misconceptions existentes (Kolaski 2023).

9. **Manter inalteradas:** todas referências (19 + novas R1-R5), glossário ("ortogonal" linha 385 ganha protagonismo), deep-dive A-D, scenarios, empírical tables, convergência 5-pernas table (atualizar com new convergence row se R2-R5 traz convergência multi-perna).

### Hard rules (KBP-13 + KBP-36)

- **Não escrever claim sem evidência.** Se Phase B falha em algum eixo → afirma o que TEM + flagueia o que falta. Sintese honesta > sintese cosmética.
- **Não inventar PMIDs.** verify-first via NCBI E-utilities (KBP-36 — Perplexity 0/8 PMIDs corretos no S187). PMID candidate até confirmação.
- **Convergence > single source.** Achados centrais (R2-R4) preferencialmente convergem ≥2 pernas da pipeline. Single-perna findings = flag medium-confidence.
- **Lucas narrative anchors backed.** Cada frase no `<section id="lucas-narrative">` tem citation explícita. Sem citation = `[heurística pedagógica]` com warrant metodológico.

## Files to modify

| File | Operação | Diff aproximado |
|------|----------|------------------|
| `slides/05-quality.html` | Rebuild markup completo (3 cols + dissociation) | -46 +~80 li |
| `metanalise.css` (334-475) | Substituir bloco s-quality | -141 +~140 li |
| `shared-bridge.css` (28-32) | Add `section#s-quality` ao :where() | +1 li |
| `slide-registry.js` (102-142) | Substituir handler s-quality | -40 +~55 li |
| `evidence/s-quality-grade-rob.html` | Header + sintese rewrite + paper-source | ~50 li mod |
| `slides/_manifest.js` (linha 21) | Update `headline:` field se h2 mudar | 1 li |
| `.slide-integrity` | Auto-recalc no build | (artifact) |

## Reused utilities (não reimplementar — KBP-03 script primacy)

- `data-reveal="N"` pattern → existente em s-importancia, s-objetivos
- `slide-registry.js __clickRevealNext` / `__hookRetreat` / `__hookCurrentBeat` interface → contract estável, reusar
- `shared-bridge.css --v2-*` tokens → calibrados APCA Lc≥75 (S239 C4.6)
- Build: `npm run build:metanalise` (na raiz `content/aulas/`)
- Lint: `npm run lint:slides` (auto-blocked pelo guard hook se falhar)
- `_archived/archetypes.md` referência histórica — NÃO usar como QA criteria (KBP-04)

## Verification (Phase D — pre-handoff a Lucas QA)

1. **Build:** `npm run build:metanalise` PASS, sem orphans
2. **Lint:** `npm run lint:slides` PASS (CSS scoping, font weights ≥400, no inline display/visibility/opacity em `<section>`)
3. **Manifest sync:** headline em `_manifest.js` linha 21 = h2 do slide HTML
4. **Pedagogical check (auto):**
   - h2 = assertion clínica (não label genérico)
   - 4 beats, cada click = 1 operação cognitiva
   - Source tag presente
   - Punchline 52% intacto com PMID
5. **Visual baseline:** `node scripts/qa-capture.mjs --aula metanalise --slide s-quality` (screenshot único — Lucas valida)
6. **APCA spot-check:** body sobre surface-panel ≥ Lc 75; emphasis ≥ Lc 80 (cálculo via shared-v2 já calibrado)
7. **Reduced motion:** animações neutralizam via `prefers-reduced-motion: reduce` (herdado de shared-v2 motion tokens — auto)
8. **EC loop docs:** Verificacao + Mudanca + Elite faria diferente (todas 3 ações executáveis ou gate-justified — KBP-37)

Após verification PASS → handoff para Lucas QA pipeline (Preflight → Inspect → Editorial via `gemini-qa3.mjs`, gate por gate, com OK explícito entre cada — KBP-05).

## Out of scope (defer)

- **s-rob2 (`08c-rob2.html`) modified per git status** ⇒ session separada
- **PENDING FIXES `_manifest.js NOT updated`** ⇒ resolverá no build (manifest já tem s-quality linha 21; warning provavelmente do s-rob2 modified)
- **Refator estrutural shared-v2 full migration** ⇒ Lucas pediu "sem refator" explícito
- **QA gates Inspect+Editorial** ⇒ Lucas decide pós-preflight (1 slide, 1 gate, 1 invocação — KBP-05)
- **Aplicar pattern aos outros 11 LINT-PASS** ⇒ avaliar após s-quality QA DONE

## Phases (commits granulares — research-first flow, 6 pernas)

| # | Phase | Estimativa | Commit message tema |
|---|-------|------------|---------------------|
| A | Session name `.session-name` + research questions formulation (R1-R5) | 5-10 min | `chore(S259): session + research scaffold s-quality` |
| B | **Codex CLI bring-up:** verify install (0.125.0 atual) + update if outdated + SOTA research + AGENTS.md update | 25-35 min | `chore(S259): codex CLI 2026-04 update + AGENTS.md SOTA sync` |
| C | **Research execution** via /evidence 6 pernas (Gemini + Perplexity + NLM + evidence-researcher + NCBI orch + Codex xhigh) — answer R1-R5 | 35-55 min | `research(S259): /evidence 6-pernas — paper-fonte + ortogonalidades` |
| D | Evidence HTML synthesis (gated por Phase C output) — paper-fonte + 3 ortogonalidades + lucas-narrative anchors cited | 25-35 min | `docs(S259): s-quality-grade-rob — ortogonalidade tese central + R1-R5 findings` |
| E | Slide HTML rebuild + `_manifest.js` headline sync | 10 min | `feat(S259): s-quality v2 — 3 cols disambiguation markup` |
| F | CSS rebuild + shared-bridge opt-in (add `section#s-quality` ao :where) | 25-30 min | `feat(S259): s-quality CSS — 3 cols + shared-v2 bridge add` |
| G | GSAP rebuild (4 beats CLT-driven) | 10-15 min | `feat(S259): s-quality slide-registry — 4 beats CLT-driven` |
| H | Build + lint + verification + EC docs + APL closure | 5-10 min | `chore(S259): s-quality build verification + APL closure` |

**Total estimado: ~140-200 min, 8 commits granulares.**

**Gate C→D:** Phase D não pode iniciar sem Phase C research output disponível. Se R1-R5 retornam achados ambíguos/insuficientes, Phase D reflete honestamente (flags + low-confidence markers) — sintese cosmética PROIBIDA (KBP-13).

**Tool choice for Phase C:**
- **`/evidence` skill 5 pernas + Codex xhigh sidecar** — convergência cross-família, custo ~$0.40-0.80, ~35-55 min
- **Híbrido por R-question:** evidence-researcher para R1 (paper identification narrow scope) + /evidence para R2-R4 + Codex xhigh em todas (cross-validation)
- **Codex xhigh prompts:** seguir `codex:gpt-5-4-prompting` skill (atualizado em Phase B se SOTA indicar 5.5 prompt format)

**Hard rule cross-perna:** Achados centrais (R2-R4) preferencialmente convergem ≥3 of 6 pernas. Single-perna findings = flag medium-confidence. Divergência Codex xhigh vs todas as outras 5 pernas = signal forte para revisitação manual antes de incorporar.

## Pre-flight checklist (antes de iniciar)

- [ ] Session name `metanalise-s-quality` escrito em `.claude/.session-name` (após ExitPlanMode approval)
- [ ] Plan archived após approval em `.claude/plans/archive/S259-metanalise-s-quality.md`
- [ ] TaskCreate batch 6 phases mandatory ao approval (anti-drift §Plan execution)
- [ ] Lucas presente para QA visual após Phase F (dual-front workflow)
