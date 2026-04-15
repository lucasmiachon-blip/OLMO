# Research Findings: Design Excellence Loop — S199

> Consolidação de 4 agentes de pesquisa + 3 agentes de exploração.
> Este arquivo preserva achados que informam o plano mas não cabem nele.

## 1. CSS Moderno Vanilla — Production-Ready Abril 2026

| Feature | Suporte | Relevância OLMO |
|---|---|---|
| OKLCH / color-mix() | Baseline (Chrome 120+, Safari 17.2+, FF 117+) | Já mandatório |
| CSS Nesting | Baseline | Reduziria verbosidade do {aula}.css — ROI médio |
| @layer (Cascade Layers) | >96% | Overkill agora, backlog para 5+ aulas |
| Container Queries | ~90% | Cards/evidence responsivos — possível |
| Subgrid | Baseline | Alinhamento de grids aninhados — possível |
| Scroll-driven animations | Baseline 2025 | Irrelevante (deck.js = slides discretos) |
| View Transitions API | Parcial | Monitorar (deck.js gerencia transições) |
| Relative Color Syntax (CSS Color 5) | Limitado | Evitar — usar color-mix() (Color 4) |

**Tendência 2025-2026:** Vanilla JS/CSS re-entrou no mainstream. APIs nativas (Fetch, Web Components, ES Modules) substituem frameworks. OLMO opera neste paradigma — é vantagem, não limitação.

Fontes: State of CSS 2025/2026 surveys, Comeau Modern CSS Reset, Argyle/Powell practices.

## 2. Design Token Architecture — Frost + Fowler

- **Frost (Atomic Design → Tokens):** 3 tiers — Option (global, privado) → Semantic (intencão, público) → Component (escopo local)
- **Fowler (Dec 2024):** CSS custom properties = delivery mechanism, não o token system. Tokens = contrato design↔engineering
- **OLMO status:** 2-tier funcional (base.css global + semantic). Tier 3 (per-slide) existe implicitamente sem naming convention

Fontes: bradfrost.com/blog/post/design-tokens, martinfowler.com/articles/design-token-based-ui-architecture

## 3. Slideology — 4 Frameworks Convergentes

| Framework | Princípio-chave | Status OLMO |
|---|---|---|
| Alley (Assertion-Evidence, ASEE 2011) | h2 = assertiva completa ≤2 linhas, corpo = evidência visual | Enforced (lint + rules) |
| Tufte (Data-Ink Ratio, 1983) | Meta ≥0.80, zero chartjunk | Parcial (sem métrica automática) |
| Reynolds (SNR, Presentation Zen) | Restrain, Reduce, Emphasize | Enforced (design-principles.md) |
| Duarte (Slideology/Resonate) | Sparkline narrativa, ponto focal, regra de 3 | Enforced (design-principles.md) |

**OLMO está alinhado com state of the art.** 27 princípios em design-principles.md já codificam os 4 frameworks. Sem gap teórico.

## 4. Motion Design — Mayer + Disney

### Mayer's Multimedia Learning Principles aplicados a motion:
- **Signaling:** Animar o elemento CHAVE, não tudo
- **Segmenting:** Quebrar info complexa em reveals progressivos
- **Temporal Contiguity:** Visual aparece COM narração
- **Coherence:** Remover animação estranha
- **Redundancy:** Não animar o que o speaker já diz

### GSAP Critérios Quantificáveis (já em slide-rules.md):
- Fade/translate: 300-600ms
- CountUp: 800-1200ms
- Stagger total: ≤1.5s
- Max duration: ≤2s
- Easing: power2.out ou power3.out

### Gap identificado:
- `prefers-reduced-motion` via `gsap.matchMedia()` — GSAP docs recomendam, projeto não implementa
- Meta-análise 2025 confirma Mayer across media types

Fontes: Mayer 2009, Johnston & Thomas 1981 (Disney), GSAP a11y docs, meta-analysis 2025 (ScienceDirect)

## 5. Multi-Model Evaluation — Evidência

### Prompt > Model (arXiv:2506.13639)
- Prompt design = ~27% da qualidade de avaliação
- Reference answers = ~15%
- Model choice = ~4%
- **Conclusão:** Fix prompts antes de adicionar modelos

### Ensemble (arXiv:2505.20854, SE-Jury, ASE 2025)
- Ensemble de modelos baratos > single caro (+29.6-140.8%)
- Dynamic team selection > brute-force multi-model
- Consenso > adversarial (debate amplifica biases — arXiv:2411.15594)

### Benchmarks visuais GPT-5.4 vs Gemini 3.1 Pro
- ScreenSpot-Pro: 85.4 vs 84.4 (+1 ponto, 2.4x custo)
- OfficeQA-Pro: 96 vs 95
- Video-MMMU: Gemini 87.6 (GPT não avalia video)
- **Conclusão:** Margem insuficiente para justificar custo

### Codex CLI (Abril 2026)
- Aceita imagens via --image
- Modelo: GPT-5.4, 1M token context
- Força: code generation FROM visuals (screenshot → CSS)
- Fraqueza: NÃO é evaluator — é fixer
- Windows: experimental (WSL2 recomendado)

### DesignQA (MIT, decode.mit.edu)
- Benchmark de compliance de design com documentação técnica
- Testou GPT-4o, Claude Opus, Gemini 1.0
- **TODOS** "struggle to reliably retrieve relevant rules from technical documentation"
- **Conclusão:** O problema não é qual modelo — é rubric + dados estruturados

Fontes completas no plano mutable-mapping-seal.md §Fontes Consolidadas.

## 6. Slides Benchmark Identificados

| Slide | Dims elite | CSS patterns | GSAP patterns |
|---|---|---|---|
| `s-etd` | Color + Contrast | Dark theme, semantic badges, scoped OKLCH tokens, color-mix() | Row-by-row reveal, MutationObserver body bg |
| `s-quality` | CSS Arch + Cognitive Load | 3-level cards, minmax(0,1fr), numbered badges | Stagger cards |
| `s-title` | Motion + Typography | Instrument Serif hero, masking overflow | CustomEase apple-style, pillar reveal yPercent |
| `s-hook` | Data-Ink + Assertion | Bloomberg layout, tabular-nums, 3-col grid | CountUp locale pt-BR, stagger facts |

## 7. Infraestrutura Existente

- **Vite:** porta 4100 (metanálise), auto-discovery de entry points
- **Playwright:** qa-capture.mjs com --video (.webm), S0+S2 states, bounding box metrics
- **Gemini QA:** gemini-qa3.mjs, 15 dims, 3+1 calls, Flash/Pro, temp 1.0
- **Chrome DevTools MCP:** 29 tools disponíveis (screenshot, evaluate_script, navigate, etc.)
- **Ralph Loop:** plugin instalado S199, nunca usado no projeto
- **Skill Creator:** eval/improve loop com train/test split (pattern transferível, impl não)

---

Coautoria: Lucas + Opus 4.6 | S199 2026-04-15
