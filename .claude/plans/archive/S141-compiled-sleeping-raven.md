# Plano: R14 Call D — s-importancia

## Context

R13 foi a ultima rodada (3 calls, sem Call D). Scores: Visual 5.4, UX+Code 7.2, Motion 8.8, Overall 7.1.
R14 sera a **primeira rodada com Call D** (anti-sycophancy, adicionado S140, temp 1.0 fixado S141).
Objetivo: verificar se o pipeline 4-call funciona end-to-end e se Call D agrega valor.

## Pre-requisitos (verificar antes de Step 1)

| Check | Como verificar | Acao se falhar |
|-------|---------------|----------------|
| Dev server porta 4102 | `curl -s http://localhost:4102/metanalise/ | head -1` | Lucas inicia: `cd content/aulas && npm run dev:metanalise` |
| GEMINI_API_KEY | `echo $GEMINI_API_KEY | head -c8` | Lucas configura env var |
| qa-rounds/s-importancia.md existe | `ls content/aulas/metanalise/qa-rounds/s-importancia.md` | Erro critico — nao rodar sem ele |

## Step 1: Captura de screenshots + video

```bash
cd content/aulas
node scripts/qa-capture.mjs --aula metanalise --slide s-importancia
```

Output esperado: S0.png, S2.png, animation-1280x720.webm, metrics.json em `metanalise/qa-screenshots/s-importancia/`.

**STOP** — reportar resultado da captura. Lucas aprova antes de Step 2.

## Step 2: Gate 4 Editorial R14 (4 calls)

```bash
cd content/aulas
node scripts/gemini-qa3.mjs --aula metanalise --slide s-importancia --editorial --round 14
```

Fluxo interno:
1. Preflight (Gate -1, $0)
2. Source extraction (HTML/CSS/JS/notes)
3. Media upload (PNGs + video para Gemini)
4. **Fresh eyes**: injeta Known FPs, SEM scores anteriores
5. **Calls A+B+C em paralelo** (visual, UX+code, motion)
6. Consolidacao + scorecard
7. **Call D** (anti-sycophancy) — audita A/B/C, recalibra scores
8. Cleanup

Custo estimado: ~$0.11-0.13 (A+B+C ~$0.09 + D ~$0.02).

**STOP** — reportar resultados completos com checklist abaixo.

## Step 3: Checklist de verificacao (6 items do HANDOFF)

| # | Check | Onde | Criterio PASS |
|---|-------|------|---------------|
| 1 | Fresh eyes | Console log Step 3 | "fresh eyes -- FPs injected" |
| 2 | Call D executa | Console log | "6b. Running Call D -- Anti-Sycophancy..." |
| 3 | Ceiling violations | gate4-validate-r14.json | Call D flagou scores 10 como inflados |
| 4 | GUARANTEE fields | gemini-qa3-r14.md | Dims com campo guarantee (nota: campo e optional no schema) |
| 5 | failsafes FP | gate4-scorecard-r14.json | Se 3/10 novamente = FP persistente confirmado |
| 6 | Adjusted overall | validate vs scorecard | Call D produz score != raw |

## Step 4: Decisoes para Lucas (pos-verificacao)

- **adjusted_overall >= 7**: slide aprovavel, issues restantes sao design decisions
- **failsafes 3/10 pela 4a vez**: adicionar exclusao explicita no prompt de Call B
- **Call D sem valor** (scores identicos): considerar remover ($0.02/run)
- **adjusted_overall < 7**: identificar dimensao fraca, planejar CSS fix

## Arquivos criticos

- `content/aulas/scripts/gemini-qa3.mjs` — script canonico (NAO modificar)
- `content/aulas/scripts/qa-capture.mjs` — captura (NAO modificar)
- `content/aulas/metanalise/qa-rounds/s-importancia.md` — contexto de rounds + Known FPs
- `content/aulas/metanalise/docs/prompts/gate4-call-d-validate.md` — prompt Call D
- `content/aulas/metanalise/qa-screenshots/s-importancia/` — output da captura

## Nota importante

Call D **nunca rodou** para s-importancia. R13 foi 3-call only. R14 e o primeiro teste end-to-end do pipeline completo.
