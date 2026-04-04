---
description: "Regras de QA com LLM: attention, rubrica, anti-sycophancy. So carrega em contextos de aula/QA."
paths:
  - "content/aulas/**"
  - "**/qa*"
  - "**/gate*"
---

# QA Pipeline — Regras para Avaliação com LLM

> Fonte: Cirrose E053, E067, E068, E069

## 1. Execução

- "Rodar QA" = apresentar plano dos gates ANTES de executar. NUNCA atalhar pipeline (E053).
- NUNCA batch QA — 1 slide por ciclo completo (vale para Opus visual e Gemini script).
- Gates são sequenciais: BACKLOG → DRAFT → CONTENT → SYNCED → LINT-PASS → QA → DONE.

## 2. Separação de Atenção (E068)

NUNCA avaliar visual design e código na mesma chamada LLM. Atenção finita = misturar inputs = inflar notas.

| Call | Input | Foco | Sem |
|------|-------|------|-----|
| A (visual) | PNGs + vídeo | Distribuição, proporção, cor, tipografia | ZERO código |
| B (UX+code) | PNGs + HTML/CSS/JS | Gestalt, carga cognitiva, cascade, failsafes | SEM vídeo |
| C (motion) | PNGs + vídeo + JS | Timing, easing, narrativa, crossfade | SEM CSS puro |

## 3. Cor Semântica no QA (E067)

Prompt QA DEVE incluir critérios explícitos de avaliação de cor semântica:
- `--danger` = intervir agora (risco clínico real). NUNCA para limitação/flaw.
- `--warning` = investigar. NUNCA para resultado neutro.
- Progressão safe → warning → danger deve refletir gravidade clínica, não estética.
- Modelo sem critério = modelo cego a cor.

## 4. Anti-Sycophancy com Substância (E069)

"Seja duro" sem definir "bom" = notas arbitrárias. Prompt DEVE incluir:

- **Rubrica com ceiling:** Apresentação médica com GSAP = 6-8 se bem feita. 9 = excepcional com narrativa cinematográfica.
- **Exemplos de penalização:** Stagger uniforme = mecânico → max 7. CountUp sem pausa dramática → max 6.
- **Critérios profissionais** (motion): 12 princípios Disney (anticipation, follow-through, secondary action, staging focal).
- Inventário de timestamps prova que o modelo VIU, não que AVALIOU qualidade.
