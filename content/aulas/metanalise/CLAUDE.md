# Meta-análise — Regras Específicas

Parent: `content/aulas/` (ver CLAUDE.md raiz do monorepo).

## Escopo

- 45–60 min, residentes clínica médica (básico-intermediário)
- Foco: LEITURA CRÍTICA de MA (não produção de RS)
- Modelo: pairwise clássico de RCTs
- Âncora: **Valgimigli 2025 — Clopidogrel vs Aspirina (Lancet, PMID 40902613)**. IPD-MA, 7 RCTs, 28.982 pts
- Conceitos avançados (NMA, IPD metodologia, bayesiana) = fora do escopo. Ancora usa IPD-MA mas e ensinada como pairwise.
- Forest plots = imagens cropadas de artigos reais (NUNCA SVG construído do zero)
- Área do Lucas ≠ hepatologia — artigo pode ser de qualquer área
- Acesso: CAPES/USP — não precisa ser open access

## Estrutura narrativa

3 fases + 2 interações (ver `references/narrative.md`):

1. **F1 — Criar importância** (slides 00-02): engajar antes de ensinar
2. **I1 — Checkpoint** (slide 03): ACCORD trap (Ray 2009 + ACCORD 2008)
3. **F2 — Metodologia** (slides 04-11): conceitos genéricos, sem artigo
4. **I2 — Checkpoint** (slide 12): consolidação
5. **F3 — Aplicação** (slides 13-17): Valgimigli 2025

**Exceção I1:** s-checkpoint-1 usa dados reais como armadilha pedagógica.
**Regra geral:** slides antes da F3 não referenciam artigo específico.

## Hierarquia de referência

```
narrative.md → evidence/*.html (living HTML) → blueprint.md → slides/
reading-list.md (paralelo, informa pre-reading)
archetypes.md (6 layout patterns)
```

## Arquivos de trabalho

```
slides/*.html (18 arquivos)
slides/_manifest.js
slide-registry.js
metanalise.css
```

Build: `npm run build:metanalise` (na raiz `content/aulas/`).
GSAP plugins: SplitText + Flip + ScrambleTextPlugin.

## QA

Script unico: `scripts/gemini-qa3.mjs` (Preflight + Inspect + Editorial).
1 slide por ciclo QA completo. NUNCA batch.

Gates: Preflight (dims objetivas $0) → [Lucas OK] → Inspect (Gemini Flash) → [Lucas OK] → Editorial (Gemini Pro).
Threshold: score < 7 → checkpoint Lucas antes de continuar.

## Hard constraints

1. Assertion-evidence em todos os slides
2. F1-F2: dados genéricos ou Cochrane. Artigo específico só na F3 (exceção: I1 ACCORD)
3. Sem dados inventados. Sem fonte Tier 1 → `[TBD]`
4. GRADE como linguagem clínica, não burocracia
5. Forest plot: cropado de artigo real quando disponível
6. Corpo do slide <= 30 palavras
7. Speaker notes em português
8. Uma MA não é melhor que os RCTs que a alimentam — isso permeia a aula

## QA Pipeline (máquina de estados)

```
BACKLOG → DRAFT → CONTENT → SYNCED → LINT-PASS → QA → DONE
```

Gates:
- **Gate 1 (CONTENT→SYNCED):** h2 é asserção + notes com timing/fontes
- **Gate 2 (SYNCED→LINT-PASS):** `npm run lint:slides` PASS
- **Gate 3 (LINT-PASS→QA):** Build PASS + sem orphans
- **Gate 4 (QA→DONE):** `gemini-qa3.mjs` (Preflight + Inspect + Editorial) + Lucas approved

Detalhes QA por slide: `HANDOFF.md`.

## Status

Tracking: `HANDOFF.md` (project-level).
18/18 slides. Âncora: Valgimigli 2025 Lancet (PMID 40902613). HEX navy: #162032.

## Display de apresentação

Samsung UN55F6400, 55", 1920×1080, ~6m distância.
Sala pequena, ~15 pessoas, iluminação forte — legibilidade constraint #1.
scaleDeck() 1.5× em 1080p. Font mínima: ≥18px no canvas 1280.
