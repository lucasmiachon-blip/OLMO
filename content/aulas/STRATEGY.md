# Aulas — Estrategia e Roadmap

> Pesquisa realizada em 2026-03-29. Decisoes informam evolucao futura.

## O que profissionais usam

### Ferramentas de apresentacao
- **TED/conferencias**: Keynote e PowerPoint dominam. TED fornece templates Keynote.
- **Conferencias medicas** (EASL, AASLD, DDW): **PPTX obrigatorio**. 16:9, Arial/Calibri, min 28pt.
- **Assertion-Evidence** (Michael Alley, Penn State): validado cientificamente. h2 = claim, visual = evidencia.
- **Nancy Duarte**: Glance Test (3 segundos para captar o ponto). Slidedocs para handouts.
- **Garr Reynolds**: rascunhar no papel antes de abrir software. Full-bleed foto + texto minimo.

### Animacao e interatividade
- **GSAP**: industria de animacao web (Netflix, Apple, Google). Controle absoluto.
  - Core: transforms, opacity, timing — 80% dos casos
  - Plugins: SplitText, ScrollTrigger, DrawSVG, MorphSVG
  - Risco: complexidade se nao contido por padroes declarativos
- **CSS Animations**: nativo, zero deps, performance S-Tier
  - Cobre: transitions, keyframes, @starting-style (2024+)
  - Nao faz: countUp numerico, sequencias complexas, morphing
- **Motion One**: successor de Framer Motion, framework-agnostic. API moderna.
- **Lottie/Rive**: animacoes vetoriais de After Effects/Figma. Ideal para fisiopatologia.
- **D3.js**: data viz (forest plots, graficos interativos, meta-analises).

### Evidencia sobre animacao em ensino
- Animacao melhora aprendizado: 72.48 vs 61.16 (p=0.001) em RCTs
- MAS: animacao decorativa REDUZ recall (detalhes sedutores consomem working memory)
- Regra: so progressive reveal e atencao direcionada. Nunca decorativo.
- ~50% das animacoes medicas falham em seguir cognitive load theory

## Canva Pro (via MCP)
- 1267+ templates medicos
- Pipeline: request-outline-review → generate-design-structured → create → edit → export
- Exporta PPTX, PDF (300dpi), PNG, JPG, GIF, MP4
- **Limitacoes**: sem speaker notes via API, sem pixel-perfect layout, sem font-family programatico
- **Melhor uso**: criacao de assets visuais para inserir em PPTX ou HTML

## Decisao: abordagem hibrida

| Contexto | Ferramenta | Por que |
|----------|-----------|---------|
| Conferencias (EASL, AASLD) | PPTX (assertion-evidence template) | Formato obrigatorio |
| Aulas regulares | HTML/JS (deck.js + GSAP declarativo) | Offline, interativo, git-friendly |
| Assets visuais | Canva Pro (MCP) | Rapido, templates profissionais |
| PDF para alunos | Export de qualquer formato acima | Sempre disponivel |

## Roadmap tecnico (uma melhoria por sessao)

1. CSS @layer para cascade management
2. Renomear shared/ → core/ (clareza)
3. Inline slides ou module system (eliminar build concatenation)
4. Design tokens isolados (tokens.css)
5. Lottie para animacoes medicas (fisiopatologia)
6. D3.js para data visualization (meta-analises, forest plots)
7. Canva MCP integration para assets
8. Template PPTX assertion-evidence para conferencias
9. Avaliar Slidev para aulas novas (texto-heavy)

---
Coautoria: Lucas + Opus 4.6 | Pesquisa: 2026-03-29
